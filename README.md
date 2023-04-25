# AMTKit
A BeamMP plugin for banning and kicking on BeamMP servers. Supports multiple servers with one file.

#### Set up:
To install just move the AMTKit folder into `/Resources/Server/`. Blacklist and authlist files will be created a directory up from where the BeamMP-server executable is located.

- To block guest accounts from joining, change allowGuests in config.lua to false if needed. 
- Set staffSlot to true if needed. Staff slot reserves a slot when the server is full for a player with staff permissions to join.

To add bans/permissions manually, just add the names to the appropriate file on separate lines. The blacklist and authlist are case sensitive.

To add custom responses, just add the command and response into response.lua

#### User Commands:
To see usernames and ID's<br>
`/id`

Shows the message of the day<br>
`/motd`

Messages player matching the ID<br>
`/dm (id) (message)`

Starts a countdown from 3<br>
`/countdown`

#### Elevated Commands:

To kick a player <br>
`/kick (id)` 

To ban a player <br>
`/ban (username)`

To ban and kick simultaneously <br>
`/kban (id)`
