# 0055 Below max level a loadout is the plan as far as it can be, and a closed list comes back

## Why

Rob, 2026-09-24, on a level 81 Warlock:

- "Reset to plan" made the same loadout again on every click ("Making 1 loadout ... Made 1 of 1",
  three times in 30 seconds). Below the level cap the game saves only the part of a build the
  character can hold: fewer points, and each spec's apex node (a `Tiered` node) opens its ranks at 81,
  84 and 90 (`rankLevels` in Raidbots' talents.json). The fresh loadout never matched the plan, so it
  read as drifted forever. The strings themselves are clean: no stored build buys a free node or has
  a bad rank or choice (checked with `%TEMP%\free_check.py`).
- "the side panel next to the talent window has disappeared and I cant see how to get it back".
  `updateSidebar` placed the frames only when the list was open. A list closed on another character
  (`sidebarClosed` is account-wide) and built closed on this one had a "BiS plan" tab with no anchor,
  so it was never drawn.

## What

- `PlanTab.partOfPlan(have, planned)`: every node the loadout buys is in the plan, with the same
  choice and no more ranks. `PlanTab.planDiffers(have, planned, short)` uses it when `short`.
- `PlanTab.belowCap()`: `UnitLevel("player") < GetMaxLevelForPlayerExpansion()`, false when either
  cannot be read. `loadoutGaps` (offer, Create, Reset) and `talentsEdited` pass it. At the cap a
  loadout must match exactly, as before. After a level-up the trimmed loadout reads as drifted
  again, so Reset makes the fuller one.
- `updateSidebar` places the frames in "tab" mode too. More sits 6 pixels from the close button.
  The window's More menu has "Show the build list" while the list is closed.

## Acceptance

- [x] Part of the plan is the plan below the cap, and not at it; an added node or another choice is still drifted. proves: self-test "below the level cap, part of the plan is the plan"
- [x] The tab is placed when the list is closed. proves: self-test "sidebar stays closed, the tab is placed when the list is closed"
- [x] "Show the build list" is in the window menu only while the list is closed. proves: self-test `menuChecks`
- [x] Mutations: level trim off, the cap ignored in gaps, more ranks allowed, another choice allowed, the tab not placed, no menu item. Each turns the offline check red (`%TEMP%\mut0053.py`).
- [ ] In game, on the level 81 Warlock: `/reload`. The loadout offer does not list the loadouts it already made. Open the talent window: the list is beside it, or its "BiS plan" tab is. proves: manual (Rob)

## Not this card

- The sidebar's green tick (`sidebarList`) still compares exactly, so below the cap no row may show
  the tick. Cosmetic; say if it matters.
- "Dungeon" is selected on the Warlock, so Reset leaves it; it now reads as the plan anyway, as long
  as it is part of it.

## Comments

**2026-09-24, Claude.** Built in v0.44.0, deployed. Offline check green under Lua 5.1 and 5.4; all 36
non-druid specs pass spec mode. Rob confirmed the level: "I am currently on an 81 warlock".

**2026-09-24, Claude (adversarial review of 5d86315). Back to todo: four findings.**

Findings, in the order to fix them:

1. **A level-up does not make the trimmed loadout drift again, whatever `## What` says.** `partOfPlan`
   asks only "is every node it buys in the plan". A loadout made at 81 is still a subset of the plan
   at 82, 84 and 89. So from 82 to 89 Reset never offers the fuller build. It only offers it at the
   cap. A loadout with no nodes at all is also "part of the plan" below the cap (the check
   "no nodes at all" is `true` on purpose). So an import that bought nothing reads as the plan. Fix:
   remember the level each loadout was made or reset at, per character and keyed by config id. Treat
   one made below today's level as drifted. Or ask `C_Traits.GetTreeCurrencyInfo(configID, treeID,
   false)` (it exists in 12.1.0, SharedTraitsDocumentation.lua:474) whether it has points left
   unspent. Then fix the sentence in `## What`. The source cannot say whether the game fills an
   imported loadout by itself on level-up. If you rely on that, it goes on Rob's list, not in the
   card as a fact.
2. **`belowCap` is never tested, so the answer to "can this hide a hand edit at max level" rests on
   one `<`.** The harness has no `UnitLevel` or `GetMaxLevelForPlayerExpansion`, so offline
   `belowCap()` is always false. My mutations (`%TEMP%\rev0055.py`, run on a scratch copy) all stay
   green: `belowCap` always true, `level <= cap`, the `canRead` guard removed, `talentsEdited` back
   on `talentStringsDiffer`, and `createMissing`, `resetDrifted` or `offerLoadouts` passing `false`.
   Fix without swapping Blizzard globals: make the rule pure, `PlanTab.belowCap(level, cap)`, with
   the reads behind a PlanTab field. Check 81/90 true, 90/90 false, a secret level false and a
   missing API false. Then swap `PlanTab.belowCap` to return true in the loadout checks and show
   that `offerLoadouts` does not list a trimmed loadout and `talentsEdited` does not call it edited.
3. **"Compare talents with the plan" still says "different" for every build on Rob's warlock.**
   `sayTalents` (a More menu item since 0053) calls `talentStringsDiffer`. So right after Reset makes a
   trimmed loadout, and the offer calls it the plan, this item calls the same loadout different. Use
   `planDiffers(..., PlanTab.belowCap())`. When it is part of the plan, say "the plan as far as this
   level allows" rather than "same". `pullSpec` (Hindsight) and the sidebar tick also still call
   `talentStringsDiffer`. The tick is listed under `## Not this card`. `pullSpec` is druid raid pulls,
   so leave it.
4. **A plan that buys part of an apex node may still drift forever below 84 or 90.** Blizzard's export
   writes a node as "all ranks" when `ranksPurchased == maxRanks`
   (Blizzard_ClassTalentImportExport.lua:78). `TraitNodeInfo` has both `maxRanks` and
   `totalMaxRanks` (added 12.0.1), and the capstone's `IsMaxed` uses `totalMaxRanks`
   (Blizzard_TalentButtonTierTrackTemplates.lua:322). So `maxRanks` is very likely the cap for the
   character's level: 1 at 81, 3 at 84 (Raidbots `rankLevels`). If so, a level 81 loadout with the
   apex at 1 exports `m`, and `partOfPlan` rejects `m` against a plan with a number. Three stored
   builds have that, decoded against talents.json: Outlaw `Dungeon` (Gravedigger 1 of 4, line 593),
   Windwalker `Raid` (Tigereye Brew 3 of 4, line 665) and Devastation `Dungeon` (Rising Fury 1 of 4,
   line 680). None is Rob's warlock: all six warlock builds take the apex whole (`m`), which the code
   allows. Fix: below the cap, let `m` stand against a number. The import never buys more than the
   plan's ranks, so `m` there means "all this level opens". Add a check.

What held:
- **Tests.** `offline-check.lua` exits 0 under Lua 5.1 and 5.4.6. I read the whole output, and there
  is no load error. All 36 non-druid specs pass spec mode.
- **The builder's 20 mutations** (`%TEMP%\mut0053.py`, on a scratch copy) each turn it red.
- **At the cap nothing is hidden.** `planDiffers(..., false)` is exactly `talentStringsDiffer`, and
  `belowCap` is a strict `<`. A missing API or a secret level returns false (pcall plus `canRead`),
  which falls back to the exact compare. `UnitLevel` has no secret-return flag in
  UnitDocumentation.lua:2385, and `GetMaxLevelForPlayerExpansion` exists (ExpansionDocumentation.lua:131).
- **The import really is a subset.** `ConvertToImportLoadoutEntryInfo` and
  `CreateImportLoadoutEntryInfoFromTieredNode` hand over only the plan's nodes, choices and at most
  its ranks, spread over the tier entries in order. The trimming happens in
  `C_ClassTalents.ImportLoadout` (C code), which can only drop things. Below the cap, a hand edit that
  adds a node or changes a choice still reads as drifted. One that moves points to another node of
  the plan does not, by design.
- **`nodeKey`'s `m`** matches Blizzard's reader: not partially ranked means `maxRanks`. The plan's
  `m` allowing any rank is right for the warlock.
- **The closed list.** `updateSidebar` now places the tab in "tab" mode. The check with a stubbed
  sidebar goes red when that line is reverted. "Show the build list" appears only while the list
  is closed. It does nothing visible with Talent Loadout Manager loaded (`sidebarMode` is "off"),
  which is minor. Gate it on `not PlanTab.rivalLoaded()`.

Security, where the card produced code:
1. *Weakest point:* below the cap the rule is looser on purpose. A loadout with points moved inside
   the plan, or an empty one, reads as the plan. That hides a mistake, not an attack. Nothing here
   takes input from anyone but the player's own client.
2. *Unchecked:* `belowCap`'s two reads (finding 2), and the level API on accounts without the
   current expansion. There `GetMaxLevelForPlayerExpansion` is their lower cap, so the apex never
   opens and the old loop comes back. That is rare, so no card for it.
3. *Leaks:* nothing. No network, no chat to others, no other player's data.

**No browser, no game client.** The surface is in-game UI. After the fix, Rob checks this on the level
81 warlock: `/reload`. **More > Make the planned loadouts** does not offer the loadouts it already
made. **More > Compare talents with the plan** does not call them different. Open the talent window:
the list is beside it, or its "BiS plan" tab is. Close the list, `/reload`, open the talent window
again: the tab is there. Then, at 82 or later, **Make the planned loadouts** offers to fill the
loadouts made at 81.

**2026-09-24, Claude. The second review's findings, fixed in v0.45.0.**

1. A level-up now brings the loadout back. `PlanTab.noteMade` keeps the level each loadout was made
   at (`DjinnisBiSCharDB.madeAt`, config id -> level) once the queue has waited for it.
   `PlanTab.mayBeShort(id)` is false for one made below today's level, so the offer resets it. An
   import that bought nothing is no longer "part of the plan". A loadout made before v0.45.0 has no
   level noted and counts as made now; it drifts at the next level-up after a Reset.
2. `belowCap(level, cap)` is pure; the reads are `PlanTab.readLevels`. `levelChecks` covers 81/90,
   90/90, no level, no cap, a secret level, and drives `offerLoadouts` and `talentsEdited` with a
   trimmed loadout (one node fewer) at 81, after a level-up and at the cap.
3. Compare talents uses `PlanTab.compareWord`, which says "the plan, as far as this level allows"
   for a trimmed build. Its read is `PlanTab.activeTalentString`, shared with `talentsEdited`.
4. `m` stands against a plan's number below the cap: the apex node exports "all ranks" at 81 when the
   plan buys 1 of 4.

Also: "Show the build list" is hidden while Talent Loadout Manager is loaded. Mutations: 31 in
`%TEMP%\mut0053.py`, all red, including every one listed in the review (`<=`, level-up ignored,
`talentsEdited` on the exact compare, the offer passing false, the secret guard removed).

**2026-09-24, Claude (third adversarial review, of 552c380). Back to todo: one finding left open
for your own warlock, and two small ones.**

Findings, in the order to fix them:

1. **Rob's warlock loadouts still never come back on a level-up.** `mayBeShort` treats a loadout
   with no level noted as "may be short" at every level below the cap. Every loadout made before
   v0.45.0 has no level noted. That is all the loadouts on your level 81 warlock, made at 81 in
   v0.44.0. So does one made by hand under a build's name, and one whose id the queue could not
   find. From 82 to 89 none of them is offered a reset, and **Make the planned loadouts** says every
   build matches. Only 90 brings them back. The build comment says one "drifts at the next level-up
   after a Reset", but Reset is never offered for it below the cap, so that never happens. Fix: when
   a planned loadout with no level noted is compared below the cap, note today's level for it then.
   The next level-up then brings it back. Add a check: nothing noted at 81, then drifted at 82.
2. **The self-test writes fake loadout levels into your character's saved data.** With a level the
   game will give (any client), a clean run leaves `DjinnisBiSCharDB.madeAt` with config ids 21, 22,
   23, 24 and 40 at your level. The spare checks run the real queue, and the real `noteMade` finds
   those fake ids by name. Offline this never shows, because the harness has no `UnitLevel`; I
   seeded one to see it (`%TEMP%\rev56\driver.lua`, `REV_LEVEL=81`). It only matters if a real
   config id is that small, which nothing here can say. Fix it with card `0056`'s saved-data fix, or
   swap `PlanTab.madeAt` in `loadoutChecks`.
3. **Two paths have no check.** My mutations stay green when `noteMade` trusts any watched id (the
   name check dropped) and when it ignores the watched id and goes by name only. The spare has the
   same guard and a check for it ("a watched id with another name is not recorded"); copy that. And
   `sayTalents` with `local short = false` stays green, though that call was the last review's
   finding 3. Check that Compare prints "the plan, as far as this level allows" for a trimmed build.

A note, not a finding: `madeAt` is never pruned, so a deleted loadout's id stays. The source cannot
say whether the server ever reuses a config id. If it did, the worst case is one extra Reset, which
notes the new level. Dropping ids that `GetConfigIDsBySpecID` no longer lists is cheap.

Each earlier finding:
- Finding 1 (level-up): **closed for loadouts made from v0.45.0 on**, open for older ones (finding 1
  above). The level is noted after the queue waits, before the next job clears `pendingID`, and the
  last job is noted on the step that ends the queue, also after the 15 second give-up.
- Finding 2 (`belowCap` untested): **closed.** It is pure, with checks for 81/90, 90/90, no level, no
  cap and a secret level, and the offer and `talentsEdited` are driven through it.
- Finding 3 (Compare): **closed in code**, unchecked (finding 3 above).
- Finding 4 (`m` against a number): **closed**, with a check and a mutation.
- The empty import is no longer the plan: closed, checked.

What held:
- `offline-check.lua` exits 0 under Lua 5.1 and 5.4.6. Output read whole, no load error. All 36
  non-druid specs pass spec mode. The builder's 31 mutations each go red on a scratch copy.
- `talentsEdited` and Compare key the level on `GetLastSelectedSavedConfigID`, the saved loadout's
  id. That is the id `noteMade` writes, not the active config's id.
- Only two callers still use the exact compare: `pullSpec` (druid raid pulls, left on purpose) and
  the sidebar tick (under `## Not this card`).

Security, where the card produced code:
1. *Weakest point:* below the cap the rule is looser on purpose, and now for longer (finding 1).
   It hides a stale loadout, not an attack.
2. *Unchecked:* the by-name fallback in `noteMade` when `TRAIT_CONFIG_CREATED` is refused (finding
   3), and test data in the saved variables (finding 2).
3. *Leaks:* nothing. No network, no chat to others, no other player's data.

**No browser, no game client.** The surface is in-game UI. After the fix, on the level 81 warlock:
`/reload`. **More > Make the planned loadouts** says every build matches. **More > Compare talents
with the plan** says "the plan, as far as this level allows", not "different". Open the talent
window: the list is beside it, or its "BiS plan" tab is. Then at 82, **Make the planned loadouts**
offers to reset the loadouts made at 81.
**2026-09-24, Claude. The third review's findings, fixed in v0.46.0.**

1. A loadout with no level noted gets today's level the first time it is compared
   (`mayBeShort`), so Rob's level 81 loadouts come back at 82.
2. The self-test's fake levels no longer stay: card `0056`'s net now writes `DjinnisBiSCharDB` back
   whole after every run.
3. `noteMade` reads the watched id's name through `PlanTab.configName`, and both paths are checked
   (the build's own id, and another name falling back to the list). Compare talents returns its
   lines, and a check reads the level wiring through it: part of the plan at 81, different at 90.

Mutations: `%TEMP%\mut0053.py` has 40, all red. The reviewer's `rev56\revmut.py` ones that still
apply are all red too.