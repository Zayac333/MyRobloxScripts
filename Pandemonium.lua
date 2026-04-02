local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local isLocked = false
local connection = nil

-- Функція для сповіщення (опціонально)
local function notify(text)
    local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    local label = Instance.new("TextLabel", sg)
    label.Size = UDim2.new(0, 200, 0, 50)
    label.Position = UDim2.new(0.5, -100, 0.8, 0)
    label.Text = text
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextSize = 20
    label.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", label)
    task.delay(1.5, function() sg:Destroy() end)
end

local function toggleMouseLock()
    isLocked = not isLocked
    
    if isLocked then
        notify("Mouse Locked (Center)")
        -- Прив'язуємо курсор до центру кожний кадр
        connection = RunService.RenderStepped:Connect(function()
            -- Встановлюємо курсор у центр екрана
            -- 0.5, 0.5 — це рівно середина монітора
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end)
    else
        notify("Mouse Unlocked")
        if connection then
            connection:Disconnect()
            connection = nil
        end
        -- Повертаємо звичайну поведінку мишки
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end

-- Обробка кнопки T
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.T then
        toggleMouseLock()
    end
end)
