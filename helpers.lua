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
    [448887] = { magic = true }, -- Erosive Spray (Rashanan, Dawnbreaker)
    [448888] = { magic = true }, -- Erosive Spray (Rashanan, Dawnbreaker)
    [448492] = { magic = true }, -- Thunderclap (Trash, Priory)
    [438476] = { magic = true }, -- Alerting Shrill (Avanoxx, Ara-Kara)
    [438877] = { magic = false }, -- Call of the brood (Thrash, Ara-Kara)
    [346742] = { magic = false }, -- Fan Mail (Mailroom Mayhem, Tazavesh)
    [350796] = { magic = true }, -- Hyperlight Spark (So'leah, Tazavesh)
    [355429] = { magic = true }, -- Tidal Stomp (Trash, Tazavesh)
    [326409] = { magic = true }, -- Thrash (Trash, Halls of atonement)
    [326426] = { magic = true }, -- Thrash (Trash, Halls of atonement)
    [326847] = { magic = true }, -- Disperse sin (Sigar, Halls of atonement)
    [1221152] = { magic = false }, -- Gorging Smash (Trash, Eco-Dome Al'dani)
    [1221532] = { magic = true }, -- Erratic Ritual (Trash, Eco-Dome Al'dani)
    [1217232] = { magic = true }, -- Devour (Azhiccar, Eco-Dome Al'dani)
    [1220497] = { magic = true }, -- Arcane Overload (Taahbar, Eco-Dome Al'dani)
    [1220511] = { magic = true }, -- Arcane Overload (Taahbar, Eco-Dome Al'dani)
    [1224793] = { magic = true }, -- Whispers of Fate (Soulscribe, Eco-Dome Al'dani)
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
    [346876] = true, -- Shearing Swings (Hylbrande, Tazavesh)
    [346877] = true, -- Shearing Swings (Hylbrande, Tazavesh)
    [352796] = true, -- Proxy Strike (Trash, Tazavesh)
    [351047] = true, -- Proxy Strike (Trash, Tazavesh)
    [323437] = true, -- Stigma of Pride (Lord Chamberlain, Halls of Atonement)
    [1235766] = true, -- Mortal Strike (Trash, Halls of Atonement)
    [1237071] = true, -- Dtone Fist (Trash, Halls of Atonement)
    [431491] = true, -- Tainted Slash (Thrash, Dawnbreaker)
    [448515] = true, -- Divine Judgement (Trash, Priory)
    [435165] = true, -- Blazing Strike (Trash, Priory)
    [1219482] = true, -- Rift Claws (Taah'bat, Eco-Dome Al'dani)
    [1222341] = true, -- Gloom Bite (Trash, Eco-Dome Al'dani)
}

-- Ultimate Penance guard: prevent suggestions from interrupting it.
P4._UP_guard_until = P4._UP_guard_until or 0

P4.NeedClip = function(channelSpell)
    -- If a timed guard is active for Ultimate Penance, do not clip.
    if P4._UP_guard_until and GetTime() < P4._UP_guard_until then
        return false
    end

    -- Also avoid clipping if we detect the UP aura or the cast by name.
    local upInfo = C_Spell.GetSpellInfo(421453)
    local upName = upInfo and upInfo.name or nil
    local castName = select(1, UnitCastingInfo("player"))
    if C_UnitAuras.GetPlayerAuraBySpellID(421453) or (upName and (channelSpell == upName or castName == upName)) then
        return false
    end

    -- Whitelist channels that are OK to clip.
    if channelSpell == nil then return true end -- no channeling, can cast
    if channelSpell == "Lingering Voltage" then return true end -- rik reverb's lingering voltage, can cast
    if channelSpell == "Arcane Missiles" then return true end -- clip this

    -- All other channels should not be clipped.
    return false
end

-- Minimal event guard for Ultimate Penance to cover API edge cases.
do
    local f = CreateFrame("Frame")
    f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    f:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    f:RegisterEvent("UNIT_SPELLCAST_STOP")
    f:RegisterEvent("PLAYER_DEAD")
    f:SetScript("OnEvent", function(_, event, unit, _, spellID)
        if event == "PLAYER_DEAD" then
            P4._UP_guard_until = 0
            return
        end
        if unit ~= "player" then return end
        if event == "UNIT_SPELLCAST_SUCCEEDED" and spellID == 421453 then
            -- Ultimate Penance duration ~5.5s; guard slightly longer to be safe.
            P4._UP_guard_until = GetTime() + 5.7
        elseif (event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_STOP") and (spellID == 421453 or P4._UP_guard_until > 0) then
            -- Clear early if the cast ends or is interrupted.
            P4._UP_guard_until = 0
        end
    end)
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
