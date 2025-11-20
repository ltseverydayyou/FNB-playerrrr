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

local watchers = {
    scrollBtn = nil,
    scrollAnces = nil,
    solo = nil,
    songChild = nil,
    songVis = nil,
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
local RF = ReplicatedStorage:WaitForChild('Modules')
    :WaitForChild('Network')
    :WaitForChild('RF')

local TakeDamageRemote

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

local function clampSpeed(value)
    local n = tonumber(value) or 1
    if n < 0.5 then
        return 0.5
    end
    if n > 200 then
        return 200
    end
    return n
end

local defSpeed = clampSpeed(
    (Input and Input.ScrollSpeed and tonumber(Input.ScrollSpeed.Value)) or 1
)
local curSpeed = defSpeed

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
local regGuiListeners
local HideMobileBtns = true
local BRPCEnabled = true
local Mode = 'normal'
local AutoLullaby = AutoLullaby or false
local LullabyChanged = LullabyChanged or false
local OriginalSpaceBind = OriginalSpaceBind or nil
local LullabyConnBG, LullabyConnPend, LullabyBeatArmed, LullabyConnKey =
    nil, nil, false, nil
local LullabySpamToken = 0
local LullabySpamInterval = 0
local LullabyRebinding = false
local AntiMissEnabled = false
local imode = IsOnMobile and 'Button' or 'Key'

local function resolveKeyName(value)
    if value == nil then
        return 'Space'
    end
    if typeof(value) == 'EnumItem' then
        return value.Name
    end
    if typeof(value) == 'string' then
        return value
    end
    return tostring(value)
end

local AutoModFlags = {
    Hard = {
        Death = false,
        FadeIn = false,
        FadeOut = false,
        Pendulum = false,
        Perfect = false,
        SuddenDeath = false,
    },
    Normal = {
        GhostTapping = false,
        Mirror = false,
        Random = false,
    },
}

local ModifierList = {
    Hard = {
        'Death',
        'FadeIn',
        'FadeOut',
        'Pendulum',
        'Perfect',
        'SuddenDeath',
    },
    Normal = { 'GhostTapping', 'Mirror', 'Random' },
}

local AppliedModifierState = {}
local ModApplyDelay = 0.5
local applyModsToken = 0
local modToggleTokens = {}

local function initModState()
    for kind, names in pairs(ModifierList) do
        AppliedModifierState[kind] = AppliedModifierState[kind] or {}
        local bucket = AppliedModifierState[kind]
        for _, name in ipairs(names) do
            if bucket[name] == nil then
                bucket[name] = false
            end
        end
    end
end

initModState()

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

local function guiClick(btn)
    if btn and not btn:IsA('GuiButton') then
        btn = asClickable(btn)
    end
    if not btn then
        return
    end
    if typeof(firesignal) == 'function' then
        pcall(firesignal, btn.MouseButton1Down)
        task.wait()
        pcall(firesignal, btn.MouseButton1Click)
        pcall(firesignal, btn.Activated)
        task.wait()
        pcall(firesignal, btn.MouseButton1Up)
    else
        if btn:IsA('GuiButton') and typeof(btn.Activate) == 'function' then
            pcall(function()
                btn:Activate()
            end)
        end
    end
end

local function normModKey(str)
    if type(str) ~= 'string' then
        return ''
    end
    return (str:gsub('%s+', '')):lower()
end

local function getSpaceBind()
    if not Keybinds then
        return nil
    end
    return Keybinds:FindFirstChild('Space')
end

local function setSpaceBind(value)
    local spaceValue = getSpaceBind()
    if not spaceValue then
        return
    end
    if resolveKeyName(spaceValue.Value) == value then
        return
    end
    LullabyRebinding = true
    RE:FireServer('REMOTE_EVENT', {
        buffer.fromstring('"Input"'),
        buffer.fromstring(string.format('"%s"', tostring(value))),
        buffer.fromstring('"Space"'),
    })
    LullabyRebinding = false
end

local function asClickable(node)
    if not node then
        return nil
    end
    if node:IsA('GuiButton') then
        return node
    end
    for _, child in ipairs(node:GetDescendants()) do
        if child:IsA('GuiButton') then
            return child
        end
    end
    return nil
end

local function findModButton(container, kind, name)
    if not container then
        return nil
    end
    local targetKey = normModKey(name)
    local buckets = {
        container:FindFirstChild(kind),
        container:FindFirstChild(kind .. 'Modifiers'),
        container,
    }
    for _, bucket in ipairs(buckets) do
        if bucket then
            local direct = bucket:FindFirstChild(name)
            local clickable = asClickable(direct)
            if clickable then
                return clickable
            end
            for _, child in ipairs(bucket:GetDescendants()) do
                if normModKey(child.Name) == targetKey then
                    local btn = asClickable(child)
                    if btn then
                        return btn
                    end
                elseif child:IsA('GuiButton') then
                    local txt = tostring(child.Text or '')
                    if normModKey(txt) == targetKey then
                        return child
                    end
                end
            end
        end
    end
    return nil
end

local function getModButton(kind, name)
    local engineGui = PlayerGui:FindFirstChild('FNFEngine')
    local engine = engineGui and engineGui:FindFirstChild('Engine')
    local button =
        findModButton(engine and engine:FindFirstChild('Modifiers'), kind, name)
    if button then
        return button
    end
    local gui = PlayerGui:FindFirstChild('GameUI')
    local ss = gui and gui:FindFirstChild('SongSelect')
    local mods = ss and ss:FindFirstChild('Modifiers')
    local act = mods and mods:FindFirstChild('ActualModifiers')
    return findModButton(act, kind, name)
end

local function engineReady()
    return PlayerGui:FindFirstChild('FNFEngine') ~= nil
end

local function applyMod(kind, name, shouldEnable, force)
    local stateBucket = AppliedModifierState[kind]
    if not stateBucket then
        stateBucket = {}
        AppliedModifierState[kind] = stateBucket
    end
    if stateBucket[name] == nil then
        stateBucket[name] = false
    end
    local desired = shouldEnable and true or false
    local previous = stateBucket[name]
    local needsToggle
    if desired then
        needsToggle = force or (previous ~= true)
    else
        needsToggle = previous == true
    end
    if not needsToggle then
        return
    end
    if not engineReady() then
        return
    end
    local btn = getModButton(kind, name)
    if not btn then
        return
    end
    guiClick(btn)
    stateBucket[name] = desired
end

local function queueModApply(kind, name, shouldEnable)
    local key = string.format('%s:%s', tostring(kind), tostring(name))
    modToggleTokens[key] = (modToggleTokens[key] or 0) + 1
    local token = modToggleTokens[key]
    task.delay(ModApplyDelay, function()
        if modToggleTokens[key] ~= token then
            return
        end
        modToggleTokens[key] = nil
        applyMod(kind, name, shouldEnable, false)
    end)
end

local function applyMods(force)
    applyModsToken += 1
    local token = applyModsToken
    task.spawn(function()
        task.wait(ModApplyDelay)
        if token ~= applyModsToken then
            return
        end
        if not engineReady() then
            return
        end
        for kind, names in pairs(ModifierList) do
            local flags = AutoModFlags[kind]
            local stateBucket = AppliedModifierState[kind]
            for _, name in ipairs(names) do
                local desired = false
                if flags then
                    desired = flags[name] and true or false
                end
                if desired or (stateBucket and stateBucket[name]) then
                    applyMod(kind, name, desired, force)
                end
            end
        end
    end)
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
    local actorsAPI = (
        typeof(getactors) == 'function' and typeof(run_on_actor) == 'function'
    )
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
            AutoCtx.press(Holder.Name, keyCode)
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

local MainControls = TabMain:AddLeftGroupbox('Autoplayer')
local InputTypeGroup = TabMain:AddLeftGroupbox('Input Type')
local MiscControls = TabMain:AddRightGroupbox('Options')
local AutoModsGroup = TabMain:AddRightGroupbox('Auto Modifiers')

local tAuto
local sSpd
local sMs
local hideMobileToggle
local soloToggle
local modeDropdown
local brpcToggle
local cursorToggle
local antiMissToggle
local inputModeDropdown

local function doSolo(singleplayerUI)
    local sp = singleplayerUI or PlayerGui:FindFirstChild('SingleplayerUI')
    if not sp then
        return false
    end
    local remote = sp:FindFirstChild('ButtonPressed')
        or sp:WaitForChild('ButtonPressed', 2)
    if not remote then
        return false
    end
    remote:FireServer()
    return true
end

local function watchSolo(enabled)
    if watchers.solo then
        watchers.solo:Disconnect()
        watchers.solo = nil
    end
    if not enabled then
        return
    end
    watchers.solo = PlayerGui.ChildAdded:Connect(function(child)
        if child and child.Name == 'SingleplayerUI' then
            doSolo(child)
        end
    end)
    local existing = PlayerGui:FindFirstChild('SingleplayerUI')
    if existing then
        doSolo(existing)
    end
end

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
        doSolo()
    end)
end

local scrollSpeedUpdating = false

local function pushSpeed(value)
    RE:FireServer('REMOTE_EVENT', {
        buffer.fromstring('"Input"'),
        buffer.fromstring(tostring(value)),
        buffer.fromstring('"ScrollSpeed"'),
    })
end

local function syncSlider(value)
    local clamped = clampSpeed(value)
    curSpeed = clamped
    if not sSpd then
        return
    end
    scrollSpeedUpdating = true
    sSpd:SetValue(clamped)
    scrollSpeedUpdating = false
end

local function parseScrollSpeedText(text)
    if type(text) ~= 'string' then
        return nil
    end
    local match = string.match(text, '[-+]?%d+%.?%d*')
    if not match then
        return nil
    end
    return tonumber(match)
end

local function syncSliderWithScrollSpeedButton(button)
    if not button or scrollSpeedUpdating then
        return
    end
    local parsed = parseScrollSpeedText(button.Text)
    if not parsed then
        return
    end
    local clamped = clampSpeed(parsed)
    if math.abs(clamped - curSpeed) < 0.001 then
        return
    end
    syncSlider(clamped)
end

local function detachScrollWatcher()
    if watchers.scrollBtn then
        watchers.scrollBtn:Disconnect()
        watchers.scrollBtn = nil
    end
    if watchers.scrollAnces then
        watchers.scrollAnces:Disconnect()
        watchers.scrollAnces = nil
    end
end

local function attachScrollWatcher()
    detachScrollWatcher()
    task.spawn(function()
        local gui = PlayerGui:FindFirstChild('GameUI')
            or PlayerGui:WaitForChild('GameUI', 5)
        if not gui then
            return
        end
        local settings = gui:FindFirstChild('Settings')
            or gui:WaitForChild('Settings', 5)
        if not settings then
            return
        end
        local options = settings:FindFirstChild('Options')
            or settings:WaitForChild('Options', 5)
        if not options then
            return
        end
        local scrollNode = options:FindFirstChild('ScrollSpeed')
            or options:WaitForChild('ScrollSpeed', 5)
        if not scrollNode then
            return
        end
        local button = scrollNode:FindFirstChild('Button')
            or scrollNode:WaitForChild('Button', 5)
        if not button or not button:IsA('TextButton') then
            return
        end
        local function onTextChanged()
            syncSliderWithScrollSpeedButton(button)
        end
        watchers.scrollBtn =
            button:GetPropertyChangedSignal('Text'):Connect(onTextChanged)
        watchers.scrollAnces = button.AncestryChanged:Connect(
            function(_, parent)
                if not parent then
                    attachScrollWatcher()
                end
            end
        )
        onTextChanged()
    end)
end

local function clearSongWatch()
    if watchers.songVis then
        watchers.songVis:Disconnect()
        watchers.songVis = nil
    end
    if watchers.songChild then
        watchers.songChild:Disconnect()
        watchers.songChild = nil
    end
end

local function bindSongVis(songSelect)
    if not songSelect then
        return
    end
    if watchers.songVis then
        watchers.songVis:Disconnect()
        watchers.songVis = nil
    end
    watchers.songVis = songSelect
        :GetPropertyChangedSignal('Visible')
        :Connect(function()
            if songSelect.Visible then
                applyMods(true)
            end
        end)
    if songSelect.Visible then
        applyMods(true)
    end
end

local function watchSongSel(gameUI)
    clearSongWatch()
    if not gameUI then
        return
    end
    local function onChildAdded(child)
        if child and child.Name == 'SongSelect' then
            bindSongVis(child)
        end
    end
    watchers.songChild = gameUI.ChildAdded:Connect(onChildAdded)
    onChildAdded(gameUI:FindFirstChild('SongSelect'))
end

sSpd = MainControls:AddSlider('ScrollSpeed', {
    Text = 'Scroll Speed',
    Default = defSpeed,
    Min = 0.5,
    Max = 200,
    Rounding = 1,
    Suffix = 'x',
    Callback = function(v)
        if scrollSpeedUpdating then
            return
        end
        local sv = clampSpeed(v)
        curSpeed = sv
        pushSpeed(sv)
    end,
})

MainControls:AddInput('ScrollSpeedInput', {
    Text = 'Speed override',
    Placeholder = '0.5 - 200.0',
    Finished = true,
    Numeric = true,
    ClearTextOnFocus = false,
    Callback = function(v)
        local n = clampSpeed(v)
        sSpd:SetValue(n)
    end,
})

sMs = MainControls:AddSlider('HitOffset', {
    Text = 'Hit offset',
    Default = 0,
    Min = -500,
    Max = 500,
    Rounding = 1,
    Suffix = 'ms',
    Callback = function(v)
        local value = math.clamp(tonumber(v) or 0, -500, 500)
        OffsetMs = value
    end,
})

MainControls:AddInput('HitOffsetInput', {
    Text = 'Offset override',
    Placeholder = '-500 - 500',
    Finished = true,
    Numeric = true,
    ClearTextOnFocus = false,
    Callback = function(v)
        local n = math.clamp(tonumber(v) or 0, -500, 500)
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
        Text = 'Auto Lullaby',
        Default = false,
        Callback = function(v)
            AutoLullaby = v and true or false
            local eng = PlayerGui:FindFirstChild('FNFEngine')
            if eng then
                if AutoLullaby then
                    setupLullaby(eng)
                else
                    resetLullaby()
                end
            end
        end,
    })
end

MiscControls:AddButton('Instant Solo', {
    Text = 'Instant Solo',
    Func = function()
        local sp = PlayerGui:WaitForChild('SingleplayerUI', 2)
        if sp then
            doSolo(sp)
        end
    end,
})

soloToggle = MiscControls:AddToggle('AutoSolo', {
    Text = 'Auto Solo',
    Default = false,
    Callback = function(v)
        watchSolo(v)
    end,
})

antiMissToggle = MiscControls:AddToggle('AntiMiss', {
    Text = 'Anti Miss',
    Default = AntiMissEnabled,
    Callback = function(v)
        AntiMissEnabled = v and true or false
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

InputTypeGroup:AddLabel({
    Text = 'For mobile emulators: choose how input is sent (button press vs key press).',
    DoesWrap = true,
})

inputModeDropdown = InputTypeGroup:AddDropdown('InputMode', {
    Text = 'Input mode',
    Values = { 'Button', 'Key' },
    Default = imode,
    Callback = function(opt)
        local sel = (typeof(opt) == 'table' and opt[1]) or opt
        if sel == 'Button' or sel == 'Key' then
            imode = sel
        end
    end,
})

AutoModsGroup:AddLabel('Hard Modifiers')
AutoModsGroup:AddToggle('AM_Hard_Death', {
    Text = 'Death',
    Default = false,
    Callback = function(v)
        AutoModFlags.Hard.Death = v
        queueModApply('Hard', 'Death', v)
    end,
})
AutoModsGroup:AddToggle('AM_Hard_FadeIn', {
    Text = 'FadeIn',
    Default = false,
    Callback = function(v)
        AutoModFlags.Hard.FadeIn = v
        queueModApply('Hard', 'FadeIn', v)
    end,
})
AutoModsGroup:AddToggle('AM_Hard_FadeOut', {
    Text = 'FadeOut',
    Default = false,
    Callback = function(v)
        AutoModFlags.Hard.FadeOut = v
        queueModApply('Hard', 'FadeOut', v)
    end,
})
AutoModsGroup:AddToggle('AM_Hard_Pendulum', {
    Text = 'Pendulum',
    Default = false,
    Callback = function(v)
        AutoModFlags.Hard.Pendulum = v
        queueModApply('Hard', 'Pendulum', v)
    end,
})
AutoModsGroup:AddToggle('AM_Hard_Perfect', {
    Text = 'Perfect',
    Default = false,
    Callback = function(v)
        AutoModFlags.Hard.Perfect = v
        queueModApply('Hard', 'Perfect', v)
    end,
})
AutoModsGroup:AddToggle('AM_Hard_SuddenDeath', {
    Text = 'SuddenDeath',
    Default = false,
    Callback = function(v)
        AutoModFlags.Hard.SuddenDeath = v
        queueModApply('Hard', 'SuddenDeath', v)
    end,
})

AutoModsGroup:AddDivider()
AutoModsGroup:AddLabel('Normal Modifiers')
AutoModsGroup:AddToggle('AM_Normal_GhostTapping', {
    Text = 'GhostTapping',
    Default = false,
    Callback = function(v)
        AutoModFlags.Normal.GhostTapping = v
        queueModApply('Normal', 'GhostTapping', v)
    end,
})
AutoModsGroup:AddToggle('AM_Normal_Mirror', {
    Text = 'Mirror',
    Default = false,
    Callback = function(v)
        AutoModFlags.Normal.Mirror = v
        queueModApply('Normal', 'Mirror', v)
    end,
})
AutoModsGroup:AddToggle('AM_Normal_Random', {
    Text = 'Random',
    Default = false,
    Callback = function(v)
        AutoModFlags.Normal.Random = v
        queueModApply('Normal', 'Random', v)
    end,
})

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

scriptGroup:AddButton('Reload script', {
    Text = 'Reload script',
    Func = function()
        AutoEnabled = false
        pcall(ReleaseAllActiveLanes)
        detachScrollWatcher()
        resetLullaby()
        connections:disconnect()
        regGuiListeners()
        scan()
        AutoEnabled = true
        notify('FNB', 'Reloaded.', 4)
    end,
})

scriptGroup:AddButton('Unload script', {
    Text = 'Unload script',
    Func = function()
        AutoEnabled = false
        pcall(ReleaseAllActiveLanes)
        connections:disconnect()
        pcall(function()
            Obsidian:Unload()
        end)
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
    if imode == 'Button' and typeof(firesignal) ~= 'function' then
        miss = true
        notifyMissing('Missing requirement', 'firesignal (needed for button input mode)')
    end
    if miss then
        notifyMissing(
            'FNB Autoplayer',
            'One or more requirements are missing; functionality may be limited.'
        )
    end
end

do
    local opts = Obsidian.Options
    local opt = opts and opts.InputMode
    if opt and opt.SetValue then
        opt:SetValue(imode)
    end
end

do
    if reqok() then
        local oldIndex
        local oldNamecall

        oldIndex = hookmetamethod(game, '__index', function(self, m)
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
            return oldIndex(self, m)
        end)

        oldNamecall = hookmetamethod(
            game,
            '__namecall',
            newcclosure(function(self, ...)
                local l = (getnamecallmethod() or ''):lower()

                if not checkcaller() then
                    if self == Client and l == 'kick' then
                        return
                    end

                    if l == 'findservice' then
                        local first = ...
                        if
                            typeof(first) == 'string'
                            and first:lower() == 'virtualinputmanager'
                        then
                            return
                        end
                    end

                    if
                        typeof(self) == 'Instance'
                        and (l == 'fireserver' or l == 'invokeserver')
                    then
                        local name = tostring(self.Name)

                        if name:lower() == 'userinputasync' then
                            return
                        end

                        if self == TakeDamageRemote then
                            return
                        end

                        if
                            name == 'TakeDamage'
                            and self.Parent
                            and self.Parent.Name == 'Engine'
                        then
                            return
                        end

                        if self == RF and AntiMissEnabled then
                            local args = { ... }
                            local payload = args[2]
                            if typeof(payload) == 'table' then
                                local stateBuf = payload[1]
                                if typeof(stateBuf) == 'buffer' then
                                    local state = buffer.tostring(stateBuf)
                                    if state and state:find('Miss') then
                                        return
                                    end
                                end
                            end
                            return oldNamecall(self, table.unpack(args))
                        end
                    end
                end

                return oldNamecall(self, ...)
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
    LullabySpamToken += 1
    local function stopSpam()
        if LullabyBeatArmed then
            LullabyBeatArmed = false
            LullabySpamToken += 1
        end
    end
    local function startSpam()
        if LullabyBeatArmed then
            return
        end
        LullabyBeatArmed = true
        LullabySpamToken += 1
        local token = LullabySpamToken
        task.spawn(function()
            while
                AutoLullaby
                and LullabyBeatArmed
                and token == LullabySpamToken
            do
                local rotation = tonumber(pend.Rotation) or 0
                if rotation < -7 or rotation > 7 then
                    break
                end
                LullabyTap()
                if LullabySpamInterval and LullabySpamInterval > 0 then
                    task.wait(LullabySpamInterval)
                else
                    task.wait()
                end
            end
            if token == LullabySpamToken then
                LullabyBeatArmed = false
            end
        end)
    end
    local function evaluate()
        local r = tonumber(pend.Rotation) or 0
        if r >= -10 and r <= 10 then
            startSpam()
        else
            stopSpam()
        end
    end
    LullabyConnPend = pend:GetPropertyChangedSignal('Rotation')
        :Connect(function()
            if not AutoLullaby then
                return
            end
            evaluate()
        end)
    evaluate()
end

function setupLullaby(eng)
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
    LullabySpamToken += 1
    local spaceBind = getSpaceBind()
    local current = resolveKeyName(spaceBind and spaceBind.Value or 'Space')
    if not OriginalSpaceBind then
        OriginalSpaceBind = current
    end
    local function forceButtonABind()
        local bindObj = getSpaceBind()
        local now = resolveKeyName(bindObj and bindObj.Value or 'Space')
        if now == 'ButtonA' then
            return
        end
        RE:FireServer('REMOTE_EVENT', {
            buffer.fromstring('"Input"'),
            buffer.fromstring('"ButtonA"'),
            buffer.fromstring('"Space"'),
        })
        LullabyChanged = true
        setSpaceBind('ButtonA')
    end
    forceButtonABind()
    LullabyConnKey = spaceBind
        and spaceBind:GetPropertyChangedSignal('Value'):Connect(function()
            if not AutoLullaby or LullabyRebinding then
                return
            end
            forceButtonABind()
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

local function resetLullaby()
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
    if LullabyChanged then
        RE:FireServer('REMOTE_EVENT', {
            buffer.fromstring('"Input"'),
            buffer.fromstring('"Space"'),
            buffer.fromstring('"Space"'),
        })
    end
    if OriginalSpaceBind then
        setSpaceBind(OriginalSpaceBind)
    else
        setSpaceBind('Space')
    end
    LullabyChanged = false
    OriginalSpaceBind = nil
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
        local bindObj = Keybinds[kv]
        local bindValue = resolveKeyName((bindObj and bindObj.Value) or kv)
        local code = Enum.KeyCode[bindValue] or Enum.KeyCode.Space
        Session[kn] = code
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
        if imode == 'Button' then
            pressLaneMobile(MobileContainer, name)
            return
        end
        if Mode == 'actor' then
            if not actorKey('press', keyCode.Name) then
                VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
            end
            return
        end
        VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
    end
    local function releaseLane(name, keyCode)
        if imode == 'Button' then
            releaseLaneMobile(MobileContainer, name)
            return
        end
        if Mode == 'actor' then
            if not actorKey('release', keyCode.Name) then
                VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
            end
            return
        end
        VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
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
        local newValue = clampSpeed(Input.ScrollSpeed.Value)
        syncSlider(newValue)
    end)
    for _, Holder in pairs(IncomingNotes) do
        connections:add(Holder.ChildAdded, function(Arrow)
            if not Arrow or not Arrow.Visible then
                return
            end

            local arrowName = tostring(Arrow.Name or '')
            local isOrange = arrowName:find('_OrangeNote', 1, true) ~= nil

            if
                Arrow:FindFirstChild('HellNote')
                and Arrow.HellNote.Value
                and PoisonNotes
                and not isOrange
            then
                return
            end

            if
                not isOrange
                and IsOnHit(Arrow:FindFirstChildOfClass('ModuleScript'))
            then
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

regGuiListeners = function()
    connections:add(PlayerGui.ChildAdded, function(o)
        if o and o.Name == 'FNFEngine' then
            if AutoLullaby and not IsOnMobile then
                setupLullaby(o)
            end
            applyMods(true)
        end
        if o and o.Name == 'GameUI' then
            attachScrollWatcher()
            watchSongSel(o)
        end
    end)
    connections:add(PlayerGui.ChildAdded, function(o)
        if o and o.Name == 'FNFEngine' then
            task.spawn(function()
                onChildAdded(o)
            end)
        end
    end)
    connections:add(PlayerGui.ChildRemoved, function(o)
        if o and o.Name == 'FNFEngine' then
            task.spawn(resetLullaby)
            scan()
        end
        if o and o.Name == 'GameUI' then
            detachScrollWatcher()
            clearSongWatch()
        end
    end)

    connections:add(PlayerGui.DescendantAdded, function(o)
        if
            o.Name == 'TakeDamage'
            and o.Parent
            and o.Parent.Name == 'Engine'
        then
            TakeDamageRemote = o
        end
    end)

    local existingEngine = PlayerGui:FindFirstChild('FNFEngine')
    if existingEngine then
        if AutoLullaby and not IsOnMobile then
            setupLullaby(existingEngine)
        end
        applyMods(true)
        local engine = existingEngine:FindFirstChild('Engine')
        if engine then
            local td = engine:FindFirstChild('TakeDamage')
            if td then
                TakeDamageRemote = td
            end
        end
        task.spawn(function()
            onChildAdded(existingEngine)
        end)
    end
    local existingGameUI = PlayerGui:FindFirstChild('GameUI')
    if existingGameUI then
        attachScrollWatcher()
        watchSongSel(existingGameUI)
    end
end

regGuiListeners()
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
