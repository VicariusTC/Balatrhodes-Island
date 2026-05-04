SMODS.Joker{
    key = 'Tomimi', 
    name = 'Tomimi',
    rarity = 1,
    atlas = 'Jokers', 
	cost = 4,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    pos = {x = 0, y = 10},
    config = { 
      extra = {
        plusChips = 12,
        plusMult = 2,
        plusChipsActive = 12,
        plusMultActive = 2,
        permaBuff = 5,
        chosenEffect = 0,
        chosenEffectOptions = 3, --Option 1: Upgrade Self, Option 2: Enhance, Option 3: Upgrade all played.
        tagClass = {"Caster"},
        tagFaction = {"Sargon"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        return {vars = {center.ability.extra.plusChipsActive, center.ability.extra.plusMultActive, center.ability.extra.plusChips, center.ability.extra.plusMult, center.ability.extra.permaBuff}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before then
                card.ability.extra.chosenEffect = math.random(card.ability.extra.chosenEffectOptions)
                if card.ability.extra.chosenEffect == 1 then --Upgrades Joker Return
                    card.ability.extra.plusChipsActive = card.ability.extra.plusChipsActive + card.ability.extra.plusChips
                    card.ability.extra.plusMultActive = card.ability.extra.plusMultActive + card.ability.extra.plusMult
                    return {
                        extra = {focus = card, message = localize('k_upgrade_ex')},
                        card = card,
                        colour = G.C.CHIPS
                    }
                elseif card.ability.extra.chosenEffect == 2 then --Enhance to Wild
                    for i = 1, #context.full_hand do
                        if context.full_hand[i].config.center == G.P_CENTERS.c_base then 
                            context.full_hand[i]:set_ability(G.P_CENTERS.m_wild, nil, true)
                            context.full_hand[i]:juice_up()
                            break
                        end
                    end
                end
            end
        end
        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and card.ability.extra.chosenEffect == 3 then
            --Effect 3, upgrade individual
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.permaBuff
            G.E_MANAGER:add_event(Event({func = (function() card:juice_up(); return true end)}))
            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
                colour = G.C.CHIPS,
                card = context.other_card
            }
        end

        if context.joker_main then
            if getJokerSlot(card) <= math.floor((#G.jokers.cards/2) +0.5) then
                return {
			        chips = card.ability.extra.plusChipsActive
		        }
            else
                return {
			        mult = card.ability.extra.plusMultActive
		        }
            end
	    end
    end,
    set_badges = function(self, card, badges)
      aktsBadgeHelper(self,card,badges)
    end
}

SMODS.Joker{
    key = 'Pepe', 
    name = 'Pepe',
    rarity = 3,
    atlas = 'Jokers', 
	cost = 7,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    pos = {x = 1, y = 10},
    config = { 
      extra = {
        lastRoundAoE = false,
        aoEEfficacy = {50, 50, 25, 25},
        aoESuitTarget = {},
        aoEUndebuffable = false,
        aoEMain = {},
        baseAoE = {-1, 1},
        fullAoE = {-1, 1, -2, 2},
        calculatedHandType = nil,
        tagClass = {"Guard"},
        tagFaction = {"Sargon"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "AoEHit"}
        return {vars = {center.ability.extra.aoEEfficacy[3]}}
    end,
    calculate = function(self,card,context)
        if context.press_play then
            card.ability.extra.aoESuitTarget = {}
            card.ability.extra.aoEMain = {}
            card.ability.extra.aoEUndebuffable = false
            local centerPlayed = G.hand.highlighted[math.floor((#G.hand.highlighted/2) +0.5)]
            if centerPlayed.config.center ~= G.P_CENTERS.c_base then
                if not card.ability.extra.lastRoundAoE then
                    card.ability.extra.aoEMain = aoEEnhancement(card, centerPlayed, G.hand.highlighted, card.ability.extra.baseAoE, card.ability.extra.aoEEfficacy)
                    card.ability.extra.lastRoundAoE = true
                else
                    card.ability.extra.aoEMain = aoEEnhancement(card, centerPlayed, G.hand.highlighted, card.ability.extra.fullAoE, card.ability.extra.aoEEfficacy)
                end
            elseif card.ability.extra.lastRoundAoE then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset')})
                card.ability.extra.lastRoundAoE = false
            end
        end

        if context.cardarea == G.jokers and context.scoring_hand and context.before then
            if card.ability.extra.aoEMain and card.ability.extra.aoEMain[1] and card.ability.extra.aoEMain[1][1] then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_AoE')})
                for i, v in pairs(card.ability.extra.aoEMain[1][1]) do
                    v:juice_up()
                    if card.ability.extra.aoEUndebuffable then
                        v.debuff = false
                    end
                end
            end
        end

        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and card.ability.extra.aoEMain and card.ability.extra.aoEMain[1] and card.ability.extra.aoEMain[1][1] then
            for i, v in pairs(card.ability.extra.aoEMain[1][1]) do
                if context.other_card == v then
                    local updateTable = parseEnhancement(card, context, context.other_card)
                    local efficacyFactor = (0.01 * card.ability.extra.aoEMain[1][2][i])
                    local returnValues = {
                        efficacyFactor * card.ability.extra.aoEMain[2],                         --chips
                        efficacyFactor * updateTable[1],                                        --flat mult
                        1 + efficacyFactor * (math.max(card.ability.extra.aoEMain[4], 1) -1),   --xmult
                        efficacyFactor * updateTable[2]                                         --dollars
                    }
                    if returnValues[4] > 0 then
                        return {
	                        chips = returnValues[1],
                            mult = returnValues[2],
                            xmult = returnValues[3],
                            dollars = returnValues[4]
                        }
                    else
                        return {
	                        chips = returnValues[1],
                            mult = returnValues[2],
                            xmult = returnValues[3],
                        }
                    end
                    break
                end
            end
        end

        if context.end_of_round then
            card.ability.extra.aoESuitTarget = {}
            card.ability.extra.aoEMain = {}
            card.ability.extra.aoEUndebuffable = false
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end 
}