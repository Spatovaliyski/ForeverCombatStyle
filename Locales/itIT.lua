local _, NS = ...

local L = {}
NS.RegisterLocale("itIT", L)

-- Window chrome
L["Client"] = "Client"
L["Close"] = "Chiudi"
L["/fcs  ·  ESC to close"] = "/fcs  ·  ESC per chiudere"
L["Drag to resize. Double-click to restore the default size."] = "Trascina per ridimensionare. Fai doppio clic per ripristinare la dimensione predefinita."

-- Pages
L["General"] = "Generale"
L["Combat"] = "Combattimento"
L["Appearance"] = "Aspetto"
L["Number style, your own combat text, and how the addon behaves."] = "Stile dei numeri, il tuo testo di combattimento e il comportamento dell'addon."
L["Choose what appears: damage, healing, shields and pets."] = "Scegli cosa mostrare: danni, cure, scudi e famigli."
L["How numbers fall, drift, start and fade."] = "Come i numeri cadono, si spostano, partono e svaniscono."
L["This adjusts Blizzard's own floating combat text, so it works 100% with the default game. Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."] =
    "Questo regola il testo di combattimento fluttuante di Blizzard stesso, quindi funziona al 100% con il gioco base. Blizzard non rende disponibili caratteri, colori o icone per esso, quindi non è possibile aggiungere altre personalizzazioni."

-- Section headings
L["Number Style"] = "Stile dei numeri"
L["Your Combat Text"] = "Il tuo testo di combattimento"
L["Behaviour"] = "Comportamento"
L["Damage"] = "Danni"
L["Healing"] = "Cure"
L["Pets"] = "Famigli"
L["Fall & Spread"] = "Caduta e dispersione"
L["Direction"] = "Direzione"
L["Start Height"] = "Altezza iniziale"
L["Pop & Fade"] = "Comparsa e dissolvenza"
L["Language"] = "Lingua"

-- Settings: names
L["Style"] = "Stile"
L["Size"] = "Dimensione"
L["Gravity"] = "Gravità"
L["Spread"] = "Dispersione"
L["Hit height"] = "Altezza dei colpi"
L["Crit height"] = "Altezza dei critici"
L["Directional movement"] = "Movimento direzionale"
L["Directional offset"] = "Scostamento direzionale"
L["Float mode"] = "Modalità di scorrimento"
L["Your scrolling text"] = "Il tuo testo scorrevole"
L["Damage over targets"] = "Danni sopra i bersagli"
L["All auto-attacks"] = "Tutti gli attacchi automatici"
L["Damage over time"] = "Danni nel tempo"
L["Healing you do"] = "Cure che effettui"
L["Shields on you"] = "Scudi su di te"
L["Shields on your target"] = "Scudi sul tuo bersaglio"
L["Pet melee damage"] = "Danni in mischia del famiglio"
L["Pet spell damage"] = "Danni da incantesimo del famiglio"
L["Ramp duration"] = "Durata della rampa"
L["Hit ramp strength"] = "Intensità della rampa (colpi)"
L["Crit ramp strength"] = "Intensità della rampa (critici)"
L["Minimum opacity"] = "Opacità minima"

-- Settings: choices
L["Retail"] = "Retail"
L["Classic"] = "Classic"
L["Up"] = "Su"
L["Down"] = "Giù"
L["Arc"] = "Arco"

-- Settings: descriptions
L["Classic or Retail look for floating damage numbers."] = "Aspetto Classic o Retail per i numeri di danno fluttuanti."
L["Overall size of damage numbers."] = "Dimensione complessiva dei numeri di danno."
L["How strongly numbers fall back down after rising."] = "Con quanta forza i numeri ricadono dopo essere saliti."
L["How far from the spawn point numbers may start."] = "Quanto lontano dal punto di comparsa possono partire i numeri."
L["Start offset for normal hits. Positive is higher."] = "Scostamento iniziale dei colpi normali. I valori positivi sono più in alto."
L["Start offset for critical hits. Positive is higher."] = "Scostamento iniziale dei colpi critici. I valori positivi sono più in alto."
L["Pushes numbers sideways, away from you."] = "Spinge i numeri di lato, lontano da te."
L["How far from the target directional numbers start."] = "A che distanza dal bersaglio partono i numeri direzionali."
L["Scroll direction of the text on your own character."] = "Direzione di scorrimento del testo sul tuo personaggio."
L["Show combat text on your own character."] = "Mostra il testo di combattimento sul tuo personaggio."
L["Show damage numbers over enemies you hit."] = "Mostra i numeri di danno sopra i nemici che colpisci."
L["Show every auto-attack number instead of hiding some."] = "Mostra ogni numero degli attacchi automatici invece di nasconderne alcuni."
L["Show damage from periodic effects."] = "Mostra i danni degli effetti periodici."
L["Show the healing you do to your target."] = "Mostra le cure che effettui sul tuo bersaglio."
L["Show shields added to yourself."] = "Mostra gli scudi applicati su di te."
L["Show shields added to your target."] = "Mostra gli scudi applicati al tuo bersaglio."
L["Show your pet's melee damage."] = "Mostra i danni in mischia del tuo famiglio."
L["Show your pet's spell damage."] = "Mostra i danni da incantesimo del tuo famiglio."
L["How long the size animation lasts, in seconds."] = "Durata dell'animazione della dimensione, in secondi."
L["How sharply hit numbers settle to their size."] = "Quanto bruscamente i numeri dei colpi si stabilizzano alla loro dimensione."
L["How sharply crits settle to their size."] = "Quanto bruscamente i critici si stabilizzano alla loro dimensione."
L["Opacity floor for numbers."] = "Soglia minima di opacità dei numeri."
L["Not available on this client."] = "Non disponibile su questo client."
L["This setting is not available on this client."] = "Questa impostazione non è disponibile su questo client."
L["Click to type an exact value."] = "Fai clic per inserire un valore esatto."

-- Number style
L["Smooth reveal"] = "Comparsa graduale"
L["Instant and direct"] = "Immediato e diretto"
L["Numbers ease into view and settle into place gradually, for a softer, more fluid feel."] =
    "I numeri compaiono in modo graduale e si assestano lentamente, per una resa più morbida e fluida."
L["Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."] =
    "I numeri compaiono subito e si muovono in linea retta, senza una crescita graduale, per una resa più rapida."
L["Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose."] =
    "Entrambi gli stili sono completamente regolabili: Dimensione e tutti i cursori della pagina %s (compresa la rampa Comparsa e dissolvenza) valgono per lo stile che scegli."

-- Behaviour
L["Re-apply at login"] = "Riapplica all'accesso"
L["Put your settings back at login if the client reset them."] = "Ripristina le tue impostazioni all'accesso se il client le ha reimpostate."

-- Language
L["Auto"] = "Auto"
L["Choose the language used by Forever Combat Style panels and messages."] = "Scegli la lingua usata dai pannelli e dai messaggi di Forever Combat Style."
L["This translation was generated with AI. If you find inconsistent terminology or incorrect wording, please report it through GitHub Issues. Thank you for your help! Translation contributors will be credited."] =
    "Questa traduzione è stata generata con l'IA. Se trovi termini incoerenti o formulazioni errate, segnalali tramite GitHub Issues. Grazie per l'aiuto! I collaboratori alla traduzione saranno citati nei ringraziamenti."
L["Open Link"] = "Apri link"
L["Press Ctrl+C to copy the URL."] = "Premi Ctrl+C per copiare l'URL."

-- Sidebar utilities
L["Reload UI"] = "Ricarica UI"
L["Reload the interface. Use it if a change does not show up in game."] = "Ricarica l'interfaccia. Usalo se una modifica non compare in gioco."
L["Reset Defaults"] = "Ripristina"
L["Put every combat text setting back to the WoW Forever default."] = "Riporta tutte le impostazioni del testo di combattimento ai valori predefiniti di WoW Forever."

-- Chat messages
L["all combat text CVars set back to the WoW Forever defaults."] = "tutti i CVar del testo di combattimento sono stati riportati ai valori predefiniti di WoW Forever."
L["/fcs opens the window. /fcs reset restores the WoW Forever defaults."] = "/fcs apre la finestra. /fcs reset ripristina i valori predefiniti di WoW Forever."
