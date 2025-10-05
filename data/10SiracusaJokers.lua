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
          local snipersOwned = CalcTaggedOwned(card.ability.extra.bonusChanceConditionTypes[1])
          local siracusaOwned = CalcTaggedOwned(card.ability.extra.bonusChanceConditionTypes[2], snipersOwned)
          local bonusChips = math.floor(currentChips / (0.01 * card.ability.extra.bonusChipsInterval)) * card.ability.extra.bonusChips
          local bonusChance = false
          if #siracusaOwned + #snipersOwned >= card.ability.extra.bonusChanceCondition then
              bonusChance = pseudorandom('doubleUp') < G.GAME.probabilities.normal/card.ability.extra.bonusChanceDivisorEnhanced
          else
            bonusChance = pseudorandom('doubleUp') < G.GAME.probabilities.normal/card.ability.extra.bonusChanceDivisorRegular
          end
          if bonusChance then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_crit')})
            bonusChips = card.ability.extra.bonusChanceMultiplier * bonusChips
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

SMODS.Joker{
    key = 'Vulpisfoglia',
    name = 'Vulpisfoglia',
    rarity = 1,
    atlas = 'Jokers',
	cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 13},
    config = { 
      extra = {
        interestBonus = 0.5,
        interestReq = 5,
        nextScoredCount = 5,
        scoredCountDefault = 5,
        bonusChips = 60,
        bonusMult = 20,
        bonusCash = 6,
        tagClass = {"Vanguard"},
        tagFaction = {"Siracusa"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.interestBonus, center.ability.extra.interestReq, center.ability.extra.nextScoredCount, center.ability.extra.bonusChips, center.ability.extra.bonusCash, center.ability.extra.bonusMult}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.interest_amount = G.GAME.interest_amount + (card.ability.extra.interestBonus * 5/card.ability.extra.interestReq)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.interest_amount = G.GAME.interest_amount - (card.ability.extra.interestBonus * 5/card.ability.extra.interestReq)
    end,
    calculate = function(self,card,context)
      if context.cardarea == G.jokers and context.joker_main then
        if #context.scoring_hand ~= card.ability.extra.nextScoredCount then
          return
        end
        if card.ability.extra.nextScoredCount == 1 then
          card.ability.extra.nextScoredCount = card.ability.extra.scoredCountDefault
          card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset')})
          return {
            card = card,
            chips = card.ability.extra.bonusChips,
            mult = card.ability.extra.bonusMult,
            dollars = card.ability.extra.bonusCash
          }
        end
        card.ability.extra.nextScoredCount = card.ability.extra.nextScoredCount - 1
        return {
            card = card,
            chips = card.ability.extra.bonusChips,
          }
      end


    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}