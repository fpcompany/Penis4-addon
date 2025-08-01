P4 = P4 or {}
P4.GroupTracker = {}
local GT = P4.GroupTracker

GT.units = {}
GT.healthData = {}
GT.mostDamagedUnit = nil
GT.currentTank = nil  -- Store the current tank unit here

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
        local healAbsorb = UnitGetTotalHealAbsorbs(unit) or 0
        local shieldAbsorb = UnitGetTotalAbsorbs(unit) or 0

        if maxHp > 0 then
            -- Effective HP: subtract healing absorbs, add damage absorbs (shields)
            local effectiveHP = math.max(hp - healAbsorb, 1) + shieldAbsorb
            GT.healthData[unit] = effectiveHP / maxHp --math.min(effectiveHP / maxHp, 1)
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

function GT:UpdateTank()
    self.currentTank = nil
    for _, unit in ipairs(self.units) do
        if UnitGroupRolesAssigned(unit) == "TANK" and UnitCanAssist("player", unit) then
            self.currentTank = unit
            break
        end
    end
end

eventFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
        UpdateGroupUnits()
        GT:UpdateTank()       -- Update tank on group changes
        UpdateAllHealth()
    elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
        if tContains(GT.units, arg1) then
            UpdateUnitHealth(arg1)
            GT:UpdateMostDamaged()
        end
    elseif event == "UNIT_ABSORB_AMOUNT_CHANGED" or event == "UNIT_HEAL_ABSORB_AMOUNT_CHANGED" then
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
eventFrame:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
eventFrame:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED")

function GT:Get()
    return self.mostDamagedUnit or nil, (GT.healthData[self.mostDamagedUnit] or 1) * 100
end

function GT:GetTank()
    local tank = self.currentTank
    if tank 
        and UnitExists(tank) 
        and UnitIsConnected(tank) 
        and UnitInRange(tank)
    then
        return tank
    end
    return nil
end

function GT:PrintGroup()
    for _, unit in ipairs(self.units) do
        local hpPercent = self.healthData[unit]
        local role = UnitGroupRolesAssigned(unit)
        local roleDisplay = role ~= "NONE" and role or "?"
        
        if hpPercent then
            print(unit .. " | " .. math.floor(hpPercent * 100) .. "% | " .. roleDisplay)
        else
            print(unit .. " | N/A | " .. roleDisplay)
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
