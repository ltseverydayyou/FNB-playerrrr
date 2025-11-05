if not game:IsLoaded() then
    game.Loaded:Wait()
end
local connections = {
    _list = {},
    add = function(self, signal, onFire)
        self._list[#self._list + 1] = signal:Connect(onFire)
    end,
    disconnect = function(self)
        for i, v in pairs(self._list) do
            if type(v) == 'userdata' and v.Connected then
                v:Disconnect()
            end
        end
        table.clear(self._list)
    end,
}
local spLimit = 2
local SplashIndex = math.random(1, spLimit)
local SplashText
if SplashIndex == 1 then
    SplashText = 'amogus'
end
if SplashIndex == 2 then
    SplashText = 'fixed the autoplayer'
end

local Client = game:GetService('Players').LocalPlayer
local Input = Client:WaitForChild('Input')
local PlayerGui = Client.PlayerGui
loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/ltseverydayyou/FNB-playerrrr/refs/heads/main/uselessAhh.luau'
    )
)()
local Offsets = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/ltseverydayyou/FNB-playerrrr/refs/heads/main/speedManager.lua'
    )
)()
local Keys = {
    [4] = { Left = 'Left', Down = 'Down', Up = 'Up', Right = 'Right' },
    [5] = {
        Left = 'Left',
        Down = 'Down',
        Space = 'Space',
        Up = 'Up',
        Right = 'Right',
    },
    [6] = { S = 'L3', D = 'L2', F = 'L1', J = 'R1', K = 'R2', L = 'R3' },
    [7] = {
        S = 'L3',
        D = 'L2',
        F = 'L1',
        Space = 'Space',
        J = 'R1',
        K = 'R2',
        L = 'R3',
    },
    [8] = {
        A = 'L4',
        S = 'L3',
        D = 'L2',
        F = 'L1',
        H = 'R1',
        J = 'R2',
        K = 'R3',
        L = 'R4',
    },
    [9] = {
        A = 'L4',
        S = 'L3',
        D = 'L2',
        Space = 'Space',
        F = 'L1',
        H = 'R1',
        J = 'R2',
        K = 'R3',
        L = 'R4',
    },
}

local oldhmmi
local oldhmmnc
oldhmmi = hookmetamethod(game, '__index', function(self, method)
    if self == Client and method:lower() == 'kick' then
        return error("Expected ':' not '.' calling member function Kick", 2)
    end
    return oldhmmi(self, method)
end)
oldhmmnc = hookmetamethod(
    game,
    '__namecall',
    newcclosure(function(self, ...)
        local m = getnamecallmethod()
        local l = m and m:lower() or ''
        if self == Client and l == 'kick' then
            return
        end
        if not checkcaller() and l == 'findservice' then
            local first = ...
            if
                typeof(first) == 'string'
                and first:lower() == 'virtualinputmanager'
            then
                return
            end
        end
        return oldhmmnc(self, ...)
    end)
)

local set_identity = (
    syn and syn.set_thread_identity
    or setidentity
    or setthreadcontext
)
local Library = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/jensonhirst/Orion/refs/heads/main/source'
    )
)()
local Window = Library:MakeWindow({
    IntroText = tostring(SplashText),
    Name = "Friday Night Bloxxin' Autoplayer REVIVED",
    HidePremium = true,
    SaveConfig = true,
    ConfigFolder = 'ltseverydayyou-fnb',
})
local Folder = Window:MakeTab({
    Name = 'Main',
    Icon = 'rbxassetid://4483345998',
    PremiumOnly = false,
})
local CreditsFolder = Window:MakeTab({
    Name = 'Credits',
    Icon = 'rbxassetid://2484564290',
    PremiumOnly = false,
})
local KeybindFolder = Window:MakeTab({
    Name = 'Keybinds',
    Icon = 'rbxassetid://6472846460',
    PremiumOnly = false,
})
local ExtrasFolder = Window:MakeTab({
    Name = 'Extras',
    Icon = 'rbxassetid://7468828225',
    PremiumOnly = false,
})
local Toggle = Folder:AddToggle({
    Name = 'Autoplayer',
    Default = true,
    Flag = 'hello',
    Save = true,
})
KeybindFolder:AddBind({
    Name = 'Autoplayer toggle',
    Default = Enum.KeyCode.End,
    Hold = false,
    Flag = 'helloT',
    Save = true,
    Callback = function()
        Toggle:Set(not Toggle.Value)
    end,
})
local OffsetToggle = Folder:AddSlider({
    Name = 'Hit offset',
    Min = -50,
    Max = 50,
    Default = 0,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    Flag = 'ms',
    Save = true,
})
Folder:AddTextbox({
    Name = 'above',
    Default = '0',
    extDisappear = false,
    Callback = function(Value)
        OffsetToggle:Set(Value)
    end,
})
Folder:AddButton({
    Name = 'Disable modcharts',
    Callback = function()
        loadstring(
            game:HttpGet(
                'https://raw.githubusercontent.com/ltseverydayyou/FNB-playerrrr/refs/heads/main/noModcharts.luau'
            )
        )()
        Library:MakeNotification({
            Name = 'Note',
            Content = 'You need to rejoin in order to re-enable modcharts',
            Image = 'rbxassetid://8370951784',
            Time = 5,
        })
    end,
})
KeybindFolder:AddBind({
    Name = 'Reset',
    Default = Enum.KeyCode.PageUp,
    Hold = false,
    Flag = 'lmao',
    Save = true,
    Callback = function()
        Client.Character:BreakJoints()
    end,
})
CreditsFolder:AddLabel('Fixed by ltseverydayyou')
CreditsFolder:AddLabel('Original by Mati278')
CreditsFolder:AddLabel('AC bypass by ltseverydayyou')
ExtrasFolder:AddButton({
    Name = 'Unload script',
    Callback = function()
        pcall(function()
            Library.Flags['hello'].Value = false
        end)
        connections:disconnect()
        pcall(function()
            Library:Destroy()
        end)
        script:Destroy()
    end,
})
ExtrasFolder:AddButton({
    Name = 'Instant Solo',
    Callback = function()
        local sp = Client.PlayerGui:WaitForChild('SingleplayerUI', 2)
        if sp then
            sp.ButtonPressed:FireServer()
        end
    end,
})
ExtrasFolder:AddButton({
    Name = 'Reload',
    Callback = function()
        pcall(function()
            Library.Flags['hello'].Value = false
        end)
        connections:disconnect()
        connections:add(PlayerGui.ChildAdded, onChildAdded)
        task.spawn(onChildAdded, PlayerGui:FindFirstChild('FNFEngine'))
        pcall(function()
            Library.Flags['hello'].Value = true
        end)
    end,
})
KeybindFolder:AddBind({
    Name = 'Instant Solo',
    Default = Enum.KeyCode.PageDown,
    Hold = false,
    Flag = 'SoloKey',
    Save = true,
    Callback = function()
        Client.PlayerGui
            :WaitForChild('SingleplayerUI').ButtonPressed
            :FireServer()
    end,
})

Library:Init()

local VirtualInputManager = (getvirtualinputmanager or game.GetService)(
    game,
    'VirtualInputManager'
)
local InputService = game:GetService('UserInputService')
local HttpService = game:GetService('HttpService')
local task = task
local type = type

function onChildAdded(Object)
    if not Object or Object.Name ~= 'FNFEngine' then return end
    local require = require
    local function IsOnHit(_)
        return (_ ~= nil and require(_).Type == 'OnHit')
    end
    local function Filter(iter, method)
        local returns = {}
        for i, v in pairs(iter) do
            returns[#returns + 1] = method(v)
        end
        return returns
    end

    local Stage = Object.Engine.Stage.Value
    while not Stage.Config.Song.Value do
        Object.Engine.Config.TimePast.Changed:Wait()
    end

    local Song = Stage.Config.Song.Value
    local PoisonNotes

    local ScrollSpeed = (Input.ScrollSpeedChange.Value and Input.ScrollSpeed.Value)
        or (function()
            local p = Song and Song.Parent
            local s = p and p:FindFirstChild('Sound')
            local ps = s and s:FindFirstChild('PlaybackSpeed')
            return (ps and tonumber(ps.Value)) or 1
        end)()

    local baseOffset = ((Offsets[string.format('%.1f', ScrollSpeed)] or 0) / 1000) + 0.4

    local Arrows = Object.Engine.Game[Object.Engine.PlayerSide.Value].Arrows
    local IncomingNotes = Filter(Arrows.IncomingNotes:GetChildren(), function(v)
        return not string.find(v.Name, '|') and v or nil
    end)

    if Song then
        PoisonNotes = (
            Song.Parent:FindFirstChild('MultiplieGimmickNotes')
            or Song:FindFirstChild('GimmickNotes')
            or Song.Parent:FindFirstChild('GimmickNotes')
            or Song:FindFirstChild('MineNotes')
            or {}
        ).Value == 'OnHit'
    end

    local Keybinds = Input.Keybinds
    local Session = {}
    for kn, kv in pairs(Keys[#IncomingNotes] or {}) do
        Session[kn] = Enum.KeyCode[Keybinds[kv].Value]
    end

    for _, connection in pairs(getconnections(Object.Engine.Events.UserInput.OnClientEvent)) do
        connection:Disable()
    end

    local MobileButtons = Object.Engine:FindFirstChild("MobileButtons")
    local MobileContainer = MobileButtons and MobileButtons:FindFirstChild("Container")

    local function getBtn(name)
        if not MobileContainer then return nil end
        local b = MobileContainer:FindFirstChild(name)
        if not b and name == "Space" then
            b = MobileContainer:FindFirstChild("SPACE") or MobileContainer:FindFirstChild("space")
        end
        return b
    end

    local function pressLane(name, keyCode)
        local b = getBtn(name)
        if b then
            pcall(firesignal, b.MouseButton1Down)
        else
            VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
        end
    end

    local function releaseLane(name, keyCode)
        local b = getBtn(name)
        if b then
            pcall(firesignal, b.MouseButton1Up)
        else
            VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
        end
    end

    local laneDown = {}
    local laneCount = {}

    for _, Holder in pairs(IncomingNotes) do
        connections:add(Holder.ChildAdded, function(Arrow)
            if not Arrow or not Arrow.Visible then return end
            if (Arrow:FindFirstChild("HellNote") and Arrow.HellNote.Value and PoisonNotes) then return end
            if IsOnHit(Arrow:FindFirstChildOfClass('ModuleScript')) then return end

            local keyCode = Session[Holder.Name]
            if not keyCode then return end

            task.wait(baseOffset + ((Library.Flags['ms'].Value or 0) / 1000))
            if not Library.Flags['hello'].Value then return end

            laneCount[Holder] = (laneCount[Holder] or 0) + 1
            if not laneDown[Holder] then
                pressLane(Holder.Name, keyCode)
                laneDown[Holder] = true
            end

            local f = Arrow:FindFirstChild("Frame")
            local Bar = f and f:FindFirstChild("Bar")
            while Arrow and Arrow.Parent and Arrow.Visible and Bar and Bar.Size and Bar.Size.Y
                and (Bar.Size.Y.Scale > 0.02) do
                if not Library.Flags['hello'].Value then break end
                task.wait()
                f = Arrow:FindFirstChild("Frame")
                if f then Bar = f:FindFirstChild("Bar") end
            end

            laneCount[Holder] = laneCount[Holder] - 1
            if laneCount[Holder] <= 0 then
                laneCount[Holder] = 0
                if laneDown[Holder] then
                    releaseLane(Holder.Name, keyCode)
                    laneDown[Holder] = false
                end
            end
        end)
    end
end

connections:add(PlayerGui.ChildAdded, onChildAdded)
task.spawn(onChildAdded, PlayerGui:FindFirstChild('FNFEngine'))

for i, v in pairs(workspace:GetDescendants()) do
    if v.ClassName == 'ProximityPrompt' then
        v.HoldDuration = 0
    end
end

if Input.Keybinds.R4.Value == ';' then
    game:GetService('ReplicatedStorage').Events.RemoteEvent
        :FireServer('Input', 'Semicolon', 'R4')
end
