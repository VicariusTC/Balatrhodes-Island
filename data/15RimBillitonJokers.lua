SMODS.Joker{
    key = 'Cement',
    name = 'Cement',
    rarity = 1,
    atlas = 'Jokers',
	cost = 5,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 0, y = 3}, 
    config = { 
      extra = {
        bonusChips = 200,
        bonusChipsMax = 200,
        bonusChipLoss = 20,
        bonusChipFactor = 2,
        bonusChipFactorIncreaseTimer = 5,
        factorApplied = false,
        tagClass = {"Defender"},
        tagFaction = {"RimBil"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.bonusChips, center.ability.extra.bonusChipLoss, center.ability.extra.bonusChipFactorIncreaseTimer}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and card.ability.extra.bonusChips > 0 then
            card.ability.extra.bonusChips = card.ability.extra.bonusChips - card.ability.extra.bonusChipLoss
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_downgrade'), G.C.ATTENTION})
        end
        
        if context.joker_main then
            return {
					chips = card.ability.extra.bonusChips,
					card = card
			}
		end
        
        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.bonusChips = card.ability.extra.bonusChipsMax
            if card.ability.extra.bonusChipFactorIncreaseTimer > 0 then
                card.ability.extra.bonusChipFactorIncreaseTimer = card.ability.extra.bonusChipFactorIncreaseTimer - 1
            elseif not card.ability.extra.factorApplied then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), G.C.ATTENTION})
                card.ability.extra.factorApplied = true
                card.ability.extra.bonusChips = card.ability.extra.bonusChipFactor * card.ability.extra.bonusChips
                card.ability.extra.bonusChipsMax = card.ability.extra.bonusChipFactor * card.ability.extra.bonusChipsMax
                card.ability.extra.bonusChipLoss = card.ability.extra.bonusChipFactor * card.ability.extra.bonusChipLoss
            end
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}

SMODS.Joker{
    key = 'Warmy',
    name = 'Warmy',
    rarity = 2,
    atlas = 'Jokers',
	cost = 4,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 1, y = 3}, 
    config = { 
      extra = {
        akts_burn_burst = true,
        burnBurstMultiplier = 2,
        burnBurstTriggeredThisRound = true,
        burnBurstTriggeredLastRound = true,
        regularElemDamage = 25,
        boostElemDamage = 35,
        elemBurstXMult = 2.2,
        tagClass = {"Caster"},
        tagFaction = {"RimBil"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "elementalInjury"}
        info_queue[#info_queue+1] = {set = 'Other', key = "burnBurst"}
        return {vars = {center.ability.extra.regularElemDamage, center.ability.extra.boostElemDamage, center.ability.extra.elemBurstXMult, elemBurstText('Burn')}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.AKTS_Globals.burnBurstFactor = card.ability.extra.burnBurstMultiplier
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            trigger = "after", 
            delay = 0.25,
            func = function() 
                if #calcTaggedOwnedTitle("burnBurstMultiplier") == 0 then
                    G.AKTS_Globals.burnBurstFactor = 1
                end
                return true
            end
        }))
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            if not G.AKTS_Globals.burnBurstApplied then
                local addedElemInj = card.ability.extra.regularElemDamage
                if not card.ability.extra.burnBurstTriggeredLastRound then
                    addedElemInj = card.ability.extra.boostElemDamage
                end
                calculateElemInjury(card, 'Burn', addedElemInj)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = elemBurstChangeText(addedElemInj), G.C.ATTENTION})
            end
            
            if G.AKTS_Globals.burnBurstApplied then
                return {
                    Xmult_mod = card.ability.extra.elemBurstXMult,
                    message = "X" .. card.ability.extra.elemBurstXMult,
                    colour = G.C.MULT,
                    delay = 0.5,
                }
            end
        end

        if context.cardarea == G.jokers and context.scoring_hand and context.final_scoring_step then
            card.ability.extra.burnBurstTriggeredThisRound = G.AKTS_Globals.burnBurstApplied
        end

        if context.end_of_round then
            card.ability.extra.burnBurstTriggeredLastRound = card.ability.extra.burnBurstTriggeredThisRound
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