-- Djinni's Class Profiles — Settings
-- Blizzard Settings integration and widget helpers.
local addonName, ns = ...
local DCP = ns.addon

---------------------------------------------------------------------------
-- Widget helpers
---------------------------------------------------------------------------

local function AddCheckbox(content, y, label, getter, setter, refreshList)
    local cb = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", content, "TOPLEFT", 14, y)

    local text = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("LEFT", cb, "RIGHT", 2, 0)
    text:SetText(label)

    cb:SetChecked(getter())
    cb:SetScript("OnClick", function(self) setter(self:GetChecked()) end)

    if refreshList then
        table.insert(refreshList, function() cb:SetChecked(getter()) end)
    end
    return y - 26
end

local function AddSlider(content, y, label, min, max, step, getter, setter, refreshList)
    local text = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", content, "TOPLEFT", 18, y)
    text:SetText(label)

    local slider = CreateFrame("Slider", nil, content)
    slider:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -6)
    slider:SetMinMaxValues(min, max)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)
    slider:SetWidth(240)
    slider:SetHeight(16)
    slider:SetOrientation("HORIZONTAL")
    slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    local bg = slider:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\Buttons\\UI-SliderBar-Background")
    bg:SetAllPoints()
    bg:SetTexCoord(0, 1, 0, 1)

    local function FormatVal(v)
        if step < 1 then return string.format("%.2f", v)
        else return tostring(math.floor(v + 0.5)) end
    end

    local input = CreateFrame("EditBox", nil, content, "BackdropTemplate")
    input:SetPoint("LEFT", slider, "RIGHT", 10, 0)
    input:SetSize(54, 22)
    input:SetAutoFocus(false)
    input:SetFontObject(GameFontHighlightSmall)
    input:SetJustifyH("CENTER")
    input:SetMaxLetters(8)
    input:SetTextInsets(4, 4, 0, 0)
    input:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true, edgeSize = 1, tileSize = 5,
    })
    input:SetBackdropColor(0, 0, 0, 0.5)
    input:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)

    local valText = input:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    valText:SetPoint("CENTER", input, "CENTER", 0, 0)
    valText:SetJustifyH("CENTER")
    valText:SetText(FormatVal(getter()))

    input:SetScript("OnEditFocusGained", function(self)
        valText:Hide()
        self:SetText(FormatVal(getter()))
        self:HighlightText()
    end)
    input:SetScript("OnEditFocusLost", function(self)
        self:HighlightText(0, 0)
        valText:SetText(FormatVal(getter()))
        valText:Show()
    end)
    input:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1) end)
    input:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8) end)

    slider:SetScript("OnValueChanged", function(_, value)
        value = math.floor(value / step + 0.5) * step
        setter(value)
        valText:SetText(FormatVal(value))
        input:SetText(FormatVal(value))
    end)
    slider:SetValue(getter())

    input:SetScript("OnEnterPressed", function(self)
        local val = tonumber(self:GetText())
        if val then
            val = math.max(min, math.min(max, val))
            val = math.floor(val / step + 0.5) * step
            setter(val)
            slider:SetValue(val)
        else
            self:SetText(FormatVal(getter()))
        end
        self:ClearFocus()
    end)
    input:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    if refreshList then
        table.insert(refreshList, function()
            slider:SetValue(getter())
            valText:SetText(FormatVal(getter()))
        end)
    end
    return y - 48
end

--- Two compact sliders side by side.
local function AddSliderPair(content, y, spec1, spec2, refreshList)
    local specs  = { spec1, spec2 }
    local xBases = { 18, 280 }
    local SLIDER_W = 155

    for i = 1, 2 do
        local spec = specs[i]
        if not spec then break end
        local xBase = xBases[i]
        local stp   = spec.step

        local function FormatVal(v)
            if stp < 1 then return string.format("%.2f", v)
            else return tostring(math.floor(v + 0.5)) end
        end

        local lbl = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        lbl:SetPoint("TOPLEFT", content, "TOPLEFT", xBase, y)
        lbl:SetText(spec.label)

        local slider = CreateFrame("Slider", nil, content)
        slider:SetPoint("TOPLEFT", lbl, "BOTTOMLEFT", 0, -6)
        slider:SetMinMaxValues(spec.min, spec.max)
        slider:SetValueStep(stp)
        slider:SetObeyStepOnDrag(true)
        slider:SetWidth(SLIDER_W)
        slider:SetHeight(16)
        slider:SetOrientation("HORIZONTAL")
        slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
        local bg = slider:CreateTexture(nil, "BACKGROUND")
        bg:SetTexture("Interface\\Buttons\\UI-SliderBar-Background")
        bg:SetAllPoints()
        bg:SetTexCoord(0, 1, 0, 1)

        local input = CreateFrame("EditBox", nil, content, "BackdropTemplate")
        input:SetPoint("LEFT", slider, "RIGHT", 8, 0)
        input:SetSize(48, 20)
        input:SetAutoFocus(false)
        input:SetFontObject(GameFontHighlightSmall)
        input:SetJustifyH("CENTER")
        input:SetMaxLetters(8)
        input:SetTextInsets(4, 4, 0, 0)
        input:SetBackdrop({
            bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
            tile = true, edgeSize = 1, tileSize = 5,
        })
        input:SetBackdropColor(0, 0, 0, 0.5)
        input:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)

        local valText = input:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        valText:SetPoint("CENTER")
        valText:SetJustifyH("CENTER")
        valText:SetText(FormatVal(spec.get()))

        input:SetScript("OnEditFocusGained", function(self)
            valText:Hide()
            self:SetText(FormatVal(spec.get()))
            self:HighlightText()
        end)
        input:SetScript("OnEditFocusLost", function(self)
            self:HighlightText(0, 0)
            valText:SetText(FormatVal(spec.get()))
            valText:Show()
        end)
        input:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1) end)
        input:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8) end)

        slider:SetScript("OnValueChanged", function(_, value)
            value = math.floor(value / stp + 0.5) * stp
            spec.set(value)
            valText:SetText(FormatVal(value))
            input:SetText(FormatVal(value))
        end)
        slider:SetValue(spec.get())

        input:SetScript("OnEnterPressed", function(self)
            local val = tonumber(self:GetText())
            if val then
                val = math.max(spec.min, math.min(spec.max, val))
                val = math.floor(val / stp + 0.5) * stp
                spec.set(val)
                slider:SetValue(val)
            else
                self:SetText(FormatVal(spec.get()))
            end
            self:ClearFocus()
        end)
        input:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

        if refreshList then
            local s, v = slider, valText
            table.insert(refreshList, function()
                s:SetValue(spec.get())
                v:SetText(FormatVal(spec.get()))
            end)
        end
    end

    return y - 48
end

local function AddDropdown(content, y, label, values, getter, setter, refreshList)
    local text = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", content, "TOPLEFT", 18, y)
    text:SetText(label)

    local dropdown = CreateFrame("DropdownButton", nil, content, "WowStyle1DropdownTemplate")
    dropdown:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -2)
    dropdown:SetWidth(200)

    dropdown:SetupMenu(function(_, rootDescription)
        local sorted = {}
        for value, displayText in pairs(values) do
            table.insert(sorted, { value = value, text = displayText })
        end
        table.sort(sorted, function(a, b)
            if a.value == "none" and b.value ~= "none" then return true end
            if b.value == "none" and a.value ~= "none" then return false end
            return a.text < b.text
        end)
        for _, item in ipairs(sorted) do
            rootDescription:CreateButton(item.text, function()
                setter(item.value)
            end):SetIsSelected(function() return getter() == item.value end)
        end
    end)

    if refreshList then
        table.insert(refreshList, function() dropdown:GenerateMenu() end)
    end
    return y - 54
end

local function AddEditBox(content, y, label, getter, setter, refreshList)
    local text = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", content, "TOPLEFT", 18, y)
    text:SetText(label)

    local editbox = CreateFrame("EditBox", nil, content, "InputBoxTemplate")
    editbox:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 4, -4)
    editbox:SetSize(380, 20)
    editbox:SetAutoFocus(false)
    editbox:SetText(getter())
    editbox:SetTextColor(0, 0, 0, 0)

    local valText = editbox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    valText:SetPoint("LEFT", editbox, "LEFT", 6, 0)
    valText:SetPoint("RIGHT", editbox, "RIGHT", -6, 0)
    valText:SetJustifyH("LEFT")
    valText:SetText(getter())

    editbox:HookScript("OnEditFocusGained", function(self)
        self:SetText(getter())
        self:SetTextColor(1, 1, 1, 1)
        C_Timer.After(0, function()
            if self:HasFocus() then
                valText:Hide()
                self:HighlightText(0, 0)
                self:SetCursorPosition(#self:GetText())
            end
        end)
    end)
    editbox:HookScript("OnEditFocusLost", function(self)
        local newVal = self:GetText()
        setter(newVal)
        self:SetTextColor(0, 0, 0, 0)
        valText:SetText(newVal)
        valText:Show()
    end)
    editbox:SetScript("OnEnterPressed", function(self)
        setter(self:GetText())
        valText:SetText(self:GetText())
        self:ClearFocus()
    end)
    editbox:SetScript("OnEscapePressed", function(self)
        self:SetText(getter())
        valText:SetText(getter())
        self:ClearFocus()
    end)
    editbox:SetScript("OnTextChanged", function(self, userInput)
        if userInput then setter(self:GetText()) end
    end)

    if refreshList then
        table.insert(refreshList, function()
            if not editbox:HasFocus() then
                editbox:SetText(getter())
                valText:SetText(getter())
            end
        end)
    end
    return y - 44
end

local function AddLabelEditBox(panel, tags, getter, setter, refreshList, suggestions)
    local header = CreateFrame("Frame", nil, panel)
    header:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -5)
    header:SetPoint("RIGHT", panel, "RIGHT", -24, 0)

    local titleStr = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleStr:SetPoint("TOPLEFT", 8, 0)
    titleStr:SetText("Label Template")

    local line = header:CreateTexture(nil, "ARTWORK")
    line:SetPoint("LEFT", titleStr, "RIGHT", 8, 0)
    line:SetPoint("RIGHT", header, "RIGHT", -10, 0)
    line:SetHeight(1)
    line:SetColorTexture(0.5, 0.5, 0.5, 0.3)

    local text = header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", header, "TOPLEFT", 18, -24)
    text:SetText("Template")

    local editbox = CreateFrame("EditBox", nil, header, "InputBoxTemplate")
    editbox:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 4, -4)
    editbox:SetSize(380, 20)
    editbox:SetAutoFocus(false)
    editbox:SetText(getter())

    local lastCursorPos = nil
    local lastText = nil

    editbox:HookScript("OnEditFocusLost", function(self)
        lastCursorPos = self:GetCursorPosition()
        lastText = self:GetText()
        setter(lastText)
    end)
    editbox:SetScript("OnEnterPressed", function(self) setter(self:GetText()); self:ClearFocus() end)
    editbox:SetScript("OnEscapePressed", function(self) self:SetText(getter()); self:ClearFocus() end)
    editbox:SetScript("OnTextChanged", function(self, userInput)
        if userInput then setter(self:GetText()) end
    end)

    if refreshList then
        table.insert(refreshList, function()
            if not editbox:HasFocus() then editbox:SetText(getter()) end
        end)
    end

    local tagY = -68
    local tagList = {}
    for tag in tags:gmatch("%S+") do table.insert(tagList, tag) end

    local xOffset    = 22
    local maxRowWidth = 380

    for _, tag in ipairs(tagList) do
        local tagStr = "<" .. tag .. ">"
        local btn = CreateFrame("Button", nil, header)
        btn:SetHeight(20)

        local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        btnText:SetPoint("CENTER")
        btnText:SetText(tagStr)
        btnText:SetTextColor(0.4, 0.78, 1.0)
        local btnWidth = math.max(btnText:GetStringWidth() + 12, 40)
        btn:SetWidth(btnWidth)

        local bbg = btn:CreateTexture(nil, "BACKGROUND")
        bbg:SetAllPoints()
        bbg:SetColorTexture(0.15, 0.15, 0.15, 0.8)
        local border = btn:CreateTexture(nil, "BORDER")
        border:SetPoint("TOPLEFT", -1, 1)
        border:SetPoint("BOTTOMRIGHT", 1, -1)
        border:SetColorTexture(0.3, 0.3, 0.3, 0.6)

        if xOffset + btnWidth > maxRowWidth + 22 then
            xOffset = 22
            tagY = tagY - 24
        end
        btn:SetPoint("TOPLEFT", header, "TOPLEFT", xOffset, tagY)
        xOffset = xOffset + btnWidth + 4

        btn:SetScript("OnEnter", function() bbg:SetColorTexture(0.25, 0.35, 0.45, 0.9); btnText:SetTextColor(1,1,1) end)
        btn:SetScript("OnLeave", function() bbg:SetColorTexture(0.15, 0.15, 0.15, 0.8); btnText:SetTextColor(0.4,0.78,1.0) end)
        btn:SetScript("OnClick", function()
            local cur = lastText or getter()
            local pos = lastCursorPos or #cur
            lastCursorPos = nil; lastText = nil
            local newVal = cur:sub(1, pos) .. tagStr .. cur:sub(pos + 1)
            setter(newVal)
            editbox:SetText(newVal)
            editbox:SetFocus()
            editbox:SetCursorPosition(pos + #tagStr)
        end)
    end

    tagY = tagY - 26

    if suggestions and #suggestions > 0 then
        tagY = tagY - 2
        local sugLabel = header:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        sugLabel:SetPoint("TOPLEFT", header, "TOPLEFT", 22, tagY)
        sugLabel:SetText("Presets:")
        tagY = tagY - 14

        for _, sug in ipairs(suggestions) do
            local btn = CreateFrame("Button", nil, header)
            btn:SetHeight(18)
            btn:SetPoint("TOPLEFT", header, "TOPLEFT", 22, tagY)
            btn:SetPoint("RIGHT", header, "RIGHT", -22, 0)

            local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            btnText:SetPoint("LEFT", 6, 0)
            btnText:SetJustifyH("LEFT")
            btnText:SetText("|cff888888" .. sug[1] .. ":|r  " .. sug[2])

            local sbg = btn:CreateTexture(nil, "BACKGROUND")
            sbg:SetAllPoints()
            sbg:SetColorTexture(0, 0, 0, 0)

            btn:SetScript("OnEnter", function() sbg:SetColorTexture(0.2, 0.3, 0.4, 0.5) end)
            btn:SetScript("OnLeave", function() sbg:SetColorTexture(0, 0, 0, 0) end)
            btn:SetScript("OnClick", function() setter(sug[2]); editbox:SetText(sug[2]) end)
            tagY = tagY - 20
        end
    end

    local headerHeight = math.abs(tagY) + 4
    header:SetHeight(headerHeight)
    panel.scroll:SetPoint("TOPLEFT", 0, -(headerHeight + 5))
    panel.labelHeader = header
    panel.labelEditBox = editbox
end

local function AddButton(content, y, label, onClick)
    local btn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
    btn:SetPoint("TOPLEFT", content, "TOPLEFT", 18, y)
    btn:SetSize(160, 24)
    btn:SetText(label)
    btn:SetScript("OnClick", onClick)
    return y - 30
end

local function AddDescription(content, y, text)
    y = y - 6
    local desc = content:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    desc:SetPoint("TOPLEFT", content, "TOPLEFT", 18, y)
    desc:SetPoint("RIGHT", content, "RIGHT", -18, 0)
    desc:SetJustifyH("LEFT")
    desc:SetWordWrap(true)
    desc:SetSpacing(2)
    desc:SetText(text)
    local cw = content:GetWidth()
    if cw and cw > 50 then desc:SetWidth(cw - 36) end
    local h = desc:GetStringHeight() or 14
    return y - h - 12
end

local function AddNote(content, y, text)
    local note = content:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    note:SetPoint("TOPLEFT", content, "TOPLEFT", 18, y)
    note:SetPoint("RIGHT", content, "RIGHT", -18, 0)
    note:SetJustifyH("LEFT")
    note:SetText(text)
    local h = math.max(14, note:GetStringHeight() + 2)
    return y - h
end

local TOOLTIP_GROW_VALUES = {
    auto = "Auto (detect from position)",
    up   = "Up (above DataText)",
    down = "Down (below DataText)",
}

local function AddTooltipGrowDirection(content, y, dbGetter, refreshList)
    return AddDropdown(content, y, "Tooltip Grow Direction", TOOLTIP_GROW_VALUES,
        function() return dbGetter().tooltipGrowDirection or "auto" end,
        function(v) dbGetter().tooltipGrowDirection = v end, refreshList)
end

---------------------------------------------------------------------------
-- Collapsible section infrastructure
---------------------------------------------------------------------------

local function AddSection(panel, title, defaultCollapsed)
    local sections = panel.sections
    local content  = panel.content

    local section = CreateFrame("Frame", nil, content)
    section:SetPoint("RIGHT", content, "RIGHT")
    if #sections == 0 then
        section:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -6)
    else
        section:SetPoint("TOPLEFT", sections[#sections], "BOTTOMLEFT", 0, -2)
    end

    local headerBtn = CreateFrame("Button", nil, section)
    headerBtn:SetHeight(24)
    headerBtn:SetPoint("TOPLEFT", 0, 0)
    headerBtn:SetPoint("RIGHT", 0, 0)

    local arrow = headerBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    arrow:SetPoint("LEFT", 8, 0)
    arrow:SetTextColor(0.6, 0.6, 0.6)

    local titleStr = headerBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleStr:SetPoint("LEFT", arrow, "RIGHT", 4, 0)
    titleStr:SetText(title)

    local line = section:CreateTexture(nil, "ARTWORK")
    line:SetPoint("LEFT", titleStr, "RIGHT", 8, 0)
    line:SetPoint("RIGHT", section, "RIGHT", -10, 0)
    line:SetHeight(1)
    line:SetColorTexture(0.5, 0.5, 0.5, 0.3)

    headerBtn:SetScript("OnEnter", function() arrow:SetTextColor(1, 0.82, 0) end)
    headerBtn:SetScript("OnLeave", function() arrow:SetTextColor(0.6, 0.6, 0.6) end)

    local body = CreateFrame("Frame", nil, section)
    body:SetPoint("TOPLEFT", headerBtn, "BOTTOMLEFT", 0, -4)
    body:SetPoint("RIGHT")

    section.body        = body
    section.headerHeight = 28
    section.bodyHeight   = 0
    section.isCollapsed  = defaultCollapsed or false

    function section:UpdateLayout()
        if self.isCollapsed then
            arrow:SetText("+")
            body:Hide()
            self:SetHeight(self.headerHeight)
        else
            arrow:SetText("-")
            body:Show()
            self:SetHeight(self.headerHeight + self.bodyHeight)
        end
        panel:RecalcHeight()
    end

    headerBtn:SetScript("OnClick", function()
        section.isCollapsed = not section.isCollapsed
        section:UpdateLayout()
    end)

    table.insert(sections, section)
    panel.currentSection = section
    return body
end

local function EndSection(panel, y)
    local section = panel.currentSection
    if not section then return end
    section.bodyHeight = math.abs(y) + 8
    section.body:SetHeight(section.bodyHeight)
    section:UpdateLayout()
    panel.currentSection = nil
end

---------------------------------------------------------------------------
-- Click-action section helpers
---------------------------------------------------------------------------

local CLICK_ACTION_KEYS = {
    { key = "leftClick",       label = "Left Click" },
    { key = "rightClick",      label = "Right Click" },
    { key = "middleClick",     label = "Middle Click" },
    { key = "shiftLeftClick",  label = "Shift + Left Click" },
    { key = "shiftRightClick", label = "Shift + Right Click" },
    { key = "ctrlLeftClick",   label = "Ctrl + Left Click" },
    { key = "ctrlRightClick",  label = "Ctrl + Right Click" },
    { key = "altLeftClick",    label = "Alt + Left Click" },
    { key = "altRightClick",   label = "Alt + Right Click" },
}

local function AddModuleClickActionsSection(panel, r, dbKey, actionValues)
    local body = AddSection(panel, "Click Actions", true)
    local y = 0
    y = AddDescription(body, y, "Configure what happens when you click the DataText.")
    for _, entry in ipairs(CLICK_ACTION_KEYS) do
        y = AddDropdown(body, y, entry.label, actionValues,
            function() return ns.db[dbKey].clickActions[entry.key] end,
            function(v) ns.db[dbKey].clickActions[entry.key] = v end, r)
    end
    EndSection(panel, y)
end

ns.AddModuleClickActionsSection = AddModuleClickActionsSection

---------------------------------------------------------------------------
-- Expose widget table (mirrors DDT's ns.SettingsWidgets)
---------------------------------------------------------------------------

ns.SettingsWidgets = {
    AddCheckbox             = AddCheckbox,
    AddSlider               = AddSlider,
    AddSliderPair           = AddSliderPair,
    AddDropdown             = AddDropdown,
    AddEditBox              = AddEditBox,
    AddLabelEditBox         = AddLabelEditBox,
    AddButton               = AddButton,
    AddDescription          = AddDescription,
    AddNote                 = AddNote,
    AddSection              = AddSection,
    EndSection              = EndSection,
    AddTooltipGrowDirection = AddTooltipGrowDirection,
}

---------------------------------------------------------------------------
-- Scroll panel factory
---------------------------------------------------------------------------

local function CreateScrollPanel()
    local panel = CreateFrame("Frame")
    panel:Hide()

    local scroll = CreateFrame("ScrollFrame", nil, panel, "ScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 0, -5)
    scroll:SetPoint("BOTTOMRIGHT", -24, 5)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetWidth(560)
    scroll:SetScrollChild(content)

    panel.scroll   = scroll
    panel.content  = content
    panel.sections = {}
    panel.refreshCallbacks = {}

    function panel:RecalcHeight()
        local totalH = 6
        for i, sec in ipairs(self.sections) do
            totalH = totalH + sec:GetHeight()
            if i < #self.sections then totalH = totalH + 2 end
        end
        self.content:SetHeight(math.max(totalH + 20, 100))
    end

    panel:SetScript("OnSizeChanged", function(self, w)
        content:SetWidth(math.max(w - 30, 400))
    end)
    panel:SetScript("OnShow", function(self)
        for _, cb in ipairs(self.refreshCallbacks) do cb() end
    end)

    return panel
end

---------------------------------------------------------------------------
-- Blizzard Settings registration
---------------------------------------------------------------------------

function DCP:SetupOptions()
    -- Single module — create one category with one panel
    local modPanel = CreateScrollPanel()
    local mod = ns.modules["actionbarprofiles"]
    if mod and mod.BuildSettingsPanel then
        mod:BuildSettingsPanel(modPanel)
    end

    local cat = Settings.RegisterCanvasLayoutCategory(modPanel, "Djinni's Class Profiles")
    Settings.RegisterAddOnCategory(cat)
    self.settingsCategoryID = cat:GetID()
end
