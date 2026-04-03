local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Ultimate v5.7",
   LoadingTitle = "System Overhaul...",
   LoadingSubtitle = "by Zayac333",
   ConfigurationSaving = { Enabled = false }
})

-- Змінні
getgenv().SpeedEnabled = false
getgenv().SpeedValue = 80
getgenv().SelectedPlayer = nil
getgenv().LoopTP = false
getgenv().DeathCounterESP = false
getgenv().ClickFlingEnabled = false
getgenv().AntiFlingEnabled = false
getgenv().IsFlinging = false -- Для розумного анти-флінгу

local function getPlayer(name)
    name = name:lower()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name or p.DisplayName:lower():sub(1, #name) == name then
            return p
        end
    end
end

local MainTab = Window:CreateTab("Movement", 4483362458)
local PlayerTab = Window:CreateTab("Players", 4483362458)
local CombatTab = Window:CreateTab("Combat & ESP", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- --- MOVEMENT ---
local SpeedTgl = MainTab:CreateToggle({
   Name = "Speed Hack (V)",
   CurrentValue = false,
   Callback = function(Value) getgenv().SpeedEnabled = Value end,
})

MainTab:CreateSlider({
   Name = "Speed Value",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 80,
   Callback = function(Value) getgenv().SpeedValue = Value end,
})

MainTab:CreateButton({
   Name = "Teleport to Center (Map)",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then root.CFrame = CFrame.new(0, 50, 0) end
   end,
})

-- --- PLAYERS ---
PlayerTab:CreateToggle({
   Name = "Loop Teleport",
   CurrentValue = false,
   Callback = function(Value) getgenv().LoopTP = Value end,
})

PlayerTab:CreateButton({
   Name = "Teleport to Player",
   Callback = function()
      local lpRoot = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if getgenv().SelectedPlayer and getgenv().SelectedPlayer.Character and lpRoot then
          lpRoot.CFrame = getgenv().SelectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
      end
   end,
})

-- --- COMBAT & ESP ---
CombatTab:CreateToggle({
   Name = "ESP Death Counter",
   CurrentValue = false,
   Callback = function(Value) getgenv().DeathCounterESP = Value end,
})

CombatTab:CreateToggle({
   Name = "Anti-Fling (Smart)",
   CurrentValue = false,
   Callback = function(Value) getgenv().AntiFlingEnabled = Value end,
})

CombatTab:CreateToggle({
   Name = "Click Fling (LKM)",
   CurrentValue = false,
   Callback = function(Value) getgenv().ClickFlingEnabled = Value end,
})

-- --- УЛЬТИМАТИВНИЙ ФЛІНГ З АВТО-АНТИФЛІНГОМ ---
function PowerFling(targetPart)
    if getgenv().IsFlinging then return end
    getgenv().IsFlinging = true
    
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not targetPart then getgenv().IsFlinging = false return end
    
    local oldCF = root.CFrame
    
    -- Тимчасово вимикаємо колізію та видимість
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false v.Transparency = 0.5 end
    end

    local bA = Instance.new("BodyAngularVelocity", root)
    bA.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bA.AngularVelocity = Vector3.new(150000, 150000, 150000)

    -- Цикл утримання біля цілі
    local start = tick()
    while tick() - start < 0.7 do
        root.CFrame = targetPart.CFrame
        task.wait()
    end

    -- Очищення
    bA:Destroy()
    root.Velocity = Vector3.new(0,0,0)
    root.RotVelocity = Vector3.new(0,0,0)
    
    -- Жорстке повернення назад (фікс ТП)
    for i = 1, 5 do
        root.CFrame = oldCF
        task.wait(0.02)
    end
    
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.Transparency = 0 end
    end
    
    task.wait(0.2)
    getgenv().IsFlinging = false
end

PlayerTab:CreateButton({
   Name = "Fling Selected Player",
   Callback = function()
      if getgenv().SelectedPlayer and getgenv().SelectedPlayer.Character then
          PowerFling(getgenv().SelectedPlayer.Character:FindFirstChild("HumanoidRootPart"))
      end
   end,
})

-- --- SETTINGS ---
SettingsTab:CreateKeybind({
   Name = "Menu Open/Close",
   CurrentKeybind = "R",
   HoldToInteract = false,
   Callback = function(Key) Window:Toggle() end,
})

SettingsTab:CreateKeybind({
   Name = "Speed Toggle (V)",
   CurrentKeybind = "V",
   HoldToInteract = false,
   Callback = function()
      getgenv().SpeedEnabled = not getgenv().SpeedEnabled
      SpeedTgl:Set(getgenv().SpeedEnabled)
   end,
})

SettingsTab:CreateButton({
   Name = "Destroy Script",
   Callback = function() Rayfield:Destroy() end,
})

-- --- ГОЛОВНИЙ ЦИКЛ ---
game:GetService("RunService").Stepped:Connect(function()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")

    -- Speed & NoStun
    if getgenv().SpeedEnabled and hum and root then
        hum.WalkSpeed = getgenv().SpeedValue
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (getgenv().SpeedValue / 110))
        end
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
    
    -- Smart Anti-Fling logic
    if getgenv().AntiFlingEnabled and not getgenv().IsFlinging then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end

    -- ESP Death Counter
    if getgenv().DeathCounterESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local counter = p.Character:FindFirstChild("CounterEffect") or p.Character:FindFirstChild("Counter")
                if counter then
                    if not head:FindFirstChild("SkullESP") then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Name = "SkullESP"
                        bb.Size = UDim2.new(4, 0, 4, 0)
                        bb.AlwaysOnTop = true
                        local label = Instance.new("TextLabel", bb)
                        label.Text = "💀"; label.BackgroundTransparency = 1; label.Size = UDim2.new(1,0,1,0); label.TextSize = 60; label.TextColor3 = Color3.new(1,0,0)
                    end
                elseif head:FindFirstChild("SkullESP") then head.SkullESP:Destroy() end
            end
        end
    end
end)

local mouse = game.Players.LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if getgenv().ClickFlingEnabled and mouse.Target and mouse.Target.Parent:FindFirstChild("Humanoid") then
        PowerFling(mouse.Target.Parent:FindFirstChild("HumanoidRootPart"))
    end
end)
