local network = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/Librare2.lua", true))()
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/Librare.lua", true))()


local vals = {
    AntiEyefestation = true,
    NoLocalDamage = true,
    InstantInteract = true
}


local window = lib:MakeWindow({Title = "Zayac Hub - Pressure", CloseCallback = function()
    print("Menu Closed")
end}, true)

local mainPage = window:AddPage({Title = "Main Cheats"})

mainPage:AddToggle({Caption = "Anti Eyefestation (Shark)", Default = true, Callback = function(b)
    vals.AntiEyefestation = b
end})

mainPage:AddToggle({Caption = "GodMode (No Damage)", Default = true, Callback = function(b)
    vals.NoLocalDamage = b
end})

mainPage:AddToggle({Caption = "Instant Interact", Default = true, Callback = function(b)
    vals.InstantInteract = b
end})


local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if vals.NoLocalDamage and method == "FireServer" and self.Name == "LocalDamage" then
        return nil 
    end
    return oldNamecall(self, ...)
end)


task.spawn(function()
    while task.wait(0.5) do
        if vals.AntiEyefestation then
            local monsters = workspace:FindFirstChild("GameplayFolder") and workspace.GameplayFolder:FindFirstChild("Monsters")
            if monsters then
                for _, monster in pairs(monsters:GetChildren()) do
                    if monster.Name:lower():match("eyefestation") then
                        local active = monster:FindFirstChild("Active")
                        if active then active.Value = false end
                    end
                end
            end
        end
    end
end)


game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if vals.InstantInteract then
        fireproximityprompt(prompt)
    end
end)
