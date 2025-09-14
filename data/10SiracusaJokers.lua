SMODS.Joker{
    key = 'Provence', 
    name = 'Provence',
    rarity = 2,
    atlas = 'Jokers',
	cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 13},
    config = { 
      extra = {
        bonusChips = 40,
        bonusChipsInterval = 20,
        bonusChanceMultiplier = 2,
        bonusChanceDivisorRegular = 5,
        bonusChanceDivisorEnhanced = 2,
        bonusChanceCondition = 3,
        bonusChanceConditionTypes = {"Sniper", "Siracusa"},
        tagClass = {"Sniper"},
        tagFaction = {"Siracusa"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.bonusChips, center.ability.extra.bonusChipsInterval, G.GAME.probabilities.normal, center.ability.extra.bonusChanceDivisorRegular, center.ability.extra.bonusChanceDivisorEnhanced, center.ability.extra.bonusChanceCondition, center.ability.extra.bonusChanceConditionTypes[1], center.ability.extra.bonusChanceConditionTypes[2]}}
    end,
    calculate = function(self,card,context)
      if context.cardarea == G.jokers and context.joker_main then
            if G.GAME.blind then
              local currentChips =  ((hand_chips * mult) + G.GAME.chips)/G.GAME.blind.chips
              local hitIntervals = 0
              local snipersOwned = calcTaggedOwned(card.ability.extra.bonusChanceConditionTypes[1])
              local siracusaOwned = calcTaggedOwned(card.ability.extra.bonusChanceConditionTypes[2], snipersOwned)
              while currentChips > 0 do
                hitIntervals = hitIntervals + 1
                currentChips = currentChips - (0.01 * card.ability.extra.bonusChipsInterval)
              end
              local bonusChips = hitIntervals * card.ability.extra.bonusChips
              local bonusChance = false
              if #siracusaOwned + #snipersOwned >= card.ability.extra.bonusChanceCondition then
                bonusChance = pseudorandom('doubleUp') < G.GAME.probabilities.normal/card.ability.extra.bonusChanceDivisorEnhanced
              else
                bonusChance = pseudorandom('doubleUp') < G.GAME.probabilities.normal/card.ability.extra.bonusChanceDivisorRegular
              end
              if bonusChance then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_crit')})
                return {
                  card = card,
                  chips = card.ability.extra.bonusChanceMultiplier * bonusChips
                }
              end
              return {
                card = card,
                chips = bonusChips
              }
            end
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}