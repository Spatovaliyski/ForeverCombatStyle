local _, NS = ...

local L = {}
NS.RegisterLocale("ptBR", L)

-- Window chrome
L["Client"] = "Cliente"
L["Close"] = "Fechar"
L["/fcs  ·  ESC to close"] = "/fcs  ·  ESC para fechar"
L["Drag to resize. Double-click to restore the default size."] = "Arraste para redimensionar. Clique duas vezes para restaurar o tamanho padrão."

-- Pages
L["General"] = "Geral"
L["Combat"] = "Combate"
L["Appearance"] = "Aparência"
L["Number style, your own combat text, and how the addon behaves."] = "Estilo dos números, seu texto de combate e o comportamento do addon."
L["Choose what appears: damage, healing, shields and pets."] = "Escolha o que aparece: dano, cura, escudos e ajudantes."
L["How numbers fall, drift, start and fade."] = "Como os números caem, se deslocam, começam e desaparecem."
L["This adjusts Blizzard's own floating combat text, so it works 100% with the default game. Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."] =
    "Isto ajusta o próprio texto de combate flutuante da Blizzard, por isso funciona 100% com o jogo padrão. A Blizzard não disponibiliza fontes, cores nem ícones para ele, portanto não é possível adicionar mais personalização."

-- Section headings
L["Number Style"] = "Estilo dos números"
L["Your Combat Text"] = "Seu texto de combate"
L["Behaviour"] = "Comportamento"
L["Damage"] = "Dano"
L["Healing"] = "Cura"
L["Pets"] = "Ajudantes"
L["Fall & Spread"] = "Queda e dispersão"
L["Direction"] = "Direção"
L["Start Height"] = "Altura inicial"
L["Pop & Fade"] = "Surgimento e desvanecimento"
L["Language"] = "Idioma"

-- Settings: names
L["Style"] = "Estilo"
L["Size"] = "Tamanho"
L["Gravity"] = "Gravidade"
L["Spread"] = "Dispersão"
L["Hit height"] = "Altura dos acertos"
L["Crit height"] = "Altura dos críticos"
L["Directional movement"] = "Movimento direcional"
L["Directional offset"] = "Deslocamento direcional"
L["Float mode"] = "Modo de flutuação"
L["Your scrolling text"] = "Seu texto rolante"
L["Damage over targets"] = "Dano sobre alvos"
L["All auto-attacks"] = "Todos os ataques automáticos"
L["Damage over time"] = "Dano ao longo do tempo"
L["Healing you do"] = "Cura que você faz"
L["Shields on you"] = "Escudos em você"
L["Shields on your target"] = "Escudos no seu alvo"
L["Pet melee damage"] = "Dano corpo a corpo do ajudante"
L["Pet spell damage"] = "Dano de magia do ajudante"
L["Ramp duration"] = "Duração da rampa"
L["Hit ramp strength"] = "Intensidade da rampa (acertos)"
L["Crit ramp strength"] = "Intensidade da rampa (críticos)"
L["Minimum opacity"] = "Opacidade mínima"

-- Settings: choices
L["Retail"] = "Retail"
L["Classic"] = "Classic"
L["Up"] = "Para cima"
L["Down"] = "Para baixo"
L["Arc"] = "Arco"

-- Settings: descriptions
L["Classic or Retail look for floating damage numbers."] = "Aparência Classic ou Retail para os números de dano flutuantes."
L["Overall size of damage numbers."] = "Tamanho geral dos números de dano."
L["How strongly numbers fall back down after rising."] = "Com que força os números voltam a cair depois de subir."
L["How far from the spawn point numbers may start."] = "A que distância do ponto de surgimento os números podem começar."
L["Start offset for normal hits. Positive is higher."] = "Deslocamento inicial dos acertos normais. Valores positivos ficam mais altos."
L["Start offset for critical hits. Positive is higher."] = "Deslocamento inicial dos acertos críticos. Valores positivos ficam mais altos."
L["Pushes numbers sideways, away from you."] = "Empurra os números para o lado, para longe de você."
L["How far from the target directional numbers start."] = "A que distância do alvo os números direcionais começam."
L["Scroll direction of the text on your own character."] = "Direção de rolagem do texto no seu próprio personagem."
L["Show combat text on your own character."] = "Mostrar texto de combate no seu próprio personagem."
L["Show damage numbers over enemies you hit."] = "Mostrar números de dano sobre os inimigos que você atinge."
L["Show every auto-attack number instead of hiding some."] = "Mostrar todos os números de ataques automáticos em vez de ocultar alguns."
L["Show damage from periodic effects."] = "Mostrar o dano de efeitos periódicos."
L["Show the healing you do to your target."] = "Mostrar a cura que você faz no seu alvo."
L["Show shields added to yourself."] = "Mostrar os escudos aplicados em você."
L["Show shields added to your target."] = "Mostrar os escudos aplicados ao seu alvo."
L["Show your pet's melee damage."] = "Mostrar o dano corpo a corpo do seu ajudante."
L["Show your pet's spell damage."] = "Mostrar o dano de magia do seu ajudante."
L["How long the size animation lasts, in seconds."] = "Quanto tempo dura a animação de tamanho, em segundos."
L["How sharply hit numbers settle to their size."] = "Com que intensidade os números de acertos se ajustam ao seu tamanho."
L["How sharply crits settle to their size."] = "Com que intensidade os críticos se ajustam ao seu tamanho."
L["Opacity floor for numbers. Not shown in the preview."] = "Opacidade mínima dos números. Não aparece na prévia."
L["Not available on this client."] = "Não disponível neste cliente."
L["This setting is not available on this client."] = "Esta configuração não está disponível neste cliente."
L["Click to type an exact value."] = "Clique para digitar um valor exato."

-- Number style
L["Smooth reveal"] = "Surgimento suave"
L["Instant and direct"] = "Instantâneo e direto"
L["Numbers ease into view and settle into place gradually, for a softer, more fluid feel."] =
    "Os números surgem aos poucos e se acomodam gradualmente, para uma sensação mais suave e fluida."
L["Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."] =
    "Os números aparecem na hora e se movem em linha reta, sem acúmulo gradual, para uma sensação mais ágil."
L["Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose. The preview below shows the result."] =
    "Os dois estilos são totalmente ajustáveis: Tamanho e todos os controles deslizantes da página %s (incluindo a rampa de Surgimento e desvanecimento) valem para o estilo que você escolher. A prévia abaixo mostra o resultado."

-- Behaviour
L["Re-apply at login"] = "Reaplicar ao entrar"
L["Put your settings back at login if the client reset them."] = "Restaura suas configurações ao entrar se o cliente as redefiniu."

-- Language
L["Auto"] = "Auto"
L["Choose the language used by Forever Combat Style panels and messages."] = "Escolha o idioma usado pelos painéis e mensagens do Forever Combat Style."
L["This translation was generated with AI. If you find inconsistent terminology or incorrect wording, please report it through GitHub Issues. Thank you for your help! Translation contributors will be credited."] =
    "Esta tradução foi gerada com IA. Se encontrar termos inconsistentes ou uma redação incorreta, informe pelo GitHub Issues. Agradecemos pela ajuda! Os colaboradores da tradução receberão os devidos créditos."
L["Open Link"] = "Abrir link"
L["Press Ctrl+C to copy the URL."] = "Pressione Ctrl+C para copiar a URL."

-- Sidebar utilities
L["Reload UI"] = "Recarregar IU"
L["Reload the interface. Use it if a change does not show up in game."] = "Recarrega a interface. Use se uma alteração não aparecer no jogo."
L["Reset Defaults"] = "Redefinir"
L["Put every combat text setting back to the WoW Forever default."] = "Restaura todas as configurações do texto de combate para o padrão do WoW Forever."

-- Preview
L["Hide preview"] = "Ocultar prévia"
L["Show preview"] = "Mostrar prévia"
L["Show sample hits, crits and incoming damage inside this window."] = "Mostra acertos, críticos e dano recebido de exemplo dentro desta janela."
L["Replay"] = "Repetir"
L["Restart the sample numbers."] = "Reinicia os números de exemplo."
L["Approximate preview  ·  check on a real target"] = "Prévia aproximada  ·  confira em um alvo real"
L["Hit"] = "Acerto"
L["Crit"] = "Crítico"
L["Heal"] = "Cura"
L["Taken"] = "Recebido"
L["Off"] = "Desligado"
L["Drag to change the preview height. Double-click to reset it."] =
    "Arraste para alterar a altura da prévia. Clique duas vezes para redefini-la."

-- Chat messages
L["all combat text CVars set back to the WoW Forever defaults."] = "todos os CVars do texto de combate foram restaurados para o padrão do WoW Forever."
L["/fcs opens the window. /fcs reset restores the WoW Forever defaults."] = "/fcs abre a janela. /fcs reset restaura os padrões do WoW Forever."
