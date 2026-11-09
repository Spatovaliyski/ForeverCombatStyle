local _, NS = ...

local L = {}
NS.RegisterLocale("koKR", L)

-- Window chrome
L["Client"] = "클라이언트"
L["Close"] = "닫기"
L["/fcs  ·  ESC to close"] = "/fcs  ·  ESC로 닫기"
L["Drag to resize. Double-click to restore the default size."] = "끌어서 크기를 조절합니다. 두 번 클릭하면 기본 크기로 돌아갑니다."

-- Pages
L["General"] = "일반"
L["Combat"] = "전투"
L["Appearance"] = "외형"
L["Number style, your own combat text, and how the addon behaves."] = "숫자 스타일, 내 전투 문자, 애드온 동작을 설정합니다."
L["Choose what appears: damage, healing, shields and pets."] = "표시할 항목을 선택합니다: 피해, 치유, 보호막, 소환수."
L["How numbers fall, drift, start and fade."] = "숫자가 떨어지고, 흘러가고, 시작하고, 사라지는 방식입니다."
L["This adjusts Blizzard's own floating combat text, so it works 100% with the default game. Blizzard does not expose fonts, colors or icons for it, so no further customisation can be added."] =
    "이 기능은 블리자드 자체의 떠오르는 전투 문자를 조정하므로 기본 게임에서 100% 작동합니다. 블리자드는 이 문자의 글꼴, 색상, 아이콘을 제공하지 않아 더 이상의 사용자 설정은 추가할 수 없습니다."

-- Section headings
L["Number Style"] = "숫자 스타일"
L["Your Combat Text"] = "내 전투 문자"
L["Behaviour"] = "동작"
L["Damage"] = "피해"
L["Healing"] = "치유"
L["Pets"] = "소환수"
L["Fall & Spread"] = "낙하 및 분산"
L["Direction"] = "방향"
L["Start Height"] = "시작 높이"
L["Pop & Fade"] = "등장 및 사라짐"
L["Language"] = "언어"

-- Settings: names
L["Style"] = "스타일"
L["Size"] = "크기"
L["Gravity"] = "중력"
L["Spread"] = "분산"
L["Hit height"] = "일반 적중 높이"
L["Crit height"] = "치명타 높이"
L["Directional movement"] = "방향성 이동"
L["Directional offset"] = "방향성 오프셋"
L["Float mode"] = "부유 모드"
L["Your scrolling text"] = "내 스크롤 문자"
L["Damage over targets"] = "대상 위 피해"
L["All auto-attacks"] = "모든 자동 공격"
L["Damage over time"] = "지속 피해"
L["Healing you do"] = "내가 하는 치유"
L["Shields on you"] = "내게 걸린 보호막"
L["Shields on your target"] = "대상에게 걸린 보호막"
L["Pet melee damage"] = "소환수 근접 피해"
L["Pet spell damage"] = "소환수 주문 피해"
L["Ramp duration"] = "변화 지속 시간"
L["Hit ramp strength"] = "일반 적중 변화 강도"
L["Crit ramp strength"] = "치명타 변화 강도"
L["Minimum opacity"] = "최소 불투명도"

-- Settings: choices
L["Retail"] = "리테일 스타일"
L["Classic"] = "클래식 스타일"
L["Up"] = "위로"
L["Down"] = "아래로"
L["Arc"] = "호"

-- Settings: descriptions
L["Classic or Retail look for floating damage numbers."] = "떠오르는 피해 숫자의 클래식 또는 리테일 모양을 선택합니다."
L["Overall size of damage numbers."] = "피해 숫자의 전체 크기입니다."
L["How strongly numbers fall back down after rising."] = "숫자가 떠오른 뒤 다시 떨어지는 세기입니다."
L["How far from the spawn point numbers may start."] = "숫자가 생성 지점에서 얼마나 멀리 떨어져 시작할 수 있는지 정합니다."
L["Start offset for normal hits. Positive is higher."] = "일반 적중의 시작 위치 오프셋입니다. 양수일수록 높습니다."
L["Start offset for critical hits. Positive is higher."] = "치명타의 시작 위치 오프셋입니다. 양수일수록 높습니다."
L["Pushes numbers sideways, away from you."] = "숫자를 옆으로, 나에게서 멀어지는 방향으로 밉니다."
L["How far from the target directional numbers start."] = "방향성 숫자가 대상에서 얼마나 떨어져 시작하는지 정합니다."
L["Scroll direction of the text on your own character."] = "내 캐릭터 위에 표시되는 문자의 스크롤 방향입니다."
L["Show combat text on your own character."] = "내 캐릭터 위에 전투 문자를 표시합니다."
L["Show damage numbers over enemies you hit."] = "내가 공격한 적 위에 피해 숫자를 표시합니다."
L["Show every auto-attack number instead of hiding some."] = "일부를 숨기지 않고 모든 자동 공격 숫자를 표시합니다."
L["Show damage from periodic effects."] = "주기적 효과로 입히는 피해를 표시합니다."
L["Show the healing you do to your target."] = "내가 대상에게 하는 치유를 표시합니다."
L["Show shields added to yourself."] = "내게 적용되는 보호막을 표시합니다."
L["Show shields added to your target."] = "대상에게 적용되는 보호막을 표시합니다."
L["Show your pet's melee damage."] = "내 소환수의 근접 피해를 표시합니다."
L["Show your pet's spell damage."] = "내 소환수의 주문 피해를 표시합니다."
L["How long the size animation lasts, in seconds."] = "크기 애니메이션이 지속되는 시간(초)입니다."
L["How sharply hit numbers settle to their size."] = "일반 적중 숫자가 제 크기로 안정되는 급격한 정도입니다."
L["How sharply crits settle to their size."] = "치명타 숫자가 제 크기로 안정되는 급격한 정도입니다."
L["Opacity floor for numbers."] = "숫자의 최소 불투명도입니다."
L["Not available on this client."] = "이 클라이언트에서는 사용할 수 없습니다."
L["This setting is not available on this client."] = "이 설정은 이 클라이언트에서 사용할 수 없습니다."
L["Click to type an exact value."] = "클릭하여 정확한 값을 입력합니다."

-- Number style
L["Smooth reveal"] = "부드러운 등장"
L["Instant and direct"] = "즉각적이고 직접적"
L["Numbers ease into view and settle into place gradually, for a softer, more fluid feel."] =
    "숫자가 서서히 나타나 점차 자리를 잡아, 더 부드럽고 자연스러운 느낌을 줍니다."
L["Numbers appear immediately and move straight, with no gradual build-up, for a snappier feel."] =
    "숫자가 즉시 나타나 곧게 움직이며 점진적인 변화가 없어, 더 빠르고 경쾌한 느낌을 줍니다."
L["Both styles are fully tweakable: Size and every slider on the %s page (including the Pop & Fade ramp) apply to whichever style you choose."] =
    "두 스타일 모두 자유롭게 조정할 수 있습니다. 크기와 %s 페이지의 모든 슬라이더(등장 및 사라짐 곡선 포함)는 선택한 스타일에 적용됩니다."

-- Behaviour
L["Re-apply at login"] = "접속 시 다시 적용"
L["Put your settings back at login if the client reset them."] = "클라이언트가 설정을 초기화했다면 접속 시 내 설정을 되돌립니다."

-- Language
L["Auto"] = "자동"
L["Choose the language used by Forever Combat Style panels and messages."] = "Forever Combat Style의 창과 메시지에 사용할 언어를 선택합니다."
L["This translation was generated with AI. If you find inconsistent terminology or incorrect wording, please report it through GitHub Issues. Thank you for your help! Translation contributors will be credited."] =
    "이 번역은 AI로 생성되었습니다. 용어가 일관되지 않거나 표현이 부정확한 부분을 발견하면 GitHub Issues에 알려 주세요. 도와주셔서 감사합니다! 번역에 기여하신 분의 이름을 명시해 감사의 뜻을 전하겠습니다."
L["Open Link"] = "링크 열기"
L["Press Ctrl+C to copy the URL."] = "Ctrl+C를 눌러 URL을 복사하세요."

-- Sidebar utilities
L["Reload UI"] = "UI 다시 불러오기"
L["Reload the interface. Use it if a change does not show up in game."] = "인터페이스를 다시 불러옵니다. 변경 사항이 게임에 적용되지 않을 때 사용하세요."
L["Reset Defaults"] = "기본값으로 초기화"
L["Put every combat text setting back to the WoW Forever default."] = "모든 전투 문자 설정을 WoW Forever 기본값으로 되돌립니다."

-- Chat messages
L["all combat text CVars set back to the WoW Forever defaults."] = "모든 전투 문자 CVar를 WoW Forever 기본값으로 되돌렸습니다."
L["/fcs opens the window. /fcs reset restores the WoW Forever defaults."] = "/fcs는 창을 엽니다. /fcs reset은 WoW Forever 기본값을 복원합니다."
