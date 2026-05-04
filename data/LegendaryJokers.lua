SMODS.Atlas{
    key = 'Walter',
    path = 'walter.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'Walter',
    name = 'Walter',
    rarity = 4,
    atlas = 'Walter',
	cost = 20,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    pos = {x = 0, y = 0},
    config = { 
      extra = {
        enhanceOdds = 1 / 12,
        overloadUsed = false,
        overloadEnhanceCount = 2,
        overloadDownsideValue = 1,
        overloadDownside = 0,
        revenantScore = 0,
        enhanceds = {},
        aktsUseButton = {"akts_walter_overload", "akts_walter_can_overload", "b_use"},
        wonRound = false,
        tagClass = {"Sniper"},
        tagFaction = {"Babel"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "Overload"}
        info_queue[#info_queue+1] = G.P_CENTERS.m_akts_Revenant
        return {vars = {math.ceil((center.ability.extra.enhanceOdds) * (G.playing_cards and (#G.playing_cards) or 3) - center.ability.extra.overloadDownside), center.ability.extra.overloadEnhanceCount, center.ability.extra.overloadDownsideValue}}
    end,
    calculate = function(self,card,context)
        if context.setting_blind and context.main_eval and G.GAME.blind then
            local enhanceds = math.ceil(card.ability.extra.enhanceOdds * #G.playing_cards) - card.ability.extra.overloadDownside
            local deck = {}
            for i, v in ipairs(G.playing_cards) do
                table.insert(deck, v)
            end

            for i = 0, enhanceds, 1 do
                local chosenIndex = math.random(1, #deck)
                local previousEnhancement = deck[chosenIndex].config.center or G.P_CENTERS.c_base
                deck[chosenIndex]:set_ability(G.P_CENTERS.m_akts_Revenant, nil, true)
                deck[chosenIndex].ability.extra.round = G.GAME.round
                deck[chosenIndex].ability.extra.previousEnhancement = previousEnhancement
                table.insert(card.ability.extra.enhanceds, deck[chosenIndex])
                table.remove(deck, chosenIndex)
            end

            card.ability.extra.overloadDownside = 0
            if card.ability.extra.revenantScore > 0 then
                G.GAME.chips = G.GAME.chips + card.ability.extra.revenantScore
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_Walter_Bang"), G.C.MULT})
                if G.GAME.chips > G.GAME.blind.chips then
                    card.ability.extra.wonRound = true
                end
            end
        end
        if context.hand_drawn and card.ability.extra.wonRound then
            end_round()
        end
        if context.cardarea == G.jokers and context.scoring_hand and context.final_scoring_step then
            local revenantScore = false
            for i, v in ipairs(context.scoring_hand) do
                if v.config.center == G.P_CENTERS.m_akts_Revenant then
                    revenantScore = true
                    break
                end
            end
            if revenantScore then
                card.ability.extra.revenantScore = card.ability.extra.revenantScore + (hand_chips * mult)
            end
        end

        if context.end_of_round and context.cardarea == G.jokers then
            if card.ability.extra.wonRound then
                G.STATE = G.STATES.HAND_PLAYED
                G.STATE_COMPLETE = true
                card.ability.extra.wonRound = false
            end
            for i, v in ipairs(card.ability.extra.enhanceds) do
                if v.config and v.config.center == G.P_CENTERS.m_akts_Revenant then
                    v:set_ability(v.ability.extra.previousEnhancement, nil, true)
                end
            end
            card.ability.extra.enhanceds = {}
            G.P_CENTERS.j_akts_Walter.pos.x = 0
        end

        if context.ante_end then
            card.ability.extra.overloadUsed = false
            card.ability.extra.revenantScore = 0
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}

G.FUNCS.akts_walter_can_overload = function(e)
    local card = e.config.ref_table
    if card.ability.extra.overloadUsed then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        return
    end
    if G.hand and not card.debuff and G.GAME.blind and G.hand.cards and #G.hand.cards > 0 then
        local unenhanceds = {}
        for i, v in ipairs(G.hand.cards) do
            if v.config.center == G.P_CENTERS.c_base then
                table.insert(unenhanceds, v)
            end
        end
        if #unenhanceds == 0 then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.MULT
            e.config.button = "akts_walter_overload"
        end
    end
end

G.FUNCS.akts_walter_overload = function(e)
    local card = e.config.ref_table
    local unenhanceds = {}
        for i, v in ipairs(G.hand.cards) do
            if v.config.center == G.P_CENTERS.c_base then
                table.insert(unenhanceds, v)
            end
        end
        if #unenhanceds == 0 then
            return
        end
        card.ability.extra.overloadUsed = true
        card.ability.extra.overloadDownside = card.ability.extra.overloadDownsideValue
        for i = 0, card.ability.extra.overloadEnhanceCount, 1 do
            if #unenhanceds == 0 then
                break
            end
            local index = math.random(1, #unenhanceds)
            local _card = unenhanceds[index]
            _card:set_ability(G.P_CENTERS.m_akts_Revenant, nil, true)
            _card.ability.extra.round = G.GAME.round
            _card.ability.extra.previousEnhancement = G.P_CENTERS.c_base
            table.insert(card.ability.extra.enhanceds, _card)
            table.remove(unenhanceds, index)
        end
        local center = G.P_CENTERS.j_akts_Walter
        for i = 1, 20, 1 do
            G.E_MANAGER:add_event(Event({
            func = (function()
                center.pos.x = i
                return true
            end)
        }))
        delay(0.1)
    end
end