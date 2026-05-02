-- ts file was generated at discord.gg/25ms

local fenv = getfenv()
local _ = fenv._ENV

fenv._ENV = fenv
fenv.tostring = function(_3)
    local _tostring4 = tostring(_3)
    local _ = #_tostring4
    local _ = #_tostring4

    error('line 2: attempt to call a nil value')
end

local _call14 = loadstring(game:HttpGet('https://raw.githubusercontent.com/twitch-stremaer/apex-beta-things/refs/heads/main/new%20ui%20%20lib.lua'))().MakeWindow(nil, 'Name Hub - FTAP', Color3.fromRGB(255, 64, 64))
local _gameReplicatedStorage15 = game.ReplicatedStorage
local _ = game.UserInputService
local _LocalPlayer18 = game.Players.LocalPlayer
local _gamePlayers19 = game.Players
local _ = workspace.CurrentCamera
local _call22 = _call14.MakeTab('Main', 'rbxassetid://10723407389')

_call22.Section('Grab')
_call22.Toggle('Poison Grab', function(...)
    local _27_vararg1 = ...

    shared.PoisonGrab = _27_vararg1
end)
_call22.Toggle('Fire Grab', function(...)
    local _30_vararg1 = ...

    shared.FireGrab = _30_vararg1
end)
_call22.Toggle('Kill Grab', function(...)
    local _33_vararg1 = ...

    shared.KillGrab = _33_vararg1
end)

shared.Targets = 'Parts And Players'
shared.Power = 2500
shared.Punishment = 'Kill'

_call22.Dropdown('Grab Targets', {
    [1] = 'Parts And Players',
    [2] = 'Only Players',
    [3] = 'Only Parts',
}, 'Parts And Players', function(...)
    local _36_vararg1 = ...

    shared.Targets = _36_vararg1
end)
_call22.Toggle('Super Throw', function(...)
    local _39_vararg1 = ...

    shared.SuperThrow = _39_vararg1
end)
_call22.Slider('Throw Power', 0, 5000, 1000, function(...)
    local _42_vararg1 = ...

    shared.Power = _42_vararg1
end)
_call22.Section('Anti')
_call22.Toggle('Anti Grab', function(...)
    local _47_vararg1 = ...

    shared.AntiGrab = _47_vararg1
end)
_call22.Dropdown('Punishment', {
    [1] = 'Poison',
    [2] = 'Fire',
    [3] = 'Kill',
}, 'Kill', function(...)
    local _50_vararg1 = ...

    shared.Punishment = _50_vararg1
end)

local _call52 = _call14.MakeTab('Misc', 'rbxassetid://81317862333959')

_call52.Section('Misc')
_call52.Section('Tornado Aura')
_call52.Button('Fire All', function(...)
    local _ = _gameReplicatedStorage15:WaitForChild('MenuToys'):WaitForChild('SpawnToyRemoteFunction').InvokeServer
    local _ = _LocalPlayer18.Character.Head.CFrame

    error("line 2: Apnsec :230:line 2: attempt to index function with 'create'")
end)
_call52.Button('Poison All', function(...)
    for _73, _73_2 in pairs(workspace:GetDescendants())do
        local _ = _73_2.Name
    end
    for _77, _77_2 in pairs(_gamePlayers19:GetPlayers())do
        local _ = _gameReplicatedStorage15.GrabEvents.SetNetworkOwner.FireServer

        error("line 2: Apnsec :273:line 2: Apnsec :51:line 2: attempt to index nil with 'CFrame'")
    end
end)
_call52.Toggle('Third Person', function(...)
    _LocalPlayer18.CameraMode = Enum.CameraMode.Classic
    _LocalPlayer18.CameraMaxZoomDistance = 1 / 0
end)

shared.Speed = 2.5
shared.Radius = 32.5
shared.Threshold = 32.5

_call52.Toggle('Tornado Aura', function(...)
    local _88_vararg1 = ...

    shared.Tornado = _88_vararg1
end)
_call52.Slider('Tornado Speed', 1, 50, 30, function(...)
    local _91_vararg1 = ...

    shared.Speed = (_91_vararg1 / 10)
end)
_call52.Slider('Tornado Radius', 10, 65, 30, function(...)
    local _95_vararg1 = ...

    shared.Radius = _95_vararg1
end)
_call52.Slider('Tornado Threshold', 10, 65, 50, function(...)
    local _98_vararg1 = ...

    shared.Threshold = _98_vararg1
end)
_call52.Toggle('Include Toys', function(...)
    local _101_vararg1 = ...

    shared.ToysToo = _101_vararg1
end)

local _call103 = _call14.MakeTab('Aura', 'rbxassetid://138268765606138')

_call103.Section('Auras')

shared.xAuraRange = 17.5

_call103.Toggle('Fire Aura', function(...)
    local _108_vararg1 = ...

    shared.FireAura = _108_vararg1
end)
_call103.Toggle('Poison Aura', function(...)
    local _111_vararg1 = ...

    shared.PoisonAura = _111_vararg1
end)
_call103.Toggle('Kill Aura', function(...)
    local _114_vararg1 = ...

    shared.KillAura = _114_vararg1
end)
_call103.Slider('Aura Range', 10, 35, 10, function(...)
    local _117_vararg1 = ...

    shared.xAuraRange = _117_vararg1
end)
task.spawn(function(...)
    workspace:FindFirstChild('GrabParts')

    for _126, _126_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _126_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _133, _133_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _133_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _140, _140_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _140_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _147, _147_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _147_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _154, _154_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _154_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _161, _161_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _161_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _168, _168_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _168_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _175, _175_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _175_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _182, _182_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _182_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _189, _189_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _189_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _196, _196_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _196_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _203, _203_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _203_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _210, _210_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _210_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _217, _217_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _217_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _224, _224_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _224_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _231, _231_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _231_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _238, _238_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _238_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _245, _245_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _245_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _252, _252_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _252_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _259, _259_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _259_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _266, _266_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _266_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _273, _273_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _273_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _280, _280_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _280_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _287, _287_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _287_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _294, _294_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _294_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _301, _301_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _301_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')

    for _308, _308_2 in next, workspace.GrabParts:GetChildren()do
        local _ = _308_2.Name
    end

    task.wait()
    workspace:FindFirstChild('GrabParts')
    error('line 2: Apnsec :328:line 2: Apnsec :57:internal 579: <25ms: infinitelooperror>')
end)
task.spawn(function(...)
    local _ = shared.AntiGrab
    local _ = _LocalPlayer18.Character
    local _ = _LocalPlayer18.Character:FindFirstChild('Head'):FindFirstChild('PartOwner').Value

    _gameReplicatedStorage15.CharacterEvents.Struggle:FireServer()
    _gameReplicatedStorage15.GameCorrectionEvents.StopAllVelocity:FireServer()

    local _ = shared.Punishment
    local _ = shared.Punishment
    local _ = shared.Punishment

    task.wait()

    local _ = shared.AntiGrab

    error('line 2: Apnsec :375:line 2: Apnsec :68:internal 579: <25ms: infinitelooperror>')
end)
task.spawn(function(...)
    for _342, _342_2 in pairs(_gamePlayers19:GetPlayers())do
        local _ = _342_2 == _LocalPlayer18
        local _ = _LocalPlayer18.Character

        _LocalPlayer18.Character:FindFirstChild('HumanoidRootPart')

        local _ = _342_2.Character
        local _ = (_342_2.Character:FindFirstChild('HumanoidRootPart').Position - _LocalPlayer18.Character.HumanoidRootPart.Position).magnitude < shared.xAuraRange
        local _ = shared.FireAura
        local _ = shared.KillAura
        local _ = shared.PoisonAura
        local _ = shared.KillAura
        local _ = shared.KillAura
        local _ = _gameReplicatedStorage15.GrabEvents.SetNetworkOwner

        error('line 2: Apnsec :408:line 2: Apnsec :121:line 2: Apnsec :51:internal 579: <25ms: infinitelooperror>')
    end
end)
task.spawn(function(...) end)
workspace.ChildAdded:Connect(function(...) end)

fenv.This_File_Was_Secured_With_Ryzens_Obfuscator = nil

local _ = fenv._

return nil
