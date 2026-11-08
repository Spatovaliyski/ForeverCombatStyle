-- Forever Combat Style: Live mode.
-- The real floating numbers are drawn by the game, over a target you attack, so the best preview is
-- the game itself. While a setting changes, this window fades out of the way and a small chip next
-- to the cursor shows the setting and its value; a moment after the last change (and once the mouse
-- button is up) the window comes back.
local _, NS = ...
local W = NS.W
local C = W.COLORS
local L = NS.L   -- Locales/Locale.lua loads first (see the TOC)

local max, min = math.max, math.min

local LIVE = {
    ALPHA = 0.15,      -- opacity of the window while a setting changes
    HOLD = 1.5,        -- seconds it stays faded after the last change (and while the mouse button is down)
    FADE_OUT = 0.12,   -- seconds to fade out
    FADE_IN = 0.25,    -- seconds to come back
    CHIP_OFFSET = 16,  -- px from the cursor to the chip
}
NS.LIVE = LIVE

local state = { level = 1, hold = 0 }
local driver = CreateFrame("Frame")
local chip

-- The text of the chip: the setting's name and its value, or nil for a CVar this addon does not list.
function NS.LiveText(cvar)
    local setting = NS.BY_CVAR[cvar]
    local value = NS.values[cvar]
    if not setting or value == nil then return nil end
    local text
    if setting.kind == "choice" then
        for _, option in ipairs(setting.options) do
            if option[1] == value then text = L[option[2]] end
        end
    elseif setting.kind == "toggle" then
        text = value ~= 0 and L["On"] or L["Off"]
    else
        text = string.format("%." .. (setting.decimals or 2) .. "f", value)
    end
    if not text then return nil end
    return L[setting.label] .. "  " .. text
end

local function BuildChip()
    chip = CreateFrame("Frame", nil, UIParent)
    chip:SetFrameStrata("TOOLTIP")
    chip:SetClampedToScreen(true)
    chip:SetHeight(28)
    W.Paint(chip, C.menu, 10, C.accentSoft)
    chip.text = W.Text(chip, "", 0, 0, nil, C.accent, "medium", 14)
    chip.text:ClearAllPoints()
    chip.text:SetPoint("CENTER", chip, "CENTER", 0, 0)
    chip.text:SetWordWrap(false)
    chip:Hide()
    NS.liveChip = chip   -- kept so the tests can look at it
end

local function SetChipText(text)
    if not chip then BuildChip() end
    chip.text:SetText(text or "")
    chip:SetWidth(max(60, (chip.text:GetStringWidth() or 40) + 28))
end

local function MoveChip()
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    if not x or not scale or scale <= 0 then return end
    chip:ClearAllPoints()
    chip:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / scale + LIVE.CHIP_OFFSET, y / scale + LIVE.CHIP_OFFSET)
end

-- Put everything back: the window at full opacity, no chip.
function NS.LiveStop()
    driver:SetScript("OnUpdate", nil)
    if state.frame then state.frame:SetAlpha(1) end
    if chip then chip:Hide() end
    state.level, state.hold, state.frame = 1, 0, nil
end

local function Step(_, elapsed)
    local frame = state.frame
    if not frame or not frame:IsShown() then
        NS.LiveStop()
        return
    end
    local dt = min(elapsed, 0.1)
    if IsMouseButtonDown and IsMouseButtonDown("LeftButton") then
        state.hold = LIVE.HOLD   -- a drag in progress: stay out of the way until the button is up
    else
        state.hold = state.hold - dt
    end
    local want = state.hold > 0 and LIVE.ALPHA or 1
    local speed = (1 - LIVE.ALPHA) / (want < state.level and LIVE.FADE_OUT or LIVE.FADE_IN)
    if state.level > want then
        state.level = max(want, state.level - speed * dt)
    else
        state.level = min(want, state.level + speed * dt)
    end
    frame:SetAlpha(state.level)
    if state.level >= 1 and state.hold <= 0 then
        NS.LiveStop()
        return
    end
    -- The chip is shown while the window is (nearly) gone, and fades with it.
    if chip and chip:IsShown() then
        chip:SetAlpha((1 - state.level) / (1 - LIVE.ALPHA))
        MoveChip()
    end
end

local function Start(cvar)
    local frame = NS.frame
    local text = NS.LiveText(cvar)
    if not text then return end
    if state.frame and state.frame ~= frame then NS.LiveStop() end
    state.frame, state.hold = frame, LIVE.HOLD
    SetChipText(text)
    chip:Show()
    MoveChip()
    driver:SetScript("OnUpdate", Step)
end

-- Every change goes through NS.Set, so this covers sliders, typed values, the mouse wheel,
-- switches and the style cards. Reset (no CVar) leaves the window alone.
NS.OnChange(function(cvar)
    if not cvar or not NS.db or NS.db.liveMode == false then return end
    if NS.frame and NS.frame:IsShown() then Start(cvar) end
end)
