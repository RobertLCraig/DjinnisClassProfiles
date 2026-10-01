-- Card 0082. Rob, 2026-10-01: "can you build me a page showing all classes and
-- specs and what buttons you propose to put where?", then "I was more hoping
-- for a more visual representation".
--
-- Writes keys_data.json next to this script from the addon's own tables
-- (BAR_CATEGORIES, BAR_ABILITIES, JOB_BUTTONS, JOB_SPEC), so the page shows
-- what the addon would do. build_keys_page.py turns it into the page. Rob's
-- keys and his Clique binds come from copies of the SavedVariables in %TEMP%
-- (sv-dcp.lua, sv-clique.lua), never the game folder.
--
-- Run from the addon folder with Lua 5.1:
--   lua docs/research/bars-analysis/keys_page.lua
--
-- The druid specs use the keys built and agreed so far. Every other spec uses
-- the proposal (Rob has not picked it yet): its role's druid spec, without
-- the choices whose reason only holds for a druid.

local here = "."
arg = { [0] = here .. "/offline-check.lua", "103" }  -- load as Feral, skip the self-test run
local keptPrint, keptExit = print, os.exit
print = function() end
os.exit = function() error("offline-check finished", 0) end  -- it ends the program; this script goes on
pcall(dofile, here .. "/offline-check.lua")
print, os.exit = keptPrint, keptExit

local PlanTab
for i = 1, 80 do
	local name, value = debug.getupvalue(SlashCmdList.DJINNISCP, i)
	if not name then break end
	if name == "PlanTab" then PlanTab = value end
end
assert(PlanTab, "PlanTab not reachable")

-- Rob's bindings: binding name -> key, read off Feral / Dungeon
DjinnisCPDB = nil
dofile(os.getenv("TEMP") .. "\\sv-dcp.lua")
local keyOf = {}
for key, binding in pairs(DjinnisCPDB.bars["Feral / Dungeon"].keys or {}) do
	local nice = key:gsub("SHIFT%-", "Shift+"):gsub("ALT%-", "Alt+"):gsub("CTRL%-", "Ctrl+"):gsub("NUMPAD", "Num")
	if not keyOf[binding] or #nice < #keyOf[binding] then keyOf[binding] = nice end
end

-- Rob's Clique profiles, one per healing class (read 2026-10-01)
CliqueDB3 = nil
dofile(os.getenv("TEMP") .. "\\sv-clique.lua")
local CLIQUE_PROFILE = { [11] = "Djinni - Bloodfeather", [5] = "Djcloud - Shadowsong", [10] = "Zuhlah - Silvermoon",
	[2] = "Loamint - Moonglade", [7] = "Shortnbitter - Aggra (Português)" }

local CLASS = { "Warrior", "Paladin", "Hunter", "Rogue", "Priest", "Death Knight", "Shaman", "Mage", "Warlock", "Monk", "Druid",
	"Demon Hunter", "Evoker" }

-- The proposal for a spec that is not a druid's: the jobs its role's druid
-- spec moved off Feral's keys, less those moved for a druid-only reason.
local DRUID_ONLY = { Guardian = { ["Class 7 (Raid Defensive)"] = "Prowl, a druid's stealth" } }
local function rules(spec, class)
	if class == PlanTab.DRUID then return PlanTab.JOB_SPEC[spec] or {}, "druid" end
	local template = PlanTab.templateFor(spec)
	if template == "Feral" or not template then return {}, "role" end
	local out = {}
	for job, b in pairs(PlanTab.JOB_SPEC[template] or {}) do
		if not (DRUID_ONLY[template] or {})[job] then out[job] = b end
	end
	return out, "role", template
end

-- Guardian's own keys whose reason was Rob's druid habit, not tanking.
local REVIEW = {
	["Combat 6"] = "Guardian put Moonfire on T because Feral has Moonfire on T. T is a stretch key.",
	["Combat 1"] = "Guardian's main builder (Mangle) is on 4 because of Rob's habit.",
	["Combat 2"] = "Guardian's Thrash is on 1 because Feral's bleed (Rake) is on 1.",
	["Combat 11"] = "Guardian put Sundering Roar on 2 because Rob's builds already did.",
	["Combat 10"] = "Guardian put Convoke on Shift+Q because Growl took its key.",
}
-- Rob, 2026-10-01: "dispels and heals go on mouse buttons that are only
-- triggered on a unitframe hover (clique/click casting)"
local ON_CLIQUE = { ["Class 6 (Dispel)"] = true }

local extras, bellular = {}, {}
for _, job in ipairs(PlanTab.BAR_CATEGORIES) do bellular[job] = true end
for job in pairs(PlanTab.JOB_BUTTONS) do if not bellular[job] then extras[#extras + 1] = job end end
table.sort(extras)

local function plan(spec, class)
	local own, source, template = rules(spec, class)
	local column = PlanTab.BAR_ABILITIES[spec] or {}
	local cells, nokey, clique, clash = {}, {}, {}, {}
	local function put(job, spell)
		if ON_CLIQUE[job] then clique[#clique + 1] = { job = job, spell = spell, short = PlanTab.jobShort(job, spec) } return end
		local b = own[job]
		local src = b and source or "base"
		if b == "" then b = nil end
		if own[job] == nil then b = PlanTab.JOB_BUTTONS[job] end
		local short = PlanTab.jobShort(job, spec)
		if not b then nokey[#nokey + 1] = { job = job, spell = spell, short = short } return end
		local note = (src == "role" and template == "Guardian" and REVIEW[job]) or nil
		if cells[b] then clash[#clash + 1] = ("%s and %s on %s"):format(cells[b].spell, spell, keyOf[b] or b) end
		cells[b] = { spell = spell, job = job, short = short, source = src, note = note }
	end
	for i, job in ipairs(PlanTab.BAR_CATEGORIES) do
		if (column[i] or "") ~= "" then put(job, column[i]) end
	end
	if class == PlanTab.DRUID then
		for _, job in ipairs(extras) do put(job, job) end  -- Rob's own druid extras and items
	else
		for _, job in ipairs({ "Healthstone", "Damage Potion" }) do put(job, job) end  -- any class can use these
	end
	return cells, nokey, clique, clash
end

-- a tiny JSON writer
local function json(v)
	local t = type(v)
	if t == "nil" then return "null" end
	if t == "boolean" or t == "number" then return tostring(v) end
	if t == "string" then
		return '"' .. v:gsub('[%c"\\]', function(c) return ({ ['"'] = '\\"', ["\\"] = "\\\\", ["\n"] = "\\n" })[c] or ("\\u%04x"):format(c:byte()) end) .. '"'
	end
	if #v > 0 or next(v) == nil then
		local parts = {}
		for _, x in ipairs(v) do parts[#parts + 1] = json(x) end
		return "[" .. table.concat(parts, ",") .. "]"
	end
	local keys = {}
	for k in pairs(v) do keys[#keys + 1] = tostring(k) end
	table.sort(keys)
	local parts = {}
	for _, k in ipairs(keys) do parts[#parts + 1] = json(k) .. ":" .. json(v[k] ~= nil and v[k] or v[tonumber(k)]) end
	return "{" .. table.concat(parts, ",") .. "}"
end

local specs, clashes = {}, 0
for _, s in ipairs(PlanTab.SPECS) do
	local id, name, class, role = s[1], s[2], s[3], s[4]
	if PlanTab.BAR_ABILITIES[name] then
		local cells, nokey, clique, clash = plan(name, class)
		clashes = clashes + #clash
		specs[#specs + 1] = { id = id, spec = name, class = class, className = CLASS[class] or ("class " .. class), role = role,
			template = class ~= PlanTab.DRUID and PlanTab.templateFor(name) or nil, cells = cells, nokey = nokey, clique = clique, clash = clash }
	end
end

local cliqueOut = {}
for class, profile in pairs(CLIQUE_PROFILE) do
	local binds = {}
	for _, b in ipairs(((CliqueDB3.profiles or {})[profile] or {}).bindings or {}) do
		binds[#binds + 1] = { key = b.key, type = b.type, spell = b.spell }
	end
	cliqueOut[CLASS[class]] = { profile = profile, binds = binds }
end

local version = io.open(here .. "/DjinnisClassProfiles.toc"):read("*a"):match("## Version: (%S+)") or "?"
local data = { built = os.date("%Y-%m-%d %H:%M"), version = version, keys = keyOf, specs = specs, clique = cliqueOut }
local path = here .. "/docs/research/bars-analysis/keys_data.json"
local f = assert(io.open(path, "w"))
f:write(json(data))
f:close()
io.write(("wrote %s: %d specs, %d clashes\n"):format(path, #specs, clashes))
