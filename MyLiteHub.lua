local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Zayac Lite Hub",
   LoadingTitle = "Завантаження систем...",
   LoadingSubtitle = "by Zayac333",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ZayacHub", 
      FileName = "Config"
   }
})

-- Змінні для функцій
local Settings = {
    SpeedValue = 16,
    SpeedEnabled = false,
    AntiFling = false
}

-- ВКЛАДКА MOVEMENT
local MainTab = Window:CreateTab("Movement", 4483362458) -- ID іконки

MainTab:CreateToggle({
   Name = "Speed Hack (V Key)",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      Settings.SpeedEnabled = Value
   end,
})

MainTab:CreateSlider({
   Name = "Speed Boost Value",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      Settings.SpeedValue = Value
   end,
})

-- ВКЛАДКА ANTIS & FLING
local FlingTab = Window:CreateTab("Fling & Antis", 4483362458)

FlingTab:CreateToggle({
   Name = "Anti-Fling",
   CurrentValue = false,
   Flag = "AntiFling",
   Callback = function(Value)
      Settings.AntiFling = Value
   end,
})

FlingTab:CreateButton({
   Name = "Click Fling (Ctrl + Click)",
   Callback = function()
      Rayfield:Notify({
         Title = "Активовано",
         Content = "Затисни Ctrl та натисни на гравця, щоб флінгнути його!",
         Duration = 5,
         Image = 4483362458,
      })
   end,
})

-- ЛОГІКА РОБОТИ (Цикли)
game:GetService("RunService").Heartbeat:Connect(function()
    -- Швидкість
    if Settings.SpeedEnabled and game.Players.LocalPlayer.Character then
        local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = Settings.SpeedValue end
    end

    -- Anti-Fling
    if Settings.AntiFling then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.Velocity = Vector3.new(0,0,0)
                    end
                end
            end
        end
    end
end)

-- Флінг мишкою (працює завжди, коли натиснуто Ctrl)
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            local root = game.Players.LocalPlayer.Character.HumanoidRootPart
            local targetRoot = target.Parent:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local oldCF = root.CFrame
                root.CFrame = targetRoot.CFrame
                root.Velocity = Vector3.new(999999, 999999, 999999)
                task.wait(0.1)
                root.CFrame = oldCF
            end
        end
    end
end)

Rayfield:Notify({
   Title = "Вітаємо!",
   Content = "Твій власний Lite Hub успішно запущено.",
   Duration = 5,
   Image = 4483362458,
})
