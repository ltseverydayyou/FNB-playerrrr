if not game:IsLoaded() then
	game.Loaded:Wait()
end

local env = getgenv()
local id = "__AnimeFanHook"
local st = rawget(env, id)

if st and st.on then
	return
end

st = st or {}
st.on = false
st.made = st.made == true
st.hooks = st.hooks or {}
rawset(env, id, st)

local req = {
	hookmetamethod,
	hookfunction,
	checkcaller,
	getnamecallmethod,
	getcallingscript,
}

for i = 1, #req do
	if type(req[i]) ~= "function" then
		env.IsAnimeFanUnsupported = true
		return
	end
end

local svc = "VirtualInputManager"
local oldNc
local oldIdx
local oldNew

local find = {
	findservice = true,
	findfirstchild = true,
	findfirstchildofclass = true,
	findfirstchildwhichisa = true,
}

local make = {
	getservice = true,
	service = true,
}

local fList = {
	"FindService",
	"FindFirstChild",
	"findFirstChild",
	"FindFirstChildOfClass",
	"findFirstChildOfClass",
	"FindFirstChildWhichIsA",
	"findFirstChildWhichIsA",
}

local mList = {
	"GetService",
	"getService",
	"service",
}

local function callScr()
	local ok, scr = pcall(getcallingscript)
	if ok then
		return scr
	end
end

local function isHum(x)
	local ok, res = pcall(function()
		return typeof(x) == "Instance" and x:IsA("Humanoid")
	end)

	return ok and res
end

local function getFn(k)
	local ok, fn = pcall(function()
		return game[k]
	end)

	if ok and type(fn) == "function" then
		return fn
	end
end

local function hookFn(k, mode)
	if st.hooks[k] then
		return
	end

	local fn = getFn(k)
	if not fn then
		return
	end

	local old
	old = hookfunction(fn, function(self, a, ...)
		if not checkcaller() and self == game and a == svc then
			if mode == "find" and not st.made then
				return nil
			end

			if mode == "make" then
				st.made = true
			end
		end

		return old(self, a, ...)
	end)

	st.hooks[k] = old
end

local hasVim = type(rawget(env, "getvirtualinputmanager")) == "function" or type(getvirtualinputmanager) == "function"

if not hasVim then
	oldNc = hookmetamethod(game, "__namecall", function(self, a, ...)
		if not checkcaller() and self == game and a == svc then
			local m = getnamecallmethod()
			m = type(m) == "string" and m:lower() or ""

			if find[m] and not st.made then
				return nil
			end

			if make[m] then
				st.made = true
			end
		end

		return oldNc(self, a, ...)
	end)

	oldIdx = hookmetamethod(game, "__index", function(self, k)
		if not checkcaller() and self == game and k == svc then
			st.made = true
		end

		return oldIdx(self, k)
	end)

	for i = 1, #fList do
		hookFn(fList[i], "find")
	end

	for i = 1, #mList do
		hookFn(mList[i], "make")
	end
end

oldNew = hookmetamethod(game, "__newindex", function(self, k, v)
	if not checkcaller() and k == "Health" and isHum(self) then
		local scr = callScr()

		if scr and scr.Name == "Client" then
			return
		end
	end

	return oldNew(self, k, v)
end)

st.on = true
env.IsAnimeFan = true
env.IsAnimeFanUnsupported = nil