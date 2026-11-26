-- Forever Combat Style: widget library. Shapes and controls come from the PlateSCT settings:
-- warm near-black surfaces, one gold accent, rounded shapes, Source Sans 3 text. Pages are laid
-- out as section cards of compact rows, in two columns when there is room.
local ADDON_NAME, NS = ...
local W = {}
NS.W = W
local L = NS.L   -- Locales/Locale.lua loads first (see the TOC)

local MEDIA = "Interface\\AddOns\\" .. (ADDON_NAME or "ForeverCombatStyle") .. "\\Media\\"
local WHITE = "Interface\\Buttons\\WHITE8X8"
local ROUND = MEDIA .. "UI\\Round.png"
local CONTROL_WIDTH = 220
local CONTROL_HEIGHT = 32

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
    cardSelected = { 0.137, 0.114, 0.071, 1 },
    accent = { 0.851, 0.682, 0.373, 1 },
    accentHover = { 0.902, 0.741, 0.439, 1 },
    accentDown = { 0.722, 0.573, 0.306, 1 },
    accentSoft = { 0.851, 0.682, 0.373, 0.55 },
    -- Gold fading out: the selected sidebar row, the header's glow and the rim along the top.
    wash = { 0.851, 0.682, 0.373, 0.17 },
    glow = { 0.851, 0.682, 0.373, 0.07 },
    rim = { 0.851, 0.682, 0.373, 0.75 },
    clear = { 0.851, 0.682, 0.373, 0 },
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
        for _, size in ipairs({ 12, 13, 14, 15, 16, 22 }) do
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
    shape.radius, shape.inset = radius, inset
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

local function GradientMix(a, b, t)
    return { a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t, a[3] + (b[3] - a[3]) * t,
        (a[4] or 1) + ((b[4] or 1) - (a[4] or 1)) * t }
end

-- A left-to-right gradient on one texture: SetGradient with colors on current clients, the older
-- SetGradientAlpha elsewhere, a flat middle color when neither exists.
local function Gradient(texture, left, right)
    if texture.SetGradient and CreateColor then
        local ok = pcall(texture.SetGradient, texture, "HORIZONTAL",
            CreateColor(left[1], left[2], left[3], left[4]), CreateColor(right[1], right[2], right[3], right[4]))
        if ok then return end
    end
    if texture.SetGradientAlpha then
        texture:SetGradientAlpha("HORIZONTAL", left[1], left[2], left[3], left[4], right[1], right[2], right[3], right[4])
        return
    end
    local middle = GradientMix(left, right, 0.5)
    texture:SetVertexColor(middle[1], middle[2], middle[3], middle[4])
end

-- A texture of its own filled with that gradient.
function W.Fade(parent, left, right, layer)
    local texture = parent:CreateTexture(nil, layer or "BORDER")
    texture:SetTexture(WHITE)
    Gradient(texture, left, right)
    return texture
end

-- Paint a rounded fill running from `from` (left edge) to `to` (right edge) across `width`, with
-- an optional ring. The corners take the color at their position; the strips carry the gradient.
function W.PaintGradient(frame, from, to, width, radius, ring)
    W.Paint(frame, from, radius, ring)
    local shape = frame.optionsFillShape
    local r, inset = shape.radius or 0, shape.inset or 0
    width = math.max(1, width or frame:GetWidth() or 1)
    local function At(x) return GradientMix(from, to, math.min(1, math.max(0, x / width))) end
    local parts = shape.parts
    local left, right = At(inset + r / 2), At(width - inset - r / 2)
    parts[1]:SetVertexColor(left[1], left[2], left[3], left[4])
    parts[4]:SetVertexColor(left[1], left[2], left[3], left[4])
    parts[2]:SetVertexColor(right[1], right[2], right[3], right[4])
    parts[3]:SetVertexColor(right[1], right[2], right[3], right[4])
    Gradient(parts[5], At(inset + r), At(width - inset - r))
    Gradient(parts[7], At(inset + r), At(width - inset - r))
    Gradient(parts[6], At(inset), At(width - inset))
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

-- The width of a label's whole text, even while its region is too narrow to show all of it
-- (a button about to be fitted to its label).
function W.TextWidth(region)
    if region.GetUnboundedStringWidth then return region:GetUnboundedStringWidth() or 0 end
    return region:GetStringWidth() or 0
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
-- "tab" (section tab, underlined when selected), "ghost" (no fill until hovered),
-- "segment" (one of a segmented control), "menu" (dropdown entry).
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
    local faces = frame.optionsActionFaces or ACTION_FACES   -- a promo button can bring its own colors
    local face = faces[mode] or ACTION_FACES[mode] or ACTION_FACES.idle
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
        fill = not selected and over and C.hover or nil
        text = (selected or over) and C.bright or C.navText
        icon = selected and C.accent or over and C.navText or C.dim
    elseif style == "tab" then
        text = (selected or over) and C.bright or C.muted
    else -- ghost
        fill = selected and C.navActive or over and C.fieldHover or nil
        text = selected and C.accent or over and C.bright or C.muted
        icon = text
    end
    if fill then W.Paint(button, fill, button.optionsRadius or 8) else W.Unpaint(button) end
    local font = button:GetFontString()
    if font then font:SetTextColor(RGB(text)) end
    if button.optionsIcon then button.optionsIcon:SetVertexColor(RGB(icon or text)) end
    for _, region in ipairs(button.optionsSelection or {}) do region:SetShown(selected and true or false) end
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
    W.SetFont(font, (style == "action") and "semibold" or (style == "menu") and "regular" or "medium",
        (style == "ghost") and 13 or 14)
    button:SetFontString(font)
    button:SetText(label or "")
    font:ClearAllPoints()
    local centered = style ~= "nav" and style ~= "menu"
    local inset = style == "action" and 14 or style == "segment" and 4 or centered and 10 or 12
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

-- The width a button needs for its label, with `extra` around it.
function W.FitButton(button, extra, minimum)
    local width = math.max(minimum or 0, math.ceil(W.TextWidth(button:GetFontString()) + extra))
    button:SetWidth(width)
    return width
end

-- Sidebar page: a full-width row with a leading icon and, at the right, a small count (`count`).
-- The selected row has a gold bar at the window's edge and a gold wash fading out to the right.
function W.NavButton(parent, label, icon, width, height, onClick)
    local button = W.Button(parent, label, width, height, onClick, "nav")
    button.optionsRadius = 0
    local wash = W.Fade(button, C.wash, C.clear)
    wash:SetPoint("TOPLEFT"); wash:SetPoint("BOTTOMLEFT")
    wash:SetWidth(math.floor(width * 0.9))
    local bar = button:CreateTexture(nil, "ARTWORK")
    bar:SetColorTexture(RGB(GOLD))
    bar:SetWidth(2)
    bar:SetPoint("TOPLEFT"); bar:SetPoint("BOTTOMLEFT")
    button.optionsSelection = { wash, bar }
    button.optionsIcon = W.Icon(button, icon, 16)
    button.optionsIcon:SetPoint("LEFT", 22, 0)
    button.count = W.Text(button, "", 0, 0, 28, C.muted, "medium", 13)
    button.count:ClearAllPoints()
    button.count:SetPoint("RIGHT", button, "RIGHT", -18, 0)
    button.count:SetJustifyH("RIGHT")
    button.count:SetWordWrap(false)
    local font = button:GetFontString()
    font:ClearAllPoints()
    font:SetPoint("LEFT", 50, 0)
    font:SetPoint("RIGHT", -48, 0)
    PaintButton(button)
    return button
end

-- A section tab: its label, underlined in gold while its section is in view.
function W.TabButton(parent, height, onClick)
    local button = W.Button(parent, "", 60, height, onClick, "tab")
    local line = button:CreateTexture(nil, "ARTWORK")
    line:SetColorTexture(RGB(GOLD))
    line:SetHeight(2)
    line:SetPoint("BOTTOMLEFT", 10, 0); line:SetPoint("BOTTOMRIGHT", -10, 0)
    button.optionsSelection = { line }
    PaintButton(button)
    return button
end

-- A field button with a leading icon, as wide as its label needs (`Fit`).
function W.IconButton(parent, label, icon, onClick)
    local button = W.Button(parent, label, 140, 30, onClick, "flat")
    button.optionsIcon = W.Icon(button, icon, 14)
    button.optionsIcon:SetPoint("LEFT", 12, 0)
    local font = button:GetFontString()
    font:ClearAllPoints()
    font:SetPoint("LEFT", 34, 0)
    font:SetPoint("RIGHT", -12, 0)
    font:SetJustifyH("LEFT")
    function button:Fit() return W.FitButton(self, 48) end
    button:Fit()
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
        width = math.max(width, W.TextWidth(entry:GetFontString()) + 60)
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
-- Scroll view: a page that scrolls with the wheel and a slim thumb. `host.OnScroll`, when set,
-- is called after every scroll or size change.
---------------------------------------------------------------------------------------------------

W.SCROLL_ROOM = 18   -- the strip at the right of a page that holds the thumb

function W.ScrollView(parent, root)
    local host = CreateFrame("Frame", nil, parent)
    host:SetAllPoints(); host:Hide()
    local scroll = CreateFrame("ScrollFrame", nil, host)
    scroll:SetPoint("TOPLEFT"); scroll:SetPoint("BOTTOMRIGHT", -W.SCROLL_ROOM, 0)
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
        if maximum > 0 and height > 0 then
            local size = math.min(height, math.max(28, height * scroll:GetHeight() / child:GetHeight()))
            thumb:SetHeight(size); thumb:ClearAllPoints()
            thumb:SetPoint("TOP", track, "TOP", 0, -(height - size) * position / maximum)
        end
        if host.OnScroll then host.OnScroll(position, maximum) end
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
    host.MaxScroll = MaxScroll
    return host
end

---------------------------------------------------------------------------------------------------
-- Layout: section cards of compact rows on a scrolling page, two rows a line when the card is
-- wide enough. A row says what its setting does, under the caption and the control. A setting that
-- differs from the client's default has a gold mark that puts it back (so does a right-click), and
-- its card a Reset button.
---------------------------------------------------------------------------------------------------

local ACTION_HEIGHT = 46              -- the least a row with an action button takes
local ROW_PAD, ROW_GAP = 12, 4        -- above and below a row's contents; over its description
local ROW_LEFT, ROW_RIGHT = 18, 16    -- the row's inner edges; the changed mark sits in the left one
local VALUE_WIDTH = 44                -- a slider's readout
local SEGMENT_PAD = 10                -- around a segment's label
local CAPTION_MIN = 70                -- the least a wide control leaves its caption
local HALVES_MIN = 600                -- card width from which rows stand two a line
local CARD_HEADER, CARD_FOOT = 40, 6
local PAGE_TOP, PAGE_BOTTOM = 16, 24
local CARD_SPACE = 14

local function Clamp(value, low, high)
    return math.max(low, math.min(high, value))
end

local function FormatValue(setting, value)
    return string.format("%." .. (setting.decimals or 2) .. "f", value)
end

-- A painted warning with its icon, as in PlateSCT. The box fits the text.
function W.WarningBox(parent, text, width)
    local box = CreateFrame("Frame", nil, parent)
    box:SetSize(width, 40)
    W.Paint(box, C.warning, 10)
    local icon = W.Icon(box, "Warning", 16, C.warningIcon)
    icon:SetPoint("TOPLEFT", ROW_LEFT - 2, -12)
    local label = W.SetSmall(W.Text(box, text, 44, -11, width - 60, C.warningText))
    box:SetHeight(math.max(18, label:GetStringHeight()) + 22)
    return box, label
end

-- opts: width (initial column width), padLeft, padRight
function W.NewLayout(parent, root, opts)
    opts = opts or {}
    local PAD_LEFT, PAD_RIGHT = opts.padLeft or 24, opts.padRight or 6
    local layout = { parent = parent, root = root, x = PAD_LEFT, rows = {}, blocks = {}, cards = {},
        sections = {}, width = math.max(200, (opts.width or parent:GetWidth()) - PAD_LEFT - PAD_RIGHT) }

    -- A row joins the open section's card. A warning, an advert or the empty note stands on the
    -- page itself, and ends the section.
    function layout:AddRow(row, caption, kind)
        row.layoutCaption, row.layoutKind = caption, kind
        row.layoutWhen, row.layoutAlways = self.condition, self.always
        self.rows[#self.rows + 1] = row
        if row:GetParent() == parent then
            self.card = nil
            self.blocks[#self.blocks + 1] = row
        else
            self.card.rows[#self.card.rows + 1] = row
        end
    end

    -- Where the next row is made: in the open section's card, else on the page.
    local function Host()
        return layout.card or parent
    end

    -- Rows added inside `build` show only while `predicate()` is true; checked on every reflow.
    function layout:When(predicate, build)
        local outer = self.condition
        self.condition = outer and function() return outer() and predicate() end or predicate
        build()
        self.condition = outer
    end

    -- Rows added inside `build` stay when the page shows only the changed settings.
    function layout:Always(build)
        local outer = self.always
        self.always = true
        build()
        self.always = outer
    end

    -- Put the settings of a card that differ from their defaults back.
    local function ResetCard(card)
        local list = {}
        for _, row in ipairs(card.rows) do
            if row.layoutSetting and NS.IsChanged(row.layoutSetting.cvar) then
                list[#list + 1] = row.layoutSetting.cvar
            end
        end
        NS.ResetSettings(list)
        for _, row in ipairs(card.rows) do
            if row.layoutSetting then row.layoutControl:Refresh() end
        end
    end

    -- A section: a card with its title, and a Reset while something in it differs.
    function layout:Section(text)
        local card = CreateFrame("Frame", nil, parent)
        card:SetSize(self.width, CARD_HEADER)
        W.Paint(card, C.card, 10, C.line)
        card.isCard, card.rows, card.rules = true, {}, {}
        card.title = W.Text(card, text, ROW_LEFT, -12, nil, GOLD, "semibold", 15)
        card.title:SetWordWrap(false)
        local line = W.Line(card, C.line, "ARTWORK")
        line:SetHeight(1)
        line:SetPoint("TOPLEFT", 1, -CARD_HEADER)
        line:SetPoint("TOPRIGHT", -1, -CARD_HEADER)
        card.reset = W.Button(card, L["Reset"], 64, 26, function() ResetCard(card) end, "ghost")
        card.reset.optionsRadius = 7
        card.reset:SetPoint("TOPRIGHT", -8, -7)
        card.reset:Hide()
        W.Tooltip(card.reset, L["Put this section back to its defaults."])
        self.card = card
        self.cards[#self.cards + 1] = card
        self.blocks[#self.blocks + 1] = card
        return card.title
    end

    -- A warning on the page, above the sections it concerns.
    function layout:Warning(text)
        local box, label = W.WarningBox(parent, text, self.width)
        self:AddRow(box, label, "warning")
        return label
    end

    -- Shown in place of the sections while only changed settings are listed and none is.
    function layout:Empty(text)
        local box = CreateFrame("Frame", nil, parent)
        box:SetSize(self.width, 96)
        W.Paint(box, C.card, 10, C.line)
        local label = W.Text(box, text, 0, 0, self.width - 32, MUTED)
        label:ClearAllPoints()
        label:SetPoint("CENTER", box, "CENTER", 0, 0)
        label:SetJustifyH("CENTER")
        box.layoutCaption, box.layoutKind = label, "empty"
        box:Hide()
        self.empty = box
        return label
    end

    -- Small supporting text across a section.
    function layout:Note(text)
        local row = CreateFrame("Frame", nil, Host())
        row:SetSize(self.width, 28)
        local label = W.SetSmall(W.Text(row, text, ROW_LEFT, -8, self.width - ROW_LEFT - ROW_RIGHT, MUTED))
        self:AddRow(row, label, "note")
        return label
    end

    -- A row: caption on the left, the control on the right, and under both what the setting does.
    function layout:NewRow(label, tip)
        local row = CreateFrame("Frame", nil, Host())
        row:SetSize(self.width, ACTION_HEIGHT)
        row:EnableMouse(true)
        local caption = W.Text(row, label, ROW_LEFT, -ROW_PAD, nil, TEXT, "medium", 14)
        local description = W.SetSmall(W.Text(row, tip or "", ROW_LEFT, 0, self.width - ROW_LEFT - ROW_RIGHT, MUTED))
        row.layoutDescription, row.tip = description, tip
        self:AddRow(row, caption, "control")
        return row, caption
    end

    -- Tie a control to a CVar: its row's tooltip, changed mark and right-click reset.
    local function Bind(control, row, setting)
        control.row, control.setting = row, setting
        row.layoutControl, row.layoutSetting = control, setting
        root.controls[#root.controls + 1] = control

        function control:ResetSetting()
            if not NS.IsChanged(setting.cvar) then return end
            NS.ResetSettings({ setting.cvar })
            self:Refresh()
        end

        local mark = CreateFrame("Button", nil, row)
        mark:SetSize(16, 16)
        mark.dot = Circle(mark, 6, GOLD, "ARTWORK")
        mark.dot:SetPoint("CENTER")
        mark.icon = W.Icon(mark, "Reset", 13, GOLD, "OVERLAY")
        mark.icon:SetPoint("CENTER")
        mark.icon:Hide()
        mark:SetScript("OnEnter", function(self) self.dot:Hide(); self.icon:Show() end)
        mark:SetScript("OnLeave", function(self) self.dot:Show(); self.icon:Hide() end)
        mark:SetScript("OnClick", function() control:ResetSetting() end)
        mark:Hide()
        W.Tooltip(mark, L["Reset to default"])
        row.layoutMark = mark
    end

    local function RightClickResets(frame, control)
        Hook(frame, "OnMouseUp", function(_, button)
            if button == "RightButton" then control:ResetSetting() end
        end)
    end

    -- The description is written in the row; the tooltip adds the CVar name and the setting's state.
    local function SettingTip(setting)
        local note
        if not NS.available[setting.cvar] then
            note = L["Not available on this client."]
        elseif NS.IsChanged(setting.cvar) then
            note = L["Changed from the default. Right-click to reset."]
        end
        return { title = L[setting.label], body = note, foot = setting.cvar }
    end

    local function Register(control, row, setting)
        Bind(control, row, setting)
        local function Tip() return SettingTip(setting) end
        W.Tooltip(row, Tip)
        W.Tooltip(control, Tip)
        RightClickResets(row, control)
        RightClickResets(control, control)
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
        row.layoutCaption:SetTextColor(RGB(available and TEXT or C.disabledText))
        control:SetAlpha(available and 1 or 0.45)
        SetControlEnabled(control, available)
        return available
    end

    function layout:Slider(setting)
        local row = self:NewRow(L[setting.label], L[setting.tip])
        local minimum, maximum, step = setting.min, setting.max, setting.step
        local control = CreateFrame("Slider", nil, row)
        control:SetOrientation("HORIZONTAL")
        control:SetSize(140, 20)
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
        local valueText = W.Text(row, "", 0, 0, VALUE_WIDTH, C.bright, "medium", 14)
        valueText:ClearAllPoints()
        valueText:SetPoint("RIGHT", row, "RIGHT", -ROW_RIGHT, 0)
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
        local edit = W.EditBox(row, 60, 28)
        edit:SetPoint("RIGHT", valueText, "RIGHT", 8, 0)
        edit:SetJustifyH("RIGHT")
        edit:SetMaxLetters(8)
        edit:Hide()
        local entry = CreateFrame("Button", nil, row)
        entry:SetPoint("RIGHT", valueText, "RIGHT", 4, 0)
        entry:SetSize(VALUE_WIDTH + 8, 24)
        local underline = entry:CreateTexture(nil, "ARTWORK")
        underline:SetPoint("BOTTOMLEFT", 4, 1); underline:SetPoint("BOTTOMRIGHT", -4, 1)
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
        local row = self:NewRow(L[setting.label], L[setting.tip])
        local control = CreateFrame("Frame", nil, row)
        control:SetHeight(32)
        W.Paint(control, C.window, 8, C.line)
        control.layoutType = "segments"
        control.segments = {}
        Register(control, row, setting)
        for _, option in ipairs(setting.options) do
            local value = option[1]
            local segment = W.Button(control, L[option[2]], 60, 26, function()
                if NS.available[setting.cvar] then
                    NS.Set(setting.cvar, value)
                    control:Refresh()
                end
            end, "segment")
            segment.optionsRadius = 6
            segment.value = value
            RightClickResets(segment, control)
            control.segments[#control.segments + 1] = segment
        end
        -- What each label asks for, all of them together, and the longest.
        local function Wanted(self)
            local wanted, total, widest = {}, 0, 0
            for index, segment in ipairs(self.segments) do
                wanted[index] = math.ceil(W.TextWidth(segment:GetFontString())) + SEGMENT_PAD
                total, widest = total + wanted[index], math.max(widest, wanted[index])
            end
            return wanted, total, widest
        end
        -- The narrowest the control can be with no label cut short.
        function control:Needed()
            local _, total = Wanted(self)
            return total + 6 + 2 * (#self.segments - 1)
        end
        -- Equal segments when the longest label fits one, else the width shared by label length.
        function control:Fit(width)
            local usable = width - 6 - 2 * (#self.segments - 1)
            local wanted, total, widest = Wanted(self)
            local equal, x = math.floor(usable / #self.segments), 3
            for index, segment in ipairs(self.segments) do
                local each = widest <= equal and equal or math.floor(wanted[index] * usable / total)
                segment:ClearAllPoints()
                segment:SetPoint("LEFT", self, "LEFT", x, 0)
                segment:SetWidth(each)
                x = x + each + 2
            end
        end
        function control:Refresh()
            local current = NS.values[setting.cvar] or setting.default
            for _, segment in ipairs(self.segments) do
                W.SetSelected(segment, math.abs(segment.value - current) < 0.01)
            end
            SetAvailable(self)
        end
        control:Fit(160)
        control:SetWidth(160)
        control:Refresh()
        return control
    end

    -- A two-way choice shown as large cards side by side, so the difference between the options
    -- reads at a glance (used for the number style). Each card has a radio dot, the option name, a
    -- short tagline and a few lines on how it behaves. `details` maps an option value to
    -- { tagline =, text = } (already translated).
    local CARD_PAD, CARD_GAP, CARD_DOT, CARD_HEAD_GAP = 14, 12, 18, 10
    local CARDS_GAP, CARDS_BOTTOM = 10, 8   -- over the cards (under the description) and under them
    function layout:StyleCards(setting, details)
        local row = CreateFrame("Frame", nil, Host())
        row:SetSize(self.width, 120)
        -- What the setting does, over the cards; each card then says what its choice is like.
        row.tip = L[setting.tip]
        row.layoutDescription = W.SetSmall(W.Text(row, row.tip, ROW_LEFT, -ROW_PAD,
            self.width - ROW_LEFT - ROW_RIGHT, MUTED))
        local control = CreateFrame("Frame", nil, row)
        control.layoutType = "cards"
        control.cards = {}
        Bind(control, row, setting)
        RightClickResets(row, control)

        local function CardTip()
            return SettingTip(setting)
        end

        local function PaintCard(card)
            local enabled = not card.IsEnabled or card:IsEnabled()
            local selected = card.optionsSelected
            local over = enabled and card.IsMouseOver and card:IsMouseOver()
            local fill = selected and C.cardSelected or over and C.cardHover or C.window
            local ring = selected and (enabled and C.accent or C.switchOnDisabled) or C.edge
            W.Paint(card, fill, 9, ring)
            -- Radio dot: a ring when off, a filled gold disc with a tick when on.
            card.dot:SetVertexColor(RGB(selected and (enabled and C.accent or C.switchOnDisabled) or C.radio))
            card.dotInner:SetVertexColor(RGB(fill))
            card.dotInner:SetShown(not selected)
            card.check:SetShown(selected and true or false)
            card.title:SetTextColor(RGB(not enabled and C.disabledText or selected and C.bright or C.text))
            card.tagline:SetTextColor(RGB(not enabled and C.disabledText or selected and C.accent or C.muted))
            card.body:SetTextColor(RGB(not enabled and C.disabledText or selected and C.navText or C.muted))
        end

        for _, option in ipairs(setting.options) do
            local detail = details and details[option[1]] or {}
            local card = CreateFrame("Button", nil, control)
            card.value = option[1]
            card.dot = Circle(card, CARD_DOT, C.radio, "ARTWORK")
            card.dotInner = Circle(card, CARD_DOT - 4, C.window, "ARTWORK", 1)
            card.check = W.Icon(card, "Check", 12, C.onAccent, "OVERLAY")
            card.dot:SetPoint("TOPLEFT", card, "TOPLEFT", CARD_PAD, -CARD_PAD)
            card.dotInner:SetPoint("CENTER", card.dot, "CENTER", 0, 0)
            card.check:SetPoint("CENTER", card.dot, "CENTER", 0, 0)
            card.title = W.Text(card, L[option[2]], 0, 0, nil, C.text, "semibold", 15)
            card.title:SetWordWrap(false)
            card.tagline = W.Text(card, detail.tagline or "", 0, 0, nil, C.muted, "medium", 14)
            card.body = W.SetSmall(W.Text(card, detail.text or "", 0, 0, nil, C.muted))
            card:SetScript("OnClick", function()
                if NS.available[setting.cvar] then
                    NS.Set(setting.cvar, card.value)
                    control:Refresh()
                end
            end)
            Hook(card, "OnEnter", PaintCard)
            Hook(card, "OnLeave", PaintCard)
            W.Tooltip(card, CardTip)
            RightClickResets(card, control)
            control.cards[#control.cards + 1] = card
        end

        -- Place the control `top` down the row and its cards across `width`; returns the height
        -- the cards need (the tallest card, so both stay the same height whatever the language).
        function control:Fit(width, top)
            self:ClearAllPoints()
            self:SetPoint("TOPLEFT", row, "TOPLEFT", ROW_LEFT, -top)
            self:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", -ROW_RIGHT, CARDS_BOTTOM)
            local count = #self.cards
            local each = math.floor((width - CARD_GAP * (count - 1)) / count)
            local headX = CARD_PAD + CARD_DOT + CARD_HEAD_GAP
            local headWidth = math.max(40, each - headX - CARD_PAD)
            local bodyWidth = math.max(40, each - CARD_PAD * 2)
            local headHeight, bodyHeight = 0, 0
            for _, card in ipairs(self.cards) do
                card.title:SetWidth(headWidth)
                card.tagline:SetWidth(headWidth)
                card.body:SetWidth(bodyWidth)
                local titleHeight = math.max(18, card.title:GetStringHeight())
                card.titleHeight = titleHeight
                headHeight = math.max(headHeight, titleHeight + 2 + math.max(16, card.tagline:GetStringHeight()))
                bodyHeight = math.max(bodyHeight, math.max(16, card.body:GetStringHeight()))
            end
            local height = CARD_PAD + headHeight + 10 + bodyHeight + CARD_PAD
            for index, card in ipairs(self.cards) do
                card:ClearAllPoints()
                card:SetPoint("TOPLEFT", self, "TOPLEFT", (index - 1) * (each + CARD_GAP), 0)
                card:SetSize(each, height)
                card.title:ClearAllPoints()
                card.title:SetPoint("TOPLEFT", card, "TOPLEFT", headX, -CARD_PAD)
                card.tagline:ClearAllPoints()
                card.tagline:SetPoint("TOPLEFT", card, "TOPLEFT", headX, -(CARD_PAD + card.titleHeight + 2))
                card.body:ClearAllPoints()
                card.body:SetPoint("TOPLEFT", card, "TOPLEFT", CARD_PAD, -(CARD_PAD + headHeight + 10))
                -- Center the dot on the title line.
                card.dot:ClearAllPoints()
                card.dot:SetPoint("TOPLEFT", card, "TOPLEFT", CARD_PAD, -(CARD_PAD + (card.titleHeight - CARD_DOT) / 2))
            end
            -- The changed mark, in the row's left edge beside the cards' names.
            row.layoutMark:ClearAllPoints()
            row.layoutMark:SetPoint("CENTER", row, "TOPLEFT", ROW_LEFT / 2, -(top + CARD_PAD + 9))
            return height
        end

        function control:Refresh()
            local current = NS.values[setting.cvar] or setting.default
            local available = NS.available[setting.cvar] and true or false
            row.layoutDescription:SetText(available and row.tip or L["This setting is not available on this client."])
            for _, card in ipairs(self.cards) do
                card.optionsSelected = math.abs(card.value - current) < 0.01
                SetControlEnabled(card, available)
                PaintCard(card)
            end
        end

        self:AddRow(row, control.cards[1].title, "cards")
        control:Refresh()
        return control
    end

    -- An on/off switch for a setting of the addon's own.
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
        control:SetScript("OnClick", function(self, button)
            if button == "RightButton" then return end
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
        local row = self:NewRow(label, tip)
        local control = W.Button(row, "", 200, CONTROL_HEIGHT, nil, "flat")
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

    -- An advert for a companion addon: a gradient card with the addon's logo, a badge, a headline,
    -- a short pitch, a checklist of features and a call-to-action button. `spec` fields: logo
    -- (texture path), logoCoords (optional texcoords), badge, title, body, features (list), button,
    -- onClick, foot, from / to (gradient colors), ring (accent color for ring, badge and ticks).
    local PROMO_PAD, PROMO_LOGO, PROMO_GAP, PROMO_RADIUS = 22, 64, 18, 14
    function layout:Promo(spec)
        local row = CreateFrame("Frame", nil, parent)
        row:SetSize(self.width, 220)
        local card = CreateFrame("Frame", nil, row)
        card:SetAllPoints(row)
        card.layoutType = "promo"
        card.spec = spec
        row.layoutControl = card

        -- With `watermark`, the logo again, large and glowing faintly at the right, like the art of
        -- a banner (for a logo on a dark background: the additive blend drops the dark parts).
        card.watermark = card:CreateTexture(nil, "BORDER")
        card.watermark:SetShown(spec.watermark and true or false)
        card.watermark:SetTexture(spec.logo)
        if spec.logoCoords then card.watermark:SetTexCoord(unpack(spec.logoCoords)) end
        card.watermark:SetBlendMode("ADD")
        card.watermark:SetAlpha(0.16)

        card.logoFrame = CreateFrame("Frame", nil, card)
        card.logoFrame:SetSize(PROMO_LOGO, PROMO_LOGO)
        W.Paint(card.logoFrame, C.drawer, 14, spec.ring)
        card.logo = card.logoFrame:CreateTexture(nil, "ARTWORK")
        card.logo:SetTexture(spec.logo)
        if spec.logoCoords then card.logo:SetTexCoord(unpack(spec.logoCoords)) end
        card.logo:SetPoint("TOPLEFT", 4, -4)
        card.logo:SetPoint("BOTTOMRIGHT", -4, 4)

        card.badge = CreateFrame("Frame", nil, card)
        card.badgeText = W.Text(card.badge, spec.badge or "", 0, 0, nil, C.onAccent, "semibold", 12)
        card.badgeText:ClearAllPoints()
        card.badgeText:SetPoint("CENTER", card.badge, "CENTER", 0, 0)
        card.badgeText:SetWordWrap(false)
        W.Paint(card.badge, spec.ring, 11)

        card.title = W.Text(card, spec.title, 0, 0, nil, C.bright, "semibold", 22)
        card.body = W.Text(card, spec.body, 0, 0, nil, C.navText, "regular", 15)

        card.features = {}
        for _, text in ipairs(spec.features or {}) do
            local feature = {}
            feature.dot = Circle(card, 18, spec.ring, "ARTWORK")
            feature.tick = W.Icon(card, "Check", 11, C.onAccent, "OVERLAY")
            feature.tick:SetPoint("CENTER", feature.dot, "CENTER", 0, 0)
            feature.text = W.Text(card, text, 0, 0, nil, C.text, "medium", 14)
            card.features[#card.features + 1] = feature
        end

        card.button = W.Button(card, spec.button, 180, 36, function() spec.onClick() end, "action")
        card.button.optionsRadius = 10
        -- The button takes the advertised addon's accent instead of this addon's gold.
        local accent = spec.ring
        local function Shade(amount)
            return { math.min(1, accent[1] + amount), math.min(1, accent[2] + amount), math.min(1, accent[3] + amount), 1 }
        end
        card.button.optionsActionFaces = {
            idle = { fill = accent, text = C.onAccent },
            hover = { fill = Shade(0.06), text = C.onAccent },
            down = { fill = Shade(-0.12), text = C.onAccent },
            selected = { fill = Shade(0.06), text = C.onAccent },
        }
        W.PaintAction(card.button, "idle")
        card.foot = W.SetSmall(W.Text(card, spec.foot or "", 0, 0, nil, C.muted))

        -- Lay the card out across `width`; returns its height.
        function card:Fit(width)
            local textX = PROMO_PAD + PROMO_LOGO + PROMO_GAP
            local textWidth = math.max(160, width - textX - PROMO_PAD)
            self.logoFrame:ClearAllPoints()
            self.logoFrame:SetPoint("TOPLEFT", self, "TOPLEFT", PROMO_PAD, -PROMO_PAD)

            self.badge:SetSize(math.floor(W.TextWidth(self.badgeText) + 22 + 0.5), 22)
            self.badge:ClearAllPoints()
            self.badge:SetPoint("TOPLEFT", self, "TOPLEFT", textX, -PROMO_PAD)
            local y = PROMO_PAD + 22 + 10
            self.title:SetWidth(textWidth)
            self.title:ClearAllPoints()
            self.title:SetPoint("TOPLEFT", self, "TOPLEFT", textX, -y)
            y = y + self.title:GetStringHeight() + 6
            self.body:SetWidth(textWidth)
            self.body:ClearAllPoints()
            self.body:SetPoint("TOPLEFT", self, "TOPLEFT", textX, -y)
            y = math.max(y + self.body:GetStringHeight(), PROMO_PAD + PROMO_LOGO) + 20

            -- Features: two columns when there is room, one otherwise.
            local columns = textWidth >= 440 and 2 or 1
            local columnGap = 18
            local columnWidth = math.floor((textWidth - columnGap * (columns - 1)) / columns)
            local lineTop, lineHeight = y, 0
            for index, feature in ipairs(self.features) do
                local column = (index - 1) % columns
                if column == 0 and index > 1 then
                    lineTop = lineTop + lineHeight + 10
                    lineHeight = 0
                end
                local x = textX + column * (columnWidth + columnGap)
                feature.text:SetWidth(columnWidth - 28)
                local height = math.max(18, feature.text:GetStringHeight())
                feature.dot:ClearAllPoints()
                feature.dot:SetPoint("TOPLEFT", self, "TOPLEFT", x, -lineTop)
                feature.text:ClearAllPoints()
                feature.text:SetPoint("TOPLEFT", self, "TOPLEFT", x + 28, -(lineTop + 1))
                lineHeight = math.max(lineHeight, height)
            end
            if #self.features > 0 then y = lineTop + lineHeight + 22 end

            -- Call to action, with the small print beside it (or under it when narrow).
            local buttonWidth = math.max(170, math.ceil(W.TextWidth(self.button:GetFontString()) + 48))
            self.button:SetSize(buttonWidth, 36)
            self.button:ClearAllPoints()
            self.button:SetPoint("TOPLEFT", self, "TOPLEFT", textX, -y)
            local footWidth = textWidth - buttonWidth - 16
            self.foot:ClearAllPoints()
            if footWidth >= 180 then
                self.foot:SetWidth(footWidth)
                self.foot:SetPoint("LEFT", self.button, "RIGHT", 16, 0)
                y = y + math.max(36, self.foot:GetStringHeight())
            else
                self.foot:SetWidth(textWidth)
                self.foot:SetPoint("TOPLEFT", self, "TOPLEFT", textX, -(y + 36 + 8))
                y = y + 36 + 8 + self.foot:GetStringHeight()
            end
            local height = y + PROMO_PAD

            local art = math.min(height - 24, 180)
            self.watermark:SetSize(art, art)
            self.watermark:ClearAllPoints()
            self.watermark:SetPoint("RIGHT", self, "RIGHT", -18, 0)
            W.PaintGradient(self, spec.from, spec.to, width, PROMO_RADIUS, spec.ring)
            W.Paint(self.badge, spec.ring, 11)
            return height
        end

        self:AddRow(row, card.title, "promo")
        card:Fit(self.width)
        return card
    end

    -- A description on the left and a button on the right that runs `onClick`.
    function layout:Action(label, tip, onClick)
        local row = CreateFrame("Frame", nil, Host())
        row:SetSize(self.width, ACTION_HEIGHT)
        local caption = W.SetSmall(W.Text(row, tip or "", ROW_LEFT, -14, nil, MUTED))
        local control = W.Button(row, label, 160, 30, function() onClick() end, "flat")
        control.layoutType = "action"
        row.layoutControl = control
        -- On the page itself (under a warning) it needs a card of its own.
        if row:GetParent() == parent then W.Paint(row, C.card, 10, C.line) end
        self:AddRow(row, caption, "action")
        return control
    end

    ---------------------------------------------------------------------------------------------
    -- Placing
    ---------------------------------------------------------------------------------------------

    -- Size a row to `width`: the caption and the control on a top line, the description across the
    -- row under them. `line` is the top line's height where two rows share a line, so that their
    -- captions and descriptions stand level. Returns the row's height and its own top line's.
    local function PlaceControlRow(row, width, line)
        local caption, control, description = row.layoutCaption, row.layoutControl, row.layoutDescription
        local kind = control.layoutType
        local taken, controlHeight = 40, 24   -- a switch
        if kind == "slider" then
            local track = Clamp(math.floor(width * 0.34), 90, 220)
            control:SetWidth(track)
            taken, controlHeight = track + 8 + VALUE_WIDTH, 20
        elseif kind == "segments" then
            -- Wider for long translations, while the caption keeps some room.
            local room = width - ROW_LEFT - ROW_RIGHT - 14 - CAPTION_MIN
            local segments = math.max(Clamp(math.floor(width * 0.5), 132, 220), math.min(control:Needed(), room))
            control:SetWidth(segments)
            control:Fit(segments)
            taken, controlHeight = segments, 32
        elseif kind == "choice" then
            local choice = Clamp(math.floor(width * 0.55), 150, 240)
            control:SetWidth(choice)
            taken, controlHeight = choice, CONTROL_HEIGHT
        end
        local textWidth = width - ROW_LEFT - ROW_RIGHT - taken - 14
        caption:SetWidth(textWidth)
        local own = math.ceil(math.max(CONTROL_HEIGHT, caption:GetStringHeight()))
        line = line or own
        local middle = ROW_PAD + line / 2
        caption:ClearAllPoints()
        caption:SetPoint("LEFT", row, "TOPLEFT", ROW_LEFT, -middle)
        description:SetWidth(width - ROW_LEFT - ROW_RIGHT)
        description:ClearAllPoints()
        description:SetPoint("TOPLEFT", row, "TOPLEFT", ROW_LEFT, -(ROW_PAD + line + ROW_GAP))
        control:ClearAllPoints()
        if kind == "slider" then
            control:SetPoint("RIGHT", row, "TOPRIGHT", -(ROW_RIGHT + VALUE_WIDTH + 8), -middle)
            control.valueText:ClearAllPoints()
            control.valueText:SetPoint("RIGHT", row, "TOPRIGHT", -ROW_RIGHT, -middle)
            control:PaintFill(tonumber(control:GetValue()) or 0)
        else
            control:SetPoint("RIGHT", row, "TOPRIGHT", -ROW_RIGHT, -middle)
        end
        if row.layoutMark then
            row.layoutMark:ClearAllPoints()
            row.layoutMark:SetPoint("CENTER", row, "TOPLEFT", ROW_LEFT / 2, -middle)
        end
        return math.ceil(ROW_PAD + line + ROW_GAP + description:GetStringHeight() + ROW_PAD), own
    end

    -- Size any row to `width`; returns the height it needs (a control row also its top line's).
    local function PlaceRow(row, width, line)
        local caption = row.layoutCaption
        local kind = row.layoutKind
        if kind == "control" then
            return PlaceControlRow(row, width, line)
        elseif kind == "cards" then
            local description = row.layoutDescription
            description:SetWidth(width - ROW_LEFT - ROW_RIGHT)
            local top = math.ceil(ROW_PAD + description:GetStringHeight() + CARDS_GAP)
            return top + row.layoutControl:Fit(width - ROW_LEFT - ROW_RIGHT, top) + CARDS_BOTTOM
        elseif kind == "note" then
            caption:SetWidth(width - ROW_LEFT - ROW_RIGHT)
            return math.ceil(math.max(16, caption:GetStringHeight()) + 18)
        elseif kind == "warning" then
            caption:SetWidth(width - 60)
            return math.ceil(math.max(18, caption:GetStringHeight()) + 22)
        elseif kind == "promo" then
            return row.layoutControl:Fit(width)
        elseif kind == "empty" then
            caption:SetWidth(width - 32)
            return math.ceil(caption:GetStringHeight() + 60)
        end
        -- action
        local buttonWidth = W.FitButton(row.layoutControl, 32, 150)
        local textWidth = width - ROW_LEFT - ROW_RIGHT - buttonWidth - 14
        caption:SetWidth(textWidth)
        local textHeight = caption:GetStringHeight()
        local tall = math.ceil(math.max(ACTION_HEIGHT, textHeight + 22))
        caption:ClearAllPoints()
        caption:SetPoint("LEFT", row, "LEFT", ROW_LEFT, 0)
        row.layoutControl:ClearAllPoints()
        row.layoutControl:SetPoint("RIGHT", row, "RIGHT", -ROW_RIGHT, 0)
        return tall
    end

    local function Visible(self, row)
        if row.layoutWhen and not row.layoutWhen() then return false end
        if not self.keep or row.layoutAlways then return true end
        return row.layoutSetting and self.keep[row.layoutSetting.cvar] and true or false
    end

    -- The `index`th hairline of a card.
    local function Rule(card, index)
        local rule = card.rules[index]
        if not rule then
            rule = W.Line(card, C.line, "ARTWORK")
            card.rules[index] = rule
        end
        rule:ClearAllPoints()
        rule:Show()
        return rule
    end

    -- Lay a card's visible rows out; returns the card's height.
    local function PlaceCard(card, list, width)
        -- Two compact rows share a line when the card is wide enough; the last of an odd run
        -- keeps to the left half, and a row with no neighbour at all takes the whole line.
        local lines, index = {}, 1
        while index <= #list do
            local row, other = list[index], list[index + 1]
            local pairing = width >= HALVES_MIN and row.layoutKind == "control"
            if pairing and other and other.layoutKind == "control" then
                lines[#lines + 1] = { row, other, halves = true }
                index = index + 2
            else
                local previous = lines[#lines]
                lines[#lines + 1] = { row, halves = pairing and previous and previous.halves }
                index = index + 1
            end
        end
        local y, rules = CARD_HEADER + 1, 0
        local half = math.floor(width / 2)
        for number, line in ipairs(lines) do
            local first, second = line[1], line[2]
            local firstWidth = line.halves and half or width
            -- Two rows on a line share the taller of their top lines.
            local shared
            if second then
                local _, left = PlaceRow(first, firstWidth)
                local _, right = PlaceRow(second, width - half)
                shared = math.max(left, right)
            end
            local height = (PlaceRow(first, firstWidth, shared))
            if second then height = math.max(height, (PlaceRow(second, width - half, shared))) end
            for column, row in ipairs(line) do
                local rowWidth = column == 2 and width - half or firstWidth
                row:ClearAllPoints()
                row:SetPoint("TOPLEFT", card, "TOPLEFT", column == 2 and half or 0, -y)
                row:SetSize(rowWidth, height)
            end
            if number > 1 then
                rules = rules + 1
                local rule = Rule(card, rules)
                rule:SetHeight(1)
                rule:SetPoint("TOPLEFT", card, "TOPLEFT", 12, -y)
                rule:SetPoint("TOPRIGHT", card, "TOPRIGHT", -12, -y)
            end
            if second then
                rules = rules + 1
                local rule = Rule(card, rules)
                rule:SetSize(1, math.max(1, height - 18))
                rule:SetPoint("TOPLEFT", card, "TOPLEFT", half, -(y + 9))
            end
            y = y + height
        end
        for spare = rules + 1, #card.rules do card.rules[spare]:Hide() end
        local reset = W.FitButton(card.reset, 24, 56)
        card.title:SetWidth(math.max(1, width - ROW_LEFT - reset - 24))
        return y + CARD_FOOT
    end

    -- Position every block; returns the page's height. Hidden rows take no space, and a card
    -- with none of its rows showing is hidden. `self.sections` lists the cards on show.
    function layout:Reflow()
        local y, placed, any = PAGE_TOP, false, false
        local sections = {}
        local function Put(block, height, gap)
            if placed then y = y + gap end
            block:ClearAllPoints()
            block:SetPoint("TOPLEFT", parent, "TOPLEFT", self.x, -y)
            block:SetSize(self.width, height)
            local top = y
            y, placed = y + height, true
            return top
        end
        for _, block in ipairs(self.blocks) do
            if block.isCard then
                local list = {}
                for _, row in ipairs(block.rows) do
                    local visible = Visible(self, row)
                    row:SetShown(visible)
                    if visible then list[#list + 1] = row end
                end
                block:SetShown(#list > 0)
                if #list > 0 then
                    any = true
                    local top = Put(block, PlaceCard(block, list, self.width), CARD_SPACE)
                    sections[#sections + 1] = { title = block.title:GetText(), top = top }
                end
            else
                local visible = Visible(self, block)
                block:SetShown(visible)
                if visible then
                    local gap = block.layoutKind == "promo" and CARD_SPACE * 2 or CARD_SPACE
                    Put(block, PlaceRow(block, self.width), gap)
                end
            end
        end
        if self.empty then
            local show = self.keep ~= nil and not any
            self.empty:SetShown(show)
            if show then Put(self.empty, PlaceRow(self.empty, self.width), CARD_SPACE) end
        end
        self.sections = sections
        parent:SetHeight(math.max(1, y + PAGE_BOTTOM))
        return y + PAGE_BOTTOM
    end

    -- List only the settings in `keep` (cvar -> true), or everything when nil.
    function layout:SetKeep(keep)
        self.keep = keep
    end

    -- Show each setting's changed mark and each card's Reset as the settings stand.
    -- Returns how many settings on the page differ from their defaults, and which.
    function layout:UpdateMarks()
        local total, changedSet = 0, {}
        for _, card in ipairs(self.cards) do
            local count = 0
            for _, row in ipairs(card.rows) do
                if row.layoutSetting then
                    local changed = NS.IsChanged(row.layoutSetting.cvar)
                    row.layoutMark:SetShown(changed)
                    if changed then
                        count = count + 1
                        changedSet[row.layoutSetting.cvar] = true
                    end
                end
            end
            card.reset:SetShown(count > 0)
            total = total + count
        end
        return total, changedSet
    end

    function layout:Finish()
        root.layouts[#root.layouts + 1] = self
        -- Resizing the page changes the column width: rewrap every row to it.
        Hook(parent, "OnSizeChanged", function(_, newWidth)
            local fitted = math.max(200, (newWidth or 0) - PAD_LEFT - PAD_RIGHT)
            if newWidth and newWidth > 0 and math.abs(fitted - self.width) >= 1 then
                self.width = fitted
                self:Reflow()
                if root.LayoutChanged then root:LayoutChanged(self) end
            end
        end)
        return self:Reflow()
    end
    return layout
end
