RSham = {}
Shaman.specs[3] = RSham

RSham.Macros = {
}

RSham.Spells = {
    HealingWave = 77472,        -- inexpensive slow heal
    Riptide = 61295,            -- hot effect
    HealingSurge = 8004,        -- expensive fast heal
    HealingStreamTotem = 5394,  -- auto-heals an ally every 1.8 sec
    EarthShield = 974,          -- affected ally heals when takes damage
    ChainHeal = 1064,           -- autotarget aoe heal
    SurgingTotem = 444995,      -- core totemic talent, replaces healing rain
    LavaBurst = 51505,          -- single target nuke
    UnleashLife = 73685,        -- next healing spell buffed
    CloudburstTotem = 157153,   -- 2 charges, 39 sec cooldown
    EarthenWallTotem = 198838,  -- 54 sec cooldown
    TotemicRecall = 108285,     -- last totem cooldown reset, 2 min cooldown
    Wellspring = 197995,        -- frontal cone heal
    HealingTideTotem = 108280,  -- aoe heal every 1.9 sec, 2.2 min cooldown
    BulwarkTotem = 108270,      -- shield self, 2.9 min cooldown
    Spiritwalker = 79206,       -- cast when moving for 15 seconds, 1.5 min cooldown
    PurifySpirit = 77130,       -- Dispel
    Skyfury = 462854,           -- Mastery buff & 20% multistrike
}

RSham.Buffs = {
    EarthShield = 383648,       -- shield effect ON ME
    EarthShieldALLY = 974,      -- shield effect ON ALLIES
    Riptide = 61295,            -- hot effect
    TidalWaves = 53390,         -- 2 stacks here
    HighTide = 288675,          -- Buffed Chain heal
    Downpour = 462488,          -- Downpour can be cast
    MasterOTElements = 462377,  -- Buffed Healing Surge
    Undulation = 216251,        -- Buffed Healing Wave & Healing Surge
    LavaSurge = 77762,          -- Free Lava Burst
    Skyfury = 462854,           -- Mastery buff & 20% multistrike
}

RSham.priority = function()
    local healthMax = UnitHealthMax("player")
    local myHealth = healthMax > 0 and 100 * (UnitHealth("player") / healthMax) or 0
    local myMana = 100 * (UnitPower("player", 0) / UnitPowerMax("player", 0))

    --[[HEALING POTION]]
    if myHealth <= 50 then
        if P4.IsItemReady(211879) or P4.IsItemReady(21880) or P4.IsItemReady(211878) then -- Algari Healing Potion
            P4.log("HP POTION (<50%)", P4.DEBUG)
            return P4.MacroSystem:GetMacroIDForMacro("HealingPotion")
        end
    end
    
    --[[MANA POTION]]
    if myMana <= 10 and (P4.IsItemReady(212240) or P4.IsItemReady(212239) or P4.IsItemReady(212241)) then -- 10% mana
        P4.log("MANA POTION (<10%)", P4.DEBUG)
        return P4.MacroSystem:GetMacroIDForMacro("ManaPotion")
    end

    --[[BUFF]]
    if not P4.AuraTracker:EveryoneHas(RSham.Buffs.Skyfury) then
        P4.log("SKUF FURY (someone does not have it)", P4.DEBUG)
        return RSham.Spells.Skyfury
    end

    local unit = nil -- THIS UNIT WILL BE FOCUSED
    local mostDamagedUnit, mduHealth = P4.GroupTracker:Get()
    local lowHealthCount = P4.GroupTracker:CountBelowPercent(80)
    local dispelReady = P4.IsSpellReady(RSham.Spells.PurifySpirit)
    local debuffedUnit = dispelReady and P4.AuraTracker:GetUnitWithDebuff(P4.Debuff.Magic, P4.Debuff.Curse)
    
    --[[SHAMAN: Use Healing Stream Totem on cooldown for minor injuries]]
    if mduHealth <= 95 and not IsPlayerSpell(RSham.Spells.CloudburstTotem) and not P4.IsTotemActive(RSham.Spells.HealingStreamTotem)then
        if P4.IsSpellReady(RSham.Spells.HealingStreamTotem) then
            P4.log("Healing Stream Totem (not currently active)", P4.DEBUG)
            return RSham.Spells.HealingStreamTotem
        end
    end

    if debuffedUnit then
        unit = debuffedUnit
    elseif mduHealth <= 80 then
        unit = mostDamagedUnit
    end

    -- Keep Earth Shield on the tank. On allies, we use EarthShieldALLY which is the same as Spells.EarthShield
    local tank = P4.GroupTracker:GetTank()
    if tank and not P4.AuraTracker:UnitHas(tank, RSham.Buffs.EarthShieldALLY) then
        if not UnitIsUnit("focus", tank) then
            unit = tank -- override unit for ACTION so its gonna get focused instead of mdu/debuffedUnit
        else
            return RSham.Spells.EarthShield
        end
    end

    -- Focusing logic
    local action = P4.GetTarget(unit)
    if action then return action end

    -- Everyone is healthy and not debuffed / cant dispel yet, stop healing
    if mduHealth > 80 and not debuffedUnit then return nil end

    -- Fireblood (Poison, Disease, Curse, Magic, Bleed)
    -- Shaman's dispel removes Magic and Curse
    local firebloodReady = P4.IsSpellReady(Common.Spells.Fireblood)
    local debuffsOnMe = P4.AuraTracker:GetActiveDebuffTypes("player")
    if firebloodReady and (tContains(debuffsOnMe, P4.Debuff.Poison) or tContains(debuffsOnMe, P4.Debuff.Disease) or tContains(debuffsOnMe, P4.Debuff.Bleed)
        --[[or not dispelReady and tContains(debuffsOnMe, P4.Debuff.Magic) or tContains(debuffsOnMe, P4.Debuff.Curse)]]) then
        return Common.Spells.Fireblood
    end

    -- Dispel the debuffed unit
    if debuffedUnit then -- if we are here, this means debuffed unit is in focus, no need to check
        P4.log("Purify Spirit on " .. tostring(debuffedUnit), P4.DEBUG)
        return RSham.Spells.PurifySpirit
    end

    -- Healing Logic
    local targetHealthMax = UnitHealthMax("focus")
    local targetHealth = targetHealthMax > 0 and 100 * (UnitHealth("focus") / targetHealthMax) or 0
    local cbtTotemReady = P4.IsSpellReady(RSham.Spells.CloudburstTotem)
    local htTotemReady = P4.IsSpellReady(RSham.Spells.HealingTideTotem)
    local hasTidalWaves = P4.AuraTracker:UnitHas("player", RSham.Buffs.TidalWaves)
    local hasHighTide = P4.AuraTracker:UnitHas("player", RSham.Buffs.HighTide)
    local hasDownpour = P4.AuraTracker:UnitHas("player", RSham.Buffs.Downpour)
    local hasMasterOTElements = P4.AuraTracker:UnitHas("player", RSham.Buffs.MasterOTElements)
    local hasUndulation = P4.AuraTracker:UnitHas("player", RSham.Buffs.Undulation)
    local hasLavaSurge = P4.AuraTracker:UnitHas("player", RSham.Buffs.LavaSurge)
    local targetHasRiptide = P4.AuraTracker:UnitHas("focus", RSham.Buffs.Riptide)
    local unleashLifeReady = P4.IsSpellReady(RSham.Spells.UnleashLife)
    local wellspringReady = P4.IsSpellReady(RSham.Spells.Wellspring)
    local earthenWallTotemReady = P4.IsSpellReady(RSham.Spells.EarthenWallTotem)
    local MasterOTElementsLearned = IsPlayerSpell(462375)
    local ancestralReachLearned = IsPlayerSpell(382732)
    local spiritwalkerReady = P4.IsSpellReady(RSham.Spells.Spiritwalker)

    -- Need to disable Hekili's Spiritwalker's grace recommendation
    if IsPlayerMoving() and spiritwalkerReady then
        return RSham.Spells.Spiritwalker
    end

    -- Protect self if party is in a pinch
    if P4.IsSpellReady(RSham.Spells.BulwarkTotem) and
        ((myHealth <= 70 and lowHealthCount >= 3) or
        (myHealth <= 70 and lowHealthCount >= 2 and mduHealth <= 50) or
        myHealth <= 30) then
            return RSham.Spells.BulwarkTotem
    end

    -- CBT Totem
    if cbtTotemReady and not P4.IsTotemActiveByName(RSham.Spells.CloudburstTotem) then
        return RSham.Spells.CloudburstTotem
    end

    -- Generate Master of the elements with incast lava burst (only if target is attackable)
    if mduHealth >= 70 and MasterOTElementsLearned and not hasMasterOTElements and hasLavaSurge 
        and UnitExists("target") and UnitCanAttack("player", "target")then
        return RSham.Spells.LavaBurst
    end

    -- Unleash life to buff heals
    if unleashLifeReady and mduHealth <= 60 then
        return RSham.Spells.UnleashLife
    end

    -- Consume Downpour
    if hasDownpour --[[and lowHealthCount >= 3]] then
        return RSham.Spells.SurgingTotem
    end

    -- Chain Heal if High Tide procced
    if hasHighTide and lowHealthCount >= 2 then
        return RSham.Spells.ChainHeal
    end
    
    -- Use Wellspring after AOE
    if wellspringReady and lowHealthCount >= 4 then
        return RSham.Spells.Wellspring
    end

    -- Use Healing Tide totem after AOE
    if htTotemReady and lowHealthCount >= 4 then
        return RSham.Spells.HealingTideTotem
    end

    -- Buffed Healing Surge
    if hasMasterOTElements then
        return RSham.Spells.HealingSurge
    end

    -- Use Riptide if available and target not affected by Riptide, or if dont have Tidal Waves stacks
    if P4.IsSpellReady(RSham.Spells.Riptide) and (not targetHasRiptide or not hasTidalWaves) then
        return RSham.Spells.Riptide
    end

    -- Keep Earthen Wall Totem on cooldown
    if earthenWallTotemReady and lowHealthCount >= 3 then
        return RSham.Spells.EarthenWallTotem
    end

    -- Consume Undulation
    if hasUndulation then
        return RSham.Spells.HealingSurge
    end

    -- If 3 or more people are injured, use Chain Heal
    if ancestralReachLearned and lowHealthCount > 3 then
        return RSham.Spells.ChainHeal
    end

    -- Fall back
    if mduHealth >= 70 and lowHealthCount <= 2 then 
        return RSham.Spells.HealingWave
    else
        return RSham.Spells.HealingSurge
    end

    -- Should never reach this point
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
