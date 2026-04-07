-- [[ ZAYAC HUB - CLEAN MENU ]] --
repeat task.wait() until game:IsLoaded()

local t = (typeof(getgenv) == "function") and getgenv() or _G

-- Завантажуємо бібліотеку БЕЗ помилок
local libUrl = "https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/ParentLibrary.lua?t=" .. tick()
local success, result = pcall(function() 
    return loadstring(game:HttpGet(libUrl))() 
end)

if success and result then
    local lib = result
    
    -- Перезаписуємо MakeWindow, щоб він працював стабільно
    local oldMW = lib.MakeWindow
    lib.MakeWindow = function(self, options, isHub)
        local window = oldMW(self, options)
        return window -- ТУТ ПОВИНЕН БУТИ RETURN
    end

    t._FIRELIB = lib
    return lib
else
    warn("Помилка завантаження бібліотеки: " .. tostring(result))
end
