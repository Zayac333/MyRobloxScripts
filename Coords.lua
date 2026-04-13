-- Zayac XYZ Tracker v2.0 (Screen Edition)
local lp = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local sg = Instance.new("ScreenGui", game.CoreGui)

-- Головний контейнер
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 90)
frame.Position = UDim2.new(0.5, -110, 0.85, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Скруглення кутів
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

-- Заголовок
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "📍 CURRENT COORDINATES"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 12

-- Текст з координатами
local coordsLabel = Instance.new("TextLabel", frame)
coordsLabel.Size = UDim2.new(1, 0, 0, 30)
coordsLabel.Position = UDim2.new(0, 0, 0, 25)
coordsLabel.BackgroundTransparency = 1
coordsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
coordsLabel.Font = Enum.Font.Code
coordsLabel.TextSize = 16
coordsLabel.Text = "X: 0 | Y: 0 | Z: 0"

-- Кнопка копіювання
local copyBtn = Instance.new("TextButton", frame)
copyBtn.Size = UDim2.new(0.8, 0, 0, 25)
copyBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
copyBtn.Text = "Copy to Clipboard"
copyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
copyBtn.Font = Enum.Font.Gotham
copyBtn.TextSize = 12

local btnCorner = Instance.new("UICorner", copyBtn)
btnCorner.CornerRadius = UDim.new(0, 4)

-- Логіка оновлення
runService.RenderStepped:Connect(function()
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local p = root.Position
        coordsLabel.Text = string.format("X: %.2f | Y: %.2f | Z: %.2f", p.X, p.Y, p.Z)
    end
end)

-- Логіка копіювання
copyBtn.MouseButton1Click:Connect(function()
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local p = root.Position
        local formatted = string.format("Vector3.new(%.2f, %.2f, %.2f)", p.X, p.Y, p.Z)
        setclipboard(formatted) -- Копіює готовий код для Lua
        
        copyBtn.Text = "COPIED!"
        copyBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(1)
        copyBtn.Text = "Copy to Clipboard"
        copyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)
