-- Forever Combat Style: the preview drawer.
-- Three columns (Hit, Crit, Taken) replay sample numbers using the live CVar values in NS.values.
-- The WoW wiki gives no formulas for these CVars, so the motion is an approximation. Every tuning
-- constant is in PHYS so it can be matched against the real client.
local _, NS = ...
local W = NS.W
local C = W.COLORS

local floor, random = math.floor, math.random

local PHYS = {
    SPEED = 1.25,           -- the whole preview (motion, fades, spawn rate) plays at this speed
    LIFETIME = 1.9,         -- seconds a number stays on screen (at normal speed)
    FADE_START = 0.55,      -- fraction of LIFETIME before the fade begins
    RAMP_DURATION = 1.0,    -- seconds of the size ramp (WorldTextRampDuration_v2 default)
    RAMP_POW = 1.9,         -- ease power for hits (WorldTextRampPow_v2 default)
    RAMP_POW_CRIT = 8,      -- ease power for crits (WorldTextRampPowCrit_v2 default)
    POP_HIT = 0.45,         -- Retail style: extra size at spawn for hits
    POP_CRIT = 1.0,         -- Retail style: extra size at spawn for crits
    CLASSIC_START = 0.55,   -- Classic style: size at spawn as a fraction of full size
    RISE_RETAIL = 110,      -- px/s initial upward speed, Retail style
    RISE_CLASSIC = 70,      -- px/s initial upward speed, Classic style
    GRAVITY_PX = 190,       -- px/s^2 per 1.0 of WorldTextGravity_v2
    SPREAD_PX = 40,         -- px per 1.0 of WorldTextStartPosRandomness_v2
    DIR_SPEED_PX = 60,      -- px/s per 1.0 of the directional scale
    DIR_OFFSET_PX = 18,     -- px per 1.0 of the directional offset
    SCREEN_HEIGHT = 1080,   -- px per 1.0 of WorldTextScreenY_v2 / WorldTextCritScreenY_v2
    BASE_SIZE = 22,         -- px font size of a hit at Size 1.0
    CRIT_SIZE_MUL = 1.45,   -- crits are this much bigger than hits
    PLAYER_SIZE = 20,       -- px font size of the numbers on your own character
    PLAYER_SPEED = 48,      -- px/s for Up and Down float modes
    ARC_RISE = 120,         -- px/s initial upward speed for the Arc float mode
    ARC_GRAVITY = 190,      -- px/s^2 for the Arc float mode
    ARC_SIDE_MIN = 45,      -- px/s sideways speed range for the Arc float mode
    ARC_SIDE_MAX = 80,
    PREVIEW_SCALE = 1.0,    -- the whole preview is drawn at this scale
    VISIBLE_FRACTION = 0.8, -- the part of a number's life used to center its arc (it is faint after)
    ORIGIN_MIN = 0.12,      -- hits and crits never start lower than this fraction of the column
    ORIGIN_MAX = 0.88,      -- ... or higher than this one
    ORIGIN_UP = 0.22,       -- where your own numbers start in Up float mode
    ORIGIN_ARC = 0.50,      -- where your own numbers start in Arc float mode
    ORIGIN_DOWN = 0.82,     -- where your own numbers start in Down float mode
}
NS.PHYS = PHYS

-- `enabled` names the CVar that switches the column on; a column that is off shows "Off".
local COLUMNS = {
    { kind = "hit", title = "Hit", color = { 1, 1, 1 }, min = 90, max = 420, interval = { 0.85, 1.25 },
        enabled = "floatingCombatTextCombatDamage_v2" },
    { kind = "crit", title = "Crit", color = C.number, min = 800, max = 2200, crit = true, interval = { 1.9, 2.5 },
        enabled = "floatingCombatTextCombatDamage_v2" },
    { kind = "heal", title = "Heal", color = { 0.45, 1, 0.45 }, min = 150, max = 900, interval = { 1.1, 1.6 },
        enabled = "floatingCombatTextCombatHealing_v2" },
    { kind = "taken", title = "Taken", color = C.incoming, min = 40, max = 260, player = true, interval = { 1.0, 1.5 },
        enabled = "enableFloatingCombatText" },
}

local function ColumnEnabled(column)
    local cvar = column.def.enabled
    if not cvar then return true end
    local value = NS.values[cvar]
    return value == nil or value ~= 0
end

local MAX_ENTRIES = 12
local FONT_SIZE = 30    -- fixed font size; the visible size comes from frame scale

local function RandRange(low, high)
    return low + random() * (high - low)
end

local function SetNumberFont(fontString, flags)
    local path = DAMAGE_TEXT_FONT or STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF"
    if not fontString:SetFont(path, FONT_SIZE, flags) then
        fontString:SetFont(STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF", FONT_SIZE, flags)
    end
end

---------------------------------------------------------------------------------------------------
-- Number entries
---------------------------------------------------------------------------------------------------

local function AcquireEntry(column)
    local pool = column.pool
    for i = 1, #pool do
        if not pool[i]:IsShown() then
            return pool[i]
        end
    end
    if #pool >= MAX_ENTRIES then
        return nil
    end
    local entry = CreateFrame("Frame", nil, column.clip)
    entry:SetSize(1, 1)
    entry.text = entry:CreateFontString(nil, "OVERLAY")
    entry.text:SetPoint("CENTER")
    SetNumberFont(entry.text, "OUTLINE")
    entry:Hide()
    pool[#pool + 1] = entry
    return entry
end

-- Size multiplier over the first RAMP_DURATION seconds.
local function RampScale(entry, t)
    local ramp = t / entry.rampDuration
    if ramp > 1 then ramp = 1 end
    local remaining = (1 - ramp) ^ entry.rampPow
    if entry.classic then
        -- Classic style: starts small, grows and settles.
        return PHYS.CLASSIC_START + (1 - PHYS.CLASSIC_START) * (1 - remaining)
    end
    -- Retail style: pops large, shrinks to normal size.
    return 1 + (entry.crit and PHYS.POP_CRIT or PHYS.POP_HIT) * remaining
end

local function Animate(column, entry, dt)
    entry.t = entry.t + dt
    local t = entry.t
    if t >= PHYS.LIFETIME then
        entry:Hide()
        return
    end

    -- x and y are in game pixels from the spawn point; the preview scale turns them into screen px.
    local x, y, scale
    if entry.player then
        scale = 1
        if entry.mode == 2 then
            x, y = 0, -PHYS.PLAYER_SPEED * t
        elseif entry.mode == 3 then
            x = entry.vx * t
            y = PHYS.ARC_RISE * t - 0.5 * PHYS.ARC_GRAVITY * t * t
        else
            x, y = 0, PHYS.PLAYER_SPEED * t
        end
    else
        scale = RampScale(entry, t)
        x = entry.x0 + entry.vx * t
        y = entry.y0 + entry.vy0 * t - 0.5 * entry.gravity * t * t
    end

    local alpha = 1
    local fadeStart = PHYS.FADE_START * PHYS.LIFETIME
    if t > fadeStart then
        alpha = 1 - (t - fadeStart) / (PHYS.LIFETIME - fadeStart)
    end

    local frameScale = entry.size / FONT_SIZE * scale * PHYS.PREVIEW_SCALE
    if frameScale < 0.1 then frameScale = 0.1 end
    entry:SetScale(frameScale)
    entry:ClearAllPoints()
    entry:SetPoint("CENTER", column.clip, "BOTTOM",
        x * PHYS.PREVIEW_SCALE / frameScale, (entry.originY + y * PHYS.PREVIEW_SCALE) / frameScale)
    entry:SetAlpha(alpha)
end

-- Lowest and highest height (game px, relative to the spawn point) a number reaches while it is
-- still clearly visible.
local function PathExtent(vy0, gravity, duration)
    local low, high = 0, 0
    for step = 1, 12 do
        local t = duration * step / 12
        local y = vy0 * t - 0.5 * gravity * t * t
        if y < low then low = y end
        if y > high then high = y end
    end
    return low, high
end

-- Start one number in a column.
local function Spawn(column)
    local def = column.def
    local entry = AcquireEntry(column)
    if not entry then
        return
    end
    local v = NS.values
    local height = column.clip:GetHeight()
    if not height or height <= 0 then height = 120 end

    entry.t = 0
    entry.crit = def.crit and true or false
    entry.player = def.player and true or false
    entry.text:SetText(tostring(floor(RandRange(def.min, def.max))))
    entry.text:SetTextColor(def.color[1], def.color[2], def.color[3])
    SetNumberFont(entry.text, def.crit and "THICKOUTLINE" or "OUTLINE")

    -- Directional numbers alternate sides: the real direction depends on where you stand.
    column.flip = not column.flip
    local away = column.flip and 1 or -1

    if entry.player then
        entry.mode = floor((v.floatingCombatTextFloatMode_v2 or 1) + 0.5)
        entry.size = PHYS.PLAYER_SIZE
        entry.originY = height * (entry.mode == 2 and PHYS.ORIGIN_DOWN
            or entry.mode == 3 and PHYS.ORIGIN_ARC or PHYS.ORIGIN_UP)
        entry.vx = away * RandRange(PHYS.ARC_SIDE_MIN, PHYS.ARC_SIDE_MAX)
    else
        local classic = (v.classicStyleWorldText or 0) >= 0.5
        local spread = v.WorldTextStartPosRandomness_v2 or 0
        local directional = v.floatingCombatTextCombatDamageDirectionalScale_v2 or 0
        local offset = v.floatingCombatTextCombatDamageDirectionalOffset_v2 or 1
        local screenY = def.crit and v.WorldTextCritScreenY_v2 or v.WorldTextScreenY_v2 or 0
        entry.classic = classic
        entry.rampDuration = math.max(0.05, v.WorldTextRampDuration_v2 or PHYS.RAMP_DURATION)
        entry.rampPow = math.max(0.1, (def.crit and v.WorldTextRampPowCrit_v2 or v.WorldTextRampPow_v2)
            or (def.crit and PHYS.RAMP_POW_CRIT or PHYS.RAMP_POW))
        entry.size = PHYS.BASE_SIZE * (v.WorldTextScale_v2 or 1) * (def.crit and PHYS.CRIT_SIZE_MUL or 1)
        entry.x0 = (random() * 2 - 1) * spread * PHYS.SPREAD_PX
        entry.y0 = screenY * PHYS.SCREEN_HEIGHT + (random() * 2 - 1) * spread * PHYS.SPREAD_PX * 0.6
        if directional > 0 then
            entry.x0 = entry.x0 + away * offset * PHYS.DIR_OFFSET_PX
        end
        entry.vx = away * directional * PHYS.DIR_SPEED_PX
        entry.vy0 = classic and PHYS.RISE_CLASSIC or PHYS.RISE_RETAIL
        entry.gravity = (v.WorldTextGravity_v2 or 0) * PHYS.GRAVITY_PX
        -- Center the visible part of the arc in the column, so rising, falling and the style are
        -- all in view. The height settings (y0) then move the numbers away from the center.
        local low, high = PathExtent(entry.vy0, entry.gravity, PHYS.LIFETIME * PHYS.VISIBLE_FRACTION)
        entry.originY = height / 2 - (low + high) / 2 * PHYS.PREVIEW_SCALE
        entry.originY = math.max(height * PHYS.ORIGIN_MIN, math.min(height * PHYS.ORIGIN_MAX, entry.originY))
    end
    entry:Show()
    Animate(column, entry, 0)
end

---------------------------------------------------------------------------------------------------
-- Drawer
---------------------------------------------------------------------------------------------------

local function ClearColumn(column)
    for i = 1, #column.pool do
        column.pool[i]:Hide()
    end
end

-- The drawer: three columns of sample numbers on a dark stage. `bar` is the strip above it.
function NS.CreatePreviewPane(content, bar)
    local pane = CreateFrame("Frame", nil, content)
    pane:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, 0)
    pane:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", 0, 0)
    W.Paint(pane, C.drawer, 9, nil, "124")

    local host = CreateFrame("Frame", nil, pane)
    host:SetPoint("TOPLEFT", 20, -10)
    host:SetPoint("BOTTOMRIGHT", -20, 12)
    pane.columns = {}

    for index, def in ipairs(COLUMNS) do
        local column = CreateFrame("Frame", nil, host)
        column.def, column.pool, column.nextIn, column.flip = def, {}, (index - 1) * 0.2, false
        if index > 1 then
            local divider = column:CreateTexture(nil, "ARTWORK")
            divider:SetWidth(1)
            divider:SetPoint("TOPLEFT", -8, -4)
            divider:SetPoint("BOTTOMLEFT", -8, 4)
            divider:SetColorTexture(C.line[1], C.line[2], C.line[3], 1)
        end
        local caption = W.Text(column, def.title, 0, 0, nil, C.dim, "semibold", 13)
        caption:ClearAllPoints()
        caption:SetPoint("TOP", 0, -2)
        caption:SetJustifyH("CENTER")
        caption:SetWordWrap(false)
        local clip = CreateFrame("Frame", nil, column)
        clip:SetPoint("TOPLEFT", 2, -22)
        clip:SetPoint("BOTTOMRIGHT", -2, 2)
        clip:SetClipsChildren(true)
        column.clip, column.caption = clip, caption
        column.offLabel = W.Text(clip, "Off", 0, 0, nil, C.dim, "medium", 14)
        column.offLabel:ClearAllPoints()
        column.offLabel:SetPoint("CENTER", clip, "CENTER", 0, 0)
        column.offLabel:SetJustifyH("CENTER")
        column.offLabel:SetWordWrap(false)
        column.offLabel:Hide()
        pane.columns[index] = column
    end

    local function LayoutColumns()
        local width = host:GetWidth()
        local count = #pane.columns
        if not width or width <= 0 or count == 0 then return end
        local gap = 16
        local columnWidth = (width - gap * (count - 1)) / count
        for index, column in ipairs(pane.columns) do
            column:ClearAllPoints()
            column:SetPoint("TOPLEFT", host, "TOPLEFT", (index - 1) * (columnWidth + gap), 0)
            column:SetPoint("BOTTOMLEFT", host, "BOTTOMLEFT", (index - 1) * (columnWidth + gap), 0)
            column:SetWidth(columnWidth)
        end
    end
    host:SetScript("OnSizeChanged", LayoutColumns)
    LayoutColumns()
    -- The size-changed event can arrive late on the first open, so the columns are also laid out
    -- on show and whenever the measured width differs from the one they were laid out for.
    function pane:LayoutColumns()
        LayoutColumns()
        self.layoutWidth = host:GetWidth()
    end

    function pane:Clear()
        for _, column in ipairs(self.columns) do
            ClearColumn(column)
        end
    end

    -- Start over so a changed setting is visible at once. Debounced while a slider is dragged.
    function pane:Poke()
        self.pokeIn = 0.08
    end

    local function Burst(self)
        self:Clear()
        for index, column in ipairs(self.columns) do
            column.nextIn = (index - 1) * 0.2
        end
    end

    pane:SetScript("OnUpdate", function(self, elapsed)
        -- `real` is wall-clock time (for the restart debounce); `dt` is animation time.
        local real = elapsed
        if real > 0.1 then real = 0.1 end
        local dt = real * PHYS.SPEED
        local width = host:GetWidth()
        if width and width > 0 and width ~= self.layoutWidth then
            self:LayoutColumns()
        end
        if self.pokeIn then
            self.pokeIn = self.pokeIn - real
            if self.pokeIn <= 0 then
                self.pokeIn = nil
                Burst(self)
            end
        end
        for _, column in ipairs(self.columns) do
            local enabled = ColumnEnabled(column)
            if enabled ~= column.enabled then
                column.enabled = enabled
                column.offLabel:SetShown(not enabled)
                column.caption:SetTextColor(C.dim[1], C.dim[2], C.dim[3], enabled and 1 or 0.5)
                if not enabled then ClearColumn(column) end
            end
            if enabled then
                column.nextIn = column.nextIn - dt
                if column.nextIn <= 0 then
                    Spawn(column)
                    column.nextIn = RandRange(column.def.interval[1], column.def.interval[2])
                end
                local pool = column.pool
                for i = 1, #pool do
                    if pool[i]:IsShown() then
                        Animate(column, pool[i], dt)
                    end
                end
            end
        end
    end)
    pane:SetScript("OnHide", function(self) self:Clear() end)
    pane:SetScript("OnShow", function(self)
        self:LayoutColumns()
        self:Poke()
    end)
    return pane
end
