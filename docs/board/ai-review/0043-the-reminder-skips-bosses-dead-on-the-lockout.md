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
