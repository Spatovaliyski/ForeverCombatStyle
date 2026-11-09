local _, NS = ...

local L = {}
NS.RegisterLocale("enUS", L)

-- Window chrome
L["Client"] = "Client"
L["Close"] = "Close"
L["/fcs  ·  ESC to close"] = "/fcs  ·  ESC to close"
L["Drag to resize. Double-click to restore the default size."] = "Drag to resize. Double-click to restore the default size."

-- Pages
L["General"] = "General"
L["Combat"] = "Combat"
L["Appearance"] = "Appearance"
L["Number style, your own combat text, and how the addon behaves."] = "Number style, your own combat text, and how the addon behaves."
L["Choose what appears: damage, healing, shields and pets."] = "Choose what appears: damage, healing, shields and pets."
L["How numbers fall, drift, start and fade."] = "How numbers fall, drift, start and fade."
L["This adjusts Blizzard's own floating combat text, so it works 100% with the default game. Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."] =
    "This adjusts Blizzard's own floating combat text, so it works 100% with the default game. Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."

-- Section headings
L["Number Style"] = "Number Style"
L["Your Combat Text"] = "Your Combat Text"
L["Behaviour"] = "Behaviour"
L["Damage"] = "Damage"
L["Healing"] = "Healing"
L["Pets"] = "Pets"
L["Fall & Spread"] = "Fall & Spread"
L["Direction"] = "Direction"
L["Start Height"] = "Start Height"
L["Pop & Fade"] = "Pop & Fade"
L["Language"] = "Language"

-- Settings: names
L["Style"] = "Style"
L["Size"] = "Size"
L["Gravity"] = "Gravity"
L["Spread"] = "Spread"
L["Hit height"] = "Hit height"
L["Crit height"] = "Crit height"
L["Directional movement"] = "Directional movement"
L["Directional offset"] = "Directional offset"
L["Float mode"] = "Float mode"
L["Your scrolling text"] = "Your scrolling text"
L["Damage over targets"] = "Damage over targets"
L["All auto-attacks"] = "All auto-attacks"
L["Damage over time"] = "Damage over time"
L["Healing you do"] = "Healing you do"
L["Shields on you"] = "Shields on you"
L["Shields on your target"] = "Shields on your target"
L["Pet melee damage"] = "Pet melee damage"
L["Pet spell damage"] = "Pet spell damage"
L["Ramp duration"] = "Ramp duration"
L["Hit ramp strength"] = "Hit ramp strength"
L["Crit ramp strength"] = "Crit ramp strength"
L["Minimum opacity"] = "Minimum opacity"

-- Settings: choices
L["Retail"] = "Retail"
L["Classic"] = "Classic"
L["Up"] = "Up"
L["Down"] = "Down"
L["Arc"] = "Arc"

-- Settings: descriptions
L["Classic or Retail look for floating damage numbers."] = "Classic or Retail look for floating damage numbers."
L["Overall size of damage numbers."] = "Overall size of damage numbers."
L["How strongly numbers fall back down after rising."] = "How strongly numbers fall back down after rising."
L["How far from the spawn point numbers may start."] = "How far from the spawn point numbers may start."
L["Start offset for normal hits. Positive is higher."] = "Start offset for normal hits. Positive is higher."
L["Start offset for critical hits. Positive is higher."] = "Start offset for critical hits. Positive is higher."
L["Pushes numbers sideways, away from you."] = "Pushes numbers sideways, away from you."
L["How far from the target directional numbers start."] = "How far from the target directional numbers start."
L["Scroll direction of the text on your own character."] = "Scroll direction of the text on your own character."
L["Show combat text on your own character."] = "Show combat text on your own character."
L["Show damage numbers over enemies you hit."] = "Show damage numbers over enemies you hit."
L["Show every auto-attack number instead of hiding some."] = "Show every auto-attack number instead of hiding some."
L["Show damage from periodic effects."] = "Show damage from periodic effects."
L["Show the healing you do to your target."] = "Show the healing you do to your target."
L["Show shields added to yourself."] = "Show shields added to yourself."
L["Show shields added to your target."] = "Show shields added to your target."
L["Show your pet's melee damage."] = "Show your pet's melee damage."
L["Show your pet's spell damage."] = "Show your pet's spell damage."
L["How long the size animation lasts, in seconds."] = "How long the size animation lasts, in seconds."
L["How sharply hit numbers settle to their size."] = "How sharply hit numbers settle to their size."
L["How sharply crits settle to their size."] = "How sharply crits settle to their size."
L["Opacity floor for numbers."] = "Opacity floor for numbers."
L["Not available on this client."] = "Not available on this client."
L["This setting is not available on this client."] = "This setting is not available on this client."
L["Click to type an exact value."] = "Click to type an exact value."

-- Number style
L["Smooth reveal"] = "Smooth reveal"
L["Instant and direct"] = "Instant and direct"
L["Numbers ease into view and settle into place gradually, for a softer, more fluid feel."] =
    "Numbers ease into view and settle into place gradually, for a softer, more fluid feel."
L["Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."] =
    "Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."
L["Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose."] =
    "Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose."

-- Behaviour
L["Re-apply at login"] = "Re-apply at login"
L["Put your settings back at login if the client reset them."] = "Put your settings back at login if the client reset them."

-- Language
L["Auto"] = "Auto"
L["Choose the language used by Forever Combat Style panels and messages."] = "Choose the language used by Forever Combat Style panels and messages."
L["This translation was generated with AI. If you find inconsistent terminology or incorrect wording, please report it through GitHub Issues. Thank you for your help! Translation contributors will be credited."] =
    "This translation was generated with AI. If you find inconsistent terminology or incorrect wording, please report it through GitHub Issues. Thank you for your help! Translation contributors will be credited."
L["Open Link"] = "Open Link"
L["Press Ctrl+C to copy the URL."] = "Press Ctrl+C to copy the URL."

-- Sidebar utilities
L["Reload UI"] = "Reload UI"
L["Reload the interface. Use it if a change does not show up in game."] = "Reload the interface. Use it if a change does not show up in game."
L["Reset Defaults"] = "Reset Defaults"
L["Put every combat text setting back to the WoW Forever default."] = "Put every combat text setting back to the WoW Forever default."

-- Chat messages
L["all combat text CVars set back to the WoW Forever defaults."] = "all combat text CVars set back to the WoW Forever defaults."
L["/fcs opens the window. /fcs reset restores the WoW Forever defaults."] = "/fcs opens the window. /fcs reset restores the WoW Forever defaults."
