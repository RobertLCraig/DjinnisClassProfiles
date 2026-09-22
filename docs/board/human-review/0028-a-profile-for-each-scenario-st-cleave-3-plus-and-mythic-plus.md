---
needs: 0014
---
# 0028 A profile for each scenario: raid single target, raid cleave, raid 3+ targets, Mythic+

## Why

Rob, 2026-09-22, choosing Option A on the planned-build question: "this leads onto something I
want to add, which is a profile for each scenario: RAID Single Target, RAID Cleave, Raid multi
Target (3+), M+."

Today a spec has three cells (`st`, `2t`, `mplus`) and only `st` and `mplus` carry a `talents`
string, so a 2-target boss has gear but no planned build, and there is no cell at all for a
3+ target fight. A profile is one cell: loadout name, talents string, gear, stat targets.

## Links

- Needs `0014`: the compare against the cell's own `talents` string is what makes a profile's
  build mean something.
- Extends `0004` (`update-gear-plan.ps1`), `0007` (Plan tab rows), `0009` (the scenario button).

## Not this card

- Choosing which boss is 3+ targets. The `BOSSES` rows say that already, one edit each.
- Running the sims. That is a Raidbots trip per spec per scenario; see below.

## Direction

- Add scenario `3t` beside `st`, `2t`, `mplus`: `SCENARIO_LABEL` "3+ targets", the strip's
  button cycles 1, 2, 3+, Mythic+ (in a raid: 1, 2, 3+, 1), `update-gear-plan.ps1` maps
  `enemyCount` 3 and above to `3t`, `SCENARIO_ORDER` gains it, the self-test covers it.
- Every cell carries `talents`. The bake script already writes it from the report's loadout
  string; a report simmed on the wrong loadout writes the wrong build, so the script prints the
  loadout name it baked and the cell's `loadout` must match a name in `BOSSES`.
- Nothing else changes shape: a cell is a cell, the Plan tab draws whatever cells exist.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN a report simmed at three or more enemies is baked, THE SCRIPT SHALL fill the spec's `3t` cell with gear, stat targets, loadout and talents. proves: `a 3+ target report fills the 3t cell`
- [x] WHEN the strip's scenario button is pressed in a raid, THE ADDON SHALL cycle 1 target, 2 targets, 3+ targets, 1 target. proves: `the scenario button reaches 3+ targets`
- [x] WHEN a boss row names scenario `3t`, THE PLAN TAB SHALL draw that cell's gear and build for it. proves: `a 3t boss row draws the 3t cell`
- [x] WHEN a cell has no `talents` string, THE ADDON SHALL show no build for it and mark nothing edited. proves: `a cell without talents has no planned build`
<!-- AC:END -->

## Tasks

- [x] `3t` in `SCENARIO_LABEL`, `nextScenario`, `planScenario`, the bag and stat readers, the
  self-test's scenario loops.
- [x] `update-gear-plan.ps1`: `$SCENARIOS` 3 and above, `$SCENARIO_ORDER`, self-test.
- [x] Offline checks under the names above.

## What I need from you

Four Raidbots Top Gear runs per spec Rob plays, one per scenario, each on the loadout that
scenario should use. The 2-target cells have gear today but no build: re-bake them on the right
loadout. For the 3+ runs, the loadout name to sim on (none in `BOSSES` today is a 3+ build).
Then `.\update-gear-plan.ps1 <report ids>` and a `/reload`.

In a client, after `/reload`, two looks. Neither is proven offline; the frames are stubs there.

- Open the character sheet outside an instance and press the strip's scenario button from
  1 target: it should read 2 targets, 3+ targets, Mythic+, 1 target. In a raid: 1, 2, 3+, 1.
  The Plan tab's row of content buttons should show four, with "Raid - 3+ targets" third.
- With 3+ targets picked and no 3t cell baked, the strip should say "No 3+ targets gear plan
  for Feral yet" and the Plan tab, once a `BOSSES` row says `scenario = "3t"`, should draw
  "No 3+ targets gear plan yet. Run a Raidbots Top Gear sim on 3+ targets" and nothing else
  under "2. Gear to change". No slot glows, no bag glows, until a report is baked.

## Comments

- 2026-09-22 Claude: written from Rob's Option A answer. The addon side is one agent's build;
  the sims are Rob's trips.
- 2026-09-22 Claude (build, worktree branch): `3t` added everywhere the addon enumerates a
  scenario: `SCENARIO_LABEL`, `planScenario`'s accepted set, `PlanTab.nextScenario` (2t goes to
  3t; 3t goes to Mythic+ outside and to 1 target in a raid), `PlanTab.CHOICES` and
  `CHOICE_LABEL` (four buttons), `PlanTab.CONTENT_WORD` (3t is raid content, so the stat
  targets, tooltip lines and item list treat it as raid), `PlanTab.SET_SUFFIX` ("DBiS Feral
  3T"), `buildPlanIndex` (now walks `PlanTab.CHOICES`), and the data check on every cell's
  scenario. `GEAR_PLAN` has no `3t` cell and nothing minds, as the Mythic+ cell used to be.
  Script: `$SCENARIOS` gains `3 = '3t'` and `Read-Plan` clamps the enemy count to 3, so seven
  enemies file as `3t`; `$SCENARIO_ORDER` is `st, 2t, 3t, mplus`; each report's line now ends
  `simmed on loadout "..."` and `Get-BossLoadouts` reads the target file's `PlanTab.BOSSES`
  rows for that spec and warns when the name is not among them. `-SelfTest` makes the 3- and
  7-enemy reports from the 1-enemy fixture in a temp folder rather than shipping two more
  8 KB fixtures; seven checks pass. Offline: three `do` blocks at the tail of `selfTest`,
  both interpreters exit 0; each behaviour was mutated once on a temp copy and went red
  (old cycle: 5 FAIL; saved `3t` refused: 4 FAIL; Plan tab drawing the st cell for a 3t row:
  1 FAIL; a cell without talents borrowing the st string: 1 FAIL; `3t` dropped from
  `$SCENARIO_ORDER`: 1 FAIL; clamp removed: the script's own "cannot place" throw; warning
  inverted: 1 FAIL). The fourth criterion is half proven here: `gearPlanFor` hands over
  `talents = nil` for such a cell and the `/simc` export leaves the loadout out rather than
  borrowing a string. "Mark nothing edited" is the compare `0014` is rebuilding around
  `PlanTab.plannedTalents(spec, scenario)`; that card's review should tick it, so it is left
  open here. Not touched: `PlanTab.talentsEdited`, `activeLoadoutName`, `loadoutState`. No
  version bump. The `a 3+ target report fills the 3t cell` proof is the PowerShell self-test,
  not a Lua block.
- 2026-09-22 Claude (review, worktree branch): attacked against the merged code, not the ticks.
  Every `"2t"` and `"mplus"` literal in `DjinnisBiS.lua` was read and sorted: the ones that
  enumerate a scenario (`SCENARIO_LABEL`, `planScenario`, `nextScenario`, `CHOICES`,
  `CHOICE_LABEL`, `CONTENT_WORD`, `SET_SUFFIX`, `buildPlanIndex`, the data check,
  `keystoneLootWanted` and the set-name loop, which walk `SCENARIO_LABEL`) all know `3t`; the
  rest (`statContext`, the stat pane's switch, `rowHere`, `sidebarRows`, the stat-target loop,
  `offerSetup`, the boss-id check) are a raid-or-Mythic+ split where `3t` is raid and falls
  through correctly. The bag glow, the equipment set names ("DBiS Guardian 3T" is 16), the
  simc export (walks the spec's cells with `pairs`) and the Plan tab's four buttons (ends at
  x=620 in a 900-wide window) need nothing. Script: `Get-BossLoadouts` run against the real
  file answers Feral's ten names and an empty list for Balance and Resto, so a bake for a spec
  with no rows warns, as its comment says; `Read-ExistingCells` keys on `\w+` so a `3t` cell
  survives a re-run; a missing `enemyCount` clamps to 0 and throws rather than filing. All
  three checks green before and after. The fourth criterion is now ticked end to end:
  `plannedTalents` returns nil for a cell with no or an empty string (checks under the
  `a cell without talents marks nothing` name), `activeLoadoutName` passes that nil to
  `talentsEdited`, which returns nil without a read, `loadoutState` then judges by name and
  `sidebarRows` marks "edited" only on a truthy `edited`. Found and fixed in place, comments
  only: three that still said "three buttons" / "row of three" / "the 1 and 2 target rows",
  and the HANDOVER's key-files line that named two scenarios. Security: the weakest point is
  `Get-BossLoadouts` trusting the target file's `PlanTab.BOSSES` block by regex, which is the
  author's own file at author time; the unchecked path is `enemyCount` from a Raidbots JSON
  the author chose to fetch, cast to int and clamped, so a bad value throws and writes
  nothing; nothing leaks, the script prints a loadout name Rob typed into Raidbots himself.
  No UI could be looked at here (no client), so this goes to human-review for the two looks
  already listed under "What I need from you", plus one more: the strip's 90-wide button with
  "3+ targets" on it, which is one glyph wider than "2 targets" was.
