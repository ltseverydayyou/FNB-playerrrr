if not game:IsLoaded() then
    game.Loaded:Wait()
end

local connections = {
    _list = {},
    add = function(self, signal, onFire)
        self._list[#self._list + 1] = signal:Connect(onFire)
    end,
    disconnect = function(self)
        for _, v in pairs(self._list) do
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
local PlayerGui = Client.PlayerGui
local UserInputService = game:GetService('UserInputService')
local VirtualInputManager = game:GetService('VirtualInputManager')

local IsOnMobile = (function()
    local platform = UserInputService:GetPlatform()
    if
        platform == Enum.Platform.IOS
        or platform == Enum.Platform.Android
        or platform == Enum.Platform.AndroidTV
        or platform == Enum.Platform.Chromecast
        or platform == Enum.Platform.MetaOS
    then
        return true
    end
    if platform == Enum.Platform.None then
        return UserInputService.TouchEnabled
            and not (
                UserInputService.KeyboardEnabled
                or UserInputService.MouseEnabled
            )
    end
    return false
end)()

local IsOnPC = (function()
    local platform = UserInputService:GetPlatform()
    if
        platform == Enum.Platform.Windows
        or platform == Enum.Platform.OSX
        or platform == Enum.Platform.Linux
        or platform == Enum.Platform.SteamOS
        or platform == Enum.Platform.UWP
        or platform == Enum.Platform.DOS
        or platform == Enum.Platform.BeOS
    then
        return true
    end
    if platform == Enum.Platform.None then
        return UserInputService.KeyboardEnabled or UserInputService.MouseEnabled
    end
    return false
end)()

local Input = Client:WaitForChild('Input')
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

local Rayfield = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/ltseverydayyou/Rayfield-backup/refs/heads/main/Rayfield'
    )
)()
local Window = Rayfield:CreateWindow({
    Name = "Friday Night Bloxxin' Autoplayer REVIVED",
    LoadingTitle = 'FNB Autoplayer',
    LoadingSubtitle = tostring(SplashText),
    HidePremium = true,
    DisableRayfieldPrompts = false,
    ConfigurationSaving = { Enabled = true, FolderName = 'ltseverydayyou-fnb' },
})

local TabMain = Window:CreateTab('Main', 4483345998)
local TabCredits = Window:CreateTab('Credits', 2484564290)
local TabExtras = Window:CreateTab('Extras', 7468828225)
local TabKeybinds = Window:CreateTab('Keybinds', 6472846460)

local AutoEnabled = true
local OffsetMs = 0
local ReleaseAllActiveLanes = function() end
local onChildAdded

local Toggle = TabMain:CreateToggle({
    Name = 'Autoplayer',
    CurrentValue = true,
    Flag = 'hello',
    Callback = function(v)
        AutoEnabled = v
        if not v then
            pcall(ReleaseAllActiveLanes)
        end
    end,
})

if TabKeybinds then
    TabKeybinds:CreateKeybind({
        Name = 'Autoplayer toggle',
        CurrentKeybind = 'End',
        Hold = false,
        Flag = 'helloT',
        Callback = function()
            Toggle:Set(not Toggle.CurrentValue)
        end,
    })
end

local OffsetSlider = TabMain:CreateSlider({
    Name = 'Hit offset',
    Range = { -50, 50 },
    Increment = 0.1,
    Suffix = 'ms',
    CurrentValue = 0,
    Flag = 'ms',
    Callback = function(v)
        OffsetMs = tonumber(v) or 0
    end,
})

TabMain:CreateInput({
    Name = 'above',
    PlaceholderText = '0',
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        local n = tonumber(Value) or 0
        OffsetSlider:Set(n)
        OffsetMs = n
    end,
})

if TabKeybinds then
    TabKeybinds:CreateKeybind({
        Name = 'Reset',
        CurrentKeybind = 'PageUp',
        Hold = false,
        Flag = 'lmao',
        Callback = function()
            Client.Character:BreakJoints()
        end,
    })
end

TabCredits:CreateParagraph({ Title = 'Fixed by ltseverydayyou', Content = '' })
TabCredits:CreateParagraph({ Title = 'Original by Mati278', Content = '' })
TabCredits:CreateParagraph({
    Title = 'AC bypass by ltseverydayyou',
    Content = '',
})

TabExtras:CreateButton({
    Name = 'Unload script',
    Callback = function()
        AutoEnabled = false
        pcall(ReleaseAllActiveLanes)
        connections:disconnect()
        pcall(function()
            Rayfield:Destroy()
        end)
        script:Destroy()
    end,
})

TabExtras:CreateButton({
    Name = 'Instant Solo',
    Callback = function()
        local sp = Client.PlayerGui:WaitForChild('SingleplayerUI', 2)
        if sp then
            sp.ButtonPressed:FireServer()
        end
    end,
})

TabExtras:CreateButton({
    Name = 'Reload',
    Callback = function()
        AutoEnabled = false
        pcall(ReleaseAllActiveLanes)
        connections:disconnect()
        connections:add(PlayerGui.ChildAdded, onChildAdded)
        task.spawn(onChildAdded, PlayerGui:FindFirstChild('FNFEngine'))
        AutoEnabled = true
        Rayfield:Notify({ Title = 'FNB', Content = 'Reloaded.', Duration = 4 })
    end,
})

if TabKeybinds then
    TabKeybinds:CreateKeybind({
        Name = 'Instant Solo',
        CurrentKeybind = 'PageDown',
        Hold = false,
        Flag = 'SoloKey',
        Callback = function()
            Client.PlayerGui
                :WaitForChild('SingleplayerUI').ButtonPressed
                :FireServer()
        end,
    })
end

local function notifyMissing(title, content)
    Rayfield:Notify({ Title = title, Content = content, Duration = 7 })
end

do
    local missingAny = false
    if
        not (
            typeof(hookmetamethod) == 'function'
            and typeof(newcclosure) == 'function'
            and typeof(getnamecallmethod) == 'function'
            and typeof(checkcaller) == 'function'
        )
    then
        missingAny = true
        notifyMissing(
            'Missing requirement',
            'hookmetamethod/newcclosure/getnamecallmethod/checkcaller'
        )
    end
    if typeof(getconnections) ~= 'function' then
        missingAny = true
        notifyMissing('Missing requirement', 'getconnections')
    end
    if IsOnMobile and typeof(firesignal) ~= 'function' then
        missingAny = true
        notifyMissing('Missing requirement', 'firesignal (needed on mobile)')
    end
    if missingAny then
        notifyMissing(
            'FNB Autoplayer',
            'One or more requirements are missing; functionality may be limited.'
        )
    end
end

do
    if
        typeof(hookmetamethod) == 'function'
        and typeof(newcclosure) == 'function'
        and typeof(getnamecallmethod) == 'function'
        and typeof(checkcaller) == 'function'
    then
        local oldhmmi
        local oldhmmnc
        oldhmmi = hookmetamethod(game, '__index', function(self, method)
            if
                self == Client
                and typeof(method) == 'string'
                and method:lower() == 'kick'
            then
                return error(
                    "Expected ':' not '.' calling member function Kick",
                    2
                )
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
    end
end

onChildAdded = function(Object)
    if not Object or Object.Name ~= 'FNFEngine' then
        return
    end
    local function IsOnHit(m)
        return (m ~= nil and require(m).Type == 'OnHit')
    end
    local function Filter(iter, fn)
        local t = {}
        for _, v in pairs(iter) do
            t[#t + 1] = fn(v)
        end
        return t
    end

    local Stage = Object.Engine.Stage.Value
    while not Stage.Config.Song.Value do
        Object.Engine.Config.TimePast.Changed:Wait()
    end

    local Song = Stage.Config.Song.Value
    local PoisonNotes
    local ScrollSpeed = (
        Input.ScrollSpeedChange.Value and Input.ScrollSpeed.Value
    )
        or (function()
            local p = Song and Song.Parent
            local s = p and p:FindFirstChild('Sound')
            local ps = s and s:FindFirstChild('PlaybackSpeed')
            return (ps and tonumber(ps.Value)) or 1
        end)()

    local baseOffset = (
        (Offsets[string.format('%.1f', ScrollSpeed)] or 0) / 1000
    ) + 0.4
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

    local Map = Keys[#IncomingNotes] or {}
    local Session = {}
    for kn, kv in pairs(Map) do
        Session[kn] = Enum.KeyCode[Input.Keybinds[kv].Value]
    end

    if typeof(getconnections) == 'function' then
        for _, c in
            pairs(getconnections(Object.Engine.Events.UserInput.OnClientEvent))
        do
            c:Disable()
        end
    end

    local MobileButtons = Object.Engine:FindFirstChild('MobileButtons')
    local MobileContainer = MobileButtons
        and MobileButtons:FindFirstChild('Container')

    local function getBtn(name)
        if not IsOnMobile then
            return nil
        end
        if not MobileContainer then
            return nil
        end
        local b = MobileContainer:FindFirstChild(name)
        if not b and name == 'Space' then
            b = MobileContainer:FindFirstChild('SPACE')
                or MobileContainer:FindFirstChild('space')
        end
        return b
    end

    local function pressLane(name, keyCode)
        if IsOnMobile then
            if typeof(firesignal) == 'function' then
                local b = getBtn(name)
                if b then
                    pcall(firesignal, b.MouseButton1Down)
                end
            end
            return
        end
        if IsOnPC then
            VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
        end
    end

    local function releaseLane(name, keyCode)
        if IsOnMobile then
            if typeof(firesignal) == 'function' then
                local b = getBtn(name)
                if b then
                    pcall(firesignal, b.MouseButton1Up)
                end
            end
            return
        end
        if IsOnPC then
            VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
        end
    end

    local laneDown = {}
    local laneCount = {}
    ReleaseAllActiveLanes = function()
        for holderName, down in pairs(laneDown) do
            if down then
                local code = Session[holderName]
                if code then
                    releaseLane(holderName, code)
                end
                laneDown[holderName] = false
            end
        end
        for k in pairs(laneCount) do
            laneCount[k] = 0
        end
    end

    for _, Holder in pairs(IncomingNotes) do
        connections:add(Holder.ChildAdded, function(Arrow)
            if not Arrow or not Arrow.Visible then
                return
            end
            if
                Arrow:FindFirstChild('HellNote')
                and Arrow.HellNote.Value
                and PoisonNotes
            then
                return
            end
            if IsOnHit(Arrow:FindFirstChildOfClass('ModuleScript')) then
                return
            end

            local keyCode = Session[Holder.Name]
            if not keyCode then
                return
            end

            task.wait(baseOffset + (OffsetMs / 1000))
            if not AutoEnabled then
                return
            end

            local f = Arrow:FindFirstChild('Frame')
            local Bar = f and f:FindFirstChild('Bar')
            local isHold = false
            if Bar and Bar.Size and Bar.Size.Y then
                isHold = Bar.Size.Y.Scale > 0.02
            end

            if not isHold and laneDown[Holder] then
                local rehold = (laneCount[Holder] or 0) > 0
                releaseLane(Holder.Name, keyCode)
                game:GetService('RunService').Heartbeat:Wait()
                pressLane(Holder.Name, keyCode)
                game:GetService('RunService').Heartbeat:Wait()
                if rehold then
                    laneDown[Holder] = true
                else
                    releaseLane(Holder.Name, keyCode)
                    laneDown[Holder] = false
                end
                return
            end

            laneCount[Holder] = (laneCount[Holder] or 0) + 1
            if not laneDown[Holder] then
                pressLane(Holder.Name, keyCode)
                laneDown[Holder] = true
            end

            while
                Arrow
                and Arrow.Parent
                and Arrow.Visible
                and Bar
                and Bar.Size
                and Bar.Size.Y
                and (Bar.Size.Y.Scale > 0.02)
            do
                if not AutoEnabled then
                    break
                end
                task.wait()
                f = Arrow:FindFirstChild('Frame')
                if f then
                    Bar = f:FindFirstChild('Bar')
                end
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

for _, v in pairs(workspace:GetDescendants()) do
    if v.ClassName == 'ProximityPrompt' then
        v.HoldDuration = 0
    end
end

if Input.Keybinds.R4.Value == ';' then
    game:GetService('ReplicatedStorage').Events.RemoteEvent
        :FireServer('Input', 'Semicolon', 'R4')
end