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

1. `/reload` (v0.38.0). Open the talent window as Feral. Double-click `Raid: Vashnik` (grey,
   `spare`). Pass: chat says to close the talent window. Close it. Pass: chat says "Making the
   spare loadout" and then "Putting on", and the talents change.
2. Open the talent window. Pass: the tree is the full Vashnik build, and `BiS: Raid: Vashnik` is
   in the dropdown.
3. Do this with five spare builds in a row, checking the tree each time. A half-filled tree would
   come and go, so one good pass proves little.
4. Click **Switch talents** on the reminder for a build with no loadout, with the talent window
   shut. Pass: it is worn in one step.
5. Go back to the build before. Pass: a plain switch, no "Making" line.
6. After a pull: action bars update in combat (no frozen buttons, card `0011`).

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

- 2026-09-23 Claude, builder, v0.38.0. Both findings and the smaller one fixed. The design changed.
  1. **The spare is never made with the talent window open.** With it open, `wearSpare` keeps the
     wish and says "Close the talent window to put on X". A one-time `OnHide` hook on
     `PlayerSpellsFrame` runs it half a second after the close. Blizzard's frame unregisters its
     events in its own `OnHide` (`Blizzard_ClassTalentsFrame.lua:282`), so nothing auto-wears. The
     spare is made through `makeLoadouts(jobs, wear)`, the same queue as Create, which waits for
     `IsConfigPopulated`. Then `wearMadeSpare` checks it is filled and switches through
     `ClassTalentHelper.SwitchToLoadoutByName`, the path every other switch takes. If the server has
     still not filled it in, it says so and wears nothing. `importOne` no longer has a window
     exception.
  2. **Only spares this character made are touched**, by config id, in `DjinnisBiSCharDB.spares`.
     `spareBuild(name, id)` needs the id to be one of them. So a player's own "BiS: M+" is never
     deleted, hidden, or read as a build.
  3. The "same" answer is fixed in `loadTalents` (card 0029's fix).
  Also: going back to the last spare build, which is still there, is a plain switch with no new
  import.
  Checks rewritten: waits for the window, made once shut, worn through the helper, the way back is
  a plain switch, the one not worn goes, a player's "BiS: M+" is never deleted, an unfilled spare
  is not worn. Mutations: window-open branch gone 17 red, delete any "BiS:" 7 red, id guard gone 2
  red, no switch 3 red, no filled check 1 red, no way back 3 red.
  The What I need from you steps change: double-click a spare row, then close the talent window.

**2026-09-23** Second adversarial review of b5530b3 (v0.38.0). Bounced to todo: three defects,
two smaller ones, and a set of untested lines.

The first review's findings are fixed as written. The spare is made with the window shut, through
the queue, and worn through `ClassTalentHelper`. Only ids in `DjinnisBiSCharDB.spares` are deleted
or hidden. The "same" misfire is gone. What follows is new, and each one was run in a temp copy
with probe checks added to `loadoutChecks`.

**Finding 1: a wish kept for the window's close overrides what the player chose after it.**
Double-click a grey row with the window open. `wearSpare` keeps `PlanTab.spareWanted`
(`DjinnisBiS.lua:6557`). Then double-click a build that has its own loadout. `loadTalents` switches
to it at once (3969) and never clears the wish. Close the window. `spareOnHide` (6527) makes and
wears the old spare, over the build the player picked last. On the way it deletes this
character's other spare. Probe: calls `delete BiS: Raid: Sszorak|import BiS: Raid: Vashnik`,
helper asked for `Raid: Nek'Zali` then `BiS: Raid: Vashnik`. The same holds after a spec change
in the open window: the old spec's build is then imported for the new spec and fails aloud after
the queue's wait. Fix: any later `loadTalents`, and a spec change, clears `spareWanted`.

**Finding 2: a "BiS: X" this character does not own gets a twin.** Spares made by v0.36.0 to
v0.37.1 were never recorded, so they are now "your own". The same happens to a player's loadout
named exactly `BiS: <a planned build>`. Wearing X then:
- skips "same" and the plain switch, because the id is not ours (6543, 6549)
- imports a second `BiS: X`. Probe: two loadouts of that name.
- `wearMadeSpare` records whichever id `savedLoadoutNames` keeps last (6638).
- `SwitchToLoadoutByName` loads "the first one found" by name (`ClassTalentHelper.lua`), which
  can be the old one. If that was a half-filled v0.36 spare, the tree is wrong again.
The loadout left over is never deleted and holds a slot for good. Fix: if the spare name is
already held by an id that is not ours, say so and make nothing, or adopt it once after checking
its string matches the build. Also take the new id from `q.pendingID`, which
`TRAIT_CONFIG_CREATED` gives (6848), not from a name lookup.

**Finding 3: a spare that is made but not listed yet fails silently and is lost.** `wearMadeSpare`
(6638) needs the new name in `savedLoadoutNames()`. If the list lags the import, it answers
"failed". The comment says "stepLoadouts said why", but the import succeeded, so nothing was said.
The id is never recorded. The spare then shows as the player's own and is never deleted. Probe:
`wearMadeSpare({ wear = "Raid: Nymrissa", made = 1 })` answered "failed" and printed nothing. The
code already believes the list can lag ("the list can lag a delete", 6568). The `q.pendingID` fix
above covers this too.

**Smaller.**
- Combat while the queue waits: `wearMadeSpare` asks the helper with no `InCombatLockdown`
  check and says "Putting on". Probe: helper asked in combat. Blizzard will refuse, so the line is
  false.
- Combat when the window closes: `spareOnHide` then `wearSpare` answer "combat" (6537) and say
  nothing. The wish is gone. The player was told closing would wear it.

**Untested (0 red under mutation, both harnesses):**
- no `HookScript` at all (6560). The harness frame has no `HookScript`, so the hook line never runs
  and the close-resumes design has no offline proof.
- `spareOnHide` keeps the wish (6530), so every later close wears it again.
- no half-second delay (6532).
- `mine[worn]` dropped from "same" (6543) or from the plain switch (6549). Finding 2's route.
- the plain switch skips `IsConfigPopulated` (6551).
- a delete does not forget the id (6566).
- `wearMadeSpare` without `q.made == 1` (6638). A failed import can then record and wear an old
  "BiS: X".
- `importOne` without its window guard (6585). That guard is the only thing stopping a retry while
  the window is open again.
- `activeLoadoutName` reading any "BiS: " name as a build (4637). The player's own "BiS: M+"
  selected would read as a build "M+".
Tested and red: the id not recorded, 5 red. `finishLoadouts` never wears, 6 red.

**Blizzard source read.** `ClassTalentsFrameMixin:OnHide` (`Blizzard_ClassTalentsFrame.lua:277`)
is the talents TAB's hide. It unregisters `TRAIT_CONFIG_CREATED`, `TRAIT_CONFIG_LIST_UPDATED` and
`TRAIT_CONFIG_DELETED`. The hook is on `PlayerSpellsFrame`, the whole window. So:
- Switching to the Spellbook tab does not fire the hook. The wish waits for the close. That is
  safe, because the talents tab's events are already off.
- Reopening the window while the queue runs registers the events again (`OnShow`, :142). If
  `TRAIT_CONFIG_CREATED` arrives then, Blizzard wears the new config with no populated check
  (:303-310). That is the first review's risk, narrowed to the server's round trip.
- `SwitchToLoadoutByName` with the frame not loaded is fine: the event handler calls
  `PlayerSpellsFrame_LoadUI` first (`ClassTalentHelper.lua`).
- **Look at this in game.** With the window shut, the frame's name list (`configIDToName`,
  :777) is only refreshed by `TRAIT_CONFIG_UPDATED`, the one event registered for good
  (`Blizzard_SharedTalentFrame.lua:186`). If the new spare's `TRAIT_CONFIG_UPDATED` does not come
  before `wearMadeSpare`, `LoadConfigByName` does not know the name and shows "invalid config"
  (:1747). The addon still says "Putting on".

**Security.**
1. Weakest point: the name. `SwitchToLoadoutByName` and `savedLoadoutNames` both work by name, and
   the player owns the names. Finding 2 is how a twin name makes the addon record and wear the wrong
   loadout.
2. Unchecked: the saved wish (finding 1) is acted on later with no check that it is still wanted.
   `DjinnisBiSCharDB.spares` is never pruned of ids deleted by hand. Config ids are server ids and
   not known to be reused, so a stale id matching a player's loadout is unlikely but not ruled out.
   A prune of ids in no spec's list would close it.
3. Leaks: nothing leaves the client. Failures print the build name and the game's reason.

No client can be run by an agent. Once fixed, a person owes What I need from you 1 to 6, plus:
- double-click a grey row, then a real loadout, then close. Pass: the real loadout stays on.
- after step 1, no red "invalid config" message and the talents really change.
- with an old v0.36 "BiS: X" in the dropdown, wear X. Pass: no second "BiS: X".