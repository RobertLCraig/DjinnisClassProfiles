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
