---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0009
---
# 0022 The best loot spec for each raid boss

## Why

A boss drops one item from the pool for your loot spec. The smaller the pool, the better the chance
of a planned item. KeystoneLoot shows this for dungeons ("X has a smaller loot pool than Y") but
not for raid bosses.

## Links

- Needs `0009`: which items each spec plans.
- Uses the Encounter Journal harvest the BiS tabs already have.
- Pairs with `0015`, `0021` (the loot spec button) and `0013` (the popup can name the spec).
- Draws by `0020`'s rules.

## Not this card

- Changing the loot spec by itself.

## Acceptance

<!-- AC:BEGIN -->
- [x] FOR each raid boss with a planned item, THE PLAN TAB SHALL name the loot spec with the best chance of a planned item, and show that spec's planned items and pool size, for example "Guardian: 2 of 5". proves: `plan tab names the best loot spec per boss`
- [x] WHEN two specs tie, THE ADDON SHALL name the current spec if it is one of them. proves: `a tie goes to the current spec`
- [x] WHEN no spec has a planned item from a boss, THE ADDON SHALL show no loot spec line for it. proves: `no loot spec line without a planned item`
- [ ] `/reload` first (the game folder holds v0.69.0). `/dcp`, Plan tab, out of combat, Encounter Journal closed: every raid boss row with a planned item ends in grey `loot spec Feral: N of M`. The first open may show none; click a boss row once or twice and they fill. If a row never fills, say so (the harvest needs another shape). proves: manual
- [ ] The picked boss has a grey line under the boss list, `Loot spec Feral before Nek'zali: N of its M drops are planned: ...`, naming items by name, not `item 271528`. proves: manual
- [ ] The Mythic+ row and Nymrissa Wavecaller carry no loot spec text. proves: manual
- [ ] Open the Encounter Journal after the Plan tab: its class and spec loot filter and slot filter are as you left them. proves: manual
- [ ] Open the journal on a Venomous Abyss boss's page, close it, open the Plan tab, reopen the journal: the same boss page, its loot tab lists that boss's loot, and the tier dropdown is unchanged. With the journal left open on a boss, opening the Plan tab changes nothing in it. proves: manual
- [ ] In combat (a training dummy will do), with a loot spec other than a row names, open the Plan tab: the rows keep what they had and nothing errors. proves: manual
<!-- AC:END -->

## Tasks

- [x] Pool size per spec with `EJ_SetLootFilter(classID, specID)` and the loot list, once, out of
  combat, cached for the session. The card's `C_EncounterJournal.SetLootFilter` does not exist;
  the global is what `Blizzard_EncounterJournal.lua` calls, checked in `wow-ui-source`.
- [x] Chance = planned items in the pool / pool size.
- [x] Offline checks under the names above.

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Comments

- 2026-09-22 Claude: written from Rob's "B" in a SecondBrain session. Ideation only.
- 2026-09-22 Claude: built. `PlanTab.harvestPools` walks the Venomous Abyss encounters once a
  session, `EJ_SelectEncounter` then `EJ_SetLootFilter(classID, specID)` for each druid spec,
  and files the item ids under the dungeon encounter id (`EJ_GetEncounterInfo`'s seventh return,
  the same id `PlanTab.BOSSES` carries for card 0027), so no boss row needed a second id. A
  filter the journal has not answered yet leaves its cell nil and the next draw fills only what
  is missing; `EJ_LOOT_DATA_RECIEVED` clears the done flag as the link harvest already does. The
  pick, `PlanTab.bestLootSpec`, is pure: planned ids over pool size, cross-multiplied, tie to the
  current spec else the first in spec order. Planned ids are the union of every filled cell of a
  spec's gear plan, raid and key alike, so a Guardian plan will count the day one exists. Drawn as
  a suffix on each boss row and one grey line under the picked boss. No new top-level local: the
  instance lookup the link harvest had inline is now `PlanTab.raidInstanceID` and both use it.
  Checks: 17 under the three names, including four against the tab as drawn. `lua
  offline-check.lua` and Lua 5.1 both exit 0. Mutations run on temp copies: dropping the
  `spec == current` tie rule failed exactly the tie check; replacing `if #hits > 0` with `if true`
  failed all five no-line checks. Nothing seen in a client; the five looks are above. Left out:
  Nymrissa Wavecaller is a lair boss in another journal instance, so she has no pool and no line;
  the harvest skips itself while the journal window is open rather than moving the player's
  selection; and no redraw fires on `EJ_LOOT_DATA_RECIEVED`, to keep a stale filter from looping a
  harvest against the event, so the first open may need one click. Not touched: `GetLootSpecialization`
  and any loot spec change, per "Not this card".
- 2026-09-22 Claude (review): pass with two faults fixed in place, to human-review. Attacked
  `cdd77e0` as merged in `158ec38` (the 0023 pull line shares the boss row, resolved right: both
  suffixes draw). Every EJ call checked against `wow-ui-source`: `EJ_GetEncounterInfo`'s seventh
  return is `dungeonEncounterID` (`Blizzard_EncounterJournal.lua:3577`), `EJ_GetLootFilter` gives
  class then spec (line 502), `GetSlotFilter`/`ResetSlotFilter`/`SetSlotFilter` are used the way
  Blizzard's own `GetLootSlotsPresent` uses them (line 522), `EncounterJournalItemInfo.itemID` is
  non-nilable, `EJ_IsLootListOutOfDate` is the flag Blizzard's own `EJ_LOOT_DATA_RECIEVED`
  handler tests (line 1005). The `EJ_*` globals are not in the generated docs at all, so the UI
  source is the only authority. Both offline checks exit 0. Eight mutations on temp copies, all
  red: no tie rule, a spec with no hits drawn, the later spec winning a tie, no row suffix, no
  line under the picked boss, hits counted against another spec's plan, `plannedIds` reading no
  scenario, and the gate below dropped. **Fault 1, fixed:** the journal answers cell by cell, so
  a boss with Feral's pool in and Guardian's still nil drew "Feral: 2 of 10" as the answer when
  Guardian's "2 of 5" was on its way, which sends you to the wrong loot spec for as long as it
  lasts. `bestLootSpec` now returns nil until every spec in `SPEC_ORDER` has a cell; one new
  check under the first name, and the hand-made pools in the checks now carry all four specs.
  **Fault 2, fixed:** the harvest moved the journal's tier, instance and encounter selection and
  put back only the filters. `EncounterJournal_OnShow` rebuilds its loot list from the client's
  selection without reselecting its own page (line 789), so a journal closed on Nek'zali and
  reopened after the Plan tab listed the whole raid's loot, or the last boss harvested, under
  Nek'zali's page. The pass now restores `EJ_GetCurrentTier()` and the journal's own
  `instanceID`/`encounterID` when it has them. The older link harvest had the tier and instance
  half of this before this card; it is left alone as not this card's code. Not fixable offline:
  the harness stubs no `EJ_GetNumTiers`, so `harvestPools` returns on its first line there and
  the walk, the async flag and the restores are looks 1, 4 and 6 above. Held: `InCombatLockdown`
  gate; the open-journal skip; Mythic+ and Nymrissa have no cell so no text; `pcall` round the
  harvest; item names go through `canRead`; `EJ_LOOT_DATA_RECIEVED` was already registered and
  verified by the link harvest. Left as noted, not fixed: pool size is read at the journal's
  current difficulty, and the very rare drops flagged per difficulty may make M differ from N by
  one; and a stale filter is thrown away per cell, so if the client keeps only the last request's
  list the pools fill one cell per draw (look 1 says what to report). Security: weakest point is
  the journal's client-side selection, shared with Blizzard's frame and any other addon, and the
  harvest now leaves it as found; unchecked path is none new, every input is the journal's own
  numbers and the gear plan's ids; on failure it leaks nothing, `pcall` swallows the harvest and
  the row shows no text.

**2026-10-11** Clear-down (attended, Rob asked): ticked 3 criteria, all ticked already and confirmed (checks `plan tab names the best loot spec per boss`; `a tie goes to the current spec`; `no loot spec line without a planned item` exist in `DjinnisClassProfiles.lua` and pass in the Lua 5.1 offline check); looks rewritten for v0.69.0 (`/bis` is `/dcp`, strings checked in the lua); the `/bis test` look dropped as a duplicate: the offline self-test passes in full, and the client-only part of this card is the journal harvest the other looks cover; moves to ai-review/ with only in-game looks open.

### 2026-10-18 review (v20261018191758-c568)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I checked the three ticked criteria against the code. All three hold.

- **#1 (name the best loot spec per boss): met.** `PlanTab.bestLootSpec` in `DjinnisClassProfiles.lua` picks the spec with the highest share of planned items in its pool. It compares by cross-multiplying, so it never compares decimals. `PlanTab.lootSpecText` makes the text "Feral: N of M". The Plan tab draw code adds that text to each boss row. It also adds the grey "Loot spec X before boss" line under the picked boss, and names the items through `PlanTab.itemNames`.
- **#2 (a tie goes to the current spec): met.** In `PlanTab.bestLootSpec`, a later spec wins a tie only if it is the current spec. An earlier tied spec keeps the win only when the current spec is not tied. With no current spec in the tie, the first spec in order wins.
- **#3 (no line without a planned item): met.** If no spec has a hit, `PlanTab.bestLootSpec` returns nil. If any spec's pool is still missing, it also returns nil. Then the row text and the line under the picked boss both draw nothing.

The offline checks under the three names call this real code. I tried to find a bug in the tie logic and the gating, and found none. The six open criteria are `proves: manual`. They wait for Rob to try them in the game.

You do not need to do anything. The card can go to `done/`.

VERDICT: sound

**scope: sound**

**What I checked:** I looked for anything that went past the card's limits.

- **The "Not this card" limit (no loot spec change):** `PlanTab.harvestPools` and `PlanTab.bestLootSpec` in `DjinnisClassProfiles.lua` only read the Encounter Journal and do a calculation. They never change the loot spec. The only code that changes it is `PlanTab.setLootSpec`, which calls `SetLootSpecialization`. That function belongs to card 0015, the loot spec card button, which this card pairs with. This card did not add it.
- **The big diff:** It covers many cards plus a rename from DjinnisBiS to DjinnisClassProfiles. That is the history of the branch, not this card growing. This card's own code is two functions (the harvest and the pick), a suffix on each boss row, and one line under the picked boss. That matches its three tasks.
- **Work left half done:** The builder named three gaps: Nymrissa has no pool, the harvest skips itself while the journal is open, and the first open can need a click. The card's in-game checks say the same things, so they are known, not hidden. They are not unmet criteria.
- **Open criteria:** All six are `proves: manual`. That is not a finding.

I disproved no criterion.

VERDICT: sound

**breakage: sound**

I tried to break it and could not find a fault.

**What I checked:**
- **`PlanTab.bestLootSpec`:** It returns nothing until all four druid specs have a pool. It compares chances by cross-multiplying, so it never compares decimals. On a tie it picks the current spec. If the current spec is not in the tie, it picks the first spec in `SPEC_ORDER`. If no spec has a planned item, it returns nothing, so the boss row gets no text.
- **Spec names:** The names in `PlanTab.SPECS` for class 11 match `SPEC_ORDER` exactly ("Resto", not "Restoration"). So `PlanTab.poolSpecs` saves each pool under the name that `bestLootSpec` looks for.
- **`PlanTab.harvestPools`:** It runs only for druids, only out of combat, and only when the journal is closed. Afterwards it puts back the loot filter, the slot filter, the tier, the instance and the encounter.
- **Callers:** The Plan tab draw and `PlanTab.lootCardModel` (the loot spec card from card 0015) both call `harvestPools` inside `pcall`, so an error there cannot break the tab. The Plan tab passes `PlanTab.POOL[row.id]`. The Mythic+ row and Nymrissa have no pool, so they get no line.
- **Comments:** Comments still match the code after the rename and the all-class change.

The `proves: manual` criteria stay open. Someone must try them in the game. They are not findings.

VERDICT: sound

