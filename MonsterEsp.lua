local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local scriptEnabled = true
local activeMonsters = {}

-- 1. ІНТЕРФЕЙС
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MonsterSystemFinal"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local alertLabel = Instance.new("TextLabel")
alertLabel.Size = UDim2.new(1, 0, 0.2, 0)
alertLabel.Position = UDim2.new(0, 0, 0.25, 0)
alertLabel.BackgroundTransparency = 1
alertLabel.Text = ""
alertLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
alertLabel.TextSize = 45
alertLabel.Font = Enum.Font.LuckiestGuy
alertLabel.Parent = screenGui

local function notify(text, color)
    local note = Instance.new("TextLabel")
    note.Size = UDim2.new(0, 300, 0, 50)
    note.Position = UDim2.new(0.5, -150, 0.8, 0)
    note.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    note.TextColor3 = color
    note.Text = text
    note.TextSize = 25
    note.Font = Enum.Font.SourceSansBold
    note.Parent = screenGui
    Instance.new("UICorner", note)
    task.delay(2, function()
        TweenService:Create(note, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        task.wait(0.5)
        note:Destroy()
    end)
end

-- 2. ВІЗУАЛЬНІ ЕФЕКТИ
local function applyVisuals(monster)
    local root = monster:IsA("Model") and (monster.PrimaryPart or monster:FindFirstChildWhichIsA("BasePart")) or monster
    if not root then return end

    if not monster:FindFirstChild("MonsterHighlight") then
        local hl = Instance.new("Highlight", monster)
        hl.Name = "MonsterHighlight"
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
    
    if not monster:FindFirstChild("MonsterTracer") then
        local att0 = Instance.new("Attachment", root)
        local beam = Instance.new("Beam", monster)
        beam.Name = "MonsterTracer"
        beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
        beam.Width0, beam.Width1 = 1, 1
        beam.Attachment0 = att0
        
        local pRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if pRoot then
            local pAtt = pRoot:FindFirstChild("MT_Att") or Instance.new("Attachment", pRoot)
            pAtt.Name = "MT_Att"
            beam.Attachment1 = pAtt
        end
    end

    if not monster:FindFirstChild("MonsterSphere") then
        local sphere = Instance.new("SelectionSphere")
        sphere.Name = "MonsterSphere"
        sphere.Adornee = root
        sphere.Color3 = Color3.fromRGB(255, 0, 0)
        sphere.Transparency = 0.6
        sphere.Parent = monster
    end
end

-- 3. ДЕТЕКЦІЯ (ДОДАНО БЛЕКЛІСТ)
local function checkMonster(child)
    task.wait(0.2)
    if not scriptEnabled or not child or not child.Parent then return end
    
    local name = child.Name:lower()
    -- Твій новий блекліст тут:
    if name:find("orb") or name:find("ambience") or name:find("light") or name:find("proxy") or name:find("vent") then 
        return 
    end
    
    if (child:IsA("Model") or child:IsA("BasePart")) and not Players:GetPlayerFromCharacter(child) then
        local inEntities = child.Parent.Name == "Entities" or child.Parent.Name == "Monsters"
        local hasSound = child:FindFirstChildOfClass("Sound", true)
        
        if (inEntities or hasSound) then
            local id = child:GetDebugId()
            if not activeMonsters[id] then
                activeMonsters[id] = {instance = child, name = child.Name, startTime = tick()}
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    local text = ""
    local currentTime = tick()
    
    if scriptEnabled then
        for id, data in pairs(activeMonsters) do
            local duration = currentTime - data.startTime
            
            if duration > 60 or not data.instance or not data.instance.Parent then
                activeMonsters[id] = nil
            else
                local root = data.instance:IsA("Model") and (data.instance.PrimaryPart or data.instance:FindFirstChildWhichIsA("BasePart")) or data.instance
                if root and player.Character and player.Character.PrimaryPart then
                    local dist = math.floor((root.Position - player.Character.PrimaryPart.Position).Magnitude)
                    if dist < 1500 then
                        text = text .. "⚠️ " .. data.name:upper() .. " [" .. dist .. "m] - " .. math.floor(duration) .. "s\n"
                        applyVisuals(data.instance)
                    else activeMonsters[id] = nil end
                end
            end
        end
        alertLabel.Text = text
    else
        alertLabel.Text = ""
    end
end)

workspace.ChildAdded:Connect(checkMonster)

UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.B then
        scriptEnabled = not scriptEnabled
        if scriptEnabled then
            notify("Скрипт увімкнено", Color3.fromRGB(0, 255, 0))
        else
            notify("Скрипт відключено", Color3.fromRGB(255, 0, 0))
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "MonsterHighlight" or v.Name == "MonsterTracer" or v.Name == "MonsterSphere" then v:Destroy() end
            end
        end
    end
end)
