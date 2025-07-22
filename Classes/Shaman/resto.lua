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
    Skyfury = 462854, -- Mastery buff & 20% multistrike
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
    Skyfury = 462854, -- Mastery buff & 20% multistrike
}

RSham.priority = function()
    local myHealth = unitHealthPercentage("player")
    local myMana = unitManaPercentage("player")

    if myHealth <= 50 then -- 50% hp
        if P4.IsItemReady(5512) then -- Warlock's Healthstone 
            P4.log("HEALTHSTONE (<50%)", P4.DEBUG)
            return P4.MacroSYstem:GetMacroIDForMacro("Healthstone")
        end
        if P4.IsItemReady(211879) then -- Algari Healing Potion
            P4.log("HP POTION (<50%)", P4.DEBUG)
            return P4.MacroSystem:GetMacroIDForMacro("HealingPotion")
        end
    end

    if myMana <= 10 and P4.IsItemReady(212240) then -- 10% mana
        P4.log("MANA POTION (<10%)", P4.DEBUG)
        return P4.MacroSystem:GetMacroIDForMacro("ManaPotion")
    end

    if not P4.AuraTracker:EveryoneHas(RSham.Buffs.Skyfury) then
        P4.log("SKUF FURY (someone does not have it)", P4.DEBUG)
        return RSham.Spells.Skyfury
    end

    -- TARGET SELECT LOGIC
    local action, mostDamagedUnit, mduHealth, lowHealthCount, debuffedUnit = GetHealingState(80, 80, RSham.Spells.PurifySpirit, P4.Debuff.Magic, P4.Debuff.Curse)
    if action then return action end

    if mduHealth <= 95 then -- Use Healing Stream Totem on cooldown for minor injuries
        local nextHsTotem = P4.GetTimeUntilNextCharge(RSham.Spells.HealingStreamTotem)
        local hsTotemReady = P4.IsSpellReady(RSham.Spells.HealingStreamTotem)

        if not IsPlayerSpell(157153) -- Cloudburst Totem (if not talented)
        and not P4.IsTotemActive(RSham.Spells.HealingStreamTotem) and hsTotemReady then
            P4.log("Healing Stream Totem (not currently active)", P4.DEBUG)
            return RSham.Spells.HealingStreamTotem
        end
    end

    if mduHealth > 80 and not debuffedUnit then return nil end

    -- Dispel the debuffed unit
    if debuffedUnit and UnitIsUnit("focus", debuffedUnit) then
        P4.log("Purify Spirit on " .. tostring(debuffedUnit), P4.DEBUG)
        return RSham.Spells.PurifySpirit
    end

    -- Healing Logic

    local targetHealth = unitHealthPercentage("focus")
    local cbtTotemReady = P4.IsSpellReady(RSham.Spells.CloudburstTotem)
    local htTotemReady = P4.IsSpellReady(RSham.Spells.HealingTideTotem)
    local hasTidalWaves = P4.AuraTracker:UnitHas("player", RSham.Buffs.TidalWaves)
    local hasHighTide = P4.AuraTracker:UnitHas("player", RSham.Buffs.HighTide)
    local hasDownpour = P4.AuraTracker:UnitHas("player", RSham.Buffs.Downpour)
    local hasMasterOfTheElements = P4.AuraTracker:UnitHas("player", RSham.Buffs.MasterOfTheElements)
    local hasUndulation = P4.AuraTracker:UnitHas("player", RSham.Buffs.Undulation)
    local hasLavaSurge = P4.AuraTracker:UnitHas("player", RSham.Buffs.LavaSurge)
    local targetHasRiptide = P4.AuraTracker:UnitHas("focus", RSham.Buffs.Riptide)
    local unleashLifeReady = P4.IsSpellReady(RSham.Spells.UnleashLife)
    local wellspringReady = P4.IsSpellReady(RSham.Spells.Wellspring)
    local earthenWallTotemReady = P4.IsSpellReady(RSham.Spells.EarthenWallTotem)
    local masterOfTheElementsLearned = IsPlayerSpell(462375)
    local ancestralReachLearned = IsPlayerSpell(382732)
    local spiritwalkerReady = P4.IsSpellReady(RSham.Spells.Spiritwalker)

    -- Need to disable Hekili's Spiritwalker's grace recommendation
    if IsPlayerMoving() and spiritwalkerReady then
        P4.log("Spiritwalker's grace (moving)", P4.DEBUG)
        return RSham.Spells.Spiritwalker
    end

    -- Protect self if party is in a pinch
    if P4.IsSpellReady(RSham.Spells.BulwarkTotem) and
    ((myHealth <= 70 and lowHealthCount >= 3) or
        (myHealth <= 70 and lowHealthCount >= 2 and mduHealth <= 50)) then
            P4.log("Bulwark totem (save self)", P4.DEBUG)
            return RSham.Spells.BulwarkTotem
    end

    --CBT Totem
    if cbtTotemReady and not P4.IsTotemActiveByName(RSham.Spells.CloudburstTotem) then
        P4.log("CBT totem (not active)", P4.DEBUG)
        return RSham.Spells.CloudburstTotem
    end

    -- Generate Master of the elements with incast lava burst (only if target is attackable)
    if mduHealth >= 70 and masterOfTheElementsLearned and not hasMasterOfTheElements and hasLavaSurge 
        and UnitExists("target") and UnitCanAttack("player", "target")then
        P4.log("Lava Burst (consume lava surge)", P4.DEBUG)
        return RSham.Spells.LavaBurst
    end

    -- Keep Earth Shield on the tank
    --[[if targetIsTank() and not P4.AuraTracker:UnitHas("target", RSham.Buffs.EarthShield) then
        P4.log("Rebuff Earth Shield on Tank", P4.DEBUG)
        return RSham.Spells.EarthShield
    end]]

    -- Unleash life to buff heals
    if unleashLifeReady then
        P4.log("Unleash Life (on cooldown)", P4.DEBUG)
        return RSham.Spells.UnleashLife
    end

    -- Consume Downpour (BUGGY)
    --[[if hasDownpour and lowHealthCount >= 3 then
        P4.log("Surging Totem (Consume Downpour)", P4.DEBUG)
        return RSham.Spells.SurgingTotem
    end]]

    -- Chain Heal if High Tide procced
    if hasHighTide and lowHealthCount >= 3 then
        P4.log("Chain Heal (has High Tide and 3 people injired)", P4.DEBUG)
        return RSham.Spells.ChainHeal
    end
    
    -- Use Wellspring after AOE
    if wellspringReady and lowHealthCount >= 4 then
        P4.log("Wellspring (4 players are hurt)", P4.DEBUG)
        return RSham.Spells.Wellspring
    end

    -- Use Healing Tide totem after AOE
    if htTotemReady and lowHealthCount >= 4 then
        P4.log("Healing Tide Totem (4 players are hurt)", P4.DEBUG)
        return RSham.Spells.HealingTideTotem
    end

    -- Buffed Healing Surge
    if hasMasterOfTheElements then
        P4.log("Healing Surge (Consume Master of the Elements)", P4.DEBUG)
        return RSham.Spells.HealingSurge
    end

    -- Use Riptide if available and target not affected by Riptide, or if dont have Tidal Waves stacks
    if P4.IsSpellReady(RSham.Spells.Riptide) and (not targetHasRiptide or not hasTidalWaves) then
        P4.log("Riptide (tidal = " .. tostring(hasTidalWaves) .. ", has buff = " .. tostring(targetHasRiptide) .. ")", P4.DEBUG)
        return RSham.Spells.Riptide
    end

    -- Keep Earthen Wall Totem on cooldown
    if earthenWallTotemReady and lowHealthCount >= 3 then
        return RSham.Spells.EarthenWallTotem
    end

    -- Consume Undulation
    if hasUndulation then
        P4.log("Healing Surge (consume Undulation)", P4.DEBUG)
        return RSham.Spells.HealingSurge
    end

    -- If 3 or more people are injured, use Chain Heal
    if ancestralReachLearned and lowHealthCount > 3 then
        P4.log("Chain Heal (at least 3 party members)", P4.DEBUG)
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
