SMODS.Shader({ key = 'thunder', path = 'Thunderstruck.fs' })

SMODS.Edition {
    key = 'thunderstruck',
    shader = 'thunder',
    config = { 
        extra = {
            moveXmult = 0.3,
            moveCount = 0,
            blocked = false
        } 
    },
    discovered = true,
    unlocked = true,
    in_shop = false,
    weight = 0,
    extra_cost = 3,
    sound = { sound = "foil1", per = 1.2, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = { 1 + card.edition.extra.moveXmult } }
    end,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            card.edition.extra.blocked = false
            for index, _card in ipairs(context.scoring_hand) do
                if _card == card then
                    local leftMost = nil
                    for i = index - 1, 1, -1 do
                        local _delay = (index - i) / 2
                        local previous = context.scoring_hand[i]
                        if previous and previous.config.center == G.P_CENTERS.c_base then
                            leftMost = previous
                            card.edition.extra.moveCount = card.edition.extra.moveCount + 1
				            G.E_MANAGER:add_event(Event({
					            trigger = "after",
					            delay = _delay,
					            blocking = false,
					            func = function()
						            previous:juice_up(1, 0.5)
						            play_sound('polychrome1', 1.2, 0.7)
						            return true
					            end
				            }))
                        else
                            break
                        end
                    end
                    if leftMost then
                        leftMost:set_edition("e_akts_thunderstruck", true, true)
				        leftMost.edition.akts_thunderstruck = false
                        local ability = card.config.center.key
				        G.E_MANAGER:add_event(Event({
					        trigger = "after",
					        delay = 1.0,
					        blocking = false,
					        func = function()
                                leftMost:set_ability(card.config.center.key)
                                leftMost:set_edition("e_akts_thunderstruck", true, true)
						        leftMost.edition.akts_thunderstruck = true
						        return true
					        end
				        }))
                    end
                end
                SMODS.destroy_cards(card)
                if card.edition.extra.moveCount > 0 then
                    return {
                        xmult = 1 + (card.edition.extra.moveCount * card.edition.extra.moveXmult)
                    }
                end
            end
        end

        if context.discard and context.other_card == card then
            card:set_edition()
        end
    end
}