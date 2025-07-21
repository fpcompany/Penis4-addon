-- Namespace for your addon
P4 = P4 or {}
P4.MacroSystem = {}

-- Internal tables
local MacroSystem = P4.MacroSystem
local macroID = -100
local macroMap = {}          -- [macroName] = ID
local unitToMacro = {}       -- [unitID] = macroName

-- Helper to assign new macro ID
local function nextID()
    local id = macroID
    macroID = macroID - 1
    return id
end

-- Helper to create the macro button
local function CreateVirtualMacro(name, macrotext)
    local frame = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
    frame:SetSize(1, 1)
    frame:SetPoint("TOPLEFT", UIParent, -100, 100) -- offscreen
    
    local button = CreateFrame("Button", name, frame, "SecureActionButtonTemplate")
    button:SetSize(1, 1)
    button:SetPoint("CENTER", frame)
    
    button:SetMouseClickEnabled(true)
    button:RegisterForClicks("LeftButtonUp", "LeftButtonDown")
    
    button:SetAttribute("type", "macro")
    button:SetAttribute("macrotext1", macrotext)

    return button
end


-- Create macro and assign ID
local function defineMacro(name, macrotext)
    if not macroMap[name] then
        local id = nextID()
        CreateVirtualMacro(name, macrotext)
        macroMap[name] = id
    end
end

-- Public: Create all macros
function MacroSystem:InitializeFocusMacros()
    -- Clear focus macro
    defineMacro("FocusClear", "/clearfocus")

    -- Focus player
    defineMacro("FocusPlayer", "/focus [target=player]")
    unitToMacro["player"] = "FocusPlayer"

    -- Mana & Healing Potions
    defineMacro("ManaPotion", "/use Algari Mana Potion")
    defineMacro("HealingPotion", "/use Algari Healing Potion")

    -- Party units
    for i = 1, 4 do
        local unit = "party" .. i
        local name = "FocusParty" .. i
        defineMacro(name, "/focus [target=" .. unit .. "]")
        unitToMacro[unit] = name
    end

    -- Raid units
    for i = 1, 30 do
        local unit = "raid" .. i
        local name = "FocusRaid" .. i
        defineMacro(name, "/focus [target=" .. unit .. "]")
        unitToMacro[unit] = name
    end
end

-- Public: Get macro ID by unitID (e.g. "raid5" → -104)
function MacroSystem:GetMacroIDForUnit(unitID)
    local macroName = unitToMacro[unitID]
    if macroName then
        return macroMap[macroName]
    end
    return nil
end

-- Public: Get full macro list: { {name = ..., id = ...}, ... }
function MacroSystem:GetAllMacroIDs()
    local list = {}
    for name, id in pairs(macroMap) do
        table.insert(list, { name = name, id = id })
    end
    return list
end

-- Public: Get macro ID by macro name (e.g. "FocusClear" → -100)
function MacroSystem:GetMacroIDForMacro(name)
    return macroMap[name]
end
