-- Forever Combat Style: CVar definitions, saved settings and slash commands.
-- Lua 5.1. Shared namespace `NS` (second vararg), also exposed as the global ForeverCombatStyle.
local ADDON_NAME, NS = ...
_G.ForeverCombatStyle = NS

NS.VERSION = "1.0.0"
NS.PREFIX = "|cff8ee6deForeverCombatStyle:|r "

local abs = math.abs
local L = NS.L   -- Locales/Locale.lua loads first (see the TOC)

-- Every control in the window is generated from this list, in this order.
--   kind    "slider" (min/max/step/decimals), "choice" (options = { {value, label}, ... })
--           or "toggle" (0 / 1)
--   hardMin / hardMax   limits for typed values (the slider range is only the drag range)
--   default             fallback default (from the Warcraft wiki), used only when the client cannot
--                       report its own; see NS.defaults
--   label, tip and option labels are English keys into NS.L; the window translates them when it
--   draws them (the language can change while the game runs), so keep them in Locales/enUS.lua.
NS.SETTINGS = {
    {
        cvar = "classicStyleWorldText", kind = "choice",
        label = "Style", default = 0,
        options = { { 0, "Retail" }, { 1, "Classic" } },
        tip = "Classic or Retail look for floating damage numbers.",
    },
    {
        cvar = "WorldTextScale_v2", kind = "slider",
        label = "Size", default = 1, min = 0.25, max = 4, step = 0.05, decimals = 2,
        tip = "Overall size of damage numbers.",
    },
    {
        cvar = "WorldTextGravity_v2", kind = "slider",
        label = "Gravity", default = 0.5, min = 0, max = 3, step = 0.05, decimals = 2,
        tip = "How strongly numbers fall back down after rising.",
    },
    {
        cvar = "WorldTextStartPosRandomness_v2", kind = "slider",
        label = "Spread", default = 0, min = 0, max = 3, step = 0.05, decimals = 2,
        tip = "How far from the spawn point numbers may start.",
    },
    {
        cvar = "WorldTextScreenY_v2", kind = "slider",
        label = "Hit height", default = 0, min = -0.25, max = 0.25, step = 0.005, decimals = 3,
        hardMin = -5, hardMax = 5,
        tip = "Start offset for normal hits. Positive is higher.",
    },
    {
        cvar = "WorldTextCritScreenY_v2", kind = "slider",
        label = "Crit height", default = 0, min = -0.25, max = 0.25, step = 0.005, decimals = 3,
        hardMin = -5, hardMax = 5,
        tip = "Start offset for critical hits. Positive is higher.",
    },
    {
        cvar = "floatingCombatTextCombatDamageDirectionalScale_v2", kind = "slider",
        label = "Directional movement", default = 0, min = 0, max = 3, step = 0.05, decimals = 2,
        tip = "Pushes numbers sideways, away from you.",
    },
    {
        cvar = "floatingCombatTextCombatDamageDirectionalOffset_v2", kind = "slider",
        label = "Directional offset", default = 1, min = 0, max = 3, step = 0.05, decimals = 2,
        tip = "How far from the target directional numbers start.",
    },
    {
        cvar = "floatingCombatTextFloatMode_v2", kind = "choice",
        label = "Float mode", default = 1,
        options = { { 1, "Up" }, { 2, "Down" }, { 3, "Arc" } },
        tip = "Scroll direction of the text on your own character.",
    },

    -- What shows (on/off). Defaults and descriptions from the Warcraft wiki.
    {
        cvar = "enableFloatingCombatText", kind = "toggle",
        label = "Your scrolling text", default = 0,
        tip = "Show combat text on your own character.",
    },
    {
        cvar = "floatingCombatTextCombatDamage_v2", kind = "toggle",
        label = "Damage over targets", default = 1,
        tip = "Show damage numbers over enemies you hit.",
    },
    {
        cvar = "floatingCombatTextCombatDamageAllAutos_v2", kind = "toggle",
        label = "All auto-attacks", default = 1,
        tip = "Show every auto-attack number instead of hiding some.",
    },
    {
        cvar = "floatingCombatTextCombatLogPeriodicSpells_v2", kind = "toggle",
        label = "Damage over time", default = 1,
        tip = "Show damage from periodic effects.",
    },
    {
        cvar = "floatingCombatTextCombatHealing_v2", kind = "toggle",
        label = "Healing you do", default = 0,
        tip = "Show the healing you do to your target.",
    },
    {
        cvar = "floatingCombatTextCombatHealingAbsorbSelf_v2", kind = "toggle",
        label = "Shields on you", default = 1,
        tip = "Show shields added to yourself.",
    },
    {
        cvar = "floatingCombatTextCombatHealingAbsorbTarget_v2", kind = "toggle",
        label = "Shields on your target", default = 1,
        tip = "Show shields added to your target.",
    },
    {
        cvar = "floatingCombatTextPetMeleeDamage_v2", kind = "toggle",
        label = "Pet melee damage", default = 1,
        tip = "Show your pet's melee damage.",
    },
    {
        cvar = "floatingCombatTextPetSpellDamage_v2", kind = "toggle",
        label = "Pet spell damage", default = 1,
        tip = "Show your pet's spell damage.",
    },

    -- Pop & fade. The wiki gives no descriptions for these; what they do is inferred from the
    -- names, and the ranges are guesses (typed values may go further).
    {
        cvar = "WorldTextRampDuration_v2", kind = "slider",
        label = "Ramp duration", default = 1, min = 0.1, max = 3, step = 0.05, decimals = 2,
        hardMin = 0.05, hardMax = 10,
        tip = "How long the size animation lasts, in seconds.",
    },
    {
        cvar = "WorldTextRampPow_v2", kind = "slider",
        label = "Hit ramp strength", default = 1.9, min = 0.5, max = 6, step = 0.1, decimals = 1,
        hardMin = 0.1, hardMax = 50,
        tip = "How sharply hit numbers settle to their size.",
    },
    {
        cvar = "WorldTextRampPowCrit_v2", kind = "slider",
        label = "Crit ramp strength", default = 8, min = 0.5, max = 16, step = 0.5, decimals = 1,
        hardMin = 0.1, hardMax = 50,
        tip = "How sharply crits settle to their size.",
    },
    {
        cvar = "WorldTextMinAlpha_v2", kind = "slider",
        label = "Minimum opacity", default = 0.5, min = 0, max = 1, step = 0.05, decimals = 2,
        hardMin = 0, hardMax = 1,
        tip = "Opacity floor for numbers.",
    },
}

NS.BY_CVAR = {}
for _, setting in ipairs(NS.SETTINGS) do
    NS.BY_CVAR[setting.cvar] = setting
end

NS.values = {}      -- cvar -> number, mirrors the live CVar (falls back to the default)
NS.defaults = {}    -- cvar -> number, the default the client reports (falls back to `default` above)
NS.available = {}   -- cvar -> true when this client knows the CVar
NS.listeners = {}   -- functions called as fn(cvar, value) after a change

---------------------------------------------------------------------------------------------------
-- CVar access (pcall'd: an unknown CVar raises an error on some clients)
---------------------------------------------------------------------------------------------------

local function ReadCVar(name)
    local getter = (C_CVar and C_CVar.GetCVar) or GetCVar
    if not getter then
        return nil
    end
    local ok, value = pcall(getter, name)
    if ok then
        return value
    end
    return nil
end

-- The default the client itself reports for a CVar, or nil when it cannot say.
local function ReadCVarDefault(name)
    local getter = (C_CVar and C_CVar.GetCVarDefault) or GetCVarDefault
    if not getter then
        return nil
    end
    local ok, value = pcall(getter, name)
    if ok then
        return tonumber(value)
    end
    return nil
end

local function WriteCVar(name, text)
    local setter = (C_CVar and C_CVar.SetCVar) or SetCVar
    if not setter then
        return false
    end
    local ok, result = pcall(setter, name, text)
    return ok and result ~= false
end

local function FormatNumber(value)
    if abs(value) < 1e-9 then
        value = 0
    end
    local text = string.format("%.4f", value)
    text = text:gsub("0+$", ""):gsub("%.$", "")
    return text
end
NS.FormatNumber = FormatNumber

local function Notify(cvar, value)
    for _, listener in ipairs(NS.listeners) do
        listener(cvar, value)
    end
end

function NS.OnChange(listener)
    NS.listeners[#NS.listeners + 1] = listener
end

---------------------------------------------------------------------------------------------------
-- State
---------------------------------------------------------------------------------------------------

-- Re-read every CVar from the client.
function NS.Refresh()
    for _, setting in ipairs(NS.SETTINGS) do
        -- The client's own default wins; the table above is only the fallback.
        NS.defaults[setting.cvar] = ReadCVarDefault(setting.cvar) or setting.default
        local number = tonumber(ReadCVar(setting.cvar))
        if number then
            NS.values[setting.cvar] = number
            NS.available[setting.cvar] = true
        else
            NS.values[setting.cvar] = NS.defaults[setting.cvar]
            NS.available[setting.cvar] = false
        end
    end
end

local function IsValidChoice(setting, value)
    for _, option in ipairs(setting.options) do
        if option[1] == value then
            return true
        end
    end
    return false
end

-- Write one CVar and remember it. Returns true on success.
function NS.Set(cvar, value)
    local setting = NS.BY_CVAR[cvar]
    value = tonumber(value)
    if not setting or not value or not NS.available[cvar] then
        return false
    end
    if setting.kind == "choice" then
        if not IsValidChoice(setting, value) then
            return false
        end
    elseif setting.kind == "toggle" then
        value = (value ~= 0) and 1 or 0
    else
        local low = setting.hardMin or setting.min
        local high = setting.hardMax or setting.max
        if low and value < low then value = low end
        if high and value > high then value = high end
    end
    if not WriteCVar(cvar, FormatNumber(value)) then
        return false
    end
    -- Trust what the client actually stored (it may round or clamp).
    value = tonumber(ReadCVar(cvar)) or value
    NS.values[cvar] = value
    if NS.db then
        NS.db.values[cvar] = value
    end
    Notify(cvar, value)
    return true
end

-- Put back anything the client changed since we last set it.
function NS.Reapply()
    if not NS.db then
        return
    end
    for _, setting in ipairs(NS.SETTINGS) do
        local saved = tonumber(NS.db.values[setting.cvar])
        if saved and NS.available[setting.cvar] and abs((NS.values[setting.cvar] or 0) - saved) > 1e-4 then
            NS.Set(setting.cvar, saved)
        end
    end
end

-- Back to the defaults the client reports (the table's values where it cannot say).
function NS.Reset()
    for _, setting in ipairs(NS.SETTINGS) do
        if NS.available[setting.cvar] then
            WriteCVar(setting.cvar, FormatNumber(NS.defaults[setting.cvar] or setting.default))
        end
    end
    if NS.db then
        NS.db.values = {}
    end
    NS.Refresh()
    Notify(nil, nil)
end

function NS.Print(message)
    print(NS.PREFIX .. message)
end

-- /fcs debug: what the client says about every CVar this addon controls, next to the fallback
-- default in the table above, and a few start-position CVars the addon does not control (they are
-- on the Retail CVar list). Stays in English.
local PROBES = {
    "WorldTextNonRandomZ_v2", "WorldTextRandomZMin_v2", "WorldTextRandomZMax_v2", "WorldTextRandomXY_v2",
    "WorldTextMinSize",
}

function NS.DebugCVars()
    NS.Print("CVars: name = live value (client default, fallback default)")
    for _, setting in ipairs(NS.SETTINGS) do
        local live = tonumber(ReadCVar(setting.cvar))
        local client = ReadCVarDefault(setting.cvar)
        local note = ""
        if live == nil then
            note = "  [not on this client]"
        elseif client and abs(client - setting.default) > 1e-6 then
            note = "  [client default differs]"
        end
        NS.Print(string.format("%s = %s (%s, %s)%s", setting.cvar, live and FormatNumber(live) or "?",
            client and FormatNumber(client) or "?", FormatNumber(setting.default), note))
    end
    for _, name in ipairs(PROBES) do
        local live, client = ReadCVar(name), ReadCVarDefault(name)
        NS.Print(string.format("%s = %s (%s)%s", name, tostring(live), client and FormatNumber(client) or "?",
            live == nil and "  [not on this client]" or ""))
    end
end

---------------------------------------------------------------------------------------------------
-- Saved variables and events
---------------------------------------------------------------------------------------------------

local function InitDB()
    ForeverCombatStyleDB = type(ForeverCombatStyleDB) == "table" and ForeverCombatStyleDB or {}
    local db = ForeverCombatStyleDB
    if type(db.values) ~= "table" then db.values = {} end
    if db.reapply == nil then db.reapply = true end
    -- Saved settings of the preview drawer, which no longer exists.
    db.showPreview, db.previewHeight, db.previewSlow = nil, nil, nil
    if not NS:IsLocalePreference(db.locale) then db.locale = "auto" end
    NS.db = db
    NS:ApplyLocale()
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_LOGIN")
events:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        InitDB()
    elseif event == "PLAYER_LOGIN" then
        NS.Refresh()
        if NS.db and NS.db.reapply then
            NS.Reapply()
        end
    end
end)

---------------------------------------------------------------------------------------------------
-- Entry points
---------------------------------------------------------------------------------------------------

SLASH_FOREVERCOMBATSTYLE1 = "/fcs"
SLASH_FOREVERCOMBATSTYLE2 = "/combatstyle"
SlashCmdList["FOREVERCOMBATSTYLE"] = function(message)
    message = (message or ""):gsub("^%s+", ""):gsub("%s+$", "")
    message = string.lower(message)
    if message == "reset" then
        NS.Reset()
        if NS.RefreshWindow then NS.RefreshWindow() end
        NS.Print(L["all combat text CVars set back to the WoW Forever defaults."])
    elseif message == "help" or message == "?" then
        NS.Print(L["/fcs opens the window. /fcs reset restores the WoW Forever defaults."])
    elseif message == "debug" then
        NS.DebugCVars()
        if NS.Debug then NS.Debug() end
    elseif NS.Toggle then
        NS.Toggle()
    end
end

function ForeverCombatStyle_OnAddonCompartmentClick()
    if NS.Toggle then
        NS.Toggle()
    end
end
