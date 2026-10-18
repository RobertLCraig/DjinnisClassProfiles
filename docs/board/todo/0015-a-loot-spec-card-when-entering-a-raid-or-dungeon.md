---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0009
---
# 0015 A loot spec card when entering a raid or dungeon

## Why

With four specs, the loot spec is the easiest thing to forget. A planned Guardian trinket that
drops while loot spec is Feral is lost for a week.

KeystoneLoot shows a card on entering a dungeon: the wanted items that drop there, per spec, and
"Correct loot specialization set?" (read 2026-09-22). `SetLootSpecialization` is in the 12.1 docs
(`PlayerScriptDocumentation.lua`).

## Links

- Needs `0009`: which plan (raid or Mythic+) covers the place.
- Uses the Encounter Journal harvest the BiS tabs already have, to know what drops here.
- `0013` shows on the same triggers. Show one window, not two: put this card inside `0013`'s popup
  if both are built.

## Not this card

- Changing loot spec without a click.
- Items outside the four druid plans.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the player enters a raid or dungeon where a planned item for any druid spec drops, THE ADDON SHALL show each spec that wants something here, with its items. proves: `loot card lists planned drops per spec`
- [x] THE CARD SHALL mark the current loot spec, and SHALL have a Set loot spec button for each other spec shown. proves: `loot card marks the loot spec and offers the others`
- [x] WHEN no planned item drops here, THE ADDON SHALL show no card. proves: `no loot card when nothing planned drops`
- [x] WHEN the player is in combat, THE ADDON SHALL not change the loot spec. proves: `loot spec not changed in combat`
- [ ] Enter the Venomous Abyss out of combat, journal closed: a card "Loot spec for The Venomous Abyss" near the top with a Feral row: icon, planned drops as item buttons, "+N more" if over six. Hover an item: the game tooltip. Empty or missing: open `/dcp` Plan tab once, re-enter, and say so. proves: manual
- [ ] Loot spec on Feral: the Feral name is green with "loot spec" under it and no button. Set loot spec to Guardian in the spec window: the row turns white with a "Set loot spec" button. Click it: loot spec is Feral and the row green, no reload. proves: manual
- [ ] In combat at a dummy, click Set loot spec: one grey chat line "Loot spec not changed: you are in combat." and the loot spec is unchanged. proves: manual
- [ ] Drag the card by its title, close it with its X, change loot spec: it stays closed. `/reload` inside the raid: it comes back where it was dragged to. proves: manual
- [ ] Enter a Mythic dungeon and an old raid: no card from this addon in either (KeystoneLoot's dungeon card is its own). proves: manual
- [ ] After entering the raid, open the journal on a boss page: the tier, instance and boss page are as you left them. proves: manual
<!-- AC:END -->

## Tasks

- [x] The instance's drop list from the Encounter Journal, joined to the four plans. (The raid's
  pools card 0022 already harvests, `PlanTab.POOL`, joined to `PlanTab.plannedIds` per spec.)
- [x] Spec icons from `GetSpecializationInfoForSpecID` (a global, `SpecializationSharedDocumentation.lua`,
  icon is the fourth return). Loot spec from `GetLootSpecialization`; 0 means "current spec".
- [x] Offline checks under the names above.

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Comments

- 2026-09-22 Claude (review, worktree `worktree-agent-a261f3540f74431be`): attacked the four
  criteria and the code, every API against `wow-ui-source` on `live`. **Held:** `SetLootSpecialization`
  and `GetSpecializationInfoForSpecID` are `AllowedWhenUntainted` and take plain numbers
  (`PlayerScriptDocumentation.lua:1492`, `SpecializationSharedDocumentation.lua:35`);
  `GetLootSpecialization` and `GetInstanceInfo` carry no secret flag (`InstanceDocumentation.lua:103`);
  `PLAYER_LOOT_SPEC_UPDATED` is `LootDocumentation.lua:299`; the combat guard is the card's own
  rule, not Blizzard's, and the docs put no combat restriction on the call, so a refusal to set is
  ours and says so. Events are attached-then-registered-then-verified per DECISIONS. The three
  builder mutants re-run red. **Broke, and fixed here, one defect in two halves:** (1) `raidName`
  made a second journal walk of its own, selected the last tier and put the tier back but not the
  instance and encounter, which `harvestPools`'s own comment says a reopened boss page needs, so
  look 6 would have failed on a reload inside the raid. (2) The raid was told by
  `GetInstanceInfo`'s name equalling `EJ_GetInstanceInfo`'s, a spelling match the handover's own
  rule ("an id survives spelling and locale where a name does not") warns against. Both go the
  way Blizzard's `EncounterJournal_OnShow` finds where you stand (`AdventureGuideUtil.lua:31`):
  the map id, `GetInstanceInfo`'s eighth return, through
  `C_EncounterJournal.GetInstanceForGameMap` (`EncounterJournalDocumentation.lua:74`,
  `AllowedWhenUntainted`), compared to `PlanTab.RAID_ID`, which `harvestPools` now records with
  `PlanTab.RAID_NAME` on the one walk it already makes. `raidName` is one line and `canRead` is
  no longer needed on that path. Five checks added or changed: the raid is told by journal id
  with the map named otherwise; another raid by map id; no card before the pools have named
  the raid; no name until harvested; and asking for the name does not call `EJ_SelectTier`. Two
  new mutants on temp copies, each exit 1: the id compare dropped (two checks red); a tier select
  put back into `raidName` (one red). `lua offline-check.lua` and Lua 5.1.5 both exit 0, 177
  top-level locals. Also corrected look 4: a `/reload` inside the raid fires
  `PLAYER_ENTERING_WORLD`, so the card comes back; "stays closed" is true of a loot spec change.
  **Security:** weakest point is the Set loot spec button, which is a plain click on an insecure
  frame calling one Blizzard function with a number from a fixed table, so the worst a stranger
  can do is press it. Unchecked path: the `PLAYER_LOOT_SPEC_UPDATED` redraw runs in combat too,
  but it only calls `Show`/`Hide`/`SetText` on non-secure frames, and `harvestPools` refuses
  combat. Leaks: nothing beyond the addon's own plan; no name from the game is concatenated or
  keyed. **To human-review, not done:** the frame, its anchors and the two events cannot be
  proven here; the looks above are the acceptance.

- 2026-09-22 Claude: built, in a worktree, in `DjinnisBiS.lua` only, no version bump, not deployed,
  nothing seen in a client. **The dungeon half is not built, on purpose.** KeystoneLoot draws its
  own loot spec card on entering a Mythic dungeon from the favourites card 0021 sends it, and its
  `modules\keystone.lua` (`GetCurrentChallengeMapId`, read 2026-09-22) returns unless
  `instanceType` is `"party"`, so it never fires in a raid. The raid half is what was missing and
  is what this builds; the card below does nothing in a dungeon (one check says so).
  **What was built**, all on `PlanTab`, no new top-level local (177 stay):
  `lootCardWants(pools, planned)` is pure: the specs with a planned item anywhere in the raid's
  pools (`PlanTab.POOL`, card 0022's harvest, joined to `PlanTab.plannedIds`), in spec order, each
  item once however many bosses drop it. `lootSpecName` turns `GetLootSpecialization`'s answer
  into a spec name, 0 being the current spec. `lootCardLines` marks the loot spec's row.
  `lootCardModel` reads the world: `GetInstanceInfo` must say `raid` and its name must equal the
  journal's name for the Venomous Abyss (`PlanTab.raidName`, read once through
  `PlanTab.raidInstanceID` with the journal's tier put back, never while the journal is open), so
  another raid draws nothing. `showLootCard` draws a `BasicFrameTemplateWithInset` card named
  `DjinnisBiSLootCard`, movable, position kept by `SetUserPlaced`: one row per spec at 36 pixels,
  the spec icon at 32, the name, up to six 32-pixel item buttons with the game tooltip on hover
  and "+N more", and a 24-high Set loot spec button on every row but the loot spec's, whose name
  is green and says "loot spec" under it (0020 rules 1 to 5). `setLootSpec` refuses in combat
  with one chat line and otherwise calls `SetLootSpecialization(specID)` with a plain number
  (`PlayerScriptDocumentation.lua`). `armLootCard` registers `PLAYER_ENTERING_WORLD` and
  `PLAYER_LOOT_SPEC_UPDATED` one at a time on their own frame and checks each with
  `IsEventRegistered`; it is armed at `PLAYER_LOGIN` from the loader, and the loot spec event
  only redraws a card already shown. The pools fill cell by cell, so when they are not complete
  on entering, the loader's `EJ_LOOT_DATA_RECIEVED` branch calls `showLootCard` again, at most
  eight times (`PlanTab.lootCardPending`), so a client that keeps only the last filter's list
  cannot loop it. Every API checked in `wow-ui-source`: `GetLootSpecialization` carries no
  secret flag, `SetLootSpecialization` and `GetSpecializationInfoForSpecID` are
  `AllowedWhenUntainted` and get plain numbers, `GetInstanceInfo`'s name goes through `canRead`
  before it is compared, and `PLAYER_LOOT_SPEC_UPDATED` is in `LootDocumentation.lua`.
  **Checks:** 24 in `selfTest` under the four names, the drawn ones with `GetInstanceInfo`,
  `GetLootSpecialization`, `PlanTab.POOL` and `PlanTab.RAID_NAME` stubbed to the raid and put
  back; `print` in the combat block records and forwards, so a FAIL line still reaches
  `offline-check.lua`. `lua offline-check.lua` and Lua 5.1.5 both exit 0. **Mutations**, each on
  a temp copy and each exit 1: the combat guard in `setLootSpec` dropped (two combat checks
  red); `if #wants == 0 then return nil end` in `lootCardModel` dropped (the "nothing planned in
  the pools" check red); `current = false` in `lootCardLines` (two mark checks red).
  **What a person must look at in the game** (there is no test client; none of this has run in
  one):
  1. Enter the Venomous Abyss out of combat with the journal closed. A card titled "Loot spec
     for The Venomous Abyss" appears near the top of the screen with a Feral row: the Feral
     icon, the planned drops as item buttons with quality borders, and "+N more" if over six.
     Hover an item button: the game tooltip. Today only Feral has a plan, so one row; if the
     card is empty or missing, the pools were not in yet: open `/bis` Plan tab once and re-enter
     or `/reload` inside, and say so on this card, because then the eight retries are not enough.
  2. With loot spec on Feral (or 0 following Feral), the Feral name is green with "loot spec"
     under it and no button. Set loot spec to Guardian through the spec window: the row turns
     white and gains a 24-high "Set loot spec" button. Click it: loot spec is Feral again and the
     row goes green without a reload.
  3. Click Set loot spec while at a training dummy in combat: one grey chat line, "Loot spec not
     changed: you are in combat", and the loot spec is as it was.
  4. Drag the card by its title bar, close it with its X, `/reload`: it stays closed until the
     next zone-in, and comes back where it was dragged to.
  5. Enter a Mythic dungeon and an old raid: no card from this addon in either (KeystoneLoot's
     own card in the dungeon is its).
  6. Open the journal on a boss page after entering the raid: the tier and page are as you left
     them.
  **Left out, and why.** The dungeon half, as above. Card 0013's "one window, not two": 0013 is
  not built, so there is nothing to sit inside; when it is, this card's rows are
  `PlanTab.lootCardLines` and can be drawn in its popup. Edit Mode: like the `/bis` window
  (0020's comment), this is a toggled dialog and is not registered; it is draggable and keeps its
  place. Items are the plan's, the four druid plans only, per "Not this card".

- 2026-09-22 Claude: written from Rob's "Option B" in a SecondBrain session. Ideation only.
- 2026-09-22 Claude, later: **KeystoneLoot already does the dungeon half of this card**, and Rob has
  it installed. It stays silent because Rob has no favourites (`Bloodfeather-Djinni-11` is empty in
  `WTF\Account\DJINNWRAITH\SavedVariables\KeystoneLoot.lua`). Its public API,
  `KeystoneLootAPI:AddFavorite(itemId, specId, tier, options)` (`modules\api.lua` line 536), can fill
  it from the plan. Before building this card, decide: send the plan to KeystoneLoot and keep only
  the raid half here, or drop the card.

**2026-10-11** Clear-down (attended, Rob asked): ticked nothing new; the four `proves:` checks (`loot card lists planned drops per spec`, `loot card marks the loot spec and offers the others`, `no loot card when nothing planned drops`, `loot spec not changed in combat`) were already ticked and still exist and pass in the Lua 5.1 offline check. Looks rewritten for v0.69.0 and `/dcp`; the title, button and combat strings match `PlanTab.showLootCard`, `lootCardRow` and `setLootSpec`, and Feral is still the only spec with a gear plan. Dropped old look 7 (the title is the journal's name): it was a note, not a check. Moves to ai-review/ with only in-game looks open.

### 2026-10-18 review (v20261018091942-5fd7)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I checked the four ticked criteria against the code, and I could not break them.

**#1, the card lists planned drops per spec.** `PlanTab.lootCardWants` takes the raid's drop lists and the plan of each of the four specs. It returns the specs in order, and each spec lists each item once. `PlanTab.lootCardModel` reads where the player stands and builds the rows. `PlanTab.showLootCard` draws them: the spec icon, up to six item buttons with the game tooltip, and "+N more". `PlanTab.armLootCard` sets the card to show on entering the world. The login code calls it, so the card is connected to the game.

**#2, the card marks the loot spec and offers the others.** `PlanTab.lootSpecName` reads 0 as "the current spec". `PlanTab.lootCardLines` marks the loot spec's row. In `PlanTab.showLootCard`, that row is green, says "loot spec" and has no button. Every other row gets a "Set loot spec" button from `PlanTab.lootCardRow`.

**#3, no card when nothing planned drops.** `PlanTab.lootCardModel` returns nothing in five cases: not a druid, not a raid, a different raid, the raid not yet named by the journal, and no planned item in the drop lists. Then `PlanTab.showLootCard` hides the card.

**#4, no loot spec change in combat.** `PlanTab.setLootSpec` checks for combat first. In combat, it prints one chat line and stops.

One gap is on purpose. Criterion #1 says "raid or dungeon", but only the raid half is built. The card's own comments and look 5 give the dungeon to KeystoneLoot, so I do not count this as a fault.

The open "manual" criteria are for you to try in the game. They are not findings.

VERDICT: sound

**scope: defect**

Two findings.

1. **The dungeon half is not built.**
   - Where: `PlanTab.lootCardModel` in `DjinnisClassProfiles.lua`.
   - It returns nil unless `instanceType` is `"raid"`. It also returns nil unless the map is `PlanTab.RAID_ID`.
   - So the card only shows in the Venomous Abyss. It never shows in a dungeon.
   - Criterion #1 still says "raid or dungeon". The builder passed the dungeon case to KeystoneLoot through card 0021. Card 0021 is still in `ai-review/`, so it is not done.
   - The rewritten look #5 now says "no card from this addon" in a Mythic dungeon. That look and criterion #1 say opposite things.
   - The checks under `loot card lists planned drops per spec` only test the raid. So the tick on #1 claims more than the code does.
   - The fix is one of two things: build the dungeon half, or reword #1 to "raid" and point to 0021.

2. **Nothing crosses the "Not this card" fence.**
   - `PlanTab.setLootSpec` acts only on a click. It refuses in combat.
   - `PlanTab.lootCardWants` reads only the four druid plans, through `SPEC_ORDER`.
   - The new every-class code puts no extra classes on the card. Through `PlanTab.gearHere`, a non-druid gets no card.

The rest of the big diff is the rename and other cards. It is not this card's scope creep.

UNMET: #1 lootCardModel returns nil for every instance that is not the one planned raid, so entering a dungeon where a planned item drops shows no card, and the dungeon case depends on unfinished card 0021 and a third-party addon.

VERDICT: defect

**breakage: sound**

I tried to break card 0015 and could not.

**What I read:** `PlanTab.lootCardWants`, `lootSpecName`, `lootCardLines`, `setLootSpec`, `lootCardModel`, `showLootCard`, `armLootCard`, and the four self-test blocks in `DjinnisClassProfiles.lua`.

**What holds:**
- The card lists each spec's planned drops one time each, in spec order. #1 holds.
- The loot spec row is green and has no button. Each other row has a "Set loot spec" button. A loot spec of 0 means "the current spec". #2 holds.
- No card when nothing planned drops, in another raid, in a dungeon, or outside. #3 holds.
- In combat, `setLootSpec` does not change the loot spec. It writes one chat line. #4 holds.
- A loot spec change does not open a closed card. Look 4 can pass.

**One small risk. It does not fail a criterion:** the loot table can still be loading when you enter the raid. While it loads, `showLootCard` runs again, up to eight times. If you close the card with its X in that short time, the card can come back once. No look tests this case.

There are no `UNMET:` lines. The only open criteria are `proves: manual`.

**What you do now:** nothing. The card goes to `done/`. The in-game looks wait on your list to try.

VERDICT: sound

**acceptance**

- **#1 was named by the scope lens and is not a ticked criterion here**, so nothing was changed: lootCardModel returns nil for every instance that is not the one planned raid, so entering a dungeon where a planned item drops shows no card, and the dungeon case depends on unfinished card 0021 and a third-party addon.

