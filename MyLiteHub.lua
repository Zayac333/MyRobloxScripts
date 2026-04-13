local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Hub v1.0",
   LoadingTitle = "Final Version",
   LoadingSubtitle = "by Zayac",
   ConfigurationSaving = { Enabled = false }
})

-- --- ЗМІННІ ---
getgenv().SpeedEnabled = false
getgenv().NoclipEnabled = false
getgenv().SpeedValue = 63 
getgenv().SelectedPlayer = nil
getgenv().LoopTP = false
getgenv().DeathCounterESP = false
getgenv().PlayerESP = false
getgenv().ClickFlingEnabled = false
getgenv().AntiFlingEnabled = false
getgenv().IsFlinging = false

local function getPlayer(name)
    name = name:lower()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name or p.DisplayName:lower():sub(1, #name) == name then
            return p
        end
    end
    return nil
end

-- ==========================================
-- --- ФУНКЦІЯ ПРИМУСОВОГО ФІКСУ КАМЕРИ ---
-- ==========================================
local function FixCamera()
    local lp = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    -- Цикл для надійності, бо гра може намагатися забагати камеру кілька разів
    task.spawn(function()
        for i = 1, 10 do -- Повторюємо 10 разів з невеликою затримкою
            if lp.Character then
                -- Повертаємо стандартний режим камери
                camera.CameraType = Enum.CameraType.Custom
                -- Фокусуємо камеру назад на твоєму Гуманоїді
                camera.CameraSubject = lp.Character:FindFirstChildOfClass("Humanoid")
                camera.FieldOfView = 70 -- Скидаємо зум, якщо він забагався
            end
            task.wait(0.05)
        end
        Rayfield:Notify({Title = "Camera", Content = "Custom Camera Restored", Duration = 2})
    end)
end

-- Координати Safe Zone над безоднею (Vexon Style)
local VOID_POS = Vector3.new(-380, -450, -210) 

local function CreateVoidSafeZone()
    -- Видаляємо стару платформу, якщо вона була створена раніше
    if workspace:FindFirstChild("ZayacVoidSafeZone") then 
        workspace.ZayacVoidSafeZone:Destroy() 
    end

    local zone = Instance.new("Part")
    zone.Name = "ZayacVoidSafeZone"
    zone.Size = Vector3.new(10000, 1, 10000) -- Велика площа, щоб точно не промахнутися
    zone.Position = VOID_POS - Vector3.new(0, 50, 0) -- Платформа трохи нижче точки телепорту
    zone.Anchored = true
    zone.CanCollide = true
    zone.Transparency = 0.8 -- Зроби 1 для повної невидимості
    zone.Color = Color3.fromRGB(255, 0, 0) -- Червоний колір (як на відео)
    zone.Parent = workspace
    
    -- Візуальна рамка (опціонально)
    local sb = Instance.new("SelectionBox", zone)
    sb.Adornee = zone
    sb.Color3 = Color3.new(1, 0, 0)
    sb.LineThickness = 0.03
end

-- Виклик функції для створення платформи при запуску
CreateVoidSafeZone()

local MainTab = Window:CreateTab("Movement", 4483362458)
local PlayerTab = Window:CreateTab("Players", 4483362458)
local CombatTab = Window:CreateTab("Combat & ESP", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)


-- --- MOVEMENT ---
local SpeedTgl = MainTab:CreateToggle({
   Name = "Speed Hack (V)",
   CurrentValue = false,
   Callback = function(Value) getgenv().SpeedEnabled = Value end,
})

local NoclipTgl = MainTab:CreateToggle({
    Name = "Noclip (N)",
    CurrentValue = false,
    Callback = function(Value) getgenv().NoclipEnabled = Value end,
})

MainTab:CreateSlider({
   Name = "Speed Value",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 63,
   Callback = function(Value) getgenv().SpeedValue = Value end,
})

MainTab:CreateButton({
   Name = "Teleport to Center",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then root.CFrame = CFrame.new(180, 450, 180) end
   end,
})

MainTab:CreateButton({
   Name = "Teleport to Void",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then root.CFrame = CFrame.new(-380, -495, -210) end
   end,
})

-- Додай цю кнопку у зручне місце в UI
MainTab:CreateButton({
   Name = "🚨 Fix Lagged Camera",
   Callback = function()
      FixCamera()
   end,
})

MainTab:CreateButton({
   Name = "Teleport to Mountian",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then root.CFrame = CFrame.new(154.89, 628.74, -446.10) end
   end,
})

MainTab:CreateButton({
   Name = "Teleport to Prison",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then root.CFrame = CFrame.new(439.87, 439.51, -374.98) end
   end,
})

MainTab:CreateButton({
   Name = "Teleport to Counter",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then root.CFrame = CFrame.new(-71.15, 49.96, 20347.57) end
   end,
})

MainTab:CreateButton({
   Name = "Teleport to Atomic Slash Base",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then root.CFrame = CFrame.new(1063.24, 19.93, 23005.99) end
   end,
})

MainTab:CreateButton({
   Name = "Teleport to Top (High)",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then 
          root.CFrame = CFrame.new(root.Position.X, 1000, root.Position.Z) 
      end
   end,
})

-- --- PLAYERS ---
PlayerTab:CreateInput({
   Name = "Find Player",
   PlaceholderText = "Name",
   Callback = function(Text)
      getgenv().SelectedPlayer = getPlayer(Text)
      if getgenv().SelectedPlayer then
          Rayfield:Notify({Title = "Обрано", Content = getgenv().SelectedPlayer.DisplayName})
      end
   end,
})

PlayerTab:CreateButton({
   Name = "Teleport to Player",
   Callback = function()
      local lpRoot = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if getgenv().SelectedPlayer and getgenv().SelectedPlayer.Character and lpRoot then
          lpRoot.CFrame = getgenv().SelectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
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

-- --- COMBAT & ESP ---
CombatTab:CreateToggle({
   Name = "Player ESP (Blue)",
   CurrentValue = false,
   Callback = function(Value) getgenv().PlayerESP = Value end,
})

CombatTab:CreateToggle({
   Name = "ESP Death Counter",
   CurrentValue = false,
   Callback = function(Value) getgenv().DeathCounterESP = Value end,
})

CombatTab:CreateToggle({
   Name = "Anti-Fling (Smart)",
   CurrentValue = false,
   Callback = function(Value) getgenv().AntiFlingEnabled = Value end,
})

CombatTab:CreateToggle({
   Name = "Click Fling (LKM)",
   CurrentValue = false,
   Callback = function(Value) getgenv().ClickFlingEnabled = Value end,
})

-- --- ГІБРИДНА ФЛІНГ ЛОГІКА (Без вильотів у космос) ---
function PowerFling(targetPart)
    if getgenv().IsFlinging or not targetPart then return end
    getgenv().IsFlinging = true
    
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not root or not hum then getgenv().IsFlinging = false return end
    
    local returnCF = root.CFrame
    
    -- 1. СТАБІЛІЗАЦІЯ (Щоб не вмерти)
    local oldState = hum:GetState()
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    -- Важливо: не використовуємо PlatformStand, якщо гра вбиває за це
    
    -- 2. СИЛА (Зменшена до стабільних значень)
    local bV = Instance.new("BodyVelocity")
    bV.Velocity = Vector3.new(15000, 15000, 15000) -- Достатньо, щоб викинути, але не зламати двигун
    bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bV.Parent = root

    local bAV = Instance.new("BodyAngularVelocity")
    bAV.AngularVelocity = Vector3.new(15000, 15000, 15000)
    bAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bAV.Parent = root

    -- 3. ЦИКЛ АТАКИ
    local start = tick()
    while tick() - start < 1.5 do
        -- Замість того, щоб бути ВЕРЕДИНІ гравця, ми літаємо ТРОХИ ВИЩЕ
        -- Це захищає тебе від зіткнення з його хитбоксом смерті
        root.CFrame = targetPart.CFrame * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.random(), math.random(), math.random())
        
        -- Створюємо ілюзію руху для сервера
        root.Velocity = Vector3.new(1000, 1000, 1000) 
        
        task.wait()
        if not targetPart or not targetPart.Parent or hum.Health <= 0 then break end
    end

    -- 4. БЕЗПЕЧНЕ ПОВЕРНЕННЯ
    bV:Destroy()
    bAV:Destroy()
    root.Velocity = Vector3.new(0,0,0)
    root.RotVelocity = Vector3.new(0,0,0)
    
    -- Плавний возврат (щоб анти-чит не кікнув за телепорт)
    for i = 1, 3 do 
        root.CFrame = returnCF 
        task.wait(0.05) 
    end
    
    getgenv().IsFlinging = false
end

-- --- ESP ЛОГІКА (ГРАВЦІ) ---
local function ManageESP(p)
    if p == game.Players.LocalPlayer then return end
    local char = p.Character
    if not char then return end

    if getgenv().PlayerESP then
        if not char:FindFirstChild("ZayacHighlight") then
            local hl = Instance.new("Highlight", char)
            hl.Name = "ZayacHighlight"; hl.FillColor = Color3.fromRGB(0, 170, 255); hl.FillTransparency = 0.5; hl.OutlineColor = Color3.new(1,1,1)
        end
        local head = char:FindFirstChild("Head")
        if head and not head:FindFirstChild("ZayacNameTag") then
            local bb = Instance.new("BillboardGui", head)
            bb.Name = "ZayacNameTag"; bb.Size = UDim2.new(0, 200, 0, 50); bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true
            local lbl = Instance.new("TextLabel", bb)
            lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.Text = p.Name
            lbl.TextColor3 = Color3.fromRGB(0, 190, 255); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 14; lbl.TextStrokeTransparency = 0
        end
    else
        if char:FindFirstChild("ZayacHighlight") then char.ZayacHighlight:Destroy() end
        if char:FindFirstChild("Head") and char.Head:FindFirstChild("ZayacNameTag") then char.Head.ZayacNameTag:Destroy() end
    end
end

-- --- SETTINGS ---
SettingsTab:CreateKeybind({
   Name = "Rayfield Keybind",
   CurrentKeybind = "R",
   HoldToInteract = false,
   Callback = function() Window:Toggle() end,
})

SettingsTab:CreateKeybind({
   Name = "Speed Toggle (V)",
   CurrentKeybind = "V",
   HoldToInteract = false,
   Callback = function()
      getgenv().SpeedEnabled = not getgenv().SpeedEnabled
      SpeedTgl:Set(getgenv().SpeedEnabled)
   end,
})

SettingsTab:CreateKeybind({
    Name = "Noclip Toggle (U)",
    CurrentKeybind = "U",
    HoldToInteract = false,
    Callback = function()
       getgenv().NoclipEnabled = not getgenv().NoclipEnabled
       NoclipTgl:Set(getgenv().NoclipEnabled)
    end,
 })

SettingsTab:CreateButton({
   Name = "Load ZayacTech",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/ZayacTech.lua'))()
   end,
})

SettingsTab:CreateButton({
   Name = "Destroy Script",
   Callback = function() Rayfield:Destroy() end,
})

-- --- ЦИКЛИ ---
game:GetService("RunService").Stepped:Connect(function()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")

    -- Оновлення звичайного ESP
    for _, p in pairs(game.Players:GetPlayers()) do ManageESP(p) end

    -- Speed Hack
    if getgenv().SpeedEnabled and hum and root then
        hum.WalkSpeed = getgenv().SpeedValue
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (getgenv().SpeedValue / 110))
        end
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
    
    -- Noclip
    if getgenv().NoclipEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    -- Loop Teleport
    if getgenv().LoopTP and getgenv().SelectedPlayer and getgenv().SelectedPlayer.Character and root then
        local tRoot = getgenv().SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then root.CFrame = tRoot.CFrame * CFrame.new(0, 2, 3) end
    end
    
    -- Anti-Fling
    if getgenv().AntiFlingEnabled and not getgenv().IsFlinging then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end

     -- --- ОРИГІНАЛЬНА ЛОГІКА DEATH COUNTER ESP ---
    if getgenv().DeathCounterESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                -- Перевірка наявності об'єкта каунтера (як в оригіналі)
                local counter = p.Character:FindFirstChild("CounterEffect") or p.Character:FindFirstChild("Counter")
                
                if counter then
                    if not head:FindFirstChild("SkullESP") then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Name = "SkullESP"
                        bb.Size = UDim2.new(4, 0, 4, 0)
                        bb.AlwaysOnTop = true
                        
                        local lbl = Instance.new("TextLabel", bb)
                        lbl.Text = "💀"
                        lbl.BackgroundTransparency = 1
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.TextSize = 60
                        lbl.TextColor3 = Color3.new(1, 0, 0)
                    end
                else
                    -- Видалення, якщо ефект зник
                    if head:FindFirstChild("SkullESP") then
                        head.SkullESP:Destroy()
                    end
                end
            end
        end
    else
        -- Очищення всіх ESP, якщо функцію вимкнено
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("SkullESP") then
                p.Character.Head.SkullESP:Destroy()
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
