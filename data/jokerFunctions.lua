SMODS.current_mod.optional_features = function()
    return{
        post_trigger = true,
        retrigger_joker = true
    }
end
----------------------------------------------------------
--Extend getChipBonusFunctions to include looking into ability.extra tables
get_all_Bonus = function(card)
    local returnTable = {0,0,0,0,0}
    if card.ability.extra and type(card.ability.extra) == "table" and card.ability.extra.chips then
        returnTable[1] = card.ability.extra.chips
    else
        returnTable[1] = card:get_chip_bonus()
    end
    if card.ability.extra and type(card.ability.extra) == "table"and card.ability.extra.mult then
        returnTable[2] = card.ability.extra.mult
    else
        returnTable[2] = card:get_chip_mult()
    end
    if card.ability.extra and type(card.ability.extra) == "table"and card.ability.extra.x_mult then
        returnTable[3] = card.ability.extra.x_mult
    else
        returnTable[3] = card:get_chip_x_mult()
    end
    if card.ability.extra and type(card.ability.extra) == "table"and card.ability.extra.h_mult then
        returnTable[4] = card.ability.extra.h_mult
    else
        returnTable[4] = card:get_chip_h_mult()
    end
    if card.ability.extra and type(card.ability.extra) == "table"and card.ability.extra.h_x_mult then
        returnTable[5] = card.ability.extra.h_x_mult
    else
        returnTable[5] = card:get_chip_h_x_mult()
    end
    return returnTable
end
------------------------------------------------------

SMODS.current_mod.set_debuff = function(card)
    -- prevent debuffs (aoE from Joker)
    if G.jokers and G.jokers.cards then
        for k, v in pairs(G.jokers.cards) do
            if v.ability and (v.ability.extra and type(v.ability.extra) == "table" and v.ability.extra.aoEUndebuffable and v.ability.extra.aoEMain and v.ability.extra.aoEMain[1] and v.ability.extra.aoEMain[1][1]) then
                for l, w in pairs(v.ability.extra.aoEMain[1][1]) do
                    if card == w then
                        return 'prevent_debuff'
                    end
                end
            end
        end
    end

    -- prevent debuffs 
    if card.ability and (card.ability.extra and type(card.ability.extra) == "table") then
        if card.ability.extra.undebuffable == true then
            return 'prevent_debuff'
        end
    end
    return false
end
-----------------------------------------------------------
--extension of set_cost
local cardSetCost = Card.set_cost
function Card:set_cost()
    cardSetCost(self)
    if self.ability and (self.ability.extra and type(self.ability.extra) == "table" and self.ability.extra.aktsCostValue) then
        self.cost = self.ability.extra.aktsCostValue or 0
    end
    if self.ability and (self.ability.extra and type(self.ability.extra) == "table" and self.ability.extra.aktsSellValue) then
        self.sell_cost = self.ability.extra.aktsSellValue or 0
    end
    if setCustomSellPrice() then self.sell_cost = setCustomSellPrice() end
    if self.area and self.ability.couponed and (self.area == G.shop_jokers or self.area == G.shop_booster) then self.cost = 0 end
    self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost    
end

-- function for setting costs on other stuff to be used in set_cost
setCustomSellPrice = function()
    local activePriceSetter = CalcTaggedOwnedTitle('aktsSettingPrice')
    if #activePriceSetter > 0 then
        return activePriceSetter[1].ability.extra.aktsNewSellPrice
    end
    return nil
end
-----------------------------------------------------------
-- extension of sell card for Fast Redeploys
local cardSellCard = Card.sell_card
function Card:sell_card()
    cardSellCard(self)  
    if self.ability.set == 'Joker' then
        G.AKTS_Globals.jokerSoldThisRound = true
    end
end
-----------------------------------------------------------
-- extension of getendofroundeffect for fast redeploys
----------------------------------------------------------
isSuitAoEHelper = function(card, suit)
    --check if joker with aoESuitTargets exists
    local suitEffActive = {}
    if G.jokers and G.jokers.cards then
        for k, v in pairs(G.jokers.cards) do
            if v.ability and (v.ability.extra and type(v.ability.extra) == "table" and v.ability.extra.aoESuitTarget) then
                table.insert(suitEffActive, v)
            end
        end
    end
    --Apply Smeared Effect if yes
    if #suitEffActive > 0 then
        for i, v in pairs(suitEffActive) do
            if #v.ability.extra.aoESuitTarget > 0 then
                for j, g in pairs(v.ability.extra.aoESuitTarget) do
                    if g == card then
                        if (card.base.suit == 'Hearts' or card.base.suit == 'Diamonds') and (suit == 'Hearts' or suit == 'Diamonds') then
                            return true
                        elseif (card.base.suit == 'Clubs' or card.base.suit == 'Spades') and (suit == 'Clubs' or suit == 'Spades') then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

--extension of is_suit function for arknights exclusive stuff
local cardisSuits = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    if flush_calc then
        if isSuitAoEHelper(self, suit) then      
            return true
        end
    else
        if isSuitAoEHelper(self, suit) then
            return true
        end
    end
    return cardisSuits(self, suit, bypass_debuff, flush_calc)
end
-------------------------------------------------------
-----extension of Card:get_id() for mudrock ranks
local cardGetId = Card.get_id
function Card:get_id()
    if self.ability.effect == 'Stone Card' and not self.vampired
    and #CalcTaggedOwnedTitle("stoneCardRank") > 0 and CalcTaggedOwnedTitle("stoneCardRank")[1].ability.extra.stoneCardRank ~= 0 then
        return CalcTaggedOwnedTitle("stoneCardRank")[1].ability.extra.stoneCardRank
    end
    return cardGetId(self)
end
-------------------------------------------------------
local gameStart = Game.start_run
function Game:start_run(args)
    local ret = gameStart(self, args)
    if Balatrhodes_Config.balatrhodes_only == true then
        self.GAME.balatrhodes_only = true
    else
        self.GAME.balatrhodes_only = false
    end
    return ret
end

local getCurrentPool = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    local _pool, _pool_key = getCurrentPool(_type, _rarity, _legendary, _append)
    if G.GAME.balatrhodes_only == true and _type == 'Joker' then
        for i, v in ipairs(_pool) do
            if not (string.sub(v, 1, 6) == 'j_akts') then
                _pool[i] = 'UNAVAILABLE'
            end
        end
    end
    return _pool, _pool_key
end
-------------------------------------------------------
Create_Joker = function (itemList, card, edition, debuffed, msg)
    if msg then
        card_eval_status_text(card or G.jokers.cards[1], 'extra', nil, nil, nil, {message = msg, G.C.ATTENTION})
    end  
    local pickedJoker = pseudorandom_element(itemList, pseudoseed(math.random(500)))
    local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,pickedJoker)
    if edition then
        new_card:set_edition(edition, true)
    end
    if debuffed then
        SMODS.debuff_card(new_card, true, "notGettingUndebuffedPal")
    end
    new_card:add_to_deck()
    G.jokers:emplace(new_card)
end


----------------------------------------------------------
flip_cards = function(card)
   card:flip()
   delay(0.1)
   G.E_MANAGER:add_event(
      Event(
         {trigger = 'after',delay = 0.15,func = function() 
            card:flip();
            card:juice_up(0.3, 0.3);
            return true end
         }  
      )
   )
end
----------------------------------------
--Added for instant destruction when scoring.
aktsDestroy = function(card, selectType)
    if card.ability.name == 'Glass Card' or (selectType and selectType == "m_glass") then 
        card:shatter()
    else
        card:start_dissolve(nil, nil)
    end
    SMODS.destroy_cards(card)
end
-------------------------------------------
--add faction and class info
aktsinfoQueueHelper = function(self,info_queue,center)
    if #center.ability.extra.tagClass > 0 then
        local tagClassName = ""
        for i, v in pairs(center.ability.extra.tagClass) do
            tagClassName = tagClassName .. center.ability.extra.tagClass[i]
        end
        info_queue[#info_queue+1] = {set = 'Other', key = tagClassName}
    end
    if #center.ability.extra.tagFaction > 0 then
        local tagFactionName = ""
        for i, v in pairs(center.ability.extra.tagFaction) do
            tagFactionName = tagFactionName .. center.ability.extra.tagFaction[i]
        end
        info_queue[#info_queue+1] = {set = 'Other', key = tagFactionName}
    end
end

--add faction and class info
aktsBadgeHelper = function(self,card, badges)
    if #card.ability.extra.tagClass > 0 then
        local tagClassName = ""
        for i, v in pairs(card.ability.extra.tagClass) do
            tagClassName = tagClassName .. card.ability.extra.tagClass[i]
        end
        badges[#badges+1] = create_badge(localize("k_akts_"..tagClassName), G.C.GREEN, nil, 0.9)
    end
    if #card.ability.extra.tagFaction > 0 then
        local tagFactionName = ""
        for i, v in pairs(card.ability.extra.tagFaction) do
            tagFactionName = tagFactionName .. card.ability.extra.tagFaction[i]
        end
        badges[#badges+1] = create_badge(localize("k_akts_"..tagFactionName), G.C.RED, nil, 0.9)
    end
end

--for skadi's mult effect
skadiMultModCalc = function(extra)
    local totalBonus = extra.baseMult + #CalcTaggedOwned(extra.tagFaction[1]) * extra.multBonus
    if #CalcTaggedOwned(extra.tagFaction[1]) >= extra.exmultBonusReq then
        totalBonus = totalBonus + extra.exmultBonus
    end
    return totalBonus
end

logosHandSizeCalc = function(extra)
    if extra.curHandSize >= 0 then
        return "+" .. extra.curHandSize
    end
    return "" .. extra.curHandSize
end

gavialAlterDebtPayment = function(card, chipPool, mode)
    local cardExtra = card.ability.extra
    local currentPayment = 0
    if cardExtra.fulldebt > 0 and chipPool > 0 then
        --Pay off x% of debt or everything at end of round
        if mode == 'tax' then
            currentPayment = math.min(math.min((cardExtra.fulldebt * cardExtra.debtPayment), cardExtra.currentdebt), chipPool)
        elseif mode == 'full' then
            currentPayment = math.min(chipPool, cardExtra.currentdebt)     
        end
        chipPool = chipPool - currentPayment
        cardExtra.currentdebt = cardExtra.currentdebt - currentPayment
        if cardExtra.currentdebt == 0 then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_debt_free'), colour = G.C.MULT})
        else
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_debt_payment'), colour = G.C.MULT})
        end
    end
    
    if cardExtra.currentdebt == 0 then
        card:set_eternal(false)
        cardExtra.fulldebt = 0
    end
    return chipPool
end

getJokerSlot = function(Joker)
    if G.jokers and G.jokers.cards then
        for i, v in ipairs(G.jokers.cards) do
            if v == Joker then
                return i
            end
        end
    end
    return 0
end

--check if joker with given tag is leftmost where said tag is set to true
leftmostActivatedTrue = function(Tag, jokerPosition)
    if G.jokers and G.jokers.cards then
        for k, v in pairs(G.jokers.cards) do
            if v.ability and (v.ability.extra and type(v.ability.extra) == "table" and v.ability.extra[Tag] and k < jokerPosition) then
                return false
            end
        end
    end
    return true
end

--tf joker into new joker
jokerTransform = function(card, newJoker)
    local new_card = G.P_CENTERS[newJoker]
    if card.config.center == new_card then return end

    local old_key = card.config.center.keyd
    card.children.center = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[new_card.atlas], new_card.pos)
    card.children.center.states.hover = card.states.hover
    card.children.center.states.click = card.states.click
    card.children.center.states.drag = card.states.drag
    card.children.center.states.collide.can = false
    card.children.center:set_role({major = card, role_type = 'Glued', draw_major = card})
    card:set_ability(new_card, true)
    card:set_cost()

    if new_card.soul_pos then
        card.children.floating_sprite = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[new_card.atlas], new_card.soul_pos)
        card.children.floating_sprite.role.draw_major = card
        card.children.floating_sprite.states.hover.can = false
        card.children.floating_sprite.states.click.can = false
    elseif card.children.floating_sprite then
        card.children.floating_sprite:remove()
        card.children.floating_sprite = nil
    end

    if not card.edition then
        card:juice_up()
        play_sound('generic1')
    else
    card:juice_up(1, 0.5)
        if card.edition.foil then play_sound('foil1', 1.2, 0.4) end
        if card.edition.holo then play_sound('holo1', 1.2*1.58, 0.4) end
        if card.edition.polychrome then play_sound('polychrome1', 1.2, 0.7) end
        if card.edition.negative then play_sound('negative', 1.5, 0.4) end
    end
end

--check if card has identical properties to other card.
checkIdenticalCard = function(card, otherCard)
    if card.base.suit == otherCard.base.suit and card:get_id() == otherCard:get_id() and card:get_seal() == otherCard:get_seal() and card:get_edition() == otherCard:get_edition() and card.config.center == otherCard.config.center then
        return true
    end
    return false
end

--create table where aoETable[1] is table of all aoE Targets and aoETable[2] is their efficacies
createAoETable = function (card, handSelect, range, efficacy, mode)
    local returnAoEtable = {{}, {}}
    --special condition for tables with multiple AoEs in 1 hand.
        -- mode structure is as follows:
        -- mode[1] is mode type, so typically multi
        -- mode[2] is a table of the full hand
        -- mode[3] is their respective bonuses.
    if handSelect then
        for i, v in pairs(handSelect) do
            if v == card then
                for j, w in pairs(range) do
                    if handSelect[i + w] then
                        table.insert(returnAoEtable[1], handSelect[i + w])
                        table.insert(returnAoEtable[2], efficacy[j])
                    end
                end
            end
        end
    end
    return returnAoEtable
end

--returns table 
-- table[1] = table aoETable consists of two tables, aoETable[1] lists all affected cards and aoETable[2] lists their efficacies
-- table[2] = chipbonus
-- table[3] = multbonus
-- table[4] = xmultbonus
-- table[5] = cardenhancement
aoEEnhancement = function(joker, card, handSelect, range, efficacy)
    local aoETable = createAoETable(card, handSelect, range, efficacy)
    local returnTable = {}
    local cardCenter = card.config.center
    local allBonus = get_all_Bonus(card)
    if cardCenter == G.P_CENTERS.m_wild then
        if aoETable and joker.ability and (joker.ability.extra and type(joker.ability.extra) == "table" and joker.ability.extra.aoESuitTarget) then
            for i, v in pairs(aoETable[1]) do
                table.insert(joker.ability.extra.aoESuitTarget, v)
                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize("akts_smeared_aoe"), colour = G.C.MULT})
            end
        end
    elseif cardCenter == G.P_CENTERS.m_akts_Hook then
        -- Dont copy seals or editions at 50% or less efficacy and dont copy enhancement at 25% or less efficacy
        if G.GAME.current_round.hands_played == 0 then
            for i, v in pairs(aoETable[1]) do
                if not checkIdenticalCard(card, v) then
                    --disable hooking for all cards except the one in the center
                    for j, w in pairs(handSelect) do
                        if w ~= card and w.ability and (w.ability.extra and type(w.ability.extra) == "table" and w.ability.extra.activated) then
                            w.ability.extra.activated = false
                        end
                    end
                    copy_card(card, v)
                    if aoETable[2][i] <= 50 then
                        v:set_seal()
                        v:set_edition()
                    end
                    if aoETable[2][i] <= 25 then
                        v:set_ability(G.P_CENTERS.c_base)
                    end
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    }))
                end
            end
        end
    elseif allBonus[1] + allBonus[2] + allBonus[3] > 0  then
        table.insert(returnTable, aoETable)
        table.insert(returnTable, allBonus[1])
        table.insert(returnTable, allBonus[2])
        table.insert(returnTable, allBonus[3])
        if cardCenter == G.P_CENTERS.m_glass then
            table.insert(returnTable, 'm_glass')
        elseif cardCenter == G.P_CENTERS.m_lucky then
            table.insert(returnTable, 'm_lucky')
        elseif cardCenter == G.P_CENTERS.m_akts_True then
            table.insert(returnTable, 'm_akts_True')
            joker.ability.extra.aoEUndebuffable = true
        end
    end
    return returnTable
end

--Returns a table to be used during individual context, (int mult, int dollars)
parseEnhancement = function(card, context, otherCard)
    local returnMultDol = {0, 0}
    if not(card and card.ability and (card.ability.extra and type(card.ability.extra) == "table" and card.ability.extra.aoEMain)) then
        return returnMultDol 
    end

    local cardBonusMult = card.ability.extra.aoEMain[3]
    local cardName = card.ability.extra.aoEMain[5]

    returnMultDol[1] = cardBonusMult
    if not cardName then
        return returnMultDol
    end

    if card.ability.extra.aoEMain[5] == 'm_glass' then
        if pseudorandom('glassShatter') < G.GAME.probabilities.normal/4 then
            --Wait for chips to update, then destroy glass card
            local curChip = G.GAME.chips
            G.E_MANAGER:add_event(Event({
                func = function() 
                    if G.GAME.chips == curChip then
                        return false
                    end
                    aktsDestroy(otherCard, "m_glass")
                    return true
                end,
                blocking = false
            }))
        end
    elseif card.ability.extra.aoEMain[5] == 'm_lucky' then
        if pseudorandom('luckyTrigger') < G.GAME.probabilities.normal/5 then
            returnMultDol[1] = 20
        end
        if pseudorandom('luckyTrigger') < G.GAME.probabilities.normal/3 then
            returnMultDol[2] = 20
        end
    end
    return returnMultDol
end

setGeekDebuff = function(card)
    if card.sell_cost <= 0 then 
        card:juice_up()
        card:set_debuff(true)
    else
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('akts_hp_down'), colour = G.C.MULT})
        card.ability.extra.aktsSellValue = card.ability.extra.aktsSellValue - 1
        card:set_cost()
    end
end

handleAmmo = function(card, effect)
    if CalcTaggedOwnedTitleHelper(card, 'ammoCount') then
    --Expend Ammo
        card.ability.extra.ammoCount = card.ability.extra.ammoCount + (effect or -1)
        if not effect or effect < 0 then  
        --Checks if Ammo was expended
        end
    end
end

getCurrentHandName = function(context)
    for k, v in pairs(G.GAME.hands) do
        if context.scoring_name == k then return G.GAME.hands[k] end
    end
    return nil
end

getCurrentHandLevel = function(context)
    local currentHandName = getCurrentHandName(context) 
    if currentHandName then
        return currentHandName.level
    end
    return 0
end

isInTable = function(table, name) -- find string e.g. joker in a table, returns bool
    if table and name then
        for k, v in pairs(table) do
            if v == name then
                return true
            end
        end
    end
    return false
end

--Check if Elemental Injury is 100, after applying damage; If so, updates the booleans for that and applies the immediate burst effect
calculateElemInjury = function(card, burstType, elemDamage, blind)
    if not elemDamage then
        return
    end
    if burstType == 'Burn' then
        G.AKTS_Globals.burnElementalInjury = math.min(G.AKTS_Globals.burnElementalInjury + elemDamage, 100)
        if G.AKTS_Globals.burnElementalInjury == 100 then
            G.GAME.chips = G.GAME.chips + (G.AKTS_Globals.burnBurstFactor * 0.1 * G.GAME.blind.chips)
            G.AKTS_Globals.burnBurstApplied = true
        end
    end
    
end

--returns additional FLAT mult for the burn effect
-- params: card = card using the function, context = context, returnTable = context.other_ret.jokers
calculateBurnBurst = function(card, context, returnTable)
    --1.2x Mult on all triggered abilities.
    if context.post_trigger and leftmostActivatedTrue("akts_burn_burst", getJokerSlot(card)) and context.other_ret then
        local returnMult = 0
        if returnTable.mult or returnTable.Xmult_mod or returnTable.xmult then
            returnMult = ((0.2 * (mult - (mult /(returnTable.Xmult_mod or returnTable.xmult or 1) - (returnTable.mult or 0))))) --get 0.2x change in mult
        end
        return returnMult
    end
    return 0
end

--Current Status of Elemental Injury within Joker's Description
elemBurstText = function(burstType)
    if G.AKTS_Globals.burnElementalInjury ~= 100 then return localize("akts_current") .. " " .. burstType .. " " .. localize("akts_injury") ..": " .. G.AKTS_Globals.burnElementalInjury
    else return burstType .. " " .. localize("akts_burst_active") end 
end

--Visual Indicator of added elem injury on a card. Also showcases when a burst triggers.
elemBurstChangeText = function(added)
    if G.AKTS_Globals.burnElementalInjury ~= 100 then return "+" .. added .. " " .. localize("akts_damage")
    else return localize("akts_burst_trigger") end
end

--returns index position of card in table or 0 if not found.
isInTable = function(card, table)
    for j,w in pairs(table) do
        if w == card then
            return j
        end
    end
    return 0
end

PerformFastRedeploy = function(cardName, card)
    if not G.AKTS_Globals.jokerSoldThisRound and G.jokers.config.card_limit + 1 > (#G.jokers.cards + G.GAME.joker_buffer) then
        --add_tag(Tag('tag_akts_redeploy_tag'))
        ease_dollars(-card.sell_cost)
        local frdList = GetFastRedeployList(cardName)
        Create_Joker(frdList)
    end
end

GetFastRedeployList = function(cardName)
    local excluList = CalcTaggedRarity("akts_Transformed")
    table.insert(excluList, cardName)
    local frdList = CalcTaggedTitle("fastRedeployFlag", excluList)
    if G.AKTS_Globals.yatosSold > G.AKTS_Globals.yatosSoldCondition then
        if frdList and #frdList > 0 then
            for i, v in pairs(frdList) do
                if v == "j_akts_Yato" then
                    table.remove(frdList, i)
                end
            end
        end
        if cardName ~= "j_akts_YatoAlter" then
            table.insert(frdList, "j_akts_YatoAlter")
        end
       
    end
    return frdList
end

Round = function(num, numDecimalPlaces)
    local multiplier = 10^(numDecimalPlaces or 0)
    return math.floor(num * multiplier + 0.5) / multiplier
end

BindHand = function (duration, card)
    if G.AKTS_Globals.blindBound == 0 then
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("akts_bind_apply"), G.C.ATTENTION})
        G.AKTS_Globals.bindHandScore = Round((hand_chips * mult), 2)
        G.AKTS_Globals.blindBound = duration
    end 
end

ApplyBoundHand = function (card, context)
    if context.joker_main and leftmostActivatedTrue("akts_bind", getJokerSlot(card)) and G.AKTS_Globals.blindBound > 0 then
        G.AKTS_Globals.blindBound = G.AKTS_Globals.blindBound - 1
        return G.AKTS_Globals.bindHandScoreMultiplier * G.AKTS_Globals.bindHandScore
    end
    return 0
end

GetBindText = function ()
    if G.AKTS_Globals.blindBound == 0 then
        return ""
    end
    return G.AKTS_Globals.bindHandScore .. " Chips are bound to Blind for "..G.AKTS_Globals.blindBound .. " hands."
end

HealJoker = function (healer, target)
    local sellValue = target.sell_cost
    local targetCost = target.cost
    if target.ability and type(target.ability.extra) == "table" and target.ability.extra.aktsCostValue then
        targetCost = math.min(targetCost, target.ability.extra.aktsCostValue)
    end
    if sellValue < math.max(math.floor(targetCost/2), 1) then
        healer.ability.extra.aktsSettingPrice = true
        healer.ability.extra.aktsNewSellPrice =  math.min(math.max(math.floor(targetCost/2), 1), sellValue + healer.ability.extra.healAmount)
        if target.ability.extra.aktsSellValue then
            target.ability.extra.aktsSellValue = healer.ability.extra.aktsNewSellPrice
        end
        target:set_cost()
        card_eval_status_text(target, 'extra', nil, nil, nil, {message = localize("akts_heal"), G.C.GREEN})
        healer.ability.extra.aktsSettingPrice = false
        healer.ability.extra.aktsNewSellPrice = 0
    end
end

FindGreatestSellValueLoss = function ()
    local maxSellValLoss = 0
    local healTarget = -1
    local jokers = G.jokers and G.jokers.cards
    if not jokers then
        return
    end
    for index, joker in pairs(jokers) do
        local jokerCost = joker.cost
        if joker.ability and type(joker.ability.extra) == "table" and joker.ability.extra.aktsCostValue then
            jokerCost = math.min(jokerCost, joker.ability.extra.aktsCostValue)
        end
        local jokerSellValLoss = math.max(0,(math.max(1, math.floor(jokerCost / 2)) - joker.sell_cost))
        if maxSellValLoss <  jokerSellValLoss then
            maxSellValLoss = jokerSellValLoss
            healTarget = index
        end
    end
    return
    {
        maxSellValLoss = maxSellValLoss,
        healTarget = healTarget
    }
end
GetRankName = function (rank)
    if rank <= 10 then
        return "" .. rank
    end
    if rank == 11 then
        return localize("Jack", 'ranks')
    end
    if rank == 12 then
        return localize("Queen", 'ranks')
    end
    if rank == 13 then
        return localize("King", 'ranks')
    end
    if rank == 14 then
        return localize("Ace", 'ranks')
    end
end

MergeLists = function (list1, list2)
    local result = {}
    local seen = {}

    for _, v in ipairs(list1) do
        if not seen[v] then
            table.insert(result, v)
            seen[v] = true
        end
    end

    for _, v in ipairs(list2) do
        if not seen[v] then
            table.insert(result, v)
            seen[v] = true
        end
    end

    return result
end

HandleEblanaServant = function (card)
    if not (G.jokers and G.jokers.cards) then
        return
    end
    local maxUpgradeLevel = G.AKTS_Globals.lesserServantMaxLevel
    local maxServantCount = G.AKTS_Globals.servantMaxCount
    local servants = GetEblanaServants()

    if #servants < maxServantCount then
        Create_Joker({"j_akts_ServantLesser"}, card, {negative = true}, false, localize("akts_plus_summon"))
        return
    end
    local UpgradeEblanaServant = function (card, index, servantCount, maxUpgradeLevel)
        servantCount[index].ability.extra.upgradeCount = servantCount[index].ability.extra.upgradeCount + 1
        if not (GetServantUpgradeCount(servantCount[index], maxUpgradeLevel) < 0) then
            card_eval_status_text(servantCount[index], 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), G.C.PURPLE})
            return
        end
        if not IsServantFusion(card, servantCount[index], servantCount, maxUpgradeLevel) then
            card_eval_status_text(servantCount[index], 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), G.C.PURPLE})
        end
    end

    local lowestUpgradeIndex = nil
    for index, servant in ipairs(servants) do
        local thisUpgradeCount = GetServantUpgradeCount(servant, maxUpgradeLevel)
        if thisUpgradeCount >= 0 and (not lowestUpgradeIndex or thisUpgradeCount < GetServantUpgradeCount(servants[lowestUpgradeIndex], maxUpgradeLevel)) then
            lowestUpgradeIndex = index
        end
    end
    if lowestUpgradeIndex then
        UpgradeEblanaServant(card, lowestUpgradeIndex, servants, maxUpgradeLevel)
        return
    end
end

GetEblanaServants = function ()
    local servants = {}
    for _, joker in pairs(G.jokers.cards) do
        local ability = joker.ability
        if ability and type(ability.extra) == "table" then
            local id = IdOf(joker)
            if (id == "j_akts_ServantLesser" and not ability.extra.markedForDestruction) or id == "j_akts_ServantGreater" then
                table.insert(servants, joker)
            end
        end
    end
    return servants
end
-- Returns UpgradeCount adjusted for fusion and returns -1 if the Joker is fully upgraded
GetServantUpgradeCount = function (servant, maxUpgradeLevel)
    if IdOf(servant) == "j_akts_ServantGreater" then
        return maxUpgradeLevel + servant.ability.extra.upgradeCount
    end
    if servant.ability.extra.upgradeCount == maxUpgradeLevel then
        return -1
    end
    return servant.ability.extra.upgradeCount
end

IsServantFusion = function (card, target, servantCount, maxUpgradeLevel)
    for servantIndex, servant in ipairs(servantCount) do
        if servant ~= target and GetServantUpgradeCount(servant, maxUpgradeLevel) < 0  then
            servant:set_eternal(false)
            target:set_eternal(false)
            servant.ability.extra.markedForDestruction = true
            target.ability.extra.markedForDestruction = true
            SMODS.destroy_cards(servant)
            SMODS.destroy_cards(target)
            Create_Joker({"j_akts_ServantGreater"}, card, {negative = true})
            return true
        end
    end
    return false
end

IdOf = function(card) 
    return "j_akts_" .. card.ability.name
end