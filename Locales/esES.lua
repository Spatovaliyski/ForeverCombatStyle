local _, NS = ...

local L = {}
NS.RegisterLocale("esES", L)

-- Window chrome
L["Client"] = "Cliente"
L["Close"] = "Cerrar"
L["/fcs  ·  ESC to close"] = "/fcs  ·  ESC para cerrar"
L["Drag to resize. Double-click to restore the default size."] = "Arrastra para cambiar el tamaño. Haz doble clic para restaurar el tamaño predeterminado."

-- Pages
L["General"] = "General"
L["Combat"] = "Combate"
L["Appearance"] = "Apariencia"
L["Number style, your own combat text, and how the addon behaves."] = "Estilo de los números, tu texto de combate y el comportamiento del addon."
L["Choose what appears: damage, healing, shields and pets."] = "Elige qué aparece: daño, sanación, escudos y mascotas."
L["How numbers fall, drift, start and fade."] = "Cómo caen, se desplazan, empiezan y se desvanecen los números."
L["This adjusts Blizzard's own floating combat text, so it works 100% with the default game. Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."] =
    "Esto ajusta el propio texto de combate flotante de Blizzard, por lo que funciona al 100 % con el juego base. Blizzard no expone fuentes, colores ni iconos para él, así que no se puede añadir más personalización."

-- Section headings
L["Number Style"] = "Estilo de números"
L["Your Combat Text"] = "Tu texto de combate"
L["Behaviour"] = "Comportamiento"
L["Damage"] = "Daño"
L["Healing"] = "Sanación"
L["Pets"] = "Mascotas"
L["Fall & Spread"] = "Caída y dispersión"
L["Direction"] = "Dirección"
L["Start Height"] = "Altura inicial"
L["Pop & Fade"] = "Aparición y desvanecimiento"
L["Language"] = "Idioma"

-- Settings: names
L["Style"] = "Estilo"
L["Size"] = "Tamaño"
L["Gravity"] = "Gravedad"
L["Spread"] = "Dispersión"
L["Hit height"] = "Altura de golpes"
L["Crit height"] = "Altura de críticos"
L["Directional movement"] = "Movimiento direccional"
L["Directional offset"] = "Desplazamiento direccional"
L["Float mode"] = "Modo de flotación"
L["Your scrolling text"] = "Tu texto desplazable"
L["Damage over targets"] = "Daño sobre objetivos"
L["All auto-attacks"] = "Todos los ataques automáticos"
L["Damage over time"] = "Daño con el tiempo"
L["Healing you do"] = "Sanación que realizas"
L["Shields on you"] = "Escudos sobre ti"
L["Shields on your target"] = "Escudos sobre tu objetivo"
L["Pet melee damage"] = "Daño cuerpo a cuerpo de la mascota"
L["Pet spell damage"] = "Daño de hechizo de la mascota"
L["Ramp duration"] = "Duración de la rampa"
L["Hit ramp strength"] = "Intensidad de rampa (golpes)"
L["Crit ramp strength"] = "Intensidad de rampa (críticos)"
L["Minimum opacity"] = "Opacidad mínima"

-- Settings: choices
L["Retail"] = "Retail"
L["Classic"] = "Classic"
L["Up"] = "Arriba"
L["Down"] = "Abajo"
L["Arc"] = "Arco"

-- Settings: descriptions
L["Classic or Retail look for floating damage numbers."] = "Aspecto Classic o Retail para los números de daño flotantes."
L["Overall size of damage numbers."] = "Tamaño general de los números de daño."
L["How strongly numbers fall back down after rising."] = "Con qué fuerza los números vuelven a caer tras subir."
L["How far from the spawn point numbers may start."] = "A qué distancia del punto de aparición pueden empezar los números."
L["Start offset for normal hits. Positive is higher."] = "Desplazamiento inicial de los golpes normales. Los valores positivos son más altos."
L["Start offset for critical hits. Positive is higher."] = "Desplazamiento inicial de los golpes críticos. Los valores positivos son más altos."
L["Pushes numbers sideways, away from you."] = "Empuja los números hacia los lados, lejos de ti."
L["How far from the target directional numbers start."] = "A qué distancia del objetivo empiezan los números direccionales."
L["Scroll direction of the text on your own character."] = "Dirección de desplazamiento del texto en tu propio personaje."
L["Show combat text on your own character."] = "Mostrar texto de combate en tu propio personaje."
L["Show damage numbers over enemies you hit."] = "Mostrar números de daño sobre los enemigos a los que golpeas."
L["Show every auto-attack number instead of hiding some."] = "Mostrar todos los números de ataques automáticos en lugar de ocultar algunos."
L["Show damage from periodic effects."] = "Mostrar el daño de los efectos periódicos."
L["Show the healing you do to your target."] = "Mostrar la sanación que realizas a tu objetivo."
L["Show shields added to yourself."] = "Mostrar los escudos que recibes."
L["Show shields added to your target."] = "Mostrar los escudos aplicados a tu objetivo."
L["Show your pet's melee damage."] = "Mostrar el daño cuerpo a cuerpo de tu mascota."
L["Show your pet's spell damage."] = "Mostrar el daño de hechizo de tu mascota."
L["How long the size animation lasts, in seconds."] = "Cuánto dura la animación de tamaño, en segundos."
L["How sharply hit numbers settle to their size."] = "Con qué brusquedad los números de golpes se asientan en su tamaño."
L["How sharply crits settle to their size."] = "Con qué brusquedad los críticos se asientan en su tamaño."
L["Opacity floor for numbers."] = "Opacidad mínima de los números."
L["Not available on this client."] = "No disponible en este cliente."
L["This setting is not available on this client."] = "Este ajuste no está disponible en este cliente."
L["Click to type an exact value."] = "Haz clic para escribir un valor exacto."

-- Number style
L["Smooth reveal"] = "Aparición suave"
L["Instant and direct"] = "Instantáneo y directo"
L["Numbers ease into view and settle into place gradually, for a softer, more fluid feel."] =
    "Los números aparecen poco a poco y se asientan gradualmente, para una sensación más suave y fluida."
L["Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."] =
    "Los números aparecen al instante y se mueven en línea recta, sin una aparición gradual, para una sensación más ágil."
L["Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose."] =
    "Ambos estilos se pueden ajustar por completo: Tamaño y todos los controles deslizantes de la página %s (incluida la rampa de Aparición y desvanecimiento) se aplican al estilo que elijas."

-- Behaviour
L["Re-apply at login"] = "Reaplicar al iniciar sesión"
L["Put your settings back at login if the client reset them."] = "Restaura tus ajustes al iniciar sesión si el cliente los reinició."

-- Language
L["Auto"] = "Auto"
L["Choose the language used by Forever Combat Style panels and messages."] = "Elige el idioma que usan los paneles y mensajes de Forever Combat Style."
L["This translation was generated with AI. If you find inconsistent terminology or incorrect wording, please report it through GitHub Issues. Thank you for your help! Translation contributors will be credited."] =
    "Esta traducción se ha generado con IA. Si encuentras términos incoherentes o una redacción incorrecta, comunícalo a través de GitHub Issues. ¡Gracias por tu ayuda! Se dará crédito a quienes contribuyan a la traducción."
L["Open Link"] = "Abrir enlace"
L["Press Ctrl+C to copy the URL."] = "Pulsa Ctrl+C para copiar la URL."

-- Sidebar utilities
L["Reload UI"] = "Recargar IU"
L["Reload the interface. Use it if a change does not show up in game."] = "Recarga la interfaz. Úsalo si un cambio no se muestra en el juego."
L["Reset Defaults"] = "Restablecer"
L["Put every combat text setting back to the WoW Forever default."] = "Restablece todos los ajustes del texto de combate a los valores predeterminados de WoW Forever."

-- Chat messages
L["all combat text CVars set back to the WoW Forever defaults."] = "todos los CVars del texto de combate se han restablecido a los valores predeterminados de WoW Forever."
L["/fcs opens the window. /fcs reset restores the WoW Forever defaults."] = "/fcs abre la ventana. /fcs reset restablece los valores predeterminados de WoW Forever."

-- Companion addon (PlateSCT / Forever Combat Style)
L["PlateSCT is hiding Blizzard's floating combat text, so these settings won't show in game."] = "PlateSCT está ocultando el texto de combate flotante de Blizzard, así que estos ajustes no se verán en el juego."
L["Show Blizzard numbers"] = "Mostrar números de Blizzard"
L["Turns off PlateSCT's \"Hide Blizzard floating combat text\". PlateSCT's own numbers keep working."] = "Desactiva «Ocultar el texto de combate flotante de Blizzard» en PlateSCT. Los números propios de PlateSCT siguen funcionando."
L["Alternative"] = "Alternativa"
L["Want full control instead of Blizzard's limits?"] = "¿Quieres control total en vez de los límites de Blizzard?"
L["PlateSCT replaces Blizzard's numbers with its own, so every part of them is yours to style."] = "PlateSCT sustituye los números de Blizzard por los suyos, así que cada detalle es tuyo para personalizar."
L["Numbers on nameplates or in screen areas"] = "Números en las placas de nombre o en áreas de la pantalla"
L["Any font, size and color"] = "Cualquier fuente, tamaño y color"
L["Spell icons and damage-school colors"] = "Iconos de hechizo y colores por escuela de daño"
L["Damage threshold and abbreviations"] = "Umbral de daño y abreviaturas"
L["Combine rapid hits into one number"] = "Combina golpes rápidos en un solo número"
L["Crit sounds and incoming damage"] = "Sonidos de crítico y daño recibido"
L["Open PlateSCT"] = "Abrir PlateSCT"
L["Get PlateSCT"] = "Obtener PlateSCT"
L["Installed. Opens its settings."] = "Instalado. Abre sus ajustes."
L["Free on CurseForge. Works on Forever, Midnight and Classic."] = "Gratis en CurseForge. Funciona en Forever, Midnight y Classic."
