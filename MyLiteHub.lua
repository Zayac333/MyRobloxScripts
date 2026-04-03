local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Ultimate v5.4",
   LoadingTitle = "Виправлення систем...",
   LoadingSubtitle = "by Zayac333",
   ConfigurationSaving = { Enabled = false }
})

-- Глобальні змінні
getgenv().SpeedEnabled = false
getgenv().SpeedValue = 80
getgenv().SelectedPlayer = nil
getgenv().LoopTP = false
getgenv().DeathCounterESP = false
getgenv().ClickFlingEnabled = false

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
   Name = "Teleport to Prison (Safe Zone)",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then 
         root.Velocity = Vector3.new(0,0,0)
         root.CFrame = CFrame.new(-481, 53, 510) -- Точні координати всередині
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
          Rayfield:Notify({Title = "Ціль обрана", Content = getgenv().SelectedPlayer.DisplayName})
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "Loop Teleport",
   CurrentValue = false,
   Callback = function(Value) getgenv().LoopTP = Value end,
})

PlayerTab:CreateButton({
   Name = "Teleport to Player (One-Time)",
   Callback = function()
      local lpRoot = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if getgenv().SelectedPlayer and getgenv().SelectedPlayer.Character and lpRoot then
          local targetRoot = getgenv().SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
          if targetRoot then lpRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3) end
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
   Name = "Click Fling (LKM)",
   CurrentValue = false,
   Callback = function(Value) getgenv().ClickFlingEnabled = Value end,
})

-- --- FLING FUNCTION ---
function PowerFling(targetPart)
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not targetPart then return end
    
    local oldCF = root.CFrame
    root.Anchored = false -- Перестраховка

    -- Потужний імпульс
    local bV = Instance.new("BodyVelocity", root)
    bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bV.Velocity = Vector3.new(85000, 85000, 85000) 
    
    local bA = Instance.new("BodyAngularVelocity", root)
    bA.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bA.AngularVelocity = Vector3.new(85000, 85000, 85000)

    root.CFrame = targetPart.CFrame
    task.wait(0.5) -- Швидкий контакт

    bV:Destroy()
    bA:Destroy()
    
    -- МИТТЄВА ЗУПИНКА ТА ПОВЕРНЕННЯ
    root.Velocity = Vector3.new(0, 0, 0)
    root.RotVelocity = Vector3.new(0, 0, 0)
    root.Anchored = true
    root.CFrame = oldCF
    task.wait(0.2)
    root.Anchored = false
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
   Name = "Toggle Menu",
   CurrentKeybind = "R",
   HoldToInteract = false,
   Callback = function() Window:Toggle() end,
})

SettingsTab:CreateKeybind({
   Name = "Toggle Speed (V)",
   CurrentKeybind = "V",
   HoldToInteract = false,
   Callback = function()
      getgenv().SpeedEnabled = not getgenv().SpeedEnabled
      SpeedToggle:Set(getgenv().SpeedEnabled)
   end,
})

-- --- MAIN CYCLES ---
game:GetService("RunService").Stepped:Connect(function()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    -- Speed
    if getgenv().SpeedEnabled and hum and root then
        hum.WalkSpeed = getgenv().SpeedValue
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (getgenv().SpeedValue / 115))
        end
    end
    
    -- Loop TP
    if getgenv().LoopTP and getgenv().SelectedPlayer and getgenv().SelectedPlayer.Character and root then
        local tRoot = getgenv().SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then root.CFrame = tRoot.CFrame * CFrame.new(0, 2, 3) end
    end
    
    -- ESP Death Counter Fix
    if getgenv().DeathCounterESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                -- Тільки якщо є специфічний ефект каунтера
                local counter = p.Character:FindFirstChild("CounterEffect") or p.Character:FindFirstChild("Counter")
                
                if counter then
                    if not head:FindFirstChild("SkullESP") then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Name = "SkullESP"
                        bb.Size = UDim2.new(4, 0, 4, 0)
                        bb.AlwaysOnTop = true
                        local label = Instance.new("TextLabel", bb)
                        label.Text = "💀"
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.TextSize = 60
                        label.TextColor3 = Color3.new(1, 0, 0)
                    end
                else
                    -- Видаляємо череп, якщо ефект зник
                    if head:FindFirstChild("SkullESP") then
                        head.SkullESP:Destroy()
                    end
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
