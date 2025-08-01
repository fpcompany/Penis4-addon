_, P4 = ...
P4.classTable = {}
P4.pendingSetup = false

P4.racials = {
    ["Orc"] = 20572,            -- Blood Fury
    ["Troll"] = 26297,          -- Berserking
    ["Vulpera"] = 312411,       -- Bag of Tricks
    ["NightElf"] = 58984,       -- Shadowmeld
    ["BloodElf"] = 50613,       -- Arcane Torrent
    ["DarkIronDwarf"] = 265221, -- Fireblood
    ["Dwarf"] = 20594,          -- Stoneform
    ["KulTiran"] = 287712,      -- Haymaker
    ["MagharOrc"] = 274738,     -- Ancestral Call
}

P4.party_busters = {
    [167385] = { magic = true }, -- Uber Strike (Dummy crush)
    [459799] = { magic = true }, -- Wallop (Momma, Operation Floodgate)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
    [473070] = { magic = true }, -- Awaken the Swamp (Swampface, Operation Floodgate)
    [465463] = { magic = true }, -- Turbo Charge (Gigazap, Operation Floodgate)
    [448791] = { magic = true }, -- Sacred Toll (Trash, Priory)
    [426787] = { magic = true }, -- Shadowy Decay (Anubi'kkaj, Dawnbreaker)
    [438476] = { magic = true }, -- Alerting Shrill (Avanoxx, Ara-Kara)
    [346742] = { magic = false }, -- Fan Mail (Mailroom Mayhem, Tazavesh)
    [350796] = { magic = true }, -- Hyperlight Spark (So'leah, Tazavesh)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
    [465827] = { magic = true }, -- Warp Blood (Trash, Operation Floodgate)
}

P4.tankbusters = {
    -- DF
    [167385] = true, -- Uber Strike (Dummy crush)
    [385958] = true, -- Arcane Expulsion (Vexamus, Algeth'ar Academy)
    [388544] = true, -- Barkbreaker (Overgrown Ancient, Algeth'ar Academy)
    [376997] = true, -- Savage Peck (Crawth, Algeth'ar Academy)
    [381444] = true, -- Savage Charge (Rira Hackclaw, Brackenhide Hollow)
    [384343] = true, -- Gut Shot (Gutshot, Brackenhide Hollow)
    [373917] = true, -- Decay Strike (Decatriarch Wratheye, Brackenhide Hollow)
    [387504] = true, -- Squall Buffet (Primal Tsunami, Halls of Infusion)
    [387571] = true, -- Focused Deluge (Primal Tsunami, Halls of Infusion)
    [374533] = true, -- Heated Swings (Forgemaster Gorek, Neltharus)
    [381444] = true, -- Savage Charge (Rira Hackclaw, Brackenhide Hollow)
    [372808] = true, -- Frigid Shard (Melidrussa Chillworn, Ruby Life Pools)
    [372858] = true, -- Searing Blows (Kokia Blazehoof, Ruby Life Pools)
    [381512] = true, -- Stormslam (Erkhart Stormvein, Ruby Life Pools)
    [386660] = true, -- Erupting Fissure (Leymor, Azure Vault)
    [372222] = true, -- Arcane Cleave (Azureblade, Azure Vault)
    [384978] = true, -- Dragon Strike (Umbrelskul, Azure Vault)
    [384620] = true, -- Electrical Storm (Raging Tempest, Nokhud Offensive)
    [382836] = true, -- Brutalize (Maruuk, Nokhud Offensive)
    [375937] = true, -- Rending Strike (Balakar Khan, Nokhud Offensive)
    [369573] = true, -- Heavy Arrow (Lost Dwarves, Uldaman)
    -- TWW
    [438471] = true, -- Voracious Bite (Avanoxx, Ara-Kara)
    [441298] = true, -- Freezing Blood (Fangs of the Queen, City of Threads)
    [461842] = true, -- Oozing Smash (Coaglamation, City of Threads)
    [439646] = true, -- Process of Elimination (Izo, City of Threads)
    [447261] = true, -- Skullsplitter (General umbriss, Grim Batol)
    [450100] = true, -- Crush (Erudax, Grim Batol)
    [450101] = true, -- Crush (Erudax, Grim Batol)
    [450102] = true, -- Crush (Erudax, Grim Batol)
    [450103] = true, -- Crush (Erudax, Grim Batol)
    [451241] = true, -- Shadowflame Slash (Trash, Grim Batol)
    [453212] = true, -- Obsidian Beam (Speaker Shadowcrown, Grim Batol)
    [427001] = true, -- Terrifying Slam (Anub'ikkaj, Grim Batol)
    [320655] = true, -- Crunch (Blightbone, Necrotic Wake)
    [320376] = true, -- Mutilate (Stitchflesh, Necrotic Wake)
    [334488] = true, -- Sever Flesh (Stitchflesh, Necrotic Wake)
    [424888] = true, -- Seismic Smash (EDNA, Stonevault)
    [422233] = true, -- Crystalline Smash (Skarmorak, Stonevault)
    [428711] = true, -- Igneous Hammer (SkarmorakMechanists, Stonevault)
    [427461] = true, -- Void Corruption (Eirich, Stonevault)
    -- TWW(S2)
    [465865] = true, -- Tank Buster (Vexie, Liberation of Undermine)
    [466178] = true, -- Lightning Bash (Cauldron, Liberation of Undermine)
    [464112] = true, -- Demolish (Stix, Liberation of Undermine)
    [1217954] = true, -- Meltdown (Stix, Liberation of Undermine)
    [460472] = true, -- The Big Hit (One-armed Bandit, Liberation of Undermine)
    [466958] = true, -- Ego Check (Gallywix, Liberation of Undermine)
    [432229] = true, -- Keg Smash (Aldryr, Cinderbrew Meadery)
    [439031] = true, -- Bottom Uppercut (Ipa, Cinderbrew Meadery)
    [422245] = true, -- Rock Buster (Old Waxbeard, Darkflame Cleft)
    [473351] = true, -- Electrocrush (Momma, Operation Floodgate)
    [459799] = true, -- Wallop (Duo, Operation Floodgate)
    [469478] = true, -- Sludge Claws (Swampface, Operation Floodgate)
    [466190] = true, -- Thunder Punch (Gigazap, Operation Floodgate)
    [465666] = true, -- Sparkslam (Trash, Operation Floodgate)
    [294929] = true, -- Blazing Chomp (Kujo, Operation Mechagon)
    [1215411] = true, -- Puncture (Trash, Operation Mechagon)
    [424414] = true, -- Pierce Armor (Captain Dailcry, Priory)
    [448485] = true, -- Shield Slam (Trash, Priory)
    [435165] = true, -- Blazing Strike (Trash, Priory)
    [1215411] = true, -- Puncture (Trash, Motherlode)
    [445457] = true, -- Oblivion Wave (Monstrosity, Rookery)
    [320069] = true, -- Mortal Strike (Challengers, Theatre of Pain)
    [323515] = true, -- Hateful Strike (Gorechop, Theatre of Pain)
    [320644] = true, -- Brutal Combo (Xav, Theatre of Pain)
    [324079] = true, -- Reaping Scythe (Mordretha, Theatre of Pain)
    [331316] = true, -- Savage Flurry (Trash, Theatre of Pain)
    [331288] = true, -- Colossus Smash (Trash, Theatre of Pain)
    [333845] = true, -- Unbalancing Blow (Trash, Theatre of Pain)
    [330565] = true, -- Shield Bash (Trash, Theatre of Pain)
    -- TWW(S3)
    [349934] = true, -- Flagellation Protocol (Grand Menagerie, Tazavesh)
    [350916] = true, -- Security Slam (Myza's Oasis, Tazavesh)
    [359028] = true, -- Security Slam (Myza's Oasis, Tazavesh)
    [346116] = true, -- Shearing Swings (Hylbrande, Tazavesh)
    [323437] = true, -- Stigma of Pride (Lord Chamberlain, Tazavesh)
}

P4.NeedClip = function(channelSpell)
    if nil == channelSpell then return true end -- no channeling, can cast
    if channelSpell == "Lingering Voltage" then return true end -- rik reverb's lingering voltage, can cast
    if channelSpell == "Arcane Missiles" then return true end -- clip this
    return false -- all other channels
end

function P4.TankbusterDanger()
    local _, _, _, _, _, _, _, _, targetCastId = UnitCastingInfo("target")
    return P4.tankbusters[targetCastId] == true
end

-- returns IN_DANGER?, IS_MAGIC?
function P4.PartybusterDanger()
    local _, _, _, _, _, _, _, _, targetCastId = UnitCastingInfo("target")
    local struya_mochi = P4.party_busters[targetCastId]
    return struya_mochi ~= nil, struya_mochi and struya_mochi.magic or false
end

function P4.WhoAmI()
    local _, raceName = UnitRace("player")
    local classNameLocalized, _, classid = UnitClass("player")
    local specid = GetSpecialization()
    local _, specName = GetSpecializationInfo(specid)
    print(raceName .. " " .. specName .. " " .. classNameLocalized .. " class id " .. classid .. ", spec id " .. specid)
end

function P4.IsItemReady(itemID)
    local count = GetItemCount(itemID, false) -- false = don't include bank
    if count == 0 then return false end

    local start, duration, enable = GetItemCooldown(itemID)
    return enable == true and (start == 0 or (start + duration - GetTime() <= 0))
end

-- Returns: [ACTION] [MOST DAMAGED UNIT] [MOST DAMAGED UNIT HP] [COUNT OF DAMAGED PARTY MEMBERS] [DEBUFFED UNIT ONLY IF CAN DISPEL]
-- Bad idea. Need to remake. Lets split debuff and heal logic? GetHealingTarget and GetDispelTarget. 
function P4.GetHealingState(low_hp_percent, party_low_hp_percent, dispelID, ...)
    local debuffTypes = ...
    local mostDamagedUnit, mduHealth = P4.GroupTracker:Get()
    local lowHealthCount = P4.GroupTracker:CountBelowPercent(party_low_hp_percent)
    local debuffedUnit = P4.AuraTracker:GetUnitWithDebuff(...)
    local dispelReady = P4.IsSpellReady(dispelID)
    local action = nil

    if (mduHealth > low_hp_percent and (not dispelReady or not debuffedUnit)) then
        if UnitExists("focus") then
            P4.log("Defocus", P4.DEBUG)
            action = P4.MacroSystem:GetMacroIDForMacro("FocusClear")
        end
    end

    if not action and not (UnitExists("focus")) or (mostDamagedUnit and not UnitIsUnit("focus", mostDamagedUnit)) or (debuffedUnit and not UnitIsUnit("focus", debuffedUnit)) then
        if debuffedUnit and dispelReady then
            P4.log("Focus " .. tostring(debuffedUnit) .. " for dispel", P4.DEBUG)
            action = P4.MacroSystem:GetMacroIDForUnit(debuffedUnit)
        end
        if not action and mduHealth <= low_hp_percent then
            P4.log("Focus " .. tostring(mostDamagedUnit) .. " for healing (" .. mduHealth .. "%)", P4.DEBUG)
            action = P4.MacroSystem:GetMacroIDForUnit(mostDamagedUnit)
        end
    end

    return action, mostDamagedUnit, mduHealth, lowHealthCount, (debuffedUnit and dispelReady) and debuffedUnit or nil
end

function P4.GetTarget(unit)
    if UnitExists("focus") and not unit then
        P4.log("Clear focus", P4.DEBUG)
        return P4.MacroSystem:GetMacroIDForMacro("FocusClear") -- need to clear focus
    end
    if unit and not UnitIsUnit("focus", unit) then
        P4.log("Focus " .. unit, P4.DEBUG)
        return P4.MacroSystem:GetMacroIDForUnit(unit) -- need to focus unit
    end
    return nil -- no action needed
end

-- Move to skill tracker?
function P4.IsTotemActive(spell_id)
    local totemName = C_Spell.GetSpellInfo(spell_id).name
    for slot = 1, MAX_TOTEMS do
        local haveTotem, name, startTime, duration, icon = GetTotemInfo(slot)
        if haveTotem and name == totemName then
            local remaining = (startTime + duration) - GetTime()
            if remaining > 1 then -- avoid false positives from expired totems
                return true
            end
        end
    end
    return false
end

function P4.HasEnrageEffect(unit)
    if not UnitExists(unit) then return false end

    local index = 1
    while true do
        local aura = C_UnitAuras.GetAuraDataByIndex(unit, index, "HARMFUL")
        if not aura then break end

        if aura.dispelName == "Enrage" then
            return true, aura.name, aura.spellId
        end

        index = index + 1
    end

    return false
end