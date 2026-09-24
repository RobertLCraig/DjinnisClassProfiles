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
