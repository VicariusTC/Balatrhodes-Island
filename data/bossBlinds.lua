SMODS.Blind {
    key = "renegade",
    dollars = 5,
    mult = 2,
    atlas = 'akts_blind',
    discovered = true,
    pos = { y = 3 },
    boss = { min = 0, showdown = false },
    boss_colour = HEX("ac0000"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.after and ((hand_chips * mult) + G.GAME.chips)/G.GAME.blind.chips >= 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.juice_up_blind()
                        for i = 1, #context.full_hand do
                            SMODS.destroy_cards(context.full_hand[i], true, false, false)
                        end
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Blind {
    key = "singer",
    dollars = 5,
    mult = 2,
    atlas = 'akts_blind',
    discovered = true,
    pos = { y = 4 },
    boss = { min = 4, showdown = false },
    boss_colour = HEX("5a559a"),
    config = {
        extra = {
            subtractor = 0.5,
        }
    },
    loc_vars = function(self)
        return { vars = { "" ..self.config.extra.subtractor} }
    end,
    collection_loc_vars = function(self)
        return { vars = { "" ..self.config.extra.subtractor } }
    end,
    calculate = function(self, blind, context)
        local setSingerDebuff = function(card)
            if card.sell_cost <= 0 then 
                card:juice_up()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_no_hp'), colour = G.C.MULT})
                SMODS.debuff_card(card, true, "AKTSSingerDebuff")
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        if not G.STATE_COMPLETE then
                            return false
                        end
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                SMODS.debuff_card(card, false, "AKTSSingerDebuff")
                                return true
                            end,
                        }))
                        return true
                    end,
                    blocking = false
                }))
            else
                local sellValue = card.sell_cost
                G.AKTS_Globals.customPriceSetter =  math.max(0, sellValue - self.config.extra.subtractor)
                if card.ability and type(card.ability.extra) == "table" and card.ability.extra.aktsSellValue then
                    card.ability.extra.aktsSellValue = G.AKTS_Globals.customPriceSetter
                end
                card:set_cost()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_hp_down'), colour = G.C.MULT})
                G.AKTS_Globals.customPriceSetter = nil
            end
        end
        
        if not blind.disabled then
            if context.press_play then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        for i = 1, #G.jokers.cards do
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    setSingerDebuff(G.jokers.cards[i])
                                    return true
                                end,
                            }))
                            delay(0.23)
                        end
                        return true
                    end
                }))
                blind.triggered = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = (function()
                        SMODS.juice_up_blind()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.06 * G.SETTINGS.GAMESPEED,
                            blockable = false,
                            blocking = false,
                            func = function()
                                play_sound('tarot2', 0.76, 0.4)
                                return true
                            end
                        }))
                        play_sound('tarot2', 1, 0.4)
                        return true
                    end)
                }))
                delay(0.4)
            end
        end
    end
}

SMODS.Blind {
    key = "patriot",
    dollars = 5,
    mult = 2,
    atlas = 'akts_blind',
    discovered = true,
    pos = { y = 0 },
    boss = { min = 5, showdown = false },
    boss_colour = HEX("975210"),
    config = {
        extra = {
            subtractor = 50,
        }
    },
    loc_vars = function(self)
        return { vars = { G.GAME.round_resets.ante * self.config.extra.subtractor } }
    end,
    collection_loc_vars = function(self)
        return { vars = { "" ..self.config.extra.subtractor .. localize('akts_blind_patriot') } }
    end,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.modify_hand then
                blind.triggered = true
                hand_chips = mod_chips(hand_chips - (self.config.extra.subtractor * G.GAME.round_resets.ante))
                update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips, mult = mult })
            end
        end
    end
}

SMODS.Blind {
    key = "sanguinarch",
    dollars = 5,
    mult = 2,
    atlas = 'akts_blind',
    discovered = true,
    pos = { y = 1 },
    boss = { min = 6, showdown = false },
    boss_colour = HEX("8e5860"),
    config = {
        extra = {
            cursedCount = 20,
            removeCount = 5,
            enhancement = "m_akts_BloodAmber"
        }
    },
    calculate = function(self, blind, context)
        if context.setting_blind and not blind.disabled then
            for i = 1, self.config.extra.cursedCount, 1 do
                local newCard = SMODS.add_card{set = 'Base', area = G.deck, no_edition = true, enhancement = self.config.extra.enhancement}
                playing_card_joker_effects({newCard})
            end
        end

        if context.end_of_round and context.main_eval and context.game_over == false then
            local removals = G.GAME.current_round.hands_left * self.config.extra.removeCount
            for _, playing_card in ipairs(G.playing_cards) do
                if removals == 0 then
                    break
                end
                if SMODS.has_enhancement(playing_card, "m_akts_BloodAmber") then 
                    SMODS.destroy_cards(playing_card, true, false, false)
                    removals = removals - 1
                end
            end
        end
    end
}

SMODS.Blind {
    key = "source_code",
    dollars = 5,
    mult = 2,
    atlas = 'akts_blind',
    discovered = true,
    pos = { y = 2 },
    boss = { min = 8, showdown = true },
    boss_colour = HEX("1a1a1a"),
    config = {
        extra = {
            currentPhase = 0,
            controlPhase = 1,
            controlLength = 1,
            controlActiveDuration = 0,
        }
    },
    calculate = function(self, blind, context)
        if context.hand_drawn and not blind.disabled then
            if self.config.extra.currentPhase >= self.config.extra.controlPhase then
                self.config.extra.controlActiveDuration = self.config.extra.controlActiveDuration + 1
                self.config.extra.currentPhase = self.config.extra.currentPhase + 1

                G.E_MANAGER:add_event(Event({
                    func = function()
                        local shouldPlay = pseudorandom('playCheck') < G.GAME.current_round.hands_left / (G.GAME.current_round.hands_left + G.GAME.current_round.discards_left)
                        local cardAmount = math.max(1, round_number(pseudorandom('count') * 5, 0))
                        local any_selected = nil
                        local _cards = {}
                        for _, playing_card in ipairs(G.hand.cards) do
                            _cards[#_cards + 1] = playing_card
                        end
                        for i = 1, cardAmount do
                            if G.hand.cards[i] then
                                local selected_card, card_index = pseudorandom_element(_cards, 'selector')
                                G.hand:add_to_highlighted(selected_card, true)
                                table.remove(_cards, card_index)
                                any_selected = true
                                play_sound('card1', 1)
                            end
                        end
                        if any_selected then
                            if shouldPlay then
                                G.FUNCS.play_cards_from_highlighted()
                            else
                                G.FUNCS.discard_cards_from_highlighted()
                            end
                        end
                        return true
                    end
                }))
                if self.config.extra.controlActiveDuration >= self.config.extra.controlLength then
                    self.config.extra.controlActiveDuration = 0
                    self.config.extra.currentPhase = 0
                end
            else
                self.config.extra.currentPhase = self.config.extra.currentPhase + 1
            end
        end
    end
}

SMODS.Blind {
    key = "carnevale",
    dollars = 5,
    mult = 2,
    atlas = 'akts_blind',
    discovered = true,
    pos = { y = 5 },
    boss = { min = 3, showdown = false },
    boss_colour = HEX("5c1ca7"),
    config = {
        extra = {
            payout = 5
        }
    },
    calculate = function(self, blind, context)
        if blind.disabled then
            G.GAME.blind.dollars = self.config.extra.payout or 5
        end
        if not blind.disabled and context.setting_blind then
            self.config.extra.payout = G.GAME.blind.dollars
            G.GAME.blind.dollars = 0
        end
        if not blind.disabled and context.final_scoring_step then
            if G.GAME.blind.chips < SMODS.calculate_round_score() then
                G.GAME.blind.dollars = 2 * self.config.extra.payout
            else
                G.GAME.blind.dollars = 0
            end
        end
    end
}

SMODS.Blind {
    key = "seaborn",
    dollars = 5,
    mult = 2,
    atlas = 'akts_blind',
    discovered = true,
    pos = { y = 6 },
    boss = { min = 1, showdown = false },
    boss_colour = HEX("0a3478"),
    calculate = function(self, blind, context)
        if not blind.disabled and context.post_trigger then
            if context.other_card and type(context.other_card) == "table" then
                context.other_card.aktsSeabornStun = true
                G.E_MANAGER:add_event(Event({
                    delay = 0.15,
                    func = function() 
                        context.other_card:juice_up()
                        context.other_card.aktsSeabornStun = nil
                        return true
                    end,
                    blocking = false
                }))
            end
            SMODS.debuff_card(context.other_card, true, "seaborn_debuff")
            
            local handsPlayed = G.GAME.current_round.hands_played
            G.E_MANAGER:add_event(Event({
                func = function() 
                    if G.GAME.blind and handsPlayed == G.GAME.current_round.hands_played then
                        return false
                    end
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            SMODS.debuff_card(context.other_card, false, "seaborn_debuff")
                            return true
                        end,
                    }))
                    return true
                end,
                blocking = false
            }))
        end
    end
}