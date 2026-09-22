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
<!-- AC:END -->

## Tasks

- [x] The instance's drop list from the Encounter Journal, joined to the four plans. (The raid's
  pools card 0022 already harvests, `PlanTab.POOL`, joined to `PlanTab.plannedIds` per spec.)
- [x] Spec icons from `GetSpecializationInfoForSpecID` (a global, `SpecializationSharedDocumentation.lua`,
  icon is the fourth return). Loot spec from `GetLootSpecialization`; 0 means "current spec".
- [x] Offline checks under the names above.

## What I need from you

There is no test client, so nothing below has run in one. Frames, anchors and events are the
looks; the data and the pure logic are proven offline. Type `/reload` first.

1. Enter the Venomous Abyss out of combat with the journal closed. A card titled "Loot spec for
   The Venomous Abyss" appears near the top of the screen with a Feral row: the Feral icon, the
   planned drops as item buttons with quality borders, and "+N more" if over six. Hover an item
   button: the game tooltip. Today only Feral has a plan, so one row. If the card is empty or
   missing, the pools were not in yet: open `/bis` Plan tab once and re-enter, and say so here,
   because then the eight retries are not enough.
2. With loot spec on Feral (or 0 following Feral), the Feral name is green with "loot spec" under
   it and no button. Set loot spec to Guardian through the spec window: the row turns white and
   gains a 24-high "Set loot spec" button. Click it: loot spec is Feral again and the row goes
   green without a reload.
3. Click Set loot spec while at a training dummy in combat: one grey chat line, "Loot spec not
   changed: you are in combat", and the loot spec is as it was.
4. Drag the card by its title bar and close it with its X. Change loot spec: it stays closed (the
   loot spec event only redraws a card that is showing). `/reload` inside the raid brings it back,
   where it was dragged to, because a reload is a `PLAYER_ENTERING_WORLD`; leaving the raid and
   coming back does the same.
5. Enter a Mythic dungeon and an old raid: no card from this addon in either (KeystoneLoot's own
   card in the dungeon is its).
6. Open the journal on a boss page after entering the raid: the tier, instance and boss page are
   as you left them. (Only the pools' walk touches the journal now.)
7. The title reads the journal's name for the raid, not the map's. If they differ, that is the
   review's change working, not a fault.

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
