SMODS.Joker{
    key = 'AmiyaC', 
    name = 'AmiyaC',
    rarity = 1,
    atlas = 'Jokers',
	cost = 8,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    pos = {x = 4, y = 0}, 
    config = { 
      extra = {
        multScale = 1,
        multStore = 0,
        maxMultScaleRound = 5,
        maxMultScaleCurrent = 0,
        tagClass = {"Caster"},
        tagFaction = {"Rhodes"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.multScale, center.ability.extra.multStore, center.ability.extra.maxMultScaleRound}}
    end,

    add_to_deck = function(self, card, from_debuff)
        if G.jokers.config.card_limit > (#G.jokers.cards + G.GAME.joker_buffer + 1) then
            local excluList = CalcTaggedOwned(card.ability.extra.tagFaction[1])
            local excluListAwoken = CalcTaggedRarity("akts_Transformed")
            for _, v in ipairs(excluListAwoken) do
                table.insert(excluList, v)
            end
            table.insert(excluList, "j_akts_AmiyaC")
            local rhodesList = CalcTagged(card.ability.extra.tagFaction[1], excluList)
            if #rhodesList > 0 then
                Create_Joker(rhodesList, card, nil, nil, localize("akts_plus_summon"))
            end
        else
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_no_space_ex")})
        end
    end,
    calculate = function(self,card,context)
        --reset Mult Scaling.
        if context.setting_blind and context.main_eval then
            card.ability.extra.maxMultScaleCurrent = 0
        end


        --Check for Rhodes Trigger
        if not context.blueprint and (context.post_trigger) and card.ability.extra.maxMultScaleCurrent < card.ability.extra.maxMultScaleRound then --and calcTaggedOwned(card.ability.extra.tagFaction[1])[context.other_joker.name]
            local ownedRhodes = CalcTaggedOwned(card.ability.extra.tagFaction[1])
            if isInTable('j_akts_' .. context.other_card.ability.name, ownedRhodes) ~= 0 and context.other_card ~= card then
                card.ability.extra.maxMultScaleCurrent = card.ability.extra.maxMultScaleCurrent + 1
                card.ability.extra.multStore = card.ability.extra.multStore + card.ability.extra.multScale
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), G.C.ATTENTION})
            end
        end
		if context.joker_main then
            return {
			    mult = card.ability.extra.multStore,
                card = card
		    }
        end		
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'Kaltsit', 
    name = 'Kaltsit',
    rarity = 2,
    atlas = 'Jokers', --atlas' key
	cost = 4,
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
        cash = 1, --Money
        tagClass = {"Medic"},
        tagFaction = {"Rhodes"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.c_akts_Mon3tr
        return {vars = {center.ability.extra.cash}} --#1# is replaced with card.ability.extra.cash
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local _card = create_card('SummonConsumableType', G.consumeables, nil, nil, nil, nil, 'c_akts_Mon3tr')
            _card:add_to_deck()
            G.consumeables:emplace(_card)
            card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('akts_plus_Mon3tr'), colour = G.C.PURPLE})
        end
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and context.other_card.config.center == G.P_CENTERS.m_akts_True then
            return {
                dollars = card.ability.extra.cash
            }
        end

        if context.setting_blind and context.main_eval and G.GAME.blind and (G.GAME.blind.boss) then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                local _card = create_card("SummonConsumableType", G.consumeables, nil, nil, nil, nil, 'c_akts_Mon3tr')
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize("akts_plus_Mon3tr"), G.C.PURPLE})
            end
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'FangAlter', 
    name = 'FangAlter',
    rarity = 1,
    atlas = 'Jokers',
	cost = 3,
    blueprint_compat = true,
    unlocked = true, 
    discovered = true, 
    pos = {x = 1, y = 0}, 
    config = { 
      extra = {
        returnMoney = 2,
        timeLimit = 4,
        extraMult = 5,
        tagList = {'tag_uncommon', 'tag_rare', 'tag_foil', 'tag_holo', 'tag_polychrome', 'tag_negative'},
        tagClass = {"Vanguard"},
        tagFaction = {"Rhodes"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.extraMult, center.ability.extra.returnMoney, center.ability.extra.timeLimit}}
    end,
    calculate = function(self,card,context)
        if context.joker_main and context.scoring_hand and card.ability.extra.timeLimit > 0 then
            if not context.blueprint then
                card.ability.extra.timeLimit = card.ability.extra.timeLimit - 1
            end
		    return {
			    mult = card.ability.extra.extraMult
		    }
	    end
        if context.selling_self and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    local pickedTag = pseudorandom_element(card.ability.extra.tagList, pseudoseed("akts_random_seed"))
                    add_tag(Tag(pickedTag))
                    play_sound('generic1', 0.9 + pseudorandom(pseudoseed("akts_random_seed"))*0.1, 0.8)
                    play_sound('holo1', 1.2 + pseudorandom(pseudoseed("akts_random_seed"))*0.1, 0.4)
                    return true
                end)
            }))
        end
    end,
    calc_dollar_bonus = function(self,card)
        return card.ability.extra.returnMoney
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'Gavial', 
    name = 'Gavial',
    rarity = 1,
    atlas = 'Jokers',
	cost = 5,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    no_pool_flag = 'akts_gavial_transform',
    pos = {x = 2, y = 0}, 
    config = { 
      extra = {
        enhanceChoice = {foil = true},
        scoredLower = 0.9,
        scoredUpper = 1.25,
        wildLower = 1,
        wildUpper = 1.5,
        transformLink = "j_akts_GavialAlter",
        tagClass = {"Medic"},
        tagFaction = {"Rhodes", "Sargon"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        return {vars = {center.ability.extra.scoredLower, center.ability.extra.scoredUpper, center.ability.extra.wildLower, center.ability.extra.wildUpper}}
    end,
    add_to_deck = function(self, card, from_debuff)
        local jokers = G.jokers and G.jokers.cards
        local unenhanced = {}
        for _, jonkler in pairs(jokers) do
            local ability = jonkler.ability
            if ability and (ability.extra and type(ability.extra) == "table" and not jonkler.edition and CalcTaggedListHelper(card.ability.extra.tagClass[1], ability.extra)) then
                table.insert(unenhanced, jonkler)
            end
        end
        if #unenhanced > 0 then
            local pickedMed = pseudorandom_element(unenhanced, pseudoseed("akts_random_seed"))
            pickedMed:set_edition(card.ability.extra.enhanceChoice, true)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_gavial_edition'), colour = G.C.PURPLE})
        end
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round then
            local returnMult = 1
            if context.other_card.config.center == G.P_CENTERS.m_wild then
                returnMult = card.ability.extra.wildLower + pseudorandom(pseudoseed("akts_random_seed")) * (card.ability.extra.wildUpper - card.ability.extra.wildLower)
            else
                returnMult = card.ability.extra.scoredLower + pseudorandom(pseudoseed("akts_random_seed")) * (card.ability.extra.scoredUpper - card.ability.extra.scoredLower)
            end
            G.E_MANAGER:add_event(Event({func = (function() card:juice_up(); return true end)}))
            return {
                xmult = returnMult,
            }
        end
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before and #context.full_hand == 5 then
                local transformable = false
                for i = 1, #context.full_hand do
                    if context.full_hand[i].config.center ~= G.P_CENTERS.m_wild then
                        transformable = false 
                        break
                    end
                    transformable = true
                end
                if transformable then
                    G.GAME.pool_flags.akts_gavial_transform = true
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_transform"), G.C.ATTENTION})
                    jokerTransform(card, card.ability.extra.transformLink)
                end
            end
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'GavialAlter', 
    name = 'GavialAlter',
    rarity = 'akts_Transformed',
    atlas = 'Jokers',
	cost = 5,
    unlocked = true, 
    discovered = false, 
    blueprint_compat = true, 
    pos = {x = 3, y = 0}, 
    config = { 
      extra = {
        minReqScore = 50,
        currentdebt = 0,
        fulldebt = 0,
        debtPayment = 0.05,
        debtLoss = 100,
        scoredLower = 1.1,
        scoredUpper = 1.5,
        wildLower = 1.25,
        wildUpper = 2,
        akts_save = true,
        tagClass = {"Guard", "Medic"},
        tagFaction = {"Rhodes", "Sargon"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        info_queue[#info_queue+1] = {set = 'Other', key = "ChipDebt"}
        return {vars = {center.ability.extra.scoredLower, center.ability.extra.scoredUpper, center.ability.extra.wildLower, center.ability.extra.wildUpper, center.ability.extra.currentdebt, center.ability.extra.fulldebt, center.ability.extra.minReqScore}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_gavial_transform = true
    end, 
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_gavial_transform = false
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round then
            local returnMult = 1
            if context.other_card.config.center == G.P_CENTERS.m_wild then
                returnMult = card.ability.extra.wildLower + pseudorandom(pseudoseed("akts_random_seed")) * (card.ability.extra.wildUpper - card.ability.extra.wildLower)
            else
                returnMult = card.ability.extra.scoredLower + pseudorandom(pseudoseed("akts_random_seed")) * (card.ability.extra.scoredUpper - card.ability.extra.scoredLower)
            end 
            G.E_MANAGER:add_event(Event({func = (function() card:juice_up(); return true end)}))
            return {
                xmult = returnMult,
            }
        end

        if not context.blueprint and context.hand_drawn then
            G.GAME.chips = gavialAlterDebtPayment(card, G.GAME.chips, 'tax')
        end

        if not context.blueprint and context.end_of_round and context.cardarea == G.jokers then
            local cardExtra = card.ability.extra
            local fullyDebted = (G.GAME.chips - (cardExtra.debtPayment * cardExtra.fulldebt)) /G.GAME.blind.chips < cardExtra.minReqScore / 100
            if fullyDebted then
                G.GAME.chips = gavialAlterDebtPayment(card, G.GAME.chips, 'tax')
            end
            if G.GAME.chips/G.GAME.blind.chips < 1 and not fullyDebted and cardExtra.akts_save and leftmostActivatedTrue("akts_save", getJokerSlot(card)) then
                cardExtra.currentdebt = cardExtra.currentdebt + (G.GAME.blind.chips - G.GAME.chips)
                cardExtra.fulldebt = cardExtra.fulldebt + (G.GAME.blind.chips - G.GAME.chips)
                card:set_eternal(true)
                G.GAME.chips = G.GAME.blind.chips
                G.STATE = G.STATES.HAND_PLAYED
                G.STATE_COMPLETE = true
                return {
                    saved = true,
                    message = localize('akts_gavial_win'),
                    colour = G.C.MULT
                }
            else
                local overflowScore = G.GAME.chips - G.GAME.blind.chips
                G.GAME.chips = G.GAME.chips - (overflowScore - gavialAlterDebtPayment(card, overflowScore, 'full'))
            end
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'Yato', 
    name = 'Yato',
    rarity = 1,
    atlas = 'Jokers',
	cost = 3,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    no_pool_flag = 'akts_yato_sold',
    pos = {x = 5, y = 0}, 
    config = { 
      extra = {
        fastRedeployFlag = true,
        bonusChips = 30,
        isFirstHand = true,
        tagClass = {"Vanguard"},
        tagFaction = {"Rhodes"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "FastRedeploy"}
        return {vars = {center.ability.extra.bonusChips}}
    end,
    calculate = function(self,card,context)
        if context.joker_main and (G.GAME.current_round.hands_played == 0 or card.ability.extra.isFirstHand) then
            if not context.blueprint then
                card.ability.extra.isFirstHand = false
            end
            return {
					chips = card.ability.extra.bonusChips,
					card = card
			}
		end

        if context.selling_self and not context.blueprint then
            --Kirin R Yato Unlock Condition
            if G.AKTS_Globals.yatosSold > G.AKTS_Globals.yatosSoldCondition then
                G.GAME.pool_flags.akts_yato_sold = true
            end
            G.AKTS_Globals.yatosSold = G.AKTS_Globals.yatosSold + 1
            PerformFastRedeploy("j_akts_Yato", card)
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'YatoAlter', 
    name = 'YatoAlter',
    rarity = 'akts_Transformed',
    atlas = 'Jokers',
	cost = 6,
    unlocked = true, 
    discovered = false, 
    blueprint_compat = true, 
    pos = {x = 6, y = 0}, 
    config = { 
      extra = {
        fastRedeployFlag = true,
        bonusChips = 30,
        bonusMult = 6,
        firstHandMultiplier = 16,
        isFirstHand = true,
        tagClass = {"Specialist", "Vanguard"},
        tagFaction = {"Rhodes"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "FastRedeploy"}
        return {vars = {center.ability.extra.bonusChips, center.ability.extra.bonusMult, center.ability.extra.firstHandMultiplier}}
    end,
    calculate = function(self,card,context)
        if context.joker_main and (G.GAME.current_round.hands_played == 0 or card.ability.extra.isFirstHand) then
            local bonusChips = card.ability.extra.bonusChips
            local bonusMult = card.ability.extra.bonusMult
            if card.ability.extra.isFirstHand then
                if not context.blueprint then
                    card.ability.extra.isFirstHand = false
                end
                bonusChips = bonusChips * card.ability.extra.firstHandMultiplier
                bonusMult = bonusMult * card.ability.extra.firstHandMultiplier
            end
            return {
					chips = bonusChips,
                    mult = bonusMult,
					card = card
			}
		end

        if context.selling_self and not context.blueprint then
            PerformFastRedeploy("j_akts_YatoAlter", card)
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'ProjektRed', 
    name = 'ProjektRed',
    rarity = 1,
    atlas = 'Jokers',
	cost = 4,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = false, 
    pos = {x = 7, y = 0}, 
    config = { 
      extra = {
        targetHands = nil,
        fastRedeployFlag = true,
        isFirstHand = true,
        handDivisor = 2,
        handDivisorMinus = 1,
        firstHandDivisorLimit = 1.5,
        tagClass = {"Specialist"},
        tagFaction = {"Rhodes"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "FastRedeploy"}
        return {vars = {
            (center.ability.extra.targetHands or G.GAME.round_resets.hands) + center.ability.extra.handDivisor, math.max(center.ability.extra.firstHandDivisorLimit, (center.ability.extra.targetHands or G.GAME.round_resets.hands) - center.ability.extra.handDivisorMinus)}}
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.targetHands = G.GAME.round_resets.hands
    end,
    calculate = function(self,card,context)
        if context.hand_drawn then
            if G.GAME.current_round.hands_played + G.GAME.current_round.hands_left > card.ability.extra.targetHands 
            and G.GAME.current_round.hands_played + G.GAME.current_round.hands_left > G.GAME.round_resets.hands + 1 then
                card.ability.extra.targetHands = G.GAME.current_round.hands_played + G.GAME.current_round.hands_left
            end
            G.AKTS_Globals.redMaxChips = 0
        end

        if context.cardarea == G.jokers and context.scoring_hand and context.final_scoring_step then
            local abExtra = card.ability.extra
            local returnChips = (1/ (abExtra.targetHands + abExtra.handDivisor)) * G.GAME.blind.chips
            if abExtra.isFirstHand then
                returnChips = (1/math.max(abExtra.firstHandDivisorLimit, abExtra.targetHands - abExtra.handDivisorMinus)) * G.GAME.blind.chips
            end
            abExtra.isFirstHand = false
            if returnChips > (mult * hand_chips) and returnChips > G.AKTS_Globals.redMaxChips then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_red_active"), G.C.ATTENTION})
                mult = mod_mult(0)
                hand_chips = mod_chips(0)
                G.GAME.chips = G.GAME.chips + (returnChips - G.AKTS_Globals.redMaxChips)
                G.AKTS_Globals.redMaxChips = returnChips
            end
		end

        if context.setting_blind and context.main_eval and G.GAME.blind then
            card.ability.extra.targetHands = G.GAME.round_resets.hands
        end
        if context.selling_self and not context.blueprint then
            PerformFastRedeploy("j_akts_ProjektRed", card)
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'Mudrock', 
    name = 'Mudrock',
    rarity = 2,
    atlas = 'Jokers',
	cost = 10,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = false, 
    pos = {x = 8, y = 0}, 
    config = { 
      extra = {
        stoneCardRank = 0,
        stoneCardRankName = "0",
        stoneTransformReq = 7,
        stoneTransformCount = 0,
        tagClass = {"Defender"},
        tagFaction = {"Rhodes"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        return {vars = {center.ability.extra.stoneCardRankName, center.ability.extra.stoneTransformReq, center.ability.extra.stoneTransformCount}}
    end,
    calculate = function(self,card,context)
        if context.hand_drawn then
            card.ability.extra.stoneTransformCount = card.ability.extra.stoneTransformCount + 1
            if card.ability.extra.stoneTransformCount >= card.ability.extra.stoneTransformReq then
                card.ability.extra.stoneTransformCount = 0
                local lowestRank = 10000
                local lowestRankIndex = 0
                for i, cards in pairs(G.hand.cards) do
                    if cards:get_id() > 0 and cards:get_id() < lowestRank then
                        lowestRank = cards:get_id()
                        lowestRankIndex = i
                    end
                end
                if lowestRankIndex ~= 0 then
                    G.E_MANAGER:add_event(Event({
                        trigger = "after", 
                        delay = 0.25,
                        func = function() 
                            G.hand.cards[lowestRankIndex]:set_ability(G.P_CENTERS.m_stone, nil, true)
                            G.hand.cards[lowestRankIndex]:juice_up()
                            return true
                        end
                    }))
                end
            end

            local ranks = {}
            for i, cards in pairs(G.hand.cards) do
                local rank = cards:get_id()
                if rank > 0 and cards.config.center ~= G.P_CENTERS.m_stone then
                    ranks[rank] = (ranks[rank] or 0) + 1
                end   
            end

            local commonRank = 0
            local highestCount = 0
            for index, count in pairs(ranks) do
                if count > highestCount then
                    commonRank = index
                    highestCount = count
                elseif count == highestCount and index > commonRank then
                    commonRank = index
                end
            end

            card.ability.extra.stoneCardRank = commonRank
            card.ability.extra.stoneCardRankName = GetRankName(commonRank)
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'Civilight',
    name = 'Civilight',
    rarity = 3,
    atlas = 'Jokers',
	cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    pos = {x = 9, y = 0},
    config = {
      extra = {
        targetSeal = "Red",
        sealAdds = 3,
        rankBalance = 1,
        ranks = {},
        balancePercentage = 15,
        tagClass = {"Supporter"},
        tagFaction = {"Rhodes"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {key = string.lower(center.ability.extra.targetSeal) ..'_seal', set = 'Other'}
        return {vars = {center.ability.extra.sealAdds, center.ability.extra.rankBalance, center.ability.extra.balancePercentage}}
    end,

    add_to_deck = function(self, card, from_debuff)
        for i = 1, 3, 1 do
            local newCard = SMODS.add_card{set = 'Base', area = G.deck, no_edition = true, seal = card.ability.extra.targetSeal}
            playing_card_joker_effects({newCard})
        end
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand and context.before then
            G.AKTS_Globals.CERanks = {}
        end

       if context.individual and not context.end_of_round and context.cardarea == G.play and not context.other_card.debuff and context.other_card.seal == card.ability.extra.targetSeal then
        local avgRank = 0
        local ranks = G.AKTS_Globals.CERanks
        if #ranks == 0 then
            for i = 1, #context.scoring_hand do
                local id = context.scoring_hand[i]:get_id()
                if id > 0 then
                    table.insert(ranks, id)
                    avgRank = avgRank + ranks[#ranks]
                end
            end
        else
            for i = 1, #ranks do
                avgRank = avgRank + ranks[i]
            end
        end
        avgRank = round_number(avgRank/#context.scoring_hand, 0)
        local index = 0
        for i = 1, #context.scoring_hand do
            local id = context.scoring_hand[i]:get_id()
            if id > 0 then
                index = index + 1
                if ranks[index] < avgRank then
                    local change = math.min(avgRank - ranks[index], card.ability.extra.rankBalance)
                    ranks[index] = ranks[index] + change
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.modify_rank(context.scoring_hand[i], change)
                            context.scoring_hand[i]:juice_up()
                            return true
                        end)
                    }))
                elseif ranks[index] > avgRank then
                    local change = -math.min(ranks[index] - avgRank, card.ability.extra.rankBalance)
                    ranks[index] = ranks[index] + change
                    G.E_MANAGER:add_event(Event({
                        func = (function ()
                            SMODS.modify_rank(context.scoring_hand[i], change)
                            context.scoring_hand[i]:juice_up()
                            return true
                        end)
                    }))
                end
            end
        end

        local change = (math.abs(hand_chips - mult) / 2) * (0.01 * card.ability.extra.balancePercentage)
        if hand_chips > mult then
            hand_chips = mod_chips(hand_chips - change)
            mult = mod_mult(mult + change)
        else
            hand_chips = mod_chips(hand_chips + change)
            mult = mod_mult(mult - change)
        end
        return {
            card = card,
            message = localize("akts_CE_Balance"),
            colour = G.C.PURPLE
        }
       end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}
----------------------------------------Base Rhodes end----------------------------------------
SMODS.Joker{
    key = 'Logos',
    name = 'Logos',
    rarity = 3,
    atlas = 'Jokers',
	cost = 7,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    pos = {x = 0, y = 1}, 
    config = { 
      extra = {
        playedRankMult = 5,
        playedRank = {false, false, false, false, false, false, false, false, false, false, false, false, false},
        playedRankPlus = 0,
        handReduction = 1,
        handInc = 1,
        handRedReqCt = 6,
        handRedReqCtr = 0,
        curHandSize = 1,
        perishFlagA = false,
        akts_save = false,
        tagClass = {"Caster"},
        tagFaction = {"EliteOp", "Rhodes"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.playedRankPlus, center.ability.extra.handReduction, center.ability.extra.handRedReqCt, center.ability.extra.handRedReqCtr, logosHandSizeCalc(center.ability.extra), center.ability.extra.handInc, center.ability.extra.playedRankMult, center.ability.extra.playedRankPlus * center.ability.extra.playedRankMult}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.curHandSize)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.curHandSize)
    end,
    calculate = function(self,card,context)
        if not context.blueprint and context.cardarea == G.jokers and context.scoring_hand then
            if context.before then
                card.ability.extra.perishFlagA = false
                card.ability.extra.akts_save = false
                card.ability.extra.playedRankPlus = 0
                for i = 1, #context.scoring_hand do
                    card.ability.extra.playedRank[context.scoring_hand[i]:get_id() - 1] = true
                end
                for i, v in pairs(card.ability.extra.playedRank) do
                    if card.ability.extra.playedRank[i] then
                        card.ability.extra.playedRankPlus = card.ability.extra.playedRankPlus + 1
                    end
                end
                if card.ability.extra.playedRankPlus == #card.ability.extra.playedRank then
                    card.ability.extra.perishFlagA = true
                    card.ability.extra.akts_save = true
                end
            end
        end
        if not context.blueprint and context.hand_drawn then
            if card.ability.extra.playedRankPlus == #card.ability.extra.playedRank and G.GAME.chips/G.GAME.blind.chips < 1 and leftmostActivatedTrue("perishFlagA", getJokerSlot(card)) then
                end_round()
            end
        end
        if not context.blueprint and context.end_of_round then
            card.ability.extra.perishFlagA = false
            if G.GAME.chips/G.GAME.blind.chips < 1 and card.ability.extra.akts_save and leftmostActivatedTrue("akts_save", getJokerSlot(card)) then
                card.ability.extra.akts_save = false
                G.GAME.chips = G.GAME.blind.chips
                if card.ability.extra.handRedReqCtr >= card.ability.extra.handRedReqCt -1 then
                    G.hand:change_size(-1)
                    card.ability.extra.handRedReqCtr = 0
                    card.ability.extra.curHandSize = card.ability.extra.curHandSize -1
                else
                    card.ability.extra.handRedReqCtr = card.ability.extra.handRedReqCtr + 1
                end
                G.STATE = G.STATES.HAND_PLAYED
                G.STATE_COMPLETE = true
                return {
                    saved = true,
                    message = localize('akts_logos_win'),
                    colour = G.C.PURPLE
                }
            end
            card.ability.extra.playedRank = {false, false, false, false, false, false, false, false, false, false, false, false, false}
            card.ability.extra.playedRankPlus = 0
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.playedRankPlus * card.ability.extra.playedRankMult,
				card = card
			}
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}

SMODS.Joker{
    key = 'Blaze', 
    name = 'Blaze',
    rarity = 2,
    atlas = 'Jokers',
	cost = 8,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    no_pool_flag = 'akts_blaze_transform',
    pos = {x = 1, y = 1}, 
    config = { 
      extra = {
        extraCardType = 'Hearts',
        extraCardsPlayed = 0,
        extraCardsReq = 15,
        bonusMult = 5,
        critBonusMult = 10,
        aktsSellValue = 4,
        sellValueLoss = 1,
        sellValueCond = 0,
        transformLink = "j_akts_BlazeAlter",
        tagClass = {"Guard"},
        tagFaction = {"EliteOp", "Rhodes"} -- , "Yan" ?
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.extraCardType, center.ability.extra.bonusMult, center.ability.extra.extraCardsReq, center.ability.extra.extraCardsPlayed, center.ability.extra.critBonusMult, center.ability.extra.sellValueLoss, center.ability.extra.sellValueCond}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and context.other_card:is_suit(card.ability.extra.extraCardType) then
            local returnMult = card.ability.extra.bonusMult
            if not context.blueprint then
                card.ability.extra.extraCardsPlayed = card.ability.extra.extraCardsPlayed + 1
                if card.ability.extra.extraCardsPlayed % card.ability.extra.extraCardsReq == 0 then
                    card.ability.extra.extraCardsPlayed = 0
                    returnMult = card.ability.extra.critBonusMult
                    if card.ability.extra.aktsSellValue > 0 then
                        card.ability.extra.aktsSellValue = card.ability.extra.aktsSellValue - 1
                        card:set_cost()
                    end
                end
            end
            return {
                mult = returnMult,
                card = card
            }
        end

        if context.end_of_round and card.ability.extra.aktsSellValue == 0 and not context.blueprint then
            G.GAME.pool_flags.akts_blaze_transform = true
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_transform"), G.C.ATTENTION})
            jokerTransform(card, card.ability.extra.transformLink)
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'BlazeAlter', 
    name = 'BlazeAlter',
    rarity = 'akts_Transformed',
    atlas = 'Jokers',
	cost = 10,
    unlocked = true, 
    discovered = false, 
    blueprint_compat = true, 
    pos = {x = 2, y = 1}, 
    config = { 
      extra = {
        extraCardType = 'Hearts',
        bonusMult = 10,
        burnMult = 15,
        aoEMain = {{},{},{},{}}, --aoEMain1 is the card, aoEMain2 is Burn Damage, aoEMain3 is Mult and aoEMain4 is the current mode for the return. (burn or mult)
        aoEEfficacy = 0.5,
        baseAoE = {-1, 1},
        rankBurnEfficacy = 0.5, 
        akts_burn_burst = true,
        tagClass = {"Caster", "Guard"},
        tagFaction = {"EliteOp", "Rhodes"} -- , "Yan"?
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "AoEHit"}
        info_queue[#info_queue+1] = {set = 'Other', key = "elementalInjury"}
        info_queue[#info_queue+1] = {set = 'Other', key = "burnBurst"}
        return {vars = {center.ability.extra.extraCardType, center.ability.extra.bonusMult, center.ability.extra.burnMult, elemBurstText('Burn')}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_blaze_transform = true
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_blaze_transform = false
    end,
    calculate = function(self,card,context)
        --Find AoE Targets and set them up.
        if not context.blueprint and context.cardarea == G.jokers and context.scoring_hand then
            if context.before then                
                card.ability.extra.aoEMain = {{nil,nil,nil,nil,nil},{0,0,0,0,0},{0,0,0,0,0}, {'Burn'}}
                for i, v in pairs(context.full_hand) do
                    --check for hearts and apply AoE to adjacent cards
                    if v:is_suit(card.ability.extra.extraCardType) then
                        for j, w in pairs(card.ability.extra.baseAoE) do
                            --check for cards to the left and right of hearts.
                            if context.full_hand[i + w] then
                                card.ability.extra.aoEMain[1][i + w] = context.full_hand[i + w]
                                card.ability.extra.aoEMain[2][i + w] = card.ability.extra.aoEMain[2][i + w] + (card.ability.extra.aoEEfficacy * context.full_hand[i + w]:get_id())
                                card.ability.extra.aoEMain[3][i + w] = card.ability.extra.aoEMain[3][i + w] + (card.ability.extra.aoEEfficacy * card.ability.extra.burnMult)
                            end
                        end
                    end
                end
            end
        end

        --Apply AoE/Burn/Mult
        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round then
            local returnMult = 0
            if G.AKTS_Globals.burnBurstApplied then
                if context.other_card:is_suit(card.ability.extra.extraCardType) then
                    returnMult = returnMult + card.ability.extra.burnMult
                end
                for i, v in pairs(card.ability.extra.aoEMain[1]) do
                    if v == context.other_card then
                        returnMult = returnMult + card.ability.extra.aoEMain[3][i]
                        break
                    end
                end
            else
                local addedElemInj = 0
                if context.other_card:is_suit(card.ability.extra.extraCardType) then
                    returnMult = returnMult + card.ability.extra.bonusMult
                    addedElemInj = addedElemInj + context.other_card:get_id()
                end
                for i, v in pairs(card.ability.extra.aoEMain[1]) do
                    if v == context.other_card then
                        addedElemInj = addedElemInj + card.ability.extra.aoEMain[2][i]
                        break
                    end
                end
                calculateElemInjury(card, 'Burn', addedElemInj)
                if addedElemInj + returnMult > 0 then
                    return {
                        mult = returnMult,
                        card = context.other_card,
                        message = '' .. elemBurstChangeText(addedElemInj),
                    }  
                end
            end
            if returnMult > 0 then
                return {
                    mult = returnMult,
                    card = card
                }
            end
        end

        --Burn Burst Effects (Mult on Joker).
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

--Fix "AoE" Message to only appear if there are any AoE targets.
SMODS.Joker{
    key = 'Rosmontis', 
    name = 'Rosmontis',
    rarity = 2,
    atlas = 'Jokers',
	cost = 8,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = false, 
    pos = {x = 3, y = 1}, 
    config = { 
      extra = {
        FirstHandReq = 2,
        enhanceTarget = "Stone Card",
        enhanceChipIncrease = 10,
        handGain = 1,
        aoEMain = {{},{}}, --aoEMain1 is the card, aoEMain2 is chips
        aoEEfficacy = 1,
        baseAoE = {-1, 1},
        tagClass = {"Sniper"},
        tagFaction = {"EliteOp", "Rhodes"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        info_queue[#info_queue+1] = {set = 'Other', key = "AoEHit"}
        return {vars = {center.ability.extra.FirstHandReq, center.ability.extra.enhanceChipIncrease, center.ability.extra.handGain}}
    end,
    calculate = function(self,card,context)
        --upgrade Stones and gain hand
        if context.cardarea == G.jokers then
            if context.before then
                if G.GAME.current_round.hands_played == 0 then
                    local numStones = {0}
                    for i = 1, #context.full_hand do
                        if context.full_hand[i].ability.effect == card.ability.extra.enhanceTarget then 
                            numStones[1] = numStones[1] + 1
                            table.insert(numStones, context.full_hand[i]) 
                        end
                    end
                    if numStones[1] == card.ability.extra.FirstHandReq then
                        for i = 1, numStones[1] do
                            numStones[i+1].ability.bonus = numStones[i+1].ability.bonus + card.ability.extra.enhanceChipIncrease
                            numStones[i+1]:juice_up()
                            card_eval_status_text(numStones[i+1], 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), G.C.ATTENTION})
                        end
                        ease_hands_played(card.ability.extra.handGain)
                    end
                end

                --AoE
                card.ability.extra.aoEMain = {{nil,nil,nil,nil,nil},{0,0,0,0,0}}
                for i, v in pairs(context.full_hand) do
                    --check for Stone and apply AoE to adjacent cards
                    if v.ability.effect == card.ability.extra.enhanceTarget then
                        for j, w in pairs(card.ability.extra.baseAoE) do
                            --check for cards to the left and right of Stone.
                            if context.full_hand[i + w] then
                                card.ability.extra.aoEMain[1][i + w] = context.full_hand[i + w]
                                card.ability.extra.aoEMain[2][i + w] = card.ability.extra.aoEMain[2][i + w] + (card.ability.extra.aoEEfficacy * v.ability.bonus)
                            end
                        end
                    end
                end
                if #card.ability.extra.aoEMain[1] > 0 then
                    for i, v in pairs(card.ability.extra.aoEMain[1]) do
                        v:juice_up()
                    end
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_AoE"), G.C.ATTENTION})
                end
            end
        end

        --Apply AoE
        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round then
            local returnChip = 0
            for i, v in pairs(card.ability.extra.aoEMain[1]) do
                if v == context.other_card then
                    returnChip = returnChip + card.ability.extra.aoEMain[2][i]
                    break
                end
            end
            if returnChip > 0 then
                return {
                    chips = returnChip,
                    card = context.other_card,
                }  
            end
        end
    end,
    set_badges = function(self, card, badges)
      aktsBadgeHelper(self,card,badges)
    end    
}
----------------------------------------Elite Op end----------------------------------------