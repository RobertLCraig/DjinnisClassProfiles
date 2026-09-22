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
- [x] THE ADDON SHALL draw every list row at least 32 pixels high, and every item as an item button of at least 32 pixels with its quality border. proves: `rows and item buttons meet the minimum size`
- [x] THE ADDON SHALL use no `...Small` font for a value, a label or a button. proves: `no small font on values, labels or buttons`
- [x] THE ADDON SHALL draw every button at least 24 pixels high. proves: `buttons meet the minimum height`
- [x] WHEN the scale slider moves, THE WINDOW SHALL change size at once and keep that size after a reload. proves: `window scale is saved`
- [x] THE PLAN TAB SHALL show the Raid 1 target, Raid 2 targets and Mythic+ choices as three buttons with the chosen one lit, and greyed with a reason when the place decides. proves: `plan tab shows every content choice`
- [ ] WHEN Rob opens every tab in the game, he SHALL say whether it reads as a game window. proves: manual
<!-- AC:END -->

## Tasks

- [x] One small set of shared helpers: a row, an item button, an action button, a section head, a
  choice row. Every tab draws with them, so the rules live in one place. (Sizes in `PlanTab.SIZE`,
  the item button in `PlanTab.newItemIcon` and `setItemIcon`, the choice row in `PlanTab.choices`
  and `pickScenario`; the row and cell builders that already existed now draw with them.)
- [x] Redraw the tabs one at a time with the helpers. Plan tab first: it is the one Rob uses most.
- [ ] Take one screenshot per tab before starting, and ask Rob for one after, for the card's comments.
  (No client here. The "after" list is in the 2026-09-22 build comment.)
- [x] Check each template name in `C:\Dev\WoWAddons\wow-ui-source` at 12.1 before using it.
  Checked 2026-09-22: `PortraitFrameTemplate`, `ButtonFrameTemplate`, `LargeItemButtonTemplate`,
  `WowScrollBoxList`, `MinimalScrollBar`, `TabSystemTemplate`, `UIPanelDynamicResizeButtonTemplate`,
  `SearchBoxTemplate` all exist.
- [x] Offline checks under the names above.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md`. The main chunk is near Lua's 200
local limit: put the helpers in a table, not in new locals. Look at how the Encounter Journal draws
a loot row (`Blizzard_EncounterJournal`) and copy its sizes rather than guessing.

## Comments

- 2026-09-22 Claude: written from Rob's words in a SecondBrain session. Ideation only. Nothing built.
- 2026-09-22 Claude: built, in a worktree branch, no version bump and not deployed. No frame has
  been seen in a client. **What was built**, all in `DjinnisBiS.lua` with no new top-level local
  (the sizes, helpers and choice logic sit on `PlanTab`):
  1. **The window is `ButtonFrameTemplate`**: the current spec's icon in the portrait
     (`SetPortraitToSpecIcon`, PortraitFrameMixin's own), the template's title bar, close button
     and inset, and the tab and spec buttons at 26 high, starting right of the portrait. The
     scroll frame and stat pane sit inside the inset. Escape still closes it.
  2. **Rows are 34 high, doll cells 36, with a hover highlight** (the `UI-QuestTitleHighlight`
     file FriendsFrame uses). Only a row that does something takes the mouse, so headings and
     blank lines stay quiet under the pointer.
  3. **Every item is Blizzard's `ItemButton` intrinsic at 32 pixels** with its quality border
     from `SetItemButtonQuality`, on the By Boss list rows, the Plan tab's gear rows and every
     doll cell. `LargeItemButtonTemplate` was not used: it is a 147-wide name plate with its own
     background, and the intrinsic is the same icon-and-border the bags draw.
  4. **No `...Small` font on a value, a label or a button.** Three small fonts remain, each on a
     help line and each marked `-- small font:` with its reason: the stat pane's footer, the
     import window's help line, and the one-word "enchant" / "gem" / "rank" mark inside a
     37-pixel slot on the character sheet, where a normal font does not fit. `offline-check.lua`
     scans the file and fails on any small font without the marker.
  5. **Buttons are 24 high** (Plan tab actions, the strip's button, the stat pane's switch) or
     26 (tabs, specs, Import sim, the import window's spec buttons). The action column is 100
     wide so "KeystoneLoot" and "Auctionator" fit.
  6. **A Size slider** in the window's bottom bar, `MinimalSliderWithSteppersTemplate`, 80% to
     140% in 5% steps, saved as `DjinnisBiSDB.scale` and clamped on read. The window is built on
     the first `/bis`, long after `ADDON_LOADED`, so the saved value is real when it is read.
  7. **Three buttons at the top of the Plan tab**: `Raid - 1 target`, `Raid - 2 targets`,
     `Mythic+`, the chosen one lit. In a raid, Mythic+ is greyed and its tooltip says "You are in
     a raid, so the raid plan is in use."; in a dungeon the raid pair is greyed the same way.
     `PlanTab.pickScenario` writes the pin the strip's button wrote, and the strip's button now
     goes through it too, so the sheet marks, bag glows, stat panes and tab all redraw from one
     place. `nextScenario`, `statContext` and `planScenario` are untouched.
  **Checks:** `lua offline-check.lua` (5.4) and Lua 5.1.5 both exit 0. 29 new checks under the
  five `proves:` names (28 in `selfTest`, one source scan in `offline-check.lua`). **Mutations**, each on a temp copy and each red on its own check: the
  in-raid guard in `PlanTab.choices` broken (two choice checks red); the clamp in
  `PlanTab.scale` dropped (two scale checks red); the in-dungeon guard in `pickScenario`
  dropped (two red); a small font put back on the item level button (the scan is red); the row,
  icon and button sizes set to 15, 16 and 18 (three size checks red).
  **What a person must look at, one screenshot each:**
  1. `/reload`, `/bis`. The window has a round portrait with your spec icon, a title bar, a close
     button, four tab buttons and four spec buttons to the right of the portrait, and a "Size"
     slider at the bottom right. Drag the title bar: it moves. Escape closes it.
  2. Move the slider to 120%. The window grows at once. `/reload`, `/bis`: it is still 120%.
  3. By Boss tab: each item row has a square item button with a coloured quality border on the
     left and normal-size text. Hover a row: it lights up and the tooltip shows. Shift-click still
     links in chat. Click the item level on the right: the menu still opens.
  4. By Slot tab: the same item buttons in both columns, headers in gold, "on you" rows, trinket
     ranks and sim extras all readable and nothing overlapping the row beneath.
  5. Stats tab: the four bars with normal-size labels and values, the Raid / Mythic+ button 24
     high. Nothing clipped at the top of the pane.
  6. Plan tab: three buttons above the list, the current one lit. Click `Raid - 2 targets`: it
     lights, the list changes to the 2 target rows, and the character sheet strip (open it) reads
     "2 targets". Click `Mythic+`: the stat pane's header reads "Mythic+".
  7. Plan tab in a dungeon: the two raid buttons are greyed and hovering one says why. In the
     raid: Mythic+ is greyed with its reason.
  8. Plan tab gear rows: each planned item has its item button and quality border, and Equip,
     Equip all, Save set, Search AH, Auctionator and KeystoneLoot are 24-high buttons that fit
     their word.
  9. The character sheet strip and its button, and the framed stat pane beside the sheet: normal
     text, the button 24 high, nothing spilling out of the strip.
  **Left out, and why.** Rule 7's `WowScrollBoxList` and `MinimalScrollBar`: the pooled rows
  already exist and work, and a scroll box rewrite touches every drawn-tab check for no change on
  screen beyond the scrollbar art. Rule 6's `TabSystemTemplate`: it wants `PanelTemplates_`
  bookkeeping and the four plain buttons already do the job. Rule 2's item level on the icon: the
  intrinsic's `Count` string is for stack counts, and the item level already sits on the right.
  Rule 5's colour-by-state and rule 10's fewer words: the Plan tab's text is unchanged, because
  the card says same content, drawn bigger. The import window keeps `BasicFrameTemplateWithInset`
  with its buttons bumped to 26. **Edit Mode:** the window is a toggled panel, not a HUD element,
  and is not registered with Edit Mode. Registering it would take the `registerPlain` pattern
  from `DjinnisUIEnhancements/EditMode.lua` (an `EventRegistry` "EditMode.Enter" / "EditMode.Exit"
  overlay with `GetFrame`, `SetUnlocked`, `ApplyLayout`), copied in, which is a card of its own if
  Rob wants a `/bis` window that Edit Mode can place.
