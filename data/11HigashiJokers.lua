SMODS.Joker{
    key = 'Utage',
    name = 'Utage',
    rarity = 2,
    atlas = 'Jokers', 
	cost = 6,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    eternal_compat = true, 
    perishable_compat = true, 
    pos = {x = 0, y = 12},
    config = { 
      extra = {
        aktsSellValue = 3,
        actualSellValue = 1,
        aktsCostValue = 6,
        bonusMultMultiplier = 8,
        tagClass = {"Guard"},
        tagFaction = {"Higashi"}
      }
    },
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.aktsCostValue = math.max(card.cost, card.ability.extra.aktsCostValue)
    end,
    
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.actualSellValue, center.ability.extra.bonusMultMultiplier, center.ability.extra.bonusMultMultiplier * CalcOwnedMissingSellValue()}}
    end,
    calculate = function(self,card,context)
        if context.setting_blind and context.main_eval then
            card.ability.extra.aktsSellValue = card.ability.extra.actualSellValue
            if G.GAME.blind and card.sell_cost > card.ability.extra.aktsSellValue then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_hp_down'), colour = G.C.MULT})
                ease_dollars(card.sell_cost - card.ability.extra.aktsSellValue)
                card:set_cost()
            end
        end

        if context.joker_main and CalcOwnedMissingSellValue() > 0 then
            return {
                mult = card.ability.extra.bonusMultMultiplier * CalcOwnedMissingSellValue(),
                card = card
            }
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end 
}