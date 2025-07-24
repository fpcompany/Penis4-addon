_, P4 = ...
Common = {}
P4.classTable[-1] = Common

Common.Macros = { --deprecated in favor of MacroSystem
    [-13] = "P4Trinket1",
    [-14] = "P4Trinket2",
    [-16] = "P3OnUseWeapon",
    [-99] = "P4FocusParty1",
    [-100] = "P4FocusClear"
    --[-98] = "P4TargetP2",
    --[-97] = "P4TargetP3",
    --[-96] = "P4TargetP4",
    --[-95] = "P4TargetP5",
}

Common.Spells = {
    Fireblood = 265221, -- Dark iron dwarf racial
}

local CreateVirtualMacro = function(name, macrotext)
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

Common.Setup = function()
    --[[CreateVirtualMacro("P4Trinket1", "/use [@cursor] 13")
    CreateVirtualMacro("P4Trinket2", "/use [@cursor] 14")
    CreateVirtualMacro("P3OnUseWeapon", "/use [@cursor] 16")
    CreateVirtualMacro("P4FocusParty1", "/focus [target=player]")
    CreateVirtualMacro("P4FocusClear", "/clearfocus")]]
    --SetBindingClick("SHIFT-F", "P4FocusParty1")

end