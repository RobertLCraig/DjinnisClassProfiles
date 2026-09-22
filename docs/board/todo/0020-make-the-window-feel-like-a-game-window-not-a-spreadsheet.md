---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
---
# 0020 Make the window feel like a game window, not a spreadsheet

## Why

Rob, 2026-09-22: "ensure that we keep the UI clean, user friendly, (currently for example, text and
buttons are slightly too small. it doesnt feel like an "ingame UI" it feels like a semi interactive
spreadsheet." And, the same evening: "Plan currently doesnt show me how to change between M+ and
Raid for example".

What the code draws now (`DjinnisBiS.lua`, read 2026-09-22 at v0.19.0):
- list rows are `ROW_HEIGHT = 15` pixels (line 1888)
- item icons are 16 by 16 (line 1980)
- most text is `GameFontHighlightSmall` or `GameFontNormalSmall`
- the window is `BasicFrameTemplateWithInset` (line 2613), a plain box with a title bar
- Raid or Mythic+ is picked by one button on the character sheet strip that goes round
  1 target, 2 targets, Mythic+ (`PlanTab.nextScenario`, line 1618). The Plan tab has no switch.

Blizzard's own gear windows (Encounter Journal loot, Great Vault, the character sheet) use item
buttons of 37 pixels or more with a quality border, a portrait in the corner, and normal-size text.

What it costs now: small text is slow to read between pulls, small buttons are easy to miss, a grid
of text asks Rob to read every cell to find the one thing that needs doing, and a choice hidden in
a button that goes round is a choice Rob cannot see.

## Links

- **Every open card that draws something follows this card's rules:** `0013`, `0014`, `0015`,
  `0016`, `0017`, `0019`, and `0021` to `0027`. Build this one first, or each of those draws in the
  old style and has to be redrawn.
- `0009` (in `ai-review/`) has Rob's switch note in its comments. If `0009`'s review fixes the
  switch, rule 11 here is already met.
- Touches every tab. The checks outside the game read the drawn tabs (`0007`), so they move with it.

## Not this card

- New features. Same content, drawn bigger and clearer.
- A skin or a theme. Blizzard's own look only; no textures shipped with the addon.

## The rules (for this card and every card after it)

1. **Text:** normal-size Blizzard fonts. `GameFontNormal` for labels, `GameFontHighlight` for
   values, `GameFontNormalLarge` for section heads. `...Small` only for a line of help under a head.
2. **Items are item buttons, not text with a tiny icon.** Blizzard's `LargeItemButtonTemplate` or
   an item button at 32-37 pixels, with the quality border, the item level on the icon, and the
   game tooltip on hover.
3. **Rows are at least 32 pixels high,** with a hover highlight.
4. **Buttons are at least 24 pixels high** and wide enough for their word with room to spare.
   `UIPanelDynamicResizeButtonTemplate` sizes a button to its text.
5. **One thing to do per row stands out.** A row that is right is quiet (grey text, no button). A row
   that needs doing is bright and has its button. Colour means the same thing everywhere:
   green = right, amber = small fix (enchant, gem), red = wrong item.
6. **The window is a Blizzard portrait window** (`PortraitFrameTemplate` or `ButtonFrameTemplate`)
   with the current spec's icon in the portrait, and tabs from `TabSystemTemplate`.
7. **Lists scroll with `WowScrollBoxList` and `MinimalScrollBar`,** as Blizzard's own lists do.
8. **A scale slider** in the window, saved per account, from 0.8 to 1.4. Rob's screen and eyes set
   the size, not the code.
9. **No more than four columns** in any list. If a row needs more, it is two lines or a tooltip.
10. **Fewer words.** A heading says what the section is for ("Change these", "Buy these"), and help
    text goes in a tooltip on a small "?" icon.
11. **Every choice is visible.** No button that goes round a list. A choice of two or three is a row
    of buttons with the chosen one lit: `Raid - 1 target`, `Raid - 2 targets`, `Mythic+`. It sits at
    the top of the Plan tab and on the strip. When the place decides (inside a raid or a dungeon),
    the others are greyed, and their tooltip says why ("You are in a raid").

## Acceptance

<!-- AC:BEGIN -->
- [ ] THE ADDON SHALL draw every list row at least 32 pixels high, and every item as an item button of at least 32 pixels with its quality border. proves: `rows and item buttons meet the minimum size`
- [ ] THE ADDON SHALL use no `...Small` font for a value, a label or a button. proves: `no small font on values, labels or buttons`
- [ ] THE ADDON SHALL draw every button at least 24 pixels high. proves: `buttons meet the minimum height`
- [ ] WHEN the scale slider moves, THE WINDOW SHALL change size at once and keep that size after a reload. proves: `window scale is saved`
- [ ] THE PLAN TAB SHALL show the Raid 1 target, Raid 2 targets and Mythic+ choices as three buttons with the chosen one lit, and greyed with a reason when the place decides. proves: `plan tab shows every content choice`
- [ ] WHEN Rob opens every tab in the game, he SHALL say whether it reads as a game window. proves: manual
<!-- AC:END -->

## Tasks

- [ ] One small set of shared helpers: a row, an item button, an action button, a section head, a
  choice row. Every tab draws with them, so the rules live in one place.
- [ ] Redraw the tabs one at a time with the helpers. Plan tab first: it is the one Rob uses most.
- [ ] Take one screenshot per tab before starting, and ask Rob for one after, for the card's comments.
- [ ] Check each template name in `C:\Dev\WoWAddons\wow-ui-source` at 12.1 before using it.
  Checked 2026-09-22: `PortraitFrameTemplate`, `ButtonFrameTemplate`, `LargeItemButtonTemplate`,
  `WowScrollBoxList`, `MinimalScrollBar`, `TabSystemTemplate`, `UIPanelDynamicResizeButtonTemplate`,
  `SearchBoxTemplate` all exist.
- [ ] Offline checks under the names above.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md`. The main chunk is near Lua's 200
local limit: put the helpers in a table, not in new locals. Look at how the Encounter Journal draws
a loot row (`Blizzard_EncounterJournal`) and copy its sizes rather than guessing.

## Comments

- 2026-09-22 Claude: written from Rob's words in a SecondBrain session. Ideation only. Nothing built.
