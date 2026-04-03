-- Djinni's Class Profiles — Core
-- Standalone core: module system, shared helpers, tooltip factory, SavedVariables init.
local addonName, ns = ...

---------------------------------------------------------------------------
-- Addon object
---------------------------------------------------------------------------

local DCP = {}
DCP.__index = DCP
ns.addon = DCP

---------------------------------------------------------------------------
-- Module system
---------------------------------------------------------------------------

ns.modules  = {}
ns.defaults = {}

function ns:RegisterModule(key, mod, defaults)
    self.modules[key] = mod
    if defaults then
        self.defaults[key] = defaults
    end
end

---------------------------------------------------------------------------
-- Defaults merge (deep, non-destructive)
---------------------------------------------------------------------------

local function MergeDefaults(target, defaults)
    for k, v in pairs(defaults) do
        if type(v) == "table" then
            if type(target[k]) ~= "table" then target[k] = {} end
            MergeDefaults(target[k], v)
        elseif target[k] == nil then
            target[k] = v
        end
    end
end

---------------------------------------------------------------------------
-- Print helper
---------------------------------------------------------------------------

function DCP:Print(msg)
    print("|cff33ff99DjinniDCP:|r " .. tostring(msg))
end

---------------------------------------------------------------------------
-- Label tag expansion
---------------------------------------------------------------------------

function ns.ExpandTag(str, tag, value)
    local s = tostring(value)
    return (str:gsub("<" .. tag .. ">", function() return s end))
end

---------------------------------------------------------------------------
-- Hide delay (seconds before tooltip auto-hides)
---------------------------------------------------------------------------

ns.HIDE_DELAY = 0.15

---------------------------------------------------------------------------
-- Font objects
-- Named DCPFont* for internal lookup by FontString helper.
---------------------------------------------------------------------------

local FONT_OBJECTS = {}

local function InitFonts()
    local h = CreateFont("DCPFontHeader")
    h:SetFont("Fonts\\FRIZQT__.TTF", 14, "")
    local n = CreateFont("DCPFontNormal")
    n:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
    local s = CreateFont("DCPFontSmall")
    s:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    FONT_OBJECTS["DCPFontHeader"] = h
    FONT_OBJECTS["DCPFontNormal"] = n
    FONT_OBJECTS["DCPFontSmall"]  = s
end

function ns.FontString(parent, fontTemplate)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    local obj = FONT_OBJECTS[fontTemplate]
    if obj then fs:SetFontObject(obj) end
    return fs
end

---------------------------------------------------------------------------
-- Click action resolver
---------------------------------------------------------------------------

function DCP:ResolveClickAction(button, clickActions)
    if IsAltKeyDown() then
        if button == "LeftButton"  then return clickActions.altLeftClick end
        if button == "RightButton" then return clickActions.altRightClick end
    elseif IsControlKeyDown() then
        if button == "LeftButton"  then return clickActions.ctrlLeftClick end
        if button == "RightButton" then return clickActions.ctrlRightClick end
    elseif IsShiftKeyDown() then
        if button == "LeftButton"  then return clickActions.shiftLeftClick end
        if button == "RightButton" then return clickActions.shiftRightClick end
    else
        if button == "LeftButton"  then return clickActions.leftClick end
        if button == "RightButton" then return clickActions.rightClick end
        if button == "MiddleButton" then return clickActions.middleClick end
    end
end

---------------------------------------------------------------------------
-- Hint bar builder
---------------------------------------------------------------------------

function DCP:BuildHintText(clickActions, actionLabels)
    local labels = {
        { key = "leftClick",       prefix = "LClick" },
        { key = "rightClick",      prefix = "RClick" },
        { key = "middleClick",     prefix = "MClick" },
        { key = "shiftLeftClick",  prefix = "Shift+L" },
        { key = "shiftRightClick", prefix = "Shift+R" },
        { key = "ctrlLeftClick",   prefix = "Ctrl+L" },
        { key = "ctrlRightClick",  prefix = "Ctrl+R" },
        { key = "altLeftClick",    prefix = "Alt+L" },
        { key = "altRightClick",   prefix = "Alt+R" },
    }
    local hints = {}
    for _, entry in ipairs(labels) do
        local action = clickActions[entry.key]
        if action and action ~= "none" then
            table.insert(hints, entry.prefix .. ": " .. (actionLabels and actionLabels[action] or action))
        end
    end
    if #hints == 0 then return "" end
    return "|cff888888" .. table.concat(hints, "  |  ") .. "|r"
end

---------------------------------------------------------------------------
-- Minimal JSON encoder/decoder
-- Handles: string, number, boolean, nil, table (array or object).
-- No metatables, cycles, or functions. Produces minified output.
---------------------------------------------------------------------------

local json = {}
ns.json = json

local function jsonEncodeString(s)
    s = s:gsub('\\', '\\\\')
    s = s:gsub('"', '\\"')
    s = s:gsub('\n', '\\n')
    s = s:gsub('\r', '\\r')
    s = s:gsub('\t', '\\t')
    return '"' .. s .. '"'
end

local function isArray(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n == #t
end

local function jsonEncode(val, depth)
    depth = depth or 0
    if depth > 40 then return "null" end
    local vtype = type(val)
    if val == nil then
        return "null"
    elseif vtype == "boolean" then
        return val and "true" or "false"
    elseif vtype == "number" then
        if val ~= val then return "null" end  -- NaN
        if val == math.huge or val == -math.huge then return "null" end
        if val == math.floor(val) and math.abs(val) < 2^53 then
            return tostring(math.floor(val))
        end
        return string.format("%.14g", val)
    elseif vtype == "string" then
        return jsonEncodeString(val)
    elseif vtype == "table" then
        if isArray(val) then
            local parts = {}
            for i = 1, #val do
                parts[i] = jsonEncode(val[i], depth + 1)
            end
            return "[" .. table.concat(parts, ",") .. "]"
        else
            local parts = {}
            -- Sort keys for deterministic output
            local keys = {}
            for k in pairs(val) do
                keys[#keys + 1] = k
            end
            table.sort(keys, function(a, b)
                local ta, tb = type(a), type(b)
                if ta ~= tb then return ta < tb end
                return a < b
            end)
            for _, k in ipairs(keys) do
                local ks = type(k) == "number" and tostring(k) or tostring(k)
                parts[#parts + 1] = jsonEncodeString(ks) .. ":" .. jsonEncode(val[k], depth + 1)
            end
            return "{" .. table.concat(parts, ",") .. "}"
        end
    end
    return "null"
end

json.encode = jsonEncode

-- Decoder: hand-written recursive descent parser for JSON subset.
local function jsonDecode(str)
    local pos = 1
    local len = #str

    local function skipWhitespace()
        while pos <= len do
            local c = str:byte(pos)
            if c == 32 or c == 9 or c == 10 or c == 13 then
                pos = pos + 1
            else
                break
            end
        end
    end

    local function peek()
        skipWhitespace()
        return pos <= len and str:sub(pos, pos) or nil
    end

    local function consume(expected)
        skipWhitespace()
        if str:sub(pos, pos) == expected then
            pos = pos + 1
            return true
        end
        return false
    end

    local parseValue  -- forward declaration

    local function parseString()
        if str:sub(pos, pos) ~= '"' then return nil end
        pos = pos + 1
        local parts = {}
        while pos <= len do
            local c = str:sub(pos, pos)
            if c == '"' then
                pos = pos + 1
                return table.concat(parts)
            elseif c == '\\' then
                pos = pos + 1
                local esc = str:sub(pos, pos)
                if esc == 'n' then parts[#parts + 1] = '\n'
                elseif esc == 'r' then parts[#parts + 1] = '\r'
                elseif esc == 't' then parts[#parts + 1] = '\t'
                elseif esc == '"' then parts[#parts + 1] = '"'
                elseif esc == '\\' then parts[#parts + 1] = '\\'
                elseif esc == '/' then parts[#parts + 1] = '/'
                elseif esc == 'u' then
                    -- Simple unicode escape (BMP only, skip surrogates)
                    local hex = str:sub(pos + 1, pos + 4)
                    local code = tonumber(hex, 16)
                    if code and code < 128 then
                        parts[#parts + 1] = string.char(code)
                    else
                        parts[#parts + 1] = '?'
                    end
                    pos = pos + 4
                else
                    parts[#parts + 1] = esc
                end
                pos = pos + 1
            else
                parts[#parts + 1] = c
                pos = pos + 1
            end
        end
        return nil  -- unterminated string
    end

    local function parseNumber()
        local start = pos
        if str:sub(pos, pos) == '-' then pos = pos + 1 end
        while pos <= len and str:byte(pos) >= 48 and str:byte(pos) <= 57 do pos = pos + 1 end
        if pos <= len and str:sub(pos, pos) == '.' then
            pos = pos + 1
            while pos <= len and str:byte(pos) >= 48 and str:byte(pos) <= 57 do pos = pos + 1 end
        end
        if pos <= len and (str:sub(pos, pos) == 'e' or str:sub(pos, pos) == 'E') then
            pos = pos + 1
            if pos <= len and (str:sub(pos, pos) == '+' or str:sub(pos, pos) == '-') then pos = pos + 1 end
            while pos <= len and str:byte(pos) >= 48 and str:byte(pos) <= 57 do pos = pos + 1 end
        end
        return tonumber(str:sub(start, pos - 1))
    end

    local function parseArray()
        pos = pos + 1  -- skip '['
        local arr = {}
        skipWhitespace()
        if str:sub(pos, pos) == ']' then pos = pos + 1; return arr end
        while true do
            local val = parseValue()
            arr[#arr + 1] = val
            skipWhitespace()
            if not consume(',') then break end
        end
        consume(']')
        return arr
    end

    local function parseObject()
        pos = pos + 1  -- skip '{'
        local obj = {}
        skipWhitespace()
        if str:sub(pos, pos) == '}' then pos = pos + 1; return obj end
        while true do
            skipWhitespace()
            local key = parseString()
            if not key then break end
            skipWhitespace()
            consume(':')
            local val = parseValue()
            -- Convert numeric string keys back to numbers for slot IDs
            local numKey = tonumber(key)
            if numKey then
                obj[numKey] = val
            else
                obj[key] = val
            end
            skipWhitespace()
            if not consume(',') then break end
        end
        consume('}')
        return obj
    end

    parseValue = function()
        skipWhitespace()
        if pos > len then return nil end
        local c = str:sub(pos, pos)
        if c == '"' then return parseString()
        elseif c == '{' then return parseObject()
        elseif c == '[' then return parseArray()
        elseif c == 't' then pos = pos + 4; return true
        elseif c == 'f' then pos = pos + 5; return false
        elseif c == 'n' then pos = pos + 4; return nil
        else return parseNumber()
        end
    end

    local result = parseValue()
    return result
end

json.decode = jsonDecode

---------------------------------------------------------------------------
-- Copy-to-clipboard popup
---------------------------------------------------------------------------

function DCP:CopyToClipboard(text, label)
    if not DCPCopyFrame then
        local f = CreateFrame("Frame", "DCPCopyFrame", UIParent, "BackdropTemplate")
        f:SetSize(500, 300)
        f:SetPoint("CENTER")
        f:SetFrameStrata("DIALOG")
        f:SetBackdrop({
            bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 14, insets = { left = 3, right = 3, top = 3, bottom = 3 },
        })
        f:SetBackdropColor(0.1, 0.1, 0.1, 0.95)
        f:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving)
        f:SetScript("OnDragStop", f.StopMovingOrSizing)

        local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", 0, -10)
        f.titleText = title

        local scroll = CreateFrame("ScrollFrame", "DCPCopyScroll", f, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 12, -34)
        scroll:SetPoint("BOTTOMRIGHT", -30, 36)

        local edit = CreateFrame("EditBox", "DCPCopyEditBox", scroll)
        edit:SetMultiLine(true)
        edit:SetAutoFocus(true)
        edit:SetFontObject("GameFontHighlight")
        edit:SetWidth(440)
        edit:SetScript("OnEscapePressed", function() f:Hide() end)
        scroll:SetScrollChild(edit)
        f.editBox = edit

        local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
        close:SetPoint("TOPRIGHT", -2, -2)

        local hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisable")
        hint:SetPoint("BOTTOM", 0, 12)
        hint:SetText("Ctrl+A to select all, Ctrl+C to copy, Escape to close")
    end

    DCPCopyFrame.titleText:SetText("Class Profiles — " .. (label or "Copy Text"))
    DCPCopyFrame.editBox:SetText(text)
    DCPCopyFrame:Show()
    DCPCopyFrame.editBox:HighlightText()
    DCPCopyFrame.editBox:SetFocus()
end

---------------------------------------------------------------------------
-- Scrollbar helpers (used by tooltip FinalizeLayout)
---------------------------------------------------------------------------

function DCP:UpdateScrollbar(f)
    local contentH = f.content:GetHeight() or 0
    local clipH    = f.clipFrame:GetHeight() or 0
    if contentH > clipH + 1 then
        local thumbH   = math.max(20, clipH * (clipH / contentH))
        local maxTrack = clipH - thumbH
        local thumbPos = maxTrack > 0 and (f.scrollOffset / (contentH - clipH)) * maxTrack or 0
        f.scrollTrack:Show()
        f.scrollThumb:Show()
        f.scrollThumb:SetHeight(thumbH)
        f.scrollThumb:ClearAllPoints()
        f.scrollThumb:SetPoint("TOP", f.scrollTrack, "TOP", 0, -thumbPos)
    else
        f.scrollTrack:Hide()
        f.scrollThumb:Hide()
    end
end

function DCP:UpdateHScrollbar(f)
    local contentW = f.content:GetWidth() or 0
    local clipW    = f.clipFrame:GetWidth() or 0
    if contentW > clipW + 1 then
        local thumbW   = math.max(20, clipW * (clipW / contentW))
        local maxTrack = clipW - thumbW
        local thumbPos = maxTrack > 0 and (f.hScrollOffset / (contentW - clipW)) * maxTrack or 0
        f.hScrollTrack:Show()
        f.hScrollThumb:Show()
        f.hScrollThumb:SetWidth(thumbW)
        f.hScrollThumb:ClearAllPoints()
        f.hScrollThumb:SetPoint("LEFT", f.hScrollTrack, "LEFT", thumbPos, 0)
    else
        f.hScrollTrack:Hide()
        f.hScrollThumb:Hide()
    end
end

---------------------------------------------------------------------------
-- Tooltip frame factory
---------------------------------------------------------------------------

local FACTORY_PADDING     = 10
local FACTORY_HEADER_H    = 20
local FACTORY_SEP_GAP     = 3
local FACTORY_CONTENT_GAP = 6
local FACTORY_HINT_H      = 28
local FACTORY_HINT_H_NONE = 8

function ns.CreateTooltipFrame(globalName, moduleRef)
    local f = CreateFrame("Frame", globalName, UIParent, "BackdropTemplate")
    f:SetFrameStrata("TOOLTIP")
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:SetSize(400, 100)
    f:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 14,
        insets   = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    f:SetBackdropColor(0.05, 0.05, 0.05, 0.92)
    f:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    f.header = ns.FontString(f, "DCPFontHeader")
    f.header:SetPoint("TOPLEFT", f, "TOPLEFT", FACTORY_PADDING, -FACTORY_PADDING)
    f.header:SetPoint("TOPRIGHT", f, "TOPRIGHT", -FACTORY_PADDING, -FACTORY_PADDING)
    f.header:SetJustifyH("LEFT")
    f.header:SetTextColor(1, 0.82, 0)
    f.header:SetHeight(FACTORY_HEADER_H)
    f.title = f.header

    f.titleSep = f:CreateTexture(nil, "ARTWORK")
    f.titleSep:SetPoint("TOPLEFT", f.header, "BOTTOMLEFT", 0, -FACTORY_SEP_GAP)
    f.titleSep:SetPoint("RIGHT", f, "RIGHT", -FACTORY_PADDING, 0)
    f.titleSep:SetHeight(1)
    f.titleSep:SetColorTexture(0.5, 0.5, 0.5, 0.5)

    f.hintSep = f:CreateTexture(nil, "ARTWORK")
    f.hintSep:SetHeight(1)
    f.hintSep:SetColorTexture(0.3, 0.3, 0.3, 0.5)
    f.hintSep:Hide()

    f.hint = ns.FontString(f, "DCPFontSmall")
    f.hint:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", FACTORY_PADDING, 10)
    f.hint:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -FACTORY_PADDING, 10)
    f.hint:SetJustifyH("CENTER")
    f.hint:SetTextColor(0.53, 0.53, 0.53)

    f.clipFrame = CreateFrame("Frame", nil, f)
    f.clipFrame:SetClipsChildren(true)

    f.content = CreateFrame("Frame", nil, f.clipFrame)
    f.scrollContent = f.content

    f.scrollOffset  = 0
    f.hScrollOffset = 0
    f.headerExtra   = 0

    f.scrollTrack = f:CreateTexture(nil, "ARTWORK")
    f.scrollTrack:SetPoint("TOPLEFT", f.clipFrame, "TOPRIGHT", 2, 0)
    f.scrollTrack:SetPoint("BOTTOMLEFT", f.clipFrame, "BOTTOMRIGHT", 2, 0)
    f.scrollTrack:SetWidth(4)
    f.scrollTrack:SetColorTexture(1, 1, 1, 0.08)
    f.scrollTrack:Hide()

    f.scrollThumb = f:CreateTexture(nil, "OVERLAY")
    f.scrollThumb:SetWidth(4)
    f.scrollThumb:SetColorTexture(0.8, 0.8, 0.8, 0.4)
    f.scrollThumb:Hide()

    f.hScrollTrack = f:CreateTexture(nil, "ARTWORK")
    f.hScrollTrack:SetPoint("TOPLEFT", f.clipFrame, "BOTTOMLEFT", 0, -2)
    f.hScrollTrack:SetPoint("TOPRIGHT", f.clipFrame, "BOTTOMRIGHT", 0, -2)
    f.hScrollTrack:SetHeight(4)
    f.hScrollTrack:SetColorTexture(1, 1, 1, 0.08)
    f.hScrollTrack:Hide()

    f.hScrollThumb = f:CreateTexture(nil, "OVERLAY")
    f.hScrollThumb:SetHeight(4)
    f.hScrollThumb:SetColorTexture(0.8, 0.8, 0.8, 0.4)
    f.hScrollThumb:Hide()

    f:EnableMouseWheel(true)
    f:SetScript("OnMouseWheel", function(self, delta)
        if IsShiftKeyDown() then
            local contentW = self.content:GetWidth() or 0
            local clipW    = self.clipFrame:GetWidth() or 0
            local maxScroll = math.max(0, contentW - clipW)
            self.hScrollOffset = math.max(0, math.min(maxScroll, self.hScrollOffset - delta * 30))
        else
            local contentH = self.content:GetHeight() or 0
            local clipH    = self.clipFrame:GetHeight() or 0
            local maxScroll = math.max(0, contentH - clipH)
            self.scrollOffset = math.max(0, math.min(maxScroll, self.scrollOffset - delta * 20))
        end
        self.content:ClearAllPoints()
        self.content:SetPoint("TOPLEFT", self.clipFrame, "TOPLEFT", -self.hScrollOffset, self.scrollOffset)
        DCP:UpdateScrollbar(self)
        DCP:UpdateHScrollbar(self)
    end)

    f:SetScript("OnEnter", function()
        if moduleRef.CancelHideTimer then moduleRef:CancelHideTimer() end
    end)
    f:SetScript("OnLeave", function()
        if moduleRef.StartHideTimer then moduleRef:StartHideTimer() end
    end)

    function f:FinalizeLayout(width, contentHeight, contentWidth)
        local padding    = FACTORY_PADDING
        local innerWidth = width - 2 * padding
        contentHeight = math.max(1, contentHeight)
        contentWidth  = contentWidth or innerWidth

        local fixedTop = padding + FACTORY_HEADER_H + FACTORY_SEP_GAP + 1 + FACTORY_CONTENT_GAP
                         + self.headerExtra

        local hintText = self.hint:GetText()
        local hasHint  = hintText and hintText ~= ""
        local hintH
        if hasHint then
            self.hint:SetWidth(innerWidth)
            hintH = math.max(FACTORY_HINT_H, math.ceil(self.hint:GetStringHeight()) + 14)
            self.hint:SetWidth(0)
        else
            hintH = FACTORY_HINT_H_NONE
        end

        local db = moduleRef.GetDB and moduleRef:GetDB() or {}
        local maxH = db.tooltipMaxHeight or math.floor(UIParent:GetHeight() * 0.7)
        local scrollAreaH = math.min(contentHeight, math.max(20, maxH - fixedTop - hintH))

        self.clipFrame:ClearAllPoints()
        self.clipFrame:SetPoint("TOPLEFT", self, "TOPLEFT", padding, -fixedTop)
        self.clipFrame:SetSize(innerWidth, scrollAreaH)

        self.content:SetSize(contentWidth, contentHeight)

        self.scrollOffset  = 0
        self.hScrollOffset = 0
        self.content:ClearAllPoints()
        self.content:SetPoint("TOPLEFT", self.clipFrame, "TOPLEFT", 0, 0)

        self:SetSize(width, fixedTop + scrollAreaH + hintH)

        if hasHint then
            self.hintSep:ClearAllPoints()
            self.hintSep:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", padding, hintH - 1)
            self.hintSep:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -padding, hintH - 1)
            self.hintSep:Show()
        else
            self.hintSep:Hide()
        end

        DCP:UpdateScrollbar(self)
        DCP:UpdateHScrollbar(self)
    end

    f:Hide()
    return f
end

---------------------------------------------------------------------------
-- Tooltip anchor helper
---------------------------------------------------------------------------

function ns.AnchorTooltip(tooltip, anchor, direction)
    direction = direction or "auto"
    local gap = 4
    tooltip:ClearAllPoints()

    local growDown
    if direction == "down" then
        growDown = true
    elseif direction == "up" then
        growDown = false
    else
        local _, anchorY = anchor:GetCenter()
        local screenH = UIParent:GetHeight()
        growDown = anchorY and screenH and (anchorY > screenH / 2)
    end

    if growDown then
        tooltip:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -gap)
    else
        tooltip:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, gap)
    end
end

---------------------------------------------------------------------------
-- ADDON_LOADED — initialise SavedVariables, fonts, modules, settings
---------------------------------------------------------------------------

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(_, _, loadedAddon)
    if loadedAddon ~= addonName then return end
    initFrame:UnregisterEvent("ADDON_LOADED")

    InitFonts()

    local svName = "DjinnisClassProfilesDB"
    if not _G[svName] then _G[svName] = {} end
    MergeDefaults(_G[svName], ns.defaults)
    ns.db = _G[svName]

    -- Settings UI (defined in Settings.lua)
    DCP:SetupOptions()

    -- Slash command
    SLASH_DCP1 = "/dcp"
    SlashCmdList["DCP"] = function()
        if DCP.settingsCategoryID then
            Settings.OpenToCategory(DCP.settingsCategoryID)
        end
    end

    -- Initialise modules
    for _, mod in pairs(ns.modules) do
        if mod.Init then mod:Init() end
    end

    -- Initial data refresh after one frame (some APIs need PLAYER_LOGIN)
    C_Timer.After(1, function()
        for _, mod in pairs(ns.modules) do
            if mod.UpdateData then pcall(mod.UpdateData, mod) end
        end
    end)
end)
