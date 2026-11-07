-- Forever Combat Style: language registry, set up the same way as PlateSCT.
-- Every locale file registers a table of L["English text"] = "translation". Code looks text up
-- through NS.L; a missing translation falls back to English, then to the key itself.
local _, NS = ...

NS.LocaleTables = NS.LocaleTables or {}

-- Preference values stored in NS.db.locale. "auto" follows the game client.
NS.LOCALE_OPTIONS = {
    { id = "auto", labelKey = "Auto" },
    { id = "enUS", label = "English" },
    { id = "frFR", label = "Français" },
    { id = "deDE", label = "Deutsch" },
    { id = "esES", label = "Español" },
    { id = "ruRU", label = "Русский" },
    { id = "itIT", label = "Italiano" },
    { id = "ptBR", label = "Português" },
    { id = "zhCN", label = "简体中文" },
    { id = "zhTW", label = "繁體中文" },
    { id = "koKR", label = "한국어" },
}

local active = {}

local L = setmetatable({}, {
    __index = function(_, key)
        local value = active[key]
        if value ~= nil then
            return value
        end
        local en = NS.LocaleTables.enUS and NS.LocaleTables.enUS[key]
        if en ~= nil then
            return en
        end
        return key
    end,
})

NS.L = L

function NS.RegisterLocale(code, strings)
    NS.LocaleTables[code] = strings
end

function NS:NormalizeLocaleCode(code)
    if not code or code == "" or code == "auto" then
        return "auto"
    end
    if code == "esMX" then
        return "esES"
    end
    if code == "enGB" or code == "enCN" or code == "enTW" then
        return "enUS"
    end
    if code == "ptPT" then
        return "ptBR"
    end
    return code
end

-- True when `value` is one of the ids in LOCALE_OPTIONS ("auto" included).
function NS:IsLocalePreference(value)
    for _, option in ipairs(self.LOCALE_OPTIONS) do
        if option.id == value then
            return true
        end
    end
    return false
end

function NS:ResolveLocaleCode(preference)
    local code = self:NormalizeLocaleCode(preference or (self.db and self.db.locale) or "auto")
    if code == "auto" then
        code = self:NormalizeLocaleCode(GetLocale and GetLocale() or "enUS")
        if code == "auto" then
            code = "enUS"
        end
    end
    if NS.LocaleTables[code] then
        return code
    end
    return "enUS"
end

function NS:GetLocaleOptionLabel(option)
    if option.id == "auto" then
        return L["Auto"] .. " (" .. self:GetLocaleLabelForCode(self:ResolveLocaleCode("auto")) .. ")"
    end
    if option.label then
        return option.label
    end
    if option.labelKey then
        return L[option.labelKey]
    end
    return option.id
end

function NS:GetLocaleLabelForCode(code)
    code = self:NormalizeLocaleCode(code)
    for _, option in ipairs(self.LOCALE_OPTIONS) do
        if option.id == code then
            return self:GetLocaleOptionLabel(option)
        end
    end
    return code
end

function NS:GetLocalePreferenceLabel(preference)
    preference = self:NormalizeLocaleCode(preference or (self.db and self.db.locale) or "auto")
    if preference == "auto" then
        return self:GetLocaleOptionLabel({ id = "auto" })
    end
    return self:GetLocaleLabelForCode(preference)
end

-- Point NS.L at the saved language. Call it once the saved variables are loaded.
function NS:ApplyLocale(preference)
    if preference ~= nil and self.db then
        self.db.locale = self:NormalizeLocaleCode(preference)
    end
    local code = self:ResolveLocaleCode()
    active = NS.LocaleTables[code] or NS.LocaleTables.enUS or {}
    return code
end

-- Change the language and rebuild the window so every label uses it.
function NS:SetLocalePreference(preference)
    preference = self:NormalizeLocaleCode(preference or "auto")
    if self.db then
        self.db.locale = preference
    end
    self:ApplyLocale(preference)
    if self.RebuildWindow then
        self:RebuildWindow()
    end
end
