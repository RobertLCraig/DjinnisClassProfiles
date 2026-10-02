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
-- triggered on a unitframe hover (clique/click casting)". Only a real
-- dispel: Bellular's "Class 6" holds Path of Frost for a Death Knight and
-- Imprison for a Demon Hunter, and Rob took Path of Frost off the wheel.
local DISPELS = {}
for _, n in ipairs({ "Remove Corruption", "Nature's Cure", "Purify", "Purify Disease", "Cleanse", "Cleanse Toxins", "Detox",
	"Cleanse Spirit", "Purify Spirit", "Remove Curse", "Expunge", "Naturalize" }) do DISPELS[n] = true end

-- Bellular's own sheet swaps its Buff and Res rows for these classes (its
-- Priest sheet: Buff "Res", Res "Power Word: Fortitude"). Rob moved Arcane
-- Intellect from the Res key (Alt+G) to Num1, the Buff key.
-- The rows hold other things too: a warlock's are Demonic Circle and its
-- Teleport. So each row's spell is sorted by what it is, not by the row.
local BUFF, RES = 33, 34
local IS_BUFF = { ["Battle Shout"] = true, ["Weapon Buffs"] = true, Poisons = true, ["Power Word: Fortitude"] = true,
	Skyfury = true, ["Arcane Intellect"] = true, ["Mark of the Wild"] = true, ["Blessing of the Bronze"] = true }
local IS_RES = { Res = true, Revive = true, ["Ancestral Spirit"] = true, ["Ancestral Vision"] = true, Return = true, ["Mass Return"] = true }
-- A class with no raid buff: its out-of-combat utility takes Num1 (Rob: Path
-- of Frost to Num1 on Blood, Spectral Sight to Num1 on Havoc and Devourer,
-- "warlock num 1 I typically have underwater breathing I think").
local NUM1_UTILITY = { [6] = "Path of Frost", [12] = "Spectral Sight", [9] = "Unending Breath" }
-- Rob, 2026-10-01: "need to do a beter job of distinguishing buffs from
-- teleports (monk has trancendance spells that work much the same as a
-- warlock demonic circle/gateway. these are not buffs that go on num1".
-- One pair of keys for a place-and-return teleport, the same in both classes:
-- setting the spot (out of combat) on Shift+2, the teleport (a movement
-- spell, like a druid's Wild Charge) on Alt+E. Both were free in both.
local TELEPORT = {
	-- Rob, 2026-10-01: "warlock teleport - yes", to Shift+V like the monk's
	["Demonic Circle"] = "MULTIACTIONBAR6BUTTON10", ["Demonic Circle: Teleport"] = "MULTIACTIONBAR3BUTTON6",
	-- Rob, 2026-10-01: "on druid alt e is for charge, I feel like roll is more of
	-- a charge than a movement". A monk's Alt+E is Roll, so its teleport goes on
	-- Shift+V, where Bellular had it. The place spell: Shift+R, Bellular's key
	-- for Transcendence, since Shift+2 is the healing potion (below).
	Transcendence = "MULTIACTIONBAR6BUTTON10", ["Transcendence: Transfer"] = "MULTIACTIONBAR3BUTTON6",
}
-- Spells with a key set by name, for every spec that has them.
local SPELL_KEY = {
	-- Rob, 2026-10-01: "Shift 2 should be healing potion on all classes and
	-- specs, shift s healthstone (ideally I would like them on the same key,
	-- with healthstones being prioritised)". His Feral bars already do this.
	["Healing Potion"] = "MULTIACTIONBAR6BUTTON12",
	-- Demonic Circle took Banish's Shift+R: Banish goes where a Demon Hunter's
	-- Imprison is, Alt+R, the same job (one enemy out of the fight).
	Banish = "MULTIACTIONBAR6BUTTON4",
	-- The teleport took its Shift+V: the slow goes on Shift+A, a monk's Disable key
	["Curse of Exhaustion"] = "MULTIACTIONBAR6BUTTON11",
	-- Rob: "can you have both roll and flying serpent kick? I deffinately dont
	-- like that on num 1". Both, yes (not a choice node). C was free on Windwalker.
	["Flying Serpent Kick"] = "MULTIACTIONBAR3BUTTON3",
}
-- Rob put Havoc's Chaos Nova (Bellular's "CC") on Shift+W, the key a druid's
-- Incapacitating Roar has: every other class's "CC" goes there too.
local CC_KEY = "MULTIACTIONBAR6BUTTON8"
-- Bellular's cells that join an either/or talent pair whose spells do different
-- jobs. Rob, 2026-10-01, on Fury's Avatar/Bladestorm: "I do not think they
-- should share a key, they do fundamentally different things." The second
-- spell gets its own key: Bladestorm on Alt+2, as on Arms.
local SPLIT = {
	Fury = { cell = "Avatar/Bladestorm", keep = "Avatar", move = "Bladestorm", to = "ACTIONBUTTON8" },
	-- Rob, 2026-10-01: "warlock could make better use of alt 1 and alt 2?"
	-- Implosion is damage, Power Siphon a resource builder.
	Demonology = { cell = "Implosion/Power Siphon", keep = "Implosion", move = "Power Siphon", to = "ACTIONBUTTON7", src = "role" },
}
-- An either/or pair that does one job, on two keys in Bellular's sheet. Rob,
-- 2026-10-01: "Whirling Dragon Punch and Strike of the Windlord are a choice
-- node yes. ... they both are frontal aoe, so can share a key." The second
-- joins the first's key, which frees its own.
-- Rob put Windwalker's pair back on two keys on the page (Strike of the
-- Windlord 5, Whirling Dragon Punch Shift+Q): a bar slot holds one spell, so
-- one key for both needs a macro.
local MERGE = {}
-- Spells with no key, put on a free key (Rob's Alt+1 question, above)
local PROPOSED = {
	Destruction = { Havoc = "ACTIONBUTTON7" },
}
-- Rob's own moves on the page, 2026-10-01, kept as he made them. A spell the
-- whole class has is moved in every spec of the class (Rob: "non spec specific
-- spells should automatically be changed for all specs").
local MONK = { ["Tiger's Lust"] = "MULTIACTIONBAR3BUTTON12", Roll = "MULTIACTIONBAR6BUTTON3", ["Ring of Peace"] = "MULTIACTIONBAR6BUTTON4",
	Disable = "MULTIACTIONBAR6BUTTON11", ["Zen Flight"] = "MULTIACTIONBAR4BUTTON2", ["Touch of Death"] = "ACTIONBUTTON6" }
local function with(base, more)
	local t = {}
	for k, v in pairs(base) do t[k] = v end
	for k, v in pairs(more or {}) do t[k] = v end
	return t
end
-- Rob, 2026-10-01: "shift + w could be used for any stun". So Frost's and
-- Unholy's Asphyxiate go on Shift+W, not on T where the page's class-wide move
-- put them (pushing off Frost's Remorseless Winter). Blood keeps Rob's T, since
-- Rob put Gorefiend's Grasp on Blood's Shift+W.
-- Rob, 2026-10-01, "1": Claude proposes keys for the spells left with none,
-- Rob fixes them on the page. Druid first. Hibernate is rare, out of a fight:
-- Num2, free in all four. Feral's 4 was empty (bar 1, the cat page). Rob,
-- on Frenzied Regeneration there: "it requires bear form and I'd rather not
-- risk pressing it by accident". So Maim on 4. Then "if the macro works. I
-- guess it could go on shift S": the heal macro freed Shift+S, a self-heal key.
local DRUID_FILL = { Hibernate = "MULTIACTIONBAR4BUTTON2" }
PROPOSED.Feral = with(DRUID_FILL, { Maim = "ACTIONBUTTON4", ["Frenzied Regeneration"] = "MULTIACTIONBAR6BUTTON6" })
PROPOSED.Guardian = with(DRUID_FILL, { ["Bristling Fur"] = "MULTIACTIONBAR2BUTTON10" })
PROPOSED.Balance = DRUID_FILL
PROPOSED.Resto = with(DRUID_FILL, { Efflorescence = "ACTIONBUTTON7", Starsurge = "ACTIONBUTTON12" })
-- Rogue, 2026-10-02 (Rob: "I want to play my rogue right now"). Keys free in
-- all three specs. Blind on Alt+R, the one-enemy CC key (Imprison, Banish);
-- Gouge on Shift+A, the slow key; Vanish on Shift+S (the heal macro freed it), behind Shift like Feral's Frenzied
-- Regeneration, since a stray press drops the fight; Tricks of the Trade on 4,
-- pressed on cooldown and harmless by mistake; Thistle Tea on C, a druid's
-- Recuperate key; Distract on Num3, out of the fight.
local ROGUE_FILL = { Blind = "MULTIACTIONBAR6BUTTON4", Gouge = "MULTIACTIONBAR6BUTTON11", Vanish = "MULTIACTIONBAR6BUTTON6",
	["Tricks of the Trade"] = "ACTIONBUTTON4", ["Thistle Tea"] = "MULTIACTIONBAR3BUTTON3", Distract = "MULTIACTIONBAR4BUTTON3" }
PROPOSED.Assassination, PROPOSED.Outlaw, PROPOSED.Subtlety = ROGUE_FILL, ROGUE_FILL, ROGUE_FILL
local DK_STUN = { Asphyxiate = "MULTIACTIONBAR6BUTTON8", ["Death and Decay"] = "MULTIACTIONBAR6BUTTON1" }
local MAGE_AOE = { ["Arcane Explosion"] = "ACTIONBUTTON10" }
local ROB_PICKS = {
	Havoc = { Darkness = "ACTIONBUTTON5", ["Essence Break"] = "ACTIONBUTTON4", ["Rain from Above"] = "ACTIONBUTTON8" },
	Devourer = { Darkness = "MULTIACTIONBAR6BUTTON1", ["Void Nova"] = "ACTIONBUTTON7" },
	Brewmaster = with(MONK, { ["Purifying Brew"] = "MULTIACTIONBAR6BUTTON1", ["Breath of Fire"] = "ACTIONBUTTON2", ["Chi Burst"] = "ACTIONBUTTON7" }),
	-- Rob, 2026-10-01, "okay" to keys for the spells his moves left with none:
	-- Vampiric Blood 2, Death Strike 4, Putrefy Alt+2, Celestial Conduit Alt+1, all free
	Mistweaver = with(MONK, { ["Celestial Conduit"] = "ACTIONBUTTON7" }),
	Windwalker = with(MONK, { ["Strike of the Windlord"] = "ACTIONBUTTON5", ["Whirling Dragon Punch"] = "ACTIONBUTTON11" }),
	Balance = { ["Wild Mushroom"] = "ACTIONBUTTON7" },  -- Balance fights on the Moonkin page
	Blood = { Asphyxiate = "ACTIONBUTTON6", ["Gorefiend's Grasp"] = "MULTIACTIONBAR6BUTTON8", ["Vampiric Blood"] = "ACTIONBUTTON2" },
	["Frost Death Knight"] = with(DK_STUN, { ["Death Strike"] = "ACTIONBUTTON4" }),
	Unholy = with(DK_STUN, { ["Death Strike"] = "ACTIONBUTTON4", Putrefy = "ACTIONBUTTON8" }),
	Fire = MAGE_AOE, ["Frost Mage"] = MAGE_AOE,
}
-- Rob took these off their key; the whole class follows.
local ROB_OFF = {}  -- Time Warp, taken off Alt+D, went back: Rob's "okay"
-- Rob's moves of a spell the whole class has, by class id. Imprison: Wheel up
-- on Havoc and Devourer, then "Devourer: Imprison (no key before) to Alt+R"
-- (Clique's wheel only fires over a unit frame, a poor home for an enemy CC).
local ROB_CLASS = {
	[12] = { Imprison = "MULTIACTIONBAR6BUTTON4" },
	[6] = { ["Wraith Walk"] = "MULTIACTIONBAR3BUTTON6", ["Death Grip"] = "MULTIACTIONBAR6BUTTON11", ["Raise Dead"] = "MULTIACTIONBAR3BUTTON10",
		["Chains of Ice"] = "MULTIACTIONBAR6BUTTON4", Lichborne = "MULTIACTIONBAR6BUTTON7", ["Anti-Magic Zone"] = "ACTIONBUTTON7" },
	[8] = { ["Mirror Image"] = "ACTIONBUTTON8", ["Cone of Cold"] = "ACTIONBUTTON7", ["Mass Invisibility"] = "MULTIACTIONBAR4BUTTON2",
		["Frost Nova"] = "MULTIACTIONBAR6BUTTON4", ["Slow Fall"] = "MULTIACTIONBAR3BUTTON2" },
}
-- Rob's mouse binds, by spec: the page's Clique panel
local ROB_MOUSE = { Brewmaster = { MOUSEWHEELDOWN = "Expel Harm" } }

local extras, bellular = {}, {}
for _, job in ipairs(PlanTab.BAR_CATEGORIES) do bellular[job] = true end
for job in pairs(PlanTab.JOB_BUTTONS) do if not bellular[job] then extras[#extras + 1] = job end end
table.sort(extras)

local function plan(spec, class)
	local own, source, template = rules(spec, class)
	local column = {}
	for i, v in ipairs(PlanTab.BAR_ABILITIES[spec] or {}) do column[i] = v end
	local rows, buff, res = { column[BUFF] or "", column[RES] or "" }, "", ""
	for _, v in ipairs(rows) do
		if IS_BUFF[v] then buff = v elseif IS_RES[v] then res = v end
	end
	column[BUFF], column[RES] = buff, res
	local others = {}  -- anything else in the rows: a teleport, placed by TELEPORT
	for _, v in ipairs(rows) do
		if v ~= "" and v ~= buff and v ~= res then others[#others + 1] = v end
	end
	if NUM1_UTILITY[class] and (column[BUFF] or "") == "" then
		for i, v in ipairs(column) do if v == NUM1_UTILITY[class] then column[i] = "" end end
		column[BUFF] = NUM1_UTILITY[class]
	end
	local cells, nokey, clique, clash = {}, {}, {}, {}
	local placed = {}
	local function put(job, spell)
		if placed[spell] then return end  -- Bellular gives Unholy's Death Coil two rows; one key is enough
		-- Card 0083's macro, on Shift+2, uses the stone first. Rob, 2026-10-01:
		-- "macro seems to work okay!" So the stone needs no key of its own.
		if spell == "Healthstone" then return end
		placed[spell] = true
		if DISPELS[spell] then clique[#clique + 1] = { job = job, spell = spell, short = PlanTab.jobShort(job, spec) } return end
		local b = own[job]
		local src = b and source or "base"
		if b == "" then b = nil end
		if own[job] == nil then b = PlanTab.JOB_BUTTONS[job] end
		if TELEPORT[spell] then b, src, job = TELEPORT[spell], "role", "Teleport" end
		if SPELL_KEY[spell] then b, src = SPELL_KEY[spell], spell == "Healing Potion" and "rob" or "role" end
		if job == "CC" and class ~= PlanTab.DRUID and not b then b, src = CC_KEY, "role" end
		local short = PlanTab.jobShort(job, spec)
		if not b then nokey[#nokey + 1] = { job = job, spell = spell, short = short } return end
		local note = (src == "role" and template == "Guardian" and REVIEW[job]) or nil
		if cells[b] then clash[#clash + 1] = ("%s and %s on %s"):format(cells[b].spell, spell, keyOf[b] or b) end
		cells[b] = { spell = spell, job = job, short = short, source = src, note = note }
	end
	for i, job in ipairs(PlanTab.BAR_CATEGORIES) do
		if (column[i] or "") ~= "" then put(job, column[i]) end
	end
	for _, v in ipairs(others) do put("Teleport", v) end
	if class == PlanTab.DRUID then
		for _, job in ipairs(extras) do put(job, job) end  -- Rob's own druid extras and items
	else
		for _, job in ipairs({ "Healthstone", "Damage Potion" }) do put(job, job) end  -- any class can use these
	end
	put("Healing Potion", "Healing Potion")
	local split = SPLIT[spec]
	if split then
		for b, c in pairs(cells) do
			if c.spell == split.cell then
				c.spell = split.keep
				assert(not cells[split.to], spec .. ": the split's key is taken")
				cells[split.to] = { spell = split.move, job = c.job, short = c.short, source = split.src or "rob" }
			end
		end
	end
	local merge = MERGE[spec]
	if merge then
		local keep, join
		for b, c in pairs(cells) do
			if c.spell == merge.keep then keep = c end
			if c.spell == merge.join then join = b end
		end
		assert(keep and join, spec .. ": a merged spell is missing")
		keep.spell, keep.choice, keep.source = merge.keep .. " / " .. merge.join, true, "rob"
		cells[join] = nil
	end
	-- Moves: the spell onto the key, what was there onto the spell's old key
	-- (a swap), or to "no key yet"
	local function apply(picks, src)
		for spell, b in pairs(picks or {}) do
			local from, entry
			for k, c in pairs(cells) do if c.spell == spell then from, entry = k, c end end
			for i, c in ipairs(nokey) do if c.spell == spell then entry = table.remove(nokey, i) break end end
			if entry and from ~= b then
				local there = cells[b]
				cells[b] = { spell = spell, job = entry.job, short = entry.short, source = src }
				if from then cells[from] = there end
				if there and not from then nokey[#nokey + 1] = { job = there.job, spell = there.spell, short = there.short } end
			end
		end
	end
	apply(ROB_PICKS[spec], "rob")
	apply(PROPOSED[spec], "role")
	for _, spell in ipairs(ROB_OFF[class] or {}) do
		for b, c in pairs(cells) do
			if c.spell == spell then nokey[#nokey + 1] = { job = c.job, spell = spell, short = c.short } cells[b] = nil end
		end
	end
	apply(ROB_CLASS[class], "rob")
	local mouse = {}
	for key, spell in pairs(ROB_MOUSE[spec] or {}) do
		for i, c in ipairs(nokey) do if c.spell == spell then table.remove(nokey, i) break end end
		for b, c in pairs(cells) do if c.spell == spell then cells[b] = nil end end
		mouse[#mouse + 1] = { key = key, spell = spell }
	end
	local seen = {}
	for b, c in pairs(cells) do
		if seen[c.spell] then clash[#clash + 1] = c.spell .. " on two keys" end
		seen[c.spell] = true
	end
	return cells, nokey, clique, clash, mouse
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

-- Rob, 2026-10-01: "can we make bar 1 change based on stance? Like in game?"
-- A druid's bar 1 is a different page in each form. The plan is the page the
-- spec fights on (PlanTab.FORM_PAGE); the other pages come from his saved bars,
-- as they are, slot by slot.
local SNAPSHOT = { Feral = "Feral / Dungeon", Guardian = "Guardian / Dungeon", Balance = "Balance", Resto = "Resto" }
local FORMS = { { "caster", 0 }, { "cat", 72 }, { "prowl", 84 }, { "bear", 96 }, { "moonkin", 108 } }
local HOME = { [0] = "caster", [72] = "cat", [96] = "bear", [108] = "moonkin" }
local function savedPages(spec)
	local snap = DjinnisCPDB.bars[SNAPSHOT[spec] or ""]
	if not snap then return nil end
	local pages = {}
	for _, f in ipairs(FORMS) do
		local page = {}
		for n = 1, 12 do
			local v = snap.slots[f[2] + n]
			if v then page["ACTIONBUTTON" .. n] = { type = v.type, id = v.id, name = v.name, index = v.index } end
		end
		pages[f[1]] = page
	end
	return { home = HOME[PlanTab.FORM_PAGE[spec]], pages = pages, saved = snap.saved, from = SNAPSHOT[spec] }
end

local specs, clashes = {}, 0
for _, s in ipairs(PlanTab.SPECS) do
	local id, name, class, role = s[1], s[2], s[3], s[4]
	if PlanTab.BAR_ABILITIES[name] then
		local cells, nokey, clique, clash, mouse = plan(name, class)
		clashes = clashes + #clash
		specs[#specs + 1] = { id = id, spec = name, class = class, className = CLASS[class] or ("class " .. class), role = role,
			template = class ~= PlanTab.DRUID and PlanTab.templateFor(name) or nil, cells = cells, nokey = nokey, clique = clique, clash = clash, mouse = mouse,
				forms = class == PlanTab.DRUID and savedPages(name) or nil }
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
