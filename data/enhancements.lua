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
                        if context.full_hand[i] == card then
                            copyPos = i-1
                            break
                        end
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
                    xmult = card.ability.extra.h_x_mult,
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

SMODS.Enhancement {
    key = "BloodAmber",
    atlas = 'AKEnhancements',
    pos = {
        x = 3,
        y = 0
    },
    order = 1,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
    weight = 0,
    in_pool = function(self, args) return false end,
    config = { bonus = -50 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.bonus } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            SMODS.destroy_cards(card, true, false, false)
        end
    end
}

SMODS.Enhancement {
    key = "Revenant",
    atlas = 'AKEnhancements',
    pos = {
        x = 4,
        y = 0
    },
    order = 1,
    any_suit = true,
    weight = 0,
    in_pool = function(self, args) return false end,
    config = { 
        Xmult = 3,
        extra = {
            previousEnhancement = G.P_CENTERS.c_base,
            round = 0,
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round or (context.hand_drawn and not (G.GAME.blind or G.GAME.round ~= card.ability.extra.round)) then
            card:set_ability(card.ability.extra.previousEnhancement, nil, true)
        end
    end
}