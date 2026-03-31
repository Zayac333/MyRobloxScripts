local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local fbEnabled = false

-- Зберігаємо стандартні налаштування гри, щоб можна було повернути все назад
local defaultSettings = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

local function toggleFullBright()
    fbEnabled = not fbEnabled
    
    if fbEnabled then
        -- Вмикаємо FullBright
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        print("FullBright: ON")
    else
        -- Повертаємо як було
        Lighting.Ambient = defaultSettings.Ambient
        Lighting.Brightness = defaultSettings.Brightness
        Lighting.FogEnd = defaultSettings.FogEnd
        Lighting.GlobalShadows = defaultSettings.GlobalShadows
        Lighting.OutdoorAmbient = defaultSettings.OutdoorAmbient
        print("FullBright: OFF")
    end
end

-- Обробка натискання клавіші Y
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end -- Ігноруємо, якщо ти пишеш у чат
    if input.KeyCode == Enum.KeyCode.Y then
        toggleFullBright()
    end
end)

-- Постійна підтримка світла (на випадок, якщо гра намагається його змінити)
game:GetService("RunService").RenderStepped:Connect(function()
    if fbEnabled then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.FogEnd = 100000
    end
end)
