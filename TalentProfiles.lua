-- Djinni's Class Profiles — Talent Profiles
-- Save and restore talent loadouts as named profiles, shared across
-- characters of the same class. Uses Blizzard export strings for portability.
local addonName, ns = ...
local DCP = ns.addon

---------------------------------------------------------------------------
-- Module setup
---------------------------------------------------------------------------

local TP = {}
ns.TalentProfiles = TP

---------------------------------------------------------------------------
-- Defaults
---------------------------------------------------------------------------

local DEFAULTS = {
    profiles = {},   -- { [classToken] = { [name] = talentProfileData } }
    activeProfile = {},  -- { [classToken] = "profileName" }
    linkToActionBars = {},  -- { [classToken .. "-" .. talentProfileName] = actionBarProfileName }
    autoLoadEnabled = false,
    autoLoadSpec = {},   -- { [classToken .. "-" .. specID] = "talentProfileName" }
}

---------------------------------------------------------------------------
-- Djinni-style message
---------------------------------------------------------------------------

local function DjinniMsg(msg)
    DCP:Print("|cff33ff99Djinni:|r " .. msg)
end

---------------------------------------------------------------------------
-- Database helpers
---------------------------------------------------------------------------

function TP:GetDB()
    return ns.db and ns.db.talentprofiles or DEFAULTS
end

local function GetClassToken()
    local _, classToken = UnitClass("player")
    return classToken or "UNKNOWN"
end

local function GetClassProfiles(db)
    local cls = GetClassToken()
    if not db.profiles[cls] then db.profiles[cls] = {} end
    return db.profiles[cls]
end

local function GetCharacterKey()
    local name = UnitName("player") or "Unknown"
    local realm = GetRealmName() or ""
    return name .. " - " .. realm
end

---------------------------------------------------------------------------
-- Core: Read current talent configuration
---------------------------------------------------------------------------

local function GetCurrentTalentString()
    local configID = C_ClassTalents.GetActiveConfigID()
    if not configID then return nil end
    return C_Traits.GenerateImportString(configID)
end

local function GetCurrentConfigName()
    local configID = C_ClassTalents.GetActiveConfigID()
    if not configID then return nil end
    local configInfo = C_Traits.GetConfigInfo(configID)
    return configInfo and configInfo.name or nil
end

---------------------------------------------------------------------------
-- Parse talent export string into node data (for mini tree visualization)
-- Returns: nodes[], specID, treeID (or nil on failure)
-- Each node: { nodeID, posX, posY, isSelected, isGranted, ranksPurchased,
--              maxRanks, isChoiceNode, choiceIndex, entryID, spellID, icon, name, subTreeID }
---------------------------------------------------------------------------

local BIT_WIDTH_VERSION = 8
local BIT_WIDTH_SPECID  = 16
local BIT_WIDTH_RANKS   = 6

local function ParseTalentExportString(exportString)
    if not exportString or exportString == "" then return nil end

    local importStream = ExportUtil.MakeImportDataStream(exportString)
    if not importStream then return nil end

    -- Read header
    local totalBits = importStream:GetNumberOfBits()
    local headerSize = BIT_WIDTH_VERSION + BIT_WIDTH_SPECID + 128
    if totalBits < headerSize then return nil end

    local serializationVersion = importStream:ExtractValue(BIT_WIDTH_VERSION)
    local specID = importStream:ExtractValue(BIT_WIDTH_SPECID)
    -- Skip tree hash (128 bits = 16 x 8)
    for i = 1, 16 do importStream:ExtractValue(8) end

    -- Get tree for this spec
    local treeID = C_ClassTalents.GetTraitTreeForSpec(specID)
    if not treeID then return nil end

    local treeNodes = C_Traits.GetTreeNodes(treeID)
    if not treeNodes or #treeNodes == 0 then return nil end

    -- We need a configID for GetNodeInfo — use active or view config
    local configID = C_ClassTalents.GetActiveConfigID()
    if not configID then return nil end

    local nodes = {}
    for i, treeNodeID in ipairs(treeNodes) do
        local nodeInfo = C_Traits.GetNodeInfo(configID, treeNodeID)
        if not nodeInfo then
            -- Consume bits to keep stream aligned
            local sel = importStream:ExtractValue(1)
            if sel == 1 then
                local purch = importStream:ExtractValue(1)
                if purch == 1 then
                    local partial = importStream:ExtractValue(1)
                    if partial == 1 then importStream:ExtractValue(BIT_WIDTH_RANKS) end
                    local choice = importStream:ExtractValue(1)
                    if choice == 1 then importStream:ExtractValue(2) end
                end
            end
        else
            local isSelected = importStream:ExtractValue(1) == 1
            local isPurchased = false
            local isPartiallyRanked = false
            local ranksPurchased = 0
            local isChoiceNode = false
            local choiceIndex = 1

            if isSelected then
                isPurchased = importStream:ExtractValue(1) == 1
                if isPurchased then
                    isPartiallyRanked = importStream:ExtractValue(1) == 1
                    if isPartiallyRanked then
                        ranksPurchased = importStream:ExtractValue(BIT_WIDTH_RANKS)
                    else
                        ranksPurchased = nodeInfo.maxRanks
                    end
                    isChoiceNode = importStream:ExtractValue(1) == 1
                    if isChoiceNode then
                        choiceIndex = importStream:ExtractValue(2) + 1
                    end
                end
            end

            -- Only include visible nodes with valid positions
            if nodeInfo.isVisible and nodeInfo.posX ~= 0 and nodeInfo.posY ~= 0 then
                local entryID = nil
                local spellID = nil
                local icon = nil
                local nodeName = nil

                if isSelected then
                    if isChoiceNode and nodeInfo.entryIDs[choiceIndex] then
                        entryID = nodeInfo.entryIDs[choiceIndex]
                    elseif nodeInfo.entryIDs and nodeInfo.entryIDs[1] then
                        entryID = nodeInfo.entryIDs[1]
                    end
                else
                    -- Not selected: still get icon from first entry for display
                    if nodeInfo.entryIDs and nodeInfo.entryIDs[1] then
                        entryID = nodeInfo.entryIDs[1]
                    end
                end

                if entryID then
                    local entryInfo = C_Traits.GetEntryInfo(configID, entryID)
                    if entryInfo and entryInfo.definitionID then
                        local defInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)
                        if defInfo then
                            spellID = defInfo.spellID
                            icon = defInfo.overrideIcon
                                or (defInfo.spellID and C_Spell.GetSpellTexture(defInfo.spellID))
                            nodeName = defInfo.overrideName
                                or (defInfo.spellID and C_Spell.GetSpellName(defInfo.spellID))
                        end
                    end
                end

                nodes[#nodes + 1] = {
                    nodeID         = treeNodeID,
                    posX           = nodeInfo.posX,
                    posY           = nodeInfo.posY,
                    isSelected     = isSelected,
                    isGranted      = isSelected and not isPurchased,
                    ranksPurchased = ranksPurchased,
                    maxRanks       = nodeInfo.maxRanks,
                    isChoiceNode   = isChoiceNode,
                    choiceIndex    = choiceIndex,
                    entryID        = entryID,
                    spellID        = spellID,
                    icon           = icon,
                    name           = nodeName,
                    subTreeID      = nodeInfo.subTreeID,
                }
            end
        end
    end

    return nodes, specID, treeID
end

---------------------------------------------------------------------------
-- Core: Save talent profile
---------------------------------------------------------------------------

local function SaveProfile(name)
    local talentString = GetCurrentTalentString()
    if not talentString or talentString == "" then
        DjinniMsg("Could not read current talent configuration.")
        return false
    end

    local db = TP:GetDB()
    local cls = GetClassToken()
    local profiles = GetClassProfiles(db)

    local specIdx = C_SpecializationInfo.GetSpecialization and C_SpecializationInfo.GetSpecialization() or 0
    local specID, specName = 0, ""
    if specIdx and specIdx > 0 then
        specID, specName = C_SpecializationInfo.GetSpecializationInfo(specIdx)
    end

    profiles[name] = {
        talentString = talentString,
        savedAt      = time(),
        savedBy      = GetCharacterKey(),
        specID       = specID or 0,
        specName     = specName or "",
        configName   = GetCurrentConfigName() or "",
    }

    db.activeProfile[cls] = name
    DjinniMsg("Saved talent profile: |cff00cc00" .. name .. "|r")
    ns.Notify("Saved talents: " .. name, "success")
    TP:UpdateData()
    return true
end

---------------------------------------------------------------------------
-- Core: Restore talent profile (apply import string)
---------------------------------------------------------------------------

local function RestoreProfile(name)
    local db = TP:GetDB()
    local cls = GetClassToken()
    local profiles = GetClassProfiles(db)
    local profile = profiles[name]
    if not profile then
        DjinniMsg("Talent profile not found: " .. name)
        return false
    end

    if InCombatLockdown() then
        DjinniMsg("Cannot change talents in combat.")
        return false
    end

    local configID = C_ClassTalents.GetActiveConfigID()
    if not configID then
        DjinniMsg("No active talent configuration found.")
        return false
    end

    -- Use Blizzard's import system
    -- First parse the import string to get entry info
    local success = false
    if ClassTalentFrame and ClassTalentFrame.ImportLoadout then
        -- If the talent frame exists, use its import method
        ClassTalentFrame:ImportLoadout(profile.talentString)
        success = true
    else
        -- Fallback: copy to clipboard and inform user
        DCP:CopyToClipboard(profile.talentString, "Talent Build: " .. name)
        DjinniMsg("Talent string copied to clipboard. Paste it in the talent UI import dialog.")
        db.activeProfile[cls] = name
        TP:UpdateData()
        return true
    end

    if success then
        db.activeProfile[cls] = name
        DjinniMsg("Applied talent profile: |cff00cc00" .. name .. "|r")
        ns.Notify("Loaded talents: " .. name, "success")

        -- Auto-load linked action bar profile if one exists
        local linkedAB = TP:GetLinkedActionBarProfile(name)
        if linkedAB and linkedAB ~= "" then
            local ABP = ns.ActionBarProfiles
            if ABP and ABP.RestoreProfile then
                DjinniMsg("Loading linked action bar profile: |cff00cc00" .. linkedAB .. "|r")
                ABP.RestoreProfile(linkedAB, false)
            end
        end
    end

    TP:UpdateData()
    return success
end

---------------------------------------------------------------------------
-- Core: Delete / Rename / Duplicate
---------------------------------------------------------------------------

local function DeleteProfile(name)
    local db = TP:GetDB()
    local cls = GetClassToken()
    local profiles = GetClassProfiles(db)
    if not profiles[name] then return false end
    profiles[name] = nil
    if db.activeProfile[cls] == name then
        db.activeProfile[cls] = nil
    end
    -- Clean link refs
    for key, val in pairs(db.linkToActionBars) do
        if val == name or key:find("^" .. cls .. "%-" .. name .. "$") then
            db.linkToActionBars[key] = nil
        end
    end
    DjinniMsg("Deleted talent profile: " .. name)
    TP:UpdateData()
    return true
end

local function RenameProfile(oldName, newName)
    local db = TP:GetDB()
    local cls = GetClassToken()
    local profiles = GetClassProfiles(db)
    if not profiles[oldName] then return false end
    if profiles[newName] then
        DjinniMsg("A talent profile named '" .. newName .. "' already exists.")
        return false
    end
    profiles[newName] = profiles[oldName]
    profiles[oldName] = nil
    if db.activeProfile[cls] == oldName then
        db.activeProfile[cls] = newName
    end
    -- Update link refs
    local linkKey = cls .. "-" .. oldName
    local newLinkKey = cls .. "-" .. newName
    if db.linkToActionBars[linkKey] then
        db.linkToActionBars[newLinkKey] = db.linkToActionBars[linkKey]
        db.linkToActionBars[linkKey] = nil
    end
    DjinniMsg("Renamed talent profile: " .. oldName .. " → " .. newName)
    TP:UpdateData()
    return true
end

local function DuplicateProfile(name, newName)
    local db = TP:GetDB()
    local profiles = GetClassProfiles(db)
    if not profiles[name] then
        DjinniMsg("Talent profile not found: " .. name)
        return false
    end
    if profiles[newName] then
        DjinniMsg("A talent profile named '" .. newName .. "' already exists.")
        return false
    end
    profiles[newName] = CopyTable(profiles[name])
    profiles[newName].savedAt = time()
    DjinniMsg("Duplicated talent profile: |cff00cc00" .. name .. "|r → |cff00cc00" .. newName .. "|r")
    TP:UpdateData()
    return true
end

local function GetSortedProfileList()
    local db = TP:GetDB()
    local profiles = GetClassProfiles(db)
    local list = {}
    for name in pairs(profiles) do
        list[#list + 1] = name
    end
    table.sort(list)
    return list
end

---------------------------------------------------------------------------
-- Action bar profile linking
---------------------------------------------------------------------------

function TP:GetLinkedActionBarProfile(talentProfileName)
    local db = self:GetDB()
    local cls = GetClassToken()
    return db.linkToActionBars[cls .. "-" .. talentProfileName]
end

function TP:SetLinkedActionBarProfile(talentProfileName, actionBarProfileName)
    local db = self:GetDB()
    local cls = GetClassToken()
    local key = cls .. "-" .. talentProfileName
    if actionBarProfileName and actionBarProfileName ~= "" then
        db.linkToActionBars[key] = actionBarProfileName
    else
        db.linkToActionBars[key] = nil
    end
end

---------------------------------------------------------------------------
-- Auto-load on spec change
---------------------------------------------------------------------------

local function CheckAutoLoadSpec()
    local db = TP:GetDB()
    if not db.autoLoadEnabled then return end
    local cls = GetClassToken()
    local specIdx = C_SpecializationInfo.GetSpecialization and C_SpecializationInfo.GetSpecialization()
    if not specIdx or specIdx == 0 then return end
    local specID = C_SpecializationInfo.GetSpecializationInfo(specIdx)
    if not specID then return end

    local key = cls .. "-" .. specID
    local profileName = db.autoLoadSpec[key]
    if not profileName then return end

    -- Skip if already active
    if db.activeProfile[cls] == profileName then return end

    local profiles = GetClassProfiles(db)
    if profiles[profileName] then
        DjinniMsg("Auto-loading talent profile for spec: |cff00cc00" .. profileName .. "|r")
        RestoreProfile(profileName)
    end
end

---------------------------------------------------------------------------
-- Event handling
---------------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")

function TP:Init()
    eventFrame:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_ENTERING_WORLD" then
            TP:UpdateData()
            C_Timer.After(3, CheckAutoLoadSpec)
            return
        end
        if event == "PLAYER_SPECIALIZATION_CHANGED" then
            TP:UpdateData()
            CheckAutoLoadSpec()
            return
        end
        if event == "TRAIT_CONFIG_UPDATED" or event == "ACTIVE_COMBAT_CONFIG_CHANGED" then
            TP:UpdateData()
            return
        end
    end)

    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
    eventFrame:RegisterEvent("ACTIVE_COMBAT_CONFIG_CHANGED")

    self:UpdateData()
end

---------------------------------------------------------------------------
-- Data collection
---------------------------------------------------------------------------

function TP:UpdateData()
    self.profileList = GetSortedProfileList()
end

---------------------------------------------------------------------------
-- Settings panel
---------------------------------------------------------------------------

TP.settingsLabel = "Talent Profiles"

function TP:BuildSettingsPanel(panel)
    local W = ns.SettingsWidgets
    local r = panel.refreshCallbacks

    local function db() return TP:GetDB() end

    local y = 0

    -- ── Talent Profile Management ─────────────────────────────
    local profBody = W.AddSection(panel, "Talent Profiles")
    y = 0

    -- Save current talents
    y = W.AddDescription(profBody, y, "Enter a name and click Save to snapshot your current talent build.")

    local saveFrame = CreateFrame("Frame", nil, profBody)
    saveFrame:SetPoint("TOPLEFT", profBody, "TOPLEFT", 18, y)
    saveFrame:SetSize(500, 30)

    local saveEB = CreateFrame("EditBox", nil, saveFrame, "InputBoxTemplate")
    saveEB:SetPoint("LEFT", saveFrame, "LEFT", 6, 0)
    saveEB:SetSize(300, 22)
    saveEB:SetAutoFocus(false)

    local saveBtn = CreateFrame("Button", nil, saveFrame, "UIPanelButtonTemplate")
    saveBtn:SetPoint("LEFT", saveEB, "RIGHT", 6, 0)
    saveBtn:SetSize(80, 22)
    saveBtn:SetText("Save")
    saveBtn:SetScript("OnClick", function()
        local name = strtrim(saveEB:GetText())
        if name == "" then return end

        local existing = GetClassProfiles(TP:GetDB())
        if existing[name] then
            StaticPopupDialogs["DCP_TP_OVERWRITE"] = {
                text = "Overwrite existing talent profile '|cff00cc00" .. name .. "|r'?",
                button1 = "Overwrite",
                button2 = "Cancel",
                OnAccept = function()
                    SaveProfile(name)
                    saveEB:SetText("")
                    TP:RebuildProfileListUI(profBody)
                end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
                preferredIndex = 3,
            }
            StaticPopup_Show("DCP_TP_OVERWRITE")
        else
            SaveProfile(name)
            saveEB:SetText("")
            TP:RebuildProfileListUI(profBody)
        end
    end)
    saveEB:SetScript("OnEnterPressed", function() saveBtn:Click() end)
    saveEB:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    y = y - 36

    -- Profile list container
    local container = CreateFrame("Frame", nil, profBody)
    container:SetPoint("TOPLEFT", profBody, "TOPLEFT", 18, y)
    container:SetPoint("RIGHT", profBody, "RIGHT", -18, 0)
    container:SetHeight(1)
    profBody._profileContainer = container
    profBody._profileRows = {}

    self:RebuildProfileListUI(profBody)

    W.EndSection(panel, y)

    -- ── Import / Export ───────────────────────────────────────
    local ioBody = W.AddSection(panel, "Talent Import / Export", true)
    y = 0

    y = W.AddButton(ioBody, y, "Export Active Talent Build", function()
        local talentString = GetCurrentTalentString()
        if talentString then
            DCP:CopyToClipboard(talentString, "Talent Build")
        else
            DjinniMsg("No active talent configuration to export.")
        end
    end)

    y = W.AddButton(ioBody, y, "Export All Talent Profiles (JSON)", function()
        local tpdb = db()
        local cls = GetClassToken()
        local profiles = GetClassProfiles(tpdb)
        local data = {
            format  = "DCP-JSON",
            version = 1,
            type    = "talentprofiles",
            class   = cls,
            profiles = profiles,
            activeProfile = tpdb.activeProfile[cls],
        }
        DCP:CopyToClipboard(ns.json.encode(data), "Talent Profiles (" .. cls .. ")")
    end)

    y = y - 8
    y = W.AddDescription(ioBody, y, "Paste a Blizzard talent import string or DCP JSON export below:")

    local importFrame = CreateFrame("Frame", nil, ioBody, "BackdropTemplate")
    importFrame:SetPoint("TOPLEFT", ioBody, "TOPLEFT", 22, y)
    importFrame:SetSize(400, 60)
    importFrame:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12, insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    importFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.8)
    importFrame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    local importScroll = CreateFrame("ScrollFrame", nil, importFrame, "UIPanelScrollFrameTemplate")
    importScroll:SetPoint("TOPLEFT", 6, -6)
    importScroll:SetPoint("BOTTOMRIGHT", -24, 6)

    local importEB = CreateFrame("EditBox", nil, importScroll)
    importEB:SetMultiLine(true)
    importEB:SetAutoFocus(false)
    importEB:SetFontObject("GameFontHighlight")
    importEB:SetWidth(360)
    importEB:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    importScroll:SetScrollChild(importEB)

    y = y - 66

    local importBtn = CreateFrame("Button", nil, ioBody, "UIPanelButtonTemplate")
    importBtn:SetPoint("TOPLEFT", ioBody, "TOPLEFT", 22, y)
    importBtn:SetSize(160, 22)
    importBtn:SetText("Save as Talent Profile")

    importBtn:SetScript("OnClick", function()
        local text = strtrim(importEB:GetText())
        if text == "" then
            DjinniMsg("No talent string to import.")
            return
        end

        -- Check for JSON format
        if text:sub(1, 1) == "{" and text:find('"DCP%-JSON"') then
            local data = ns.json.decode(text)
            if data and data.format == "DCP-JSON" and data.type == "talentprofiles" and type(data.profiles) == "table" then
                local tpdb = TP:GetDB()
                local cls = data.class or GetClassToken()
                if not tpdb.profiles[cls] then tpdb.profiles[cls] = {} end
                local count = 0
                for name, profile in pairs(data.profiles) do
                    tpdb.profiles[cls][name] = profile
                    count = count + 1
                end
                importEB:SetText("")
                DjinniMsg("Imported " .. count .. " talent profiles for " .. cls .. ".")
                TP:UpdateData()
                TP:RebuildProfileListUI(profBody)
                return
            else
                DjinniMsg("Invalid DCP JSON format for talent profiles.")
                return
            end
        end

        -- Standard Blizzard talent string — save as a new profile
        local db2 = TP:GetDB()
        local cls = GetClassToken()
        local profiles = GetClassProfiles(db2)

        local specIdx = C_SpecializationInfo.GetSpecialization and C_SpecializationInfo.GetSpecialization() or 0
        local specID, specName = 0, ""
        if specIdx and specIdx > 0 then
            specID, specName = C_SpecializationInfo.GetSpecializationInfo(specIdx)
        end

        local name = "Imported " .. date("%Y-%m-%d %H:%M")
        profiles[name] = {
            talentString = text,
            savedAt      = time(),
            savedBy      = "Import",
            specID       = specID or 0,
            specName     = specName or "",
            configName   = "",
        }

        importEB:SetText("")
        DjinniMsg("Saved imported talent build as: |cff00cc00" .. name .. "|r")
        TP:UpdateData()
        TP:RebuildProfileListUI(profBody)
    end)

    y = y - 28
    W.EndSection(panel, y)

    -- ── Auto-Load on Spec Change ─────────────────────────────
    local specBody = W.AddSection(panel, "Auto-Load Talents on Spec Change", true)
    y = 0

    y = W.AddCheckbox(specBody, y, "Enable talent auto-load on spec change",
        function() return db().autoLoadEnabled end,
        function(v) db().autoLoadEnabled = v end, r)
    y = W.AddNote(specBody, y, "When enabled, switching specializations will automatically load the assigned talent profile (and its linked action bar profile).")

    y = W.AddDescription(specBody, y, "Assign a talent profile to each specialization:")

    local cls = GetClassToken()
    local numSpecs = GetNumSpecializations and GetNumSpecializations() or 0
    for i = 1, numSpecs do
        local specID, specName = C_SpecializationInfo.GetSpecializationInfo(i)
        if specID and specName then
            local specKey = cls .. "-" .. specID

            local specLabel = specBody:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            specLabel:SetPoint("TOPLEFT", specBody, "TOPLEFT", 18, y)
            specLabel:SetText(specName)

            local specDD = CreateFrame("DropdownButton", nil, specBody, "WowStyle1DropdownTemplate")
            specDD:SetPoint("TOPLEFT", specLabel, "BOTTOMLEFT", 0, -2)
            specDD:SetWidth(200)

            local capturedKey = specKey
            specDD:SetupMenu(function(_, rootDescription)
                rootDescription:CreateButton("(None)", function()
                    db().autoLoadSpec[capturedKey] = nil
                end):SetIsSelected(function() return not db().autoLoadSpec[capturedKey] end)

                local list = GetSortedProfileList()
                for _, n in ipairs(list) do
                    local pName = n
                    rootDescription:CreateButton(pName, function()
                        db().autoLoadSpec[capturedKey] = pName
                    end):SetIsSelected(function() return db().autoLoadSpec[capturedKey] == pName end)
                end
            end)

            y = y - 52
        end
    end

    W.EndSection(panel, y)
end

---------------------------------------------------------------------------
-- Profile list UI
---------------------------------------------------------------------------

function TP:RebuildProfileListUI(profBody)
    local container = profBody._profileContainer
    if not container then return end

    for _, row in ipairs(profBody._profileRows or {}) do
        row:Hide()
        row:SetParent(nil)
    end
    profBody._profileRows = {}

    local profiles = GetSortedProfileList()
    local db = self:GetDB()
    local cls = GetClassToken()
    local ry = 0

    for _, name in ipairs(profiles) do
        local profile = GetClassProfiles(db)[name]
        if profile then
            local row = CreateFrame("Frame", nil, container)
            row:SetPoint("TOPLEFT", container, "TOPLEFT", 0, ry)
            row:SetPoint("RIGHT", container, "RIGHT", 0, 0)
            row:SetHeight(28)

            -- Name label
            local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            nameText:SetPoint("LEFT", row, "LEFT", 4, 0)
            nameText:SetText(name)
            if db.activeProfile[cls] == name then
                nameText:SetTextColor(0.2, 1.0, 0.2)
            end

            -- Buttons
            local profName = name

            local applyBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            applyBtn:SetPoint("RIGHT", row, "RIGHT", 0, 0)
            applyBtn:SetSize(54, 20)
            applyBtn:SetText("Apply")
            applyBtn:SetScript("OnClick", function()
                RestoreProfile(profName)
                TP:RebuildProfileListUI(profBody)
            end)

            local copyBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            copyBtn:SetPoint("RIGHT", applyBtn, "LEFT", -4, 0)
            copyBtn:SetSize(50, 20)
            copyBtn:SetText("Copy")
            copyBtn:SetScript("OnClick", function()
                local p = GetClassProfiles(TP:GetDB())[profName]
                if p and p.talentString then
                    DCP:CopyToClipboard(p.talentString, "Talent: " .. profName)
                end
            end)

            local delBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            delBtn:SetPoint("RIGHT", copyBtn, "LEFT", -4, 0)
            delBtn:SetSize(54, 20)
            delBtn:SetText("Delete")
            delBtn:SetScript("OnClick", function()
                StaticPopupDialogs["DCP_TP_DELETE"] = {
                    text = "Delete talent profile '|cff00cc00" .. profName .. "|r'?\n\nThis cannot be undone.",
                    button1 = "Delete",
                    button2 = "Cancel",
                    OnAccept = function()
                        DeleteProfile(profName)
                        TP:RebuildProfileListUI(profBody)
                    end,
                    timeout = 0,
                    whileDead = true,
                    hideOnEscape = true,
                    preferredIndex = 3,
                }
                StaticPopup_Show("DCP_TP_DELETE")
            end)

            local renBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            renBtn:SetPoint("RIGHT", delBtn, "LEFT", -4, 0)
            renBtn:SetSize(62, 20)
            renBtn:SetText("Rename")
            renBtn:SetScript("OnClick", function()
                StaticPopupDialogs["DCP_TP_RENAME"] = {
                    text = "Rename talent profile '" .. profName .. "' to:",
                    button1 = "Rename",
                    button2 = "Cancel",
                    hasEditBox = true,
                    OnShow = function(self) self.EditBox:SetText(profName) end,
                    OnAccept = function(self)
                        local newName = strtrim(self.EditBox:GetText())
                        if newName ~= "" and newName ~= profName then
                            RenameProfile(profName, newName)
                            TP:RebuildProfileListUI(profBody)
                        end
                    end,
                    timeout = 0,
                    whileDead = true,
                    hideOnEscape = true,
                    preferredIndex = 3,
                }
                StaticPopup_Show("DCP_TP_RENAME")
            end)

            -- Meta text (anchored between name and leftmost button)
            local meta = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            meta:SetPoint("LEFT", nameText, "RIGHT", 8, 0)
            meta:SetPoint("RIGHT", renBtn, "LEFT", -6, 0)
            meta:SetJustifyH("RIGHT")
            meta:SetWordWrap(false)
            local metaText = (profile.specName or "")
            if profile.savedAt then
                metaText = metaText .. " | " .. date("%Y-%m-%d", profile.savedAt)
            end
            meta:SetText("|cff888888" .. metaText .. "|r")

            profBody._profileRows[#profBody._profileRows + 1] = row
            ry = ry - 30
        end
    end

    container:SetHeight(math.max(math.abs(ry), 1))
end

---------------------------------------------------------------------------
-- Import from Blizzard built-in loadouts
---------------------------------------------------------------------------

-- Returns a list of { configID, name, talentString } for every saved loadout
-- the player has for the given specID (defaults to current spec).
local function GetBlizzardLoadouts(specID)
    specID = specID or (C_SpecializationInfo.GetSpecialization and
        select(1, C_SpecializationInfo.GetSpecializationInfo(C_SpecializationInfo.GetSpecialization())) or nil)
    if not specID then return {} end

    local configIDs = C_ClassTalents.GetConfigIDsBySpecID(specID)
    if not configIDs then return {} end

    local results = {}
    for _, configID in ipairs(configIDs) do
        local info = C_Traits.GetConfigInfo(configID)
        local name = (info and info.name and info.name ~= "") and info.name or ("Loadout #" .. configID)
        local talentString = C_Traits.GenerateImportString(configID)
        if talentString and talentString ~= "" then
            results[#results + 1] = {
                configID     = configID,
                name         = name,
                talentString = talentString,
            }
        end
    end
    return results
end

-- Import all Blizzard loadouts for the current spec as DCP talent profiles.
-- Skips any whose name already exists (unless overwrite=true).
-- Returns imported, skipped counts.
local function ImportFromBlizzardLoadouts(overwrite)
    local db      = TP:GetDB()
    local cls     = GetClassToken()
    local profs   = GetClassProfiles(db)

    local specIdx = C_SpecializationInfo.GetSpecialization and C_SpecializationInfo.GetSpecialization()
    local specID, specName = 0, ""
    if specIdx and specIdx > 0 then
        specID, specName = C_SpecializationInfo.GetSpecializationInfo(specIdx)
    end

    local loadouts = GetBlizzardLoadouts(specID)
    local imported, skipped = 0, 0

    for _, entry in ipairs(loadouts) do
        local profileName = entry.name
        if profs[profileName] and not overwrite then
            skipped = skipped + 1
        else
            profs[profileName] = {
                talentString = entry.talentString,
                savedAt      = time(),
                savedBy      = GetCharacterKey(),
                specID       = specID or 0,
                specName     = specName or "",
                configName   = entry.name,
            }
            imported = imported + 1
        end
    end

    if imported > 0 then
        TP:UpdateData()
        ns.Notify("Imported " .. imported .. " talent loadout(s)", "success")
        DjinniMsg("Imported " .. imported .. " Blizzard loadout(s)" ..
            (skipped > 0 and (", " .. skipped .. " skipped (already exist)") or "") .. ".")
    elseif skipped > 0 then
        DjinniMsg(skipped .. " loadout(s) already exist. Use 'overwrite' to replace them.")
    else
        DjinniMsg("No Blizzard loadouts found for current spec.")
    end

    return imported, skipped
end

TP.GetBlizzardLoadouts     = GetBlizzardLoadouts
TP.ImportFromBlizzardLoadouts = ImportFromBlizzardLoadouts

---------------------------------------------------------------------------
-- Find matching profile: detect which saved profile matches current talents
---------------------------------------------------------------------------

local function FindMatchingProfile()
    local currentStr = GetCurrentTalentString()
    if not currentStr or currentStr == "" then return nil end
    local db = TP:GetDB()
    local cls = GetClassToken()
    local profiles = GetClassProfiles(db)
    for name, prof in pairs(profiles) do
        if prof.talentString == currentStr then
            return name
        end
    end
    return nil
end

---------------------------------------------------------------------------
-- Public API (for CompanionFrame and other modules)
---------------------------------------------------------------------------

TP.SaveProfile = SaveProfile
TP.RestoreProfile = RestoreProfile
TP.GetSortedProfileList = GetSortedProfileList
TP.GetClassProfiles = GetClassProfiles
TP.GetCurrentTalentString = GetCurrentTalentString
TP.FindMatchingProfile = FindMatchingProfile
TP.ParseTalentExportString = ParseTalentExportString
TP.DeleteProfile = DeleteProfile
TP.RenameProfile = RenameProfile
TP.DuplicateProfile = DuplicateProfile

---------------------------------------------------------------------------
-- Module registration
---------------------------------------------------------------------------

ns:RegisterModule("talentprofiles", TP, DEFAULTS)
