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

-- event -> the frames that registered it, so the spec run can fire one (0049)
local registered = {}

local function newFrame()
	local f = setmetatable({}, frameMT)
	f.CreateFontString = function() return newFrame() end
	f.CreateTexture = function() return newFrame() end
	f.IsShown = function() return false end
	f.GetHeight = function() return 100 end
	f.IsEventRegistered = function() return true end
	f.RegisterEvent = function(self, event)
		registered[event] = registered[event] or {}
		table.insert(registered[event], self)
	end
	f.SetScript = function(self, name, fn) if name == "OnEvent" then self.onEvent = fn end end
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
GetCursorInfo = function() return nil end  -- the bar commands' fence (the 0049 spec run)
-- Every bar slot empty and nothing up. Anything else it is asked answers nil.
C_ActionBar = setmetatable({
	HasVehicleActionBar = function() return false end,
	HasOverrideActionBar = function() return false end,
}, { __index = function() return function() return nil end end })
GetNumBindings = function() return 0 end  -- no key bindings to save with the bars

CR_CRIT_MELEE, CR_HASTE_MELEE, CR_MASTERY, CR_VERSATILITY_DAMAGE_DONE = 11, 18, 26, 29
local RATINGS = { [11] = 900, [18] = 1200, [26] = 1000, [29] = 300 }
GetCombatRating = function(index) return RATINGS[index] or 0 end

GetInstanceInfo = function() return "Nowhere", "none" end
GetInventoryItemLink = function() return nil end
time, date = os.time, os.date  -- WoW exposes both as globals; the plan's age reads time()
GetBuildInfo = function() return "12.1.0", "00000", "Sep 10 2026", 120100 end

C_AddOns = { IsAddOnLoaded = function() return false end }
C_Item = {
	GetItemInfoInstant = function() return nil end,
	GetItemStats = function() return nil end,
	GetDetailedItemLevelInfo = function() return nil end,
	GetItemInfo = function() return nil end,
	GetItemIcon = function() return nil end,
	GetItemCount = function() return 0 end,  -- the Plan tab's gear lines, once a drawn boss has a plan
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
local watchBiS, bisLines = false, 0
local realPrint = print
print = function(...)
	local parts = {}
	for i = 1, select("#", ...) do parts[i] = tostring((select(i, ...))) end
	local line = table.concat(parts, " ")
	-- The summary counts too: a check that runs with print swapped out can
	-- lose its FAIL line, and the addon's own "N check(s) failed" still shows
	-- (0011 build, where five red checks read as a pass).
	-- The red marker, not the bare word: the addon's own CONFIG_COMMIT_FAILED
	-- chat line is not a failed check.
	if line:find("|cffff0000FAIL|r", 1, true) or line:find("check(s) failed", 1, true) then failures = failures + 1 end
	if watchBiS and line:find("[BiS]", 1, true) then bisLines = bisLines + 1 end  -- the spec run's roll events
	realPrint(line)
end

-- `lua offline-check.lua 250` loads the addon as that spec (card 0049, Blood)
-- and, instead of the self-test, types every slash command a player would.
-- The self-test's checks are written for Feral, so they are not run then.
-- This proves no command errors on another class; it proves nothing drawn.
local asSpec = tonumber(arg and arg[1])
if asSpec then
	C_SpecializationInfo.GetSpecializationInfo = function() return asSpec end
	UnitClass = function() return "?", "?", nil end  -- the spec must decide the class, not this
end
local tooltipHook
TooltipDataProcessor.AddTooltipPostCall = function(_, hook) tooltipHook = hook end

local here = arg and arg[0] and arg[0]:match("^(.*)[/\\][^/\\]*$") or "."
local source = assert(io.open(here .. "/DjinnisBiS.lua")):read("*a")
dofile(here .. "/DjinnisBiS.lua")
-- An id the addon does not know would run as "no spec" and pass (0049 review).
if asSpec and not source:find("{ " .. asSpec .. ", \"", 1, true) then
	print("|cffff0000FAIL|r spec " .. asSpec .. " is not in PlanTab.SPECS, so this run would prove nothing")
end
if not asSpec then
	SlashCmdList.DJINNISBIS("test")
else
	-- Not "" (the window): it needs a template's children, which no stub has,
	-- and it fails the same way as Feral. The window's spec buttons are the
	-- four druid specs whatever the class, so it is druid gear by design.
	local commands = { "here", "talents", "loadouts", "tidy", "bars", "bars list", "bars save",
		"bars save build", "bars undo", "bars load nothing", "Venomous" }
	for _, cmd in ipairs(commands) do
		local ok, err = pcall(SlashCmdList.DJINNISBIS, cmd)
		if not ok then print("|cffff0000FAIL|r /djbis " .. cmd .. " as spec " .. asSpec .. ": " .. tostring(err)) end
	end
	-- The first item in the gear plan, by id and name, so a druid hovering it
	-- gets a plan line. On another class the tooltip gets no line at all.
	local plan = source:match("BEGIN GENERATED GEAR PLAN(.-)END GENERATED GEAR PLAN") or ""
	local itemID, itemName = plan:match("\"id=(%d+),[^\n]-%-%- ([^\n]-)%s*\n")
	if not itemID then print("|cffff0000FAIL|r no planned item in the gear plan block: the tooltip check would prove nothing") end
	local itemLink = "|cffa335ee|Hitem:" .. tostring(itemID) .. "::::::::80:::::|h[" .. tostring(itemName) .. "]|h|r"
	local added = {}
	local tip = setmetatable({ AddLine = function(_, text) added[#added + 1] = text end }, frameMT)
	GameTooltip = tip
	TooltipUtil.GetDisplayedItem = function() return itemName, itemLink, tonumber(itemID) end
	C_Item.GetItemInfoInstant = function() return tonumber(itemID), "Armor", "Misc", "INVTYPE_NECK" end
	local ok, err = pcall(tooltipHook, tip)
	if not ok then print("|cffff0000FAIL|r the item tooltip as spec " .. asSpec .. ": " .. tostring(err)) end
	for _, text in ipairs(added) do
		print("|cffff0000FAIL|r hovering " .. tostring(itemName) .. " as spec " .. asSpec .. " adds: " .. text)
	end
	-- A boss kill, a finished key and a loot roll of that item: the druid
	-- verdict would reach RaidWarningUtil, which is not stubbed, or print a
	-- "[BiS]" chat line. Either fails here.
	GetLootRollItemLink = function() return itemLink end
	watchBiS = true
	local fired = 0
	for _, event in ipairs({ "ENCOUNTER_END", "CHALLENGE_MODE_COMPLETED", "START_LOOT_ROLL" }) do
		for _, frame in ipairs(registered[event] or {}) do
			if frame.onEvent then
				fired = fired + 1
				local okEvent, errEvent = pcall(frame.onEvent, frame, event, 3445, "Vashnik", 16, 20, 1)
				if not okEvent then print("|cffff0000FAIL|r " .. event .. " as spec " .. asSpec .. ": " .. tostring(errEvent)) end
			end
		end
	end
	watchBiS = false
	if bisLines > 0 then print("|cffff0000FAIL|r the roll events as spec " .. asSpec .. " printed " .. bisLines .. " [BiS] line(s)") end
	if fired < 3 then print("|cffff0000FAIL|r only " .. fired .. " frames took the three events: the event capture is broken") end
	realPrint("offline-check: typed " .. #commands .. " commands, hovered one item and fired " .. fired .. " events as spec " .. asSpec)
end

-- Card 0011: no C_ClassTalents or C_Traits call that changes talents, anywhere
-- in the file's code (comments may name them). Every such call in code must
-- be on this list of readers; Blizzard's ClassTalentHelper is the only writer.
do
	local readers = {
		["C_ClassTalents.GetActiveConfigID"] = true, ["C_ClassTalents.GetActiveHeroTalentSpec"] = true,
		["C_ClassTalents.GetLastSelectedSavedConfigID"] = true, ["C_ClassTalents.GetStarterBuildActive"] = true,
		["C_ClassTalents.GetConfigIDsBySpecID"] = true,
		["C_Traits.GetConfigInfo"] = true, ["C_Traits.GetSubTreeInfo"] = true,
		["C_Traits.GenerateImportString"] = true,  -- a read: the "(edited)" compare (card 0014)
		["C_ClassTalents.CanCreateNewConfig"] = true, ["C_ClassTalents.IsConfigPopulated"] = true,
		["C_ClassTalents.GetTraitTreeForSpec"] = true, ["C_Traits.GetLoadoutSerializationVersion"] = true,
		["C_Traits.GetTreeHash"] = true, ["C_Traits.GetTreeNodes"] = true,  -- card 0034's node order
		-- Card 0031: these two make and delete SAVED loadouts, the same calls
		-- Blizzard's import and delete dialogs make. Neither changes the talents
		-- in play. CommitConfig, LoadConfig, PurchaseRank and SetSelection stay
		-- off this list: those are the frozen-action-bar route (card 0002).
		["C_ClassTalents.ImportLoadout"] = true, ["C_ClassTalents.DeleteConfig"] = true,
	}
	local src = assert(io.open(here .. "/DjinnisBiS.lua")):read("*a")
	local seen = 0
	for line in src:gmatch("[^\n]+") do
		for call in line:gsub("%-%-.*$", ""):gmatch("C_[CT][%w_]*%.[%w_]+") do
			seen = seen + 1
			if (call:find("^C_ClassTalents%.") or call:find("^C_Traits%.")) and not readers[call] then
				print("|cffff0000FAIL|r no talent-changing call in the file: " .. call)
			end
		end
	end
	if seen == 0 then print("|cffff0000FAIL|r no talent-changing call in the file: saw no C_ call at all, the scan is broken") end
end

-- Card 0020: no `...Small` font on a value, a label or a button. A small font
-- is allowed only for a line of help, and every such line carries the marker
-- `-- small font:` with its reason, so a new one has to say why it is small.
do
	local src = assert(io.open(here .. "/DjinnisBiS.lua")):read("*a")
	local seen, lineNo = 0, 0
	for line in src:gmatch("[^\n]*\n?") do
		lineNo = lineNo + 1
		local code = line:gsub("%-%-.*$", "")
		local font = code:match("\"(GameFont%w-Small%w*)\"")
		if font then
			seen = seen + 1
			if not line:find("-- small font:", 1, true) then
				print("|cffff0000FAIL|r no small font on values, labels or buttons: " .. font .. " at line " .. lineNo)
			end
		end
	end
	if seen == 0 then print("|cffff0000FAIL|r no small font on values, labels or buttons: saw no font name at all, the scan is broken") end
end

realPrint(failures == 0 and "offline-check: no FAIL lines"
	or ("offline-check: " .. failures .. " FAIL lines"))
os.exit(failures == 0 and 0 or 1)
