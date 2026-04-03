local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Private Hub v3.5",
   LoadingTitle = "Завантаження...",
   LoadingSubtitle = "by Zayac333",
   ConfigurationSaving = { Enabled = true, FolderName = "ZayacHub" }
})

-- Глобальні змінні для роботи функцій
getgenv().SpeedEnabled = false
getgenv().SpeedValue = 64 -- x4 від стандарту (16 * 4)
getgenv().AntiFling = false
getgenv().ClickFlingEnabled = false
getgenv().DeathCounterESP = false

-- ВКЛАДКА MOVEMENT
local MainTab = Window:CreateTab("Movement", 4483362458)

local SpeedToggle = MainTab:CreateToggle({
   Name = "Speed Hack & Anti-Stun",
   CurrentValue = false,
   Flag = "SpeedHack", 
   Callback = function(Value)
      getgenv().SpeedEnabled = Value
   end,
})

MainTab:CreateSlider({
   Name = "Speed Value",
   Range = {16, 300},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 64,
   Flag = "SpeedVal",
   Callback = function(Value)
      getgenv().SpeedValue = Value
   end,
})

-- ВКЛАДКА COMBAT
local CombatTab = Window:CreateTab("Combat & ESP", 4483362458)

CombatTab:CreateToggle({
   Name = "Click Fling (LKM)",
   CurrentValue = false,
   Flag = "CFling",
   Callback = function(Value)
      getgenv().ClickFlingEnabled = Value
   end,
})

CombatTab:CreateToggle({
   Name = "Anti-Fling",
   CurrentValue = false,
   Flag = "AFling",
   Callback = function(Value)
      getgenv().AntiFling = Value
   end,
})

CombatTab:CreateToggle({
   Name = "ESP Death Counter",
   CurrentValue = false,
   Flag = "DCESP",
   Callback = function(Value)
      getgenv().DeathCounterESP = Value
   end,
})

-- ВКЛАДКА SETTINGS
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateKeybind({
   Name = "Open/Close Menu",
   CurrentKeybind = "R",
   HoldToInteract = false,
   Callback = function()
      Window:Toggle()
   end,
})

SettingsTab:CreateKeybind({
   Name = "Toggle Speed (V)",
   CurrentKeybind = "V",
   HoldToInteract = false,
   Callback = function()
      getgenv().SpeedEnabled = not getgenv().SpeedEnabled
      SpeedToggle:Set(getgenv().SpeedEnabled) -- Тепер кнопка в меню БУДЕ мінятись
   end,
})

-- ПОКРАЩЕНА ФУНКЦІЯ ФЛІНГУ
local function advancedFling(targetPart)
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and targetPart then
        local oldCF = root.CFrame
        local startTime = tick()
        
        -- Створюємо силу кручення (це краще за просто Velocity)
        local bg = Instance.new("BodyGyro", root)
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = root.CFrame
        
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(9e9, 9e9, 9e9)

        -- Тримаємо флінг 1.5 секунди
        repeat
            root.CFrame = targetPart.CFrame
            task.wait()
        until tick() - startTime > 1.5 or not targetPart
        
        -- Видаляємо сили та повертаємо на місце
        bg:Destroy()
        bv:Destroy()
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
        root.CFrame = oldCF
    end
end

-- КЛІК ЛКМ ДЛЯ ФЛІНГУ
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if getgenv().ClickFlingEnabled then
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            advancedFling(target.Parent:FindFirstChild("HumanoidRootPart"))
        end
    end
end)

-- ГОЛОВНИЙ ЦИКЛ (Heartbeat)
game:GetService("RunService").Heartbeat:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    
    -- Speed & Anti-Stun
    if getgenv().SpeedEnabled and hum then
        hum.WalkSpeed = getgenv().SpeedValue
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        if hum:GetState() == Enum.HumanoidStateType.Stunned then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
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
                if (p.Character:FindFirstChild("DeathCounter") or p.Character:FindFirstChild("Counter")) then
                    local head = p.Character:FindFirstChild("Head")
                    if head and not head:FindFirstChild("SkullESP") then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Name = "SkullESP"
                        bb.Size = UDim2.new(2, 0, 2, 0)
                        bb.AlwaysOnTop = true
                        local label = Instance.new("TextLabel", bb)
                        label.Text = "💀"
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.TextSize = 35
                        task.delay(2, function() if bb then bb:Destroy() end end)
                    end
                end
            end
        end
    end
end)
