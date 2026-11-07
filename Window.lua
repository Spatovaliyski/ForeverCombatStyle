-- Forever Combat Style: the settings window, laid out like the PlateSCT settings: a header, a
-- page sidebar on the left (General, Appearance), a scrolling page with a title, and a preview
-- drawer along the bottom.
local ADDON_NAME, NS = ...
local W = NS.W
local C = W.COLORS

local WINDOW_WIDTH, WINDOW_HEIGHT = 840, 740   -- default size
local MIN_WIDTH, MIN_HEIGHT = 720, 560           -- smallest size the grip allows
local SIDEBAR_WIDTH, HEADER_HEIGHT = 200, 64
local BAR_HEIGHT, STAGE_HEIGHT = 44, 180
local PAGE_TOP = 92
local NAV_TOP, NAV_STEP, NAV_HEIGHT = 24, 38, 36
local UTILITY_STEP, UTILITY_HEIGHT = 32, 30
local GOLD = C.accent

local session = { page = "general", scroll = {} }

local WARNING = "This adjusts Blizzard's own floating combat text, so it works 100% with the default game. "
    .. "Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."

local function S(cvar)
    return NS.BY_CVAR[cvar]
end

local PAGES = {
    {
        id = "general", label = "General", icon = "General",
        subtitle = "Number style, your own combat text, and how the addon behaves.",
        build = function(layout)
            layout:Warning(WARNING)
            layout:Heading("Number Style")
            layout:Segments(S("classicStyleWorldText"))
            layout:Slider(S("WorldTextScale_v2"))
            layout:Heading("Your Combat Text")
            layout:Toggle(S("enableFloatingCombatText"))
            layout:Segments(S("floatingCombatTextFloatMode_v2"))
            layout:Heading("Behaviour")
            layout:Switch("Re-apply at login",
                "Put your settings back at login if the client reset them.",
                function() return NS.db.reapply end,
                function(value) NS.db.reapply = value end)
        end,
    },
    {
        id = "combat", label = "Combat", icon = "Combat",
        subtitle = "Choose what appears: damage, healing, shields and pets.",
        build = function(layout)
            layout:Warning(WARNING)
            layout:Heading("Damage")
            layout:Toggle(S("floatingCombatTextCombatDamage_v2"))
            layout:Toggle(S("floatingCombatTextCombatDamageAllAutos_v2"))
            layout:Toggle(S("floatingCombatTextCombatLogPeriodicSpells_v2"))
            layout:Heading("Healing")
            layout:Toggle(S("floatingCombatTextCombatHealing_v2"))
            layout:Toggle(S("floatingCombatTextCombatHealingAbsorbSelf_v2"))
            layout:Toggle(S("floatingCombatTextCombatHealingAbsorbTarget_v2"))
            layout:Heading("Pets")
            layout:Toggle(S("floatingCombatTextPetMeleeDamage_v2"))
            layout:Toggle(S("floatingCombatTextPetSpellDamage_v2"))
        end,
    },
    {
        id = "appearance", label = "Appearance", icon = "Appearance",
        subtitle = "How numbers fall, drift, start and fade.",
        build = function(layout)
            layout:Warning(WARNING)
            layout:Heading("Fall & Spread")
            layout:Slider(S("WorldTextGravity_v2"))
            layout:Slider(S("WorldTextStartPosRandomness_v2"))
            layout:Heading("Direction")
            layout:Slider(S("floatingCombatTextCombatDamageDirectionalScale_v2"))
            layout:Slider(S("floatingCombatTextCombatDamageDirectionalOffset_v2"))
            layout:Heading("Start Height")
            layout:Slider(S("WorldTextScreenY_v2"))
            layout:Slider(S("WorldTextCritScreenY_v2"))
            layout:Heading("Pop & Fade")
            layout:Slider(S("WorldTextRampDuration_v2"))
            layout:Slider(S("WorldTextRampPow_v2"))
            layout:Slider(S("WorldTextRampPowCrit_v2"))
            layout:Slider(S("WorldTextMinAlpha_v2"))
        end,
    },
}

local function Build()
    local frame = CreateFrame("Frame", "ForeverCombatStyleFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    frame:Hide()
    frame:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetToplevel(true)
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetResizable(true)
    -- ESC closes the window through the game's special-frames list.
    table.insert(UISpecialFrames, "ForeverCombatStyleFrame")
    W.Backdrop(frame, "window")
    frame.controls, frame.layouts, frame.pages = {}, {}, {}
    frame.navButtons, frame.utilityButtons = {}, {}

    -- Header: identity on the left, close on the right.
    local titleBar = CreateFrame("Frame", nil, frame)
    titleBar:SetPoint("TOPLEFT", 1, -1)
    titleBar:SetPoint("TOPRIGHT", -1, -1)
    titleBar:SetHeight(HEADER_HEIGHT)
    titleBar:EnableMouse(true)
    -- Same surface as the preview drawer; square bottom corners, rounded top to match the window.
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
    local version = W.Text(titleBar, "v" .. NS.VERSION .. (gameVersion and ("  ·  Client " .. gameVersion) or ""),
        64, -34, 360, C.muted)
    version:SetWordWrap(false)
    local close = W.CloseButton(frame, function() frame:Hide() end)
    close:SetPoint("TOPRIGHT", -16, -16)
    close:SetFrameLevel(titleBar:GetFrameLevel() + 5)
    W.Tooltip(close, "Close")

    -- Sidebar: pages, then quiet utilities pinned to the bottom.
    local sidebar = CreateFrame("Frame", nil, frame)
    sidebar:SetWidth(SIDEBAR_WIDTH)
    sidebar:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, 0)
    sidebar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 1, 1)
    W.Paint(sidebar, C.sidebar, 9, nil, "123")
    local sidebarLine = W.Line(sidebar, C.line)
    sidebarLine:SetWidth(1)
    sidebarLine:SetPoint("TOPRIGHT"); sidebarLine:SetPoint("BOTTOMRIGHT")
    local hint = W.Text(sidebar, "/fcs  ·  ESC to close", 0, 0, 176, C.dim)
    hint:ClearAllPoints()
    hint:SetPoint("BOTTOMLEFT", 22, 14)
    hint:SetWordWrap(false)
    local divider = W.Line(sidebar, C.line)
    divider:SetHeight(1)
    divider:SetPoint("BOTTOMLEFT", 16, 110); divider:SetPoint("BOTTOMRIGHT", -16, 110)

    -- Content: page title, subtitle, scrolling page, and the preview drawer.
    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 0, 0)
    content:SetPoint("BOTTOMRIGHT", -1, 1)
    frame.pageTitle = W.Text(content, "", 32, -24, 560, C.bright, "semibold", 22)
    frame.pageTitle:SetWordWrap(false)
    frame.subtitle = W.Text(content, "", 32, -52, 560, C.muted)
    frame.subtitle:SetWordWrap(false)
    frame.pageArea = CreateFrame("Frame", nil, content)
    frame.pageArea:SetClipsChildren(true)

    local previewBar = CreateFrame("Frame", nil, content)
    previewBar:SetHeight(BAR_HEIGHT)
    local barLine = W.Line(previewBar, C.line)
    barLine:SetHeight(1)
    barLine:SetPoint("TOPLEFT"); barLine:SetPoint("TOPRIGHT")
    local toggle = W.NavButton(previewBar, "Hide preview", "ChevronDown", 140, 30, function()
        NS.db.showPreview = not NS.db.showPreview
        frame.previewPane:UpdateLayout()
    end, "ghost")
    toggle:SetPoint("LEFT", 12, 0)
    W.Tooltip(toggle, "Show sample hits, crits and incoming damage inside this window.")
    local replay = W.Button(previewBar, "Replay", 100, 30, function()
        frame.previewPane:Poke()
    end, "flat")
    replay:SetPoint("RIGHT", -16, 0)
    W.Tooltip(replay, "Restart the sample numbers.")
    local note = W.Text(previewBar, "Approximate preview  ·  check on a real target", 0, 0, nil, C.dim)
    note:ClearAllPoints()
    note:SetPoint("RIGHT", replay, "LEFT", -16, 0)
    note:SetJustifyH("RIGHT")
    note:SetWordWrap(false)

    local pane = NS.CreatePreviewPane(content, previewBar)
    frame.previewPane = pane

    function pane:UpdateLayout()
        local open = NS.db.showPreview ~= false
        self:SetShown(open)
        replay:SetShown(open)
        note:SetShown(open)
        previewBar:ClearAllPoints()
        previewBar:SetPoint("BOTTOMLEFT", content, "BOTTOMLEFT", 0, open and STAGE_HEIGHT or 0)
        previewBar:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", 0, open and STAGE_HEIGHT or 0)
        W.Paint(previewBar, C.drawer, 9, nil, open and "1234" or "124")
        frame.pageArea:ClearAllPoints()
        frame.pageArea:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -PAGE_TOP)
        frame.pageArea:SetPoint("BOTTOMRIGHT", previewBar, "TOPRIGHT", 0, 0)
        W.RefreshText(toggle:GetFontString())
        toggle:SetText(open and "Hide preview" or "Show preview")
        W.SetIcon(toggle.optionsIcon, open and "ChevronDown" or "ChevronUp")
        toggle:SetWidth(toggle:GetFontString():GetStringWidth() + 50)
        for _, entry in pairs(frame.pages) do entry.view:UpdateScroll() end
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

    local reload = W.NavButton(sidebar, "Reload UI", "Transfer", width, UTILITY_HEIGHT,
        function() ReloadUI() end, "utility")
    reload:SetPoint("BOTTOMLEFT", 12, 38 + UTILITY_STEP)
    W.Tooltip(reload, "Reload the interface. Use it if a change does not show up in game.")
    local reset = W.NavButton(sidebar, "Reset Defaults", "Reset", width, UTILITY_HEIGHT, function()
        NS.Reset()
        frame:Refresh()
    end, "utility")
    reset:SetPoint("BOTTOMLEFT", 12, 38)
    W.Tooltip(reset, "Put every combat text setting back to the WoW Forever default.")

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
    W.Tooltip(grip, "Drag to resize. Double-click to restore the default size.")
    frame.resizeGrip = grip

    frame:SetScript("OnEvent", function(self)
        self:FitToScreen()
    end)
    frame:SetScript("OnHide", function(self)
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
        -- fonts have loaded: re-lay every label now and once more a moment later.
        W.RefreshAllText()
        pane:UpdateLayout()
        pane:LayoutColumns()
        self:Refresh()
        self:SelectPage(session.page)
        pane:Poke()
        if C_Timer and C_Timer.After then
            C_Timer.After(0.3, function()
                if self:IsShown() then
                    W.RefreshAllText()
                    pane:LayoutColumns()
                    self:Refresh()
                end
            end)
        end
    end)

    NS.OnChange(function() pane:Poke() end)
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

-- /fcs debug: report how a few labels are being drawn (for diagnosing blank text).
function NS.Debug()
    if not NS.frame then
        NS.Print("open the window once with /fcs, then run /fcs debug.")
        return
    end
    local wanted = { ["Number Style"] = true, ["Style"] = true, ["Size"] = true, ["Behaviour"] = true }
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
end
