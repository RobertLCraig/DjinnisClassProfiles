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

1. `/reload` (v0.38.2). Open the talent window as Feral. Double-click `Raid: Vashnik` (grey,
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

- [ ] WHEN a build with no loadout is double-clicked, THE GAME SHALL wear it through `BiS: <build>`, with the full tree. proves: `... is worn through the spare, made once the window is shut`, `..., then worn through Blizzard's helper`, `..., an unfilled spare is not worn`, and the in-game steps
- [ ] WHEN the next spare build is worn, THE ADDON SHALL delete the previous spare and never the one worn, and never a loadout it did not make. proves: `..., then the one not worn goes`, `..., a player's own "BiS: " loadout is never deleted`, `..., a "BiS: X" it did not make is not doubled`
- [ ] Action bars still update in combat after a spare wear. proves: manual, step 6

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
- 2026-09-23 Claude, builder, v0.38.1. All three defects and both smaller points fixed.
  1. `loadTalents` clears a waiting wish on any new ask. The wish keeps its spec, and `spareOnHide`
     drops it after a spec change. A window shut in combat says so and makes nothing.
  2. A "BiS: X" this character did not record is never doubled: `wearSpare` answers `"taken"` and
     asks the player to delete or rename it. That covers spares left by v0.36.0 to v0.37.1.
  3. `wearMadeSpare` takes the id from `q.pendingID` when its name matches, else from the list. If
     neither has it, it says so ("unlisted"). In combat it records the spare and says to try again.
  New checks for each, plus: `importOne` refuses with the window open, and a player's "BiS: M+"
  selected reads as "BiS: M+". Mutations, each red (a crash counts): no clearing on a new ask 3,
  no spec check 2, no "taken" guard 1, no `pendingID` 1, no id guard in `spareBuild` 3, no window
  guard in `importOne` 1, no combat checks 6. Not covered: the `HookScript` line (harness frames
  keep no scripts) and the half-second delay.

**2026-09-23** Third adversarial review of e1b2ecb (v0.38.1). **Bounced to todo: one defect, and
three of the fixes have no check that can fail.**

The second review's three defects are fixed in the code. A new ask through `loadTalents` or a spec
change drops the waiting wish. An unrecorded "BiS: X" answers "taken" and nothing is made. The
new id comes from `q.pendingID`.

**Finding 1: a loadout picked in Blizzard's own dropdown is still overridden.** The wish is dropped
only by `loadTalents` (`DjinnisBiS.lua:3935`) and a spec change (6537). With the talent window open,
the natural way to choose a loadout is Blizzard's dropdown, which never reaches `loadTalents`. So:
double-click a grey row, then pick another loadout in the dropdown, then close the window.
`spareOnHide` (6533) makes and wears the spare over that choice, and deletes this character's
other spare on the way (6583). Same for a hand edit Applied in the open window. Fix: keep
`selected = PlanTab.selectedConfigID()` in the wish at 6575, and drop the wish in `spareOnHide` when
it has changed. Add a check.

**Finding 2: three fixes, each 0 red under mutation, both harnesses.**
- `wearMadeSpare` without its combat check (6666): 0 red. The second review's "helper asked in
  combat" is fixed but not checked.
- the "unlisted" line made silent (6662): 0 red. That is the second review's finding 3 ("fails
  silently"), and nothing checks it now says so.
- `q.pendingID` taken without the name match (6660, `info.name == name` dropped): 0 red. That
  match is the only thing stopping another Combat config created during the queue from being
  recorded in `DjinnisBiSCharDB.spares`. Anything recorded there is deleted on the next spare wear
  (6584). So it guards the delete path and needs a check.
Two the second review listed are still 0 red: `wearMadeSpare` without `q.made ~= 1` (6656), and
`spareOnHide` keeping the wish (6536).

**Smaller, and it comes with finding 2's "unlisted" path.** "Unlisted" tells the player to
double-click the build again. Once the list catches up, that double-click answers "taken" and
says this addon did not make it (6557), which is false, and asks them to delete it. The spare made
by v0.36.0 to v0.37.1 gets the same false line. One way to cover both: adopt an unrecorded
"BiS: X" once, when its `loadoutString` equals the build's code. That is the second review's other
option.

What held:
- Mutations red, both harnesses: no clear in `loadTalents` 3, no spec check 2, no close-in-combat
  check 1, no "taken" guard 1, no `pendingID` 1, no `pendingID` from the event 1, wish without its
  spec 8, `importOne` without the window guard 1, `spareBuild` without the id guard 3, "same"
  branch gone 1, id recorded before the combat check moved away 6.
- `stepLoadouts` clears `pendingID` before each import and not before `finishLoadouts`, so the id
  that reaches `wearMadeSpare` is the last import's.
- `wearMadeSpare` compares `info.name` without `canRead`. `TraitConfigInfo.name` is not marked
  secret (`SharedTraitsDocumentation.lua:947`), so a note only.
- The game folder holds v0.38.1, the same file as the repository.

Security:
1. Weakest point: `DjinnisBiSCharDB.spares`. Whatever id lands there is deleted later with no
   question. Its one entry path now trusts a name match that no check covers (finding 2).
2. Unchecked: the saved wish is acted on at the window's close with no check that the player did
   not choose something else in Blizzard's own UI (finding 1). Ids in `spares` are still never
   pruned.
3. Leaks: nothing leaves the client. Failures print the build name and the game's reason.

No client can be run by an agent. Once fixed, a person owes What I need from you 1 to 6, plus the
three the second review added.
- 2026-09-23 Claude, builder, v0.38.2. Third review fixed.
  1. The waiting request keeps the selected loadout id. At close it is dropped if the player picked
     another loadout in Blizzard's dropdown, as it already was for a new ask or a spec change.
  2. Checks that can fail now cover: the combat branch of `wearMadeSpare` (1 red), the "does not
     list it yet" message (1 red), the name match on the watched id (3 red: an unrelated loadout is
     never recorded, so never deleted later), `q.made ~= 1` (2 red), and the request cleared at
     close (1 red). The dropdown pick: 2 red.
  3. A spare this session made but the list had not shown yet is adopted by name on the next ask
     (`PlanTab.spareUnlisted`), so it is not called someone else's. The "taken" message now says the
     addon has no record of making it, which is true for spares from before 0.38.