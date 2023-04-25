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

local motd = "Welcome to the ApolloHub roleplay server! To get started on the server please join the Discord server. You can get the address by using the command /discord. When you get to the server and read the rules, continue to the instructions channel for info on how to play and use the economy!"

local chatCommands = {
    motd = "/motd",
    discord = "/discord",
    help = "/help"
}

local elevChatCommands = {
    askdc = "/askdc",
    askpay = "/askpay",
    warnfrp = "/warnfrp",
    warngen = "/warngen"
}
    
local chatMessages = {
    motd = motd,
    discord = "Join the ApolloHub Discord server at https://discord.gg/apollohub!",
    help = "Available commands: /motd Shows the welcome message for the server. /countdown - Starts a countdown. /discord - Shows the ApolloHub Discord server link. /id - Shows player ids. /dm (id) (message) - Sends a private message."
}

local elevChatMessages = {
    askdc = ", are you already a member of the ApolloHub Discord? If so, what is your Discord username, please?",
    askpay = ", did you pay for that vehicle using the economy on the Discord server?",
    warnfrp = ", reminder that racing/drifting in town and around other players is a punishable offense and will be enforced.",
    warngen = ", this is a warning. Continuing with this behavior will get you removed from our server, please refrain from breaking the server rules again."
}
    
return {nativeCommands = nativeCommands, motd = motd, nativeFunctions = nativeFunctions, chatCommands = chatCommands, chatMessages = chatMessages, elevChatCommands = elevChatCommands, elevChatMessages = elevChatMessages}
    
    
    
    