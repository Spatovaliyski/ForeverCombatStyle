# Forever Combat Style

A small WoW Forever addon for tuning the floating damage number CVars with a live preview.
Open it with `/fcs` (or `/combatstyle`), or from the addon compartment button.

The window copies the PlateSCT settings layout: a page sidebar on the left (General, Combat, Appearance) with
Reload UI and Reset Defaults pinned at the bottom, a scrolling page with a title and subtitle, and a preview drawer
along the bottom that replays sample Hit, Crit, Heal and Taken numbers as you change settings. A PlateSCT-style
warning at the top of every page notes that this works with Blizzard's own floating text and that no further
customisation (fonts, colors, icons) can be added.

## What it controls

| Page | Section | Control | CVar | Wiki default |
| --- | --- | --- | --- | --- |
| General | Number Style | Style (Retail / Classic) | `classicStyleWorldText` | 0 |
| General | Number Style | Size | `WorldTextScale_v2` | 1 |
| General | Your Combat Text | Your scrolling text (on / off) | `enableFloatingCombatText` | 0 |
| General | Your Combat Text | Float mode (Up / Down / Arc) | `floatingCombatTextFloatMode_v2` | 1 |
| General | Behaviour | Re-apply at login | (addon setting) | on |
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

Defaults come from the Warcraft wiki Classic CVar list. "Reset Defaults" (or `/fcs reset`) writes them back.
That includes "Your scrolling text", whose wiki default is off.

- Sliders write the CVar as you drag. Click a value to type an exact number; typed values may go past the slider range.
- Hover a setting for its CVar name.
- "Re-apply at login" puts your values back if the client resets them.
- A CVar the client does not know is greyed out instead of raising an error.
- "Reload UI" is in the sidebar in case a change does not show up in game.
- Drag the window's bottom-right corner to resize it (720x560 up to the screen size); double-click the corner to
  restore the default size. The size is saved, and the window scales down on small screens.
- `/fcs debug` prints how a few labels are being drawn (for diagnosing blank text).

## About the preview

The wiki lists these CVars but gives no formulas, so the preview is an approximation of how the client animates
them. The motion constants are all in the `PHYS` table at the top of `Preview.lua`; adjust them if the preview
and a real target disagree. The float mode only affects the "Taken" column. Directional numbers alternate sides
in the preview, since the real direction depends on where you stand.

The preview columns follow the switches: a column whose setting is off (Hit and Crit with "Damage over targets",
Heal with "Healing you do", Taken with "Your scrolling text") shows "Off".

The wiki gives no description for the Pop & Fade CVars. What they do is inferred from their names: the ramp
settings drive the preview's size animation, and "Minimum opacity" is not shown in the preview.

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
  game runs. The `label`, `tip` and option names in `NS.SETTINGS` (`Core.lua`) and the preview column titles are
  English keys that are translated when drawn.
- To add text: add the key to `enUS.lua` and to every other locale file. `/fcs debug` output stays in English.

## Files

- `Core.lua`: CVar list, reading/writing, saved variables, slash commands
- `Locales/`: the language registry and one file per language (see above)
- `Widgets.lua`: palette, rounded shapes, buttons, sliders, switches, dropdown, rows (ported from the PlateSCT settings)
- `Preview.lua`: the preview drawer and number animation
- `Window.lua`: the window
- `Media/`: rounded-corner texture, icons and Source Sans 3 fonts (SIL OFL, see `Media/Fonts/SourceSans3-OFL.md`), copied from PlateSCT
