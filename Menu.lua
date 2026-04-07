repeat task.wait() until game:IsLoaded()

local libUrl = "https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/ParentLibrary.lua?t=" .. tick()
local rawCode = game:HttpGet(libUrl)
local success, result = pcall(function() return loadstring(rawCode)() end)

if success and result then
    local lib = result
    
    -- Фікс для MakeWindow
    local oldMW = lib.MakeWindow
    lib.MakeWindow = function(self, options)
        local window = oldMW(self, options)
        return window
    end

    return lib
else
    warn("Критична помилка завантаження бібліотеки!")
    return nil
end
