_, P4 = ...
P4._logTimestamps = P4._logTimestamps or {}
local showDebug = false

-- Log level constants
P4.NOTICE  = "NOTICE"
P4.SUCCESS = "SUCCESS"
P4.WARN    = "WARN"
P4.ERROR   = "ERROR"
P4.DEBUG   = "DEBUG"

-- Color mapping for levels
local levelColors = {
    [P4.NOTICE]  = "|cffffffff", -- white
    [P4.SUCCESS] = "|cff00ff00[OK] ", -- green
    [P4.WARN]    = "|cffff9900[WARN] ", -- orange
    [P4.ERROR]   = "|cffff0000[ERR] ", -- red
    [P4.DEBUG]   = "|cffffffff[DEBUG]", -- white
}

function P4.debug(isDebug)
    showDebug = isDebug
end

-- Logs a message with a level and deduplicates based on the message string
function P4.log(message, level)
    if level == "DEBUG" and not showDebug then return end

    if not levelColors[level] then
        level = P4.NOTICE
    end

    local now = GetTime()
    local rateLimit = 1

    if not P4._logTimestamps[message] or (now - P4._logTimestamps[message]) > rateLimit then
        local color = levelColors[level] or levelColors[P4.NOTICE]
        DEFAULT_CHAT_FRAME:AddMessage(color .. message .. "|r")
        P4._logTimestamps[message] = now
    end
end