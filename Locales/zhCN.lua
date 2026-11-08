local _, NS = ...

local L = {}
NS.RegisterLocale("zhCN", L)

-- Window chrome
L["Client"] = "客户端"
L["Close"] = "关闭"
L["/fcs  ·  ESC to close"] = "/fcs  ·  按 ESC 关闭"
L["Drag to resize. Double-click to restore the default size."] = "拖动以调整大小。双击恢复默认大小。"

-- Pages
L["General"] = "常规"
L["Combat"] = "战斗"
L["Appearance"] = "外观"
L["Number style, your own combat text, and how the addon behaves."] = "数字样式、你自己的战斗文字，以及插件的行为。"
L["Choose what appears: damage, healing, shields and pets."] = "选择显示的内容：伤害、治疗、护盾和宠物。"
L["How numbers fall, drift, start and fade."] = "数字如何下落、漂移、起始和淡出。"
L["This adjusts Blizzard's own floating combat text, so it works 100% with the default game. Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."] =
    "这会调整暴雪自带的浮动战斗文字，因此可与原版游戏 100% 兼容。暴雪未开放该文字的字体、颜色或图标设置，因此无法添加更多自定义选项。"

-- Section headings
L["Number Style"] = "数字样式"
L["Your Combat Text"] = "你的战斗文字"
L["Behaviour"] = "行为"
L["Damage"] = "伤害"
L["Healing"] = "治疗"
L["Pets"] = "宠物"
L["Fall & Spread"] = "下落与分散"
L["Direction"] = "方向"
L["Start Height"] = "起始高度"
L["Pop & Fade"] = "弹出与淡出"
L["Language"] = "语言"

-- Settings: names
L["Style"] = "样式"
L["Size"] = "大小"
L["Gravity"] = "重力"
L["Spread"] = "分散度"
L["Hit height"] = "普通命中高度"
L["Crit height"] = "暴击高度"
L["Directional movement"] = "方向性移动"
L["Directional offset"] = "方向性偏移"
L["Float mode"] = "浮动模式"
L["Your scrolling text"] = "你的滚动文字"
L["Damage over targets"] = "目标上方伤害"
L["All auto-attacks"] = "所有自动攻击"
L["Damage over time"] = "持续伤害"
L["Healing you do"] = "你造成的治疗"
L["Shields on you"] = "你身上的护盾"
L["Shields on your target"] = "目标身上的护盾"
L["Pet melee damage"] = "宠物近战伤害"
L["Pet spell damage"] = "宠物法术伤害"
L["Ramp duration"] = "渐变时长"
L["Hit ramp strength"] = "普通命中渐变强度"
L["Crit ramp strength"] = "暴击渐变强度"
L["Minimum opacity"] = "最低不透明度"

-- Settings: choices
L["Retail"] = "正式服样式"
L["Classic"] = "经典样式"
L["Up"] = "向上"
L["Down"] = "向下"
L["Arc"] = "弧线"

-- Settings: descriptions
L["Classic or Retail look for floating damage numbers."] = "浮动伤害数字的经典或正式服外观。"
L["Overall size of damage numbers."] = "伤害数字的整体大小。"
L["How strongly numbers fall back down after rising."] = "数字上升后向下回落的力度。"
L["How far from the spawn point numbers may start."] = "数字可能从距离生成点多远的位置开始。"
L["Start offset for normal hits. Positive is higher."] = "普通命中的起始偏移。正值更高。"
L["Start offset for critical hits. Positive is higher."] = "暴击的起始偏移。正值更高。"
L["Pushes numbers sideways, away from you."] = "将数字向侧面推开，远离你。"
L["How far from the target directional numbers start."] = "方向性数字从距离目标多远的位置开始。"
L["Scroll direction of the text on your own character."] = "你自己角色上文字的滚动方向。"
L["Show combat text on your own character."] = "在你自己的角色上显示战斗文字。"
L["Show damage numbers over enemies you hit."] = "在你击中的敌人上方显示伤害数字。"
L["Show every auto-attack number instead of hiding some."] = "显示每次自动攻击的数字，而不是隐藏其中一部分。"
L["Show damage from periodic effects."] = "显示周期性效果造成的伤害。"
L["Show the healing you do to your target."] = "显示你对目标造成的治疗。"
L["Show shields added to yourself."] = "显示施加在你自己身上的护盾。"
L["Show shields added to your target."] = "显示施加在你目标身上的护盾。"
L["Show your pet's melee damage."] = "显示你宠物的近战伤害。"
L["Show your pet's spell damage."] = "显示你宠物的法术伤害。"
L["How long the size animation lasts, in seconds."] = "大小动画持续的时间，单位为秒。"
L["How sharply hit numbers settle to their size."] = "普通命中数字稳定到其大小的剧烈程度。"
L["How sharply crits settle to their size."] = "暴击数字稳定到其大小的剧烈程度。"
L["Opacity floor for numbers. Not shown in the preview."] = "数字的最低不透明度。预览中不会显示。"
L["Not available on this client."] = "此客户端不可用。"
L["This setting is not available on this client."] = "此设置在此客户端上不可用。"
L["Click to type an exact value."] = "点击输入精确数值。"

-- Number style
L["Smooth reveal"] = "平滑显现"
L["Instant and direct"] = "即时直接"
L["Numbers ease into view and settle into place gradually, for a softer, more fluid feel."] =
    "数字会渐渐显现并逐步稳定到最终大小，观感更柔和、更流畅。"
L["Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."] =
    "数字会立即出现并直线移动，没有逐渐放大的过程，观感更干脆利落。"
L["Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose. The preview below shows the result."] =
    "两种样式都可以自由调整：大小以及%s页面上的所有滑块（包括弹出与淡出渐变）适用于你所选的样式。下方预览会显示效果。"

-- Behaviour
L["Re-apply at login"] = "登录时重新应用"
L["Put your settings back at login if the client reset them."] = "如果客户端重置了设置，登录时将你的设置恢复。"

-- Language
L["Auto"] = "自动"
L["Choose the language used by Forever Combat Style panels and messages."] = "选择 Forever Combat Style 面板和消息使用的语言。"
L["This translation was generated with AI. If you find inconsistent terminology or incorrect wording, please report it through GitHub Issues. Thank you for your help! Translation contributors will be credited."] =
    "此翻译由 AI 生成。如果发现术语不一致或措辞不准确，请通过 GitHub Issues 反馈。感谢你的帮助！翻译贡献者将获得署名致谢。"
L["Open Link"] = "打开链接"
L["Press Ctrl+C to copy the URL."] = "按 Ctrl+C 复制网址。"

-- Sidebar utilities
L["Reload UI"] = "重载界面"
L["Reload the interface. Use it if a change does not show up in game."] = "重新加载界面。如果某项更改没有在游戏中生效，请使用此项。"
L["Reset Defaults"] = "恢复默认设置"
L["Put every combat text setting back to the WoW Forever default."] = "将所有战斗文字设置恢复为 WoW Forever 的默认值。"

-- Preview
L["Hide preview"] = "隐藏预览"
L["Show preview"] = "显示预览"
L["Show sample hits, crits and incoming damage inside this window."] = "在此窗口中显示示例命中、暴击和受到的伤害。"
L["Replay"] = "重播"
L["Restart the sample numbers."] = "重新开始示例数字。"
L["Approximate preview  ·  check on a real target"] = "预览仅供参考  ·  请在真实目标上确认"
L["Hit"] = "普通命中"
L["Crit"] = "暴击"
L["Heal"] = "治疗"
L["Taken"] = "承受"
L["Off"] = "关闭"
L["Drag to change the preview height. Double-click to reset it."] = "拖动以调整预览高度。双击重置。"

-- Chat messages
L["all combat text CVars set back to the WoW Forever defaults."] = "所有战斗文字 CVar 已恢复为 WoW Forever 默认值。"
L["/fcs opens the window. /fcs reset restores the WoW Forever defaults."] = "/fcs 打开窗口。/fcs reset 恢复 WoW Forever 默认值。"
