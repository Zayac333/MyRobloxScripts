local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Ultimate v5.3",
   LoadingTitle = "Запуск систем ESP & Combat...",
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
   Name = "Teleport to Prison (Safe Zone)",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then 
         root.Velocity = Vector3.new(0,0,0)
         root.CFrame = CFrame.new(-480, 50, 520) 
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
          if targetRoot then
              lpRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
          end
      end
   end,
})

-- Ультимативний Флінг
function PowerFling(targetPart)
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not targetPart then return end
    
    local oldCF = root.CFrame
    
    -- Вимикаємо колізію
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end

    root.CFrame = targetPart.CFrame
    task.wait(0.1)

    local bV = Instance.new("BodyVelocity", root)
    bV.MaxForce = Vector3.new(1, 1, 1) * 9e9
    bV.Velocity = Vector3.new(70000, 70000, 70000) 
    
    local bA = Instance.new("BodyAngularVelocity", root)
    bA.MaxTorque = Vector3.new(1, 1, 1) * 9e9
    bA.AngularVelocity = Vector3.new(70000, 70000, 70000)

    task.wait(0.8)

    bV:Destroy()
    bA:Destroy()
    root.Velocity = Vector3.new(0, 0, 0)
    root.RotVelocity = Vector3.new(0, 0, 0)
    
    root.Anchored = true 
    root.CFrame = oldCF
    task.wait(0.15)
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

-- Settings
SettingsTab:CreateKeybind({
   Name = "Menu Key (R)",
   CurrentKeybind = "R",
   Callback = function() Window:Toggle() end,
})

-- ЦИКЛИ
game:GetService("RunService").Stepped:Connect(function()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    -- Speed Hack
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
    
    -- ESP Death Counter (ПОКРАЩЕНИЙ)
    if getgenv().DeathCounterESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local character = p.Character
                local isCountering = false
                
                -- Пошук за об'єктами або папками ефектів
                if character:FindFirstChild("Counter") or 
                   character:FindFirstChild("CounterEffect") or 
                   character:FindFirstChild("Stance") or
                   character:FindFirstChild("Highlight") or
                   (character:FindFirstChild("Effects") and character.Effects:FindFirstChild("Counter")) then
                    isCountering = true
                end
                
                -- Відображення черепа
                local head = character.Head
                if isCountering and not head:FindFirstChild("SkullESP") then
                    local bb = Instance.new("BillboardGui", head)
                    bb.Name = "SkullESP"
                    bb.Size = UDim2.new(4, 0, 4, 0)
                    bb.AlwaysOnTop = true
                    
                    local label = Instance.new("TextLabel", bb)
                    label.Text = "💀"
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.TextSize = 55
                    label.TextColor3 = Color3.new(1, 0, 0)
                    
                    -- Видалення після завершення
                    task.delay(1.5, function() if bb then bb:Destroy() end end)
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
