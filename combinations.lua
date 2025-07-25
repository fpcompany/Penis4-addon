_, P4 = ...

local function makeColor(r, g)
    return { r / 255, g / 255, (r + g + 50) / 255 }
end

P4.Combinations = {
    { combination = "CTRL-NUMPAD0", color = makeColor(1, 93), short = "CN0" },
    { combination = "CTRL-NUMPAD1", color = makeColor(1, 94), short = "CN1" },
    { combination = "CTRL-NUMPAD2", color = makeColor(1, 95), short = "CN2" },
    { combination = "CTRL-NUMPAD3", color = makeColor(1, 96), short = "CN3" },
    { combination = "CTRL-NUMPAD4", color = makeColor(1, 97), short = "CN4" },
    { combination = "CTRL-NUMPAD5", color = makeColor(1, 98), short = "CN5" },
    { combination = "CTRL-NUMPAD6", color = makeColor(1, 99), short = "CN6" },
    { combination = "CTRL-NUMPAD7", color = makeColor(1, 100), short = "CN7" },
    { combination = "CTRL-NUMPAD8", color = makeColor(1, 101), short = "CN8" },
    { combination = "CTRL-NUMPAD9", color = makeColor(1, 102), short = "CN9" },
    { combination = "ALT-NUMPAD0", color = makeColor(2, 93), short = "AN0" },
    { combination = "ALT-NUMPAD1", color = makeColor(2, 94), short = "AN1" },
    { combination = "ALT-NUMPAD2", color = makeColor(2, 95), short = "AN2" },
    { combination = "ALT-NUMPAD3", color = makeColor(2, 96), short = "AN3" },
    { combination = "ALT-NUMPAD4", color = makeColor(2, 97), short = "AN4" },
    { combination = "ALT-NUMPAD5", color = makeColor(2, 98), short = "AN5" },
    { combination = "ALT-NUMPAD6", color = makeColor(2, 99), short = "AN6" },
    { combination = "ALT-NUMPAD7", color = makeColor(2, 100), short = "AN7" },
    { combination = "ALT-NUMPAD8", color = makeColor(2, 101), short = "AN8" },
    { combination = "ALT-NUMPAD9", color = makeColor(2, 102), short = "AN9" },
    { combination = "CTRL-F1", color = makeColor(1, 38), short = "CF1" },
    { combination = "CTRL-F2", color = makeColor(1, 39), short = "CF2" },
    { combination = "CTRL-F3", color = makeColor(1, 40), short = "CF3" },
    { combination = "CTRL-F4", color = makeColor(1, 41), short = "CF4" },
    { combination = "CTRL-F5", color = makeColor(1, 42), short = "CF5" },
    { combination = "CTRL-F6", color = makeColor(1, 43), short = "CF6" },
    { combination = "CTRL-F7", color = makeColor(1, 44), short = "CF7" },
    { combination = "CTRL-F8", color = makeColor(1, 45), short = "CF8" },
    { combination = "CTRL-F9", color = makeColor(1, 46), short = "CF9" },
    { combination = "CTRL-F10", color = makeColor(1, 47), short = "CF10" },
    { combination = "CTRL-F11", color = makeColor(1, 48), short = "CF11" },
    { combination = "CTRL-F12", color = makeColor(1, 49), short = "CF12" },
    { combination = "ALT-F12", color = makeColor(2, 49), short = "AF12" },
    { combination = "SHIFT-F1", color = makeColor(3, 38), short = "SF1" },
    { combination = "SHIFT-F2", color = makeColor(3, 39), short = "SF2" },
    { combination = "SHIFT-F3", color = makeColor(3, 40), short = "SF3" },
    { combination = "SHIFT-F4", color = makeColor(3, 41), short = "SF4" },
    { combination = "SHIFT-F5", color = makeColor(3, 42), short = "SF5" },
    { combination = "SHIFT-F6", color = makeColor(3, 43), short = "SF6" },
    { combination = "SHIFT-F7", color = makeColor(3, 44), short = "SF7" },
    { combination = "SHIFT-F8", color = makeColor(3, 45), short = "SF8" },
    { combination = "SHIFT-F9", color = makeColor(3, 46), short = "SF9" },
    { combination = "SHIFT-F10", color = makeColor(3, 47), short = "SF10" },
    { combination = "SHIFT-F11", color = makeColor(3, 48), short = "SF11" },
    { combination = "SHIFT-F12", color = makeColor(3, 49), short = "SF12" }
}


--get hotkey by spell
function P4.Lookup(skill)
    local color = P4.spellColorTable[skill]
    if skill > 0 then 
        local hkey = "???"
        if color then hkey = P4.ReverseLookup(color) end
        local spell = C_Spell.GetSpellInfo(skill)
        local name = "???"
        if spell then name = spell.name end
        print(name .. " id = " .. skill .. " key = " .. hkey)
    end
end

--get combination by color
P4.ReverseLookup = function (color)
    for k, v in pairs(P4.Combinations) do
        if v.color[1] == color[1] and v.color[2] == color[2] and v.color[3] == color[3] then
            return v.combination
        end
    end
end

local js_key_to_code = {
    -- Digits
    ["0"] = 1,
    ["1"] = 2,
    ["2"] = 3,
    ["3"] = 4,
    ["4"] = 5,
    ["5"] = 6,
    ["6"] = 7,
    ["7"] = 8,
    ["8"] = 9,
    ["9"] = 10,

    -- Letters
    A = 11, B = 12, C = 13, D = 14, E = 15, F = 16,
    G = 17, H = 18, I = 19, J = 20, K = 21, L = 22,
    M = 23, N = 24, O = 25, P = 26, Q = 27, R = 28,
    S = 29, T = 30, U = 31, V = 32, W = 33, X = 34,
    Y = 35, Z = 36,

    -- Numpad (N0-N9)
    N0 = 93, N1 = 94, N2 = 95, N3 = 96, N4 = 97,
    N5 = 98, N6 = 99, N7 = 100, N8 = 101, N9 = 102,

    -- Function keys
    F1 = 38, F2 = 39, F3 = 40, F4 = 41, F5 = 42,
    F6 = 43, F7 = 44, F8 = 45, F9 = 46, F10 = 47,
    F11 = 48, F12 = 49,
}

local function modifier(str)
    if str == "C" then
        return 1
    elseif str == "A" then
        return 2
    elseif str == "S" then
        return 3
    else
        return 4
    end
end

local function button(sym)
    if sym == "" then return -1 end
    local ret_val = js_key_to_code[sym:upper()] or -1
    if ret_val == -1 then
        P4.log("WE DO NOT SUPPORT THE KEY (" .. sym .. ") YET, PLEASE CHANGE IT TO ANOTHER BUTTON THX", P4.WARN)
    end
    return ret_val
end

--Dynamic Combination function
--Takes hotkey in wow's format
--Returns modifier and button as numbers
P4.DCombo = function (str)
    if not str then return nil end
    if #str == 1 or str:sub(1, 1) == "N" or str:sub(1, 1) == "F" then
        return makeColor(4, button(str))
    else
        local mod = str:sub(1, 1)
        local btn = str:sub(2)
        return makeColor(modifier(mod), button(btn))
    end
end

