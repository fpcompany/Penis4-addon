Brewmaster = {}
Monk.specs[1] = Brewmaster

Brewmaster.Macros = {
}

Brewmaster.Setup = function ()
end

Brewmaster.Spells = {
    Vivify = 116670,
    ExpelHarm = 322101,
    FortifyingBrew = 115203,
    CelestialBrew = 322507,
    PurifyingBrew = 119582,
    TouchOfDeath = 322109,
    Detox = 218164,
}

Brewmaster.Buffs = {
    VivaciousVivification = 392883,
    PurifiedChi = 325092,
    CelestialBrewBuff = 322507,
    FortifyingBrewBuff = 120954,
    ZenMeditationBuff = 115176,
    DiffuseMagicBuff = 122783,
}

Brewmaster.priority = function()
    local energy = UnitPower("player", 3)
    local healthPercentPlayer = 100 * (UnitHealth("player") / UnitHealthMax("player"))
    local healthPlayer = UnitHealth("player")
    local healthPercentTarget = 100 * (UnitHealth("target") / UnitHealthMax("target")) 
    local healthTarget = UnitHealth("target")    
    local staggerPercent = 100 * (UnitStagger("player") / UnitHealthMax("player"))
    --[[local chargesPurifyingBrew, maxChargesPurifyingBrew, startPurifyingBrew, durationPurifyingBrew = C_Spell.GetSpellCharges(Brewmaster.Spells.PurifyingBrew) --Purifying Brew charges]]
    local purifyingBrewChargesInfo = C_Spell.GetSpellCharges(Brewmaster.Spells.PurifyingBrew) --Purifying Brew charges
    local maxChargesPurifyingBrew, startPurifyingBrew, chargesPurifyingBrew, durationPurifyingBrew = purifyingBrewChargesInfo.maxCharges, purifyingBrewChargesInfo.cooldownStartTime, purifyingBrewChargesInfo.currentCharges, purifyingBrewChargesInfo.cooldownDuration --Purifying Brew charges
    local purifyingBrewCooldown = math.max(0, (startPurifyingBrew + durationPurifyingBrew) - GetTime()) --Purifying Brew cooldown
    local celestialBrewChargesInfo = C_Spell.GetSpellCharges(Brewmaster.Spells.CelestialBrew) --Celestial Brew charges
    local maxChargesCelestialBrew, startCelestialBrew, chargesCelestialBrew, durationCelestialBrew = celestialBrewChargesInfo.maxCharges, celestialBrewChargesInfo.cooldownStartTime, celestialBrewChargesInfo.currentCharges, celestialBrewChargesInfo.cooldownDuration --Celestial Brew charges
    local celestialBrewCooldown = math.max(0, (startCelestialBrew + durationCelestialBrew) - GetTime()) --Celestial Brew cooldown
    local healingSpheresCount= C_Spell.GetSpellCastCount(Brewmaster.Spells.ExpelHarm) --Expel Harm charges
    local _, purifiedChiTimer, purifiedChiStacks = P4.AuraTracker:UnitHas("player", Brewmaster.Buffs.PurifiedChi)
    local debuffsOnMe = P4.AuraTracker:GetActiveDebuffTypes("player")


    if (tContains(debuffsOnMe, P4.Debuff.Disease) or tContains(debuffsOnMe, P4.Debuff.Poison)) and P4.IsSpellReady(Brewmaster.Spells.Detox) then
        return Brewmaster.Spells.Detox
    end

    --[[
    if P4.IsSpellReady(Brewmaster.Spells.TouchOfDeath) and staggerPercent > 50 and healthPlayer > healthTarget then
        return Brewmaster.Spells.TouchOfDeath
    end
    ]]

    if chargesPurifyingBrew > 1 and not (staggerPercent == 0) then
        return Brewmaster.Spells.PurifyingBrew
    end
    if chargesPurifyingBrew > 0 and purifyingBrewCooldown < 1 and not (staggerPercent == 0) then
        return Brewmaster.Spells.PurifyingBrew
    end
    if staggerPercent > 50 and chargesPurifyingBrew > 0 then
        return Brewmaster.Spells.PurifyingBrew
    end


    if healthPercentPlayer < 70 and P4.IsSpellReady(Brewmaster.Spells.ExpelHarm) and healingSpheresCount > 3 then
        return Brewmaster.Spells.ExpelHarm
    end
    if healthPercentPlayer < 70 and P4.AuraTracker:UnitHas("player", Brewmaster.Buffs.VivaciousVivification) then
        return Brewmaster.Spells.Vivify
    end


    if healthPercentPlayer < 80 and chargesCelestialBrew > 0 and purifiedChiStacks > 3 and not P4.AuraTracker:UnitHas("player", Brewmaster.Buffs.CelestialBrewBuff) and not P4.AuraTracker:UnitHas("player", Brewmaster.Buffs.FortifyingBrewBuff) then
        return Brewmaster.Spells.CelestialBrew
    end


    if healthPercentPlayer < 60 and not P4.AuraTracker:UnitHas("player", Brewmaster.Buffs.FortifyingBrewBuff) and not P4.AuraTracker:UnitHas("player", Brewmaster.Buffs.CelestialBrewBuff)  and P4.IsSpellReady(Brewmaster.Spells.FortifyingBrew) then
        return Brewmaster.Spells.FortifyingBrew
    end

    return nil
end