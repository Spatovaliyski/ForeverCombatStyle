-- Forever Combat Style: widget library. A trimmed port of the PlateSCT settings look:
-- warm near-black surfaces, one gold accent, rounded shapes, Source Sans 3 text.
local ADDON_NAME, NS = ...
local W = {}
NS.W = W
local L = NS.L   -- Locales/Locale.lua loads first (see the TOC)

local MEDIA = "Interface\\AddOns\\" .. (ADDON_NAME or "ForeverCombatStyle") .. "\\Media\\"
local WHITE = "Interface\\Buttons\\WHITE8X8"
local ROUND = MEDIA .. "UI\\Round.png"
local CONTROL_WIDTH = 220
local CONTROL_HEIGHT = 32
local ROW_PAD = 12
local ROW_MINIMUM = 48

local C = {
    window = { 0.071, 0.063, 0.051, 1 },
    sidebar = { 0.055, 0.047, 0.039, 1 },
    drawer = { 0.043, 0.039, 0.031, 1 },
    edge = { 0.180, 0.157, 0.122, 1 },
    line = { 0.141, 0.122, 0.094, 1 },
    rule = { 0.125, 0.110, 0.086, 1 },
    field = { 0.106, 0.094, 0.075, 1 },
    fieldHover = { 0.133, 0.118, 0.094, 1 },
    fieldOpen = { 0.141, 0.122, 0.090, 1 },
    selected = { 0.169, 0.145, 0.106, 1 },
    navActive = { 0.133, 0.114, 0.086, 1 },
    hover = { 0.098, 0.086, 0.067, 1 },
    menu = { 0.118, 0.102, 0.078, 1 },
    menuHover = { 0.165, 0.141, 0.106, 1 },
    card = { 0.090, 0.078, 0.059, 1 },
    cardHover = { 0.106, 0.094, 0.071, 1 },
    cardSelected = { 0.110, 0.094, 0.063, 1 },
    accent = { 0.851, 0.682, 0.373, 1 },
    accentHover = { 0.902, 0.741, 0.439, 1 },
    accentDown = { 0.722, 0.573, 0.306, 1 },
    accentSoft = { 0.851, 0.682, 0.373, 0.55 },
    onAccent = { 0, 0, 0 },
    text = { 0.929, 0.902, 0.847 },
    bright = { 0.945, 0.918, 0.863 },
    navText = { 0.788, 0.753, 0.690 },
    muted = { 0.639, 0.604, 0.541 },
    dim = { 0.549, 0.518, 0.459 },
    disabledText = { 0.45, 0.42, 0.37 },
    reasonText = { 0.835, 0.706, 0.506 },
    warning = { 0.141, 0.106, 0.055, 1 },
    warningText = { 0.922, 0.796, 0.576 },
    warningIcon = { 0.914, 0.706, 0.373 },
    switchOff = { 0.180, 0.157, 0.125, 1 },
    switchOffHover = { 0.216, 0.192, 0.153, 1 },
    switchDisabled = { 0.122, 0.106, 0.082, 1 },
    switchOnDisabled = { 0.400, 0.325, 0.192, 1 },
    knobOn = { 0.078, 0.067, 0.047, 1 },
    knobOff = { 0.549, 0.518, 0.459, 1 },
    knobDisabled = { 0.227, 0.200, 0.165, 1 },
    radio = { 0.353, 0.318, 0.267, 1 },
    number = { 1, 0.827, 0.302 },
    incoming = { 1, 0.420, 0.369 },
}
W.COLORS = C
local GOLD, TEXT, MUTED = C.accent, C.text, C.muted

local function RGB(color) return color[1], color[2], color[3] end

local function Hook(frame, event, handler)
    if frame.HookScript then
        frame:HookScript(event, handler)
    else
        local previous = frame:GetScript(event)
        frame:SetScript(event, function(self, ...)
            if previous then previous(self, ...) end
            handler(self, ...)
        end)
    end
end

---------------------------------------------------------------------------------------------------
-- Fonts
---------------------------------------------------------------------------------------------------

local FONT_FILES = {
    regular = "SourceSans3-Regular.ttf",
    medium = "SourceSans3-Medium.ttf",
    semibold = "SourceSans3-Semibold.ttf",
}
-- Korean and Chinese need a font with those glyphs, and Source Sans 3 has none. These are the
-- fonts the game itself uses for each language. STANDARD_TEXT_FONT is not enough: on an English
-- client it is the Latin-only Friz Quadrata, so picking Korean or Chinese there showed boxes.
local CJK_FONTS = {
    koKR = "Fonts\\2002.TTF",
    zhCN = "Fonts\\ARKai_T.ttf",
    zhTW = "Fonts\\bLEI00D.ttf",
}

-- The font file for text in language `code`: Source Sans 3 covers Latin and Cyrillic.
function W.FontPathFor(code, role)
    return CJK_FONTS[code] or (MEDIA .. "Fonts\\" .. (FONT_FILES[role] or FONT_FILES.regular))
end

-- The font for the window's own language.
function W.FontPath(role)
    return W.FontPathFor(NS.ResolveLocaleCode and NS:ResolveLocaleCode() or "", role)
end

-- The client loads a font file on first use; text laid out before that can stay blank.
-- Touch every bundled font at every size the window uses while the addon loads, well before
-- the window is built.
do
    local loader = CreateFrame("Frame")
    loader:Hide()
    for _, file in pairs(FONT_FILES) do
        for _, size in ipairs({ 12, 13, 14, 15, 16, 22 }) do
            local probe = loader:CreateFontString(nil, "ARTWORK")
            pcall(probe.SetFont, probe, MEDIA .. "Fonts\\" .. file, size, "")
            probe:SetText("Aa")
        end
    end
    for _, path in pairs(CJK_FONTS) do
        for _, size in ipairs({ 13, 14, 15, 22 }) do
            local probe = loader:CreateFontString(nil, "ARTWORK")
            pcall(probe.SetFont, probe, path, size, "")
            probe:SetText("Aa")
        end
    end
end

-- Set a font and make sure it took. A font the client rejects can leave the old (or no) font
-- in place without an error, so check the resulting size and fall back to the client font.
function W.SetFont(region, role, size, flags)
    region.optionsRole, region.optionsSize = role or "regular", size
    flags = flags or ""
    if region.SetShadowOffset then region:SetShadowOffset(0, 0) end
    -- `optionsFontPath` pins one region to a font (a language name drawn in its own script).
    local ok, loaded = pcall(region.SetFont, region, region.optionsFontPath or W.FontPath(region.optionsRole), size, flags)
    local _, current = region:GetFont()
    if not ok or loaded == false or not current or math.abs(current - size) > 0.5 then
        pcall(region.SetFont, region, STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF", size, flags)
    end
end

-- Text laid out before its font loaded can stay blank; set it again.
function W.RefreshText(region)
    local text = region:GetText()
    if not text then return end
    region:SetText("")
    region:SetText(text)
end

-- Set a region's own font (the role and size it was given) again. The client can change a
-- button's label font when the button changes state, so buttons do this on every state event.
function W.ReapplyFont(region)
    if region.optionsSize then
        W.SetFont(region, region.optionsRole, region.optionsSize)
    end
end

-- Every label made by W.Text and every button label made by W.Button, so the whole window can
-- be re-laid when it opens.
W.texts = {}

function W.RefreshAllText()
    for _, region in ipairs(W.texts) do
        if region.optionsButtonLabel then W.ReapplyFont(region) end
        W.RefreshText(region)
    end
end

---------------------------------------------------------------------------------------------------
-- Rounded shapes: four quarter-circle corners and three strips, tinted with vertex colors.
---------------------------------------------------------------------------------------------------

local CORNERS = {
    { "TOPLEFT", 1, -1, 0, 0.5, 0, 0.5 },
    { "TOPRIGHT", -1, -1, 0.5, 1, 0, 0.5 },
    { "BOTTOMRIGHT", -1, 1, 0.5, 1, 0.5, 1 },
    { "BOTTOMLEFT", 1, 1, 0, 0.5, 0.5, 1 },
}

local function NoSnap(texture)
    if texture.SetSnapToPixelGrid then texture:SetSnapToPixelGrid(false) end
    if texture.SetTexelSnappingBias then texture:SetTexelSnappingBias(0) end
end

local function NewShape(frame, sublevel)
    local shape = { frame = frame, parts = {} }
    for index = 1, 7 do
        local texture = frame:CreateTexture(nil, "BACKGROUND", nil, sublevel)
        NoSnap(texture)
        shape.parts[index] = texture
    end
    return shape
end

local function LayoutShape(shape, radius, inset, square)
    local key = radius .. ":" .. inset .. ":" .. (square or "")
    if shape.key == key then return end
    shape.key = key
    local frame, parts = shape.frame, shape.parts
    for index, spec in ipairs(CORNERS) do
        local corner = parts[index]
        corner:ClearAllPoints()
        corner:SetPoint(spec[1], frame, spec[1], spec[2] * inset, spec[3] * inset)
        corner:SetSize(radius, radius)
        if square and square:find(tostring(index), 1, true) then
            corner:SetTexture(WHITE); corner:SetTexCoord(0, 1, 0, 1)
        else
            corner:SetTexture(ROUND); corner:SetTexCoord(spec[4], spec[5], spec[6], spec[7])
        end
    end
    local top, middle, bottom = parts[5], parts[6], parts[7]
    for _, strip in ipairs({ top, middle, bottom }) do strip:SetTexture(WHITE); strip:ClearAllPoints() end
    top:SetPoint("TOPLEFT", frame, "TOPLEFT", inset + radius, -inset)
    top:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -inset - radius, -inset)
    top:SetHeight(math.max(radius, 0.01))
    bottom:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", inset + radius, inset)
    bottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -inset - radius, inset)
    bottom:SetHeight(math.max(radius, 0.01))
    middle:SetPoint("TOPLEFT", frame, "TOPLEFT", inset, -inset - radius)
    middle:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -inset, inset + radius)
    shape.rounded = radius > 0
end

local function ColorShape(shape, color)
    for index, part in ipairs(shape.parts) do
        part:SetVertexColor(color[1], color[2], color[3], color[4] or 1)
        part:SetShown(shape.rounded or index == 6)
    end
end

local function HideShape(shape)
    if not shape then return end
    for _, part in ipairs(shape.parts) do part:Hide() end
end

-- Paint a rounded fill, with an optional 1px ring. `square` lists corners (1 TL, 2 TR, 3 BR,
-- 4 BL) that stay square where a panel meets the window edge.
function W.Paint(frame, fill, radius, ring, square)
    radius = radius or 8
    frame.optionsFillShape = frame.optionsFillShape or NewShape(frame, -6)
    if ring then
        frame.optionsRingShape = frame.optionsRingShape or NewShape(frame, -7)
        LayoutShape(frame.optionsRingShape, radius, 0, square)
        ColorShape(frame.optionsRingShape, ring)
        LayoutShape(frame.optionsFillShape, math.max(0, radius - 1), 1, square)
    else
        HideShape(frame.optionsRingShape)
        LayoutShape(frame.optionsFillShape, radius, 0, square)
    end
    ColorShape(frame.optionsFillShape, fill)
    frame.optionsFill = fill
end

function W.Unpaint(frame)
    HideShape(frame.optionsFillShape)
    HideShape(frame.optionsRingShape)
    frame.optionsFill = nil
end

function W.Icon(parent, name, size, color, layer)
    local icon = parent:CreateTexture(nil, layer or "ARTWORK")
    icon:SetTexture(MEDIA .. "UI\\Icons\\" .. name .. ".png")
    icon:SetSize(size or 16, size or 16)
    NoSnap(icon)
    if color then icon:SetVertexColor(color[1], color[2], color[3], color[4] or 1) end
    return icon
end

function W.SetIcon(icon, name)
    icon:SetTexture(MEDIA .. "UI\\Icons\\" .. name .. ".png")
end

function W.Line(parent, color, layer)
    local line = parent:CreateTexture(nil, layer or "BORDER")
    line:SetColorTexture(RGB(color or C.line))
    return line
end

local function Circle(parent, size, color, layer, sublevel)
    local circle = parent:CreateTexture(nil, layer or "ARTWORK", nil, sublevel)
    circle:SetTexture(ROUND)
    circle:SetSize(size, size)
    NoSnap(circle)
    if color then circle:SetVertexColor(color[1], color[2], color[3], color[4] or 1) end
    return circle
end

local KINDS = {
    window = { fill = C.window, radius = 10, ring = C.edge },
    control = { fill = C.field, radius = 8 },
    menu = { fill = C.menu, radius = 10, ring = C.edge },
    focus = { fill = C.fieldOpen, radius = 8, ring = C.accentSoft },
    cardSelected = { fill = C.cardSelected, radius = 10, ring = C.accent },
}

function W.Backdrop(frame, kind, radius)
    local spec = KINDS[kind]
    if not spec then W.Unpaint(frame); return end
    W.Paint(frame, spec.fill, radius or spec.radius, spec.ring)
end

---------------------------------------------------------------------------------------------------
-- Text
---------------------------------------------------------------------------------------------------

-- Created from a Blizzard font template, as PlateSCT does: if the bundled font ever fails to
-- apply, the label keeps the template's font instead of going blank.
function W.Text(parent, text, x, y, width, color, role, size)
    local label = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    W.SetFont(label, role or "regular", size or 14)
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", x or 0, y or 0)
    if width then label:SetWidth(width) end
    label:SetJustifyH("LEFT")
    label:SetJustifyV("TOP")
    label:SetSpacing(4)
    label:SetWordWrap(true)
    label:SetText(text or "")
    label:SetTextColor(RGB(color or TEXT))
    W.texts[#W.texts + 1] = label
    return label
end

-- Supporting text under a label: one step smaller than the label.
function W.SetSmall(region)
    W.SetFont(region, region.optionsRole or "regular", 13)
    region:SetSpacing(3)
    return region
end

-- Tooltip for a frame. `source` is a string, or a function returning a string or a table
-- { title =, body =, foot = } (foot is drawn in the accent color, e.g. a CVar name).
function W.Tooltip(owner, source)
    if not source then return end
    Hook(owner, "OnEnter", function(self)
        local tip = type(source) == "function" and source(self) or source
        if not tip or tip == "" or not GameTooltip then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if type(tip) == "table" then
            GameTooltip:AddLine(tip.title or "", 1, 1, 1)
            if tip.body and tip.body ~= "" then GameTooltip:AddLine(tip.body, 0.85, 0.85, 0.85, true) end
            if tip.foot and tip.foot ~= "" then GameTooltip:AddLine(tip.foot, GOLD[1], GOLD[2], GOLD[3]) end
        else
            GameTooltip:AddLine(tip, 1, 1, 1, true)
        end
        GameTooltip:Show()
    end)
    Hook(owner, "OnLeave", function()
        if GameTooltip then GameTooltip:Hide() end
    end)
end

---------------------------------------------------------------------------------------------------
-- Buttons. Styles: "action" (gold pill), "flat" (filled field), "nav" (sidebar page),
-- "utility" (quiet sidebar link), "ghost" (no fill until hovered), "segment" (tab/segment).
---------------------------------------------------------------------------------------------------

local ACTION_FACES = {
    idle = { fill = C.accent, text = C.onAccent },
    hover = { fill = C.accentHover, text = C.onAccent },
    down = { fill = C.accentDown, text = C.onAccent },
    selected = { fill = C.accentHover, text = C.onAccent },
    disabled = { fill = { 0.200, 0.176, 0.141, 1 }, text = C.disabledText },
}

function W.PaintAction(frame, mode)
    if mode == "idle" and frame.IsMouseOver and frame:IsMouseOver() then mode = "hover" end
    if frame.IsEnabled and not frame:IsEnabled() then mode = "disabled" end
    local face = ACTION_FACES[mode] or ACTION_FACES.idle
    W.Paint(frame, face.fill, frame.optionsRadius or 8)
    local font = frame.GetFontString and frame:GetFontString()
    if font and face.text then font:SetTextColor(RGB(face.text)) end
end

local function PaintButton(button)
    local style = button.optionsStyle
    if style == "action" then
        W.PaintAction(button, button.optionsSelected and "selected" or "idle")
        return
    end
    local enabled = not button.IsEnabled or button:IsEnabled()
    local over = enabled and button.IsMouseOver and button:IsMouseOver()
    local selected, open = button.optionsSelected, button.optionsOpen
    local fill, text, icon
    if style == "flat" then
        fill = open and C.fieldOpen or selected and C.selected or over and C.fieldHover or C.field
        text = not enabled and C.disabledText or selected and C.accent or C.bright
    elseif style == "menu" then
        fill = over and C.menuHover or nil
        text = selected and C.accent or over and C.bright or C.text
    elseif style == "segment" then
        fill = selected and C.selected or over and C.navActive or nil
        text = selected and C.accent or over and C.bright or C.muted
    elseif style == "nav" then
        fill = selected and C.navActive or over and C.hover or nil
        text = selected and C.accent or over and C.bright or C.navText
        icon = selected and C.accent or over and C.navText or C.dim
    else -- utility, ghost
        fill = selected and C.navActive or over and C.hover or nil
        text = selected and C.accent or over and C.bright or C.muted
        icon = text
    end
    if fill then W.Paint(button, fill, button.optionsRadius or 8) else W.Unpaint(button) end
    local font = button:GetFontString()
    if font then font:SetTextColor(RGB(text)) end
    if button.optionsIcon and icon then button.optionsIcon:SetVertexColor(RGB(icon)) end
end
W.PaintButton = PaintButton

function W.SetSelected(button, selected)
    button.optionsSelected = selected and true or false
    PaintButton(button)
end

function W.Button(parent, label, width, height, onClick, style)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(width or 160, height or 32)
    style = style or "action"
    button.optionsStyle = style
    -- No Blizzard font template: the client can reapply template colors after PaintButton runs.
    local font = button:CreateFontString(nil, "OVERLAY")
    W.SetFont(font, (style == "action") and "semibold"
        or (style == "utility" or style == "menu") and "regular" or "medium", 14)
    button:SetFontString(font)
    button:SetText(label or "")
    font:ClearAllPoints()
    local centered = style == "action" or style == "segment" or style == "flat"
    local inset = centered and 14 or 12
    font:SetPoint("LEFT", inset, 0)
    font:SetPoint("RIGHT", -inset, 0)
    font:SetJustifyH(centered and "CENTER" or "LEFT")
    font:SetWordWrap(false)
    -- The client can change the label's font when the button changes state (shown, hovered,
    -- enabled, pressed), as PlateSCT found, so set the addon font again on each of those events.
    -- These hooks come before the paint hooks below: the font goes on first, the color last.
    font.optionsButtonLabel = true
    W.texts[#W.texts + 1] = font
    for _, event in ipairs({ "OnEnter", "OnLeave", "OnEnable", "OnDisable", "OnShow", "OnMouseUp" }) do
        Hook(button, event, function() W.ReapplyFont(font) end)
    end
    Hook(button, "OnEnter", function(self)
        if self.optionsStyle == "action" then W.PaintAction(self, "hover") else PaintButton(self) end
    end)
    Hook(button, "OnLeave", PaintButton)
    Hook(button, "OnEnable", PaintButton)
    Hook(button, "OnDisable", PaintButton)
    Hook(button, "OnShow", PaintButton)
    if style == "action" then
        Hook(button, "OnMouseDown", function(self)
            if self:IsEnabled() then W.PaintAction(self, "down") end
        end)
        Hook(button, "OnMouseUp", PaintButton)
    end
    button:SetScript("OnClick", function(self, ...)
        if self:IsEnabled() and onClick then onClick(self, ...) end
    end)
    PaintButton(button)
    return button
end

-- Sidebar page with a leading icon.
function W.NavButton(parent, label, icon, width, height, onClick, style)
    local button = W.Button(parent, label, width, height, onClick, style or "nav")
    local iconSize = button.optionsStyle == "nav" and 16 or 15
    button.optionsIcon = W.Icon(button, icon, iconSize)
    button.optionsIcon:SetPoint("LEFT", 10, 0)
    local font = button:GetFontString()
    font:ClearAllPoints()
    font:SetPoint("LEFT", 36, 0)
    font:SetPoint("RIGHT", -8, 0)
    PaintButton(button)
    return button
end

function W.CloseButton(parent, onClick)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(32, 32)
    local icon = W.Icon(button, "Close", 16, C.muted)
    icon:SetPoint("CENTER")
    button.icon = icon
    button:SetScript("OnEnter", function(self)
        W.Paint(self, C.hover, 8); self.icon:SetVertexColor(RGB(C.bright))
    end)
    button:SetScript("OnLeave", function(self)
        W.Unpaint(self); self.icon:SetVertexColor(RGB(C.muted))
    end)
    button:SetScript("OnClick", function(self, ...)
        if onClick then onClick(self, ...) end
    end)
    return button
end

function W.EditBox(parent, width, height)
    local box = CreateFrame("EditBox", nil, parent)
    box:SetSize(width or CONTROL_WIDTH, height or CONTROL_HEIGHT)
    box:SetAutoFocus(false)
    W.Backdrop(box, "control")
    W.SetFont(box, "medium", 14)
    box:SetTextInsets(10, 10, 0, 0)
    box:SetJustifyH("LEFT")
    box:SetTextColor(RGB(C.bright))
    return box
end

---------------------------------------------------------------------------------------------------
-- Switch
---------------------------------------------------------------------------------------------------

local KNOB_SIZE, KNOB_INSET = 16, 4
local THUMB_SIZE = 14

function W.Switch(parent)
    local control = CreateFrame("CheckButton", nil, parent)
    control:SetSize(40, 24)
    if control.SetHitRectInsets then control:SetHitRectInsets(-6, -6, -8, -8) end
    control.knob = Circle(control, KNOB_SIZE, C.knobOff, "ARTWORK")
    function control:Paint()
        local on = self:GetChecked() and true or false
        local enabled = self:IsEnabled()
        local over = enabled and self.IsMouseOver and self:IsMouseOver()
        local track = not enabled and (on and C.switchOnDisabled or C.switchDisabled)
            or on and (over and C.accentHover or C.accent) or (over and C.switchOffHover or C.switchOff)
        local knobColor = not enabled and C.knobDisabled or on and C.knobOn or C.knobOff
        W.Paint(self, track, 12)
        self.knob:SetVertexColor(RGB(knobColor))
        self.knob:ClearAllPoints()
        self.knob:SetPoint("LEFT", self, "LEFT", on and (40 - KNOB_SIZE - KNOB_INSET) or KNOB_INSET, 0)
    end
    control:SetScript("OnEnter", function(self) self:Paint() end)
    control:SetScript("OnLeave", function(self) self:Paint() end)
    return control
end

---------------------------------------------------------------------------------------------------
-- Dropdown menu: one shared popup, opened by layout:Choice controls (a trimmed port of the
-- PlateSCT menu). A full-screen layer behind it closes it on any outside click.
---------------------------------------------------------------------------------------------------

local MENU_ROW, MENU_PAD = 32, 6
local menuFrame

local function CreateMenu()
    local layer = CreateFrame("Button", nil, UIParent)
    layer:SetAllPoints(UIParent)
    layer:SetFrameStrata("FULLSCREEN_DIALOG")
    layer:EnableMouse(true)
    layer:EnableMouseWheel(true)
    layer:Hide()
    local menu = CreateFrame("Frame", nil, layer)
    menu:SetFrameStrata("FULLSCREEN_DIALOG")
    menu:SetFrameLevel(layer:GetFrameLevel() + 2)
    menu:SetClampedToScreen(true)
    menu:EnableMouse(true)
    menu:EnableMouseWheel(true)
    W.Backdrop(menu, "menu")
    menu.entries, menu.layer = {}, layer
    local scroll = CreateFrame("ScrollFrame", nil, menu)
    scroll:SetPoint("TOPLEFT", MENU_PAD, -MENU_PAD)
    scroll:SetPoint("BOTTOMRIGHT", -MENU_PAD, MENU_PAD)
    scroll:EnableMouseWheel(true)
    local child = CreateFrame("Frame", nil, scroll)
    scroll:SetScrollChild(child)
    menu.scroll, menu.child = scroll, child
    function menu.MouseWheel(_, delta)
        local maximum = math.max(0, child:GetHeight() - scroll:GetHeight())
        scroll:SetVerticalScroll(math.max(0, math.min(maximum, scroll:GetVerticalScroll() - delta * MENU_ROW)))
    end
    layer:SetScript("OnMouseWheel", function() end)
    layer:SetScript("OnClick", function() menu:Hide() end)
    menu:SetScript("OnMouseWheel", menu.MouseWheel)
    scroll:SetScript("OnMouseWheel", menu.MouseWheel)
    menu:SetScript("OnHide", function(self)
        layer:Hide()
        local owner = self.owner
        self.owner = nil
        if owner then
            owner.optionsOpen = nil
            if owner.optionsTrailing then W.SetIcon(owner.optionsTrailing, "ChevronDown") end
            PaintButton(owner)
        end
    end)
    return menu
end

-- Close the popup if it is open (the window calls this when it hides).
function W.CloseMenu()
    if menuFrame then menuFrame:Hide() end
end

-- `control.choices` is { { id =, label =, font = }, ... }; `font` (optional) is the font file
-- the entry is drawn in. control.get() returns the current id and control.set(id) is called
-- when an entry is picked.
local function OpenMenu(control)
    if not control:IsEnabled() then return end
    if menuFrame and menuFrame.owner == control then menuFrame:Hide(); return end
    menuFrame = menuFrame or CreateMenu()
    local menu = menuFrame
    menu:Hide()   -- hand over from any other owner
    menu.layer:SetScale(control:GetEffectiveScale() / UIParent:GetEffectiveScale())
    menu.owner = control
    local choices, selected = control.choices, control.get()
    for _, entry in ipairs(menu.entries) do entry:Hide() end
    local width = control:GetWidth()
    for index, choice in ipairs(choices) do
        local entry = menu.entries[index]
        if not entry then
            entry = W.Button(menu.child, "", width, MENU_ROW, nil, "menu")
            entry.optionsRadius = 6
            entry:EnableMouseWheel(true)
            entry:SetScript("OnMouseWheel", menu.MouseWheel)
            local font = entry:GetFontString()
            font:SetPoint("LEFT", 10, 0)
            font:SetPoint("RIGHT", -30, 0)
            entry.check = W.Icon(entry, "Check", 15, GOLD, "OVERLAY")
            entry.check:SetPoint("RIGHT", -10, 0)
            menu.entries[index] = entry
        end
        local id = choice.id
        local entryFont = entry:GetFontString()
        entryFont.optionsFontPath = choice.font
        W.SetFont(entryFont, "regular", 14)
        entry:SetText(choice.label)
        W.RefreshText(entryFont)
        entry.check:SetShown(id == selected)
        W.SetSelected(entry, id == selected)
        entry:SetScript("OnClick", function()
            menu:Hide()
            if control:IsEnabled() then control.set(id) end
        end)
        entry:ClearAllPoints()
        entry:SetPoint("TOPLEFT", 0, -(index - 1) * MENU_ROW)
        entry:Show()
        width = math.max(width, (entry:GetFontString():GetStringWidth() or 0) + 60)
    end
    -- Long names widen the popup, within the screen.
    local screenWidth = UIParent:GetWidth() / menu.layer:GetScale()
    width = math.min(width, math.max(CONTROL_WIDTH, screenWidth - 40))
    local fullHeight = math.max(MENU_ROW, #choices * MENU_ROW)
    local screenHeight = UIParent:GetHeight() / menu.layer:GetScale()
    local viewHeight = math.min(fullHeight, math.max(MENU_ROW * 2, screenHeight - 80))
    menu:SetSize(width + MENU_PAD * 2, viewHeight + MENU_PAD * 2)
    menu.child:SetSize(width, fullHeight)
    for _, entry in ipairs(menu.entries) do entry:SetWidth(width) end
    menu:ClearAllPoints()
    local bottom = control:GetBottom()
    if bottom and bottom < viewHeight + 24 then
        menu:SetPoint("BOTTOMRIGHT", control, "TOPRIGHT", 0, 6)
    else
        menu:SetPoint("TOPRIGHT", control, "BOTTOMRIGHT", 0, -6)
    end
    control.optionsOpen = true
    if control.optionsTrailing then W.SetIcon(control.optionsTrailing, "ChevronUp") end
    PaintButton(control)
    menu.layer:Show()
    menu:Show()
    -- Keep the current choice in view when the list is taller than the popup.
    menu.scroll:SetVerticalScroll(0)
    for index, choice in ipairs(choices) do
        if choice.id == selected then
            menu.scroll:SetVerticalScroll(math.min(math.max(0, fullHeight - viewHeight), (index - 1) * MENU_ROW))
            break
        end
    end
    menu:Raise()
end

---------------------------------------------------------------------------------------------------
-- Scroll view: a page that scrolls with the wheel and a slim thumb.
---------------------------------------------------------------------------------------------------

function W.ScrollView(parent, root)
    local host = CreateFrame("Frame", nil, parent)
    host:SetAllPoints(); host:Hide()
    local scroll = CreateFrame("ScrollFrame", nil, host)
    scroll:SetPoint("TOPLEFT"); scroll:SetPoint("BOTTOMRIGHT", -18, 0)
    scroll:EnableMouseWheel(true)
    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(598, 1)
    scroll:SetScrollChild(child)
    local track = CreateFrame("Frame", nil, host)
    track:SetWidth(8); track:SetPoint("TOPRIGHT", -4, -8); track:SetPoint("BOTTOMRIGHT", -4, 8)
    track:EnableMouse(true); track:EnableMouseWheel(true)
    local thumb = CreateFrame("Button", nil, track)
    thumb:SetWidth(6); thumb:RegisterForDrag("LeftButton")
    W.Paint(thumb, C.edge, 3)
    thumb:SetScript("OnEnter", function(self) W.Paint(self, C.radio, 3) end)
    thumb:SetScript("OnLeave", function(self) W.Paint(self, C.edge, 3) end)
    local function MaxScroll() return math.max(0, child:GetHeight() - scroll:GetHeight()) end
    local function Update()
        local maximum, height = MaxScroll(), track:GetHeight()
        local position = math.min(maximum, math.max(0, scroll:GetVerticalScroll()))
        if position ~= scroll:GetVerticalScroll() then scroll:SetVerticalScroll(position) end
        track:SetShown(maximum > 0 and height > 0)
        if maximum <= 0 or height <= 0 then return end
        local size = math.min(height, math.max(28, height * scroll:GetHeight() / child:GetHeight()))
        thumb:SetHeight(size); thumb:ClearAllPoints()
        thumb:SetPoint("TOP", track, "TOP", 0, -(height - size) * position / maximum)
    end
    local function SetScroll(value)
        scroll:SetVerticalScroll(math.min(MaxScroll(), math.max(0, value)))
        Update()
    end
    local function Wheel(_, delta)
        SetScroll(scroll:GetVerticalScroll() - delta * 40)
    end
    scroll:SetScript("OnMouseWheel", Wheel)
    child:EnableMouseWheel(true); child:SetScript("OnMouseWheel", Wheel)
    track:SetScript("OnMouseWheel", Wheel)
    scroll:SetScript("OnVerticalScroll", Update)
    scroll:SetScript("OnScrollRangeChanged", Update)
    scroll:SetScript("OnSizeChanged", function(_, width)
        if width and width > 0 then child:SetWidth(width) end
        Update()
    end)
    child:SetScript("OnSizeChanged", Update)
    thumb:SetScript("OnDragStart", function(self)
        local _, cursor = GetCursorPosition()
        self.startCursor, self.startScroll = cursor / root:GetEffectiveScale(), scroll:GetVerticalScroll()
        self:SetScript("OnUpdate", function()
            local _, current = GetCursorPosition()
            local travel = math.max(1, track:GetHeight() - thumb:GetHeight())
            SetScroll(self.startScroll + (self.startCursor - current / root:GetEffectiveScale()) * MaxScroll() / travel)
        end)
    end)
    thumb:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
    host:SetScript("OnHide", function() thumb:SetScript("OnUpdate", nil) end)
    host.scroll, host.child, host.UpdateScroll = scroll, child, Update
    host.SetScroll = function(_, value) SetScroll(value) end
    return host
end

---------------------------------------------------------------------------------------------------
-- Layout: headings and rows (label + control) on a scrolling page. Descriptions are tooltips.
---------------------------------------------------------------------------------------------------

local function FormatValue(setting, value)
    return string.format("%." .. (setting.decimals or 2) .. "f", value)
end

-- A painted warning with its icon, as in PlateSCT. The box fits the text.
function W.WarningBox(parent, text, width)
    local box = CreateFrame("Frame", nil, parent)
    box:SetSize(width, 40)
    W.Paint(box, C.warning, 8)
    local icon = W.Icon(box, "Warning", 16, C.warningIcon)
    icon:SetPoint("TOPLEFT", 14, -13)
    local label = W.Text(box, text, 40, -12, width - 54, C.warningText, "regular", 14)
    box:SetHeight(math.max(18, label:GetStringHeight()) + 24)
    return box, label
end

-- opts: width (initial column width), padLeft, padRight, controlWidth
function W.NewLayout(parent, root, opts)
    opts = opts or {}
    local PAD_LEFT, PAD_RIGHT = opts.padLeft or 32, opts.padRight or 14
    local CONTROL = opts.controlWidth or CONTROL_WIDTH
    local layout = { parent = parent, root = root, x = PAD_LEFT, rows = {},
        width = math.max(200, (opts.width or parent:GetWidth()) - PAD_LEFT - PAD_RIGHT) }

    local function ControlWidth(total)
        return math.min(CONTROL, math.floor(total * 0.6))
    end

    function layout:AddRow(row, caption, kind)
        row.layoutCaption, row.layoutKind = caption, kind
        row.layoutGap = (kind == "heading" and #self.rows > 0) and 28 or 0
        self.rows[#self.rows + 1] = row
    end

    function layout:Heading(text)
        local row = CreateFrame("Frame", nil, parent)
        row:SetSize(self.width, 28)
        local label = W.Text(row, text, 0, -2, self.width, GOLD, "semibold", 15)
        local line = row:CreateTexture(nil, "ARTWORK")
        line:SetPoint("BOTTOMLEFT", 0, 2)
        line:SetPoint("BOTTOMRIGHT", 0, 2)
        line:SetHeight(1)
        line:SetColorTexture(RGB(C.line))
        self:AddRow(row, label, "heading")
        return label
    end

    -- A warning under the settings it concerns; sits a little below the previous row.
    function layout:Warning(text)
        local box, label = W.WarningBox(parent, text, self.width)
        self:AddRow(box, label, "warning")
        box.layoutGap = 16
        return label
    end

    -- Small supporting text on its own row, under the heading it belongs to.
    function layout:Note(text)
        local row = CreateFrame("Frame", nil, parent)
        row:SetSize(self.width, 28)
        local label = W.SetSmall(W.Text(row, text, 0, -2, self.width, MUTED))
        self:AddRow(row, label, "note")
        return label
    end

    -- A row: caption and a one-line description on the left, the control on the right.
    function layout:NewRow(label, tip)
        local row = CreateFrame("Frame", nil, parent)
        row:SetSize(self.width, ROW_MINIMUM)
        row:EnableMouse(true)
        local rule = row:CreateTexture(nil, "BACKGROUND")
        rule:SetHeight(1)
        rule:SetPoint("BOTTOMLEFT"); rule:SetPoint("BOTTOMRIGHT")
        rule:SetColorTexture(RGB(C.rule))
        local controlWidth = ControlWidth(self.width)
        local textWidth = self.width - controlWidth - 24
        local caption = W.Text(row, label, 0, -ROW_PAD, textWidth, TEXT, "medium", 14)
        local description = W.SetSmall(W.Text(row, tip or "", 0, 0, textWidth, MUTED))
        row.layoutDescription, row.tip = description, tip
        row.minimumHeight = ROW_MINIMUM
        self:AddRow(row, caption, "control")
        return row, caption, controlWidth
    end

    -- The CVar name stays in a tooltip; the description is already written under the label.
    local function Register(control, row, setting)
        control.row, control.setting = row, setting
        row.layoutControl = control
        root.controls[#root.controls + 1] = control
        local function Tip()
            local note = (not NS.available[setting.cvar]) and L["Not available on this client."] or nil
            return { title = L[setting.label], body = note, foot = setting.cvar }
        end
        W.Tooltip(row, Tip)
        W.Tooltip(control, Tip)
    end

    local function SetControlEnabled(control, enabled)
        if control.SetEnabled then
            control:SetEnabled(enabled)
        elseif enabled and control.Enable then
            control:Enable()
        elseif not enabled and control.Disable then
            control:Disable()
        end
    end

    -- Greys the row when the client does not know the CVar. Colors and the control's own alpha
    -- change; the row frame itself is never faded.
    local function SetAvailable(control)
        local available = NS.available[control.setting.cvar] and true or false
        local row = control.row
        row.layoutDescription:SetText(available and (row.tip or "") or L["This setting is not available on this client."])
        control.row.layoutCaption:SetTextColor(RGB(available and TEXT or C.disabledText))
        control:SetAlpha(available and 1 or 0.45)
        SetControlEnabled(control, available)
        return available
    end

    function layout:Slider(setting)
        local row, caption, controlWidth = self:NewRow(L[setting.label], L[setting.tip])
        local minimum, maximum, step = setting.min, setting.max, setting.step
        local control = CreateFrame("Slider", nil, row)
        control:SetOrientation("HORIZONTAL")
        control:SetSize(controlWidth - 64, 20)
        control:SetMinMaxValues(minimum, maximum)
        control:SetValueStep(step)
        if control.SetObeyStepOnDrag then control:SetObeyStepOnDrag(true) end
        if control.SetHitRectInsets then control:SetHitRectInsets(-4, -4, -8, -8) end
        control:EnableMouseWheel(true)
        control:SetThumbTexture(ROUND)
        local thumb = control:GetThumbTexture()
        if thumb then thumb:SetSize(THUMB_SIZE, THUMB_SIZE); thumb:SetVertexColor(RGB(C.bright)); NoSnap(thumb) end
        control.thumb = thumb
        local rail = CreateFrame("Frame", nil, control)
        rail:SetHeight(4)
        rail:SetPoint("LEFT", 0, 0); rail:SetPoint("RIGHT", 0, 0)
        rail:SetFrameLevel(math.max(0, control:GetFrameLevel() - 1))
        W.Paint(rail, C.switchOff, 2)
        local fill = CreateFrame("Frame", nil, rail)
        fill:SetPoint("TOPLEFT"); fill:SetPoint("BOTTOMLEFT")
        W.Paint(fill, GOLD, 2)
        control.rail, control.fill = rail, fill
        local valueText = W.Text(row, "", 0, 0, 52, C.bright, "medium", 14)
        valueText:ClearAllPoints()
        valueText:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, -ROW_PAD)
        valueText:SetJustifyH("RIGHT")
        valueText:SetWordWrap(false)
        control.valueText = valueText
        control.layoutType = "slider"
        Register(control, row, setting)

        local function Normalize(value)
            value = math.max(minimum, math.min(maximum, value))
            value = minimum + math.floor((value - minimum) / step + 0.5) * step
            return tonumber(FormatValue(setting, math.max(minimum, math.min(maximum, value))))
        end
        function control:PaintFill(value)
            local width = self:GetWidth()
            if not width or width <= 0 then return end
            local ratio = (math.max(minimum, math.min(maximum, value)) - minimum) / (maximum - minimum)
            self.fill:SetWidth(math.max(4, THUMB_SIZE / 2 + ratio * (width - THUMB_SIZE)))
        end
        local function Display(value)
            valueText:SetText(FormatValue(setting, value))
            control:PaintFill(value)
        end

        -- Clicking the readout types an exact value. It may go past the slider's drag range.
        local edit = W.EditBox(row, 68, 28)
        edit:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, -(ROW_PAD - 2))
        edit:SetJustifyH("RIGHT")
        edit:SetMaxLetters(8)
        edit:Hide()
        local entry = CreateFrame("Button", nil, row)
        entry:SetPoint("TOPRIGHT", valueText, "TOPRIGHT", 4, 4)
        entry:SetSize(56, 22)
        local underline = entry:CreateTexture(nil, "ARTWORK")
        underline:SetPoint("BOTTOMLEFT", 4, 2); underline:SetPoint("BOTTOMRIGHT", -4, 2)
        underline:SetHeight(1); underline:SetColorTexture(RGB(GOLD)); underline:Hide()
        entry:SetScript("OnEnter", function()
            if control:IsEnabled() then valueText:SetTextColor(RGB(GOLD)); underline:Show() end
        end)
        entry:SetScript("OnLeave", function() valueText:SetTextColor(RGB(C.bright)); underline:Hide() end)
        entry:SetScript("OnClick", function()
            if not control:IsEnabled() then return end
            entry:Hide(); valueText:Hide()
            edit:SetText(FormatValue(setting, NS.values[setting.cvar]))
            edit:Show(); edit:SetFocus(); edit:HighlightText()
        end)
        W.Tooltip(entry, function()
            if not control:IsEnabled() then return nil end
            return L["Click to type an exact value."]
        end)
        local function CloseEntry()
            edit:Hide(); entry:Show(); valueText:Show()
        end
        edit:SetScript("OnEnterPressed", function(self)
            local number = tonumber((string.gsub(self:GetText() or "", ",", ".")))
            CloseEntry(); self:ClearFocus()
            if number then NS.Set(setting.cvar, number) end
            control:Refresh()
        end)
        edit:SetScript("OnEscapePressed", function(self) CloseEntry(); self:ClearFocus() end)
        edit:SetScript("OnEditFocusLost", function() CloseEntry() end)

        control:SetScript("OnValueChanged", function(self, value)
            if self.refreshing or not self:IsEnabled() then return end
            value = Normalize(value)
            if math.abs(value - (NS.values[setting.cvar] or 0)) > step / 2 then
                NS.Set(setting.cvar, value)
            end
            Display(NS.values[setting.cvar])
        end)
        control:SetScript("OnMouseWheel", function(self, delta)
            if not self:IsEnabled() then return end
            NS.Set(setting.cvar, Normalize((NS.values[setting.cvar] or minimum) + step * delta))
            self:Refresh()
        end)
        control:SetScript("OnSizeChanged", function(self) self:PaintFill(NS.values[setting.cvar] or minimum) end)
        function control:Refresh()
            local value = NS.values[setting.cvar] or setting.default
            self.refreshing = true
            self:SetValue(math.max(minimum, math.min(maximum, value)))
            self.refreshing = nil
            Display(value)
            local available = SetAvailable(self)
            valueText:SetTextColor(RGB(available and C.bright or C.disabledText))
            if self.thumb then self.thumb:SetVertexColor(RGB(available and C.bright or C.knobDisabled)) end
            W.Paint(self.fill, available and GOLD or C.switchOnDisabled, 2)
        end
        control:Refresh()
        return control
    end

    -- Two or three exact choices as a segmented control.
    function layout:Segments(setting)
        local row, caption, controlWidth = self:NewRow(L[setting.label], L[setting.tip])
        local control = CreateFrame("Frame", nil, row)
        control:SetHeight(36)
        W.Paint(control, C.field, 9)
        control.layoutType = "segments"
        control.segments = {}
        Register(control, row, setting)
        for _, option in ipairs(setting.options) do
            local value = option[1]
            local segment = W.Button(control, L[option[2]], 60, 30, function()
                if NS.available[setting.cvar] then
                    NS.Set(setting.cvar, value)
                    control:Refresh()
                end
            end, "segment")
            segment.optionsRadius = 7
            segment.value = value
            control.segments[#control.segments + 1] = segment
        end
        function control:Fit(width)
            local count = #self.segments
            local each = math.floor((width - 6 - 2 * (count - 1)) / count)
            for index, segment in ipairs(self.segments) do
                segment:ClearAllPoints()
                segment:SetPoint("LEFT", self, "LEFT", 3 + (index - 1) * (each + 2), 0)
                segment:SetWidth(each)
            end
        end
        function control:Refresh()
            local current = NS.values[setting.cvar] or setting.default
            for _, segment in ipairs(self.segments) do
                W.SetSelected(segment, math.abs(segment.value - current) < 0.01)
            end
            SetAvailable(self)
        end
        control:Fit(controlWidth)
        control:Refresh()
        return control
    end

    function layout:Switch(label, tip, get, set)
        local row = self:NewRow(label, tip)
        local control = W.Switch(row)
        control.layoutType = "switch"
        row.layoutControl = control
        root.controls[#root.controls + 1] = control
        control:SetScript("OnClick", function(self)
            set(self:GetChecked() and true or false)
            self:Paint()
        end)
        function control:Refresh()
            self:SetChecked(get() and true or false)
            self:Paint()
        end
        control:Refresh()
        return control
    end

    -- An on/off switch bound to a 0 / 1 CVar.
    function layout:Toggle(setting)
        local row = self:NewRow(L[setting.label], L[setting.tip])
        local control = W.Switch(row)
        control.layoutType = "switch"
        Register(control, row, setting)
        control:SetScript("OnClick", function(self)
            if NS.available[setting.cvar] then
                NS.Set(setting.cvar, self:GetChecked() and 1 or 0)
            end
            self:Refresh()
        end)
        function control:Refresh()
            self:SetChecked((NS.values[setting.cvar] or setting.default) ~= 0)
            SetAvailable(self)
            self:Paint()
        end
        control:Refresh()
        return control
    end

    -- A dropdown: the current choice on a button, the rest in a popup menu. `choices` is
    -- { { id =, label = }, ... } (labels already translated); get() returns the current id.
    function layout:Choice(label, tip, choices, get, set)
        local row, _, controlWidth = self:NewRow(label, tip)
        local control = W.Button(row, "", controlWidth, CONTROL_HEIGHT, nil, "flat")
        control.layoutType = "choice"
        local font = control:GetFontString()
        font:SetPoint("LEFT", 12, 0)
        font:SetPoint("RIGHT", -32, 0)
        font:SetJustifyH("LEFT")
        font:SetWordWrap(false)
        control.optionsTrailing = W.Icon(control, "ChevronDown", 16, C.muted, "OVERLAY")
        control.optionsTrailing:SetPoint("RIGHT", -10, 0)
        control.choices, control.get, control.set = choices, get, set
        row.layoutControl = control
        root.controls[#root.controls + 1] = control
        control:SetScript("OnClick", function() OpenMenu(control) end)
        Hook(control, "OnHide", function()
            if menuFrame and menuFrame.owner == control then menuFrame:Hide() end
        end)
        function control:Refresh()
            local value, text = self.get(), ""
            for _, choice in ipairs(self.choices) do
                if choice.id == value then text = choice.label; break end
            end
            self:SetText(text)
        end
        control:Refresh()
        return control
    end

    -- A description on the left and a button on the right that runs `onClick`.
    function layout:Action(label, tip, onClick)
        local row = self:NewRow("", tip)
        local control = W.Button(row, label, 160, CONTROL_HEIGHT, function() onClick() end, "flat")
        control.layoutType = "action"
        row.layoutControl = control
        return control
    end

    -- Size a row to its caption and control; returns its height.
    local function PlaceControlRow(row, width)
        local caption, control = row.layoutCaption, row.layoutControl
        local controlWidth = ControlWidth(width)
        local controlHeight = CONTROL_HEIGHT
        local textWidth = width - controlWidth - 24
        if control.layoutType == "switch" then
            textWidth = width - 40 - 24
            controlHeight = 24
        elseif control.layoutType == "slider" then
            control:SetWidth(controlWidth - 64)
            controlHeight = 20
        elseif control.layoutType == "segments" then
            control:SetWidth(controlWidth)
            control:Fit(controlWidth)
            controlHeight = 36
        elseif control.layoutType == "choice" then
            control:SetWidth(controlWidth)
        elseif control.layoutType == "action" then
            control:SetWidth(math.min(160, controlWidth))
        end
        caption:SetWidth(textWidth)
        local description = row.layoutDescription
        description:SetWidth(textWidth)
        description:ClearAllPoints()
        local top = ROW_PAD + caption:GetStringHeight() + 4
        description:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -top)
        local textHeight = top - ROW_PAD + description:GetStringHeight()
        local height = math.max(row.minimumHeight, ROW_PAD * 2 + math.max(textHeight, controlHeight))
        -- Center the control against the text block.
        local controlY = -math.floor((height - controlHeight) / 2 + 0.5)
        control:ClearAllPoints()
        if control.layoutType == "slider" then
            control:SetPoint("TOPRIGHT", row, "TOPRIGHT", -64, controlY)
            control.valueText:ClearAllPoints()
            control.valueText:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, controlY + 1)
            control:PaintFill(tonumber(control:GetValue()) or 0)
        else
            control:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, controlY)
        end
        return height
    end

    -- Position every row; returns the column height.
    function layout:Reflow()
        local y = 0
        for _, row in ipairs(self.rows) do
            y = y - row.layoutGap
            local caption = row.layoutCaption
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", self.x, y)
            row:SetWidth(self.width)
            local height
            if row.layoutKind == "heading" then
                caption:SetWidth(self.width)
                height = math.max(24, caption:GetStringHeight() + 12)
            elseif row.layoutKind == "warning" then
                caption:SetWidth(self.width - 54)
                height = math.max(18, caption:GetStringHeight()) + 24
            elseif row.layoutKind == "note" then
                caption:SetWidth(self.width)
                height = math.max(16, caption:GetStringHeight()) + 12
            else
                height = PlaceControlRow(row, self.width)
            end
            row:SetHeight(height)
            y = y - height
        end
        parent:SetHeight(math.max(1, -y + 24))
        return -y + 24
    end

    function layout:Finish()
        root.layouts[#root.layouts + 1] = self
        -- Resizing the page changes the column width: rewrap every row to it.
        Hook(parent, "OnSizeChanged", function(_, newWidth)
            local fitted = math.max(200, (newWidth or 0) - PAD_LEFT - PAD_RIGHT)
            if newWidth and newWidth > 0 and math.abs(fitted - self.width) >= 1 then
                self.width = fitted
                self:Reflow()
            end
        end)
        return self:Reflow()
    end
    return layout
end
