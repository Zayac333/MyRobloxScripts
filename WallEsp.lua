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
wallGui.Name = "WallDwellerSystem"
wallGui.IgnoreGuiInset = true
wallGui.ResetOnSpawn = false
wallGui.Parent = playerGui

local wallAlertLabel = Instance.new("TextLabel")
wallAlertLabel.Size = UDim2.new(1, 0, 0.2, 0)
wallAlertLabel.Position = UDim2.new(0, 0, 0.45, 0)
wallAlertLabel.BackgroundTransparency = 1
wallAlertLabel.Text = ""
wallAlertLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
wallAlertLabel.TextSize = 45
wallAlertLabel.Font = Enum.Font.LuckiestGuy
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
    task.delay(2, function()
        TweenService:Create(note, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        task.wait(0.5)
        note:Destroy()
    end)
end

-- 2. ВІЗУАЛІЗАЦІЯ (З ФІКСОМ ПІДСВІТКИ)
local function applyWallVisuals(obj)
    -- Перевіряємо, чи це справді монстр, а не частина кімнати
    local isMonster = obj:FindFirstChildOfClass("Humanoid") or obj:FindFirstChildOfClass("AnimationController")
    if not isMonster then return end

    local root = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    if not root then return end

    if not obj:FindFirstChild("WallHighlight") then
        local hl = Instance.new("Highlight", obj)
        hl.Name = "WallHighlight"
        hl.FillColor = Color3.fromRGB(255, 165, 0)
        hl.OutlineColor = Color3.new(1, 1, 1)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end

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

-- 3. МОНІТОРИНГ (180 СЕКУНД ТА ФІКС КІМНАТИ)
RunService.RenderStepped:Connect(function()
    local text = ""
    local currentTime = tick()
    
    if wallScriptEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local name = obj.Name:lower()
                -- Тільки якщо в назві є wall/dwell ТА це живий об'єкт
                if (name:find("wall") or name:find("dwell")) and (obj:FindFirstChildOfClass("Humanoid") or obj:FindFirstChildOfClass("AnimationController")) then
                    
                    local id = obj:GetDebugId()
                    if not activeWalls[id] then
                        activeWalls[id] = {instance = obj, startTime = currentTime}
                    end

                    local data = activeWalls[id]
                    local duration = currentTime - data.startTime

                    -- ТЕПЕР 180 СЕКУНД
                    if duration > 180 or not obj.Parent then
                        activeWalls[id] = nil
                    else
                        local root = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if root and player.Character and player.Character.PrimaryPart then
                            local dist = math.floor((root.Position - player.Character.PrimaryPart.Position).Magnitude)
                            if dist < 1500 then
                                text = text .. "⚠️ WALL DWELLER [" .. dist .. "m] - " .. math.floor(duration) .. "s\n"
                                applyWallVisuals(obj)
                            end
                        end
                    end
                end
            end
        end
        wallAlertLabel.Text = text
    else
        wallAlertLabel.Text = ""
    end
end)

-- 4. КЕРУВАННЯ [K]
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.K then
        wallScriptEnabled = not wallScriptEnabled
        if wallScriptEnabled then
            notifyWall("Wall Detector: ON", Color3.fromRGB(0, 255, 0))
        else
            notifyWall("Wall Detector: OFF", Color3.fromRGB(255, 0, 0))
            wallAlertLabel.Text = ""
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "WallHighlight" or v.Name == "WallTracer" or v.Name == "MT_Att_Wall" then 
                    v:Destroy() 
                end
            end
            activeWalls = {}
        end
    end
end)
