# 0030 Dreamgrove's builds live in DjinnisBiS, one per boss and spec

## Why

Rob, 2026-09-23: "DjinnisBiS, using Dreamgrove's builds. I would actually suggest we merge them and
remove DjinnisDreamgrove going forward." Two addons picking talents per boss disagreed: the boss
table here names DjinnisDreamgrove 0.6.0 loadouts (`WS Raid Most Bosses`, `DotC Raid ST *`), and
Dreamgrove 0.7.0 renamed them `Raid: <boss>`. Running `/dg tidy` today would orphan this table.

Dreamgrove itself moved Feral to one build per boss on 2026-09-18; six of nine bosses are now
Wildstalker.

## What

- The generator in `C:\Dev\WoWAddons\.dreamgrove-tmp\` (`extract.py`, `gen_data.py`) moves into
  this repo as author tooling beside `update-gear-plan.ps1`, and writes a `BEGIN GENERATED BUILDS`
  block into `DjinnisBiS.lua` the way the gear plan block is written.
- Every row of `PlanTab.BOSSES` gets its own `talents` string and a `build` name, for all four
  specs, not only Feral. Names are the ones Rob accepted in Dreamgrove 0.7.0: `Raid: <boss>`,
  `Dungeon`, `Dungeon: <when>`.
- `PlanTab.plannedTalents` answers for a boss row first and falls back to the scenario cell.
  The gear plan cells keep their simmed `talents`; they say which build the gear was simmed on.

## Built, v0.26.0, 2026-09-23

- `update-builds.py` fetches the four compendiums with `gh api` and Raidbots' `talents.json`,
  checks every build is its own spec with 34 / 34 / 13 points, and writes `PlanTab.BUILDS`.
  28 builds.
- `PlanTab.buildFor(spec, name)` is the one lookup: Dreamgrove's build for the name, else the
  gear cell simmed under it. The Plan tab, the sidebar, the "edited" mark, Hindsight's
  last-pull line, the /simc export and the setup prompt all go through it or the rows.
  `plannedTalents` is left for the gear cells, which is what it always described.
- Feral rows renamed to one build per boss. **Balance got rows too.** Ula'tek has no Balance
  build in the guide, so its row borrows `Raid: Vashnik`, marked uncertain in the code.
- **Guardian and Resto have no rows.** The guide gives two raid builds each and does not say
  which fits which boss. That is Rob's pick.
- The setup prompt now offers the scenario's first boss row's loadout (Mythic+: `Dungeon`),
  not the gear cell's simmed name, so the prompt and the Plan tab agree.
- `lua offline-check.lua`: self-test passed, with new checks that every row has a stored
  build and that `buildFor` prefers Dreamgrove's.

**To look at in a client.** `/reload`, then open the Plan tab as Feral and as Balance. Each
boss row names a `Raid: <boss>` loadout. Those loadouts exist only if DjinnisDreamgrove 0.7.0
already imported them; if not, the rows show and the Talents button says the name is not
saved. Card `0031` makes them.

## Not this card

- Creating the loadouts in the game. That is `0031`.
- Retiring DjinnisDreamgrove. That is `0035`.

## Acceptance

- [ ] WHEN the generator runs, THE SCRIPT SHALL refuse to write if a picked build is missing from a compendium page, or decodes to the wrong spec.
- [ ] WHEN a boss row has a `talents` string, THE ADDON SHALL treat it as the planned build for that boss.
- [ ] `/bis test` covers `plannedTalents` for a boss row with and without its own string.
- [ ] The build decodes to 34 class, 34 spec and 13 hero points for every row (`choices.py` check, carried over).
