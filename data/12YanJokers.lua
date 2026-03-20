SMODS.Joker{
    key = 'Leizi',
    name = 'Leizi',
    rarity = 2,
    atlas = 'Jokers',
	cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    no_pool_flag = 'akts_leizi_transform',
    pos = {x = 0, y = 16},
    config = {
      extra = {
        transformReq = 8,
        transformCount = 0,
        transformThisHand = 0,
        transformLink = "",
        tagClass = {"Caster"},
        tagFaction = {"Yan"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.transformReq, center.ability.extra.transformCount}}
    end,
    calculate = function(self,card,context)
      if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and card.ability.extra.transformThisHand < 2 and context.other_card.config.center ~= G.P_CENTERS.c_base then
        local thisPos = 0
        for i = 1, #context.full_hand do
            if context.scoring_hand[i] == context.other_card then
                thisPos = i
                break
            end
        end
        local thisCard = context.scoring_hand[thisPos]
        local nextCard = context.scoring_hand[thisPos + 1]
        if nextCard and nextCard.config.center == G.P_CENTERS.c_base then
            card.ability.extra.transformCount = card.ability.extra.transformCount + 1
            card.ability.extra.transformThisHand = card.ability.extra.transformThisHand + 1
            nextCard:set_ability(context.scoring_hand[thisPos].config.center, nil, true)
            thisCard:set_ability(G.P_CENTERS.c_base, nil, true)
            G.E_MANAGER:add_event(Event({
                    trigger = "after", 
                    delay = 0.1,
                    func = function() 
                        thisCard:juice_up()
                        delay(0.2)
                        nextCard:juice_up()
                        return true
                    end
                }))
            --[[if card.ability.extra.transformCount >= card.ability.extra.transformReq then
                G.GAME.pool_flags.akts_leizi_transform = true
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_transform"), G.C.ATTENTION})
                jokerTransform(card, card.ability.extra.transformLink)
            end]]
        end
    end

    if context.end_of_round or context.hand_drawn then
        card.ability.extra.transformThisHand = 0
    end
  end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}