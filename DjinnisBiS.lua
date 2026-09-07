-- Djinni's BiS -- "do I roll on this?" for all four druid specs.
--
-- ============================ EDIT THE LIST HERE ============================
-- Season 2 / patch 12.1.0 / The Venomous Abyss.
-- Sources: method.gg and icy-veins.com, both pulled 2026-08-19 (season week 1).
--
-- The two sites disagree on a lot of slots, so both picks are kept and the
-- `site` field says who said what. "both" means they agree, which is the
-- strongest signal in this table. A slot with two entries is a slot where the
-- theorycrafters have not settled.
--
-- Item effects in this raid changed <24h before the season opened, so every
-- public list is still in flux. Re-pull both sites when the sims settle.
--
-- Rings and trinkets are one slot each rather than "Finger 1 / Finger 2".
-- The sites order those two arbitrarily and matching them up implies a
-- precision that is not there.
--
-- Matching is by NAME, normalised (case and punctuation ignored).
-- ponytail: name matching, so English clients only. Swap to item IDs if you
-- ever play on a non-English client.
-- ===========================================================================

local M, IV, BOTH = "Method", "Icy Veins", "both"

local BIS = {
	Balance = {
		{ slot = "Head",      name = "Gaze of the Coiled Watcher",               boss = "Ula'tek",              site = M },
		{ slot = "Head",      name = "Enigmatic Dreamwatcher's Somnolent Stare", boss = "Ula'tek / Catalyst",   site = IV },
		{ slot = "Neck",      name = "Aqirbane Reliquary",                       boss = "Ula'tek",              site = BOTH },
		{ slot = "Shoulder",  name = "Frothing Venom Spaulders",                 boss = "Vashnik",              site = BOTH },
		{ slot = "Back",      name = "Silken Voodoo Drape",                      boss = "The Coiled Altar",     site = BOTH },
		{ slot = "Chest",     name = "Vestment of the Awakening",                boss = "Nek'zali",             site = M },
		{ slot = "Chest",     name = "Enigmatic Dreamwatcher's Lunar Raiment",   boss = "Vashnik / Catalyst",   site = IV },
		{ slot = "Wrist",     name = "Restless Spirit Shackles",                 boss = "Nek'zali",             site = BOTH },
		{ slot = "Hands",     name = "Ruthless Slaughtergrips",                  boss = "Sszorak",              site = M },
		{ slot = "Hands",     name = "Enigmatic Dreamwatcher's Gauntlets",       boss = "Entombed Sentinels / Catalyst", site = IV },
		{ slot = "Waist",     name = "Sash of the Forlorn Vessel",               boss = "The Coiled Altar",     site = BOTH },
		{ slot = "Legs",      name = "Coiled Hex Legguards",                     boss = "The Coiled Altar",     site = M },
		{ slot = "Legs",      name = "Enigmatic Dreamwatcher's Leggings",        boss = "The Coiled Altar / Catalyst", site = IV },
		{ slot = "Feet",      name = "Bespittled Slitherslippers",               boss = "The Twin Fangs",       site = M },
		{ slot = "Feet",      name = "Silvermoon Agent's Sneakers",              boss = "Crafted",              site = IV },
		{ slot = "Finger",    name = "Vile Alchemist's Band",                    boss = "Vashnik",              site = BOTH },
		{ slot = "Finger",    name = "Apex Brute's Claw Ring",                   boss = "Sszorak",              site = M },
		{ slot = "Finger",    name = "Charged Sandstone Band",                   boss = "Temple of Sethraliss", site = IV },
		{ slot = "Trinket",   name = "Gebbo's Bottomless Bag",                   boss = "The Lost Explorers",   site = BOTH },
		{ slot = "Trinket",   name = "Hex Lord's Dooming Idol",                  boss = "The Coiled Altar",     site = M },
		{ slot = "Trinket",   name = "Vile Vial of Volatile Venom",              boss = "Altar of Fangs",       site = IV },
		{ slot = "Main Hand", name = "Jan'thrazet, the Soul Fang",               boss = "Ula'tek",              site = BOTH },
		{ slot = "Off Hand",  name = "Aln'hara Lantern",                         boss = "Crafted",              site = IV },
	},
	Feral = {
		{ slot = "Head",      name = "Gaze of the Coiled Watcher",               boss = "Ula'tek",              site = M },
		{ slot = "Head",      name = "Enigmatic Dreamwatcher's Somnolent Stare", boss = "Ula'tek / Catalyst",   site = IV },
		{ slot = "Neck",      name = "Aqirbane Reliquary",                       boss = "Ula'tek",              site = BOTH },
		{ slot = "Shoulder",  name = "Enigmatic Dreamwatcher's Plumage",         boss = "The Lost Explorers / Catalyst", site = IV },
		{ slot = "Back",      name = "Silken Voodoo Drape",                      boss = "The Coiled Altar",     site = BOTH },
		{ slot = "Chest",     name = "Enigmatic Dreamwatcher's Lunar Raiment",   boss = "Nek'zali / Catalyst",  site = IV },
		{ slot = "Wrist",     name = "Silvermoon Agent's Deflectors",            boss = "Crafted",              site = BOTH },
		{ slot = "Hands",     name = "Enigmatic Dreamwatcher's Gauntlets",       boss = "Murder Row / Catalyst", site = IV },
		{ slot = "Waist",     name = "Sash of the Forlorn Vessel",               boss = "The Coiled Altar",     site = BOTH },
		{ slot = "Legs",      name = "Coiled Hex Legguards",                     boss = "The Coiled Altar",     site = M },
		{ slot = "Legs",      name = "Enigmatic Dreamwatcher's Leggings",        boss = "The Coiled Altar / Catalyst", site = IV },
		{ slot = "Feet",      name = "Silvermoon Agent's Sneakers",              boss = "Crafted",              site = IV },
		{ slot = "Finger",    name = "Sickening Signet of Atroxus",              boss = "Voidscar Arena",       site = BOTH },
		{ slot = "Finger",    name = "Vile Alchemist's Band",                    boss = "Vashnik",              site = BOTH },
		{ slot = "Trinket",   name = "Voracious Heart of Ula'tek",               boss = "Ula'tek",              site = BOTH },
		{ slot = "Trinket",   name = "Zul'jin's Guillotine Technique",           boss = "The Coiled Altar",     site = BOTH },
		{ slot = "Main Hand", name = "Abyssal Broodfiend's Bardiche",            boss = "Ula'tek",              site = BOTH },
	},
	Guardian = {
		{ slot = "Head",      name = "Gaze of the Coiled Watcher",               boss = "Ula'tek",              site = BOTH },
		{ slot = "Neck",      name = "Aqirbane Reliquary",                       boss = "Ula'tek",              site = BOTH },
		{ slot = "Shoulder",  name = "Somber Spaulders",                         boss = "Voidscar Arena",       site = M },
		{ slot = "Shoulder",  name = "Enigmatic Dreamwatcher's Plumage",         boss = "The Lost Explorers / Catalyst", site = IV },
		{ slot = "Back",      name = "Silken Voodoo Drape",                      boss = "The Coiled Altar",     site = BOTH },
		{ slot = "Chest",     name = "Enigmatic Dreamwatcher's Lunar Raiment",   boss = "Vashnik / Catalyst",   site = BOTH },
		{ slot = "Wrist",     name = "Fury-Fletched Armlets",                    boss = "Murder Row",           site = M },
		{ slot = "Wrist",     name = "Silvermoon Agent's Deflectors",            boss = "Crafted",              site = IV },
		{ slot = "Hands",     name = "Gauntlets of Fevered Defense",             boss = "Murder Row",           site = M },
		{ slot = "Hands",     name = "Enigmatic Dreamwatcher's Gauntlets",       boss = "Entombed Sentinels / Catalyst", site = IV },
		{ slot = "Waist",     name = "Sash of the Forlorn Vessel",               boss = "The Coiled Altar",     site = BOTH },
		{ slot = "Legs",      name = "Coiled Hex Legguards",                     boss = "The Coiled Altar",     site = M },
		{ slot = "Legs",      name = "Enigmatic Dreamwatcher's Leggings",        boss = "The Coiled Altar / Catalyst", site = IV },
		{ slot = "Feet",      name = "Breakwater Boots",                         boss = "Nymrissa Wavecaller",  site = M },
		{ slot = "Feet",      name = "Bespittled Slitherslippers",               boss = "The Twin Fangs",       site = IV },
		{ slot = "Finger",    name = "Ritual Binder's Ring",                     boss = "Kings' Rest",          site = M },
		{ slot = "Finger",    name = "Alluring Bubbleband",                      boss = "Nymrissa Wavecaller",  site = M },
		{ slot = "Finger",    name = "Apex Brute's Claw Ring",                   boss = "Sszorak",              site = IV },
		{ slot = "Finger",    name = "Vile Alchemist's Band",                    boss = "Vashnik",              site = IV },
		{ slot = "Trinket",   name = "Voracious Heart of Ula'tek",               boss = "Ula'tek",              site = M },
		{ slot = "Trinket",   name = "Keeper's Seething Core",                   boss = "Entombed Sentinels",   site = M },
		{ slot = "Trinket",   name = "Gebbo's Bottomless Bag",                   boss = "The Lost Explorers",   site = IV },
		{ slot = "Trinket",   name = "Zul'jin's Guillotine Technique",           boss = "The Coiled Altar",     site = IV },
		{ slot = "Main Hand", name = "Abyssal Broodfiend's Bardiche",            boss = "Ula'tek",              site = BOTH },
	},
	Resto = {
		{ slot = "Head",      name = "Gaze of the Coiled Watcher",               boss = "Ula'tek",              site = M },
		{ slot = "Head",      name = "Enigmatic Dreamwatcher's Somnolent Stare", boss = "Ula'tek / Catalyst",   site = IV },
		{ slot = "Neck",      name = "Amulet of the Twin Fangs",                 boss = "The Twin Fangs",       site = BOTH },
		{ slot = "Shoulder",  name = "Silvermoon Agent's Mantle",                boss = "Crafted",              site = BOTH },
		{ slot = "Back",      name = "Silken Voodoo Drape",                      boss = "The Coiled Altar",     site = BOTH },
		{ slot = "Chest",     name = "War Trial Vestments",                      boss = "Den of Nalorakk / Catalyst", site = M },
		{ slot = "Chest",     name = "Enigmatic Dreamwatcher's Lunar Raiment",   boss = "Nek'zali / Catalyst",  site = IV },
		{ slot = "Wrist",     name = "Silvermoon Agent's Deflectors",            boss = "Crafted",              site = BOTH },
		{ slot = "Hands",     name = "Enigmatic Dreamwatcher's Gauntlets",       boss = "Entombed Sentinels / Catalyst", site = BOTH },
		{ slot = "Waist",     name = "Sash of the Forlorn Vessel",               boss = "The Coiled Altar",     site = BOTH },
		{ slot = "Legs",      name = "Coiled Hex Legguards",                     boss = "The Coiled Altar",     site = M },
		{ slot = "Legs",      name = "Enigmatic Dreamwatcher's Leggings",        boss = "The Coiled Altar / Catalyst", site = IV },
		{ slot = "Feet",      name = "Breakwater Boots",                         boss = "Nymrissa Wavecaller",  site = M },
		{ slot = "Feet",      name = "Silvermoon Agent's Sneakers",              boss = "Crafted",              site = IV },
		{ slot = "Finger",    name = "Sickening Signet of Atroxus",              boss = "Voidscar Arena",       site = BOTH },
		{ slot = "Finger",    name = "Vile Alchemist's Band",                    boss = "Vashnik",              site = M },
		{ slot = "Finger",    name = "Alluring Bubbleband",                      boss = "Nymrissa Wavecaller",  site = IV },
		{ slot = "Trinket",   name = "Soulcoiler Ritual Vessel",                 boss = "Nek'zali",             site = BOTH },
		{ slot = "Trinket",   name = "Wavecaller's Seastone",                    boss = "Nymrissa Wavecaller",  site = M },
		{ slot = "Trinket",   name = "Gebbo's Bottomless Bag",                   boss = "The Lost Explorers",   site = IV },
		{ slot = "Main Hand", name = "Jan'thrazet, the Soul Fang",               boss = "Ula'tek",              site = BOTH },
		{ slot = "Off Hand",  name = "Spine of the Hissing Abyss",               boss = "Entombed Sentinels",   site = BOTH },
		{ slot = "Two Hand",  name = "Staff of the Lightning Serpent",           boss = "Temple of Sethraliss", site = M },
	},
}

-- ===========================================================================

-- Trinket tiers -------------------------------------------------------------
--
-- GENERATED, do not hand-edit. Everything between the BEGIN and END markers
-- below is rewritten by `update-classcodex-data.ps1`, which reads ClassCodex's
-- own shipped data files. `u` is u.gg, `iv` is Icy Veins. Patching a letter
-- here loses the patch the next time that script runs.
--
-- ClassCodex is the source because it is the only one that is not a fight. The
-- sites themselves are closed to a script: Archon answers a plain request with
-- 403, Wowhead, Icy Veins and u.gg publish no API and scraping their HTML means
-- owning a parser that breaks whenever they restyle a page. ClassCodex already
-- does that work, ships the result as parseable Lua, and CurseForge keeps those
-- files current on disk **whether or not the addon is enabled in the game**. So
-- the refresh costs one command and no maintenance. The full reasoning, and
-- what each site actually answered, is in that script's header.
--
-- Keyed by item id, not by name, because that is how ClassCodex stores it and
-- an id does not care about spelling or locale. The join to the BiS list above
-- happens at runtime: the Encounter Journal harvest gives a name an item link,
-- and the link gives an id. A trinket with no resolved link gets no tier, and
-- that is the correct outcome rather than a wrong one.
--
-- PvP-context entries are dropped: this addon is about PvE drops. So is one
-- Icy Veins entry graded "F-", which is a joke rather than a tier.
--
-- These tiers rate ALL trinkets a spec might wear, not only the ones on the
-- BiS list, which is the point: the list says what is best, the tiers say what
-- to do with the thing that actually dropped.

-- BEGIN GENERATED TRINKET TIERS
local TRINKET_TIER_SOURCE = "ClassCodex 1.3.1, read 2026-09-02"
local TRINKET_TIER = {
	Balance = {
		[270164] = { u = "C", iv = "S" },
		[270167] = { u = "C", iv = "S" },
		[273796] = { u = "A", iv = "S" },
		[249346] = { u = "A" },
		[250215] = { u = "B", iv = "A" },
		[270169] = { iv = "A" },
		[270170] = { iv = "A" },
		[249343] = { u = "B" },
		[250214] = { u = "B", iv = "B" },
		[250224] = { u = "C", iv = "B" },
		[250259] = { iv = "B" },
		[270161] = { iv = "B" },
		[158368] = { iv = "C" },
		[193757] = { iv = "C" },
		[250144] = { u = "C" },
		[270168] = { iv = "C" },
		[273649] = { iv = "C" },
		[273794] = { iv = "C" },
		[274493] = { u = "C" },
	},
	Feral = {
		[193701] = { u = "S" },
		[270164] = { iv = "S" },
		[270173] = { iv = "S" },
		[270175] = { u = "C", iv = "S" },
		[159617] = { u = "C", iv = "A" },
		[250228] = { u = "C", iv = "A" },
		[270165] = { iv = "A" },
		[273796] = { u = "B", iv = "A" },
		[241288] = { iv = "B" },
		[248583] = { u = "C", iv = "B" },
		[249343] = { u = "B" },
		[250214] = { u = "B", iv = "B" },
		[250215] = { u = "C", iv = "B" },
		[250225] = { u = "C", iv = "B" },
		[251792] = { u = "C", iv = "B" },
		[265657] = { iv = "B" },
		[270166] = { iv = "B" },
		[158374] = { u = "C", iv = "C" },
		[250259] = { iv = "C" },
		[251785] = { iv = "C" },
		[270168] = { iv = "C" },
		[274493] = { u = "C", iv = "C" },
		[241340] = { iv = "D" },
		[246304] = { iv = "D" },
		[246305] = { iv = "D" },
		[246306] = { iv = "D" },
		[246307] = { iv = "D" },
		[251783] = { iv = "D" },
		[273797] = { iv = "D" },
		[274496] = { iv = "D" },
		[274497] = { iv = "D" },
	},
	Guardian = {
		[270164] = { iv = "S" },
		[270168] = { iv = "S" },
		[270173] = { iv = "S" },
		[270175] = { iv = "S" },
		[273796] = { u = "B", iv = "S" },
		[270160] = { iv = "A" },
		[270165] = { iv = "A" },
		[270166] = { iv = "A" },
		[270174] = { iv = "A" },
		[273797] = { iv = "A" },
		[249343] = { u = "B" },
		[250214] = { u = "C", iv = "B" },
		[250215] = { u = "B", iv = "B" },
		[250225] = { u = "C", iv = "B" },
		[250228] = { u = "B", iv = "B" },
		[250243] = { iv = "B" },
		[250244] = { iv = "B" },
		[250245] = { u = "B", iv = "B" },
		[250259] = { iv = "B" },
		[268292] = { u = "B" },
		[159617] = { u = "C", iv = "C" },
		[159618] = { iv = "C" },
		[193701] = { u = "C" },
		[193757] = { iv = "C" },
		[250256] = { u = "C" },
		[260235] = { u = "C" },
		[274493] = { u = "C" },
		[158374] = { iv = "D" },
	},
	Resto = {
		[270162] = { u = "B", iv = "S" },
		[270164] = { iv = "S" },
		[270167] = { u = "B", iv = "S" },
		[193757] = { iv = "A" },
		[248583] = { iv = "A" },
		[249343] = { u = "A", iv = "B" },
		[250214] = { u = "B", iv = "A" },
		[270169] = { iv = "A" },
		[249809] = { u = "B" },
		[249811] = { iv = "B" },
		[250256] = { u = "B" },
		[251792] = { u = "C", iv = "B" },
		[268292] = { u = "B" },
		[273649] = { iv = "B" },
		[250248] = { iv = "C" },
		[250254] = { iv = "C" },
		[250255] = { u = "C", iv = "C" },
		[273796] = { u = "C", iv = "C" },
		[274493] = { u = "C" },
		[264507] = { iv = "D" },
		[264701] = { iv = "D" },
		[270171] = { iv = "D" },
	},
}
-- END GENERATED TRINKET TIERS

-- Stat targets --------------------------------------------------------------
--
-- GENERATED, do not hand-edit. Same script, same source files, second block.
--
-- The secondary-stat ratings the top 20% of each spec are actually running, per
-- hero talent, for raid and for Mythic+. u.gg only: Icy Veins writes prose about
-- which stat to favour and publishes no number to aim at.
--
-- These are OBSERVED, not simulated. They are what the best logged players wear,
-- which is why there is no "breakpoint" language here and no claim that hitting
-- one does anything mechanical. A few genuinely are breakpoints (a haste value
-- that fits another tick into a channel); most are just where the gear settles.
-- Treating all of them the same way is the honest reading of what the data is.
--
-- `all` is the aggregate across every hero talent, and it is the fallback when
-- the player's hero talent has no entry of its own. That fallback matters: for
-- Feral raid, Druid of the Claw wants 1225 crit and the aggregate says 775, so
-- showing the aggregate to a Druid of the Claw player would be wrong by more
-- than half. When the fallback is in use the panel says so.
--
-- Only the top-20% bin is carried. u.gg also publishes top 50% and top 80%, and
-- a selector between three bins is a control nobody asked for.
--
-- BEGIN GENERATED STAT TARGETS
local STAT_TARGET_SOURCE = "ClassCodex 1.3.1, u.gg top 20%, read 2026-09-07"
local STAT_TARGET = {
	Balance = {
		all = {
			raid  = { crit = 975, haste = 1011, mastery = 1071, versatility = 347 },
			mplus = { crit = 973, haste = 1062, mastery = 1094, versatility = 303 },
		},
		["elunes-chosen"] = {
			raid  = { crit = 975, haste = 1011, mastery = 1071, versatility = 347 },
			mplus = { crit = 973, haste = 1062, mastery = 1094, versatility = 303 },
		},
		["keeper-of-the-grove"] = {
			raid  = { crit = 925, haste = 1075, mastery = 975, versatility = 375 },
			mplus = { crit = 825, haste = 575, mastery = 1125, versatility = 225 },
		},
	},
	Feral = {
		all = {
			raid  = { crit = 775, haste = 1008, mastery = 1195, versatility = 325 },
			mplus = { crit = 850, haste = 1265, mastery = 1161, versatility = 445 },
		},
		["druid-of-the-claw"] = {
			raid  = { crit = 1225, haste = 1075, mastery = 975, versatility = 375 },
			mplus = { crit = 850, haste = 1265, mastery = 1161, versatility = 445 },
		},
		wildstalker = {
			raid  = { crit = 775, haste = 1008, mastery = 1195, versatility = 325 },
			mplus = { crit = 915, haste = 1125, mastery = 1195, versatility = 475 },
		},
	},
	Guardian = {
		all = {
			raid  = { crit = 858, haste = 1355, mastery = 608, versatility = 685 },
			mplus = { crit = 975, haste = 1329, mastery = 811, versatility = 666 },
		},
		["druid-of-the-claw"] = {
			raid  = { crit = 1075, haste = 1125, mastery = 575, versatility = 375 },
			mplus = { crit = 1100, haste = 1200, mastery = 975, versatility = 458 },
		},
		["elunes-chosen"] = {
			raid  = { crit = 858, haste = 1355, mastery = 608, versatility = 685 },
			mplus = { crit = 975, haste = 1329, mastery = 811, versatility = 666 },
		},
	},
	Resto = {
		all = {
			raid  = { crit = 542, haste = 1533, mastery = 1242, versatility = 325 },
			mplus = { crit = 564, haste = 1408, mastery = 1343, versatility = 519 },
		},
		["keeper-of-the-grove"] = {
			raid  = { crit = 425, haste = 1225, mastery = 1225, versatility = 25 },
			mplus = { crit = 835, haste = 1404, mastery = 1132, versatility = 575 },
		},
		wildstalker = {
			raid  = { crit = 542, haste = 1533, mastery = 1242, versatility = 325 },
			mplus = { crit = 564, haste = 1408, mastery = 1343, versatility = 519 },
		},
	},
}
-- END GENERATED STAT TARGETS

-- ===========================================================================

local SPEC_ORDER = { "Balance", "Feral", "Guardian", "Resto" }

local SLOT_ORDER = {
	"Head", "Neck", "Shoulder", "Back", "Chest", "Wrist", "Hands", "Waist",
	"Legs", "Feet", "Finger", "Trinket", "Main Hand", "Off Hand", "Two Hand",
}

-- The eight Venomous Abyss bosses in kill order. Everything not listed falls to
-- the bottom alphabetically, which is where the dungeon, world boss and crafted
-- sources belong. Murder Row and Kings' Rest are dungeons, not raid bosses.
local BOSS_ORDER = {
	"Nek'zali", "Entombed Sentinels", "The Lost Explorers", "Vashnik",
	"Sszorak", "The Twin Fangs", "The Coiled Altar", "Ula'tek",
}

-- Upgrade tracks. Exact per-rank numbers from method.gg, pulled 2026-08-19.
-- Adventurer and Veteran are deliberately absent: nothing on this list drops on
-- them, and no source publishes their per-rank numbers, so they would be guesses.
local TRACKS = {
	{ name = "Champion", ilvl = { 292, 295, 298, 302, 305, 308 } },
	{ name = "Hero",     ilvl = { 305, 308, 311, 315, 318, 321 } },
	{ name = "Myth",     ilvl = { 318, 321, 324, 328, 331, 334 } },
}
-- The last two Mythic bosses drop above the normal cap and take no upgrades.
local MYTHIC_RAID = { name = "Mythic raid", ilvl = 344 }

local function norm(name)
	return (name:lower():gsub("[^%a]", ""))
end

local function bossOf(source)
	return source:match("^(.-) / ") or source
end

-- normalised name -> { name, boss, specs = {...} }, for the tooltip and the roll
local lookup = {}
for _, spec in ipairs(SPEC_ORDER) do
	for _, item in ipairs(BIS[spec]) do
		local key = norm(item.name)
		local entry = lookup[key]
		if not entry then
			entry = { name = item.name, boss = item.boss, specs = {}, seen = {} }
			lookup[key] = entry
		end
		if not entry.seen[spec] then
			entry.seen[spec] = true
			entry.specs[#entry.specs + 1] = spec
		end
	end
end
do  -- keep spec lists in a stable, readable order
	local rank = {}
	for i, spec in ipairs(SPEC_ORDER) do rank[spec] = i end
	for _, entry in pairs(lookup) do
		table.sort(entry.specs, function(a, b) return rank[a] < rank[b] end)
	end
end

local function match(itemName)
	return itemName and lookup[norm(itemName)] or nil
end

local GREEN, GREY, GOLD, WHITE = "|cff00ff00", "|cff808080", "|cffffd100", "|cffffffff"

-- The item level you are chasing -------------------------------------------
--
-- Per item, saved per account. This is a plan, not a reading of what you have
-- equipped: the point is to record the rank you are actually aiming each piece
-- at, so a drop can be judged against it.

local function db()
	DjinnisBiSDB = DjinnisBiSDB or {}
	DjinnisBiSDB.gear = DjinnisBiSDB.gear or {}
	return DjinnisBiSDB
end

local function setGear(itemName, track, rank)
	db().gear[norm(itemName)] = track and { track = track, rank = rank } or nil
end

local function gearLabel(itemName)
	local set = db().gear[norm(itemName)]
	if not set then return GREY .. "set ilvl|r" end
	if set.track == MYTHIC_RAID.name then
		return GOLD .. MYTHIC_RAID.ilvl .. "|r " .. GREY .. "mythic|r"
	end
	for _, track in ipairs(TRACKS) do
		if track.name == set.track and track.ilvl[set.rank] then
			return GOLD .. track.ilvl[set.rank] .. "|r "
				.. GREY .. track.name:sub(1, 1) .. " " .. set.rank .. "/6|r"
		end
	end
	return GREY .. "set ilvl|r"  -- track was renamed or the save is stale
end

-- Item links ---------------------------------------------------------------
--
-- The Encounter Journal already holds this raid's whole loot table, with real
-- item links in it. Reading it beats hardcoding ~90 item IDs by hand, and it
-- stays right if Blizzard renames anything.

local links = {}  -- normalised name -> item link

local function resolveFromCache()
	for key, entry in pairs(lookup) do
		if not links[key] then
			local _, link = C_Item.GetItemInfo(entry.name)
			if link then links[key] = link end
		end
	end
end

local harvested = false
local function harvestFromJournal()
	if harvested or not EJ_GetNumTiers then return end
	C_AddOns.LoadAddOn("Blizzard_EncounterJournal")
	EJ_SelectTier(EJ_GetNumTiers())

	local instanceID
	local index = 1
	while true do
		local id, name = EJ_GetInstanceByIndex(index, true)  -- true = raids
		if not id then break end
		if name and name:find("Venomous Abyss") then instanceID = id break end
		index = index + 1
	end
	if not instanceID then return end

	EJ_SelectInstance(instanceID)

	-- A slot filter left on by the journal UI hides most of the loot table.
	-- Blizzard's own GetLootSlotsPresent resets it before counting, for the
	-- same reason. Put it back afterwards so the journal looks untouched.
	local slotFilter = C_EncounterJournal.GetSlotFilter()
	C_EncounterJournal.ResetSlotFilter()

	-- The tier set only appears with a class filter on. Setting that filter is
	-- asynchronous: the loot list is stale until EJ_LOOT_DATA_RECIEVED lands,
	-- so reading it immediately returns the previous, unfiltered list. That is
	-- exactly why the Dreamwatcher pieces kept coming back without links.
	local classID = select(3, UnitClass("player"))
	local stale = false

	for _, filter in ipairs({ 0, classID }) do
		EJ_SetLootFilter(filter, 0)
		if EJ_IsLootListOutOfDate and EJ_IsLootListOutOfDate() then
			stale = true
		else
			for i = 1, (EJ_GetNumLoot() or 0) do
				local info = C_EncounterJournal.GetLootInfoByIndex(i)
				if info and info.name and info.link then
					links[norm(info.name)] = info.link
				end
			end
		end
	end

	EJ_SetLootFilter(0, 0)
	C_EncounterJournal.SetSlotFilter(slotFilter)

	-- Only call it done when nothing was stale. Anything stale leaves this
	-- false, and EJ_LOOT_DATA_RECIEVED brings us back for another pass.
	harvested = not stale
end

-- Second source, free and already on disk: every item id in an imported
-- Droptimizer. Once the client has cached an id we get its name and link, so
-- any BiS item that appeared in a sim resolves without the journal at all.
local function resolveFromSim()
	local store = db().sim
	if not store then return end
	for _, sim in pairs(store) do
		for id in pairs(sim.items or {}) do
			local name, link = C_Item.GetItemInfo(id)
			if name and link then
				local key = norm(name)
				if lookup[key] and not links[key] then links[key] = link end
			elseif not name then
				C_Item.RequestLoadItemDataByID(id)  -- ready on the next open
			end
		end
	end
end

local function linkFor(name)
	return links[norm(name)]
end

-- Raidbots import ----------------------------------------------------------
--
-- Raidbots has no copy button, but every report is downloadable as CSV at
--     https://www.raidbots.com/simbot/report/<id>/data.csv
-- and that CSV is machine generated rather than a UI layout, so it is a far
-- safer thing to parse than anything scraped off the page.
--
-- Rows look like this, the first being the unmodified character:
--     Djinni,101155.39,...
--     -1/1311/dungeon-mythic-weekly10/271681/318/0/off_hand////,101375.64,...
-- Splitting that label on "/" gives source, item id, item level and slot. Item
-- ids beat names outright: exact, and immune to spelling and localisation.
--
-- A Droptimizer covers one spec at a time, so results are stored per spec.

local function slashFields(label)
	local out = {}
	for part in (label .. "/"):gmatch("(.-)/") do out[#out + 1] = part end
	return out
end

-- returns items keyed by item id, the baseline dps, and a count of bad rows
local function parseSim(text)
	local raw, baseline, unreadable = {}, nil, 0

	for line in (text .. "\n"):gmatch("(.-)\r?\n") do
		if line:match("%S") and not line:find("^name,") then
			local label, dps = line:match("^(.-),([%d%.eE%+%-]+)")
			dps = tonumber(dps)
			if not (label and dps) then
				unreadable = unreadable + 1
			elseif not label:find("/", 1, true) then
				baseline = baseline or dps  -- the character's own row
			else
				local field = slashFields(label)
				local id = tonumber(field[4])
				if id then
					raw[id] = { dps = dps, ilvl = tonumber(field[5]), slot = field[7] or "" }
				else
					unreadable = unreadable + 1
				end
			end
		end
	end

	if not baseline then return nil, nil, unreadable end

	local items, count = {}, 0
	for id, info in pairs(raw) do
		local percent = ((info.dps - baseline) / baseline) * 100
		items[id] = {
			gain = math.floor(percent * 100 + 0.5) / 100,  -- two decimals
			ilvl = info.ilvl,
			slot = info.slot,
		}
		count = count + 1
	end
	return items, baseline, unreadable, count
end

local function itemIdFor(name)
	local link = links[norm(name)]
	return link and tonumber(link:match("item:(%d+)"))
end

local function simFor(spec)
	local store = db().sim
	return store and store[spec]
end

local function simGain(spec, itemName)
	local sim = simFor(spec)
	local id = itemIdFor(itemName)
	local hit = id and sim and sim.items[id]
	return hit and hit.gain
end

local function gainText(gain)
	if not gain then return "" end
	local colour = gain > 0 and GREEN or GREY
	return "  " .. colour .. (gain > 0 and "+" or "") .. gain .. "%|r"
end

-- Trinket tiers, and standing aside for ClassCodex ---------------------------
--
-- ClassCodex is where the table above came from and it re-ships that data every
-- time the sites move. This copy cannot. So when ClassCodex is loaded it wins
-- outright: every tier this addon would draw is suppressed, and the panel says
-- so rather than going quietly missing. Two panels of the same tiers, one of
-- them stale, is worse than one panel.
--
-- Checked per render rather than once at load: an addon's load order is not
-- ours to assume, and this is one table lookup.

local CLASS_CODEX = "ClassCodex"

local function classCodexLoaded()
	return C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded(CLASS_CODEX) and true or false
end

-- The same five hex values ClassCodex uses, which are WoW's own item quality
-- colours, so a letter means the same thing in both addons.
local TIER_COLOUR = {
	S = "|cffff8000", A = "|cffa335ee", B = "|cff0070dd", C = "|cff1eff00", D = "|cff9d9d9d",
}
local TIER_RANK = { S = 1, A = 2, B = 3, C = 4, D = 5 }

local function tiersForId(spec, id)
	if not id or classCodexLoaded() then return nil end
	local perSpec = TRINKET_TIER[spec]
	return perSpec and perSpec[id] or nil
end

-- spec -> normalised item name -> tiers, built from the ids above via the
-- client's item cache. Rebuilt on refresh because a cold cache answers nil and
-- is right on the next open, the same as everywhere else in this file.
local tierNames = {}

local function refreshTierNames()
	for spec, items in pairs(TRINKET_TIER) do
		local byName = tierNames[spec]
		if not byName then byName = {}; tierNames[spec] = byName end
		for id, tiers in pairs(items) do
			local name = C_Item.GetItemInfo(id)
			if name then byName[norm(name)] = tiers end
		end
	end
end

-- One item can be reachable by more than one item id: the id the tier table
-- carries and the id the Encounter Journal link carries are not always the
-- same, which is why "Gebbo's Bottomless Bag" was rated in the ranked list and
-- blank in the Trinket slot on 2026-09-02 despite being the same trinket. The
-- name is the thing both agree on, so it is the fallback.
--
-- ponytail: two different items sharing one name would take each other's tier.
-- Item id is still tried first, so that only bites where the ids already
-- disagree, and no trinket in this table shares a name with another.
local function tiersFor(spec, id, itemName)
	local byId = tiersForId(spec, id)
	if byId then return byId end
	if not itemName or classCodexLoaded() then return nil end
	local byName = tierNames[spec]
	return byName and byName[norm(itemName)] or nil
end

local function nameFromLink(link)
	return link and link:match("|h%[(.-)%]|h") or nil
end

local function bestTier(tiers)
	return math.min(TIER_RANK[tiers.u] or 99, TIER_RANK[tiers.iv] or 99)
end

-- "S" when both sources agree or only one rated it, "A/S" when they disagree,
-- u.gg first then Icy Veins. A disagreement is worth seeing, not averaging.
local function tierText(tiers)
	if not tiers then return "" end
	local u, iv = tiers.u, tiers.iv
	if u and iv and u ~= iv then
		return "  " .. TIER_COLOUR[u] .. u .. "|r" .. GREY .. "/|r" .. TIER_COLOUR[iv] .. iv .. "|r"
	end
	local tier = u or iv
	return "  " .. TIER_COLOUR[tier] .. tier .. "|r"
end

-- Stat targets: where you are, where you want to be, and what a drop does ----
--
-- Three surfaces, one set of numbers: a Stats tab in this window, a pane that
-- rides alongside the character sheet, and lines on any gear tooltip. They all
-- go through the same helpers below, because three answers to "how much haste
-- do I want" that could disagree is the failure this section exists to avoid.

local STATS = { "crit", "haste", "mastery", "versatility" }
local STAT_LABEL = {
	crit = "Crit", haste = "Haste", mastery = "Mastery", versatility = "Vers",
}
local ZERO_STATS = { crit = 0, haste = 0, mastery = 0, versatility = 0 }

-- C_Item.GetItemStats keys. Two spellings are accepted per stat because the
-- game has shipped both and which one an item answers with is not worth
-- guessing: the first key that returns a number wins, and they are never added
-- together, which would double-count an item that carries both.
local STAT_ITEM_KEYS = {
	crit        = { "ITEM_MOD_CRIT_RATING_SHORT",    "ITEM_MOD_CRIT_RATING" },
	haste       = { "ITEM_MOD_HASTE_RATING_SHORT",   "ITEM_MOD_HASTE_RATING" },
	mastery     = { "ITEM_MOD_MASTERY_RATING_SHORT", "ITEM_MOD_MASTERY_RATING" },
	versatility = { "ITEM_MOD_VERSATILITY",          "ITEM_MOD_VERSATILITY_SHORT" },
}

-- Read at call time rather than stored in a table at file scope: these are
-- FrameXML constants and this file should not care what order it loaded in.
local function ratingIndexFor(stat)
	if stat == "crit" then return CR_CRIT_MELEE end
	if stat == "haste" then return CR_HASTE_MELEE end
	if stat == "mastery" then return CR_MASTERY end
	if stat == "versatility" then return CR_VERSATILITY_DAMAGE_DONE end
end

-- 12.1 secret values. A secret may not be compared or used in arithmetic, and
-- `type()` still answers "number" for one, so the guard this workspace reaches
-- for first does not see it. These two globals are the guard that does.
--
-- This is not a defensive guess: Blizzard's own API documentation flags
-- GetCombatRating with `SecretWhenUnitStatsRestricted`, so there is a
-- documented state where every number below arrives unusable. See
-- C:\Dev\WoWAddons\docs\DECISIONS.md for the two traps this workspace has
-- already been bitten by.
local canRead
if canaccessvalue then
	canRead = canaccessvalue
elseif issecretvalue then
	canRead = function(value) return not issecretvalue(value) end
else
	canRead = function() return true end
end

-- Ratings move with every proc, so reading them mid-fight makes a bar that
-- jitters and a comparison that means nothing. Read out of combat, serve the
-- last good reading during it.
local ratingCache = {}

local function ratingOf(stat)
	local index = ratingIndexFor(stat)
	if not index or not GetCombatRating then return ratingCache[stat] end
	if not InCombatLockdown() then
		local ok, value = pcall(GetCombatRating, index)
		if ok and value and canRead(value) then
			ratingCache[stat] = value
			return value
		end
	end
	return ratingCache[stat]
end

local SPEC_BY_ID = { [102] = "Balance", [103] = "Feral", [104] = "Guardian", [105] = "Resto" }

local function playerSpec()
	local api = C_SpecializationInfo
	if not (api and api.GetSpecialization and api.GetSpecializationInfo) then return nil end
	local index = api.GetSpecialization()
	if not index then return nil end
	local ok, id = pcall(api.GetSpecializationInfo, index)
	return ok and SPEC_BY_ID[id] or nil
end

-- u.gg's hero keys are the display name lowercased, apostrophes dropped and
-- spaces hyphenated: "Druid of the Claw" -> "druid-of-the-claw", "Elune's
-- Chosen" -> "elunes-chosen". Deriving the key beats a hardcoded id table,
-- which would need editing every time Blizzard adds a hero tree. Kept separate
-- from the API call so /bis test can prove the rule without a game client.
-- Both apostrophes are stripped. The game has shipped the typographic one
-- (U+2019, "\226\128\153" in UTF-8) in names before, and it would not match a
-- plain one, so the slug would silently miss and fall back to the aggregate.
local function heroSlug(displayName)
	if not displayName or displayName == "" then return nil end
	local slug = displayName:lower()
	slug = slug:gsub("\226\128\153", ""):gsub("'", "")
	slug = slug:gsub("%s+", "-"):gsub("[^%w%-]", "")
	return slug ~= "" and slug or nil
end

local function activeHero()
	if not (C_ClassTalents and C_ClassTalents.GetActiveHeroTalentSpec) then return nil end
	if not (C_Traits and C_Traits.GetSubTreeInfo) then return nil end
	local subTreeID = C_ClassTalents.GetActiveHeroTalentSpec()
	if not subTreeID or subTreeID == 0 then return nil end
	local ok, info = pcall(C_Traits.GetSubTreeInfo, subTreeID)
	if not ok or not info or not info.name then return nil end
	return heroSlug(info.name)
end

-- Raid or Mythic+, read off where you are standing. That is right more often
-- than a remembered setting, and it is still overridable, because gearing for
-- Tuesday happens in a city.
local function autoContext()
	if not GetInstanceInfo then return nil end
	local _, instanceType = GetInstanceInfo()
	if instanceType == "party" then return "mplus" end
	if instanceType == "raid" then return "raid" end
	return nil
end

local function statContext()
	local chosen = db().statContext
	if chosen == "raid" or chosen == "mplus" then return chosen, true end
	return autoContext() or "raid", false
end

local CONTEXT_LABEL = { raid = "Raid", mplus = "Mythic+" }

-- Returns the four target ratings, and the hero key they came from. A nil hero
-- means the aggregate was used, which the panel says out loud: for Feral raid
-- the aggregate wants 775 crit and Druid of the Claw wants 1225, so a silent
-- fallback would be wrong by more than half.
local function targetsFor(spec, context)
	local bySpec = STAT_TARGET[spec]
	if not bySpec then return nil end

	-- The hero talent read is the player's own. Applying it to a spec the
	-- player is not in would be reading one character's talents onto another
	-- spec's targets, so it only counts when the two agree.
	local hero = (spec == playerSpec()) and activeHero() or nil
	if hero and bySpec[hero] and bySpec[hero][context] then
		return bySpec[hero][context], hero
	end
	return bySpec.all and bySpec.all[context] or nil, nil
end

local function statsOf(link)
	if not link or not C_Item or not C_Item.GetItemStats then return nil end
	local ok, stats = pcall(C_Item.GetItemStats, link)
	if not ok or type(stats) ~= "table" then return nil end
	local out = {}
	for _, stat in ipairs(STATS) do
		out[stat] = 0
		for _, key in ipairs(STAT_ITEM_KEYS[stat]) do
			local value = tonumber(stats[key])
			if value then
				out[stat] = value
				break
			end
		end
	end
	return out
end

-- INVTYPE -> the inventory slots an item of that type can go in. SLOT_INVENTORY
-- above answers the same question for this addon's own slot names; this one
-- answers it for an arbitrary item link, which is what a tooltip has.
local INVTYPE_SLOTS = {
	INVTYPE_HEAD = { 1 },            INVTYPE_NECK = { 2 },
	INVTYPE_SHOULDER = { 3 },        INVTYPE_CLOAK = { 15 },
	INVTYPE_CHEST = { 5 },           INVTYPE_ROBE = { 5 },
	INVTYPE_WAIST = { 6 },           INVTYPE_LEGS = { 7 },
	INVTYPE_FEET = { 8 },            INVTYPE_WRIST = { 9 },
	INVTYPE_HAND = { 10 },
	INVTYPE_FINGER = { 11, 12 },     INVTYPE_TRINKET = { 13, 14 },
	INVTYPE_WEAPON = { 16, 17 },     INVTYPE_2HWEAPON = { 16 },
	INVTYPE_WEAPONMAINHAND = { 16 }, INVTYPE_WEAPONOFFHAND = { 17 },
	INVTYPE_HOLDABLE = { 17 },       INVTYPE_SHIELD = { 17 },
	INVTYPE_RANGED = { 16 },         INVTYPE_RANGEDRIGHT = { 16 },
}

-- What this item would take off you, as four rating deltas.
--
-- For a slot you wear two of (rings, trinkets, dual weapons) the piece that
-- comes off is the weaker one, so that is what it is compared against. Weaker
-- here means the lower total of the four secondary ratings, which is the same
-- question the comparison is about; item level would be the wrong measure,
-- because a higher-level piece with the wrong two stats is exactly the thing
-- this panel exists to catch.
--
-- An empty slot counts as zero rather than being skipped: an empty ring finger
-- is a real comparison and the honest answer is "all of it".
local function deltaAgainstEquipped(link)
	local incoming = statsOf(link)
	if not incoming then return nil end

	local id = tonumber(link:match("item:(%d+)"))
	if not id then return nil end
	local _, _, _, equipLoc = C_Item.GetItemInfoInstant(id)
	local slots = INVTYPE_SLOTS[equipLoc or ""]
	if not slots then return nil end

	local weakest, weakestTotal, replacedLink
	for _, slotID in ipairs(slots) do
		local worn = GetInventoryItemLink("player", slotID)
		local wornStats = worn and statsOf(worn) or ZERO_STATS
		local total = 0
		for _, stat in ipairs(STATS) do total = total + wornStats[stat] end
		if not weakestTotal or total < weakestTotal then
			weakest, weakestTotal, replacedLink = wornStats, total, worn
		end
	end
	if not weakest then return nil end

	local delta = {}
	for _, stat in ipairs(STATS) do delta[stat] = incoming[stat] - weakest[stat] end
	return delta, replacedLink
end

-- How a rating stands against its target. Within 5% is "at": these numbers are
-- observed from logs, not solved, so treating 1220 and 1225 as different would
-- be reading precision into them that is not there.
local function statVerdict(current, target)
	if not current or not target or target <= 0 then return nil end
	local off = (current - target) / target
	if math.abs(off) < 0.05 then return "at" end
	return off > 0 and "above" or "below"
end

local VERDICT_COLOUR = { at = "|cff40ff70", above = "|cff5aa9ff", below = "|cffff6666" }
local VERDICT_WORD   = { at = "on target",  above = "over",       below = "under" }

-- Defined with the panes further down, because that is where the panes it
-- pushes to are built. Declared here so the tooltip hook, which comes first,
-- can call it: the hook is the one place that already sees every item the
-- player looks at, wherever they look at it.
local setPreview

-- The same answer as the pane, in words, on the item itself. One line per stat
-- the item actually carries: a line reading "Crit 0 -> 0" is noise, and a piece
-- with no secondary stats at all gets nothing rather than four zeroes.
local function addStatLines(tooltip, link)
	if not link then return end
	local spec = playerSpec()
	if not spec then return end

	local context = statContext()
	local targets = targetsFor(spec, context)
	if not targets then return end

	local deltas = deltaAgainstEquipped(link)
	if not deltas then return end

	local any = false
	for _, stat in ipairs(STATS) do
		local delta = deltas[stat]
		if delta ~= 0 then
			if not any then
				tooltip:AddLine(GREY .. "Against your " .. CONTEXT_LABEL[context]
					.. " targets, versus what it replaces:|r")
				any = true
			end
			local current = ratingOf(stat) or 0
			local after = current + delta
			local verdict = statVerdict(after, targets[stat])
			tooltip:AddDoubleLine(
				("  %s %s%+d|r"):format(STAT_LABEL[stat],
					delta > 0 and GREEN or "|cffff6666", delta),
				("%s%d|r %s/ %d, %s|r"):format(
					VERDICT_COLOUR[verdict] or WHITE, after,
					GREY, targets[stat], VERDICT_WORD[verdict] or "?"))
		end
	end
end

-- Tooltip ------------------------------------------------------------------

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip)
	if tooltip ~= GameTooltip and tooltip ~= ItemRefTooltip then return end
	local name, link, id = TooltipUtil.GetDisplayedItem(tooltip)
	-- GetDisplayedItem's name comes from the item cache, which can be cold on
	-- the first hover of a fresh drop. The link is always there, so read it.
	if not name and link then name = link:match("|h%[(.-)%]|h") end
	if not name then return end

	-- only annotate gear, so bags and the auction house stay quiet
	if id then
		local _, _, _, equipLoc = C_Item.GetItemInfoInstant(id)
		if not equipLoc or equipLoc == "" or equipLoc == "INVTYPE_NON_EQUIP_IGNORE" then return end
	end

	local entry = match(name)
	if entry then
		tooltip:AddLine(GREEN .. "BiS: " .. table.concat(entry.specs, ", ") .. "|r")
	else
		tooltip:AddLine(GREY .. "Not BiS" .. "|r")
	end

	-- Feed the stat panes, then say the same thing here in words. The panes are
	-- the picture; a loot roll does not always have one open.
	if link then setPreview(link) end
	addStatLines(tooltip, link)
end)

-- Clearing on hide, not on the next hover, so a pane does not sit there showing
-- what a bag item would have done ten seconds after the mouse left it.
GameTooltip:HookScript("OnHide", function() setPreview(nil) end)

-- Bonus rolls ---------------------------------------------------------------
--
-- Season 2 brought bonus rolls back at one coin per instance, and they now roll
-- at Great Vault item level rather than boss level, so a coin is worth more
-- than it used to be. The only question this can answer is the useful one:
-- can this place drop something you actually want?

local function bisFrom(sourceName)
	if not sourceName or sourceName == "" then return {} end
	local want = sourceName:lower()
	local found = {}
	for _, entry in pairs(lookup) do
		local boss = bossOf(entry.boss):lower()
		-- loose both ways: the game says "Temple of Sethraliss" where a guide
		-- might say "Sethraliss", and a boss name can be a substring either way
		if boss ~= "crafted"
			and (boss == want or want:find(boss, 1, true) or boss:find(want, 1, true)) then
			found[#found + 1] = entry
		end
	end
	table.sort(found, function(a, b) return a.name < b.name end)
	return found
end

local function bonusRollVerdict(sourceName)
	if not sourceName or sourceName == "" then return end
	local found = bisFrom(sourceName)

	if #found == 0 then
		RaidWarningUtil.AddMessage("Bonus roll: NO\n" .. sourceName, ChatTypeInfo["RAID_WARNING"])
		print(GREY .. "[BiS] nothing BiS drops from " .. sourceName .. ". Keep the coin.|r")
		return
	end

	RaidWarningUtil.AddMessage("Bonus roll: YES\n" .. sourceName, ChatTypeInfo["RAID_WARNING"])
	PlaySound(SOUNDKIT.RAID_WARNING)
	print(GOLD .. "[BiS] worth a coin at " .. sourceName .. ":|r")
	for _, entry in ipairs(found) do
		print("   " .. (linkFor(entry.name) or entry.name)
			.. GREEN .. "  " .. table.concat(entry.specs, ", ") .. "|r")
	end
end

-- Loot roll ----------------------------------------------------------------

local roll = CreateFrame("Frame")
roll:RegisterEvent("START_LOOT_ROLL")
roll:RegisterEvent("CHALLENGE_MODE_COMPLETED")
roll:RegisterEvent("ENCOUNTER_END")
roll:SetScript("OnEvent", function(_, event, arg1, arg2, _, _, success)
	if event == "CHALLENGE_MODE_COMPLETED" then
		bonusRollVerdict((GetInstanceInfo()))
		return
	end
	if event == "ENCOUNTER_END" then
		if success == 1 then bonusRollVerdict(arg2) end  -- arg2 is the boss name
		return
	end

	local link = GetLootRollItemLink and GetLootRollItemLink(arg1)
	if not link then return end
	local name = link:match("|h%[(.-)%]|h")
	local entry = match(name)

	if entry then
		local specs = table.concat(entry.specs, ", ")
		-- RaidNotice_AddMessage is deprecation-shim only, and the shim is gated
		-- behind the loadDeprecationFallbacks CVar. This is what it calls.
		RaidWarningUtil.AddMessage("BiS: " .. specs .. "\n" .. name,
			ChatTypeInfo["RAID_WARNING"])
		PlaySound(SOUNDKIT.RAID_WARNING)
		print(GREEN .. "[BiS] ROLL|r " .. link .. " -> " .. specs)
	else
		print(GREY .. "[BiS] pass|r " .. link)
	end
end)

-- What you are wearing -------------------------------------------------------
--
-- The slot ids and the GetDetailedItemLevelInfo route are lifted from
-- DjinnisCharacterFrame/Data.lua, which already solved this properly. Copied
-- rather than shared: that addon is dormant and is not installed in the game,
-- so a runtime dependency on it would be a dependency on nothing.

local SLOT_INVENTORY = {
	Head     = { 1 },  Neck    = { 2 },      Shoulder = { 3 },
	Chest    = { 5 },  Waist   = { 6 },      Legs     = { 7 },
	Feet     = { 8 },  Wrist   = { 9 },      Hands    = { 10 },
	Finger   = { 11, 12 },                   Trinket  = { 13, 14 },
	Back     = { 15 },
	["Main Hand"] = { 16 }, ["Off Hand"] = { 17 },
	-- Two Hand deliberately has no slot: a two-hander already shows under Main
	-- Hand, and listing slot 16 twice would print the same weapon twice.
	["Two Hand"] = {},
}

local function itemLevelOf(link)
	if not link or not C_Item.GetDetailedItemLevelInfo then return nil end
	local ok, ilvl = pcall(C_Item.GetDetailedItemLevelInfo, link)
	return ok and ilvl or nil
end

local function equippedIn(slot)
	local worn = {}
	for _, slotID in ipairs(SLOT_INVENTORY[slot] or {}) do
		local link = GetInventoryItemLink("player", slotID)
		if link then
			worn[#worn + 1] = {
				link = link,
				ilvl = itemLevelOf(link),
				id = tonumber(link:match("item:(%d+)")),
			}
		end
	end
	return worn
end

-- rebuilt on every render, so the ticks follow you changing gear
local wornIds = {}
local function refreshWornIds()
	wornIds = {}
	for slot in pairs(SLOT_INVENTORY) do
		for _, worn in ipairs(equippedIn(slot)) do
			if worn.id then wornIds[worn.id] = true end
		end
	end
end

-- Lines --------------------------------------------------------------------
--
-- Both tabs render the same thing: a flat list of { text, link }. Only the
-- grouping differs, so the scroll frame and the row pool are shared.

local function byBossLines()
	local groups, rank = {}, {}
	for i, boss in ipairs(BOSS_ORDER) do rank[boss] = i end

	for _, entry in pairs(lookup) do
		local boss = bossOf(entry.boss)
		groups[boss] = groups[boss] or {}
		table.insert(groups[boss], entry)
	end

	local bosses = {}
	for boss in pairs(groups) do bosses[#bosses + 1] = boss end
	table.sort(bosses, function(a, b)
		local ra, rb = rank[a] or 99, rank[b] or 99
		if ra ~= rb then return ra < rb end
		return a < b
	end)

	local lines = {
		{ text = GREY .. "Every BiS item, grouped by who drops it." .. "|r" },
		{ text = "" },
	}
	for _, boss in ipairs(bosses) do
		lines[#lines + 1] = { text = GOLD .. boss .. "|r" }
		local entries = groups[boss]
		table.sort(entries, function(a, b) return a.name < b.name end)
		for _, entry in ipairs(entries) do
			local link = linkFor(entry.name)
			lines[#lines + 1] = {
				text = "  " .. (link or WHITE .. entry.name .. "|r")
					.. GREEN .. "  " .. table.concat(entry.specs, ", ") .. "|r",
				link = link,
				name = entry.name,
			}
		end
		lines[#lines + 1] = { text = "" }
	end
	return lines
end

-- Tab 2 mirrors the character sheet: slots down the left, slots down the right,
-- weapons across the bottom. Where the two sites disagree the slot holds two
-- items stacked, so the disagreement stays visible rather than me picking a
-- winner and hiding it.

-- Weapons hang off the bottom of the left column rather than sitting in a
-- full-width band underneath. The right column carries the rings and trinkets
-- and so runs much longer, which left a hole under Wrist; this fills it and
-- keeps the whole spec on one screen without scrolling.
local DOLL_LEFT  = { "Head", "Neck", "Shoulder", "Back", "Chest", "Wrist",
                     "Main Hand", "Off Hand", "Two Hand" }
local DOLL_RIGHT = { "Hands", "Waist", "Legs", "Feet", "Finger", "Trinket" }

local function itemsBySlot(spec)
	local groups = {}
	for _, item in ipairs(BIS[spec]) do
		groups[item.slot] = groups[item.slot] or {}
		table.insert(groups[item.slot], item)
	end
	return groups
end

-- long form for the list, short form for the cramped doll cells
local function shortSite(site)
	if site == BOTH then return "" end
	return GREY .. " (" .. (site == M and "M" or "IV") .. ")|r"
end

-- Window -------------------------------------------------------------------

local ROW_HEIGHT = 15
local ILVL_WIDTH = 70
local WINDOW_W = 900  -- two columns wide enough for the long tier set names
local CONTENT_W = WINDOW_W - 50  -- window minus the insets and the scrollbar
local rowPool = {}
local window
local activeTab, activeSpec = 1, "Balance"
-- forward declarations: the row closures and refresh reference these
local refresh, openTrackMenu, renderList, renderDoll

-- Both the list rows and the doll cells want the same two behaviours, so they
-- are built once here rather than twice.

local function attachIlvlButton(parent)
	local b = CreateFrame("Button", nil, parent)
	b:SetSize(ILVL_WIDTH, ROW_HEIGHT)
	b:SetPoint("RIGHT", parent, "RIGHT")
	b.text = b:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	b.text:SetAllPoints()
	b.text:SetJustifyH("RIGHT")
	b:SetScript("OnClick", function(self)
		if self.itemName then openTrackMenu(self, self.itemName) end
	end)
	b:SetScript("OnEnter", function(self)
		if not self.itemName then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("Click to set the item level you are chasing")
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

local function attachItemHover(frame)
	frame:SetScript("OnEnter", function(self)
		if not self.link then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetHyperlink(self.link)
		GameTooltip:Show()
	end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnClick", function(self)
		if self.link then HandleModifiedItemClick(self.link) end
	end)
end

local function acquireRow(content, index)
	local row = rowPool[index]
	if not row then
		row = CreateFrame("Button", nil, content)
		row:SetHeight(ROW_HEIGHT)
		row.text = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightLeft")
		row.text:SetPoint("LEFT")
		row.text:SetPoint("RIGHT", row, "RIGHT", -(ILVL_WIDTH + 4), 0)
		row.text:SetJustifyH("LEFT")
		row.text:SetWordWrap(false)  -- a wrapped name overlaps the row beneath
		row.ilvl = attachIlvlButton(row)
		attachItemHover(row)
		row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(index - 1) * ROW_HEIGHT)
		row:SetPoint("RIGHT", content, "RIGHT")
		rowPool[index] = row
	end
	return row
end

-- Doll cells ---------------------------------------------------------------

local CELL_ITEM, CELL_HEAD = 20, 16
local SIM_EXTRAS_SHOWN = 12
local TIER_ROWS_SHOWN = 12
local cellPool = {}

local function acquireCell(content, index)
	local cell = cellPool[index]
	if not cell then
		cell = CreateFrame("Button", nil, content)
		cell.icon = cell:CreateTexture(nil, "ARTWORK")
		cell.icon:SetSize(16, 16)
		cell.icon:SetPoint("LEFT")
		cell.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)  -- trim the icon border
		-- small font: the tier set names are long and the columns are narrow
		cell.text = cell:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		cell.text:SetJustifyH("LEFT")
		cell.text:SetWordWrap(false)
		cell.ilvl = attachIlvlButton(cell)
		attachItemHover(cell)
		cellPool[index] = cell
	end
	return cell
end

local function setHeaderCell(cell, slot)
	cell:SetHeight(CELL_HEAD)
	cell.icon:Hide()
	cell.ilvl:Hide()
	cell.link, cell.ilvl.itemName = nil, nil
	cell.text:ClearAllPoints()
	cell.text:SetPoint("LEFT", cell, "LEFT", 0, 0)
	cell.text:SetPoint("RIGHT", cell, "RIGHT", 0, 0)
	cell.text:SetText(GOLD .. slot .. "|r")
end

-- every item-shaped cell lays out the same way: icon, then text, then the
-- right-hand item level button
local function beginItemCell(cell)
	cell:SetHeight(CELL_ITEM)
	cell.icon:Show()
	cell.ilvl:Show()
	cell.text:ClearAllPoints()
	cell.text:SetPoint("LEFT", cell.icon, "RIGHT", 4, 0)
	cell.text:SetPoint("RIGHT", cell.ilvl, "LEFT", -4, 0)
end

local function setItemCell(cell, item)
	local link = linkFor(item.name)
	beginItemCell(cell)

	local icon = link and select(5, C_Item.GetItemInfoInstant(link))
	cell.icon:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")
	local id = itemIdFor(item.name)
	local have = id and wornIds[id] and "|TInterface\\RaidFrame\\ReadyCheck-Ready:12|t" or ""
	cell.text:SetText(have .. (link or WHITE .. item.name .. "|r") .. shortSite(item.site)
		.. tierText(tiersFor(activeSpec, id, item.name))
		.. gainText(simGain(activeSpec, item.name)))
	cell.link = link
	cell.ilvl.itemName = item.name
	cell.ilvl.text:SetText(gearLabel(item.name))
end

local function setWearingCell(cell, worn)
	beginItemCell(cell)

	cell.icon:SetTexture(select(5, C_Item.GetItemInfoInstant(worn.link))
		or "Interface\\Icons\\INV_Misc_QuestionMark")
	cell.text:SetText(GREY .. "on you |r" .. worn.link
		.. tierText(tiersFor(activeSpec, worn.id, nameFromLink(worn.link))))
	cell.link = worn.link
	cell.ilvl.itemName = nil  -- this is what you have, not a target to set
	cell.ilvl.text:SetText(GREY .. (worn.ilvl or "?") .. "|r")
end

-- An item your sim rated that no BiS list mentions. Known only by item id, so
-- the name and icon come from the client's item cache; a cold cache shows the
-- bare id once and is correct on the next open.
local function setSimCell(cell, id, info)
	beginItemCell(cell)

	local _, link = C_Item.GetItemInfo(id)
	if not link then C_Item.RequestLoadItemDataByID(id) end
	cell.icon:SetTexture(select(5, C_Item.GetItemInfoInstant(id))
		or "Interface\\Icons\\INV_Misc_QuestionMark")
	cell.text:SetText((link or WHITE .. "item " .. id .. "|r")
		.. tierText(tiersFor(activeSpec, id, nameFromLink(link))) .. gainText(info.gain))
	cell.link = link
	cell.ilvl.itemName = nil  -- no target to set: the sim already fixed its level
	cell.ilvl.text:SetText(GREY .. (info.ilvl or "?") .. "|r")
end

-- A trinket rated by u.gg or Icy Veins, drawn whether or not any BiS list or
-- sim mentions it. Same cold-cache handling as the sim cell above: an id the
-- client has never seen shows bare once and is right on the next open.
local function setTierCell(cell, id, tiers, worn)
	beginItemCell(cell)

	local _, link = C_Item.GetItemInfo(id)
	if not link then C_Item.RequestLoadItemDataByID(id) end
	cell.icon:SetTexture(select(5, C_Item.GetItemInfoInstant(id))
		or "Interface\\Icons\\INV_Misc_QuestionMark")
	local have = worn and "|TInterface\\RaidFrame\\ReadyCheck-Ready:12|t" or ""
	cell.text:SetText(have .. (link or WHITE .. "item " .. id .. "|r") .. tierText(tiers))
	cell.link = link
	cell.ilvl.itemName = nil  -- a rating, not a piece you are aiming at a rank
	cell.ilvl.text:SetText("")
end

openTrackMenu = function(owner, itemName)
	MenuUtil.CreateContextMenu(owner, function(_, root)
		root:CreateTitle(itemName)
		for _, track in ipairs(TRACKS) do
			local submenu = root:CreateButton(track.name)
			for rank, ilvl in ipairs(track.ilvl) do
				submenu:CreateButton(rank .. "/6      " .. ilvl, function()
					setGear(itemName, track.name, rank)
					refresh()
				end)
			end
		end
		root:CreateButton(MYTHIC_RAID.name .. "      " .. MYTHIC_RAID.ilvl, function()
			setGear(itemName, MYTHIC_RAID.name, 0)
			refresh()
		end)
		root:CreateButton("Clear", function()
			setGear(itemName, nil)
			refresh()
		end)
	end)
end

refresh = function()
	if not window then return end
	pcall(harvestFromJournal)
	pcall(resolveFromCache)
	pcall(resolveFromSim)
	pcall(refreshTierNames)

	for i, button in ipairs(window.tabs) do
		if i == activeTab then button:LockHighlight() else button:UnlockHighlight() end
	end
	for _, button in ipairs(window.specs) do
		-- the Stats tab is per spec too, so its buttons stay up on both
		button:SetShown(activeTab ~= 1)
		if button.spec == activeSpec then button:LockHighlight() else button:UnlockHighlight() end
	end

	window.scroll:SetShown(activeTab ~= 3)
	window.statPane:SetShown(activeTab == 3)

	if activeTab == 3 then
		window.statPane:Update()
		return
	end

	if activeTab == 1 then
		for i = 1, #cellPool do cellPool[i]:Hide() end
		renderList(byBossLines())
	else
		for i = 1, #rowPool do rowPool[i]:Hide() end
		renderDoll()
	end
	window.scroll:SetVerticalScroll(0)
end

renderList = function(lines)
	for i, line in ipairs(lines) do
		local row = acquireRow(window.content, i)
		row.text:SetText(line.text)
		row.link = line.link
		row.ilvl.itemName = line.name
		row.ilvl.text:SetText(line.name and gearLabel(line.name) or "")
		row.ilvl:SetShown(line.name ~= nil)
		row:Show()
	end
	for i = #lines + 1, #rowPool do rowPool[i]:Hide() end
	window.content:SetSize(CONTENT_W, #lines * ROW_HEIGHT + 20)
end

renderDoll = function()
	local content = window.content
	local groups = itemsBySlot(activeSpec)
	local colW = (CONTENT_W - 16) / 2
	local used = 0
	refreshWornIds()

	local function place(x, y, width, setup)
		used = used + 1
		local cell = acquireCell(content, used)
		cell:ClearAllPoints()
		cell:SetPoint("TOPLEFT", content, "TOPLEFT", x, -y)
		cell:SetWidth(width)
		setup(cell)
		cell:Show()
		return y + cell:GetHeight()
	end

	local function column(slots, x, y)
		for _, slot in ipairs(slots) do
			local items = groups[slot]
			if items then
				y = place(x, y, colW, function(cell) setHeaderCell(cell, slot) end)
				-- what you have on right now, above what you are chasing
				for _, worn in ipairs(equippedIn(slot)) do
					y = place(x, y, colW, function(cell) setWearingCell(cell, worn) end)
				end
				for _, item in ipairs(items) do
					y = place(x, y, colW, function(cell) setItemCell(cell, item) end)
				end
				y = y + 6
			end
		end
		return y
	end

	local leftY  = column(DOLL_LEFT, 0, 4)
	local rightY = column(DOLL_RIGHT, colW + 16, 4)
	local y = math.max(leftY, rightY) + 10

	-- Every trinket the two sites rate for this spec, best first. The BiS list
	-- above answers "what should I chase"; this answers "the thing that just
	-- dropped is not on the list, is it any good".
	if classCodexLoaded() then
		y = place(0, y, CONTENT_W - 20, function(cell)
			setHeaderCell(cell, "Trinket ranks are off: ClassCodex is loaded and keeps them current")
		end)
	else
		local ranked = {}
		for id, tiers in pairs(TRINKET_TIER[activeSpec] or {}) do
			ranked[#ranked + 1] = { id = id, tiers = tiers, rank = bestTier(tiers) }
		end
		if #ranked > 0 then
			table.sort(ranked, function(a, b)
				if a.rank ~= b.rank then return a.rank < b.rank end
				return a.id < b.id
			end)

			-- the stamp is on screen on purpose: this table is a copy of a
			-- moving thing, so how old it is belongs next to what it claims
			y = place(0, y, CONTENT_W - 20, function(cell)
				setHeaderCell(cell, "Trinket ranks  " .. GREY
					.. "u.gg / Icy Veins, two letters where they disagree  --  "
					.. TRINKET_TIER_SOURCE .. "|r")
			end)
			local shown = math.min(#ranked, TIER_ROWS_SHOWN)
			for i = 1, shown do
				local entry = ranked[i]
				y = place(0, y, CONTENT_W - 20, function(cell)
					setTierCell(cell, entry.id, entry.tiers, wornIds[entry.id])
				end)
			end
			-- never hide a cut silently
			if #ranked > shown then
				y = place(0, y, CONTENT_W - 20, function(cell)
					setHeaderCell(cell, ("... and %d lower-rated trinkets, not shown")
						:format(#ranked - shown))
				end)
			end
		end
	end

	-- Anything your own sim rates that the two BiS lists never mentioned. This
	-- is the part no public list can give you, because it is your gear.
	local sim = simFor(activeSpec)
	if sim then
		local onList = {}
		for _, item in ipairs(BIS[activeSpec]) do
			local id = itemIdFor(item.name)
			if id then onList[id] = true end
		end

		local extras = {}
		for id, info in pairs(sim.items) do
			if not onList[id] and info.gain > 0 then
				extras[#extras + 1] = { id = id, info = info }
			end
		end
		table.sort(extras, function(a, b) return a.info.gain > b.info.gain end)

		y = place(0, y, CONTENT_W - 20, function(cell)
			setHeaderCell(cell, "Your sim rates these, and no BiS list mentions them")
		end)
		local shown = math.min(#extras, SIM_EXTRAS_SHOWN)
		for i = 1, shown do
			y = place(0, y, CONTENT_W - 20, function(cell)
				setSimCell(cell, extras[i].id, extras[i].info)
			end)
		end
		-- never hide a cut silently
		if #extras > shown then
			y = place(0, y, CONTENT_W - 20, function(cell)
				setHeaderCell(cell, ("... and %d more gains below these, not shown")
					:format(#extras - shown))
			end)
		end
		y = place(0, y, CONTENT_W - 20, function(cell)
			setHeaderCell(cell, ("Droptimizer imported %s, baseline %d dps")
				:format(sim.when or "?", sim.baseline or 0))
		end)
	end

	for i = used + 1, #cellPool do cellPool[i]:Hide() end
	content:SetSize(CONTENT_W, y + 10)
end

-- The stat pane -------------------------------------------------------------
--
-- One pane, built twice: once as a tab in this window, once bolted to the side
-- of the character sheet. Both call Update, so neither can drift.
--
-- The bar runs to 130% of the target, with a tick on the target itself. Two
-- reasons for the overshoot room rather than filling to 100%: a bar that is
-- simply full cannot show HOW far over you are, and being over is a real state
-- worth seeing, because rating spent above a target is rating not spent on the
-- stat that is under one.

local PANE_W = 300
local BAR_W, BAR_H = PANE_W - 24, 14
local BAR_SCALE = 1.3
local BAR_ROW_H = 34

local BAR_RGB = {
	at    = { 0.25, 0.85, 0.40 },
	above = { 0.30, 0.62, 0.95 },
	below = { 0.85, 0.30, 0.30 },
}

local function makeStatRow(parent, index)
	local row = CreateFrame("Frame", nil, parent)
	row:SetSize(BAR_W, BAR_ROW_H)
	row:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, -(index - 1) * BAR_ROW_H)

	row.label = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	row.label:SetPoint("TOPLEFT")
	row.label:SetJustifyH("LEFT")

	row.value = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	row.value:SetPoint("TOPRIGHT")
	row.value:SetJustifyH("RIGHT")

	local bar = CreateFrame("Frame", nil, row)
	bar:SetSize(BAR_W, BAR_H)
	bar:SetPoint("BOTTOMLEFT")

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints()
	bar.bg:SetColorTexture(0.08, 0.08, 0.08, 0.9)

	bar.fill = bar:CreateTexture(nil, "ARTWORK")
	bar.fill:SetPoint("TOPLEFT")
	bar.fill:SetPoint("BOTTOMLEFT")
	bar.fill:SetColorTexture(1, 1, 1, 1)

	-- What the hovered item would add or take away, drawn from where you are
	-- now to where you would be. Its own layer so it sits over the fill when it
	-- is a loss and beside it when it is a gain.
	bar.ghost = bar:CreateTexture(nil, "OVERLAY")
	bar.ghost:SetPoint("TOP")
	bar.ghost:SetPoint("BOTTOM")

	bar.tick = bar:CreateTexture(nil, "OVERLAY", nil, 2)
	bar.tick:SetPoint("TOP")
	bar.tick:SetPoint("BOTTOM")
	bar.tick:SetWidth(2)
	bar.tick:SetColorTexture(1, 0.85, 0.35, 1)

	row.bar = bar
	return row
end

-- x offset on the bar for a rating, clamped to the bar
local function barX(rating, target)
	if not target or target <= 0 then return 0 end
	local ratio = rating / (target * BAR_SCALE)
	return math.max(0, math.min(1, ratio)) * BAR_W
end

local function setStatRow(row, stat, current, target, delta)
	local verdict = statVerdict(current, target)
	local rgb = BAR_RGB[verdict] or BAR_RGB.below

	row.label:SetText(STAT_LABEL[stat])

	local text = ("%d %s/ %d|r"):format(current, GREY, target)
	if delta and delta ~= 0 then
		local after = current + delta
		local afterVerdict = statVerdict(after, target)
		text = ("%d %s->|r %s%d|r %s/ %d|r"):format(
			current, GREY,
			VERDICT_COLOUR[afterVerdict] or WHITE, after,
			GREY, target)
	end
	row.value:SetText(text)

	local bar = row.bar
	local x = barX(current, target)
	bar.fill:SetWidth(math.max(1, x))
	bar.fill:SetColorTexture(rgb[1], rgb[2], rgb[3], 0.85)
	bar.tick:ClearAllPoints()
	bar.tick:SetPoint("TOP", bar, "TOPLEFT", BAR_W / BAR_SCALE, 0)
	bar.tick:SetPoint("BOTTOM", bar, "BOTTOMLEFT", BAR_W / BAR_SCALE, 0)

	if not delta or delta == 0 then
		bar.ghost:Hide()
		return
	end

	local afterX = barX(current + delta, target)
	local left, right = math.min(x, afterX), math.max(x, afterX)
	bar.ghost:ClearAllPoints()
	bar.ghost:SetPoint("LEFT", bar, "LEFT", left, 0)
	bar.ghost:SetWidth(math.max(1, right - left))
	if delta > 0 then
		bar.ghost:SetColorTexture(1, 1, 1, 0.75)
	else
		bar.ghost:SetColorTexture(0.95, 0.2, 0.2, 0.9)
	end
	bar.ghost:Show()
end

-- Every pane built, so one hover updates all of them. Two entries at most, but
-- the list is what makes "they cannot disagree" true rather than hoped for.
local statPanes = {}
local previewLink

local function buildStatPane(parent, opts)
	local pane = CreateFrame("Frame", nil, parent)
	pane:SetWidth(PANE_W)

	pane.heading = pane:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	pane.heading:SetPoint("TOPLEFT", 12, -8)
	pane.heading:SetPoint("RIGHT", pane, "RIGHT", -12, 0)
	pane.heading:SetJustifyH("LEFT")

	pane.context = CreateFrame("Button", nil, pane, "UIPanelButtonTemplate")
	pane.context:SetSize(88, 20)
	pane.context:SetPoint("TOPRIGHT", -12, -4)
	pane.context:SetScript("OnClick", function()
		local now = statContext()
		db().statContext = (now == "raid") and "mplus" or "raid"
		for _, other in ipairs(statPanes) do other:Update() end
	end)

	pane.rows = CreateFrame("Frame", nil, pane)
	pane.rows:SetPoint("TOPLEFT", 0, -30)
	pane.rows:SetSize(PANE_W, #STATS * BAR_ROW_H)
	pane.bars = {}
	for i, _ in ipairs(STATS) do
		pane.bars[i] = makeStatRow(pane.rows, i)
	end

	pane.footer = pane:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	pane.footer:SetPoint("TOPLEFT", pane.rows, "BOTTOMLEFT", 12, -4)
	pane.footer:SetPoint("RIGHT", pane, "RIGHT", -12, 0)
	pane.footer:SetJustifyH("LEFT")
	pane.footer:SetWordWrap(true)

	pane:SetHeight(30 + #STATS * BAR_ROW_H + 46)

	function pane:Update()
		-- opts.spec is a function so the window's pane follows its spec buttons
		-- and the character sheet's pane follows the character.
		local spec = opts.spec and opts.spec() or playerSpec()
		local context, pinned = statContext()
		self.context:SetText(CONTEXT_LABEL[context] .. (pinned and "" or " *"))

		-- `spec and targetsFor(...)` would keep only the first return, which is
		-- how the hero name would silently go missing
		local targets, hero
		if spec then targets, hero = targetsFor(spec, context) end
		if not targets then
			self.heading:SetText(GREY .. "No stat targets for this spec.|r")
			for _, row in ipairs(self.bars) do row:Hide() end
			self.footer:SetText("")
			return
		end
		for _, row in ipairs(self.bars) do row:Show() end

		local deltas, replaced
		if previewLink then deltas, replaced = deltaAgainstEquipped(previewLink) end

		self.heading:SetText(("%s%s|r  %s%s|r"):format(
			GOLD, spec,
			GREY, hero and hero:gsub("-", " ") or "all hero talents"))

		for i, stat in ipairs(STATS) do
			setStatRow(self.bars[i], stat, ratingOf(stat) or 0, targets[stat],
				deltas and deltas[stat])
		end

		local note
		if deltas then
			local name = previewLink:match("|h%[(.-)%]|h") or "that item"
			note = ("%svs %s|r"):format(GREY, replaced
				and ("your " .. (replaced:match("|h%[(.-)%]|h") or "equipped piece"))
				or "an empty slot")
			note = ("%s%s|r\n%s"):format(WHITE, name, note)
		elseif not hero then
			-- Say it, do not hide it: the aggregate can be half the right number
			note = GREY .. "No targets for your hero talent, so this is the "
				.. "average across all of them.|r"
		else
			note = GREY .. STAT_TARGET_SOURCE .. "|r"
		end
		self.footer:SetText(note)
	end

	statPanes[#statPanes + 1] = pane
	return pane
end

-- A hover anywhere is the preview. The tooltip post-call already runs on every
-- item the player looks at, so this rides it rather than hooking bags, the
-- loot frame, the encounter journal and the auction house one at a time.
setPreview = function(link)
	if link == previewLink then return end
	previewLink = link
	for _, pane in ipairs(statPanes) do
		if pane:IsShown() then pane:Update() end
	end
end

local function buildWindow()
	local f = CreateFrame("Frame", "DjinnisBiSFrame", UIParent, "BasicFrameTemplateWithInset")
	f:SetSize(WINDOW_W, 560)
	f:SetPoint("CENTER")
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:SetClampedToScreen(true)

	-- own title rather than the template's, which has moved between patches
	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOP", f, "TOP", 0, -6)
	title:SetText("Djinni's BiS  " .. GREY .. "The Venomous Abyss|r")

	-- Plain buttons rather than PanelTabButtonTemplate: the tab templates want
	-- PanelTemplates_ bookkeeping and give nothing back for two tabs.
	f.tabs = {}
	local TAB_LABELS = { "By Boss", "By Slot", "Stats" }
	for i, label in ipairs(TAB_LABELS) do
		local button = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		button:SetSize(110, 22)
		button:SetPoint("TOPLEFT", f, "TOPLEFT", 12 + (i - 1) * 114, -28)
		button:SetText(label)
		button:SetScript("OnClick", function() activeTab = i; refresh() end)
		f.tabs[i] = button
	end

	local importButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	importButton:SetSize(130, 22)
	importButton:SetPoint("TOPRIGHT", f, "TOPRIGHT", -14, -28)
	importButton:SetText("Import sim")
	importButton:SetScript("OnClick", function() DjinnisBiS_ShowImport(activeSpec) end)

	f.specs = {}
	for i, spec in ipairs(SPEC_ORDER) do
		local button = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		button:SetSize(104, 22)
		button:SetPoint("TOPLEFT", f, "TOPLEFT", 12 + (i - 1) * 108, -54)
		button:SetText(spec)
		button.spec = spec
		button:SetScript("OnClick", function() activeSpec = spec; refresh() end)
		f.specs[i] = button
	end

	local scroll = CreateFrame("ScrollFrame", "DjinnisBiSScroll", f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 12, -80)
	scroll:SetPoint("BOTTOMRIGHT", -34, 10)
	f.scroll = scroll

	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(CONTENT_W, 10)
	scroll:SetScrollChild(content)
	f.content = content

	-- The Stats tab. It sits over the scroll frame rather than inside it: four
	-- bars never need scrolling, and a scroll child that is sometimes 40 pixels
	-- tall fights the scrollbar.
	f.statPane = buildStatPane(f, { spec = function() return activeSpec end })
	f.statPane:SetPoint("TOPLEFT", 12, -80)
	f.statPane:Hide()

	tinsert(UISpecialFrames, "DjinnisBiSFrame")  -- Escape closes it
	return f
end

function DjinnisBiS_Toggle()
	window = window or buildWindow()
	if window:IsShown() then
		window:Hide()
	else
		refresh()
		window:Show()
	end
end

-- Sim import window ---------------------------------------------------------

local importWindow
local function buildImportWindow()
	local f = CreateFrame("Frame", "DjinnisBiSImport", UIParent, "BasicFrameTemplateWithInset")
	f:SetSize(560, 420)
	f:SetPoint("CENTER")
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetFrameStrata("DIALOG")
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOP", f, "TOP", 0, -6)
	title:SetText("Import a Raidbots Droptimizer")

	local help = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	help:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -32)
	help:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	help:SetJustifyH("LEFT")
	help:SetText(GREY .. "Open your report URL with |r/data.csv" .. GREY
		.. " on the end, select all, copy, paste below. Pick the spec you simmed.|r")

	f.specs = {}
	for i, spec in ipairs(SPEC_ORDER) do
		local button = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		button:SetSize(126, 22)
		button:SetPoint("TOPLEFT", f, "TOPLEFT", 14 + (i - 1) * 130, -62)
		button:SetText(spec)
		button.spec = spec
		button:SetScript("OnClick", function()
			f.spec = spec
			for _, other in ipairs(f.specs) do
				if other.spec == spec then other:LockHighlight() else other:UnlockHighlight() end
			end
		end)
		f.specs[i] = button
	end

	local box = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	box:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -92)
	box:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -34, 62)

	local edit = CreateFrame("EditBox", nil, box)
	edit:SetMultiLine(true)
	edit:SetFontObject("ChatFontNormal")
	edit:SetWidth(490)
	edit:SetAutoFocus(false)
	edit:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	box:SetScrollChild(edit)
	f.edit = edit

	f.status = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	f.status:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 16)
	f.status:SetPoint("RIGHT", f, "RIGHT", -150, 0)
	f.status:SetJustifyH("LEFT")

	local go = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	go:SetSize(120, 24)
	go:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -14, 12)
	go:SetText("Import")
	go:SetScript("OnClick", function()
		local items, baseline, unreadable, count = parseSim(f.edit:GetText())
		if not items then
			f.status:SetText("|cffff0000Could not read that.|r " .. GREY
				.. "No baseline row found, so it is not a Raidbots CSV.|r")
			return
		end
		db().sim = db().sim or {}
		db().sim[f.spec] = {
			items = items,
			baseline = baseline,
			when = (date and date("%d %b %H:%M")) or "?",
		}
		f.status:SetText(GREEN .. count .. " items imported for " .. f.spec .. ".|r "
			.. GREY .. unreadable .. " rows skipped.|r")
		f.edit:SetText("")
		refresh()
	end)

	return f
end

function DjinnisBiS_ShowImport(spec)
	importWindow = importWindow or buildImportWindow()
	importWindow.spec = spec or activeSpec
	for _, button in ipairs(importWindow.specs) do
		if button.spec == importWindow.spec then button:LockHighlight() else button:UnlockHighlight() end
	end
	importWindow.status:SetText("")
	importWindow:Show()
end

-- The button ---------------------------------------------------------------

-- A minimap button via LibDBIcon, which is what DjinnisWarbandManager,
-- DjinnisDelveTracker and DjinnisClassProfiles already use. The floating claw
-- icon this replaces was a placeholder: no minimap docking, no edge clamping
-- to the ring, and no relationship to how the other addons present themselves.
--
-- Registering a LibDataBroker "data source" rather than only a button is the
-- standalone answer to wanting this as a data text. Any broker display picks it
-- up, ElvUI's data texts included, and nothing here depends on another addon
-- being installed. Card 0001.

local function summaryLines(tooltip)
	tooltip:AddLine("Djinni's BiS")

	local where = GetInstanceInfo and (GetInstanceInfo())
	local here = where and bisFrom(where) or {}
	if #here > 0 then
		tooltip:AddLine(("|cff00ff00%d BiS item%s drop here|r")
			:format(#here, #here == 1 and "" or "s"))
		for i = 1, math.min(3, #here) do
			tooltip:AddDoubleLine("  " .. here[i].name,
				table.concat(here[i].specs, ", "))
		end
		if #here > 3 then
			tooltip:AddLine(("|cff808080  and %d more|r"):format(#here - 3))
		end
	elseif where and where ~= "" then
		tooltip:AddLine("|cff808080Nothing BiS drops here|r")
	end

	tooltip:AddLine(" ")
	tooltip:AddLine("|cffaaaaaaClick to open|r")
end

local function buildBroker()
	if not LibStub then return end
	local ldb = LibStub("LibDataBroker-1.1", true)
	if not ldb then return end

	local broker = ldb:NewDataObject("DjinnisBiS", {
		type = "data source",
		text = "BiS",
		icon = "Interface\\Icons\\Ability_Druid_Maul",
		OnClick = function() DjinnisBiS_Toggle() end,
		OnTooltipShow = summaryLines,
	})

	local icon = LibStub("LibDBIcon-1.0", true)
	if icon and broker then
		DjinnisBiSDB = DjinnisBiSDB or {}
		DjinnisBiSDB.minimap = DjinnisBiSDB.minimap or { hide = false }
		icon:Register("DjinnisBiS", broker, DjinnisBiSDB.minimap)
	end
end

-- The character sheet pane --------------------------------------------------
--
-- Anchored beside CharacterFrame, never inside it. Nothing Blizzard owns is
-- moved, resized, reparented or hidden, which is the whole reason this can
-- coexist with a character sheet replacement such as Chonky Character Sheet:
-- that addon reskins Blizzard's frame hard, and anything that also edited it
-- would be fighting for the same textures. Riding alongside costs one anchor
-- and takes that fight off the table.

local function buildCharacterPane()
	if not CharacterFrame then return end

	local holder = CreateFrame("Frame", "DjinnisBiSCharacterPane", CharacterFrame,
		"TooltipBackdropTemplate")
	holder:SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT", 4, -12)
	holder:SetWidth(PANE_W)
	holder:SetFrameStrata("HIGH")

	local pane = buildStatPane(holder, { spec = playerSpec })
	pane:SetPoint("TOPLEFT")
	holder:SetHeight(pane:GetHeight() + 12)

	-- Follow the sheet rather than tracking its show and hide separately, so
	-- there is no state to get out of step.
	CharacterFrame:HookScript("OnShow", function()
		holder:Show()
		pane:Update()
	end)
	CharacterFrame:HookScript("OnHide", function() holder:Hide() end)
	holder:SetShown(CharacterFrame:IsShown())

	-- Gear changes and a respec both move every number on this pane.
	--
	-- Handler first, then one event at a time, each verified. 12.1 can refuse a
	-- registration SILENTLY: pcall does not see it, so an addon that registered
	-- four events in a row and asked nothing would sit waiting forever for one
	-- that never arrives. See C:\Dev\WoWAddons\docs\DECISIONS.md.
	local watcher = CreateFrame("Frame")
	watcher:SetScript("OnEvent", function()
		wipe(ratingCache)
		for _, each in ipairs(statPanes) do
			if each:IsShown() then each:Update() end
		end
	end)
	for _, event in ipairs({
		"PLAYER_EQUIPMENT_CHANGED",
		"TRAIT_CONFIG_UPDATED",
		"PLAYER_SPECIALIZATION_CHANGED",
		"COMBAT_RATING_UPDATE",
	}) do
		watcher:RegisterEvent(event)
		if not watcher:IsEventRegistered(event) then
			print(GOLD .. "Djinni's BiS|r " .. GREY
				.. "could not register " .. event
				.. ", so the stat pane will not refresh by itself. Reopen it to update.|r")
		end
	end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
-- Blizzard's own typo, RECIEVED. The journal streams loot in after the request,
-- so a harvest that ran too early gets thrown away and retried on next open.
loader:RegisterEvent("EJ_LOOT_DATA_RECIEVED")
loader:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" then
		buildBroker()
		pcall(buildCharacterPane)
	else
		harvested = false
	end
end)

-- /bis ---------------------------------------------------------------------

local function listBySource(filter)
	local want = filter:lower()
	print(GOLD .. "Djinni's BiS|r -- items matching '" .. filter .. "':")
	local names = {}
	for _, entry in pairs(lookup) do
		if entry.boss:lower():find(want, 1, true) then names[#names + 1] = entry.name end
	end
	table.sort(names)
	if #names == 0 then
		print("  " .. GREY .. "nothing. Try: ula, coiled, vashnik, nek, twin, sszorak, explorers, sentinels|r")
		return
	end
	for _, name in ipairs(names) do
		local entry = lookup[norm(name)]
		print("  " .. name .. GREEN .. "  " .. table.concat(entry.specs, ", ") .. "|r"
			.. GREY .. "  -- " .. entry.boss .. "|r")
	end
end

-- one runnable check: /bis test
local function selfTest()
	local failed = 0
	local function check(label, got, want)
		if got ~= want then
			failed = failed + 1
			print("|cffff0000FAIL|r " .. label .. ": expected " .. tostring(want) .. ", got " .. tostring(got))
		end
	end

	-- matching, including the normalisation that lets a guide's odd casing win
	check("Sash of the Forlorn Vessel", #match("Sash of the Forlorn Vessel").specs, 4)
	check("normalised name", #match("SASH  OF THE  FORLORN-VESSEL").specs, 4)
	check("Jan'thrazet", #match("Jan'thrazet, the Soul Fang").specs, 2)
	check("Hearthstone", match("Hearthstone") and 1 or 0, 0)

	-- every item must land in a slot the By Slot tab knows how to draw
	local known = {}
	for _, slot in ipairs(SLOT_ORDER) do known[slot] = true end
	for _, spec in ipairs(SPEC_ORDER) do
		for _, item in ipairs(BIS[spec]) do
			if not known[item.slot] then
				failed = failed + 1
				print("|cffff0000FAIL|r unknown slot '" .. tostring(item.slot) .. "' on " .. item.name)
			end
		end
	end

	-- the raidbots CSV parser, against real rows from a Droptimizer report
	local sample = table.concat({
		"name,dps_mean,dps_min,dps_max,dps_std_dev,dps_mean_std_dev",
		"Djinni,100000.0,89317.2,117457.9,3456.4,25.7",
		"-1/1311/dungeon-mythic-weekly10/271681/318/0/off_hand////,101000.0,1,2,3,4",
		"-1/1311/dungeon-mythic-weekly10/159636/318/0/main_hand////,104230.0,1,2,3,4",
		"a line that is not a csv row at all",
	}, "\n")
	local items, baseline, unreadable, count = parseSim(sample)
	check("sim parse, baseline", baseline, 100000.0)
	check("sim parse, item count", count, 2)
	check("sim parse, unreadable", unreadable, 1)
	check("sim parse, gain percent", items and items[159636] and items[159636].gain, 4.23)
	check("sim parse, item level", items and items[271681] and items[271681].ilvl, 318)
	check("sim parse, slot", items and items[271681] and items[271681].slot, "off_hand")

	-- a paste that is not a Raidbots CSV must fail loudly, not half-work
	local bad = parseSim("just some words\nand some more")
	check("sim parse, rejects junk", bad, nil)

	-- the bonus roll advice is only as good as the source matching
	check("bonus roll, Ula'tek", #bisFrom("Ula'tek") > 0, true)
	check("bonus roll, dungeon", #bisFrom("Temple of Sethraliss") > 0, true)
	check("bonus roll, nowhere", #bisFrom("Stormwind"), 0)
	check("bonus roll, no source", #bisFrom(nil), 0)

	-- every slot needs an inventory mapping, or its "on you" row silently
	-- never appears
	for _, slot in ipairs(SLOT_ORDER) do
		if not SLOT_INVENTORY[slot] then
			failed = failed + 1
			print("|cffff0000FAIL|r slot '" .. slot .. "' has no inventory slot id")
		end
	end

	-- every slot must be drawn by one of the two doll columns, or its items
	-- vanish from the By Slot tab without any error
	local drawn = {}
	for _, list in ipairs({ DOLL_LEFT, DOLL_RIGHT }) do
		for _, slot in ipairs(list) do drawn[slot] = true end
	end
	for _, slot in ipairs(SLOT_ORDER) do
		if not drawn[slot] then
			failed = failed + 1
			print("|cffff0000FAIL|r slot '" .. slot .. "' is in no doll column")
		end
	end

	-- upgrade tracks must be six ranks and always climbing
	for _, track in ipairs(TRACKS) do
		check(track.name .. " rank count", #track.ilvl, 6)
		for rank = 2, #track.ilvl do
			if track.ilvl[rank] <= track.ilvl[rank - 1] then
				failed = failed + 1
				print("|cffff0000FAIL|r " .. track.name .. " " .. rank .. "/6 is not above " .. (rank - 1) .. "/6")
			end
		end
	end

	-- every tier letter must have a colour, or tierText concatenates a nil and
	-- throws inside a render rather than anywhere findable
	for spec, items in pairs(TRINKET_TIER) do
		if not BIS[spec] then
			failed = failed + 1
			print("|cffff0000FAIL|r tier table has unknown spec '" .. tostring(spec) .. "'")
		end
		for id, tiers in pairs(items) do
			if not (tiers.u or tiers.iv) then
				failed = failed + 1
				print("|cffff0000FAIL|r tier entry " .. id .. " (" .. spec .. ") rates nothing")
			end
			for _, letter in pairs(tiers) do
				if not (TIER_COLOUR[letter] and TIER_RANK[letter]) then
					failed = failed + 1
					print("|cffff0000FAIL|r unknown tier '" .. tostring(letter) .. "' on item " .. id)
				end
			end
		end
	end

	-- the badge: agreement collapses to one letter, disagreement keeps both
	check("tier badge, agreed", tierText({ u = "S", iv = "S" }):find("S", 1, true) ~= nil, true)
	check("tier badge, one source", tierText({ iv = "A" }):find("A", 1, true) ~= nil, true)
	check("tier badge, disagreed", tierText({ u = "A", iv = "S" }):find("A", 1, true) ~= nil
		and tierText({ u = "A", iv = "S" }):find("S", 1, true) ~= nil, true)
	check("tier badge, no data", tierText(nil), "")
	check("tier best of two", bestTier({ u = "C", iv = "S" }), 1)
	check("tier best of one", bestTier({ u = "B" }), 3)

	-- ClassCodex ships the same tiers, so it turns ours off. If that check ever
	-- stops returning a boolean the suppression silently stops working.
	check("ClassCodex check is a boolean", type(classCodexLoaded()), "boolean")
	if classCodexLoaded() then
		check("tiers suppressed while ClassCodex is loaded", tiersForId("Feral", 193701), nil)
		check("name fallback suppressed too", tiersFor("Feral", nil, "zzz"), nil)
	else
		check("tiers resolve by item id", tiersForId("Feral", 193701) ~= nil, true)

		-- The name fallback is what stopped a BiS trinket being rated in the
		-- ranked list and blank in its own slot, when the two item ids for it
		-- disagreed. Plant a name, then look it up by a name-only call.
		tierNames.Feral = tierNames.Feral or {}
		tierNames.Feral[norm("Zzz Test Trinket")] = { u = "S" }
		check("falls back to the name when the id misses",
			(tiersFor("Feral", 999999, "Zzz Test Trinket") or {}).u, "S")
		check("id still wins over the name",
			(tiersFor("Feral", 193701, "Zzz Test Trinket") or {}).u, "S")
		check("unknown name is still nil", tiersFor("Feral", 999999, "Not A Trinket"), nil)
		tierNames.Feral[norm("Zzz Test Trinket")] = nil
	end

	-- Stat targets. Every spec needs an `all` set, because that is the fallback
	-- when the player's hero talent has no entry of its own, and a spec missing
	-- it would show an empty pane rather than an error.
	for _, spec in ipairs(SPEC_ORDER) do
		local bySpec = STAT_TARGET[spec]
		if not bySpec or not bySpec.all then
			failed = failed + 1
			print("|cffff0000FAIL|r no fallback stat targets for " .. spec)
		else
			for _, context in ipairs({ "raid", "mplus" }) do
				local set = bySpec.all[context]
				if not set then
					failed = failed + 1
					print("|cffff0000FAIL|r " .. spec .. " has no " .. context .. " targets")
				else
					for _, stat in ipairs(STATS) do
						if type(set[stat]) ~= "number" then
							failed = failed + 1
							print("|cffff0000FAIL|r " .. spec .. " " .. context
								.. " is missing " .. stat)
						end
					end
				end
			end
		end
	end

	-- Every hero key must be a slug heroSlug() can actually produce, or the
	-- lookup misses and every player silently gets the aggregate.
	for spec, bySpec in pairs(STAT_TARGET) do
		for hero in pairs(bySpec) do
			if hero ~= heroSlug(hero) then
				failed = failed + 1
				print("|cffff0000FAIL|r " .. spec .. " hero key '" .. hero
					.. "' is not a slug this addon can build")
			end
		end
	end

	check("hero slug, spaces", heroSlug("Druid of the Claw"), "druid-of-the-claw")
	check("hero slug, apostrophe", heroSlug("Elune's Chosen"), "elunes-chosen")
	check("hero slug, curly apostrophe", heroSlug("Elune\226\128\153s Chosen"), "elunes-chosen")
	check("hero slug, nothing", heroSlug(""), nil)

	-- within 5% is "at", because these numbers are observed and not solved
	check("verdict, exactly on", statVerdict(1000, 1000), "at")
	check("verdict, 4% under", statVerdict(960, 1000), "at")
	check("verdict, 10% under", statVerdict(900, 1000), "below")
	check("verdict, 10% over", statVerdict(1100, 1000), "above")
	check("verdict, no target", statVerdict(900, 0), nil)

	-- The bar must not draw past its own end, and being ON target must still
	-- leave room to the right, or there is nowhere to show an overshoot. Asked
	-- as facts about the drawing, not as the formula restated: a check written
	-- in terms of BAR_SCALE would agree with any value of BAR_SCALE.
	check("bar, empty", barX(0, 1000), 0)
	check("bar, on target leaves headroom", barX(1000, 1000) < BAR_W, true)
	check("bar, on target is most of the bar", barX(1000, 1000) > BAR_W * 0.6, true)
	check("bar, far over is clamped", barX(99999, 1000), BAR_W)
	check("bar, climbs with the rating", barX(900, 1000) > barX(500, 1000), true)
	check("bar, no target", barX(500, 0), 0)

	-- a saved target must survive the round trip and show its item level
	setGear("zzz not a real item", "Myth", 6)
	check("saved ilvl label", gearLabel("zzz not a real item"):find("334", 1, true) ~= nil, true)
	setGear("zzz not a real item", nil)
	check("cleared ilvl label", gearLabel("zzz not a real item"):find("334", 1, true) ~= nil, false)

	print(failed == 0 and (GREEN .. "[BiS] self-test passed|r")
		or ("|cffff0000[BiS] " .. failed .. " check(s) failed|r"))
end

SLASH_DJINNISBIS1 = "/bis"
SlashCmdList.DJINNISBIS = function(msg)
	msg = msg:match("^%s*(.-)%s*$")
	if msg == "" then DjinnisBiS_Toggle()
	elseif msg == "here" then bonusRollVerdict((GetInstanceInfo()))
	elseif msg == "test" then selfTest()
	else listBySource(msg) end
end
