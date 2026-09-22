---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0007
---
# 0027 Match each boss by name and by id

## Why

The boss table (`0007`) is keyed by name, for example `{ boss = "Nek'zali", ... }`. A name can differ
by an apostrophe, a locale or a hotfix rename. The game's own events carry ids: `ENCOUNTER_START`
and `ENCOUNTER_END` give an encounter id, Hindsight saves pulls by encounter id, and Keystone Polaris'
data (`Data\Expansions\12_Midnight.lua`) has each dungeon boss's encounter id.

Rob, 2026-09-22: "do both name AND ID". Keep the name, which a person reads and an Encounter Journal
lookup uses, and add the id, which the events use.

## Links

- Blocks `0023` (Hindsight uses ids) and helps `0013` (next boss after `ENCOUNTER_END`) and `0009`
  (dungeon bosses).

## Not this card

- Reading Keystone Polaris while the game runs. Copy the ids in when the plan is written.

## Acceptance

<!-- AC:BEGIN -->
- [ ] EVERY boss row in the plan SHALL carry both its name and its encounter id. proves: `every boss row has a name and an id`
- [ ] WHEN the addon looks up a boss from a game event, THE ADDON SHALL match by id first, and by name when there is no id. proves: `boss lookup tries id then name`
- [ ] WHEN a row's name and id point at two different bosses, THE CHECK SHALL fail. proves: `a name and id that disagree fail the check`
<!-- AC:END -->

## Tasks

- [ ] Encounter ids for The Venomous Abyss from the Encounter Journal (`EJ_GetEncounterInfo`), and
  for the dungeons from Keystone Polaris' data file, copied in by hand once.
- [ ] `update-gear-plan.ps1` writes both.
- [ ] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "B (but do both name AND ID)" in a SecondBrain session.
  Ideation only.
