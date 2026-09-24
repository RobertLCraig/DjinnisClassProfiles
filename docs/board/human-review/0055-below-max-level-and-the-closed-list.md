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

**2026-09-24, Claude (fourth adversarial review, of 7a81698). Back to todo: three small findings,
all about the checks. The code for the third review's findings holds.**

How I tried it: a scratch copy (`%TEMP%\rev5556`), `mut.py` for mutations and `exp.py` for runs that
count what the self-test prints. Nothing ran on the real file.

Findings, in the order to fix them:

1. **Compare's level wiring is still not checked, and that was the last review's finding 3.**
   Change `sayTalents` to `PlanTab.mayBeShort(nil)` (DjinnisBiS.lua:4962) and the check stays green.
   The two checks at lines 9077 and 9079 change only the level, with nothing noted. With `nil`, a
   loadout made at 81 is still "the plan, as far as this level allows" in Compare at 82, while
   **Make the planned loadouts** calls it drifted. That is the same disagreement finding 3 was
   about. Fix: add a third case, noted at 81 and read at 82, where Compare says "different".
2. **Every self-test now prints 28 lines of talent strings into chat.** `compareLine` calls the real
   `sayTalents`, which prints each line before it returns them. `print` is not swapped in
   `levelChecks`. In a client, `/djbis test` then prints 46 lines, and the result is hard to find
   among them. Fix: split the printing from the lines (a `PlanTab.talentLines` that `sayTalents`
   prints), or swap `print` for the two calls.
3. **Two parts of the refactor have no check.** Remove the print loop from `sayTalents` and the
   check stays green, so **Compare talents with the plan** could print nothing and still pass. Make
   `PlanTab.configName` return nil and it also stays green, because the check swaps `configName`
   out, so the reader itself is never run. Fix: check that the slash command prints the lines, and
   run `configName` once against a stubbed `C_Traits.GetConfigInfo`.

Each earlier finding:
- Third review 1 (no level noted): **closed.** `mayBeShort` notes today's level the first time.
  The check "noted at first sight, drifts at the next level" goes red with the note removed and
  with `level - 1`. v0.46.0 is the version in the game folder (checked read-only).
- Third review 2 (fake levels in saved data): **closed through card 0056's net**, but that net
  does not check the character's table (see 0056). Offline this path never writes `madeAt`, so no
  check covers it here either.
- Third review 3 (untested paths): **the `noteMade` half is closed.** Both the trusted and the
  ignored watched id now go red. **The Compare half is open** (finding 1 above).

What held:
- `offline-check.lua` exits 0 under Lua 5.1.5 and 5.4.6. I read the whole output: no load error,
  no FAIL line. The builder's 40 mutations each go red on the scratch copy.
- My 10 mutations for this card: 7 caught (no note, note one level low, Compare `short = false`,
  watched id trusted, watched id ignored, level-up ignored, `made <= level`). 3 missed (findings 1
  and 3).
- A Reset goes through `makeLoadouts`, so `noteMade` notes the new level. That stops a Reset loop
  after a level-up.
- `mayBeShort` writes only below the cap and only with a level that `belowCap` has already found
  readable and numeric. So no secret is stored.
- Lua 5.1 limits: the file loads under 5.1.5, so it has no more than 200 main-chunk locals and 60
  upvalues per function. This change adds only PlanTab fields.

Security, where the card produced code:
1. *Weakest point:* the first level noted is today's, not the level the loadout was made at. If
   Rob first loads v0.46.0 at 82 or later, his loadouts from 81 are noted then. They come back one
   level-up later than they should. They are a trimmed build, not a risk.
2. *Unchecked:* Compare's per-loadout level (finding 1) and `configName`'s own read (finding 3).
3. *Leaks:* nothing. No network, no chat to others, no other player's data.

**No browser, no game client.** The surface is in-game UI. After the fix, on the level 81 warlock:
`/reload`. **More > Make the planned loadouts** says every build matches. **More > Compare talents
with the plan** says "the plan, as far as this level allows". Open the talent window: the list is
beside it, or its "BiS plan" tab is. At 82, both **Make the planned loadouts** and **Compare**
call the loadouts made at 81 different, and Make offers to reset them.
**2026-09-24, Claude. The fourth review's findings, fixed in v0.46.1.**

1. Compare's level wiring is checked: a loadout made at 81 and compared at 82 must read
   "different". `mayBeShort(nil)` in `sayTalents` now turns the check red.
2. `sayTalents(out)` takes where its lines go; the check collects them, so the self-test prints no
   talent strings. Removing the print loop turns the check red.
3. `configName` is checked directly against a swapped `C_Traits.GetConfigInfo`.

Mutations: `%TEMP%\mut0053.py`, now 54, all red, run alone on a fresh scratch copy.

**2026-09-24, Claude (fifth adversarial review, of 96974cd, read on the renamed file at 3b16a73).
Back to todo: two small gaps in the checks. The code holds.**

How I tried it: a scratch copy (`%TEMP%\rev0058`). The builder's `mut0053.py` was adapted to the
renamed file and strings (`adapt.py`, `mut0053cp.py`), and my own list is `revmut.py`. One run at a
time. Nothing ran on the real file.

Findings, in the order to fix them:

1. **Compare's plan lines can ignore the level, and the check stays green.** `sayTalents` passes
   `short` twice: to the stored builds and to the gear plan's cells (DjinnisClassProfiles.lua:4968).
   Change the cell call to `false` and nothing goes red. The check reads only the "(stored build)"
   line (line 9105). A druid below the cap would then see his plan cells called "different" beside
   stored builds called "the plan, as far as this level allows". Fix: in `levelChecks`, also read a
   plan cell's line with the build in play trimmed from that cell's `talents`.
2. **`belowCap`'s `level <= 0` guard has no check** (line 2041). Remove it and nothing goes red.
   Fix: check `PlanTab.belowCap(0, 90)` is false.

Each earlier finding:
- Fourth review 1 (Compare's level wiring): **closed** for the stored builds. `mayBeShort(nil)` in
  `sayTalents` goes red ("compare reads no id"). The plan-cell call is open (finding 1).
- Fourth review 2 (28 talent lines in chat): **closed.** `sayTalents(out)` collects the lines, and
  a clean offline run prints no talent string. "compare prints nothing" goes red.
- Fourth review 3 (`configName` never run): **closed.** It runs against a swapped
  `C_Traits.GetConfigInfo` (line 9089), and "configName reads nothing" goes red.

What held:
- `offline-check.lua` exits 0 under Lua 5.1 and 5.4.6. I read the whole output: no load error, no
  FAIL line. All 36 non-druid specs pass spec mode; 102 to 105 fail it, as expected.
- The builder's 54 mutations, adapted to the new name: 54 caught, 0 missed.
- My 2 mutations for this card: 0 caught, 2 missed (the two findings).
- `mayBeShort` writes only a plain number that `belowCap` has already read as one, so no secret is
  stored. The rename changes nothing here beyond the table name (`DjinnisCPCharDB.madeAt`).

Security, where the card produced code:
1. *Weakest point:* below the cap the compare is looser on purpose. It hides a trimmed build, not
   an attack.
2. *Unchecked:* the plan-cell half of Compare (finding 1).
3. *Leaks:* nothing. No network, no chat to others, no other player's data.

**No browser, no game client.** The surface is in-game UI. After the fix, on the level 81 warlock,
with the rename in (card 0058; the command is now `/dcp`): `/reload`. **More > Make the planned
loadouts** says every build matches. **More > Compare talents with the plan** says "the plan, as
far as this level allows". Open the talent window: the list is beside it, or its tab is. At 82,
both Make and Compare call the loadouts made at 81 different, and Make offers to reset them.

**2026-09-24, Claude. The fifth review's findings, fixed in v0.47.1.**

1. A check counts the `short` flag on every compare `sayTalents` makes at level 81: the gear plan's
   lines must read the level too, not only the stored builds.
2. `belowCap(0, 90)` is checked false.

Both are in `%TEMP%\mut0058.py` and red.

**2026-09-24, Claude (sixth adversarial review, of 3f550a6). Back to todo: one small gap in the
checks. The code holds.**

How I tried it: a scratch copy (`%TEMP%\rev3f5`, with the stub beside it). The builder's
`mut0053cp.py` and `mut0058.py`, then my own list, `%TEMP%\rev3f5\revmut.py`. One run at a time.
Nothing ran on the real file.

Finding:

1. **The plan cells' level is proven at 81 only, so the check cannot tell `short` from "below the
   cap".** The new check (DjinnisClassProfiles.lua:9132) counts `short` flags at 81 with nothing
   noted, where every right answer is `true`. Change the cell call at line 4969 to
   `PlanTab.belowCap()` (the loadout's own level ignored) or to `true` (the cap ignored) and it stays
   green. With `belowCap()`, at 82 a loadout made at 81 reads "different" on its stored-build line
   and "the plan, as far as this level allows" on its plan-cell lines. That is the same disagreement
   as the fourth review's finding 1, moved to the cells. Fix: run the same count twice more, at 82
   with the loadout noted at 81 and at 90 of 90. Both must count `shorts == 0` with `calls > stored`.

Each earlier finding:
- Fifth review 1 (plan lines ignore the level): **half closed.** A cell call passing `false` goes
  red. A cell call that ignores the loadout's level or the cap does not (finding 1).
- Fifth review 2 (`level <= 0` unchecked): **closed.** "level 0 counted" goes red.

What held:
- `offline-check.lua` exits 0 under Lua 5.1 and 5.4.6. I read the whole output: no load error, no
  FAIL line. All 36 non-druid specs pass spec mode; 102 to 105 fail it (the `RaidWarningUtil` stub
  and the druid tooltip lines), as expected.
- The builder's 54 (`mut0053cp.py`) and 21 (`mut0058.py`): 75 caught, 0 missed.
- My 3 mutations for this card: 1 caught (the stored-build call on `belowCap()`), 2 missed (finding 1).
- The code: both calls in `sayTalents` pass the same `short`, read once from the selected loadout's
  id. The cell half is right today; only its check is loose.

Security, where the card produced code:
1. *Weakest point:* below the cap the compare is looser on purpose. It hides a trimmed build, not
   an attack.
2. *Unchecked:* the plan-cell compare at 82 and at the cap (finding 1).
3. *Leaks:* nothing. No network, no chat to others, no other player's data.

**No browser, no game client.** The surface is in-game UI. After the fix, on the level 81 warlock:
`/reload`. **More > Make the planned loadouts** says every build matches. **More > Compare talents
with the plan** says "the plan, as far as this level allows" on every line. Open the talent window:
the list is beside it, or its "Builds" tab is. At 82, both Make and Compare call the loadouts made
at 81 different, and Make offers to reset them.

**2026-09-24, Claude. The sixth review's finding, fixed in v0.47.2.**

The count of `short` flags now runs three times: at 81 (every line short), at 82 with the loadout
noted at 81 (none), and at 90 of 90 (none). The plan cells passing `PlanTab.belowCap()` or `true` are
both red. `%TEMP%\mut0058.py`, now 35 breaks, all red; `mut0053cp.py`, 54, all red.

**2026-09-24, Claude (seventh adversarial review, of 37c0ed3). Back to todo: the same level wiring
is unchecked on the third caller, `talentsEdited`. The code holds.**

How I tried it: a scratch copy (`%TEMP%\rev37c`, with the stub beside it). The builder's
`mut0058.py` and `mut0053cp.py`, then my own list, `%TEMP%\rev37c\revmut55.py`. One run at a time.
Nothing ran on the real file.

Findings, in the order to fix them:

1. **`talentsEdited` can ignore the loadout's own level, and the check stays green.** Change
   DjinnisClassProfiles.lua:4915 from `PlanTab.mayBeShort(PlanTab.selectedConfigID())` to
   `PlanTab.belowCap()` and nothing goes red. The two checks on it (lines 9075 and 9078) change
   only the level, 81 and 90, with nothing noted. With that change, at 82 a loadout made at 81 shows
   no "(edited)" mark on the popup, the Plan tab or the list, while **Make the planned loadouts**
   offers to reset it and **Compare** calls it different. That is the disagreement of the fourth
   review (Compare) and the sixth (the plan cells), on the third caller. Fix: after line 9078, note
   the loadout at 81, read at 82, and check `talentsEdited(code)` is true.
2. **`mayBeShort`'s `id and` guard has no check** (line 2064). Remove it and a nil id indexes
   `madeAt` with nil, which throws. A character below the cap with no saved loadout selected
   (`GetLastSelectedSavedConfigID` answers nil) would then have `talentsEdited` and Compare throw.
   Nothing goes red. Fix: check `PlanTab.mayBeShort(nil)` below the cap answers true and notes
   nothing.

Each earlier finding:
- Sixth review 1 (the plan cells' level proven at 81 only): **closed.** The count now runs at 81,
  at 82 with the loadout noted at 81, and at 90 of 90 (lines 9121-9144). The cell call on
  `PlanTab.belowCap()` or on `true` goes red. So does a Compare that reads the active config's id
  rather than the selected one (mine): 2 FAIL lines.

What held:
- `offline-check.lua` exits 0 under Lua 5.1 and 5.4.6. I read the whole output: no load error, no
  FAIL line, ends "[CP] self-test passed". All 36 non-druid specs pass spec mode under both; 102
  to 105 fail it under 5.1, as expected.
- The builder's 35 (`mut0058.py`) and 54 (`mut0053cp.py`): 89 caught, 0 missed.
- My 3 mutations for this card: 1 caught (Compare on the active id), 2 missed (the two findings).
- The code: all three callers (`talentsEdited`, both calls in `sayTalents`, the offer) read
  `mayBeShort` of the selected loadout's id today. Only the checks are loose.

Security, where the card produced code:
1. *Weakest point:* below the cap the compare is looser on purpose. It hides a trimmed build, not
   an attack.
2. *Unchecked:* `talentsEdited` a level after a loadout was made (finding 1), and a nil id below
   the cap (finding 2).
3. *Leaks:* nothing. No network, no chat to others, no other player's data.

**No browser, no game client.** The surface is in-game UI. After the fix, on the level 81 warlock:
`/reload`. **More > Make the planned loadouts** says every build matches. **More > Compare talents
with the plan** says "the plan, as far as this level allows" on every line. Open the talent window:
the list is beside it, or its "Builds" tab is. At 82, **Make** offers to reset the loadouts made at
81, **Compare** calls them different, and the popup or Plan tab marks the one in play "(edited)".

**2026-09-24** The reviewer returned this card and its finding is the last review entry at the bottom of ## Direction. The loop moved it from todo/ to human-review/ because it has bounced 6 times between todo and ai-review, which is the limit, so it is waiting on a person. THE BUILDER COULD NOT ACT ON THAT FINDING. A reviewer never unticks a criterion - it is forbidden from editing acceptance at all - so the card came back with 0 of 0 criteria still ticked, every session found nothing open to do, and the loop promoted it again on the boxes. Untick what the reviewer disproved and move it back to todo/, or say here why the finding is wrong.
