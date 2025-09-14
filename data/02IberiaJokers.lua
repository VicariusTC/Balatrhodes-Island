SMODS.Joker{
    key = 'Lumen', 
    name = 'Lumen',
    rarity = 1,
    atlas = 'Jokers',
	cost = 6,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = false, 
    eternal_compat = true, 
    perishable_compat = true,
    pos = {x = 0, y = 4}, 
    config = { 
      extra = {
        chipStorage = 0,
        chipIncrement = 5,
        tempSteelTurns = 3,
        cleanseNum = 3,
        cleanseCount = 0,
        ammoCount = 3,
        tagClass = {"Medic"},
        tagFaction = {"Iberia", "Aegir"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_akts_TempSteel
        return {vars = {center.ability.extra.ammoCount, center.ability.extra.tempSteelTurns, center.ability.extra.chipIncrement, center.ability.extra.chipStorage, center.ability.extra.cleanseNum}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand and not context.blueprint and card.ability.extra.ammoCount > 0 then
            if context.before then
                local currentlyCleansed = 0
                for i = 1, #context.full_hand do
                    if context.full_hand[i].debuff then 
                        --Cleanse and enhance, increment, then break if currentlyCleansed == cleanseNum
                        context.full_hand[i]:set_ability(G.P_CENTERS.m_akts_TempSteel, nil, true)
                        context.full_hand[i].ability.extra.remainingTurn = card.ability.extra.tempSteelTurns
                        context.full_hand[i].ability.extra.undebuffable = true
                        context.full_hand[i].debuff = false
                        card.ability.extra.cleanseSuccess = true
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                context.full_hand[i]:juice_up()
                                return true
                            end
                        }))
                        currentlyCleansed = currentlyCleansed + 1
                        if currentlyCleansed >= card.ability.extra.cleanseNum then
                            break
                        end
                    end
                end
                if card.ability.extra.cleanseSuccess == true then
                    card.ability.extra.cleanseSuccess = false
                    handleAmmo(card)         
                delay(0.2) 
                end
            end
        end
        if context.joker_main then
            card.ability.extra.cleanseCount = 0
            if card.ability.extra.chipStorage > 0 then
                return {
                    card = card,
                    chips = card.ability.extra.chipStorage,
                }
            end
        end
        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and (context.other_card.config.center == G.P_CENTERS.m_akts_TempSteel or context.other_card.config.center == G.P_CENTERS.m_gold or context.other_card.config.center == G.P_CENTERS.m_steel) then
            --[[
            if context.other_card.config.center == G.P_CENTERS.m_akts_TempSteel then
                context.other_card.ability.extra.remainingTurn = math.min(context.other_card.ability.extra.remainingTurn + 1, card.ability.extra.tempSteelTurns)
            end
            ]]
            card.ability.extra.chipStorage = card.ability.extra.chipStorage + card.ability.extra.chipIncrement
            return {
                extra = {focus = card, message = localize('k_upgrade_ex')},
                card = card,
                colour = G.C.CHIPS
            }
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end 
}

----------------------------------------Base Iberia end----------------------------------------