local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Hub v1.0",
   LoadingTitle = "Final Version",
   LoadingSubtitle = "by Zayac",
   ConfigurationSaving = { Enabled = false }
})

-- --- ЗМІННІ ---
getgenv().SpeedEnabled = false
getgenv().NoclipEnabled = false -- Нова змінна
getgenv().SpeedValue = 63 
getgenv().SelectedPlayer = nil
getgenv().LoopTP = false
getgenv().DeathCounterESP = false
getgenv().ClickFlingEnabled = false
getgenv().AntiFlingEnabled = false
getgenv().IsFlinging = false

local function getPlayer(name)
    name = name:lower()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name or p.DisplayName:lower():sub(1, #name) == name then
            return p
        end
    end
    return nil
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

-- Нова кнопка NOCLIP
local NoclipTgl = MainTab:CreateToggle({
    Name = "Noclip (N)",
    CurrentValue = false,
    Callback = function(Value) getgenv().NoclipEnabled = Value end,
})

MainTab:CreateSlider({
   Name = "Speed Value",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 63,
   Callback = function(Value) getgenv().SpeedValue = Value end,
})

MainTab:CreateButton({
   Name = "Teleport to Center",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then root.CFrame = CFrame.new(180, 450, 180) end
   end,
})

MainTab:CreateButton({
   Name = "Teleport to Top (High)",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then 
          root.CFrame = CFrame.new(root.Position.X, 1000, root.Position.Z) 
      end
   end,
})

-- --- PLAYERS ---
PlayerTab:CreateInput({
   Name = "Find Player",
   PlaceholderText = "Нік...",
   Callback = function(Text)
      getgenv().SelectedPlayer = getPlayer(Text)
      if getgenv().SelectedPlayer then
          Rayfield:Notify({Title = "Обрано", Content = getgenv().SelectedPlayer.DisplayName})
      end
   end,
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

PlayerTab:CreateToggle({
   Name = "Loop Teleport",
   CurrentValue = false,
   Callback = function(Value) getgenv().LoopTP = Value end,
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

-- --- ФЛІНГ ---
function PowerFling(targetPart)
    if getgenv().IsFlinging or not targetPart then return end
    getgenv().IsFlinging = true
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then getgenv().IsFlinging = false return end
    local returnCF = root.CFrame
    
    local function applyForce()
        root.Velocity = Vector3.new(500000, 500000, 500000)
        root.RotVelocity = Vector3.new(500000, 500000, 500000)
    end

    local start = tick()
    while tick() - start < 0.5 do
        applyForce()
        root.CFrame = targetPart.CFrame * CFrame.Angles(math.random(), math.random(), math.random())
        task.wait()
    end
    root.Velocity = Vector3.new(0,0,0); root.RotVelocity = Vector3.new(0,0,0)
    for i = 1, 10 do root.CFrame = returnCF task.wait(0.01) end
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
   Name = "Rayfield Keybind",
   CurrentKeybind = "R",
   HoldToInteract = false,
   Callback = function() Window:Toggle() end,
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

-- Бінд для Нокліпу на N
SettingsTab:CreateKeybind({
    Name = "Noclip Toggle",
    CurrentKeybind = "U",
    HoldToInteract = false,
    Callback = function()
       getgenv().NoclipEnabled = not getgenv().NoclipEnabled
       NoclipTgl:Set(getgenv().NoclipEnabled)
    end,
 })

SettingsTab:CreateButton({
   Name = "Destroy Script",
   Callback = function() Rayfield:Destroy() end,
})

-- --- ЦИКЛИ (RunService) ---
game:GetService("RunService").Stepped:Connect(function()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")

    -- Логіка Speed Hack
    if getgenv().SpeedEnabled and hum and root then
        hum.WalkSpeed = getgenv().SpeedValue
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (getgenv().SpeedValue / 110))
        end
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
    
    -- Логіка NOCLIP
    if getgenv().NoclipEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Loop Teleport
    if getgenv().LoopTP and getgenv().SelectedPlayer and getgenv().SelectedPlayer.Character and root then
        local tRoot = getgenv().SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then root.CFrame = tRoot.CFrame * CFrame.new(0, 2, 3) end
    end
    
    -- Anti-Fling
    if getgenv().AntiFlingEnabled and not getgenv().IsFlinging then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end

    -- Death Counter ESP
    if getgenv().DeathCounterESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local counter = p.Character:FindFirstChild("CounterEffect") or p.Character:FindFirstChild("Counter")
                if counter then
                    if not head:FindFirstChild("SkullESP") then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Name = "SkullESP"; bb.Size = UDim2.new(4,0,4,0); bb.AlwaysOnTop = true
                        local lbl = Instance.new("TextLabel", bb)
                        lbl.Text = "💀"; lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(1,0,1,0); lbl.TextSize = 60; lbl.TextColor3 = Color3.new(1,0,0)
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
