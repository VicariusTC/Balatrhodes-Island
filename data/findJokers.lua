local isExcluded = function(card, exclusions)
    if not exclusions or #exclusions == 0 then return false end
    for _, ex in ipairs(exclusions) do
        if ex == card or (card.ability and card.ability.extra and ex == card.ability.extra.transformLink) then
            return true
        end
    end
    return false
end

CalcTaggedListHelper = function(Tag, abilityExtra)
    if not abilityExtra.tagFaction then
        return false
    end
    if #abilityExtra.tagFaction > 0 then
        for i, v in pairs(abilityExtra.tagFaction) do
            if abilityExtra.tagFaction[i] == Tag then
                return true
            end
        end
    end
    if #abilityExtra.tagClass > 0 then
        for i, v in pairs(abilityExtra.tagClass) do
            if abilityExtra.tagClass[i] == Tag then
                return true
            end
        end
    end
    return false
end

--lists all owned jokers names with specified tag content (e.g. Sniper or Iberia)
CalcTaggedOwned = function(tag, exclusions)
    local found = {}
    local jokers = G.jokers and G.jokers.cards
    if not jokers then return found end

    for _, card in pairs(jokers) do
        local ability = card.ability
        if ability and ability.extra and type(ability.extra) == "table" and CalcTaggedListHelper(tag, ability.extra) then
            if not isExcluded(card, exclusions) then
                table.insert(found, card.config.center.key)
            end
        end
    end
    return found
end

CalcTaggedOwnedTitleHelper = function(card, Tag)
    if card.ability and (card.ability.extra and type(card.ability.extra) == "table" and card.ability.extra[Tag]) then
        return true
    end
    return false
end

--lists all owned jokers with specified tagtitle (e.g. card.ability.extra.ammoCount)
CalcTaggedOwnedTitle = function(tag, exclusions)
    local found = {}
    local jokers = G.jokers and G.jokers.cards
    if not jokers then return found end

    for _, card in pairs(jokers) do
        local ability = card.ability
        if CalcTaggedOwnedTitleHelper(card, tag) then
            if not isExcluded(card, exclusions) then
                table.insert(found, card)
            end
        end
    end
    return found
end


--lists all owned jokers names and positions with specified tag
CalcTaggedOwnedPos = function(Tag, exclusions)
    local found = {}
    local jokers = G.jokers and G.jokers.cards
    if not jokers then return found end

    for _, card in pairs(jokers) do
        local ability = card.ability
        if ability and (ability.extra and type(ability.extra) == "table" and CalcTaggedListHelper(Tag, ability.extra)) then
            if not isExcluded(card, exclusions) then
                table.insert(found, {card.config.center.key, _})
            end
        end
    end
    return found
end    

local calcTaggedTitleHelper = function(card, Tag)
    if card.config and (card.config.extra and type(card.config.extra) == "table" and card.config.extra[Tag]) then
        return true
    end
    return false
end
--lists all arknights jokers with specified tag content (e.g. Sniper/Rhodes)
CalcTagged = function(Tag,exclusions)
    local pool = {}

    for k, center in pairs(G.P_CENTERS) do
        if not k:find("^j_akts") then goto continue end

        local config = center and center.config
        local extra = config and config.extra
        if not extra then goto continue end

        if exclusions and #exclusions > 0 then
            for _, ex in pairs(exclusions) do
                if ex == k or ex == extra.transformLink then
                    goto continue
                end
            end
        end

        if CalcTaggedListHelper(Tag, extra) then
            table.insert(pool, k)
        end

        ::continue::
    end

    return pool
end    

local calcTaggedTitleHelper = function(card, Tag)
    if card.config and (card.config.extra and type(card.config.extra) == "table" and card.config.extra[Tag]) then
        return true
    end
    return false
end

--lists all arknights jokers with specified tag (e.g. FastRedeployFlag)
CalcTaggedTitle = function(Tag,exclusions)
    local pool = {}

    for k, center in pairs(G.P_CENTERS) do
        if not k:find("^j_akts") then goto continue end

        local config = center and center.config
        local extra = config and config.extra
        if not extra then goto continue end

        if exclusions and #exclusions > 0 then
            for _, ex in pairs(exclusions) do
                if ex == k or ex == extra.transformLink then
                    goto continue
                end
            end
        end

        if calcTaggedTitleHelper(center, Tag) then
            table.insert(pool, k)
        end

        ::continue::
    end

    return pool
end 

--lists all jokers of given rarity
CalcTaggedRarity = function(Rarity)
    local pool = {}
    for k, jokers in pairs(G.P_CENTERS) do
        if jokers.rarity == Rarity then
            table.insert(pool, k)
        end
    end
    return pool
end

CalcNamedConsumableOwned = function (key)
    local count = 0
    if not G.consumeables or not G.consumeables.cards then
        return count
    end
    for k, consumables in pairs(G.consumeables.cards) do
        if consumables.ability.name == key then
            count = count + 1
        end
    end
    return count
end

CalcOwnedMissingSellValue = function ()
    local sellVal = 0
    local jokers = G.jokers and G.jokers.cards
    if not jokers then return 0 end
    for _, card in pairs(jokers) do
        sellVal = sellVal + math.max(0,(math.max(1, math.floor(card.cost / 2)) - card.sell_cost))
    end
    return sellVal
end

CalcOwnedPlanets = function ()
    local pool = {}
    if not G.consumeables or not G.consumeables.cards then
        return pool
    end
    for k, consumables in pairs(G.consumeables.cards) do
        if consumables.ability.set == 'Planet' then
            table.insert(pool, k)
        end
    end
    return pool
end

CalcPlanetsMult = function ()
    local totalMult = 0
    if not G.consumeables or not G.consumeables.cards then
        return totalMult
    end
    for k, consumables in pairs(G.consumeables.cards) do
        if consumables.ability.set == 'Planet' then
            totalMult = totalMult + G.GAME.hands[consumables.ability.hand_type].l_mult
        end
    end
    return totalMult
end