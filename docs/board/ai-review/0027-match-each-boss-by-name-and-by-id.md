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
- [x] EVERY boss row in the plan SHALL carry both its name and its encounter id. proves: `every boss row has a name and an id`
- [x] WHEN the addon looks up a boss from a game event, THE ADDON SHALL match by id first, and by name when there is no id. proves: `boss lookup tries id then name`
- [x] WHEN a row's name and id point at two different bosses, THE CHECK SHALL fail. proves: `a name and id that disagree fail the check`
<!-- AC:END -->

## Tasks

- [x] Encounter ids for The Venomous Abyss, copied in by hand once. Not from `EJ_GetEncounterInfo`
  and not from Keystone Polaris, for the reasons in the comment below.
- [ ] `update-gear-plan.ps1` writes both. Dropped: that script never wrote `PlanTab.BOSSES`, the
  table is hand-kept, so there is nothing for it to write.
- [x] Offline checks under the names above.

## What I need from you

There is no test client, so nothing here has been seen in the game. Two looks:

1. `/djbis test` in the game. The three named checks run there as well as offline, and the
   `canRead` guard in `PlanTab.bossRow` only means anything against the real `canaccessvalue`.
2. Any Venomous Abyss pull. Nothing in this addon reacts to it yet (that is `0013` and `0023`), so
   the look is indirect: BigWigs enables its boss module off `ENCOUNTER_START` by the same id this
   card copied, so if BigWigs' Nek'zali timers start on the Nek'zali pull, id 3470 is the one the
   event carries. If BigWigs stays quiet, the id is wrong and so is this table.

## Comments

- 2026-09-22 Claude: written from Rob's "B (but do both name AND ID)" in a SecondBrain session.
  Ideation only.
- 2026-09-22 Claude (built, branch `worktree-agent-a4684978735bb9777`): **What was built.** Every
  row of `PlanTab.BOSSES.Feral` carries `id`, the encounter id `ENCOUNTER_START` and `ENCOUNTER_END`
  hand over, except the Mythic+ row, which is a plan for any key and not a boss, and the check says
  so by name. `PlanTab.bossRow(bosses, id, name)` takes the events' first two payload fields in
  order and answers the row: by id when there is one (an unknown id answers nil rather than falling
  back, so a hotfixed name can never point a known id at the wrong row), by name only when the id
  is nil, exact after `norm()` or the event's long name starting with the row's short one. Both
  arguments pass `canRead` before they are compared, per the 2026-08-21 secret-values entry; the
  event payload in `EncounterInfoDocumentation.lua` carries no `SecretWhen` flag, so that is belt
  and braces. No event was registered and no top-level local was added.
  **Where each id came from.** Not the Encounter Journal: `EJ_GetEncounterInfo` takes the journal's
  own encounter id (Nek'zali is 2888 there) and the local Blizzard source documents only its first
  four returns, none of which is the id the events use, so the journal cannot supply these
  offline and I will not rely on a seventh return from memory. Not Keystone Polaris either: its
  `12_Midnight.lua` stores the journal id (2659 for Arcanotron Custos), and there are no dungeon
  rows to give it to anyway. The nine ids are copied from
  `BigWigs_TheVenomousAbyss\*.lua` (`mod:SetEncounterID(...)`) and, for Nymrissa, from
  `BigWigs_MidnightLairs\Nymrissa.lua`; all nine agree with the second source,
  `ArchonTooltip\Localization.lua`, which keys its boss names as `Encounter-3470` and so on. Nek'zali
  3470, Entombed Sentinels 3445, The Lost Explorers 3497, Vashnik 3455, Sszorak 3420, The Twin Fangs
  3421, The Coiled Altar 3429, Ula'tek 3492, Nymrissa Wavecaller 3379. The offline reference in
  `selfTest` is the ArchonTooltip enUS names by id, which is also where the fact that the events say
  "Nek'zali the Soulcoiler" and "Vashnik the Malignant" came from.
  **Checks.** `lua offline-check.lua` under Lua 5.1.5 and 5.4.6, both exit 0. Two mutations, each
  on a temp copy: giving Sszorak the Twin Fangs id turned `a name and id that disagree fail the
  check, Sszorak is The Twin Fangs` and `an id used once` red; deleting the `return nil` that stops
  an unknown id falling through to the name turned `an unknown id does not fall back to the name`
  red. Not seen in the game.
  **Left out.** `bossFor`, `PlanTab.boss` and the drawn tab still work by name, because a person
  clicks a name and no event feeds them yet; `0013` and `0023` are the consumers of `bossRow`. The
  existing `roll` frame registers `ENCOUNTER_END` without an `IsEventRegistered` check and its
  handler still passes the name to `bonusRollVerdict`; that is the BiS list's source matching, a
  different table, and I left it alone rather than widen this diff into a card two other sessions
  may be touching. The `update-gear-plan.ps1` task was dropped as stated above.
