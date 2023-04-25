local response = require("response")
local tomlParser = require("toml")
local cfg = require("config")

local util = {}

-- Todo
-- Add console interactibility

-- Parse config file

util.readConfig = function()
    
	local tomlFile = io.open("ServerConfig.toml", "r")
	local contents = tomlFile:read("*all")
	tomlFile:close()

	local parsed = tomlParser.parse(contents)
	local playerLimit = parsed.General.MaxPlayers
    local carLimit = parsed.General.MaxCars

    print("AMTKit: ServerConfig.toml loaded.")
    return {playerLimit = playerLimit, carLimit = carLimit}
end

-- File initialization --

-- Todo: multiMode switch to toggle file paths
-- util.multiModeCheck = function(fileName)
   -- return cfg.multiMode and ("../" .. fileName) or ("data/" .. fileName)
-- end

util.readAuthFile = function()
    local path = "../authlist"
    local authFile = io.open(path, "r")

	if not authFile then
		print("AMTKit: Permissions file not found. Creating...")
		authFile = io.open(path, "w")
        authFile:close()
        authFile = io.open(path, "r")
	end
    
	local authlist = authFile:read("*all")

	authFile:close()

	return authlist
end

util.readBanFile = function(rwSw, wrInput)
    local path = "../blacklist"
    local blFile = io.open(path, rwSw and "a+" or "r")

    if not blFile then
        print("AMTKit: Player blacklist file not found. Creating...")
        blFile = io.open(path, "w")
        blFile:close()
        blFile = io.open(path, rwSw and "a+" or "r")
    end

    local blacklist = blFile:read("*all")

    if wrInput then
        blFile:write(wrInput)
        blFile:flush()
        blacklist = blacklist .. wrInput
    end

    blFile:close()

    return blacklist
end

-- General --

util.initList = function()
    local files = {
        {util.readBanFile, "Player blacklist loaded."},
        {util.readAuthFile, "Permissions list loaded."}
    }

    for _, file in ipairs(files) do
        if file[1]() then
            print("AMTKit: " .. file[2])
        else
            print("AMTKit: WARNING: " .. file[2] .. " loading failed.")
        end
    end
end

util.parseName = function(name)
    local pattern = {"%-"}
    local patternout = {"%%-"}

    for i = 1, # pattern do
        name = name:gsub(pattern[i], patternout[i])
    end
    return name
end

util.isAuthorized = function(senderName)
    local authMatch = string.match(util.readAuthFile(), senderName)
    if senderName == authMatch then
        return true
    else
        return false
    end
end

util.msgCheck = function(playerID, msgNum)
    local idCheck = not msgNum
    local playerCheck = MP.GetPlayerName(msgNum) == "" or MP.GetPlayerName(msgNum) == nil

    local cases = {
        {idCheck, "No ID given or invalid ID."},
        {playerCheck, "Player does not exist."}
    }

    for _, case in ipairs(cases) do
        if case[1] then
            MP.SendChatMessage(playerID, case[2])
            return false
        end
    end

    return true
end

-- Custom response functions

util.msgSelect = function(playerID, command)
    for chatMessage, match in pairs(response.chatMessages) do
        local msgMatch = string.match(chatMessage, command)
        
        if msgMatch then
            local chatMessageStr = response.chatMessages[msgMatch]
            MP.SendChatMessage(playerID, chatMessageStr)
            break
        end
    end 
end

util.elevMsgSelect = function(playerID, command, msgNum)
    for elevChatMessage, match in pairs(response.elevChatMessages) do
        local msgMatch = string.match(elevChatMessage, command)

        if msgMatch and util.msgCheck(playerID, msgNum) then
            local playerName = MP.GetPlayerName(msgNum)
            local elevChatMessageStr = playerName .. response.elevChatMessages[msgMatch]
            MP.SendChatMessage(playerID, elevChatMessageStr)
            MP.SendChatMessage(msgNum, elevChatMessageStr)
            break
        end
    end 
end

-- User functions

util.id = function(playerID, playerLimit)
    local i = playerLimit
    
    if not cfg.staffSlot then
        playerLimit = playerLimit - 1
    end
    
    while i >= 0 do
        local playerName = MP.GetPlayerName(i)
        if playerName ~= "" then
            playerName = i .. " - " .. playerName
            MP.SendChatMessage(playerID, playerName)
        end
        i = i - 1
    end
end

util.countdown = function()
    local i = 3
    while i > 0 do
        MP.SendChatMessage(-1, "Countdown: " .. i)
        i = i - 1
        MP.Sleep(1000)
    end
    MP.SendChatMessage(-1, "Go!")
end

util.dmsg = function(playerID, msgNum, dmTxt)
    if util.msgCheck(playerID, msgNum) then
        if dmTxt == "" then
            MP.SendChatMessage(playerID, "No message or invalid format.")
        else
            MP.SendChatMessage(playerID, "To " .. MP.GetPlayerName(msgNum) .. ":" .. dmTxt)
            MP.SendChatMessage(msgNum, "From " .. MP.GetPlayerName(playerID) .. ":" .. dmTxt)
        end
    end
end

-- Elevated functions

util.ver = function(playerID)
    MP.SendChatMessage(playerID, "This server is running AMTKit version " .. release)
end

util.kickPlayer = function(playerID, msgNum)
    if util.msgCheck(playerID, msgNum) then
        MP.DropPlayer(msgNum)
        MP.SendChatMessage(playerID, "Kicked player " .. MP.GetPlayerName(msgNum))
    end
end

util.kbanPlayer = function(playerID, msgNum)
    if util.msgCheck(playerID, msgNum) then
        local KbanUsr = MP.GetPlayerName(msgNum)
        local i = "\n" .. KbanUsr
        util.readBanFile(true, i)
        MP.DropPlayer(msgNum)
        MP.SendChatMessage(playerID, "Banned user " .. KbanUsr)
    end
end

util.banPlayer = function(playerID, msgTxt)
    if not msgTxt or msgTxt == "" then
        MP.SendChatMessage(playerID, "Invalid username")
    else
        local i = "\n" .. msgTxt
        util.readBanFile(true, i)
        MP.SendChatMessage(playerID, "Banned user " .. msgTxt)
    end
end

return util