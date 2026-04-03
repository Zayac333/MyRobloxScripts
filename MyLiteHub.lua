-- Повна очистка перед запуском (щоб не було конфліктів)
if getgenv().ZayacRunning then 
    return 
end
getgenv().ZayacRunning = true

-- Завантаження бібліотеки (пряме посилання)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Ultimate Hub v4.8",
   LoadingTitle = "Завантаження...",
   LoadingSubtitle = "by Zayac333",
   ConfigurationSaving = { Enabled = false }
})

-- Налаштування
getgenv().SpeedEnabled = false
getgenv().SpeedValue = 80
getgenv().AntiFling = false
getgenv().ClickFlingEnabled = false
getgenv().SelectedPlayer = nil
getgenv().LoopTP = false
getgenv().DeathCounterESP = false

-- Допоміжна функція пошуку
local function getPlayer(name)
    name = name:lower()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name or p.DisplayName:lower():sub(1, #name) == name then
            return p
        end
    end
end

-- Вкладка Руху
local MainTab = Window:CreateTab("Movement", 4483362458)

local SpeedToggle = MainTab:CreateToggle({
   Name = "Speed Hack & Anti-Stun (V)",
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
   Name = "Center Map (Y=120)",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then root.CFrame = CFrame.new(0, 120, 0) end
   end,
})

-- Вкладка Гравців
local PlayerTab = Window:CreateTab("Players", 4483362458)

PlayerTab:CreateInput({
   Name = "Find Player",
   PlaceholderText = "Нік...",
   Callback = function(Text)
      getgenv().SelectedPlayer = getPlayer(Text)
      if getgenv().SelectedPlayer then
          Rayfield:Notify({Title = "Знайдено", Content = getgenv().SelectedPlayer.DisplayName})
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "Loop Teleport",
   CurrentValue = false,
   Callback = function(Value) getgenv().LoopTP = Value end,
})

-- Вкладка Бою
local CombatTab = Window:CreateTab("Combat & ESP", 4483362458)

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

-- Функція Флінгу
function PowerFling(targetPart)
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root or not targetPart then return end
    local oldCF = root.CFrame
    root.CFrame = targetPart.CFrame * CFrame.new(0,0,1)
    task.wait(0.1)
    local bV = Instance.new("BodyVelocity", root)
    bV.MaxForce = Vector3.new(1,1,1) * 9e9
    bV.Velocity = Vector3.new(30000, 30000, 30000)
    local bA = Instance.new("BodyAngularVelocity", root)
    bA.MaxTorque = Vector3.new(1,1,1) * 9e9
    bA.AngularVelocity = Vector3.new(30000, 30000, 30000)
    task.wait(1.2)
    bV:Destroy() bA:Destroy()
    root.Velocity = Vector3.new(0,0,0)
    root.CFrame = oldCF
end

-- Налаштування
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateKeybind({
   Name = "Toggle Menu (R)",
   CurrentKeybind = "R",
   Callback = function() Window:Toggle() end,
})

SettingsTab:CreateKeybind({
   Name = "Toggle Speed (V)",
   CurrentKeybind = "V",
   Callback = function()
      getgenv().SpeedEnabled = not getgenv().SpeedEnabled
      SpeedToggle:Set(getgenv().SpeedEnabled)
   end,
})

-- ЦИКЛ (Stepped для стабільної швидкості)
game:GetService("RunService").Stepped:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if getgenv().SpeedEnabled and hum and root then
        hum.WalkSpeed = getgenv().SpeedValue
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (getgenv().SpeedValue / 110))
        end
    end
    
    if getgenv().LoopTP and getgenv().SelectedPlayer and getgenv().SelectedPlayer.Character and root then
        local tRoot = getgenv().SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then root.CFrame = tRoot.CFrame * CFrame.new(0, 2, 3) end
    end
end)

-- Click Fling за ЛКМ
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if getgenv().ClickFlingEnabled and mouse.Target and mouse.Target.Parent:FindFirstChild("Humanoid") then
        PowerFling(mouse.Target.Parent:FindFirstChild("HumanoidRootPart"))
    end
end)
