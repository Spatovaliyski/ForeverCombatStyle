-- Forever Combat Style: the settings window, laid out like the PlateSCT settings: a header, a
-- page sidebar on the left (General, Combat, Appearance) and a scrolling page with a title.
local ADDON_NAME, NS = ...
local W = NS.W
local C = W.COLORS
local L = NS.L   -- Locales/Locale.lua loads first (see the TOC)

local WINDOW_WIDTH, WINDOW_HEIGHT = 840, 780   -- default size
local MIN_WIDTH, MIN_HEIGHT = 720, 560           -- smallest size the grip allows
local SIDEBAR_WIDTH, HEADER_HEIGHT = 200, 64
local PAGE_TOP = 92
local NAV_TOP, NAV_STEP, NAV_HEIGHT = 24, 38, 36
local UTILITY_STEP, UTILITY_HEIGHT = 32, 30
local GOLD = C.accent
-- Seconds after the window opens at which every label is laid out again (see OnShow).
local RELAY_DELAYS = { 0.3, 1.0, 2.5 }

local session = { page = "general", scroll = {} }

-- Where translation mistakes are reported (shown from the Language section).
local TRANSLATION_ISSUES_URL = "https://github.com/Spatovaliyski/ForeverCombatStyle/issues"
StaticPopupDialogs["FOREVERCOMBATSTYLE_TRANSLATION_ISSUES_URL"] = {
    text = "",   -- filled in when shown, so it follows the language
    button1 = CLOSE,
    hasEditBox = true,
    editBoxWidth = 360,
    OnShow = function(self)
        local editBox = self.GetEditBox and self:GetEditBox() or self.editBox or self.EditBox
        editBox:SetText(TRANSLATION_ISSUES_URL)
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

local function S(cvar)
    return NS.BY_CVAR[cvar]
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
                layout:Heading(L["Number Style"])
                layout:StyleCards(S("classicStyleWorldText"), {
                    [0] = {
                        tagline = L["Smooth reveal"],
                        text = L["Numbers ease into view and settle into place gradually, for a softer, more fluid feel."],
                    },
                    [1] = {
                        tagline = L["Instant and direct"],
                        text = L["Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."],
                    },
                })
                layout:Note(string.format(
                    L["Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose."],
                    L["Appearance"]))
                layout:Slider(S("WorldTextScale_v2"))
                layout:Heading(L["Your Combat Text"])
                layout:Toggle(S("enableFloatingCombatText"))
                layout:Segments(S("floatingCombatTextFloatMode_v2"))
                layout:Heading(L["Behaviour"])
                layout:Switch(L["Re-apply at login"],
                    L["Put your settings back at login if the client reset them."],
                    function() return NS.db.reapply end,
                    function(value) NS.db.reapply = value end)
                layout:Heading(L["Language"])
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
                        StaticPopupDialogs["FOREVERCOMBATSTYLE_TRANSLATION_ISSUES_URL"].text =
                            L["Press Ctrl+C to copy the URL."]
                        StaticPopup_Show("FOREVERCOMBATSTYLE_TRANSLATION_ISSUES_URL")
                    end)
                end
            end,
        },
        {
            id = "combat", label = L["Combat"], icon = "Combat",
            subtitle = L["Choose what appears: damage, healing, shields and pets."],
            build = function(layout)
                layout:Warning(warning)
                layout:Heading(L["Damage"])
                layout:Toggle(S("floatingCombatTextCombatDamage_v2"))
                layout:Toggle(S("floatingCombatTextCombatDamageAllAutos_v2"))
                layout:Toggle(S("floatingCombatTextCombatLogPeriodicSpells_v2"))
                layout:Heading(L["Healing"])
                layout:Toggle(S("floatingCombatTextCombatHealing_v2"))
                layout:Toggle(S("floatingCombatTextCombatHealingAbsorbSelf_v2"))
                layout:Toggle(S("floatingCombatTextCombatHealingAbsorbTarget_v2"))
                layout:Heading(L["Pets"])
                layout:Toggle(S("floatingCombatTextPetMeleeDamage_v2"))
                layout:Toggle(S("floatingCombatTextPetSpellDamage_v2"))
            end,
        },
        {
            id = "appearance", label = L["Appearance"], icon = "Appearance",
            subtitle = L["How numbers fall, drift, start and fade."],
            build = function(layout)
                layout:Warning(warning)
                layout:Heading(L["Fall & Spread"])
                layout:Slider(S("WorldTextGravity_v2"))
                layout:Slider(S("WorldTextStartPosRandomness_v2"))
                layout:Heading(L["Direction"])
                layout:Slider(S("floatingCombatTextCombatDamageDirectionalScale_v2"))
                layout:Slider(S("floatingCombatTextCombatDamageDirectionalOffset_v2"))
                layout:Heading(L["Start Height"])
                layout:Slider(S("WorldTextScreenY_v2"))
                layout:Slider(S("WorldTextCritScreenY_v2"))
                layout:Heading(L["Pop & Fade"])
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
    frame.navButtons, frame.utilityButtons = {}, {}

    -- Header: identity on the left, close on the right.
    local titleBar = CreateFrame("Frame", nil, frame)
    titleBar:SetPoint("TOPLEFT", 1, -1)
    titleBar:SetPoint("TOPRIGHT", -1, -1)
    titleBar:SetHeight(HEADER_HEIGHT)
    titleBar:EnableMouse(true)
    -- The darkest surface; square bottom corners, rounded top to match the window.
    W.Paint(titleBar, C.drawer, 9, nil, "34")
    -- Move from mouse down/up: dragging a child shifts the parent cursor offset.
    titleBar:SetScript("OnMouseDown", function(_, button) if button == "LeftButton" then frame:StartMoving(true) end end)
    titleBar:SetScript("OnMouseUp", function() frame:StopMovingOrSizing(); frame:SetUserPlaced(false) end)
    local headerLine = W.Line(titleBar, C.line)
    headerLine:SetHeight(1)
    headerLine:SetPoint("BOTTOMLEFT"); headerLine:SetPoint("BOTTOMRIGHT")
    local logo = CreateFrame("Frame", nil, titleBar)
    logo:SetSize(32, 32)
    logo:SetPoint("LEFT", 20, 0)
    W.Paint(logo, GOLD, 9)
    local logoIcon = W.Icon(logo, "Combat", 20, C.onAccent, "OVERLAY")
    logoIcon:SetPoint("CENTER")
    W.Text(titleBar, "Forever Combat Style", 64, -15, 300, C.bright, "semibold", 15)
    local gameVersion = GetBuildInfo and GetBuildInfo()
    local version = W.Text(titleBar, "v" .. NS.VERSION .. (gameVersion and ("  ·  " .. L["Client"] .. " " .. gameVersion) or ""),
        64, -34, 360, C.muted)
    version:SetWordWrap(false)
    local close = W.CloseButton(frame, function() frame:Hide() end)
    close:SetPoint("TOPRIGHT", -16, -16)
    close:SetFrameLevel(titleBar:GetFrameLevel() + 5)
    W.Tooltip(close, L["Close"])

    -- Sidebar: pages, then quiet utilities pinned to the bottom.
    local sidebar = CreateFrame("Frame", nil, frame)
    sidebar:SetWidth(SIDEBAR_WIDTH)
    sidebar:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, 0)
    sidebar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 1, 1)
    W.Paint(sidebar, C.sidebar, 9, nil, "123")
    local sidebarLine = W.Line(sidebar, C.line)
    sidebarLine:SetWidth(1)
    sidebarLine:SetPoint("TOPRIGHT"); sidebarLine:SetPoint("BOTTOMRIGHT")
    local hint = W.Text(sidebar, L["/fcs  ·  ESC to close"], 0, 0, 176, C.dim)
    hint:ClearAllPoints()
    hint:SetPoint("BOTTOMLEFT", 22, 14)
    hint:SetWordWrap(false)
    local divider = W.Line(sidebar, C.line)
    divider:SetHeight(1)
    divider:SetPoint("BOTTOMLEFT", 16, 110); divider:SetPoint("BOTTOMRIGHT", -16, 110)

    -- Content: page title, subtitle and the scrolling page.
    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 0, 0)
    content:SetPoint("BOTTOMRIGHT", -1, 1)
    frame.pageTitle = W.Text(content, "", 32, -24, 560, C.bright, "semibold", 22)
    frame.pageTitle:SetWordWrap(false)
    -- The subtitle may wrap onto a second line: translations run longer than the English text.
    frame.subtitle = W.Text(content, "", 32, -52, nil, C.muted)
    frame.subtitle:SetPoint("TOPRIGHT", content, "TOPRIGHT", -32, -52)
    frame.pageArea = CreateFrame("Frame", nil, content)
    frame.pageArea:SetClipsChildren(true)

    -- The scrolling page fills the content below the title and subtitle.
    function frame:LayoutPages()
        self.pageArea:ClearAllPoints()
        self.pageArea:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -PAGE_TOP)
        self.pageArea:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", 0, 0)
        for _, entry in pairs(self.pages) do entry.view:UpdateScroll() end
    end

    function frame:Refresh()
        NS.Refresh()
        for _, control in ipairs(self.controls) do control:Refresh() end
        for _, layout in ipairs(self.layouts) do layout:Reflow() end
        for _, entry in pairs(self.pages) do entry.view:UpdateScroll() end
    end

    function frame:SelectPage(pageId)
        local entry = self.pages[pageId]
        if not entry then return end
        if self.activeView then
            session.scroll[session.page] = self.activeView.scroll:GetVerticalScroll()
        end
        session.page = pageId
        for id, other in pairs(self.pages) do other.view:SetShown(id == pageId) end
        self.pageTitle:SetText(entry.page.label)
        self.subtitle:SetText(entry.page.subtitle)
        for id, button in pairs(self.navButtons) do W.SetSelected(button, id == pageId) end
        self.activeView = entry.view
        entry.view:UpdateScroll()
        entry.view:SetScroll(session.scroll[pageId] or 0)
    end

    -- Pages and their sidebar entries.
    local width = SIDEBAR_WIDTH - 24
    for index, page in ipairs(PAGES) do
        local id = page.id
        local button = W.NavButton(sidebar, page.label, page.icon, width, NAV_HEIGHT,
            function() frame:SelectPage(id) end, "nav")
        button:SetPoint("TOPLEFT", 12, -NAV_TOP - (index - 1) * NAV_STEP)
        frame.navButtons[id] = button
        local view = W.ScrollView(frame.pageArea, frame)
        local layout = W.NewLayout(view.child, frame,
            { width = view.child:GetWidth(), padLeft = 32, padRight = 14, controlWidth = 220 })
        page.build(layout)
        layout:Finish()
        frame.pages[id] = { page = page, view = view, layout = layout }
    end

    local reload = W.NavButton(sidebar, L["Reload UI"], "Transfer", width, UTILITY_HEIGHT,
        function() ReloadUI() end, "utility")
    reload:SetPoint("BOTTOMLEFT", 12, 38 + UTILITY_STEP)
    W.Tooltip(reload, L["Reload the interface. Use it if a change does not show up in game."])
    local reset = W.NavButton(sidebar, L["Reset Defaults"], "Reset", width, UTILITY_HEIGHT, function()
        NS.Reset()
        frame:Refresh()
    end, "utility")
    reset:SetPoint("BOTTOMLEFT", 12, 38)
    W.Tooltip(reset, L["Put every combat text setting back to the WoW Forever default."])

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
        Describe("row caption (draws)", sample and sample.layoutCaption)
        Describe("row description", sample and sample.layoutDescription)
    end
end
