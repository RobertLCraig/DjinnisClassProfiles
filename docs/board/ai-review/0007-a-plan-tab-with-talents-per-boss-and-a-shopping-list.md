---
not_for_the_loop: Rob, 2026-09-21: building DjinnisBiS by hand in a session on msiraider
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
needs: 0004
---
# 0007 A Plan tab: talents per boss, and a shopping list

## Why

Two parts of the 2026-09-21 advice have nowhere to live in the game. **Talents:** the best Feral
build differs by boss. The saved "DotC Raid ST *" loadout is best on one target, while Dreamgrove's
Twin Fangs build sims 18% higher than it on two targets (Raidbots report `woaue4bCT5xSu46yWFoL7W`).
Rob has to remember which loadout goes with which boss. **Enchants and gems:** the plan's rings
need Eyes of the Eagle and a haste gem he did not have, and there is no list of what to buy.

What it costs: the wrong loadout on a boss is worth up to 18% on its own; a missing enchant stays
missing until somebody reads his sheet.

How it came to be: the per-boss builds only appeared on Dreamgrove on 2026-09-18, and the plan data
did not exist in the game until card `0004`.

## Links

- Needs `0004`: the plan table, which carries the loadout per scenario and the planned enchant and
  gem ids.
- `DjinnisDreamgrove` (`C:\Dev\WoWAddons\DjinnisDreamgrove`) already imports Dreamgrove builds as
  Blizzard loadouts; its `Data.lua` was last generated 2026-09-02 and every Feral build has changed
  since. This card names loadouts; refreshing that addon is its own card there.

## Not this card

- Applying a talent loadout. **An addon must not call `C_ClassTalents.LoadConfig` or
  `CommitConfig`**: DjinnisBiS card `0002` found ClassCodex doing so from insecure code, the known
  route to action bars that stop updating in combat. This tab tells Rob which loadout to pick; he
  clicks it.
- Glows (`0005`, `0006`). Consumables. An equip button.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the Plan tab is open, THE ADDON SHALL list each boss of the current raid with the planned loadout name and scenario for the current spec. proves: `plan tab lists a loadout per boss for the spec`
- [x] WHEN the active loadout's name differs from the planned one for the boss selected in the tab, THE ADDON SHALL show the planned name in red. proves: `loadout mismatch is flagged by name`
- [x] WHEN any planned slot lacks its enchant or gem, THE ADDON SHALL list each missing enchant and gem once, by name, with a count. proves: `shopping list counts each missing enchant and gem once`
- [x] WHEN nothing is missing, THE ADDON SHALL say "Nothing to buy". proves: `empty shopping list says nothing to buy`
<!-- AC:END -->

## Tasks

- [x] Boss-to-scenario table per spec in the generated plan block (from Dreamgrove's per-boss builds).
- [x] Active loadout name via `C_ClassTalents` read-only calls.
- [x] Tab in the existing `/bis` window beside Stats.
- [x] Offline checks under the names above.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md` and cards `0002` and `0004`.

The boss-to-build mapping for Feral is on `https://dreamgrove.gg/blog/feral/compendium` (updated
2026-09-18): one build per boss, with its hero tree. A 2026-09-21 session extracted all 17 Dreamgrove
strings with labels to `C:\Users\r\AppData\Local\Temp\sims\builds.txt`; that is a temp folder, so
re-extract if it is gone. Balance had not changed since 2026-09-01.

Check every talent API against `C:\Dev\WoWAddons\wow-ui-source\` and use read-only calls only:
the active config id, its loadout name, and the saved configs list.

Deploy: `C:\Dev\WoWAddons\bin\deploy.ps1 -WhatIf -Only DjinnisBiS`, then without `-WhatIf`.

## Comments

- 2026-09-21 Claude: card written from the same session as `0004`. The talent and enchant advice it
  carries is in `C:\Users\r\OneDrive\Desktop\SecondBrain\outputs\2026-09-21 Raid DPS as Feral or
  Balance.md`. Nothing is built yet.
- 2026-09-21 Claude: built at v0.16.0 (`bc3b651`) and deployed. `lua offline-check.lua` passes, and
  a copy broken on purpose in four places failed all four named checks, so the checks can fail.
  **No frame has been seen in a client.** Four things differ from the plan above:
  1. **The boss table is outside the generated block**, straight after its END marker, and is kept
     by hand. `update-gear-plan.ps1` rewrites the block from Raidbots reports and a boss list is
     not in a report, so inside the block it would be deleted on the next run.
  2. **The loadout names are the ones DjinnisDreamgrove imported on 2026-09-02**, because those are
     what exist in the game to click. The hero tree per boss follows Dreamgrove's 2026-09-18 page.
     The newer per-boss builds have no loadout yet; when that addon is refreshed, change the names
     in `PlanTab.BOSSES`.
  3. **Enchant names are a hand table**, `PlanTab.ENCHANT_NAME`. The game has no call from an
     enchant id to a name (checked in `wow-ui-source`). Names came from
     `raidbots.com/static/data/live/enchantments.json`. An id not in the table prints as
     `enchant 1234`.
  4. **Rob's screenshots mid-build: "7 slots to fix" did not say which slots or what to do.** So the
     tab also lists each slot to change, and the strip under the character sheet now says "Click
     for the list" and opens this tab. That touches `0005`'s strip, text and one click only.
  A planned piece that is not worn is left out of the shopping list, and the tab says so, because
  the bag copy may already carry its enchant.
  **Trap for the next card:** `DjinnisBiS.lua` is at Lua's limit of 200 top-level locals. The first
  build would not load. Everything new went into one `PlanTab` table. Add to a table, not a local.
