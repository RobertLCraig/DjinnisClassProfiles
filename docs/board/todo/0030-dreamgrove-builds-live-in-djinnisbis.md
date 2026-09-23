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

## Not this card

- Creating the loadouts in the game. That is `0031`.
- Retiring DjinnisDreamgrove. That is `0035`.

## Acceptance

- [ ] WHEN the generator runs, THE SCRIPT SHALL refuse to write if a picked build is missing from a compendium page, or decodes to the wrong spec.
- [ ] WHEN a boss row has a `talents` string, THE ADDON SHALL treat it as the planned build for that boss.
- [ ] `/bis test` covers `plannedTalents` for a boss row with and without its own string.
- [ ] The build decodes to 34 class, 34 spec and 13 hero points for every row (`choices.py` check, carried over).
