-- Налаштування
local ESP_COLOR = Color3.fromRGB(255, 0, 0) -- Червоний для Dummy
local Players = game:GetService("Players")

local function applyESP(object)
    -- Перевіряємо, чи це модель з гуманоїдом
    if object:IsA("Model") and object:FindFirstChild("Humanoid") then
        
        -- ГОЛОВНА ПЕРЕВІРКА: чи є ця модель персонажем реального гравця?
        if Players:GetPlayerFromCharacter(object) then
            return -- Якщо це гравець, нічого не робимо (виходимо з функції)
        end

        -- Якщо це НЕ гравець, але називається "Dummy" (або просто NPC)
        if not object:FindFirstChild("ESPHighlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = ESP_COLOR
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.Adornee = object
            highlight.Parent = object
            
            -- Додамо тег над головою для зручності
            print("Знайдено NPC/Dummy: " .. object.Name)
        end
    end
end

-- Очищення існуючих підсвічувань перед запуском (про всяк випадок)
local function clearExisting()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name == "ESPHighlight" then obj:Destroy() end
    end
end

-- Ініціалізація
clearExisting()
for _, obj in pairs(game.Workspace:GetDescendants()) do
    applyESP(obj)
end

-- Слідкуємо за новими об'єктами
game.Workspace.DescendantAdded:Connect(function(newObj)
    task.wait(0.1)
    applyESP(newObj)
end)
