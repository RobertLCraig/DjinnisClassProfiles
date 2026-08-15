-- Djinni's Class Profiles — Keybinding Profiles
-- Save and restore keybinding layouts as named profiles.
-- Profiles are per-account (not class-specific) since keybindings are shared.
local addonName, ns = ...
local DCP = ns.addon

---------------------------------------------------------------------------
-- Module setup
---------------------------------------------------------------------------

local KBP = {}
ns.KeybindingProfiles = KBP

---------------------------------------------------------------------------
-- Defaults
---------------------------------------------------------------------------

local DEFAULTS = {
    profiles      = {},   -- { [profileName] = keybindProfileData }
    activeProfile = nil,  -- "profileName"
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

function KBP:GetDB()
    return ns.db and ns.db.keybindingprofiles or DEFAULTS
end

local function GetCharacterKey()
    local name = UnitName("player") or "Unknown"
    local realm = GetRealmName() or ""
    return name .. " - " .. realm
end

---------------------------------------------------------------------------
-- Core: Read current keybindings
---------------------------------------------------------------------------

local function ReadAllBindings()
    local bindings = {}
    local count = GetNumBindings()
    for i = 1, count do
        local action, category, key1, key2 = GetBinding(i)
        if action and (key1 or key2) then
            bindings[action] = {
                key1 = key1 or nil,
                key2 = key2 or nil,
            }
        end
    end
    return bindings, count
end

---------------------------------------------------------------------------
-- Core: Restore keybindings from saved data
---------------------------------------------------------------------------

local function ApplyBindings(savedBindings)
    if InCombatLockdown() then
        DjinniMsg("Cannot change keybindings in combat.")
        return false, 0, 0
    end

    -- First, unbind all current keys so we start clean
    local count = GetNumBindings()
    for i = 1, count do
        local action, _, key1, key2 = GetBinding(i)
        if key1 then SetBinding(key1, nil) end
        if key2 then SetBinding(key2, nil) end
    end

    -- Apply saved bindings
    local placed, skipped = 0, 0
    for action, keys in pairs(savedBindings) do
        if keys.key1 then
            if SetBinding(keys.key1, action) then
                placed = placed + 1
            else
                skipped = skipped + 1
            end
        end
        if keys.key2 then
            if SetBinding(keys.key2, action) then
                placed = placed + 1
            else
                skipped = skipped + 1
            end
        end
    end

    -- Persist to the current binding set
    SaveBindings(GetCurrentBindingSet())
    return true, placed, skipped
end

---------------------------------------------------------------------------
-- Core: Save keybinding profile
---------------------------------------------------------------------------

local function SaveProfile(name)
    local db = KBP:GetDB()
    local bindings, totalActions = ReadAllBindings()

    local boundCount = 0
    for _ in pairs(bindings) do boundCount = boundCount + 1 end

    db.profiles[name] = {
        bindings     = bindings,
        savedAt      = time(),
        savedBy      = GetCharacterKey(),
        bindingSet   = GetCurrentBindingSet(),
        actionCount  = totalActions,
        boundCount   = boundCount,
    }

    db.activeProfile = name
    DjinniMsg("Saved keybinding profile: |cff00cc00" .. name .. "|r (" .. boundCount .. " bound actions)")
    KBP:UpdateData()
    return true
end

---------------------------------------------------------------------------
-- Core: Restore keybinding profile
---------------------------------------------------------------------------

local function RestoreProfile(name)
    local db = KBP:GetDB()
    local profile = db.profiles[name]
    if not profile then
        DjinniMsg("Keybinding profile not found: " .. name)
        return false
    end

    if InCombatLockdown() then
        DjinniMsg("Cannot change keybindings in combat.")
        return false
    end

    local success, placed, skipped = ApplyBindings(profile.bindings)
    if success then
        db.activeProfile = name
        DjinniMsg("Restored keybinding profile: |cff00cc00" .. name .. "|r (" .. placed .. " set, " .. skipped .. " skipped)")
    end

    KBP:UpdateData()
    return success
end

---------------------------------------------------------------------------
-- Core: Delete / Rename / Duplicate
---------------------------------------------------------------------------

local function DeleteProfile(name)
    local db = KBP:GetDB()
    if not db.profiles[name] then return false end
    db.profiles[name] = nil
    if db.activeProfile == name then
        db.activeProfile = nil
    end
    DjinniMsg("Deleted keybinding profile: " .. name)
    KBP:UpdateData()
    return true
end

local function RenameProfile(oldName, newName)
    local db = KBP:GetDB()
    if not db.profiles[oldName] then return false end
    if db.profiles[newName] then
        DjinniMsg("A keybinding profile named '" .. newName .. "' already exists.")
        return false
    end
    db.profiles[newName] = db.profiles[oldName]
    db.profiles[oldName] = nil
    if db.activeProfile == oldName then
        db.activeProfile = newName
    end
    DjinniMsg("Renamed keybinding profile: " .. oldName .. " → " .. newName)
    KBP:UpdateData()
    return true
end

local function DuplicateProfile(name, newName)
    local db = KBP:GetDB()
    if not db.profiles[name] then
        DjinniMsg("Keybinding profile not found: " .. name)
        return false
    end
    if db.profiles[newName] then
        DjinniMsg("A keybinding profile named '" .. newName .. "' already exists.")
        return false
    end
    db.profiles[newName] = CopyTable(db.profiles[name])
    db.profiles[newName].savedAt = time()
    DjinniMsg("Duplicated keybinding profile: |cff00cc00" .. name .. "|r → |cff00cc00" .. newName .. "|r")
    KBP:UpdateData()
    return true
end

local function GetSortedProfileList()
    local db = KBP:GetDB()
    local list = {}
    for name in pairs(db.profiles) do
        list[#list + 1] = name
    end
    table.sort(list)
    return list
end

---------------------------------------------------------------------------
-- Export / Import (JSON)
---------------------------------------------------------------------------

local function ExportProfileAsJSON(name)
    local db = KBP:GetDB()
    local profile = db.profiles[name]
    if not profile then return nil end

    local data = {
        format  = "DCP-JSON",
        version = 1,
        type    = "keybindings",
        name    = name,
        profile = profile,
    }
    return ns.json.encode(data)
end

local function ImportKeybindingJSON(text)
    local data = ns.json.decode(text)
    if not data or data.format ~= "DCP-JSON" or data.type ~= "keybindings" then
        return nil, nil
    end
    return data.name, data.profile and data.profile.bindings or nil
end

---------------------------------------------------------------------------
-- Event handling
---------------------------------------------------------------------------

function KBP:Init()
    self:UpdateData()
end

---------------------------------------------------------------------------
-- Data collection
---------------------------------------------------------------------------

function KBP:UpdateData()
    self.profileList = GetSortedProfileList()
end

---------------------------------------------------------------------------
-- Settings panel
---------------------------------------------------------------------------

KBP.settingsLabel = "Keybinding Profiles"

function KBP:BuildSettingsPanel(panel)
    local W = ns.SettingsWidgets
    local r = panel.refreshCallbacks

    local function db() return KBP:GetDB() end

    local y = 0

    -- ── Keybinding Profile Management ──────────────────────────
    local profBody = W.AddSection(panel, "Keybinding Profiles")
    y = 0

    -- Save current keybindings
    y = W.AddDescription(profBody, y, "Enter a name and click Save to snapshot your current keybindings.")

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

    local function DoSave()
        local name = strtrim(saveEB:GetText())
        if name == "" then return end
        local existing = db().profiles
        if existing[name] then
            StaticPopupDialogs["DCP_KBP_OVERWRITE"] = {
                text = "Overwrite existing keybinding profile '|cff00cc00" .. name .. "|r'?",
                button1 = "Overwrite",
                button2 = "Cancel",
                OnAccept = function()
                    SaveProfile(name)
                    saveEB:SetText("")
                    KBP:RebuildProfileListUI(profBody)
                end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
                preferredIndex = 3,
            }
            StaticPopup_Show("DCP_KBP_OVERWRITE")
        else
            SaveProfile(name)
            saveEB:SetText("")
            KBP:RebuildProfileListUI(profBody)
        end
    end

    saveBtn:SetScript("OnClick", DoSave)
    saveEB:SetScript("OnEnterPressed", function(self) DoSave(); self:ClearFocus() end)
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
    local ioBody = W.AddSection(panel, "Keybinding Import / Export", true)
    y = 0

    y = W.AddDescription(ioBody, y, "Export your current keybinding profile or import one from text.")

    local exportDD = CreateFrame("Frame", nil, ioBody)
    exportDD:SetPoint("TOPLEFT", ioBody, "TOPLEFT", 18, y)
    exportDD:SetSize(500, 24)

    local exportBtn = CreateFrame("Button", nil, exportDD, "UIPanelButtonTemplate")
    exportBtn:SetPoint("LEFT", exportDD, "LEFT", 0, 0)
    exportBtn:SetSize(160, 22)
    exportBtn:SetText("Export Active Profile")
    exportBtn:SetText("Export Active Profile (JSON)")
    exportBtn:SetSize(200, 22)
    exportBtn:SetScript("OnClick", function()
        local activeName = db().activeProfile
        if not activeName or not db().profiles[activeName] then
            DjinniMsg("No active keybinding profile to export. Save one first.")
            return
        end
        local text = ExportProfileAsJSON(activeName)
        if text then
            DCP:CopyToClipboard(text, "Keybinding Profile: " .. activeName)
        end
    end)

    y = y - 30
    y = W.AddDescription(ioBody, y, "Paste a DCP JSON keybinding export below:")

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
    importBtn:SetText("Import Profile")
    importBtn:SetScript("OnClick", function()
        local text = strtrim(importEB:GetText())
        if text == "" then
            DjinniMsg("No keybinding data to import.")
            return
        end

        local name, bindings = ImportKeybindingJSON(text)
        if not name or not bindings then
            DjinniMsg("Could not parse keybinding profile. Ensure it is a DCP JSON export.")
            return
        end

        local boundCount = 0
        for _ in pairs(bindings) do boundCount = boundCount + 1 end

        db().profiles[name] = {
            bindings    = bindings,
            savedAt     = time(),
            savedBy     = "Import",
            bindingSet  = GetCurrentBindingSet(),
            actionCount = 0,
            boundCount  = boundCount,
        }

        importEB:SetText("")
        DjinniMsg("Imported keybinding profile: |cff00cc00" .. name .. "|r (" .. boundCount .. " bindings)")
        KBP:UpdateData()
        KBP:RebuildProfileListUI(profBody)
    end)

    y = y - 28
    W.EndSection(panel, y)
end

---------------------------------------------------------------------------
-- Profile list UI
---------------------------------------------------------------------------

function KBP:RebuildProfileListUI(profBody)
    local container = profBody._profileContainer
    if not container then return end

    for _, row in ipairs(profBody._profileRows or {}) do
        row:Hide()
        row:SetParent(nil)
    end
    profBody._profileRows = {}

    local profiles = GetSortedProfileList()
    local db = self:GetDB()
    local ry = 0

    for _, name in ipairs(profiles) do
        local profile = db.profiles[name]
        if profile then
            local row = CreateFrame("Frame", nil, container)
            row:SetPoint("TOPLEFT", container, "TOPLEFT", 0, ry)
            row:SetPoint("RIGHT", container, "RIGHT", 0, 0)
            row:SetHeight(28)

            -- Name label
            local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            nameText:SetPoint("LEFT", row, "LEFT", 4, 0)
            nameText:SetText(name)
            if db.activeProfile == name then
                nameText:SetTextColor(0.2, 1.0, 0.2)
            end

            -- Buttons
            local profName = name

            local loadBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            loadBtn:SetPoint("RIGHT", row, "RIGHT", 0, 0)
            loadBtn:SetSize(50, 20)
            loadBtn:SetText("Load")
            loadBtn:SetScript("OnClick", function()
                StaticPopupDialogs["DCP_KBP_RESTORE"] = {
                    text = "Restore keybinding profile '|cff00cc00" .. profName .. "|r'?\n\nThis will replace all your current keybindings.",
                    button1 = "Restore",
                    button2 = "Cancel",
                    OnAccept = function()
                        RestoreProfile(profName)
                        KBP:RebuildProfileListUI(profBody)
                    end,
                    timeout = 0,
                    whileDead = true,
                    hideOnEscape = true,
                    preferredIndex = 3,
                }
                StaticPopup_Show("DCP_KBP_RESTORE")
            end)

            local dupBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            dupBtn:SetPoint("RIGHT", loadBtn, "LEFT", -4, 0)
            dupBtn:SetSize(44, 20)
            dupBtn:SetText("Dup")
            dupBtn:SetScript("OnClick", function()
                StaticPopupDialogs["DCP_KBP_DUPLICATE"] = {
                    text = "Duplicate keybinding profile '" .. profName .. "' as:",
                    button1 = "Duplicate",
                    button2 = "Cancel",
                    hasEditBox = true,
                    OnShow = function(self) self.EditBox:SetText(profName .. " Copy") end,
                    OnAccept = function(self)
                        local newName = strtrim(self.EditBox:GetText())
                        if newName ~= "" then
                            DuplicateProfile(profName, newName)
                            KBP:RebuildProfileListUI(profBody)
                        end
                    end,
                    timeout = 0,
                    whileDead = true,
                    hideOnEscape = true,
                    preferredIndex = 3,
                }
                StaticPopup_Show("DCP_KBP_DUPLICATE")
            end)

            local delBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            delBtn:SetPoint("RIGHT", dupBtn, "LEFT", -4, 0)
            delBtn:SetSize(54, 20)
            delBtn:SetText("Delete")
            delBtn:SetScript("OnClick", function()
                StaticPopupDialogs["DCP_KBP_DELETE"] = {
                    text = "Delete keybinding profile '|cff00cc00" .. profName .. "|r'?\n\nThis cannot be undone.",
                    button1 = "Delete",
                    button2 = "Cancel",
                    OnAccept = function()
                        DeleteProfile(profName)
                        KBP:RebuildProfileListUI(profBody)
                    end,
                    timeout = 0,
                    whileDead = true,
                    hideOnEscape = true,
                    preferredIndex = 3,
                }
                StaticPopup_Show("DCP_KBP_DELETE")
            end)

            local renBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            renBtn:SetPoint("RIGHT", delBtn, "LEFT", -4, 0)
            renBtn:SetSize(62, 20)
            renBtn:SetText("Rename")
            renBtn:SetScript("OnClick", function()
                StaticPopupDialogs["DCP_KBP_RENAME"] = {
                    text = "Rename keybinding profile '" .. profName .. "' to:",
                    button1 = "Rename",
                    button2 = "Cancel",
                    hasEditBox = true,
                    OnShow = function(self) self.EditBox:SetText(profName) end,
                    OnAccept = function(self)
                        local newName = strtrim(self.EditBox:GetText())
                        if newName ~= "" and newName ~= profName then
                            RenameProfile(profName, newName)
                            KBP:RebuildProfileListUI(profBody)
                        end
                    end,
                    timeout = 0,
                    whileDead = true,
                    hideOnEscape = true,
                    preferredIndex = 3,
                }
                StaticPopup_Show("DCP_KBP_RENAME")
            end)

            -- Meta text
            local meta = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            meta:SetPoint("LEFT", nameText, "RIGHT", 8, 0)
            meta:SetPoint("RIGHT", renBtn, "LEFT", -6, 0)
            meta:SetJustifyH("RIGHT")
            meta:SetWordWrap(false)
            local metaParts = {}
            if profile.boundCount then
                metaParts[#metaParts + 1] = profile.boundCount .. " bindings"
            end
            if profile.savedAt then
                metaParts[#metaParts + 1] = date("%Y-%m-%d", profile.savedAt)
            end
            meta:SetText("|cff888888" .. table.concat(metaParts, " | ") .. "|r")

            profBody._profileRows[#profBody._profileRows + 1] = row
            ry = ry - 30
        end
    end

    container:SetHeight(math.max(math.abs(ry), 1))
end

---------------------------------------------------------------------------
-- Module registration
---------------------------------------------------------------------------

ns:RegisterModule("keybindingprofiles", KBP, DEFAULTS)
