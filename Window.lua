-- Forever Combat Style: the settings window. A sidebar of pages (General, Combat, Appearance)
-- with each page's count of changed settings; beside it the page title, a tab per section with
-- the All / Changed filter and the preview switch, the damage preview, the page's section cards
-- and a footer.
local ADDON_NAME, NS = ...
local W = NS.W
local C = W.COLORS
local L = NS.L   -- Locales/Locale.lua loads first (see the TOC)

local WINDOW_WIDTH, WINDOW_HEIGHT = 1000, 780   -- default size
local MIN_WIDTH, MIN_HEIGHT = 720, 560          -- smallest size the grip allows
local SIDEBAR_WIDTH, HEADER_HEIGHT = 216, 88
local TABS_HEIGHT, FOOTER_HEIGHT = 40, 52
local NAV_HEIGHT = 40
local PAGE_PAD = 24    -- the left edge of the title, the tabs and the cards
local JUMP_ABOVE = 16  -- the room left above a section a tab jumps to
local GOLD = C.accent
-- Seconds after the window opens at which every label is laid out again (see OnShow).
local RELAY_DELAYS = { 0.3, 1.0, 2.5 }

local session = { page = "general", filter = "all", scroll = {} }

-- The game cannot open a browser, so links are offered in a box to copy from.
local function RegisterLinkPopup(name, url)
    StaticPopupDialogs[name] = {
        text = "",   -- filled in when shown, so it follows the language
        button1 = CLOSE,
        hasEditBox = true,
        editBoxWidth = 360,
        OnShow = function(self)
            local editBox = self.GetEditBox and self:GetEditBox() or self.editBox or self.EditBox
            editBox:SetText(url)
            editBox:SetFocus()
            editBox:HighlightText()
        end,
        EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
        EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
end

local function ShowLinkPopup(name)
    StaticPopupDialogs[name].text = L["Press Ctrl+C to copy the URL."]
    StaticPopup_Show(name)
end

-- Where translation mistakes are reported (shown from the Language section).
RegisterLinkPopup("FOREVERCOMBATSTYLE_TRANSLATION_ISSUES_URL", "https://github.com/Spatovaliyski/ForeverCombatStyle/issues")
-- The companion addon, offered at the end of the General page when it is not installed.
RegisterLinkPopup("FOREVERCOMBATSTYLE_PLATESCT_URL", "https://www.curseforge.com/wow/addons/platesct")

local function S(cvar)
    return NS.BY_CVAR[cvar]
end

-- PlateSCT (same author) draws its own numbers and, by default, turns Blizzard's off: then
-- nothing this window sets shows in game. Read through its global namespace when it is loaded.
local function PlateSCT()
    local addon = _G.PlateSCT
    return type(addon) == "table" and addon or nil
end

local function PlateSCTHidesBlizzard()
    local addon = PlateSCT()
    return addon and type(addon.db) == "table" and addon.db.hideBlizzardFCT and true or false
end

-- The warning and its fix, shown at the top of each page while PlateSCT hides Blizzard's text
-- (also while the page lists only changed settings).
local function PlateSCTWarning(layout)
    layout:Always(function()
        layout:When(PlateSCTHidesBlizzard, function()
            layout:Warning(L["PlateSCT is hiding Blizzard's floating combat text, so these settings won't show in game."])
            layout:Action(L["Show Blizzard numbers"],
                L["Turns off PlateSCT's \"Hide Blizzard floating combat text\". PlateSCT's own numbers keep working."],
                function()
                    local addon = PlateSCT()
                    if addon and addon.SetHideBlizzardFCT then
                        addon:SetHideBlizzardFCT(false)
                    elseif addon and addon.db then
                        -- An older PlateSCT without the hook: turn the option off and its text back on.
                        addon.db.hideBlizzardFCT = false
                        if addon.RestoreBlizzardFCTSetting then addon:RestoreBlizzardFCTSetting() end
                    end
                    NS.Resync()
                end)
        end)
    end)
end

-- The PlateSCT advert at the end of the General page, in PlateSCT's ember colors: open it when it
-- is loaded, otherwise offer its download link.
local PLATESCT_LOGO = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Media\\UI\\PlateSCT.png"
local function Companion(layout)
    local addon = PlateSCT()
    local installed = addon and addon.ShowOptions and true or false
    layout:Promo({
        logo = PLATESCT_LOGO,
        watermark = true,
        badge = L["Alternative"],
        title = L["Want full control instead of Blizzard's limits?"],
        body = L["PlateSCT replaces Blizzard's numbers with its own, so every part of them is yours to style."],
        features = {
            L["Numbers on nameplates or in screen areas"],
            L["Any font, size and color"],
            L["Spell icons and damage-school colors"],
            L["Damage threshold and abbreviations"],
            L["Combine rapid hits into one number"],
            L["Crit sounds and incoming damage"],
        },
        button = installed and L["Open PlateSCT"] or L["Get PlateSCT"],
        foot = installed and L["Installed. Opens its settings."]
            or L["Free on CurseForge. Works on Forever, Midnight and Classic."],
        onClick = function()
            if installed then
                if NS.frame then NS.frame:Hide() end
                addon:ShowOptions()
            else
                ShowLinkPopup("FOREVERCOMBATSTYLE_PLATESCT_URL")
            end
        end,
        from = { 0.384, 0.149, 0.043, 1 },
        to = { 0.098, 0.071, 0.051, 1 },
        ring = { 0.965, 0.553, 0.204, 1 },
    })
end

-- The pages are made each time the window is built, not at load: every label is looked up in
-- the language that is active then (the window is rebuilt when the language changes).
local function BuildPages()
    local warning = L["This adjusts Blizzard's own floating combat text, so it works 100% with the default game. Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."]
    return {
        {
            id = "general", label = L["General"], icon = "General",
            subtitle = L["Number style, your own combat text, and how the addon behaves."],
            build = function(layout)
                layout:Warning(warning)
                PlateSCTWarning(layout)
                layout:Section(L["Number Style"])
                layout:StyleCards(S("classicStyleWorldText"), {
                    [1] = {
                        tagline = L["Smooth reveal"],
                        text = L["Numbers ease into view and settle into place gradually, for a softer, more fluid feel."],
                    },
                    [0] = {
                        tagline = L["Instant and direct"],
                        text = L["Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."],
                    },
                })
                layout:Note(string.format(
                    L["Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose."],
                    L["Appearance"]))
                layout:Slider(S("WorldTextScale_v2"))
                layout:Section(L["Your Combat Text"])
                layout:Toggle(S("enableFloatingCombatText"))
                layout:Segments(S("floatingCombatTextFloatMode_v2"))
                layout:Section(L["Behaviour"])
                layout:Switch(L["Re-apply at login"],
                    L["Put your settings back at login if the client reset them."],
                    function() return NS.db.reapply end,
                    function(value) NS.db.reapply = value end)
                layout:Section(L["Language"])
                local choices = {}
                for _, option in ipairs(NS.LOCALE_OPTIONS) do
                    -- Each name is drawn in a font that has its own script (Source Sans 3 has no
                    -- Korean or Chinese); "Auto" is drawn in the language it resolves to.
                    local code = option.id == "auto" and NS:ResolveLocaleCode("auto") or option.id
                    choices[#choices + 1] = {
                        id = option.id, label = NS:GetLocaleOptionLabel(option), font = W.FontPathFor(code, "regular"),
                    }
                end
                layout:Choice(L["Language"],
                    L["Choose the language used by Forever Combat Style panels and messages."], choices,
                    function() return NS.db.locale end,
                    function(value) NS:SetLocalePreference(value) end)
                -- Every translation here is machine-made: say so, and say where to report problems.
                if NS:ResolveLocaleCode() ~= "enUS" then
                    layout:Note(L["This translation was generated with AI. If you find inconsistent terminology or incorrect wording, please report it through GitHub Issues. Thank you for your help! Translation contributors will be credited."])
                    layout:Action(L["Open Link"], L["Press Ctrl+C to copy the URL."], function()
                        ShowLinkPopup("FOREVERCOMBATSTYLE_TRANSLATION_ISSUES_URL")
                    end)
                end
                Companion(layout)
            end,
        },
        {
            id = "combat", label = L["Combat"], icon = "Combat",
            subtitle = L["Choose what appears: damage, healing, shields and pets."],
            build = function(layout)
                layout:Warning(warning)
                PlateSCTWarning(layout)
                layout:Section(L["Damage"])
                layout:Toggle(S("floatingCombatTextCombatDamage_v2"))
                layout:Toggle(S("floatingCombatTextCombatDamageAllAutos_v2"))
                layout:Toggle(S("floatingCombatTextCombatLogPeriodicSpells_v2"))
                layout:Section(L["Healing"])
                layout:Toggle(S("floatingCombatTextCombatHealing_v2"))
                layout:Toggle(S("floatingCombatTextCombatHealingAbsorbSelf_v2"))
                layout:Toggle(S("floatingCombatTextCombatHealingAbsorbTarget_v2"))
                layout:Section(L["Pets"])
                layout:Toggle(S("floatingCombatTextPetMeleeDamage_v2"))
                layout:Toggle(S("floatingCombatTextPetSpellDamage_v2"))
            end,
        },
        {
            id = "appearance", label = L["Appearance"], icon = "Appearance",
            subtitle = L["How numbers fall, drift, start and fade."],
            build = function(layout)
                layout:Warning(warning)
                PlateSCTWarning(layout)
                layout:Section(L["Fall & Spread"])
                layout:Slider(S("WorldTextGravity_v2"))
                layout:Slider(S("WorldTextStartPosRandomness_v2"))
                layout:Section(L["Direction"])
                layout:Slider(S("floatingCombatTextCombatDamageDirectionalScale_v2"))
                layout:Slider(S("floatingCombatTextCombatDamageDirectionalOffset_v2"))
                layout:Section(L["Start Height"])
                layout:Slider(S("WorldTextScreenY_v2"))
                layout:Slider(S("WorldTextCritScreenY_v2"))
                layout:Section(L["Pop & Fade"])
                layout:Slider(S("WorldTextRampDuration_v2"))
                layout:Slider(S("WorldTextRampPow_v2"))
                layout:Slider(S("WorldTextRampPowCrit_v2"))
                layout:Slider(S("WorldTextMinAlpha_v2"))
            end,
        },
    }
end

local function Build()
    local PAGES = BuildPages()
    -- Labels of a window that was replaced (language change) are no longer worth re-laying.
    W.texts = {}
    local frame = CreateFrame("Frame", "ForeverCombatStyleFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    -- ESC looks the window up by this global name. A rebuilt window (language change) reuses the
    -- name, and the game may keep the old frame under it, so point the name at this one.
    _G["ForeverCombatStyleFrame"] = frame
    frame:Hide()
    frame:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetToplevel(true)
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetResizable(true)
    -- ESC closes the window through the game's special-frames list (once, even after a rebuild).
    local listed = false
    for _, name in ipairs(UISpecialFrames) do
        if name == "ForeverCombatStyleFrame" then listed = true break end
    end
    if not listed then table.insert(UISpecialFrames, "ForeverCombatStyleFrame") end
    W.Backdrop(frame, "window")
    frame.controls, frame.layouts, frame.pages = {}, {}, {}
    frame.navButtons, frame.tabs = {}, {}

    -- Move from mouse down/up: dragging a child shifts the parent cursor offset.
    local function Draggable(region)
        region:EnableMouse(true)
        region:SetScript("OnMouseDown", function(_, button) if button == "LeftButton" then frame:StartMoving(true) end end)
        region:SetScript("OnMouseUp", function() frame:StopMovingOrSizing(); frame:SetUserPlaced(false) end)
    end

    local function Rule(parent, from, to, y)
        local line = W.Line(parent, C.line, "ARTWORK")
        line:SetHeight(1)
        line:SetPoint(from, 0, y or 0)
        line:SetPoint(to, 0, y or 0)
        return line
    end

    -- Sidebar: the addon's name, the pages, and how to close the window.
    local sidebar = CreateFrame("Frame", nil, frame)
    sidebar:SetWidth(SIDEBAR_WIDTH)
    sidebar:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    sidebar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 1, 1)
    W.Paint(sidebar, C.sidebar, 9, nil, "23")   -- rounded where it meets the window's corners
    Draggable(sidebar)
    local sidebarLine = W.Line(sidebar, C.line, "ARTWORK")
    sidebarLine:SetWidth(1)
    sidebarLine:SetPoint("TOPRIGHT"); sidebarLine:SetPoint("BOTTOMRIGHT")
    local logo = CreateFrame("Frame", nil, sidebar)
    logo:SetSize(36, 36)
    logo:SetPoint("TOPLEFT", 20, -26)
    W.Paint(logo, GOLD, 9)
    local logoIcon = W.Icon(logo, "Combat", 22, C.onAccent, "OVERLAY")
    logoIcon:SetPoint("CENTER")
    W.Text(sidebar, "FOREVER", 68, -28, nil, GOLD, "semibold", 12):SetWordWrap(false)
    W.Text(sidebar, "Combat Style", 68, -44, nil, C.bright, "semibold", 16):SetWordWrap(false)
    local gameVersion = GetBuildInfo and GetBuildInfo()
    local version = W.Text(sidebar, "v" .. NS.VERSION .. (gameVersion and ("  ·  " .. L["Client"] .. " " .. gameVersion) or ""),
        20, -84, SIDEBAR_WIDTH - 28, C.dim, "regular", 12)
    version:SetWordWrap(false)
    -- These two run on with the lines under the tabs and over the footer.
    Rule(sidebar, "TOPLEFT", "TOPRIGHT", -(HEADER_HEIGHT + TABS_HEIGHT - 1))
    Rule(sidebar, "BOTTOMLEFT", "BOTTOMRIGHT", FOOTER_HEIGHT - 1)
    local hint = W.Text(sidebar, L["/fcs  ·  ESC to close"], 0, 0, SIDEBAR_WIDTH - 28, C.dim, "regular", 13)
    hint:ClearAllPoints()
    hint:SetPoint("LEFT", sidebar, "BOTTOMLEFT", 20, FOOTER_HEIGHT / 2)
    hint:SetWordWrap(false)

    local main = CreateFrame("Frame", nil, frame)
    main:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 0, 0)
    main:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)

    -- Header: the page's title and subtitle over a warm glow, close on the right.
    local header = CreateFrame("Frame", nil, main)
    header:SetPoint("TOPLEFT"); header:SetPoint("TOPRIGHT")
    header:SetHeight(HEADER_HEIGHT)
    Draggable(header)
    local glow = W.Fade(header, C.glow, C.clear, "BACKGROUND")
    glow:SetAllPoints(header)
    frame.pageTitle = W.Text(header, "", PAGE_PAD, -20, nil, C.bright, "semibold", 22)
    frame.pageTitle:SetWordWrap(false)
    -- The subtitle may wrap onto a second line: translations run longer than the English text.
    frame.subtitle = W.Text(header, "", PAGE_PAD, -50, nil, C.muted, "regular", 13)
    frame.subtitle:SetPoint("TOPRIGHT", header, "TOPRIGHT", -60, -50)
    local close = W.CloseButton(frame, function() frame:Hide() end)
    close:SetPoint("TOPRIGHT", -14, -14)
    close:SetFrameLevel(header:GetFrameLevel() + 5)
    W.Tooltip(close, L["Close"])

    -- The gold rim along the window's top, brightest in the middle.
    local rim = CreateFrame("Frame", nil, frame)
    rim:SetAllPoints(frame)
    rim:SetFrameLevel(frame:GetFrameLevel() + 40)
    local rimLeft = W.Fade(rim, C.clear, C.rim, "OVERLAY")
    rimLeft:SetHeight(1)
    rimLeft:SetPoint("TOPLEFT", rim, "TOPLEFT", 10, 0)
    rimLeft:SetPoint("TOPRIGHT", rim, "TOP", 0, 0)
    local rimRight = W.Fade(rim, C.rim, C.clear, "OVERLAY")
    rimRight:SetHeight(1)
    rimRight:SetPoint("TOPLEFT", rim, "TOP", 0, 0)
    rimRight:SetPoint("TOPRIGHT", rim, "TOPRIGHT", -10, 0)

    -- The band under the header: a tab per section of the page; the filter and the preview
    -- switch at its right end.
    local band = CreateFrame("Frame", nil, main)
    band:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, 0)
    band:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", 0, 0)
    band:SetHeight(TABS_HEIGHT)
    Rule(band, "BOTTOMLEFT", "BOTTOMRIGHT")

    local previewSwitch = W.Switch(band)
    previewSwitch:SetPoint("RIGHT", band, "RIGHT", -24, 0)
    previewSwitch:SetScript("OnClick", function(self)
        NS.db.previewHidden = (not self:GetChecked()) or nil
        self:Paint()
        frame:LayoutPages()
    end)
    local previewLabel = W.Text(band, L["Preview"], 0, 0, nil, C.muted, "medium", 13)
    previewLabel:ClearAllPoints()
    previewLabel:SetPoint("RIGHT", previewSwitch, "LEFT", -8, 0)
    previewLabel:SetWordWrap(false)
    W.Tooltip(previewSwitch, L["Show or hide the damage preview."])
    frame.previewSwitch = previewSwitch

    local filter = CreateFrame("Frame", nil, band)
    filter:SetHeight(28)
    filter:SetPoint("RIGHT", previewLabel, "LEFT", -18, 0)
    W.Paint(filter, C.window, 8, C.line)
    local function FilterButton(label, name, tip)
        local button = W.Button(filter, label, 60, 22, function() frame:SetFilter(name) end, "segment")
        button.optionsRadius = 6
        W.ReapplyFont(button:GetFontString())
        W.Tooltip(button, tip)
        return button
    end
    local showAll = FilterButton(L["All"], "all")
    showAll:SetPoint("LEFT", filter, "LEFT", 3, 0)
    local showChanged = FilterButton(L["Changed"], "changed", L["Show only the settings that differ from the defaults."])
    showChanged:SetPoint("LEFT", showAll, "RIGHT", 2, 0)
    frame.filterButtons = { all = showAll, changed = showChanged }

    -- The damage preview (Preview.lua): under the tabs, above every page, so it keeps playing
    -- whichever page is open.
    frame.preview = NS.Preview.New(main)
    local previewBand = frame.preview.frame
    previewBand:SetPoint("TOPLEFT", band, "BOTTOMLEFT", 0, 0)
    previewBand:SetPoint("TOPRIGHT", band, "BOTTOMRIGHT", 0, 0)
    previewBand:SetHeight(NS.Preview.HEIGHT)

    -- Footer: reload on the left, reset everything on the right.
    local footer = CreateFrame("Frame", nil, main)
    footer:SetPoint("BOTTOMLEFT"); footer:SetPoint("BOTTOMRIGHT")
    footer:SetHeight(FOOTER_HEIGHT)
    W.Paint(footer, C.drawer, 9, nil, "124")
    Rule(footer, "TOPLEFT", "TOPRIGHT")
    local reload = W.IconButton(footer, L["Reload UI"], "Transfer", function() ReloadUI() end)
    reload:SetPoint("LEFT", footer, "LEFT", PAGE_PAD, 0)
    W.Tooltip(reload, L["Reload the interface. Use it if a change does not show up in game."])
    local reset = W.IconButton(footer, L["Reset Defaults"], "Reset", function()
        NS.Reset()
        frame:Refresh()
    end)
    reset:SetPoint("RIGHT", footer, "RIGHT", -PAGE_PAD, 0)
    W.Tooltip(reset, L["Put every combat text setting back to the WoW Forever default."])

    frame.pageArea = CreateFrame("Frame", nil, main)
    frame.pageArea:SetClipsChildren(true)

    -- The scrolling page fills what is left between the tabs (or the preview) and the footer.
    function frame:LayoutPages()
        local shown = not (NS.db and NS.db.previewHidden)
        previewBand:SetShown(shown)
        previewSwitch:SetChecked(shown)
        previewSwitch:Paint()
        local top = HEADER_HEIGHT + TABS_HEIGHT + (shown and NS.Preview.HEIGHT or 0)
        self.pageArea:ClearAllPoints()
        self.pageArea:SetPoint("TOPLEFT", main, "TOPLEFT", 0, -top)
        self.pageArea:SetPoint("BOTTOMRIGHT", footer, "TOPRIGHT", 0, 0)
        for _, entry in pairs(self.pages) do entry.view:UpdateScroll() end
        self:MarkTab()
    end

    -- Light the tab of the section in view: the one a tab jumped to until the page moves again,
    -- else the last section that starts at the top of the view (the last of all at the end).
    function frame:MarkTab()
        local view = self.activeView
        if not view then return end
        local sections = self.pages[session.page].layout.sections
        local position, maximum = view.scroll:GetVerticalScroll(), view:MaxScroll()
        local active = 1
        if self.jumped and math.abs(position - self.jumped.position) < 1 then
            active = self.jumped.index
        else
            self.jumped = nil
            for index, section in ipairs(sections) do
                if section.top - JUMP_ABOVE - 8 <= position then active = index end
            end
            if maximum > 0 and position >= maximum - 1 then active = #sections end
        end
        for index, tab in ipairs(self.tabs) do W.SetSelected(tab, index == active) end
    end

    function frame:JumpTo(index)
        local view = self.activeView
        local section = view and self.pages[session.page].layout.sections[index]
        if not section then return end
        local position = math.max(0, math.min(view:MaxScroll(), section.top - JUMP_ABOVE))
        self.jumped = { index = index, position = position }
        view:SetScroll(position)
    end

    -- The `index`th section tab, made on first use, named and sized for `title`.
    function frame:Tab(index, title)
        local tab = self.tabs[index]
        if not tab then
            tab = W.TabButton(band, TABS_HEIGHT, function() frame:JumpTo(index) end)
            self.tabs[index] = tab
        end
        tab:SetText(title)
        W.FitButton(tab, 20)
        return tab
    end

    -- The filter's size, then as many section tabs as fit before it (a narrow window or long
    -- translations leave the last ones out; the page still scrolls to them). Where not even the
    -- first fits, the preview switch goes without its word (its tooltip still names it).
    function frame:LayoutTabs()
        local filterWidth = W.FitButton(showAll, 22, 40) + W.FitButton(showChanged, 22, 60) + 8
        filter:SetWidth(filterWidth)
        local entry = self.pages[session.page]
        local sections = entry and entry.layout.sections or {}
        local labelWidth = W.TextWidth(previewLabel)
        local room = band:GetWidth() - (24 + 40 + 8 + labelWidth + 18 + filterWidth) - 12
        local first = sections[1] and self:Tab(1, sections[1].title)
        local worded = not first or PAGE_PAD - 10 + first:GetWidth() <= room
        previewLabel:SetShown(worded)
        filter:ClearAllPoints()
        if worded then
            filter:SetPoint("RIGHT", previewLabel, "LEFT", -18, 0)
        else
            filter:SetPoint("RIGHT", previewSwitch, "LEFT", -18, 0)
            room = room + labelWidth + 8
        end
        local x, full = PAGE_PAD - 10, false
        for index, section in ipairs(sections) do
            local tab = self:Tab(index, section.title)
            local width = tab:GetWidth()
            full = full or x + width > room
            tab:SetShown(not full)
            tab:ClearAllPoints()
            tab:SetPoint("BOTTOMLEFT", band, "BOTTOMLEFT", x, 0)
            x = x + width + 2
        end
        for index = #sections + 1, #self.tabs do self.tabs[index]:Hide() end
        self:MarkTab()
    end

    -- The changed marks, the sidebar's counts and the filter's.
    function frame:UpdateMarks()
        local here = 0
        for id, entry in pairs(self.pages) do
            local count = entry.layout:UpdateMarks()
            entry.changed = count
            self.navButtons[id].count:SetText(count > 0 and tostring(count) or "")
            if id == session.page then here = count end
        end
        local label = here > 0 and (L["Changed"] .. "  " .. here) or L["Changed"]
        if showChanged:GetText() ~= label then
            showChanged:SetText(label)
            self:LayoutTabs()
        end
    end

    -- Lay the open page out for the filter. The settings listed under "Changed" are the ones that
    -- differ now: a row stays while it is being edited, even once it is back at its default.
    local function ApplyFilter(self)
        local entry = self.pages[session.page]
        local _, changed = entry.layout:UpdateMarks()
        entry.layout:SetKeep(session.filter == "changed" and changed or nil)
        entry.layout:Reflow()
        for name, button in pairs(self.filterButtons) do W.SetSelected(button, name == session.filter) end
        self.jumped = nil
        entry.view:UpdateScroll()
        entry.view:SetScroll(session.filter == "all" and session.scroll[session.page] or 0)
    end

    -- Remember where the full page was scrolled to before it changes.
    local function KeepScroll(self)
        if self.activeView and self.shownFilter == "all" then
            session.scroll[session.page] = self.activeView.scroll:GetVerticalScroll()
        end
    end

    function frame:SetFilter(name)
        KeepScroll(self)
        session.filter = name
        ApplyFilter(self)
        self.shownFilter = name
        self:LayoutTabs()
    end

    function frame:SelectPage(pageId)
        local entry = self.pages[pageId]
        if not entry then return end
        KeepScroll(self)
        session.page = pageId
        for id, other in pairs(self.pages) do other.view:SetShown(id == pageId) end
        self.pageTitle:SetText(entry.page.label)
        self.subtitle:SetText(entry.page.subtitle)
        for id, button in pairs(self.navButtons) do W.SetSelected(button, id == pageId) end
        self.activeView = entry.view
        ApplyFilter(self)
        self.shownFilter = session.filter
        self:UpdateMarks()
        self:LayoutTabs()
    end

    function frame:Refresh()
        NS.Refresh()
        for _, control in ipairs(self.controls) do control:Refresh() end
        self.preview.Look()
        reload:Fit()
        reset:Fit()
        for _, layout in ipairs(self.layouts) do layout:Reflow() end
        for _, entry in pairs(self.pages) do entry.view:UpdateScroll() end
        self:UpdateMarks()
        self:LayoutTabs()
    end

    -- A page was laid out again for a new width.
    function frame:LayoutChanged(layout)
        local entry = self.pages[session.page]
        if entry and entry.layout == layout then
            entry.view:UpdateScroll()
            self:LayoutTabs()
        end
    end

    -- Pages and their sidebar entries.
    for index, page in ipairs(PAGES) do
        local id = page.id
        local button = W.NavButton(sidebar, page.label, page.icon, SIDEBAR_WIDTH - 1, NAV_HEIGHT,
            function() frame:SelectPage(id) end)
        button:SetPoint("TOPLEFT", 0, -(HEADER_HEIGHT + TABS_HEIGHT + 10 + (index - 1) * NAV_HEIGHT))
        W.Tooltip(button, function()
            local entry = frame.pages[id]
            local count = entry and entry.changed or 0
            if count > 0 then return string.format(L["Settings changed from the default: %d"], count) end
        end)
        frame.navButtons[id] = button
        local view = W.ScrollView(frame.pageArea, frame)
        local layout = W.NewLayout(view.child, frame,
            { width = view.child:GetWidth(), padLeft = PAGE_PAD, padRight = PAGE_PAD - W.SCROLL_ROOM })
        page.build(layout)
        layout:Empty(L["Nothing on this page differs from the defaults."])
        layout:Finish()
        frame.pages[id] = { page = page, view = view, layout = layout }
        view.OnScroll = function()
            if frame.activeView == view then frame:MarkTab() end
        end
    end
    main:SetScript("OnSizeChanged", function() frame:LayoutTabs() end)

    -- Fit the window to the screen. The default size sets the scale on small screens; the saved
    -- size is restored within what fits, and the last position is kept while the game runs.
    function frame:FitToScreen()
        local screenWidth, screenHeight = UIParent:GetWidth(), UIParent:GetHeight()
        local scale, maxWidth, maxHeight = 1, 4096, 4096
        if screenWidth and screenWidth > 0 and screenHeight and screenHeight > 0 then
            local availableWidth, availableHeight = screenWidth * 0.94, screenHeight * 0.94
            scale = math.min(1, availableWidth / WINDOW_WIDTH, availableHeight / WINDOW_HEIGHT)
            maxWidth = math.max(WINDOW_WIDTH, availableWidth / scale)
            maxHeight = math.max(WINDOW_HEIGHT, availableHeight / scale)
        end
        self:SetScale(scale)
        if self.SetResizeBounds then
            self:SetResizeBounds(MIN_WIDTH, MIN_HEIGHT, maxWidth, maxHeight)
        else
            if self.SetMinResize then self:SetMinResize(MIN_WIDTH, MIN_HEIGHT) end
            if self.SetMaxResize then self:SetMaxResize(maxWidth, maxHeight) end
        end
        local db = NS.db or {}
        self:SetSize(math.min(maxWidth, math.max(MIN_WIDTH, db.windowWidth or WINDOW_WIDTH)),
            math.min(maxHeight, math.max(MIN_HEIGHT, db.windowHeight or WINDOW_HEIGHT)))
        if session.left and session.top then
            self:ClearAllPoints()
            self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT",
                session.left / self:GetEffectiveScale(), session.top / self:GetEffectiveScale())
        end
    end

    -- Resize grip in the bottom-right corner, as in PlateSCT. The size is kept between sessions;
    -- double-click returns to the default size.
    local function SaveSize()
        NS.db.windowWidth = math.floor(frame:GetWidth() + 0.5)
        NS.db.windowHeight = math.floor(frame:GetHeight() + 0.5)
    end
    local grip = CreateFrame("Button", nil, frame)
    grip:SetSize(16, 16)
    grip:SetPoint("BOTTOMRIGHT", -3, 3)
    grip:SetFrameLevel(frame:GetFrameLevel() + 50)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetScript("OnMouseDown", function(_, button)
        if button ~= "LeftButton" then return end
        grip.sizing = true
        frame:StartSizing("BOTTOMRIGHT")
    end)
    grip:SetScript("OnMouseUp", function()
        frame:StopMovingOrSizing()
        frame:SetUserPlaced(false)
        if grip.sizing then
            grip.sizing = nil
            SaveSize()
        end
    end)
    grip:SetScript("OnDoubleClick", function()
        NS.db.windowWidth, NS.db.windowHeight = nil, nil
        frame:FitToScreen()
    end)
    W.Tooltip(grip, L["Drag to resize. Double-click to restore the default size."])
    frame.resizeGrip = grip

    frame:SetScript("OnEvent", function(self)
        self:FitToScreen()
    end)
    frame:SetScript("OnHide", function(self)
        W.CloseMenu()   -- the dropdown is not a child of this window, so close it explicitly
        if grip.sizing then
            grip.sizing = nil
            SaveSize()
        end
        self:StopMovingOrSizing()
        if self:GetLeft() and self:GetTop() then
            session.left = self:GetLeft() * self:GetEffectiveScale()
            session.top = self:GetTop() * self:GetEffectiveScale()
        end
        -- The window opens on the whole page, where it was left.
        KeepScroll(self)
        self.activeView = nil
        session.filter = "all"
        self:UnregisterAllEvents()
    end)
    frame:SetScript("OnShow", function(self)
        self:RegisterEvent("UI_SCALE_CHANGED")
        self:RegisterEvent("DISPLAY_SIZE_CHANGED")
        self:FitToScreen()
        -- Text laid out before its font loaded can stay blank, and widths are only reliable once
        -- fonts have loaded: re-lay every label now and again at RELAY_DELAYS after the window
        -- opens. On the first open after a fresh game start the client can take longer than a
        -- moment to load the fonts (a /reload keeps them loaded, which hides the problem).
        W.RefreshAllText()
        self:LayoutPages()
        self:Refresh()
        self:SelectPage(session.page)
        if C_Timer and C_Timer.After then
            -- A pass from an earlier open must not run after the window was closed and reopened.
            self.openCount = (self.openCount or 0) + 1
            local opened = self.openCount
            for _, delay in ipairs(RELAY_DELAYS) do
                C_Timer.After(delay, function()
                    if self:IsShown() and self.openCount == opened then
                        W.RefreshAllText()
                        self:Refresh()
                    end
                end)
            end
        end
    end)

    NS.RefreshWindow = function()
        if frame:IsShown() then frame:Refresh() end
    end
    return frame
end

-- Every change moves the changed marks, the sidebar's counts and the filter's.
NS.OnChange(function()
    local frame = NS.frame
    if frame and frame:IsShown() then frame:UpdateMarks() end
end)

function NS.Toggle()
    if not NS.frame then
        NS.frame = Build()
    end
    if NS.frame:IsShown() then
        NS.frame:Hide()
    else
        NS.frame:Show()
    end
end

-- Build the window again in the current language (called after the language changes). A frame
-- cannot be destroyed, so the old one is hidden and dropped; its position is kept in `session`.
-- If the window was never opened, the first /fcs builds it in the new language anyway.
-- Show the window (never closes it); used by PlateSCT's "Open Forever Combat Style".
function NS.Open()
    if not NS.frame then
        NS.frame = Build()
    end
    NS.frame:Show()
    NS.frame:Raise()
end

function NS:RebuildWindow()
    local old = NS.frame
    if not old then
        return
    end
    local shown = old:IsShown()
    old:Hide()
    old:UnregisterAllEvents()
    old:SetParent(nil)
    NS.frame = Build()
    if shown then
        NS.frame:Show()
    end
end

-- /fcs debug: report how a few labels are being drawn (for diagnosing blank text).
function NS.Debug()
    if not NS.frame then
        NS.Print("open the window once with /fcs, then run /fcs debug.")
        return
    end
    -- ESC closes the window through UISpecialFrames, which finds it by its global name.
    local listed = false
    for _, name in ipairs(UISpecialFrames) do
        if name == "ForeverCombatStyleFrame" then listed = true end
    end
    NS.Print(string.format("window: shown=%s listed for ESC=%s global is this window=%s language=%s",
        tostring(NS.frame:IsShown()), tostring(listed),
        tostring(_G["ForeverCombatStyleFrame"] == NS.frame), NS:ResolveLocaleCode()))
    local wanted = { [L["Number Style"]] = true, [L["Style"]] = true, [L["Size"]] = true, [L["Behaviour"]] = true }
    for _, region in ipairs(W.texts) do
        local text = region:GetText()
        if text and wanted[text] then
            local path, size = region:GetFont()
            local alpha = region.GetEffectiveAlpha and region:GetEffectiveAlpha() or -1
            NS.Print(string.format("%s: shown=%s visible=%s alpha=%.2f font=%s size=%s width=%.0f height=%.0f",
                text, tostring(region:IsShown()), tostring(region:IsVisible()), alpha,
                tostring(path):match("[^\\]+$") or "?", tostring(size),
                region:GetStringWidth() or 0, region:GetStringHeight() or 0))
        end
    end
    -- The labels that draw blank, next to one that draws fine (a row caption).
    local function Describe(name, region)
        if not region then
            NS.Print(name .. ": not found")
            return
        end
        local path, size = region:GetFont()
        local r, g, b, a = region:GetTextColor()
        local parent = region:GetParent()
        local layer, sublevel = region:GetDrawLayer()
        NS.Print(string.format(
            "%s: text=%q shown=%s visible=%s alpha=%.2f font=%s size=%s color=%.2f/%.2f/%.2f/%.2f "
                .. "width=%.0f height=%.0f layer=%s/%s parent: level=%s alpha=%.2f shown=%s",
            name, string.sub(region:GetText() or "", 1, 24), tostring(region:IsShown()),
            tostring(region:IsVisible()), region.GetEffectiveAlpha and region:GetEffectiveAlpha() or -1,
            tostring(path):match("[^\\]+$") or "?", tostring(size), r or -1, g or -1, b or -1, a or -1,
            region:GetStringWidth() or 0, region:GetStringHeight() or 0, tostring(layer), tostring(sublevel),
            parent and tostring(parent:GetFrameLevel()) or "?", parent and parent:GetEffectiveAlpha() or -1,
            parent and tostring(parent:IsShown()) or "?"))
    end
    local combat = NS.frame.pages and NS.frame.pages.combat
    if combat then
        local sample, warning
        for _, row in ipairs(combat.layout.rows) do
            if row.layoutKind == "warning" and not warning then warning = row.layoutCaption end
            if row.layoutKind == "control" and not sample then sample = row end
        end
        Describe("warning text", warning)
        Describe("row caption", sample and sample.layoutCaption)
        Describe("section title", combat.layout.cards[1] and combat.layout.cards[1].title)
    end
end
