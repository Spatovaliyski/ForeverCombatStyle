# Forever Combat Style

A small WoW Forever addon for tuning the floating damage number CVars.
Open it with `/fcs` (or `/combatstyle`), or from the addon compartment button.

The layout takes its cues from the settings window of [Polestar](https://github.com/fitzforge/polestar), in this
addon's own colors and code:

- A sidebar with the pages (General, Combat, Appearance), each showing how many of its settings differ from the
  defaults.
- A header with the page title and subtitle.
- A tab per section; clicking one scrolls to it, and the tab of the section in view is underlined. A narrow window or
  a long translation leaves out the tabs that do not fit.
- **All / Changed**: "Changed" lists only the page's settings that differ from the defaults. A row stays listed while
  you edit it, even back to its default.
- **Preview**: shows or hides the damage preview; the choice is saved.
- Each section is a card. Its rows stand two a line when the card is at least 600 wide (the default window), one a line
  below that.
- A footer with Reload UI and Reset Defaults.

A warning at the top of every page notes that this works with Blizzard's own floating text and that no further
customisation (fonts, colors, icons) can be added.

## What it controls

| Page | Section | Control | CVar | Fallback default |
| --- | --- | --- | --- | --- |
| General | Number Style | Style (Retail / Classic, two cards) | `classicStyleWorldText` | 0 |
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

"Reset Defaults" (or `/fcs reset`) writes back the defaults the client itself reports (`GetCVarDefault`). The
"Fallback default" column is only used for a CVar the client cannot report one for; those values come from the
Warcraft wiki and several differ from the client's (the Retail list has Hit height 0.015, Crit height 0.0275,
Spread 1 and Directional movement 1). Reset includes "Your scrolling text", which is off by default.

- The number style is two large cards side by side instead of a small toggle. Retail is a smooth reveal (numbers
  ease in and settle gradually); Classic is instant and direct. A note under the cards explains that both styles are
  fully tweakable: Size and every Appearance slider apply to whichever style is chosen.
- Sliders write the CVar as you drag. Click a value to type an exact number; typed values may go past the slider range.
- Every option has a line under it saying what it does. Hover a setting for its CVar name.
- A setting that differs from its default has a gold dot. Click the dot, or right-click the setting, to put it back;
  a section's Reset button puts back everything changed in it.
- "Re-apply at login" puts your values back if the client resets them. A setting you reset on its own or by section is
  no longer re-applied.
- A CVar the client does not know is greyed out, with a note, instead of raising an error.
- "Reload UI" is in the footer in case a change does not show up in game.
- Drag the window's bottom-right corner to resize it (720x560 up to the screen size); double-click the corner to
  restore the default size (1000x780). The size is saved, and the window scales down on small screens.
- `/fcs debug` prints, for every CVar the addon controls (and a few start-position CVars it does not), the live
  value, the client's default and the fallback default, then how a few labels are being drawn (for diagnosing blank text).

## Damage preview

An animated band between the section tabs and the page (so it keeps playing on every page, unless switched off) shows a
training dummy with numbers popping off it every half second (every fourth one a crit), drawn in the game's damage
font (`DAMAGE_TEXT_FONT`). It follows the live CVars, including while a slider is dragged:

- Size: text size (18 at 1x, crits 1.4x)
- Gravity: how soon numbers arc back down (0.5 is a soft arc)
- Spread: random start offset
- Directional movement / offset: sideways drift (alternating sides) and a higher start
- Hit height / Crit height: start offset for hits and crits
- Style: Retail eases numbers in and starts them larger, settling over Ramp duration (Hit/Crit ramp strength set how
  fast); Classic shows them at once at full size
- Minimum opacity: a higher value keeps numbers solid longer before they fade
- Damage over targets off: no numbers, and a note says so

It is labelled an approximation. The real numbers are Blizzard's 3D world text; the wiki lists the CVars but gives no
formulas, size follows camera distance, and some start-position CVars are not controlled here (`WorldTextNonRandomZ_v2`,
`WorldTextRandomZMin_v2`, `WorldTextRandomZMax_v2`, `WorldTextRandomXY_v2`). Check the real numbers over a target.

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
- `Widgets.lua`: palette, rounded shapes, buttons, sliders, switches, dropdown, style cards (shapes and controls from
  the PlateSCT settings) and the layout of section cards and rows
- `Preview.lua`: the damage preview band
- `Window.lua`: the window (sidebar, header, section tabs, filter, footer)
- `Media/`: rounded-corner texture, icons and Source Sans 3 fonts (SIL OFL, see `Media/Fonts/SourceSans3-OFL.md`), copied from PlateSCT
