SMODS.current_mod.reset_game_globals = function(run_start)
    G.AKTS_Globals.burnElementalInjury = 0
    G.AKTS_Globals.burnBurstApplied = false
    G.AKTS_Globals.necrosisElementalInjury = 0
    G.AKTS_Globals.necrosisBurstApplied = false
    G.AKTS_Globals.bindHandScore = 0
    G.AKTS_Globals.blindBound = 0
    G.AKTS_Globals.jokerSoldThisRound = false
    if run_start then
        G.AKTS_Globals.yatosSold = 0
        G.AKTS_Globals.cloneChips = 25
        G.AKTS_Globals.burnBurstFactor = 1
        G.AKTS_Globals.necrassDestroyed = 0
    end
end

G.AKTS_Globals = {
    jokerSoldThisRound = false,
    burnElementalInjury = 0,
    burnBurstApplied = false,
    burnBurstFactor = 1,
    necrosisElementalInjury = 0,
    necrosisBurstApplied = false,
    bindHandScoreMultiplier = 0.25,
    blindBound = 0,
    bindHandScore = 0,
    yatosSold = 0,
    yatosSoldCondition = 2,
    cloneChips = 25,
    necrassDestroyed = 0,
    lesserServantMaxLevel = 3,
    servantMaxCount = 2
}

G.AKTS_Colors = {
    transformColor = HEX("6B2980"),
    summonColor = HEX("818B96"),
    fastRedeployColor = HEX("75201A");
}