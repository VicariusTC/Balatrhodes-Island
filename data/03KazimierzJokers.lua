SMODS.Joker{
    key = 'NearlRadiant', 
    name = 'NearlRadiant',
    rarity = 1,
    atlas = 'Jokers', --atlas' key
	cost = 6,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = false, --can it be perishable
    no_pool_flag = 'akts_NearlAlter_transform',
    pos = {x = 0, y = 6}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
        aktsSellValue = 0,
        tagClass = {"Guard"},
        tagFaction = {"Kazimierz"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.c_akts_NearlTheRadiant
    end,
    add_to_deck = function (self,card,from_debuff)
        card.ability.extra.aktsCostValue = 0
    end,
    calculate = function(self,card,context)
        if context.selling_self and not context.blueprint and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local _card = create_card("SummonConsumableType", G.consumeables, nil, nil, nil, nil, 'c_akts_NearlTheRadiant')
            _card:add_to_deck()
            G.consumeables:emplace(_card)
            card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize("akts_plus_summon"), G.C.ATTENTION})
        end

        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before and next(context.poker_hands['Straight']) then
                local kingFound = false
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() == 13 then 
                        kingFound = true
                    end
                end
                if kingFound then
                    _card = context.scoring_hand[1]
                    card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize("akts_textRadiantJ"), G.C.ATTENTION})
                    delay(0.25)
                    _card:set_ability(G.P_CENTERS.m_akts_True, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            _card:juice_up()
                            return true
                        end
                    }))
                    delay(0.1)
                end
            end
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end 
}

SMODS.Joker{
    key = 'Mlynar',
    name = 'Mlynar',
    rarity = 3,
    atlas = 'Jokers',
	cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    no_pool_flag = 'akts_mlynar_transform',
    pos = {x = 1, y = 6},
    config = { 
      extra = {
        chipRequirement = 70,
        transformLength = 5,
        transformLink = "j_akts_MlynarActive",
        tagClass = {"Guard"},
        tagFaction = {"Kazimierz"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_akts_MlynarActive
        return {vars = {center.ability.extra.transformLength, center.ability.extra.chipRequirement}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before and G.GAME.current_round.hands_left == 0 and (G.GAME.chips/G.GAME.blind.chips) < (card.ability.extra.chipRequirement * 0.01) then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_transform"), G.C.ATTENTION})
                jokerTransform(card, card.ability.extra.transformLink)
            end
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end 
}

SMODS.Joker{
    key = 'MlynarActive',
    name = 'MlynarActive',
    rarity = 'akts_Transformed',
    atlas = 'Jokers',
	cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 6},
    config = { 
      extra = {
        globalCut = 2,
        finalCut = 4,
        trueCut = 2,
        transformLength = 5,
        transformRevert = "j_akts_Mlynar",
        tagClass = {"Guard"},
        tagFaction = {"Kazimierz"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.globalCut, center.ability.extra.trueCut, center.ability.extra.finalCut, center.ability.extra.transformLength}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_mlynar_transform = true
    end, 
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_mlynar_transform = false
    end,
    calculate = function(self,card,context)
        if context.joker_main and context.scoring_hand then
            card.ability.extra.transformLength = card.ability.extra.transformLength -1
            local totalCut = card.ability.extra.globalCut * #context.scoring_hand
            if G.GAME.current_round.hands_left == 0 then
                totalCut = totalCut + card.ability.extra.finalCut * #context.scoring_hand
            end
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].config.center == G.P_CENTERS.m_akts_True then 
                    totalCut = totalCut + card.ability.extra.trueCut
                end
            end
            G.GAME.blind.chips = G.GAME.blind.chips * (1 - (totalCut * 0.01))
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_mlynar_score"), G.C.ATTENTION})
        end
        if (context.hand_drawn or context.end_of_round) and card.ability.extra.transformLength <= 0 then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_transform_revert"), G.C.ATTENTION})
            jokerTransform(card, card.ability.extra.transformRevert)
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end 
}
----------------------------------------Base Kazimierz end----------------------------------------
SMODS.Joker{
    key = 'Flametail', 
    name = 'Flametail',
    rarity = 1,
    atlas = 'Jokers',
	cost = 4,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 0, y = 7}, 
    config = { 
      extra = {
        currentChance = 0,
        currentChanceAdd = 0,
        chanceReq = 10,
        moneyGain = 5,
        discGain = 1,
        editionReq = 5,
        discActivated = false,
        tagClass = {"Vanguard"},
        tagFaction = {"Pinus", "Kazimierz"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {''..(math.min(G.GAME.probabilities.normal + center.ability.extra.currentChanceAdd - 1, center.ability.extra.chanceReq) or center.ability.extra.currentChance), center.ability.extra.chanceReq, center.ability.extra.moneyGain, center.ability.extra.discGain, center.ability.extra.editionReq, ''..(G.GAME and G.GAME.probabilities.normal or 1)}}
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.extra.currentChance = G.GAME.probabilities.normal -1
            local kaziFactor = 1
            if #CalcTaggedOwned(card.ability.extra.tagFaction[2], card) > 0 then
                kaziFactor = 2
            end
            if math.random() <= (kaziFactor * G.GAME.probabilities.normal)/card.ability.extra.editionReq then
                G.E_MANAGER:add_event(Event({
                    trigger = "after", 
                    delay = 0.25,
                    func = function() 
                        card:set_edition({negative = true}, true)
                        return true 
                    end
                }))
            end
        end
    end,
    calculate = function(self,card,context)
        if context.discard and not card.ability.extra.discActivated then
            card.ability.extra.discActivated = true
            if math.random() <= card.ability.extra.currentChance/card.ability.extra.chanceReq then
                --gain cash, disc, reset.
                card.ability.extra.currentChanceAdd = 0
                card.ability.extra.currentChance = G.GAME.probabilities.normal - 1
                ease_discard(card.ability.extra.discGain, nil, true)
                ease_dollars(card.ability.extra.moneyGain)
                return {
                    message = localize("akts_Dodged"),
                    colour = G.C.MONEY,
                    delay = 0.45, 
                    card = card
                }
            else
                --increase currentChance.
                card.ability.extra.currentChanceAdd = card.ability.extra.currentChanceAdd + 1
                card.ability.extra.currentChance = math.min(G.GAME.probabilities.normal + card.ability.extra.currentChanceAdd, card.ability.extra.chanceReq)
            end
        end
        if context.scoring_hand then 
            card.ability.extra.discActivated = false
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'Fartooth', 
    name = 'Fartooth',
    rarity = 1,
    atlas = 'Jokers',
	cost = 6,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 1, y = 7}, 
    config = { 
      extra = {
        multAddFactor = 0,
        returnMult = 0,
        tagClass = {"Sniper"},
        tagFaction = {"Pinus", "Kazimierz"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {(#CalcTaggedOwned(center.ability.extra.tagFaction[1]))}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            card.ability.extra.multAddFactor = #CalcTaggedOwned(card.ability.extra.tagFaction[1])
            local lowestRank = 14
            local highestRank = 0
            card.ability.extra.returnMult = 0
            if #G.hand.cards >= 2 then
                for k, v in ipairs(G.hand.cards) do
                    if v:get_id() < lowestRank and v:get_id() > 0 then
                        lowestRank = v:get_id()
                    end
                    if v:get_id() > highestRank then
                        highestRank = v:get_id()
                    end
                end
                card.ability.extra.returnMult = highestRank - lowestRank
            end
            return {
			    mult = card.ability.extra.returnMult * card.ability.extra.multAddFactor
		    }
        end
        if context.end_of_round and context.main_eval and context.game_over == false and context.cardarea == G.jokers then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                local handRank = {false, false, false, false, false, false, false, false, false, false, false, false, false}
                local duplicate = false
                for k, v in ipairs(G.hand.cards) do
                    if handRank[v:get_id()] then
                        duplicate = true
                        break
                    else
                        handRank[v:get_id()] = true
                    end
                end
                if not duplicate then
                    local _card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil)
                    _card:add_to_deck()
                    G.consumeables:emplace(_card)
                    card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize("k_plus_tarot"), G.C.PURPLE})
                end
            end
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}
----------------------------------------Pinus Sylvestris end----------------------------------------