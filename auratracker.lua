P4 = P4 or {}
P4.AuraTracker = {}

local AT = P4.AuraTracker
AT.unitAuras = {}
AT.guidToUnit = {}

local LibDispel = LibStub("LibDispel-1.0")
local bleedList = LibDispel:GetBleedList()

-- SAY THE LINE HEALERJAK
local badDebuffs = {
    [472197] = true, -- One-Armed Bandit | Withering Flames
    [164812] = true, -- MOONFIRE
}
-- THESE DEBUFFS ARE *TOXIC* TO MY WORKFLOW NIGGA
-- Hahaha i love this little fella

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

local eventFrame = CreateFrame("Frame")

local function EnsureUnitTable(guid)
    if not AT.unitAuras[guid] then
        AT.unitAuras[guid] = {}
    end
    return AT.unitAuras[guid]
end

local function TrackGUID(unit)
    local guid = UnitGUID(unit)
    if guid then
        AT.guidToUnit[guid] = unit
    end
    return guid
end

-- Full aura scan using C_UnitAuras
local function FullAuraScan(unit)
    local guid = TrackGUID(unit)
    if not guid then return end

    local auras = EnsureUnitTable(guid)
    wipe(auras)

    for index = 1, 255 do
        local aura = C_UnitAuras.GetAuraDataByIndex(unit, index, "HELPFUL")
        if not aura then break end
        auras[aura.spellId] = {
            expiration = aura.expirationTime,
            stacks = aura.applications or 1,
            instanceID = aura.auraInstanceID,
            dispelName = aura.dispelName,
            isHelpful = true,
        }
    end

    for index = 1, 255 do
        local aura = C_UnitAuras.GetAuraDataByIndex(unit, index, "HARMFUL")
        if not aura then break end
        auras[aura.spellId] = {
            expiration = aura.expirationTime,
            stacks = aura.applications or 1,
            instanceID = aura.auraInstanceID,
            dispelName = aura.dispelName,
            isHelpful = false,
        }
    end
end

local function FullGroupRescan()
    if not P4.GroupTracker or not P4.GroupTracker.units then return end
    for _, unit in ipairs(P4.GroupTracker.units) do
        if UnitExists(unit) and UnitIsConnected(unit) and UnitIsPlayer(unit) then
            FullAuraScan(unit)
        end
    end
end

local function CleanupOrphanedGUIDs()
    local currentGUIDs = {}
    if P4.GroupTracker and P4.GroupTracker.units then
        for _, unit in ipairs(P4.GroupTracker.units) do
            local guid = UnitGUID(unit)
            if guid then
                currentGUIDs[guid] = true
            end
        end
    end

    -- Clean aura + reverse map
    for guid in pairs(AT.unitAuras) do
        if not currentGUIDs[guid] then
            AT.unitAuras[guid] = nil
            AT.guidToUnit[guid] = nil
        end
    end
end


eventFrame:SetScript("OnEvent", function(_, event, unit, updateInfo)
    if event == "UNIT_AURA" then
        if not unit or not UnitIsPlayer(unit) then return end
        local guid = TrackGUID(unit)
        if not guid then return end

        local auras = EnsureUnitTable(guid)

        if not updateInfo or updateInfo.isFullUpdate then
            FullAuraScan(unit)
            return
        end

        for _, aura in ipairs(updateInfo.addedAuras or {}) do
            auras[aura.spellId] = {
                expiration = aura.expirationTime,
                stacks = aura.applications or 1,
                instanceID = aura.auraInstanceID,
                dispelName = aura.dispelName,
                isHelpful = aura.isHelpful,
            }
        end

        for _, aura in ipairs(updateInfo.updatedAuras or {}) do
            auras[aura.spellId] = {
                expiration = aura.expirationTime,
                stacks = aura.applications or 1,
                instanceID = aura.auraInstanceID,
                dispelName = aura.dispelName,
                isHelpful = aura.isHelpful,
            }
        end

        for _, auraInstanceID in ipairs(updateInfo.removedAuraInstanceIDs or {}) do
            for spellId, data in pairs(auras) do
                if data.instanceID == auraInstanceID then
                    auras[spellId] = nil
                    break
                end
            end
        end

    elseif event == "PLAYER_ENTERING_WORLD" or
           event == "GROUP_ROSTER_UPDATE" or
           event == "ZONE_CHANGED_NEW_AREA" then
        C_Timer.After(1.0, function()
            FullGroupRescan()
            CleanupOrphanedGUIDs()
        end)
    end
end)


eventFrame:RegisterEvent("UNIT_AURA")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

------------------------------------------------
-- Public API
------------------------------------------------

-- Convert unit or guid to guid
function AT:GetGUID(unitOrGUID)
    if type(unitOrGUID) == "string" and unitOrGUID:find("^Player%-") then
        return unitOrGUID
    end
    return UnitGUID(unitOrGUID)
end

function AT:EveryoneHas(spellId)
    for _, unit in ipairs(P4.GroupTracker:GetUnitsInRange() or {}) do
        if not self:UnitHas(unit, spellId) then
            return false
        end
    end
    return true
end

function AT:WhoHas(spellId)
    local result = {}
    for _, unit in ipairs(P4.GroupTracker:GetUnitsInRange() or {}) do
        if self:UnitHas(unit, spellId) then
            table.insert(result, unit)
        end
    end
    return result
end

function AT:UnitHas(unitOrGUID, spellId)
    local guid = self:GetGUID(unitOrGUID)
    if not guid then return false end

    local aura = self.unitAuras[guid] and self.unitAuras[guid][spellId]
    if aura then
        return true, aura.expiration, aura.stacks
    end
    return false
end

function AT:GetActiveDebuffTypes(unitOrGUID)
    local guid = self:GetGUID(unitOrGUID)
    if not guid then return {} end

    local auras = self.unitAuras[guid]
    if not auras then return {} end

    local result = {}
    local found = {}

    for spellId, aura in pairs(auras) do
        if not aura.isHelpful and not badDebuffs[spellId] then
            local dispelType = aura.dispelName
            if dispelType and P4.Debuff[dispelType] and not found[dispelType] then
                table.insert(result, dispelType)
                found[dispelType] = true
            end

            if bleedList[spellId] and not found[P4.Debuff.Bleed] then
                table.insert(result, P4.Debuff.Bleed)
                found[P4.Debuff.Bleed] = true
            end
        end
    end

    return result
end

function AT:GetUnitWithDebuff(...)
    local wantedTypes = {}
    for _, t in ipairs({...}) do
        wantedTypes[t] = true
    end

    for _, unit in ipairs(P4.GroupTracker:GetUnitsInRange() or {}) do
        if UnitIsFriend("player", unit) then
            local active = self:GetActiveDebuffTypes(unit)
            for _, debuffType in ipairs(active) do
                if wantedTypes[debuffType] then
                    return unit
                end
            end
        end
    end

    return nil
end
