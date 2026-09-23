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

## Comments

**2026-09-23** Adversarial review of 5c6b3ff. Bounced to todo: two defects and one smaller one.

**Finding 1: the empty-tree risk is real from source, and one pass in game cannot clear it.**
Blizzard's own import calls `OnTraitConfigCreateStarted(#entries > 0)` right after `ImportLoadout`
(`Blizzard_ClassTalentImportExport.lua:224-233`). That sets `nextNewConfigRequiresPopulatedCheck`.
The addon does not call it, so the flag is false. On `TRAIT_CONFIG_CREATED` the handler then skips
the populated check. It goes straight to `OnTraitConfigCreateFinished` and
`SetSelectedSavedConfigID(configID, autoApply = true)` (`Blizzard_ClassTalentsFrame.lua:303-310`,
`:431-435`). The API doc says a new config "may or may not be populated" when it is created
(`ClassTalentsDocumentation.lua:240`). DjinnisDreamgrove card 0001 measured this in Rob's client:
the event came before the config was filled, which is why its v0.6.0 polls `IsConfigPopulated`. So
the spare can be worn before it is filled, sometimes and not always. One clean pass in game proves
nothing about the next wear.
A safer route is already in the file. Make the spare with the window closed, through the existing
queue. The queue waits for `IsConfigPopulated`. Then wear it with
`ClassTalentHelper.SwitchToLoadoutByName`, which `loadTalents` already uses (`DjinnisBiS.lua:3958`).
No addon code commits talents that way, and the frame's populated gap is never used.

**Finding 2: any loadout the player named "BiS: ..." is deleted without asking.**
`DjinnisBiS.lua:6507-6509` deletes every loadout of this spec whose name starts with `BiS: `,
except the selected one. It runs on any double-click of a grey row, or on the reminder's Switch
talents. A player's own "BiS: M+" goes, and the new "Your loadouts" list hides it too. Fix: delete
only when the rest of the name is a planned build of this spec, or keep the ids of spares the addon
made. Add a check that a player's "BiS: " loadout that is not a planned name survives.

**Smaller: the "same" check misfires once a build has both a spare and a real loadout.**
The spare is worn, and later Create makes the real loadout. `activeLoadoutName` now reads
"BiS: X" as X (`:4626`). So `loadTalents("X")` answers "same" at `:3946`. It says X "is loaded
already, but its build is not the planned one", and that is false. The real loadout can then not be
reached by double-click.

What held:
- Harness green under Lua 5.1 and 5.4.
- Mutations, red count each under both: delete the worn spare, 2. Never delete a spare, 1. No "BiS:"
  strip, 1. No two-slot reserve, 5. The window refuses the spare import, 5. Delete any loadout, 3.
  Skip the full check, 3.
- The talent-write scan still runs after the spare checks.
- Deleting a spare that is not selected cannot drop to the starter build.
  `OnTraitConfigDeleted` only clears the selection when the deleted id is the selected one
  (`Blizzard_ClassTalentsFrame.lua:414-420`).
- Polling `CanCreateNewConfig` after a delete is bounded by `GIVE_UP`, then `importOne` says why.
- Duplicate spare names: `savedLoadoutNames` keeps one id per name. A second "BiS: X" would never
  be deleted and would hold a slot. That needs a failed delete to happen, so it is a note only.
- Spares are per spec. The reserve counts this spec's spares, and `freeLoadoutSlots` counts all
  specs. Those agree.
- `resetDrifted` and `tidy` never touch a "BiS: " name. Neither is a planned or retired name.
- Per-build bars keyed on the stripped name share a key with the real loadout. That is intended.

No criterion carries `proves:`.

Security:
1. Weakest point: deletion by name. Loadout names are the player's own text. Any name with the
   prefix is treated as the addon's own, and the loss cannot be undone.
2. Unchecked: the prefix match is the only ownership test on the delete path. Nothing records
   which loadouts the addon made.
3. Leaks: nothing leaves the client. Failures print the build name and the game's reason in chat.

No client can be run by an agent. The in-game checks are the card's What I need from you. Also look
at: wear five spare builds in a row and confirm the tree is full every time, not just once.
