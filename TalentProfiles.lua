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
-- Event handling
---------------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")

function TP:Init()
    eventFrame:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_ENTERING_WORLD" then
            TP:UpdateData()
            return
        end
        if event == "TRAIT_CONFIG_UPDATED" or event == "ACTIVE_COMBAT_CONFIG_CHANGED" then
            TP:UpdateData()
            return
        end
    end)

    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
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
    local r = function() end  -- refresh callback placeholder

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
                    OnShow = function(self) self.editBox:SetText(profName) end,
                    OnAccept = function(self)
                        local newName = strtrim(self.editBox:GetText())
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
-- Module registration
---------------------------------------------------------------------------

ns:RegisterModule("talentprofiles", TP, DEFAULTS)
