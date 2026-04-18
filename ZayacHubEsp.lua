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
local ExploitsTab = Window:CreateTab("Exploits", 4483362458)
local MovesetTab = Window:CreateTab("Movesets", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- --- ГЛОБАЛЬНІ НАЛАШТУВАННЯ ---
getgenv().EffectsColor = Color3.fromRGB(255, 255, 255)

-- ==========================================
-- --- ЯДРО ФАРБУВАННЯ (НЕ ВМИРАЄ) ---
-- ==========================================
local function ApplyColor(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        local seq = ColorSequence.new({
            ColorSequenceKeypoint.new(0, getgenv().EffectsColor),
            ColorSequenceKeypoint.new(1, getgenv().EffectsColor),
        })
        obj.Color = seq
    end
end

local function StartColorMonitor(char)
    if not char then return end
    
    -- Фарбуємо все існуюче
    for _, desc in pairs(char:GetDescendants()) do
        ApplyColor(desc)
    end
    
    -- Стежимо за новими ефектами
    char.DescendantAdded:Connect(function(desc)
        task.wait() 
        ApplyColor(desc)
    end)
end

-- Респавн-менеджер
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    StartColorMonitor(char)
end)

-- Старт для поточного персонажа
if game.Players.LocalPlayer.Character then
    task.spawn(function() StartColorMonitor(game.Players.LocalPlayer.Character) end)
end

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

-- Функція для швидкого встановлення атрибутів (як у оригіналі)
local function SetExploitAttr(name, val)
    game.Players.LocalPlayer:SetAttribute(name, val)
end
-- Функція для швидкого встановлення атрибутів (як у оригіналі)
local function SetExploitAttr(name, val)
    game.Players.LocalPlayer:SetAttribute(name, val)
end

-- 1. No Dash Cooldown
ExploitsTab:CreateToggle({
   Name = "No Dash Cooldown",
   CurrentValue = false,
   Callback = function(Value)
       SetExploitAttr('NoDashCooldown', Value)
   end,
})

-- 2. No Fatigue (Втома)
ExploitsTab:CreateToggle({
   Name = "No Fatigue",
   CurrentValue = false,
   Callback = function(Value)
       SetExploitAttr('NoFatigue', Value)
   end,
})

-- 3. No Ragdoll (Примусове вимкнення регдолу)
ExploitsTab:CreateToggle({
   Name = "No Ragdoll",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().NoRagdoll = Value
       if Value then
           task.spawn(function()
               while getgenv().NoRagdoll do
                   local char = game.Players.LocalPlayer.Character
                   if char and char:FindFirstChild("Ragdoll") then
                       -- У TSB регдол часто працює через наявність об'єкта Ragdoll
                       char.Ragdoll:Destroy() 
                   end
                   task.wait()
               end
           end)
       end
   end,
})

-- 4. No Slow (Захист від уповільнення)
ExploitsTab:CreateToggle({
   Name = "No Slowdown",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().NoSlow = Value
       if Value then
           task.spawn(function()
               while getgenv().NoSlow do
                   local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                   if hum then
                       -- Якщо гра намагається поставити швидкість менше стандартної (16)
                       if hum.WalkSpeed < 16 and not getgenv().IsFlinging then
                           hum.WalkSpeed = 16
                       end
                   end
                   task.wait()
               end
           end)
       end
   end,
})

ExploitsTab:CreateDivider()
ExploitsTab:CreateLabel("Visual / Interface")

-- 5. Extra Emote Slots
ExploitsTab:CreateToggle({
   Name = "Extra Emote Slots",
   CurrentValue = false,
   Callback = function(Value)
       SetExploitAttr('ExtraSlots', Value)
   end,
})

-- 6. Emote Search Bar
ExploitsTab:CreateToggle({
   Name = "Emote Search Bar",
   CurrentValue = false,
   Callback = function(Value)
       SetExploitAttr('EmoteSearchBar', Value)
   end,
})

-- 7. No Rotate Bypass (Дозволяє крутити персонажа під час атак)
ExploitsTab:CreateToggle({
   Name = "No Rotate Bypass",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().NoRotate = Value
       if Value then
           game:GetService("RunService").Heartbeat:Connect(function()
               if getgenv().NoRotate then
                   local char = game.Players.LocalPlayer.Character
                   if char and char:FindFirstChild("Humanoid") then
                       char.Humanoid.AutoRotate = true
                   end
               end
           end)
       end
   end,
})

-- 8. No Jump Bypass
ExploitsTab:CreateToggle({
   Name = "No Jump Bypass",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().NoJumpBypass = Value
       -- Дозволяє стрибати навіть коли гра блокує Jump
       game:GetService("UserInputService").JumpRequest:Connect(function()
           if getgenv().NoJumpBypass then
               local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
               if hum then
                   hum:ChangeState(Enum.HumanoidStateType.Jumping)
               end
           end
       end)
   end,
})

ExploitsTab:CreateToggle({
    Name = "No Block SlowDown",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().NoBlockSlow = Value
        if Value then
            -- Використовуємо RenderStepped для миттєвої корекції швидкості
            game:GetService("RunService"):BindToRenderStep("ZayacNoSlow", 1, function()
                if not getgenv().NoBlockSlow then 
                    game:GetService("RunService"):UnbindFromRenderStep("ZayacNoSlow")
                    return 
                end
                
                local char = game.Players.LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                -- Якщо швидкість нижче 16, примусово ставимо 16
                if hum and hum.WalkSpeed < 16 and not getgenv().IsFlinging then
                    hum.WalkSpeed = 20
                end
            end)
        else
            game:GetService("RunService"):UnbindFromRenderStep("ZayacNoSlow")
        end
    end,
})

-- ==========================================
-- --- ВКЛАДКА MOVESETS (АВТОМАТИЧНА) ---
-- ==========================================
local allMovesets = {
    {"Suiru to Mahito", "Loads Mahito anims and 4 skill is saratov", "https://raw.githubusercontent.com/GreatestLime4K/mahitotsb/refs/heads/main/Protected_6381580361331378.txt"},
    {"Saitama to Gojo", "Loads Gojo anims and VFX", "https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua"},
    {"Saitama to Hakari", "Loads Hakari anims and VFX", "https://pastebin.com/raw/eEDYWj8p"},
    {"Garou to Goku", "Loads Goku anims", "https://raw.githubusercontent.com/JayXSama/ray-makk/main/GOKUTSB"},
    {"Sonic to Chainsaw Man", "Loads Chainsaw man anims and VFX", "https://gist.githubusercontent.com/GoldenHeads2/0fd8d36993c850f3fac89e5adf793076/raw/ab4f5a42bd0b2e24a32a46301d533ea849ca771c/gistfile1.txt"},
    {"Saitama to Jun", "Loads Jun anims and VFX", "https://gist.githubusercontent.com/GoldenHeads2/f66279000c58a020e894a6db44914838/raw/62e53e1acacec0b38b43cd0f594292c32e09c39b/gistfile1.txt"},
    {"Blade master to Sukuna", "Loads Sukuna anims and VFX", "https://raw.githubusercontent.com/zyrask/Nexus-Base/main/atomic-blademaster%20to%20sukuna"},
    {"Garou to Okarun", "Loads Okarun anims and VFX", "https://paste.ee/r/Pn4oj"},
    {"Garou to Freddy", "Loads Freddy anims and VFX", "https://pastebin.com/raw/Ft5psDmD"},
    {"Garou to Kizaru", "Loads Kixaru anims and VFX", "https://paste.ee/r/NPnfk"},
    {"Garou to Angel", "1 skill teleport to heaven .-.", "https://paste.ee/r/1HxVZ"},
    {"Garou to Akaza", "Cool script", "https://paste.ee/r/zzvAH"},
    {"Garou to A-train", "Funny script", "https://paste.ee/r/AnZ5j"},
    {"Garou to Mastery Deku", "2 skil is a very cool", "https://pastebin.com/raw/xKextYP5"},
    {"KJ to JK", "Only KJ servers!", "https://raw.githubusercontent.com/NetlessMade/KJ-TO-JK/refs/heads/main/script.lua"},
    {"Suiru to trashcan man", "VERY troll script. Have teleport gui", "https://pastebin.com/raw/JH7mnC7X"},
    {"Garou to Diddy", "DIDDY?!🤨", "https://paste.ee/r/gKC8V"},
    {"Sonic to Toji", "Have 5 and 6 skills", "https://pastebin.com/raw/VQnyWP5D"},
    {"Saitama to Sans", "Dont have ult, but have gaster blaster", "https://paste.ee/r/rF9d3"},
    {"Saitama to Heian Sukuna", "In ult have only 3 skill", "https://raw.githubusercontent.com/damir512/sukunasaitamav1/main/thescript"},
    {"Saitama to JJS Gojo", "Load full JJS Gojo version", "https://raw.githubusercontent.com/damir512/jjsgojov3/main/SaitamaToGojoV3_SOURCE-obfuscated_2.txt"},
    {"Suiru to Deku v2", "Have ult anim", "https://github.com/aggiealledge/obfuscated-scripts/raw/refs/heads/main/deku%20suiryu%20thingy.txt"},
    {"Blade master to Yuta", "RIKA!!!!!!!!!", "https://raw.githubusercontent.com/damir512/AtomicToYuta/main/Protected_8122576078506000.txt"},
    {"Saitama to Kashimo", "THOR!!!", "https://raw.githubusercontent.com/damir512/Kashimo/main/Protected_7491278457865044.txt"},
    {"Saitama to Gojo sensei", "200% PURPLE!!!", "https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua"},
    {"Saitama to Shinji", "Have working 5 skill", "https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/refs/heads/main/Shinji%20tp%20exploit"},
    {"Garou to Sukuna", "Have Kamutoke", "https://rawscripts.net/raw/The-Strongest-Battlegrounds-Garou-to-Sukuna-23069"},
    {"Saitama to Choi Jong In", "Have custom avatar", "https://raw.githubusercontent.com/nil071n/fireman/refs/heads/main/TSB"},
    {"Saitama to Yuji x Sukuna", "Dance skill (5 skill)", "https://pastebin.com/raw/xpptBe4C"},
    {"Saitama to Gojo v2", "Have purple nuke on ult", "https://pastebin.com/raw/jZHTybYw"},
    {"Saitama to Megumi", "Dont have VFX and ult. Bad", "https://pastefy.app/j8w2DdyG/raw"},
    {"Star Lighter (Multi)", "4 character modes, VERY good VFX", "https://raw.githubusercontent.com/Reapvitalized/TSB/refs/heads/main/SG_DEMO.lua"},
    {"Sonic to 1x1x1x1 hacker", "Sonic hacker script", "https://gist.githubusercontent.com/GoldenHeads2/900e87ffc32f3c740930ccb106dd6abf/raw/358c5bf0f0a6aa25946718288dab006e3ae7e1d4/gistfile1.txt"},
    {"Garou to Troll Garou", "Phantom blink and Vibral shift", "https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Void%20Reaper%20Obfuscated.txt"},
    {"Saitama to Gojo sensei v2", "Good vfx and banmade 5 skill", "https://raw.githubusercontent.com/Skibiditoilethaterfr2024/Script-protected-blud-/refs/heads/main/Protected_4902678279449732.txt"},
    {"Sonic to black Goku", "NIGA NIGA NIGA", "https://raw.githubusercontent.com/Nova2ezz/BlackGoku/refs/heads/main/Protected_5687298824595816.lua"},
    {"Saitama to Luffy", "Dont have VFX. Bad", "https://github.com/aggiealledge/obfuscated-scripts/raw/refs/heads/main/Protected_7732857839120517.txt"},
    {"Garou to KJ", "KJ is already in the game...", "https://raw.githubusercontent.com/damir512/garoukjv1maybeidk/main/Protected_2460290213750059.txt"},
    {"Saitama to Chara", "tubap tubap tubap", "https://paste.ee/r/0yYkO"},
    {"Saitama to True Nokotan", "A life of gambling", "https://raw.githubusercontent.com/JayXSama/ray-makk/refs/heads/main/True%20Nosakatan"}
}

for _, data in pairs(allMovesets) do
    MovesetTab:CreateButton({
        Name = data[1],
        Info = data[2],
        Interact = "Load",
        Callback = function()
            loadstring(game:HttpGet(data[3]))()
            
            Rayfield:Notify({
                Title = "Success",
                Content = "Loaded: " .. data[1],
                Duration = 2,
                Image = 4483362458,
            })
        end,
    })
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
   Name = "Load Gojo",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua'))()
   end,
})

SettingsTab:CreateButton({
   Name = "Load CoordsLocate",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/Coords.lua'))()
   end,
})

SettingsTab:CreateButton({
   Name = "Destroy Script",
   Callback = function() Rayfield:Destroy() end,
})

VisualsTab:CreateColorPicker({
    Name = "Effect Color",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        getgenv().EffectsColor = Value
        -- Миттєве оновлення
        if game.Players.LocalPlayer.Character then
            for _, desc in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                ApplyColor(desc)
            end
        end
    end
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
