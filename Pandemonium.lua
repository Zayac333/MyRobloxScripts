local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local isLocked = false
local connection = nil

-- Функція для сповіщення
local function notify(text)
    local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    local label = Instance.new("TextLabel", sg)
    label.Size = UDim2.new(0, 250, 0, 50)
    label.Position = UDim2.new(0.5, -125, 0.2, 0) -- Зверху екрана
    label.Text = text
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextSize = 22
    label.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", label)
    task.delay(2, function() sg:Destroy() end)
end

local function toggleMouseLock()
    isLocked = not isLocked
    
    if isLocked then
        notify("PANDEMONIUM MODE: ON")
        
        connection = RunService.RenderStepped:Connect(function()
            -- 1. Вираховуємо центр екрана прямо зараз
            local screenSize = camera.ViewportSize
            local centerX = screenSize.X / 2
            local centerY = screenSize.Y / 2
            
            -- 2. Силоміць ставимо мишку в центр (через Virtual Input або Behavior)
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            
            -- Додаткова перевірка: якщо гра намагається звільнити мишку, ми її повертаємо
            if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            end
        end)
    else
        notify("PANDEMONIUM MODE: OFF")
        if connection then
            connection:Disconnect()
            connection = nil
        end
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end

-- Кнопка T
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.T then
        toggleMouseLock()
    end
end)
