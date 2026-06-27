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

local runtimeEnv = (getgenv and getgenv()) or _G
if type(runtimeEnv.__FNBPlayerRuntime) == "table" and type(runtimeEnv.__FNBPlayerRuntime.cleanup) == "function" then
	pcall(runtimeEnv.__FNBPlayerRuntime.cleanup)
end
local runtimeState = {
	alive = true
}
runtimeEnv.__FNBPlayerRuntime = runtimeState

local connections = {
	_list = {},
	add = function(self, s, cb)
		local conn = s:Connect(cb)
		self._list[#self._list + 1] = conn
		return conn
	end,
	disconnect = function(self)
		for _, v in self._list do
			if typeof(v) == "RBXScriptConnection" then
				pcall(function()
					v:Disconnect()
				end)
			elseif type(v) == "userdata" then
				pcall(function()
					if v.Connected ~= false and typeof(v.Disconnect) == "function" then
						v:Disconnect()
					end
				end)
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

local fn = {}

fn.getDesc = function(root)
	if not root then
		return {}
	end
	local okQ, resQ = pcall(function()
		if typeof(root.QueryDescendants) == "function" then
			return root:QueryDescendants("Instance")
		end
	end)
	if okQ and type(resQ) == "table" then
		return resQ
	end
	local okG, resG = pcall(function()
		return root:QueryDescendants("Instance")
	end)
	if okG and type(resG) == "table" then
		return resG
	end
	return {}
end

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
	vim = nil
}

fn.getVim = function()
	if svc.vim and typeof(svc.vim) == "Instance" then
		return svc.vim
	end

	local ok, vim = pcall(function()
		return __lt.cs("VirtualInputManager", cloneref)
	end)

	if ok and vim then
		svc.vim = vim
		return vim
	end
end

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

fn.loadChunk = function(url, label)
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

local Offsets = fn.loadChunk("https://raw.githubusercontent.com/ltseverydayyou/FNB-playerrrr/refs/heads/main/speedManager.lua", "speedManager.lua")
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

fn.clampSpeed = function(value)
	local n = tonumber(value) or 1
	if n < 0.5 then
		return 0.5
	end
	if n > 200 then
		return 200
	end
	return n
end

local defSpeed = fn.clampSpeed(Input and Input.ScrollSpeed and tonumber(Input.ScrollSpeed.Value) or 1)
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

fn.notify = function(title, description, time)
	Obsidian:Notify({
		Title = tostring(title or "FNB"),
		Description = tostring(description or ""),
		Time = time or 5
	})
end

fn.fmtPre = function(prefix, text)
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
	tapMs = 35,
	relMs = 0,
	holdTick = 0.015,
	maxHold = 8,
	hitOnHit = false,
	hitPoison = false,
	botScoreFun = false,
	botScoreMult = 2,
	botScoreBase = 500,
	dScore = false,
	scoreMult = 2,
	scoreBase = 500,
	scoreVal = false,
	gcScore = false,
	gcTiming = false,
	winMult = 1,
	promptInstant = true,
	aDmg = true,
	rel = function() end,
	onAdd = nil,
	regUi = nil,
	hideMb = true,
	brpc = true,
	mode = "normal",
	aKick = true,
	aMiss = true,
	aStat = true,
	aRemote = true,
	aDead = true,
	autoDeleteLullaby = true,
	matchEngine = nil,
	inMode = "Virtual Input",
	adHp = 1000000000,
	adHum = nil,
	adOrig = {}
}

local cap = {
	firesignal = typeof(firesignal) == "function",
	getgc = typeof(getgc) == "function",
	hookfunction = typeof(hookfunction) == "function",
	hookmetamethod = typeof(hookmetamethod) == "function",
	newcclosure = typeof(newcclosure) == "function",
	getnamecallmethod = typeof(getnamecallmethod) == "function",
	checkcaller = typeof(checkcaller) == "function",
	restorefunction = typeof(restorefunction) == "function",
	getactors = typeof(getactors) == "function",
	run_on_actor = typeof(run_on_actor) == "function",
	create_comm_channel = typeof(create_comm_channel) == "function",
	get_comm_channel = typeof(get_comm_channel) == "function"
}
cap.namecall = cap.hookmetamethod and cap.newcclosure and cap.getnamecallmethod
cap.actors = cap.getactors and cap.run_on_actor
cap.actorComm = cap.actors and cap.create_comm_channel and cap.get_comm_channel

if not cap.firesignal then
	st.inMode = "Virtual Input"
end

if not cap.namecall then
	st.aKick = false
	st.aMiss = false
	st.aStat = false
	st.aRemote = false
end

if not cap.getgc then
	st.gcScore = false
	st.gcTiming = false
end

fn.capText = function(name, ok)
	return name .. ": " .. (ok and "yes" or "no")
end

local actorState = {
	obj = nil,
	bound = nil,
	chan = nil,
	chanId = nil,
	init = false,
	ready = false,
	lastScan = 0,
	src = [[
		local isDown, keyName = ...
		local kc = typeof(keyName) == "string" and Enum.KeyCode[keyName] or nil
		if not kc then
			return
		end
		local ok, vim = pcall(function()
			return Instance.new("VirtualInputManager")
		end)
		if ok and vim then
			pcall(function()
				vim:SendKeyEvent(isDown and true or false, kc, false, nil)
			end)
		end
	]],
	initSrc = [[
		local id = ...
		local env = (getgenv and getgenv()) or _G or {}
		local key = "__lt_actor_input_" .. tostring(id)
		if env[key] then
			return true
		end
		local okC, chan = pcall(get_comm_channel, id)
		if not okC or not chan then
			return false
		end
		local okV, vim = pcall(function()
			return Instance.new("VirtualInputManager")
		end)
		if not okV or not vim then
			return false
		end
		env[key] = true
		chan.Event:Connect(function(isDown, keyName)
			local kc = typeof(keyName) == "string" and Enum.KeyCode[keyName] or nil
			if not kc then
				return
			end
			pcall(function()
				vim:SendKeyEvent(isDown and true or false, kc, false, nil)
			end)
		end)
		return true
	]]
}

fn.actorReset = function(dropObj)
	actorState.init = false
	actorState.ready = false
	if actorState.chan then
		pcall(function()
			actorState.chan:Destroy()
		end)
	end
	actorState.chan = nil
	actorState.chanId = nil
	actorState.bound = nil
	if dropObj then
		actorState.obj = nil
	end
end

fn.actorObj = function()
	if not cap.actors then
		return nil
	end
	if actorState.obj and actorState.obj.Parent then
		return actorState.obj
	end
	local now = os.clock()
	if now - actorState.lastScan < 1 then
		return nil
	end
	actorState.lastScan = now
	local okA, actors = pcall(getactors)
	if not okA or type(actors) ~= "table" then
		return nil
	end
	for _, obj in actors do
		if typeof(obj) == "Instance" and obj:IsA("Actor") and obj.Parent then
			actorState.obj = obj
			return obj
		end
	end
	for _, obj in actors do
		if obj ~= nil then
			actorState.obj = obj
			return obj
		end
	end
	return nil
end

fn.actorReady = function()
	if not cap.actorComm then
		return false
	end
	local obj = fn.actorObj()
	if not obj then
		return false
	end
	if actorState.ready and actorState.chan and actorState.bound == obj then
		return true
	end
	if not actorState.chan or actorState.chanId == nil then
		local okId, id, chan = pcall(create_comm_channel)
		if not okId or type(id) ~= "number" or not chan then
			fn.actorReset(false)
			return false
		end
		actorState.chanId = id
		actorState.chan = chan
	end
	local okRun = pcall(run_on_actor, obj, actorState.initSrc, actorState.chanId)
	actorState.init = okRun and true or false
	actorState.ready = okRun and true or false
	actorState.bound = okRun and obj or nil
	if not okRun then
		fn.actorReset(false)
		return false
	end
	return true
end

fn.actorWarm = function()
	if st.mode ~= "actor" then
		return false
	end
	if fn.actorReady() then
		return true
	end
	return fn.actorObj() ~= nil
end

local patchNetworkFire
local applyTimingWindows
local boostScoreValue
local applyScoreValue
local bindScoreValue
local bumpBotScore
local gcScanReport
local gcState = {
	netPatched = false,
	netClient = nil,
	netOld = nil,
	netFire = nil,
	netMode = nil,
	timing = {},
	timingBase = {}
}
local scoreState = {
	val = nil,
	conn = nil,
	busy = false,
	base = 0,
	hitGain = 0,
	shown = 0,
	lastKey = nil,
	lastTime = 0
}

runtimeState.cleanup = function()
	if not runtimeState.alive then
		return
	end
	runtimeState.alive = false
	st.auto = false
	pcall(st.rel)
	connections:disconnect()
	pcall(function()
		if type(runtimeState.gcClean) == "function" then
			runtimeState.gcClean()
		end
	end)
	for key, conn in watchers do
		if typeof(conn) == "RBXScriptConnection" then
			pcall(function()
				conn:Disconnect()
			end)
			watchers[key] = nil
		end
	end
	fn.actorReset(true)
	for humanoid, state in st.adOrig do
		if humanoid and humanoid:IsA("Humanoid") then
			pcall(function()
				humanoid.MaxHealth = state.maxHealth or 100
			end)
			if state.breakJointsOnDeath ~= nil then
				pcall(function()
					humanoid.BreakJointsOnDeath = state.breakJointsOnDeath
				end)
			end
			pcall(function()
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			end)
		end
		st.adOrig[humanoid] = nil
	end
	if runtimeEnv.__FNBPlayerRuntime == runtimeState then
		runtimeEnv.__FNBPlayerRuntime = nil
	end
	pcall(function()
		if Obsidian and Obsidian.Unload then
			Obsidian:Unload()
		end
	end)
end
if not cap.firesignal then
	st.inMode = "Virtual Input"
end

local gEnv
if typeof(getrenv) == "function" then
	local ok, env = pcall(getrenv)
	if ok and type(env) == "table" then
		gEnv = env._G
	end
end

fn.lastInputMode = function()
	if st.inMode == "firesignal" then
		return Enum.UserInputType.Touch, "Mobile"
	end
	return Enum.UserInputType.Keyboard, "Computer"
end

fn.forceLastInput = function()
	local wanted, device = fn.lastInputMode()
	local li
	pcall(function()
		li = rawget(_G, "LastInput")
	end)
	if not li and gEnv then
		pcall(function()
			li = rawget(gEnv, "LastInput")
		end)
	end
	if type(li) == "table" then
		pcall(function()
			li.Value = wanted
		end)
		pcall(function()
			local env = getfenv(li.Value)
			if type(env) == "table" then
				local s = rawget(env, "script")
				local dv = s and s:FindFirstChild("Device")
				if dv and dv:IsA("StringValue") then
					dv.Value = device
				end
			end
		end)
	end
	pcall(function()
		local fnf = PlayerGui:FindFirstChild("FNFEngine")
		local eng = fnf and fnf:FindFirstChild("Engine")
		local dv = eng and eng:FindFirstChild("Device")
		if dv and dv:IsA("StringValue") then
			dv.Value = device
		end
	end)
end


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

fn.safeKeyCode = function(name)
	if typeof(name) ~= "string" then
		return nil
	end
	local ok, kc = pcall(function()
		return Enum.KeyCode[name]
	end)
	return ok and kc or nil
end

fn.resolveKeyName = function(value)
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
local ModClickDelay = 0.1
local applyModsTok = 0
local engineModsTok = 0
local modTok = {}
local modAppliedButton = {}

fn.initModState = function()
	for kind, names in ModifierList do
		modState[kind] = modState[kind] or {}
		local bucket = modState[kind]
		for _, name in names do
			if bucket[name] == nil then
				bucket[name] = false
			end
		end
	end
end

fn.initModState()

fn.resetModState = function()
	for kind, names in ModifierList do
		local bucket = modState[kind]
		if bucket then
			for _, name in names do
				bucket[name] = false
				modAppliedButton[string.format("%s:%s", tostring(kind), tostring(name))] = nil
			end
		end
	end
end

fn.pname = function()
	local ok, info = pcall(svc.mps.GetProductInfo, svc.mps, game.PlaceId)
	return ok and info and info.Name or __lt.cm("MarketplaceService", "GetProductInfo", game.PlaceId).Name
end

fn.picon = function()
	local ok, info = pcall(svc.mps.GetProductInfo, svc.mps, game.PlaceId)
	if ok and info and info.IconImageAssetId and info.IconImageAssetId ~= 0 then
		return info.IconImageAssetId
	end
	return nil
end

fn.rpc = function(details, state, largeId, largeHover, smallId, smallHover)
	if not st.brpc then
		return
	end
	local detailsText = fn.fmtPre(rpcDet, details)
	local stateText = fn.fmtPre(RPCStatePrefix, state)
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

fn.lobbyRPC = function()
	fn.rpc(fn.pname(), "Lobby", fn.picon(), fn.pname(), nil, nil)
end

fn.parseCredit = function(txt)
	local t = txt or ""
	local ln1 = t:match("^[^\n]+") or ""
	ln1 = ln1:gsub("%s%(%d+%.?%d*x%)", "")
	local rest = t:gsub("^[^\n]*\n?", "")
	rest = rest:gsub("\n?%d+:%d%d%s*$", "")
	rest = (rest:gsub("^%s+", "")):gsub("%s+$", "")
	return ln1, rest
end

fn.scan = function()
	local eng = PlayerGui:FindFirstChild("FNFEngine")
	if not eng then
		fn.lobbyRPC()
		return
	end
	local engine = eng:FindFirstChild("Engine")
	local lower = engine and engine:FindFirstChild("LowerContainer")
	local credit = lower and lower:FindFirstChild("Credit")
	local det, st = "", ""
	if credit and credit:IsA("TextLabel") then
		det, st = fn.parseCredit(credit.Text)
	end
	local sid
	local mods = engine and engine:FindFirstChild("Modifiers")
	local ghost = mods and mods:FindFirstChild("GhostTapping")
	if ghost and ghost:IsA("ImageButton") and type(ghost.Image) == "string" then
		local d = ghost.Image:match("%d+")
		sid = d and tonumber(d) or nil
	end
	local sideVal = engine and engine:FindFirstChild("PlayerSide") and engine.PlayerSide.Value or "L"
	local sh = fn.fmtPre(RPCSidePrefix, sideVal == "L" and "Left" or "Right")
	fn.rpc(det, st, fn.picon(), fn.pname(), sid, sh)
end

fn.guiClick = function(btn)
	if btn and not btn:IsA("GuiButton") then
		btn = (function(node)
			if not node then
				return nil
			end
			if node:IsA("GuiButton") then
				return node
			end
			for _, child in fn.getDesc(node) do
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
	if cap.firesignal then
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

fn.normModKey = function(str)
	if type(str) ~= "string" then
		return ""
	end
	return (str:gsub("%s+", "")):lower()
end

fn.asClickable = function(node)
	if not node then
		return nil
	end
	if node:IsA("GuiButton") then
		return node
	end
	for _, child in fn.getDesc(node) do
		if child:IsA("GuiButton") then
			return child
		end
	end
	return nil
end

fn.findModButton = function(container, kind, name)
	if not container then
		return nil
	end
	local targetKey = fn.normModKey(name)
	local buckets = {
		container:FindFirstChild(kind),
		container:FindFirstChild(kind .. "Modifiers"),
		container
	}
	for _, bucket in buckets do
		if bucket then
			local direct = bucket:FindFirstChild(name)
			local clickable = fn.asClickable(direct)
			if clickable then
				return clickable
			end
			for _, child in fn.getDesc(bucket) do
				if fn.normModKey(child.Name) == targetKey then
					local btn = fn.asClickable(child)
					if btn then
						return btn
					end
				elseif child:IsA("GuiButton") then
					local txt = tostring(child.Text or "")
					if fn.normModKey(txt) == targetKey then
						return child
					end
				end
			end
		end
	end
	return nil
end

fn.getActualModifiers = function(timeout)
	local deadline = os.clock() + (tonumber(timeout) or 0)
	repeat
		local gui = PlayerGui:FindFirstChild("GameUI")
		local songSelect = gui and gui:FindFirstChild("SongSelect")
		local modifiers = songSelect and songSelect:FindFirstChild("Modifiers")
		local actual = modifiers and modifiers:FindFirstChild("ActualModifiers")
		if actual then
			return actual
		end
		if os.clock() >= deadline then
			break
		end
		task.wait(0.1)
	until false
	return nil
end

fn.getActualModButton = function(kind, name, timeout)
	local actual = fn.getActualModifiers(timeout)
	local bucket = actual and actual:FindFirstChild(kind)
	if bucket then
		local direct = bucket:FindFirstChild(name)
		local button = fn.asClickable(direct)
		if button then
			return button
		end
	end
	return fn.findModButton(actual, kind, name)
end

fn.getModButton = function(kind, name)
	return fn.getActualModButton(kind, name, 0)
end

fn.engineReady = function()
	return PlayerGui:FindFirstChild("FNFEngine") ~= nil
end

fn.getSongPlaybackSpeed = function(song)
	local parent = song and song.Parent
	local sound = parent and parent:FindFirstChild("Sound")
	local playbackSpeed = sound and sound:FindFirstChild("PlaybackSpeed")
	return playbackSpeed and tonumber(playbackSpeed.Value) or 1
end

fn.getActiveScrollSpeed = function(song)
	if Input.ScrollSpeedChange.Value then
		return Input.ScrollSpeed.Value
	end
	return fn.getSongPlaybackSpeed(song)
end

fn.applyMod = function(kind, name, shouldEnable, force)
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
	local stateKey = string.format("%s:%s", tostring(kind), tostring(name))
	local needsToggle
	if desired then
		needsToggle = force or previous ~= true
	else
		needsToggle = previous == true
	end
	if not needsToggle then
		return false
	end
	if not fn.engineReady() then
		return false
	end
	local btn = fn.getModButton(kind, name)
	if not btn then
		return false
	end
	if desired and force and previous == true and modAppliedButton[stateKey] == btn then
		return false
	end
	fn.guiClick(btn)
	stateBucket[name] = desired
	modAppliedButton[stateKey] = desired and btn or nil
	return true
end

fn.queueModApply = function(kind, name, shouldEnable)
	local key = string.format("%s:%s", tostring(kind), tostring(name))
	modTok[key] = (modTok[key] or 0) + 1
	local token = modTok[key]
	task.delay(ModApplyDelay, function()
		if modTok[key] ~= token then
			return
		end
		modTok[key] = nil
		fn.applyMod(kind, name, shouldEnable, false)
	end)
end

fn.applyMods = function(force)
	applyModsTok += 1
	local token = applyModsTok
	task.spawn(function()
		task.wait(ModApplyDelay)
		if token ~= applyModsTok then
			return
		end
		fn.applyModsNow(force)
	end)
end

fn.applyModsNow = function(force)
	if not fn.engineReady() then
		return false
	end
	local clicked = false
	for kind, names in ModifierList do
		local flags = AutoModFlags[kind]
		local stateBucket = modState[kind]
		for _, name in names do
			local desired = false
			if flags then
				desired = flags[name] and true or false
			end
			if desired or stateBucket and stateBucket[name] then
				if fn.applyMod(kind, name, desired, force) then
					clicked = true
				end
			end
		end
	end
	return clicked
end

fn.applyModsSequential = function(force)
	if not fn.engineReady() then
		return false
	end
	local clicked = false
	for kind, names in ModifierList do
		local flags = AutoModFlags[kind]
		local stateBucket = modState[kind]
		for _, name in names do
			local desired = false
			if flags then
				desired = flags[name] and true or false
			end
			if desired or stateBucket and stateBucket[name] then
				if fn.applyMod(kind, name, desired, force) then
					clicked = true
					task.wait(ModClickDelay)
				end
			end
		end
	end
	return clicked
end

fn.applyModsForEngine = function(engineGui)
	if not engineGui then
		return
	end
	engineModsTok += 1
	local token = engineModsTok
	fn.resetModState()
	task.spawn(function()
		task.wait(ModApplyDelay)
		local endAt = os.clock() + 8
		while token == engineModsTok and engineGui.Parent and PlayerGui:FindFirstChild("FNFEngine") == engineGui and os.clock() <= endAt do
			fn.applyModsSequential(false)
			task.wait(0.75)
		end
	end)
end

fn.calcOff = function(scrollSpeed)
	local key = string.format("%.1f", tonumber(scrollSpeed) or 1)
	local ms = Offsets[key]
	if ms == nil then
		local fallback = Offsets["10.0"] or 0
		ms = fallback
	end
	return ms / 1000 + 0.4
end

fn.pressMob = function(container, name)
	if not cap.firesignal then
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

fn.relMob = function(container, name)
	if not cap.firesignal then
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

fn.actorKey = function(op, keyCode)
	if st.mode ~= "actor" then
		return false
	end
	if not cap.actors then
		return false
	end
	if not keyCode or typeof(keyCode) ~= "EnumItem" then
		return false
	end
	local obj = fn.actorObj()
	if not obj then
		return false
	end
	local down = op == "press"
	if fn.actorReady() and actorState.chan then
		local okFire = pcall(function()
			actorState.chan:Fire(down, keyCode.Name)
		end)
		if okFire then
			return true
		end
		fn.actorReset(false)
	end
	local okRun = pcall(run_on_actor, obj, actorState.src, down, keyCode.Name)
	if not okRun and actorState.obj == obj then
		actorState.obj = nil
	end
	return okRun
end

fn.playSeq = function(Holder, Arrow, keyCode, AutoCtx)
	task.spawn(function()
		local delayTime = math.max(0, (AutoCtx.baseOffset or 0) + (AutoCtx.offsetMs or 0) / 1000)
		if delayTime > 0 then
			task.wait(delayTime)
		end
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
		end
		AutoCtx.press(Holder.Name, keyCode)
		if type(AutoCtx.botScore) == "function" then
			pcall(AutoCtx.botScore, Holder.Name, Arrow)
		end
		AutoCtx.laneDown[Holder] = true
		AutoCtx.laneCount[Holder] = (AutoCtx.laneCount[Holder] or 0) + 1
		local untilTime = os.clock() + math.max(0.05, AutoCtx.maxHold or 8)
		if isHold(Arrow) then
			while Arrow and Arrow.Parent and Arrow.Visible and AutoCtx.enabled and os.clock() <= untilTime do
				if not isHold(Arrow) then
					break
				end
				task.wait(math.max(0.005, AutoCtx.holdTick or 0.015))
			end
		else
			task.wait(math.max(0, AutoCtx.tapMs or 35) / 1000)
		end
		if AutoCtx.relMs and AutoCtx.relMs > 0 then
			task.wait(AutoCtx.relMs / 1000)
		end
		AutoCtx.laneCount[Holder] = math.max((AutoCtx.laneCount[Holder] or 1) - 1, 0)
		if AutoCtx.laneCount[Holder] <= 0 then
			AutoCtx.laneCount[Holder] = 0
			if AutoCtx.laneDown[Holder] then
				AutoCtx.release(Holder.Name, keyCode)
				AutoCtx.laneDown[Holder] = false
			end
		end
	end)
end

fn.killLullabyChild = function(child)
	if not st.autoDeleteLullaby or not child then
		return
	end
	if child.Name == "background" and child:IsA("Frame") then
		child:Destroy()
	elseif child.Name == "static" and child:IsA("Sound") then
		child:Destroy()
	end
end

fn.syncLullabyPurge = function(engine)
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
		fn.killLullabyChild(engine:FindFirstChild("background"))
		for _, child in engine:GetChildren() do
			fn.killLullabyChild(child)
		end
	end)
	watchers.lullaby = engine.ChildAdded:Connect(function(child)
		task.defer(function()
			if watchers.lullabyEngine ~= engine then
				return
			end
			fn.killLullabyChild(child)
		end)
	end)
end

local MainControls = TabMain:AddLeftGroupbox("Autoplayer")
local MiscControls = TabMain:AddRightGroupbox("Options")
local AutoModsGroup = TabMain:AddRightGroupbox("Auto Modifiers")

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

fn.doSolo = function(singleplayerUI)
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

fn.watchSolo = function(enabled)
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
				fn.doSolo(child)
			end
		end)
	end)
	local existing = PlayerGui:FindFirstChild("SingleplayerUI")
	if existing then
		task.defer(function()
			fn.doSolo(existing)
		end)
	end
end

fn.getHum = function()
	local character = Client.Character
	if not character then
		return nil
	end
	return character:FindFirstChildOfClass("Humanoid")
end

fn.snapAdHum = function(humanoid)
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

fn.applyAd = function(humanoid)
	if not st.aDead or not humanoid or not humanoid:IsA("Humanoid") or humanoid.Parent == nil then
		return
	end
	st.adHum = humanoid
	fn.snapAdHum(humanoid)
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

fn.restAd = function(humanoid)
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

fn.killTd = function(remote)
	if not st.aDmg or not remote or remote.Parent == nil then
		return
	end
	local name = tostring(remote.Name)
	if name ~= "TakeDamage" and name ~= "Damage" and name ~= "DamagePlayer" then
		return
	end
	pcall(function()
		remote:Destroy()
	end)
end

fn.setAd = function(enabled)
	st.aDead = enabled and true or false
	if st.aDead then
		fn.applyAd(fn.getHum())
		return
	end
	local restoreList = {}
	for humanoid in st.adOrig do
		restoreList[#restoreList + 1] = humanoid
	end
	for _, humanoid in restoreList do
		fn.restAd(humanoid)
	end
end

tAuto = MainControls:AddToggle("AutoplayerToggle", {
	Text = "Autoplayer",
	Default = true,
	Callback = function(v)
		st.auto = v
		if v and st.mode == "actor" then
			fn.actorWarm()
		elseif not v then
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
		fn.doSolo()
	end)
end

local spdSync = false

fn.pushSpeed = function(value)
	RE:FireServer("REMOTE_EVENT", {
		buffer.fromstring("\"Input\""),
		buffer.fromstring(tostring(value)),
		buffer.fromstring("\"ScrollSpeed\"")
	})
end

fn.syncSlider = function(value)
	local clamped = fn.clampSpeed(value)
	curSpeed = clamped
	if not sSpd then
		return
	end
	spdSync = true
	sSpd:SetValue(clamped)
	spdSync = false
end

fn.parseSpd = function(text)
	if type(text) ~= "string" then
		return nil
	end
	local match = string.match(text, "[-+]?%d+%.?%d*")
	if not match then
		return nil
	end
	return tonumber(match)
end

fn.syncBtn = function(button)
	if not button or spdSync then
		return
	end
	local parsed = fn.parseSpd(button.Text)
	if not parsed then
		return
	end
	local clamped = fn.clampSpeed(parsed)
	if math.abs(clamped - curSpeed) < 0.001 then
		return
	end
	fn.syncSlider(clamped)
end

fn.dropSw = function()
	if watchers.scrollBtn then
		watchers.scrollBtn:Disconnect()
		watchers.scrollBtn = nil
	end
	if watchers.scrollAnces then
		watchers.scrollAnces:Disconnect()
		watchers.scrollAnces = nil
	end
end

fn.bindSw = function()
	fn.dropSw()
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
			fn.syncBtn(button)
		end
		watchers.scrollBtn = button:GetPropertyChangedSignal("Text"):Connect(onTextChanged)
		watchers.scrollAnces = button.AncestryChanged:Connect(function(_, parent)
			if not parent then
				fn.bindSw()
			end
		end)
		onTextChanged()
	end)
end

fn.clearSongWatch = function()
	if watchers.songVis then
		watchers.songVis:Disconnect()
		watchers.songVis = nil
	end
	if watchers.songChild then
		watchers.songChild:Disconnect()
		watchers.songChild = nil
	end
end

fn.bindSongVis = function(songSelect)
	if not songSelect then
		return
	end
	if watchers.songVis then
		watchers.songVis:Disconnect()
		watchers.songVis = nil
	end
	watchers.songVis = songSelect:GetPropertyChangedSignal("Visible"):Connect(function()
		if songSelect.Visible then
			fn.applyMods(true)
		end
	end)
	if songSelect.Visible then
		fn.applyMods(true)
	end
end

fn.watchSongSel = function(gameUI)
	fn.clearSongWatch()
	if not gameUI then
		return
	end
	local function onSong(child)
		task.defer(function()
			if child and child.Name == "SongSelect" then
				fn.bindSongVis(child)
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
		local sv = fn.clampSpeed(v)
		curSpeed = sv
		fn.pushSpeed(sv)
	end
})

MainControls:AddInput("ScrollSpeedInput", {
	Text = "Speed override",
	Placeholder = "0.5 - 200.0",
	Finished = true,
	Numeric = true,
	ClearTextOnFocus = false,
	Callback = function(v)
		local n = fn.clampSpeed(v)
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

MainControls:AddSlider("TapHoldMs", {
	Text = "Tap hold",
	Default = st.tapMs,
	Min = 5,
	Max = 250,
	Rounding = 0,
	Suffix = "ms",
	Callback = function(v)
		st.tapMs = math.clamp(tonumber(v) or 35, 5, 250)
	end
})

MainControls:AddSlider("ReleaseDelayMs", {
	Text = "Release delay",
	Default = st.relMs,
	Min = 0,
	Max = 250,
	Rounding = 0,
	Suffix = "ms",
	Callback = function(v)
		st.relMs = math.clamp(tonumber(v) or 0, 0, 250)
	end
})

MainControls:AddSlider("MaxHoldSeconds", {
	Text = "Max hold watchdog",
	Default = st.maxHold,
	Min = 1,
	Max = 30,
	Rounding = 1,
	Suffix = "s",
	Callback = function(v)
		st.maxHold = math.clamp(tonumber(v) or 8, 1, 30)
	end
})

local inputModes = { "Virtual Input" }
if cap.firesignal then
	inputModes[#inputModes + 1] = "firesignal"
end

inModeDrop = MainControls:AddDropdown("InputMode", {
	Text = "Input method",
	Values = inputModes,
	Default = st.inMode,
	Callback = function(opt)
		local sel = typeof(opt) == "table" and opt[1] or opt or "Virtual Input"
		if sel ~= "firesignal" then
			sel = "Virtual Input"
		end
		if sel == "firesignal" and not cap.firesignal then
			fn.notify("Missing requirement", "firesignal is required for firesignal mode; using Virtual Input instead.", 6)
			st.inMode = "Virtual Input"
			if inModeDrop then
				inModeDrop:SetValue("Virtual Input")
			end
			fn.forceLastInput()
			return
		end
		st.inMode = sel
		fn.forceLastInput()
	end
})

MainControls:AddLabel("if firesignal doesn't work\nswitch to Virtual Input")

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

MiscControls:AddButton("Instant Solo", {
	Text = "Instant Solo",
	Func = function()
		local sp = PlayerGui:WaitForChild("SingleplayerUI", 2)
		if sp then
			fn.doSolo(sp)
		end
	end
})

soloToggle = MiscControls:AddToggle("AutoSolo", {
	Text = "Auto Solo",
	Default = false,
	Callback = function(v)
		fn.watchSolo(v)
	end
})

MiscControls:AddToggle("AutoDeleteLullaby", {
	Text = "Auto Delete Lullaby",
	Default = st.autoDeleteLullaby,
	Callback = function(v)
		st.autoDeleteLullaby = v and true or false
		if st.autoDeleteLullaby and st.matchEngine and st.matchEngine.Parent then
			fn.syncLullabyPurge(st.matchEngine)
		else
			fn.syncLullabyPurge(nil)
		end
	end
})

MiscControls:AddToggle("HitOnHitNotes", {
	Text = "Hit OnHit/Gimmick Notes",
	Default = st.hitOnHit,
	Callback = function(v)
		st.hitOnHit = v and true or false
	end
})

MiscControls:AddToggle("HitPoisonNotes", {
	Text = "Hit Poison/Hell Notes",
	Default = st.hitPoison,
	Callback = function(v)
		st.hitPoison = v and true or false
	end
})

MiscControls:AddButton("ExecutorSupportInfo", {
	Text = "Show executor support",
	Func = function()
		fn.notify("Executor support", table.concat({
			fn.capText("firesignal", cap.firesignal),
			fn.capText("hookmetamethod", cap.namecall),
			fn.capText("hookfunction", cap.hookfunction),
			fn.capText("getgc", cap.getgc)
		}, "\n"), 6)
	end
})

MiscControls:AddToggle("BotScoreFun", {
	Text = "Bot Double Score",
	Default = st.botScoreFun,
	Callback = function(v)
		st.botScoreFun = v and true or false
	end
})

MiscControls:AddSlider("BotScoreMultiplier", {
	Text = "Bot score multiplier",
	Default = st.botScoreMult,
	Min = 1,
	Max = 50,
	Rounding = 0,
	Suffix = "x",
	Callback = function(v)
		st.botScoreMult = math.clamp(math.floor(tonumber(v) or 2), 1, 50)
	end
})

MiscControls:AddSlider("BotScorePerHit", {
	Text = "Bot score per hit",
	Default = st.botScoreBase,
	Min = 50,
	Max = 10000,
	Rounding = 0,
	Suffix = " pts",
	Callback = function(v)
		st.botScoreBase = math.clamp(math.floor(tonumber(v) or 500), 50, 10000)
	end
})

MiscControls:AddButton("TestBotScoreRF", {
	Text = "Send bot score test",
	Func = function()
		if bumpBotScore then
			bumpBotScore("Down")
		end
	end
})

if cap.getgc then
	MiscControls:AddToggle("GCNetworkScoreHook", {
		Text = "getgc Hit Replay Test",
		Default = st.gcScore,
		Callback = function(v)
			st.gcScore = v and true or false
			if st.gcScore and patchNetworkFire then
				patchNetworkFire()
			end
		end
	})

	MiscControls:AddToggle("GCTimingWindows", {
		Text = "getgc Timing Windows",
		Default = st.gcTiming,
		Callback = function(v)
			st.gcTiming = v and true or false
			if applyTimingWindows then
				applyTimingWindows()
			end
		end
	})

	MiscControls:AddSlider("TimingWindowMultiplier", {
		Text = "Timing window multiplier",
		Default = st.winMult,
		Min = 1,
		Max = 25,
		Rounding = 1,
		Suffix = "x",
		Callback = function(v)
			st.winMult = math.clamp(tonumber(v) or 1, 1, 25)
			if applyTimingWindows then
				applyTimingWindows()
			end
		end
	})

	MiscControls:AddButton("GetGCClientScan", {
		Text = "getgc client scan",
		Func = function()
			if gcScanReport then
				gcScanReport()
			end
		end
	})
else
	MiscControls:AddButton("GetGCUnavailableInfo", {
		Text = "getgc options unavailable",
		Func = function()
			fn.notify("getgc unavailable", "This executor does not expose getgc, so getgc-only options were hidden.", 5)
		end
	})
end

MiscControls:AddButton("Release stuck keys", {
	Text = "Release stuck keys",
	Func = function()
		pcall(st.rel)
	end
})

if cap.namecall then
	antiMissToggle = MiscControls:AddToggle("AntiMiss", {
		Text = "Anti Miss",
		Default = st.aMiss,
		Callback = function(v)
			st.aMiss = v and true or false
		end
	})

	MiscControls:AddToggle("SanitizeStats", {
		Text = "Sanitize Stats",
		Default = st.aStat,
		Callback = function(v)
			st.aStat = v and true or false
		end
	})

	MiscControls:AddToggle("AntiRemoteChecks", {
		Text = "Anti Remote Checks",
		Default = st.aRemote,
		Callback = function(v)
			st.aRemote = v and true or false
		end
	})
else
	MiscControls:AddButton("HookedBypassUnavailableInfo", {
		Text = "Hooked bypasses unavailable",
		Func = function()
			fn.notify("Hooking unavailable", "Missing hookmetamethod, newcclosure, or getnamecallmethod.", 5)
		end
	})
end

deadTg = MiscControls:AddToggle("AntiDeath", {
	Text = "Anti Death",
	Default = st.aDead,
	Callback = function(v)
		fn.setAd(v)
	end
})

MiscControls:AddToggle("AntiDamageRemote", {
	Text = cap.namecall and "Anti Damage Remote" or "Anti Damage Remote (local)",
	Default = st.aDmg,
	Callback = function(v)
		st.aDmg = v and true or false
		if st.aDmg then
			local engGui = PlayerGui:FindFirstChild("FNFEngine")
			local eng = engGui and engGui:FindFirstChild("Engine")
			for _, obj in fn.getDesc(eng) do
				fn.killTd(obj)
			end
		end
	end
})

if cap.actors then
	modeDropdown = MiscControls:AddDropdown("AutoplayerMode", {
		Text = "Autoplayer Mode",
		Values = {
			"normal",
			"actor"
		},
		Default = st.mode,
		Callback = function(opt)
			local sel = typeof(opt) == "table" and opt[1] or opt or st.mode
			if sel ~= "actor" and sel ~= "normal" then
				sel = "normal"
			end
			if st.mode == sel then
				if sel == "actor" then
					fn.actorWarm()
				end
				return
			end
			st.mode = sel
			if sel == "actor" then
				fn.actorWarm()
			else
				fn.actorReset(false)
			end
		end
	})
end

AutoModsGroup:AddLabel("Hard Modifiers")

AutoModsGroup:AddToggle("AM_Hard_Death", {
	Text = "Death",
	Default = false,
	Callback = function(v)
		AutoModFlags.Hard.Death = v
		fn.queueModApply("Hard", "Death", v)
	end
})

AutoModsGroup:AddToggle("AM_Hard_FadeIn", {
	Text = "FadeIn",
	Default = false,
	Callback = function(v)
		AutoModFlags.Hard.FadeIn = v
		fn.queueModApply("Hard", "FadeIn", v)
	end
})

AutoModsGroup:AddToggle("AM_Hard_FadeOut", {
	Text = "FadeOut",
	Default = false,
	Callback = function(v)
		AutoModFlags.Hard.FadeOut = v
		fn.queueModApply("Hard", "FadeOut", v)
	end
})

AutoModsGroup:AddToggle("AM_Hard_Pendulum", {
	Text = "Pendulum",
	Default = false,
	Callback = function(v)
		AutoModFlags.Hard.Pendulum = v
		fn.queueModApply("Hard", "Pendulum", v)
	end
})

AutoModsGroup:AddToggle("AM_Hard_Perfect", {
	Text = "Perfect",
	Default = false,
	Callback = function(v)
		AutoModFlags.Hard.Perfect = v
		fn.queueModApply("Hard", "Perfect", v)
	end
})

AutoModsGroup:AddToggle("AM_Hard_SuddenDeath", {
	Text = "SuddenDeath",
	Default = false,
	Callback = function(v)
		AutoModFlags.Hard.SuddenDeath = v
		fn.queueModApply("Hard", "SuddenDeath", v)
	end
})

AutoModsGroup:AddDivider()

AutoModsGroup:AddLabel("Normal Modifiers")

AutoModsGroup:AddToggle("AM_Normal_GhostTapping", {
	Text = "GhostTapping",
	Default = false,
	Callback = function(v)
		AutoModFlags.Normal.GhostTapping = v
		fn.queueModApply("Normal", "GhostTapping", v)
	end
})

AutoModsGroup:AddToggle("AM_Normal_Mirror", {
	Text = "Mirror",
	Default = false,
	Callback = function(v)
		AutoModFlags.Normal.Mirror = v
		fn.queueModApply("Normal", "Mirror", v)
	end
})

AutoModsGroup:AddToggle("AM_Normal_Random", {
	Text = "Random",
	Default = false,
	Callback = function(v)
		AutoModFlags.Normal.Random = v
		fn.queueModApply("Normal", "Random", v)
	end
})

local creditsGroup = TabCredits:AddLeftGroupbox("Credits")

if typeof(setclipboard) == "function" then
	creditsGroup:AddButton("FixerLink", {
		Text = "Fixed by ltseverydayyou",
		Func = function()
			setclipboard("https://github.com/ltseverydayyou")
			fn.notify("Copied", "GitHub URL copied to clipboard", 3)
		end
	})
	creditsGroup:AddButton("OriginalLink", {
		Text = "Original by Mati278",
		Func = function()
			setclipboard("https://github.com/Mati278")
			fn.notify("Copied", "GitHub URL copied to clipboard", 3)
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

fn.resolveKeyCode = function(nameOrEnum)
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

fn.applyUiKey = function()
	if not keyPick then
		return
	end
	local keyName = keyPick.Value
	local enumValue = fn.resolveKeyCode(keyName)
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
	keyPick:OnChanged(fn.applyUiKey)
	fn.applyUiKey()
end

local scriptGroup = TabSettings:AddRightGroupbox("Script Controls")

if cap.namecall then
	scriptGroup:AddToggle("AntiKick", {
		Text = "Anti Kick",
		Default = st.aKick,
		Callback = function(v)
			st.aKick = v and true or false
		end
	})
else
	scriptGroup:AddButton("AntiKickUnavailableInfo", {
		Text = "Anti Kick unavailable",
		Func = function()
			fn.notify("Anti Kick unavailable", "This executor is missing namecall hook support.", 5)
		end
	})
end

brpcToggle = scriptGroup:AddToggle("BloxstrapRPC", {
	Text = "Bloxstrap RPC",
	Default = st.brpc,
	Callback = function(v)
		st.brpc = v
		if v then
			fn.scan()
		end
	end
})

scriptGroup:AddButton("Reload script", {
	Text = "Reload script",
	Func = function()
		st.auto = false
		pcall(st.rel)
		fn.dropSw()
		connections:disconnect()
		if type(st.regUi) == "function" then
			pcall(st.regUi)
		end
		fn.scan()
		st.auto = true
		if st.mode == "actor" then
			fn.actorWarm()
		end
		fn.notify("FNB", "Reloaded.", 4)
	end
})

scriptGroup:AddButton("Unload script", {
	Text = "Unload script",
	Func = function()
		if type(runtimeState.cleanup) == "function" then
			runtimeState.cleanup()
		end
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

fn.lowStr = function(v)
	if typeof(v) == "buffer" then
		local ok, s = pcall(buffer.tostring, v)
		if ok and type(s) == "string" then
			return s:lower()
		end
	elseif type(v) == "string" then
		return v:lower()
	elseif type(v) == "number" or type(v) == "boolean" then
		return tostring(v):lower()
	end
end

fn.hasToken = function(v, words, seen, depth)
	if depth > 4 then
		return false
	end
	local s = fn.lowStr(v)
	if s then
		for _, w in words do
			if s:find(w, 1, true) then
				return true
			end
		end
	end
	if type(v) ~= "table" then
		return false
	end
	seen = seen or {}
	if seen[v] then
		return false
	end
	seen[v] = true
	for k, val in v do
		if fn.hasToken(k, words, seen, depth + 1) or fn.hasToken(val, words, seen, depth + 1) then
			return true
		end
	end
	return false
end

fn.findHitPayload = function(v, seen, depth)
	if depth and depth > 5 then
		return nil
	end
	if type(v) == "table" then
		seen = seen or {}
		if seen[v] then
			return nil
		end
		seen[v] = true
		local lane = rawget(v, 1)
		local kind = rawget(v, 2)
		local stamp = rawget(v, 3)
		if (type(lane) == "string" or typeof(lane) == "EnumItem") and type(kind) == "number" and type(stamp) == "number" then
			return v
		end
		for _, val in v do
			local found = fn.findHitPayload(val, seen, (depth or 0) + 1)
			if found then
				return found
			end
		end
	end
	return nil
end

fn.isHitCall = function(args)
	local hasHit = false
	for _, v in args do
		if type(v) == "string" and v:lower() == "hit" then
			hasHit = true
			break
		end
	end
	if not hasHit then
		return false, nil
	end
	local payload = fn.findHitPayload(args, nil, 0)
	if not payload then
		return false, nil
	end
	return true, payload
end

fn.tablePack = function(...)
	local t = { ... }
	t.n = select("#", ...)
	return t
end

fn.gcList = function(includeTables)
	if typeof(getgc) ~= "function" then
		return {}
	end
	local ok, res = pcall(getgc, includeTables)
	if ok and type(res) == "table" then
		return res
	end
	return {}
end

fn.findNetworkClient = function()
	local okMod, net = pcall(function()
		return require(svc.rs:WaitForChild("Modules"):WaitForChild("Network"))
	end)
	if okMod and type(net) == "table" and type(rawget(net, "Client")) == "table" and type(rawget(rawget(net, "Client"), "Fire")) == "function" then
		return rawget(net, "Client"), "require"
	end
	for _, obj in fn.gcList(true) do
		if type(obj) == "table" then
			local client = rawget(obj, "Client")
			if type(client) == "table" and type(rawget(client, "Fire")) == "function" then
				return client, "getgc"
			end
			if type(rawget(obj, "Fire")) == "function" and type(rawget(obj, "Subscribe")) == "function" then
				return obj, "getgc"
			end
		end
	end
end

local netReplayBusy = false
patchNetworkFire = function()
	if gcState.netPatched then
		return true
	end
	local client, src = fn.findNetworkClient()
	if not client then
		fn.notify("Double Score", "Could not find Network.Client with require/getgc.", 6)
		return false
	end
	local fire = rawget(client, "Fire")
	if type(fire) ~= "function" then
		fn.notify("Double Score", "Network.Client.Fire is missing.", 6)
		return false
	end
	local function wrapped(oldFire, ...)
		if netReplayBusy or not st.dScore then
			return oldFire(...)
		end
		local args = { ... }
		local okHit, payload = fn.isHitCall(args)
		if not okHit or not payload or tonumber(payload[2]) ~= 0 then
			return oldFire(...)
		end
		local mult = math.clamp(math.floor(tonumber(st.scoreMult) or 2), 2, 50)
		netReplayBusy = true
		local ret = fn.tablePack(oldFire(...))
		if boostScoreValue then
			boostScoreValue(payload)
		end
		for _ = 2, mult do
			pcall(function()
				oldFire(table.unpack(args))
			end)
		end
		netReplayBusy = false
		return table.unpack(ret, 1, ret.n)
	end
	gcState.netClient = client
	gcState.netFire = fire
	gcState.netMode = src
	if cap.hookfunction then
		local oldFire
		local okHook, hookErr = pcall(function()
			oldFire = hookfunction(fire, function(...)
				return wrapped(oldFire, ...)
			end)
		end)
		if okHook and type(oldFire) == "function" then
			gcState.netOld = oldFire
			gcState.netPatched = true
			fn.notify("Double Score", "Hooked Network.Client.Fire through " .. tostring(src) .. ".", 4)
			return true
		end
		warn("[FNB] hookfunction failed for Network.Client.Fire: " .. tostring(hookErr))
	end
	local okSet = pcall(function()
		client.Fire = function(...)
			return wrapped(fire, ...)
		end
	end)
	if okSet then
		gcState.netOld = fire
		gcState.netPatched = true
		fn.notify("Double Score", "Wrapped Network.Client.Fire through " .. tostring(src) .. ".", 4)
		return true
	end
	fn.notify("Double Score", "hookfunction is missing and direct wrap failed.", 6)
	return false
end

local timingKeys = {
	"Marvelous",
	"Sick",
	"Good",
	"Ok",
	"Bad"
}

fn.isTimingTable = function(t)
	if type(t) ~= "table" then
		return false
	end
	for _, key in timingKeys do
		if type(rawget(t, key)) ~= "number" then
			return false
		end
	end
	return true
end

fn.addTimingTable = function(t)
	if not fn.isTimingTable(t) or gcState.timingBase[t] then
		return
	end
	gcState.timing[#gcState.timing + 1] = t
	local base = {}
	for _, key in timingKeys do
		base[key] = rawget(t, key)
	end
	gcState.timingBase[t] = base
end

fn.findTimingTables = function()
	local okMod, mod = pcall(function()
		return require(svc.rs:WaitForChild("Modules"):WaitForChild("TimingWindows"))
	end)
	if okMod then
		fn.addTimingTable(mod)
	end
	for _, obj in fn.gcList(true) do
		fn.addTimingTable(obj)
	end
	return #gcState.timing
end

applyTimingWindows = function()
	fn.findTimingTables()
	local mult = st.gcTiming and math.clamp(tonumber(st.winMult) or 1, 1, 25) or 1
	for tbl, base in gcState.timingBase do
		if type(tbl) == "table" and type(base) == "table" then
			for _, key in timingKeys do
				if type(base[key]) == "number" then
					pcall(function()
						tbl[key] = base[key] * mult
					end)
				end
			end
		end
	end
	return #gcState.timing
end

gcScanReport = function()
	local total = 0
	local tables = 0
	local funcs = 0
	local network = 0
	local timing = 0
	local suspicious = 0
	local words = {
		"kick",
		"miss",
		"damage",
		"death",
		"anticheat",
		"inputcheck",
		"userinputasync"
	}
	for _, obj in fn.gcList(true) do
		total += 1
		local typ = type(obj)
		if typ == "table" then
			tables += 1
			if fn.isTimingTable(obj) then
				timing += 1
			end
			if type(rawget(obj, "Fire")) == "function" or type(rawget(obj, "Client")) == "table" then
				network += 1
			end
			if fn.hasToken(obj, words, nil, 0) then
				suspicious += 1
			end
		elseif typ == "function" then
			funcs += 1
		end
	end
	fn.notify("getgc scan", string.format("objects=%d | tables=%d | funcs=%d | network-ish=%d | timing=%d | watched=%d", total, tables, funcs, network, timing, suspicious), 8)
end

fn.ownScoreValue = function()
	local eng = st.matchEngine
	if not eng or not eng.Parent then
		local gui = PlayerGui:FindFirstChild("FNFEngine")
		eng = gui and gui:FindFirstChild("Engine")
	end
	if not eng then
		return nil
	end
	local stgObj = eng:FindFirstChild("Stage")
	local stage = stgObj and stgObj.Value
	local cfg = stage and stage:FindFirstChild("Config")
	if not cfg then
		return nil
	end
	local p1 = cfg:FindFirstChild("Player1")
	local own = p1 and p1.Value == Client and cfg:FindFirstChild("P1Points") or cfg:FindFirstChild("P2Points")
	if own and (own:IsA("NumberValue") or own:IsA("IntValue")) then
		return own
	end
end

fn.quotedBuf = function(v)
	local str = tostring(v or "")
	str = "\"" .. str:gsub("\\", "\\\\"):gsub("\"", "\\\"") .. "\""
	if type(buffer) == "table" and type(buffer.fromstring) == "function" then
		local ok, res = pcall(buffer.fromstring, str)
		if ok then
			return res
		end
	end
	return str
end

fn.rawBuf = function(v)
	local str = tostring(v or "")
	if type(buffer) == "table" and type(buffer.fromstring) == "function" then
		local ok, res = pcall(buffer.fromstring, str)
		if ok then
			return res
		end
	end
	return str
end

bumpBotScore = function(lane)
	if not st.botScoreFun then
		return
	end
	local base = math.clamp(math.floor(tonumber(st.botScoreBase) or 500), 50, 10000)
	local mult = math.clamp(math.floor(tonumber(st.botScoreMult) or 2), 1, 50)
	local score = math.floor(base * mult + 0.5)
	local rating = "Sick"
	local dir = tostring(lane or "Down")
	task.spawn(function()
		local ok, err = pcall(function()
			RF:InvokeServer("UserInputAsync" .. Client.Name, {
				fn.quotedBuf("Bot"),
				{
					fn.quotedBuf(rating),
					fn.rawBuf(score),
					fn.quotedBuf(dir)
				}
			})
		end)
		if not ok then
			fn.notify("Bot score RF", tostring(err), 4)
		end
	end)
end

fn.resetScoreState = function(v)
	scoreState.base = tonumber(v) or 0
	scoreState.hitGain = 0
	scoreState.shown = scoreState.base
	scoreState.lastKey = nil
	scoreState.lastTime = 0
end

applyScoreValue = function()
	local val = fn.ownScoreValue()
	if not val then
		return false
	end
	if scoreState.val ~= val then
		if typeof(scoreState.conn) == "RBXScriptConnection" then
			pcall(function()
				scoreState.conn:Disconnect()
			end)
		end
		scoreState.val = val
		fn.resetScoreState(val.Value)
		scoreState.conn = val.Changed:Connect(function(nv)
			if scoreState.busy then
				return
			end
			nv = tonumber(nv) or tonumber(val.Value) or 0
			if nv <= 0 or nv + 5 < scoreState.base then
				fn.resetScoreState(nv)
				return
			end
			local realBase = nv - (scoreState.hitGain * (math.clamp(math.floor(tonumber(st.scoreMult) or 2), 2, 50) - 1))
			if realBase > scoreState.base then
				scoreState.base = realBase
			end
			if st.dScore and st.scoreVal and scoreState.hitGain > 0 then
				task.defer(applyScoreValue)
			end
		end)
	end
	if not (st.dScore and st.scoreVal) then
		return true
	end
	local mult = math.clamp(math.floor(tonumber(st.scoreMult) or 2), 2, 50)
	local desired = math.floor(scoreState.base + scoreState.hitGain * (mult - 1) + 0.5)
	if desired > tonumber(val.Value) then
		scoreState.busy = true
		pcall(function()
			val.Value = desired
		end)
		scoreState.busy = false
		scoreState.shown = desired
	end
	return true
end

bindScoreValue = function()
	return applyScoreValue()
end

boostScoreValue = function(payload)
	if not (st.dScore and st.scoreVal) then
		return
	end
	if payload and tonumber(payload[2]) ~= 0 then
		return
	end
	if payload then
		local key = tostring(payload[1]) .. "|" .. tostring(payload[3]) .. "|" .. tostring(payload[6])
		local now = tick()
		if scoreState.lastKey == key and now - scoreState.lastTime < 0.75 then
			return
		end
		scoreState.lastKey = key
		scoreState.lastTime = now
	end
	local val = fn.ownScoreValue()
	if not val then
		return
	end
	if scoreState.val ~= val then
		applyScoreValue()
	end
	local cur = tonumber(val.Value) or 0
	local mult = math.clamp(math.floor(tonumber(st.scoreMult) or 2), 2, 50)
	local bonus = scoreState.hitGain * (mult - 1)
	local realBase = cur - bonus
	if realBase > scoreState.base then
		scoreState.base = realBase
	end
	local gain = math.clamp(math.floor(tonumber(st.scoreBase) or 500), 50, 10000)
	if cur <= scoreState.shown and realBase <= scoreState.base + 1 then
		scoreState.base = scoreState.base + gain
	else
		scoreState.base = math.max(scoreState.base, realBase)
	end
	scoreState.hitGain = scoreState.hitGain + gain
	task.defer(applyScoreValue)
	task.delay(0.05, applyScoreValue)
	task.delay(0.15, applyScoreValue)
end

runtimeState.gcClean = function()
	if gcState.netPatched and gcState.netClient and gcState.netOld then
		pcall(function()
			if cap.restorefunction and gcState.netFire then
				restorefunction(gcState.netFire)
			elseif type(gcState.netClient) == "table" then
				gcState.netClient.Fire = gcState.netOld
			end
		end)
	end
	gcState.netPatched = false
	if typeof(scoreState.conn) == "RBXScriptConnection" then
		pcall(function()
			scoreState.conn:Disconnect()
		end)
	end
	scoreState.conn = nil
	scoreState.val = nil
	for tbl, base in gcState.timingBase do
		if type(tbl) == "table" and type(base) == "table" then
			for _, key in timingKeys do
				pcall(function()
					tbl[key] = base[key]
				end)
			end
		end
	end
end

local scoreReplayBusy = false
fn.replayScoreHits = function(oldNamecall, self, method, args)
	if scoreReplayBusy or not st.dScore then
		return false
	end
	local okHit, payload = fn.isHitCall(args)
	if not okHit then
		return false
	end
	if payload and tonumber(payload[2]) ~= 0 then
		return false
	end
	local mult = math.clamp(math.floor(tonumber(st.scoreMult) or 2), 2, 50)
	local extra = mult - 1
	if extra <= 0 then
		return false
	end
	scoreReplayBusy = true
	local ret = table.pack(oldNamecall(self, table.unpack(args)))
	if boostScoreValue then
		boostScoreValue(payload)
	end
	for _ = 1, extra do
		pcall(function()
			oldNamecall(self, table.unpack(args))
		end)
	end
	scoreReplayBusy = false
	return true, table.unpack(ret, 1, ret.n)
end

fn.patchStatsPayload = function(args)
	if not st.aStat then
		return args
	end
	for _, v in args do
		if type(v) == "table" then
			if v.misses ~= nil then
				v.misses = 0
			end
			if v.accuracy ~= nil then
				v.accuracy = 100
			end
			if v.bot ~= nil then
				v.bot = false
			end
		end
	end
	return args
end

fn.reqok = function()
	return cap.namecall == true
end

fn.isExecCall = function()
	if not cap.checkcaller then
		return false
	end
	local ok, res = pcall(checkcaller)
	return ok and res == true
end

fn.notifyMissing = function(t, c)
	fn.notify(t, c, 7)
end

do
	local miss = false
	if not fn.reqok() then
		miss = true
		fn.notifyMissing("Missing requirement", "hookmetamethod/newcclosure/getnamecallmethod")
	end
	if miss then
		fn.notifyMissing("FNB Autoplayer", "One or more requirements are missing; functionality may be limited.")
	end
end

do
	if fn.reqok() then

		-- local oldIndex
		local oldNamecall
		-- oldIndex = hookmetamethod(game, "__index", function(self, m)
		-- 	if not checkcaller() and self == Client and typeof(m) == "string" and m:lower() == "kick" then
		-- 		return error("Expected ':' not '.' calling member function Kick", 2)
		-- 	end
		-- 	return oldIndex(self, m)
		-- end)
		local okNamecall, namecallErr
		okNamecall, namecallErr = pcall(function()
			oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
			local l = (getnamecallmethod() or ""):lower()
			if not fn.isExecCall() then
				if st.aKick and self == Client and l == "kick" then
					return
				end
				if typeof(self) == "Instance" and (l == "fireserver" or l == "invokeserver") then
					local name = tostring(self.Name)
					local low = name:lower()
					local args = { ... }
					local scoreDone, r1, r2, r3, r4, r5 = fn.replayScoreHits(oldNamecall, self, l, args)
					if scoreDone then
						return r1, r2, r3, r4, r5
					end
					if st.aRemote and (low:find("userinputasync", 1, true) or low == "inputcheck" or low == "ac" or low == "anticheat") then
						return
					end
					if st.aDmg and (low == "takedamage" or low == "damage" or low == "damageplayer" or fn.hasToken(args, { "takedamage", "damageplayer" }, nil, 0)) then
						return
					end
					if st.aDead and fn.hasToken(args, { "death", "dead", "kill", "health=0" }, nil, 0) then
						return
					end
					if st.aMiss and fn.hasToken(args, { "miss", "onmiss", "missed" }, nil, 0) then
						return
					end
					if st.aStat and (low == "updatedata" or low == "stats" or low == "score") then
						fn.patchStatsPayload(args)
						return oldNamecall(self, table.unpack(args))
					end
				end
			end
			return oldNamecall(self, ...)
		end))
		end)
		if not okNamecall then
			warn("[FNB] hookmetamethod failed: " .. tostring(namecallErr))
		end
	end
end

task.defer(function()
	if st.gcScore and patchNetworkFire then
		patchNetworkFire()
	end
	if applyTimingWindows then
		applyTimingWindows()
	end
	if bindScoreValue then
		bindScoreValue()
	end
end)

st.onAdd = function(Object)
	pcall(st.rel)
	if not Object or Object.Name ~= "FNFEngine" then
		fn.scan()
		return
	end
	local Engine = Object.Engine
	local function IsOnHit(m)
		if m == nil then
			return false
		end

		local typ = m:GetAttribute("Type")
		if typ == "OnHit" then
			return true
		end
		if typ == "OnMiss" then
			return false
		end

		local v = m:FindFirstChild("Type")
		if v and v:IsA("StringValue") then
			return v.Value == "OnHit"
		end

		return false
	end
	local function Filter(iter, fn)
		local t = {}
		for _, v in iter do
			local res = fn(v)
			if res ~= nil then
				t[#t + 1] = res
			end
		end
		return t
	end
	local Stage = Object.Engine.Stage.Value
	while not Stage.Config.Song.Value do
		Object.Engine.Config.TimePast.Changed:Wait()
	end
	local Song = Stage.Config.Song.Value
	st.matchEngine = Engine
	if bindScoreValue then
		bindScoreValue()
	end
	fn.syncLullabyPurge(Engine)
	local PoisonNotes
	local scrollSpeed = fn.getActiveScrollSpeed(Song)
	local baseOffset = fn.calcOff(scrollSpeed)
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
	for kn, kv in Map do
		local bindObj = Keybinds[kv]
		local bindValue = fn.resolveKeyName(bindObj and bindObj.Value or kv)
		local code = fn.safeKeyCode(bindValue) or Enum.KeyCode.Space
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
		local vim = fn.getVim()
		if vim then
			vim:SendKeyEvent(isDown, keyCode, false, nil)
		end
	end

	local function pressLane(name, keyCode)
		if st.inMode == "firesignal" then
			fn.pressMob(mobCont, name)
			return
		end
		if st.mode == "actor" then
			if not fn.actorKey("press", keyCode) then
				sendLaneKey(true, keyCode)
			end
			return
		end
		sendLaneKey(true, keyCode)
	end

	local function releaseLane(name, keyCode)
		if st.inMode == "firesignal" then
			fn.relMob(mobCont, name)
			return
		end
		if st.mode == "actor" then
			if not fn.actorKey("release", keyCode) then
				sendLaneKey(false, keyCode)
			end
			return
		end
		sendLaneKey(false, keyCode)
	end

	local laneDown = {}
	local laneCount = {}

	st.rel = function()
		for holderName, down in laneDown do
			if down then
				local code = Session[holderName]
				if code then
					releaseLane(holderName, code)
				end
				laneDown[holderName] = false
			end
		end
		for k in laneCount do
			laneCount[k] = 0
		end
	end

	local lower = Object.Engine:FindFirstChild("LowerContainer")
	local credit = lower and lower:FindFirstChild("Credit")
	local psVal = Object.Engine:FindFirstChild("PlayerSide")
	if credit then
		connections:add(credit:GetPropertyChangedSignal("Text"), fn.scan)
	end
	if psVal then
		connections:add(psVal.Changed, fn.scan)
	end
	fn.scan()

	local AutoCtx = {
		enabled = true,
		offsetMs = st.off,
		baseOffset = baseOffset,
		tapMs = st.tapMs,
		relMs = st.relMs,
		holdTick = st.holdTick,
		maxHold = st.maxHold,
		laneDown = laneDown,
		laneCount = laneCount,
		press = pressLane,
		release = releaseLane,
		botScore = bumpBotScore
	}

	connections:add(Input.ScrollSpeed.Changed, function()
		local newValue = fn.clampSpeed(Input.ScrollSpeed.Value)
		fn.syncSlider(newValue)
	end)

	for _, Holder in IncomingNotes do
		connections:add(Holder.ChildAdded, function(Arrow)
			task.defer(function()
				if not Arrow or not Arrow.Visible then
					return
				end
				local arrowName = tostring(Arrow.Name or "")
				local isOrange = arrowName:find("_OrangeNote", 1, true) ~= nil
				if not st.hitPoison and Arrow:FindFirstChild("HellNote") and Arrow.HellNote.Value and PoisonNotes and not isOrange then
					return
				end
				if not st.hitOnHit and not isOrange and IsOnHit(Arrow:FindFirstChildOfClass("ModuleScript")) then
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
				AutoCtx.tapMs = st.tapMs
				AutoCtx.relMs = st.relMs
				AutoCtx.holdTick = st.holdTick
				AutoCtx.maxHold = st.maxHold
				AutoCtx.baseOffset = fn.calcOff(fn.getActiveScrollSpeed(Song))
				fn.playSeq(Holder, Arrow, keyCode, AutoCtx)
			end)
		end)
	end
end

st.regUi = function()
	connections:add(svc.run.Heartbeat, fn.forceLastInput)
	fn.forceLastInput()
	connections:add(Client.CharacterAdded, function(char)
		task.spawn(function()
			local humanoid = char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10))
			if humanoid and st.aDead then
				fn.applyAd(humanoid)
			end
		end)
	end)
	connections:add(svc.run.RenderStepped, function()
		if not st.aDead then
			return
		end
		fn.applyAd(fn.getHum())
	end)
	if svc.run.PreSimulation then
		connections:add(svc.run.PreSimulation, function()
			if not st.aDead then
				return
			end
			local humanoid = fn.getHum()
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
		local humanoid = fn.getHum()
		if humanoid and humanoid.Health < humanoid.MaxHealth then
			pcall(function()
				humanoid.Health = humanoid.MaxHealth
			end)
		end
	end)
	connections:add(PlayerGui.ChildAdded, function(o)
		task.defer(function()
			if o and o.Name == "FNFEngine" then
				fn.applyModsForEngine(o)
			end
			if o and o.Name == "GameUI" then
				fn.bindSw()
				fn.watchSongSel(o)
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
			pcall(st.rel)
			st.matchEngine = nil
			fn.resetScoreState(0)
			fn.syncLullabyPurge(nil)
			fn.scan()
		end
		if o and o.Name == "GameUI" then
			fn.dropSw()
			fn.clearSongWatch()
		end
	end)
	connections:add(PlayerGui.DescendantAdded, function(o)
		task.defer(function()
			if o and o.Name == "TakeDamage" and o.Parent and o.Parent.Name == "Engine" then
				fn.killTd(o)
			end
		end)
	end)
	connections:add(workspace.DescendantAdded, function(o)
		if o and o.ClassName == "ProximityPrompt" then
			pcall(function()
				o.HoldDuration = 0
			end)
		end
	end)
	local existingEngine = PlayerGui:FindFirstChild("FNFEngine")
	if existingEngine then
		fn.applyModsForEngine(existingEngine)
		local engine = existingEngine:FindFirstChild("Engine")
		if engine then
			for _, td in fn.getDesc(engine) do
				fn.killTd(td)
			end
			local td = engine:FindFirstChild("TakeDamage")
			if td then
				fn.killTd(td)
			end
		end
		task.spawn(function()
			st.onAdd(existingEngine)
		end)
	end
	local existingGameUI = PlayerGui:FindFirstChild("GameUI")
	if existingGameUI then
		fn.bindSw()
		fn.watchSongSel(existingGameUI)
	end
	if st.aDead then
		task.spawn(function()
			local humanoid = fn.getHum()
			if humanoid then
				fn.applyAd(humanoid)
			end
		end)
	end
end

st.regUi()
fn.scan()

for _, v in fn.getDesc(workspace) do
	if v.ClassName == "ProximityPrompt" then
		pcall(function()
			v.HoldDuration = 0
		end)
	end
end

do
	local v = fn.resolveKeyName(Keybinds.R4 and Keybinds.R4.Value)
	if v == "Semicolon" then
		RE:FireServer("REMOTE_EVENT", {
			buffer.fromstring("\"Input\""),
			buffer.fromstring("\"Semicolon\""),
			buffer.fromstring("\"R4\"")
		})
	end
end
