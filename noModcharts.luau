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

local ReplicatedStorage = __lt.cs("ReplicatedStorage", cloneref);
(require(ReplicatedStorage.Modules.Util)).ModchartCheck = function()
end;
