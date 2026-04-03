local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Ultimate Hub v4.6",
   LoadingTitle = "Ініціалізація систем...",
   LoadingSubtitle = "by Zayac333",
   ConfigurationSaving = { Enabled = false }
})

-- Глобальні змінні (Налаштування)
getgenv().SpeedEnabled = false
getgenv().SpeedValue = 80
getgenv().AntiFling = false
getgenv().ClickFlingEnabled = false
getgenv().SelectedPlayer = nil
getgenv().LoopTP = false
getgenv().DeathCounterESP = false

-- Функція пошуку гравця
local function getPlayer(name)
    name = name:lower()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name or p.DisplayName:lower():sub(1, #name) == name then
            return p
        end
    end
    return nil
end

-- ВКЛАДКА MOVEMENT
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
   Name = "Teleport to Map Center (H=120)",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then 
          root.Velocity = Vector3.new(0,0,0)
          root.CFrame = CFrame.new(0, 120, 0) 
      end
   end,
})

-- ВКЛАДКА PLAYERS (Пошук та Loop TP)
local PlayerTab = Window:CreateTab("Players", 4483362458)

PlayerTab:CreateInput({
   Name = "Search Player Name",
   PlaceholderText = "Введіть нік...",
   Callback = function(Text)
      local p = getPlayer(Text)
      if p then
          getgenv().SelectedPlayer = p
          Rayfield:Notify({Title = "Ціль вибрана", Content = "Вибрано: " .. p.DisplayName, Duration = 3})
      else
          Rayfield:Notify({Title = "Помилка", Content = "Гравця не знайдено", Duration = 3})
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "Loop Teleport to Selected",
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

-- ВКЛАДКА COMBAT & ESP
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

-- ФУНКЦІЯ FLING (Потужна версія)
function PowerFling(targetPart)
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not targetPart then return end
    
    local oldCF = root.CFrame
    root.CFrame = targetPart.CFrame * CFrame.new(0, 0, 1)
    task.wait(0.2) -- Затримка для стабілізації перед ударом
    
    local bV = Instance.new("BodyVelocity", root)
    bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bV.Velocity = Vector3.new(20000, 20000, 20000)
    
    local bA = Instance.new("BodyAngularVelocity", root)
    bA.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bA.AngularVelocity = Vector3.new(20000, 20000, 20000)

    local start = tick()
    while tick() - start < 1.2 do
        root.CFrame = targetPart.CFrame
        task.wait()
    end
    
    bV:Destroy()
    bA:Destroy()
    root.Velocity = Vector3.new(0,0,0)
    root.RotVelocity = Vector3.new(0,0,0)
    root.CFrame = oldCF
end

-- ВКЛАДКА SETTINGS
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateKeybind({
   Name = "Menu Open/Close",
   CurrentKeybind = "R",
   HoldToInteract = false,
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

SettingsTab:CreateButton({
   Name = "Destroy Script (Full Stop)",
   Callback = function() Rayfield:Destroy() end,
})

-- ГОЛОВНИЙ ЦИКЛ ОБРОБКИ
game:GetService("RunService").Heartbeat:Connect(function()
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    -- Швидкість та Анти-Стан
    if getgenv().SpeedEnabled and hum then
        hum.WalkSpeed = getgenv().SpeedValue
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Stunned, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end
    
    -- Loop TP (Кріплення до гравця)
    if getgenv().LoopTP and getgenv().SelectedPlayer and getgenv().SelectedPlayer.Character and root then
        local tRoot = getgenv().SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then
            root.CFrame = tRoot.CFrame * CFrame.new(0, 2, 3)
        end
    end

    -- Anti-Fling (Вимкнення колізії)
    if getgenv().AntiFling then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end

    -- ESP Death Counter (Череп над головою)
    if getgenv().DeathCounterESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                local dc = p.Character:FindFirstChild("DeathCounter") or p.Character:FindFirstChild("Counter")
                local head = p.Character:FindFirstChild("Head
