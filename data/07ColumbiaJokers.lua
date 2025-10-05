SMODS.Joker{
    key = 'Surfer', 
    name = 'Surfer',
    rarity = 1,
    atlas = 'Jokers',
	cost = 4,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 0, y = 5},
    config = { 
      extra = {
        fastRedeployFlag = true,
        bonusMoney = 2,
        bonusMoneyLessThanCondition = 4,
        blindCut = 2,
        tagClass = {"Vanguard"},
        tagFaction = {"Blacksteel", "Columbia"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "FastRedeploy"}
        return {vars = {center.ability.extra.bonusMoney, center.ability.extra.bonusMoneyLessThanCondition, center.ability.extra.blindCut}}
    end,
    add_to_deck = function(self, card, from_debuff)
        if #(G.jokers and G.jokers.cards) < card.ability.extra.bonusMoneyLessThanCondition +1 then
            ease_dollars(card.ability.extra.bonusMoney)
        end
    end, 
    calculate = function(self,card,context)
        if context.joker_main then
            local blindCutMultiplier = G.GAME.current_round.hands_played
            local totalCut = blindCutMultiplier * card.ability.extra.blindCut
            G.GAME.blind.chips = G.GAME.blind.chips * (1 - (totalCut * 0.01))
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_surfer_score"), G.C.ATTENTION})
		end

        if context.selling_self and not context.blueprint then
            PerformFastRedeploy("j_akts_Surfer", card)
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}