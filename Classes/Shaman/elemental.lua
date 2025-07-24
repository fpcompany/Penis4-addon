Elem = {}
Shaman.specs[1] = Elem

Elem.Macros = {
}

Elem.Buffs = {
    Skyfury = 462854, -- Mastery buff & 20% multistrike
}

Elem.Spells = {
    Skyfury = 462854, -- Mastery buff & 20% multistrike
    AstralShift = 108271, -- 40% incoming damage reduction
    CleanseSpirit = 51886, -- dispel Curse effects
    StoneBulwarkTotem = 108270, -- shield self
}

Elem.priority = function()
    local healthPercentPlayer = 100 * (UnitHealth("player") / UnitHealthMax("player"))
    local dispelReady = P4.IsSpellReady(Elem.Spells.CleanseSpirit)
    local debuffedUnit = dispelReady and P4.AuraTracker:GetUnitWithDebuff(P4.Debuff.Curse)
    
    -- Focusing logic
    local action = P4.GetTarget(debuffedUnit)
    if action then return action end

    if healthPercentPlayer <= 60 and P4.IsSpellReady(Elem.Spells.StoneBulwarkTotem) then
        return Elem.Spells.StoneBulwarkTotem
    end

    -- Dispel the debuffed unit
    if debuffedUnit then -- if we are here, this means debuffed unit is in focus, no need to check
        P4.log("Purify Spirit on " .. tostring(debuffedUnit), P4.DEBUG)
        return Elem.Spells.CleanseSpirit
    end

        --[[BUFF]]
    if not P4.AuraTracker:EveryoneHas(RSham.Buffs.Skyfury) then
        P4.log("SKUF FURY (someone does not have it)", P4.DEBUG)
        return RSham.Spells.Skyfury
    end

    if healthPercentPlayer <= 50 then -- 50% hp
        if P4.IsItemReady(211879) then -- Algari Healing Potion
            P4.log("HP POTION (<50%)", P4.DEBUG)
            return P4.MacroSystem:GetMacroIDForMacro("HealingPotion")
        end
    end

    if healthPercentPlayer <= 49 and P4.IsSpellReady(Elem.Spells.AstralShift) then
        return Elem.Spells.AstralShift
    end

    if not P4.AuraTracker:EveryoneHas(Elem.Buffs.Skyfury) then
        P4.log("SKUF FURY (someone does not have it)", P4.DEBUG)
        return Elem.Spells.Skyfury
    end

end