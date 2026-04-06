local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local wallScriptEnabled = true

-- 1. ІНТЕРФЕЙС ДЛЯ СПОВІЩЕНЬ (Такий же, як у першому)
local wallGui = Instance.new("ScreenGui")
wallGui.Name = "WallDwellerSystem"
wallGui.ResetOnSpawn = false
wallGui.Parent = playerGui

local function notifyWall(text, color)
    local note = Instance.new("TextLabel")
    note.Size = UDim2.new(0, 300, 0, 50)
    note.Position = UDim2.new(0.5, -150, 0.7, 0) -- Трохи нижче основного, щоб не перекривали один одного
    note.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    note.TextColor3 = color
    note.Text = text
    note.TextSize = 25
    note.Font = Enum.Font.SourceSansBold
    note.Parent = wallGui
    Instance.new("UICorner", note)
    task.delay(2, function()
        TweenService:Create(note, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        task.wait(0.5)
        note:Destroy()
    end)
end

-- 2. ФУНКЦІЯ ВІЗУАЛІЗАЦІЇ (Highlight + Трейсер)
local function applyWallVisuals(obj)
    local root = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
    if not root then return end

    -- Підсвітка
    if not obj:FindFirstChild("WallHighlight") then
        local hl = Instance.new("Highlight", obj)
        hl.Name = "WallHighlight"
        hl.FillColor = Color3.fromRGB(255, 165, 0) -- Помаранчевий для стін
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end

    -- Трейсер (Лінія)
    if not obj:FindFirstChild("WallTracer") then
        local att0 = Instance.new("Attachment", root)
        local beam = Instance.new("Beam", obj)
        beam.Name = "WallTracer"
        beam.Color = ColorSequence.new(Color3.fromRGB(255, 165, 0))
        beam.Width0, beam.Width1 = 1, 1
        beam.Attachment0 = att0
        
        local pRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if pRoot then
            local pAtt = pRoot:FindFirstChild("MT_Att_Wall") or Instance.new("Attachment", pRoot)
            pAtt.Name = "MT_Att_Wall"
            beam.Attachment1 = pAtt
        end
    end
end

-- 3. ОСНОВНИЙ ЦИКЛ ПОШУКУ
task.spawn(function()
    while true do
        if wallScriptEnabled then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") then
                    local name = obj.Name:lower()
                    if name:find("wall") or name:find("dwell") then
                        applyWallVisuals(obj)
                    end
                end
            end
        end
        task.wait(2) -- Перевірка кожні 2 секунди
    end
end)

-- 4. КЕРУВАННЯ КЛАВІШЕЮ K
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.K then
        wallScriptEnabled = not wallScriptEnabled
        if wallScriptEnabled then
            notifyWall("Wall Detector: ON", Color3.fromRGB(0, 255, 0))
        else
            notifyWall("Wall Detector: OFF", Color3.fromRGB(255, 0, 0))
            -- Видаляємо ефекти при вимкненні
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "WallHighlight" or v.Name == "WallTracer" or v.Name == "MT_Att_Wall" then 
                    v:Destroy() 
                end
            end
        end
    end
end)
