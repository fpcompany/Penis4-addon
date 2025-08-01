Rdruid = {}
Druid.specs[4] = Rdruid --FIX

Rdruid.Macros = {
}

local function allyTargeted()
    return 
        UnitIsPlayer("target") and 
        (
            UnitIsUnit("target", "player") or 
            UnitInParty("target") or 
            UnitInRaid("target")
        )
end

local function unitHealthPercentage(unit)
    local current = UnitHealth(unit)
    local max = UnitHealthMax(unit)
    if max == 0 then
        return 0
    end
    return (current / max) * 100
end

local function unitManaPercentage(unit)
    local current = UnitPower("player", 0)
    local max = UnitPowerMax("player", 0)
    if max == 0 then
        return 0
    end
    return (current / max) * 100
end

local function targetIsTank()
    local role = UnitGroupRolesAssigned("focus")
    return role == "TANK"
end


Rdruid.Spells = {
    NaturesVigil = 124974,
    Innervate = 29166,
    Rebirth = 20484,
    Regrowth = 8936,
    MarkOfTheWild = 1126,
    Rejuvenation = 774,
    Renewal = 108238,
    WildGrowth = 48438,
    CenarionWard = 102351,
    Eflorescence = 145205,
    Barkskin = 22812,
    IronBark = 102342,
    ConvokeTheSpirits = 391528,
    GroveGuardians = 102693,
    Lifebloom = 188550,
    NaturesCure = 88423,
    NaturesSwiftness = 132158,
    Swiftmend = 18562,
    Revitalize = 212040,
    Tranquility = 740,
    Flourish = 197721,
    IncarnationTreeOfLife = 197721,
    MarkOfTheWild = 1126,
}

Rdruid.Buffs = {
    Barkskin = 22812,
    NaturesVigil = 124974,
    Innervate = 29166,
    Regrowth = 8936,
    MarkOfTheWild = 1126,
    Rejuvenation = 774,
    RejuvenationGermination = 155777,
    WildGrowth = 48438,
    CenarionWard = 102351,
    Eflorescence = 145205,
    IronBark = 102342,
    Lifebloom = 188550,
    NaturesSwiftness = 132158,
    Swiftmend = 383193,
    SoulOfTheForest = 114108,
    Tranquility = 157982,
    Flourish = 197721,
    ClearCasting = 16870,
    MarkOfTheWild = 1126,
    MarkOfTheWildNPCs = 432661, -- on Brann
}

Rdruid.priority = function()
    local groveGuardiansCharges, groveGuardiansMaxCharges = P4.GetSpellCharges(Rdruid.Spells.GroveGuardians)
    
    local myMana = unitManaPercentage("player")
    if myMana <= 10 and (P4.IsItemReady(212240) or P4.IsItemReady(212239) or P4.IsItemReady(212241)) then -- 10% mana
        P4.log("MANA POTION (<10%)", P4.DEBUG)
        return P4.MacroSystem:GetMacroIDForMacro("ManaPotion")
    end

    if not P4.AuraTracker:EveryoneHas(Feral.Buffs.MarkOfTheWild, Rdruid.Buffs.MarkOfTheWildNPCs) then
        P4.log("Lapka (someone does not have it)", P4.DEBUG)
        return Feral.Spells.MarkOfTheWild
    end

    if not P4.AuraTracker:UnitHas("player", Rdruid.Buffs.Eflorescence) and InCombatLockdown() then
        return Rdruid.Spells.Eflorescence
    end

    local unit = nil -- THIS UNIT WILL BE FOCUSED
    local mostDamagedUnit, mduHealth = P4.GroupTracker:Get()
    local lowHealthCount = P4.GroupTracker:CountBelowPercent(80)
    local naturesCureReady = P4.IsSpellReady(Rdruid.Spells.NaturesCure)
    local debuffedUnit = naturesCureReady and P4.AuraTracker:GetUnitWithDebuff(P4.Debuff.Magic, P4.Debuff.Curse, P4.Debuff.Poison)
    
    if debuffedUnit then
        unit = debuffedUnit
    elseif mduHealth <= 80 then
        unit = mostDamagedUnit
    end

    -- Focusing logic
    local action = P4.GetTarget(unit)
    if action then return action end

    -- Everyone is healthy and not debuffed / cant dispel yet, stop healing
    if mduHealth > 90 and not debuffedUnit then return nil end

    -- Dispel the debuffed unit
    if debuffedUnit then -- if we are here, this means debuffed unit is in focus, no need to check
        P4.log("Natures Cure on " .. tostring(debuffedUnit), P4.DEBUG)
        return Rdruid.Spells.NaturesCure
    end

    -- Healing Logic
    local myHealth = unitHealthPercentage("player")
    local groveGuardiansCharges, groveGuardiansMaxCharges = P4.GetSpellCharges(Rdruid.Spells.GroveGuardians)
    --[[local lifebloomReady = P4.IsSpellReady(Rdruid.Spells.Lifebloom)]]
    local focusHasLifebloom = P4.AuraTracker:UnitHas("focus", Rdruid.Buffs.Lifebloom)
    local rejuvenationReady = P4.IsSpellReady(Rdruid.Spells.Rejuvenation)
    local focusHasRejuvenation = P4.AuraTracker:UnitHas("focus", Rdruid.Buffs.Rejuvenation)
    --[[local regrowthReady = P4.IsSpellReady(Rdruid.Spells.Regrowth)]]
    local focusHasRegrowth = P4.AuraTracker:UnitHas("focus", Rdruid.Buffs.Regrowth)
    local naturesSwiftnessReady = P4.IsSpellReady(Rdruid.Spells.NaturesSwiftness)
    local hasNaturesSwiftness = P4.AuraTracker:UnitHas("player", Rdruid.Buffs.NaturesSwiftness)
    local swiftmendReady = P4.IsSpellReady(Rdruid.Spells.Swiftmend)
    local ironBarkReady = P4.IsSpellReady(Rdruid.Spells.IronBark)
    local focusHasIronBark = P4.AuraTracker:UnitHas("focus", Rdruid.Buffs.IronBark)
    local focusHasBarkskin = P4.AuraTracker:UnitHas("focus", Rdruid.Buffs.Barkskin)
    local barkskinReady = P4.IsSpellReady(Rdruid.Spells.Barkskin)
    local wildGrowthReady = P4.IsSpellReady(Rdruid.Spells.WildGrowth)
    local focusHasWildGrowth = P4.AuraTracker:UnitHas("focus", Rdruid.Buffs.WildGrowth)
    local tranquilityReady = P4.IsSpellReady(Rdruid.Spells.Tranquility)
    local cenarionWardReady = P4.IsSpellReady(Rdruid.Spells.CenarionWard)
    local hasTreant = GetTotemInfo(1)
    local groveGuardiansReady = P4.IsSpellReady(Rdruid.Spells.GroveGuardians)

    -- Protect self if party is in a pinch
    if (myHealth <= 70 and lowHealthCount >= 3) or (myHealth <= 50 and lowHealthCount <= 2) then
        if P4.IsSpellReady(Rdruid.Spells.Renewal) then
            return Rdruid.Spells.Renewal
        elseif barkskinReady then
            return Rdruid.Spells.Barkskin
        elseif myHealth <= 50 then -- 50% hp
            if P4.IsItemReady(211879) or P4.IsItemReady(21880) or P4.IsItemReady(211878) then -- Algari Healing Potion
                P4.log("HP POTION (<50%)", P4.DEBUG)
                return P4.MacroSystem:GetMacroIDForMacro("HealingPotion")
            end
        end
    end

    if IsPlayerMoving() then -- Running rotation
        if lowHealthCount <= 2 then -- Single rotation
            if mduHealth < 90 and not focusHasLifebloom then
                return Rdruid.Spells.Lifebloom
            elseif mduHealth < 80 and rejuvenationReady and not focusHasRejuvenation then
                return Rdruid.Spells.Rejuvenation
            elseif mduHealth < 50 and ironBarkReady and not focusHasIronBark and not focusHasBarkskin then
                return Rdruid.Spells.IronBark
            elseif mduHealth < 60 and cenarionWardReady then
                return Rdruid.Spells.CenarionWard
            elseif mduHealth < 60 and naturesSwiftnessReady then
                return Rdruid.Spells.NaturesSwiftness
            elseif mduHealth < 70 and hasNaturesSwiftness then
                return Rdruid.Spells.Regrowth
            end
        elseif lowHealthCount >= 3 then
            if naturesSwiftnessReady then
                return Rdruid.Spells.NaturesSwiftness
            elseif hasNaturesSwiftness then
                return Rdruid.Spells.WildGrowth
            elseif mduHealth < 90 and not focusHasLifebloom then
                return Rdruid.Spells.Lifebloom
            elseif mduHealth < 80 and rejuvenationReady and not focusHasRejuvenation then
                return Rdruid.Spells.Rejuvenation
            elseif mduHealth < 50 and ironBarkReady and not focusHasIronBark and not focusHasBarkskin then
                return Rdruid.Spells.IronBark
            elseif mduHealth < 60 and cenarionWardReady then
                return Rdruid.Spells.CenarionWard
            elseif mduHealth < 60 and naturesSwiftnessReady then
                return Rdruid.Spells.NaturesSwiftness
            elseif mduHealth < 70 and hasNaturesSwiftness then
                return Rdruid.Spells.Regrowth
            end
        end
    else -- Staying rotation
        if lowHealthCount <= 2 then -- Single rotation
            if mduHealth < 90 and not focusHasLifebloom then
                return Rdruid.Spells.Lifebloom
            elseif mduHealth < 80 and rejuvenationReady and not focusHasRejuvenation then
                return Rdruid.Spells.Rejuvenation
            elseif mduHealth < 50 and ironBarkReady and not focusHasIronBark and not focusHasBarkskin then
                return Rdruid.Spells.IronBark
            elseif mduHealth < 60 and cenarionWardReady then
                return Rdruid.Spells.CenarionWard
            elseif mduHealth < 60 then
                if swiftmendReady then
                    return Rdruid.Spells.Swiftmend
                elseif naturesSwiftnessReady then
                    return Rdruid.Spells.NaturesSwiftness
                end
            elseif mduHealth < 70 and not hasTreant and groveGuardiansCharges > 0 and groveGuardiansReady then
                return Rdruid.Spells.GroveGuardians
            elseif mduHealth < 70 then
                return Rdruid.Spells.Regrowth
            end
        elseif lowHealthCount >= 3 then
            elseif mduHealth < 50 and ironBarkReady and not focusHasIronBark and not focusHasBarkskin then
                return Rdruid.Spells.IronBark
            elseif mduHealth < 50 and tranquilityReady then
                return Rdruid.Spells.Tranquility
            elseif mduHealth < 60 and cenarionWardReady then
                return Rdruid.Spells.CenarionWard
            elseif mduHealth < 60 then
                if swiftmendReady then
                    return Rdruid.Spells.Swiftmend
                elseif naturesSwiftnessReady then
                    return Rdruid.Spells.NaturesSwiftness
                end
            elseif mduHealth < 70 and wildGrowthReady and not hasWildGrowth then
                return Rdruid.Spells.WildGrowth
            elseif mduHealth < 90 and not focusHasLifebloom then
                return Rdruid.Spells.Lifebloom
            elseif mduHealth < 80 and rejuvenationReady and not focusHasRejuvenation then
                return Rdruid.Spells.Rejuvenation
            elseif mduHealth < 70 and not hasTreant and groveGuardiansCharges > 0 and groveGuardiansReady then
                return Rdruid.Spells.GroveGuardians
            elseif mduHealth < 70 then
                return Rdruid.Spells.Regrowth
        end
    end

    if P4.PartybusterDanger() then
        if barkskinReady then
            return Rdruid.Spells.Barkskin
        end
    end

    return nil
end