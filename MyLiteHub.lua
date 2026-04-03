local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Lite Hub v2",
   LoadingTitle = "Завантаження систем...",
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

MainTab:CreateToggle({
   Name = "Speed Hack & Anti-Stun",
   CurrentValue = false,
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

-- ФУНКЦІЯ ФЛІНГУ (БЕЗ ВИЛЬОТУ)
local function doFling(targetPart)
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and targetPart then
        local oldCF = root.CFrame
        -- Переміщення до цілі з величезною швидкістю
        root.CFrame = targetPart.CFrame
        root.Velocity = Vector3.new(999999, 999999, 999999)
        root.RotVelocity = Vector3.new(999999, 999999, 999999)
        
        task.wait(0.1) -- Час на удар
        
        -- Повернення та "заморозка" швидкості
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

-- ГОЛОВНИЙ ЦИКЛ
game:GetService("RunService").Heartbeat:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    
    -- Speed + Anti-Stun
    if Settings.SpeedEnabled and hum then
        hum.WalkSpeed = Settings.SpeedValue
        -- Вимикаємо стан падіння та стану "приголомшення"
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Stunned, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
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

    -- Death Counter ESP
    if Settings.DeathCounterESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                -- Перевіряємо наявність об'єкта DeathCounter (за назвою або анімацією)
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
                    label.TextSize = 30
                    
                    task.delay(5, function() bb:Destroy() end) -- Видаляємо через 5 сек
                end
            end
        end
    end
end)

Rayfield:Notify({
   Title = "Zayac Hub v2",
   Content = "Системи готові. Тепер тебе повертає на місце після флінгу!",
   Duration = 5
})
