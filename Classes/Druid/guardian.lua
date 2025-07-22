Guardian = {}
Druid.specs[3] = Guardian

Guardian.Macros = {
}

Guardian.Setup = function ()
end

Guardian.Spells = {
    RemoveCorruption = 2782,
    Ironfur = 192081,
    FrenziedRegeneration = 22842,
    Barkskin = 22812,
    RageOfTheSleeper = 200851,
    SurvivalInstincts = 61336,
}

Guardian.Buffs = {
    FrenziedRegeneration = 22842,
    Barkskin = 22812,
    RageOfTheSleeper = 200851,
    SurvivalInstincts = 61336,
    Ironfur = 192081,
}

Guardian.priority = function()
    local DESIRED_IRON_FUR_STACKS = 7
    local IRON_FUR_COST = 40
    local FR_COST = 10

    local rage = UnitPower("player", 1)
    local healthPercent = 100 * (UnitHealth("player") / UnitHealthMax("player"))    
    local targetHealthPercent = 100 * (UnitHealth("target") / UnitHealthMax("target"))
    local hasIronfur, _, ironFurStacks = P4.AuraTracker:UnitHas("player", Guardian.Buffs.Ironfur) -- Iron fur stacks
    local hasFrenzied = P4.AuraTracker:UnitHas("player", Guardian.Buffs.FrenziedRegeneration)
    local hasBarkskin = P4.AuraTracker:UnitHas("player", Guardian.Buffs.Barkskin)
    local hasRageOfSleeper = P4.AuraTracker:UnitHas("player", Guardian.Buffs.RageOfTheSleeper)
    local hasSurvivalInstincts = P4.AuraTracker:UnitHas("player", Guardian.Buffs.SurvivalInstincts)
    local debuffsOnMe = P4.AuraTracker:GetActiveDebuffTypes("player")


    if (tContains(debuffsOnMe, P4.Debuffs.Curse) or tContains(debuffsOnMe, P4.Debuffs.Poison)) and P4.IsSpellReady(Guardian.Spells.RemoveCorruption) then
        return Guardian.Spells.RemoveCorruption
    end

    if (ironFurStacks or 0) < DESIRED_IRON_FUR_STACKS and P4.IsSpellReady(Guardian.Spells.Ironfur) and rage >= (IRON_FUR_COST + FR_COST) then -- Iron fur
        --P4.log("Defensive Iron Fur")
        return Guardian.Spells.Ironfur
    end
    if rage > 90 and P4.IsSpellReady(Guardian.Spells.Ironfur) then
        --P4.log("Dumping Iron Fur")
        return Guardian.Spells.Ironfur
    end

    if not hasFrenzied and P4.IsSpellReady(Guardian.Spells.FrenziedRegeneration) and rage >= FR_COST then
        if healthPercent < 50 then
            --P4.log("Emergency Frenzied Regeneration")
            return Guardian.Spells.FrenziedRegeneration
        elseif not hasBarkskin and not hasRageOfSleeper and not hasSurvivalInstincts and healthPercent < 75 then
            --P4.log("Fallback Frenzied Regeneration")
            return Guardian.Spells.FrenziedRegeneration
        end
    end

    if healthPercent < 85 then
        if not hasFrenzied and not hasRageOfSleeper and not hasSurvivalInstincts and P4.IsSpellReady(Guardian.Spells.Barkskin) then
            --P4.log("Barkskin")
            return Guardian.Spells.Barkskin
        end
        if not hasFrenzied and not hasBarkskin and not hasSurvivalInstincts and P4.IsSpellReady(Guardian.Spells.RageOfTheSleeper) then
            --P4.log("Rage of the Sleeper")
            return Guardian.Spells.RageOfTheSleeper
        end
    end

    if healthPercent < 75 and not hasFrenzied and not hasBarkskin and not hasRageOfSleeper and P4.IsSpellReady(Guardian.Spells.SurvivalInstincts) then
        --P4.log("Survival Instincts")
        return Guardian.Spells.SurvivalInstincts
    end
    
    if P4.TankbusterDanger() then
        if not hasBarkskin and P4.IsSpellReady(Guardian.Spells.Barkskin) then
            return Guardian.Spells.Barkskin
        elseif not hasRageOfSleeper and P4.IsSpellReady(Guardian.Spells.RageOfTheSleeper) then
            return Guardian.Spells.RageOfTheSleeper
        elseif not hasSurvivalInstincts and P4.IsSpellReady(Guardian.Spells.SurvivalInstincts) then
            return Guardian.Spells.SurvivalInstincts
        end
    end

    return nil
end