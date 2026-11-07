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
L["Opacity floor for numbers. Not shown in the preview."] = "數字的最低不透明度。預覽中不會顯示。"
L["Not available on this client."] = "此用戶端不可用。"
L["This setting is not available on this client."] = "此設定在此用戶端上不可用。"
L["Click to type an exact value."] = "點擊輸入精確數值。"

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

-- Preview
L["Hide preview"] = "隱藏預覽"
L["Show preview"] = "顯示預覽"
L["Show sample hits, crits and incoming damage inside this window."] = "在此視窗中顯示範例命中、致命一擊和受到的傷害。"
L["Replay"] = "重播"
L["Restart the sample numbers."] = "重新開始範例數字。"
L["Approximate preview  ·  check on a real target"] = "預覽僅供參考  ·  請在真實目標上確認"
L["Hit"] = "一般命中"
L["Crit"] = "致命一擊"
L["Heal"] = "治療"
L["Taken"] = "承受"
L["Off"] = "關閉"

-- Chat messages
L["all combat text CVars set back to the WoW Forever defaults."] = "所有戰鬥文字 CVar 已還原為 WoW Forever 預設值。"
L["/fcs opens the window. /fcs reset restores the WoW Forever defaults."] = "/fcs 開啟視窗。/fcs reset 還原 WoW Forever 預設值。"
