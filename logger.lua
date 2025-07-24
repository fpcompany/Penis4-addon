_, P4 = ...
P4._logTimestamps = P4._logTimestamps or {}
local showDebug = false
local watch_primary = false
local watch_aoe = false

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

function P4.debug(isDebug, primary, aoe)
    showDebug = isDebug
    watch_primary = primary
    watch_aoe = aoe
end

function P4.log(message, level, hekiliChannel)
    if level == "DEBUG" and not showDebug then return end
    if hekiliChannel == "Primary" and not watch_primary then return end
    if hekiliChannel == "AOE" and not watch_aoe then return end

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

-- Slash command handler
SLASH_P4DEBUG1 = "/debug"
SlashCmdList["P4DEBUG"] = function()
    showDebug = not showDebug
    print("|cff00ffff[P4] Debug mode: " .. (showDebug and "enabled" or "disabled") .. "|r")
end

SLASH_P4WATCH1 = "/watch"
SlashCmdList["P4WATCH"] = function(msg)
    msg = msg:lower()
    if msg == "primary" then
        watch_primary = not watch_primary
        print("|cff00ffff[P4] Watch Primary: " .. (watch_primary and "enabled" or "disabled") .. "|r")
    elseif msg == "aoe" then
        watch_aoe = not watch_aoe
        print("|cff00ffff[P4] Watch AOE: " .. (watch_aoe and "enabled" or "disabled") .. "|r")
    else
        print("|cffffff00[P4] Usage: /watch Primary or /watch AOE|r")
    end
end