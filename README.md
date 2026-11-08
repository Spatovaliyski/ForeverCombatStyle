# Forever Combat Style

A small WoW Forever addon for tuning the floating damage number CVars. The real numbers are the preview: the window
fades out of the way while you change a setting, so you can watch them over a target you attack.
Open it with `/fcs` (or `/combatstyle`), or from the addon compartment button.

The window copies the PlateSCT settings layout: a page sidebar on the left (General, Combat, Appearance) with
Reload UI and Reset Defaults pinned at the bottom, and a scrolling page with a title and subtitle. A PlateSCT-style
warning at the top of every page notes that this works with Blizzard's own floating text and that no further
customisation (fonts, colors, icons) can be added.

## What it controls

| Page | Section | Control | CVar | Fallback default |
| --- | --- | --- | --- | --- |
| General | Number Style | Style (Retail / Classic, two cards) | `classicStyleWorldText` | 0 |
| General | Number Style | Size | `WorldTextScale_v2` | 1 |
| General | Your Combat Text | Your scrolling text (on / off) | `enableFloatingCombatText` | 0 |
| General | Your Combat Text | Float mode (Up / Down / Arc) | `floatingCombatTextFloatMode_v2` | 1 |
| General | Behaviour | Re-apply at login | (addon setting) | on |
| General | Behaviour | See through while adjusting | (addon setting) | on |
| General | Language | Language (Auto or one of 10 languages) | (addon setting) | Auto |
| Combat | Damage | Damage over targets | `floatingCombatTextCombatDamage_v2` | on |
| Combat | Damage | All auto-attacks | `floatingCombatTextCombatDamageAllAutos_v2` | on |
| Combat | Damage | Damage over time | `floatingCombatTextCombatLogPeriodicSpells_v2` | on |
| Combat | Healing | Healing you do | `floatingCombatTextCombatHealing_v2` | off |
| Combat | Healing | Shields on you | `floatingCombatTextCombatHealingAbsorbSelf_v2` | on |
| Combat | Healing | Shields on your target | `floatingCombatTextCombatHealingAbsorbTarget_v2` | on |
| Combat | Pets | Pet melee damage | `floatingCombatTextPetMeleeDamage_v2` | on |
| Combat | Pets | Pet spell damage | `floatingCombatTextPetSpellDamage_v2` | on |
| Appearance | Fall & Spread | Gravity | `WorldTextGravity_v2` | 0.5 |
| Appearance | Fall & Spread | Spread | `WorldTextStartPosRandomness_v2` | 0 |
| Appearance | Direction | Directional movement | `floatingCombatTextCombatDamageDirectionalScale_v2` | 0 |
| Appearance | Direction | Directional offset | `floatingCombatTextCombatDamageDirectionalOffset_v2` | 1 |
| Appearance | Start Height | Hit height | `WorldTextScreenY_v2` | 0 |
| Appearance | Start Height | Crit height | `WorldTextCritScreenY_v2` | 0 |
| Appearance | Pop & Fade | Ramp duration | `WorldTextRampDuration_v2` | 1 |
| Appearance | Pop & Fade | Hit ramp strength | `WorldTextRampPow_v2` | 1.9 |
| Appearance | Pop & Fade | Crit ramp strength | `WorldTextRampPowCrit_v2` | 8 |
| Appearance | Pop & Fade | Minimum opacity | `WorldTextMinAlpha_v2` | 0.5 |

"Reset Defaults" (or `/fcs reset`) writes back the defaults the client itself reports (`GetCVarDefault`). The
"Fallback default" column is only used for a CVar the client cannot report one for; those values come from the
Warcraft wiki and several differ from the client's (the Retail list has Hit height 0.015, Crit height 0.0275,
Spread 1 and Directional movement 1). Reset includes "Your scrolling text", which is off by default.

- The number style is two large cards side by side instead of a small toggle. Retail is a smooth reveal (numbers
  ease in and settle gradually); Classic is instant and direct. A note under the cards explains that both styles are
  fully tweakable: Size and every Appearance slider apply to whichever style is chosen.
- Sliders write the CVar as you drag. Click a value to type an exact number; typed values may go past the slider range.
- Hover a setting for its CVar name.
- "Re-apply at login" puts your values back if the client resets them.
- A CVar the client does not know is greyed out instead of raising an error.
- "Reload UI" is in the sidebar in case a change does not show up in game.
- Drag the window's bottom-right corner to resize it (720x560 up to the screen size); double-click the corner to
  restore the default size. The size is saved, and the window scales down on small screens.
- `/fcs debug` prints, for every CVar the addon controls (and a few start-position CVars it does not), the live
  value, the client's default and the fallback default, then how a few labels are being drawn (for diagnosing blank text).

## Live mode (there is no preview in the window)

The real floating numbers are Blizzard's own 3D world text. The wiki lists the CVars but gives no formulas, and there are
start-position CVars the addon does not control (`WorldTextNonRandomZ_v2`, `WorldTextRandomZMin_v2`,
`WorldTextRandomZMax_v2`, `WorldTextRandomXY_v2` on the Retail list), so a drawing inside a window could not match the game,
and the earlier previews (animated columns, an arena, a static sketch) were removed for that reason. The game itself is
the preview instead:

While a setting changes (a slider drag, a typed value, the mouse wheel, a switch or a style card) the window fades to
about 15% and a small chip next to the cursor shows the setting and its value. It stays faded while the mouse button is
down and for 1.5 s after the last change, then comes back. Attack a training dummy and the real numbers change as you
drag. Turn it off with General > Behaviour > "See through while adjusting". The constants are in `LIVE` at the top of
`Live.lua`.

The wiki gives no description for the Pop & Fade CVars; what they do is inferred from their names.

The Up / Down / Arc labels (1 / 2 / 3) follow Blizzard's combat text scroll options and are not on the wiki page.

## Languages

English, Français, Deutsch, Español, Русский, Italiano, Português, 简体中文, 繁體中文 and 한국어, set up the same way as
PlateSCT. Under General > Language, "Auto" follows the game client (esMX uses Español, ptPT uses Português, any other
unsupported client uses English) or you can pick a language. Changing it rebuilds the window at once. Anything without a
translation falls back to English. The addon description in the AddOns list is translated too (`## Notes-xxXX` in the
TOC).

Korean and Chinese use the game's own font for that language (`2002.TTF`, `ARKai_T.ttf`, `bLEI00D.ttf`), because Source
Sans 3 has no such glyphs and an English client's default font is Latin-only (it drew boxes). The dropdown draws each
language name in its own font, so every name is readable whichever language is active.

The translations are AI-generated; the Language section says so for every language except English and has an Open Link
button that shows the GitHub Issues URL to copy. Terms shared with PlateSCT reuse its wording.

- `Locales/Locale.lua`: the registry (`NS.L`, `NS.RegisterLocale`, language choice and fallback). It loads first.
- `Locales/enUS.lua`: every string, written `L["English text"] = "English text"`. The English text is the key.
- `Locales/<code>.lua`: one file per language, with the same keys in the same order.
- Text is looked up where it is drawn (`L["..."]`), never when a file loads, because the language can change while the
  game runs. The `label`, `tip` and option names in `NS.SETTINGS` (`Core.lua`) are English keys that are translated
  when drawn.
- To add text: add the key to `enUS.lua` and to every other locale file. `/fcs debug` output stays in English.

## Files

- `Core.lua`: CVar list, reading/writing, saved variables, slash commands
- `Locales/`: the language registry and one file per language (see above)
- `Widgets.lua`: palette, rounded shapes, buttons, sliders, switches, dropdown, style cards, rows (ported from the PlateSCT settings)
- `Live.lua`: Live mode, which fades the window while a setting changes
- `Window.lua`: the window
- `Media/`: rounded-corner texture, icons and Source Sans 3 fonts (SIL OFL, see `Media/Fonts/SourceSans3-OFL.md`), copied from PlateSCT
