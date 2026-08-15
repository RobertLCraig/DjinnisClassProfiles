-- Djinni's Class Profiles — Companion Frame
-- Small floating panel anchored to the spellbook/talent UI, providing
-- quick access to profiles without opening the full settings.
local addonName, ns = ...
local DCP = ns.addon

local CF = {}
ns.CompanionFrame = CF

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------

local function GetClassToken()
    local _, t = UnitClass("player"); return t or "UNKNOWN"
end

local function DjinniMsg(msg)
    DCP:Print("|cff33ff99Djinni:|r " .. msg)
end

---------------------------------------------------------------------------
-- Frame
---------------------------------------------------------------------------

local companionFrame = nil
local currentMode    = "actionbar"

local BD = {
    bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 14, insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

local function Btn(parent, label, w, h)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(w or 190, h or 22)
    b:SetText(label)
    return b
end

local function CreateCompanionFrame()
    if companionFrame then return companionFrame end

    local f = CreateFrame("Frame", "DCPCompanionFrame", UIParent, "BackdropTemplate")
    f:SetSize(210, 196)
    f:SetFrameStrata("HIGH")
    f:SetBackdrop(BD)
    f:SetBackdropColor(0.06, 0.07, 0.12, 0.97)
    f:SetBackdropBorderColor(0.35, 0.55, 1, 1)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)
    f:Hide()

    -- Header
    local header = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    header:SetPoint("TOP", f, "TOP", 0, -10)
    header:SetText("|cff33ccffDjinni's Profiles|r")

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -1)
    closeBtn:SetSize(20, 20)
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    -- Active profile display (mode-aware)
    local modeLabel = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    modeLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -28)
    modeLabel:SetText("Active Profile:")
    f._modeLabel = modeLabel

    local activeFS = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    activeFS:SetPoint("TOPLEFT", modeLabel, "BOTTOMLEFT", 0, -2)
    activeFS:SetPoint("RIGHT", f, "RIGHT", -10, 0)
    f._activeFS = activeFS

    -- Profile dropdown
    local dd = CreateFrame("DropdownButton", nil, f, "WowStyle1DropdownTemplate")
    dd:SetPoint("TOPLEFT", activeFS, "BOTTOMLEFT", -4, -6)
    dd:SetWidth(190)
    f._dropdown = dd
    dd:SetupMenu(function(_, root)
        local ABP = ns.ActionBarProfiles
        if not ABP then return end
        local list = ABP.GetSortedProfileList()
        if #list == 0 then
            root:CreateButton("|cff888888(no profiles)|r")
            return
        end
        for _, pName in ipairs(list) do
            local n = pName
            root:CreateButton(pName, function()
                ABP.RestoreProfile(n, false)
                CF:UpdateContent()
            end)
        end
    end)

    -- Buttons
    local saveBtn = Btn(f, "Save to Profile")
    saveBtn:SetPoint("TOPLEFT", dd, "BOTTOMLEFT", 4, -8)
    saveBtn:SetScript("OnClick", function()
        local ABP = ns.ActionBarProfiles
        if not ABP then return end
        local db  = ABP:GetDB()
        local cls = GetClassToken()
        local active = db.activeProfile[cls]
        if not active or active == "" then
            DjinniMsg("No active profile — use Save As to create one.")
            return
        end
        ABP.SaveProfile(active)
        CF:UpdateContent()
    end)

    local saveAsBtn = Btn(f, "Save As...")
    saveAsBtn:SetPoint("TOPLEFT", saveBtn, "BOTTOMLEFT", 0, -4)
    saveAsBtn:SetScript("OnClick", function()
        StaticPopupDialogs["DCP_CF_SAVEAS"] = {
            text = "Save current action bars as:",
            button1 = "Save", button2 = "Cancel", hasEditBox = true,
            OnAccept = function(self)
                local name = strtrim(self.EditBox:GetText())
                if name ~= "" then
                    local ABP = ns.ActionBarProfiles
                    if ABP then ABP.SaveProfile(name); CF:UpdateContent() end
                end
            end,
            timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
        }
        StaticPopup_Show("DCP_CF_SAVEAS")
    end)

    -- "Manage Profiles" opens the full ProfileManager window
    local manageBtn = Btn(f, "[+] Manage Profiles...")
    manageBtn:SetPoint("TOPLEFT", saveAsBtn, "BOTTOMLEFT", 0, -8)
    manageBtn:SetScript("OnClick", function()
        if ns.ProfileManager then ns.ProfileManager:Open() end
    end)

    companionFrame = f
    return f
end

---------------------------------------------------------------------------
-- Content update
---------------------------------------------------------------------------

function CF:UpdateContent()
    if not companionFrame or not companionFrame:IsShown() then return end
    local cls = GetClassToken()
    local ABP = ns.ActionBarProfiles
    if ABP then
        local db     = ABP:GetDB()
        local active = db.activeProfile[cls]
        if active and active ~= "" then
            local color = ABP.profileModified and "|cffffcc00" or "|cff44ff44"
            companionFrame._activeFS:SetText(color .. active .. "|r"
                .. (ABP.profileModified and " |cffffcc00(modified)|r" or ""))
        else
            companionFrame._activeFS:SetText("|cff888888(none)|r")
        end
        companionFrame._modeLabel:SetText(
            currentMode == "actionbar" and "Action Bar Profile:" or "Talent Profile:")
    end
end

---------------------------------------------------------------------------
-- Show / hide
---------------------------------------------------------------------------

local function ShowCompanion(mode)
    local f = CreateCompanionFrame()
    currentMode = mode or "actionbar"
    if PlayerSpellsFrame and PlayerSpellsFrame:IsShown() then
        f:ClearAllPoints()
        f:SetPoint("TOPLEFT", PlayerSpellsFrame, "TOPRIGHT", 4, 0)
    end
    f:Show()
    CF:UpdateContent()
end

local function HideCompanion()
    if companionFrame then companionFrame:Hide() end
end

---------------------------------------------------------------------------
-- Init
---------------------------------------------------------------------------

function CF:Init()
    EventRegistry:RegisterCallback("PlayerSpellsFrame.OpenFrame", function()
        ShowCompanion(currentMode)
    end, CF)

    EventRegistry:RegisterCallback("PlayerSpellsFrame.CloseFrame", function()
        HideCompanion()
    end, CF)

    EventRegistry:RegisterCallback("PlayerSpellsFrame.SpellBookFrame.Show", function()
        currentMode = "actionbar"
        CF:UpdateContent()
    end, CF)

    EventRegistry:RegisterCallback("PlayerSpellsFrame.TalentTab.Show", function()
        currentMode = "talent"
        CF:UpdateContent()
    end, CF)
end

---------------------------------------------------------------------------
-- Module registration
---------------------------------------------------------------------------

ns:RegisterModule("companionframe", CF)
