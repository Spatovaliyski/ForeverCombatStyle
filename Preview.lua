-- Forever Combat Style: the damage preview, a band of its own between the section tabs and the
-- page, so it keeps playing whichever page is open (the window's Preview switch hides it).
-- A training dummy with numbers popping off it, driven by one OnUpdate. Font strings are recycled,
-- and a text size is only set when a number is spawned. Each of this addon's CVars moves one part
-- of the motion. It is an approximation: the game's numbers are 3D world text with no published
-- formulas, so the band says so.
local _, NS = ...
local W = NS.W
local C = W.COLORS
local L = NS.L   -- Locales/Locale.lua loads first (see the TOC)

local P = {}
NS.Preview = P

P.HEIGHT = 168        -- band height in the window
P.EVERY = 0.5         -- seconds between numbers
P.SIZE = 18           -- a normal hit's text size at Size 1
P.CRIT = 1.4          -- crit text size, times a hit's
P.LIFE = 1.1          -- seconds a number lives
P.RISE = 110          -- px per second upward at the start (crits get CRIT_RISE more)
P.CRIT_RISE = 30
P.GRAVITY = 280       -- px per second squared at Gravity 1 (the default 0.5 gives 140)
P.SIDE = 45           -- px per second sideways at Directional movement 1
P.JITTER = 6          -- px of random start offset at Spread 0, plus SPREAD per 1
P.SPREAD = 12
P.OFFSET = 8          -- px higher start per 1 of Directional offset
P.SCREEN = 600        -- px per 1.0 of Hit/Crit height (a fraction of the screen in game)
P.FADE = 0.4          -- share of the life spent fading out at Minimum opacity 0
P.POP_HIT = 0.35      -- Retail: extra size a hit starts with, settling over the ramp
P.POP_CRIT = 0.9
P.REVEAL = 0.12       -- Retail: seconds to ease into view

local floor, max, min, random = math.floor, math.max, math.min, math.random

local function clamp(value, low, high)
    if value < low then return low end
    if value > high then return high end
    return value
end

-- The live value of one of this addon's CVars (its default when the client lacks it).
local function V(cvar)
    local value = NS.values[cvar]
    if value == nil then
        local setting = NS.BY_CVAR[cvar]
        value = NS.defaults[cvar] or (setting and setting.default) or 0
    end
    return value
end

local function DamageFont()
    return _G.DAMAGE_TEXT_FONT or "Fonts\\FRIZQT__.TTF"
end

local function Amount(value)
    if _G.BreakUpLargeNumbers then return _G.BreakUpLargeNumbers(value) end
    return tostring(value)
end

function P.New(parent)
    local s = {}
    local f = CreateFrame("Frame", nil, parent)
    s.frame = f
    f:Hide()
    f:SetClipsChildren(true)
    -- The darkest surface, like the header, with a rule under it: set apart from the page below.
    W.Paint(f, C.drawer, 0)
    local rule = W.Line(f, C.edge, "ARTWORK")
    rule:SetHeight(1)
    rule:SetPoint("BOTTOMLEFT"); rule:SetPoint("BOTTOMRIGHT")

    local caption = W.Text(f, L["Approximate preview"], 24, -10, nil, C.dim, "regular", 12)
    caption:SetWordWrap(false)

    local dummy = CreateFrame("Frame", nil, f)
    dummy:SetSize(130, 24)
    dummy:SetPoint("BOTTOM", f, "BOTTOM", 0, 10)
    W.Paint(dummy, C.card, 6, C.edge)
    local name = W.Text(dummy, L["Training Dummy"], 0, 0, nil, C.muted, "regular", 12)
    name:ClearAllPoints()
    name:SetPoint("CENTER")
    name:SetJustifyH("CENTER")
    name:SetWordWrap(false)

    -- Shown instead of numbers while the game's damage numbers are switched off.
    local off = W.Text(f, L["Damage over targets is off, so no numbers show in game."], 0, 0, nil, C.muted, "regular", 13)
    off:ClearAllPoints()
    off:SetPoint("CENTER", f, "CENTER", 0, 14)
    off:SetJustifyH("CENTER")
    off:Hide()

    local live, spare = {}, {}
    local clock, n = 0, 0
    local look = {}

    -- Everything the numbers read from the settings, once per change.
    function s.Look()
        local scale = clamp(V("WorldTextScale_v2"), 0.25, 4)
        look.file = DamageFont()
        look.size = clamp(floor(P.SIZE * scale + 0.5), 6, 64)
        look.crit = clamp(floor(P.SIZE * scale * P.CRIT + 0.5), 6, 80)
        look.gravity = P.GRAVITY * max(0, V("WorldTextGravity_v2"))
        look.side = P.SIDE * max(0, V("floatingCombatTextCombatDamageDirectionalScale_v2"))
        look.jitter = P.JITTER + P.SPREAD * max(0, V("WorldTextStartPosRandomness_v2"))
        look.start = 2 + P.OFFSET * max(0, V("floatingCombatTextCombatDamageDirectionalOffset_v2"))
        look.hitY = clamp(V("WorldTextScreenY_v2") * P.SCREEN, -40, 80)
        look.critY = clamp(V("WorldTextCritScreenY_v2") * P.SCREEN, -40, 80)
        -- The Style choice: 1 is Retail (smooth reveal), 0 is Classic (instant), as on the cards.
        look.retail = V("classicStyleWorldText") == 1
        look.ramp = clamp(V("WorldTextRampDuration_v2"), 0.05, P.LIFE)
        look.powHit = clamp(V("WorldTextRampPow_v2"), 0.1, 50)
        look.powCrit = clamp(V("WorldTextRampPowCrit_v2"), 0.1, 50)
        -- A higher floor keeps numbers solid for longer before they go.
        look.fade = P.FADE * (1 - clamp(V("WorldTextMinAlpha_v2"), 0, 1))
        look.on = V("floatingCombatTextCombatDamage_v2") ~= 0
        off:SetShown(not look.on)
    end

    -- A number is a holder frame (scaled for the Retail pop) with its text bottom-centred in it.
    local function Take()
        local number = table.remove(spare)
        if not number then
            number = CreateFrame("Frame", nil, f)
            number:SetSize(1, 1)
            number.text = number:CreateFontString(nil, "OVERLAY")
            number.text:SetPoint("BOTTOM", number, "BOTTOM")
        end
        return number
    end

    local function Place(number, x, y, scale)
        if number.scale ~= scale then
            number:SetScale(scale)
            number.scale = scale
        end
        -- Offsets are in the holder's own scale.
        number:ClearAllPoints()
        number:SetPoint("BOTTOM", dummy, "TOP", x / scale, y / scale)
    end

    local function Spawn()
        n = n + 1
        local crit = n % 4 == 0
        local number = Take()
        local text = number.text
        local size = crit and look.crit or look.size
        if text.file ~= look.file or text.size ~= size then
            if not pcall(text.SetFont, text, look.file, size, "OUTLINE") then
                pcall(text.SetFont, text, "Fonts\\FRIZQT__.TTF", size, "OUTLINE")
            end
            text.file, text.size = look.file, size
        end
        text:SetText(Amount(crit and random(1800, 3200) or random(300, 1200)))
        if crit then
            text:SetTextColor(C.number[1], C.number[2], C.number[3])
        else
            text:SetTextColor(1, 1, 1)
        end
        number.t = 0
        number.crit = crit
        -- Alternate sides, like the game's directional numbers.
        number.vx = (n % 2 == 0 and 1 or -1) * look.side * (0.7 + 0.6 * random())
        number.x0 = (random() * 2 - 1) * look.jitter
        number.y0 = (crit and look.critY or look.hitY) + (random() * 2 - 1) * (look.jitter - P.JITTER) * 0.3
        number.vy = P.RISE + (crit and P.CRIT_RISE or 0)
        number.scale = nil
        number:SetAlpha(look.retail and 0 or 1)
        number:Show()
        live[#live + 1] = number
    end

    local function Recycle(i)
        local number = live[i]
        number:Hide()
        table.remove(live, i)
        spare[#spare + 1] = number
    end

    local function Step(_, elapsed)
        clock = clock + elapsed
        if clock >= P.EVERY then
            clock = 0
            if look.on then Spawn() end
        end
        for i = #live, 1, -1 do
            local number = live[i]
            number.t = number.t + elapsed
            local t = number.t
            if t >= P.LIFE then
                Recycle(i)
            else
                local y = number.vy * t - 0.5 * look.gravity * t * t
                local scale, alpha = 1, 1
                if look.retail then
                    -- Starts larger and settles to its size over the ramp; a higher strength settles sooner.
                    local rest = 1 - min(t / look.ramp, 1)
                    if rest > 0 then
                        local pop = number.crit and P.POP_CRIT or P.POP_HIT
                        scale = 1 + pop * rest ^ (number.crit and look.powCrit or look.powHit)
                    end
                    alpha = min(1, t / P.REVEAL)
                end
                local left = 1 - t / P.LIFE
                if look.fade > 0 and left < look.fade then
                    alpha = min(alpha, left / look.fade)
                end
                -- Rounded so a settled number stops re-scaling every frame.
                Place(number, number.x0 + number.vx * t, look.start + number.y0 + max(y, -20),
                    floor(scale * 100 + 0.5) / 100)
                number:SetAlpha(alpha)
            end
        end
    end

    -- OnUpdate only runs while the strip is visible, so it stops by itself with its page or the
    -- window. OnShow re-reads the look.
    f:SetScript("OnUpdate", Step)
    f:SetScript("OnShow", function()
        s.Look()
        clock = P.EVERY   -- the first number right away
    end)
    f:SetScript("OnHide", function()
        for i = #live, 1, -1 do Recycle(i) end
    end)

    -- Follow every change, from the sliders while they are dragged too.
    NS.OnChange(function()
        if f:IsVisible() then s.Look() end
    end)

    s.Look()
    return s
end
