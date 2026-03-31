local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local target = nil
local isLocked = false
local MAX_DISTANCE = 1000 -- Велика дистанція для тесту
local SNAP_RADIUS = 200 -- Наскільки близько до центру екрана має бути ворог

-- Блакитна підсвітка
local highlight = Instance.new("Highlight")
highlight.FillColor = Color3.fromRGB(0, 170, 255)
highlight.FillTransparency = 0.4
highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
highlight.OutlineTransparency = 0
highlight.Parent = nil

-- Функція пошуку
local function getClosestToCursor()
    local closestPlayer = nil
    local shortestMouseDistance = SNAP_RADIUS

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local char = otherPlayer.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")

            if hrp and hum and hum.Health > 0 then
                -- Отримуємо позицію гравця на екрані
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    -- Центр екрана
                    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                    local playerPos2D = Vector2.new(screenPos.X, screenPos.Y)
                    local distToCenter = (center - playerPos2D).Magnitude

                    -- Якщо цей гравець ближче до прицілу, ніж попередній
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

-- Керування клавішею Z
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.Z then
        if isLocked then
            isLocked = false
            target = nil
            highlight.Parent = nil
            print("Lock OFF") -- Для перевірки в консолі (F9)
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

-- Оновлення камери
RunService.RenderStepped:Connect(function()
    if isLocked and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart
        local hum = target.Character:FindFirstChild("Humanoid")

        if hum and hum.Health > 0 then
            -- Дивимося на груди/голову
            local lookAt = hrp.Position + Vector3.new(0, 1.5, 0)
            camera.CFrame = CFrame.new(camera.CFrame.Position, lookAt)
        else
            isLocked = false
            target = nil
            highlight.Parent = nil
        end
    end
end)
