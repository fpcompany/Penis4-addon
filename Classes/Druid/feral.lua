Feral = {}
Druid.specs[2] = Feral

Feral.Macros = {
}

Feral.Setup = function ()
end

Feral.Spells = {
    RemoveCorruption = 2782,
    FrenziedRegeneration = 22842,
    Barkskin = 22812,
    RageOfTheSleeper = 200851,
    SurvivalInstincts = 61336,
    Regrowth = 8936,
    Renewal = 108238,
    BearForm = 5487,
    MarkOfTheWild = 1126,
    Mangle = 33917,
}

Feral.Buffs = {
    FrenziedRegeneration = 22842,
    Barkskin = 22812,
    SurvivalInstincts = 61336,
    PredatorySwiftness = 69369,
    BearForm = 5487,
    MarkOfTheWild = 1126,
}

Feral.priority = function()
    local healthPercent = 100 * (UnitHealth("player") / UnitHealthMax("player"))    
    local targetHealthPercent = 100 * (UnitHealth("target") / UnitHealthMax("target"))
    local frenziedRegenerationReady = P4.IsSpellReady(Feral.Spells.FrenziedRegeneration)
    local hasFrenziedRegeneration = P4.AuraTracker:UnitHas("player", Feral.Buffs.FrenziedRegeneration)
    local barkskinReady = P4.IsSpellReady(Feral.Spells.Barkskin)
    local hasBarkskin = P4.AuraTracker:UnitHas("player", Feral.Buffs.Barkskin)
    local survivalInstinctsReady = P4.IsSpellReady(Feral.Spells.SurvivalInstincts)
    local hasSurvivalInstincts = P4.AuraTracker:UnitHas("player", Feral.Buffs.SurvivalInstincts)
    local renewalReady = P4.IsSpellReady(Feral.Spells.Renewal)
    local bearFormReady = P4.IsSpellReady(Feral.Spells.BearForm)
    local hasBearForm = P4.AuraTracker:UnitHas("player", Feral.Buffs.BearForm)
    local debuffsOnMe = P4.AuraTracker:GetActiveDebuffTypes("player")


    --[[if (tContains(debuffsOnMe, P4.Debuff.Curse) or tContains(debuffsOnMe, P4.Debuff.Poison)) and P4.IsSpellReady(Feral.Spells.RemoveCorruption) then
        return Feral.Spells.RemoveCorruption
    end]]

    local debuffedUnit = P4.AuraTracker:GetUnitWithDebuff(P4.Debuff.Poison, P4.Debuff.Curse)
    local dispelReady = P4.IsSpellReady(Feral.Spells.RemoveCorruption)
    if debuffedUnit and not UnitIsUnit("focus", debuffedUnit) then
            if dispelReady then
                P4.log("Focus " .. tostring(debuffedUnit) .. " for dispel", P4.DEBUG)
                return P4.MacroSystem:GetMacroIDForUnit(debuffedUnit)
            end
    end
    if debuffedUnit and UnitIsUnit("focus", debuffedUnit) and dispelReady then
      return Feral.Spells.RemoveCorruption
    end

    if not P4.AuraTracker:EveryoneHas(Feral.Buffs.MarkOfTheWild) then
        P4.log("Lapka (someone does not have it)", P4.DEBUG)
        return Feral.Spells.MarkOfTheWild
    end

    if hasFrenziedRegeneration then
        return Feral.Spells.Mangle
    end

    if healthPercent < 70 then
        if renewalReady then
            return Feral.Spells.Renewal
        elseif barkskinReady and not hasFrenziedRegeneration and not hasSurvivalInstincts then
            return Feral.Spells.Barkskin
        end
    end

    if healthPercent <= 50 then -- 50% hp
        if P4.IsItemReady(211879) then -- Algari Healing Potion
            P4.log("HP POTION (<50%)", P4.DEBUG)
            return P4.MacroSystem:GetMacroIDForMacro("HealingPotion")
        end
    end

    if healthPercent < 50 then
        if survivalInstinctsReady and not hasFrenziedRegeneration and not hasBarkskin  then
            return Feral.Spells.SurvivalInstincts
        elseif frenziedRegenerationReady and not hasBarkskin and not hasSurvivalInstincts then
            if hasBearForm then
                return Feral.Spells.FrenziedRegeneration
            else
                return Feral.Spells.BearForm
            end
        end
    end

    return nil
end