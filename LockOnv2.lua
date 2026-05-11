local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local target = nil
local isLocked = false
local MAX_DISTANCE = 1000 
local SNAP_RADIUS = 200 

-- Блакитна підсвітка
local highlight = Instance.new("Highlight")
highlight.FillColor = Color3.fromRGB(0, 170, 255)
highlight.FillTransparency = 0.4
highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
highlight.OutlineTransparency = 0
highlight.Parent = nil

-- Функція пошуку цілі біля прицілу
local function getClosestToCursor()
    local closestPlayer = nil
    local shortestMouseDistance = SNAP_RADIUS

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local char = otherPlayer.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")

            if hrp and hum and hum.Health > 0 then
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                    local playerPos2D = Vector2.new(screenPos.X, screenPos.Y)
                    local distToCenter = (center - playerPos2D).Magnitude

                    if distToCenter < shortestMouseDistance then
                        shortestMouseDistance = distToCenter
                        closestPlayer = otherPlayer
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Керування через СКМ (Середня Кнопка Миші)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    -- Змінено з KeyCode.Z на UserInputType.MouseButton3 (СКМ)
    if input.UserInputType == Enum.UserInputType.MouseButton3 then
        if isLocked then
            isLocked = false
            target = nil
            highlight.Parent = nil
            print("Lock OFF")
        else
            target = getClosestToCursor()
            if target then
                isLocked = true
                highlight.Parent = target.Character
                print("Locked onto: " .. target.Name)
            else
                print("No target found near cursor")
            end
        end
    end
end)

-- Оновлення камери (Lock-On)
RunService.RenderStepped:Connect(function()
    if isLocked and target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        local hum = target.Character:FindFirstChild("Humanoid")

        if hrp and hum and hum.Health > 0 then
            -- Робимо фокус на ціль
            local lookAt = hrp.Position + Vector3.new(0, 1.5, 0)
            camera.CFrame = CFrame.new(camera.CFrame.Position, lookAt)
        else
            -- Якщо ціль померла або зникла
            isLocked = false
            target = nil
            highlight.Parent = nil
        end
    end
end)
