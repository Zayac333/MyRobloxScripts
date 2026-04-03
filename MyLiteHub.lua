local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Lite Hub v2.1",
   LoadingTitle = "Завантаження конфігурації...",
   LoadingSubtitle = "by Zayac333",
   ConfigurationSaving = { Enabled = true, FolderName = "ZayacHub" }
})

local Settings = {
    SpeedValue = 16,
    SpeedEnabled = false,
    AntiFling = false,
    ClickFlingEnabled = false,
    DeathCounterESP = false
}

-- ВКЛАДКА MOVEMENT
local MainTab = Window:CreateTab("Movement", 4483362458)

local SpeedToggle = MainTab:CreateToggle({
   Name = "Speed Hack & Anti-Stun (V Key)",
   CurrentValue = false,
   Flag = "SpeedToggle", 
   Callback = function(Value)
      Settings.SpeedEnabled = Value
   end,
})

MainTab:CreateSlider({
   Name = "Speed Value",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      Settings.SpeedValue = Value
   end,
})

-- ОБРОБНИК КЛАВІШІ V
game:GetService("UserInputService").InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.V then
        Settings.SpeedEnabled = not Settings.SpeedEnabled
        SpeedToggle:Set(Settings.SpeedEnabled) -- Оновлюємо кнопку в меню
        
        Rayfield:Notify({
            Title = "Movement",
            Content = Settings.SpeedEnabled and "Speed & Anti-Stun: ON" or "Speed & Anti-Stun: OFF",
            Duration = 2
        })
    end
end)

-- ВКЛАДКА COMBAT & ESP
local CombatTab = Window:CreateTab("Combat & ESP", 4483362458)

CombatTab:CreateToggle({
   Name = "Click Fling (On/Off)",
   CurrentValue = false,
   Callback = function(Value)
      Settings.ClickFlingEnabled = Value
   end,
})

CombatTab:CreateToggle({
   Name = "Anti-Fling",
   CurrentValue = false,
   Callback = function(Value)
      Settings.AntiFling = Value
   end,
})

CombatTab:CreateToggle({
   Name = "ESP Death Counter",
   CurrentValue = false,
   Callback = function(Value)
      Settings.DeathCounterESP = Value
   end,
})

-- ФУНКЦІЯ ФЛІНГУ
local function doFling(targetPart)
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and targetPart then
        local oldCF = root.CFrame
        root.CFrame = targetPart.CFrame
        root.Velocity = Vector3.new(999999, 999999, 999999)
        root.RotVelocity = Vector3.new(999999, 999999, 999999)
        
        task.wait(0.1)
        
        root.CFrame = oldCF
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
    end
end

-- СИСТЕМА ЛКМ КЛІКУ
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if Settings.ClickFlingEnabled then
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            doFling(target.Parent:FindFirstChild("HumanoidRootPart"))
        end
    end
end)

-- ГОЛОВНИЙ ЦИКЛ (Heartbeat)
game:GetService("RunService").Heartbeat:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    
    -- Speed + Anti-Stun
    if Settings.SpeedEnabled and hum then
        hum.WalkSpeed = Settings.SpeedValue
        -- Жорстке вимкнення станів приголомшення
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Stunned, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        if hum:GetState() == Enum.HumanoidStateType.Stunned then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end

    -- Anti-Fling
    if Settings.AntiFling then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end

    -- Death Counter ESP (Череп 💀)
    if Settings.DeathCounterESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                local dc = p.Character:FindFirstChild("DeathCounter") or p.Character:FindFirstChild("Counter")
                local head = p.Character:FindFirstChild("Head")
                
                if dc and head and not head:FindFirstChild("SkullESP") then
                    local bb = Instance.new("BillboardGui", head)
                    bb.Name = "SkullESP"
                    bb.Size = UDim2.new(2, 0, 2, 0)
                    bb.AlwaysOnTop = true
                    bb.Adornee = head
                    
                    local label = Instance.new("TextLabel", bb)
                    label.Text = "💀"
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.new(1, 0, 0)
                    label.TextSize = 35
                    
                    task.delay(4, function() if bb then bb:Destroy() end end)
                end
            end
        end
    end
end)
