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

## Comments

**2026-09-23, adversarial review (agent). Verdict: BOUNCE.** Reviewed at HEAD `fa454ac`, which
includes 0034 and the Balance rename `43b4530` on top of `8a71604`.

**Attacked.** I ran `lua offline-check.lua` on a temp copy. It passes, and it does run
`PlanTab.sidebarChecks`. Then I tried 13 mutations in the copy:
- **Went red (7):** tick by name, dropping the boss-here reorder, ignoring the fold, dropping the
  Mythic+ swap, `saved` always true, `warn` dropped, and a direct `C_ClassTalents.LoadConfig` in
  the double-click. The last one was caught by the talent-write scan.
- **Stayed green, as the harness says it must (4):** the combat hide, the fold toggle, a
  double-click on a header, and the `canRead` gate in `liveTalents`. All four are frame or live
  API code, and the harness stubs every frame.
- **Stayed green, and should not have (2):** "tick every matching row" and "drop the tie-break".

I also probed the pure code:
- Non-druid, and a nil spec: the list is empty, the title says so, and nothing errors.
- A fold key it does not know about is ignored.
- Every raid boss in `PlanTab.BOSSES` has a `BOSS_ICON` entry.
- No spec has two build names on one string.
- An injected duplicate ticks only the selected name. So the code is right; nothing checks it.

I checked against `wow-ui-source`:
- `SetElementInitializer("Button", fn)` with `SetElementExtent`: ScrollBoxListView.lua 487 and
  its Init. With an extent set, the template lookup is skipped. FrameFactory.lua 12 treats
  "Button" as a native frame type.
- `WowScrollBoxList` is a Frame and `MinimalScrollBar` is an EventFrame. Both match the
  `CreateFrame` types used.
- `ReadLoadoutHeader`, `IsHashEmpty` and `HashEquals` are mixin methods. The `bitWidth*` fields
  sit on the mixin table (Blizzard_ClassTalentImportExport.lua 52), so calling them on the mixin
  works.
- The `LOADOUT_ERROR_*` checks run in the same order as `ImportLoadout`.
- Every `C_Traits` and `C_ClassTalents` call it makes is in the generated API docs.
- After combat, `PLAYER_REGEN_ENABLED` on the bag-mark watcher calls `PlanTab.redraw`, and that
  calls `updateSidebar`.

**Broke.**
1. **Criterion 2 ("and no other") has no check that can fail.** `DjinnisBiS.lua:7172-7177`. Since
   the Balance rename, every build name holds its own string. So the duplicate case is never run,
   and the tie-break at 5858 is untested. The Built line "Balance stores one build under three
   boss names" is stale too. Fix: in `sidebarChecks`, set a second Balance name to the first
   name's string. Check that `ticked(...)`, with the second name selected, returns only that name.
   Then put the string back. Update the Built line.
2. Minor: `DjinnisBiS.lua:5867/5870` and `5973` index `sidebarFolded` without checking its type.
   A saved file edited by hand to `sidebarFolded = true` throws there. Fix: use it only when
   `type(...) == "table"`.
3. Minor: `DjinnisBiS.lua:6034-6037` counts on a plain Button being registered for left clicks by
   default. Nothing in the local source proves that. TalentLoadoutsEx registers explicitly
   (`frames/list.xml:155`). Fix: add `row:RegisterForClicks("LeftButtonUp")` in the first-time
   block.

**Security.**
1. **Weakest point:** a double-click switches talents. After a header fold, the list is flushed
   and its row frames are handed out again. If the scroll position moves, the second click of a
   double-click on a header could land on a build row. That row would then call `loadTalents`.
   Even then, it works out of combat only and goes through Blizzard's helper.
2. **Unchecked:** only our own SavedVariables (`sidebarFolded`, finding 2) and the addon's own
   stored strings. The strings are parsed inside `pcall`. Nothing arrives from another player.
   There is no network.
3. **Leaks:** nothing. The tooltips show the player's own build names and Blizzard's error
   strings.

On the 12.1 traps: `liveTalents` gates the import string with `canRead`. The only event it
registers is `PLAYER_REGEN_DISABLED`, one at a time, after the handler is set, and verified.
It takes no unit reads.

**No client was run. The list is UI in a game client no agent can run.** When it reaches
human-review, a person must check:
- Rows really respond to a click and a double-click (finding 3).
- The scroll bar is shown even when the list is short (there is no managed visibility).
- For step 2, the tick only follows the tree after Apply. Nothing redraws on a staged talent
  change.
- Double-click a header after scrolling to the bottom: the talents must not switch.

**2026-09-23** Builder, v0.33.0, commit `4fbcc30`. All three findings fixed.
1. `sidebarChecks` lends one Balance build another's string and checks both ways round: only
   one row ticks, and it is the selected one. Tick-every-match and no-tie-break both go red.
2. `sidebarList` ignores a fold setting that is not a table; `sidebarClick` replaces one.
3. Rows call `RegisterForClicks("LeftButtonUp")`, as TalentLoadoutsEx does.
The review also noted that the Built line on Balance's shared names is out of date. Since `43b4530`
each Balance build has its own string.

**2026-09-23** Re-review of the v0.33.0 fixes (agent). **CLEAN.**

What I attacked: `4fbcc30`, with 4 mutations on a copy in `%TEMP%\rereview`.

What held:
- Tick-every-match and no-tie-break both go red now. The lent string goes to `Dungeon`, which is
  in the Mythic+ group, so it sorts after `Raid: Single Target` in raid context. One of the two
  checks really does need the tie-break.
- Remove the fold guard in `sidebarList` and the new check throws, so it goes red.
- The tick now goes through `nodeKey` (0031's fix). I checked `nodeKey` against Blizzard's reader
  on all 23 builds. A fresh import ticks its row.

What is weak (no bounce):
- `sidebarClick`'s guard (`DjinnisBiS.lua:6010`) has no check. Put back `d.sidebarFolded or {}`
  and everything stays green. It is one line and simple to read.
- `RegisterForClicks` is frame code and cannot be checked here. It is for the in-game pass.
- The Built line on this card (lines 36-37) still says Balance stores one build under three boss
  names. That has been untrue since `43b4530`. Fix the text.

Security: unchanged. The fold setting is the player's own saved file, and it is now type-checked
on both paths.

Verdict: CLEAN. Acceptance is in-game only, so the card goes to human-review next.
