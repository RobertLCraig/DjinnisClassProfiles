---
needs: 0031
model: fable  # interface work
---
# 0032 The loadout list beside the talent window looks like TalentLoadoutsEx

## Why

Rob, 2026-09-23: "Visually I like TalentLoadoutsEx." The sidebar from card `0019` already sits
beside Blizzard's talent window. This gives it that addon's look. The source is in
`research/TalentLoadoutsEx/modules/list.lua` and `frame.lua` (gitignored), and what makes it look
good is written up in `docs/research/talent-loadout-addons.md`.

## What

- Blizzard's own `ScrollBox` list, 36 px icon per row. A raid boss row shows the boss's portrait
  (TalentLoadoutsEx `preset.lua` has the Season 2 icon IDs); a dungeon row the Mythic+ icon.
- Groups that fold open: one per boss in the current raid, one for dungeons.
- **A green tick on the row whose build matches the tree right now**, compared by content
  (`PlanTab.talentStringsDiffer`), never by name.
- A warning mark on a stored string this client cannot read.
- Double-click switches through `PlanTab.loadTalents`. Nothing else writes.
- Hidden in combat.

## Built, v0.29.0, 2026-09-23

- The card 0019 sidebar is rebuilt on Blizzard's `WowScrollBoxList` and `MinimalScrollBar`, with
  plain buttons for rows, laid out after TalentLoadoutsEx's `frames/list.xml`: 44 px rows, a 36 px
  icon, the name and its bosses beside it, a mark on the right. The Apply button is gone:
  **double-click switches**, through `PlanTab.loadTalents` only.
- Groups **Raid**, **Mythic+** and **Other builds** fold on a click, and the fold is kept in
  `DjinnisBiSDB.sidebarFolded`. Mythic+ goes first in a key. In a raid, the boss here goes first.
  Other builds holds stored builds no boss row names: Guardian's and Resto's raid builds today.
- Boss portraits are TalentLoadoutsEx's Season 2 icon IDs (`PlanTab.BOSS_ICON`). A dungeon row
  has the Mythic+ icon, 4352494.
- **The tick** compares strings, never names, and lands on one row. Balance stores one build under
  three boss names, so the selected name wins, else the first.
- **The warning mark** runs Blizzard's import checks in order (TalentLoadoutsEx's
  `validator.lua`): bad string, other game version, other spec, older tree. **Expect it on every
  Guardian and Resto build**: their strings carry a real, older tree stamp. DjinnisDreamgrove
  imported them fine all the same.
- A build this character has no loadout for is grey, says `not saved`, and its tooltip points at
  `/djbis loadouts`.
- Hidden in combat, by `PLAYER_REGEN_DISABLED` on the list itself, verified when registered.
- The row's hover calls `PlanTab.showTreeDiff` when it exists. That is card 0034's hook.
- `/bis test`: `PlanTab.sidebarChecks`, 17 checks on the list model. The frame is not tested.

## What I need from you

1. `/reload`, open the talent window as Feral. Pass: the list sits on the right, with the Raid
   group of boss portraits and a Mythic+ group. Compare it with a TalentLoadoutsEx screenshot.
2. Pass: one green tick, on the build in play. Move one talent: the tick goes.
3. Click the Raid header: it folds. `/reload`: it is still folded.
4. Double-click a saved build. Pass: the talents switch, and no frozen button on the next pull.
5. As Guardian: the builds sit under Other builds, each with a warning mark. Hover one to read it.
6. Enter combat with the talent window open. Pass: the list goes, and comes back after.

## Acceptance

- [ ] WHEN the talent window opens, THE LIST SHALL show every stored build for the spec, grouped, with the current raid's boss first.
- [ ] WHEN the tree matches a stored build, THE LIST SHALL tick that row and no other.
- [ ] WHEN a row is double-clicked, THE ADDON SHALL switch through Blizzard's helper only.
- [ ] Rob accepts the look in a client, against a screenshot of TalentLoadoutsEx.
