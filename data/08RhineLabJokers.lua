SMODS.Joker{
    key = 'Astgenne', 
    name = 'Astgenne',
    rarity = 1,
    atlas = 'Jokers',
	cost = 3,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 14}, 
    config = { 
      extra = {
        multScaleFirst = 1,
        multScaleSecond = 3,
        multScaleThird = 5,
        multStorage = 0,
        tagClass = {"Caster"},
        tagFaction = {"Rhine", "Columbia"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.multScaleFirst, center.ability.extra.multScaleSecond, center.ability.extra.multScaleThird, center.ability.extra.multStorage}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before and #context.scoring_hand > 0 and context.scoring_hand[1].config.center ~= G.P_CENTERS.c_base then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), G.C.MULT})
                local foundEnhancement = context.scoring_hand[1].config.center
                card.ability.extra.multStorage = card.ability.extra.multStorage + card.ability.extra.multScaleFirst;
                if #context.scoring_hand > 1 and context.scoring_hand[2].config.center == foundEnhancement then      
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), G.C.MULT})
                    card.ability.extra.multStorage = card.ability.extra.multStorage + card.ability.extra.multScaleSecond;
                    if #context.scoring_hand > 2 and context.scoring_hand[3].config.center == foundEnhancement then      
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), G.C.MULT})
                        card.ability.extra.multStorage = card.ability.extra.multStorage + card.ability.extra.multScaleThird;
                    end
                end
            end
        end
        if context.joker_main then
            return {
			    mult = card.ability.extra.multStorage,
                card = card
		    }
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}

SMODS.Joker{
    key = 'Saria',
    name = 'Saria',
    rarity = 2,
    atlas = 'Jokers',
	cost = 6,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 14}, 
    config = { 
      extra = {
        healAmount = 1,
        planetEdition = {negative = true},
        aktsSettingPrice = false,
        aktsNewSellPrice = 0,
        tagClass = {"Defender"},
        tagFaction = {"Rhine", "Columbia"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "edition_negative_consumable"}
        info_queue[#info_queue+1] = {set = 'Other', key = "Heal"}
        return {vars = {center.ability.extra.healAmount, CalcPlanetsMult()}}
    end,
    add_to_deck = function(self, card, from_debuff)
        for k, consumables in pairs(G.consumeables.cards) do
            if consumables.ability.set == 'Planet' then
                consumables:set_edition(card.ability.extra.planetEdition, true)
            end
        end
    end,
    calculate = function(self,card,context)
        if context.card_added and not context.blueprint and not (context.card == card) then
			if context.card.ability.set == 'Planet' then
                G.E_MANAGER:add_event(Event({
                    trigger = "after", 
                    delay = 0.1,
                    func = function() 
                        context.card:set_edition(card.ability.extra.planetEdition, true)
                        return true
                    end
                }))
                
            end
		end

        if context.end_of_round and context.cardarea == G.jokers then
            local jokers = G.jokers and G.jokers.cards
            if not jokers then
                return
            end
            for _, joker in pairs(jokers) do 
                HealJoker(card, joker)
            end
        end

        if context.joker_main then
            return {
			    mult = CalcPlanetsMult(),
                card = card
		    }
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}

SMODS.Joker{
    key = 'Silence',
    name = 'Silence',
    rarity = 2,
    atlas = 'Jokers',
	cost = 5,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = false,
    eternal_compat = true, 
    perishable_compat = true,
    no_pool_flag = 'akts_silence_transform',
    pos = {x = 2, y = 14},
    config = { 
      extra = {
        planetCond = 2,
        targetGroup = {"Medic", "Rhine"},
        targetRetriggered = true,
        retriggerCount = 1,
        healAmount = 3,
        healApplied = false,
        aktsSettingPrice = false,
        aktsNewSellPrice = 0,
        transformCondCurrent = 0,
        transformCond = 15,
        transformLink = "j_akts_SilenceAlter",
        tagClass = {"Medic"},
        tagFaction = {"Rhine", "Columbia"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "Heal"}
        return {vars = {center.ability.extra.planetCond, center.ability.extra.healAmount, center.ability.extra.transformCond, center.ability.extra.transformCondCurrent}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before and #CalcOwnedPlanets() >= card.ability.extra.planetCond then
                card.ability.extra.targetRetriggered = false
            end
        end

        if context.retrigger_joker_check and not card.ability.extra.targetRetriggered and #CalcOwnedPlanets() >= card.ability.extra.planetCond and context.other_card ~= card then
            local targetList = MergeLists(CalcTaggedOwned(card.ability.extra.targetGroup[1]), CalcTaggedOwned(card.ability.extra.targetGroup[2]))
            for index, joker in pairs(targetList) do
                local ability = context.other_card.ability
                if ability and ability.extra and type(ability.extra) == "table" and "j_akts_" .. ability.name == joker then
                    card.ability.extra.targetRetriggered = true
                    return {
                        message = localize('k_again_ex'),
                        repetitions = card.ability.extra.retriggerCount,
                        card = context.other_card
                    }
                end
            end
        end

        if context.end_of_round and context.main_eval and context.game_over == false then
            card.ability.extra.targetRetriggered = true
            local maxSellValLoss = 0
            local healTarget = 0
            local jokers = G.jokers and G.jokers.cards
            if not jokers then
                return
            end
            for index, joker in pairs(jokers) do
                local jokerSellValLoss = math.max(0,(math.max(1, math.floor(joker.cost / 2)) - joker.sell_cost))
                if maxSellValLoss <  jokerSellValLoss then
                    maxSellValLoss = jokerSellValLoss
                    healTarget = index
                end
            end

            if maxSellValLoss > 0 and healTarget ~= nil then
                HealJoker(card, G.jokers.cards[healTarget])
                card.ability.extra.transformCondCurrent = card.ability.extra.transformCondCurrent + math.min(maxSellValLoss, card.ability.extra.healAmount)
            end

            if card.ability.extra.transformCondCurrent >= card.ability.extra.transformCond then
                G.GAME.pool_flags.akts_silence_transform = true
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
    key = 'SilenceAlter',
    name = 'SilenceAlter',
    rarity = 'akts_Transformed',
    atlas = 'Jokers',
	cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 14},
    config = { 
      extra = {
        targetGroup = {"Medic", "Rhine", "Supporter"},
        targetRetriggered = true,
        retriggerCount = 1,
        healAmount = 2,
        chipGain = 5,
        chipStorage = 0,
        undebuffCount = 1,
        enhanceChoice = {polychrome = true},
        aktsSettingPrice = false,
        aktsNewSellPrice = 0,
        tagClass = {"Supporter", "Medic"},
        tagFaction = {"Rhine", "Columbia"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "Heal"}
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        return {vars = {center.ability.extra.healAmount, center.ability.extra.chipGain, center.ability.extra.chipStorage, center.ability.extra.undebuffCount}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_silence_transform = true
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_silence_transform = false
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before then
                card.ability.extra.targetRetriggered = false
                local jokers = G.jokers and G.jokers.cards
                if card.ability.extra.undebuffCount > 0 and jokers then
                    for index, joker in pairs(jokers) do
                        if joker.debuff and (not joker.edition or not joker.edition.type == "negative") then
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_silence_immortal"), G.C.ATTENTION})
                            joker.ability.extra.undebuffable = true
                            joker.debuff = false
                            HealJoker(card, joker)
                            joker:set_edition(card.ability.extra.enhanceChoice, true)
                            card.ability.extra.undebuffCount = card.ability.extra.undebuffCount - 1
                            local currentAnte = G.GAME.round_resets.ante
                            G.E_MANAGER:add_event(Event({
                                func = function() 
                                    if G.GAME.round_resets.ante == currentAnte then
                                        return false
                                    end
                                    joker.ability.extra.undebuffable = false
                                    return true
                                end,
                                blocking = false
                            }))
                            return
                        end
                    end
                end
            end
        end

        if context.joker_main then
            local jokers = G.jokers and G.jokers.cards
            if card.ability.extra.undebuffCount > 0 and jokers then
                for index, joker in pairs(jokers) do
                    if joker.debuff and (not joker.edition or not joker.edition.type == "negative") then
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_silence_immortal"), G.C.ATTENTION})
                        joker.ability.extra.undebuffable = true
                        joker.debuff = false
                        HealJoker(card, joker)
                        joker:set_edition(card.ability.extra.enhanceChoice, true)
                        card.ability.extra.undebuffCount = card.ability.extra.undebuffCount - 1
                        local currentAnte = G.GAME.round_resets.ante
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                if G.GAME.round_resets.ante == currentAnte then
                                    return false
                                end
                                joker.ability.extra.undebuffable = false
                                return true
                            end,
                            blocking = false
                        }))
                        return
                    end
                end
            end

            local maxSellValLoss = 0
            local healTarget = 0
            local jokers = G.jokers and G.jokers.cards
            if not jokers then
                return
            end
            for index, joker in pairs(jokers) do
                local jokerSellValLoss = math.max(0,(math.max(1, math.floor(joker.cost / 2)) - joker.sell_cost))
                if maxSellValLoss <  jokerSellValLoss then
                    maxSellValLoss = jokerSellValLoss
                    healTarget = index
                end
            end

            if maxSellValLoss > 0 and healTarget ~= nil then
                HealJoker(card, G.jokers.cards[healTarget])
                local leftoverHeal = math.max(0, card.ability.extra.healAmount - maxSellValLoss)
                if leftoverHeal > 0 then
                    card.ability.extra.chipStorage = card.ability.extra.chipStorage + leftoverHeal * card.ability.extra.chipGain
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), G.C.CHIPS})
                end
            end

            return{
                chips = card.ability.extra.chipStorage,
                card = card
            }
        end

        if context.retrigger_joker_check and not card.ability.extra.targetRetriggered and context.other_card ~= card then
            local targetList = MergeLists(CalcTaggedOwned(card.ability.extra.targetGroup[3]), MergeLists(CalcTaggedOwned(card.ability.extra.targetGroup[1]), CalcTaggedOwned(card.ability.extra.targetGroup[2])))
            for index, joker in pairs(targetList) do
                local ability = context.other_card.ability
                if ability and ability.extra and type(ability.extra) == "table" and "j_akts_" .. ability.name == joker then
                    card.ability.extra.targetRetriggered = true
                    return {
                        message = localize('k_again_ex'),
                        repetitions = card.ability.extra.retriggerCount,
                        card = context.other_card
                    }
                end
            end
        end

        if context.end_of_round and not context.blueprint then
            card.ability.extra.targetRetriggered = true
        end

    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}

SMODS.Joker{
    key = 'Ifrit',
    name = 'Ifrit',
    rarity = 2,
    atlas = 'Jokers',
	cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 14}, 
    config = { 
      extra = {
        akts_burn_burst = true,
        multFactor = 2,
        burnFactor = 2,
        multFactorScale = 1,
        burnFactorScale = 1,
        handTypes = {"Straight", "Straight Flush"},
        tagClass = {"Caster"},
        tagFaction = {"Rhine", "Columbia"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "elementalInjury"}
        info_queue[#info_queue+1] = {set = 'Other', key = "burnBurst"}
        return {vars = {center.ability.extra.multFactor, center.ability.extra.burnFactor, ((G.GAME.hands[center.ability.extra.handTypes[1]].played + G.GAME.hands[center.ability.extra.handTypes[2]].played) or 0) * center.ability.extra.multFactor, center.ability.extra.multFactorScale}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            if not G.AKTS_Globals.burnBurstApplied then
                local addedElemInj = ((G.GAME.hands[card.ability.extra.handTypes[1]].played + G.GAME.hands[card.ability.extra.handTypes[2]].played) or 0) * card.ability.extra.burnFactor
                calculateElemInjury(card, 'Burn', addedElemInj)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = elemBurstChangeText(addedElemInj), G.C.ATTENTION})
            elseif next(context.poker_hands[card.ability.extra.handTypes[2]]) and not context.blueprint then
                card.ability.extra.multFactor = card.ability.extra.multFactor + card.ability.extra.multFactorScale
                card.ability.extra.burnFactor = card.ability.extra.burnFactor + card.ability.extra.burnFactorScale
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), G.C.MULT})
            end
            return {
			    mult = ((G.GAME.hands[card.ability.extra.handTypes[1]].played + G.GAME.hands[card.ability.extra.handTypes[2]].played) or 0) * card.ability.extra.multFactor,
                card = card
		    }
        end

        --Burn Apply
        if context.post_trigger and leftmostActivatedTrue("akts_burn_burst", getJokerSlot(card)) and G.AKTS_Globals.burnBurstApplied and not context.blueprint and context.other_ret.jokers then
            local returnMult = calculateBurnBurst(card, context, context.other_ret.jokers)
            if returnMult > 0 then
                return {
                    mult = returnMult,
                    card = context.other_card
                }
            end
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}