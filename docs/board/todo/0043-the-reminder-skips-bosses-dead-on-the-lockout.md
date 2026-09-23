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

1. In the raid with Nek'zali dead, `/reload` in front of Entombed Sentinels. Pass: the reminder
   names Entombed Sentinels, or shows nothing if the talents already match.
2. Pass: no "Create 3" offer while all slots are used.

## Acceptance

- [ ] WHEN a boss is dead on this lockout, THE REMINDER SHALL name the next living boss, after a `/reload` too.
- [ ] WHEN no slot is free, THE OFFER SHALL not ask to Create.

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