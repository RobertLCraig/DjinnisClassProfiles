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
- [ ] `/reload` first (the game folder holds v0.69.0). `/dcp test` in the game prints `[CP] self-test passed` (the `canRead` guard in `PlanTab.bossRow` only means anything against the real `canaccessvalue`). proves: manual
- [ ] Before a Venomous Abyss pull paste `/run local f=CreateFrame("Frame") f:RegisterEvent("ENCOUNTER_START") f:SetScript("OnEvent", function(_,_,id,name) print(id, name, canaccessvalue(id), canaccessvalue(name)) end)` and pull Nek'zali: it prints `3470 Nek'zali the Soulcoiler true true`. BigWigs' Nek'zali timers starting on the pull say the same. proves: manual
- [ ] As Feral, kill Nek'zali with the talents for the next boss wrong: the wrong-setup popup after the kill names Entombed Sentinels and `Raid: Entombed Sentinels`, not Nek'zali. proves: manual
<!-- AC:END -->

## Tasks

- [x] Encounter ids for The Venomous Abyss, copied in by hand once. Not from `EJ_GetEncounterInfo`
  and not from Keystone Polaris, for the reasons in the comment below.
- [ ] `update-gear-plan.ps1` writes both. Dropped: that script never wrote `PlanTab.BOSSES`, the
  table is hand-kept, so there is nothing for it to write.
- [x] Offline checks under the names above.

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

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

**2026-10-11** Clear-down (attended, Rob asked): ticked 3 criteria, all ticked already and confirmed (checks `every boss row has a name and an id`; `boss lookup tries id then name`; `a name and id that disagree fail the check` exist in `DjinnisClassProfiles.lua` and pass in the Lua 5.1 offline check); all three criteria were ticked and are confirmed offline. Looks rewritten for v0.69.0 (`/djbis test` is `/dcp test`); the BigWigs look folded into the `/run` look; the old look 2 said nothing in the addon reacts to a pull yet, which is no longer true: `PlanTab.onSetupEvent` calls `bossRow` on `ENCOUNTER_END` to move the popup to the next boss, so that is now a direct look; moves to ai-review/ with only in-game looks open.

### 2026-10-19 review (v20261019043606-74b3)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: defect**

I checked the three ticked criteria (the boxes marked done) against the code.

**#1: every boss row carries a name and an id.** This holds in the data. Each Feral row and each Balance row in `PlanTab.BOSSES` in `DjinnisClassProfiles.lua` has `boss` and `id`. The only exception is the "Mythic+, any key" row, which the card says is not a boss. One gap: the check `every boss row has a name and an id` in the self-test only loops over `PlanTab.BOSSES.Feral`.

**#2: look up by id first, then by name.** This holds. `PlanTab.bossRow` looks for the id first. An unknown id gives back nil (nothing). It does not fall back to the name. It uses the name only when there is no id. The `ENCOUNTER_END` branch of `PlanTab.onSetupEvent` calls it with the player's spec table. The `boss lookup tries id then name` checks cover this.

**#3: a name and an id that disagree make the check fail.** This is not met for every spec. The `a name and id that disagree fail the check` loop in the self-test only reads `PlanTab.BOSSES.Feral`. `PlanTab.BOSSES.Balance` also has ids, and `bossRow` uses that table on `ENCOUNTER_END` when you play Balance. So a wrong id on a Balance row passes the self-test. A Balance player would then get the wrong row after a kill. The "id used once" and "no name starts with another's" checks have the same Feral-only gap.

The three in-game criteria are only open, so I did not count them as findings.

UNMET: #3 the disagree check (and the id-used-once and name-prefix checks) only loops over PlanTab.BOSSES.Feral, so a Balance row whose id points at another boss passes the self-test but is still used by bossRow on ENCOUNTER_END.

VERDICT: defect

**scope: sound**

I checked if this work went past what card 0027 asked for.

**What I found:**

- All Feral and Guardian boss rows have a name and an id. Proof: `PlanTab.BOSSES` in `DjinnisClassProfiles.lua`. The Mythic+ row has no id, and the card says why.
- `PlanTab.bossRow` tries the id first. It uses the name only when there is no id. The self-test covers this.
- The game does not read Keystone Polaris while it runs. The card's fence holds.
- The big diff is the whole branch history: the rename and many other cards. Those changes belong to their own cards. They are not this card growing.
- The `update-gear-plan.ps1` task was dropped. The card gives a reason: the boss table is kept by hand, so that script has nothing to write.
- `PlanTab.onSetupEvent` now calls `bossRow`. That work belongs to card 0013, and the card says so.

Nothing goes past the fence. Nothing is half done. The only open items are the in-game manual checks, and those are for you to try in the game.

VERDICT: sound

**breakage: defect**

I looked at `PlanTab.BOSSES`, `PlanTab.bossRow`, `PlanTab.onSetupEvent` and the card 0027 checks in `selfTest`, all in `DjinnisClassProfiles.lua`.

**Finding: the checks look only at Feral, but two specs have boss tables.**

- `PlanTab.BOSSES` has two tables: `Feral` and `Balance`. The `Balance` table has 11 rows with ids, and Kith'ix is one of them.
- `PlanTab.onSetupEvent` (`ENCOUNTER_END`) calls `bossRow` with `PlanTab.BOSSES[spec]`. So a Balance player's popup reads the `Balance` table.
- In `selfTest`, all three card checks loop only over `PlanTab.BOSSES.Feral`: "every boss row has a name and an id", "no name starts with another's" and "a name and id that disagree fail the check".
- So a wrong, missing or repeated id in a `Balance` row gives no red line. The popup goes to the wrong boss with no warning.
- Today the `Balance` ids match the Feral ids. This is a gap in the check, not a wrong value now. But the card's rule is "every boss row in the plan", and only half the plan is checked.

The rest held up:

- `bossRow` tries the id first and does not fall back to the name when the id is unknown.
- `bossRow` checks `canRead` before it compares anything.
- Kith'ix (3513) is in `ENCOUNTER_NAMES`.

UNMET: #1 the name-and-id check loops only over `PlanTab.BOSSES.Feral`, so the `Balance` rows that `onSetupEvent` uses are never checked.
UNMET: #3 the disagree check loops only over `PlanTab.BOSSES.Feral`, so a `Balance` row with the wrong id does not make the check fail.

VERDICT: defect

**acceptance**

- **#3 was named by the acceptance lens and is not a ticked criterion here**, so nothing was changed: the disagree check (and the id-used-once and name-prefix checks) only loops over PlanTab.BOSSES.Feral, so a Balance row whose id points at another boss passes the self-test but is still used by bossRow on ENCOUNTER_END.
- **#1 was named by the breakage lens and is not a ticked criterion here**, so nothing was changed: the name-and-id check loops only over `PlanTab.BOSSES.Feral`, so the `Balance` rows that `onSetupEvent` uses are never checked.
- **#3 was named by the breakage lens and is not a ticked criterion here**, so nothing was changed: the disagree check loops only over `PlanTab.BOSSES.Feral`, so a `Balance` row with the wrong id does not make the check fail.

