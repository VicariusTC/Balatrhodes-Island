SMODS.Joker{
    key = 'Ebenholz', 
    name = 'Ebenholz',
    rarity = 3,
    atlas = 'Jokers',
	cost = 9,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true,
    pos = {x = 0, y = 8}, 
    config = { 
      extra = {
        Xmultbonus = 1.5,
        maxStored = 4,
        storedAttack = 0,
        addedStored = 0.5,
        tagClass = {"Caster"},
        tagFaction = {"Leithanien"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = {set = 'Other', key = "StoredMult"}
        return {vars = {center.ability.extra.Xmultbonus, center.ability.extra.maxStored, center.ability.extra.storedAttack}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.scoring_hand and context.final_scoring_step and G.GAME.blind then
            if not (G.GAME.blind.boss) then
                local faceFound = false 
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:is_face() then
                        faceFound = true
                        break
                    end
                end
                if not faceFound then
                    if not context.blueprint then
                        card.ability.extra.storedAttack = math.min(card.ability.extra.storedAttack + 1, card.ability.extra.maxStored)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_plus_Stored"), G.C.ATTENTION})
                    end
                    return
                end
            end
            if (SMODS.calculate_round_score() + G.GAME.chips)/G.GAME.blind.chips >= 1 then
                if not context.blueprint then
                    card.ability.extra.storedAttack = math.min(card.ability.extra.storedAttack + 1, card.ability.extra.maxStored)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_plus_Stored"), G.C.ATTENTION})
                end
            else
                local effectiveMult =  card.ability.extra.Xmultbonus + card.ability.extra.storedAttack * card.ability.extra.addedStored
                if context.blueprint then
                    if ((SMODS.calculate_round_score() * effectiveMult) + G.GAME.chips)/G.GAME.blind.chips >= 1 then
                        card.ability.extra.storedAttack = 0
                    end
                else
                    card.ability.extra.storedAttack = 0
                end
                return {
                    card = card,
                    xmult = effectiveMult,
                }
            end  
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end  
}

----------------------------------------Base Leithanien end----------------------------------------