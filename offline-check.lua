-- Run this addon's own /bis test outside the game.
--
--     lua offline-check.lua
--
-- Author tooling, never shipped: it is in pkgmeta.yaml's ignore list.
--
-- WHY IT EXISTS. Every check that matters for this addon happens in a live game
-- client, which no agent can run, so the whole of DjinnisBiS.lua's pure logic
-- would otherwise be unverifiable between sessions. This stubs just enough of
-- Blizzard's API to load the file and reach the slash command. It proves the
-- data and the pure logic. IT PROVES NO FRAME: every CreateFrame here returns a
-- table whose methods do nothing, so a layout fault, an anchor fault or an
-- event fault passes straight through it. Those still need a person.
--
-- The stubs are deliberately dumb. A stub that got clever would start being a
-- second, wrong implementation of the API, and a check that passes against it
-- would mean less than no check at all.

local function noop() end

-- Any method not named below answers nil and swallows its arguments, which is
-- what makes the whole of the UI code loadable without listing its API surface.
local frameMT = {}
frameMT.__index = function()
	return function() return nil end
end

local function newFrame()
	local f = setmetatable({}, frameMT)
	f.CreateFontString = function() return newFrame() end
	f.CreateTexture = function() return newFrame() end
	f.IsShown = function() return false end
	f.GetHeight = function() return 100 end
	f.IsEventRegistered = function() return true end
	return f
end

CreateFrame = function() return newFrame() end
UIParent = newFrame()
GameTooltip = newFrame()
ItemRefTooltip = newFrame()
UISpecialFrames = {}

Enum = { TooltipDataType = { Item = 1 } }
TooltipDataProcessor = { AddTooltipPostCall = noop }
TooltipUtil = { GetDisplayedItem = function() return nil end }

tinsert = table.insert
wipe = function(t)
	for k in pairs(t) do t[k] = nil end
	return t
end
HandleModifiedItemClick = noop
InCombatLockdown = function() return false end

CR_CRIT_MELEE, CR_HASTE_MELEE, CR_MASTERY, CR_VERSATILITY_DAMAGE_DONE = 11, 18, 26, 29
local RATINGS = { [11] = 900, [18] = 1200, [26] = 1000, [29] = 300 }
GetCombatRating = function(index) return RATINGS[index] or 0 end

GetInstanceInfo = function() return "Nowhere", "none" end
GetInventoryItemLink = function() return nil end

C_AddOns = { IsAddOnLoaded = function() return false end }
C_Item = {
	GetItemInfoInstant = function() return nil end,
	GetItemStats = function() return nil end,
	GetDetailedItemLevelInfo = function() return nil end,
	GetItemInfo = function() return nil end,
	GetItemIcon = function() return nil end,
}
C_SpecializationInfo = {
	GetSpecialization = function() return 2 end,
	GetSpecializationInfo = function() return 103 end,  -- Feral
}
C_ClassTalents = { GetActiveHeroTalentSpec = function() return 0 end }
C_Traits = { GetSubTreeInfo = function() return nil end }
C_EncounterJournal = {}
EJ_SelectInstance, EJ_SelectEncounter, EJ_SetDifficulty, EJ_SelectTier = noop, noop, noop, noop
EJ_GetNumLoot = function() return 0 end
EJ_GetLootInfoByIndex = function() return nil end
EJ_GetEncounterInfoByIndex = function() return nil end

LibStub = function() return nil end
SlashCmdList = {}

-- The addon reports failures by printing, so failures are counted by reading
-- what it printed. Its own count is trusted for the summary line; this is the
-- belt to that braces, and it is what makes the exit code meaningful.
local failures = 0
local realPrint = print
print = function(...)
	local parts = {}
	for i = 1, select("#", ...) do parts[i] = tostring((select(i, ...))) end
	local line = table.concat(parts, " ")
	if line:find("FAIL") then failures = failures + 1 end
	realPrint(line)
end

local here = arg and arg[0] and arg[0]:match("^(.*)[/\\][^/\\]*$") or "."
dofile(here .. "/DjinnisBiS.lua")
SlashCmdList.DJINNISBIS("test")

realPrint(failures == 0 and "offline-check: no FAIL lines"
	or ("offline-check: " .. failures .. " FAIL lines"))
os.exit(failures == 0 and 0 or 1)
