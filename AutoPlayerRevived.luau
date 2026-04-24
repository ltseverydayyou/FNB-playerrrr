local __lt = (function()
	local globalEnv = (getgenv and getgenv()) or _G or {};
	local sharedEnv = rawget(_G, "shared");
	local cacheHost = type(sharedEnv) == "table" and sharedEnv or (type(globalEnv) == "table" and globalEnv or nil);
	if cacheHost then
		local cached = rawget(cacheHost, "__lt_service_resolver");
		if type(cached) == "table" then
			return cached;
		end;
	end;
	local loader = loadstring or load;
	if type(loader) ~= "function" then
		error("Service resolver loader unavailable");
	end;
	local resolver = loader(game:HttpGet("https://ltseverydayyou.github.io/ServiceResolver.luau"), "@ServiceResolver.luau");
	if type(resolver) ~= "function" then
		error("Service resolver failed to compile");
	end;
	local loaded = resolver();
	if type(loaded) ~= "table" then
		error("Service resolver failed to load");
	end;
	if cacheHost then
		cacheHost.__lt_service_resolver = loaded;
	end;
	return loaded;
end)();

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
			if type(v) == "userdata" and v.Connected then
				v:Disconnect()
			end
		end
		table.clear(self._list)
	end
}

local watchers = {
	scrollBtn = nil,
	scrollAnces = nil,
	solo = nil,
	songChild = nil,
	songVis = nil,
	lullaby = nil,
	lullabyEngine = nil
}

local spLimit = 15
local SplashIndex = math.random(1, spLimit)
local SplashText
if SplashIndex == 1 then
	SplashText = "hi guys hows doin there"
end
if SplashIndex == 2 then
	SplashText = "Did u know that that in terms of male human and female pokemon breeding..."
end
if SplashIndex == 3 then
	SplashText = "They took everything from me: my voice, my freedom, my legacy; and they replaced me with some blue haired kid"
end
if SplashIndex == 4 then
	SplashText = "amogus ඞ"
end
if SplashIndex == 5 then
	SplashText = "swish i fixed the autoplayer for u :)"
end
if SplashIndex == 6 then
	SplashText = "nah my man fq0e, kill urself instead u gigantic faggot"
end
if SplashIndex == 7 then
	SplashText = "Friday Night Funkin’: Vs. MX/Mario 85 - Game Over (ft. Kiwiquest) (+ FLP)"
end
if SplashIndex == 8 then
	SplashText = "you will to be silenced"
end
if SplashIndex == 9 then
	SplashText = "Are u winning, son?"
end
if SplashIndex == 10 then
	SplashText = "Now █████████████████-proof!"
end
if SplashIndex == 11 then
	SplashText = "Testificate: Family guy edition!"
end
if SplashIndex == 12 then
	SplashText = "The cakes aren't lies here!"
end
if SplashIndex == 13 then
	SplashText = "Made by professional shitters! :)"
end
if SplashIndex == 14 then
	SplashText = "me when no rewrite"
end
if SplashIndex == 15 then
	SplashText = "officilly bypassed lmao"
end

local Client = __lt.cs("Players", cloneref).LocalPlayer
local PlayerGui = Client.PlayerGui
local svc = {
	ui = __lt.cs("UserInputService", cloneref),
	http = __lt.cs("HttpService", cloneref),
	mps = __lt.cs("MarketplaceService", cloneref),
	rs = __lt.cs("ReplicatedStorage", cloneref),
	run = __lt.cs("RunService", cloneref),
	vim = __lt.cs("VirtualInputManager", cloneref)
}

local RE = svc.rs:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RE")
local RF = svc.rs:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RF")

local IsOnMobile = (function()
	local p = __lt.cm("UserInputService", "GetPlatform")
	if p == Enum.Platform.IOS or p == Enum.Platform.Android or p == Enum.Platform.AndroidTV or p == Enum.Platform.Chromecast or p == Enum.Platform.MetaOS then
		return true
	end
	if p == Enum.Platform.None then
		return svc.ui.TouchEnabled and not (svc.ui.KeyboardEnabled or svc.ui.MouseEnabled)
	end
	return false
end)()

local Input = Client:WaitForChild("Input")
local Keybinds = Input.Keybinds

local function loadChunk(url, label)
	if typeof(loadstring) ~= "function" then
		warn(string.format("[FNB] Skipping %s (loadstring unavailable)", tostring(label)))
		return nil
	end
	local okBody, body = pcall(function()
		return game:HttpGet(url)
	end)
	if not okBody or type(body) ~= "string" then
		warn(string.format("[FNB] Failed to download %s: %s", tostring(label), tostring(body)))
		return nil
	end
	local okCompile, chunk = pcall(loadstring, body)
	if not okCompile or type(chunk) ~= "function" then
		warn(string.format("[FNB] Failed to compile %s: %s", tostring(label), tostring(chunk)))
		return nil
	end
	local okRun, result = pcall(chunk)
	if not okRun then
		warn(string.format("[FNB] Failed to run %s: %s", tostring(label), tostring(result)))
		return nil
	end
	return result
end

local Offsets = loadChunk("https://raw.githubusercontent.com/ltseverydayyou/FNB-playerrrr/refs/heads/main/speedManager.lua", "speedManager.lua")
if type(Offsets) ~= "table" then
	Offsets = {}
end

local Keys = {
	[4] = {
		Left = "Left",
		Down = "Down",
		Up = "Up",
		Right = "Right"
	},
	[5] = {
		Left = "Left",
		Down = "Down",
		Space = "Space",
		Up = "Up",
		Right = "Right"
	},
	[6] = {
		S = "L3",
		D = "L2",
		F = "L1",
		J = "R1",
		K = "R2",
		L = "R3"
	},
	[7] = {
		S = "L3",
		D = "L2",
		F = "L1",
		Space = "Space",
		J = "R1",
		K = "R2",
		L = "R3"
	},
	[8] = {
		A = "L4",
		S = "L3",
		D = "L2",
		F = "L1",
		H = "R1",
		J = "R2",
		K = "R3",
		L = "R4"
	},
	[9] = {
		A = "L4",
		S = "L3",
		D = "L2",
		Space = "Space",
		F = "L1",
		H = "R1",
		J = "R2",
		K = "R3",
		L = "R4"
	}
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

local defSpeed = clampSpeed(Input and Input.ScrollSpeed and tonumber(Input.ScrollSpeed.Value) or 1)
local curSpeed = defSpeed

local rpcDet = ""
local RPCStatePrefix = ""
local RPCSidePrefix = "Side: "

local Obsidian = (loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua")))()
local Window = Obsidian:CreateWindow({
	Title = "FNB Autoplayer",
	Footer = string.format("Friday Night Bloxxin' Autoplayer REVIVED | %s", tostring(SplashText or "")),
	Center = true,
	AutoShow = true,
	ShowCustomCursor = not IsOnMobile,
	NotifySide = "Right"
})

local function notify(title, description, time)
	Obsidian:Notify({
		Title = tostring(title or "FNB"),
		Description = tostring(description or ""),
		Time = time or 5
	})
end

local function fmtPre(prefix, text)
	local prefixText = tostring(prefix or "")
	local content = tostring(text or "")
	if prefixText ~= "" then
		return prefixText .. content
	end
	return content
end

local TabMain = Window:AddTab({
	Name = "Main",
	Icon = "layout-dashboard"
})
local TabCredits = Window:AddTab({
	Name = "Credits",
	Icon = "users"
})
local TabSettings = Window:AddTab({
	Name = "Settings",
	Icon = "settings"
})

local st = {
	auto = true,
	off = 0,
	rel = function() end,
	onAdd = nil,
	regUi = nil,
	hideMb = true,
	brpc = true,
	mode = "normal",
	aKick = true,
	aMiss = false,
	aDead = false,
	autoDeleteLullaby = true,
	inMode = "Virtual Input",
	adHp = 1000000000,
	adHum = nil,
	adOrig = {}
}
local firesignalChecked = false
local firesignalWorks = false
local firesignalReason = "firesignal is unavailable."

local function canUseFireSignal(forceRecheck)
	if not forceRecheck and firesignalChecked then
		return firesignalWorks, firesignalReason
	end
	firesignalChecked = true
	firesignalWorks = false
	if typeof(firesignal) ~= "function" then
		firesignalReason = "firesignal is unavailable because your executor does not provide the function."
		return false, firesignalReason
	end
	local probe = Instance.new("BindableEvent")
	local fired = false
	local conn = probe.Event:Connect(function()
		fired = true
	end)
	local ok = pcall(firesignal, probe.Event)
	conn:Disconnect()
	probe:Destroy()
	firesignalWorks = ok and fired
	if firesignalWorks then
		firesignalReason = ""
	else
		firesignalReason = "firesignal exists, but it does not work in this executor."
	end
	return firesignalWorks, firesignalReason
end

local firesignalAvailable = canUseFireSignal()
local hookRequirementsAvailable = typeof(hookmetamethod) == "function" and typeof(newcclosure) == "function" and typeof(getnamecallmethod) == "function" and typeof(checkcaller) == "function"

if not firesignalAvailable then
	st.inMode = "Virtual Input"
end
if not hookRequirementsAvailable then
	st.aKick = false
	st.aMiss = false
end

local gEnv
if typeof(getrenv) == "function" then
	local ok, env = pcall(getrenv)
	if ok and type(env) == "table" then
		gEnv = env._G
	end
end

svc.run.RenderStepped:Connect(function()
	if not gEnv then
		return
	end
	pcall(function()
		local li = gEnv.LastInput
		if li then
			if st.inMode == "firesignal" and canUseFireSignal() then
				li.Value = Enum.UserInputType.Touch
			else
				li.Value = Enum.UserInputType.Keyboard
			end
		end
	end)
end)


local charKeyMap = {
	[";"] = "Semicolon",
	[":"] = "Semicolon",
	["#"] = "Semicolon",

	["'"] = "Quote",
	[","] = "Comma",
	["."] = "Period",
	["/"] = "Slash",
	["["] = "LeftBracket",
	["]"] = "RightBracket",
	["-"] = "Minus",
	["="] = "Equals",
	["`"] = "Backquote",
	["\\"] = "Backslash"
}

local function safeKeyCode(name)
	if typeof(name) ~= "string" then
		return nil
	end
	local ok, kc = pcall(function()
		return Enum.KeyCode[name]
	end)
	return ok and kc or nil
end

local function resolveKeyName(value)
	if value == nil then
		return "Space"
	end
	if typeof(value) == "EnumItem" then
		return value.Name
	end
	if typeof(value) == "string" then
		local mapped = charKeyMap[value]
		if mapped then
			return mapped
		end
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
		SuddenDeath = false
	},
	Normal = {
		GhostTapping = false,
		Mirror = false,
		Random = false
	}
}

local ModifierList = {
	Hard = {
		"Death",
		"FadeIn",
		"FadeOut",
		"Pendulum",
		"Perfect",
		"SuddenDeath"
	},
	Normal = {
		"GhostTapping",
		"Mirror",
		"Random"
	}
}

local modState = {}
local ModApplyDelay = 0.5
local applyModsTok = 0
local modTok = {}

local function initModState()
	for kind, names in pairs(ModifierList) do
		modState[kind] = modState[kind] or {}
		local bucket = modState[kind]
		for _, name in ipairs(names) do
			if bucket[name] == nil then
				bucket[name] = false
			end
		end
	end
end

initModState()

local function pname()
	local ok, info = pcall(svc.mps.GetProductInfo, svc.mps, game.PlaceId)
	return ok and info and info.Name or __lt.cm("MarketplaceService", "GetProductInfo", game.PlaceId).Name
end

local function picon()
	local ok, info = pcall(svc.mps.GetProductInfo, svc.mps, game.PlaceId)
	if ok and info and info.IconImageAssetId and info.IconImageAssetId ~= 0 then
		return info.IconImageAssetId
	end
	return nil
end

local function rpc(details, state, largeId, largeHover, smallId, smallHover)
	if not st.brpc then
		return
	end
	local detailsText = fmtPre(rpcDet, details)
	local stateText = fmtPre(RPCStatePrefix, state)
	local data = {
		details = detailsText,
		state = stateText,
		largeImage = largeId and {
			assetId = tonumber(largeId),
			hoverText = tostring(largeHover or "")
		} or nil
	}
	if smallId ~= nil then
		data.smallImage = {
			assetId = tonumber(smallId) or 0,
			hoverText = tostring(smallHover or "")
		}
	end
	print("[BloxstrapRPC] " .. svc.http:JSONEncode({
		command = "SetRichPresence",
		data = data
	}))
end

local function lobbyRPC()
	rpc(pname(), "Lobby", picon(), pname(), nil, nil)
end

local function parseCredit(txt)
	local t = txt or ""
	local ln1 = t:match("^[^\n]+") or ""
	ln1 = ln1:gsub("%s%(%d+%.?%d*x%)", "")
	local rest = t:gsub("^[^\n]*\n?", "")
	rest = rest:gsub("\n?%d+:%d%d%s*$", "")
	rest = (rest:gsub("^%s+", "")):gsub("%s+$", "")
	return ln1, rest
end

local function scan()
	local eng = PlayerGui:FindFirstChild("FNFEngine")
	if not eng then
		lobbyRPC()
		return
	end
	local engine = eng:FindFirstChild("Engine")
	local lower = engine and engine:FindFirstChild("LowerContainer")
	local credit = lower and lower:FindFirstChild("Credit")
	local det, st = "", ""
	if credit and credit:IsA("TextLabel") then
		det, st = parseCredit(credit.Text)
	end
	local sid
	local mods = engine and engine:FindFirstChild("Modifiers")
	local ghost = mods and mods:FindFirstChild("GhostTapping")
	if ghost and ghost:IsA("ImageButton") and type(ghost.Image) == "string" then
		local d = ghost.Image:match("%d+")
		sid = d and tonumber(d) or nil
	end
	local sideVal = engine and engine:FindFirstChild("PlayerSide") and engine.PlayerSide.Value or "L"
	local sh = fmtPre(RPCSidePrefix, sideVal == "L" and "Left" or "Right")
	rpc(det, st, picon(), pname(), sid, sh)
end

local function guiClick(btn)
	if btn and not btn:IsA("GuiButton") then
		btn = (function(node)
			if not node then
				return nil
			end
			if node:IsA("GuiButton") then
				return node
			end
			for _, child in ipairs(node:QueryDescendants("Instance")) do
				if child:IsA("GuiButton") then
					return child
				end
			end
			return nil
		end)(btn)
	end
	if not btn then
		return
	end
	if canUseFireSignal() then
		pcall(firesignal, btn.MouseButton1Down)
		task.wait()
		pcall(firesignal, btn.MouseButton1Click)
		pcall(firesignal, btn.Activated)
		task.wait()
		pcall(firesignal, btn.MouseButton1Up)
	elseif btn:IsA("GuiButton") and typeof(btn.Activate) == "function" then
		pcall(function()
			btn:Activate()
		end)
	end
end

local function normModKey(str)
	if type(str) ~= "string" then
		return ""
	end
	return (str:gsub("%s+", "")):lower()
end

local function asClickable(node)
	if not node then
		return nil
	end
	if node:IsA("GuiButton") then
		return node
	end
	for _, child in ipairs(node:QueryDescendants("Instance")) do
		if child:IsA("GuiButton") then
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
		container:FindFirstChild(kind .. "Modifiers"),
		container
	}
	for _, bucket in ipairs(buckets) do
		if bucket then
			local direct = bucket:FindFirstChild(name)
			local clickable = asClickable(direct)
			if clickable then
				return clickable
			end
			for _, child in ipairs(bucket:QueryDescendants("Instance")) do
				if normModKey(child.Name) == targetKey then
					local btn = asClickable(child)
					if btn then
						return btn
					end
				elseif child:IsA("GuiButton") then
					local txt = tostring(child.Text or "")
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
	local engineGui = PlayerGui:FindFirstChild("FNFEngine")
	local engine = engineGui and engineGui:FindFirstChild("Engine")
	local button = findModButton(engine and engine:FindFirstChild("Modifiers"), kind, name)
	if button then
		return button
	end
	local gui = PlayerGui:FindFirstChild("GameUI")
	local ss = gui and gui:FindFirstChild("SongSelect")
	local mods = ss and ss:FindFirstChild("Modifiers")
	local act = mods and mods:FindFirstChild("ActualModifiers")
	return findModButton(act, kind, name)
end

local function engineReady()
	return PlayerGui:FindFirstChild("FNFEngine") ~= nil
end

local function applyMod(kind, name, shouldEnable, force)
	local stateBucket = modState[kind]
	if not stateBucket then
		stateBucket = {}
		modState[kind] = stateBucket
	end
	if stateBucket[name] == nil then
		stateBucket[name] = false
	end
	local desired = shouldEnable and true or false
	local previous = stateBucket[name]
	local needsToggle
	if desired then
		needsToggle = force or previous ~= true
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
	local key = string.format("%s:%s", tostring(kind), tostring(name))
	modTok[key] = (modTok[key] or 0) + 1
	local token = modTok[key]
	task.delay(ModApplyDelay, function()
		if modTok[key] ~= token then
			return
		end
		modTok[key] = nil
		applyMod(kind, name, shouldEnable, false)
	end)
end

local function applyMods(force)
	applyModsTok += 1
	local token = applyModsTok
	task.spawn(function()
		task.wait(ModApplyDelay)
		if token ~= applyModsTok then
			return
		end
		if not engineReady() then
			return
		end
		for kind, names in pairs(ModifierList) do
			local flags = AutoModFlags[kind]
			local stateBucket = modState[kind]
			for _, name in ipairs(names) do
				local desired = false
				if flags then
					desired = flags[name] and true or false
				end
				if desired or stateBucket and stateBucket[name] then
					applyMod(kind, name, desired, force)
				end
			end
		end
	end)
end

local function calcOff(scrollSpeed)
	local key = string.format("%.1f", tonumber(scrollSpeed) or 1)
	local ms = Offsets[key]
	if ms == nil then
		local fallback = Offsets["10.0"] or 0
		ms = fallback
	end
	return ms / 1000 + 0.4
end

local function pressMob(container, name)
	if not canUseFireSignal() then
		return
	end
	if not container then
		return
	end
	local b = container:FindFirstChild(name)
	if not b and name == "Space" then
		b = container:FindFirstChild("SPACE") or container:FindFirstChild("space")
	end
	if b then
		pcall(firesignal, b.MouseButton1Down)
	end
end

local function relMob(container, name)
	if not canUseFireSignal() then
		return
	end
	if not container then
		return
	end
	local b = container:FindFirstChild(name)
	if not b and name == "Space" then
		b = container:FindFirstChild("SPACE") or container:FindFirstChild("space")
	end
	if b then
		pcall(firesignal, b.MouseButton1Up)
	end
end

local function actorKey(op, keyCode)
	if st.mode ~= "actor" then
		return false
	end
	if not keyCode or typeof(keyCode) ~= "EnumItem" then
		return false
	end

	local actorsAPI = typeof(getactors) == "function" and typeof(run_on_actor) == "function"
	if not actorsAPI then
		return false
	end

	local okA, actors = pcall(getactors)
	if not okA or type(actors) ~= "table" or not actors[1] then
		return false
	end

	local down = op == "press"
	local src = string.format([[
		local vim
		local isDown = %s
		local kc = Enum.KeyCode[%q]
		local cref = type(cloneref) == "function" and cloneref or nil
		local live = __lt.gs("VirtualInputManager")
		local ok, svc = cref and pcall(function()
			return __lt.cs("VirtualInputManager", cref)
		end)
		if ok and svc then
			vim = setmetatable({}, {
				__index = function(_, key)
					local current = __lt.gs("VirtualInputManager")
					local value = current[key]
					if type(value) == "function" then
						return function(_, ...)
							return value(current, ...)
						end
					end
					if cref and typeof(value) == "Instance" then
						local ok2, cloned = pcall(cref, value)
						if ok2 and cloned ~= nil then
							return cloned
						end
					end
					return value
				end,
				__newindex = function(_, key, value)
					__lt.gs("VirtualInputManager")[key] = value
				end
			})
		else
			vim = live
		end
		if vim then
			vim:SendKeyEvent(isDown, kc, false, nil)
		end
	]], down and "true" or "false", keyCode.Name)

	pcall(run_on_actor, actors[1], src)
	return true
end

local function playSeq(Holder, Arrow, keyCode, AutoCtx)
	task.spawn(function()
		local baseOffset = AutoCtx.baseOffset
		task.wait(baseOffset + AutoCtx.offsetMs / 1000)
		if not AutoCtx.enabled then
			return
		end
		if not Arrow or not Arrow.Parent or not Arrow.Visible then
			return
		end
		local function isHold(a)
			local f = a:FindFirstChild("Frame")
			local b = f and f:FindFirstChild("Bar")
			return b and b.Size and b.Size.Y and b.Size.Y.Scale > 0 or false
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

local function killLullabyChild(child)
	if not st.autoDeleteLullaby or not child then
		return
	end
	if child.Name == "background" and child:IsA("Frame") then
		child:Destroy()
	elseif child.Name == "static" and child:IsA("Sound") then
		child:Destroy()
	end
end

local function syncLullabyPurge(engine)
	if watchers.lullaby then
		watchers.lullaby:Disconnect()
		watchers.lullaby = nil
	end
	watchers.lullabyEngine = engine
	if not engine or not st.autoDeleteLullaby then
		return
	end
	task.spawn(function()
		task.wait(5)
		if watchers.lullabyEngine ~= engine or not st.autoDeleteLullaby or not engine.Parent then
			return
		end
		killLullabyChild(engine:FindFirstChild("background"))
		for _, child in ipairs(engine:GetChildren()) do
			killLullabyChild(child)
		end
	end)
	watchers.lullaby = engine.ChildAdded:Connect(function(child)
		task.defer(function()
			if watchers.lullabyEngine ~= engine then
				return
			end
			killLullabyChild(child)
		end)
	end)
end

local MainControls = TabMain:AddLeftGroupbox("Autoplayer")
local MiscControls = TabMain:AddRightGroupbox("Options")
local AutoModsGroup = firesignalAvailable and TabMain:AddRightGroupbox("Auto Modifiers") or nil

local tAuto
local sSpd
local sMs
local hideMobTg
local soloToggle
local modeDropdown
local brpcToggle
local cursorToggle
local antiMissToggle
local deadTg
local inModeDrop

local function setInputMode(opt)
	local sel = typeof(opt) == "table" and opt[1] or opt or "Virtual Input"
	local wasMode = st.inMode
	local canFireSignal, fireSignalIssue = canUseFireSignal(sel == "firesignal")
	if sel == "firesignal" and not canFireSignal then
		notify("firesignal unavailable", string.format("A working firesignal is required for firesignal mode; using Virtual Input instead.\nReason: %s", fireSignalIssue), 6)
		st.inMode = "Virtual Input"
		if inModeDrop then
			inModeDrop:SetValue("Virtual Input")
		end
		return
	end
	st.inMode = sel
	if sel == "firesignal" then
		if wasMode ~= "firesignal" then
			notify("firesignal warning", "firesignal spoofs Touch/Mobile input to work. FNB does not support lullaby on mobile, so it will not add or use lullaby there.", 8)
		end
	end
end

local function doSolo(singleplayerUI)
	local sp = singleplayerUI or PlayerGui:FindFirstChild("SingleplayerUI")
	if not sp then
		return false
	end
	local remote = sp:FindFirstChild("ButtonPressed") or sp:WaitForChild("ButtonPressed", 2)
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
		task.defer(function()
			if child and child.Name == "SingleplayerUI" then
				doSolo(child)
			end
		end)
	end)
	local existing = PlayerGui:FindFirstChild("SingleplayerUI")
	if existing then
		task.defer(function()
			doSolo(existing)
		end)
	end
end

local function getHum()
	local character = Client.Character
	if not character then
		return nil
	end
	return character:FindFirstChildOfClass("Humanoid")
end

local function snapAdHum(humanoid)
	if not humanoid or not humanoid:IsA("Humanoid") then
		return nil
	end
	local state = st.adOrig[humanoid]
	if state then
		return state
	end
	local okBreak, breakJointsOnDeath = pcall(function()
		return humanoid.BreakJointsOnDeath
	end)
	state = {
		maxHealth = humanoid.MaxHealth,
		breakJointsOnDeath = okBreak and breakJointsOnDeath or nil
	}
	st.adOrig[humanoid] = state
	return state
end

local function applyAd(humanoid)
	if not st.aDead or not humanoid or not humanoid:IsA("Humanoid") or humanoid.Parent == nil then
		return
	end
	st.adHum = humanoid
	snapAdHum(humanoid)
	if humanoid.MaxHealth < st.adHp then
		pcall(function()
			humanoid.MaxHealth = st.adHp
		end)
	end
	if humanoid.Health < humanoid.MaxHealth then
		pcall(function()
			humanoid.Health = humanoid.MaxHealth
		end)
	end
	pcall(function()
		if humanoid.BreakJointsOnDeath ~= false then
			humanoid.BreakJointsOnDeath = false
		end
	end)
	pcall(function()
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	end)
	pcall(function()
		if humanoid:GetState() == Enum.HumanoidStateType.Dead then
			humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
	end)
end

local function restAd(humanoid)
	if not humanoid or not humanoid:IsA("Humanoid") then
		return
	end
	local state = st.adOrig[humanoid]
	if state then
		pcall(function()
			humanoid.MaxHealth = state.maxHealth or 100
		end)
		pcall(function()
			if humanoid.Health > humanoid.MaxHealth then
				humanoid.Health = humanoid.MaxHealth
			end
		end)
		if state.breakJointsOnDeath ~= nil then
			pcall(function()
				humanoid.BreakJointsOnDeath = state.breakJointsOnDeath
			end)
		end
		st.adOrig[humanoid] = nil
	end
	pcall(function()
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
	end)
	if st.adHum == humanoid then
		st.adHum = nil
	end
end

local function killTd(remote)
	if not remote or remote.Parent == nil or remote.Name ~= "TakeDamage" then
		return
	end
	pcall(function()
		remote:Destroy()
	end)
end

local function setAd(enabled)
	st.aDead = enabled and true or false
	if st.aDead then
		applyAd(getHum())
		return
	end
	local restoreList = {}
	for humanoid in pairs(st.adOrig) do
		restoreList[#restoreList + 1] = humanoid
	end
	for _, humanoid in ipairs(restoreList) do
		restAd(humanoid)
	end
end

tAuto = MainControls:AddToggle("AutoplayerToggle", {
	Text = "Autoplayer",
	Default = true,
	Callback = function(v)
		st.auto = v
		if not v then
			pcall(st.rel)
		end
	end
})

if not IsOnMobile then
	local KeybindGroup = TabMain:AddLeftGroupbox("Keybinds")
	local function createKeybind(labelText, idx, defaultKey, callback)
		local label = KeybindGroup:AddLabel(labelText)
		label:AddKeyPicker(idx, {
			Text = labelText,
			Default = defaultKey,
			Mode = "Press",
			Callback = function()
				callback()
			end
		})
	end
	createKeybind("Autoplayer toggle", "AutoToggleKey", "End", function()
		tAuto:SetValue(not tAuto.Value)
	end)
	createKeybind("Reset", "ResetKey", "PageUp", function()
		Client.Character:BreakJoints()
	end)
	createKeybind("Instant Solo", "SoloKey", "PageDown", function()
		doSolo()
	end)
end

local spdSync = false

local function pushSpeed(value)
	RE:FireServer("REMOTE_EVENT", {
		buffer.fromstring("\"Input\""),
		buffer.fromstring(tostring(value)),
		buffer.fromstring("\"ScrollSpeed\"")
	})
end

local function syncSlider(value)
	local clamped = clampSpeed(value)
	curSpeed = clamped
	if not sSpd then
		return
	end
	spdSync = true
	sSpd:SetValue(clamped)
	spdSync = false
end

local function parseSpd(text)
	if type(text) ~= "string" then
		return nil
	end
	local match = string.match(text, "[-+]?%d+%.?%d*")
	if not match then
		return nil
	end
	return tonumber(match)
end

local function syncBtn(button)
	if not button or spdSync then
		return
	end
	local parsed = parseSpd(button.Text)
	if not parsed then
		return
	end
	local clamped = clampSpeed(parsed)
	if math.abs(clamped - curSpeed) < 0.001 then
		return
	end
	syncSlider(clamped)
end

local function dropSw()
	if watchers.scrollBtn then
		watchers.scrollBtn:Disconnect()
		watchers.scrollBtn = nil
	end
	if watchers.scrollAnces then
		watchers.scrollAnces:Disconnect()
		watchers.scrollAnces = nil
	end
end

local function bindSw()
	dropSw()
	task.spawn(function()
		local gui = PlayerGui:FindFirstChild("GameUI") or PlayerGui:WaitForChild("GameUI", 5)
		if not gui then
			return
		end
		local settings = gui:FindFirstChild("Settings") or gui:WaitForChild("Settings", 5)
		if not settings then
			return
		end
		local options = settings:FindFirstChild("Options") or settings:WaitForChild("Options", 5)
		if not options then
			return
		end
		local scrollNode = options:FindFirstChild("ScrollSpeed") or options:WaitForChild("ScrollSpeed", 5)
		if not scrollNode then
			return
		end
		local button = scrollNode:FindFirstChild("Button") or scrollNode:WaitForChild("Button", 5)
		if not button or not button:IsA("TextButton") then
			return
		end
		local function onTextChanged()
			syncBtn(button)
		end
		watchers.scrollBtn = button:GetPropertyChangedSignal("Text"):Connect(onTextChanged)
		watchers.scrollAnces = button.AncestryChanged:Connect(function(_, parent)
			if not parent then
				bindSw()
			end
		end)
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
	watchers.songVis = songSelect:GetPropertyChangedSignal("Visible"):Connect(function()
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
	local function onSong(child)
		task.defer(function()
			if child and child.Name == "SongSelect" then
				bindSongVis(child)
			end
		end)
	end
	watchers.songChild = gameUI.ChildAdded:Connect(onSong)
	onSong(gameUI:FindFirstChild("SongSelect"))
end

sSpd = MainControls:AddSlider("ScrollSpeed", {
	Text = "Scroll Speed",
	Default = defSpeed,
	Min = 0.5,
	Max = 200,
	Rounding = 1,
	Suffix = "x",
	Callback = function(v)
		if spdSync then
			return
		end
		local sv = clampSpeed(v)
		curSpeed = sv
		pushSpeed(sv)
	end
})

MainControls:AddInput("ScrollSpeedInput", {
	Text = "Speed override",
	Placeholder = "0.5 - 200.0",
	Finished = true,
	Numeric = true,
	ClearTextOnFocus = false,
	Callback = function(v)
		local n = clampSpeed(v)
		sSpd:SetValue(n)
	end
})

sMs = MainControls:AddSlider("HitOffset", {
	Text = "Hit offset",
	Default = 0,
	Min = -500,
	Max = 500,
	Rounding = 1,
	Suffix = "ms",
	Callback = function(v)
		local value = math.clamp(tonumber(v) or 0, -500, 500)
		st.off = value
	end
})

MainControls:AddInput("HitOffsetInput", {
	Text = "Offset override",
	Placeholder = "-500 - 500",
	Finished = true,
	Numeric = true,
	ClearTextOnFocus = false,
	Callback = function(v)
		local n = math.clamp(tonumber(v) or 0, -500, 500)
		sMs:SetValue(n)
		st.off = n
	end
})

if firesignalAvailable then
	inModeDrop = MainControls:AddDropdown("InputMode", {
		Text = "Input method",
		Values = {
			"Virtual Input",
			"firesignal"
		},
		Default = st.inMode,
		Callback = setInputMode
	})

	MainControls:AddLabel("firesignal mode spoofs Touch\ninput")
	MainControls:AddLabel("FNB doesn't support lullaby on\nmobile")
	MainControls:AddLabel("so it will not add or use lullaby")
	MainControls:AddLabel("if firesignal doesn't work")
	MainControls:AddLabel("switch to Virtual Input")

	hideMobTg = MiscControls:AddToggle("HideMobileButtons", {
		Text = "Hide Mobile Buttons",
		Default = true,
		Callback = function(v)
			st.hideMb = v
			local eng = PlayerGui:FindFirstChild("FNFEngine")
			if not eng then
				return
			end
			local mb = eng.Engine:FindFirstChild("MobileButtons")
			local cont = mb and mb:FindFirstChild("Container")
			if cont then
				cont.Visible = not v
			end
		end
	})
end

MiscControls:AddButton("Instant Solo", {
	Text = "Instant Solo",
	Func = function()
		local sp = PlayerGui:WaitForChild("SingleplayerUI", 2)
		if sp then
			doSolo(sp)
		end
	end
})

soloToggle = MiscControls:AddToggle("AutoSolo", {
	Text = "Auto Solo",
	Default = false,
	Callback = function(v)
		watchSolo(v)
	end
})

MiscControls:AddToggle("AutoDeleteLullaby", {
	Text = "Auto Delete Lullaby",
	Default = st.autoDeleteLullaby,
	Callback = function(v)
		st.autoDeleteLullaby = v and true or false
		local existingEngine = PlayerGui:FindFirstChild("FNFEngine")
		syncLullabyPurge(existingEngine and existingEngine:FindFirstChild("Engine") or nil)
	end
})

if hookRequirementsAvailable then
	antiMissToggle = MiscControls:AddToggle("AntiMiss", {
		Text = "Anti Miss",
		Default = st.aMiss,
		Callback = function(v)
			st.aMiss = v and true or false
		end
	})
end

deadTg = MiscControls:AddToggle("AntiDeath", {
	Text = "Anti Death",
	Default = st.aDead,
	Callback = function(v)
		setAd(v)
	end
})

local actorsAPI = typeof(getactors) == "function" and typeof(run_on_actor) == "function"
if actorsAPI then
	modeDropdown = MiscControls:AddDropdown("AutoplayerMode", {
		Text = "Autoplayer Mode",
		Values = {
			"normal",
			"actor"
		},
		Default = st.mode,
		Callback = function(opt)
			local sel = typeof(opt) == "table" and opt[1] or opt or st.mode
			if sel == "actor" or sel == "normal" then
				st.mode = sel
			end
		end
	})
end

if AutoModsGroup then
	AutoModsGroup:AddLabel("Hard Modifiers")

	AutoModsGroup:AddToggle("AM_Hard_Death", {
		Text = "Death",
		Default = false,
		Callback = function(v)
			AutoModFlags.Hard.Death = v
			queueModApply("Hard", "Death", v)
		end
	})

	AutoModsGroup:AddToggle("AM_Hard_FadeIn", {
		Text = "FadeIn",
		Default = false,
		Callback = function(v)
			AutoModFlags.Hard.FadeIn = v
			queueModApply("Hard", "FadeIn", v)
		end
	})

	AutoModsGroup:AddToggle("AM_Hard_FadeOut", {
		Text = "FadeOut",
		Default = false,
		Callback = function(v)
			AutoModFlags.Hard.FadeOut = v
			queueModApply("Hard", "FadeOut", v)
		end
	})

	AutoModsGroup:AddToggle("AM_Hard_Pendulum", {
		Text = "Pendulum",
		Default = false,
		Callback = function(v)
			AutoModFlags.Hard.Pendulum = v
			queueModApply("Hard", "Pendulum", v)
		end
	})

	AutoModsGroup:AddToggle("AM_Hard_Perfect", {
		Text = "Perfect",
		Default = false,
		Callback = function(v)
			AutoModFlags.Hard.Perfect = v
			queueModApply("Hard", "Perfect", v)
		end
	})

	AutoModsGroup:AddToggle("AM_Hard_SuddenDeath", {
		Text = "SuddenDeath",
		Default = false,
		Callback = function(v)
			AutoModFlags.Hard.SuddenDeath = v
			queueModApply("Hard", "SuddenDeath", v)
		end
	})

	AutoModsGroup:AddDivider()

	AutoModsGroup:AddLabel("Normal Modifiers")

	AutoModsGroup:AddToggle("AM_Normal_GhostTapping", {
		Text = "GhostTapping",
		Default = false,
		Callback = function(v)
			AutoModFlags.Normal.GhostTapping = v
			queueModApply("Normal", "GhostTapping", v)
		end
	})

	AutoModsGroup:AddToggle("AM_Normal_Mirror", {
		Text = "Mirror",
		Default = false,
		Callback = function(v)
			AutoModFlags.Normal.Mirror = v
			queueModApply("Normal", "Mirror", v)
		end
	})

	AutoModsGroup:AddToggle("AM_Normal_Random", {
		Text = "Random",
		Default = false,
		Callback = function(v)
			AutoModFlags.Normal.Random = v
			queueModApply("Normal", "Random", v)
		end
	})
end

local creditsGroup = TabCredits:AddLeftGroupbox("Credits")

if typeof(setclipboard) == "function" then
	creditsGroup:AddButton("FixerLink", {
		Text = "Fixed by ltseverydayyou",
		Func = function()
			setclipboard("https://github.com/ltseverydayyou")
			notify("Copied", "GitHub URL copied to clipboard", 3)
		end
	})
	creditsGroup:AddButton("OriginalLink", {
		Text = "Original by Mati278",
		Func = function()
			setclipboard("https://github.com/Mati278")
			notify("Copied", "GitHub URL copied to clipboard", 3)
		end
	})
else
	creditsGroup:AddLabel({
		Text = "Fixed by ltseverydayyou\nhttps://github.com/ltseverydayyou",
		DoesWrap = true
	})
	creditsGroup:AddLabel({
		Text = "Original by Mati278\nhttps://github.com/Mati278",
		DoesWrap = true
	})
end

creditsGroup:AddLabel("AC bypass by ltseverydayyou")

local uiSettings = TabSettings:AddLeftGroupbox("UI Settings")

cursorToggle = uiSettings:AddToggle("ObsidianCursor", {
	Text = "Show Obsidian cursor",
	Default = Obsidian.ShowCustomCursor ~= false,
	Callback = function(v)
		Obsidian.ShowCustomCursor = v
		if v then
			return
		end
		svc.ui.MouseIconEnabled = true
	end
})

uiSettings:AddToggle("NotifyOnErrorToggle", {
	Text = "Notify on callback errors",
	Default = Obsidian.NotifyOnError,
	Callback = function(v)
		Obsidian.NotifyOnError = v
	end
})

uiSettings:AddToggle("LockDraggingToggle", {
	Text = "Lock window dragging",
	Default = Obsidian.CantDragForced,
	Callback = function(v)
		Obsidian.CantDragForced = v
	end
})

local noteSide = Obsidian.NotifySide or "Right"
if type(noteSide) == "string" then
	noteSide = noteSide:sub(1, 1):upper() .. noteSide:sub(2):lower()
else
	noteSide = "Right"
end

uiSettings:AddDropdown("NotifySideDropdown", {
	Text = "Notification side",
	Values = {
		"Right",
		"Left"
	},
	Default = noteSide,
	Callback = function(value)
		local side = value == "Left" and "Left" or "Right"
		Obsidian:SetNotifySide(side)
	end
})

uiSettings:AddToggle("CompactSidebarToggle", {
	Text = "Compact sidebar layout",
	Default = Window:IsSidebarCompacted(),
	Callback = function(v)
		Window:SetCompact(v)
	end
})

local toggleKeyLabel = uiSettings:AddLabel("UI toggle key")
local keyPick

local function resolveKeyCode(nameOrEnum)
	if typeof(nameOrEnum) == "EnumItem" then
		return nameOrEnum
	end
	if typeof(nameOrEnum) == "string" then
		for _, item in Enum.KeyCode:GetEnumItems() do
			if item.Name == nameOrEnum then
				return item
			end
		end
	end
	return nil
end

local function applyUiKey()
	if not keyPick then
		return
	end
	local keyName = keyPick.Value
	local enumValue = resolveKeyCode(keyName)
	if enumValue then
		Obsidian.ToggleKeybind = enumValue
	end
end

local keyDef = "RightControl"
if typeof(Obsidian.ToggleKeybind) == "EnumItem" then
	keyDef = Obsidian.ToggleKeybind.Name
end

toggleKeyLabel:AddKeyPicker("UIToggleKeyPicker", {
	Text = "UI Toggle Key",
	Default = keyDef,
	Mode = "Toggle",
	SyncToggleState = false
})

keyPick = Obsidian.Options.UIToggleKeyPicker
if keyPick then
	keyPick:OnChanged(applyUiKey)
	applyUiKey()
end

local scriptGroup = TabSettings:AddRightGroupbox("Script Controls")

if hookRequirementsAvailable then
	scriptGroup:AddToggle("AntiKick", {
		Text = "Anti Kick",
		Default = st.aKick,
		Callback = function(v)
			st.aKick = v and true or false
		end
	})
end

brpcToggle = scriptGroup:AddToggle("BloxstrapRPC", {
	Text = "Bloxstrap RPC",
	Default = st.brpc,
	Callback = function(v)
		st.brpc = v
		if v then
			scan()
		end
	end
})

scriptGroup:AddButton("Reload script", {
	Text = "Reload script",
	Func = function()
		st.auto = false
		pcall(st.rel)
		dropSw()
		connections:disconnect()
		st.regUi()
		scan()
		st.auto = true
		notify("FNB", "Reloaded.", 4)
	end
})

scriptGroup:AddButton("Unload script", {
	Text = "Unload script",
	Func = function()
		st.auto = false
		pcall(st.rel)
		connections:disconnect()
		pcall(function()
			Obsidian:Unload()
		end)
	end
})

local SaveManager = (loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/SaveManager.lua")))()
SaveManager:SetLibrary(Obsidian)
SaveManager:SetFolder("ltseverydayyou-fnb")
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(TabSettings)
SaveManager:LoadAutoloadConfig()

local ThemeManager = (loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/ThemeManager.lua")))()
ThemeManager:SetLibrary(Obsidian)
ThemeManager:SetFolder("ltseverydayyou-fnb")
ThemeManager:ApplyToTab(TabSettings)

local function reqok()
	return typeof(hookmetamethod) == "function" and typeof(newcclosure) == "function" and typeof(getnamecallmethod) == "function" and typeof(checkcaller) == "function"
end

local function notifyMissing(t, c)
	notify(t, c, 7)
end

do
	local miss = false
	if not reqok() then
		miss = true
		notifyMissing("Missing requirement", "hookmetamethod/newcclosure/getnamecallmethod/checkcaller")
	end
	if miss then
		notifyMissing("FNB Autoplayer", "One or more requirements are missing; functionality may be limited.")
	end
end

do
	if reqok() then
		-- local oldIndex
		local oldNamecall
		-- oldIndex = hookmetamethod(game, "__index", function(self, m)
		-- 	if not checkcaller() and self == Client and typeof(m) == "string" and m:lower() == "kick" then
		-- 		return error("Expected ':' not '.' calling member function Kick", 2)
		-- 	end
		-- 	return oldIndex(self, m)
		-- end)
		oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
			local l = (getnamecallmethod() or ""):lower()
			if not checkcaller() then
				if st.aKick and self == Client and l == "kick" then
					return
				end
				-- if l == "findservice" then
				-- 	local first = ...
				-- 	if typeof(first) == "string" and first:lower() == "virtualinputmanager" then
				-- 		return
				-- 	end
				-- end
				if typeof(self) == "Instance" and (l == "fireserver" or l == "invokeserver") then
					local name = tostring(self.Name)
					-- if name:lower() == "userinputasync" then
					-- 	return
					-- end
					-- if self == TakeDamageRemote then
					-- 	return
					-- end
					-- if name == "TakeDamage" and self.Parent and self.Parent.Name == "Engine" then
					-- 	return
					-- end
					if self == RF and st.aMiss then
						local args = { ... }
						local payload = args[2]
						if typeof(payload) == "table" then
							local stateBuf = payload[1]
							if typeof(stateBuf) == "buffer" then
								local state = buffer.tostring(stateBuf)
								if state and state:find("Miss") then
									return
								end
							end
						end
						return oldNamecall(self, table.unpack(args))
					end
				end
			end
			return oldNamecall(self, ...)
		end))
		local real_require = require
		local patched = {}
		require = function(mod)
			local ok, obj = pcall(real_require, mod)
			if not ok then
				error(obj, 2)
			end
			if type(obj) == "table" and not patched[obj] then
				if tostring((rawget(obj, "Type") or "")) == "OnMiss" then
					obj.Type = "OnHit"
					if type(obj.Run) == "function" then
						obj.Run = function() end
					end
				end
				patched[obj] = true
			end
			return obj
		end
	end
end

st.onAdd = function(Object)
	if not Object or Object.Name ~= "FNFEngine" then
		scan()
		return
	end
	local Engine = Object.Engine
	task.spawn(function()
		syncLullabyPurge(Engine)
	end)
	local function IsOnHit(m)
		return m ~= nil and (require(m)).Type == "OnHit"
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
	local scrollSpeed = Input.ScrollSpeedChange.Value and Input.ScrollSpeed.Value or (function()
		local p = Song and Song.Parent
		local s = p and p:FindFirstChild("Sound")
		local ps = s and s:FindFirstChild("PlaybackSpeed")
		return ps and tonumber(ps.Value) or 1
	end)()
	local baseOffset = calcOff(scrollSpeed)
	local sideValue = Object.Engine.PlayerSide.Value
	local sideFolder = Object.Engine.Game:FindFirstChild(sideValue)
	local Arrows = sideFolder and sideFolder:FindFirstChild("Arrows")
	local incomingFolder = Arrows and Arrows:FindFirstChild("IncomingNotes")
	if not incomingFolder then
		return
	end
	local IncomingNotes = Filter(incomingFolder:GetChildren(), function(v)
		return not string.find(v.Name, "|") and v or nil
	end)
	if Song then
		PoisonNotes = ((Song.Parent:FindFirstChild("MultiplieGimmickNotes") or Song:FindFirstChild("GimmickNotes") or Song.Parent:FindFirstChild("GimmickNotes") or Song:FindFirstChild("MineNotes") or {})).Value == "OnHit"
	end
	local Map = Keys[#IncomingNotes] or {}
	local Session = {}
	for kn, kv in pairs(Map) do
		local bindObj = Keybinds[kv]
		local bindValue = resolveKeyName(bindObj and bindObj.Value or kv)
		local code = safeKeyCode(bindValue) or Enum.KeyCode.Space
		Session[kn] = code
	end
	local mbMain = Object.Engine:FindFirstChild("MobileButtons")
	local contMain = mbMain and mbMain:FindFirstChild("Container")
	if contMain then
		contMain.Visible = not st.hideMb
	end
	local MobileButtons = Object.Engine:FindFirstChild("MobileButtons")
	local mobCont = MobileButtons and MobileButtons:FindFirstChild("Container")

	local function sendLaneKey(isDown, keyCode)
		if not keyCode then
			return
		end
		if svc.vim then
			svc.vim:SendKeyEvent(isDown, keyCode, false, nil)
		end
	end

	local function pressLane(name, keyCode)
		if st.inMode == "firesignal" and canUseFireSignal() then
			pressMob(mobCont, name)
			return
		end
		if st.mode == "actor" then
			if not actorKey("press", keyCode) then
				sendLaneKey(true, keyCode)
			end
			return
		end
		sendLaneKey(true, keyCode)
	end

	local function releaseLane(name, keyCode)
		if st.inMode == "firesignal" and canUseFireSignal() then
			relMob(mobCont, name)
			return
		end
		if st.mode == "actor" then
			if not actorKey("release", keyCode) then
				sendLaneKey(false, keyCode)
			end
			return
		end
		sendLaneKey(false, keyCode)
	end

	local laneDown = {}
	local laneCount = {}

	st.rel = function()
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

	local lower = Object.Engine:FindFirstChild("LowerContainer")
	local credit = lower and lower:FindFirstChild("Credit")
	local psVal = Object.Engine:FindFirstChild("PlayerSide")
	if credit then
		connections:add(credit:GetPropertyChangedSignal("Text"), scan)
	end
	if psVal then
		connections:add(psVal.Changed, scan)
	end
	scan()

	local AutoCtx = {
		enabled = true,
		offsetMs = st.off,
		baseOffset = baseOffset,
		laneDown = laneDown,
		laneCount = laneCount,
		press = pressLane,
		release = releaseLane
	}

	connections:add(Input.ScrollSpeed.Changed, function()
		local newValue = clampSpeed(Input.ScrollSpeed.Value)
		syncSlider(newValue)
	end)

	for _, Holder in pairs(IncomingNotes) do
		connections:add(Holder.ChildAdded, function(Arrow)
			task.defer(function()
				if not Arrow or not Arrow.Visible then
					return
				end
				local arrowName = tostring(Arrow.Name or "")
				local isOrange = arrowName:find("_OrangeNote", 1, true) ~= nil
				if Arrow:FindFirstChild("HellNote") and Arrow.HellNote.Value and PoisonNotes and not isOrange then
					return
				end
				if not isOrange and IsOnHit(Arrow:FindFirstChildOfClass("ModuleScript")) then
					return
				end
				local keyCode = Session[Holder.Name]
				if not keyCode then
					return
				end
				if not st.auto then
					return
				end
				AutoCtx.enabled = st.auto
				AutoCtx.offsetMs = st.off
				AutoCtx.baseOffset = calcOff(Input.ScrollSpeedChange.Value and Input.ScrollSpeed.Value or 1)
				playSeq(Holder, Arrow, keyCode, AutoCtx)
			end)
		end)
	end
end

st.regUi = function()
	connections:add(Client.CharacterAdded, function(char)
		task.spawn(function()
			local humanoid = char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10))
			if humanoid and st.aDead then
				applyAd(humanoid)
			end
		end)
	end)
	connections:add(svc.run.RenderStepped, function()
		if not st.aDead then
			return
		end
		applyAd(getHum())
	end)
	if svc.run.PreSimulation then
		connections:add(svc.run.PreSimulation, function()
			if not st.aDead then
				return
			end
			local humanoid = getHum()
			if humanoid and humanoid.Health < humanoid.MaxHealth then
				pcall(function()
					humanoid.Health = humanoid.MaxHealth
				end)
			end
		end)
	end
	connections:add(svc.run.Heartbeat, function()
		if not st.aDead then
			return
		end
		local humanoid = getHum()
		if humanoid and humanoid.Health < humanoid.MaxHealth then
			pcall(function()
				humanoid.Health = humanoid.MaxHealth
			end)
		end
	end)
	connections:add(PlayerGui.ChildAdded, function(o)
		task.defer(function()
			if o and o.Name == "FNFEngine" then
				applyMods(true)
			end
			if o and o.Name == "GameUI" then
				bindSw()
				watchSongSel(o)
			end
		end)
	end)
	connections:add(PlayerGui.ChildAdded, function(o)
		task.defer(function()
			if o and o.Name == "FNFEngine" then
				st.onAdd(o)
			end
		end)
	end)
	connections:add(PlayerGui.ChildRemoved, function(o)
		if o and o.Name == "FNFEngine" then
			syncLullabyPurge(nil)
			scan()
		end
		if o and o.Name == "GameUI" then
			dropSw()
			clearSongWatch()
		end
	end)
	connections:add(PlayerGui.DescendantAdded, function(o)
		task.defer(function()
			if o and o.Name == "TakeDamage" and o.Parent and o.Parent.Name == "Engine" then
				killTd(o)
			end
		end)
	end)
	local existingEngine = PlayerGui:FindFirstChild("FNFEngine")
	if existingEngine then
		applyMods(true)
		local engine = existingEngine:FindFirstChild("Engine")
		if engine then
			syncLullabyPurge(engine)
			local td = engine:FindFirstChild("TakeDamage")
			if td then
				killTd(td)
			end
		end
		task.spawn(function()
			st.onAdd(existingEngine)
		end)
	end
	local existingGameUI = PlayerGui:FindFirstChild("GameUI")
	if existingGameUI then
		bindSw()
		watchSongSel(existingGameUI)
	end
	if st.aDead then
		task.spawn(function()
			local humanoid = getHum()
			if humanoid then
				applyAd(humanoid)
			end
		end)
	end
end

st.regUi()
scan()

for _, v in pairs(workspace:QueryDescendants("Instance")) do
	if v.ClassName == "ProximityPrompt" then
		v.HoldDuration = 0
	end
end

do
	local v = resolveKeyName(Keybinds.R4 and Keybinds.R4.Value)
	if v == "Semicolon" then
		RE:FireServer("REMOTE_EVENT", {
			buffer.fromstring("\"Input\""),
			buffer.fromstring("\"Semicolon\""),
			buffer.fromstring("\"R4\"")
		})
	end
end
