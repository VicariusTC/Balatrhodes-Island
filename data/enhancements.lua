SMODS.Atlas{
    key = 'AKEnhancements', --atlas key
    path = 'AKEnhancements.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Enhancement {
    key = "True",
    atlas = 'AKEnhancements',
    pos = {
        x = 0,
        y = 0
    },
    order = 1,
    config = {
        extra = {
        chips = 10,
        mult = 3,
        chips_mod = 0,
        mult_mod = 0,
        undebuffable = true,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
          vars = {
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.chips_mod,
            card.ability.extra.mult_mod,
          }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                card = card
            }
        end
    end
}

SMODS.Enhancement {
    key = "Hook",
    atlas = 'AKEnhancements',
    pos = {
        x = 1,
        y = 0
    },
    order = 1,
    config = {
        extra = {
        chips = 0,
        mult = 0,
        chips_mod = 0,
        mult_mod = 0,
        activated = true,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
          vars = {
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.chips_mod,
            card.ability.extra.mult_mod,
          }
        }
    end,
    calculate = function(self, card, context)
        if context.scoring_hand and context.cardarea == G.play and G.GAME.current_round.hands_played == 0 then
            if context.before then
                if card.ability.extra.activated then
                    local copyPos = 0
                    for i = 1, #context.full_hand do
                        if context.full_hand[i] == card then copyPos = i-1 end
                    end
                    if copyPos > 0 then
                        copy_card(card, context.full_hand[copyPos])
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                context.full_hand[copyPos]:juice_up()
                                return true
                            end
                        })) 
                    end
                    return {
                        chips = card.ability.extra.chips,
                        mult = card.ability.extra.mult,
                        card = card
                    }
                else
                    card.ability.extra.activated = true
                end
            end
        end
    end
}

SMODS.Enhancement {
    key = "TempSteel",
    atlas = 'AKEnhancements',
    pos = {
        x = 2,
        y = 0
    },
    order = 1,
    config = {
        extra = {
        h_x_mult = 1.5,
        remainingTurn = 3,
        undebuffable = false,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
          vars = {
            card.ability.extra.h_x_mult,
            card.ability.extra.remainingTurn,
          }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.main_scoring then
            if not self.debuff then
                if card.ability.extra.remainingTurn >= 1 then
                    card.ability.extra.remainingTurn = card.ability.extra.remainingTurn - 1
                    return {
                    card = card,
                    Xmult_mod = card.ability.extra.h_x_mult,
                    message = "X".. card.ability.extra.h_x_mult,
                    colour = G.C.MULT
                }
                else
                    card:set_ability(G.P_CENTERS.c_base, nil, true)
                end 
            end
        end
        if context.final_scoring_step then
            card.ability.extra.undebuffable = false
            if card.ability.extra.remainingTurn <= 0 then
                card:set_ability(G.P_CENTERS.c_base, nil, true)
            end
        end
        if context.end_of_round and card.ability.extra.remainingTurn <= 0 then
            card:set_ability(G.P_CENTERS.c_base, nil, true)
        end
    end
}