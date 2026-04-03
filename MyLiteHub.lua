-- Видаляємо старі змінні перед запуском
getgenv().ZayacRunning = nil

-- Завантаження бібліотеки через офіційне джерело
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Ultimate v4.9",
   LoadingTitle = "Запуск хаба...",
   LoadingSubtitle = "by Zayac333",
   ConfigurationSaving = { Enabled = false }
})

-- Глобальні змінні
getgenv().SpeedEnabled = false
getgenv().SpeedValue = 80
getgenv().AntiFling = false
getgenv().ClickFlingEnabled = false
getgenv().SelectedPlayer = nil
getgenv().LoopTP = false
getgenv().DeathCounterESP = false

-- Функція пошуку
local function getPlayer(name)
    name = name:lower()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name or p.DisplayName:lower():sub(1, #name) == name then
            return p
        end
    end
end

-- ВКЛАДКИ
local MainTab = Window:CreateTab("Movement", 4483362458)
local PlayerTab = Window:CreateTab("Players", 4483362458)
local CombatTab = Window:CreateTab("Combat & ESP", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Movement
local SpeedToggle = MainTab:CreateToggle({
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
   Name = "Teleport Center (Y=120)",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then 
         root.Velocity = Vector3.new(0,0,0)
         root.CFrame = CFrame.new(0, 120, 0) 
      end
   end,
})

-- Players
PlayerTab:CreateInput({
   Name = "Find Player",
   PlaceholderText = "Нік...",
   Callback = function(Text)
      getgenv().SelectedPlayer = getPlayer(Text)
      if getgenv().SelectedPlayer then
          Rayfield:Notify({Title = "Знайдено!", Content = getgenv().SelectedPlayer.DisplayName})
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "Loop Teleport",
   CurrentValue = false,
   Callback = function(Value) getgenv().LoopTP = Value end,
})

PlayerTab:CreateButton({
   Name = "Fling Selected Player",
   Callback = function()
      if getgenv().SelectedPlayer and getgenv().SelectedPlayer.Character then
          PowerFling(getgenv().SelectedPlayer.Character:FindFirstChild("HumanoidRootPart"))
      end
   end,
})

-- Combat & ESP
CombatTab:CreateToggle({
   Name = "Click Fling (LKM)",
   CurrentValue = false,
   Callback = function(Value) getgenv().ClickFlingEnabled = Value end,
})

CombatTab:CreateToggle({
   Name = "Anti-Fling",
   CurrentValue = false,
   Callback = function(Value) getgenv().AntiFling = Value end,
})

CombatTab:CreateToggle({
   Name = "ESP Death Counter",
   CurrentValue = false,
   Callback = function(Value) getgenv().DeathCounterESP = Value end,
})

-- ФУНКЦІЯ FLING
function PowerFling(targetPart)
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root or not targetPart then return end
    local oldCF = root.CFrame
    root.CFrame = targetPart.CFrame * CFrame.new(0, 0, 1.2)
    task.wait(0.15)
    local bV = Instance.new("BodyVelocity", root)
    bV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bV.Velocity = Vector3.new(35000, 35000, 35000)
    local bA = Instance.new("BodyAngularVelocity", root)
    bA.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bA.AngularVelocity = Vector3.new(35000, 35000, 35000)
    task.wait(1.2)
    bV:Destroy() bA:Destroy()
    root.Velocity = Vector3.new(0, 0, 0)
    root.CFrame = oldCF
end

-- Settings
SettingsTab:CreateKeybind({
   Name = "Menu Key (R)",
   CurrentKeybind = "R",
   Callback = function() Window:Toggle() end,
})

SettingsTab:CreateKeybind({
   Name = "Speed Toggle (V)",
   CurrentKeybind = "V",
   Callback = function()
      getgenv().SpeedEnabled = not getgenv().SpeedEnabled
      SpeedToggle:Set(getgenv().SpeedEnabled)
   end,
})

SettingsTab:CreateButton({
   Name = "Destroy Script",
   Callback = function() Rayfield:Destroy() end,
})

-- ЦИКЛИ (FIXED SPEED)
game:GetService("RunService").Stepped:Connect(function()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    -- Швидкість, яка не скидається
    if getgenv().SpeedEnabled and hum and root then
        hum.WalkSpeed = getgenv().SpeedValue
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (getgenv().SpeedValue / 115))
        end
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Stunned, false)
    end
    
    -- Loop TP
    if getgenv().LoopTP and getgenv().SelectedPlayer and getgenv().SelectedPlayer.Character and root then
        local tRoot = getgenv().SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then root.CFrame = tRoot.CFrame * CFrame.new(0, 2, 3) end
    end
    
    -- Anti-Fling
    if getgenv().AntiFling then
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
            if p ~= lp and p.Character then
                local dc = p.Character:FindFirstChild("DeathCounter") or p.Character:FindFirstChild("Counter")
                local head = p.Character:FindFirstChild("Head")
                if dc and head and not head:FindFirstChild("SkullESP") then
                    local bb = Instance.new("BillboardGui", head)
                    bb.Name = "SkullESP"
                    bb.Size = UDim2.new(2.5, 0, 2.5, 0)
                    bb.AlwaysOnTop = true
                    local label = Instance.new("TextLabel", bb)
                    label.Text = "💀"
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.TextSize = 45
                    task.delay(2.5, function() if bb then bb:Destroy() end end)
                end
            end
        end
    end
end)

-- Click Fling
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if getgenv().ClickFlingEnabled and mouse.Target and mouse.Target.Parent:FindFirstChild("Humanoid") then
        PowerFling(mouse.Target.Parent:FindFirstChild("HumanoidRootPart"))
    end
end)
