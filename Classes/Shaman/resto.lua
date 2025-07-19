Resto = {}
Shaman.specs[3] = Resto

Resto.Macros = {
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

local function targetIsTank()
    local role = UnitGroupRolesAssigned("focus")
    return role == "TANK"
end


Resto.Spells = {
    HealingWave = 77472,
    Riptide = 61295,
    HealingSurge = 8004,
    HealingStreamTotem = 5394,
    EarthShield = 974,
    ChainHeal = 1064,
    SurgingTotem = 444995,
    LavaBurst = 51505,
    UnleashLife = 73685, -- next healing spell buffed
    CloudburstTotem = 157153, -- 2 charges, 39 sec cooldown
    EarthenWallTotem = 198838, -- 54 sec cooldown
    TotemicRecall = 108285, -- last totem cooldown reset, 2 min cooldown
    Wellspring = 197995, -- frontal cone heal
    HealingTideTotem = 108280, -- aoe heal every 1.9 sec, 2.2 min cooldown
    BulwarkTotem = 108270, -- shield self, 2.9 min cooldown
    Spiritwalker = 79206, -- cast when moving for 15 seconds, 1.5 min cooldown
}

Resto.Buffs = {
    EarthShield = 383648,
    Riptide = 61295, -- hot effect
    TidalWaves = 53390, -- 2 stacks here
    HighTide = 288675, -- Buffed Chain heal
    Downpour = 288675, -- Downpour can be cast
    MasterOfTheElements = 462377, -- Buffed Healing Surge
    Undulation = 216251, -- Buffed Healing Wave & Healing Surge
    LavaSurge = 77762, -- Free Lava Burst
}

Resto.priority = function()
    local hsTotemCharges, hsTotemMaxCharges = P4.GetSpellCharges(Resto.Spells.HealingStreamTotem)
    local nextHsTotem = P4.GetTimeUntilNextCharge(Resto.Spells.HealingStreamTotem)

    -- Target Select Logic
    local mostDamagedUnit, mduHealth = P4.GroupTracker:Get()
    local lowHealthCount = P4.GroupTracker:CountBelowPercent(80)
    if (mduHealth > 80) then -- Party is healthy, skip healing rotation

        if mduHealth <= 95 then -- Use Healing Stream Totem on cooldown for minor injuries
            if not IsPlayerSpell(157153) and (hsTotemCharges == 2 or (hsTotemCharges == 1 and nextHsTotem <= 18)) then
                P4.log("Healing Stream totem (do not overcap charges)", P4.SUCCESS)
                return Resto.Spells.HealingStreamTotem
            end
        end

        if UnitExists("focus") then
            return P4.MacroSystem:GetMacroIDForMacro("FocusClear")
        end
        return nil
    end
    if not UnitExists("focus") or not UnitIsUnit("focus", mostDamagedUnit) then
        return P4.MacroSystem:GetMacroIDForUnit(mostDamagedUnit)
    end

    -- Healing Logic
    local myHealth = unitHealthPercentage("player")
    local targetHealth = unitHealthPercentage("focus")
    local cbtTotemCharges, cbtTotemMaxCharges = P4.GetSpellCharges(Resto.Spells.CloudburstTotem)
    local cbtTotemReady = P4.IsSpellReady(Resto.Spells.CloudburstTotem)
    local htTotemReady = P4.IsSpellReady(Resto.Spells.HealingTideTotem)
    local hasTidalWaves = P4.selfBuff(Resto.Buffs.TidalWaves)
    local hasHighTide = P4.selfBuff(Resto.Buffs.HighTide)
    local hasDownpour = P4.selfBuff(Resto.Buffs.Downpour)
    local hasMasterOfTheElements = P4.selfBuff(Resto.Buffs.MasterOfTheElements)
    local hasUndulation = P4.selfBuff(Resto.Buffs.Undulation)
    local hasLavaSurge = P4.selfBuff(Resto.Buffs.LavaSurge)
    local targetHasRiptide = P4.UnitBuff("focus", Resto.Buffs.Riptide)
    local unleashLifeReady = P4.IsSpellReady(Resto.Spells.UnleashLife)
    local wellspringReady = P4.IsSpellReady(Resto.Spells.Wellspring)
    local earthenWallTotemReady = P4.IsSpellReady(Resto.Spells.EarthenWallTotem)
    local masterOfTheElementsLearned = IsPlayerSpell(462375)
    local ancestralReachLearned = IsPlayerSpell(382732)
    local spiritwalkerReady = P4.IsSpellReady(Resto.Spells.Spiritwalker)

    -- Need to disable Hekili's Spiritwalker's grace recommendation
    if IsPlayerMoving() and spiritwalkerReady then
        P4.log("Spiritwalker's grace (moving)", P4.SUCCESS)
        return Resto.Spells.Spiritwalker
    end

    -- Protect self if party is in a pinch
    if P4.IsSpellReady(Resto.Spells.BulwarkTotem) and
    ((myHealth <= 70 and lowHealthCount >= 3) or
        (myHealth <= 70 and lowHealthCount >= 2 and mduHealth <= 50)) then
            P4.log("Bulwark totem (save self)", P4.SUCCESS)
            return Resto.Spells.BulwarkTotem
    end

    -- Use CBT totem on cooldown
    if cbtTotemReady and cbtTotemCharges == 2 then
        P4.log("CBT totem (2 charges)", P4.SUCCESS)
        return Resto.Spells.CloudburstTotem
    end

    -- Generate Master of the elements with incast lava burst (only if target is attackable)
    if mduHealth >= 70 and masterOfTheElementsLearned and not hasMasterOfTheElements and hasLavaSurge 
        and UnitExists("target") and UnitCanAttack("player", "target")then
        P4.log("Lava Burst (consume lava surge)", P4.SUCCESS)
        return Resto.Spells.LavaBurst
    end

    -- Keep Earth Shield on the tank
    --[[if targetIsTank() and not P4.UnitBuff("target", Resto.Buffs.EarthShield) then
        P4.log("Rebuff Earth Shield on Tank", P4.SUCCESS)
        return Resto.Spells.EarthShield
    end]]

    -- Unleash life to buff heals
    if unleashLifeReady then
        P4.log("Unleash Life (on cooldown)", P4.SUCCESS)
        return Resto.Spells.UnleashLife
    end

    -- Consume Downpour (BUGGY)
    --[[if hasDownpour and lowHealthCount >= 3 then
        P4.log("Surging Totem (Consume Downpour)", P4.SUCCESS)
        return Resto.Spells.SurgingTotem
    end]]

    -- Chain Heal if High Tide procced
    if hasHighTide and lowHealthCount >= 3 then
        P4.log("Chain Heal (has High Tide and 3 people injired)", P4.SUCCESS)
        return Resto.Spells.ChainHeal
    end
    
    -- Use Wellspring after AOE
    if wellspringReady and lowHealthCount >= 4 then
        P4.log("Wellspring (4 players are hurt)", P4.SUCCESS)
        return Resto.Spells.Wellspring
    end

    -- Use Healing Tide totem after AOE
    if htTotemReady and lowHealthCount >= 4 then
        P4.log("Healing Tide Totem (4 players are hurt)", P4.SUCCESS)
        return Resto.Spells.HealingTideTotem
    end

    -- Buffed Healing Surge
    if hasMasterOfTheElements then
        P4.log("Healing Surge (Consume Master of the Elements)", P4.SUCCESS)
        return Resto.Spells.HealingSurge
    end

    -- Use Riptide if available and target not affected by Riptide, or if dont have Tidal Waves stacks
    if P4.IsSpellReady(Resto.Spells.Riptide) and (not targetHasRiptide or not hasTidalWaves) then
        P4.log("Riptide (tidal = " .. tostring(hasTidalWaves) .. ", has buff = " .. tostring(targetHasRiptide) .. ")", P4.SUCCESS)
        return Resto.Spells.Riptide
    end

    -- Keep Earthen Wall Totem on cooldown
    if earthenWallTotemReady then
        return Resto.Spells.EarthenWallTotem
    end

    -- Consume Undulation
    if hasUndulation then
        P4.log("Healing Surge (consume Undulation)", P4.SUCCESS)
        return Resto.Spells.HealingSurge
    end

    -- If 3 or more people are injured, use Chain Heal
    if ancestralReachLearned and lowHealthCount > 3 then
        P4.log("Chain Heal (at least 3 party members)", P4.SUCCESS)
        return Resto.Spells.ChainHeal
    end

    if mduHealth >= 70 and lowHealthCount <= 2 then 
        return Resto.Spells.HealingWave
    else
        return Resto.Spells.HealingSurge
    end

    return nil
end

Resto.Setup = function ()
    print("resto setup")
end
