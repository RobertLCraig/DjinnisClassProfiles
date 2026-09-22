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
3. (added in review) Before that same pull, paste this once, it prints what the event carries:
   `/run local f=CreateFrame("Frame") f:RegisterEvent("ENCOUNTER_START")
   f:SetScript("OnEvent", function(_,_,id,name) print(id, name, canaccessvalue(id), canaccessvalue(name)) end)`
   before the pull. Expect `3470 Nek'zali the Soulcoiler true true` for Nek'zali. Anything but
   `true true` means the payload is secret in practice and `bossRow` will answer nil for every boss.

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
- 2026-09-22 Claude (review, branch `worktree-agent-aee97ee737c4a8cc6`): **pass, with two small
  fixes in place; moved to `human-review/` because nothing here has run in the game.**
  **The ids.** All nine checked by me against both sources, not three: every
  `mod:SetEncounterID(...)` in `BigWigs_TheVenomousAbyss\*.lua` and `BigWigs_MidnightLairs\Nymrissa.lua`,
  and every `L["Encounter-NNNN"]` in `ArchonTooltip\Localization.lua` (enUS block). Nine of nine
  agree with the table, and the long event names ("Nek'zali the Soulcoiler", "Vashnik the
  Malignant") are BigWigs' `NewBoss` names as well. `EncounterInfoDocumentation.lua` in the local
  Blizzard source has `encounterID` then `encounterName` as the first two payload fields of both
  events and no `SecretWhen` flag on either, as the build comment says.
  **The checks.** `lua offline-check.lua` under 5.4 and the 5.1 exe both exit 0, before and after
  the fixes. Seven mutants, each on a temp copy, each run under both versions, each red: Sszorak
  given the Twin Fangs id (disagree and used-once red), the `return nil` after the id loop removed
  (unknown id falls back red), Vashnik's id deleted, the name tried before the id, the prefix match
  narrowed to exact (the long event name red), the id compared as a string, and a row named
  "Nek'zali Wavecaller" (the new prefix check below red).
  **What broke.** Two things, both fixed in `DjinnisBiS.lua`, no new top-level local. (1) In
  `PlanTab.bossRow` the guard read `id ~= nil and canRead(id)`, so the comparison a secret throws on
  ran before the guard meant to stop it; now `canRead(id) and id ~= nil`. Belt and braces still, since
  the payload carries no secret flag, but a guard that runs second guards nothing. (2) The Vashnik
  mutant did not go red, it crashed: a row with no id made `seenID[nil] = ...` raise "table index is
  nil" and end the whole self-test, offline and in `/djbis test` alike. Now `seenID[row.id or 0]`,
  and the mutant is one red line. Also added, inside the existing `every boss row has a name and an
  id` group: no row's normalised name may start with another's, because the name path answers the
  first row the event name starts with and an earlier row would win every time. The table passes
  today; the check is for the next hand edit.
  **What held.** Id wins over a disagreeing name; an unknown id answers nil rather than the name; the
  Mythic+ row has no id and cannot be reached by one; `type(name)` before `canRead(name)` is safe
  because `type()` sees through a secret (DECISIONS 2026-09-04) and a non-string never gets compared;
  `norm()` strips non-ASCII bytes so a deDE name cannot match an enUS row, which is the id's job.
  **Security.** Weakest: the name path's prefix match, where a future row whose name is a prefix of
  another's would silently answer the wrong plan; the new check makes that a red `/djbis test`
  rather than a wrong loadout. Unchecked: nothing, both arguments come from a Blizzard event with
  no secret flag and are tested with `canRead` before use; `bossRow` has no caller yet, so no path
  in exists until `0013` or `0023`. Leaks: nothing, it returns a row of the addon's own hand-kept
  table or nil, and no id or name goes to chat or SavedVariables.
  **Not looked at in the game**, the two looks above stand; a third is added below.
