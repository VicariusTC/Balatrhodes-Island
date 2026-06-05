SMODS.Joker{
    key = 'Leizi',
    name = 'Leizi',
    rarity = 2,
    atlas = 'Jokers',
	cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    no_pool_flag = 'akts_leizi_transform',
    pos = {x = 0, y = 16},
    config = {
      extra = {
        transformReq = 10,
        transformCount = 0,
        transformThisHand = 0,
        transformLink = "j_akts_LeiziAlter",
        tagClass = {"Caster"},
        tagFaction = {"Yan"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.transformReq, center.ability.extra.transformCount}}
    end,
    calculate = function(self,card,context)
      if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and card.ability.extra.transformThisHand < 2 and next(SMODS.get_enhancements(context.other_card)) then
        local thisPos = 0
        for index, value in ipairs(context.scoring_hand) do
            if value == card then
                thisPos = index
                break
            end
        end
        for i = 1, #context.scoring_hand do
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
            nextCard:set_ability(thisCard.config.center, nil, true)
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
        end
    end

    if context.after and card.ability.extra.transformCount >= card.ability.extra.transformReq then
        G.GAME.pool_flags.akts_leizi_transform = true
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_transform"), G.C.ATTENTION})
        jokerTransform(card, card.ability.extra.transformLink)
    end

    if context.end_of_round or context.hand_drawn then
        card.ability.extra.transformThisHand = 0
    end
  end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

SMODS.Joker{
    key = 'LeiziAlter',
    name = 'LeiziAlter',
    rarity = 'akts_Transformed',
    atlas = 'Jokers',
	cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    pos = {x = 1, y = 16},
    config = {
      extra = {
        transformMult = 5,
        transformThisHand = 0,
        thunderReq = 3,
        transformLink = "",
        tagClass = {"Guard", "Caster"},
        tagFaction = {"Yan"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.e_akts_thunderstruck
        return {vars = {center.ability.extra.transformMult, center.ability.extra.thunderReq}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_leizi_transform = true
    end, 
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_leizi_transform = false
    end,
    calculate = function(self,card,context)
      if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and next(SMODS.get_enhancements(context.other_card)) then
        local thisPos = 0
        local isRightMostUnenhanced = true
        for index, value in ipairs(context.scoring_hand) do
            if value == context.other_card then
                thisPos = index
            end
            if thisPos ~= 0 and index > thisPos + 1 then
                if value.config.center == G.P_CENTERS.c_base then
                    isRightMostUnenhanced = false
                end
            end
        end
        local thisCard = context.scoring_hand[thisPos]
        local nextCard = context.scoring_hand[thisPos + 1]
        if nextCard and nextCard.config.center == G.P_CENTERS.c_base then
            card.ability.extra.transformThisHand = card.ability.extra.transformThisHand + 1
            if card.ability.extra.transformThisHand >= card.ability.extra.thunderReq and isRightMostUnenhanced then
                nextCard:set_edition("e_akts_thunderstruck", true, true)
				nextCard.edition.akts_thunderstruck = false
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 1.0,
					blocking = false,
					func = function()
						nextCard:juice_up(1, 0.5)
						play_sound('polychrome1', 1.2, 0.7)
                        nextCard:set_edition("e_akts_thunderstruck", true, true)
						nextCard.edition.akts_thunderstruck = true
						return true
					end
				}))
            end
            nextCard:set_ability(thisCard.config.center, nil, true)
            thisCard:set_ability(G.P_CENTERS.c_base, nil, true)
            G.E_MANAGER:add_event(Event({
                    trigger = "after", 
                    delay = 0.1,
                    func = function() 
                        nextCard:juice_up()
                        return true
                    end
                }))
            return {
                mult = card.ability.extra.transformThisHand * card.ability.extra.transformMult,
                card = card
            }
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

SMODS.Joker{
    key = 'SwireAlter',
    name = 'Swire the Elegant Wit',
    rarity = 2,
    atlas = 'Jokers',
	cost = 1,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    pos = {x = 2, y = 16},
    config = {
      extra = {
        baseDestroyCost = 2,
        destroyCostMultiplier = 1,
        rentalMult = 0,
        destroyCostMult = 0,
        aktsUseButton = {"akts_swire_destroy_card", "akts_swire_can_destroy", "b_use"},
        subClass = "Merchant",
        tagClass = {"Specialist"},
        tagFaction = {"Yan"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = center.ability.extra.subClass}
        return {vars = {center.ability.extra.destroyCostMultiplier * center.ability.extra.baseDestroyCost, center.ability.extra.destroyCostMult + center.ability.extra.rentalMult}}
    end,
    calculate = function(self,card,context)
        if not context.blueprint and context.end_of_round and context.cardarea == G.jokers then
            if card.ability['rental'] then
                card.ability.extra.rentalMult = card.ability.extra.rentalMult + 3
            end
            card.ability.extra.destroyCostMult = 0
            card.ability.extra.destroyCostMultiplier = 1
        end

        if context.joker_main and card.ability.extra.rentalMult + card.ability.extra.destroyCostMult > 0 then
            return {
                mult = card.ability.extra.rentalMult + card.ability.extra.destroyCostMult,
                card = card
            }
        end

        if context.starting_shop then
            handleMerchant(card)
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card:set_rental(true)
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}

G.FUNCS.akts_swire_can_destroy = function(e)
    local card = e.config.ref_table
    if G.hand and #G.hand.highlighted == 1 and G.GAME.dollars - card.ability.extra.baseDestroyCost * card.ability.extra.destroyCostMultiplier >= G.GAME.bankrupt_at then
        e.config.colour = G.C.MULT
        e.config.button = "akts_swire_destroy_card"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.akts_swire_destroy_card = function(e)
    local card = e.config.ref_table
    SMODS.destroy_cards(G.hand.highlighted)
    local cost = card.ability.extra.baseDestroyCost * card.ability.extra.destroyCostMultiplier
    ease_dollars(-cost)
    card.ability.extra.destroyCostMult = card.ability.extra.destroyCostMult + cost
    card.ability.extra.destroyCostMultiplier = card.ability.extra.destroyCostMultiplier * 2
    card:highlight(false)
end