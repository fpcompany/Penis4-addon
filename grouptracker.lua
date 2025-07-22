P4 = P4 or {}
P4.GroupTracker = {}
local GT = P4.GroupTracker

GT.units = {}
GT.healthData = {}
GT.mostDamagedUnit = nil

local eventFrame = CreateFrame("Frame")

local function UpdateGroupUnits()
    wipe(GT.units)

    if IsInRaid() then
        for i = 1, GetNumGroupMembers() do
            local unit = "raid" .. i
            if UnitCanAssist("player", unit) then
                table.insert(GT.units, unit)
            end
        end
    elseif IsInGroup() then
        table.insert(GT.units, "player")
        for i = 1, GetNumSubgroupMembers() do
            local unit = "party" .. i
            if UnitCanAssist("player", unit) then
                table.insert(GT.units, unit)
            end
        end
    else
        table.insert(GT.units, "player")
    end
end

local function UpdateUnitHealth(unit)
    if UnitExists(unit) and UnitIsConnected(unit) and not UnitIsDeadOrGhost(unit) and UnitCanAssist("player", unit) then
        local hp = UnitHealth(unit)
        local maxHp = UnitHealthMax(unit)
        local absorb = UnitGetTotalHealAbsorbs(unit) or 0

        if maxHp > 0 then
            -- Cap effective HP at maxHP to avoid negative values
            local effectiveHP = math.max(hp - absorb, 0)
            GT.healthData[unit] = effectiveHP / maxHp
        else
            GT.healthData[unit] = 1
        end
    else
        GT.healthData[unit] = nil
    end
end

function GT:UpdateMostDamaged()
    local lowestUnit = nil
    local lowestHP = 1.1

    for unit, hp in pairs(self.healthData) do
        if hp < lowestHP and UnitCanAssist("player", unit) and (unit == "player" or UnitInRange(unit)) then
            lowestHP = hp
            lowestUnit = unit
        end
    end

    self.mostDamagedUnit = lowestUnit
end

local function UpdateAllHealth()
    for _, unit in ipairs(GT.units) do
        UpdateUnitHealth(unit)
    end
    GT:UpdateMostDamaged()
end

eventFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
        UpdateGroupUnits()
        UpdateAllHealth()
    elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
        if tContains(GT.units, arg1) then
            UpdateUnitHealth(arg1)
            GT:UpdateMostDamaged()
        end
    end
end)

eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("UNIT_HEALTH")
eventFrame:RegisterEvent("UNIT_MAXHEALTH")

function GT:Get()
    return self.mostDamagedUnit or nil, (GT.healthData[self.mostDamagedUnit] or 1) * 100
end

-- Print a list of tracked units and their health % to chat
function GT:PrintHealthList()
    for _, unit in ipairs(self.units) do
        local hpPercent = self.healthData[unit]
        if hpPercent then
            print(unit .. " | " .. math.floor(hpPercent * 100) .. "%")
        else
            print(unit .. " | " .. "N/A")
        end
    end
end

function GT:CountBelowPercent(percent)
    local count = 0
    for _, unit in ipairs(self.units) do
        local hp = self.healthData[unit]
        if hp and hp * 100 < percent and UnitCanAssist("player", unit) then
            count = count + 1
        end
    end
    return count
end

function GT:GetUnitsInRange()
    local inRange = {}
    for _, unit in ipairs(self.units) do
        if UnitCanAssist("player", unit) and (unit == "player" or UnitInRange(unit)) then
            table.insert(inRange, unit)
        end
    end
    return inRange
end