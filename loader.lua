-- [[ ПІДКЛЮЧЕННЯ ТВОЇХ БІБЛІОТЕК ]] --
-- Використовуємо raw посилання, щоб скрипт міг зчитати чистий код
local network = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/Librare2.lua", true))()
local espLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/Librare.lua", true))()

print("Бібліотеки Zayac333 завантажено!")

-- [[ 1. БЛОКУВАННЯ УРОНУ (GODMODE ВІД ОЧЕЙ) ]] --
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Блокуємо івент LocalDamage, щоб Eyefestation не зносила HP
    if method == "FireServer" and self.Name == "LocalDamage" then
        return nil 
    end
    
    return oldNamecall(self, ...)
end)

-- [[ 2. АВТО-ВИМКНЕННЯ EYEFESTATION ]] --
task.spawn(function()
    while task.wait(0.5) do
        -- Перевіряємо наявність папки з монстрами
        local monstersFolder = workspace:FindFirstChild("GameplayFolder") and workspace.GameplayFolder:FindFirstChild("Monsters")
        
        if monstersFolder then
            for _, monster in pairs(monstersFolder:GetChildren()) do
                -- Шукаємо за назвою (Eye/Shark)
                if monster.Name:lower():match("eyefestation") then
                    local active = monster:FindFirstChild("Active")
                    if active and active.Value == true then
                        active.Value = false
                        print("Eyefestation (Shark) neutralized!")
                    end
                end
            end
        end
    end
end)

-- [[ 3. ОСНОВНА ЛОГІКА ТА ESP ]] --
local vals = {
    AntiEyefestation = true,
    InstantInteract = true
}

-- Швидка взаємодія через твій network
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if vals.InstantInteract then
        -- Викликаємо функцію кліку з бібліотеки
        if network and network.Other then
            network.Other:FireProximityPrompt(prompt)
        else
            fireproximityprompt(prompt)
        end
    end
end)

print("--- Anti-Eyefestation Shield & Libraries Active ---")
