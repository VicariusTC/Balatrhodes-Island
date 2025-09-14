SMODS.Joker{
    key = 'Phantom',
    name = 'Phantom',
    rarity = 2,
    atlas = 'Jokers',
	cost = 3,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 0, y = 9}, 
    config = { 
      extra = {
        fastRedeployFlag = true,
        maxClonesOwned = 1,
        bonusChipXMin = 1.25,
        bonusChipXMax = 2,
        summonTarget = "c_akts_Clone",
        isFirstHandOrClone = true,
        tagClass = {"Specialist"},
        tagFaction = {"Victoria"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "FastRedeploy"}
        info_queue[#info_queue+1] = G.P_CENTERS.c_akts_Clone
        return {vars = {center.ability.extra.maxClonesOwned, center.ability.extra.bonusChipXMin, center.ability.extra.bonusChipXMax}}
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and #CalcNamedConsumableOwned(card.ability.extra.summonTarget) < 1 then
            local _card = create_card('SummonConsumableType', G.consumeables, nil, nil, nil, nil, card.ability.extra.summonTarget)
            _card:add_to_deck()
            G.consumeables:emplace(_card)
            card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('akts_plus_summon'), colour = G.C.PURPLE})
        end
    end,
    calculate = function(self,card,context)
        if context.using_consumeable and context.consumeable.ability.name == 'Death' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and #CalcNamedConsumableOwned(card.ability.extra.summonTarget) < 1 then
            local _card = create_card('SummonConsumableType', G.consumeables, nil, nil, nil, nil, card.ability.extra.summonTarget)
            _card:add_to_deck()
            G.consumeables:emplace(_card)
            card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('akts_plus_summon'), colour = G.C.PURPLE})
        end

        if context.using_consumeable and context.consumeable.ability.name == card.ability.extra.summonTarget then
            card.ability.extra.isFirstHandOrClone = true
        end


        if context.joker_main and card.ability.extra.isFirstHandOrClone then
            local returnChips = math.random(100* card.ability.extra.bonusChipXMin, 100* card.ability.extra.bonusChipXMax) /100    
            card.ability.extra.isFirstHandOrClone = false
            return {
                xchips = returnChips
            }
		end

        if context.selling_self and not context.blueprint then
            PerformFastRedeploy("j_akts_Phantom", card)
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'Goldenglow',
    name = 'Goldenglow',
    rarity = 1,
    atlas = 'Jokers',
	cost = 6,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 1, y = 9}, 
    config = { 
      extra = {
        explosionChance = 10,
        explosionMultiplier = 3,
        tagClass = {"Caster"},
        tagFaction = {"Victoria"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {G.GAME.probabilities.normal, center.ability.extra.explosionChance, center.ability.extra.explosionMultiplier}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.hand and context.individual and not context.other_card.debuff and not context.end_of_round then
            if math.random() <= G.GAME.probabilities.normal/card.ability.extra.explosionChance then
                SMODS.destroy_cards(context.other_card)
                return {
                    chips = card.ability.extra.explosionMultiplier * context.other_card:get_id(),
                    card = context.other_card
                }
            end
            return {
                chips = context.other_card:get_id(),
                card = context.other_card
            }
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}