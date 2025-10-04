SMODS.Atlas{
    key = 'Summons', --atlas key
    path = 'AKSummons.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.ConsumableType{
    key = 'SummonConsumableType', --consumable type key

    collection_rows = {4,5}, --amount of cards in one page
    primary_colour = G.C.PURPLE, --first color
    secondary_colour = G.AKTS_Colors.summonColor, --second color
    loc_txt = {
        collection = 'Summon Cards', --name displayed in collection
        name = 'Summon', --name displayed in badge
        undiscovered = {
            name = 'Unknown Summon', --undiscovered name
            text = {'Undiscovered', 'Summon'} --undiscovered text
        }
    },
    shop_rate = 0, --rate in shop out of 100
}


SMODS.UndiscoveredSprite{
    key = 'SummonConsumableType', --must be the same key as the consumabletype
    atlas = 'Summons',
    pos = {x = 0, y = 0}
}


SMODS.Consumable{
    key = 'Mon3tr', --key
    set = 'SummonConsumableType', --the set of the card: corresponds to a consumable type
    atlas = 'Summons', --atlas
    pos = {x = 1, y = 0}, --position in atlas
    config = {
        extra = {
            cards = 2, --configurable value
            cardBonus = 20
        }
    },
    loc_vars = function(self,info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_akts_True
        return {vars = {center.ability.extra.cards}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    can_use = function(self,card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then --if cards in hand highlighted are above 0 but below the configurable value then
                return true
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
        for i = 1, #G.hand.highlighted do 
            --for every card in hand highlighted
            local conv_card = G.hand.highlighted[i]
            if conv_card.config.center == G.P_CENTERS.m_akts_True then
                conv_card.ability.extra.chips = conv_card.ability.extra.chips + card.ability.extra.cardBonus
            else
                conv_card:set_ability(G.P_CENTERS.m_akts_True, nil, true)
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    flip_cards(conv_card)
                    G.hand:unhighlight_all(); return true
                end
             }))
        end
    end,
}

SMODS.Consumable{
    key = 'NearlTheRadiant', --key
    set = 'SummonConsumableType', --the set of the card: corresponds to a consumable type
    atlas = 'Summons', --atlas
    cost = 6, --to make sell value = NTRJoker Sellvalue
    pos = {x = 2, y = 0}, --position in atlas
    config = {
        extra = {
            cardMult = 2,
            cashReq = 5
        }
    },
    loc_vars = function(self,info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_akts_True
        return {vars = {center.ability.extra.cardMult, center.ability.extra.cashReq}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_NearlAlter_transform = true
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.akts_NearlAlter_transform = false
    end,
    can_use = function(self,card)
        if G.jokers.config.card_limit > (#G.jokers.cards + G.GAME.joker_buffer) then
            return true
        end
        return false
    end,
    use = function(self,card,area,copier)
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_retreat"), G.C.ATTENTION})
        local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_akts_NearlRadiant')
        new_card:add_to_deck()
        G.jokers:emplace(new_card)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if G.GAME.dollars >= card.ability.extra.cashReq then
                local TrueScored = false
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i].config.center == G.P_CENTERS.m_akts_True then
                        TrueScored = true
                        break
                    end
                end
                if TrueScored then
                    ease_dollars(-card.ability.extra.cashReq, true)
                    return {
                        card = card,
                        Xmult_mod = card.ability.extra.cardMult,
                        message = localize("akts_textRadiantC"),
                        colour = G.C.MULT
                    }
                end
            else
                if G.jokers.config.card_limit > (#G.jokers.cards + G.GAME.joker_buffer) then
                  local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_akts_NearlRadiant')
                  new_card:add_to_deck()
                  G.jokers:emplace(new_card)
                end
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_retreat"), G.C.ATTENTION})
                card:remove()
                card = nil
            end
        end
    end,
}

SMODS.Consumable{
    key = 'Clone',
    set = 'SummonConsumableType', 
    atlas = 'Summons',
    cost = 0, 
    pos = {x = 3, y = 0},
    config = {
        extra = {
            chipLossUse = 5,
            chipGainSell = 10,
            chipBonusMax = 50
        }
    },
    loc_vars = function(self,info_queue, center)
        return {vars = {G.AKTS_Globals.cloneChips, center.ability.extra.chipLossUse, center.ability.extra.chipGainSell, center.ability.extra.chipBonusMax, G.GAME.last_hand_played or "none"}} 
    end,
    can_use = function(self,card)
        if G.GAME.last_hand_played and G.AKTS_Globals.cloneChips > 0 then
            return true
        end
        return false
    end,
    use = function(self,card,area,copier)
        local lastHand = G.GAME.hands[G.GAME.last_hand_played]
        G.GAME.hands[G.GAME.last_hand_played].chips = G.GAME.hands[G.GAME.last_hand_played].chips + G.AKTS_Globals.cloneChips
        G.AKTS_Globals.cloneChips = math.max(0, G.AKTS_Globals.cloneChips - card.ability.extra.chipLossUse)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 1.7}, {handname=localize(G.GAME.last_hand_played, 'poker_hands'),chips = lastHand.chips, mult = lastHand.mult, level= lastHand.level})
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,
    calculate = function(self, card, context)
        if context.selling_self then
            G.AKTS_Globals.cloneChips = math.min(card.ability.extra.chipBonusMax, G.AKTS_Globals.cloneChips + card.ability.extra.chipGainSell)
        end
    end,
}
----------------------------------------------
------------MOD CODE END----------------------
    
