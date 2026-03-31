local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local settings = {
    players = false,
    monsters = false,
    gens = false,
    items = false,
    loot = false, 
    traps = false  
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

local lastAutoScan = 0

RunService.RenderStepped:Connect(function()
    -- 1. ГРАВЦІ (V)
    if settings.players then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer and p.Character then
                applyESP(p.Character, Color3.fromRGB(0, 255, 0), "ESP_P")
            end
        end
    end

    -- 2. МОНСТРИ (B) - Пошук по звуку та всьому Workspace
    if settings.monsters then
        local searchFolders = {workspace:FindFirstChild("Entities"), workspace:FindFirstChild("Monsters"), workspace}
        for _, folder in pairs(searchFolders) do
            if folder then
                for _, obj in pairs(folder:GetChildren()) do
                    if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                        local name = obj.Name:lower()
                        local hasSound = obj:FindFirstChildOfClass("Sound", true) 
                        local isNotLight = not name:find("light") and not name:find("lamp")
                        
                        if isNotLight and (hasSound or obj:FindFirstChild("HumanoidRootPart") or #name > 10) then
                            applyESP(obj, Color3.fromRGB(255, 0, 0), "ESP_M")
                        end
                    end
                end
            end
        end
    end

    -- 3. АВТО-СКАНЕР (Лут H та Пастки J)
    if (settings.loot or settings.traps) and tick() - lastAutoScan > 1.2 then
        lastAutoScan = tick()
        
        for _, v in pairs(workspace:GetDescendants()) do
            local name = v.Name:lower()

            -- ПАСТКИ (J) - ВИПРАВЛЕНО (Більше не засліплює)
            if settings.traps then
                -- Пошук за назвою
                local isTrapName = name:find("landmine") or name:find("mine") or name:find("doorstopper") or name:find("apd") or name:find("trap")
                
                -- Пошук за фізикою лазера (Червоний Неон)
                local isLaser = false
                if v:IsA("BasePart") and v.Material == Enum.Material.Neon then
                    local c = v.Color
                    local s = v.Size
                    -- ПЕРЕВІРКА: Тільки тонкі об'єкти (лазери), а не стелі!
                    local isThin = (s.X < 0.6 or s.Y < 0.6 or s.Z < 0.6)
                    if c.r > 0.7 and c.g < 0.3 and c.b < 0.3 and isThin then
                        isLaser = true
                    end
                end

                if isTrapName or isLaser then
                    local target = v
                    if v.Parent and v.Parent:IsA("Model") then target = v.Parent
                    elseif v.Parent and v.Parent.Parent and v.Parent.Parent:IsA("Model") then target = v.Parent.Parent end
                    
                    -- Додаткова перевірка розміру моделі (щоб не підсвітити цілу кімнату)
                    local tSize = target:IsA("Model") and target:GetExtentsSize() or (target:IsA("BasePart") and target.Size or Vector3.new(0,0,0))
                    if tSize.X < 12 and tSize.Y < 12 and not Players:GetPlayerFromCharacter(target) then
                        applyESP(target, Color3.fromRGB(255, 0, 255), "ESP_T")
                    end
                end
            end

            -- ЛУТ ТА ВАЛЮТА (H)
            if settings.loot then
                local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    local objText = prompt.ObjectText:lower()
                    local actionText = prompt.ActionText:lower()
                    
                    local isCurrency = objText:find("$") or objText:find("kr") or objText:find("gold") or 
                                      objText:find("money") or objText:match("%d+")

                    local isInsideFurniture = v:FindFirstAncestor("Drawer") or v:FindFirstAncestor("Desk") or 
                                              v:FindFirstAncestor("Table") or v:FindFirstAncestor("Counter") or
                                              v:FindFirstAncestor("Locker")

                    local isTrash = actionText:find("open") or actionText:find("hide") or 
                                    actionText:find("unlock") or name:find("handle") or 
                                    name:find("knob") or name:find("hinge") or 
                                    name:find("door") or objText:find("drawer") or objText:find("locker")

                    if isCurrency and not isTrash and not isInsideFurniture then
                        local target = v:IsA("BasePart") and v.Parent and v.Parent:IsA("Model") and v.Parent or v
                        local size = target:IsA("Model") and target:GetExtentsSize() or target:IsA("BasePart") and target.Size or Vector3.new(10,10,10)
                        
                        if size.X < 3.3 and size.Y < 3.3 and size.Z < 3.3 then
                            applyESP(target, Color3.fromRGB(50, 255, 50), "ESP_L")
                        end
                    end
                end
            end
        end
    end
end)

-- КЕРУВАННЯ
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.H then
        settings.loot = not settings.loot
        if not settings.loot then for _,v in pairs(workspace:GetDescendants()) do if v.Name == "ESP_L" then v:Destroy() end end end
    elseif input.KeyCode == Enum.KeyCode.J then
        settings.traps = not settings.traps
        if not settings.traps then for _,v in pairs(workspace:GetDescendants()) do if v.Name == "ESP_T" then v:Destroy() end end end
    elseif input.KeyCode == Enum.KeyCode.V then 
        settings.players = not settings.players
        if not settings.players then for _,v in pairs(workspace:GetDescendants()) do if v.Name == "ESP_P" then v:Destroy() end end end
    elseif input.KeyCode == Enum.KeyCode.B then 
        settings.monsters = not settings.monsters
        if not settings.monsters then for _,v in pairs(workspace:GetDescendants()) do if v.Name == "ESP_M" then v:Destroy() end end end
    elseif input.KeyCode == Enum.KeyCode.N then
        settings.gens = not settings.gens
        if not settings.gens then for _,v in pairs(workspace:GetDescendants()) do if v.Name == "ESP_G" then v:Destroy() end end else
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and (v.Name:lower():find("gen") or v.Name:lower():find("cons")) then applyESP(v, Color3.fromRGB(0, 150, 255), "ESP_G") end
            end
        end
    elseif input.KeyCode == Enum.KeyCode.F then
        settings.items = not settings.items
        if not settings.items then for _,v in pairs(workspace:GetDescendants()) do if v.Name == "ESP_I" then v:Destroy() end end else
            for _, v in pairs(workspace:GetDescendants()) do
                if (v:IsA("Model") or v:IsA("BasePart")) and (v.Name:lower():find("card") or v.Name:lower():find("key")) then applyESP(v, Color3.fromRGB(255, 255, 0), "ESP_I") end
            end
        end
    end
end)
