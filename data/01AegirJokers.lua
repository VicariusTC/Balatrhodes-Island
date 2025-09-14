----------------------------------------Base Aegir end----------------------------------------

SMODS.Joker{
    key = 'Gladiia', 
    name = 'Gladiia',
    rarity = 2,
    atlas = 'Jokers',
	cost = 7,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = false, 
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 0, y = 2}, 
    config = { 
      extra = {
        flushThreshold = 3,
        flushPlayed = 0,
        flushPlayedMin = 0,
        targetNum = 8,
        tagClass = {"Specialist"},
        tagFaction = {"Abyssal", "Aegir"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_akts_Hook
        return {vars = {center.ability.extra.flushThreshold, center.ability.extra.flushPlayed, center.ability.extra.targetNum}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand and not context.blueprint then
            if context.before and next(context.poker_hands['Flush']) then
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() == 8 then 
                        context.scoring_hand[i]:set_ability(G.P_CENTERS.m_akts_Hook, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                context.scoring_hand[i]:juice_up()
                                return true
                            end
                        })) 
                    end
                end
                delay(0.2) 
            end
            if context.joker_main and not context.blueprint and next(context.poker_hands['Flush']) then
                card.ability.extra.flushPlayed = card.ability.extra.flushPlayed + 1
                if card.ability.extra.flushPlayed >= card.ability.extra.flushThreshold then
                    if G.jokers.config.card_limit > (#G.jokers.cards + G.GAME.joker_buffer) then
                        local excluList = calcTaggedOwned(card.ability.extra.tagFaction[2])
                        table.insert(excluList, "j_akts_SpecterAlter")
                        local abyssalList = calcTagged(card.ability.extra.tagFaction[2], excluList)
                        if #abyssalList > 0 then
                            Create_Joker(abyssalList, card)
                        end
                    else
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_no_space"), G.C.INACTIVE})
                    end
                    card.ability.extra.flushPlayed = card.ability.extra.flushPlayedMin
                end
            end
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end 
}

SMODS.Joker{
    key = 'Skadi', 
    name = 'Skadi',
    rarity = 3,
    atlas = 'Jokers',
	cost = 8,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 1, y = 2}, 
    config = { 
      extra = {
        baseMult = 1,
        handSizeBonus = 1,
        storedHandSizeBonus = 0,
        multBonus = 0.2,
        exmultBonus = 1,
        exmultBonusReq = 5,
        tagClass = {"Guard"},
        tagFaction = {"Abyssal", "Aegir"}
      }
    },
    loc_vars = function(self,info_queue,center)
        local factionOwned = #calcTaggedOwned(center.ability.extra.tagFaction[1])
        return {vars = {center.ability.extra.handSizeBonus, factionOwned * center.ability.extra.handSizeBonus, center.ability.extra.multBonus, center.ability.extra.exmultBonus, center.ability.extra.exmultBonusReq, skadiMultModCalc(center.ability.extra)}}
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.storedHandSizeBonus)
    end,
    calculate = function(self,card,context)
        if (context.setting_blind and context.main_eval) or context.joker_main then
            G.hand:change_size(- card.ability.extra.storedHandSizeBonus)
            local handSizeBonus = #calcTaggedOwned(card.ability.extra.tagFaction[1]) * card.ability.extra.handSizeBonus
            card.ability.extra.storedHandSizeBonus = handSizeBonus
            G.hand:change_size(handSizeBonus)
        end
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = skadiMultModCalc(card.ability.extra),
                message = localize('akts_tidal'),
                colour = G.C.MULT,
                delay = 0.5,
            }
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end     
}

SMODS.Joker{
    key = 'Specter', 
    name = 'Specter',
    rarity = 2,
    atlas = 'Jokers',
	cost = 4,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true,
    no_pool_flag = 'akts_specter_transform',
    pos = {x = 2, y = 2}, 
    config = { 
      extra = {
        chipbonus = 20,
        multbonus = 2,
        returnchipbonus = 0,
        returnmultbonus = 0,
        targetNum = 8,
        transformLink = "j_akts_SpecterAlter",
        tagClass = {"Guard"},
        tagFaction = {"Abyssal", "Aegir"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.chipbonus, center.ability.extra.multbonus, center.ability.extra.targetNum}}
    end,
    calculate = function(self,card,context)
        
        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round then
            card.ability.extra.returnmultbonus = 0
            card.ability.extra.returnchipbonus = 0
            if context.other_card:get_id() >= card.ability.extra.targetNum then
                card.ability.extra.returnmultbonus = card.ability.extra.multbonus
            end
            if context.other_card:get_id() <= card.ability.extra.targetNum then
                card.ability.extra.returnchipbonus = card.ability.extra.chipbonus
            end
            return {
                chips = card.ability.extra.returnchipbonus,
                mult = card.ability.extra.returnmultbonus,
                card = card
            }
        end
        if context.before and next(context.poker_hands['Flush Five']) then
            G.GAME.pool_flags.akts_specter_transform = true
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_transform_unchained"), G.C.ATTENTION})
            jokerTransform(card, card.ability.extra.transformLink)
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end 
}

SMODS.Joker{
    key = 'SpecterAlter', 
    name = 'SpecterAlter',
    rarity = 'akts_Transformed',
    atlas = 'Jokers',
	cost = 10,
    unlocked = true, 
    discovered = false, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 3, y = 2}, 
    config = { 
      extra = {
        chipbonus = 80,
        multbonus = 8,
        extraXMult = 1.08,
        currentXMult = 1,
        returnchipbonus = 0,
        returnmultbonus = 0,
        targetNum = 8,
        akts_save = false,
        prevDeathTrigger = false,
        prevDeathTriggerDesc = 1,
        tagClass = {"Specialist", "Guard"},
        tagFaction = {"Abyssal", "Aegir"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.chipbonus, center.ability.extra.multbonus, center.ability.extra.targetNum, center.ability.extra.prevDeathTriggerDesc, center.ability.extra.extraXMult}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_specter_transform = true
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_specter_transform = false
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand and not card.ability.extra.prevDeathTrigger then
            card.ability.extra.akts_save = false
            local Eights = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == card.ability.extra.targetNum then 
                    Eights = 1
                    break 
                end
            end
            if Eights > 0 then
                card.ability.extra.akts_save = true
            end
        end
        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round then
            card.ability.extra.returnmultbonus = 0
            card.ability.extra.returnchipbonus = 0
            if context.other_card:get_id() >= card.ability.extra.targetNum then
                card.ability.extra.returnmultbonus = card.ability.extra.multbonus
            end
            if context.other_card:get_id() <= card.ability.extra.targetNum then
                card.ability.extra.returnchipbonus = card.ability.extra.chipbonus
            end
            if card.ability.extra.currentXMult == card.ability.extra.extraXMult then
                return {
                chips = card.ability.extra.returnchipbonus,
                mult = card.ability.extra.returnmultbonus,
                Xmult_mod = card.ability.extra.currentXMult,
                message = 'X' .. card.ability.extra.currentXMult,
                colour = G.C.MULT,
                card = card
                }
            else
                return {
                chips = card.ability.extra.returnchipbonus,
                mult = card.ability.extra.returnmultbonus,
                card = card
                }
            end
            
        end
        if context.end_of_round and not self.debuff then
            if context.game_over and not card.ability.extra.prevDeathTrigger and card.ability.extra.akts_save then
                if leftmostActivatedTrue("akts_save", getJokerSlot(card)) then
                    --Add a function that looks at every joker to the left and sees if their akts_save is true. if so, then turn your akts_save to false.
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.hand_text_area.blind_chips:juice_up()
                            G.hand_text_area.game_chips:juice_up()
                            play_sound('tarot1')
                            card.ability.extra.prevDeathTrigger = true
                            card.ability.extra.prevDeathTriggerDesc = 0
                            card.ability.extra.akts_save = false
                            card.ability.extra.currentXMult = card.ability.extra.extraXMult
                            return true
                        end
                        })) 
                    return {
                        message = localize('k_saved_ex'),
                        saved = true,
                        colour = G.C.RED
                    }
                else
                    card.ability.extra.akts_save = false
                end
            end
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end 
}

SMODS.Joker{
    key = 'Andreana', 
    name = 'Andreana',
    rarity = 1,
    atlas = 'Jokers',
	cost = 5,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = false, 
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 4, y = 2}, 
    config = { 
      extra = {
        chipStorage = 0,
        chipIncrement = 10,
        moneyGain = 2,
        curerentMoneyGain = 0,
        blindReq = 50,
        tagClass = {"Sniper"},
        tagFaction = {"Abyssal", "Aegir"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.moneyGain, center.ability.extra.chipIncrement, center.ability.extra.blindReq, center.ability.extra.chipStorage}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.joker_main then
            if G.GAME.blind then
                card.ability.extra.curerentMoneyGain = 0
                if ((hand_chips * mult) + G.GAME.chips + card.ability.extra.chipStorage)/G.GAME.blind.chips <= 0.01 * card.ability.extra.blindReq then
                    card.ability.extra.chipStorage = card.ability.extra.chipStorage + card.ability.extra.chipIncrement
                    card.ability.extra.curerentMoneyGain = card.ability.extra.moneyGain
                    return {
                        card = card,
                        chips = card.ability.extra.chipStorage,
                        dollars = card.ability.extra.curerentMoneyGain
                    }
                else
                    return {
                        card = card,
                        chips = card.ability.extra.chipStorage
                    }
                end
            end          
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

----------------------------------------Abyssal Hunter end----------------------------------------