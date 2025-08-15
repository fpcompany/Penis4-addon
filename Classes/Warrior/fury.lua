Fury = {}
Warrior.specs[2] = Fury

Fury.Macros = {
}

Fury.Setup = function ()
end

Fury.Spells = {
    BattleShout = 6673,
    BerserkerRage = 18499,
    SpellReflection = 23920,
    BerserkerStance = 386196,
    RallyingCry = 97462,
    DefensiveStance = 386208,
    EnragedRegeneration = 184364,
    ImpendingVictory = 202168,
}

Fury.Buffs = {
    BattleShout = 6673,
    BerserkerRage = 18499,
    SpellReflection = 23920,
    BerserkerStance = 386196,
    DefensiveStance = 386208,
    RallyingCry = 97463,
    EnragedRegeneration = 184364,
}

Fury.priority = function()
    local rage = UnitPower("player", 1)
    local myHealth = 100 * (UnitHealth("player") / UnitHealthMax("player"))    
    local targetHealth = 100 * (UnitHealth("target") / UnitHealthMax("target"))
    local berserkerRageReady = P4.IsSpellReady(Fury.Spells.BerserkerRage)
    local hasBerserkerRage = P4.AuraTracker:UnitHas("player", Fury.Buffs.BerserkerRage)
    local spellReflectionReady = P4.IsSpellReady(Fury.Spells.SpellReflection)
    local berserkerStanceReady = P4.IsSpellReady(Fury.Spells.BerserkerStance)
    local hasBerserkerStance = P4.AuraTracker:UnitHas("player", Fury.Buffs.BerserkerStance)
    local defensiveStanceReady = P4.IsSpellReady(Fury.Spells.DefensiveStance)
    local hasDefensiveStance = P4.AuraTracker:UnitHas("player", Fury.Buffs.DefensiveStance)
    local rallyingCryReady = P4.IsSpellReady(Fury.Spells.RallyingCry)
    local enragedRegenerationReady = P4.IsSpellReady(Fury.Spells.EnragedRegeneration)
    local hasEnragedRegeneration = P4.AuraTracker:UnitHas("player", Fury.Buffs.EnragedRegeneration)
    local impendingVictoryReady = P4.IsSpellReady(Fury.Spells.ImpendingVictory)

    if not P4.AuraTracker:EveryoneHas(Fury.Buffs.BattleShout) then
        P4.log("AP (someone does not have it)", P4.DEBUG)
        return Fury.Spells.BattleShout
    end

    if myHealth > 50 and berserkerStanceReady and not hasBerserkerStance then
        return Fury.Spells.BerserkerStance
    end

    if myHealth < 70 and impendingVictoryReady and rage > 9 then
        return Fury.Spells.ImpendingVictory
    end

    if myHealth <= 50 then
        if P4.IsHealingPotionReady() then
            P4.log("HP POTION (<50%)", P4.DEBUG)
            return P4.MacroSystem:GetMacroIDForMacro("HealingPotion")
        elseif enragedRegenerationReady then
            return Fury.Spells.EnragedRegeneration
        elseif not hasFrenziedRegeneration and not hasDefensiveStance then
            return Fury.Spells.DefensiveStance
        end
    end

    if myHealth < 30 and rallyingCryReady then
            return Fury.Spells.RallyingCry
    end

    local physPartyBuster, magicPartyBuster = P4.PartybusterDanger()
    if physPartyBuster then
        if magicPartyBuster and spellReflectionReady and not hasEnragedRegeneration then
            return Fury.Spells.SpellReflection
        elseif enragedRegenerationReady then
            return Fury.Spells.EnragedRegeneration
        elseif not hasDefensiveStance and not hasEnragedRegeneration then
            return Fury.Spells.DefensiveStance
        end
    end

    return nil
end