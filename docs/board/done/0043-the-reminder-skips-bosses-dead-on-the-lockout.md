# 0043 The reminder skips bosses already dead on the lockout

## Why

Rob, 2026-09-23, with a screenshot, in front of Entombed Sentinels: the reminder said "The
Venomous Abyss: Nek'zali, Switch talents". "Should not be getting a reminder to switch here." The
same screenshot showed the loadouts offer asking to Create 3 builds that had no room.

The cause: `PlanTab.rowHere` knew only the kill it saw in this session (`PlanTab.lastKill`). A
`/reload` or a zone-in resets that, so the reminder went back to the first boss.

## Built, v0.36.2

- `PlanTab.bossDone(id)` asks `C_RaidLocks.IsEncounterComplete(mapID, id, difficultyID)`, with the
  map and difficulty from `GetInstanceInfo`. That is how the dungeon journal draws its "defeated"
  mark (`Blizzard_EncounterJournal.lua`, `EncounterJournalBossButton_UpdateDifficultyOverlay`).
  Each read is `canRead`-checked. It answers false when unsure.
- `rowHere` takes it as `done` and skips dead bosses after the last kill seen. The reminder and
  the list's "boss here first" both pass it.
- The loadouts offer asks only for as many builds as fit (`PlanTab.loadoutRoom`, shared with
  Create). With no room it offers no Create. When asked, it says the builds are worn through the
  spare.
- 6 new checks. Three mutations, each turned red.

## Not this card

- A boss killed out of order before the last seen kill is not gone back to.
- With no lockout (for example LFR, or a raid with no saved kills), nothing is skipped.

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN a boss is dead on this lockout, THE REMINDER SHALL name the next living boss, after a `/reload` too. proves: `popup names what differs from the plan here, the reminder names the next living boss`, `..., the list puts the next living boss first`, `..., the lockout is asked as the journal asks it`
- [x] WHEN no slot is free, THE OFFER SHALL not ask to Create. proves: `a build with no loadout of its own is worn through the spare, and offers no Create with no room`
- [ ] In the raid with Nek'zali dead, `/reload` before Entombed Sentinels. Pass: the reminder names Entombed Sentinels, or nothing shows if the talents already match. proves: manual
- [ ] Same spot, open the talent window. Pass: the list beside it puts `Raid: Entombed Sentinels` first, not `Raid: Nek'Zali`. proves: manual
<!-- AC:END -->

## Comments

**2026-09-23** Adversarial review of c578611. Bounced to todo: the fix itself is not tested.

**Finding: nothing checks `bossDone` or that it is passed in.** The harness never defines
`C_RaidLocks`, so `PlanTab.bossDone` answers false at its first line (`DjinnisBiS.lua:5176`) on
every run. The new checks give `rowHere` a hand-made `done`. None goes through the real one. Three
mutations stay green under Lua 5.1 and 5.4:
- the reminder no longer passes `PlanTab.bossDone` (`:5311`): 0 red
- the sidebar no longer passes it (`:6218`): 0 red
- the arguments swapped to `(id, mapID, difficultyID)` (`:5179`): 0 red

Those three are exactly how Rob's report would come back. Fix: in the `checkSetup` test, stub
`C_RaidLocks.IsEncounterComplete` to answer true for one `(mapID, 3470, difficultyID)`. Make
`GetInstanceInfo` return that map as its 8th value and that difficulty as its 3rd. Then check that
the popup title names Entombed Sentinels with `lastKill` nil.

What held:
- Harness green under Lua 5.1 and 5.4.
- Mutations: `rowHere` ignores `done`, 2 red. The offer shows Create with no room, 1 red. `bossDone`
  always true, 31 red.
- The arguments match the API. `C_RaidLocks.IsEncounterComplete(mapID, encounterID, difficultyID)`
  is in `RaidLocksDocumentation.lua:27-41`. The journal passes the dungeon encounter id, the same id
  `ENCOUNTER_END` gives (`Blizzard_EncounterJournal.lua:3577-3579`).
- `GetInstanceInfo`'s 8th value is `instanceID`, a map id (`InstanceDocumentation.lua:115`).
- Secrets: neither function marks a return as secret. Both carry `SecretArguments =
  AllowedWhenUntainted`, so a secret passed in from tainted code would throw. The map, the
  difficulty and the answer are each `canRead`-checked, and the call is `pcall`ed. It answers false
  when unsure, which is the old behaviour.
- The offer part: `loadoutRoom` is shared with Create. With no room, missing is emptied before the
  buttons are built.

No criterion carries `proves:`.

Security:
1. Weakest point: a wrong "dead" answer hides the reminder for a living boss. It fails quiet, not
   loud. The false-when-unsure default keeps it to the old behaviour.
2. Unchecked: nothing comes in from outside. The game's answers are guarded, as above.
3. Leaks: nothing leaves the client.

No client can be run by an agent. The in-game checks are the card's What I need from you.

- 2026-09-23 Claude, builder, v0.38.0. Fixed.
  - Both callers go through one function, `PlanTab.bossHere(spec, here)`.
  - New checks stub `C_RaidLocks` and `GetInstanceInfo`: the lockout is asked as the journal asks
    it (`2939/3445/15`), a boss dead on it reads dead, and `bossHere` skips it. Mutations: `bossHere`
    without `bossDone` 1 red, the arguments swapped 3 red.

**2026-09-23** Second adversarial review of b5530b3 (v0.38.0). Bounced to todo: one finding, and
it is the first review's own finding, only half closed.

Attacked, on a temp copy, the same under Lua 5.1 and the newer one:
- `bossHere` without `bossDone`: 1 red.
- `bossHere` without `lastKill`: 2 red.
- `IsEncounterComplete` arguments swapped: 3 red.
- the map read from `GetInstanceInfo`'s 4th value, not the 8th: 1 red.
- **`checkSetup` back to `rowHere(..., PlanTab.lastKill)` with no `done`** (`DjinnisBiS.lua:5328`):
  **0 red**.
- **the list back to `rowHere(..., "raid", PlanTab.lastKill)`** (6235): **0 red**.

**Finding: the reminder and the list can still stop skipping dead bosses with every check green.**
The first review listed three mutations that stayed green. The first two were these call sites.
They are still green. The new check at 10123 is named "the reminder's and the list's row skips
it", but it calls `bossHere` directly. So it proves `bossHere` and not that the reminder or the
list use it. The first review asked for the check to go through `checkSetup`. Fix: in the same
stubbed setup (`C_RaidLocks`, `GetInstanceInfo` giving map 2939, difficulty 15, `lastKill` nil),
call `PlanTab.checkSetup()` and check the popup title names Entombed Sentinels. The list half
can be a check on `updateSidebar`'s `here`, or say on the card that only the game proves it.

No criterion carries `proves:`. The first review said so and the fix left it. Name the checks.

What held:
- `bossDone` asks `IsEncounterComplete(mapID, encounterID, difficultyID)` in the journal's order.
  Each value passes `canRead`, and the call is in `pcall`. It answers false when unsure, which is
  the old behaviour.
- `bossHere` is now the one place both callers go through, and `rowHere` skips dead bosses after
  the last kill.
- The offer part is unchanged since the first review and still holds.

Security:
1. Weakest point: a wrong "dead" answer hides the reminder for a living boss. It fails quiet.
   False-when-unsure keeps that to the old behaviour.
2. Unchecked: nothing from outside. The game's answers pass `canRead` and `pcall`.
3. Leaks: nothing leaves the client.

No client can be run by an agent. What I need from you 1 and 2 still stand.
- 2026-09-23 Claude, builder, v0.38.1. Fixed: checks now go through the callers. `checkSetup` names
  Entombed Sentinels with Nek'zali dead, and the list's new `PlanTab.sidebarHere` puts its loadout
  first. Pointing either caller back at `rowHere` alone: 1 red each. `proves:` added.

**2026-09-23** Third adversarial review of e1b2ecb (v0.38.1). **Clean. Moved to human-review for
the in-game steps.**

Attacked, on a temp copy, the same count under Lua 5.1 and the newer one:
- `checkSetup` back to `rowHere(..., PlanTab.lastKill)` with no `done` (`DjinnisBiS.lua:5329`):
  1 red. The second review's finding is fixed.
- `sidebarHere` back to `rowHere` with no `done` (6219): 1 red.
- `bossHere` without `bossDone` (5187): 3 red. Without `lastKill`: 2 red.
- the map read from `GetInstanceInfo`'s 4th value (5195): 1 red. The arguments swapped (5197): 5 red.
- `updateSidebar` passing `nil` instead of `sidebarHere(spec)` (6243): 0 red. That line only runs
  with the list open, and harness frames never open it. So I added step 3 to What I need from you.
  It is one call, and the logic it calls is tested.

What held:
- The reminder check goes through `checkSetup` itself with `lastKill` nil and Nek'zali dead on
  the stubbed lockout, and names Entombed Sentinels.
- `bossDone` asks `IsEncounterComplete(mapID, encounterID, difficultyID)` in the journal's order.
  Each value passes `canRead` and the call is in `pcall`. It answers false when unsure.
- All four `proves:` names exist in the file and ran.

Security:
1. Weakest point: a wrong "dead" answer hides the reminder for a living boss. It fails quiet.
   False-when-unsure keeps that to the old behaviour.
2. Unchecked: nothing comes from outside. The game's answers pass `canRead` and `pcall`.
3. Leaks: nothing leaves the client.

No client can be run by an agent. A person owes What I need from you 1 to 3.

**2026-10-11** Clear-down (attended, Rob asked): ticked both criteria (checks `popup names what differs from the plan here, ...` (the reminder names the next living boss, the list puts the next living boss first, the lockout is asked as the journal asks it) and `a build with no loadout of its own is worn through the spare, and offers no Create with no room` exist and pass in the Lua 5.1 offline check); looks rewritten for v0.69.0, with the full `proves:` prefixes written out; dropped old step 2 (no Create offer with every slot used), because card 0039's first look checks the same box; moves to ai-review/ with only in-game looks open.

### 2026-10-19 review (v20261019204833-92c6)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I checked each criterion against the code in `DjinnisClassProfiles.lua`.

**#1, the reminder names the next living boss after a `/reload` too.** This is met.
- `PlanTab.bossDone` asks `C_RaidLocks.IsEncounterComplete(mapID, id, difficultyID)`. It reads the map and the difficulty from `GetInstanceInfo`. Each value goes through `canRead` and the call is in `pcall`. It answers false when it is not sure.
- `PlanTab.bossHere` passes `PlanTab.bossDone` to `PlanTab.rowHere`, together with `lastKill` and the current map.
- `PlanTab.rowHere` skips each boss that `done` says is dead, after the last kill it saw.
- The reminder (`PlanTab.checkSetup`) and the list (`PlanTab.sidebarHere`) both have a named check in the self-test. Each check runs with `lastKill` nil and Nek'zali dead on a stubbed lockout. Each one expects Entombed Sentinels. A third check makes sure the lockout is asked in the journal's order.

**#2, no Create offer with no free slot.** This is met.
- `PlanTab.loadoutRoom` counts the free slots.
- The self-test check "...offers no Create with no room" makes sure no Create button shows.

**#3 and #4** are `proves: manual`. They wait for the in-game check. Nothing in the code stops them from passing.

I did not run the self-test. I only traced the code and the check names.

VERDICT: sound

**scope: sound**

I checked the card's code in `DjinnisClassProfiles.lua`. I did not change anything.

**What I found:**

- The four functions the card names are all there. They are `PlanTab.bossHere`, `PlanTab.bossDone`, `PlanTab.sidebarHere` and `PlanTab.loadoutRoom`.
- The diff is very big: 165 files and about 66,000 lines. Almost none of it is this card's work. The diff also holds other things:
  - The rename to DjinnisClassProfiles (card 0058).
  - About 60 other board cards.
  - Warcraft Logs tools (`wcl.py`, `wcl-builds.py`).
  - Research files.
- The diff covers many cards in the repo's history, not one change for this card. So I cannot blame those extra files on 0043. They are not scope creep in this card's code.
- I found nothing in the card's own functions that crosses its "Not this card" fence. Nothing goes back to a boss killed out of order. Nothing makes up a lockout when the game has none.
- Criteria #1 and #2 have named checks. The two in-game looks are only open, so they are not findings.

**What you do now:** Nothing for this card. If you want each card reviewed on its own, scope the next review to that card's own commits, not the whole branch.

VERDICT: sound

**breakage: sound**

I tried to break the card 0043 fix. I could not break it.

**What I checked**

- **`PlanTab.bossHere`**: the reminder and the list both use this one function. It passes the last kill, `PlanTab.bossDone` and `PlanTab.mapHere()` to `PlanTab.rowHere`. The rename to `DjinnisClassProfiles.lua` did not break any caller.
- **`PlanTab.bossDone`**: it still asks the game in the same order as the dungeon journal (map, boss id, difficulty). Each value is checked before use. The call is wrapped so an error cannot stop the addon. When it is not sure, it answers "not dead".
- **`PlanTab.rowHere`**: a later change makes it match boss rows by map. The raid rows now carry `map = 3004`. The self-test fakes the game with that same map, so the real path runs. The check names the card points to still exist:
  - "the reminder names the next living boss" goes through `PlanTab.checkSetup`.
  - "the list puts the next living boss first" goes through `PlanTab.sidebarHere`.
  - "the lockout is asked as the journal asks it" expects `3004/3445/15`.
- **Comments**: the notes above `rowHere`, `bossHere` and `bossDone` still match the code.

**What I did not do**

- I did not run the offline check. No test suite ran for this review.

**What you do now**

Nothing in the code. The two in-game checks on the card are still yours to try in the raid.

VERDICT: sound

