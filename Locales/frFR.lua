local _, NS = ...

local L = {}
NS.RegisterLocale("frFR", L)

-- Window chrome
L["Client"] = "Client"
L["Close"] = "Fermer"
L["/fcs  ·  ESC to close"] = "/fcs  ·  Échap pour fermer"
L["Drag to resize. Double-click to restore the default size."] = "Faites glisser pour redimensionner. Double-cliquez pour rétablir la taille par défaut."

-- Pages
L["General"] = "Général"
L["Combat"] = "Combat"
L["Appearance"] = "Apparence"
L["Number style, your own combat text, and how the addon behaves."] = "Style des nombres, votre texte de combat et comportement de l'addon."
L["Choose what appears: damage, healing, shields and pets."] = "Choisissez ce qui s'affiche : dégâts, soins, boucliers et familiers."
L["How numbers fall, drift, start and fade."] = "Comment les nombres tombent, dérivent, démarrent et s'estompent."
L["This adjusts Blizzard's own floating combat text, so it works 100% with the default game. Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."] =
    "Ceci ajuste le texte de combat flottant de Blizzard lui-même ; il fonctionne donc à 100 % avec le jeu de base. Blizzard n'expose ni polices, ni couleurs, ni icônes pour celui-ci : aucune personnalisation supplémentaire n'est possible."

-- Section headings
L["Number Style"] = "Style des nombres"
L["Your Combat Text"] = "Votre texte de combat"
L["Behaviour"] = "Comportement"
L["Damage"] = "Dégâts"
L["Healing"] = "Soins"
L["Pets"] = "Familiers"
L["Fall & Spread"] = "Chute et dispersion"
L["Direction"] = "Direction"
L["Start Height"] = "Hauteur de départ"
L["Pop & Fade"] = "Apparition et fondu"
L["Language"] = "Langue"

-- Settings: names
L["Style"] = "Style"
L["Size"] = "Taille"
L["Gravity"] = "Gravité"
L["Spread"] = "Dispersion"
L["Hit height"] = "Hauteur des coups"
L["Crit height"] = "Hauteur des critiques"
L["Directional movement"] = "Mouvement directionnel"
L["Directional offset"] = "Décalage directionnel"
L["Float mode"] = "Mode de flottement"
L["Your scrolling text"] = "Votre texte défilant"
L["Damage over targets"] = "Dégâts sur les cibles"
L["All auto-attacks"] = "Toutes les attaques automatiques"
L["Damage over time"] = "Dégâts sur la durée"
L["Healing you do"] = "Soins que vous prodiguez"
L["Shields on you"] = "Boucliers sur vous"
L["Shields on your target"] = "Boucliers sur votre cible"
L["Pet melee damage"] = "Dégâts de mêlée du familier"
L["Pet spell damage"] = "Dégâts de sort du familier"
L["Ramp duration"] = "Durée de la montée"
L["Hit ramp strength"] = "Intensité de la montée (coups)"
L["Crit ramp strength"] = "Intensité de la montée (critiques)"
L["Minimum opacity"] = "Opacité minimale"

-- Settings: choices
L["Retail"] = "Retail"
L["Classic"] = "Classic"
L["Up"] = "Haut"
L["Down"] = "Bas"
L["Arc"] = "Arc"

-- Settings: descriptions
L["Classic or Retail look for floating damage numbers."] = "Apparence Classic ou Retail des nombres de dégâts flottants."
L["Overall size of damage numbers."] = "Taille globale des nombres de dégâts."
L["How strongly numbers fall back down after rising."] = "Force avec laquelle les nombres retombent après être montés."
L["How far from the spawn point numbers may start."] = "Distance maximale entre le point d'apparition et le départ des nombres."
L["Start offset for normal hits. Positive is higher."] = "Décalage de départ des coups normaux. Une valeur positive place plus haut."
L["Start offset for critical hits. Positive is higher."] = "Décalage de départ des coups critiques. Une valeur positive place plus haut."
L["Pushes numbers sideways, away from you."] = "Pousse les nombres sur le côté, loin de vous."
L["How far from the target directional numbers start."] = "Distance de la cible à laquelle démarrent les nombres directionnels."
L["Scroll direction of the text on your own character."] = "Sens de défilement du texte sur votre propre personnage."
L["Show combat text on your own character."] = "Afficher le texte de combat sur votre propre personnage."
L["Show damage numbers over enemies you hit."] = "Afficher les nombres de dégâts au-dessus des ennemis que vous touchez."
L["Show every auto-attack number instead of hiding some."] = "Afficher chaque nombre d'attaque automatique au lieu d'en masquer certains."
L["Show damage from periodic effects."] = "Afficher les dégâts des effets périodiques."
L["Show the healing you do to your target."] = "Afficher les soins que vous prodiguez à votre cible."
L["Show shields added to yourself."] = "Afficher les boucliers que vous recevez."
L["Show shields added to your target."] = "Afficher les boucliers ajoutés à votre cible."
L["Show your pet's melee damage."] = "Afficher les dégâts de mêlée de votre familier."
L["Show your pet's spell damage."] = "Afficher les dégâts de sort de votre familier."
L["How long the size animation lasts, in seconds."] = "Durée de l'animation de taille, en secondes."
L["How sharply hit numbers settle to their size."] = "Rapidité avec laquelle les nombres de coups se stabilisent à leur taille."
L["How sharply crits settle to their size."] = "Rapidité avec laquelle les critiques se stabilisent à leur taille."
L["Opacity floor for numbers."] = "Opacité minimale des nombres."
L["Not available on this client."] = "Indisponible sur ce client."
L["This setting is not available on this client."] = "Ce réglage n'est pas disponible sur ce client."
L["Click to type an exact value."] = "Cliquez pour saisir une valeur exacte."

-- Number style
L["Smooth reveal"] = "Apparition en douceur"
L["Instant and direct"] = "Instantané et direct"
L["Numbers ease into view and settle into place gradually, for a softer, more fluid feel."] =
    "Les nombres apparaissent progressivement et se stabilisent peu à peu, pour un rendu plus doux et plus fluide."
L["Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."] =
    "Les nombres apparaissent immédiatement et se déplacent en ligne droite, sans montée progressive, pour un rendu plus nerveux."
L["Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose."] =
    "Les deux styles sont entièrement personnalisables : Taille et tous les curseurs de la page %s (y compris la rampe « Apparition et fondu ») s'appliquent au style que vous choisissez."

-- Behaviour
L["Re-apply at login"] = "Réappliquer à la connexion"
L["Put your settings back at login if the client reset them."] = "Rétablit vos réglages à la connexion si le client les a réinitialisés."

-- Language
L["Auto"] = "Auto"
L["Choose the language used by Forever Combat Style panels and messages."] = "Choisissez la langue utilisée par les fenêtres et les messages de Forever Combat Style."
L["This translation was generated with AI. If you find inconsistent terminology or incorrect wording, please report it through GitHub Issues. Thank you for your help! Translation contributors will be credited."] =
    "Cette traduction a été générée par IA. Si vous trouvez des termes incohérents ou des formulations incorrectes, veuillez les signaler via GitHub Issues. Merci pour votre aide ! Les contributeurs à la traduction seront crédités."
L["Open Link"] = "Ouvrir le lien"
L["Press Ctrl+C to copy the URL."] = "Appuyez sur Ctrl+C pour copier l'URL."

-- Sidebar utilities
L["Reload UI"] = "Recharger l'UI"
L["Reload the interface. Use it if a change does not show up in game."] = "Recharge l'interface. Utilisez-le si un changement n'apparaît pas en jeu."
L["Reset Defaults"] = "Réinitialiser"
L["Put every combat text setting back to the WoW Forever default."] = "Rétablit tous les réglages du texte de combat aux valeurs par défaut de WoW Forever."

-- Chat messages
L["all combat text CVars set back to the WoW Forever defaults."] = "tous les CVars du texte de combat ont été rétablis aux valeurs par défaut de WoW Forever."
L["/fcs opens the window. /fcs reset restores the WoW Forever defaults."] = "/fcs ouvre la fenêtre. /fcs reset rétablit les valeurs par défaut de WoW Forever."

-- Companion addon (PlateSCT / Forever Combat Style)
L["PlateSCT is hiding Blizzard's floating combat text, so these settings won't show in game."] = "PlateSCT masque le texte de combat flottant de Blizzard : ces réglages ne s'afficheront donc pas en jeu."
L["Show Blizzard numbers"] = "Afficher les nombres de Blizzard"
L["Turns off PlateSCT's \"Hide Blizzard floating combat text\". PlateSCT's own numbers keep working."] = "Désactive « Masquer le texte de combat flottant de Blizzard » dans PlateSCT. Les nombres de PlateSCT continuent de fonctionner."
L["Alternative"] = "Alternative"
L["Want full control instead of Blizzard's limits?"] = "Envie d'un contrôle total, sans les limites de Blizzard ?"
L["PlateSCT replaces Blizzard's numbers with its own, so every part of them is yours to style."] = "PlateSCT remplace les nombres de Blizzard par les siens : chaque détail est à vous de styliser."
L["Numbers on nameplates or in screen areas"] = "Nombres sur les barres de nom ou dans des zones de l'écran"
L["Any font, size and color"] = "Police, taille et couleur au choix"
L["Spell icons and damage-school colors"] = "Icônes de sort et couleurs par école de dégâts"
L["Damage threshold and abbreviations"] = "Seuil de dégâts et abréviations"
L["Combine rapid hits into one number"] = "Regroupe les coups rapides en un seul nombre"
L["Crit sounds and incoming damage"] = "Sons de critique et dégâts subis"
L["Open PlateSCT"] = "Ouvrir PlateSCT"
L["Get PlateSCT"] = "Obtenir PlateSCT"
L["Installed. Opens its settings."] = "Installé. Ouvre ses réglages."
L["Free on CurseForge. Works on Forever, Midnight and Classic."] = "Gratuit sur CurseForge. Fonctionne sur Forever, Midnight et Classic."
