--[[ Zyx Loader ]]--

local VERSION = "1.0"
local REPO = "https://raw.githubusercontent.com/cowbollocks87/Zyx/main/"

local GAMES = {
	[93978595733734] = "vd", -- Violence District
}

local FILES = {
	["shared/utils/Signal"] = "shared/utils/Signal.luau",
	["shared/utils/Trove"]  = "shared/utils/Trove.luau",
	["shared/ui"]           = "shared/ui/init.luau",
	["games/vd"]            = "games/vd/init.luau",
}

--================================================================--
-- VINSTANCE
--================================================================--

local vinstIsA = function(_, className)
	return className == "ModuleScript" or className == "Instance"
end

local vinstFindFirstChild = function(self, name)
	local children = rawget(self, "_children")
	return children and children[name] or nil
end

local VInstance = {}
VInstance.__index = function(self, key)
	if key == "Parent" then return rawget(self, "_parent") end
	if key == "Name" then return rawget(self, "_name") end
	if key == "ClassName" then return "ModuleScript" end
	if key == "IsA" then return vinstIsA end
	if key == "FindFirstChild" then return vinstFindFirstChild end
	local children = rawget(self, "_children")
	return children and children[key] or nil
end

local function newVInstance(name, parent)
	local self = setmetatable({
		_name = name,
		_parent = parent,
		_children = {},
		_source = nil,
	}, VInstance)
	if parent then
		parent._children[name] = self
	end
	return self
end

--================================================================--
-- TREE BUILDER
--================================================================--

local function buildTree(fileMap)
	local root = newVInstance("Zyx", nil)

	for path, source in fileMap do
		local parts = string.split(path, "/")
		local current = root
		for _, part in parts do
			if not current._children[part] then
				newVInstance(part, current)
			end
			current = current._children[part]
		end
		current._source = source
	end

	return root
end

--================================================================--
-- MODULE LOADER
--================================================================--

local root = buildTree(FILES)
local origRequire = require
local loaded = {}
local cache = {}

local function fetch(path)
	local url = REPO .. path
	local ok, result = pcall(game.HttpGet, game, url)
	if not ok then
		error("[Zyx] Failed to fetch " .. path .. ": " .. tostring(result), 2)
	end
	return result
end

local function customRequire(target)
	if type(target) == "table" and rawget(target, "_children") ~= nil then
		if loaded[target] then return cache[target] end

		if not target._source then
			error("[Zyx] No source for module '" .. (rawget(target, "_name") or "?") .. "'", 2)
		end

		local source = fetch(target._source)
		local fn, err = loadstring(source, "@" .. target._source)
		if not fn then
			error("[Zyx] Parse error in " .. target._source .. ": " .. tostring(err), 2)
		end

		local env = setmetatable({
			script = target,
			require = customRequire,
		}, { __index = getfenv(0) })
		setfenv(fn, env)

		local result = fn()
		loaded[target] = true
		cache[target] = result
		return result
	end

	return origRequire(target)
end

--================================================================--
-- BOOTSTRAP
--================================================================--

print("[Zyx] v" .. VERSION)

local placeId = game.PlaceId
local gameName = GAMES[placeId]

if not gameName then
	warn("[Zyx] PlaceId " .. tostring(placeId) .. " is not supported")
	return
end

local gameModule = root._children.games and root._children.games._children[gameName]
if not gameModule then
	warn("[Zyx] No module registered for '" .. gameName .. "'")
	return
end

print("[Zyx] Loading " .. gameName .. " (PlaceId " .. tostring(placeId) .. ")")
customRequire(gameModule)
print("[Zyx] Loaded")
