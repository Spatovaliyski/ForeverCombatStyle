local _, NS = ...

local L = {}
NS.RegisterLocale("ruRU", L)

-- Window chrome
L["Client"] = "Клиент"
L["Close"] = "Закрыть"
L["/fcs  ·  ESC to close"] = "/fcs  ·  ESC — закрыть"
L["Drag to resize. Double-click to restore the default size."] = "Перетащите, чтобы изменить размер. Двойной щелчок возвращает размер по умолчанию."

-- Pages
L["General"] = "Общие"
L["Combat"] = "Бой"
L["Appearance"] = "Внешний вид"
L["Number style, your own combat text, and how the addon behaves."] = "Стиль чисел, ваш текст боя и поведение аддона."
L["Choose what appears: damage, healing, shields and pets."] = "Выберите, что показывать: урон, исцеление, щиты и питомцев."
L["How numbers fall, drift, start and fade."] = "Как числа падают, смещаются, появляются и затухают."
L["This adjusts Blizzard's own floating combat text, so it works 100% with the default game. Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."] =
    "Здесь настраивается встроенный всплывающий текст боя Blizzard, поэтому он на 100 % работает с обычной игрой. Blizzard не предоставляет для него шрифты, цвета и значки, поэтому дополнительная настройка невозможна."

-- Section headings
L["Number Style"] = "Стиль чисел"
L["Your Combat Text"] = "Ваш текст боя"
L["Behaviour"] = "Поведение"
L["Damage"] = "Урон"
L["Healing"] = "Исцеление"
L["Pets"] = "Питомцы"
L["Fall & Spread"] = "Падение и разброс"
L["Direction"] = "Направление"
L["Start Height"] = "Начальная высота"
L["Pop & Fade"] = "Появление и затухание"
L["Language"] = "Язык"

-- Settings: names
L["Style"] = "Стиль"
L["Size"] = "Размер"
L["Gravity"] = "Гравитация"
L["Spread"] = "Разброс"
L["Hit height"] = "Высота попаданий"
L["Crit height"] = "Высота критических попаданий"
L["Directional movement"] = "Направленное движение"
L["Directional offset"] = "Направленное смещение"
L["Float mode"] = "Режим всплытия"
L["Your scrolling text"] = "Ваш всплывающий текст"
L["Damage over targets"] = "Урон над целями"
L["All auto-attacks"] = "Все автоатаки"
L["Damage over time"] = "Периодический урон"
L["Healing you do"] = "Ваше исцеление"
L["Shields on you"] = "Щиты на вас"
L["Shields on your target"] = "Щиты на вашей цели"
L["Pet melee damage"] = "Урон питомца в ближнем бою"
L["Pet spell damage"] = "Урон заклинаний питомца"
L["Ramp duration"] = "Длительность нарастания"
L["Hit ramp strength"] = "Сила нарастания (попадания)"
L["Crit ramp strength"] = "Сила нарастания (критические)"
L["Minimum opacity"] = "Минимальная непрозрачность"

-- Settings: choices
L["Retail"] = "Retail"
L["Classic"] = "Classic"
L["Up"] = "Вверх"
L["Down"] = "Вниз"
L["Arc"] = "Дуга"

-- Settings: descriptions
L["Classic or Retail look for floating damage numbers."] = "Вид всплывающих чисел урона: Classic или Retail."
L["Overall size of damage numbers."] = "Общий размер чисел урона."
L["How strongly numbers fall back down after rising."] = "Насколько сильно числа падают обратно после подъёма."
L["How far from the spawn point numbers may start."] = "Насколько далеко от точки появления могут начинаться числа."
L["Start offset for normal hits. Positive is higher."] = "Начальное смещение обычных попаданий. Положительное значение — выше."
L["Start offset for critical hits. Positive is higher."] = "Начальное смещение критических попаданий. Положительное значение — выше."
L["Pushes numbers sideways, away from you."] = "Сдвигает числа в сторону, от вас."
L["How far from the target directional numbers start."] = "Насколько далеко от цели начинаются направленные числа."
L["Scroll direction of the text on your own character."] = "Направление прокрутки текста над вашим персонажем."
L["Show combat text on your own character."] = "Показывать текст боя над вашим персонажем."
L["Show damage numbers over enemies you hit."] = "Показывать числа урона над врагами, которых вы поражаете."
L["Show every auto-attack number instead of hiding some."] = "Показывать числа всех автоатак, а не скрывать часть из них."
L["Show damage from periodic effects."] = "Показывать урон от периодических эффектов."
L["Show the healing you do to your target."] = "Показывать исцеление, которое вы оказываете своей цели."
L["Show shields added to yourself."] = "Показывать щиты, наложенные на вас."
L["Show shields added to your target."] = "Показывать щиты, наложенные на вашу цель."
L["Show your pet's melee damage."] = "Показывать урон вашего питомца в ближнем бою."
L["Show your pet's spell damage."] = "Показывать урон заклинаний вашего питомца."
L["How long the size animation lasts, in seconds."] = "Длительность анимации размера в секундах."
L["How sharply hit numbers settle to their size."] = "Насколько резко числа попаданий приходят к своему размеру."
L["How sharply crits settle to their size."] = "Насколько резко числа критов приходят к своему размеру."
L["Opacity floor for numbers. Not shown in the preview."] = "Нижний предел непрозрачности чисел. В предпросмотре не отображается."
L["Not available on this client."] = "Недоступно в этом клиенте."
L["This setting is not available on this client."] = "Эта настройка недоступна в этом клиенте."
L["Click to type an exact value."] = "Нажмите, чтобы ввести точное значение."

-- Number style
L["Smooth reveal"] = "Плавное появление"
L["Instant and direct"] = "Мгновенно и напрямую"
L["Numbers ease into view and settle into place gradually, for a softer, more fluid feel."] =
    "Числа плавно проявляются и постепенно принимают нужный размер, для более мягкого и плавного ощущения."
L["Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."] =
    "Числа появляются мгновенно и движутся прямо, без постепенного нарастания, для более резкого и быстрого ощущения."
L["Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose. The preview below shows the result."] =
    "Оба стиля полностью настраиваются: параметр «Размер» и все ползунки на странице «%s» (включая кривую «Появление и затухание») действуют для выбранного стиля. Предпросмотр ниже показывает результат."

-- Behaviour
L["Re-apply at login"] = "Применять заново при входе"
L["Put your settings back at login if the client reset them."] = "Возвращает ваши настройки при входе, если клиент их сбросил."

-- Language
L["Auto"] = "Авто"
L["Choose the language used by Forever Combat Style panels and messages."] = "Выберите язык окон и сообщений Forever Combat Style."
L["This translation was generated with AI. If you find inconsistent terminology or incorrect wording, please report it through GitHub Issues. Thank you for your help! Translation contributors will be credited."] =
    "Этот перевод создан с помощью ИИ. Если вы заметите несогласованные термины или некорректные формулировки, сообщите об этом через GitHub Issues. Спасибо за помощь! Участники перевода будут указаны в благодарностях."
L["Open Link"] = "Открыть ссылку"
L["Press Ctrl+C to copy the URL."] = "Нажмите Ctrl+C, чтобы скопировать URL."

-- Sidebar utilities
L["Reload UI"] = "Перезагрузить UI"
L["Reload the interface. Use it if a change does not show up in game."] = "Перезагружает интерфейс. Используйте, если изменение не отображается в игре."
L["Reset Defaults"] = "Сбросить"
L["Put every combat text setting back to the WoW Forever default."] = "Возвращает все настройки текста боя к значениям WoW Forever по умолчанию."

-- Preview
L["Hide preview"] = "Скрыть предпросмотр"
L["Show preview"] = "Показать предпросмотр"
L["Show sample hits, crits and incoming damage inside this window."] = "Показывает в этом окне примеры попаданий, критов и входящего урона."
L["Replay"] = "Повторить"
L["Restart the sample numbers."] = "Перезапускает примеры чисел."
L["Approximate preview  ·  check on a real target"] = "Приблизительный предпросмотр  ·  проверьте на настоящей цели"
L["Hit"] = "Попадание"
L["Crit"] = "Критическое"
L["Heal"] = "Исцеление"
L["Taken"] = "Получено"
L["Off"] = "Выкл."
L["Drag to change the preview height. Double-click to reset it."] =
    "Перетащите, чтобы изменить высоту предпросмотра. Двойной щелчок сбрасывает её."

-- Chat messages
L["all combat text CVars set back to the WoW Forever defaults."] = "все CVar текста боя возвращены к значениям WoW Forever по умолчанию."
L["/fcs opens the window. /fcs reset restores the WoW Forever defaults."] = "/fcs открывает окно. /fcs reset восстанавливает значения WoW Forever по умолчанию."
