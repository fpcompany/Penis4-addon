DCP = {}
Priest.specs[1] = DCP


DCP.Macros = {
}

DCP.Setup = function ()
end

DCP.Spells = {
    PW_Shield = 17, -- shield target & atonement
    Renew = 139, -- hot target & atonement
    FlashHeal = 2061, -- fast heal
    PW_Fortitude = 21562, -- stamina buff on party
    PW_Radiance = 194509, -- heal group & atonement
    Purify = 527, -- dispel magic
    Penance = 47540, -- single target channeled heal
    Evangelism = 472433, -- extend atonement by 6 seconds
    DesperatePrayer = 19236, -- increase self health by 40%
    Premonition = 428924, -- Oracle rotationg effect buff
    PainSuppression = 33206, -- 40% damage reduction save
    PremonitionOfInsight = 428933, -- next 3 healing spells will have their cooldown reduced by 7 seconds
    PremonitionOfPiety = 428930, -- for the next 15 seconds all heal is increased by 20% and 70% of overheal will aoe heal
    PremonitionOfSolace = 428934, -- next single target heal spell will shield ally
    PremonitionOfClairvoyance = 440725, -- grants effect of all 3 premonitions
    UltimatePenance = 421453, -- damage enemies and heal party over 5.5 seconds, 4 min cd
}

DCP.Buffs = {
    Fortitude = 21562, -- stamina buff
    Shielded = 17, -- sheild
    Atonement = 194384, -- heal when caster does damage
    PremonitionOfInsight = 428933, -- next 3 spells will have their cooldown reduced by 7 seconds
    PremonitionOfPiety = 428930, -- increased healing and overhealing heals other allies
    PremonitionOfSolace = 428934, -- next ST healing spell will apply shield and -15% incoming damage save for 15 seconds
    PainSuppression = 33206, -- 40% damage reduction save
}

DCP.Talents = {
    ImprovedPurify = 390632, -- also dispel disease
}

DCP.priority = function ()
    local HEALING_THRESHOLD = 90 -- Heal people who are less than this %
    local healthMax = UnitHealthMax("player")
    local myHealth = healthMax > 0 and 100 * (UnitHealth("player") / healthMax) or 0
    local myMana = 100 * (UnitPower("player", 0) / UnitPowerMax("player", 0))

    --[[HEALING POTION]]
    if myHealth <= 50 then
        if P4.IsItemReady(211879) then -- Algari Healing Potion
            P4.log("HP POTION (<50%)", P4.DEBUG)
            return P4.MacroSystem:GetMacroIDForMacro("HealingPotion")
        end
    end
    
    --[[MANA POTION]]
    if myMana <= 10 and P4.IsItemReady(212240) then -- 10% mana
        P4.log("MANA POTION (<10%)", P4.DEBUG)
        return P4.MacroSystem:GetMacroIDForMacro("ManaPotion")
    end

    --[[BUFF]]
    if not P4.AuraTracker:EveryoneHas(DCP.Buffs.Fortitude) then
        P4.log("STAMINA (someone does not have it)", P4.DEBUG)
        return DCP.Spells.PW_Fortitude
    end

    local unit = nil -- THIS UNIT WILL BE FOCUSED
    local mostDamagedUnit, mduHealth = P4.GroupTracker:Get()
    local lowHealthCount = P4.GroupTracker:CountBelowPercent(80)
    local dispelReady = P4.IsSpellReady(DCP.Spells.Purify)
    local hasImprovedPurify = IsPlayerSpell(DCP.Talents.ImprovedPurify)
    local debuffedUnit = dispelReady and ((hasImprovedPurify and P4.AuraTracker:GetUnitWithDebuff(P4.Debuff.Magic, P4.Debuff.Disease)) or (not hasImprovedPurify and P4.AuraTracker:GetUnitWithDebuff(P4.Debuff.Magic)))
    
    if debuffedUnit then
        unit = debuffedUnit
    elseif mduHealth <= HEALING_THRESHOLD then
        unit = mostDamagedUnit
    end

    -- Focusing logic
    local action = P4.GetTarget(unit)
    if action then return action end

    -- Everyone is healthy and not debuffed / cant dispel yet, stop healing
    if mduHealth > HEALING_THRESHOLD and not debuffedUnit then return nil end

    -- Dispel the debuffed unit
    if debuffedUnit then -- if we are here, this means debuffed unit is in focus, no need to check
        P4.log("Purify on " .. tostring(debuffedUnit), P4.DEBUG)
        return DCP.Spells.Purify
    end

    -- Healing Logic   
    local targetHealthMax = UnitHealthMax("focus")
    local targetHealth = targetHealthMax > 0 and 100 * (UnitHealth("focus") / targetHealthMax) or 0
    local pwsReady = P4.IsSpellReady(DCP.Spells.PW_Shield)
    local targetShielded = P4.AuraTracker:UnitHas("focus", DCP.Buffs.Shielded)
    local targetHasAtonement = P4.AuraTracker:UnitHas("focus", DCP.Buffs.Atonement)
    local pwrReady = P4.IsSpellReady(DCP.Spells.PW_Radiance)
    local penanceReady = P4.IsSpellReady(DCP.Spells.Penance)
    local evangelismReady = P4.IsSpellReady(DCP.Spells.Evangelism)
    local desperatePrayerReady = P4.IsSpellReady(DCP.Spells.DesperatePrayer)
    local premonitionReady = P4.IsSpellReady(DCP.Spells.Premonition)
    local hasPremonitionOfInsight = P4.AuraTracker:UnitHas("player", DCP.Buffs.PremonitionOfInsight)
    local hasPremonitionOfPiety = P4.AuraTracker:UnitHas("player", DCP.Buffs.PremonitionOfPiety)
    local hasPremonitionOfSolace = P4.AuraTracker:UnitHas("player", DCP.Buffs.PremonitionOfSolace)
    local painSuppressionReady = P4.IsSpellReady(DCP.Spells.PainSuppression)
    local targetHasPainSuppression = P4.AuraTracker:UnitHas("focus", DCP.Buffs.PainSuppression)
    local ultimatePenanceReady = P4.IsSpellReady(DCP.Spells.UltimatePenance)

    local premonitionOfInsightUsable = IsSpellKnownOrOverridesKnown(DCP.Spells.PremonitionOfInsight)
    local premonitionOfPietyUsable = IsSpellKnownOrOverridesKnown(DCP.Spells.PremonitionOfPiety)
    local premonitionOfSolaceUsable = IsSpellKnownOrOverridesKnown(DCP.Spells.PremonitionOfSolace)
    local premonitionOfClairvoyanceUsable = IsSpellKnownOrOverridesKnown(DCP.Spells.PremonitionOfClairvoyance)

    -- Ultimate penance if party is in a pinch
    if ultimatePenanceReady and  mduHealth <= 50 and lowHealthCount >= 4 then
        return DCP.Spells.UltimatePenance
    end

    -- Get a premonition buff if party is in a pinch
    if (mduHealth <= 50 or lowHealthCount >= 3) and premonitionReady and not (hasPremonitionOfInsight or hasPremonitionOfPiety or hasPremonitionOfSolace) then
        if premonitionOfInsightUsable then return DCP.Spells.PremonitionOfInsight end
        if premonitionOfPietyUsable then return DCP.Spells.PremonitionOfPiety end
        if premonitionOfSolaceUsable then return DCP.Spells.PremonitionOfSolace end
        if premonitionOfClairvoyanceUsable then return DCP.Spells.PremonitionOfClairvoyance end
    end

    -- Protect self if party is in a pinch
    if desperatePrayerReady and ((myHealth <= 70 and lowHealthCount >= 3) or (myHealth <= 70 and lowHealthCount >= 2 and mduHealth <= 50) or myHealth <= 30) then
        return DCP.Spells.DesperatePrayer
    end

    -- Extend atonement on group if everyone has it
    if lowHealthCount >= 3 and evangelismReady and P4.AuraTracker:EveryoneHas(DCP.Buffs.Atonement) then
        return DCP.Spells.Evangelism
    end

    -- Give atonement to group if 3 or more people are damaged
    if pwrReady and lowHealthCount >= 3 and not P4.AuraTracker:EveryoneHas(DCP.Buffs.Atonement) then
        return DCP.Spells.PW_Radiance
    end

    -- Give atonement to target with Shield if its ready
    if pwsReady and not targetShielded and not targetHasAtonement then
        return DCP.Spells.PW_Shield
    end

    -- Give atonement to target with Renew if Shield is not ready
    if not pwsReady and not targetHasAtonement then
        return DCP.Spells.Renew
    end

    -- Add / Refresh shield on critical target
    if mduHealth <= 70 and pwsReady and not targetShielded then
        return DCP.Spells.PW_Shield
    end

    -- Penance on critical target
    if mduHealth <= 60 and penanceReady then
        return DCP.Spells.Penance
    end

    -- Pain suppression critical target
    if mduHealth <= 40 and painSuppressionReady and not targetHasPainSuppression then
        return DCP.Spells.PainSuppression
    end

    -- Flash Heal critical target
    if mduHealth <= 50 then
        return DCP.Spells.FlashHeal
    end
end
