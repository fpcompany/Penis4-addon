RSham = {}
Shaman.specs[3] = RSham

RSham.Macros = {
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


RSham.Spells = {
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
    PurifySpirit = 77130, -- Dispel
}

RSham.Buffs = {
    EarthShield = 383648,
    Riptide = 61295, -- hot effect
    TidalWaves = 53390, -- 2 stacks here
    HighTide = 288675, -- Buffed Chain heal
    Downpour = 288675, -- Downpour can be cast
    MasterOfTheElements = 462377, -- Buffed Healing Surge
    Undulation = 216251, -- Buffed Healing Wave & Healing Surge
    LavaSurge = 77762, -- Free Lava Burst
}

RSham.priority = function()
    local hsTotemCharges, hsTotemMaxCharges = P4.GetSpellCharges(RSham.Spells.HealingStreamTotem)
    local nextHsTotem = P4.GetTimeUntilNextCharge(RSham.Spells.HealingStreamTotem)
    local purifySpiritReady = P4.IsSpellReady(RSham.Spells.PurifySpirit)

    -- Target Select Logic
    local mostDamagedUnit, mduHealth = P4.GroupTracker:Get()
    local lowHealthCount = P4.GroupTracker:CountBelowPercent(80)
    local debuffedUnit = P4.GroupTracker:GetUnitWithDebuff(P4.Debuff.Magic, P4.Debuff.Curse)

    if (mduHealth > 80 and not debuffedUnit) then -- Party is healthy, skip healing rotation

        if mduHealth <= 95 then -- Use Healing Stream Totem on cooldown for minor injuries
            if not IsPlayerSpell(157153) and (hsTotemCharges == 2 or (hsTotemCharges == 1 and nextHsTotem <= 18)) then
                P4.log("Healing Stream totem (do not overcap charges)", P4.SUCCESS)
                return RSham.Spells.HealingStreamTotem
            end
        end

        if UnitExists("focus") then
            P4.log("Defocus", P4.SUCCESS)
            return P4.MacroSystem:GetMacroIDForMacro("FocusClear")
        end
        return nil
    end
    -- If no focused, or focus is not MDU or (focus is not Debuffed)
    if not UnitExists("focus") or 
        not UnitIsUnit("focus", mostDamagedUnit) or 
        (debuffedUnit and not UnitIsUnit("focus", debuffedUnit)) then
        if debuffedUnit and purifySpiritReady then
            P4.log("Focus DEBUFFED = " .. tostring(debuffedUnit) .. "Focus=debuffed? " .. tostring(UnitIsUnit("focus", debuffedUnit)), P4.SUCCESS)
            return P4.MacroSystem:GetMacroIDForUnit(debuffedUnit)
        end
        if mduHealth <= 80 then
            P4.log("Focus MDU", P4.SUCCESS)
            return P4.MacroSystem:GetMacroIDForUnit(mostDamagedUnit)
        end
        return nil
    end

    -- Dispel the debuffed unit
    if debuffedUnit and UnitIsUnit("focus", debuffedUnit) then
        P4.log("Purify Spirit on " .. tostring(debuffedUnit), P4.SUCCESS)
        return RSham.Spells.PurifySpirit
    end

    -- Healing Logic
    local myHealth = unitHealthPercentage("player")
    local targetHealth = unitHealthPercentage("focus")
    local cbtTotemCharges, cbtTotemMaxCharges = P4.GetSpellCharges(RSham.Spells.CloudburstTotem)
    local cbtTotemReady = P4.IsSpellReady(RSham.Spells.CloudburstTotem)
    local htTotemReady = P4.IsSpellReady(RSham.Spells.HealingTideTotem)
    local hasTidalWaves = P4.selfBuff(RSham.Buffs.TidalWaves)
    local hasHighTide = P4.selfBuff(RSham.Buffs.HighTide)
    local hasDownpour = P4.selfBuff(RSham.Buffs.Downpour)
    local hasMasterOfTheElements = P4.selfBuff(RSham.Buffs.MasterOfTheElements)
    local hasUndulation = P4.selfBuff(RSham.Buffs.Undulation)
    local hasLavaSurge = P4.selfBuff(RSham.Buffs.LavaSurge)
    local targetHasRiptide = P4.UnitBuff("focus", RSham.Buffs.Riptide)
    local unleashLifeReady = P4.IsSpellReady(RSham.Spells.UnleashLife)
    local wellspringReady = P4.IsSpellReady(RSham.Spells.Wellspring)
    local earthenWallTotemReady = P4.IsSpellReady(RSham.Spells.EarthenWallTotem)
    local masterOfTheElementsLearned = IsPlayerSpell(462375)
    local ancestralReachLearned = IsPlayerSpell(382732)
    local spiritwalkerReady = P4.IsSpellReady(RSham.Spells.Spiritwalker)

    -- Need to disable Hekili's Spiritwalker's grace recommendation
    if IsPlayerMoving() and spiritwalkerReady then
        P4.log("Spiritwalker's grace (moving)", P4.SUCCESS)
        return RSham.Spells.Spiritwalker
    end

    -- Protect self if party is in a pinch
    if P4.IsSpellReady(RSham.Spells.BulwarkTotem) and
    ((myHealth <= 70 and lowHealthCount >= 3) or
        (myHealth <= 70 and lowHealthCount >= 2 and mduHealth <= 50)) then
            P4.log("Bulwark totem (save self)", P4.SUCCESS)
            return RSham.Spells.BulwarkTotem
    end

    -- Use CBT totem on cooldown
    if cbtTotemReady and cbtTotemCharges == 2 then
        P4.log("CBT totem (2 charges)", P4.SUCCESS)
        return RSham.Spells.CloudburstTotem
    end

    -- Generate Master of the elements with incast lava burst (only if target is attackable)
    if mduHealth >= 70 and masterOfTheElementsLearned and not hasMasterOfTheElements and hasLavaSurge 
        and UnitExists("target") and UnitCanAttack("player", "target")then
        P4.log("Lava Burst (consume lava surge)", P4.SUCCESS)
        return RSham.Spells.LavaBurst
    end

    -- Keep Earth Shield on the tank
    --[[if targetIsTank() and not P4.UnitBuff("target", RSham.Buffs.EarthShield) then
        P4.log("Rebuff Earth Shield on Tank", P4.SUCCESS)
        return RSham.Spells.EarthShield
    end]]

    -- Unleash life to buff heals
    if unleashLifeReady then
        P4.log("Unleash Life (on cooldown)", P4.SUCCESS)
        return RSham.Spells.UnleashLife
    end

    -- Consume Downpour (BUGGY)
    --[[if hasDownpour and lowHealthCount >= 3 then
        P4.log("Surging Totem (Consume Downpour)", P4.SUCCESS)
        return RSham.Spells.SurgingTotem
    end]]

    -- Chain Heal if High Tide procced
    if hasHighTide and lowHealthCount >= 3 then
        P4.log("Chain Heal (has High Tide and 3 people injired)", P4.SUCCESS)
        return RSham.Spells.ChainHeal
    end
    
    -- Use Wellspring after AOE
    if wellspringReady and lowHealthCount >= 4 then
        P4.log("Wellspring (4 players are hurt)", P4.SUCCESS)
        return RSham.Spells.Wellspring
    end

    -- Use Healing Tide totem after AOE
    if htTotemReady and lowHealthCount >= 4 then
        P4.log("Healing Tide Totem (4 players are hurt)", P4.SUCCESS)
        return RSham.Spells.HealingTideTotem
    end

    -- Buffed Healing Surge
    if hasMasterOfTheElements then
        P4.log("Healing Surge (Consume Master of the Elements)", P4.SUCCESS)
        return RSham.Spells.HealingSurge
    end

    -- Use Riptide if available and target not affected by Riptide, or if dont have Tidal Waves stacks
    if P4.IsSpellReady(RSham.Spells.Riptide) and (not targetHasRiptide or not hasTidalWaves) then
        P4.log("Riptide (tidal = " .. tostring(hasTidalWaves) .. ", has buff = " .. tostring(targetHasRiptide) .. ")", P4.SUCCESS)
        return RSham.Spells.Riptide
    end

    -- Keep Earthen Wall Totem on cooldown
    if earthenWallTotemReady and lowHealthCount >= 3 then
        return RSham.Spells.EarthenWallTotem
    end

    -- Consume Undulation
    if hasUndulation then
        P4.log("Healing Surge (consume Undulation)", P4.SUCCESS)
        return RSham.Spells.HealingSurge
    end

    -- If 3 or more people are injured, use Chain Heal
    if ancestralReachLearned and lowHealthCount > 3 then
        P4.log("Chain Heal (at least 3 party members)", P4.SUCCESS)
        return RSham.Spells.ChainHeal
    end

    if mduHealth >= 70 and lowHealthCount <= 2 then 
        return RSham.Spells.HealingWave
    else
        return RSham.Spells.HealingSurge
    end

    return nil
end

RSham.Setup = function ()
    -- Patch Hekili to add missing spell
    Hekili:GetSpecialization(264):RegisterAbilities({
        purify_spirit = {
            id = 77130,
            cast = 0,
            cooldown = 8,
            gcd = "spell",
            spend = 0.07,
            spendType = "mana",
            startsCombat = false,
            texture = 136043,

            handler = function()
            end
        },
    })
end
