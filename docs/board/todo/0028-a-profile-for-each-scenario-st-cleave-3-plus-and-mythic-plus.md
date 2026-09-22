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
- [ ] WHEN a report simmed at three or more enemies is baked, THE SCRIPT SHALL fill the spec's `3t` cell with gear, stat targets, loadout and talents. proves: `a 3+ target report fills the 3t cell`
- [ ] WHEN the strip's scenario button is pressed in a raid, THE ADDON SHALL cycle 1 target, 2 targets, 3+ targets, 1 target. proves: `the scenario button reaches 3+ targets`
- [ ] WHEN a boss row names scenario `3t`, THE PLAN TAB SHALL draw that cell's gear and build for it. proves: `a 3t boss row draws the 3t cell`
- [ ] WHEN a cell has no `talents` string, THE ADDON SHALL show no build for it and mark nothing edited. proves: `a cell without talents has no planned build`
<!-- AC:END -->

## Tasks

- [ ] `3t` in `SCENARIO_LABEL`, `nextScenario`, `planScenario`, the bag and stat readers, the
  self-test's scenario loops.
- [ ] `update-gear-plan.ps1`: `$SCENARIOS` 3 and above, `$SCENARIO_ORDER`, self-test.
- [ ] Offline checks under the names above.

## What I need from you

Four Raidbots Top Gear runs per spec Rob plays, one per scenario, each on the loadout that
scenario should use. The 2-target cells have gear today but no build: re-bake them on the right
loadout. For the 3+ runs, the loadout name to sim on (none in `BOSSES` today is a 3+ build).
Then `.\update-gear-plan.ps1 <report ids>` and a `/reload`.

## Comments

- 2026-09-22 Claude: written from Rob's Option A answer. The addon side is one agent's build;
  the sims are Rob's trips.
