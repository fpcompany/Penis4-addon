--Penis rewrite project
--This is a refined version of Penis 3.
--We aim to reduce bloat and unnecessary entities
--For example, we can now detect precisely which slot is Hekili referring to
--and direct output to the correct macro every time.
--Additional goal is to streamline overrides for dwarven racials, and class saves and dispels
_, P4 = ...

local mult = PixelUtil.GetPixelToUIUnitFactor()
local f = CreateFrame("Frame")
f:SetPoint("TOPLEFT", 0, 0)
f:SetSize(2 * mult, 1 * mult)
f:SetFrameStrata("TOOLTIP")
f:SetFrameLevel(1000)
local _st = f:CreateTexture(nil, "OVERLAY")
_st: SetPoint("TOPLEFT", 0, 0)
_st:SetSize(1 * mult, 1 * mult)
_st:SetColorTexture(0, 0, 0)
local _aoe = f:CreateTexture(nil, "OVERLAY")
_aoe:SetPoint("TOPLEFT", 1 * mult, 0)
_aoe:SetSize(1 * mult, 1 * mult)
_aoe:SetColorTexture(0, 0, 0)

local update = function(indicator, source)
    local spell = nil
    local hekiliSuggestion = nil
    local hekiliActionID, _, hekiliActionInfo = Hekili_GetRecommendedAbility(source, 1)
    spell = hekiliActionID and hekiliActionID or nil
    
    if spell and spell > 0 then
        hekiliSuggestion = C_Spell.GetSpellInfo(spell).name
    end

    --Priority system
    --First, get any race overrides, like Dwarf's stoneform. 2 minute cooldowns
    --Next, get any class overrides, like Warrior's spell reflection, defensive stance
    --Finally, get spec overrides. Here we may have healing spells or saves
    --is this ok? we havent decided yet
    local prio = P4.class and P4.class.priority and P4.class.priority()

    local keybind = hekiliActionInfo and hekiliActionInfo.keybind

    if hekiliActionID and hekiliActionID < 0 and not prio then --this is an item
        local itemID = Hekili.Class.abilities[hekiliActionID].item
        local slot = P4.Character:GetSlot(itemID) --get its slot. 13 and 14 are for trinkets, mainhand weapon is 16. we are going to convert them to macro id's
        spell = -1 * slot
    end

    -- override hekili's spell and keybind if got priority cast
    if prio and prio > 0 then 
        spell = prio
         P4.log("PRIO = " .. prio, P4.SUCCESS)
        local prio_spell_key = Hekili.Class.abilities[prio].key
        local info = Hekili.KeybindInfo[prio_spell_key]

        if info and info.upper then
            for _, key in pairs(info.upper) do
                keybind = key
                break
            end
        end
    end

    -- macro override
    if prio and prio < 0 then
        keybind = P4.keybindTable[prio]
    end


    --Stop recommendation if we channeling
    --This may be issue for some specs like fire mage
    --We also check for rik reverb's lingering voltage cast, because it wont block you from attacking
    local channelSpell = UnitChannelInfo("player")
    if not P4.NeedClip(channelSpell) then
        spell = nil
    end

    if spell then
        --local color = P4.spellColorTable[spell]
        
        --Dynamic Combo interaction
        --We will first check if ability is bound to a macro.
        --If it is true, then we will use its color
        --Otherwise, convert hotkey to color with P4.DCombo
        --We need abilities that 
        local color = P4.DCombo(keybind)
        
        
        --[[if hekiliSuggestion and color then
            local hkey = P4.ReverseLookup(color)
            local realSpellName = "???"
            if spell > 0 then
                realSpellName = C_Spell.GetSpellInfo(spell).name
            end
            P4.log("Hekili:" .. hekiliSuggestion .. ", real:" .. realSpellName .. ", id =" .. skill .. ", key = " .. hkey)
        end]]

        --Try to resolve bind by looking into .known field, or to refer a spell by its .bind and see its id
        --Now, this SHOULD remove all issues with spells that replace other spells in druid forms or hero talents, for example
        --but it still needs extensive testing
        if hekiliSuggestion and not color then
            local known = Hekili.Class.abilities[spell].known
            if (type(known) == "number" and known > 0) then
                spell = known
                color = P4.spellColorTable[spell]
                --P4.log("Inferred that " .. hekiliActionID .. " is " .. spell, P4.SUCCESS)
            else
                local bind = Hekili.Class.abilities[spell].bind
                if bind then
                    spell = Hekili.Class.abilities[bind].id
                    color = P4.spellColorTable[spell]
                    --P4.log("Inferred that " .. hekiliActionID .. " is " .. spell, P4.SUCCESS)
                end
            end
            if not color then
                P4.log("HEKILI WANTS TO PRESS " .. hekiliSuggestion .. " (ID=" .. spell .. ") BUT WE DONT HAVE HOTKEY!!!", P4.WARN)
            end
        end
        --Stop recomendations if its GCD to save cpu cycles
        if not P4.IsSpellOffGCD(spell) and P4.IsGCD() then
            color = nil
        end
        if color then
            indicator:SetColorTexture(unpack(color))
        else
            indicator:SetColorTexture(0, 0, 0)
        end
    else
        indicator:SetColorTexture(0, 0, 0)    
    end


end

function f:onUpdate(sinceLastUpdate)
    update(_st, "Primary")
    update(_aoe, "AOE")
end

local function P4Setup_Combinations()
    P4.log("Available combinations: " .. #P4.Combinations, P4.SUCCESS)
    local classNameLocalized, _, classID = UnitClass("player")
    local specID = GetSpecialization()
    local _, specName = GetSpecializationInfo(specID)
    local c = P4.classTable and P4.classTable[classID] or nil
    P4.class = c and c.specs[specID] or nil
    P4.log("Loading " .. specName .. " " .. classNameLocalized, P4.SUCCESS)
    
    --Run setup function, if implemented
    print("CSETUP?")
    if c and c.specs[specID] and c.specs[specID].Setup then
        print("CSETUP!")
        c.specs[specID].Setup()
    end
    print("CSETUP END")

    P4.spellColorTable = {}
    P4.keybindTable = {}
    local i = 1



    -- Commons, if implemented
    local c = P4.classTable and P4.classTable[-1] or nil
    if c and c.Setup then
        c.Setup()
    end

    -- Common macros, if implemented
    --[[if c and c.Macros then
        for key, macro in pairs(c.Macros) do
            local binding = P4.Combinations[i]
            if binding then
                P4.log("Macro: " .. macro .. " is set to " .. binding.combination, P4.SUCCESS)
                --SetBinding(binding.combination, "MACRO " .. macro)
                SetBindingClick(binding.combination, macro)
                P4.spellColorTable[key] = binding.color
                P4.keybindTable[key] = binding.short
                i = i + 1
            else
                P4.log("No more combinations available for Macro: " .. macro, P4.ERROR)
                break
            end
        end
    end]]

    -- Macro System
    for _, macro in ipairs(P4.MacroSystem:GetAllMacroIDs()) do
        local binding = P4.Combinations[i]
        if binding then
            P4.log("Macro: " .. macro.name .. " (" .. macro.id .. ") is set to " .. binding.combination, P4.SUCCESS)
            SetBindingClick(binding.combination, macro.name)
            P4.spellColorTable[macro.id] = binding.color
            P4.keybindTable[macro.id] = binding.short
            i = i + 1
        else
            P4.log("No more combinations available for Macro: " .. macro, P4.ERROR)
            break
        end
    end
    
    P4.log("Great Success", P4.SUCCESS)
end

P4.Setup = function()
    P4.Character:Init()
    P4Setup_Combinations()
end

P4.EnqueueSetup = function()
    P4.log("Queueing P4 setup")
    P4.pendingSetup = true
end

P4.HandleEvent = function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        P4.log("Penis 4 is now loading")
        if not InCombatLockdown() then
            P4.MacroSystem:InitializeFocusMacros()
            P4.Setup();
        else
            P4.EnqueueSetup()
        end
        P4.log("Welcome to Penis 4!\nPenis 4: enlarge your e-penis.", P4.SUCCESS)
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        local slot = ...
        P4.Character:UpdateSlot(slot)
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
        if not InCombatLockdown() then
            if "player" == ... then
                P4.Setup()
                P4.log("Spec changed")
            end
        else
            P4.EnqueueSetup()
        end
    elseif event == "TRAIT_CONFIG_UPDATED" then
        if not InCombatLockdown() then
            P4.Setup()
            P4.log("Talents changed")
        else
            P4.EnqueueSetup()
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if P4.pendingSetup then
            P4.log("Processing pending P4 setup")
            P4.Setup()
            P4.pendingSetup = false
        end
    end
end

f:SetScript("OnUpdate", f.onUpdate)
f:SetScript("OnEvent", P4.HandleEvent)
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
f:RegisterEvent("TRAIT_CONFIG_UPDATED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:Show()