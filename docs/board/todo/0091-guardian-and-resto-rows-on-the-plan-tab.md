# 0091 Guardian and Resto rows on the Plan tab, so their gear plans show

## Why

Rob decided on 2026-10-11 (card `0028`) that every druid spec gets a gear plan. Once the Raidbots
runs are baked, Guardian and Restoration will have plan cells, but the Plan tab will not show them.
`PlanTab.lines` draws the tab from `PlanTab.BOSSES`, which has rows for Feral and Balance only, so
as Guardian or Resto the tab says "No boss plan for Guardian yet. Only Feral and Balance have one."
The strip under the character sheet and the bag glows read the cells directly and do work.

What it costs: the Plan tab, the place the gear list, the shopping list and the Talents button
live, is blank for two of the four specs the plan is being simmed for.

How it came to be: the rows were written when only Feral had a plan, and Balance gained rows for
its builds (card `0064`). Guardian and Resto have two builds each, `Raid` and `Dungeon`, and no rows.

## Links

**Relates to**
- `0028` - the decision that makes these cells exist, and the twelve Raidbots runs that fill them.

## Not this card

- The sims themselves (card `0028`).
- One row per boss. One raid row and one Mythic+ row each is what their builds support.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN the player is Guardian or Resto, THE PLAN TAB SHALL list a raid row on the `Raid` loadout and a Mythic+ row on the `Dungeon` loadout, and draw that row's cell. proves: a new check in the Plan tab checks, run as Guardian and as Resto
- [ ] WHEN a spec's row names a scenario with no baked cell, THE PLAN TAB SHALL say so, as it does for Feral's empty cells. proves: `missing mplus plan is said, not filled from raid`
- [ ] WHEN Rob opens the Plan tab as Guardian and as Resto after `/reload`, THE TAB SHALL show the rows and, once baked, the gear. proves: manual
<!-- AC:END -->

## Tasks

1. Add `Guardian` and `Resto` to `PlanTab.BOSSES` in `DjinnisClassProfiles.lua`: rows for the raid
   bosses on `Raid` (scenario `st`) and `{ boss = "Mythic+, any key", scenario = "mplus", loadout = "Dungeon" }`.
   Read the Balance comment first: `update-builds.py` pools each row's bosses, so run
   `python update-builds.py --check` after and say what it reports.
2. Update the "Only Feral and Balance have one" sentence in `PlanTab.lines`.
3. `"C:\Program Files (x86)\Lua\5.1\lua.exe" offline-check.lua`, and spec modes 104 and 105 (each fails 5 lines today, card `0075`; no new ones).

## Comments

**2026-10-11** Raised in the clear-down (attended, Rob asked) while writing card `0028`'s Raidbots list.
