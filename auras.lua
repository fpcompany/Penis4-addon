_, P4 = ...

local LibDispel = LibStub("LibDispel-1.0")

P4.Debuff = {
    Magic = "Magic",
    Curse = "Curse",
    Disease = "Disease",
    Poison = "Poison",
    Feared = "Feared",
    Stunned = "Stunned",
    Charmed = "Charmed",
    Sapped = "Sapped",
    Bleed = "Bleed",
    Polymorphed = "Polymorphed",
    Incapacitated = "Incapacitated",
}

local bleedList = LibDispel:GetBleedList()

function P4.TestDispel()
    local b = LibDispel:GetBleedList()
    local d = LibDispel:GetMyDispelTypes()
    local i = LibDispel:IsDispellableByMe("Magic")

    print("My dispel list: " .. tostring(#d))
    print("Bleed list: " .. tostring(#b))
    print("Is dispellable by me: " .. tostring(i))
    print("458771 = " .. tostring(b[458771]))
end

--[[P4.IAm("Stunned"), P4.IAm("Feared"), Incapacitated, etc]]
function P4.IAm(status)
    local loc = C_LossOfControl.GetActiveLossOfControlData(1)
    return loc and loc.displayText == status
end

function P4.CanDispel(unit, ...)
    if not UnitExists(unit) then return false end

    local debuffTypes = {...}

    for i = 1, 40 do
        local aura = C_UnitAuras.GetAuraDataByIndex(unit, i, "HARMFUL")
        if not aura then break end

        for _, type in ipairs(debuffTypes) do
            -- Dispelling known types like Magic, Curse, Disease, Poison
            if (type == P4.Debuff.Magic or type == P4.Debuff.Curse or
                type == P4.Debuff.Disease or type == P4.Debuff.Poison) and
                aura.dispelName == type and LibDispel:IsDispellableByMe(type) then
                return true
            end

            -- Bleed detection via LibDispel spell ID list
            if type == P4.Debuff.Bleed and bleedList[aura.spellId] then
                return true
            end
        end
    end

    -- Control effects like Fear/Stun/Charm/Polymorph only work on self
    if UnitIsUnit(unit, "player") then
        for _, type in ipairs(debuffTypes) do
            if type == P4.Debuff.Feared or type == P4.Debuff.Stunned or
               type == P4.Debuff.Charmed or type == P4.Debuff.Polymorphed then
                if P4.IAm(type) then
                    return true
                end
            end
        end
    end

    return false
end


function P4.selfBuff(id)
    local spellInfo = C_UnitAuras.GetPlayerAuraBySpellID(id)
    local remaining = spellInfo and spellInfo.expirationTime - GetTime() or 0
    return spellInfo ~= nil, remaining, spellInfo and spellInfo.applications or 0
end

function P4.UnitBuff(unit, id)
    local spellInfo = C_UnitAuras.GetAuraDataBySpellName(unit, C_Spell.GetSpellInfo(id).name)
    local remaining = spellInfo and spellInfo.expirationTime - GetTime() or 0
    return spellInfo ~= nil, remaining, spellInfo and spellInfo.applications or 0
end