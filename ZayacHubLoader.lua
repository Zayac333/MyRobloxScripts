local PlaceId = game.PlaceId

-- Список ігор для Pressure (Давление)
local PressureGames = {
    [12552538292] = true, -- Основна гра
    [12411473842] = true, -- Лобі
    [12552511828] = true, -- Операція Heartbeat
    [124505452456262] = true -- Інше
}

-- Список ігор для TSB (The Strongest Battlegrounds)
local TSBGames = {
    [10449761463] = true, -- ТСБ основний
    [12360882630] = true, -- ТСБ дуелі
    [131048399685555] = true -- ТСБ ВС
}

-- Список ігор для JJS (Jujutsu Shenanigans)
local JJSGames = {
    [9391468976] = true -- ЖЖС
}

if PressureGames[PlaceId] then
    -- Завантаження для Pressure
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/Pressure/main/ZayacHub.lua", true))()
    
elseif TSBGames[PlaceId] then
    -- Завантаження для TSB
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/MyLiteHub.lua", true))()

elseif JJSGames[PlaceId] then
    -- Завантаження для ЖЖС (нове посилання)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/MiLiteHub2.lua", true))()
    
else
    -- Якщо гри немає в списку
    warn("ZayacHub: Game not supported. ID: " .. PlaceId)
end
