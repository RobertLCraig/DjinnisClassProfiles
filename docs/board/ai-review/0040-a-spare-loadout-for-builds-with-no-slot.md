---
needs: 0039
---
# 0040 A spare loadout wears the builds that have no slot

## Why

Rob, 2026-09-23, after the 40-slot cap stopped Create: "I guess this is where and why
ImprovedTalentLoadouts had 1 sacrificial one. I guess no matter how much I dislike that solution,
we need to do something similar. (Although I would still like as many unique builds saved in
Blizzard's version too.)"

ImprovedTalentLoadouts writes nodes into its temp loadout and commits from addon code
(`research/ImprovedTalentLoadouts/ImprovedTalentLoadouts.lua:716-827`). That is the frozen-bar
route cards `0002` and `0011` rule out.

## Built, v0.36.0

- A build with no loadout of its own is worn through a spare loadout named `BiS: <build>`.
  `PlanTab.loadTalents` sends it to `PlanTab.wearSpare`, so a double-click on a grey row wears it.
- **No addon code loads or commits talents.** The spare is made with `ImportLoadout` while the
  talent window is open. Blizzard's own `TRAIT_CONFIG_CREATED` handler then wears it
  (`Blizzard_ClassTalentsFrame.lua:296` to `:430`, `SetSelectedSavedConfigID` with autoApply).
  DjinnisDreamgrove card `0001` saw that handler wear every import in Rob's client. The
  talent-write scan in `loadoutChecks` still runs after the spare checks.
- The worn spare is never deleted, because deleting the selected loadout drops to the starter
  build. It goes on the next wear, once another is on. So spares take at most 2 slots, and Create
  leaves 2 free (less any spare there is), then says "Room for N of M".
- `activeLoadoutName` reads `BiS: X` as `X`, so the tick, the "active" mark and per-build bars
  work on a spare-worn build.
- A grey row now says `spare` and its tooltip names the spare loadout.
- `loadoutChecks`: 11 new checks. Nine mutations, each turned red.

## Not this card

- Each spec has its own spare.
- The login offer still counts every missing build, including those that will never fit.

## What I need from you

1. `/reload`. Open the talent window as Feral. Double-click `Raid: Vashnik` (grey, `spare`).
   Pass: the talents change to that build, and `BiS: Raid: Vashnik` is in the dropdown.
2. **Watch the tree.** It must be the full build, not an empty or half tree. Blizzard's import
   dialog first calls `OnTraitConfigCreateStarted`, which waits for the server to fill the
   loadout. The addon cannot call it without tainting the frame. If the tree comes out wrong,
   say so. This is the one real risk.
3. Double-click `Raid: Twin Fangs`. Pass: it is worn, and both spares are in the dropdown. Then
   double-click a third build: the Vashnik spare goes.
4. After a pull: action bars update in combat (no frozen buttons, card `0011`).

## Acceptance

- [ ] WHEN a build with no loadout is double-clicked, THE GAME SHALL wear it through `BiS: <build>`, with the full tree.
- [ ] WHEN the next spare build is worn, THE ADDON SHALL delete the previous spare and never the one worn.
- [ ] Action bars still update in combat after a spare wear.
