SMODS.Joker{
    key = 'Necrass',
    name = 'Necrass',
    rarity = 3,
    atlas = 'Jokers',
	cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    pos = {x = 0, y = 15},
    config = { 
      extra = {
        maxServantCount = 2,
        tagClass = {"Caster"},
        tagFaction = {"Tara"}
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_akts_ServantLesser
        return {vars = {center.ability.extra.maxServantCount}}
    end,
    calculate = function(self,card,context)
        if context.joker_main and G.jokers and G.jokers.cards then
            for k, joker in pairs(G.jokers.cards) do
                if joker.debuff and not joker.ability.eternal then
                    G.E_MANAGER:add_event(Event({
                        trigger = "after", 
                        delay = 0.01,
                        func = function() 
                            SMODS.destroy_cards(joker)
                            G.AKTS_Globals.necrassDestroyed = G.AKTS_Globals.necrassDestroyed + 1
                            return true
                        end
                    }))
                end
            end
        end

        if (context.joker_type_destroyed and context.card.ability and not (context.card.ability.name == "ServantGreater" or context.card.ability.name == "ServantLesser")) 
        or (context.end_of_round and context.main_eval and context.game_over == false and G.GAME.blind) then
            HandleEblanaServant(card)
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}

SMODS.Joker{
    key = 'ServantLesser',
    name = 'ServantLesser',
    rarity = 'akts_Transformed',
    atlas = 'Jokers',
	cost = 1,
    unlocked = true,
    no_collection = true,
    blueprint_compat = true,
    perishable_compat = false,
    pos = {x = 1, y = 15},
    config = { 
      extra = {
        bonusChips = 40,
        bonusMult = 10,
        upgradeCount = 0,
        necrassDestructChipBonus = 30,
        upgrade2Cash = 5,
        markedForDestruction = false
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.bonusChips, center.ability.extra.bonusMult, center.ability.extra.necrassDestructChipBonus, center.ability.extra.necrassDestructChipBonus * G.AKTS_Globals.necrassDestroyed, center.ability.extra.upgradeCount, center.ability.extra.upgrade2Cash, G.AKTS_Globals.lesserServantMaxLevel}}
    end,
    add_to_deck = function(self, card, from_debuff)
        card:set_eternal(true)
        if card.ability.extra.upgradeCount == G.AKTS_Globals.lesserServantMaxLevel then
            IsServantFusion(card, card, GetEblanaServants(), G.AKTS_Globals.lesserServantMaxLevel)
        end
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            local returnChips = card.ability.extra.bonusChips
            if card.ability.extra.upgradeCount > 0 then
                returnChips = returnChips + card.ability.extra.necrassDestructChipBonus * G.AKTS_Globals.necrassDestroyed
            end
            return{
                chips = returnChips,
                mult = card.ability.extra.bonusMult,
                card = card
            }
        end

        if (context.selling_card or context.joker_type_destroyed) and context.card.ability.set == "Joker" and G.jokers and G.jokers.cards then

            local necrassFound = false
            for k, joker in pairs(G.jokers.cards) do
                local ability = joker.ability
                if ability and ability.extra and type(ability.extra) == "table" and "j_akts_" .. ability.name == "j_akts_Necrass" and joker ~= context.card then
                   necrassFound = true
                end
            end
            if not necrassFound then
                card:set_eternal(false)
                SMODS.destroy_cards(card)
            end
            if context.joker_type_destroyed and card.ability.extra.upgradeCount >= 2 and not (context.card.ability.name == "ServantGreater" or context.card.ability.name == "ServantLesser") then
                return{
                    dollars = card.ability.extra.upgrade2Cash
                }
            end
        end
    end,
}

SMODS.Joker{
    key = 'ServantGreater',
    name = 'ServantGreater',
    rarity = 'akts_Transformed',
    atlas = 'Jokers',
	cost = 1,
    unlocked = true,
    no_collection = true,
    blueprint_compat = true,
    perishable_compat = false,
    pos = {x = 2, y = 15},
    config = { 
      extra = {
        bonusXChips = 1.5,
        bonusXMult = 1.5,
        upgradeBonusChips = 0.15,
        upgradeCount = 0,
        upgradeSummonReq = 3,
        upgradeSummonTarget = "j_joker",
      }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_joker
        return {vars = {center.ability.extra.bonusXChips + (center.ability.extra.upgradeCount * center.ability.extra.upgradeBonusChips), center.ability.extra.bonusXMult, center.ability.extra.upgradeBonusChips, center.ability.extra.upgradeCount, center.ability.extra.upgradeSummonReq}}
    end,
    add_to_deck = function(self, card, from_debuff)
        card:set_eternal(true)
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return{
                xchips = card.ability.extra.bonusXChips + (card.ability.extra.upgradeCount * card.ability.extra.upgradeBonusChips),
                xmult = card.ability.extra.bonusXMult,
                delay = 0.5,
                card = card
            }
        end

        if (context.selling_card or context.joker_type_destroyed) and context.card.ability.set == "Joker" and G.jokers and G.jokers.cards then
            local necrassFound = false
            for k, joker in pairs(G.jokers.cards) do
                local ability = joker.ability
                if ability and ability.extra and type(ability.extra) == "table" and IdOf(joker) == "j_akts_Necrass" and joker ~= context.card then
                    necrassFound = true
                    break
                end
            end
            if not necrassFound then
                card:set_eternal(false)
                SMODS.destroy_cards(card)
            end
        end

        if context.end_of_round and context.cardarea == G.jokers and card.ability.extra.upgradeCount >= card.ability.extra.upgradeSummonReq then
            Create_Joker({card.ability.extra.upgradeSummonTarget}, card, {negative = true}, true)
        end
    end,
}