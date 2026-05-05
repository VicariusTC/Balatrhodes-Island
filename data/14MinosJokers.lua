SMODS.Joker{
    key = 'Conviction',
    name = 'Conviction',
    rarity = 1,
    atlas = 'Jokers',
	cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    pos = {x = 0, y = 17},
    config = { 
      extra = {
        regularMult = 10,
        debuffChance = 4,
        critChance = 20,
        critMult = 100,
        tagClass = {"Guard"},
        tagFaction = {"Minos"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.regularMult, G.GAME.probabilities.normal, center.ability.extra.debuffChance, center.ability.extra.critChance, center.ability.extra.critMult}}
    end,
    calculate = function(self,card,context)
        if context.setting_blind and context.main_eval and SMODS.pseudorandom_probability(card, 'akts_random_seed', 1, card.ability.extra.debuffChance) then
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_stunned'), colour = G.C.MULT})
            local round = G.GAME.round
            SMODS.debuff_card(card, true, "ConvictionDebuff")
            G.E_MANAGER:add_event(Event({
                func = function() 
                    if G.GAME.round == round then
                        return false
                    end
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            SMODS.debuff_card(card, false, "ConvictionDebuff")
                            return true
                        end,
                    }))
                    return true
                end,
                blocking = false
            }))
        end

        if context.joker_main then
            local returnMult = card.ability.extra.regularMult
            if SMODS.pseudorandom_probability(card, 'akts_random_seed', 1, card.ability.extra.critChance) then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_crit')})
                returnMult = card.ability.extra.critMult
            end
            return {
                mult = returnMult,
                card = card
            }
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}