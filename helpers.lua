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

function P4.WhoAmI()
    local _, raceName = UnitRace("player")
    local classNameLocalized, _, classid = UnitClass("player")
    local specid = GetSpecialization()
    local _, specName = GetSpecializationInfo(specid)
    print(raceName .. " " .. specName .. " " .. classNameLocalized .. " class id " .. classid .. ", spec id " .. specid)
end
