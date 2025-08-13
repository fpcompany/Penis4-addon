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
    MarkOfTheWild = 1126,
    Ravage = 441605,
}

Guardian.Buffs = {
    FrenziedRegeneration = 22842,
    Barkskin = 22812,
    RageOfTheSleeper = 200851,
    SurvivalInstincts = 61336,
    Ironfur = 192081,
    MarkOfTheWild = 1126,
    MarkOfTheWildNPCs = 432661, -- on Brann
    Ravage = 441602,
}

Guardian.priority = function(hekili)
    local DESIRED_IRON_FUR_STACKS = 7
    local IRON_FUR_COST = 40
    local FR_COST = 10

    local rage = UnitPower("player", 1)
    local myHealth = 100 * (UnitHealth("player") / UnitHealthMax("player"))    
    local targetHealth = 100 * (UnitHealth("target") / UnitHealthMax("target"))
    local hasIronfur, _, ironFurStacks = P4.AuraTracker:UnitHas("player", Guardian.Buffs.Ironfur) -- Iron fur stacks
    local hasFrenzied = P4.AuraTracker:UnitHas("player", Guardian.Buffs.FrenziedRegeneration)
    local hasBarkskin = P4.AuraTracker:UnitHas("player", Guardian.Buffs.Barkskin)
    local hasRageOfSleeper = P4.AuraTracker:UnitHas("player", Guardian.Buffs.RageOfTheSleeper)
    local hasSurvivalInstincts = P4.AuraTracker:UnitHas("player", Guardian.Buffs.SurvivalInstincts)
    local debuffsOnMe = P4.AuraTracker:GetActiveDebuffTypes("player")


    local dispelReady = P4.IsSpellReady(Guardian.Spells.RemoveCorruption)
    local debuffedUnit = dispelReady and P4.AuraTracker:GetUnitWithDebuff(P4.Debuff.Curse, P4.Debuff.Poison)
    
    -- Focusing logic
    local action = P4.GetTarget(debuffedUnit)
    if action then return action end

    -- Dispel the debuffed unit
    if debuffedUnit then -- if we are here, this means debuffed unit is in focus, no need to check
        P4.log("Purify Spirit on " .. tostring(debuffedUnit), P4.DEBUG)
        return Guardian.Spells.RemoveCorruption
    end

    if not P4.AuraTracker:EveryoneHas(Guardian.Buffs.MarkOfTheWild, Guardian.Buffs.MarkOfTheWildNPCs) then
        P4.log("Lapka (someone does not have it)", P4.DEBUG)
        return Guardian.Spells.MarkOfTheWild
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
        if myHealth < 50 then
            --P4.log("Emergency Frenzied Regeneration")
            return Guardian.Spells.FrenziedRegeneration
        elseif not hasBarkskin and not hasRageOfSleeper and not hasSurvivalInstincts and myHealth < 75 then
            --P4.log("Fallback Frenzied Regeneration")
            return Guardian.Spells.FrenziedRegeneration
        end
    end

    if (P4.IsItemReady(211879) or P4.IsItemReady(21880) or P4.IsItemReady(211878)) and not P4.IsSpellReady(Guardian.Spells.FrenziedRegeneration) and myHealth < 50 then -- Algari Healing Potion
        P4.log("HP POTION (<50%)", P4.DEBUG)
        return P4.MacroSystem:GetMacroIDForMacro("HealingPotion")
    end

    if myHealth < 85 then
        if not hasFrenzied and not hasRageOfSleeper and not hasSurvivalInstincts and P4.IsSpellReady(Guardian.Spells.Barkskin) then
            --P4.log("Barkskin")
            return Guardian.Spells.Barkskin
        end
        if not hasFrenzied and not hasBarkskin and not hasSurvivalInstincts and P4.IsSpellReady(Guardian.Spells.RageOfTheSleeper) then
            --P4.log("Rage of the Sleeper")
            return Guardian.Spells.RageOfTheSleeper
        end
    end

    if myHealth < 75 and not hasFrenzied and not hasBarkskin and not hasRageOfSleeper and P4.IsSpellReady(Guardian.Spells.SurvivalInstincts) then
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

    if (P4.AuraTracker:UnitHas("player", Guardian.Buffs.Ravage) and hekili==6807) then
        --P4.log("Ravage")
        return Guardian.Spells.Ravage
    end

    return nil
end