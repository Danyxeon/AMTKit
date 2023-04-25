local util = require("util")
local response = require("response")
local cfg = require("config")

release = "2.0.0"

function onInit()
	print("\n")
	print("AMTKit " .. release .. " Loaded")

	MP.RegisterEvent("onPlayerAuth", "onPlayerAuth")
	MP.RegisterEvent("onChatMessage", "onChatMessage")
	MP.RegisterEvent("onVehicleSpawn", "onVehicleSpawn")

	util.initList()
	beamcfg = util.readConfig()
	print("AMTKit: All systems go!")
end

function onPlayerAuth(name, role, isGuest)
	local playersCurrent = MP.GetPlayerCount()
	local name = util.parseName(name)
	
	if isGuest and not cfg.allowGuests then
		return "You must be signed in to join this server!"
	end

	if cfg.staffSlot then
		if playersCurrent == (beamcfg.playerLimit - 1) and not string.match(util.readAuthFile(), name) then
			return "The server is full. Last slot is reserved for staff."
		end
	end
	
	print("AMTKit: Checking player blacklist for " .. name)
	   
	if string.match(util.readBanFile(), name) then
		return "You have been banned from the server."
	else
		print("AMTKit: All good, user clear to join.")
	end

end

function onVehicleSpawn(playerID)
	local playerVehicles = MP.GetPlayerVehicles(playerID)
	local playerCarCount = 0

	if playerVehicles then
		for _ in pairs(playerVehicles) do playerCarCount = playerCarCount + 1 end
	end

	-- + 1 to account for unicycle
	-- Attempted fix for unicycle spam bug:
	if (playerCarCount + 1) > beamcfg.carLimit + 1 then
		MP.DropPlayer(playerID)
		MP.SendChatMessage(-1, "Player " .. MP.GetPlayerName(playerID) .. " was kicked for spawning more than " .. beamcfg.carLimit + 1 .. " cars.")
		print("AMTKit: Player " .. MP.GetPlayerName(playerID) .. " was kicked for spawning too many cars.")
	end

end

function onChatMessage(playerID, senderName, message)
	local msgTxt = string.match(message, "%s(.*)")
	local msgNum = tonumber(string.match(message, "%d+"))

	-- Check message for nativeCommands
	for command, match in pairs(response.nativeCommands) do
		local cmdMatch = string.match(message, match)

		if cmdMatch then

			if command == "id" then
				util.id(playerID, beamcfg.playerLimit)
				return -1

			elseif command == "countdown" then
				util.countdown()
				return -1

			elseif command == "dm" then
				local dmTxt = string.sub(message, 6)
				util.dmsg(playerID, msgNum, dmTxt)
				return -1

			end

			break
		end
	end

	-- Check message for chatCommands
	for command, match in pairs(response.chatCommands) do
		local cmdMatch = string.match(message, match)
		if cmdMatch then
			util.msgSelect(playerID, command)
			return -1
		end
	end

	-- Check if sender has elevated permissions
	if util.isAuthorized(senderName) then
		-- Check message for elevChatCommands
		for command, match in pairs(response.elevChatCommands) do
			local cmdMatch = string.match(message, match)
			if cmdMatch then
				util.elevMsgSelect(playerID, command, msgNum)
				return -1
			end
		end
		-- Todo: make below into above and add countdown and DM system
		-- Check message for elevated native commands
		for command, match in pairs(response.nativeCommands) do
			local cmdMatch = string.match(message, match)

			if cmdMatch then

				if command == "kick" then
					util.kickPlayer(playerID, msgNum)
					return -1

				elseif command == "kban" then
					util.kbanPlayer(playerID, msgNum)
					return -1

				elseif command == "ban" then
					util.banPlayer(playerID, msgTxt)
					return -1

				elseif command == "version" then
					util.ver(playerID)
					return -1

				end

				break
			end
		end

		
	end
end



