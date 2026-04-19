local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Hub | Color Customizer",
   LoadingTitle = "Loading Engine...",
   LoadingSubtitle = "by Zayac",
   ConfigurationSaving = { Enabled = false }
})

-- --- ГЛОБАЛЬНІ НАЛАШТУВАННЯ ---
getgenv().EffectsColor = Color3.fromRGB(255, 255, 255)

-- ==========================================
-- --- ЯДРО ФАРБУВАННЯ (НЕ ВМИРАЄ) ---
-- ==========================================
local function ApplyColor(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        local seq = ColorSequence.new({
            ColorSequenceKeypoint.new(0, getgenv().EffectsColor),
            ColorSequenceKeypoint.new(1, getgenv().EffectsColor),
        })
        obj.Color = seq
    end
end

local function StartColorMonitor(char)
    if not char then return end
    
    -- Фарбуємо все існуюче
    for _, desc in pairs(char:GetDescendants()) do
        ApplyColor(desc)
    end
    
    -- Стежимо за новими ефектами
    char.DescendantAdded:Connect(function(desc)
        task.wait() 
        ApplyColor(desc)
    end)
end

-- Респавн-менеджер
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    StartColorMonitor(char)
end)

-- Старт для поточного персонажа
if game.Players.LocalPlayer.Character then
    task.spawn(function() StartColorMonitor(game.Players.LocalPlayer.Character) end)
end

-- ==========================================
-- --- ГОЛОВНА ВКЛАДКА ---
-- ==========================================
local MainTab = Window:CreateTab("Settings", 4483362458)

MainTab:CreateColorPicker({
    Name = "Effect Color",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        getgenv().EffectsColor = Value
        -- Миттєве оновлення
        if game.Players.LocalPlayer.Character then
            for _, desc in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                ApplyColor(desc)
            end
        end
    end
})

MainTab:CreateLabel("Вибери колір вище, щоб змінити ефекти ударів")

Rayfield:Notify({
    Title = "Zayac Hub",
    Content = "Скрипт готовий до роботи!",
    Duration = 5
})
