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
<!-- AC:END -->

## Tasks

- [x] Pool size per spec with `EJ_SetLootFilter(classID, specID)` and the loot list, once, out of
  combat, cached for the session. The card's `C_EncounterJournal.SetLootFilter` does not exist;
  the global is what `Blizzard_EncounterJournal.lua` calls, checked in `wow-ui-source`.
- [x] Chance = planned items in the pool / pool size.
- [x] Offline checks under the names above.

## What I need from you

Open `/bis`, Plan tab, out of combat, with the Encounter Journal closed:

1. Every raid boss row that has a planned item in some pool ends in "loot spec Feral: N of M" (or
   another spec). The first open may show none: the journal answers the filters asynchronously,
   and a row says nothing until all four specs' pools for that boss are in, so click any boss row
   once or twice and they should be there. If a row never fills after a few clicks, say so: that
   means the client only keeps the last filter's list and the harvest needs a different shape.
2. The picked boss has a grey line under the boss list, "Loot spec Feral before Nek'zali: N of its
   M drops are planned: ..." naming the items. The names should be item names, not "item 271528".
3. Mythic+ and Nymrissa Wavecaller carry no loot spec text. Neither should.
4. Open the Encounter Journal afterwards and check its class and spec loot filter and slot filter
   are as you left them: the harvest puts both back.
5. `/bis test` in the game prints "self-test passed".
6. Open the journal on a Venomous Abyss boss's page, close it, open `/bis` Plan tab, then reopen
   the journal: the page is still that boss and its loot tab lists that boss's loot, not another
   boss's or the whole raid's, and the tier dropdown still says the tier you had. Then open the
   Plan tab with the journal left open on a boss: nothing about the journal changes.
7. Set your loot spec to something other than what a row names, open the Plan tab in combat (a
   training dummy will do): the rows keep what they had and nothing errors.

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
