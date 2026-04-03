local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Ultimate Hub v4.0",
   LoadingTitle = "Завантаження...",
   LoadingSubtitle = "by Zayac333",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Глобальні змінні
getgenv().SpeedEnabled = false
getgenv().SpeedValue = 80
getgenv().AntiFling = false
getgenv().ClickFlingEnabled = false
getgenv().SelectedPlayer = nil

-- Функція пошуку гравця по частині імені
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
   Name = "Teleport to Map Center",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then root.CFrame = CFrame.new(0, 50, 0) end
   end,
})

-- ВКЛАДКА PLAYERS (Пошук та Дії)
local PlayerTab = Window:CreateTab("Players", 4483362458)

PlayerTab:CreateInput({
   Name = "Player Name (Short)",
   PlaceholderText = "Введіть нік...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local p = getPlayer(Text)
      if p then
          getgenv().SelectedPlayer = p
          Rayfield:Notify({Title = "Знайдено!", Content = "Вибрано: " .. p.DisplayName, Duration = 3})
      end
   end,
})

PlayerTab:CreateButton({
   Name = "Teleport to Player",
   Callback = function()
      local p = getgenv().SelectedPlayer
      if p and p.Character then
          game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
      end
   end,
})

-- ВКЛАДКА COMBAT
local CombatTab = Window:CreateTab("Combat", 4483362458)

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

-- ФУНКЦІЯ FLING (Invisible Method)
local function PowerFling(targetPart)
    local char = game.Players.LocalPlayer.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root or not targetPart then return end
    
    local oldCF = root.CFrame
    local startTime = tick()
    
    -- Створюємо невидимість для фізики
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end
    
    local bV = Instance.new("BodyVelocity", root)
    bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bV.Velocity = Vector3.new(10000, 10000, 10000)
    
    local bA = Instance.new("BodyAngularVelocity", root)
    bA.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bA.AngularVelocity = Vector3.new(10000, 10000, 10000)

    while tick() - startTime < 1.5 do
        root.CFrame = targetPart.CFrame
        task.wait()
    end
    
    bV:Destroy()
    bA:Destroy()
    root.Velocity = Vector3.new(0,0,0)
    root.RotVelocity = Vector3.new(0,0,0)
    root.CFrame = oldCF
end

PlayerTab:CreateButton({
   Name = "Fling Selected Player",
   Callback = function()
      if getgenv().SelectedPlayer and getgenv().SelectedPlayer.Character then
          PowerFling(getgenv().SelectedPlayer.Character.HumanoidRootPart)
      end
   end,
})

-- ВКЛАДКА SETTINGS
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateKeybind({
   Name = "Open/Close Menu",
   CurrentKeybind = "R",
   HoldToInteract = false,
   Callback = function(Key)
      Window:Toggle()
   end,
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
   Name = "Destroy Script (X)",
   Callback = function()
      Rayfield:Destroy()
   end,
})

-- ЦИКЛИ
game:GetService("RunService").Heartbeat:Connect(function()
    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if getgenv().SpeedEnabled and hum then
        hum.WalkSpeed = getgenv().SpeedValue
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Stunned, false)
    end
    
    if getgenv().AntiFling then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
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
