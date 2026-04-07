repeat task.wait() until game:IsLoaded()

-- Функція для видалення чужих вікон
local function cleanup()
    for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v:IsA("ScreenGui") and (v.Name:find("Fire") or v:FindFirstChild("MainFrame")) then
            v:Destroy()
        end
    end
end
cleanup() -- Чистимо перед завантаженням

local function getGlobalTable()
    return typeof(getgenv) == "function" and typeof(getgenv()) == "table" and getgenv() or _G
end
local t = getGlobalTable()

-- Завантажуємо бібліотеку з ПОВНИМ ігноруванням кешу
local libUrl = "https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/ParentLibrary.lua?nocache=" .. tick()
local lib = loadstring(game:HttpGet(libUrl))()

if lib then
    local mw = lib.MakeWindow
    lib.MakeWindow = function(self, options, fireHubWindow)
        cleanup() -- Чистимо ще раз перед створенням твого вікна
        local window = mw(self, options)
        return window
    end
end

t._FIRELIB = lib
return lib
