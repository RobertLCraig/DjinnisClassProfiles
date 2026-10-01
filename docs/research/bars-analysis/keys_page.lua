-- Card 0082. Rob, 2026-10-01: "can you build me a page showing all classes and
-- specs and what buttons you propose to put where?"
--
-- Writes docs/research/2026-10-01-keys-for-every-class.html from the addon's
-- own tables (BAR_CATEGORIES, BAR_ABILITIES, JOB_BUTTONS, JOB_SPEC), so the
-- page shows what the addon would do. Rob's keys come from a copy of the
-- SavedVariables in %TEMP% (sv-dcp.lua), never the game folder.
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
local sv = os.getenv("TEMP") .. "\\sv-dcp.lua"
DjinnisCPDB = nil
dofile(sv)
local keyOf = {}
for key, binding in pairs(DjinnisCPDB.bars["Feral / Dungeon"].keys or {}) do
	local nice = key:gsub("SHIFT%-", "Shift+"):gsub("ALT%-", "Alt+"):gsub("CTRL%-", "Ctrl+"):gsub("NUMPAD", "Num")
	if not keyOf[binding] or #nice < #keyOf[binding] then keyOf[binding] = nice end
end

local CLASS = { "Warrior", "Paladin", "Hunter", "Rogue", "Priest", "Death Knight", "Shaman", "Mage", "Warlock", "Monk", "Druid",
	"Demon Hunter", "Evoker" }
local ROLE_TEMPLATE = { TANK = "Guardian", HEALER = "Resto" }

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

-- Guardian's own keys whose reason was Rob's druid habit, not tanking: shown
-- for review on every other tank.
local REVIEW = {
	["Combat 6"] = "Guardian put Moonfire on T because Feral has Moonfire on T. T is a stretch key.",
	["Combat 1"] = "Guardian's main builder (Mangle) is on 4 because of Rob's habit.",
	["Combat 2"] = "Guardian's Thrash is on 1 because Feral's bleed (Rake) is on 1.",
	["Combat 11"] = "Guardian put Sundering Roar on 2 because Rob's builds already did.",
	["Combat 10"] = "Guardian put Convoke on Shift+Q because Growl took its key.",
}

local esc = function(s) return (tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;")) end

-- the rows: every binding a job can have, in bar order
local BAR_ORDER = { { "ACTIONBUTTON", "Bar 1" }, { "MULTIACTIONBAR6BUTTON", "Bar 7" }, { "MULTIACTIONBAR3BUTTON", "Bar 4" },
	{ "MULTIACTIONBAR4BUTTON", "Bar 5" } }

local extras = {}
local bellular = {}
for _, job in ipairs(PlanTab.BAR_CATEGORIES) do bellular[job] = true end
for job in pairs(PlanTab.JOB_BUTTONS) do if not bellular[job] then extras[#extras + 1] = job end end
table.sort(extras)

-- one spec: binding -> { spell, job, source, note }, the jobs with no key, clashes
local function plan(spec, class)
	local own, source, template = rules(spec, class)
	local column = PlanTab.BAR_ABILITIES[spec] or {}
	local cells, nokey, clash = {}, {}, {}
	local function put(job, spell)
		local b = own[job]
		local src = b and source or "base"
		if b == "" then b = nil end
		if own[job] == nil then b = PlanTab.JOB_BUTTONS[job] end
		if not b then nokey[#nokey + 1] = { job = job, spell = spell } return end
		local note = (src == "role" and template == "Guardian" and REVIEW[job]) or nil
		if cells[b] then clash[#clash + 1] = ("%s and %s on %s"):format(cells[b].spell, spell, keyOf[b] or b) end
		cells[b] = { spell = spell, job = job, source = src, note = note }
	end
	for i, job in ipairs(PlanTab.BAR_CATEGORIES) do
		if (column[i] or "") ~= "" then put(job, column[i]) end
	end
	if class == PlanTab.DRUID then
		for _, job in ipairs(extras) do put(job, job) end  -- Rob's own druid extras and items
	else
		for _, job in ipairs({ "Healthstone", "Damage Potion" }) do put(job, job) end  -- any class can use these
	end
	return cells, nokey, clash
end

-- the specs, by class
local byClass, order = {}, {}
for _, s in ipairs(PlanTab.SPECS) do
	local id, name, class, role = s[1], s[2], s[3], s[4]
	if PlanTab.BAR_ABILITIES[name] then
		if not byClass[class] then byClass[class] = {} order[#order + 1] = class end
		table.insert(byClass[class], { name = name, role = role })
	end
end
table.sort(order, function(a, b) return (CLASS[a] or "") < (CLASS[b] or "") end)
-- druids first: their keys are agreed, the rest follow them
for i, c in ipairs(order) do if c == PlanTab.DRUID then table.remove(order, i) table.insert(order, 1, c) break end end

local out = {}
local function w(s) out[#out + 1] = s end
w([[<!doctype html><html lang="en"><head><meta charset="utf-8"><title>Keys for every class and spec</title>
<style>
body{font-family:Segoe UI,Arial,sans-serif;background:#16181d;color:#e6e6e6;margin:24px;line-height:1.45}
h1{font-size:24px;margin:0 0 4px} h2{font-size:20px;margin:36px 0 8px;border-bottom:1px solid #444;padding-bottom:4px}
p,li{max-width:900px} .small{color:#aaa;font-size:13px}
table{border-collapse:collapse;margin:8px 0 4px;font-size:13px}
th,td{border:1px solid #3a3d45;padding:4px 8px;text-align:left;vertical-align:top}
th{background:#23262e;position:sticky;top:0} td.key{font-weight:600;white-space:nowrap;background:#1d2026}
td.bar{color:#888;white-space:nowrap}
.base{color:#e6e6e6} .role{color:#7cc8ff} .druid{color:#8ee08e} .review{background:#3a2e12}
.none{color:#555} .clash{color:#ff7070;font-weight:600}
.legend span{display:inline-block;margin-right:18px}
details{margin:4px 0 0} summary{cursor:pointer;color:#bbb;font-size:13px}
</style></head><body>]])
w("<h1>Keys for every class and spec</h1>")
w('<p class="small">Card 0082. Built ' .. os.date("%Y-%m-%d %H:%M") .. " from the addon's own tables (DjinnisClassProfiles " ..
	esc((io.open(here .. "/DjinnisClassProfiles.toc"):read("*a"):match("## Version: (%S+)") or "?")) ..
	") and Rob's key bindings. The script is <code>docs/research/bars-analysis/keys_page.lua</code>.</p>")
w([[<h2>How to read this</h2>
<ul>
<li>Each table is one class. A row is one key. A column is one spec. The cell is the spell that goes on that key.</li>
<li>The jobs come from Bellular's planner. A job is a kind of spell, for example "Interrupt" or "Combat 1" (the main filler).</li>
<li>Your keys are the same in every spec, so "one job, one key" means each kind of spell is always on the same key.</li>
</ul>
<p class="legend"><span class="base">White: Feral's key (the model)</span><span class="role">Blue: moved for the role (casters, healers, tanks)</span><span class="druid">Green: a druid spec's own key, agreed with Rob</span><span class="review">&nbsp;Brown: a druid habit copied to another tank. Review it&nbsp;</span></p>
<h2>The rules used</h2>
<ul>
<li><b>Druid specs:</b> the keys agreed so far (Feral is the model; Balance and Resto keep Sunfire 1, Moonfire 2, Wrath 3, Starfire 4; Guardian's own keys from 2026-10-01).</li>
<li><b>Melee damage</b> (every other class): Feral's keys.</li>
<li><b>Ranged damage and healers:</b> Feral's keys, but Combat 1 to 4 sit where Balance and Resto have them (3, 4, 2, 1), and Combat 7 on Alt+3.</li>
<li><b>Tanks:</b> Guardian's keys, but not Prowl on Shift+3 (a druid's stealth). The taunt goes on Alt+2.</li>
<li><b>Healthstone and the damage potion</b> are on the same key for every class.</li>
</ul>
<h2>The case against, before you read the tables</h2>
<ul>
<li><b>Casters' 1 to 4 are copied from Balance.</b> Balance keeps Sunfire 1, Moonfire 2, Wrath 3, Starfire 4 because your hands know those. For a Fire Mage that means Scorch 1, Pyroblast 2, Fireball 3, Fire Blast 4. That order has no reason of its own. The other way: Combat 1 to 4 on keys 1 to 4 in order for every non-druid caster.</li>
<li><b>Tanks copy Guardian, and some Guardian keys are your druid habits</b> (shown brown). The worst one: Combat 6 on T. For a Brewmaster that is Purifying Brew, and for a Protection Warrior Ignore Pain. Both are pressed often, and T is a stretch key.</li>
<li><b>Many jobs have no key yet.</b> Your Feral bars never needed them (for example a dispel, a second crowd control, a raid defensive). Each spec lists them under "No key yet". They need keys before a healer or a caster can use this plan.</li>
<li><b>Bellular's "Combat" numbers mean different things in each class.</b> So the rotation rows only line up roughly. The rows below the rotation (interrupt, movement, defensives, taunt) line up exactly, and they matter most.</li>
</ul>]])

local CLASH_TOTAL = 0
for _, class in ipairs(order) do
	local specs = byClass[class]
	w("<h2>" .. esc(CLASS[class] or ("class " .. class)) .. "</h2>")
	local plans, used = {}, {}
	for i, s in ipairs(specs) do
		local cells, nokey, clash = plan(s.name, class)
		plans[i] = { cells = cells, nokey = nokey, clash = clash }
		for b in pairs(cells) do used[b] = true end
		CLASH_TOTAL = CLASH_TOTAL + #clash
	end
	w("<table><tr><th>Bar</th><th>Key</th>")
	for _, s in ipairs(specs) do w("<th>" .. esc(s.name) .. "<br><span class=\"small\">" .. esc(s.role:lower()) .. "</span></th>") end
	w("</tr>")
	for _, bar in ipairs(BAR_ORDER) do
		for n = 1, 12 do
			local b = bar[1] .. n
			if used[b] then
				w("<tr><td class=\"bar\">" .. bar[2] .. " #" .. n .. "</td><td class=\"key\">" .. esc(keyOf[b] or "no key") .. "</td>")
				for i in ipairs(specs) do
					local c = plans[i].cells[b]
					if c then
						local cls = c.note and (c.source .. " review") or c.source
						local title = c.job .. (c.note and (". " .. c.note) or "")
						w("<td class=\"" .. cls .. "\" title=\"" .. esc(title) .. "\">" .. esc(c.spell) .. "</td>")
					else
						w("<td class=\"none\">-</td>")
					end
				end
				w("</tr>")
			end
		end
	end
	w("</table>")
	for i, s in ipairs(specs) do
		local p = plans[i]
		for _, c in ipairs(p.clash) do w("<p class=\"clash\">" .. esc(s.name) .. ": two spells on one key: " .. esc(c) .. "</p>") end
		if #p.nokey > 0 then
			local list = {}
			for _, x in ipairs(p.nokey) do list[#list + 1] = esc(x.spell) .. " <span class=\"small\">(" .. esc(x.job) .. ")</span>" end
			w("<details><summary>" .. esc(s.name) .. ": no key yet for " .. #p.nokey .. "</summary><p>" .. table.concat(list, ", ") .. "</p></details>")
		end
	end
end
w("</body></html>")

local path = here .. "/docs/research/2026-10-01-keys-for-every-class.html"
local f = assert(io.open(path, "w"))
f:write(table.concat(out, "\n"))
f:close()
io.write(("wrote %s: %d classes, %d clashes\n"):format(path, #order, CLASH_TOTAL))
