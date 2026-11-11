local _, NS = ...

local L = {}
NS.RegisterLocale("zhTW", L)

-- Window chrome
L["Client"] = "用戶端"
L["Close"] = "關閉"
L["/fcs  ·  ESC to close"] = "/fcs  ·  按 ESC 關閉"
L["Drag to resize. Double-click to restore the default size."] = "拖曳以調整大小。按兩下恢復預設大小。"

-- Pages
L["General"] = "一般"
L["Combat"] = "戰鬥"
L["Appearance"] = "外觀"
L["Number style, your own combat text, and how the addon behaves."] = "數字樣式、你自己的戰鬥文字，以及插件的行為。"
L["Choose what appears: damage, healing, shields and pets."] = "選擇顯示的內容：傷害、治療、護盾和寵物。"
L["How numbers fall, drift, start and fade."] = "數字如何下落、漂移、起始和淡出。"
L["This adjusts Blizzard's own floating combat text, so it works 100% with the default game. Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."] =
    "這會調整暴雪內建的浮動戰鬥文字，因此可與原版遊戲 100% 相容。暴雪未開放該文字的字型、顏色或圖示設定，因此無法新增更多自訂選項。"

-- Section headings
L["Number Style"] = "數字樣式"
L["Your Combat Text"] = "你的戰鬥文字"
L["Behaviour"] = "行為"
L["Damage"] = "傷害"
L["Healing"] = "治療"
L["Pets"] = "寵物"
L["Fall & Spread"] = "下落與分散"
L["Direction"] = "方向"
L["Start Height"] = "起始高度"
L["Pop & Fade"] = "彈出與淡出"
L["Language"] = "語言"

-- Settings: names
L["Style"] = "樣式"
L["Size"] = "大小"
L["Gravity"] = "重力"
L["Spread"] = "分散度"
L["Hit height"] = "一般命中高度"
L["Crit height"] = "致命一擊高度"
L["Directional movement"] = "方向性移動"
L["Directional offset"] = "方向性偏移"
L["Float mode"] = "浮動模式"
L["Your scrolling text"] = "你的捲動文字"
L["Damage over targets"] = "目標上方傷害"
L["All auto-attacks"] = "所有自動攻擊"
L["Damage over time"] = "持續傷害"
L["Healing you do"] = "你造成的治療"
L["Shields on you"] = "你身上的護盾"
L["Shields on your target"] = "目標身上的護盾"
L["Pet melee damage"] = "寵物近戰傷害"
L["Pet spell damage"] = "寵物法術傷害"
L["Ramp duration"] = "漸變時長"
L["Hit ramp strength"] = "一般命中漸變強度"
L["Crit ramp strength"] = "致命一擊漸變強度"
L["Minimum opacity"] = "最低不透明度"

-- Settings: choices
L["Retail"] = "正式服樣式"
L["Classic"] = "經典樣式"
L["Up"] = "向上"
L["Down"] = "向下"
L["Arc"] = "弧線"

-- Settings: descriptions
L["Classic or Retail look for floating damage numbers."] = "浮動傷害數字的經典或正式服外觀。"
L["Overall size of damage numbers."] = "傷害數字的整體大小。"
L["How strongly numbers fall back down after rising."] = "數字上升後向下回落的力度。"
L["How far from the spawn point numbers may start."] = "數字可能從距離生成點多遠的位置開始。"
L["Start offset for normal hits. Positive is higher."] = "一般命中的起始偏移。正值更高。"
L["Start offset for critical hits. Positive is higher."] = "致命一擊的起始偏移。正值更高。"
L["Pushes numbers sideways, away from you."] = "將數字向側面推開，遠離你。"
L["How far from the target directional numbers start."] = "方向性數字從距離目標多遠的位置開始。"
L["Scroll direction of the text on your own character."] = "你自己角色上文字的捲動方向。"
L["Show combat text on your own character."] = "在你自己的角色上顯示戰鬥文字。"
L["Show damage numbers over enemies you hit."] = "在你擊中的敵人上方顯示傷害數字。"
L["Show every auto-attack number instead of hiding some."] = "顯示每次自動攻擊的數字，而不是隱藏其中一部分。"
L["Show damage from periodic effects."] = "顯示週期性效果造成的傷害。"
L["Show the healing you do to your target."] = "顯示你對目標造成的治療。"
L["Show shields added to yourself."] = "顯示施加在你自己身上的護盾。"
L["Show shields added to your target."] = "顯示施加在你目標身上的護盾。"
L["Show your pet's melee damage."] = "顯示你寵物的近戰傷害。"
L["Show your pet's spell damage."] = "顯示你寵物的法術傷害。"
L["How long the size animation lasts, in seconds."] = "大小動畫持續的時間，單位為秒。"
L["How sharply hit numbers settle to their size."] = "一般命中數字穩定到其大小的劇烈程度。"
L["How sharply crits settle to their size."] = "致命一擊數字穩定到其大小的劇烈程度。"
L["Opacity floor for numbers."] = "數字的最低不透明度。"
L["Not available on this client."] = "此用戶端不可用。"
L["This setting is not available on this client."] = "此設定在此用戶端上不可用。"
L["Click to type an exact value."] = "點擊輸入精確數值。"

-- Number style
L["Smooth reveal"] = "平滑顯現"
L["Instant and direct"] = "即時直接"
L["Numbers ease into view and settle into place gradually, for a softer, more fluid feel."] =
    "數字會漸漸顯現並逐步穩定到最終大小，觀感更柔和、更流暢。"
L["Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."] =
    "數字會立即出現並直線移動，沒有逐漸放大的過程，觀感更俐落。"
L["Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose."] =
    "兩種樣式都可以自由調整：大小以及%s頁面上的所有滑桿（包括彈出與淡出漸變）適用於你所選的樣式。"

-- Behaviour
L["Re-apply at login"] = "登入時重新套用"
L["Put your settings back at login if the client reset them."] = "若用戶端重置了設定，登入時會還原你的設定。"

-- Language
L["Auto"] = "自動"
L["Choose the language used by Forever Combat Style panels and messages."] = "選擇 Forever Combat Style 面板和訊息使用的語言。"
L["This translation was generated with AI. If you find inconsistent terminology or incorrect wording, please report it through GitHub Issues. Thank you for your help! Translation contributors will be credited."] =
    "此翻譯由 AI 產生。如果發現術語不一致或用詞不正確，請透過 GitHub Issues 回報。感謝你的協助！翻譯貢獻者將獲得署名致謝。"
L["Open Link"] = "開啟連結"
L["Press Ctrl+C to copy the URL."] = "按 Ctrl+C 複製網址。"

-- Sidebar utilities
L["Reload UI"] = "重新載入介面"
L["Reload the interface. Use it if a change does not show up in game."] = "重新載入介面。若某項變更沒有在遊戲中生效，請使用此項。"
L["Reset Defaults"] = "還原預設值"
L["Put every combat text setting back to the WoW Forever default."] = "將所有戰鬥文字設定還原為 WoW Forever 的預設值。"

-- Chat messages
L["all combat text CVars set back to the WoW Forever defaults."] = "所有戰鬥文字 CVar 已還原為 WoW Forever 預設值。"
L["/fcs opens the window. /fcs reset restores the WoW Forever defaults."] = "/fcs 開啟視窗。/fcs reset 還原 WoW Forever 預設值。"

-- Companion addon (PlateSCT / Forever Combat Style)
L["PlateSCT is hiding Blizzard's floating combat text, so these settings won't show in game."] = "PlateSCT 正在隱藏暴雪浮動戰鬥文字，因此這些設定不會在遊戲中顯示。"
L["Show Blizzard numbers"] = "顯示暴雪數字"
L["Turns off PlateSCT's \"Hide Blizzard floating combat text\". PlateSCT's own numbers keep working."] = "關閉 PlateSCT 的「隱藏暴雪浮動戰鬥文字」。PlateSCT 自己的數字仍會正常顯示。"
L["Alternative"] = "替代選擇"
L["Want full control instead of Blizzard's limits?"] = "想要完全掌控，而不受暴雪的限制？"
L["PlateSCT replaces Blizzard's numbers with its own, so every part of them is yours to style."] = "PlateSCT 用自己的數字取代暴雪的數字，每個細節都由你來自訂。"
L["Numbers on nameplates or in screen areas"] = "數字顯示在名條或螢幕區域"
L["Any font, size and color"] = "任意字型、大小和顏色"
L["Spell icons and damage-school colors"] = "法術圖示和傷害類型顏色"
L["Damage threshold and abbreviations"] = "傷害門檻和數字縮寫"
L["Combine rapid hits into one number"] = "將快速連擊合併為一個數字"
L["Crit sounds and incoming damage"] = "致命一擊音效和承受傷害"
L["Open PlateSCT"] = "開啟 PlateSCT"
L["Get PlateSCT"] = "取得 PlateSCT"
L["Installed. Opens its settings."] = "已安裝。點擊開啟其設定。"
L["Free on CurseForge. Works on Forever, Midnight and Classic."] = "CurseForge 免費下載。支援 Forever、Midnight 和經典版。"
