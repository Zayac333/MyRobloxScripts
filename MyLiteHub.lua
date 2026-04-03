local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Private Hub v3.0",
   LoadingTitle = "Ініціалізація систем...",
   LoadingSubtitle = "by Zayac333",
   ConfigurationSaving = { Enabled = true, FolderName = "ZayacHub" },
   KeySystem = false -- Можна увімкнути за бажанням
})

local Settings = {
    SpeedValue = 16,
    SpeedEnabled = false,
    AntiFling = false,
    ClickFlingEnabled = false,
    DeathCounterESP = false,
    MenuKey = Enum.KeyCode.R,
    SpeedKey = Enum.KeyCode.V
}

-- ВКЛАДКА MOVEMENT
local MainTab = Window:CreateTab("Movement", 4483362458)

local SpeedToggle = MainTab:CreateToggle({
   Name = "Speed Hack & Anti-Stun",
   CurrentValue = false,
   Callback = function(Value) Settings.SpeedEnabled = Value end,
})

MainTab:CreateSlider({
   Name = "Speed Value",
   Range = {16, 250},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value) Settings.SpeedValue = Value end,
})

-- ВКЛАДКА COMBAT
local CombatTab = Window:CreateTab("Combat & ESP", 4483362458)

CombatTab:CreateToggle({
   Name = "Click Fling (LKM)",
   CurrentValue = false,
   Callback = function(Value) Settings.ClickFlingEnabled = Value end,
})

CombatTab:CreateToggle({
   Name = "Anti-Fling",
   CurrentValue = false,
   Callback = function(Value) Settings.AntiFling = Value end,
})

CombatTab:CreateToggle({
   Name = "ESP Death Counter",
   CurrentValue = false,
   Callback = function(Value) Settings.DeathCounterESP = Value end,
})

-- НОВА ВКЛАДКА SETTINGS (Кейбінди)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateKeybind({
   Name = "Open/Close Menu",
   CurrentKeybind = "R",
   HoldToInteract = false,
   Flag = "MenuKey",
   Callback = function(Keybind)
      Window:Toggle() -- Перемикає видимість меню
   end,
})

SettingsTab:CreateKeybind({
   Name = "Toggle Speed (V)",
   CurrentKeybind = "V",
   HoldToInteract = false,
   Flag = "SpeedKey",
   Callback = function(Keybind)
      Settings.SpeedEnabled = not Settings.SpeedEnabled
      SpeedToggle:Set(Settings.SpeedEnabled)
   end,
})

-- ФУНКЦІЯ ФЛІНГУ (БЕЗПЕЧНА ВЕРСІЯ)
local function safeFling(targetPart)
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and targetPart then
        local oldCF = root.CFrame
        
        -- 1. Підготовка (вимкнення фізики персонажа, щоб не влетіти з ним)
        root.CFrame = targetPart.CFrame * CFrame.new(0, 0, 1) -- трохи збоку
        
        -- 2. Удар (сила знижена до 50к, щоб не видалив античіт)
        root.Velocity = Vector3.new(50000, 50000, 50000)
        root.RotVelocity = Vector3.new(50000, 50000, 50000)
        
        task.wait(0.15) -- трохи більше часу на контакт
        
        -- 3. Повернення та миттєва зупинка
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
        root.CFrame = oldCF
    end
end

-- КЛІК ЛКМ
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if Settings.ClickFlingEnabled then
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            safeFling(target.Parent:FindFirstChild("HumanoidRootPart"))
        end
    end
end)

-- ЦИКЛ ОБРОБКИ
game:GetService("RunService").Heartbeat:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    
    -- Speed & Anti-Stun
    if Settings.SpeedEnabled and hum then
        hum.WalkSpeed = Settings.SpeedValue
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
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

    -- ESP Death Counter
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
                    local label = Instance.new("TextLabel", bb)
                    label.Text = "💀"
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.new(1, 0, 0)
                    label.TextSize = 35
                    task.delay(3, function() if bb then bb:Destroy() end end)
                end
            end
        end
    end
end)
