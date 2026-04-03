-- Завантаження бібліотеки з перевіркою
local Success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not Success or not Rayfield then
    warn("Rayfield Library failed to load. Check your internet connection.")
    return
end

local Window = Rayfield:CreateWindow({
   Name = "Zayac Ultimate Hub v4.7",
   LoadingTitle = "Ініціалізація систем...",
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
   Name = "Teleport to Map Center",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then 
          root.Velocity = Vector3.new(0,0,0)
          root.CFrame = CFrame.new(0, 120, 0) 
      end
   end,
})

-- ВКЛАДКА PLAYERS
local PlayerTab = Window:CreateTab("Players", 4483362458)

PlayerTab:CreateInput({
   Name = "Search Player",
   PlaceholderText = "Нік...",
   Callback = function(Text)
      local p = getPlayer(Text)
      if p then
          getgenv().SelectedPlayer = p
          Rayfield:Notify({Title = "Ціль вибрана", Content = p.DisplayName, Duration = 3})
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

-- ВКЛАДКА COMBAT
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

-- ФУНКЦІЯ FLING
function PowerFling(targetPart)
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not targetPart then return end
    
    local oldCF = root.CFrame
    root.CFrame = targetPart.CFrame * CFrame.new(0, 0, 1.5)
    task.wait(0.2)
    
    local bV = Instance.new("BodyVelocity", root)
    bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bV.Velocity = Vector3.new(25000, 25000, 25000)
    
    local bA = Instance.new("BodyAngularVelocity", root)
    bA.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bA.AngularVelocity = Vector3.new(25000, 25000, 25000)

    local start = tick()
    while tick() - start < 1.3 do
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
   Name = "Menu Toggle (R)",
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
   Callback = function() 
       getgenv().SpeedEnabled = false
       getgenv().LoopTP = false
       Rayfield:Destroy() 
   end,
})

-- ЦИКЛИ
game:GetService("RunService").Stepped:Connect(function()
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    -- FIX: Швидкість тепер не скидається при поворотах
    if getgenv().SpeedEnabled and hum and root then
        hum.WalkSpeed = getgenv().SpeedValue
        -- Додатковий форс-мув, щоб обійти внутрішні скрипти гри
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (getgenv().SpeedValue / 100))
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
            if p ~= game.Players.LocalPlayer and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end

    -- Death Counter ESP
    if getgenv().DeathCounterESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
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

local mouse = game.Players.LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if getgenv().ClickFlingEnabled and mouse.Target and mouse.Target.Parent:FindFirstChild("Humanoid") then
        PowerFling(mouse.Target.Parent:FindFirstChild("HumanoidRootPart"))
    end
end)

Rayfield:Notify({Title = "Zayac Ultimate v4.7", Content = "Готово! Швидкість зафіксовано.", Duration = 5})
