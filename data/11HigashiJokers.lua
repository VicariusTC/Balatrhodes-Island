SMODS.Joker{
    key = 'Utage',
    name = 'Utage',
    rarity = 2,
    atlas = 'Jokers', 
	cost = 6,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
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

SMODS.Joker{
    key = 'Kichisei',
    name = 'Kichisei',
    rarity = 1,
    atlas = 'Jokers',
	cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    pos = {x = 1, y = 12},
    config = { 
      extra = {
        bonusChips = 60,
        typesPlayed = {},
        tagClass = {"Sniper"},
        tagFaction = {"Higashi"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.bonusChips, center.ability.extra.bonusChips * #center.ability.extra.typesPlayed}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand and not context.blueprint and #card.ability.extra.typesPlayed < 4 then
            if context.before and next(context.poker_hands['Flush']) then
                local flushType = nil
                for i = 1, #context.scoring_hand do
                    if not SMODS.has_any_suit(context.scoring_hand[i]) then 
                        flushType = context.scoring_hand[i].base.suit
                        break
                    end
                end
                if flushType then
                    local duplicate = false
                    for index, value in ipairs(card.ability.extra.typesPlayed) do
                        if value == flushType then
                            duplicate = true
                            break
                        end
                    end
                    if not duplicate then
                        table.insert(card.ability.extra.typesPlayed, flushType)
                    end
                else
                    card.ability.extra.typesPlayed = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
                end
            end
        end
        if context.joker_main then
            return {
				chips = card.ability.extra.bonusChips * #card.ability.extra.typesPlayed,
				card = card
			}
        end
        if context.end_of_round then
            card.ability.extra.typesPlayed = {}
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}