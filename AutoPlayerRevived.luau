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

local spLimit = 15
local SplashIndex = math.random(1, spLimit)
local SplashText
if SplashIndex == 1 then
    SplashText = 'hi guys hows doin there'
end
if SplashIndex == 2 then
    SplashText =
        'Did u know that that in terms of male human and female pokemon breeding...'
end
if SplashIndex == 3 then
    SplashText =
        'They took everything from me: my voice, my freedom, my legacy; and they replaced me with some blue haired kid'
end
if SplashIndex == 4 then
    SplashText = 'amogus ඞ'
end
if SplashIndex == 5 then
    SplashText = 'swish i fixed the autoplayer for u :)'
end
if SplashIndex == 6 then
    SplashText = 'nah my man fq0e, kill urself instead u gigantic faggot'
end
if SplashIndex == 7 then
    SplashText =
        'Friday Night Funkin’: Vs. MX/Mario 85 - Game Over (ft. Kiwiquest) (+ FLP)'
end
if SplashIndex == 8 then
    SplashText = 'you will to be silenced'
end
if SplashIndex == 9 then
    SplashText = 'Are u winning, son?'
end
if SplashIndex == 10 then
    SplashText =
        'Now █████████████████-proof!'
end
if SplashIndex == 11 then
    SplashText = 'Testificate: Family guy edition!'
end
if SplashIndex == 12 then
    SplashText = "The cakes aren't lies here!"
end
if SplashIndex == 13 then
    SplashText = 'Made by professional shitters! :)'
end
if SplashIndex == 14 then
    SplashText = 'me when no rewrite'
end
if SplashIndex == 15 then
    SplashText = 'officilly bypassed lmao'
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
local Keybinds = Input.Keybinds

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

local function clampScrollSpeed(value)
    local n = tonumber(value) or 1
    if n < 0.5 then
        return 0.5
    end
    if n > 50 then
        return 50
    end
    return n
end

local scrollSpeedDefault = clampScrollSpeed(
    (Input and Input.ScrollSpeed and tonumber(Input.ScrollSpeed.Value)) or 1
)

local RPCDetailsPrefix = ''
local RPCStatePrefix = ''
local RPCSidePrefix = 'Side: '

local Obsidian = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua'
    )
)()
local Window = Obsidian:CreateWindow({
    Title = 'FNB Autoplayer',
    Footer = string.format(
        "Friday Night Bloxxin' Autoplayer REVIVED | %s",
        tostring(SplashText or '')
    ),
    Center = true,
    AutoShow = true,
    ShowCustomCursor = not IsOnMobile,
    NotifySide = 'Right',
})

local function notify(title, description, time)
    Obsidian:Notify({
        Title = tostring(title or 'FNB'),
        Description = tostring(description or ''),
        Time = time or 5,
    })
end

local function asset(id)
    return string.format('rbxassetid://%d', id)
end

local function formatWithPrefix(prefix, text)
    local prefixText = tostring(prefix or '')
    local content = tostring(text or '')
    if prefixText ~= '' then
        return prefixText .. content
    end
    return content
end

local TabMain = Window:AddTab({ Name = 'Main', Icon = 'layout-dashboard' })
local TabCredits = Window:AddTab({ Name = 'Credits', Icon = 'users' })
local TabSettings = Window:AddTab({ Name = 'Settings', Icon = 'settings' })

local AutoEnabled = true
local OffsetMs = 0
local ReleaseAllActiveLanes = function() end
local onChildAdded
local HideMobileBtns = true
local BRPCEnabled = true
local Mode = 'normal'
local AutoLullaby = AutoLullaby or false
local LullabyChanged = LullabyChanged or false
local OriginalSpaceBind = OriginalSpaceBind or nil
local LullabyConnBG, LullabyConnPend, LullabyBeatArmed, LullabyConnKey =
    nil, nil, false, nil

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
    local detailsText = formatWithPrefix(RPCDetailsPrefix, details)
    local stateText = formatWithPrefix(RPCStatePrefix, state)
    local data = {
        details = detailsText,
        state = stateText,
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

local function LullabyTap()
    if IsOnPC and AutoLullaby then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
    end
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
    local sh =
        formatWithPrefix(RPCSidePrefix, sideVal == 'L' and 'Left' or 'Right')
    rpc(det, st, picon(), pname(), sid, sh)
end

local function hookPend(pend)
    if not pend or not pend:IsA('ImageLabel') then
        return
    end
    if LullabyConnPend then
        LullabyConnPend:Disconnect()
        LullabyConnPend = nil
    end
    LullabyBeatArmed = false
    LullabyConnPend = pend:GetPropertyChangedSignal('Rotation')
        :Connect(function()
            if not AutoLullaby then
                return
            end
            local r = tonumber(pend.Rotation) or 0
            local inWin = (r >= -10 and r <= 10)
            if inWin and not LullabyBeatArmed then
                LullabyBeatArmed = true
                LullabyTap()
            elseif not inWin and LullabyBeatArmed then
                LullabyBeatArmed = false
            end
        end)
end

local function ApplyLullabyKeybind(eng)
    if not AutoLullaby or IsOnMobile then
        return
    end

    if LullabyConnKey then
        LullabyConnKey:Disconnect()
        LullabyConnKey = nil
    end
    if LullabyConnBG then
        LullabyConnBG:Disconnect()
        LullabyConnBG = nil
    end
    if LullabyConnPend then
        LullabyConnPend:Disconnect()
        LullabyConnPend = nil
    end
    LullabyBeatArmed = false

    local current = tostring(Keybinds.Space.Value)
    if not OriginalSpaceBind then
        OriginalSpaceBind = current
    end
    if current == 'Space' then
        RE:FireServer('REMOTE_EVENT', {
            buffer.fromstring('"Input"'),
            buffer.fromstring('"ButtonA"'),
            buffer.fromstring('"Space"'),
        })
        LullabyChanged = true
    end

    LullabyConnKey = Keybinds.Space
        :GetPropertyChangedSignal('Value')
        :Connect(function()
            if not AutoLullaby then
                return
            end
            local now = tostring(Keybinds.Space.Value)
            if now == 'Space' then
                RE:FireServer('REMOTE_EVENT', {
                    buffer.fromstring('"Input"'),
                    buffer.fromstring('"ButtonA"'),
                    buffer.fromstring('"Space"'),
                })
                LullabyChanged = true
            end
        end)

    local engine = eng:FindFirstChild('Engine')
    if not engine then
        return
    end
    local bg = engine:FindFirstChild('background')
    if bg and bg:IsA('Frame') then
        local pend = bg:FindFirstChild('pendelum')
        if pend then
            hookPend(pend)
        end
    end
    LullabyConnBG = engine.ChildAdded:Connect(function(c)
        if c.Name == 'background' and c:IsA('Frame') then
            local pend = c:FindFirstChild('pendelum')
            if pend then
                hookPend(pend)
            end
            if not pend then
                c.ChildAdded:Connect(function(gc)
                    if gc.Name == 'pendelum' then
                        hookPend(gc)
                    end
                end)
            end
        end
    end)
end

local function RestoreLullabyKeybind()
    if LullabyConnKey then
        LullabyConnKey:Disconnect()
        LullabyConnKey = nil
    end
    if LullabyConnBG then
        LullabyConnBG:Disconnect()
        LullabyConnBG = nil
    end
    if LullabyConnPend then
        LullabyConnPend:Disconnect()
        LullabyConnPend = nil
    end
    LullabyBeatArmed = false
    if LullabyChanged and OriginalSpaceBind == 'Space' then
        RE:FireServer('REMOTE_EVENT', {
            buffer.fromstring('"Input"'),
            buffer.fromstring('"Space"'),
            buffer.fromstring('"Space"'),
        })
    end
    LullabyChanged = false
    OriginalSpaceBind = nil
end

local MainControls = TabMain:AddLeftGroupbox('Autoplayer')
local MiscControls = TabMain:AddRightGroupbox('Options')

local tAuto
local sSpd
local sMs
local hideMobileToggle
local modeDropdown
local brpcToggle
local cursorToggle

tAuto = MainControls:AddToggle('AutoplayerToggle', {
    Text = 'Autoplayer',
    Default = true,
    Callback = function(v)
        AutoEnabled = v
        if not v then
            pcall(ReleaseAllActiveLanes)
        end
    end,
})

if not IsOnMobile then
    local KeybindGroup = TabMain:AddLeftGroupbox('Keybinds')
    local function createKeybind(labelText, idx, defaultKey, callback)
        local label = KeybindGroup:AddLabel(labelText)
        label:AddKeyPicker(idx, {
            Text = labelText,
            Default = defaultKey,
            Mode = 'Press',
            Callback = function()
                callback()
            end,
        })
    end

    createKeybind('Autoplayer toggle', 'AutoToggleKey', 'End', function()
        tAuto:SetValue(not tAuto.Value)
    end)
    createKeybind('Reset', 'ResetKey', 'PageUp', function()
        Client.Character:BreakJoints()
    end)
    createKeybind('Instant Solo', 'SoloKey', 'PageDown', function()
        local ui = Client.PlayerGui:FindFirstChild('SingleplayerUI')
        if ui then
            ui.ButtonPressed:FireServer()
        end
    end)
end

local scrollSpeedUpdating = false
local function pushScrollSpeed(value)
    RE:FireServer('REMOTE_EVENT', {
        buffer.fromstring('"Input"'),
        buffer.fromstring(tostring(value)),
        buffer.fromstring('"ScrollSpeed"'),
    })
end

sSpd = MainControls:AddSlider('ScrollSpeed', {
    Text = 'Scroll Speed',
    Default = scrollSpeedDefault,
    Min = 0.5,
    Max = 50,
    Rounding = 1,
    Suffix = 'x',
    Callback = function(v)
        if scrollSpeedUpdating then
            return
        end
        local sv = clampScrollSpeed(v)
        pushScrollSpeed(sv)
    end,
})

MainControls:AddInput('ScrollSpeedInput', {
    Text = 'Speed override',
    Placeholder = '0.5 - 50.0',
    Finished = true,
    Numeric = true,
    ClearTextOnFocus = false,
    Callback = function(v)
        local n = clampScrollSpeed(v)
        sSpd:SetValue(n)
    end,
})

sMs = MainControls:AddSlider('HitOffset', {
    Text = 'Hit offset',
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 1,
    Suffix = 'ms',
    Callback = function(v)
        local value = math.clamp(tonumber(v) or 0, -100, 100)
        OffsetMs = value
    end,
})

MainControls:AddInput('HitOffsetInput', {
    Text = 'Offset override',
    Placeholder = '-100 - 100',
    Finished = true,
    Numeric = true,
    ClearTextOnFocus = false,
    Callback = function(v)
        local n = math.clamp(tonumber(v) or 0, -100, 100)
        sMs:SetValue(n)
        OffsetMs = n
    end,
})

if IsOnMobile then
    hideMobileToggle = MiscControls:AddToggle('HideMobileButtons', {
        Text = 'Hide Mobile Buttons',
        Default = true,
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

if not IsOnMobile then
    MiscControls:AddToggle('AutoLullaby', {
        Text = 'Auto Lullaby [WIP]',
        Default = false,
        Callback = function(v)
            AutoLullaby = v and true or false
            local eng = PlayerGui:FindFirstChild('FNFEngine')
            if eng then
                if AutoLullaby then
                    ApplyLullabyKeybind(eng)
                else
                    RestoreLullabyKeybind()
                end
            end
        end,
    })
end

MiscControls:AddButton('InstantSoloMainButton', {
    Text = 'Instant Solo',
    Func = function()
        local sp = PlayerGui:WaitForChild('SingleplayerUI', 2)
        if sp then
            sp.ButtonPressed:FireServer()
        end
    end,
})

local actorsAPI = (
    typeof(getactors) == 'function' and typeof(run_on_actor) == 'function'
)
if actorsAPI then
    modeDropdown = MiscControls:AddDropdown('AutoplayerMode', {
        Text = 'Autoplayer Mode',
        Values = { 'normal', 'actor' },
        Default = Mode,
        Callback = function(opt)
            local sel = (typeof(opt) == 'table' and opt[1]) or opt or Mode
            if sel == 'actor' or sel == 'normal' then
                Mode = sel
            end
        end,
    })
end

local creditsGroup = TabCredits:AddLeftGroupbox('Credits')

if typeof(setclipboard) == 'function' then
    creditsGroup:AddButton('FixerLink', {
        Text = 'Fixed by ltseverydayyou',
        Func = function()
            setclipboard('https://github.com/ltseverydayyou')
            notify('Copied', 'GitHub URL copied to clipboard', 3)
        end,
    })
    creditsGroup:AddButton('OriginalLink', {
        Text = 'Original by Mati278',
        Func = function()
            setclipboard('https://github.com/Mati278')
            notify('Copied', 'GitHub URL copied to clipboard', 3)
        end,
    })
else
    creditsGroup:AddLabel({
        Text = 'Fixed by ltseverydayyou\nhttps://github.com/ltseverydayyou',
        DoesWrap = true,
    })
    creditsGroup:AddLabel({
        Text = 'Original by Mati278\nhttps://github.com/Mati278',
        DoesWrap = true,
    })
end

creditsGroup:AddLabel('Anticheat bypass by ltseverydayyou')

local uiSettings = TabSettings:AddLeftGroupbox('UI Settings')
cursorToggle = uiSettings:AddToggle('ObsidianCursor', {
    Text = 'Show Obsidian cursor',
    Default = Obsidian.ShowCustomCursor ~= false,
    Callback = function(v)
        Obsidian.ShowCustomCursor = v
        if v then
            return
        end
        UserInputService.MouseIconEnabled = true
    end,
})

uiSettings:AddToggle('NotifyOnErrorToggle', {
    Text = 'Notify on callback errors',
    Default = Obsidian.NotifyOnError,
    Callback = function(v)
        Obsidian.NotifyOnError = v
    end,
})

uiSettings:AddToggle('LockDraggingToggle', {
    Text = 'Lock window dragging',
    Default = Obsidian.CantDragForced,
    Callback = function(v)
        Obsidian.CantDragForced = v
    end,
})

local currentNotifySide = Obsidian.NotifySide or 'Right'
if type(currentNotifySide) == 'string' then
    currentNotifySide = currentNotifySide:sub(1, 1):upper()
        .. currentNotifySide:sub(2):lower()
else
    currentNotifySide = 'Right'
end

uiSettings:AddDropdown('NotifySideDropdown', {
    Text = 'Notification side',
    Values = { 'Right', 'Left' },
    Default = currentNotifySide,
    Callback = function(value)
        local side = (value == 'Left') and 'Left' or 'Right'
        Obsidian:SetNotifySide(side)
    end,
})

uiSettings:AddToggle('CompactSidebarToggle', {
    Text = 'Compact sidebar layout',
    Default = Window:IsSidebarCompacted(),
    Callback = function(v)
        Window:SetCompact(v)
    end,
})

local toggleKeyLabel = uiSettings:AddLabel('UI toggle key')
local toggleKeyPicker
local function resolveKeyCode(nameOrEnum)
    if typeof(nameOrEnum) == 'EnumItem' then
        return nameOrEnum
    end
    if typeof(nameOrEnum) == 'string' then
        for _, item in Enum.KeyCode:GetEnumItems() do
            if item.Name == nameOrEnum then
                return item
            end
        end
    end
    return nil
end

local function applyUIToggleKey()
    if not toggleKeyPicker then
        return
    end
    local keyName = toggleKeyPicker.Value
    local enumValue = resolveKeyCode(keyName)
    if enumValue then
        Obsidian.ToggleKeybind = enumValue
    end
end

local toggleKeyDefault = 'RightControl'
if typeof(Obsidian.ToggleKeybind) == 'EnumItem' then
    toggleKeyDefault = Obsidian.ToggleKeybind.Name
end

toggleKeyLabel:AddKeyPicker('UIToggleKeyPicker', {
    Text = 'UI Toggle Key',
    Default = toggleKeyDefault,
    Mode = 'Toggle',
    SyncToggleState = false,
})
toggleKeyPicker = Obsidian.Options.UIToggleKeyPicker
if toggleKeyPicker then
    toggleKeyPicker:OnChanged(applyUIToggleKey)
    applyUIToggleKey()
end

local scriptGroup = TabSettings:AddRightGroupbox('Script Controls')
brpcToggle = scriptGroup:AddToggle('BloxstrapRPC', {
    Text = 'Bloxstrap RPC',
    Default = BRPCEnabled,
    Callback = function(v)
        BRPCEnabled = v
        if v then
            scan()
        end
    end,
})

scriptGroup:AddButton('ReloadScriptSettings', {
    Text = 'Reload script',
    Func = function()
        AutoEnabled = false
        pcall(ReleaseAllActiveLanes)
        connections:disconnect()
        connections:add(PlayerGui.ChildAdded, onChildAdded)
        task.spawn(onChildAdded, PlayerGui:FindFirstChild('FNFEngine'))
        AutoEnabled = true
        notify('FNB', 'Reloaded.', 4)
    end,
})

scriptGroup:AddButton('UnloadScriptSettings', {
    Text = 'Unload script',
    Func = function()
        AutoEnabled = false
        pcall(ReleaseAllActiveLanes)
        connections:disconnect()
        pcall(function()
            Obsidian:Unload()
        end)
        script:Destroy()
    end,
})

local SaveManager = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/SaveManager.lua'
    )
)()
SaveManager:SetLibrary(Obsidian)
SaveManager:SetFolder('ltseverydayyou-fnb')
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(TabSettings)
SaveManager:LoadAutoloadConfig()

local ThemeManager = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/ThemeManager.lua'
    )
)()
ThemeManager:SetLibrary(Obsidian)
ThemeManager:SetFolder('ltseverydayyou-fnb')
ThemeManager:ApplyToTab(TabSettings)

local function reqok()
    return typeof(hookmetamethod) == 'function'
        and typeof(newcclosure) == 'function'
        and typeof(getnamecallmethod) == 'function'
        and typeof(checkcaller) == 'function'
end
local function notifyMissing(t, c)
    notify(t, c, 7)
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
    if reqok() then
        local oldhmmi
        local oldhmmnc
        oldhmmi = hookmetamethod(game, '__index', function(self, m)
            if
                not checkcaller()
                and self == Client
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
                if not checkcaller() and self == Client and l == 'kick' then
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
                if
                    not checkcaller()
                    and (l == 'fireserver' or l == 'invokeserver')
                then
                    if
                        typeof(self) == 'Instance'
                        and tostring(self.Name):lower() == 'userinputasync'
                    then
                        return
                    end
                end
                return oldhmmnc(self, ...)
            end)
        )
        local real_require = require
        local patched = setmetatable({}, { __mode = 'k' })
        require = function(mod)
            local ok, obj = pcall(real_require, mod)
            if not ok then
                error(obj, 2)
            end
            if type(obj) == 'table' and not patched[obj] then
                if tostring(rawget(obj, 'Type') or '') == 'OnMiss' then
                    obj.Type = 'OnHit'
                    if type(obj.Run) == 'function' then
                        obj.Run = function() end
                    end
                end
                patched[obj] = true
            end
            return obj
        end
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
            return (b and b.Size and b.Size.Y and (b.Size.Y.Scale > 0.0))
                or false
        end

        if AutoCtx.laneDown[Holder] then
            AutoCtx.release(Holder.Name, keyCode)
            game:GetService('RunService').Heartbeat:Wait()
            AutoCtx.press(Holder.Name, keyCode)
            game:GetService('RunService').Heartbeat:Wait()
            AutoCtx.laneDown[Holder] = true
        else
            AutoCtx.press(Holder.Name, keyCode)
            AutoCtx.laneDown[Holder] = true
        end

        AutoCtx.laneCount[Holder] = (AutoCtx.laneCount[Holder] or 0) + 1

        while Arrow and Arrow.Parent and Arrow.Visible and AutoCtx.enabled do
            if not isHold(Arrow) then
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
        Session[kn] = Enum.KeyCode[Keybinds[kv].Value]
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
        local newValue = clampScrollSpeed(Input.ScrollSpeed.Value)
        scrollSpeedUpdating = true
        sSpd:SetValue(newValue)
        scrollSpeedUpdating = false
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

connections:add(PlayerGui.ChildAdded, function(o)
    if o and o.Name == 'FNFEngine' then
        task.spawn(function()
            onChildAdded(o)
        end)
        if AutoLullaby and not IsOnMobile then
            ApplyLullabyKeybind(o)
        end
    end
end)
connections:add(PlayerGui.ChildRemoved, function(o)
    if o and o.Name == 'FNFEngine' then
        task.spawn(RestoreLullabyKeybind)
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

if Keybinds.R4.Value == ';' then
    RE:FireServer('REMOTE_EVENT', {
        buffer.fromstring('"Input"'),
        buffer.fromstring('"Semicolon"'),
        buffer.fromstring('"R4"'),
    })
end