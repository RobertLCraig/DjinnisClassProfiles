-- Djinni's Class Profiles — Profile Manager
-- Standalone window providing full profile CRUD, slot grid preview,
-- multi-profile merge with conflict resolution, and the login sync prompt.
local addonName, ns = ...
local DCP = ns.addon

local PM = {}
ns.ProfileManager = PM

---------------------------------------------------------------------------
-- Constants
---------------------------------------------------------------------------

local W, H          = 780, 540
local SIDEBAR_W     = 224
local SLOT_SZ       = 32
local SLOT_GAP      = 2
local SLOTS_PER_ROW = 12
local BAR_LABEL_W   = 112
local CONTENT_X     = SIDEBAR_W + 10   -- right panel left edge (relative to window)
local CONTENT_W     = W - CONTENT_X - 10

-- Backdrop shared template
local BD = {
    bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 12, insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

---------------------------------------------------------------------------
-- State
---------------------------------------------------------------------------

local window          = nil
local currentTab      = "actionbar"
local selectedProfile = nil
local mergeMode       = false
local mergeSelected   = {}   -- { [name] = true }
local mergeResult     = {}   -- { [slotID] = { prof = name, data = slotData } }

-- Reusable slot-icon button pool
local slotPool = {}

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------

local function GetClassToken()
    local _, t = UnitClass("player"); return t or "UNKNOWN"
end

local function GetSlotIcon(sd)
    if not sd then return nil end
    if sd.type == "spell"     then
        return (C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(sd.id))
            or "Interface\\Icons\\INV_Misc_QuestionMark"
    end
    if sd.type == "item"      then
        local _, _, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(sd.id)
        return icon or "Interface\\Icons\\INV_Misc_QuestionMark"
    end
    if sd.type == "macro"     then
        local _, icon = GetMacroInfo(sd.name or "")
        return icon or "Interface\\Icons\\INV_Misc_QuestionMark"
    end
    if sd.type == "flyout"    then return "Interface\\Icons\\Spell_Nature_NullWard" end
    if sd.type == "summonpet" then return "Interface\\Icons\\INV_Pet_Achievement_WinDuel" end
    return "Interface\\Icons\\INV_Misc_QuestionMark"
end

local function GetSlotName(sd)
    if not sd then return "(empty)" end
    if sd.type == "spell"  then
        return (C_Spell.GetSpellName and C_Spell.GetSpellName(sd.id))
            or ("Spell #" .. sd.id)
    end
    if sd.type == "item"   then
        return C_Item.GetItemNameByID and C_Item.GetItemNameByID(sd.id)
            or ("Item #" .. sd.id)
    end
    if sd.type == "macro"  then return "Macro: " .. (sd.name or "?") end
    if sd.type == "flyout" then return "Flyout" end
    if sd.type == "summonpet" then return "Pet" end
    return sd.type
end

local function SpellIDsEquivalent(idA, idB)
    if idA == idB then return true end
    if not idA or not idB then return false end
    -- Normalize via base spell (handles talent-morphed / override spell IDs)
    local baseA = C_SpellBook.FindBaseSpellByID and C_SpellBook.FindBaseSpellByID(idA) or idA
    local baseB = C_SpellBook.FindBaseSpellByID and C_SpellBook.FindBaseSpellByID(idB) or idB
    if baseA == baseB then return true end
    -- Fallback: compare by display name (handles rank/version differences)
    local nameA = C_Spell.GetSpellName and C_Spell.GetSpellName(idA)
    local nameB = C_Spell.GetSpellName and C_Spell.GetSpellName(idB)
    if nameA and nameB and nameA == nameB then return true end
    return false
end

local function SlotsEqual(a, b)
    if a == nil and b == nil then return true end
    if a == nil or b == nil  then return false end
    if a.type ~= b.type      then return false end
    if a.type == "macro"     then return (a.name or "") == (b.name or "") end
    if a.type == "spell"     then return SpellIDsEquivalent(a.id, b.id) end
    return a.id == b.id
end

-- Returns list of { slotID, saved, current } where they differ
local function DiffSlots(savedSlots, currentSlots)
    local union = {}
    for id in pairs(savedSlots  or {}) do union[id] = true end
    for id in pairs(currentSlots or {}) do union[id] = true end
    local diff = {}
    for id in pairs(union) do
        local s = savedSlots   and savedSlots[id]
        local c = currentSlots and currentSlots[id]
        if not SlotsEqual(s, c) then
            diff[#diff + 1] = { slotID = id, saved = s, current = c }
        end
    end
    table.sort(diff, function(a, b) return a.slotID < b.slotID end)
    return diff
end

local function GetBarLabel(slotID)
    for _, bar in ipairs(ns.ACTION_BARS) do
        if slotID >= bar.startSlot and slotID <= bar.endSlot then
            return bar.label .. " #" .. (slotID - bar.startSlot + 1)
        end
    end
    return "Slot " .. slotID
end

local function TagColor(tag)
    local ABP = ns.ActionBarProfiles
    if ABP and ABP.TAG_COLORS then
        local c = ABP.TAG_COLORS[tag or ""]
        if c then return tonumber(c:sub(1,2),16)/255, tonumber(c:sub(3,4),16)/255, tonumber(c:sub(5,6),16)/255 end
    end
    return 0.5, 0.5, 0.5
end

---------------------------------------------------------------------------
-- Slot button pool — reusable 32×32 icon cells
---------------------------------------------------------------------------

local function AcquireSlot(parent)
    for i = #slotPool, 1, -1 do
        local btn = slotPool[i]
        if not btn:GetParent() or btn:GetParent() == parent then
            table.remove(slotPool, i)
            btn:SetParent(parent)
            btn:Show()
            return btn
        end
    end
    -- Create new
    local btn = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    btn:SetSize(SLOT_SZ, SLOT_SZ)
    btn:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\UI-SlotHighlight",
        edgeSize = 4, insets = { left = 1, right = 1, top = 1, bottom = 1 } })
    btn:SetBackdropColor(0.05, 0.05, 0.05, 1)
    btn:SetBackdropBorderColor(0.25, 0.25, 0.25, 0.8)

    local tex = btn:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -2)
    tex:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -2, 2)
    tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    btn._tex = tex

    local overlay = btn:CreateTexture(nil, "OVERLAY")
    overlay:SetAllPoints()
    overlay:SetColorTexture(0, 0, 0, 0)
    btn._overlay = overlay

    btn:EnableMouse(true)
    btn:SetScript("OnEnter", function(self)
        if self._slotData then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:ClearLines()
            local name = GetSlotName(self._slotData)
            GameTooltip:AddLine(name, 1, 1, 1)
            GameTooltip:AddLine("|cff888888" .. GetBarLabel(self._slotID or 0) .. "|r", 1, 1, 1)
            if self._slotData.type == "spell" then
                GameTooltip:SetSpellByID(self._slotData.id)
            end
            GameTooltip:Show()
        end
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return btn
end

local function ReleaseSlot(btn)
    btn:Hide()
    btn:ClearAllPoints()
    btn:SetParent(nil)
    btn._slotData = nil
    btn._slotID   = nil
    btn._onClick  = nil
    btn:SetScript("OnMouseUp", nil)
    btn._overlay:SetColorTexture(0, 0, 0, 0)
    btn:SetBackdropBorderColor(0.25, 0.25, 0.25, 0.8)
    slotPool[#slotPool + 1] = btn
end

-- Apply a tint overlay to a slot button: r,g,b,a  (0=clear)
local function TintSlot(btn, r, g, b, a)
    btn._overlay:SetColorTexture(r, g, b, a or 0.45)
end

-- Render a slot grid into `parent`, returning list of buttons and total height used.
-- slots:    { [slotID] = slotData }  (saved profile slots)
-- diffSet:  { [slotID] = true }      (slots to highlight as different, optional)
-- onClick:  function(slotID, slotData)  optional click handler
local function RenderSlotGrid(parent, slots, diffSet, onClick)
    -- Release children that are slot buttons
    if parent._slotBtns then
        for _, btn in ipairs(parent._slotBtns) do ReleaseSlot(btn) end
    end
    parent._slotBtns = {}
    if parent._slotLabels then
        for _, fs in ipairs(parent._slotLabels) do fs:Hide() end
    end
    parent._slotLabels = {}

    slots = slots or {}
    local usedBars = {}
    for _, bar in ipairs(ns.ACTION_BARS) do
        local hasContent = false
        for s = bar.startSlot, bar.endSlot do
            if slots[s] then hasContent = true; break end
        end
        if hasContent then usedBars[#usedBars + 1] = bar end
    end
    if #usedBars == 0 then return 0 end

    local y = 0
    for _, bar in ipairs(usedBars) do
        -- Bar label
        local lbl = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        lbl:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, y - 2)
        lbl:SetText("|cff66bbff" .. bar.label .. "|r")
        lbl:Show()
        parent._slotLabels[#parent._slotLabels + 1] = lbl
        y = y - 16

        -- 12 slots
        for col = 0, SLOTS_PER_ROW - 1 do
            local slotID = bar.startSlot + col
            local sd = slots[slotID]
            local btn = AcquireSlot(parent)
            btn:SetPoint("TOPLEFT", parent, "TOPLEFT",
                col * (SLOT_SZ + SLOT_GAP), y)
            btn._slotData = sd
            btn._slotID   = slotID

            if sd then
                local icon = GetSlotIcon(sd)
                btn._tex:SetTexture(icon)
                btn._tex:SetDesaturated(false)
                btn:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
                if diffSet and diffSet[slotID] then
                    TintSlot(btn, 1, 0.85, 0, 0.35)
                    btn:SetBackdropBorderColor(1, 0.85, 0, 1)
                end
            else
                btn._tex:SetTexture(nil)
                btn._tex:SetDesaturated(true)
                btn:SetBackdropBorderColor(0.15, 0.15, 0.15, 0.5)
                if diffSet and diffSet[slotID] then
                    TintSlot(btn, 0.2, 0.4, 1, 0.35)
                    btn:SetBackdropBorderColor(0.3, 0.5, 1, 1)
                end
            end

            if onClick then
                btn:SetScript("OnMouseUp", function(self) onClick(slotID, sd) end)
            end
            parent._slotBtns[#parent._slotBtns + 1] = btn
        end
        y = y - (SLOT_SZ + SLOT_GAP + 4)
    end
    return math.abs(y)
end

---------------------------------------------------------------------------
-- Merge helpers
---------------------------------------------------------------------------

-- Returns { [slotID] = { profA = slotData|nil, profB = slotData|nil, conflict = bool } }
local function BuildMergeTable(profNameA, profNameB)
    local ABP = ns.ActionBarProfiles
    local db  = ABP:GetDB()
    local cls = GetClassToken()
    local profs = ABP.GetClassProfiles(db)

    local slotsA = (profs[profNameA] and profs[profNameA].slots) or {}
    local slotsB = (profs[profNameB] and profs[profNameB].slots) or {}

    local union = {}
    for id in pairs(slotsA) do union[id] = true end
    for id in pairs(slotsB) do union[id] = true end

    local tbl = {}
    for id in pairs(union) do
        local a = slotsA[id]
        local b = slotsB[id]
        tbl[#tbl + 1] = {
            slotID   = id,
            profA    = a,
            profB    = b,
            conflict = not SlotsEqual(a, b),
        }
    end
    table.sort(tbl, function(x, y) return x.slotID < y.slotID end)
    return tbl, slotsA, slotsB
end

---------------------------------------------------------------------------
-- Window construction
---------------------------------------------------------------------------

local function MakeSection(parent, title)
    local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    f:SetBackdrop(BD)
    f:SetBackdropColor(0.06, 0.06, 0.10, 0.95)
    f:SetBackdropBorderColor(0.25, 0.35, 0.6, 0.8)
    if title then
        local lbl = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        lbl:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -6)
        lbl:SetText("|cffaaccff" .. title .. "|r")
        f._title = lbl
    end
    return f
end

local function MakeButton(parent, label, w, h)
    local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    btn:SetSize(w or 80, h or 22)
    btn:SetText(label)
    return btn
end

local function MakeDivider(parent, isVertical)
    local f = CreateFrame("Frame", nil, parent)
    if isVertical then
        f:SetWidth(1)
        local t = f:CreateTexture(nil, "BACKGROUND"); t:SetAllPoints()
        t:SetColorTexture(0.25, 0.35, 0.6, 0.4)
    else
        f:SetHeight(1)
        local t = f:CreateTexture(nil, "BACKGROUND"); t:SetAllPoints()
        t:SetColorTexture(0.25, 0.35, 0.6, 0.4)
    end
    return f
end

---------------------------------------------------------------------------
-- Scrollable container helper
---------------------------------------------------------------------------

local function MakeScrollFrame(parent, w, h)
    local scroll = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
    scroll:SetSize(w, h)
    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(w - 20, 1)
    scroll:SetScrollChild(child)
    return scroll, child
end

---------------------------------------------------------------------------
-- Sidebar: profile list
---------------------------------------------------------------------------

local function UpdateSidebarRows()
    if not window or not window._sidebar then return end
    local sb = window._sidebar
    if sb._rows then
        for _, r in ipairs(sb._rows) do r:Hide() end
    end
    sb._rows = {}

    local isTalent = (currentTab == "talent")
    local ABP = ns.ActionBarProfiles
    local TP  = ns.TalentProfiles
    if isTalent and not TP then return end
    if not isTalent and not ABP then return end
    local db     = isTalent and TP:GetDB() or ABP:GetDB()
    local cls    = GetClassToken()
    local list   = isTalent and TP.GetSortedProfileList() or ABP.GetSortedProfileList()
    local active = db.activeProfile[cls]

    local allProfs = isTalent and TP.GetClassProfiles(db) or ABP.GetClassProfiles(db)

    -- For talent tab: detect which profile matches current talents
    local matchingTalent = nil
    if isTalent and TP.FindMatchingProfile then
        matchingTalent = TP.FindMatchingProfile()
    end

    local y = 0
    for _, name in ipairs(list) do
        local prof = allProfs[name]
        if prof then

        local row = CreateFrame("Button", nil, sb._child)
        row:SetPoint("TOPLEFT", sb._child, "TOPLEFT", 0, y)
        row:SetPoint("RIGHT", sb._child, "RIGHT", 0, 0)
        row:SetHeight(36)
        row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight", "ADD")

        -- Tag color bar (left edge)
        -- For action bar: category tag color. For talent: green if matches current.
        if isTalent then
            local isMatch = (matchingTalent == name)
            local tagBar = row:CreateTexture(nil, "BACKGROUND")
            tagBar:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
            tagBar:SetSize(4, 36)
            tagBar:SetColorTexture(0.2, 0.9, 0.2, isMatch and 0.9 or 0.15)
        else
            local tag = ABP and ABP.GetProfileTag(name) or ""
            local tr, tg, tb = TagColor(tag)
            local tagBar = row:CreateTexture(nil, "BACKGROUND")
            tagBar:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
            tagBar:SetSize(4, 36)
            tagBar:SetColorTexture(tr, tg, tb, tag ~= "" and 0.9 or 0.2)
        end

        -- Merge checkbox (action bar only)
        local cb = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
        cb:SetSize(16, 16)
        cb:SetPoint("LEFT", row, "LEFT", 8, 0)
        cb:SetChecked(mergeSelected[name] or false)
        cb:SetScript("OnClick", function(self)
            mergeSelected[name] = self:GetChecked() or nil
            local n = 0; for _ in pairs(mergeSelected) do n = n + 1 end
            if window._mergeBtn then
                window._mergeBtn:SetEnabled(n >= 2)
                window._mergeBtn:SetText("Merge " .. (n > 0 and ("(" .. n .. ")") or ""))
            end
        end)
        cb:SetShown(mergeMode and not isTalent)
        row._cb = cb

        -- Selection highlight
        if name == selectedProfile then
            local sel = row:CreateTexture(nil, "BACKGROUND")
            sel:SetAllPoints()
            sel:SetColorTexture(0.15, 0.3, 0.6, 0.35)
        end

        -- Profile name
        local nameFS = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        nameFS:SetPoint("TOPLEFT", row, "TOPLEFT", 28, -6)
        nameFS:SetPoint("RIGHT", row, "RIGHT", -6, 0)
        if isTalent then
            local isMatch = (matchingTalent == name)
            if name == active and isMatch then
                nameFS:SetText("|cff44ff44" .. name .. "|r")
            elseif name == active then
                nameFS:SetText("|cffffcc00" .. name .. " (outdated)|r")
            elseif isMatch then
                nameFS:SetText("|cff88ddff" .. name .. " [current]|r")
            else
                nameFS:SetText(name)
            end
        else
            if name == active and ABP.profileModified then
                nameFS:SetText("|cffffcc00" .. name .. " *|r")
            elseif name == active then
                nameFS:SetText("|cff44ff44" .. name .. "|r")
            else
                nameFS:SetText(name)
            end
        end

        -- Meta line
        local metaFS = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        metaFS:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 28, 4)
        local metaStr = (prof.specName or "")
        if prof.savedAt then
            metaStr = metaStr .. "  " .. date("%Y-%m-%d", prof.savedAt)
        end
        if isTalent then
            local linked = TP:GetLinkedActionBarProfile(name)
            if linked and linked ~= "" then
                metaStr = metaStr .. "  |cff666688-> " .. linked .. "|r"
            end
        end
        metaFS:SetText(metaStr)

        row:SetScript("OnClick", function()
            selectedProfile = name
            PM:RefreshRightPanel()
            UpdateSidebarRows()
        end)

        sb._rows[#sb._rows + 1] = row
        y = y - 37
        end  -- if prof
    end
    sb._child:SetHeight(math.max(math.abs(y), 1))
end

---------------------------------------------------------------------------
-- Mini talent tree renderer
-- Draws a compact grid of talent node icons from parsed node data.
-- Returns total height used.
---------------------------------------------------------------------------

local TALENT_ICON_SZ  = 24
local TALENT_ICON_GAP = 2

-- Talent node icon pool (separate from slot pool)
local talentIconPool = {}

local function AcquireTalentIcon(parent)
    for i = #talentIconPool, 1, -1 do
        local btn = talentIconPool[i]
        table.remove(talentIconPool, i)
        btn:SetParent(parent)
        btn:Show()
        return btn
    end
    -- Create new
    local btn = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    btn:SetSize(TALENT_ICON_SZ, TALENT_ICON_SZ)
    btn:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\UI-SlotHighlight",
        edgeSize = 3, insets = { left = 1, right = 1, top = 1, bottom = 1 } })
    btn:SetBackdropColor(0.03, 0.03, 0.03, 1)
    btn:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.6)

    local tex = btn:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -2)
    tex:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -2, 2)
    tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    btn._tex = tex

    local rankFS = btn:CreateFontString(nil, "OVERLAY")
    rankFS:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
    rankFS:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -1, 1)
    btn._rankFS = rankFS

    btn:EnableMouse(true)
    btn:SetScript("OnEnter", function(self)
        if self._nodeName then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:ClearLines()
            GameTooltip:AddLine(self._nodeName, 1, 1, 1)
            if self._spellID then
                GameTooltip:SetSpellByID(self._spellID)
            end
            if self._rankText then
                GameTooltip:AddLine(self._rankText, 0.7, 0.7, 0.7)
            end
            GameTooltip:Show()
        end
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return btn
end

local function ReleaseTalentIcon(btn)
    btn:Hide()
    btn:ClearAllPoints()
    btn:SetParent(nil)
    btn._nodeName = nil
    btn._spellID  = nil
    btn._rankText = nil
    btn._tex:SetTexture(nil)
    btn._tex:SetDesaturated(false)
    btn._rankFS:SetText("")
    btn:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.6)
    talentIconPool[#talentIconPool + 1] = btn
end

local function RenderTalentTree(parent, nodes)
    -- Release previous icons
    if parent._talentIcons then
        for _, btn in ipairs(parent._talentIcons) do ReleaseTalentIcon(btn) end
    end
    parent._talentIcons = {}
    if parent._talentLabels then
        for _, fs in ipairs(parent._talentLabels) do fs:Hide() end
    end
    parent._talentLabels = {}

    if not nodes or #nodes == 0 then return 0 end

    -- Count selected vs total
    local selectedCount = 0
    for _, n in ipairs(nodes) do
        if n.isSelected then selectedCount = selectedCount + 1 end
    end

    -- Summary line
    local summaryFS = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    summaryFS:SetPoint("TOPLEFT", parent, "TOPLEFT", 6, -4)
    summaryFS:SetText("|cff44ff44" .. selectedCount .. "|r / " .. #nodes
        .. " talents selected")
    parent._talentLabels[#parent._talentLabels + 1] = summaryFS

    -- Quantize positions into a grid to prevent overlap.
    -- 1. Find unique sorted X and Y positions
    local xMap, yMap = {}, {}
    for _, n in ipairs(nodes) do
        xMap[n.posX] = true
        yMap[n.posY] = true
    end
    local xList, yList = {}, {}
    for x in pairs(xMap) do xList[#xList + 1] = x end
    for y in pairs(yMap) do yList[#yList + 1] = y end
    table.sort(xList)
    table.sort(yList)

    -- 2. Build index lookup: posX → column, posY → row
    local xIndex, yIndex = {}, {}
    for i, x in ipairs(xList) do xIndex[x] = i end
    for i, y in ipairs(yList) do yIndex[y] = i end

    local numCols = #xList
    local numRows = #yList

    -- 3. Calculate cell size based on available width
    local parentW = parent:GetWidth() or CONTENT_W
    local availW = parentW - 12
    local cellW = math.floor(availW / math.max(numCols, 1))
    cellW = math.max(math.min(cellW, 28), 18)  -- clamp 18..28
    local cellH = cellW  -- square cells

    -- Center the grid horizontally
    local gridW = numCols * cellW
    local offsetX = math.max(math.floor((availW - gridW) / 2), 0)
    local offsetY = 18  -- below summary line

    -- Dynamically size icons to fit
    local iconSz = cellW - 2

    local totalH = 0
    for _, n in ipairs(nodes) do
        local col = xIndex[n.posX] - 1
        local row = yIndex[n.posY] - 1
        local px = offsetX + col * cellW
        local py = -(offsetY + row * cellH)

        local btn = AcquireTalentIcon(parent)
        btn:SetSize(iconSz, iconSz)
        btn._tex:SetPoint("TOPLEFT", btn, "TOPLEFT", 1, -1)
        btn._tex:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -1, 1)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", px, py)
        btn._nodeName = n.name
        btn._spellID  = n.spellID

        if n.icon then
            btn._tex:SetTexture(n.icon)
        else
            btn._tex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        end

        if n.isSelected then
            btn._tex:SetDesaturated(false)
            btn:SetBackdropColor(0.03, 0.03, 0.03, 1)
            if n.isChoiceNode then
                btn:SetBackdropBorderColor(0.2, 0.8, 1, 1)
            elseif n.isGranted then
                btn:SetBackdropBorderColor(0.6, 0.6, 0.2, 0.8)
            else
                btn:SetBackdropBorderColor(0.4, 1, 0.4, 0.9)
            end
            if n.maxRanks > 1 and n.ranksPurchased > 0 then
                btn._rankFS:SetText("|cffffffff" .. n.ranksPurchased .. "/" .. n.maxRanks .. "|r")
                btn._rankText = "Rank " .. n.ranksPurchased .. "/" .. n.maxRanks
            end
        else
            btn._tex:SetDesaturated(true)
            btn:SetBackdropBorderColor(0.12, 0.12, 0.12, 0.3)
            btn:SetBackdropColor(0.02, 0.02, 0.02, 0.4)
        end

        parent._talentIcons[#parent._talentIcons + 1] = btn
        local nodeBottom = math.abs(py) + iconSz
        if nodeBottom > totalH then totalH = nodeBottom end
    end

    return totalH + 8
end

---------------------------------------------------------------------------
-- Right panel: unified cleanup (called before any render)
---------------------------------------------------------------------------

local function CleanupRightPanel()
    if not window or not window._rightPanel then return end
    local rp = window._rightPanel

    -- Clean up slot grid
    if rp._gridParent then
        if rp._gridParent._slotBtns then
            for _, b in ipairs(rp._gridParent._slotBtns) do ReleaseSlot(b) end
        end
        if rp._gridParent._slotLabels then
            for _, fs in ipairs(rp._gridParent._slotLabels) do fs:Hide() end
        end
        rp._gridParent:Hide()
        rp._gridParent:SetParent(nil)
        rp._gridParent = nil
    end

    -- Clean up talent body
    if rp._talentBody then
        rp._talentBody:Hide()
        rp._talentBody:SetParent(nil)
        rp._talentBody = nil
    end

    -- Clean up talent tree frame (release pooled icons)
    if rp._talentTreeFrame then
        if rp._talentTreeFrame._talentIcons then
            for _, btn in ipairs(rp._talentTreeFrame._talentIcons) do ReleaseTalentIcon(btn) end
        end
        if rp._talentTreeFrame._talentLabels then
            for _, fs in ipairs(rp._talentTreeFrame._talentLabels) do fs:Hide() end
        end
        rp._talentTreeFrame:Hide()
        rp._talentTreeFrame:SetParent(nil)
        rp._talentTreeFrame = nil
    end

    -- Clean up merge rows
    local sc = rp._scrollChild
    if sc and sc._mergeRows then
        for _, c in ipairs(sc._mergeRows) do c:Hide() end
        sc._mergeRows = nil
    end

    -- Clean up legend, header, empty msg
    if rp._legend   then rp._legend:Hide();   rp._legend   = nil end
    if rp._header   then rp._header:Hide() end
    if rp._emptyMsg then rp._emptyMsg:Hide() end

    -- Hide merge save bar
    if window._mergeSaveBar then window._mergeSaveBar:Hide() end
end

---------------------------------------------------------------------------
-- Right panel: profile detail + slot grid
---------------------------------------------------------------------------

local function RenderDetailPanel()
    local rp = window._rightPanel
    if not rp then return end
    CleanupRightPanel()

    local ABP = ns.ActionBarProfiles
    if not ABP or not selectedProfile then
        if rp._emptyMsg then rp._emptyMsg:Show() else
            local em = rp._scrollChild:CreateFontString(nil,"OVERLAY","GameFontDisable")
            em:SetPoint("TOPLEFT", rp._scrollChild, "TOPLEFT", 20, -40)
            em:SetText("< Select a profile from the list")
            rp._emptyMsg = em
        end
        return
    end
    if rp._emptyMsg then rp._emptyMsg:Hide() end

    local db    = ABP:GetDB()
    local cls   = GetClassToken()
    local profs = ABP.GetClassProfiles(db)
    local prof  = profs[selectedProfile]
    if not prof then return end

    local sc    = rp._scrollChild
    local active = db.activeProfile[cls]

    -- Header inside scroll child
    if not rp._header then
        local hdr = CreateFrame("Frame", nil, sc, "BackdropTemplate")
        hdr:SetPoint("TOPLEFT", sc, "TOPLEFT", 0, 0)
        hdr:SetPoint("RIGHT",   sc, "RIGHT",   0, 0)
        hdr:SetHeight(54)
        hdr:SetBackdrop(BD)
        hdr:SetBackdropColor(0.08, 0.12, 0.20, 1)
        hdr:SetBackdropBorderColor(0.2, 0.35, 0.7, 0.8)

        local nameFS = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        nameFS:SetPoint("TOPLEFT", hdr, "TOPLEFT", 10, -8)
        hdr._nameFS = nameFS

        local metaFS = hdr:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        metaFS:SetPoint("BOTTOMLEFT", hdr, "BOTTOMLEFT", 10, 6)
        hdr._metaFS = metaFS

        local statusFS = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        statusFS:SetPoint("TOPRIGHT", hdr, "TOPRIGHT", -10, -10)
        hdr._statusFS = statusFS

        rp._header = hdr
    end

    -- Populate header
    rp._header:Show()
    local isActive = (selectedProfile == active)
    local isDirty  = isActive and ABP.profileModified
    rp._header._nameFS:SetText(
        (isActive and isDirty  and "|cffffcc00[*] " or "")
        .. (isActive and not isDirty and "|cff44ff44" or "")
        .. (not isActive and "|cff888888" or "")
        .. selectedProfile .. "|r")
    local metaStr = (prof.specName or "Unknown Spec")
    if prof.savedAt then metaStr = metaStr .. "  |  " .. date("%Y-%m-%d %H:%M", prof.savedAt) end
    if prof.savedBy then metaStr = metaStr .. "  |  " .. prof.savedBy end
    rp._header._metaFS:SetText("|cff888888" .. metaStr .. "|r")
    rp._header._statusFS:SetText(
        isActive and (isDirty and "|cffffcc00Modified|r" or "|cff44ff44Active|r") or "")

    -- Build diff set vs current bars for highlighting
    local currentSlots = ABP.ReadCurrentSlots()
    local diffSet = {}
    if isActive and isDirty then
        local diffs = DiffSlots(prof.slots, currentSlots)
        for _, d in ipairs(diffs) do diffSet[d.slotID] = true end
    end

    -- Render slot grid below header
    local gridParent = CreateFrame("Frame", nil, sc)
    gridParent:SetPoint("TOPLEFT", rp._header, "BOTTOMLEFT", 0, -8)
    gridParent:SetPoint("RIGHT", sc, "RIGHT", 0, 0)
    gridParent:SetHeight(1)
    rp._gridParent = gridParent

    local gridH = RenderSlotGrid(gridParent, prof.slots, next(diffSet) and diffSet or nil)
    gridParent:SetHeight(gridH + 4)
    sc:SetHeight(rp._header:GetHeight() + 8 + gridH + 16)

    -- Diff legend (only shown when active & dirty)
    if isActive and isDirty and next(diffSet) then
        local legend = sc:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        legend:SetPoint("TOPLEFT", gridParent, "BOTTOMLEFT", 0, -6)
        legend:SetText("|cffffcc00[!]|r Highlighted slots differ from current bars")
        sc:SetHeight(sc:GetHeight() + 20)
        rp._legend = legend
    elseif rp._legend then
        rp._legend:Hide()
    end
end

---------------------------------------------------------------------------
-- Right panel: merge view (2-profile comparison)
---------------------------------------------------------------------------

local function RenderMergePanel(nameA, nameB)
    local rp = window._rightPanel
    if not rp then return end

    CleanupRightPanel()

    local sc = rp._scrollChild
    sc._mergeRows = {}

    local ABP = ns.ActionBarProfiles
    local tbl, slotsA, slotsB = BuildMergeTable(nameA, nameB)
    mergeResult = {}

    -- Auto-resolve non-conflicts
    for _, row in ipairs(tbl) do
        if not row.conflict then
            mergeResult[row.slotID] = { prof = nameA, data = row.profA or row.profB }
        end
    end

    local COL_W = math.floor((CONTENT_W - 120) / 3)
    local COL_A = 120
    local COL_B = COL_A + COL_W + 4
    local COL_R = COL_B + COL_W + 4

    -- Column headers
    local function MakeColHdr(x, label, color)
        local fs = sc:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fs:SetPoint("TOPLEFT", sc, "TOPLEFT", x, 0)
        fs:SetWidth(COL_W)
        fs:SetJustifyH("CENTER")
        fs:SetText("|cff" .. (color or "aaccff") .. label .. "|r")
        sc._mergeRows[#sc._mergeRows + 1] = { Hide = function() fs:Hide() end }
        return fs
    end
    MakeColHdr(0,     "Slot",   "888888")
    MakeColHdr(COL_A, nameA,    "66bbff")
    MakeColHdr(COL_B, nameB,    "ff9944")
    MakeColHdr(COL_R, "Result", "44ff88")

    local y = -22

    -- One row per slot entry
    local conflictCount = 0
    for _, entry in ipairs(tbl) do
        if entry.conflict then conflictCount = conflictCount + 1 end

        local rowH = 36
        local rowBG = CreateFrame("Frame", nil, sc, "BackdropTemplate")
        sc._mergeRows[#sc._mergeRows + 1] = rowBG
        rowBG:SetPoint("TOPLEFT", sc, "TOPLEFT", 0, y)
        rowBG:SetPoint("RIGHT",   sc, "RIGHT",  0, 0)
        rowBG:SetHeight(rowH)
        rowBG:SetBackdrop(BD)
        if entry.conflict then
            rowBG:SetBackdropColor(0.20, 0.15, 0.03, 0.9)
            rowBG:SetBackdropBorderColor(0.8, 0.6, 0.0, 0.6)
        else
            rowBG:SetBackdropColor(0.06, 0.10, 0.06, 0.8)
            rowBG:SetBackdropBorderColor(0.15, 0.35, 0.15, 0.5)
        end

        -- Slot label
        local slotLbl = rowBG:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        slotLbl:SetPoint("LEFT", rowBG, "LEFT", 4, 0)
        slotLbl:SetWidth(COL_A - 8)
        slotLbl:SetWordWrap(true)
        slotLbl:SetText(GetBarLabel(entry.slotID))

        -- Helper: render a profile cell at x offset
        local function MakeCell(x, sd, profName)
            local cell = CreateFrame("Button", nil, rowBG, "BackdropTemplate")
            cell:SetPoint("TOPLEFT", rowBG, "TOPLEFT", x, -2)
            cell:SetSize(COL_W, rowH - 4)
            cell:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                edgeSize = 8, insets = { left = 2, right = 2, top = 2, bottom = 2 } })

            local isWinner = mergeResult[entry.slotID] and mergeResult[entry.slotID].prof == profName
            if isWinner then
                cell:SetBackdropColor(0.05, 0.25, 0.05, 0.9)
                cell:SetBackdropBorderColor(0.1, 0.9, 0.1, 1)
            elseif sd then
                cell:SetBackdropColor(0.08, 0.08, 0.12, 0.8)
                cell:SetBackdropBorderColor(0.25, 0.25, 0.4, 0.7)
            else
                cell:SetBackdropColor(0.04, 0.04, 0.04, 0.6)
                cell:SetBackdropBorderColor(0.15, 0.15, 0.15, 0.4)
            end

            if sd then
                local icon = cell:CreateTexture(nil, "ARTWORK")
                icon:SetSize(28, 28)
                icon:SetPoint("LEFT", cell, "LEFT", 4, 0)
                icon:SetTexture(GetSlotIcon(sd))
                icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

                local lbl = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                lbl:SetPoint("LEFT", icon, "RIGHT", 4, 0)
                lbl:SetPoint("RIGHT", cell, "RIGHT", -4, 0)
                lbl:SetWordWrap(false)
                lbl:SetText(GetSlotName(sd))
            else
                local lbl = cell:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
                lbl:SetAllPoints()
                lbl:SetJustifyH("CENTER")
                lbl:SetText("(empty)")
            end

            -- Click to select this as winner
            if entry.conflict and profName ~= "result" then
                cell:SetScript("OnClick", function()
                    mergeResult[entry.slotID] = sd and { prof = profName, data = sd } or nil
                    RenderMergePanel(nameA, nameB)
                end)
                cell:SetScript("OnEnter", function(self)
                    self:SetBackdropBorderColor(1, 1, 0, 1)
                end)
                cell:SetScript("OnLeave", function(self)
                    if mergeResult[entry.slotID] and mergeResult[entry.slotID].prof == profName then
                        self:SetBackdropBorderColor(0.1, 0.9, 0.1, 1)
                    else
                        self:SetBackdropBorderColor(0.25, 0.25, 0.4, 0.7)
                    end
                end)
            end
            return cell
        end

        MakeCell(COL_A, entry.profA, nameA)
        MakeCell(COL_B, entry.profB, nameB)

        -- Result cell
        local winner = mergeResult[entry.slotID]
        MakeCell(COL_R, winner and winner.data, "result")

        y = y - (rowH + 3)
    end

    -- Conflict count + resolve info
    local resolved = 0
    for _, entry in ipairs(tbl) do
        if entry.conflict and mergeResult[entry.slotID] then resolved = resolved + 1 end
    end

    local summary = sc:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sc._mergeRows[#sc._mergeRows + 1] = { Hide = function() summary:Hide() end }
    summary:SetPoint("TOPLEFT", sc, "TOPLEFT", 0, y - 6)
    if conflictCount == 0 then
        summary:SetText("|cff44ff44No conflicts - profiles are compatible.|r")
    else
        local remaining = conflictCount - resolved
        if remaining > 0 then
            summary:SetText("|cffffcc00" .. remaining .. " conflict(s) unresolved. Click a cell to pick the winner.|r")
        else
            summary:SetText("|cff44ff44All conflicts resolved. Ready to save.|r")
        end
    end
    y = y - 24

    sc:SetHeight(math.max(math.abs(y), 1))

    -- Save bar at bottom of window (not in scroll)
    if window._mergeSaveBar then window._mergeSaveBar:Show()
    else
        local bar = CreateFrame("Frame", nil, window._rightPanelOuter, "BackdropTemplate")
        bar:SetPoint("BOTTOMLEFT",  window._rightPanelOuter, "BOTTOMLEFT",  0, 0)
        bar:SetPoint("BOTTOMRIGHT", window._rightPanelOuter, "BOTTOMRIGHT", 0, 0)
        bar:SetHeight(40)
        bar:SetBackdrop(BD)
        bar:SetBackdropColor(0.06, 0.10, 0.06, 1)
        bar:SetBackdropBorderColor(0.2, 0.5, 0.2, 0.8)

        local saveLabel = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        saveLabel:SetPoint("LEFT", bar, "LEFT", 8, 0)
        saveLabel:SetText("Save merged as:")

        local eb = CreateFrame("EditBox", nil, bar, "InputBoxTemplate")
        eb:SetPoint("LEFT", saveLabel, "RIGHT", 6, 0)
        eb:SetSize(180, 22)
        eb:SetAutoFocus(false)
        eb:SetText(nameA .. " + " .. nameB)

        local saveBtn = MakeButton(bar, "Save Merged", 100, 24)
        saveBtn:SetPoint("LEFT", eb, "RIGHT", 6, 0)
        saveBtn:SetScript("OnClick", function()
            local newName = strtrim(eb:GetText())
            if newName == "" then return end
            -- Build merged slots
            local merged = {}
            for slotID, w in pairs(mergeResult) do
                if w and w.data then merged[slotID] = w.data end
            end
            -- Save as new profile
            local ABP = ns.ActionBarProfiles
            local db  = ABP:GetDB()
            local cls = GetClassToken()
            local profs = ABP.GetClassProfiles(db)
            local specIdx = C_SpecializationInfo.GetSpecialization and C_SpecializationInfo.GetSpecialization() or 0
            local specID, specName = 0, ""
            if specIdx and specIdx > 0 then specID, specName = C_SpecializationInfo.GetSpecializationInfo(specIdx) end
            profs[newName] = {
                slots    = merged,
                slotCount = 180,
                savedAt  = time(),
                savedBy  = UnitName("player") .. " - " .. GetRealmName(),
                specID   = specID or 0,
                specName = specName or "",
            }
            ABP:UpdateData()
            ns.Notify("Merged profile saved: " .. newName, "success")
            mergeMode = false
            mergeSelected = {}
            mergeResult = {}
            window._mergeSaveBar:Hide()
            selectedProfile = newName
            PM:Refresh()
        end)

        local cancelBtn = MakeButton(bar, "Cancel", 70, 24)
        cancelBtn:SetPoint("LEFT", saveBtn, "RIGHT", 4, 0)
        cancelBtn:SetScript("OnClick", function()
            mergeMode = false
            mergeSelected = {}
            mergeResult = {}
            window._mergeSaveBar:Hide()
            PM:RefreshRightPanel()
            UpdateSidebarRows()
        end)

        window._mergeSaveBar = bar
    end
end

---------------------------------------------------------------------------
-- Right panel: talent profile detail
---------------------------------------------------------------------------

local function RenderTalentDetailPanel()
    local rp = window._rightPanel
    if not rp then return end

    CleanupRightPanel()

    local TP = ns.TalentProfiles
    if not TP or not selectedProfile then
        if rp._emptyMsg then rp._emptyMsg:Show() else
            local em = rp._scrollChild:CreateFontString(nil, "OVERLAY", "GameFontDisable")
            em:SetPoint("TOPLEFT", rp._scrollChild, "TOPLEFT", 20, -40)
            em:SetText("< Select a talent profile from the list")
            rp._emptyMsg = em
        end
        return
    end
    if rp._emptyMsg then rp._emptyMsg:Hide() end

    local db    = TP:GetDB()
    local cls   = GetClassToken()
    local profs = db.profiles[cls] or {}
    local prof  = profs[selectedProfile]
    if not prof then return end

    local sc     = rp._scrollChild
    local active = db.activeProfile[cls]
    local isActive = (selectedProfile == active)

    -- Reuse/create header frame
    if not rp._header then
        local hdr = CreateFrame("Frame", nil, sc, "BackdropTemplate")
        hdr:SetPoint("TOPLEFT", sc, "TOPLEFT", 0, 0)
        hdr:SetPoint("RIGHT",   sc, "RIGHT",   0, 0)
        hdr:SetHeight(54)
        hdr:SetBackdrop(BD)
        hdr:SetBackdropColor(0.08, 0.12, 0.20, 1)
        hdr:SetBackdropBorderColor(0.2, 0.35, 0.7, 0.8)
        local nameFS = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        nameFS:SetPoint("TOPLEFT", hdr, "TOPLEFT", 10, -8)
        hdr._nameFS = nameFS
        local metaFS = hdr:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        metaFS:SetPoint("BOTTOMLEFT", hdr, "BOTTOMLEFT", 10, 6)
        hdr._metaFS = metaFS
        local statusFS = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        statusFS:SetPoint("TOPRIGHT", hdr, "TOPRIGHT", -10, -10)
        hdr._statusFS = statusFS
        rp._header = hdr
    end

    rp._header:Show()
    rp._header._nameFS:SetText(
        (isActive and "|cff44ff44" or "|cff888888") .. selectedProfile .. "|r")
    local metaStr = (prof.specName or "Unknown Spec")
    if prof.savedAt then metaStr = metaStr .. "  |  " .. date("%Y-%m-%d %H:%M", prof.savedAt) end
    if prof.savedBy then metaStr = metaStr .. "  |  " .. prof.savedBy end
    rp._header._metaFS:SetText("|cff888888" .. metaStr .. "|r")
    rp._header._statusFS:SetText(isActive and "|cff44ff44Active|r" or "")

    -- Talent body
    local body = CreateFrame("Frame", nil, sc)
    body:SetPoint("TOPLEFT", rp._header, "BOTTOMLEFT", 0, -8)
    body:SetPoint("RIGHT", sc, "RIGHT", 0, 0)
    rp._talentBody = body

    local y = 0

    -- Spec header
    local specLabel = body:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    specLabel:SetPoint("TOPLEFT", body, "TOPLEFT", 4, y)
    local specIDInfo = ""
    if prof.specID and prof.specID ~= 0 then
        -- Show spec icon if available
        local _, _, _, specIconID = GetSpecializationInfoByID(prof.specID)
        if specIconID then
            specIDInfo = "|T" .. specIconID .. ":18:18:0:0|t  "
        end
    end
    specLabel:SetText(specIDInfo .. "|cffaaccff" .. (prof.specName or "Unknown Spec") .. "|r"
        .. (prof.configName and prof.configName ~= "" and ("  |cff888888(" .. prof.configName .. ")|r") or ""))
    y = y - 26

    -- Divider
    local div = body:CreateTexture(nil, "BACKGROUND")
    div:SetPoint("TOPLEFT", body, "TOPLEFT", 0, y)
    div:SetPoint("RIGHT", body, "RIGHT", -4, 0)
    div:SetHeight(1)
    div:SetColorTexture(0.25, 0.35, 0.6, 0.4)
    y = y - 10

    -- Talent string section
    local strLabel = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    strLabel:SetPoint("TOPLEFT", body, "TOPLEFT", 4, y)
    strLabel:SetText("|cff888888Talent Export String:|r")
    y = y - 18

    -- Read-only editbox displaying the talent string
    local strBG = CreateFrame("Frame", nil, body, "BackdropTemplate")
    strBG:SetPoint("TOPLEFT", body, "TOPLEFT", 4, y)
    strBG:SetPoint("RIGHT", body, "RIGHT", -4, 0)
    strBG:SetHeight(52)
    strBG:SetBackdrop(BD)
    strBG:SetBackdropColor(0.04, 0.04, 0.06, 1)
    strBG:SetBackdropBorderColor(0.2, 0.25, 0.4, 0.8)

    local strEB = CreateFrame("EditBox", nil, strBG)
    strEB:SetMultiLine(false)
    strEB:SetAutoFocus(false)
    strEB:SetFontObject("GameFontHighlightSmall")
    strEB:SetPoint("TOPLEFT",     strBG, "TOPLEFT",     8, -8)
    strEB:SetPoint("BOTTOMRIGHT", strBG, "BOTTOMRIGHT", -8,  8)
    strEB:SetText(prof.talentString or "")
    strEB:SetCursorPosition(0)
    strEB:SetScript("OnEscapePressed", function(s) s:ClearFocus() end)
    -- Select all on focus for easy copy
    strEB:SetScript("OnEditFocusGained", function(s) s:HighlightText() end)
    y = y - 58

    -- Copy button
    local copyBtn = MakeButton(body, "Copy String", 100, 22)
    copyBtn:SetPoint("TOPLEFT", body, "TOPLEFT", 4, y)
    copyBtn:SetScript("OnClick", function()
        if prof.talentString then
            DCP:CopyToClipboard(prof.talentString, "Talent Build: " .. selectedProfile)
        end
    end)

    -- Load button (inline, next to copy)
    local loadTalBtn = MakeButton(body, isActive and "Reload Talents" or "Load Talents", 120, 22)
    loadTalBtn:SetPoint("LEFT", copyBtn, "RIGHT", 6, 0)
    loadTalBtn:SetScript("OnClick", function()
        local TP2 = ns.TalentProfiles
        if TP2 then TP2.RestoreProfile(selectedProfile) end
        PM:Refresh()
    end)
    y = y - 30

    -- Mini talent tree visualization
    if prof.talentString and TP.ParseTalentExportString then
        local treeLabel = body:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        treeLabel:SetPoint("TOPLEFT", body, "TOPLEFT", 4, y)
        treeLabel:SetText("|cffaaccffTalent Tree Preview:|r")
        y = y - 20

        local treeFrame = CreateFrame("Frame", nil, body, "BackdropTemplate")
        treeFrame:SetPoint("TOPLEFT", body, "TOPLEFT", 0, y)
        treeFrame:SetPoint("RIGHT", body, "RIGHT", 0, 0)
        treeFrame:SetBackdrop(BD)
        treeFrame:SetBackdropColor(0.03, 0.04, 0.06, 1)
        treeFrame:SetBackdropBorderColor(0.15, 0.25, 0.45, 0.6)
        rp._talentTreeFrame = treeFrame

        local nodes = TP.ParseTalentExportString(prof.talentString)
        if nodes and #nodes > 0 then
            local treeH = RenderTalentTree(treeFrame, nodes)
            treeFrame:SetHeight(treeH + 8)
            y = y - (treeH + 16)

            -- Legend
            local legend = body:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            legend:SetPoint("TOPLEFT", body, "TOPLEFT", 4, y)
            legend:SetText("|cff44ff44Green|r = selected   |cff999933Yellow|r = granted   |cff4499ffBlue|r = choice   |cff333333Gray|r = unselected")
            y = y - 16
        else
            treeFrame:SetHeight(30)
            local noData = treeFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            noData:SetPoint("CENTER", treeFrame, "CENTER", 0, 0)
            noData:SetText("Unable to parse talent tree (different spec or version)")
            y = y - 38
        end
    end

    -- Linked action bar profile (interactive dropdown)
    local ABP = ns.ActionBarProfiles
    if ABP then
        local linked = TP:GetLinkedActionBarProfile(selectedProfile)

        local linkLabel = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        linkLabel:SetPoint("TOPLEFT", body, "TOPLEFT", 4, y)
        linkLabel:SetText("|cff888888Linked Action Bar Profile:|r")
        y = y - 18

        local linkDD = CreateFrame("DropdownButton", nil, body, "WowStyle1DropdownTemplate")
        linkDD:SetPoint("TOPLEFT", body, "TOPLEFT", 0, y)
        linkDD:SetWidth(220)
        local capturedProf = selectedProfile
        linkDD:SetupMenu(function(_, root)
            -- "(none)" option to unlink
            root:CreateButton("|cff888888(none - no link)|r", function()
                TP:SetLinkedActionBarProfile(capturedProf, nil)
                ns.Notify("Unlinked action bar profile from " .. capturedProf, "success")
                PM:RefreshRightPanel()
            end)
            -- List all action bar profiles for this class
            local abList = ABP.GetSortedProfileList()
            for _, abName in ipairs(abList) do
                local n = abName
                local isLinked = (linked == n)
                root:CreateButton(
                    (isLinked and "|cff44ff44" or "") .. n .. (isLinked and " [linked]" or "") .. "|r",
                    function()
                        TP:SetLinkedActionBarProfile(capturedProf, n)
                        ns.Notify("Linked: " .. capturedProf .. " -> " .. n, "success")
                        PM:RefreshRightPanel()
                    end)
            end
        end)
        y = y - 30

        -- Show current link status
        local linkStatus = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        linkStatus:SetPoint("TOPLEFT", body, "TOPLEFT", 4, y)
        if linked and linked ~= "" then
            linkStatus:SetText("|cff44ff44Currently linked to:|r  |cffffffff" .. linked .. "|r")
        else
            linkStatus:SetText("|cff555555No action bar profile linked. Loading this talent profile will not affect action bars.|r")
        end
        linkStatus:SetWidth(CONTENT_W - 20)
        linkStatus:SetWordWrap(true)
        y = y - 20
    end

    body:SetHeight(math.abs(y) + 8)
    sc:SetHeight(rp._header:GetHeight() + 8 + math.abs(y) + 16)
end

---------------------------------------------------------------------------
-- UpdateActionBar — bottom button state
---------------------------------------------------------------------------

local function UpdateActionBar()
    if not window or not window._actionBar then return end
    local ab = window._actionBar
    if not selectedProfile then
        for _, btn in ipairs(ab._btns or {}) do btn:SetEnabled(false) end
        return
    end

    for _, btn in ipairs(ab._btns or {}) do btn:SetEnabled(true) end

    if currentTab == "talent" then
        local TP  = ns.TalentProfiles
        local db  = TP and TP:GetDB()
        local cls = GetClassToken()
        if ab._loadBtn then
            local active = db and db.activeProfile[cls]
            ab._loadBtn:SetText(selectedProfile == active and "Reload" or "Load")
        end
    else
        local ABP = ns.ActionBarProfiles
        local db  = ABP and ABP:GetDB()
        local cls = GetClassToken()
        if ab._loadBtn then
            local active = db and db.activeProfile[cls]
            ab._loadBtn:SetText(selectedProfile == active and "Reload" or "Load")
        end
    end
end

---------------------------------------------------------------------------
-- Create main window
---------------------------------------------------------------------------

local function CreateWindow()
    if window then return window end

    local f = CreateFrame("Frame", "DCPProfileManager", UIParent, "BackdropTemplate")
    f:SetSize(W, H)
    f:SetPoint("CENTER")
    f:SetFrameStrata("MEDIUM")
    f:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        edgeSize = 26, insets = { left = 7, right = 7, top = 7, bottom = 7 } })
    f:SetBackdropColor(0.05, 0.06, 0.10, 0.97)
    f:SetBackdropBorderColor(0.35, 0.5, 0.9, 0.9)
    f:SetMovable(true)
    f:SetResizable(true)
    f:SetResizeBounds(600, 400, 1200, 900)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)
    f:SetClampedToScreen(true)
    f:Hide()

    -- ── Title bar ────────────────────────────────────────────
    local titleBar = CreateFrame("Frame", nil, f)
    titleBar:SetPoint("TOPLEFT",  f, "TOPLEFT",  8, -8)
    titleBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -8, -8)
    titleBar:SetHeight(28)

    local titleFS = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleFS:SetPoint("LEFT", titleBar, "LEFT", 4, 0)
    titleFS:SetText("|cff33ccffClass Profiles|r")

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
    closeBtn:SetSize(26, 26)
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    local divTop = MakeDivider(f, false)
    divTop:SetPoint("TOPLEFT",  f, "TOPLEFT",  8, -36)
    divTop:SetPoint("TOPRIGHT", f, "TOPRIGHT", -8, -36)

    -- ── Tab bar ──────────────────────────────────────────────
    local tabY = -38
    local TABS = {
        { key = "actionbar", label = "Action Bars" },
        { key = "talent",    label = "Talents" },
    }
    local tabBtns = {}
    local tabX = 12
    for _, tab in ipairs(TABS) do
        local btn = CreateFrame("Button", nil, f, "BackdropTemplate")
        btn:SetSize(100, 24)
        btn:SetPoint("TOPLEFT", f, "TOPLEFT", tabX, tabY)
        btn:SetBackdrop(BD)
        btn:EnableMouse(true)

        local lbl = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        lbl:SetAllPoints()
        lbl:SetJustifyH("CENTER")
        lbl:SetText(tab.label)

        local key = tab.key
        btn:SetScript("OnClick", function()
            currentTab = key
            selectedProfile = nil
            mergeMode = false
            mergeSelected = {}
            for _, b in ipairs(tabBtns) do
                if b._key == key then
                    b:SetBackdropColor(0.1, 0.15, 0.3, 1)
                    b:SetBackdropBorderColor(0.4, 0.6, 1, 1)
                else
                    b:SetBackdropColor(0.04, 0.06, 0.10, 0.8)
                    b:SetBackdropBorderColor(0.2, 0.3, 0.5, 0.5)
                end
            end
            UpdateSidebarRows()
            PM:RefreshRightPanel()
        end)
        btn._key  = key
        btn._label = lbl
        btn:SetBackdropColor(0.04, 0.06, 0.10, 0.8)
        btn:SetBackdropBorderColor(0.2, 0.3, 0.5, 0.5)
        tabBtns[#tabBtns + 1] = btn
        tabX = tabX + 106
    end
    -- Highlight first tab
    tabBtns[1]:SetBackdropColor(0.1, 0.15, 0.3, 1)
    tabBtns[1]:SetBackdropBorderColor(0.4, 0.6, 1, 1)
    f._tabBtns = tabBtns

    local divTab = MakeDivider(f, false)
    divTab:SetPoint("TOPLEFT",  f, "TOPLEFT",  8, -64)
    divTab:SetPoint("TOPRIGHT", f, "TOPRIGHT", -8, -64)

    -- ── Sidebar ──────────────────────────────────────────────
    local sidebarOuter = MakeSection(f, nil)
    sidebarOuter:SetPoint("TOPLEFT",    f, "TOPLEFT",    8, -66)
    sidebarOuter:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 8, 8)
    sidebarOuter:SetWidth(SIDEBAR_W)

    local sideScroll, sideChild = MakeScrollFrame(sidebarOuter, SIDEBAR_W - 6, H - 66 - 72)
    sideScroll:SetPoint("TOPLEFT",    sidebarOuter, "TOPLEFT",    3, -3)
    sideScroll:SetPoint("BOTTOMLEFT", sidebarOuter, "BOTTOMLEFT", 3, 66)

    sidebarOuter._scroll = sideScroll
    sidebarOuter._child  = sideChild
    f._sidebar = sidebarOuter

    -- Bottom row of sidebar: Save Current + Merge button
    local newBtn = MakeButton(sidebarOuter, "Save Current", SIDEBAR_W - 80, 22)
    newBtn:SetPoint("BOTTOMLEFT",  sidebarOuter, "BOTTOMLEFT",  4, 6)
    f._sidebarSaveBtn = newBtn
    newBtn:SetScript("OnClick", function()
        if currentTab == "talent" then
            StaticPopupDialogs["DCP_PM_TALENT_SAVEAS"] = {
                text = "Save current talents as profile:",
                button1 = "Save", button2 = "Cancel", hasEditBox = true,
                OnAccept = function(self)
                    local name = strtrim(self.EditBox:GetText())
                    if name ~= "" then
                        local TP = ns.TalentProfiles
                        if TP then TP.SaveProfile(name); PM:Refresh() end
                    end
                end,
                timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
            }
            StaticPopup_Show("DCP_PM_TALENT_SAVEAS")
        else
            StaticPopupDialogs["DCP_PM_SAVEAS"] = {
                text = "Save current action bars as profile:",
                button1 = "Save", button2 = "Cancel", hasEditBox = true,
                OnAccept = function(self)
                    local name = strtrim(self.EditBox:GetText())
                    if name ~= "" then
                        local ABP = ns.ActionBarProfiles
                        if ABP then ABP.SaveProfile(name); PM:Refresh() end
                    end
                end,
                timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
            }
            StaticPopup_Show("DCP_PM_SAVEAS")
        end
    end)

    local mergeToggleBtn = MakeButton(sidebarOuter, "Merge", 62, 22)
    mergeToggleBtn:SetPoint("BOTTOMRIGHT", sidebarOuter, "BOTTOMRIGHT", -4, 6)
    mergeToggleBtn:SetScript("OnClick", function()
        mergeMode = not mergeMode
        mergeSelected = {}
        mergeResult = {}
        if not mergeMode and window._mergeSaveBar then window._mergeSaveBar:Hide() end
        UpdateSidebarRows()
        if mergeMode then
            selectedProfile = nil
            PM:RefreshRightPanel()
        end
    end)
    f._mergeBtn = mergeToggleBtn

    -- Talent-only: "Import Game Loadouts" button (second bottom row)
    local importBtn = MakeButton(sidebarOuter, "Import Game Loadouts", SIDEBAR_W - 8, 22)
    importBtn:SetPoint("BOTTOMLEFT", sidebarOuter, "BOTTOMLEFT", 4, 32)
    importBtn:SetScript("OnClick", function()
        local TP = ns.TalentProfiles
        if not TP or not TP.ImportFromBlizzardLoadouts then
            ns.Notify("Talent module not available.", "error")
            return
        end
        StaticPopupDialogs["DCP_PM_IMPORT_BLIZZ"] = {
            text = "Import all saved game talent loadouts as DCP talent profiles?\n\nExisting profiles with the same name will be |cffffcc00skipped|r.",
            button1 = "Import", button2 = "Cancel",
            OnAccept = function()
                TP.ImportFromBlizzardLoadouts(false)
                PM:Refresh()
            end,
            timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
        }
        StaticPopup_Show("DCP_PM_IMPORT_BLIZZ")
    end)
    f._importGameBtn = importBtn
    importBtn:Hide()  -- hidden by default; shown when talent tab is active

    -- Divider between sidebar and right panel
    local divV = MakeDivider(f, true)
    divV:SetPoint("TOPLEFT",    f, "TOPLEFT",    SIDEBAR_W + 9, -66)
    divV:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", SIDEBAR_W + 9, 8)

    -- ── Right panel ──────────────────────────────────────────
    local rightOuter = MakeSection(f, nil)
    rightOuter:SetPoint("TOPLEFT",     f, "TOPLEFT",     SIDEBAR_W + 12, -66)
    rightOuter:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 50)
    f._rightPanelOuter = rightOuter

    local rpScroll, rpChild = MakeScrollFrame(rightOuter, CONTENT_W + 12, H - 66 - 52)
    rpScroll:SetPoint("TOPLEFT",     rightOuter, "TOPLEFT",     3, -3)
    rpScroll:SetPoint("BOTTOMRIGHT", rightOuter, "BOTTOMRIGHT", -3, 3)

    local rp = {}
    rp._scroll      = rpScroll
    rp._scrollChild = rpChild
    f._rightPanel   = rp

    -- ── Bottom action bar ─────────────────────────────────────
    local ab = CreateFrame("Frame", nil, f, "BackdropTemplate")
    ab:SetPoint("BOTTOMLEFT",  f, "BOTTOMLEFT",  SIDEBAR_W + 12, 8)
    ab:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 8)
    ab:SetHeight(38)
    ab:SetBackdrop(BD)
    ab:SetBackdropColor(0.06, 0.08, 0.16, 1)
    ab:SetBackdropBorderColor(0.25, 0.35, 0.65, 0.8)
    f._actionBar = ab
    ab._btns = {}

    local function AB_Btn(label, w, anchor, anchorTo, xOff)
        local btn = MakeButton(ab, label, w, 26)
        btn:SetPoint("LEFT", anchorTo, anchor, xOff, 0)
        ab._btns[#ab._btns + 1] = btn
        return btn
    end

    local loadBtn = MakeButton(ab, "Load", 70, 26)
    loadBtn:SetPoint("LEFT", ab, "LEFT", 6, 0)
    ab._loadBtn = loadBtn
    loadBtn:SetScript("OnClick", function()
        if not selectedProfile then return end
        if currentTab == "talent" then
            local TP = ns.TalentProfiles
            if TP then TP.RestoreProfile(selectedProfile); PM:Refresh() end
        else
            local ABP = ns.ActionBarProfiles
            if ABP then ABP.RestoreProfile(selectedProfile, false); PM:Refresh() end
        end
    end)
    ab._btns[#ab._btns + 1] = loadBtn

    local saveBtn2 = AB_Btn("Save", 70, "RIGHT", loadBtn, 4)
    saveBtn2:SetScript("OnClick", function()
        if not selectedProfile then return end
        if currentTab == "talent" then
            local TP = ns.TalentProfiles
            if TP then
                StaticPopupDialogs["DCP_PM_TALENT_OVERWRITE"] = {
                    text = "Overwrite talent profile '|cff00cc00" .. selectedProfile .. "|r' with current talents?",
                    button1 = "Overwrite", button2 = "Cancel",
                    OnAccept = function() TP.SaveProfile(selectedProfile); PM:Refresh() end,
                    timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
                }
                StaticPopup_Show("DCP_PM_TALENT_OVERWRITE")
            end
        else
            local ABP = ns.ActionBarProfiles
            if not ABP then return end
            StaticPopupDialogs["DCP_PM_OVERWRITE"] = {
                text = "Overwrite profile '|cff00cc00" .. selectedProfile .. "|r' with current bars?",
                button1 = "Overwrite", button2 = "Cancel",
                OnAccept = function() ABP.SaveProfile(selectedProfile); PM:Refresh() end,
                timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
            }
            StaticPopup_Show("DCP_PM_OVERWRITE")
        end
    end)

    local dupeBtn = AB_Btn("Duplicate", 80, "RIGHT", saveBtn2, 4)
    dupeBtn:SetScript("OnClick", function()
        if not selectedProfile then return end
        StaticPopupDialogs["DCP_PM_DUPE"] = {
            text = "Duplicate profile '" .. selectedProfile .. "' as:",
            button1 = "Duplicate", button2 = "Cancel", hasEditBox = true,
            OnShow = function(s) s.EditBox:SetText(selectedProfile .. " Copy") end,
            OnAccept = function(s)
                local n = strtrim(s.EditBox:GetText())
                if n ~= "" then
                    if currentTab == "talent" then
                        local TP = ns.TalentProfiles
                        local db2 = TP and TP:GetDB()
                        local cls2 = GetClassToken()
                        if db2 and db2.profiles[cls2] and db2.profiles[cls2][selectedProfile] then
                            db2.profiles[cls2][n] = CopyTable(db2.profiles[cls2][selectedProfile])
                            TP:UpdateData()
                            PM:Refresh()
                        end
                    else
                        local ABP = ns.ActionBarProfiles
                        if ABP then ABP.DuplicateProfile(selectedProfile, n); PM:Refresh() end
                    end
                end
            end,
            timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
        }
        StaticPopup_Show("DCP_PM_DUPE")
    end)

    local renBtn = AB_Btn("Rename", 70, "RIGHT", dupeBtn, 4)
    renBtn:SetScript("OnClick", function()
        if not selectedProfile then return end
        StaticPopupDialogs["DCP_PM_RENAME"] = {
            text = "Rename profile '" .. selectedProfile .. "' to:",
            button1 = "Rename", button2 = "Cancel", hasEditBox = true,
            OnShow = function(s) s.EditBox:SetText(selectedProfile) end,
            OnAccept = function(s)
                local n = strtrim(s.EditBox:GetText())
                if n ~= "" and n ~= selectedProfile then
                    if currentTab == "talent" then
                        local TP = ns.TalentProfiles
                        local db2 = TP and TP:GetDB()
                        local cls2 = GetClassToken()
                        if db2 and db2.profiles[cls2] then
                            db2.profiles[cls2][n] = db2.profiles[cls2][selectedProfile]
                            db2.profiles[cls2][selectedProfile] = nil
                            if db2.activeProfile[cls2] == selectedProfile then
                                db2.activeProfile[cls2] = n
                            end
                            TP:UpdateData()
                            selectedProfile = n
                            PM:Refresh()
                        end
                    else
                        local ABP = ns.ActionBarProfiles
                        if ABP then
                            local old = selectedProfile
                            ABP.RenameProfile(old, n)
                            selectedProfile = n
                            PM:Refresh()
                        end
                    end
                end
            end,
            timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
        }
        StaticPopup_Show("DCP_PM_RENAME")
    end)

    local delBtn = AB_Btn("Delete", 70, "RIGHT", renBtn, 4)
    delBtn:SetScript("OnClick", function()
        if not selectedProfile then return end
        StaticPopupDialogs["DCP_PM_DELETE"] = {
            text = "Delete profile '|cff00cc00" .. selectedProfile .. "|r'?\n\nThis cannot be undone.",
            button1 = "Delete", button2 = "Cancel",
            OnAccept = function()
                if currentTab == "talent" then
                    local TP = ns.TalentProfiles
                    local db2 = TP and TP:GetDB()
                    local cls2 = GetClassToken()
                    if db2 and db2.profiles[cls2] then
                        db2.profiles[cls2][selectedProfile] = nil
                        if db2.activeProfile[cls2] == selectedProfile then
                            db2.activeProfile[cls2] = nil
                        end
                        TP:UpdateData()
                    end
                else
                    local ABP = ns.ActionBarProfiles
                    if ABP then ABP.DeleteProfile(selectedProfile) end
                end
                selectedProfile = nil
                PM:Refresh()
            end,
            timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
        }
        StaticPopup_Show("DCP_PM_DELETE")
    end)

    -- Settings link (right-aligned)
    local settBtn = MakeButton(ab, "Settings", 80, 22)
    settBtn:SetPoint("RIGHT", ab, "RIGHT", -6, 0)
    settBtn:SetScript("OnClick", function() DCP:OpenSettings() end)

    -- ── Resize grip ────────────────────────────────────────────
    local grip = CreateFrame("Button", nil, f)
    grip:SetSize(16, 16)
    grip:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 4)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetScript("OnMouseDown", function() f:StartSizing("BOTTOMRIGHT") end)
    grip:SetScript("OnMouseUp", function() f:StopMovingOrSizing() end)

    local resizeTimer = nil
    f:SetScript("OnSizeChanged", function(self, w, h)
        -- Update scroll child widths to match new dimensions
        local contentW = w - SIDEBAR_W - 22
        if rp._scrollChild then
            rp._scrollChild:SetWidth(contentW)
        end
        if sideChild then
            sideChild:SetWidth(SIDEBAR_W - 26)
        end
        -- Throttle refresh during drag resize
        if resizeTimer then resizeTimer:Cancel() end
        resizeTimer = C_Timer.NewTimer(0.1, function()
            resizeTimer = nil
            if window and window:IsShown() then
                PM:Refresh()
            end
        end)
    end)

    window = f
    return f
end

---------------------------------------------------------------------------
-- Public API
---------------------------------------------------------------------------

function PM:RefreshRightPanel()
    if not window then return end
    local names = {}
    for n in pairs(mergeSelected) do names[#names + 1] = n end
    if mergeMode and #names >= 2 then
        RenderMergePanel(names[1], names[2])
    elseif currentTab == "talent" then
        RenderTalentDetailPanel()
    else
        RenderDetailPanel()
    end
    -- Update sidebar save button label and talent-only buttons
    if window._sidebarSaveBtn then
        window._sidebarSaveBtn:SetText(
            currentTab == "talent" and "Save Talents" or "Save Current")
    end
    if window._importGameBtn then
        if currentTab == "talent" then
            window._importGameBtn:Show()
        else
            window._importGameBtn:Hide()
        end
    end
    -- Hide merge button on talent tab (merge is action bar only)
    if window._mergeBtn then
        if currentTab == "talent" then
            window._mergeBtn:Hide()
        else
            window._mergeBtn:Show()
        end
    end
    UpdateActionBar()
end

function PM:Refresh()
    if not window or not window:IsShown() then return end
    UpdateSidebarRows()
    PM:RefreshRightPanel()
end

function PM:Open()
    CreateWindow()
    window:Show()
    UpdateSidebarRows()
    PM:RefreshRightPanel()
end

function PM:Close()
    if window then window:Hide() end
end

function PM:Toggle()
    if window and window:IsShown() then
        PM:Close()
    else
        PM:Open()
    end
end

---------------------------------------------------------------------------
-- Login Sync Modal
-- Shown on PLAYER_ENTERING_WORLD (with delay) if saved profile differs
-- from current action bars.
---------------------------------------------------------------------------

local syncModal = nil

local function CreateSyncModal()
    if syncModal then return syncModal end

    local MODAL_W = 440

    local f = CreateFrame("Frame", "DCPSyncModal", UIParent, "BackdropTemplate")
    f:SetSize(MODAL_W, 120)  -- height set dynamically
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 80)
    f:SetFrameStrata("DIALOG")
    f:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        edgeSize = 26, insets = { left = 7, right = 7, top = 7, bottom = 7 } })
    f:SetBackdropColor(0.05, 0.07, 0.12, 0.98)
    f:SetBackdropBorderColor(0.35, 0.5, 0.9, 0.9)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)
    f:Hide()

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", f, "TOP", 0, -14)
    title:SetText("|cff33ccffProfile Sync Check|r")
    f._title = title

    local sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    sub:SetPoint("TOP", title, "BOTTOM", 0, -4)
    sub:SetWidth(MODAL_W - 40)
    sub:SetWordWrap(true)
    f._sub = sub

    -- Scrollable diff list area
    local listArea = CreateFrame("Frame", nil, f, "BackdropTemplate")
    listArea:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -62)
    listArea:SetPoint("RIGHT", f, "RIGHT", -14, 0)
    listArea:SetBackdrop(BD)
    listArea:SetBackdropColor(0.04, 0.05, 0.08, 1)
    listArea:SetBackdropBorderColor(0.2, 0.3, 0.5, 0.6)
    f._listArea = listArea

    -- Column headers
    local hdrSlot = listArea:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    hdrSlot:SetPoint("TOPLEFT", listArea, "TOPLEFT", 6, -4)
    hdrSlot:SetText("|cff888888Slot|r")
    local hdrSaved = listArea:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    hdrSaved:SetPoint("TOPLEFT", listArea, "TOPLEFT", 100, -4)
    hdrSaved:SetText("|cff66bbffSaved|r")
    local hdrCurrent = listArea:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    hdrCurrent:SetPoint("TOPLEFT", listArea, "TOPLEFT", 265, -4)
    hdrCurrent:SetText("|cffffcc00Current|r")
    f._diffRows = {}

    -- Action buttons (positioned after content, dynamically)
    local loadBtn = MakeButton(f, "Load Profile", 140, 26)
    loadBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 12)
    loadBtn:SetScript("OnClick", function()
        local ABP = ns.ActionBarProfiles
        if ABP and f._profileName then
            ABP.RestoreProfile(f._profileName, false)
        end
        f:Hide()
    end)
    f._loadBtn = loadBtn

    local saveOverBtn = MakeButton(f, "Save Current", 110, 26)
    saveOverBtn:SetPoint("LEFT", loadBtn, "RIGHT", 6, 0)
    saveOverBtn:SetScript("OnClick", function()
        local ABP = ns.ActionBarProfiles
        if ABP and f._profileName then
            ABP.SaveProfile(f._profileName)
        end
        f:Hide()
    end)
    f._saveBtn = saveOverBtn

    local dismissBtn = MakeButton(f, "Dismiss", 80, 26)
    dismissBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -14, 12)
    dismissBtn:SetScript("OnClick", function() f:Hide() end)

    syncModal = f
    return f
end

function PM:ShowSyncModal(profileName, savedSlots, currentSlots, diffList)
    local f = CreateSyncModal()
    f._profileName = profileName

    -- Clean previous diff rows
    if f._diffRows then
        for _, row in ipairs(f._diffRows) do row:Hide() end
    end
    f._diffRows = {}

    local diffCount = #diffList
    f._sub:SetText("Profile |cff44ff44" .. profileName .. "|r has |cffffcc00" ..
        diffCount .. " slot(s)|r that differ from your current action bars.")

    -- Render compact diff rows (max 12 visible, then summary)
    local maxShow = math.min(diffCount, 12)
    local ROW_H = 28
    local y = -18  -- below column headers

    for i = 1, maxShow do
        local d = diffList[i]
        local row = CreateFrame("Frame", nil, f._listArea, "BackdropTemplate")
        row:SetPoint("TOPLEFT", f._listArea, "TOPLEFT", 4, y)
        row:SetPoint("RIGHT", f._listArea, "RIGHT", -4, 0)
        row:SetHeight(ROW_H)
        row:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground" })
        row:SetBackdropColor(0.08, 0.1, 0.16, (i % 2 == 0) and 0.5 or 0)

        -- Slot name
        local slotFS = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        slotFS:SetPoint("LEFT", row, "LEFT", 2, 0)
        slotFS:SetWidth(90)
        slotFS:SetJustifyH("LEFT")
        slotFS:SetWordWrap(false)
        slotFS:SetText(GetBarLabel(d.slotID))

        -- Saved icon + name
        local savedIcon = row:CreateTexture(nil, "ARTWORK")
        savedIcon:SetSize(22, 22)
        savedIcon:SetPoint("LEFT", row, "LEFT", 96, 0)
        savedIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        local savedName = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        savedName:SetPoint("LEFT", savedIcon, "RIGHT", 4, 0)
        savedName:SetWidth(120)
        savedName:SetJustifyH("LEFT")
        savedName:SetWordWrap(false)
        if d.saved then
            savedIcon:SetTexture(GetSlotIcon(d.saved))
            savedName:SetText("|cff66bbff" .. (GetSlotName(d.saved) or "?") .. "|r")
        else
            savedIcon:SetTexture(nil)
            savedName:SetText("|cff555555(empty)|r")
        end

        -- Current icon + name
        local curIcon = row:CreateTexture(nil, "ARTWORK")
        curIcon:SetSize(22, 22)
        curIcon:SetPoint("LEFT", row, "LEFT", 261, 0)
        curIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        local curName = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        curName:SetPoint("LEFT", curIcon, "RIGHT", 4, 0)
        curName:SetWidth(120)
        curName:SetJustifyH("LEFT")
        curName:SetWordWrap(false)
        if d.current then
            curIcon:SetTexture(GetSlotIcon(d.current))
            curName:SetText("|cffffcc00" .. (GetSlotName(d.current) or "?") .. "|r")
        else
            curIcon:SetTexture(nil)
            curName:SetText("|cff555555(empty)|r")
        end

        f._diffRows[#f._diffRows + 1] = row
        y = y - ROW_H
    end

    -- "and N more..." if truncated
    if diffCount > maxShow then
        local moreFS = f._listArea:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        moreFS:SetPoint("TOPLEFT", f._listArea, "TOPLEFT", 6, y - 4)
        moreFS:SetText("... and " .. (diffCount - maxShow) .. " more differences")
        local wrapper = CreateFrame("Frame", nil, f._listArea)
        wrapper:SetAllPoints(moreFS)
        wrapper.Hide = function(self) moreFS:Hide() end
        f._diffRows[#f._diffRows + 1] = wrapper
        y = y - 18
    end

    -- Size the list area and modal to fit
    local listH = math.abs(y) + 6
    f._listArea:SetHeight(listH)

    local totalH = 62 + listH + 50  -- header + list + buttons
    f:SetHeight(totalH)

    f._loadBtn:SetText("Load: " .. profileName)
    f:Show()
    UIFrameFadeIn(f, 0.3, 0, 1)
end

---------------------------------------------------------------------------
-- Init
---------------------------------------------------------------------------

function PM:Init()
    -- Listen for PLAYER_ENTERING_WORLD to show sync modal
    local listenFrame = CreateFrame("Frame")
    listenFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    listenFrame:SetScript("OnEvent", function(_, event, isInitialLogin, isUIReload)
        if not isInitialLogin then return end   -- only on fresh login, not zone transitions
        listenFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")

        -- Delay 3s so bars have fully loaded
        C_Timer.After(3, function()
            local ABP = ns.ActionBarProfiles
            if not ABP then return end
            local db      = ABP:GetDB()
            local cls     = GetClassToken()
            local profs   = ABP.GetClassProfiles(db)

            -- Determine current spec
            local specIdx = C_SpecializationInfo and C_SpecializationInfo.GetSpecialization
                            and C_SpecializationInfo.GetSpecialization() or 0
            local curSpecID
            if specIdx and specIdx > 0 then
                curSpecID = C_SpecializationInfo.GetSpecializationInfo(specIdx)
            end

            -- Prefer the per-spec auto-load profile for the current spec; fall
            -- back to db.activeProfile only if it matches the current spec.
            local target
            if curSpecID and db.autoLoadSpec then
                target = db.autoLoadSpec[cls .. "-" .. curSpecID]
            end
            if not target then
                local active = db.activeProfile[cls]
                local activeProf = active and profs[active]
                if activeProf and (not activeProf.specID or activeProf.specID == 0
                                   or activeProf.specID == curSpecID) then
                    target = active
                end
            end
            if not target then return end

            local prof = profs[target]
            if not prof or not prof.slots then return end
            -- Final guard: never compare against a profile from a different spec
            if prof.specID and prof.specID ~= 0 and curSpecID
               and prof.specID ~= curSpecID then
                return
            end

            local current = ABP.ReadCurrentSlots()
            local diffs   = DiffSlots(prof.slots, current)

            if #diffs > 0 then
                PM:ShowSyncModal(target, prof.slots, current, diffs)
            end
        end)
    end)
end

---------------------------------------------------------------------------
-- Module registration
---------------------------------------------------------------------------

ns:RegisterModule("profilemanager", PM)
