local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local wallScriptEnabled = true
local activeWalls = {}

-- 1. ІНТЕРФЕЙС
local wallGui = Instance.new("ScreenGui")
wallGui.Name = "WallDwellerSystem_Opt"
wallGui.IgnoreGuiInset = true
wallGui.ResetOnSpawn = false
wallGui.Parent = playerGui

local wallAlertLabel = Instance.new("TextLabel")
wallAlertLabel.Size = UDim2.new(1, 0, 0.2, 0)
wallAlertLabel.Position = UDim2.new(0, 0, 0.45, 0)
wallAlertLabel.BackgroundTransparency = 1
wallAlertLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
wallAlertLabel.TextSize = 45
wallAlertLabel.Font = Enum.Font.LuckiestGuy
wallAlertLabel.Text = ""
wallAlertLabel.Parent = wallGui

local function notifyWall(text, color)
    local note = Instance.new("TextLabel")
    note.Size = UDim2.new(0, 300, 0, 50)
    note.Position = UDim2.new(0.5, -150, 0.7, 0)
    note.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    note.TextColor3 = color
    note.Text = text
    note.TextSize = 25
    note.Font = Enum.Font.SourceSansBold
    note.Parent = wallGui
    Instance.new("UICorner", note)
    
    local tween = TweenService:Create(note, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 2), {TextTransparency = 1, BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function() note:Destroy() end)
end

-- 2. ВІЗУАЛІЗАЦІЯ
local function applyWallVisuals(obj, root)
    if not obj:FindFirstChild("WallHighlight") then
        local hl = Instance.new("Highlight", obj)
        hl.Name = "WallHighlight"
        hl.FillColor = Color3.fromRGB(255, 165, 0)
        hl.OutlineColor = Color3.new(1, 1, 1)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end

    if not obj:FindFirstChild("WallTracer") then
        local att0 = Instance.new("Attachment", root)
        att0.Name = "WallAtt"
        local beam = Instance.new("Beam", obj)
        beam.Name = "WallTracer"
        beam.Color = ColorSequence.new(Color3.fromRGB(255, 165, 0))
        beam.Width0, beam.Width1 = 0.5, 0.5
        beam.Attachment0 = att0
        
        local pRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if pRoot then
            local pAtt = pRoot:FindFirstChild("MT_Att_Wall") or Instance.new("Attachment", pRoot)
            pAtt.Name = "MT_Att_Wall"
            beam.Attachment1 = pAtt
        end
    end
end

-- 3. ОПТИМІЗОВАНА ДЕТЕКЦІЯ
local function checkObject(obj)
    if not obj:IsA("Model") then return end
    
    local name = obj.Name:lower()
    if (name:find("wall") or name:find("dwell")) then
        -- Швидка перевірка на "живість" монстра
        task.wait(0.1) -- Даємо час підвантажитись гуманоїду
        if obj:FindFirstChildOfClass("Humanoid") or obj:FindFirstChildOfClass("AnimationController") then
            local root = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if root then
                local id = obj:GetDebugId()
                if not activeWalls[id] then
                    activeWalls[id] = {instance = obj, root = root, startTime = tick()}
                end
            end
        end
    end
end

-- Початкове сканування та підписка на нові об'єкти
workspace.DescendantAdded:Connect(checkObject)
for _, v in pairs(workspace:GetDescendants()) do task.spawn(checkObject, v) end

-- 4. ОНОВЛЕННЯ ТЕКСТУ (RenderStepped тепер легкий)
RunService.RenderStepped:Connect(function()
    if not wallScriptEnabled then 
        wallAlertLabel.Text = ""
        return 
    end

    local text = ""
    local now = tick()
    local charRoot = player.Character and player.Character.PrimaryPart

    for id, data in pairs(activeWalls) do
        local obj = data.instance
        local duration = now - data.startTime

        -- Перевірка на 180 секунд та існування
        if duration > 180 or not obj or not obj.Parent then
            activeWalls[id] = nil
            continue
        end

        if charRoot and data.root then
            local dist = math.floor((data.root.Position - charRoot.Position).Magnitude)
            if dist < 1000 then
                text = text .. "⚠️ WALL DWELLER [" .. dist .. "m] - " .. math.floor(duration) .. "s\n"
                applyWallVisuals(obj, data.root)
            end
        end
    end
    wallAlertLabel.Text = text
end)

-- 5. КЕРУВАННЯ
UserInputService.InputBegan:Connect(function(input, proc)
    if proc or input.KeyCode ~= Enum.KeyCode.K then return end
    
    wallScriptEnabled = not wallScriptEnabled
    if wallScriptEnabled then
        notifyWall("Wall Detector: ON", Color3.fromRGB(0, 255, 0))
    else
        notifyWall("Wall Detector: OFF", Color3.fromRGB(255, 0, 0))
        for id, data in pairs(activeWalls) do
            if data.instance then
                local h = data.instance:FindFirstChild("WallHighlight")
                local t = data.instance:FindFirstChild("WallTracer")
                if h then h:Destroy() end
                if t then t:Destroy() end
            end
        end
        activeWalls = {}
    end
end)
