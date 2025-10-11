SMODS.Joker{
    key = 'Spuria', 
    name = 'Spuria',
    rarity = 2,
    atlas = 'Jokers', 
	cost = 5,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true, 
    pos = {x = 0, y = 11},
    config = { 
      extra = {
        debuffChance = 4,
        minusHandChance = 10,
        minusHandCount = 1,
        aktsSellValue = 3,
        aktsCostValue = 6,
        subClass = "Geek",
        targetClass = "Sniper",
        tagClass = {"Specialist"},
        tagFaction = {"Laterano"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = center.ability.extra.subClass}
        return {vars = {#CalcTaggedOwned(center.ability.extra.targetClass), center.ability.extra.debuffChance, center.ability.extra.minusHandCount, center.ability.extra.minusHandChance, G.GAME.probabilities.normal}}
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.aktsCostValue = math.max(card.cost, card.ability.extra.aktsCostValue)
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.repetition then     
            return {
                message = localize('k_again_ex'),
                repetitions = 1 + #CalcTaggedOwned(card.ability.extra.targetClass),
                card = card
            }
        end

        -- Debuff when played
        if context.cardarea == G.jokers and context.scoring_hand and context.before then
            if not context.blueprint then
                setGeekDebuff(card)
            end
            if not card.debuff then
                for i = 1, #context.scoring_hand do
                    if pseudorandom('debuffCheck') < G.GAME.probabilities.normal/card.ability.extra.debuffChance then
                        context.scoring_hand[i]:set_debuff(true)
                    end
                end   
            end
        end
        -- Minus Hand
        if context.cardarea == G.play and context.individual and not context.other_card.debuff and G.GAME.current_round.hands_left > 0 then
            if pseudorandom('minusCheck') < G.GAME.probabilities.normal/card.ability.extra.minusHandChance then
                ease_hands_played(- card.ability.extra.minusHandCount)
            end
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end 
}

SMODS.Joker{
    key = 'Lemuen', 
    name = 'Lemuen',
    rarity = 3,
    atlas = 'Jokers', 
	cost = 7,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true, 
    pos = {x = 1, y = 11},
    config = { 
      extra = {
        targetLevel = 3,
        ammoCount = 5,
        handCount = 1,
        numRetriggers = 0,
        retriggerTarget = 1,
        planetCopies = 3,
        twiceRetriggerOrder = 8,
        thriceRetriggerOrder = 4,
        aktsSettingPrice = false,
        aktsNewSellPrice = 0,
        tagClass = {"Sniper"},
        tagFaction = {"Laterano"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.ammoCount, center.ability.extra.targetLevel, center.ability.extra.planetCopies, center.ability.extra.aktsNewSellPrice}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before then
                local currentHandLevel = getCurrentHandLevel(context)
                local currentHand = getCurrentHandName(context)
                if currentHand and currentHandLevel >= card.ability.extra.targetLevel and card.ability.extra.ammoCount > 0 then
                    local retriggerFactor = 1  
                    if currentHand.order <= card.ability.extra.thriceRetriggerOrder then
                        retriggerFactor = 3
                    elseif currentHand.order <= card.ability.extra.twiceRetriggerOrder then
                        retriggerFactor = 2
                    end
                    card.ability.extra.numRetriggers = currentHandLevel * retriggerFactor
                    if context.scoring_name then
                        --level down hand after hand finishes
                        local curChip = G.GAME.chips
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                if G.GAME.chips == curChip then
                                    return false
                                end
                                local targetCard = context.scoring_hand[card.ability.extra.retriggerTarget]
                                aktsDestroy(targetCard)
                                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(context.scoring_name, 'poker_hands'),chips = G.GAME.hands[context.scoring_name].chips, mult = G.GAME.hands[context.scoring_name].mult, level=G.GAME.hands[context.scoring_name].level})
                                local newCurrentHandLevel = getCurrentHandLevel(context)
                                level_up_hand(card, context.scoring_name, nil, -newCurrentHandLevel +1)
                                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
                                --Activate Custom Sell Price Mode
                                card.ability.extra.aktsSettingPrice = true
                                local _card = create_card("Planet", G.consumeables)
                                _card:set_edition({negative = true}, true)
                                _card:add_to_deck()
                                G.consumeables:emplace(_card)
                                for i = 1, card.ability.extra.planetCopies - 1, 1 do
                                    local copyCard = copy_card(_card, nil)
                                    copyCard:add_to_deck()
                                    G.consumeables:emplace(copyCard)
                                end
                                --Disable Custom Sell Price Mode
                                card.ability.extra.aktsSettingPrice = false
                                return true
                            end,
                            blocking = false
                        }))
                        handleAmmo(card)
                    end
                end
            end
        end
        
        if context.cardarea == G.play and context.repetition and card.ability.extra.numRetriggers > 0 and (context.other_card == context.scoring_hand[card.ability.extra.retriggerTarget]) then
            local requiredRetriggers = card.ability.extra.numRetriggers
            card.ability.extra.numRetriggers = 0
            return {
                message = localize('k_again_ex'),
                repetitions = requiredRetriggers,
                card = card
            }
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end 
}

SMODS.Joker{
    key = 'Fiametta', 
    name = 'Fiametta',
    rarity = 1,
    atlas = 'Jokers', 
	cost = 6,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true, 
    pos = {x = 2, y = 11},
    config = { 
      extra = {
        subClass = "Geek",
        aktsSellValue = 4,
        aktsCostValue = 8,
        centerMult = 1.3,
        aoEMain = {},
        baseAoE = {-1, 1},
        aoEEfficacy = {50, 50},
        vigorThreshold = 3,
        tagClass = {"Sniper"},
        tagFaction = {"Laterano"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = center.ability.extra.subClass}
        info_queue[#info_queue+1] = {set = 'Other', key = "AoEHit"}
        return {vars = {center.ability.extra.centerMult, center.ability.extra.vigorThreshold}}
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.aktsCostValue = math.max(card.cost, card.ability.extra.aktsCostValue)
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before then
                if card.ability.extra.aktsSellValue > 0 then
                    card.ability.extra.aoEMain = {}
                    local centerPlayed = context.scoring_hand[math.floor((#context.scoring_hand/2) +0.5)]
                    card.ability.extra.aoEMain = createAoETable(centerPlayed, context.scoring_hand, card.ability.extra.baseAoE, card.ability.extra.aoEEfficacy)
                    if card.ability.extra.aoEMain and card.ability.extra.aoEMain[1] then
                        --Add centercard to aoeTable with efficacy at 100%
                        table.insert(card.ability.extra.aoEMain[1], centerPlayed)
                        table.insert(card.ability.extra.aoEMain[2], 100)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_AoE')})
                        for i, v in pairs(card.ability.extra.aoEMain[1]) do
                            v:juice_up()
                        end
                    end
                end
                if not context.blueprint then
                    setGeekDebuff(card)
                end
            end
        end

        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and card.ability.extra.aoEMain and card.ability.extra.aoEMain[1] then
            for i, v in pairs(card.ability.extra.aoEMain[1]) do
                if context.other_card == v then
                    local efficacyFactor = (0.01 * card.ability.extra.aoEMain[2][i])
                    local returnMult = ((card.ability.extra.centerMult -1) * efficacyFactor)
                    if card.ability.extra.aktsSellValue >= card.ability.extra.vigorThreshold then
                        returnMult = 2* returnMult
                    end
                    return {
                        xmult = 1+ returnMult,
                        card = other_card
                    }
                end
            end
        end

        if context.end_of_round then
            card.ability.extra.aoEMain = {}
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end 
}