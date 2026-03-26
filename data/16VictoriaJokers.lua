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
            local returnChips = math.max(context.other_card:get_id(), 0)
            if math.random() <= G.GAME.probabilities.normal/card.ability.extra.explosionChance and returnChips > 0 then
                SMODS.destroy_cards(context.other_card)
                returnChips = card.ability.extra.explosionMultiplier * returnChips
            end
            return {
                chips = returnChips,
                card = context.other_card
            }
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}

SMODS.Joker{
    key = 'Saileach',
    name = 'Saileach',
    rarity = 2,
    atlas = 'Jokers',
	cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 2, y = 9},
    config = { 
      extra = {
        bannerActive = false,
        bannerActiveTriggers = 0,
        bannerActiveCap = 100,
        triggerCash = 0.5,
        triggerChips = 20,
        tagClass = {"Vanguard"},
        tagFaction = {"Victoria"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_banner
        return {vars = {center.ability.extra.triggerCash, center.ability.extra.triggerChips}}
    end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.add_card({set ='Joker', key = 'j_banner', edition={negative = true}, stickers={"eternal"}, force_stickers=true})
    end,
    remove_from_deck = function(self, card, from_debuff)
        local banners = SMODS.find_card('j_banner', true)
        for _, joker in pairs(banners) do
            if joker.edition.negative and joker.ability.eternal then
                joker:set_eternal(false)
                SMODS.destroy_cards(joker)
                return
            end
        end
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand and context.before and G.GAME.current_round.discards_left == 0 then
            local banners = SMODS.find_card('j_banner', false)
            if banners and #banners > 0 and banners[1] ~= nil then
                SMODS.debuff_card(banners[1], true, 'AKTS_Saileach_debuff')
                banners[1]:juice_up()
                card_eval_status_text(banners[1], 'extra', nil, nil, nil, {message = localize('akts_saileach_banner'), colour = G.C.RED})
                card.ability.extra.bannerActive = true
            end
        end

        if context.end_of_round and context.beat_boss then
            local banners = SMODS.find_card('j_banner', true)
            for _, joker in pairs(banners) do
                SMODS.debuff_card(joker, false, 'AKTS_Saileach_debuff')
            end
        end

        if not context.blueprint and card.ability.extra.bannerActive
         and ((context.post_trigger and context.other_card ~= card)
         or (context.cardarea == G.play and context.individual and not context.other_card.debuff)) 
         and card.ability.extra.bannerActiveTriggers < card.ability.extra.bannerActiveCap then
            card.ability.extra.bannerActiveTriggers = card.ability.extra.bannerActiveTriggers + 1
            return {
                chips = card.ability.extra.triggerChips,
                dollars = card.ability.extra.triggerCash,
                card = card
            }
        end

        if context.after and card.ability.extra.bannerActive then
            card.ability.extra.bannerActive = false
            card.ability.extra.bannerActiveTriggers = 0
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}