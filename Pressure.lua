local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Zayac Hub | Pressure ULTIMATE",
   LoadingTitle = "Restoring Classic ESP...",
   LoadingSubtitle = "With Blacklist & Numbers",
   ConfigurationSaving = { Enabled = false }
})

_G.Instant = false
_G.DoorESP = false
_G.TrapESP = false
_G.AntiShark = false

-- [[ СПИСОК ІГНОРУВАННЯ (ДЛЯ ПАСТОК) ]] --
local TrapBlacklist = {
    "fan", "vent", "motor", "engine", "propeller", "spinner", 
    "light", "decor", "sign", "button", "lever", "valve", "prop"
}

-- [[ ТА САМА ФУНКЦІЯ ESP (З ТВОГО 1-ГО КОДУ) ]] --
local function CreateSmartESP(obj, text, color, tag)
    if obj:FindFirstChild(tag) then obj[tag]:Destroy() end
    
    -- Фільтр фейків для дверей
    if obj.Name == "Door" and not obj:FindFirstChildOfClass("ProximityPrompt", true) then
        return 
    end

    local folder = Instance.new("Folder", obj)
    folder.Name = tag
    
    local h = Instance.new("Highlight", folder)
    h.FillColor = color
    h.OutlineColor = Color3.new(1,1,1)
    h.FillTransparency = 0.4
    h.Adornee = obj
    
    local bg = Instance.new("BillboardGui", folder)
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 150, 0, 50)
    bg.MaxDistance = 250
    bg.Adornee = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
    
    local lbl = Instance.new("TextLabel", bg)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0
    lbl.Text = text
    lbl.TextScaled = true
    lbl.Font = Enum.Font.RobotoMono
end

local MainTab = Window:CreateTab("Automation", 4483362458)

-- [[ 1. INSTANT INTERACT ]] --
MainTab:CreateToggle({
   Name = "Instant Interact",
   CurrentValue = false,
   Callback = function(Value)
      _G.Instant = Value
      task.spawn(function()
         while _G.Instant do
            pcall(function()
               for _, v in pairs(workspace:GetDescendants()) do
                  if v:IsA("ProximityPrompt") then
                     v.HoldDuration = 0
                     v.RequiresLineOfSight = false
                  end
               end
            end)
            task.wait(0.5)
         end
      end)
   end,
})

local VisualsTab = Window:CreateTab("Visuals", 4483362458)

-- [[ 2. DOOR ESP (ТОЧНО З ТВОГО 1-ГО КОДУ) ]] --
VisualsTab:CreateToggle({
   Name = "Door ESP (Smart Number)",
   CurrentValue = false,
   Callback = function(Value)
      _G.DoorESP = Value
      if Value then
         task.spawn(function()
            while _G.DoorESP do
               pcall(function()
                  for _, m in pairs(workspace:GetDescendants()) do
                     if (m.Name == "Door" or m.Name == "NormalDoor") and m:IsA("Model") then
                        
                        -- ШУКАЄМО НОМЕР
                        local roomNum = m.Parent.Name:match("%d+") 
                        
                        if not roomNum then
                            local sign = m:FindFirstChild("Sign", true)
                            local txt = sign and sign:FindFirstChildOfClass("TextLabel", true)
                            if txt and txt.Text:match("%d+") then
                                roomNum = txt.Text:match("%d+")
                            end
                        end
                        
                        if not roomNum then roomNum = "Door" end 

                        CreateSmartESP(m, "DOOR ["..roomNum.."]", Color3.fromRGB(0, 255, 0), "ZayacVisual")
                     end
                  end
               end)
               task.wait(2)
            end
         end)
      else
         for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "ZayacVisual" then v:Destroy() end
         end
      end
   end,
})

-- [[ 3. TRAP ESP (З 2-ГО КОДУ + BLACKLIST) ]] --
VisualsTab:CreateToggle({
   Name = "Trap & Monster ESP",
   CurrentValue = false,
   Callback = function(Value)
      _G.TrapESP = Value
      if Value then
         task.spawn(function()
            while _G.TrapESP do
               pcall(function()
                  for _, v in pairs(workspace:GetDescendants()) do
                     local name = v.Name:lower()
                     
                     -- ПЕРЕВІРКА BLACK LIST
                     local isBlacklisted = false
                     for _, word in pairs(TrapBlacklist) do
                        if name:find(word) then
                           isBlacklisted = true
                           break
                        end
                     end

                     if not isBlacklisted then
                        -- Твоя логіка детекції (Wall Dweller, Void, Monster)
                        if name:find("wall") or name:find("dwell") or name:find("void") or name == "staredown" then
                           if v:FindFirstChildOfClass("Humanoid") or v:FindFirstChildOfClass("AnimationController") or v:IsA("Model") then
                              CreateSmartESP(v, "⚠️ TRAP!", Color3.fromRGB(255, 0, 0), "ZayacTrap")
                           end
                        elseif name == "locker" and v:FindFirstChild("Monster") then
                           CreateSmartESP(v, "⚠️ FAKE LOCKER!", Color3.fromRGB(255, 80, 0), "ZayacTrap")
                        end
                     end
                  end
               end)
               task.wait(3)
            end
         end)
      else
         for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "ZayacTrap" then v:Destroy() end
         end
      end
   end,
})

-- [[ 4. ANTI-SHARK (EYEFESTATION) ]] --
VisualsTab:CreateToggle({
   Name = "Anti-Shark Protection",
   CurrentValue = false,
   Callback = function(Value)
      _G.AntiShark = Value
      task.spawn(function()
         while _G.AntiShark do
            pcall(function()
               for _, v in pairs(workspace.CurrentCamera:GetChildren()) do
                  if v.Name:find("Eye") or v.Name:find("Gaze") or v.Name == "Static" then
                     v:Destroy()
                  end
               end
               local pg = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
               if pg and pg:FindFirstChild("MainGui") then
                  local static = pg.MainGui:FindFirstChild("Static", true)
                  if static then static.Visible = false end
               end
            end)
            task.wait(0.2)
         end
      end)
   end,
})
