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

-- Gear plan -----------------------------------------------------------------
--
-- GENERATED, do not hand-edit. Rewritten by update-gear-plan.ps1 from finished
-- Raidbots Top Gear reports, one report per cell: spec, then scenario (`st` is
-- one raid target, `2t` is two, `mplus` is a dungeon fight style). A cell no
-- report has filled is simply absent.
--
-- Unlike the two tables above this one is about ONE character: it is what the
-- sim said Djinni should wear out of what Djinni owned on the day in `simmed`.
-- It goes stale the moment a better piece drops, and the fix is a fresh Top
-- Gear run and the script again, not an edit here.
--
-- Each slot is the sim's own simc gear line, cut down to the parts the game can
-- check, plus the item level Raidbots printed for it. parsePlanLine reads it.
-- An empty slot (the off hand under a two-hander) has no entry. `talents` is
-- the string the talent import box takes; nothing here applies it.
--
-- BEGIN GENERATED GEAR PLAN
local GEAR_PLAN_SOURCE = "Raidbots Top Gear, written 2026-09-22"
local GEAR_PLAN = {
	Feral = {
		["st"] = {
			report = "ttktB9kVE77x2zkadhVgPn", simmed = "2026-09-21", dps = 176492,
			loadout = "DotC Raid ST *",
			talents = "CcGADBD3hSPCL9Y9gz68WcKvMAAAAAAwghxYmZmxsxDsMz2MzMmZGAAAAWAzGMmZwMmFmZmxYmZGAAAAAAgBAAAgZWmlZmZAALgZGgFmhBAAwMbYA",
			slots = {
				head      = "id=271528,enchant_id=7991,bonus_id=6652/13696/13692/13698/12846,ilevel=321", -- Enigmatic Dreamwatcher's Somnolent Stare
				neck      = "id=251142,gem_id=240983,bonus_id=12843/13440/6652/13668/12699,ilevel=311", -- Pendant of Malefic Fury
				shoulder  = "id=271526,enchant_id=7973,bonus_id=6652/13440/13694/13697/12846,ilevel=321", -- Enigmatic Dreamwatcher's Plumage
				back      = "id=193763,bonus_id=12843/13440/6652/13662/12699,ilevel=311", -- Fireproof Drape
				chest     = "id=268235,enchant_id=7987,bonus_id=41/13662/13334/12846,ilevel=321", -- Vestment of the Awakening
				wrist     = "id=251135,bonus_id=12849/13440/6652/13695/13662/12699,gem_id=240908,ilevel=318", -- Fury-fletched Armlets
				hands     = "id=271529,bonus_id=13691/6652/13697/12843,ilevel=311", -- Enigmatic Dreamwatcher's Gauntlets
				waist     = "id=268256,bonus_id=6652/13696/13662/13333/12836,ilevel=302", -- Sash of the Forlorn Vessel
				legs      = "id=271527,enchant_id=8159,bonus_id=6652/12836/13693/13698/1555,ilevel=302", -- Enigmatic Dreamwatcher's Leggings
				feet      = "id=272240,enchant_id=8018,bonus_id=6652/13662/12835,ilevel=298", -- Miststalker's Striders
				finger1   = "id=251093,enchant_id=7967,gem_id=240894,bonus_id=13440/6652/13668/12699/12798,ilevel=276", -- Omission of Light
				finger2   = "id=251194,enchant_id=7966,gem_id=240908,bonus_id=12843/13440/6652/13668/12699,ilevel=311", -- Lightwarden's Bind
				trinket1  = "id=270175,bonus_id=6652/13334/12844,ilevel=315", -- Voracious Heart of Ula'tek
				trinket2  = "id=270166,bonus_id=6652/13334/12843,ilevel=311", -- Vashnik's Sanguine Rancor
				main_hand = "id=268215,enchant_id=7982,bonus_id=6652/13333/13846/12838,ilevel=308", -- Abyssal Broodfiend's Bardiche
			},
		},
		["mplus"] = {
			report = "ttC3zNmZSvC7C2XQNSe6Bi", simmed = "2026-09-22", dps = 224577,
			loadout = "WS M+",
			talents = "CcGADBD3hSPCL9Y9gz68WcKvMAAAAAAgZmZ2MzMzMGzmx2YbGzMmZAAAAYBMbGeAzMYGziZmZmlxMPwMAAAAAAADAAAAAwsMziZZmlNwMDwCDGAAzMAYA",
			slots = {
				head      = "id=271528,enchant_id=7991,bonus_id=6652/13696/13692/13698/12846,ilevel=321", -- Enigmatic Dreamwatcher's Somnolent Stare
				neck      = "id=268265,gem_id=240983/240888,bonus_id=6652/13668/13333/13987/12838,ilevel=308", -- Aqirbane Reliquary
				shoulder  = "id=271526,enchant_id=7973,bonus_id=6652/13440/13694/13697/12846,ilevel=321", -- Enigmatic Dreamwatcher's Plumage
				back      = "id=193763,bonus_id=12843/13440/6652/13662/12699,ilevel=311", -- Fireproof Drape
				chest     = "id=268235,enchant_id=7987,bonus_id=41/13662/13334/12846,ilevel=321", -- Vestment of the Awakening
				wrist     = "id=251135,gem_id=240908,bonus_id=12849/13440/6652/13695/13662/12699,ilevel=318", -- Fury-fletched Armlets
				hands     = "id=271529,bonus_id=13691/6652/13697/12843,ilevel=311", -- Enigmatic Dreamwatcher's Gauntlets
				waist     = "id=268256,bonus_id=6652/13696/13662/13333/12836,ilevel=302", -- Sash of the Forlorn Vessel
				legs      = "id=271527,enchant_id=8159,bonus_id=6652/12836/13693/13698/1555,ilevel=302", -- Enigmatic Dreamwatcher's Leggings
				feet      = "id=272240,enchant_id=8018,bonus_id=6652/13662/12835,ilevel=298", -- Miststalker's Striders
				finger1   = "id=272147,bonus_id=6652/13668/12838,enchant_id=7967,gem_id=240908,ilevel=308", -- Colubrine Band
				finger2   = "id=268249,gem_id=240888,bonus_id=6652/13668/13333/12841/13696,enchant_id=7967,ilevel=305", -- Vile Alchemist's Band
				trinket1  = "id=250228,bonus_id=13440/6652/12699/12843,ilevel=311", -- Resonant Bellowstone
				trinket2  = "id=270175,bonus_id=6652/13334/12844,ilevel=315", -- Voracious Heart of Ula'tek
				main_hand = "id=268215,enchant_id=7982,bonus_id=6652/13333/13846/12838,ilevel=308", -- Abyssal Broodfiend's Bardiche
			},
		},
	},
}
-- END GENERATED GEAR PLAN

-- Outside the gear plan markers on purpose: update-gear-plan.ps1 rewrites
-- everything between them from Raidbots reports, and neither table below is in
-- a report.
local PlanTab = {}  -- one name for the whole Plan tab: this file sits at Lua's 200-local limit

-- GENERATED, do not hand-edit. Rewritten by update-plan-ranks.py from Raidbots'
-- public enchant and gem lists: every id in the family of every enchant and
-- gem the plan asks for, as { family name, rank, ranks in the family }.
--
-- Why a family and a rank rather than a name: the game has no call from an
-- enchant id to a name, two gem ids share the name "Flawless Masterful Garnet",
-- and a lower rank of the right thing is not WRONG, only not as good as it
-- could be. Rob may well choose a cheaper rank on gear he expects to replace
-- (2026-09-22), so a lower rank is "lesser", never "enchant" or "gem".
-- BEGIN GENERATED PLAN RANKS
PlanTab.RANK_SOURCE = "Raidbots enchantments.json and gems.json, read 2026-09-22"
PlanTab.RANK = {
	enchant = {
		[7972] = { "Akil'zon's Swiftness", 1, 2 },
		[7973] = { "Akil'zon's Swiftness", 2, 2 },
		[7982] = { "Berserker's Rage", 1, 2 },
		[7983] = { "Berserker's Rage", 2, 2 },
		[7990] = { "Empowered Blessing of Speed", 1, 2 },
		[7991] = { "Empowered Blessing of Speed", 2, 2 },
		[7966] = { "Eyes of the Eagle", 1, 2 },
		[7967] = { "Eyes of the Eagle", 2, 2 },
		[8018] = { "Farstrider's Hunt", 1, 2 },
		[8019] = { "Farstrider's Hunt", 2, 2 },
		[8158] = { "Forest Hunter's Armor Kit", 1, 2 },
		[8159] = { "Forest Hunter's Armor Kit", 2, 2 },
		[7986] = { "Mark of the Worldsoul", 1, 2 },
		[7987] = { "Mark of the Worldsoul", 2, 2 },
	},
	gem = {
		[240982] = { "Indecipherable Eversong Diamond", 1, 2 },
		[240983] = { "Indecipherable Eversong Diamond", 2, 2 },
		[240875] = { "Masterful Garnet", 1, 4 },
		[240876] = { "Masterful Garnet", 2, 4 },
		[240907] = { "Masterful Garnet", 3, 4 },
		[240908] = { "Masterful Garnet", 4, 4 },
		[240855] = { "Quick Peridot", 1, 4 },
		[240856] = { "Quick Peridot", 2, 4 },
		[240887] = { "Quick Peridot", 3, 4 },
		[240888] = { "Quick Peridot", 4, 4 },
		[240861] = { "Versatile Peridot", 1, 4 },
		[240862] = { "Versatile Peridot", 2, 4 },
		[240893] = { "Versatile Peridot", 3, 4 },
		[240894] = { "Versatile Peridot", 4, 4 },
	},
}
-- END GENERATED PLAN RANKS

-- "Eyes of the Eagle (rank 1 of 2)", or "enchant 1234" for an id the table
-- has never seen, which is the cue to run update-plan-ranks.py.
function PlanTab.rankName(kind, id)
	local row = PlanTab.RANK[kind][id]
	if not row then return (kind == "enchant" and "enchant " or "gem ") .. tostring(id) end
	return ("%s (rank %d of %d)"):format(row[1], row[2], row[3])
end

-- "lesser" when `worn` is a lower rank of `planned`'s family, "ok" when it is
-- the same or a higher rank, "wrong" otherwise or when either id is unknown.
function PlanTab.rankState(kind, planned, worn)
	if planned == worn then return "ok" end
	local p, w = PlanTab.RANK[kind][planned], PlanTab.RANK[kind][worn]
	if not (p and w) or p[1] ~= w[1] then return "wrong" end
	return w[2] < p[2] and "lesser" or "ok"
end

-- Which saved loadout and which gear scenario go with which boss. The hero tree
-- per boss is Dreamgrove's Feral compendium as updated 2026-09-18. The NAMES are
-- the loadouts DjinnisDreamgrove imported on 2026-09-02, because those are what
-- exist in the game to click. Dreamgrove's newer one-build-per-boss strings sim
-- about 1.5% over these and have no loadout yet; when DjinnisDreamgrove is
-- refreshed, change the names here to match.
-- `scenario` picks the gear plan cell. There are only two, so a boss that is
-- neither clean single target nor sustained two target takes `st`.
-- `id` is the encounter id ENCOUNTER_START and ENCOUNTER_END carry (card 0027),
-- copied by hand from BigWigs_TheVenomousAbyss's `mod:SetEncounterID(...)`
-- lines on 2026-09-22. It is NOT the Encounter Journal id (Nek'zali is 3470
-- here and 2888 in the journal). The events' name is the journal's long one,
-- "Nek'zali the Soulcoiler", which is why the id is the thing to match on.
PlanTab.BOSSES = {
	Feral = {
		{ boss = "Nek'zali",            id = 3470, scenario = "st", loadout = "WS Raid Most Bosses" },
		{ boss = "Entombed Sentinels",  id = 3445, scenario = "st", loadout = "DotC Raid ST *" },
		{ boss = "The Lost Explorers",  id = 3497, scenario = "2t", loadout = "WS Raid 2T *" },
		{ boss = "Vashnik",             id = 3455, scenario = "st", loadout = "WS Raid Most Bosses" },
		{ boss = "Sszorak",             id = 3420, scenario = "st", loadout = "DotC Raid ST *" },
		{ boss = "The Twin Fangs",      id = 3421, scenario = "2t", loadout = "WS Raid 2T *" },
		{ boss = "The Coiled Altar",    id = 3429, scenario = "st", loadout = "WS Raid Coiled Altar" },
		{ boss = "Ula'tek",             id = 3492, scenario = "st", loadout = "WS Raid Most Bosses" },
		-- a lair boss, not a raid one: her id is from BigWigs_MidnightLairs
		{ boss = "Nymrissa Wavecaller", id = 3379, scenario = "st", loadout = "DotC Raid Most Bosses *" },
		-- One Mythic+ loadout, not one per dungeon (card 0009). "WS M+" simmed
		-- 214,785 against "DotC M+" 207,837 on two targets, 2026-09-21; a
		-- dungeon-style sim should settle it, and none has run yet.
		{ boss = "Mythic+, any key",   scenario = "mplus", loadout = "WS M+" },
	},
}

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

-- All four ratings or nothing. A sheet first opened in combat, or a /reload in
-- combat, has never had a readable rating, and drawing that as 0 is a wrong
-- number that looks like a right one. `read` is ratingOf outside the checks.
local function allRatings(read)
	local ratings = {}
	for _, stat in ipairs(STATS) do
		local value = read(stat)
		if value == nil then return nil end
		ratings[stat] = value
	end
	return ratings
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
	if not C_ClassTalents.GetActiveConfigID then return nil end

	local subTreeID = C_ClassTalents.GetActiveHeroTalentSpec()
	if not subTreeID or subTreeID == 0 then return nil end

	-- GetSubTreeInfo takes (configID, subTreeID), BOTH of them. Called with the
	-- subtree alone it returns nothing, and the failure is silent: the pane just
	-- says "all hero talents" and shows the aggregate, which for Feral raid is
	-- 775 crit where Druid of the Claw wants 1225. Checked against
	-- wow-ui-source's SharedTraitsDocumentation after Rob's screenshot showed
	-- the fallback wording while he had a hero talent chosen.
	local configID = C_ClassTalents.GetActiveConfigID()
	if not configID then return nil end

	local ok, info = pcall(C_Traits.GetSubTreeInfo, configID, subTreeID)
	if not ok or not info or not info.name then return nil end
	return heroSlug(info.name)
end

-- Raid or Mythic+, read off where you are standing. Inside an instance this
-- is the answer and the switch below cannot override it (card 0009); outside,
-- nil, and the switch decides, because gearing for Tuesday happens in a city.
local function autoContext()
	if not GetInstanceInfo then return nil end
	local _, instanceType = GetInstanceInfo()
	if instanceType == "party" then return "mplus" end
	if instanceType == "raid" then return "raid" end
	return nil
end

-- Where you stand first, then the switch, then Raid. Until card 0009 the
-- switch beat the instance; that left a key showing the raid plan when Raid
-- had been pinned in a city on Tuesday, which is the wrong answer for the
-- whole run. Inside an instance the content is not a choice.
local function statContext()
	local here = autoContext()
	if here then return here, false end
	local chosen = db().statContext
	if chosen == "raid" or chosen == "mplus" then return chosen, true end
	return "raid", false
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
-- is a real comparison and the honest answer is "all of it". THAT ONLY HOLDS
-- WHERE THE EMPTY SLOT IS ACTUALLY USABLE, which is what twoHandedMainHand
-- below is about.
--
-- Pure, so /bis test can prove it without a game client. This is where the
-- weapon fault below actually showed: an empty slot always wins on a total of
-- zero, so the moment an unusable slot is in the list the answer is wrong.
local function weakestOf(worn)
	local best, bestTotal
	for _, entry in ipairs(worn) do
		local total = 0
		for _, stat in ipairs(STATS) do total = total + (entry.stats[stat] or 0) end
		if not bestTotal or total < bestTotal then best, bestTotal = entry, total end
	end
	return best
end

-- A two-handed weapon fills the main hand and leaves the off-hand slot EMPTY
-- BUT UNUSABLE. Rob hovered a one-handed dagger while wearing a staff and the
-- pane answered "vs an empty slot", so it read as pure gain when what actually
-- happens is that the staff comes off and its mastery goes with it.
local TWO_HANDED = {
	INVTYPE_2HWEAPON = true, INVTYPE_RANGED = true, INVTYPE_RANGEDRIGHT = true,
}
local ONE_HANDED = {
	INVTYPE_WEAPON = true, INVTYPE_WEAPONMAINHAND = true,
	INVTYPE_WEAPONOFFHAND = true, INVTYPE_HOLDABLE = true, INVTYPE_SHIELD = true,
}

local function twoHandedMainHand()
	local worn = GetInventoryItemLink("player", 16)
	local id = worn and tonumber(worn:match("item:(%d+)"))
	if not id then return false end
	local _, _, _, equipLoc = C_Item.GetItemInfoInstant(id)
	return TWO_HANDED[equipLoc or ""] or false
end

local function deltaAgainstEquipped(link)
	local incoming = statsOf(link)
	if not incoming then return nil end

	local id = tonumber(link:match("item:(%d+)"))
	if not id then return nil end
	local _, _, _, equipLoc = C_Item.GetItemInfoInstant(id)
	local slots = INVTYPE_SLOTS[equipLoc or ""]
	if not slots then return nil end

	-- Anything one-handed, main hand or off hand, unseats a two-hander
	if ONE_HANDED[equipLoc or ""] and twoHandedMainHand() then slots = { 16 } end

	local worn = {}
	for _, slotID in ipairs(slots) do
		local wornLink = GetInventoryItemLink("player", slotID)
		worn[#worn + 1] = {
			link = wornLink,
			stats = (wornLink and statsOf(wornLink)) or ZERO_STATS,
		}
	end

	local weakest = weakestOf(worn)
	if not weakest then return nil end

	local delta = {}
	for _, stat in ipairs(STATS) do delta[stat] = incoming[stat] - weakest.stats[stat] end
	return delta, weakest.link
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
local addPlanLine  -- set by the slot marks, once the character pane is built
local addBagLine   -- set by the bag marks, further down

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

	-- No readable ratings yet, so no lines: a delta measured from zero is worse
	-- than none.
	local ratings = allRatings(ratingOf)
	if not ratings then return end

	local any = false
	for _, stat in ipairs(STATS) do
		local delta = deltas[stat]
		if delta ~= 0 then
			if not any then
				tooltip:AddLine(GREY .. "Against your " .. CONTEXT_LABEL[context]
					.. " targets, versus what it replaces:|r")
				any = true
			end
			local after = ratings[stat] + delta
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
	-- Here rather than in a slot button's OnEnter, because the sheet redraws a
	-- slot's tooltip several times a second and this runs on every redraw.
	if addPlanLine then addPlanLine(tooltip, tooltip:GetOwner()) end
	if addBagLine then addBagLine(tooltip, link) end
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

-- Gear plan lookups ----------------------------------------------------------
--
-- The plan is keyed by simc's slot names, because that is what the report
-- speaks. This is the one place they become inventory slot ids.
local PLAN_SLOT_INVENTORY = {
	head = 1, neck = 2, shoulder = 3, back = 15, chest = 5, wrist = 9,
	hands = 10, waist = 6, legs = 7, feet = 8, finger1 = 11, finger2 = 12,
	trinket1 = 13, trinket2 = 14, main_hand = 16, off_hand = 17,
}
-- Either of a pair can sit in either slot, and the sim does not care which.
local PLAN_PAIRS = { { "finger1", "finger2" }, { "trinket1", "trinket2" } }

local function idList(text)
	local list = {}
	for n in (text or ""):gmatch("%d+") do list[#list + 1] = tonumber(n) end
	return list
end

-- "id=1,enchant_id=2,gem_id=3/4,bonus_id=5/6,ilevel=300" -> a plan entry, or
-- nil for a line with no item id on it.
local function parsePlanLine(line)
	local field = {}
	for key, value in (line or ""):gmatch("([%a_]+)=([%d/]+)") do field[key] = value end
	if not field.id then return nil end
	return {
		id = tonumber(field.id),
		ilvl = tonumber(field.ilevel),
		enchant = tonumber(field.enchant_id),
		gems = idList(field.gem_id),
		bonus = idList(field.bonus_id),
	}
end

-- Item id AND item level, never the name: the same id drops on every track,
-- and the Champion copy of a Myth plan piece is not the piece the sim chose.
-- A level the client has not cached yet reads as no match, not as a match.
local function planMatches(entry, id, ilvl)
	return entry ~= nil and id ~= nil and ilvl ~= nil
		and entry.id == id and entry.ilvl == ilvl
end

local function planMatchesLink(entry, link)
	if not link then return false end
	return planMatches(entry, tonumber(link:match("item:(%d+)")), itemLevelOf(link))
end

-- Two planned pieces against two worn ones, each { id =, ilvl = } or nil.
local function planPairMatches(planA, planB, wornA, wornB)
	local function m(entry, worn) return planMatches(entry, worn and worn.id, worn and worn.ilvl) end
	return (m(planA, wornA) and m(planB, wornB)) or (m(planA, wornB) and m(planB, wornA))
end

-- The parsed plan for one spec and scenario: { report, simmed, dps, loadout,
-- talents, slots = { head = entry, ... } }, or nil where no report filled it.
local function gearPlanFor(spec, scenario)
	local cell = GEAR_PLAN[spec] and GEAR_PLAN[spec][scenario]
	if not cell then return nil end
	if not cell.parsed then
		cell.parsed = {}
		for slot, line in pairs(cell.slots) do cell.parsed[slot] = parsePlanLine(line) end
	end
	return {
		report = cell.report, simmed = cell.simmed, dps = cell.dps,
		loadout = cell.loadout, talents = cell.talents, slots = cell.parsed,
	}
end

-- Slot marks ------------------------------------------------------------------
--
-- What is worn against what the plan wants, one word per slot. Everything down
-- to slotStates is pure, so /bis test covers it outside the game.

-- The field order is Blizzard's own, written out in Blizzard_Reports.lua:
-- item:itemID:enchantID:gemID1:gemID2:gemID3:gemID4:... A gem field holds the
-- gem's ITEM id, which is what simc's gem_id holds too.
local function wornFromLink(link)
	if not link then return nil end
	local id, enchant, g1, g2, g3, g4 = link:match("item:(%d+):(%d*):(%d*):(%d*):(%d*):(%d*)")
	if not id then return nil end
	local gems = {}
	for _, gem in ipairs({ g1, g2, g3, g4 }) do
		if gem ~= "" then gems[#gems + 1] = tonumber(gem) end
	end
	return { link = link, id = tonumber(id), enchant = tonumber(enchant), gems = gems }
end

-- A gem is matched by NAME when the client knows it, by id otherwise. Two ids
-- share the name "Flawless Masterful Garnet" (240907 and 240908 on Raidbots'
-- gem list, 2026-09-22); the sim asked for one and the auction house sold Rob
-- the other, and the addon called it wrong for a day.
function PlanTab.gemKey(id)
	local row = PlanTab.RANK.gem[id]
	if row then return row[1] end
	local name = C_Item.GetItemInfo(id)
	return name and canRead(name) and name or tostring(id)
end

-- Planned gems against worn ones. Each planned gem takes the worn gem of its
-- family with the highest rank; the result is "gem" when a planned gem has no
-- family match, "lesser" when every planned gem is matched but one is by a
-- lower rank, "ok" otherwise. Also returns the unmatched planned gems and the
-- { planned, worn } pairs that are lesser, for the shopping list and the lines.
function PlanTab.gemMatch(planned, worn)
	local pool = {}
	for _, gem in ipairs(worn or {}) do pool[#pool + 1] = gem end
	local missing, lesser = {}, {}
	for _, want in ipairs(planned) do
		local best, at = nil, nil
		for i, have in ipairs(pool) do
			if PlanTab.gemKey(have) == PlanTab.gemKey(want) then
				local rank = PlanTab.RANK.gem[have] and PlanTab.RANK.gem[have][2] or 0
				if not best or rank > best then best, at = rank, i end
			end
		end
		if not at then
			missing[#missing + 1] = want
		else
			local have = table.remove(pool, at)
			if PlanTab.rankState("gem", want, have) == "lesser" then lesser[#lesser + 1] = { want, have } end
		end
	end
	local state = #missing > 0 and "gem" or #lesser > 0 and "lesser" or "ok"
	return state, missing, lesser
end

-- `worn` is wornFromLink's table plus `ilvl` and `sockets`, or nil for a bare
-- slot. A slot the plan leaves empty is "ok": the only one is the off hand
-- under a two-hander, and nothing can be worn there anyway.
local function slotState(entry, worn)
	if not entry then return "ok" end
	if not worn or not planMatches(entry, worn.id, worn.ilvl) then return "change" end
	-- "lesser" is a lower rank of the right enchant or gem: not wrong, and
	-- reported after anything that is.
	local enchant = entry.enchant and PlanTab.rankState("enchant", entry.enchant, worn.enchant) or "ok"
	if enchant == "wrong" then return "enchant" end
	local gems = worn.gems or {}
	if (worn.sockets or 0) > #gems then return "gem" end
	-- A gem the plan never listed is no worse than none, so only a planned gem
	-- can be the wrong one.
	local gem = PlanTab.gemMatch(entry.gems, gems)
	if gem == "gem" then return "gem" end
	return (enchant == "lesser" or gem == "lesser") and "lesser" or "ok"
end

-- Which planned ring goes with which finger: whichever way round matches more
-- of what is worn, so a swapped pair is not two red slots.
local function planPairOrder(planA, planB, wornA, wornB)
	local function m(entry, worn)
		return planMatches(entry, worn and worn.id, worn and worn.ilvl) and 1 or 0
	end
	if m(planA, wornB) + m(planB, wornA) > m(planA, wornA) + m(planB, wornB) then
		return planB, planA
	end
	return planA, planB
end

-- { [inventory slot id] = { state =, entry = } } for every slot that is not
-- "ok". `wornBySlot` is keyed by the plan's slot names. No plan, no marks.
-- The plan's entry for each slot, with each ring and trinket pair turned the
-- way round that matches what is worn.
function PlanTab.entries(plan, wornBySlot)
	local entryFor = {}
	for slot, entry in pairs(plan.slots) do entryFor[slot] = entry end
	for _, pair in ipairs(PLAN_PAIRS) do
		entryFor[pair[1]], entryFor[pair[2]] = planPairOrder(
			plan.slots[pair[1]], plan.slots[pair[2]], wornBySlot[pair[1]], wornBySlot[pair[2]])
	end
	return entryFor
end

local function slotStates(plan, wornBySlot)
	local marks = {}
	if not plan then return marks end
	for slot, entry in pairs(PlanTab.entries(plan, wornBySlot)) do
		local state = slotState(entry, wornBySlot[slot])
		if state ~= "ok" then
			marks[PLAN_SLOT_INVENTORY[slot]] = { state = state, entry = entry, worn = wornBySlot[slot] }
		end
	end
	return marks
end

-- ponytail: the bank is asked by item id alone, so a lower-track copy in the
-- bank reads as "bank". Scan the bank by link if that ever misleads.
local function planLocation(inBags, bankCount)
	if inBags then return "bags" end
	if (bankCount or 0) > 0 then return "bank" end
	return "missing"
end

-- The Plan tab's shopping list: { { kind = "enchant" | "gem", id =, count = } },
-- each thing once with how many, enchants first. Second return is how many
-- planned pieces are not worn.
-- ponytail: a planned piece that is not worn is not counted at all, because the
-- copy in the bags may already carry its enchant and gem. Read the bag copy's
-- link through wornFromLink if the list needs to be complete before equipping.
-- Third return: the upgrades, the same shape, for a lower rank of the right
-- enchant or gem that is on. Those are never "to buy"; Rob may have chosen
-- the cheaper rank on purpose.
function PlanTab.shoppingList(plan, wornBySlot)
	local count, better, unworn = { enchant = {}, gem = {} }, { enchant = {}, gem = {} }, 0
	for slot, entry in pairs(plan and PlanTab.entries(plan, wornBySlot) or {}) do
		local worn = wornBySlot[slot]
		if not worn or not planMatches(entry, worn.id, worn.ilvl) then
			unworn = unworn + 1
		else
			if entry.enchant then
				local state = PlanTab.rankState("enchant", entry.enchant, worn.enchant)
				local into = state == "wrong" and count or state == "lesser" and better
				if into then into.enchant[entry.enchant] = (into.enchant[entry.enchant] or 0) + 1 end
			end
			local _, missing, lesser = PlanTab.gemMatch(entry.gems, worn.gems)
			for _, gem in ipairs(missing) do count.gem[gem] = (count.gem[gem] or 0) + 1 end
			for _, pair in ipairs(lesser) do better.gem[pair[1]] = (better.gem[pair[1]] or 0) + 1 end
		end
	end
	local function flat(byKind)
		local list = {}
		for kind, byId in pairs(byKind) do
			for id, n in pairs(byId) do list[#list + 1] = { kind = kind, id = id, count = n } end
		end
		table.sort(list, function(a, b)
			if a.kind ~= b.kind then return a.kind < b.kind end  -- "enchant" sorts first
			return a.id < b.id
		end)
		return list
	end
	return flat(count), unworn, flat(better)
end

-- `nameOf(kind, id)` is handed in so /bis test can run this with no item cache.
function PlanTab.shoppingLines(list, nameOf)
	if #list == 0 then return { "Nothing to buy" } end
	local lines = {}
	for i, want in ipairs(list) do
		lines[i] = ("%dx %s"):format(want.count, nameOf(want.kind, want.id))
	end
	return lines
end

-- "match", "mismatch", or "unknown" when the game would not say which loadout
-- is active. Unknown is never drawn red: red means "go and change it".
-- `edited` is true when the talents no longer match the named loadout (card
-- 0014): the right name with a point moved by hand is still the wrong build.
function PlanTab.loadoutState(planned, active, edited)
	if not active or not planned then return "unknown" end
	if edited then return "mismatch" end
	return planned == active and "match" or "mismatch"
end

-- true when two talent import strings name different builds, false when the
-- same, nil when either is missing or may not be read. Pure, for /bis test.
-- ponytail: whole-string compare. The header (version, spec, tree hash) is the
-- same for two configs of one spec; if a client ever differs there, compare
-- from the node bits on instead, here and nowhere else.
function PlanTab.talentStringsDiffer(active, saved)
	if type(active) ~= "string" or type(saved) ~= "string" then return nil end
	if active == "" or saved == "" then return nil end
	if not (canRead(active) and canRead(saved)) then return nil end
	return active ~= saved
end

local SCENARIO_LABEL = { st = "1 target", ["2t"] = "2 targets", mplus = "Mythic+" }

-- The plan cell in use. In a key, or with the stat pane's switch on Mythic+,
-- it is the Mythic+ cell; in a raid, or with the switch on Raid, it is the
-- saved 1 or 2 target raid cell. One switch drives the stat targets, the slot
-- glows, the bag glows and the Plan tab (card 0009).
local function planScenario(spec)
	if statContext() == "mplus" then return "mplus" end
	-- Only a scenario that has a label: the saved file is editable by hand, and
	-- an unknown one would reach a format() as nil on every sheet open.
	local saved = db().planScenario
	local scenario = type(saved) == "table" and saved[spec]
	return (scenario == "st" or scenario == "2t") and scenario or "st"
end

-- The next stop on the strip's button: 1 target, 2 targets, Mythic+, round
-- again. Picking Mythic+ pins the content switch to Mythic+; picking a raid
-- scenario pins it to Raid, because the button is one thing to press, not two.
-- `here` is autoContext(): in a raid the instance refuses Mythic+, so the
-- button goes 1, 2, 1 (without this it stuck on 2 targets for good); in a
-- dungeon there is nothing to cycle and the button stays put.
function PlanTab.nextScenario(scenario, here)
	if here == "mplus" then return "mplus" end
	if scenario == "st" then return "2t" end
	if scenario == "2t" and here ~= "raid" then return "mplus" end
	return "st"
end

-- What is worn, keyed by the plan's slot names, or nil when any link came back
-- secret and nothing about the gear can be trusted.
local function readWorn()
	local worn = {}
	for slot, slotID in pairs(PLAN_SLOT_INVENTORY) do
		local link = GetInventoryItemLink("player", slotID)
		if link and not canRead(link) then return nil end
		local item = wornFromLink(link)
		if item then
			item.ilvl = itemLevelOf(link)
			local ok, sockets = pcall(C_Item.GetItemNumSockets, link)
			item.sockets = ok and sockets or 0
		end
		worn[slot] = item
	end
	return worn
end

-- The data broker line (card 0026): "BiS: 2 off plan" on any broker display,
-- so nothing has to be opened to know. `count` nil is no plan or unreadable
-- gear, and the text says nothing rather than "on plan".
function PlanTab.brokerText(count)
	if count == nil then return "BiS" end
	if count == 0 then return "BiS: on plan" end
	return ("BiS: %d off plan"):format(count)
end

-- How many worn slots differ from the plan for the current spec and content,
-- or nil with no plan or a link that cannot be read. `forSpec` is for the
-- self-test; the broker always asks about the player.
function PlanTab.offPlanCount(forSpec)
	local spec = forSpec or playerSpec()
	local plan = spec and gearPlanFor(spec, planScenario(spec))
	if not plan then return nil end
	local worn = readWorn()
	if not worn then return nil end
	local count = 0
	for _ in pairs(slotStates(plan, worn)) do count = count + 1 end
	return count
end

-- Rides rebuildBagWanted, which the bag-mark watcher runs from login on every
-- event that redraws the glows, so the line and the glows cannot disagree.
function PlanTab.updateBroker()
	if PlanTab.broker then PlanTab.broker.text = PlanTab.brokerText(PlanTab.offPlanCount()) end
end

-- Bag marks -------------------------------------------------------------------
--
-- A bag item is wanted when it is the planned piece for a slot that is wearing
-- something else. "The planned piece" is planMatches, the same rule the slot
-- marks use: item id AND item level, so of two copies only the planned one is
-- wanted, and a planned piece that is already worn leaves no slot to want it.

local PLAN_SLOT_LABEL = {
	[1] = "Head", [2] = "Neck", [3] = "Shoulder", [5] = "Chest", [6] = "Waist",
	[7] = "Legs", [8] = "Feet", [9] = "Wrist", [10] = "Hands", [11] = "Finger",
	[12] = "Finger", [13] = "Trinket", [14] = "Trinket", [15] = "Back",
	[16] = "Main Hand", [17] = "Off Hand",
}

-- { { entry =, slotID = }, ... }: the planned pieces that are not being worn.
local function wantedFrom(plan, wornBySlot)
	local wanted = {}
	for slotID, mark in pairs(slotStates(plan, wornBySlot)) do
		if mark.state == "change" then
			wanted[#wanted + 1] = { entry = mark.entry, slotID = slotID }
		end
	end
	return wanted
end

-- The inventory slot id a bag item is wanted for, or nil.
local function wantedSlot(wanted, id, ilvl)
	for _, want in ipairs(wanted) do
		if planMatches(want.entry, id, ilvl) then return want.slotID end
	end
	return nil
end

local function wantedLine(slotID, scenario)
	return ("Plan: equip in %s, %s"):format(PLAN_SLOT_LABEL[slotID] or "?", SCENARIO_LABEL[scenario] or "?")
end

-- Rebuilt out of combat only. In combat the last list stands, so nothing here
-- reads gear or bags until PLAYER_REGEN_ENABLED.
local bagWanted, bagScenario = {}, "st"
local refreshBagGlows  -- set once the bag glows are built

local function rebuildBagWanted()
	if InCombatLockdown() then return end
	local spec = playerSpec()
	bagScenario = spec and planScenario(spec) or "st"
	local plan = spec and gearPlanFor(spec, bagScenario)
	local worn = plan and readWorn()
	if plan and not worn then return end
	bagWanted = plan and wantedFrom(plan, worn) or {}
	if refreshBagGlows then refreshBagGlows() end
	PlanTab.updateBroker()
end

local function wantedSlotForLink(link)
	if not link or not canRead(link) or #bagWanted == 0 then return nil end
	return wantedSlot(bagWanted, tonumber(link:match("item:(%d+)")), itemLevelOf(link))
end

-- A wanted piece is by definition not worn, so any tooltip showing that link
-- is showing a copy to equip, wherever it is hovered.
addBagLine = function(tooltip, link)
	local slotID = wantedSlotForLink(link)
	if slotID then tooltip:AddLine(GREEN .. wantedLine(slotID, bagScenario) .. "|r") end
end

-- Baganator is the bag Rob opens, and it has an API for exactly this: a corner
-- widget is asked about every item it draws. The holder it positions is tiny;
-- the glow inside is pinned to the whole button, so it reads as a glow and not
-- as a corner icon. The default bags are the fallback when it is not loaded.
local function newBagGlow(button, parent)
	local glow = (parent or button):CreateTexture(nil, "OVERLAY")
	glow:SetAllPoints(button)
	glow:SetAtlas("bags-glow-white")
	glow:SetBlendMode("ADD")
	glow:SetVertexColor(0.1, 1, 0.1)
	return glow
end

local function buildBagGlows()
	if Baganator and Baganator.API and Baganator.API.RegisterCornerWidget then
		Baganator.API.RegisterCornerWidget("Djinni's BiS: gear plan", "djinnisbis_plan",
			function(_, details) return wantedSlotForLink(details.itemLink) ~= nil end,
			function(itemButton)
				local holder = CreateFrame("Frame", nil, itemButton)
				holder:SetSize(1, 1)
				newBagGlow(itemButton, holder)
				return holder
			end,
			{ corner = "top_right", priority = 1 })
		refreshBagGlows = function()
			if Baganator.API.RequestItemButtonsRefresh then Baganator.API.RequestItemButtonsRefresh() end
		end
		return
	end

	-- Blizzard's bags, combined or separate: whichever is in use is the one
	-- that is shown, so one pass over all of them covers either. The frames are
	-- read off their globals and NOT through
	-- ContainerFrameUtil_EnumerateContainerFrames: that builds its list on first
	-- use, and built from here the list is tainted for every secure caller after.
	-- The glows live in a table here, never in a field on Blizzard's button, for
	-- the same reason.
	local separate = ContainerFrameContainer and ContainerFrameContainer.ContainerFrames
	if not (ContainerFrameCombinedBags or separate) then return end
	local glows = {}
	refreshBagGlows = function()
		if InCombatLockdown() then return end
		local frames = { ContainerFrameCombinedBags }
		for _, frame in ipairs(separate or {}) do frames[#frames + 1] = frame end
		for _, frame in ipairs(frames) do
			if frame:IsShown() and frame.EnumerateValidItems then
				for _, button in frame:EnumerateValidItems() do
					local link = C_Container.GetContainerItemLink(button:GetBagID(), button:GetID())
					local show = wantedSlotForLink(link) ~= nil
					if show and not glows[button] then glows[button] = newBagGlow(button) end
					if glows[button] then glows[button]:SetShown(show) end
				end
			end
		end
	end
	-- GenerateFrame is a bag opening, UpdateAll is its contents changing.
	for _, name in ipairs({ "ContainerFrame_GenerateFrame", "ContainerFrame_UpdateAll" }) do
		if hooksecurefunc and _G[name] then hooksecurefunc(name, function() refreshBagGlows() end) end
	end
	return true
end

-- Handler first, then one event at a time, each verified. See
-- C:\Dev\WoWAddons\docs\DECISIONS.md.
local function armBagMarks()
	-- Baganator redraws its own items when a bag changes and asks the widget
	-- again, so only Blizzard's bags need telling.
	local defaultBags = buildBagGlows()
	local watcher = CreateFrame("Frame")
	watcher:SetScript("OnEvent", function(_, event)
		if event == "BAG_UPDATE_DELAYED" then
			if refreshBagGlows and not InCombatLockdown() then refreshBagGlows() end
		elseif event == "TRAIT_CONFIG_UPDATED" or event == "CONFIG_COMMIT_FAILED" then
			PlanTab.onTalentEvent(event)
		else
			rebuildBagWanted()
			-- The Plan tab lists what to equip, so an equip redraws it. This
			-- watcher exists from login; the slot-mark one only after the sheet
			-- is first opened, which is why the redraw does not ride that one.
			if PlanTab.redraw then PlanTab.redraw() end
		end
	end)
	for _, event in ipairs({
		"PLAYER_EQUIPMENT_CHANGED",
		"PLAYER_SPECIALIZATION_CHANGED",
		"PLAYER_REGEN_ENABLED",
		"PLAYER_ENTERING_WORLD",  -- zoning into a key or a raid changes which plan the bags follow (card 0009)
		"SOCKET_INFO_CLOSE",  -- a gem went in (or the socket window shut): the Plan tab's gem lines
		"TRAIT_CONFIG_UPDATED",  -- a talent moved or a loadout loaded: the Plan tab's "(edited)" mark and "your loadout now" (cards 0011, 0014)
		"CONFIG_COMMIT_FAILED",  -- the game refused a loadout: one chat line (card 0011)
		defaultBags and "BAG_UPDATE_DELAYED" or nil,
	}) do
		watcher:RegisterEvent(event)
		if not watcher:IsEventRegistered(event) then
			print(GOLD .. "Djinni's BiS|r " .. GREY
				.. "could not register " .. event
				.. ", so the bag marks will not refresh by themselves.|r")
		end
	end
	rebuildBagWanted()
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
		if not (self.link or self.tip) then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if self.link then GameTooltip:SetHyperlink(self.link) else GameTooltip:SetText(self.tip) end
		GameTooltip:Show()
	end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnClick", function(self)
		if self.onClick then self.onClick()
		elseif self.link then HandleModifiedItemClick(self.link) end
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
		-- A real button for a Plan tab action. The item level target stays plain
		-- text, because a target is a value and not a thing to do (Rob, 2026-09-22:
		-- the Equip "button" read as "a little bit of text").
		row.action = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
		row.action:SetSize(ILVL_WIDTH, ROW_HEIGHT - 2)
		row.action:SetPoint("RIGHT", row, "RIGHT")
		row.action:SetScript("OnClick", function(self) if self.onClick then self.onClick() end end)
		row.action:SetScript("OnEnter", function(self)
			if not self.tip then return end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tip)
			GameTooltip:Show()
		end)
		row.action:SetScript("OnLeave", function() GameTooltip:Hide() end)
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
		-- the Stats tab is per spec too, so its buttons stay up on both. The Plan
		-- tab is about the spec you are IN, so it has no use for them.
		button:SetShown(activeTab == 2 or activeTab == 3)
		if button.spec == activeSpec then button:LockHighlight() else button:UnlockHighlight() end
	end

	window.scroll:SetShown(activeTab ~= 3)
	window.statPane:SetShown(activeTab == 3)

	if activeTab == 3 then
		window.statPane:Update()
		return
	end

	if activeTab == 1 or activeTab == 4 then
		for i = 1, #cellPool do cellPool[i]:Hide() end
		renderList(activeTab == 1 and byBossLines() or PlanTab.lines())
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
		row.tip = line.tip  -- a plain-text hover for a row with no item, the plan's age (card 0026)
		row.onClick = line.onClick
		-- The right-hand button is the item level target on the BiS tabs and a
		-- named action (Equip, Search AH) on the Plan tab. One button, two jobs.
		local action = line.button
		row.ilvl.itemName = line.name
		row.ilvl.text:SetText(line.name and gearLabel(line.name) or "")
		row.ilvl:SetShown(line.name ~= nil)
		row.action.onClick = action and action.onClick
		row.action.tip = action and action.tip
		row.action:SetText(action and action.label or "")
		row.action:SetShown(action ~= nil)
		row:Show()
	end
	for i = #lines + 1, #rowPool do rowPool[i]:Hide() end
	window.content:SetSize(CONTENT_W, #lines * ROW_HEIGHT + 20)
end

-- Redraws the Plan tab if it is the one on screen. Called from the bag-mark
-- watcher on an equip or a spec change, never in combat.
function PlanTab.redraw()
	if window and window:IsShown() and activeTab == 4 and not InCombatLockdown() then refresh() end
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
local BAR_ROW_H = 36

-- Chonky Character Sheet's own numbers, read off its stat sections rather than
-- picked to taste: its content rows sit on 0.05 black at 60%, its section
-- headers on 0.1 black at 40%, and its sections are 238 wide. Matching those
-- three is what makes this pane read as one more of its panels instead of as a
-- box parked next to them. They are also perfectly ordinary values, so nothing
-- looks wrong when Chonky is not installed.
local ROW_BG = { 0.05, 0.05, 0.05, 0.6 }
local HEADER_BG = { 0.1, 0.1, 0.1, 0.4 }

local BAR_RGB = {
	at    = { 0.25, 0.85, 0.40 },
	above = { 0.30, 0.62, 0.95 },
	below = { 0.85, 0.30, 0.30 },
}

local function makeStatRow(parent, index, width)
	local barW = width - 24
	local row = CreateFrame("Frame", nil, parent)
	row:SetSize(barW, BAR_ROW_H - 3)
	row:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, -(index - 1) * BAR_ROW_H)
	row.barW = barW

	row.bg = row:CreateTexture(nil, "BACKGROUND")
	row.bg:SetPoint("TOPLEFT", -3, 0)
	row.bg:SetPoint("BOTTOMRIGHT", 3, 0)
	row.bg:SetColorTexture(unpack(ROW_BG))

	row.label = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	row.label:SetPoint("TOPLEFT", 2, -1)
	row.label:SetJustifyH("LEFT")

	row.value = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	row.value:SetPoint("TOPRIGHT", -2, -1)
	row.value:SetJustifyH("RIGHT")

	local bar = CreateFrame("Frame", nil, row)
	bar:SetSize(barW - 4, BAR_H)
	bar:SetPoint("BOTTOMLEFT", 2, 2)

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints()
	bar.bg:SetColorTexture(0.02, 0.02, 0.02, 0.95)

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
local function barX(rating, target, width)
	if not target or target <= 0 then return 0 end
	local ratio = rating / (target * BAR_SCALE)
	return math.max(0, math.min(1, ratio)) * width
end

local function setStatRow(row, stat, current, target, delta)
	local width = row.bar:GetWidth()
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
	local x = barX(current, target, width)
	bar.fill:SetWidth(math.max(1, x))
	bar.fill:SetColorTexture(rgb[1], rgb[2], rgb[3], 0.85)
	bar.tick:ClearAllPoints()
	bar.tick:SetPoint("TOP", bar, "TOPLEFT", width / BAR_SCALE, 0)
	bar.tick:SetPoint("BOTTOM", bar, "BOTTOMLEFT", width / BAR_SCALE, 0)

	if not delta or delta == 0 then
		bar.ghost:Hide()
		return
	end

	local afterX = barX(current + delta, target, width)
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

-- Chonky Character Sheet draws its own stat sections with exactly this
-- backdrop, so a pane wearing it reads as one more of them rather than as a
-- bolted-on box. It is a plain Blizzard dialog border, so it is equally at home
-- when Chonky is not installed at all.
local PANE_BACKDROP = {
	bgFile   = "Interface\\Buttons\\WHITE8X8",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	edgeSize = 6,
	insets   = { left = 2, right = 2, top = 2, bottom = 2 },
}

-- Chonky lets the player recolour its borders, including "use my class colour",
-- and it keeps that choice in a table this addon cannot see. What it CAN see is
-- the result, because every section it draws is a named global frame and the
-- backdrop colour of a frame is public. So the colour is read off the finished
-- article rather than guessed, and falls back to Blizzard's own grey.
local function paneBorderColour()
	local section = _G["CCS_Section_SECONDARY"]
	if section and section.GetBackdropBorderColor then
		local ok, r, g, b, a = pcall(section.GetBackdropBorderColor, section)
		if ok and r then return r, g, b, a or 1 end
	end
	return 0.6, 0.6, 0.6, 1
end

local HEADER_H = 23

-- Chonky's sections are a fixed width and this pane sits in a row with them, so
-- it takes theirs when they are there. Read off the finished frame rather than
-- hardcoded, so a future version that changes the number carries this along.
local function paneWidth()
	local section = _G["CCS_Section_SECONDARY"]
	local width = section and section:GetWidth()
	if width and width > 120 then return math.floor(width + 0.5) end
	return PANE_W
end

local function buildStatPane(parent, opts)
	local pane = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	local width = opts.framed and paneWidth() or PANE_W
	pane:SetWidth(width)

	if opts.framed then
		pane:SetBackdrop(PANE_BACKDROP)
		pane:SetBackdropColor(0.05, 0.05, 0.05, 0.85)
		pane:SetBackdropBorderColor(paneBorderColour())
	end

	-- A titled bar across the top, the shape and the colour every panel on that
	-- side of the sheet already has: near-black at 40%, with the title centred
	-- rather than tucked into the corner.
	pane.header = pane:CreateTexture(nil, "ARTWORK")
	pane.header:SetPoint("TOPLEFT", 5, -5)
	pane.header:SetPoint("TOPRIGHT", -5, -5)
	pane.header:SetHeight(HEADER_H)
	pane.header:SetColorTexture(unpack(HEADER_BG))
	pane.header:SetShown(opts.framed or false)

	pane.title = pane:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	pane.title:SetPoint("CENTER", pane.header, "CENTER", 0, 0)
	pane.title:SetText("Stat targets")
	pane.title:SetShown(opts.framed or false)

	local top = opts.framed and (HEADER_H + 8) or 4

	pane.context = CreateFrame("Button", nil, pane, "UIPanelButtonTemplate")
	pane.context:SetSize(80, 18)
	pane.context:SetPoint("TOPRIGHT", -8, -(top))

	pane.heading = pane:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	pane.heading:SetPoint("TOPLEFT", 12, -(top + 4))
	pane.heading:SetPoint("RIGHT", pane.context, "LEFT", -6, 0)
	pane.heading:SetJustifyH("LEFT")
	pane.heading:SetWordWrap(false)

	pane.context:SetScript("OnClick", function()
		-- Inside an instance the button is disabled; if a click lands anyway,
		-- writing the pin here would flip it unseen and surprise the next city.
		if autoContext() then return end
		local now = statContext()
		db().statContext = (now == "raid") and "mplus" or "raid"
		for _, other in ipairs(statPanes) do other:Update() end
	end)

	pane.rows = CreateFrame("Frame", nil, pane)
	pane.rows:SetPoint("TOPLEFT", 0, -(top + 24))
	pane.rows:SetSize(width, #STATS * BAR_ROW_H)
	pane.bars = {}
	for i, _ in ipairs(STATS) do
		pane.bars[i] = makeStatRow(pane.rows, i, width)
	end

	pane.footer = pane:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	pane.footer:SetPoint("TOPLEFT", pane.rows, "BOTTOMLEFT", 12, -2)
	pane.footer:SetPoint("RIGHT", pane, "RIGHT", -12, 0)
	pane.footer:SetJustifyH("LEFT")
	pane.footer:SetWordWrap(true)

	-- The fixed part of the height. The footer is added after it has text in
	-- it, because a two-line note and a one-line note are different heights and
	-- guessing at one of them is how text ends up outside the border.
	pane.fixedHeight = top + 24 + #STATS * BAR_ROW_H + 10
	pane:SetHeight(pane.fixedHeight + 14)

	function pane:Resize()
		local extra = math.max(12, math.ceil(self.footer:GetStringHeight() or 12))
		self:SetHeight(self.fixedHeight + extra + 4)
		if opts.onResize then opts.onResize(self) end
	end

	function pane:Update()
		-- opts.spec is a function so the window's pane follows its spec buttons
		-- and the character sheet's pane follows the character.
		local spec = opts.spec and opts.spec() or playerSpec()
		local context, pinned = statContext()
		self.context:SetText(CONTEXT_LABEL[context] .. (pinned and "" or " *"))
		self.context:SetEnabled(autoContext() == nil)  -- where you stand is not a choice

		-- `spec and targetsFor(...)` would keep only the first return, which is
		-- how the hero name would silently go missing
		local targets, hero
		if spec then targets, hero = targetsFor(spec, context) end
		if not targets then
			self.heading:SetText(GREY .. "No stat targets for this spec.|r")
			for _, row in ipairs(self.bars) do row:Hide() end
			self.footer:SetText("")
			self:Resize()
			return
		end

		-- Say it rather than draw four bars at zero. PLAYER_REGEN_ENABLED fills
		-- the cache and runs this again. The wording does not say "in combat":
		-- Blizzard documents the restriction as "when access to unit stats would
		-- generally produce secret values", which is not promised to be combat only.
		local ratings = allRatings(ratingOf)
		if not ratings then
			self.heading:SetText(GREY .. "Ratings are hidden right now.|r")
			for _, row in ipairs(self.bars) do row:Hide() end
			self.footer:SetText(GREY .. "The bars come back when combat or the encounter ends.|r")
			self:Resize()
			return
		end
		for _, row in ipairs(self.bars) do row:Show() end

		local deltas, replaced
		if previewLink then deltas, replaced = deltaAgainstEquipped(previewLink) end

		self.heading:SetText(("%s%s|r  %s%s|r"):format(
			GOLD, spec,
			GREY, hero and hero:gsub("-", " ") or "all hero talents"))

		for i, stat in ipairs(STATS) do
			setStatRow(self.bars[i], stat, ratings[stat], targets[stat],
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
		self:Resize()
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
	local TAB_LABELS = { "By Boss", "By Slot", "Stats", "Plan" }
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
	-- A new frame is born shown, so without this the first /djbis after a
	-- reload "toggled" it closed and only the second opened it (Rob, 2026-09-22).
	f:Hide()
	return f
end

-- What the plan strip under the character sheet opens: the list behind its
-- "N slots to fix".
-- `scenario` is the one the strip is counting. The tab opens on a boss of that
-- scenario, or "7 slots to fix" on 2 targets would open a 1 target list.
function PlanTab.bossFor(bosses, pickedBoss, scenario)
	local first
	for _, row in ipairs(bosses or {}) do
		if row.scenario == scenario then
			if row.boss == pickedBoss then return pickedBoss end
			first = first or row.boss
		end
	end
	return first or pickedBoss
end

-- The row for what ENCOUNTER_START or ENCOUNTER_END handed over (card 0027):
-- by id first, because the events' name is the journal's long one ("Nek'zali
-- the Soulcoiler") and a locale or a hotfix can change it; by name only when
-- there is no id, exact after norm() or the event name starting with the row's.
-- Both arrive from the game, so each is tested with canRead before it is
-- compared: a secret one would throw (docs/DECISIONS.md, 2026-08-21).
function PlanTab.bossRow(bosses, id, name)
	-- canRead before `~= nil`: the comparison is the thing a secret throws on
	if canRead(id) and id ~= nil then
		for _, row in ipairs(bosses or {}) do
			if row.id == id then return row end
		end
		return nil
	end
	if type(name) ~= "string" or not canRead(name) then return nil end
	local want = norm(name)
	for _, row in ipairs(bosses or {}) do
		local have = norm(row.boss)
		if want == have or want:find(have, 1, true) == 1 then return row end
	end
	return nil
end

function PlanTab.open(scenario)
	PlanTab.boss = PlanTab.bossFor(PlanTab.BOSSES[playerSpec() or ""], PlanTab.boss, scenario)
	window = window or buildWindow()
	activeTab = 4
	refresh()
	window:Show()
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
	PlanTab.broker = broker  -- its text is kept by PlanTab.updateBroker (card 0026)

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

-- WHERE THE RIGHT EDGE OF THE CHARACTER SHEET ACTUALLY IS.
--
-- Not `CharacterFrame:GetRight()`. A child frame is not clipped to its parent,
-- so a sheet replacement can widen the thing on screen without CharacterFrame's
-- own bounds moving at all, and Chonky Character Sheet does exactly that: it
-- fills CharacterStatsPane, which is Blizzard's own frame, with stat sections
-- that reach past the frame they descend from. Anchoring to CharacterFrame's
-- right edge put this pane on top of them.
--
-- These three named frames are what the sheet is made of, and the widest of
-- them is its edge. They are all Blizzard's, which is the point: this reads
-- correctly for a plain sheet and for a replacement that fills them, and it
-- names no other addon.
--
-- IT USED TO WALK EVERY DESCENDANT AND TAKE THE FURTHEST RIGHT, AND THAT PUT
-- THE PANE IN THE MIDDLE OF THE SCREEN. Other addons parent frames to
-- CharacterFrame, and a frame's own IsShown flag reads true even when an
-- ancestor is hidden, so the walk found something far away and believed it. A
-- fixed list cannot do that, and it is the smaller thing as well.
local SHEET_FRAMES = { "CharacterFrame", "CharacterFrameInsetRight", "CharacterStatsPane" }

-- Returns the FRAME, not the number. Anchoring to a frame is what makes the
-- pane follow the sheet when it is dragged: a point set from coordinates is
-- measured once and then sits there while the sheet walks away from it, which
-- is what the first version of this did.
local function widestSheetFrame()
	local widest, right = CharacterFrame, CharacterFrame:GetRight() or 0
	for _, name in ipairs(SHEET_FRAMES) do
		local frame = _G[name]
		if frame and frame:IsVisible() then
			local edge = frame:GetRight()
			if edge and edge > right then widest, right = frame, edge end
		end
	end
	return widest, right
end

-- Slot marks on the character sheet -------------------------------------------
--
-- Blizzard's own buttons, by inventory slot id. Chonky Character Sheet moves
-- these same buttons rather than drawing its own (read in its Modules/MOP.lua,
-- 2026-09-21), so a glow anchored to the button lands right under either sheet.
local SLOT_BUTTONS = {
	[1] = "CharacterHeadSlot", [2] = "CharacterNeckSlot", [3] = "CharacterShoulderSlot",
	[5] = "CharacterChestSlot", [6] = "CharacterWaistSlot", [7] = "CharacterLegsSlot",
	[8] = "CharacterFeetSlot", [9] = "CharacterWristSlot", [10] = "CharacterHandsSlot",
	[11] = "CharacterFinger0Slot", [12] = "CharacterFinger1Slot",
	[13] = "CharacterTrinket0Slot", [14] = "CharacterTrinket1Slot",
	[15] = "CharacterBackSlot", [16] = "CharacterMainHandSlot",
	[17] = "CharacterSecondaryHandSlot",
}
-- "lesser" is a quiet grey: a lower rank of the right thing is fine, and Rob
-- said so (2026-09-22). It is there to be seen, not to nag.
local MARK_COLOUR = { change = { 1, 0.15, 0.15 }, enchant = { 1, 0.7, 0 }, gem = { 1, 0.7, 0 }, lesser = { 0.6, 0.6, 0.6 } }
local MARK_LABEL = { change = "", enchant = "enchant", gem = "gem", lesser = "rank" }
local LOCATION_WORD = { bags = "in your bags", bank = "in the bank", missing = "not owned" }
local PLAN_STRIP_H = 44

-- The bag and slot holding the planned piece, or nil.
local function planItemInBags(entry)
	if not (C_Container and C_Container.GetContainerItemLink) then return nil end
	for bag = 0, NUM_TOTAL_EQUIPPED_BAG_SLOTS or 5 do
		for slot = 1, C_Container.GetContainerNumSlots(bag) or 0 do
			if planMatchesLink(entry, C_Container.GetContainerItemLink(bag, slot)) then return bag, slot end
		end
	end
	return nil
end

-- The bags, and the bank too while it is open: at the bank its tabs are
-- containers like any other (Enum.BagIndex.CharacterBankTab_1 .. AccountBankTab_5,
-- 6 to 16) and a pickup from one equips the same way. Rob pressed Equip all
-- standing at the bank on 2026-09-22 with five pieces in it and nothing moved.
function PlanTab.holding(entry)
	local bag, slot = planItemInBags(entry)
	if bag then return bag, slot, "bags" end
	if not (C_Bank and C_Bank.AreAnyBankTypesViewable and C_Bank.AreAnyBankTypesViewable()) then return nil end
	for tab = 6, 16 do
		for s = 1, C_Container.GetContainerNumSlots(tab) or 0 do
			if planMatchesLink(entry, C_Container.GetContainerItemLink(tab, s)) then return tab, s, "bank" end
		end
	end
	return nil
end

-- The three buttons (Rob, 2026-09-22: "planner should have a button to change
-- talents / gear / shop for gems and enchants on the AH").

-- Opens the talent window. The fallback when the loadout cannot be loaded.
function PlanTab.openTalents()
	if PlayerSpellsUtil and PlayerSpellsUtil.OpenToClassTalentsTab then
		PlayerSpellsUtil.OpenToClassTalentsTab()
	end
end

-- The Talents button loads the loadout through ClassTalentHelper (card 0011),
-- the code behind Blizzard's own /loadout-by-name slash command
-- (Blizzard_ChatFrame/Shared/ClassTalentHelper.lua). It fires an event that
-- Blizzard's talent frame answers with LoadConfigByName, so the frame runs
-- the change and this file calls no C_ClassTalents or C_Traits function that
-- writes: LoadConfig or CommitConfig from addon code is the known route to
-- action bars that freeze in combat (card 0002 found ClassCodex doing it).
-- Rob ran the same call by hand on 2026-09-22: loaded, no frozen bar.

-- The saved loadout names for the spec as a set, or nil when the game will
-- not say. Read only, the same two calls Blizzard's frame makes to fill its
-- own dropdown (Blizzard_ClassTalentsFrame.lua, RefreshLoadoutOptions).
function PlanTab.savedLoadoutNames()
	local spec = C_SpecializationInfo
	if not (spec and spec.GetSpecialization and C_ClassTalents and C_ClassTalents.GetConfigIDsBySpecID
		and C_Traits and C_Traits.GetConfigInfo) then return nil end
	local ok, specID = pcall(spec.GetSpecializationInfo, spec.GetSpecialization())
	if not ok or not specID then return nil end
	local okIDs, ids = pcall(C_ClassTalents.GetConfigIDsBySpecID, specID)
	if not okIDs or type(ids) ~= "table" then return nil end
	local names = {}
	for _, id in ipairs(ids) do
		local okInfo, info = pcall(C_Traits.GetConfigInfo, id)
		local name = okInfo and info and info.name
		if name and canRead(name) then names[name] = true end
	end
	return names
end

-- The Talents button. Answers what it did, for the checks: "combat" did
-- nothing; "missing" opened the window and said which name is not saved;
-- "loaded" asked Blizzard's helper; "no helper" opened the window as before.
-- When the game will not list the loadouts the helper is still asked, and
-- Blizzard's frame says ERR_TALENT_FAILED_INVALID_CONFIG itself if need be.
function PlanTab.loadTalents(name)
	if InCombatLockdown() then return "combat" end
	local saved = PlanTab.savedLoadoutNames()
	if saved and not saved[name] then
		PlanTab.openTalents()
		print(("%sDjinni's BiS|r %sno saved loadout named \"%s\" for this spec. Save one with that name.|r"):format(GOLD, GREY, name))
		return "missing"
	end
	if not (ClassTalentHelper and ClassTalentHelper.SwitchToLoadoutByName) then
		PlanTab.openTalents()
		return "no helper"
	end
	ClassTalentHelper.SwitchToLoadoutByName(name)
	return "loaded"
end

-- TRAIT_CONFIG_UPDATED is a loadout landing, CONFIG_COMMIT_FAILED is the game
-- refusing one. One chat line for the refusal, and either way the tab's "your
-- loadout now" is redrawn. Called from the bag-mark watcher.
function PlanTab.onTalentEvent(event)
	if event == "CONFIG_COMMIT_FAILED" then
		print(GOLD .. "Djinni's BiS|r " .. GREY .. "the talent change did not go through (CONFIG_COMMIT_FAILED). Stand still, out of combat, and click Talents again.|r")
	end
	if PlanTab.redraw then PlanTab.redraw() end
end

-- Picks the exact bag copy up and drops it in the slot the plan chose, so a
-- lower-track twin is never the one equipped and a ring lands on the planned
-- finger. Out of combat only. Returns true when an equip was asked for.
function PlanTab.equip(entry, slotID)
	if InCombatLockdown() then return false end
	local bag, slot = PlanTab.holding(entry)
	if not bag then return false end
	-- Step for step what Blizzard's own equipment sets do
	-- (Blizzard_FrameXML/Mainline/EquipmentManager.lua, EquipmentManager_EquipContainerItem),
	-- because that is what works at a bank, a vendor and in a raid. Each refusal
	-- says why in chat: Rob pressed Equip all at the bank on 2026-09-22 and
	-- nothing moved and nothing said so.
	local function refused(why)
		ClearCursor()  -- never leave it on the cursor: a click on the world from there is the destroy prompt
		print(("%sDjinni's BiS|r %s%s not equipped: %s|r"):format(GOLD, GREY, C_Item.GetItemInfo(entry.id) or ("item " .. entry.id), why))
		return false
	end
	ClearCursor()
	C_Container.PickupContainerItem(bag, slot)
	if not CursorHasItem() then return refused("could not pick it up (the slot is locked, a move is still in flight)") end
	if not C_PaperDollInfo.CanCursorCanGoInSlot(slotID) then return refused("the game says it cannot go in " .. (PLAN_SLOT_LABEL[slotID] or "that slot")) end
	if IsInventoryItemLocked(slotID) then return refused((PLAN_SLOT_LABEL[slotID] or "that slot") .. " is locked, a move is still in flight") end
	PickupInventoryItem(slotID)
	return true
end

-- What to type into the auction house for a thing on the list. An enchant is
-- sold as a scroll named after the enchant, so the rank is dropped. Nil when
-- the name is not known yet, which is a gem the client has not cached.
function PlanTab.searchTerm(kind, id)
	-- Not `a and b or c`: an enchant id nobody named would fall through to an
	-- ITEM lookup by the enchant's id and search the house for a stranger.
	local row = PlanTab.RANK[kind][id]
	if row then return row[1] end
	if kind == "enchant" then return nil end
	local name = C_Item.GetItemInfo(id)
	return name and canRead(name) and name or nil
end

-- Runs the auction house's own search box, which is what a typed search does
-- (Blizzard_AuctionHouseSearchBar.lua, StartSearch). Needs the house open.
function PlanTab.searchAH(term)
	local ah = AuctionHouseFrame
	if not (ah and ah:IsShown() and ah.SearchBar) then
		print(GOLD .. "Djinni's BiS|r " .. GREY .. "Open the auction house first, then click Search AH.|r")
		return false
	end
	ah.SearchBar:SetSearchText(term)
	ah.SearchBar:StartSearch()
	return true
end

-- Auctionator (card 0025) ----------------------------------------------------
--
-- Through its public API only (Auctionator/Source/API/v1, read 2026-09-22):
-- every call takes the caller's addon name first. ClassCodex edits
-- Auctionator's saved lists by hand instead; that is not copied here.

PlanTab.AUCTIONATOR_LIST = "DjinnisBiS plan"

-- Auctionator's v1 API, or nil when it is not loaded. The global is asked,
-- not IsAddOnLoaded: the table is what gets called.
function PlanTab.auctionator()
	local a = Auctionator
	return a and a.API and a.API.v1 or nil
end

-- 123456 copper is "12g 34s". Copper is never shown; nothing here costs less than a silver.
function PlanTab.gold(copper)
	return ("%dg %02ds"):format(math.floor(copper / 10000), math.floor(copper % 10000 / 100))
end

-- Auctionator's price for one of a thing on the list, in copper, or nil: no
-- Auctionator, nothing seen yet, or an enchant. An enchant's id is the
-- enchant's, not the scroll's item id, so there is nothing to ask a price of.
-- ponytail: price enchants when PlanTab.RANK carries the scroll item id.
function PlanTab.priceOf(kind, id)
	local api = PlanTab.auctionator()
	if not api or kind ~= "gem" then return nil end
	local ok, price = pcall(api.GetAuctionPriceByItemID, "DjinnisBiS", id)
	return ok and type(price) == "number" and price or nil
end

-- shoppingLines with a price on the end of each line Auctionator can price.
-- Returns the lines, the total in copper (nil without Auctionator) and how
-- many lines had no price.
function PlanTab.pricedLines(list, nameOf)
	local lines = PlanTab.shoppingLines(list, nameOf)
	if not PlanTab.auctionator() then return lines, nil, 0 end
	local total, unpriced = 0, 0
	for i, want in ipairs(list) do
		local each = PlanTab.priceOf(want.kind, want.id)
		if each then
			total = total + each * want.count
			lines[i] = lines[i] .. "   " .. GREY .. PlanTab.gold(each * want.count) .. "|r"
		else
			unpriced = unpriced + 1
		end
	end
	return lines, total, unpriced
end

-- Makes or replaces the "DjinnisBiS plan" shopping list from the list's
-- search terms (the same terms Search AH uses, the rank stripped). A thing
-- with no term yet is left out and said. False, with the reason printed,
-- when Auctionator is absent or its API refuses.
function PlanTab.sendToAuctionator(list)
	local api = PlanTab.auctionator()
	if not api then
		print(GOLD .. "Djinni's BiS|r " .. GREY .. "Auctionator is not loaded.|r")
		return false
	end
	local terms, skipped = {}, 0
	for _, want in ipairs(list) do
		local term = PlanTab.searchTerm(want.kind, want.id)
		if term then terms[#terms + 1] = term else skipped = skipped + 1 end
	end
	-- Nothing named yet would replace the last good list with an empty one (0025 review).
	if #terms == 0 then
		print(GOLD .. "Djinni's BiS|r " .. GREY .. "Nothing on the list has a name yet; the Auctionator list is left as it was.|r")
		return false
	end
	local ok, err = pcall(api.CreateShoppingList, "DjinnisBiS", PlanTab.AUCTIONATOR_LIST, terms)
	if not ok then
		print(GOLD .. "Djinni's BiS|r " .. GREY .. "Auctionator refused the list: " .. tostring(err) .. "|r")
		return false
	end
	print(("%sDjinni's BiS|r %s%d item%s sent to Auctionator's \"%s\" list%s.|r"):format(GOLD, GREY, #terms,
		#terms == 1 and "" or "s", PlanTab.AUCTIONATOR_LIST,
		skipped > 0 and (", " .. skipped .. " with no name yet left out") or ""))
	return true
end

-- A Blizzard equipment set for each plan (card 0012) -------------------------
--
-- Saved from what is WORN, because that is all C_EquipmentSet can save from
-- (Blizzard_APIDocumentationGenerated/EquipmentManagerDocumentation.lua), so
-- it runs after Equip all lands, and from a Save set button when every slot
-- already matches. Blizzard then does the remembering: the set is on the
-- character sheet, in `/equipset`, and on every item tooltip.

-- Names stay within 16 letters, the cap on Blizzard's own name box
-- (Blizzard_SharedXML/Mainline/SharedUIPanelTemplates.xml, IconSelectorEditBox
-- letters="16"): "DBiS Guardian 2T" is exactly 16. A longer name that the
-- server cut short would not be found again and would be created afresh on
-- every Equip all. ST and 2T are raid cells, so "Raid" is not spelt out.
PlanTab.SET_PREFIX = "DBiS "
PlanTab.SET_SUFFIX = { st = "ST", ["2t"] = "2T", mplus = "M+" }
function PlanTab.setName(spec, scenario)
	return PlanTab.SET_PREFIX .. spec .. " " .. (PlanTab.SET_SUFFIX[scenario] or "?")
end

-- Only a set this addon named is ever saved over. Rob's own sets are not.
function PlanTab.ownsSet(name)
	return type(name) == "string" and name:sub(1, #PlanTab.SET_PREFIX) == PlanTab.SET_PREFIX
end

-- The labels of the planned slots not wearing the planned piece, sorted by
-- slot. An enchant or gem short of the plan does not count: the item is on.
function PlanTab.missingSlots(plan, wornBySlot)
	local ids = {}
	for slotID, mark in pairs(slotStates(plan, wornBySlot)) do
		if mark.state == "change" then ids[#ids + 1] = slotID end
	end
	table.sort(ids)
	for i, slotID in ipairs(ids) do ids[i] = PLAN_SLOT_LABEL[slotID] or tostring(slotID) end
	return ids
end

-- Saves the worn gear as the plan's set, creating it or updating the one of
-- that name. Returns true and the name, or false and why not. Pure apart
-- from the C_EquipmentSet calls, so /bis test drives it with a stub.
function PlanTab.saveSet(spec, scenario)
	local api = C_EquipmentSet
	if not (api and api.CreateEquipmentSet) then return false, "no equipment manager" end
	if InCombatLockdown() then return false, "not in combat" end
	if api.CanUseEquipmentSets and not api.CanUseEquipmentSets() then return false, "the equipment manager is off" end
	local plan = gearPlanFor(spec, scenario)
	if not plan then return false, "no plan for " .. spec .. " " .. (SCENARIO_LABEL[scenario] or "?") end
	local worn = readWorn()
	if not worn then return false, "your gear cannot be read right now" end
	local missing = PlanTab.missingSlots(plan, worn)
	if #missing > 0 then return false, "not worn: " .. table.concat(missing, ", ") end
	local name = PlanTab.setName(spec, scenario)
	local id = api.GetEquipmentSetID(name)
	-- The id came from our own name, but the name it answers to is checked
	-- back before anything is saved over it.
	if id and not PlanTab.ownsSet((api.GetEquipmentSetInfo(id))) then return false, "set " .. id .. " is not ours" end
	if not id and api.GetNumEquipmentSets and MAX_EQUIPMENT_SETS_PER_PLAYER
		and api.GetNumEquipmentSets() >= MAX_EQUIPMENT_SETS_PER_PLAYER then
		return false, "you already have " .. MAX_EQUIPMENT_SETS_PER_PLAYER .. " sets"
	end
	-- Shirt and tabard are cosmetic, and a set that holds them fights transmog.
	-- 4 and 19 are INVSLOT_BODY and INVSLOT_TABARD (Blizzard_FrameXMLBase/Constants.lua).
	api.ClearIgnoredSlotsForSave()
	api.IgnoreSlotForSave(4)
	api.IgnoreSlotForSave(19)
	local icon
	local si = C_SpecializationInfo
	if si and si.GetSpecialization and si.GetSpecializationInfo then
		local ok, _, _, _, fileID = pcall(si.GetSpecializationInfo, si.GetSpecialization())
		icon = ok and fileID or nil
	end
	if id then api.SaveEquipmentSet(id, icon) else api.CreateEquipmentSet(name, icon) end
	return true, name
end

-- saveSet, said in chat. Equip all calls it two seconds after the last
-- pickup, because an equip is a server round trip and the slots read stale
-- until it lands; the Save set button calls it at once.
function PlanTab.saveSetAndSay(spec, scenario)
	local ok, detail = PlanTab.saveSet(spec, scenario)
	print(("%sDjinni's BiS|r %s%s|r"):format(GOLD, ok and WHITE or GREY,
		ok and ("Saved as equipment set " .. detail) or ("No equipment set saved: " .. detail)))
	return ok
end

local function itemName(id)
	return id and C_Item.GetItemInfo(id) or ("item " .. tostring(id))
end

function PlanTab.enchantName(id)
	return PlanTab.rankName("enchant", id)
end

-- One line saying what the plan wants in this slot and where that is.
local function planLineFor(mark)
	local entry = mark.entry
	if mark.state == "enchant" then
		return "Plan: enchant with " .. PlanTab.enchantName(entry.enchant)
	elseif mark.state == "gem" then
		local _, missing = PlanTab.gemMatch(entry.gems, mark.worn and mark.worn.gems)
		local names = {}
		for i, gem in ipairs(missing) do names[i] = PlanTab.rankName("gem", gem) end
		return #names > 0 and ("Plan: wants " .. table.concat(names, ", ")) or "Plan: a socket is empty"
	elseif mark.state == "lesser" then
		-- Not wrong. Rob may have picked the cheaper rank on purpose (2026-09-22).
		local parts = {}
		if entry.enchant and PlanTab.rankState("enchant", entry.enchant, mark.worn.enchant) == "lesser" then
			parts[#parts + 1] = PlanTab.rankName("enchant", mark.worn.enchant)
		end
		local _, _, lesser = PlanTab.gemMatch(entry.gems, mark.worn.gems)
		for _, pair in ipairs(lesser) do parts[#parts + 1] = PlanTab.rankName("gem", pair[2]) end
		return "Plan: fine. " .. table.concat(parts, ", ") .. " is on; a higher rank exists"
	end
	local inBank = C_Item.GetItemCount(entry.id, true, false, true, true) - C_Item.GetItemCount(entry.id)
	return ("Plan: %s (%d), %s"):format(itemName(entry.id), entry.ilvl,
		LOCATION_WORD[planLocation(planItemInBags(entry), inBank)])
end

-- The Plan tab ----------------------------------------------------------------
--
-- One boss picked, three answers under it: which loadout, which slots to
-- change, what to buy. It names a loadout and applies one only through
-- Blizzard's own ClassTalentHelper (card 0011, PlanTab.loadTalents): an addon
-- that calls C_ClassTalents.LoadConfig or CommitConfig itself is the known
-- route to action bars that stop updating in combat (card 0002 found
-- ClassCodex doing it).

-- Whether the talents in play still match the saved loadout the game says is
-- selected (card 0014): the active config's import string against the saved
-- config's, both from C_Traits.GenerateImportString. true when edited, false
-- when they match, nil when the game will not say. Read out of combat only;
-- in combat the last reading is held rather than blanked, per DECISIONS.md.
function PlanTab.talentsEdited(savedConfigID)
	if InCombatLockdown() then return PlanTab.lastEdited end
	local edited = nil
	if savedConfigID and C_ClassTalents.GetActiveConfigID and C_Traits.GenerateImportString then
		local activeConfigID = C_ClassTalents.GetActiveConfigID()
		if activeConfigID then
			local okActive, active = pcall(C_Traits.GenerateImportString, activeConfigID)
			local okSaved, saved = pcall(C_Traits.GenerateImportString, savedConfigID)
			edited = PlanTab.talentStringsDiffer(okActive and active, okSaved and saved)
		end
	end
	PlanTab.lastEdited = edited
	return edited
end

-- The saved loadout picked in the talent window, by name, or nil, and then
-- whether the talents have been edited away from it since (card 0014). The
-- name alone is the last loadout SELECTED, which a hand edit does not change.
function PlanTab.activeLoadoutName()
	local spec = C_SpecializationInfo
	if not (spec and spec.GetSpecialization and C_ClassTalents and C_Traits) then return nil end
	local ok, specID = pcall(spec.GetSpecializationInfo, spec.GetSpecialization())
	if not ok or not specID then return nil end
	-- The starter build is not a saved loadout, and while it is active the last
	-- SELECTED id still names the old one, which would draw a stale green.
	-- Blizzard's own talent frame makes the same check first.
	local okStarter, starter = pcall(C_ClassTalents.GetStarterBuildActive)
	if okStarter and starter then return nil end
	local okConfig, configID = pcall(C_ClassTalents.GetLastSelectedSavedConfigID, specID)
	if not okConfig or not configID then return nil end
	local okInfo, info = pcall(C_Traits.GetConfigInfo, configID)
	local name = okInfo and info and info.name
	if not (name and canRead(name)) then return nil end
	return name, PlanTab.talentsEdited(configID)
end

-- The /simc export (card 0018). The Simulationcraft addon already writes every
-- saved loadout of the spec as "# Saved Loadout: NAME" then "# talents=...",
-- so Raidbots sims them all from one paste. What it cannot say is which boss
-- wants which one, and a planned loadout that is not saved in the game just
-- is not there. This adds a comment block of boss -> loadout, and for a
-- planned loadout the game has not saved, the plan's own talent string where
-- the gear plan carries one, else the name goes to chat and the loadout is
-- left out.
--
-- Pure: `saved` is a set of the names saved in the game, `cells` maps a
-- loadout name to the plan's talent string. Returns the lines and the names
-- left out, so /bis test can prove both without a client.
function PlanTab.simcLines(spec, bosses, saved, cells)
	local lines = { ("# Djinni's BiS plan (%s): boss -> loadout"):format(spec) }
	local missing, seen = {}, {}
	for _, row in ipairs(bosses) do
		lines[#lines + 1] = ("# %s -> %s"):format(row.boss, row.loadout)
	end
	for _, row in ipairs(bosses) do
		if not saved[row.loadout] and not seen[row.loadout] then
			seen[row.loadout] = true
			local talents = cells[row.loadout]
			if talents then
				lines[#lines + 1] = ("# Saved Loadout: %s (DBiS plan)"):format(row.loadout)
				lines[#lines + 1] = "# talents=" .. talents
			else
				missing[#missing + 1] = row.loadout
			end
		end
	end
	return lines, missing
end

-- Where the block goes: after the last "# talents=" line, so it sits with the
-- SimC addon's own loadouts, else after the live "talents=" line, else the end.
function PlanTab.simcInsert(profile, block)
	local at  -- index of the last character of the line the block follows
	for e in profile:gmatch("\n# talents=[^\n]*()") do at = e - 1 end
	if not at then at = select(2, profile:find("\ntalents=[^\n]*")) end
	if not at then return profile .. "\n" .. block .. "\n" end
	return profile:sub(1, at) .. "\n" .. block .. profile:sub(at + 1)
end

function PlanTab.simcAppend(profile)
	local spec = playerSpec()
	local bosses = spec and PlanTab.BOSSES[spec]
	if not bosses then return profile end
	local saved = {}
	if C_ClassTalents and C_ClassTalents.GetConfigIDsBySpecID and C_Traits and C_Traits.GetConfigInfo then
		local okSpec, specID = pcall(C_SpecializationInfo.GetSpecializationInfo, C_SpecializationInfo.GetSpecialization())
		local okIDs, ids = pcall(C_ClassTalents.GetConfigIDsBySpecID, okSpec and specID or nil)
		for _, id in ipairs(okIDs and ids or {}) do
			local okInfo, info = pcall(C_Traits.GetConfigInfo, id)
			local name = okInfo and info and info.name
			if name and canRead(name) then saved[name] = true end
		end
	end
	local cells = {}
	for _, cell in pairs(GEAR_PLAN[spec] or {}) do
		if cell.loadout and cell.talents then cells[cell.loadout] = cell.talents end
	end
	local lines, missing = PlanTab.simcLines(spec, bosses, saved, cells)
	if #missing > 0 then
		print(GOLD .. "Djinni's BiS|r " .. GREY .. "not saved in the game, so left out of the /simc export: |r"
			.. table.concat(missing, ", "))
	end
	return PlanTab.simcInsert(profile, table.concat(lines, "\n"))
end

-- Wrap the Simulationcraft addon's profile builder, once, and only when it is
-- loaded. A plain wrapper, not hooksecurefunc: the block has to go into the
-- returned string. Nothing of Blizzard's is touched.
function PlanTab.armSimc()
	local simc = _G.Simulationcraft
	if type(simc) ~= "table" or type(simc.GetSimcProfile) ~= "function" or simc.DjinnisBiSWrapped then return false end
	local build = simc.GetSimcProfile
	simc.GetSimcProfile = function(self, ...)
		local profile, err = build(self, ...)
		if type(profile) == "string" and not err then
			local ok, more = pcall(PlanTab.simcAppend, profile)
			if ok and more then profile = more end
		end
		return profile, err
	end
	simc.DjinnisBiSWrapped = true
	return true
end

-- PlanTab.boss is the boss picked in the tab; the first one until a click.
-- `forSpec` is for /bis test only, which has to pass whatever spec runs it.
-- How old the plan is (card 0026). A plan is baked in from one Raidbots report
-- and goes stale: a patch, a drop, a new build. Raidbots also drops a report
-- after about 30 days, so an old link may stop opening.
PlanTab.STALE_DAYS = 14  -- Rob's first guess on the card; he sets it
PlanTab.MONTHS = { Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
	Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12 }

-- "Sep 10 2026", the client build date GetBuildInfo prints, as "2026-09-10".
-- Nil for anything else, and nil never marks a plan old.
function PlanTab.isoBuildDate(built)
	local mon, day, year = tostring(built or ""):match("^(%a%a%a) +(%d+) +(%d%d%d%d)$")
	local m = mon and PlanTab.MONTHS[mon]
	if not m then return nil end
	return ("%04d-%02d-%02d"):format(tonumber(year), m, tonumber(day))
end

-- Whole days from an ISO date to `now` (a time()), or nil for a date that
-- cannot be read. Rounded, so a report simmed this morning is 0 days old.
function PlanTab.daysSince(iso, now)
	local y, m, d = tostring(iso or ""):match("^(%d%d%d%d)-(%d%d)-(%d%d)$")
	if not y then return nil end
	local then_ = time({ year = tonumber(y), month = tonumber(m), day = tonumber(d), hour = 12 })
	return math.floor((now - then_) / 86400 + 0.5)
end

-- days, old: `old` when the report is over STALE_DAYS old or was simmed
-- before the game build the client is running, which is the last patch the
-- addon can know about without a hand-kept date. Nil days for an unreadable date.
function PlanTab.planAge(simmed, now, built)
	local days = PlanTab.daysSince(simmed, now)
	if not days then return nil, false end
	local build = PlanTab.isoBuildDate(built)
	return days, days > PlanTab.STALE_DAYS or (build ~= nil and simmed < build)
end

-- The Plan tab's line under the gear header: the report date and its age,
-- amber with "re-sim?" in its hover when old.
function PlanTab.ageLine(simmed, days, old)
	local AMBER = "|cffffb300"
	local age = days and ("%d day%s old"):format(days, days == 1 and "" or "s") or "age not known"
	return {
		text = ("   %sReport simmed %s, %s|r"):format(old and AMBER or GREY, tostring(simmed), age),
		tip = old and ("Older than %d days, or older than this game build. Re-sim?"):format(PlanTab.STALE_DAYS)
			or "The Raidbots Top Gear report this plan came from. Raidbots keeps a report about 30 days.",
	}
end

function PlanTab.lines(forSpec)
	local RED = "|cffff2020"
	local LOADOUT_COLOUR = { match = GREEN, mismatch = RED, unknown = WHITE }
	local spec = forSpec or playerSpec()
	local bosses = spec and PlanTab.BOSSES[spec]
	if not bosses then
		-- the strip under the character sheet says "Click for how", so say how
		return {
			{ text = ("%sNo boss plan for %s yet. Only Feral has one.|r"):format(GREY, spec or "this spec") },
			{ text = GREY .. "For a gear plan: run a Raidbots Top Gear sim, then: .\\update-gear-plan.ps1 <report link> -Deploy|r" },
		}
	end

	local picked = bosses[1]
	for _, row in ipairs(bosses) do
		if row.boss == PlanTab.boss then picked = row end
	end

	local active, edited = PlanTab.activeLoadoutName()
	local lines = {
		{ text = ("%sPick the boss you are about to pull. Everything below is for that boss.|r"):format(GREY) },
		{ text = "" },
		{ text = ("%s1. Talents|r   %syour loadout now: |r%s%s%s|r"):format(GOLD, GREY, WHITE,
				active or "not known", edited and " (edited)" or ""),
			button = { label = "Talents", tip = ("Load \"%s\" through Blizzard's own talent helper, as its slash command would. Out of combat only."):format(picked.loadout),
				onClick = function() PlanTab.loadTalents(picked.loadout) end } },
	}
	for _, row in ipairs(bosses) do
		local isPicked = row == picked
		-- Only the picked boss is judged. Red on every other row would be nine
		-- warnings about fights nobody is standing in front of.
		local colour = isPicked and LOADOUT_COLOUR[PlanTab.loadoutState(row.loadout, active, edited)] or GREY
		lines[#lines + 1] = {
			text = ("%s%s|r   %s%s|r   %s%s|r"):format(
				isPicked and (WHITE .. "> ") or (GREY .. "   "), row.boss,
				colour, row.loadout, GREY, SCENARIO_LABEL[row.scenario]),
			onClick = function() PlanTab.boss = row.boss; refresh() end,
		}
	end
	if PlanTab.loadoutState(picked.loadout, active, edited) == "mismatch" then
		lines[#lines + 1] = { text = ("%sClick Talents to load \"%s\" before %s.|r"):format(RED, picked.loadout, picked.boss) }
	end

	lines[#lines + 1] = { text = "" }
	lines[#lines + 1] = { text = ("%s2. Gear to change|r   %s%s plan|r"):format(GOLD, GREY, SCENARIO_LABEL[picked.scenario]) }
	local plan = gearPlanFor(spec, picked.scenario)
	local worn = plan and readWorn()
	if plan then
		-- The report date and its age, before anything the report says, so a
		-- stale plan is marked even when the gear cannot be read.
		local days, old = PlanTab.planAge(plan.simmed, time(), (select(3, GetBuildInfo())))
		lines[#lines + 1] = PlanTab.ageLine(plan.simmed, days, old)
	end
	if not plan then
		-- Said, never filled from the raid plan: a key and a raid boss want
		-- different gear, and a silent fallback reads like an answer.
		lines[#lines + 1] = { text = ("%s   No %s gear plan yet. Run a Raidbots Top Gear sim %s,|r"):format(
			GREY, SCENARIO_LABEL[picked.scenario],
			picked.scenario == "mplus" and "with the DungeonSlice fight style" or ("on " .. SCENARIO_LABEL[picked.scenario])) }
		lines[#lines + 1] = { text = GREY .. "   then: .\\update-gear-plan.ps1 <report link> -Deploy|r" }
		return lines
	elseif not worn then
		lines[#lines + 1] = { text = GREY .. "   Your gear cannot be read right now. Open this again out of combat.|r" }
		return lines
	end

	local marks, slotIDs, inBags = slotStates(plan, worn), {}, {}
	for slotID in pairs(marks) do slotIDs[#slotIDs + 1] = slotID end
	table.sort(slotIDs)
	for _, slotID in ipairs(slotIDs) do
		local mark = marks[slotID]
		local _, link = C_Item.GetItemInfo(mark.entry.id)
		-- Not `state == "change" and PlanTab.holding(...)`: an `and` keeps only the
		-- first of a call's returns, and that is how 0.17.5 drew no Equip at all.
		local where
		if mark.state == "change" then
			local _, _, w = PlanTab.holding(mark.entry)
			where = w
		end
		local canEquip = where ~= nil
		if canEquip then inBags[#inBags + 1] = slotID end
		lines[#lines + 1] = {
			text = ("   %s%s:|r %s"):format(WHITE, PLAN_SLOT_LABEL[slotID] or "?",
				(planLineFor(mark):gsub("^Plan: ", ""))),
			link = mark.state == "change" and link or nil,
			button = canEquip and { label = "Equip", tip = ("Equip the copy in %s into this slot."):format(where == "bank" and "the open bank" or "your bags"),
				onClick = function() PlanTab.equip(mark.entry, slotID) end } or nil,
		}
	end
	if #inBags > 0 then
		lines[#lines + 1] = { text = ("   %s%d of these can go on from here.|r"):format(GREY, #inBags),
			button = { label = "Equip all", tip = "Equip every planned piece in your bags, and in the bank while it is open.",
				onClick = function()
					for _, slotID in ipairs(inBags) do PlanTab.equip(marks[slotID].entry, slotID) end
					-- Not now: the pickups above are in flight, and the slots read
					-- stale until the server answers (card 0012).
					if C_Timer then C_Timer.After(2, function() PlanTab.saveSetAndSay(spec, picked.scenario) end) end
				end } }
	end
	-- Every planned PIECE on, whatever its enchants and gems, is enough for a
	-- set, and the button is how a set gets saved when Equip all's timer read
	-- the slots too early, or when nothing was left to equip.
	if #PlanTab.missingSlots(plan, worn) == 0 then
		lines[#lines + 1] = { text = #slotIDs == 0 and (GREEN .. "   Every slot matches the plan.|r") or (GREY .. "   Every planned piece is on.|r"),
			button = { label = "Save set", tip = ("Save what you are wearing as the equipment set \"%s\"."):format(PlanTab.setName(spec, picked.scenario)),
				onClick = function() PlanTab.saveSetAndSay(spec, picked.scenario) end } }
	end

	lines[#lines + 1] = { text = "" }
	lines[#lines + 1] = { text = GOLD .. "3. To buy|r" }
	local list, unworn, better = PlanTab.shoppingList(plan, worn)
	local function nameOf(kind, id) return PlanTab.rankName(kind, id) end
	local function searchRows(items, colour)
		local texts, total, unpriced = PlanTab.pricedLines(items, nameOf)
		for i, text in ipairs(texts) do
			local term = items[i] and PlanTab.searchTerm(items[i].kind, items[i].id)
			lines[#lines + 1] = { text = "   " .. colour .. text .. "|r",
				button = term and { label = "Search AH", tip = "Search the auction house for \"" .. term .. "\". The house must be open.",
					onClick = function() PlanTab.searchAH(term) end } or nil }
		end
		return total, unpriced
	end
	local total, unpriced = searchRows(list, #list == 0 and GREEN or WHITE)
	-- Only with Auctionator loaded (total is nil without it) and something to buy.
	if total and #list > 0 then
		lines[#lines + 1] = { text = ("   %sTotal %s%s|r"):format(GREY, PlanTab.gold(total),
				unpriced > 0 and (", " .. unpriced .. " without an Auctionator price yet") or ""),
			-- "Auctionator", not "Send to Auctionator": the action button is ILVL_WIDTH wide.
			button = { label = "Auctionator", tip = ("Send to Auctionator: make or replace its \"%s\" shopping list with everything above."):format(PlanTab.AUCTIONATOR_LIST),
				onClick = function() PlanTab.sendToAuctionator(list) end } }
	end
	if #better > 0 then
		lines[#lines + 1] = { text = GREY .. "   Higher ranks exist, if you want to spend on them:|r" }
		searchRows(better, GREY)
	end
	if unworn > 0 then
		lines[#lines + 1] = { text = ("%s   %d planned piece%s not worn yet, so %s enchants and gems are not counted.|r"):format(
			GREY, unworn, unworn == 1 and " is" or "s are", unworn == 1 and "its" or "their") }
	end
	return lines
end

-- Returns the refresh function. `holder` is the character pane's frame and
-- `below` is what the strip sits under.
local function buildSlotMarks(holder, below)
	local strip = CreateFrame("Frame", nil, holder, "BackdropTemplate")
	strip:SetPoint("TOPLEFT", below, "BOTTOMLEFT", 0, -4)
	strip:SetPoint("TOPRIGHT", below, "BOTTOMRIGHT", 0, -4)
	strip:SetHeight(PLAN_STRIP_H - 4)
	strip:SetBackdrop(PANE_BACKDROP)
	strip:SetBackdropColor(0.05, 0.05, 0.05, 0.85)
	strip:SetBackdropBorderColor(paneBorderColour())

	strip.scenario = CreateFrame("Button", nil, strip, "UIPanelButtonTemplate")
	strip.scenario:SetSize(80, 18)
	strip.scenario:SetPoint("RIGHT", -8, 0)

	strip.text = strip:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	strip.text:SetPoint("LEFT", 12, 0)
	strip.text:SetPoint("RIGHT", strip.scenario, "LEFT", -6, 0)
	strip.text:SetJustifyH("LEFT")

	local glows, marks, dirty = {}, {}, false

	local function glowFor(button)
		if glows[button] then return glows[button] end
		-- A frame of our own on top of the button, not a texture on Blizzard's:
		-- it takes no mouse, so the slot underneath clicks and drags as before.
		local glow = CreateFrame("Frame", nil, button)
		glow:SetAllPoints()
		glow.ring = glow:CreateTexture(nil, "OVERLAY")
		glow.ring:SetAllPoints()
		glow.ring:SetAtlas("bags-glow-white")
		glow.ring:SetBlendMode("ADD")
		glow.label = glow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		glow.label:SetPoint("BOTTOM", 0, 2)
		glows[button] = glow

		-- An empty slot shows no item tooltip, so the tooltip post-call never
		-- runs for it and the line is added here instead.
		-- ponytail: the sheet redraws that tooltip a few times a second and the
		-- line goes with it. Add it on the redraw too if an empty slot matters.
		button:HookScript("OnEnter", function(self)
			local mark = not InCombatLockdown() and marks[self:GetID()]
			if mark and not GetInventoryItemLink("player", self:GetID()) then
				GameTooltip:AddLine(GOLD .. planLineFor(mark) .. "|r")
				GameTooltip:Show()
			end
		end)
		return glow
	end

	local function refresh()
		-- Nothing on screen changes in combat. The marks that were up stay up,
		-- and PLAYER_REGEN_ENABLED runs this again.
		if InCombatLockdown() then dirty = true return end
		dirty = false

		local spec = playerSpec()
		local scenario = spec and planScenario(spec)
		local plan = spec and gearPlanFor(spec, scenario)
		strip.scenario:SetText(SCENARIO_LABEL[scenario or "st"])
		strip.scenario:SetEnabled(autoContext() ~= "mplus")  -- in a dungeon there is nothing to cycle

		-- A secret link cannot be matched, and reading it as a bare slot would
		-- paint the whole sheet red. Leave everything as it was.
		local worn = {}
		if plan then
			worn = readWorn()
			if not worn then return end
		end

		marks = slotStates(plan, worn)
		local count = 0
		for slotID, name in pairs(SLOT_BUTTONS) do
			local button, mark = _G[name], marks[slotID]
			if button and mark then
				count = count + 1
				local glow = glowFor(button)
				glow.ring:SetVertexColor(unpack(MARK_COLOUR[mark.state]))
				glow.label:SetText(MARK_LABEL[mark.state])
				glow:Show()
			elseif button and glows[button] then
				glows[button]:Hide()
			end
		end

		if not spec then
			strip.text:SetText(GREY .. "Gear plan: no spec.|r")
		elseif not plan then
			strip.text:SetText(("%sNo %s gear plan for %s yet. Click for how.|r"):format(GREY, SCENARIO_LABEL[scenario], spec))
		elseif count == 0 then
			strip.text:SetText(("%sGear plan:|r %severy slot matches|r"):format(GOLD, GREEN))
		else
			strip.text:SetText(("%sGear plan:|r %s%d slot%s to fix.|r %sClick for the list.|r"):format(
				GOLD, WHITE, count, count == 1 and "" or "s", GREY))
		end
	end

	-- "7 slots to fix" on its own says nothing about which or how (Rob,
	-- 2026-09-21). The list lives in the Plan tab, and this opens it.
	strip:EnableMouse(true)
	strip:SetScript("OnMouseUp", function()
		local spec = playerSpec()
		PlanTab.open(spec and planScenario(spec))
	end)

	strip.scenario:SetScript("OnClick", function()
		local spec = playerSpec()
		if not spec then return end
		local saved = db()
		local next = PlanTab.nextScenario(planScenario(spec), autoContext())
		if next == planScenario(spec) then return end  -- nowhere to go, so write nothing
		saved.statContext = next == "mplus" and "mplus" or "raid"
		if next ~= "mplus" then
			saved.planScenario = saved.planScenario or {}
			saved.planScenario[spec] = next
		end
		refresh()
		rebuildBagWanted()
		for _, pane in ipairs(statPanes) do
			if pane:IsShown() then pane:Update() end  -- the stat targets follow the same switch
		end
	end)

	addPlanLine = function(tooltip, owner)
		-- Not in combat: the marks are held still there and can be stale, and the
		-- card's rule is that nothing of ours changes a frame until combat ends.
		if not owner or not glows[owner] or InCombatLockdown() then return end
		local mark = marks[owner:GetID()]
		if mark then tooltip:AddLine(GOLD .. planLineFor(mark) .. "|r") end
	end

	-- Handler first, then one event at a time, each verified: see the watcher
	-- below and C:\Dev\WoWAddons\docs\DECISIONS.md.
	local watcher = CreateFrame("Frame")
	watcher:SetScript("OnEvent", function(_, event)
		if event == "PLAYER_REGEN_ENABLED" and not dirty then return end
		if CharacterFrame:IsShown() or dirty then refresh() end
	end)
	for _, event in ipairs({
		"PLAYER_EQUIPMENT_CHANGED",
		"PLAYER_SPECIALIZATION_CHANGED",
		"PLAYER_REGEN_ENABLED",
	}) do
		watcher:RegisterEvent(event)
		if not watcher:IsEventRegistered(event) then
			print(GOLD .. "Djinni's BiS|r " .. GREY
				.. "could not register " .. event
				.. ", so the slot marks will not refresh by themselves. Reopen the sheet to update.|r")
		end
	end

	return refresh
end

local function buildCharacterPane()
	if not CharacterFrame then return end

	local holder = CreateFrame("Frame", "DjinnisBiSCharacterPane", CharacterFrame)
	holder:SetWidth(PANE_W)
	holder:SetFrameStrata("HIGH")

	local pane = buildStatPane(holder, {
		spec = playerSpec,
		framed = true,
		onResize = function(self) holder:SetHeight(self:GetHeight() + PLAN_STRIP_H) end,
	})
	local refreshMarks = buildSlotMarks(holder, pane)
	pane:SetPoint("TOPLEFT")
	pane:SetPoint("TOPRIGHT")
	holder:SetHeight(pane:GetHeight() + PLAN_STRIP_H)

	-- Re-anchored on every open, because the sheet is not always the same width:
	-- panels can be collapsed, and a sheet that was narrow last time it was open
	-- would leave this pane sitting in a gap. The POINT is to a frame every
	-- time, so between opens the pane is dragged around by the sheet for free.
	local function place()
		local widest, right = widestSheetFrame()
		holder:ClearAllPoints()

		-- No room on that side of the screen, so it goes on the other one.
		-- Anchored to CharacterFrame rather than to the widest frame, because
		-- nothing widens a sheet leftwards and its own left edge is the honest
		-- one to sit beside.
		local screenRight = UIParent:GetRight() or 0
		if right + PANE_W + 6 > screenRight then
			holder:SetPoint("TOPRIGHT", CharacterFrame, "TOPLEFT", -6, 0)
			return
		end

		-- Line the top up with the sheet, not with whatever happened to be the
		-- widest piece of it, which can start well below the title bar.
		local drop = (widest:GetTop() or 0) - (CharacterFrame:GetTop() or 0)
		holder:SetPoint("TOPLEFT", widest, "TOPRIGHT", 6, drop)
	end

	-- Follow the sheet rather than tracking its show and hide separately, so
	-- there is no state to get out of step.
	CharacterFrame:HookScript("OnShow", function()
		place()
		holder:Show()
		pane:Update()
		refreshMarks()
		-- And again once this frame's OnShow handlers have all run. A sheet
		-- replacement lays its panels out in its own OnShow, and hook order is
		-- not ours to assume, so the first measurement can be of a sheet that
		-- has not finished widening yet.
		if C_Timer then C_Timer.After(0, place) end
	end)
	CharacterFrame:HookScript("OnHide", function() holder:Hide() end)

	-- The pane follows a drag on its own now, because it is anchored to a frame.
	-- These are for the one thing an anchor cannot do: decide which SIDE of the
	-- sheet to be on, which only changes when the sheet is near the edge of the
	-- screen.
	CharacterFrame:HookScript("OnSizeChanged", place)

	-- Hooking OnDragStop is not enough and that is why swapping sides only
	-- worked on a window resize. CharacterFrame is not movable in Blizzard's own
	-- UI, so whatever is dragging it here is another addon, and that addon
	-- starts and stops the move by calling the frame's own methods rather than
	-- through CharacterFrame's drag scripts. Hooking the METHOD catches any
	-- addon that moves it the ordinary way; the script hook stays for one that
	-- moves it the other way.
	CharacterFrame:HookScript("OnDragStop", place)
	if hooksecurefunc then
		hooksecurefunc(CharacterFrame, "StopMovingOrSizing", place)
	end
	-- This runs while the sheet is already open, one frame after it opened, so
	-- that open's OnShow has already been and gone and will not do this for us.
	if CharacterFrame:IsShown() then
		place()
		holder:Show()
		pane:Update()
		refreshMarks()
	else
		holder:Hide()
	end

	-- Gear changes and a respec both move every number on this pane.
	--
	-- Handler first, then one event at a time, each verified. 12.1 can refuse a
	-- registration SILENTLY: pcall does not see it, so an addon that registered
	-- four events in a row and asked nothing would sit waiting forever for one
	-- that never arrives. See C:\Dev\WoWAddons\docs\DECISIONS.md.
	local watcher = CreateFrame("Frame")
	watcher:SetScript("OnEvent", function()
		-- Never in combat. COMBAT_RATING_UPDATE fires on every proc, ratingOf
		-- cannot refill until combat ends, and an emptied cache blanks the pane
		-- and every tooltip for the whole fight with a good reading thrown away.
		if not InCombatLockdown() then wipe(ratingCache) end
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

-- Built on the first frame AFTER the sheet is first opened, not at login.
--
-- The pane takes its width and its border colour from the sheet it sits beside,
-- and a sheet replacement builds the panels those are read from when the sheet
-- is first opened, in its own OnShow. At login there is nothing there to read,
-- so the pane would take the fallback and keep it for the whole session. One
-- frame later there is, and by then hook order does not matter either.
local function armCharacterPane()
	if not CharacterFrame then return end
	local armed = false
	CharacterFrame:HookScript("OnShow", function()
		if armed then return end
		armed = true
		if C_Timer then
			C_Timer.After(0, function() pcall(buildCharacterPane) end)
		else
			pcall(buildCharacterPane)
		end
	end)
end

-- The rating cache is filled here, not by whoever first asks: the pane is built
-- on the first sheet open, and if that is in combat nobody has ever asked.
-- Handler first, then the event, then verified, per DECISIONS.md.
local function armRatingCache()
	local function warm()
		if InCombatLockdown() then return end
		for _, stat in ipairs(STATS) do ratingOf(stat) end
		for _, pane in ipairs(statPanes) do
			if pane:IsShown() then pane:Update() end
		end
	end
	local watcher = CreateFrame("Frame")
	watcher:SetScript("OnEvent", warm)
	watcher:RegisterEvent("PLAYER_REGEN_ENABLED")
	if not watcher:IsEventRegistered("PLAYER_REGEN_ENABLED") then
		print(GOLD .. "Djinni's BiS|r " .. GREY
			.. "could not register PLAYER_REGEN_ENABLED, so stat bars first opened in combat stay hidden until the sheet is reopened.|r")
	end
	warm()
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
-- Blizzard's own typo, RECIEVED. The journal streams loot in after the request,
-- so a harvest that ran too early gets thrown away and retried on next open.
loader:RegisterEvent("EJ_LOOT_DATA_RECIEVED")
loader:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" then
		buildBroker()
		pcall(armCharacterPane)
		pcall(armBagMarks)
		pcall(armRatingCache)
		pcall(PlanTab.armSimc)  -- Simulationcraft loads after this addon (S after D) and is not load-on-demand, so it is here by login
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
	check("bar, empty", barX(0, 1000, BAR_W), 0)
	check("bar, on target leaves headroom", barX(1000, 1000, BAR_W) < BAR_W, true)
	check("bar, on target is most of the bar", barX(1000, 1000, BAR_W) > BAR_W * 0.6, true)
	check("bar, far over is clamped", barX(99999, 1000, BAR_W), BAR_W)
	check("bar, climbs with the rating",
		barX(900, 1000, BAR_W) > barX(500, 1000, BAR_W), true)
	check("bar, no target", barX(500, 0, BAR_W), 0)
	-- the bar is sized off the pane now, and the pane is sized off Chonky's
	-- sections when they are there, so the maths has to hold at any width
	check("bar, narrow pane still clamps", barX(99999, 1000, 120), 120)

	-- Which worn piece a drop replaces. An empty slot wins on a total of zero,
	-- which is right for a bare ring finger and wrong the moment a slot that
	-- cannot be used is in the list, so both are asked.
	local strong = { crit = 100, haste = 100, mastery = 100, versatility = 100 }
	local weak   = { crit = 10,  haste = 10,  mastery = 10,  versatility = 10 }
	check("replaces the weaker of two",
		weakestOf({ { link = "A", stats = strong }, { link = "B", stats = weak } }).link, "B")
	check("order does not decide it",
		weakestOf({ { link = "B", stats = weak }, { link = "A", stats = strong } }).link, "B")
	check("an empty slot beats any worn piece",
		weakestOf({ { link = "A", stats = strong }, { link = nil, stats = ZERO_STATS } }).link, nil)
	check("one candidate is the answer",
		weakestOf({ { link = "A", stats = strong } }).link, "A")
	check("nothing to compare against", weakestOf({}), nil)

	-- Gear plan. The block is generated, so what is asked of it is its shape:
	-- a cell that names a spec or a slot the addon does not know would be
	-- skipped by everything that draws it, without an error.
	for spec, byScenario in pairs(GEAR_PLAN) do
		if not BIS[spec] then
			failed = failed + 1
			print("|cffff0000FAIL|r gear plan block holds a slot table per spec and scenario: unknown spec '" .. tostring(spec) .. "'")
		end
		for scenario, cell in pairs(byScenario) do
			local where = "gear plan block holds a slot table per spec and scenario: " .. spec .. " " .. scenario
			check(where .. ", scenario is st, 2t or mplus", scenario == "st" or scenario == "2t" or scenario == "mplus", true)
			check(where .. ", has a talent string", type(cell.talents) == "string" and cell.talents ~= "", true)
			local plan = gearPlanFor(spec, scenario)
			local count = 0
			for slot in pairs(cell.slots) do
				count = count + 1
				local entry = plan.slots[slot]
				check(where .. ", " .. slot .. " is a slot", PLAN_SLOT_INVENTORY[slot] ~= nil, true)
				check(where .. ", " .. slot .. " has an id and a level",
					entry ~= nil and entry.id ~= nil and entry.ilvl ~= nil, true)
			end
			check(where .. ", is a whole set", count >= 14, true)
		end
	end
	check("gear plan, a cell nobody filled is nil", gearPlanFor("Feral", "no such scenario"), nil)

	local entry = parsePlanLine("id=251093,enchant_id=7967,gem_id=240894/240908,bonus_id=13440/6652,ilevel=276")
	local lineTest = "plan parses enchant and gem ids from a simc gear line"
	check(lineTest .. ", enchant", entry.enchant, 7967)
	check(lineTest .. ", first gem", entry.gems[1], 240894)
	check(lineTest .. ", second gem", entry.gems[2], 240908)
	check(lineTest .. ", gem count", #entry.gems, 2)
	check(lineTest .. ", enchant is a number", type(entry.enchant), "number")
	check(lineTest .. ", bonus ids are not gems", entry.bonus[2], 6652)
	check(lineTest .. ", no enchant is nil", parsePlanLine("id=1,ilevel=300").enchant, nil)
	check(lineTest .. ", no gem is an empty list", #parsePlanLine("id=1,ilevel=300").gems, 0)
	check(lineTest .. ", no id is no entry", parsePlanLine("enchant_id=7967"), nil)

	local matchTest = "plan match compares item id and item level"
	check(matchTest .. ", same both", planMatches(entry, 251093, 276), true)
	check(matchTest .. ", same id on a lower track", planMatches(entry, 251093, 263), false)
	check(matchTest .. ", same level, other item", planMatches(entry, 251194, 276), false)
	check(matchTest .. ", level not cached yet", planMatches(entry, 251093, nil), false)
	check(matchTest .. ", empty slot", planMatchesLink(entry, nil), false)
	check(matchTest .. ", no plan entry", planMatches(nil, 251093, 276), false)

	local pairTest = "paired slots match in either order"
	local ringA, ringB = parsePlanLine("id=1,ilevel=300"), parsePlanLine("id=2,ilevel=310")
	local wornA, wornB = { id = 1, ilvl = 300 }, { id = 2, ilvl = 310 }
	check(pairTest .. ", as planned", planPairMatches(ringA, ringB, wornA, wornB), true)
	check(pairTest .. ", swapped", planPairMatches(ringA, ringB, wornB, wornA), true)
	check(pairTest .. ", one wrong", planPairMatches(ringA, ringB, wornA, { id = 3, ilvl = 310 }), false)
	check(pairTest .. ", one finger bare", planPairMatches(ringA, ringB, wornA, nil), false)
	check(pairTest .. ", the same ring twice is not the pair", planPairMatches(ringA, ringB, wornA, wornA), false)
	for _, pair in ipairs(PLAN_PAIRS) do
		check(pairTest .. ", " .. pair[1] .. " is a slot", PLAN_SLOT_INVENTORY[pair[1]] ~= nil, true)
		check(pairTest .. ", " .. pair[2] .. " is a slot", PLAN_SLOT_INVENTORY[pair[2]] ~= nil, true)
	end

	-- Slot marks. `full` is a plan entry with everything on it, and each check
	-- breaks one thing about what is worn.
	local full = parsePlanLine("id=251093,enchant_id=7967,gem_id=240894,bonus_id=1,ilevel=276")
	local function wornAs(link, ilvl, sockets)
		local worn = wornFromLink(link)
		worn.ilvl, worn.sockets = ilvl, sockets
		return worn
	end
	local good = "|Hitem:251093:7967:240894::::::80:103|h[Omission of Light]|h"
	check("worn link gives id, enchant and gems, id", wornFromLink(good).id, 251093)
	check("worn link gives id, enchant and gems, enchant", wornFromLink(good).enchant, 7967)
	check("worn link gives id, enchant and gems, gem", wornFromLink(good).gems[1], 240894)
	check("worn link gives id, enchant and gems, gem count", #wornFromLink(good).gems, 1)
	check("worn link gives id, enchant and gems, no link", wornFromLink(nil), nil)

	check("slot state is ok when everything matches", slotState(full, wornAs(good, 276, 1)), "ok")
	check("slot state is ok when the plan leaves the slot empty", slotState(nil, nil), "ok")
	local changeTest = "slot state is change when item differs from plan"
	check(changeTest .. ", other item",
		slotState(full, wornAs("|Hitem:251194:7967:240894::::|h[x]|h", 276, 1)), "change")
	check(changeTest .. ", lower track", slotState(full, wornAs(good, 263, 1)), "change")
	check(changeTest .. ", bare slot", slotState(full, nil), "change")
	local enchantTest = "slot state is enchant when enchant differs"
	check(enchantTest .. ", none",
		slotState(full, wornAs("|Hitem:251093::240894::::|h[x]|h", 276, 1)), "enchant")
	check(enchantTest .. ", another",
		slotState(full, wornAs("|Hitem:251093:7973:240894::::|h[x]|h", 276, 1)), "enchant")
	check(enchantTest .. ", a lower rank of it is lesser, not enchant",
		slotState(full, wornAs("|Hitem:251093:7966:240894::::|h[x]|h", 276, 1)), "lesser")
	check(enchantTest .. ", the plan wants none",
		slotState(parsePlanLine("id=251093,ilevel=276"), wornAs("|Hitem:251093:7966:::::|h[x]|h", 276, 0)), "ok")
	local gemTest = "slot state is gem when a socket differs"
	check(gemTest .. ", empty socket",
		slotState(full, wornAs("|Hitem:251093:7967:::::|h[x]|h", 276, 1)), "gem")
	check(gemTest .. ", another gem",
		slotState(full, wornAs("|Hitem:251093:7967:240908::::|h[x]|h", 276, 1)), "gem")
	check(gemTest .. ", an unplanned empty socket",
		slotState(parsePlanLine("id=251093,ilevel=276"), wornAs("|Hitem:251093::::::|h[x]|h", 276, 1)), "gem")
	-- Neither list is in order, so a match that walked them side by side turns this red.
	check(gemTest .. ", same gems in another order", (PlanTab.gemMatch({ 2, 1, 3 }, { 3, 1, 2 })), "ok")

	local locationTest = "planned item location resolves to bags bank or missing"
	check(locationTest .. ", bags", planLocation(true, 0), "bags")
	check(locationTest .. ", bags beats bank", planLocation(true, 1), "bags")
	check(locationTest .. ", bank", planLocation(false, 1), "bank")
	check(locationTest .. ", missing", planLocation(false, 0), "missing")
	check(locationTest .. ", count not known", planLocation(false, nil), "missing")

	-- /bis test runs in the game too, so the player's own choice goes back after.
	local keptScenario = db().planScenario
	db().planScenario = { Feral = "2t", Balance = "not a scenario" }
	check("saved scenario is read back", planScenario("Feral"), "2t")
	check("saved scenario nobody offers falls back to st", planScenario("Balance"), "st")
	check("saved scenario, none saved", planScenario("Resto"), "st")
	db().planScenario = keptScenario

	-- Mythic+ beside raid (card 0009). The content rule is statContext, shared
	-- with the stat pane: where you stand first, then the switch.
	local contentTest = "current content follows instance type then the switch"
	local keptInstance, keptContext = GetInstanceInfo, db().statContext
	db().planScenario = { Feral = "2t" }
	GetInstanceInfo = function() return "Somewhere", "raid" end
	db().statContext = "mplus"
	check(contentTest .. ", a raid instance beats a Mythic+ switch", planScenario("Feral"), "2t")
	GetInstanceInfo = function() return "Somewhere", "party" end
	db().statContext = "raid"
	check(contentTest .. ", a dungeon beats a Raid switch", planScenario("Feral"), "mplus")
	GetInstanceInfo = function() return "Nowhere", "none" end
	check(contentTest .. ", outside, the switch on Raid", planScenario("Feral"), "2t")
	db().statContext = "mplus"
	check(contentTest .. ", outside, the switch on Mythic+", planScenario("Feral"), "mplus")
	db().statContext = nil
	check(contentTest .. ", outside, no switch, is raid", planScenario("Feral"), "2t")
	check(contentTest .. ", the button goes 1, 2, Mythic+, round",
		PlanTab.nextScenario("st") .. PlanTab.nextScenario("2t") .. PlanTab.nextScenario("mplus"), "2tmplusst")
	check(contentTest .. ", in a raid the button goes 1, 2, 1",
		PlanTab.nextScenario("st", "raid") .. PlanTab.nextScenario("2t", "raid"), "2tst")
	check(contentTest .. ", in a dungeon the button stays on Mythic+", PlanTab.nextScenario("mplus", "mplus"), "mplus")
	-- The bag list is rebuilt from the current content and nothing else: in a
	-- dungeon with no Mythic+ cell it is empty, not the raid list.
	GetInstanceInfo = function() return "Nowhere", "none" end
	db().statContext, db().planScenario = nil, nil  -- outside, unpinned, the 1 target cell (the filled one)
	rebuildBagWanted()
	check(contentTest .. ", outside, the bags follow the raid plan", bagScenario == "st" and #bagWanted > 0, true)
	GetInstanceInfo = function() return "Somewhere", "party" end
	rebuildBagWanted()
	check(contentTest .. ", in a dungeon the bags follow the Mythic+ plan", bagScenario == "mplus" and #bagWanted > 0, true)
	local keptMplusCell = GEAR_PLAN.Feral.mplus
	GEAR_PLAN.Feral.mplus = nil
	rebuildBagWanted()
	check(contentTest .. ", in a dungeon with no Mythic+ cell the bags are empty, not the raid list", bagScenario == "mplus" and #bagWanted == 0, true)
	GEAR_PLAN.Feral.mplus = keptMplusCell
	GetInstanceInfo, db().statContext, db().planScenario = keptInstance, keptContext, keptScenario
	rebuildBagWanted()
	check(contentTest .. ", every scenario has a label", SCENARIO_LABEL.mplus ~= nil and SCENARIO_LABEL.st ~= nil, true)

	-- The Feral cell is filled (a DungeonSlice Top Gear, 2026-09-22), so the
	-- "no plan yet" wording is checked with the cell taken away for the moment.
	local mplusTest = "missing mplus plan is said, not filled from raid"
	check(mplusTest .. ", the Feral cell is filled", gearPlanFor("Feral", "mplus") ~= nil, true)
	check(mplusTest .. ", the Plan tab has a Mythic+ row", PlanTab.bossFor(PlanTab.BOSSES.Feral, nil, "mplus"), "Mythic+, any key")
	do
		local realBoss3, realCell = PlanTab.boss, GEAR_PLAN.Feral.mplus
		PlanTab.boss, GEAR_PLAN.Feral.mplus = "Mythic+, any key", nil
		check(mplusTest .. ", the cell is empty for the check", gearPlanFor("Feral", "mplus"), nil)
		local text = {}
		for i, line in ipairs(PlanTab.lines("Feral")) do text[i] = line.text end
		text = table.concat(text, "\n")
		PlanTab.boss, GEAR_PLAN.Feral.mplus = realBoss3, realCell
		check(mplusTest .. ", drawn", text:find("No Mythic+ gear plan yet", 1, true) ~= nil, true)
		check(mplusTest .. ", says which fight style", text:find("DungeonSlice", 1, true) ~= nil, true)
		check(mplusTest .. ", no raid gear listed", text:find("in the bank", 1, true) == nil and text:find("in your bags", 1, true) == nil, true)
		check("plan tab shows the current content and can switch, the Mythic+ row is picked",
			text:find("> Mythic+, any key", 1, true) ~= nil, true)
		check("plan tab shows the current content and can switch, the raid rows stay to click",
			text:find("   Nek'zali", 1, true) ~= nil, true)
	end

	check("no plan for spec marks no slots", next(slotStates(nil, {})), nil)
	local twoRings = { slots = { finger1 = ringA, finger2 = ringB } }
	check("slot states, a swapped pair marks nothing",
		next(slotStates(twoRings, { finger1 = wornB, finger2 = wornA })), nil)
	local oneWrong = slotStates(twoRings, { finger1 = { id = 3, ilvl = 1, gems = {} }, finger2 = wornA })
	check("slot states, a swapped pair with one wrong marks the wrong finger",
		oneWrong[11] and oneWrong[11].state, "change")
	check("slot states, and wants the other ring there", oneWrong[11] and oneWrong[11].entry, ringB)
	check("slot states, and leaves the right finger alone", oneWrong[12], nil)
	for slot, slotID in pairs(PLAN_SLOT_INVENTORY) do
		check("every plan slot has a button, " .. slot, SLOT_BUTTONS[slotID] ~= nil, true)
	end

	-- Ratings nobody has been able to read yet must never be drawn as 0.
	local nilTest = "a nil rating does not reach statVerdict as 0"
	local partial = { crit = 900, haste = 1200, mastery = 1000 }
	check(nilTest .. ", one stat unread", allRatings(function(stat) return partial[stat] end), nil)
	check(nilTest .. ", none read", allRatings(function() return nil end), nil)
	local whole = allRatings(function(stat) return partial[stat] or 300 end)
	check(nilTest .. ", all read", whole and whole.versatility, 300)
	check(nilTest .. ", a real zero is kept", (allRatings(function() return 0 end) or {}).crit, 0)

	-- Bag marks. The plan wants a cloak and two rings; ringA is worn, the cloak
	-- slot holds something else and one finger is bare.
	local cloak = parsePlanLine("id=193763,ilevel=311")
	local bagPlan = { slots = { back = cloak, finger1 = ringA, finger2 = ringB } }
	local bagWorn = { back = { id = 9, ilvl = 300, gems = {} }, finger1 = wornA }
	local want = wantedFrom(bagPlan, bagWorn)
	local wantedTest = "bag item is wanted when it matches an unfilled plan slot"
	check(wantedTest .. ", the cloak", wantedSlot(want, 193763, 311), 15)
	check(wantedTest .. ", the missing ring, on the bare finger", wantedSlot(want, 2, 310), 12)
	check(wantedTest .. ", an item the plan never named", wantedSlot(want, 12345, 311), nil)
	check(wantedTest .. ", no plan wants nothing", #wantedFrom(nil, {}), 0)
	local copyTest = "only the planned copy of a duplicate is wanted"
	check(copyTest .. ", lower track copy", wantedSlot(want, 193763, 298), nil)
	check(copyTest .. ", higher track copy", wantedSlot(want, 193763, 324), nil)
	check(copyTest .. ", level not cached yet", wantedSlot(want, 193763, nil), nil)
	-- The bag glows read one plan, the current content's, so a piece both
	-- plans want is one wanted piece, not two glows or two lines.
	local bothTest = "an item planned for both contents is wanted once"
	local raidPlan = { slots = { back = cloak } }
	local mplusPlan = { slots = { back = parsePlanLine("id=193763,ilevel=311") } }
	local both = wantedFrom(raidPlan, {})
	check(bothTest .. ", one plan, one want", #both, 1)
	check(bothTest .. ", the other plan wants the same piece", wantedSlot(wantedFrom(mplusPlan, {}), 193763, 311), 15)
	check(bothTest .. ", the glow list holds one plan at a time", wantedSlot(both, 193763, 311) == 15 and #both == 1, true)

	local equippedTest = "equipped planned item glows no bag copy"
	check(equippedTest .. ", a second copy of the worn ring", wantedSlot(want, 1, 300), nil)
	local enchantOnly = wantedFrom({ slots = { back = parsePlanLine("id=193763,enchant_id=5,ilevel=311") } },
		{ back = { id = 193763, ilvl = 311, gems = {} } })
	check(equippedTest .. ", worn but missing its enchant", wantedSlot(enchantOnly, 193763, 311), nil)
	local lineTest2 = "wanted bag item names its slot and scenario"
	check(lineTest2 .. ", back, one target", wantedLine(15, "st"), "Plan: equip in Back, 1 target")
	check(lineTest2 .. ", finger, two targets", wantedLine(12, "2t"), "Plan: equip in Finger, 2 targets")
	for slot, slotID in pairs(PLAN_SLOT_INVENTORY) do
		check(lineTest2 .. ", every plan slot has a label, " .. slot, PLAN_SLOT_LABEL[slotID] ~= nil, true)
	end

	-- the Plan tab (card 0007)
	local bossTest = "plan tab lists a loadout per boss for the spec"
	local planned = {}
	for _, row in ipairs(PlanTab.BOSSES.Feral) do
		planned[row.boss] = true
		check(bossTest .. ", a loadout, " .. row.boss, type(row.loadout) == "string" and row.loadout ~= "", true)
		check(bossTest .. ", a scenario with a label, " .. row.boss, SCENARIO_LABEL[row.scenario] ~= nil, true)
	end
	for _, boss in ipairs(BOSS_ORDER) do
		check(bossTest .. ", every raid boss is listed, " .. boss, planned[boss], true)
	end

	local flagTest = "loadout mismatch is flagged by name"
	check(flagTest .. ", another loadout", PlanTab.loadoutState("WS Raid 2T *", "DotC Raid ST *"), "mismatch")
	check(flagTest .. ", the same loadout", PlanTab.loadoutState("WS Raid 2T *", "WS Raid 2T *"), "match")
	check(flagTest .. ", the game will not say", PlanTab.loadoutState("WS Raid 2T *", nil), "unknown")

	-- card 0014: the right name with the talents moved by hand is the wrong build
	local editTest = "edited talents are marked"
	local sameTest = "matching talents are not marked"
	local aString = "CcGADBD3hSPCL9Y9gz68WcKvMAAAAAAwghxYmZmxsxDsMz2MzMmZGAAAAWAzGMmZwMmFmZmxYmZGAAAAAAgBAAAgZWmlZmZAALgZGgFmhBAAwMbYA"
	local bString = aString:sub(1, -2) .. "B"
	check(editTest .. ", strings differ", PlanTab.talentStringsDiffer(aString, bString), true)
	check(sameTest .. ", strings equal", PlanTab.talentStringsDiffer(aString, aString), false)
	check(editTest .. ", no active string", PlanTab.talentStringsDiffer(nil, aString), nil)
	check(editTest .. ", no saved string", PlanTab.talentStringsDiffer(aString, false), nil)
	check(editTest .. ", empty string", PlanTab.talentStringsDiffer("", aString), nil)
	check(editTest .. ", same name still mismatches", PlanTab.loadoutState("WS Raid 2T *", "WS Raid 2T *", true), "mismatch")
	check(sameTest .. ", same name matches", PlanTab.loadoutState("WS Raid 2T *", "WS Raid 2T *", false), "match")
	check(editTest .. ", no loadout is still unknown", PlanTab.loadoutState("WS Raid 2T *", nil, true), "unknown")

	-- The reader itself: the strings come from the game, so stub the two calls
	-- and prove which config ids it asks for and what it does with them.
	local combatTest = "talent string read out of combat only"
	local wasActiveID, wasGenerate = C_ClassTalents.GetActiveConfigID, C_Traits.GenerateImportString
	local wasCombat, wasLast = InCombatLockdown, PlanTab.lastEdited
	local strings = { [1] = aString, [2] = bString }
	C_ClassTalents.GetActiveConfigID = function() return 1 end
	C_Traits.GenerateImportString = function(id) return strings[id] end
	InCombatLockdown = function() return false end
	check(editTest .. ", read from the game", PlanTab.talentsEdited(2), true)
	check(sameTest .. ", read from the game", PlanTab.talentsEdited(1), false)
	check(editTest .. ", no saved loadout", PlanTab.talentsEdited(nil), nil)
	local reads = 0
	C_Traits.GenerateImportString = function(id) reads = reads + 1 return strings[id] end
	PlanTab.talentsEdited(2)
	InCombatLockdown = function() return true end
	check(combatTest .. ", holds the last reading", PlanTab.talentsEdited(1), true)
	check(combatTest .. ", reads nothing", reads, 2)
	InCombatLockdown = function() return false end
	check(combatTest .. ", reads again after", PlanTab.talentsEdited(1), false)
	check(combatTest .. ", and it was a read", reads, 4)
	C_ClassTalents.GetActiveConfigID, C_Traits.GenerateImportString = wasActiveID, wasGenerate
	InCombatLockdown, PlanTab.lastEdited = wasCombat, wasLast

	-- The /simc export (card 0018). Names are the real Feral plan's, so a plan
	-- edit that drops one of them fails here rather than in a Raidbots run.
	local simcTest = "simc export carries each planned loadout"
	local allSaved = {}
	for _, row in ipairs(PlanTab.BOSSES.Feral) do allSaved[row.loadout] = true end
	local ferals = { ["DotC Raid ST *"] = "AAAA", ["WS M+"] = "BBBB" }
	local lines, missing = PlanTab.simcLines("Feral", PlanTab.BOSSES.Feral, allSaved, ferals)
	local text = table.concat(lines, "\n")
	check(simcTest .. ", a header", lines[1]:find("Feral", 1, true) ~= nil, true)
	for _, row in ipairs(PlanTab.BOSSES.Feral) do
		check(simcTest .. ", " .. row.boss, text:find("# " .. row.boss .. " -> " .. row.loadout, 1, true) ~= nil, true)
	end
	check(simcTest .. ", nothing added when all are saved", text:find("Saved Loadout", 1, true), nil)
	check(simcTest .. ", nothing missing when all are saved", #missing, 0)
	local missTest = "a missing loadout is left out and named"
	local someSaved = {}
	for name in pairs(allSaved) do someSaved[name] = true end
	someSaved["WS Raid Coiled Altar"], someSaved["DotC Raid ST *"] = nil, nil
	lines, missing = PlanTab.simcLines("Feral", PlanTab.BOSSES.Feral, someSaved, ferals)
	text = table.concat(lines, "\n")
	check(missTest .. ", named once", table.concat(missing, ","), "WS Raid Coiled Altar")
	check(missTest .. ", no talents line for it", text:find("Coiled Altar (DBiS plan)", 1, true), nil)
	check(missTest .. ", the plan's string stands in when it has one",
		text:find("# Saved Loadout: DotC Raid ST * (DBiS plan)\n# talents=AAAA", 1, true) ~= nil, true)
	check(missTest .. ", and that one is not named as missing", text:find("Saved Loadout: DotC", 1, true) ~= nil and #missing, 1)
	lines = PlanTab.simcLines("Feral", PlanTab.BOSSES.Feral, {}, {})
	local stand = 0
	for _, line in ipairs(lines) do if line:find("^# Saved Loadout") then stand = stand + 1 end end
	check(missTest .. ", nothing saved and no plan string adds no loadout", stand, 0)
	local insTest = "simc block sits with the addon's own loadouts"
	local profile = "# head\ntalents=LIVE\n\n# Saved Loadout: A\n# talents=AAA\n# Saved Loadout: B\n# talents=BBB\n\nhead=x\n"
	check(insTest .. ", after the last saved one", PlanTab.simcInsert(profile, "# X"),
		"# head\ntalents=LIVE\n\n# Saved Loadout: A\n# talents=AAA\n# Saved Loadout: B\n# talents=BBB\n# X\n\nhead=x\n")
	check(insTest .. ", after the live talents when none are saved", PlanTab.simcInsert("# head\ntalents=LIVE\n\nhead=x\n", "# X"),
		"# head\ntalents=LIVE\n# X\n\nhead=x\n")
	check(insTest .. ", at the end when there are no talents", PlanTab.simcInsert("# head\nhead=x", "# X"), "# head\nhead=x\n# X\n")
	local hookTest = "no error without the simc addon"
	local wasSimc, wasIDs, wasInfo = _G.Simulationcraft, C_ClassTalents.GetConfigIDsBySpecID, C_Traits.GetConfigInfo
	_G.Simulationcraft = nil
	local okArm, armed = pcall(PlanTab.armSimc)
	check(hookTest .. ", no error", okArm, true)
	check(hookTest .. ", nothing armed", armed, false)
	local fake = { GetSimcProfile = function(self, a) return self.text .. tostring(a), nil end, text = profile }
	_G.Simulationcraft = fake
	C_ClassTalents.GetConfigIDsBySpecID = function() return { 1, 2 } end
	C_Traits.GetConfigInfo = function(id) return { name = ({ "WS Raid Most Bosses", "DotC Raid ST *" })[id] } end
	check(hookTest .. ", armed when present", PlanTab.armSimc(), true)
	check(hookTest .. ", armed once", PlanTab.armSimc(), false)
	local out, err = fake:GetSimcProfile("!")
	check(hookTest .. ", the addon's own text survives", out:find("# Saved Loadout: B\n# talents=BBB\n# Djinni's BiS plan (Feral)", 1, true) ~= nil, true)
	check(hookTest .. ", the arguments reach the addon", out:sub(-1), "!")
	check(hookTest .. ", saved names are read from the game", out:find("Saved Loadout: WS Raid Most Bosses (DBiS", 1, true), nil)
	check(hookTest .. ", the plan's string for an unsaved one", out:find("# Saved Loadout: WS M+ (DBiS plan)\n# talents=" .. GEAR_PLAN.Feral.mplus.talents, 1, true) ~= nil, true)
	check(hookTest .. ", no error back", err, nil)
	fake.GetSimcProfile = function() return nil, "boom" end
	fake.DjinnisBiSWrapped = nil
	PlanTab.armSimc()
	out, err = fake:GetSimcProfile()
	check(hookTest .. ", an error from the addon passes through", err, "boom")
	check(hookTest .. ", with no profile", out, nil)
	_G.Simulationcraft, C_ClassTalents.GetConfigIDsBySpecID, C_Traits.GetConfigInfo = wasSimc, wasIDs, wasInfo

	local shopTest = "shopping list counts each missing enchant and gem once"
	local shopPlan = { slots = {
		finger1 = parsePlanLine("id=1,enchant_id=7967,gem_id=50,ilevel=300"),
		finger2 = parsePlanLine("id=2,enchant_id=7967,gem_id=50/51,ilevel=300"),
		back    = parsePlanLine("id=3,enchant_id=9,ilevel=300"),
		head    = parsePlanLine("id=4,enchant_id=8,ilevel=300"),
		neck    = parsePlanLine("id=5,gem_id=60/60,ilevel=300"),
	} }
	local shop, unworn = PlanTab.shoppingList(shopPlan, {
		finger1 = { id = 1, ilvl = 300, gems = {} },
		finger2 = { id = 2, ilvl = 300, enchant = 1, gems = { 51 } },
		back    = { id = 3, ilvl = 300, enchant = 9, gems = {} },
		neck    = { id = 5, ilvl = 300, gems = { 60 } },
	})
	check(shopTest .. ", three things", #shop, 3)
	check(shopTest .. ", one worn gem covers one planned gem, not two", shop[3].count, 1)
	check(shopTest .. ", the enchant once", shop[1].kind .. shop[1].id, "enchant7967")
	check(shopTest .. ", counted on both rings", shop[1].count, 2)
	check(shopTest .. ", the gem once", shop[2].kind .. shop[2].id, "gem50")
	check(shopTest .. ", a worn gem is not bought again", shop[2].count, 2)
	check(shopTest .. ", an unworn piece is set aside", unworn, 1)
	local function plainName(kind, id) return kind .. " " .. id end
	check(shopTest .. ", by name with a count", PlanTab.shoppingLines(shop, plainName)[1], "2x enchant 7967")

	-- the three buttons (card 0008)
	local termTest = "auction search term drops the enchant rank"
	check(termTest .. ", enchant", PlanTab.searchTerm("enchant", 7967), "Eyes of the Eagle")
	check(termTest .. ", enchant nobody named", PlanTab.searchTerm("enchant", 1), nil)
	check(termTest .. ", gem not in the table and not cached", PlanTab.searchTerm("gem", 1), nil)
	-- A pretend bag with the planned ring in bag 0 slot 2, and a cursor that
	-- records what was picked up and where it went. Every global swapped here
	-- is put back, so /bis test in the game touches nothing for longer than
	-- these six lines. (0008 review: without the bag, "does nothing in combat"
	-- passed with the combat guard deleted, because there was nothing to do.)
	local ring = parsePlanLine("id=1,ilevel=300")
	local wasInCombat, wasContainer, wasIlvl = InCombatLockdown, C_Container, C_Item.GetDetailedItemLevelInfo
	local wasClear, wasHas, wasEquip = ClearCursor, CursorHasItem, PickupInventoryItem
	local wasDoll, wasLocked = C_PaperDollInfo, IsInventoryItemLocked
	local held, picked, equippedTo, slotLocked, canGo = nil, nil, nil, false, true
	C_PaperDollInfo = { CanCursorCanGoInSlot = function() return canGo end }
	IsInventoryItemLocked = function() return slotLocked end
	C_Container = {
		GetContainerNumSlots = function(bag) return bag == 0 and 2 or 0 end,
		GetContainerItemLink = function(bag, slot) return bag == 0 and slot == 2 and "|Hitem:1::::::|h[Ring]|h" or nil end,
		PickupContainerItem = function(bag, slot) picked, held = { bag, slot }, true end,
	}
	C_Item.GetDetailedItemLevelInfo = function() return 300 end
	ClearCursor = function() held = false end
	CursorHasItem = function() return held == true end
	PickupInventoryItem = function(slotID) equippedTo, held = slotID, false end
	InCombatLockdown = function() return true end
	check("equip button does nothing in combat", PlanTab.equip(ring, 11), false)
	check("equip button does nothing in combat, picks nothing up", picked, nil)
	InCombatLockdown = wasInCombat
	check("equip button does nothing when the piece is not in the bags", PlanTab.equip(parsePlanLine("id=2,ilevel=300"), 11), false)
	check("equip button does nothing when the piece is not in the bags, picks nothing up", picked, nil)
	local equipTest = "equip button picks the exact bag copy up and equips it into the planned slot"
	check(equipTest, PlanTab.equip(ring, 11), true)
	check(equipTest .. ", that bag slot", picked and picked[1] .. "," .. picked[2], "0,2")
	check(equipTest .. ", that inventory slot", equippedTo, 11)
	check(equipTest .. ", nothing left on the cursor", held, false)
	-- The tab AS DRAWN with a planned piece in the pretend bag: it has to offer
	-- Equip for that slot and Equip all under the list. At 0.17.5 it offered
	-- neither, and every check above still passed.
	do
		local neck = GEAR_PLAN.Feral.st.slots.neck:match("id=(%d+)")
		local ilvl = tonumber(GEAR_PLAN.Feral.st.slots.neck:match("ilevel=(%d+)"))
		local wasLink, wasLevel = C_Container.GetContainerItemLink, C_Item.GetDetailedItemLevelInfo
		C_Container.GetContainerItemLink = function(bag, slot)
			return bag == 0 and slot == 2 and ("|Hitem:%s::::::|h[Neck]|h"):format(neck) or nil
		end
		C_Item.GetDetailedItemLevelInfo = function() return ilvl end
		local realBoss2 = PlanTab.boss
		PlanTab.boss = "Nek'zali"  -- a 1 target boss, so the tab reads gear
		local equipRows, equipAll = 0, false
		for _, line in ipairs(PlanTab.lines("Feral")) do
			if line.button and line.button.label == "Equip" then equipRows = equipRows + 1 end
			if line.button and line.button.label == "Equip all" then equipAll = true end
		end
		PlanTab.boss = realBoss2
		C_Container.GetContainerItemLink, C_Item.GetDetailedItemLevelInfo = wasLink, wasLevel
		check("drawn tab offers Equip for the one planned piece in the bags", equipRows, 1)
		check("drawn tab offers Equip all when a planned piece is in the bags", equipAll, true)
	end
	-- the two refusals Blizzard's equipment sets make, each clearing the cursor
	equippedTo, slotLocked = nil, true
	check("equip button refuses a locked slot", PlanTab.equip(ring, 11), false)
	check("equip button refuses a locked slot, equips nothing", equippedTo, nil)
	check("equip button refuses a locked slot, nothing left on the cursor", held, false)
	slotLocked, canGo = false, false
	check("equip button refuses a slot the item cannot go in", PlanTab.equip(ring, 11), false)
	check("equip button refuses a slot the item cannot go in, nothing left on the cursor", held, false)
	InCombatLockdown, C_Container, C_Item.GetDetailedItemLevelInfo = wasInCombat, wasContainer, wasIlvl
	ClearCursor, CursorHasItem, PickupInventoryItem = wasClear, wasHas, wasEquip
	C_PaperDollInfo, IsInventoryItemLocked = wasDoll, wasLocked
	check("search button without the auction house open", PlanTab.searchAH("x"), false)

	-- equipment sets (card 0012): a pretend equipment manager that records
	-- every call, and a pretend body wearing the whole Feral 1 target plan
	do
		for _, spec in ipairs(SPEC_ORDER) do
			for scenario in pairs(SCENARIO_LABEL) do
				check("set name fits Blizzard's 16-letter name box, " .. spec .. " " .. scenario, #PlanTab.setName(spec, scenario) <= 16, true)
				check("set name starts with the prefix, " .. spec .. " " .. scenario, PlanTab.ownsSet(PlanTab.setName(spec, scenario)), true)
			end
		end
		check("a set Rob named is not ours", PlanTab.ownsSet("Tank"), false)
		check("a set with no name is not ours", PlanTab.ownsSet(nil), false)

		local plan = gearPlanFor("Feral", "st")
		local entryBySlotID, ilvlById = {}, {}
		for slot, entry in pairs(plan.slots) do
			entryBySlotID[PLAN_SLOT_INVENTORY[slot]] = entry
			ilvlById[entry.id] = entry.ilvl
		end
		local bare = nil  -- a slot id left empty, or nil for the whole plan on
		local wasWornLink, wasLevel = GetInventoryItemLink, C_Item.GetDetailedItemLevelInfo
		GetInventoryItemLink = function(_, slotID)
			local entry = slotID ~= bare and entryBySlotID[slotID]
			return entry and ("|Hitem:%d::::::|h[x]|h"):format(entry.id) or nil
		end
		C_Item.GetDetailedItemLevelInfo = function(link) return ilvlById[tonumber(link:match("item:(%d+)"))] end

		local calls, sets, ignored = {}, {}, {}
		local wasSets, wasCombat, wasMax = C_EquipmentSet, InCombatLockdown, MAX_EQUIPMENT_SETS_PER_PLAYER
		MAX_EQUIPMENT_SETS_PER_PLAYER = 10
		local function log(name) return function(...) calls[#calls + 1] = { name, ... } end end
		C_EquipmentSet = {
			CanUseEquipmentSets = function() return true end,
			ClearIgnoredSlotsForSave = function() wipe(ignored) end,
			IgnoreSlotForSave = function(slot) ignored[#ignored + 1] = slot end,
			GetEquipmentSetID = function(name) return sets[name] end,
			GetEquipmentSetInfo = function(id) for name, i in pairs(sets) do if i == id then return name, 0, id end end end,
			GetNumEquipmentSets = function() local n = 0 for _ in pairs(sets) do n = n + 1 end return n end,
			CreateEquipmentSet = log("create"),
			SaveEquipmentSet = log("save"),
			DeleteEquipmentSet = log("delete"),
			ModifyEquipmentSet = log("modify"),
		}
		local function saveCalls()
			local names = {}
			for _, c in ipairs(calls) do names[#names + 1] = c[1] end
			return table.concat(names, ",")
		end

		local saveTest = "equip all saves the plan as an equipment set"
		sets = { Tank = 1 }
		ignored[1] = 1  -- a Head tick left on the paper doll: the save must clear it, or the set ignores Head
		local ok, detail = PlanTab.saveSet("Feral", "st")
		check(saveTest, ok, true)
		check(saveTest .. ", named for the plan", detail, "DBiS Feral ST")
		check(saveTest .. ", created when no set of that name exists", saveCalls(), "create")
		check(saveTest .. ", created under that name", calls[1] and calls[1][2], "DBiS Feral ST")
		check("the set ignores shirt and tabard", table.concat(ignored, ","), "4,19")

		wipe(calls)
		sets = { Tank = 1, ["DBiS Feral ST"] = 2 }
		ok = PlanTab.saveSet("Feral", "st")
		check(saveTest .. ", updated when the set exists", ok and saveCalls(), "save")
		check(saveTest .. ", updated into the set of that name", calls[1] and calls[1][2], 2)

		local ownTest = "sets Rob made are never touched"
		wipe(calls)
		sets = { Tank = 1 }
		local realID = C_EquipmentSet.GetEquipmentSetID
		C_EquipmentSet.GetEquipmentSetID = function() return 1 end  -- the manager answers with Rob's set
		ok, detail = PlanTab.saveSet("Feral", "st")
		C_EquipmentSet.GetEquipmentSetID = realID
		check(ownTest, ok, false)
		check(ownTest .. ", says why", detail, "set 1 is not ours")
		check(ownTest .. ", no call reached the manager", saveCalls(), "")

		wipe(calls)
		bare = 1  -- head off
		ok, detail = PlanTab.saveSet("Feral", "st")
		check("no set is saved from a half-worn plan", ok, false)
		check("no set is saved from a half-worn plan, says which slot", detail, "not worn: Head")
		check("no set is saved from a half-worn plan, no call reached the manager", saveCalls(), "")
		bare = nil

		wipe(calls)
		InCombatLockdown = function() return true end
		ok, detail = PlanTab.saveSet("Feral", "st")
		InCombatLockdown = wasCombat
		check("no set is saved in combat", ok, false)
		check("no set is saved in combat, says why", detail, "not in combat")
		check("no set is saved in combat, no call reached the manager", saveCalls(), "")

		wipe(calls)
		sets = { a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7, h = 8, i = 9, j = 10 }
		ok, detail = PlanTab.saveSet("Feral", "st")
		check("no set is created past Blizzard's ten", ok, false)
		check("no set is created past Blizzard's ten, no call reached the manager", saveCalls(), "")

		-- the tab AS DRAWN with the whole plan on: it offers Save set
		sets = {}
		local realBoss4 = PlanTab.boss
		PlanTab.boss = "Nek'zali"
		local saveRow
		for _, line in ipairs(PlanTab.lines("Feral")) do
			if line.button and line.button.label == "Save set" then saveRow = line end
		end
		PlanTab.boss = realBoss4
		check("drawn tab offers Save set when every planned piece is on", saveRow ~= nil, true)
		check("drawn tab offers Save set when every planned piece is on, names the set", saveRow and saveRow.button.tip:find("DBiS Feral ST", 1, true) ~= nil, true)
		-- and withholds it with a piece off: a set saved then would be the wrong gear
		bare, saveRow = 1, nil
		PlanTab.boss = "Nek'zali"
		for _, line in ipairs(PlanTab.lines("Feral")) do
			if line.button and line.button.label == "Save set" then saveRow = line end
		end
		PlanTab.boss = realBoss4
		bare = nil
		check("drawn tab withholds Save set when a planned piece is off", saveRow == nil, true)

		C_EquipmentSet, MAX_EQUIPMENT_SETS_PER_PLAYER = wasSets, wasMax
		GetInventoryItemLink, C_Item.GetDetailedItemLevelInfo = wasWornLink, wasLevel
	end

	-- The Talents button (card 0011): Blizzard's ClassTalentHelper, never a
	-- C_ClassTalents or C_Traits call that writes. Two saved loadouts are
	-- pretended, the helper and the window record what they were asked, and
	-- every C_ClassTalents / C_Traits key the button touches is recorded, so a
	-- LoadConfig or CommitConfig call from our own code goes red.
	do
		local wasHelper, wasUtil, wasTalents, wasTraits, wasPrint, wasCombat = ClassTalentHelper, PlayerSpellsUtil, C_ClassTalents, C_Traits, print, InCombatLockdown
		local asked, opened, printed, touched = nil, 0, {}, {}
		ClassTalentHelper = { SwitchToLoadoutByName = function(name) asked = name end }
		PlayerSpellsUtil = { OpenToClassTalentsTab = function() opened = opened + 1 end }
		local reads = {
			GetConfigIDsBySpecID = function() return { 1, 2 } end,
			GetConfigInfo = function(id) return { name = ({ "WS Raid 2T *", "DotC Raid ST *" })[id] } end,
		}
		-- an unknown key answers a function that does nothing, so a write call
		-- from our code is reported by the "reads only" check, not by a crash
		local function watched() return setmetatable({}, { __index = function(_, k) touched[k] = true return reads[k] or function() end end }) end
		C_ClassTalents, C_Traits = watched(), watched()
		-- check() reports through print too, so a FAIL line goes to the real
		-- one: with it captured, five red checks here read as a pass (0011 build)
		print = function(...)
			local line = tostring((...))
			if line:find("|cffff0000FAIL|r", 1, true) then wasPrint(...) else printed[#printed + 1] = line end
		end
		InCombatLockdown = function() return true end
		check("talents button does nothing in combat", PlanTab.loadTalents("WS Raid 2T *"), "combat")
		InCombatLockdown = wasCombat
		check("talents button does nothing in combat, asks nothing", asked, nil)
		check("talents button does nothing in combat, opens nothing", opened, 0)
		local missTest = "talents button falls back when the loadout is missing"
		check(missTest, PlanTab.loadTalents("Not Saved"), "missing")
		check(missTest .. ", opens the window", opened, 1)
		check(missTest .. ", asks nothing", asked, nil)
		check(missTest .. ", names the missing loadout", printed[1] and printed[1]:find("\"Not Saved\"", 1, true) ~= nil, true)
		check(missTest .. ", in one line", #printed, 1)
		local loadTest = "talents button loads a saved loadout through ClassTalentHelper"
		check(loadTest, PlanTab.loadTalents("WS Raid 2T *"), "loaded")
		check(loadTest .. ", by name", asked, "WS Raid 2T *")
		check(loadTest .. ", without opening the window", opened, 1)
		local keys = {}
		for k in pairs(touched) do keys[#keys + 1] = k end
		table.sort(keys)
		check("no talent-changing call in the file, the button reads only", table.concat(keys, ","), "GetConfigIDsBySpecID,GetConfigInfo")
		-- the two events: nothing said for a landing, one line for a refusal
		printed = {}
		PlanTab.onTalentEvent("TRAIT_CONFIG_UPDATED")
		check("a loadout landing says nothing", #printed, 0)
		PlanTab.onTalentEvent("CONFIG_COMMIT_FAILED")
		check("a refused talent commit says so in one line", #printed, 1)
		-- the tab AS DRAWN: the button carries the picked boss's loadout
		local realBoss = PlanTab.boss
		PlanTab.boss = "The Twin Fangs"
		asked = nil
		for _, line in ipairs(PlanTab.lines("Feral")) do
			if line.button and line.button.label == "Talents" then line.button.onClick() end
		end
		PlanTab.boss = realBoss
		check("drawn Talents button loads the picked boss's loadout", asked, "WS Raid 2T *")
		ClassTalentHelper, PlayerSpellsUtil, C_ClassTalents, C_Traits, print, InCombatLockdown = wasHelper, wasUtil, wasTalents, wasTraits, wasPrint, wasCombat
	end

	-- ranks: a lower rank of the right enchant or gem is "lesser", never wrong
	do
		local rankTest = "a lower rank of the planned gem or enchant is lesser, not wrong"
		check(rankTest .. ", gem rank 2 of 4 for rank 4", PlanTab.rankState("gem", 240908, 240907), "lesser")
		check(rankTest .. ", gem rank 4 for rank 2 is fine", PlanTab.rankState("gem", 240907, 240908), "ok")
		check(rankTest .. ", the same gem", PlanTab.rankState("gem", 240908, 240908), "ok")
		check(rankTest .. ", another family", PlanTab.rankState("gem", 240908, 240894), "wrong")
		check(rankTest .. ", an id the table never saw", PlanTab.rankState("gem", 240908, 1), "wrong")
		check(rankTest .. ", enchant rank 1 for rank 2", PlanTab.rankState("enchant", 7967, 7966), "lesser")
		check(rankTest .. ", no enchant at all", PlanTab.rankState("enchant", 7967, nil), "wrong")
		local twin = parsePlanLine("id=7,enchant_id=7967,gem_id=240908,ilevel=300")
		check(rankTest .. ", the slot reads lesser",
			slotState(twin, { id = 7, ilvl = 300, sockets = 1, enchant = 7966, gems = { 240907 } }), "lesser")
		check(rankTest .. ", a wrong gem beats a lesser enchant",
			slotState(twin, { id = 7, ilvl = 300, sockets = 1, enchant = 7966, gems = { 240894 } }), "gem")
		local buy, _, upgrades = PlanTab.shoppingList({ slots = { wrist = twin } },
			{ wrist = { id = 7, ilvl = 300, enchant = 7966, gems = { 240907 } } })
		check(rankTest .. ", nothing to buy", #buy, 0)
		check(rankTest .. ", two upgrades offered", #upgrades, 2)
		check(rankTest .. ", the upgrade is the planned rank", upgrades[2].id, 240908)
		-- Rank 3, not 2: the rare at 278 outstats the uncommon at 295 (0010 review).
		check(rankTest .. ", named with its rank", PlanTab.rankName("gem", 240907), "Masterful Garnet (rank 3 of 4)")
		check(rankTest .. ", the rare at a lower item level outranks the uncommon above it", PlanTab.rankState("gem", 240876, 240907), "ok")
		check(rankTest .. ", search term is the family", PlanTab.searchTerm("gem", 240907), "Masterful Garnet")
		local worn = { id = 7, ilvl = 300, enchant = 7966, gems = { 240907 } }
		check(rankTest .. ", the line says fine", planLineFor({ state = "lesser", entry = twin, worn = worn }):find("^Plan: fine%.") ~= nil, true)
		check("two planned gems of one family, one worn, wants one more",
			#select(2, PlanTab.gemMatch({ 240908, 240908 }, { 240907 })), 1)
		-- A missing gem beside a lesser one is "gem": swapping that order passed
		-- every check above (0010 review).
		check("two planned gems of one family, one worn, wants one more, and reads gem not lesser",
			(PlanTab.gemMatch({ 240908, 240908 }, { 240907 })), "gem")
		-- The tab AS DRAWN with the planned wrist worn at a lower gem rank: the
		-- planned rank sits under "Higher ranks exist" with Search AH, and "To
		-- buy" says nothing. Deleting either drawn row passed every check above.
		local wasWornLink, wasLevel, wasBoss = GetInventoryItemLink, C_Item.GetDetailedItemLevelInfo, PlanTab.boss
		GetInventoryItemLink = function(_, slotID) return slotID == 9 and "|Hitem:251135::240907::::|h[x]|h" or nil end
		C_Item.GetDetailedItemLevelInfo = function() return 318 end
		PlanTab.boss = "Nek'zali"
		local rows, header, upgrade = PlanTab.lines("Feral"), nil, nil
		for i, line in ipairs(rows) do
			if line.text:find("Higher ranks exist", 1, true) then header, upgrade = i, rows[i + 1] end
		end
		GetInventoryItemLink, C_Item.GetDetailedItemLevelInfo, PlanTab.boss = wasWornLink, wasLevel, wasBoss
		check(rankTest .. ", drawn under Higher ranks exist", header ~= nil, true)
		check(rankTest .. ", drawn as the planned rank", upgrade and upgrade.text:find("1x Masterful Garnet (rank 4 of 4)", 1, true) ~= nil, true)
		check(rankTest .. ", drawn with Search AH", upgrade and upgrade.button and upgrade.button.label, "Search AH")
		check(rankTest .. ", drawn with nothing to buy", header and rows[header - 1].text:find("Nothing to buy", 1, true) ~= nil, true)
		check(rankTest .. ", drawn wrist line says fine", table.concat((function() local t = {} for i, l in ipairs(rows) do t[i] = l.text end return t end)(), "\n"):find("Wrist:|r fine.", 1, true) ~= nil, true)
	end

	local emptyTest = "empty shopping list says nothing to buy"
	check(emptyTest, PlanTab.shoppingLines(PlanTab.shoppingList(shopPlan, {}), plainName)[1], "Nothing to buy")
	check(emptyTest .. ", no plan", PlanTab.shoppingLines(PlanTab.shoppingList(nil, {}), plainName)[1], "Nothing to buy")
	check(emptyTest .. ", one line only", #PlanTab.shoppingLines({}, plainName), 1)

	-- Auctionator (card 0025): a pretend Auctionator.API.v1 that records the
	-- list it was given and prices one gem. The global is put back after.
	do
		local wasAuctionator, wasPrint = Auctionator, print
		local sent, said = nil, {}
		-- Recorded AND passed on: a swallowed print hides this block's own FAIL
		-- lines from offline-check.lua, which counts them off what was printed.
		print = function(...) said[#said + 1] = table.concat({ ... }, " "); wasPrint(...) end
		Auctionator = nil
		local noneTest = "no auctionator parts without auctionator"
		check(noneTest .. ", no api", PlanTab.auctionator(), nil)
		check(noneTest .. ", no price", PlanTab.priceOf("gem", 50), nil)
		check(noneTest .. ", no total", (select(2, PlanTab.pricedLines(shop, plainName))), nil)
		check(noneTest .. ", the line is plain", PlanTab.pricedLines(shop, plainName)[2], "2x gem 50")
		check(noneTest .. ", send refuses", PlanTab.sendToAuctionator(shop), false)
		check(noneTest .. ", send says why", said[#said] and said[#said]:find("not loaded", 1, true) ~= nil, true)
		Auctionator = { API = { v1 = {
			CreateShoppingList = function(caller, name, terms) sent = { caller = caller, name = name, terms = terms } end,
			-- 7967 is priced so the enchant guard is proven: that is a stranger's item id.
			-- 98 answers a string and 99 throws: neither may reach the total (0025 review).
			GetAuctionPriceByItemID = function(caller, id)
				if id == 99 then error("Contact the maintainer") end
				return id == 50 and 123456 or id == 240908 and 50000 or id == 7967 and 1 or id == 98 and "12g" or nil
			end,
		} } }
		local priceTest = "shopping list shows auctionator prices"
		check(priceTest .. ", gold from copper", PlanTab.gold(123456), "12g 34s")
		check(priceTest .. ", a gem is priced", PlanTab.priceOf("gem", 50), 123456)
		check(priceTest .. ", an enchant is not, its id is not an item id", PlanTab.priceOf("enchant", 7967), nil)
		check(priceTest .. ", a price that is not a number is no price", PlanTab.priceOf("gem", 98), nil)
		check(priceTest .. ", a throw from Auctionator is no price", PlanTab.priceOf("gem", 99), nil)
		local texts, total, unpriced = PlanTab.pricedLines(shop, plainName)
		check(priceTest .. ", the line carries count times price", texts[2], "2x gem 50   " .. GREY .. "24g 69s|r")
		check(priceTest .. ", an unpriced line is left plain", texts[1], "2x enchant 7967")
		check(priceTest .. ", the total", total, 246912)
		check(priceTest .. ", the unpriced are counted", unpriced, 2)
		local sendTest = "shopping list sent to auctionator"
		check(sendTest, PlanTab.sendToAuctionator(shop), true)
		check(sendTest .. ", as this addon", sent and sent.caller, "DjinnisBiS")
		check(sendTest .. ", named", sent and sent.name, "DjinnisBiS plan")
		check(sendTest .. ", the search term, rank stripped", sent and sent.terms[1], "Eyes of the Eagle")
		check(sendTest .. ", a thing with no name yet is left out", sent and #sent.terms, 1)
		check(sendTest .. ", and said so", said[#said] and said[#said]:find("2 with no name yet left out", 1, true) ~= nil, true)
		-- Nothing named at all (an enchant id the rank table has never seen): the
		-- last good list must not be replaced by an empty one (0025 review).
		sent = nil
		check(sendTest .. ", nothing named sends nothing", PlanTab.sendToAuctionator({ { kind = "enchant", id = 1, count = 1 } }), false)
		check(sendTest .. ", nothing named leaves the list alone", sent, nil)
		check(sendTest .. ", nothing named says so", said[#said] and said[#said]:find("left as it was", 1, true) ~= nil, true)
		Auctionator.API.v1.CreateShoppingList = function() error("Contact the maintainer") end
		check(sendTest .. ", a refusal is caught", PlanTab.sendToAuctionator(shop), false)
		check(sendTest .. ", a refusal is shown", said[#said] and said[#said]:find("refused", 1, true) ~= nil, true)
		-- The tab AS DRAWN with a wrong gem in the planned wrist: the total row
		-- and its button with Auctionator, neither without.
		local wasWornLink, wasLevel, wasBoss = GetInventoryItemLink, C_Item.GetDetailedItemLevelInfo, PlanTab.boss
		GetInventoryItemLink = function(_, slotID) return slotID == 9 and "|Hitem:251135::240894::::|h[x]|h" or nil end
		C_Item.GetDetailedItemLevelInfo = function() return 318 end
		PlanTab.boss = "Nek'zali"
		local function totalRow()
			for _, line in ipairs(PlanTab.lines("Feral")) do
				if line.text:find("Total", 1, true) then return line end
			end
		end
		local withRow = totalRow()
		check(priceTest .. ", drawn total", withRow and withRow.text:find("Total 5g 00s", 1, true) ~= nil, true)
		check(sendTest .. ", drawn with its button", withRow and withRow.button and withRow.button.label, "Auctionator")
		-- A lesser gem is nothing to buy, so no total and no button even with Auctionator.
		GetInventoryItemLink = function(_, slotID) return slotID == 9 and "|Hitem:251135::240907::::|h[x]|h" or nil end
		check(sendTest .. ", no total row with nothing to buy", totalRow(), nil)
		GetInventoryItemLink = function(_, slotID) return slotID == 9 and "|Hitem:251135::240894::::|h[x]|h" or nil end
		Auctionator = nil
		check(noneTest .. ", no total row drawn", totalRow(), nil)
		GetInventoryItemLink, C_Item.GetDetailedItemLevelInfo, PlanTab.boss = wasWornLink, wasLevel, wasBoss
		Auctionator, print = wasAuctionator, wasPrint
	end

	-- The tab AS DRAWN (0007 review): the checks above prove the tables, and a
	-- tab that drew mismatch in green, or no loadout at all, passed every one.
	-- A 2 target boss is picked so lines() stops before it reads gear or bags.
	local realActive, realBoss = PlanTab.activeLoadoutName, PlanTab.boss
	local function drawn(active, edited)
		PlanTab.activeLoadoutName = function() return active, edited end
		local texts = {}
		for i, line in ipairs(PlanTab.lines("Feral")) do texts[i] = line.text end
		return table.concat(texts, "\n")
	end
	PlanTab.boss = "The Twin Fangs"
	local wrong, right, unknown = drawn("DotC Raid ST *", false), drawn("WS Raid 2T *", false), drawn(nil)
	local touched = drawn("WS Raid 2T *", true)
	PlanTab.activeLoadoutName, PlanTab.boss = realActive, realBoss
	check(editTest .. ", drawn after the name", touched:find("your loadout now: |r" .. WHITE .. "WS Raid 2T * (edited)|r", 1, true) ~= nil, true)
	check(editTest .. ", drawn red on the same name", touched:find("|cffff2020WS Raid 2T *|r", 1, true) ~= nil, true)
	check(editTest .. ", and told to reload it", touched:find("Click Talents to load \"WS Raid 2T *\"", 1, true) ~= nil, true)
	check(sameTest .. ", drawn with nothing after", right:find("your loadout now: |r" .. WHITE .. "WS Raid 2T *|r", 1, true) ~= nil, true)
	check(sameTest .. ", not marked", right:find("(edited)", 1, true), nil)
	check(sameTest .. ", unknown is not marked", unknown:find("(edited)", 1, true), nil)
	for _, row in ipairs(PlanTab.BOSSES.Feral) do
		local colour = row.boss == "The Twin Fangs" and "|cffff2020" or GREY
		check(bossTest .. ", drawn with loadout and scenario, " .. row.boss, wrong:find(
			row.boss .. "|r   " .. colour .. row.loadout .. "|r   " .. GREY .. SCENARIO_LABEL[row.scenario], 1, true) ~= nil, true)
	end
	check(flagTest .. ", drawn red", wrong:find("|cffff2020WS Raid 2T *|r", 1, true) ~= nil, true)
	check(flagTest .. ", and told to change it", wrong:find("Click Talents to load \"WS Raid 2T *\"", 1, true) ~= nil, true)
	check(flagTest .. ", a match is drawn green", right:find("> The Twin Fangs|r   " .. GREEN .. "WS Raid 2T *|r", 1, true) ~= nil, true)
	check(flagTest .. ", a match is not red", right:find("|cffff2020", 1, true), nil)
	check(flagTest .. ", unknown is never red", unknown:find("|cffff2020", 1, true), nil)

	local openTest = "the strip opens the tab on a boss of its own scenario"
	check(openTest .. ", first 2 target boss", PlanTab.bossFor(PlanTab.BOSSES.Feral, nil, "2t"), "The Lost Explorers")
	check(openTest .. ", keeps a pick that already fits", PlanTab.bossFor(PlanTab.BOSSES.Feral, "The Twin Fangs", "2t"), "The Twin Fangs")
	check(openTest .. ", moves a pick that does not", PlanTab.bossFor(PlanTab.BOSSES.Feral, "The Twin Fangs", "st"), "Nek'zali")
	check(openTest .. ", no scenario leaves the pick alone", PlanTab.bossFor(PlanTab.BOSSES.Feral, "Vashnik", nil), "Vashnik")
	check(openTest .. ", no boss table", PlanTab.bossFor(nil, nil, "st"), nil)

	-- boss ids (card 0027). The reference is a second copy, on purpose: the
	-- event names as ArchonTooltip's Localization.lua keys them by encounter id
	-- (enUS), which agrees with BigWigs' SetEncounterID lines. A row whose id
	-- points at a boss whose name does not start with the row's fails here.
	local ENCOUNTER_NAMES = {
		[3470] = "Nek'zali the Soulcoiler", [3445] = "Entombed Sentinels",
		[3497] = "The Lost Explorers",      [3455] = "Vashnik the Malignant",
		[3420] = "Sszorak",                 [3421] = "The Twin Fangs",
		[3429] = "The Coiled Altar",        [3492] = "Ula'tek",
		[3379] = "Nymrissa Wavecaller",
	}
	local idTest = "every boss row has a name and an id"
	local seenID = {}
	for _, row in ipairs(PlanTab.BOSSES.Feral) do
		check(idTest .. ", a name, " .. tostring(row.boss), type(row.boss) == "string" and row.boss ~= "", true)
		if row.scenario ~= "mplus" then  -- the Mythic+ row is a plan for any key, not a boss
			check(idTest .. ", an id, " .. row.boss, type(row.id) == "number", true)
			check(idTest .. ", an id used once, " .. row.boss, seenID[row.id or 0], nil)  -- `or 0`: a missing id is one red line, not a nil-key error that ends the test
			seenID[row.id or 0] = row.boss
		end
	end
	-- the name path answers the first row the event name starts with, so no row's
	-- name may start with another's: the earlier one would win every time
	for i, row in ipairs(PlanTab.BOSSES.Feral) do
		for j, other in ipairs(PlanTab.BOSSES.Feral) do
			if i ~= j then
				check(idTest .. ", no name starts with another's, " .. row.boss .. " vs " .. other.boss,
					norm(row.boss):find(norm(other.boss), 1, true) == 1, false)
			end
		end
	end
	local agreeTest = "a name and id that disagree fail the check"
	for _, row in ipairs(PlanTab.BOSSES.Feral) do
		if row.id then
			local eventName = ENCOUNTER_NAMES[row.id]
			check(agreeTest .. ", id known, " .. row.boss, eventName ~= nil, true)
			check(agreeTest .. ", " .. row.boss .. " is " .. tostring(eventName),
				eventName and norm(eventName):find(norm(row.boss), 1, true), 1)
		end
	end
	local rowTest = "boss lookup tries id then name"
	local byID = PlanTab.bossRow(PlanTab.BOSSES.Feral, 3470, "Some Other Name")
	check(rowTest .. ", id wins over a name that disagrees", byID and byID.boss, "Nek'zali")
	check(rowTest .. ", an unknown id does not fall back to the name", PlanTab.bossRow(PlanTab.BOSSES.Feral, 1, "Nek'zali"), nil)
	local byName = PlanTab.bossRow(PlanTab.BOSSES.Feral, nil, "Nek'zali the Soulcoiler")
	check(rowTest .. ", no id, the event's long name", byName and byName.boss, "Nek'zali")
	local exact = PlanTab.bossRow(PlanTab.BOSSES.Feral, nil, "the twin fangs")
	check(rowTest .. ", no id, an exact name any case", exact and exact.boss, "The Twin Fangs")
	check(rowTest .. ", no id and an unknown name", PlanTab.bossRow(PlanTab.BOSSES.Feral, nil, "Ragnaros"), nil)
	check(rowTest .. ", nothing at all", PlanTab.bossRow(PlanTab.BOSSES.Feral, nil, nil), nil)
	check(rowTest .. ", no boss table", PlanTab.bossRow(nil, 3470, "Nek'zali"), nil)

	-- the data broker line (card 0026)
	local brokerTest = "data broker text counts slots off plan"
	check(brokerTest .. ", on plan", PlanTab.brokerText(0), "BiS: on plan")
	check(brokerTest .. ", one off", PlanTab.brokerText(1), "BiS: 1 off plan")
	check(brokerTest .. ", two off", PlanTab.brokerText(2), "BiS: 2 off plan")
	check(brokerTest .. ", no plan says nothing", PlanTab.brokerText(nil), "BiS")
	do
		-- The count the broker writes is the count the slot marks draw: the same
		-- plan, the same slotStates. With nothing worn (the link read is
		-- stubbed nil, and put back) every planned slot is off plan, and that
		-- number is counted here by hand so a broker writing the wrong one shows.
		local wasWornLink = GetInventoryItemLink
		GetInventoryItemLink = function() return nil end
		local plan = gearPlanFor("Feral", planScenario("Feral"))
		local expected = 0
		if plan then for _ in pairs(slotStates(plan, {})) do expected = expected + 1 end end
		check(brokerTest .. ", every planned slot is off plan when nothing is worn", PlanTab.offPlanCount("Feral"), plan and expected or nil)
		check(brokerTest .. ", and that is more than none", plan and expected > 0, plan and true or nil)
		local realBroker = PlanTab.broker
		PlanTab.broker = { text = "" }
		-- Through the rebuild the glow events run, not updateBroker itself: a
		-- broker the events forget to write is the fault this guards (0026 review).
		rebuildBagWanted()
		local written = PlanTab.broker.text
		-- the player's own spec here, not Feral: a Guardian running /bis test has no plan and must read "BiS"
		local wanted = PlanTab.brokerText(PlanTab.offPlanCount())
		PlanTab.broker = realBroker
		GetInventoryItemLink = wasWornLink
		rebuildBagWanted()  -- the bag list and the real broker line back on the real gear
		check(brokerTest .. ", the broker line is written for the player", written, wanted)
	end

	-- the plan's date and age (card 0026)
	local ageTest = "plan tab shows the report date and age"
	local noon = function(y, m, d, h) return time({ year = y, month = m, day = d, hour = h or 12 }) end
	check(ageTest .. ", days since", PlanTab.daysSince("2026-09-01", noon(2026, 9, 10)), 9)
	check(ageTest .. ", simmed this morning is 0 days", PlanTab.daysSince("2026-09-10", noon(2026, 9, 10, 8)), 0)
	check(ageTest .. ", unreadable date", PlanTab.daysSince("last Tuesday", noon(2026, 9, 10)), nil)
	check(ageTest .. ", build date read", PlanTab.isoBuildDate("Sep 10 2026"), "2026-09-10")
	check(ageTest .. ", build date not read", PlanTab.isoBuildDate("12.1.0"), nil)
	check(ageTest .. ", line names the date", PlanTab.ageLine("2026-09-01", 9, false).text:find("Report simmed 2026-09-01, 9 days old", 1, true) ~= nil, true)
	check(ageTest .. ", one day", PlanTab.ageLine("2026-09-01", 1, false).text:find("1 day old", 1, true) ~= nil, true)
	check(ageTest .. ", unknown age is said", PlanTab.ageLine("?", nil, false).text:find("age not known", 1, true) ~= nil, true)
	do
		-- as drawn: the line is under the gear header for the picked boss's cell
		local realBoss4 = PlanTab.boss
		PlanTab.boss = "Nek'zali"  -- 1 target, the one filled cell
		local found
		for _, line in ipairs(PlanTab.lines("Feral")) do
			if line.text:find("Report simmed " .. GEAR_PLAN.Feral.st.simmed, 1, true) then found = line end
		end
		PlanTab.boss = realBoss4
		check(ageTest .. ", drawn with the cell's date", found ~= nil, true)
		check(ageTest .. ", drawn with an age", found and found.text:match("%d+ days? old") ~= nil, true)
		check(ageTest .. ", drawn with a hover", found and found.tip ~= nil, true)
	end
	local oldTest = "an old plan is marked"
	local function age(simmed, y, m, d, built) return PlanTab.planAge(simmed, noon(y, m, d), built) end
	check(oldTest .. ", over 14 days", select(2, age("2026-09-01", 2026, 9, 20, "Aug 20 2026")), true)
	check(oldTest .. ", 14 days exactly is not old", select(2, age("2026-09-01", 2026, 9, 15, "Aug 20 2026")), false)
	check(oldTest .. ", before the game build", select(2, age("2026-09-01", 2026, 9, 4, "Sep 05 2026")), true)
	check(oldTest .. ", fresh and after the build", select(2, age("2026-09-01", 2026, 9, 4, "Aug 20 2026")), false)
	check(oldTest .. ", build date unreadable never marks", select(2, age("2026-09-01", 2026, 9, 4, "who knows")), false)
	check(oldTest .. ", unreadable report date never marks", select(2, age("junk", 2026, 9, 4, "Sep 05 2026")), false)
	check(oldTest .. ", days still counted", (age("2026-09-01", 2026, 9, 20, "Aug 20 2026")), 19)
	local oldLine, freshLine = PlanTab.ageLine("2026-09-01", 19, true), PlanTab.ageLine("2026-09-01", 3, false)
	check(oldTest .. ", drawn amber", oldLine.text:find("|cffffb300", 1, true) ~= nil, true)
	check(oldTest .. ", re-sim in the hover", oldLine.tip:find("Re-sim?", 1, true) ~= nil, true)
	check(oldTest .. ", fresh is not amber", freshLine.text:find("|cffffb300", 1, true), nil)
	check(oldTest .. ", fresh does not say re-sim", freshLine.tip:find("Re-sim", 1, true), nil)

	-- a saved target must survive the round trip and show its item level
	setGear("zzz not a real item", "Myth", 6)
	check("saved ilvl label", gearLabel("zzz not a real item"):find("334", 1, true) ~= nil, true)
	setGear("zzz not a real item", nil)
	check("cleared ilvl label", gearLabel("zzz not a real item"):find("334", 1, true) ~= nil, false)

	print(failed == 0 and (GREEN .. "[BiS] self-test passed|r")
		or ("|cffff0000[BiS] " .. failed .. " check(s) failed|r"))
end

-- /djbis first: /bis was not always ours, another addon can claim it and
-- whichever registers last wins (Rob, 2026-09-22). /bis stays as a second
-- name for the times nobody else takes it.
SLASH_DJINNISBIS1 = "/djbis"
SLASH_DJINNISBIS2 = "/bis"
SlashCmdList.DJINNISBIS = function(msg)
	msg = msg:match("^%s*(.-)%s*$")
	if msg == "" then DjinnisBiS_Toggle()
	elseif msg == "here" then bonusRollVerdict((GetInstanceInfo()))
	elseif msg == "test" then selfTest()
	else listBySource(msg) end
end
