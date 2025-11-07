if not game:IsLoaded() then
    game.Loaded:Wait()
end
if game.GameId ~= 2953945619 then
    return
end

local connections = {
    _list = {},
    add = function(self, s, cb)
        self._list[#self._list + 1] = s:Connect(cb)
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
local HttpService = game:GetService('HttpService')
local MarketplaceService = game:GetService('MarketplaceService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RE = ReplicatedStorage:WaitForChild('Modules')
    :WaitForChild('Network')
    :WaitForChild('RE')

local IsOnMobile = (function()
    local p = UserInputService:GetPlatform()
    if
        p == Enum.Platform.IOS
        or p == Enum.Platform.Android
        or p == Enum.Platform.AndroidTV
        or p == Enum.Platform.Chromecast
        or p == Enum.Platform.MetaOS
    then
        return true
    end
    if p == Enum.Platform.None then
        return UserInputService.TouchEnabled
            and not (
                UserInputService.KeyboardEnabled
                or UserInputService.MouseEnabled
            )
    end
    return false
end)()
local IsOnPC = (function()
    local p = UserInputService:GetPlatform()
    if
        p == Enum.Platform.Windows
        or p == Enum.Platform.OSX
        or p == Enum.Platform.Linux
        or p == Enum.Platform.SteamOS
        or p == Enum.Platform.UWP
        or p == Enum.Platform.DOS
        or p == Enum.Platform.BeOS
    then
        return true
    end
    if p == Enum.Platform.None then
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
local TabKeybinds = IsOnMobile and nil
    or Window:CreateTab('Keybinds', 6472846460)

local AutoEnabled = true
local OffsetMs = 0
local ReleaseAllActiveLanes = function() end
local onChildAdded
local HideMobileBtns = true
local BRPCEnabled = true
local Mode = 'normal'

local function pname()
    local ok, info = pcall(
        MarketplaceService.GetProductInfo,
        MarketplaceService,
        game.PlaceId
    )
    return ok and info and info.Name
        or game:GetService('MarketplaceService')
            :GetProductInfo(game.PlaceId).Name
end
local function picon()
    local ok, info = pcall(
        MarketplaceService.GetProductInfo,
        MarketplaceService,
        game.PlaceId
    )
    if ok and info and info.IconImageAssetId and info.IconImageAssetId ~= 0 then
        return info.IconImageAssetId
    end
    return nil
end

local function rpc(details, state, largeId, largeHover, smallId, smallHover)
    if not BRPCEnabled then
        return
    end
    local data = {
        details = tostring(details or ''),
        state = tostring(state or ''),
        largeImage = largeId and {
            assetId = tonumber(largeId),
            hoverText = tostring(largeHover or ''),
        } or nil,
    }
    if smallId ~= nil then
        data.smallImage = {
            assetId = tonumber(smallId) or 0,
            hoverText = tostring(smallHover or ''),
        }
    end
    print('[BloxstrapRPC] ' .. HttpService:JSONEncode({
        command = 'SetRichPresence',
        data = data,
    }))
end

local function lobbyRPC()
    rpc(pname(), 'Lobby', picon(), pname(), nil, nil)
end

local function parseCredit(txt)
    local t = txt or ''
    local ln1 = t:match('^[^\n]+') or ''
    ln1 = ln1:gsub('%s%(%d+%.?%d*x%)', '')
    local rest = t:gsub('^[^\n]*\n?', '')
    rest = rest:gsub('\n?%d+:%d%d%s*$', '')
    rest = rest:gsub('^%s+', ''):gsub('%s+$', '')
    return ln1, rest
end

local function scan()
    local eng = PlayerGui:FindFirstChild('FNFEngine')
    if not eng then
        lobbyRPC()
        return
    end
    local engine = eng:FindFirstChild('Engine')
    local lower = engine and engine:FindFirstChild('LowerContainer')
    local credit = lower and lower:FindFirstChild('Credit')
    local det, st = '', ''
    if credit and credit:IsA('TextLabel') then
        det, st = parseCredit(credit.Text)
    end
    local sid
    local mods = engine and engine:FindFirstChild('Modifiers')
    local ghost = mods and mods:FindFirstChild('GhostTapping')
    if ghost and ghost:IsA('ImageButton') and type(ghost.Image) == 'string' then
        local d = ghost.Image:match('%d+')
        sid = d and tonumber(d) or nil
    end
    local sideVal = engine
            and engine:FindFirstChild('PlayerSide')
            and engine.PlayerSide.Value
        or 'L'
    local sh = 'Side: ' .. (sideVal == 'L' and 'Left' or 'Right')
    rpc(det, st, picon(), pname(), sid, sh)
end

local tAuto = TabMain:CreateToggle({
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

if not IsOnMobile then
    TabKeybinds:CreateKeybind({
        Name = 'Autoplayer toggle',
        CurrentKeybind = 'End',
        Hold = false,
        Flag = 'helloT',
        Callback = function()
            tAuto:Set(not tAuto.CurrentValue)
        end,
    })
end

local sSpd = TabMain:CreateSlider({
    Name = 'Scroll Speed',
    Range = { 0.5, 50.0 },
    Increment = 0.1,
    Suffix = 'x',
    CurrentValue = (Input and Input.ScrollSpeed and tonumber(
        Input.ScrollSpeed.Value
    )) or 1,
    Flag = 'speed',
    Callback = function(v)
        local sv = tonumber(v) or 1
        if sv < 0.5 then
            sv = 0.5
        end
        if sv > 50 then
            sv = 50
        end
        RE:FireServer('REMOTE_EVENT', {
            buffer.fromstring('"Input"'),
            buffer.fromstring(tostring(sv)),
            buffer.fromstring('"ScrollSpeed"'),
        })
    end,
})

TabMain:CreateInput({
    Name = 'speed above',
    PlaceholderText = tostring(
        (Input and Input.ScrollSpeed and tonumber(Input.ScrollSpeed.Value)) or 1
    ),
    RemoveTextAfterFocusLost = false,
    Callback = function(v)
        local n = tonumber(v)
        if not n then
            return
        end
        if n < 0.5 then
            n = 0.5
        end
        if n > 50 then
            n = 50
        end
        sSpd:Set(n)
        RE:FireServer('REMOTE_EVENT', {
            buffer.fromstring('"Input"'),
            buffer.fromstring(tostring(n)),
            buffer.fromstring('"ScrollSpeed"'),
        })
    end,
})

local sMs = TabMain:CreateSlider({
    Name = 'Hit offset',
    Range = { -100, 100 },
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
    Callback = function(v)
        local n = tonumber(v) or 0
        sMs:Set(n)
        OffsetMs = n
    end,
})

if not IsOnMobile then
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

if not IsOnMobile then
    TabKeybinds:CreateKeybind({
        Name = 'Instant Solo',
        CurrentKeybind = 'PageDown',
        Hold = false,
        Flag = 'SoloKey',
        Callback = function()
            local ui = Client.PlayerGui:FindFirstChild('SingleplayerUI')
            if ui then
                ui.ButtonPressed:FireServer()
            end
        end,
    })
end

if IsOnMobile then
    TabMain:CreateToggle({
        Name = 'Hide Mobile Buttons',
        CurrentValue = true,
        Flag = 'hideMobile',
        Callback = function(v)
            HideMobileBtns = v
            local eng = PlayerGui:FindFirstChild('FNFEngine')
            if not eng then
                return
            end
            local mb = eng.Engine:FindFirstChild('MobileButtons')
            local cont = mb and mb:FindFirstChild('Container')
            if cont then
                cont.Visible = not v
            end
        end,
    })
end

local actorsAPI = (
    typeof(getactors) == 'function' and typeof(run_on_actor) == 'function'
)
if actorsAPI then
    TabMain:CreateDropdown({
        Name = 'Autoplayer Mode',
        Options = { 'normal', 'actor' },
        CurrentOption = Mode,
        Flag = 'mode',
        Callback = function(opt)
            local sel = (typeof(opt) == 'table') and (opt[1] or Mode)
                or tostring(opt)
            if sel == 'actor' or sel == 'normal' then
                Mode = sel
            end
        end,
    })
end

if typeof(setclipboard) == 'function' then
    TabCredits:CreateButton({
        Name = 'Fixed by ltseverydayyou',
        Callback = function()
            setclipboard('https://github.com/ltseverydayyou')
            Rayfield:Notify({
                Title = 'Copied',
                Content = 'GitHub URL copied to clipboard',
                Duration = 3,
            })
        end,
    })
    TabCredits:CreateButton({
        Name = 'Original by Mati278',
        Callback = function()
            setclipboard('https://github.com/Mati278')
            Rayfield:Notify({
                Title = 'Copied',
                Content = 'GitHub URL copied to clipboard',
                Duration = 3,
            })
        end,
    })
else
    TabCredits:CreateParagraph({
        Title = 'Fixed by ltseverydayyou',
        Content = 'https://github.com/ltseverydayyou',
    })
    TabCredits:CreateParagraph({
        Title = 'Original by Mati278',
        Content = 'https://github.com/Mati278',
    })
end

TabCredits:CreateParagraph({
    Title = 'Anticheat bypass by ltseverydayyou',
    Content = '',
})

TabExtras:CreateToggle({
    Name = 'Bloxstrap RPC',
    CurrentValue = true,
    Flag = 'brpc',
    Callback = function(v)
        BRPCEnabled = v
        if v then
            scan()
        end
    end,
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
        local sp = PlayerGui:WaitForChild('SingleplayerUI', 2)
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

local function reqok()
    return typeof(hookmetamethod) == 'function'
        and typeof(newcclosure) == 'function'
        and typeof(getnamecallmethod) == 'function'
        and typeof(checkcaller) == 'function'
end
local function notifyMissing(t, c)
    Rayfield:Notify({ Title = t, Content = c, Duration = 7 })
end

do
    local miss = false
    if not reqok() then
        miss = true
        notifyMissing(
            'Missing requirement',
            'hookmetamethod/newcclosure/getnamecallmethod/checkcaller'
        )
    end
    if IsOnMobile and typeof(firesignal) ~= 'function' then
        miss = true
        notifyMissing('Missing requirement', 'firesignal (needed on mobile)')
    end
    if miss then
        notifyMissing(
            'FNB Autoplayer',
            'One or more requirements are missing; functionality may be limited.'
        )
    end
end

do
    if reqok then
        local oldhmmi
        local oldhmmnc
        oldhmmi = hookmetamethod(game, '__index', function(self, m)
            if
                self == Client
                and typeof(m) == 'string'
                and m:lower() == 'kick'
            then
                return error(
                    "Expected ':' not '.' calling member function Kick",
                    2
                )
            end
            return oldhmmi(self, m)
        end)
        oldhmmnc = hookmetamethod(
            game,
            '__namecall',
            newcclosure(function(self, ...)
                local l = (getnamecallmethod() or ''):lower()
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

local function computeBaseOffset(scrollSpeed)
    local key = string.format('%.1f', tonumber(scrollSpeed) or 1)
    local ms = Offsets[key]
    if ms == nil then
        local fallback = Offsets['10.0'] or 0
        ms = fallback
    end
    return (ms / 1000) + 0.4
end

local function pressLaneMobile(container, name)
    if typeof(firesignal) ~= 'function' then
        return
    end
    if not container then
        return
    end
    local b = container:FindFirstChild(name)
    if not b and name == 'Space' then
        b = container:FindFirstChild('SPACE')
            or container:FindFirstChild('space')
    end
    if b then
        pcall(firesignal, b.MouseButton1Down)
    end
end

local function releaseLaneMobile(container, name)
    if typeof(firesignal) ~= 'function' then
        return
    end
    if not container then
        return
    end
    local b = container:FindFirstChild(name)
    if not b and name == 'Space' then
        b = container:FindFirstChild('SPACE')
            or container:FindFirstChild('space')
    end
    if b then
        pcall(firesignal, b.MouseButton1Up)
    end
end

local function actorKey(op, codeName)
    if Mode ~= 'actor' then
        return false
    end
    if not actorsAPI then
        return false
    end
    local okA, actors = pcall(getactors)
    if not okA or type(actors) ~= 'table' or not actors[1] then
        return false
    end
    local src = 'local vim=game:GetService("VirtualInputManager");vim:SendKeyEvent('
        .. (op == 'press' and 'true' or 'false')
        .. ', Enum.KeyCode['
        .. string.format('%q', codeName)
        .. '], false, nil)'
    pcall(run_on_actor, actors[1], src)
    return false
end

local function playNoteSequence(Holder, Arrow, keyCode, AutoCtx)
    task.spawn(function()
        local baseOffset = AutoCtx.baseOffset
        task.wait(baseOffset + (AutoCtx.offsetMs / 1000))
        if not AutoCtx.enabled then
            return
        end
        if not Arrow or not Arrow.Parent or not Arrow.Visible then
            return
        end
        local function isHold(a)
            local f = a:FindFirstChild('Frame')
            local b = f and f:FindFirstChild('Bar')
            return (b and b.Size and b.Size.Y and (b.Size.Y.Scale > 0.02))
                or false
        end
        local currentlyHold = isHold(Arrow)
        if not currentlyHold and AutoCtx.laneDown[Holder] then
            local rehold = (AutoCtx.laneCount[Holder] or 0) > 0
            AutoCtx.release(Holder.Name, keyCode)
            game:GetService('RunService').Heartbeat:Wait()
            AutoCtx.press(Holder.Name, keyCode)
            game:GetService('RunService').Heartbeat:Wait()
            if rehold then
                AutoCtx.laneDown[Holder] = true
            else
                AutoCtx.release(Holder.Name, keyCode)
                AutoCtx.laneDown[Holder] = false
            end
            return
        end
        AutoCtx.laneCount[Holder] = (AutoCtx.laneCount[Holder] or 0) + 1
        if not AutoCtx.laneDown[Holder] then
            AutoCtx.press(Holder.Name, keyCode)
            AutoCtx.laneDown[Holder] = true
        end
        while Arrow and Arrow.Parent and Arrow.Visible do
            local f = Arrow:FindFirstChild('Frame')
            local b = f and f:FindFirstChild('Bar')
            local holding = (
                b
                and b.Size
                and b.Size.Y
                and (b.Size.Y.Scale > 0.0)
            ) or false
            if not holding then
                break
            end
            if not AutoCtx.enabled then
                break
            end
            task.wait()
        end
        AutoCtx.laneCount[Holder] = AutoCtx.laneCount[Holder] - 1
        if AutoCtx.laneCount[Holder] <= 0 then
            AutoCtx.laneCount[Holder] = 0
            if AutoCtx.laneDown[Holder] then
                AutoCtx.release(Holder.Name, keyCode)
                AutoCtx.laneDown[Holder] = false
            end
        end
    end)
end

onChildAdded = function(Object)
    if not Object or Object.Name ~= 'FNFEngine' then
        scan()
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
    local scrollSpeed = (
        Input.ScrollSpeedChange.Value and Input.ScrollSpeed.Value
    )
        or (function()
            local p = Song and Song.Parent
            local s = p and p:FindFirstChild('Sound')
            local ps = s and s:FindFirstChild('PlaybackSpeed')
            return (ps and tonumber(ps.Value)) or 1
        end)()
    local baseOffset = computeBaseOffset(scrollSpeed)
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
    if IsOnMobile then
        local mb = Object.Engine:FindFirstChild('MobileButtons')
        local cont = mb and mb:FindFirstChild('Container')
        if cont and HideMobileBtns then
            cont.Visible = false
        end
    end
    local MobileButtons = Object.Engine:FindFirstChild('MobileButtons')
    local MobileContainer = MobileButtons
        and MobileButtons:FindFirstChild('Container')
    local function pressLane(name, keyCode)
        if IsOnMobile then
            pressLaneMobile(MobileContainer, name)
            return
        end
        if Mode == 'actor' then
            if not actorKey('press', keyCode.Name) then
                VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
            end
            return
        end
        if IsOnPC then
            VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
        end
    end
    local function releaseLane(name, keyCode)
        if IsOnMobile then
            releaseLaneMobile(MobileContainer, name)
            return
        end
        if Mode == 'actor' then
            if not actorKey('release', keyCode.Name) then
                VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
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
    local lower = Object.Engine:FindFirstChild('LowerContainer')
    local credit = lower and lower:FindFirstChild('Credit')
    local psVal = Object.Engine:FindFirstChild('PlayerSide')
    if credit then
        connections:add(credit:GetPropertyChangedSignal('Text'), scan)
    end
    if psVal then
        connections:add(psVal.Changed, scan)
    end
    scan()
    local AutoCtx = {
        enabled = true,
        offsetMs = OffsetMs,
        baseOffset = baseOffset,
        laneDown = laneDown,
        laneCount = laneCount,
        press = pressLane,
        release = releaseLane,
    }
    connections:add(Input.ScrollSpeed.Changed, function()
        sSpd:Set(tonumber(Input.ScrollSpeed.Value) or 1)
    end)
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
            if not AutoEnabled then
                return
            end
            AutoCtx.enabled = AutoEnabled
            AutoCtx.offsetMs = OffsetMs
            AutoCtx.baseOffset = computeBaseOffset(
                (Input.ScrollSpeedChange.Value and Input.ScrollSpeed.Value) or 1
            )
            playNoteSequence(Holder, Arrow, keyCode, AutoCtx)
        end)
    end
end

connections:add(PlayerGui.ChildAdded, onChildAdded)
connections:add(PlayerGui.ChildRemoved, function(o)
    if o and o.Name == 'FNFEngine' then
        scan()
    end
end)
task.spawn(onChildAdded, PlayerGui:FindFirstChild('FNFEngine'))
scan()

for _, v in pairs(workspace:GetDescendants()) do
    if v.ClassName == 'ProximityPrompt' then
        v.HoldDuration = 0
    end
end

Rayfield:LoadConfiguration()

if Input.Keybinds.R4.Value == ';' then
    RE:FireServer('REMOTE_EVENT', {
        buffer.fromstring('"Input"'),
        buffer.fromstring('"Semicolon"'),
        buffer.fromstring('"R4"'),
    })
end