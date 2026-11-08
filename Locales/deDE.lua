local _, NS = ...

local L = {}
NS.RegisterLocale("deDE", L)

-- Window chrome
L["Client"] = "Client"
L["Close"] = "Schließen"
L["/fcs  ·  ESC to close"] = "/fcs  ·  ESC zum Schließen"
L["Drag to resize. Double-click to restore the default size."] = "Ziehen, um die Größe zu ändern. Doppelklick stellt die Standardgröße wieder her."

-- Pages
L["General"] = "Allgemein"
L["Combat"] = "Kampf"
L["Appearance"] = "Aussehen"
L["Number style, your own combat text, and how the addon behaves."] = "Zahlenstil, dein eigener Kampftext und das Verhalten des Addons."
L["Choose what appears: damage, healing, shields and pets."] = "Wähle, was angezeigt wird: Schaden, Heilung, Schilde und Begleiter."
L["How numbers fall, drift, start and fade."] = "Wie Zahlen fallen, driften, starten und verblassen."
L["This adjusts Blizzard's own floating combat text, so it works 100% with the default game. Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."] =
    "Dies passt den schwebenden Kampftext von Blizzard selbst an und funktioniert daher zu 100 % mit dem normalen Spiel. Blizzard stellt dafür weder Schriftarten noch Farben oder Symbole bereit, daher sind keine weiteren Anpassungen möglich."

-- Section headings
L["Number Style"] = "Zahlenstil"
L["Your Combat Text"] = "Dein Kampftext"
L["Behaviour"] = "Verhalten"
L["Damage"] = "Schaden"
L["Healing"] = "Heilung"
L["Pets"] = "Begleiter"
L["Fall & Spread"] = "Fall und Streuung"
L["Direction"] = "Richtung"
L["Start Height"] = "Starthöhe"
L["Pop & Fade"] = "Aufpoppen und Ausblenden"
L["Language"] = "Sprache"

-- Settings: names
L["Style"] = "Stil"
L["Size"] = "Größe"
L["Gravity"] = "Schwerkraft"
L["Spread"] = "Streuung"
L["Hit height"] = "Trefferhöhe"
L["Crit height"] = "Höhe kritischer Treffer"
L["Directional movement"] = "Richtungsbewegung"
L["Directional offset"] = "Richtungsversatz"
L["Float mode"] = "Schwebemodus"
L["Your scrolling text"] = "Dein Lauftext"
L["Damage over targets"] = "Schaden über Zielen"
L["All auto-attacks"] = "Alle Automatikangriffe"
L["Damage over time"] = "Schaden über Zeit"
L["Healing you do"] = "Von dir gewirkte Heilung"
L["Shields on you"] = "Schilde auf dir"
L["Shields on your target"] = "Schilde auf deinem Ziel"
L["Pet melee damage"] = "Nahkampfschaden des Begleiters"
L["Pet spell damage"] = "Zauberschaden des Begleiters"
L["Ramp duration"] = "Anstiegsdauer"
L["Hit ramp strength"] = "Anstiegsstärke (Treffer)"
L["Crit ramp strength"] = "Anstiegsstärke (kritisch)"
L["Minimum opacity"] = "Minimale Deckkraft"

-- Settings: choices
L["Retail"] = "Retail"
L["Classic"] = "Classic"
L["Up"] = "Hoch"
L["Down"] = "Runter"
L["Arc"] = "Bogen"

-- Settings: descriptions
L["Classic or Retail look for floating damage numbers."] = "Classic- oder Retail-Optik für schwebende Schadenszahlen."
L["Overall size of damage numbers."] = "Gesamtgröße der Schadenszahlen."
L["How strongly numbers fall back down after rising."] = "Wie stark die Zahlen nach dem Aufsteigen wieder herabfallen."
L["How far from the spawn point numbers may start."] = "Wie weit vom Entstehungspunkt entfernt Zahlen starten dürfen."
L["Start offset for normal hits. Positive is higher."] = "Startversatz für normale Treffer. Positive Werte liegen höher."
L["Start offset for critical hits. Positive is higher."] = "Startversatz für kritische Treffer. Positive Werte liegen höher."
L["Pushes numbers sideways, away from you."] = "Schiebt Zahlen seitlich von dir weg."
L["How far from the target directional numbers start."] = "Wie weit vom Ziel entfernt gerichtete Zahlen starten."
L["Scroll direction of the text on your own character."] = "Scrollrichtung des Textes an deinem eigenen Charakter."
L["Show combat text on your own character."] = "Kampftext an deinem eigenen Charakter anzeigen."
L["Show damage numbers over enemies you hit."] = "Schadenszahlen über Gegnern anzeigen, die du triffst."
L["Show every auto-attack number instead of hiding some."] = "Jede Zahl von Automatikangriffen anzeigen, statt einige auszublenden."
L["Show damage from periodic effects."] = "Schaden durch periodische Effekte anzeigen."
L["Show the healing you do to your target."] = "Die Heilung anzeigen, die du deinem Ziel gewährst."
L["Show shields added to yourself."] = "Schilde anzeigen, die du auf dich selbst erhältst."
L["Show shields added to your target."] = "Schilde anzeigen, die deinem Ziel hinzugefügt werden."
L["Show your pet's melee damage."] = "Den Nahkampfschaden deines Begleiters anzeigen."
L["Show your pet's spell damage."] = "Den Zauberschaden deines Begleiters anzeigen."
L["How long the size animation lasts, in seconds."] = "Wie lange die Größenanimation dauert, in Sekunden."
L["How sharply hit numbers settle to their size."] = "Wie abrupt sich Trefferzahlen auf ihre Größe einpendeln."
L["How sharply crits settle to their size."] = "Wie abrupt sich kritische Treffer auf ihre Größe einpendeln."
L["Opacity floor for numbers."] = "Untergrenze der Deckkraft für Zahlen."
L["Not available on this client."] = "Auf diesem Client nicht verfügbar."
L["This setting is not available on this client."] = "Diese Einstellung ist auf diesem Client nicht verfügbar."
L["Click to type an exact value."] = "Klicken, um einen genauen Wert einzugeben."

-- Number style
L["Smooth reveal"] = "Sanftes Einblenden"
L["Instant and direct"] = "Sofort und direkt"
L["Numbers ease into view and settle into place gradually, for a softer, more fluid feel."] =
    "Zahlen blenden sanft ein und pendeln sich allmählich auf ihre Größe ein – für ein weicheres, flüssigeres Gefühl."
L["Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."] =
    "Zahlen erscheinen sofort und bewegen sich geradlinig, ohne allmählichen Aufbau – für ein direkteres Gefühl."
L["Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose."] =
    "Beide Stile sind vollständig anpassbar: Größe und alle Regler auf der Seite %s (einschließlich der Rampe Aufpoppen und Ausblenden) gelten für den Stil, den du wählst."

-- Behaviour
L["Re-apply at login"] = "Beim Login erneut anwenden"
L["Put your settings back at login if the client reset them."] = "Stellt deine Einstellungen beim Login wieder her, falls der Client sie zurückgesetzt hat."
L["See through while adjusting"] = "Durchsichtig beim Anpassen"
L["Fade this window while you change a setting, so you can watch the real numbers on a target."] = "Blendet dieses Fenster beim Ändern einer Einstellung aus, damit die echten Zahlen an einem Ziel zu sehen sind."
L["On"] = "An"
L["Off"] = "Aus"

-- Language
L["Auto"] = "Auto"
L["Choose the language used by Forever Combat Style panels and messages."] = "Wähle die Sprache für die Fenster und Meldungen von Forever Combat Style."
L["This translation was generated with AI. If you find inconsistent terminology or incorrect wording, please report it through GitHub Issues. Thank you for your help! Translation contributors will be credited."] =
    "Diese Übersetzung wurde mit KI erstellt. Wenn dir uneinheitliche Begriffe oder falsche Formulierungen auffallen, melde sie bitte über GitHub Issues. Vielen Dank für deine Hilfe! Mitwirkende an der Übersetzung werden namentlich erwähnt."
L["Open Link"] = "Link öffnen"
L["Press Ctrl+C to copy the URL."] = "Drücke Strg+C, um die URL zu kopieren."

-- Sidebar utilities
L["Reload UI"] = "UI neu laden"
L["Reload the interface. Use it if a change does not show up in game."] = "Lädt die Benutzeroberfläche neu. Nutze es, wenn eine Änderung im Spiel nicht erscheint."
L["Reset Defaults"] = "Standard zurücksetzen"
L["Put every combat text setting back to the WoW Forever default."] = "Setzt alle Kampftext-Einstellungen auf die Standardwerte von WoW Forever zurück."

-- Chat messages
L["all combat text CVars set back to the WoW Forever defaults."] = "Alle Kampftext-CVars wurden auf die Standardwerte von WoW Forever zurückgesetzt."
L["/fcs opens the window. /fcs reset restores the WoW Forever defaults."] = "/fcs öffnet das Fenster. /fcs reset stellt die Standardwerte von WoW Forever wieder her."
