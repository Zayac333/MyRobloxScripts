local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Інтерфейс
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Hub v27.0",
   LoadingTitle = "Pressure: Original Filters",
   ConfigurationSaving = { Enabled = false }
})

getgenv().Settings = {
    players = false, loot = false, traps = false, gens = false, items = false,
    pCol = Color3.fromRGB(0, 255, 0),
    lCol = Color3.fromRGB(50, 255, 50),
    tCol = Color3.fromRGB(255, 0, 255),
    gCol = Color3.fromRGB(0, 150, 255),
    iCol = Color3.fromRGB(255, 255, 0)
}

local function applyESP(obj, color, name)
    if not obj:FindFirstChild(name) then
        local hl = Instance.new("Highlight")
        hl.Name = name
        hl.FillColor = color
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.3
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = obj
    end
end

local function removeESP(tag)
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == tag then v:Destroy() end
    end
end

-- Вкладка кольорів
local Tab = Window:CreateTab("Colors", 4483362458)
Tab:CreateColorPicker({Name = "Loot", Color = getgenv().Settings.lCol, Callback = function(v) getgenv().Settings.lCol = v end})
Tab:CreateColorPicker({Name = "Traps", Color = getgenv().Settings.tCol, Callback = function(v) getgenv().Settings.tCol = v end})
Tab:CreateColorPicker({Name = "Players", Color = getgenv().Settings.pCol, Callback = function(v) getgenv().Settings.pCol = v end})

-- КЕРУВАННЯ (Твої кейбінди)
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    local s = getgenv().Settings
    if input.KeyCode == Enum.KeyCode.H then
        s.loot = not s.loot
        if not s.loot then removeESP("ESP_L") end
    elseif input.KeyCode == Enum.KeyCode.J then
        s.traps = not s.traps
        if not s.traps then removeESP("ESP_T") end
    elseif input.KeyCode == Enum.KeyCode.V then
        s.players = not s.players
        if not s.players then removeESP("ESP_P") end
    elseif input.KeyCode == Enum.KeyCode.N then
        s.gens = not s.gens
        if not s.gens then removeESP("ESP_G") end
    elseif input.KeyCode == Enum.KeyCode.F then
        s.items = not s.items
        if not s.items then removeESP("ESP_I") end
    end
end)

-- СКАНЕР (Твоя логіка + моя оптимізація)
local lastAutoScan = 0
RunService.Heartbeat:Connect(function()
    local s = getgenv().Settings
    
    -- Гравці (V)
    if s.players then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer and p.Character then
                applyESP(p.Character, s.pCol, "ESP_P")
            end
        end
    end

    -- Твій Авто-сканер з чергою
    if (s.loot or s.traps or s.gens or s.items) and tick() - lastAutoScan > 1.2 then
        lastAutoScan = tick()
        
        task.spawn(function()
            local descendants = workspace:GetDescendants()
            for i, v in ipairs(descendants) do
                if i % 150 == 0 then task.wait() end -- Щоб не було фризів
                
                local name = v.Name:lower()

                -- ТВОЯ ЛОГІКА ПАСТОК (J)
                if s.traps then
                    local isTrapName = name:find("landmine") or name:find("mine") or name:find("doorstopper") or name:find("apd") or name:find("trap")
                    local isLaser = false
                    if v:IsA("BasePart") and v.Material == Enum.Material.Neon then
                        local c, sz = v.Color, v.Size
                        if c.r > 0.7 and c.g < 0.3 and c.b < 0.3 and (sz.X < 0.6 or sz.Y < 0.6 or sz.Z < 0.6) then isLaser = true end
                    end

                    if isTrapName or isLaser then
                        local target = v
                        if v.Parent and v.Parent:IsA("Model") then target = v.Parent
                        elseif v.Parent and v.Parent.Parent and v.Parent.Parent:IsA("Model") then target = v.Parent.Parent end
                        
                        local tSize = target:IsA("Model") and target:GetExtentsSize() or (target:IsA("BasePart") and target.Size or Vector3.new(0,0,0))
                        if tSize.X < 12 and tSize.Y < 12 and not Players:GetPlayerFromCharacter(target) then
                            applyESP(target, s.tCol, "ESP_T")
                        end
                    end
                end

                -- ТВОЯ ЛОГІКА ЛУТУ (H)
                if s.loot then
                    local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        local objText, actText = prompt.ObjectText:lower(), prompt.ActionText:lower()
                        local isCurrency = objText:find("$") or objText:find("kr") or objText:find("gold") or objText:find("money") or objText:match("%d+")
                        local isInside = v:FindFirstAncestor("Drawer") or v:FindFirstAncestor("Desk") or v:FindFirstAncestor("Table") or v:FindFirstAncestor("Locker")
                        local isTrash = actText:find("open") or actText:find("hide") or name:find("handle") or name:find("door") or objText:find("drawer")

                        if isCurrency and not isTrash and not isInside then
                            local target = v:IsA("BasePart") and v.Parent and v.Parent:IsA("Model") and v.Parent or v
                            local size = target:IsA("Model") and target:GetExtentsSize() or target.Size
                            if size.X < 3.3 and size.Y < 3.3 and size.Z < 3.3 then
                                applyESP(target, s.lCol, "ESP_L")
                            end
                        end
                    end
                end

                -- ТВОЯ ЛОГІКА ГЕНІВ (N) ТА ПРЕДМЕТІВ (F)
                if s.gens and v:IsA("Model") and (name:find("gen") or name:find("cons")) then
                    applyESP(v, s.gCol, "ESP_G")
                end
                if s.items and (v:IsA("Model") or v:IsA("BasePart")) and (name:find("card") or name:find("key")) then
                    applyESP(v, s.iCol, "ESP_I")
                end
            end
        end)
    end
end)
