_, P4 = ...
-- Guide on macros:
-- ["Arbitrary name of macros"] = 
-- {identifier = "Original Spell Name",
-- modifiers = {P3.Targets.None},
-- solver_id = Upgraded Spell ID},
-- Example:

-- Regular ground AOE
-- ["Death and Decay"] = {identifier = 49998, modifiers = {P3.Targets.Player}},
-- Macro will be P3DeathandDecay and will use "/cast [@player] Death and Decay" when Hekili solves into 49998

-- A spell that transforms into another spell but require base spell to be used.
-- ["Bloodbath Kavkaz"] = {identifier = "Bloodthirst", modifiers = {P3.Targets.None}, solver_id = 335096},
-- Macro will be P3BloodbathKavkaz and will use "/cast Bloodthirst" when Hekili or Priority solves into 335096 (upgraded spell ID)

P4.Targets = {
    None = "",
    Cursor = "[@cursor]",
    Player = "[@player]",
    Party1 = "[@party1]",
    PetWaterElemental = "[@cursor][pet:Water Elemental]",
    FriendlyFocus = "[@focus,help,nodead][]",
}

function P4.ToMacroName(spellName)
    return "P3" .. spellName:gsub(" ", "") -- We are compatible with P3
end

function P4.CreateMacroEx(name, identifier, modifiers)
    if (type(identifier) == "number") then --resolve spell name by id
        identifier = C_Spell.GetSpellInfo(identifier).name
    end

    name = P4.ToMacroName(name)

    local all_modifiers = ""

    for k, v in pairs(modifiers) do
        if v ~= P4.Targets.None then
            all_modifiers = all_modifiers .. " " .. v
        end
    end

    if GetMacroIndexByName(name) == 0 then
        print("Creating macro " .. name)
        CreateMacro(name, "INV_MISC_QUESTIONMARK", "/cast " .. all_modifiers .. identifier, 1)
    end
end