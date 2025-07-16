_, P4 = ...

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

function P4.CanDispel(...)
    local target = "player"
    local debuffTypes = {...}  -- Capture all passed debuff types in a table

    for _, type in ipairs(debuffTypes) do
        -- Check for dispellable debuffs (Magic, Curse, Disease, Poison)
        if type == P4.Debuff.Magic or type == P4.Debuff.Curse
        or type == P4.Debuff.Disease or type == P4.Debuff.Poison then
            for i = 1, 40 do
                local aura = C_UnitAuras.GetAuraDataByIndex(target, i, "HARMFUL")
                if aura and aura.dispelName and aura.dispelName == type then
                    return true
                end
            end
        end

        -- Check for control effects (Fear, Stun, Charmed)
        if type == P4.Debuff.Feared or type == P4.Debuff.Stunned
        or type == P4.Debuff.Charmed or type == P4.Debuff.Polymorphed then
            if P4.IAm(type) then
                return true
            end
        end

        -- Check for bleeds
        if type == P4.Debuff.Bleed then
            for i = 1, 40 do
                local aura = C_UnitAuras.GetAuraDataByIndex(target, i, "HARMFUL")
                if aura and bleeds[aura.spellId] then
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