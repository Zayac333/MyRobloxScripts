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
    [2413927524] = true 
    [8795690372] = true 
}

if PressureGames[PlaceId] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/Pressure/main/ZayacHub.lua", true))()
    
elseif TSBGames[PlaceId] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/ZayacHubEsp.lua", true))()

elseif JJSGames[PlaceId] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/ZayacJjs.lua", true))()
    
elseif RakeGames[PlaceId] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/TheRake/main/ZayacHub.lua", true))()
    
else
    warn("ZayacHub: Game not supported. ID: " .. PlaceId)
end
