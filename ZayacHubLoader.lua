local PlaceId = game.PlaceId

local PressureGames = {
    [12552538292] = true,
    [12411473842] = true, 
    [12552511828] = true,
    [124505452456262] = true 
}

local TSBGames = {
    [10449761463] = true,
    [12360882630] = true, 
    [131048399685555] = true 
}

local JJSGames = {
    [9391468976] = true 
}

local RakeGames = {
    [2413927524] = true,
    [8795690372] = true 
}

local AtOTGames = {
    [13379208636] = true,
    [126678335159530] = true,
    [17688739434] = true,
    [14638336319] = true,
    [15030367419] = true,
    [15374465998] = true,
    [13904207646] = true,
    [13379349730] = true,
    [15824912319] = true,
    [14916516914] = true,
    [14932214603] = true,
    [112374853034490] = true,
    [14012874501] = true,
    [15220308770] = true
}

local FTaPGames = {
    [6961824067] = true 
}

if PressureGames[PlaceId] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/Pressure/main/ZayacHub.lua", true))()
    
elseif TSBGames[PlaceId] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/ZayacHubEsp.lua", true))()

elseif JJSGames[PlaceId] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/ZayacJjs.lua", true))()
    
elseif RakeGames[PlaceId] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RunDTM/ZeeroxHub/main/scripts/TheRake.lua", true))()

elseif AtOTGames[PlaceId] then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/705e7fe7aa288f0fe86900cedb1119b1.lua", true))()

elseif FTaPGames[PlaceId] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/NameHubScript/_/refs/heads/main/f", true))()
    
else
    warn("ZayacHub: Game not supported. ID: " .. PlaceId)
end
