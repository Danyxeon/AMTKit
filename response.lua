local response = {}

local nativeCommands = {
    -- Elev
    id = "/id",
	kick = "/kick",
	kban = "/kban",
	ban = "/ban",
    version = "/version",

    -- User
    countdown = "/countdown",
    dm = "/dm"
}

-- Only modify from here down --

local motd = ""

local chatCommands = {
	motd = "/motd",
	example = "/example"
}

local elevChatCommands = {
	example = "/elevExample"
}
    
local chatMessages = {
    motd = motd,
	example = "Lorem ipsum"
}

local elevChatMessages = {
    elevExample = "Elevated lorem ipsum"
}
    
return {nativeCommands = nativeCommands, motd = motd, nativeFunctions = nativeFunctions, chatCommands = chatCommands, chatMessages = chatMessages, elevChatCommands = elevChatCommands, elevChatMessages = elevChatMessages}
    
    
    
    