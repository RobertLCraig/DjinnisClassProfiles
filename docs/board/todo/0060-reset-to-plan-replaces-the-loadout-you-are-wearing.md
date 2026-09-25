# 0060 "Reset to plan" replaces the loadout you are wearing

## Why

Rob, 2026-09-24, in a live client: "Dungeon" had drifted and was the loadout he wore. "Reset to
plan" refused it ("is the loadout you have selected, so it is not replaced yet") and told him to
pick another loadout and click again. With the talent window open to pick one, the next click was
fenced by "Close the talent window first". A loop with no exit. His words: "I DONT CARE, JUST FIX
IT!"

Deleting the worn loadout drops the character to the starter build, so it cannot be deleted first.

## What

- The worn loadout goes the long way round (`PlanTab.swapSelected`, `PlanTab.finishSwap`):
  1. The plan is made as "<name> (new)" through the normal queue.
  2. It is put on through `ClassTalentHelper.SwitchToLoadoutByName`, as every switch is (card 0011).
  3. Once `GetLastSelectedSavedConfigID` answers the new one, the old one is deleted.
  4. The new one takes the old name through `C_ClassTalents.RenameConfig`, the call behind
     Blizzard's own rename box (`Blizzard_ClassTalentLoadoutEditDialog.lua:56`).
- Any make asked for with the talent window open waits for the window to close and then runs
  (`PlanTab.whenTalentsClose`). Combat still fences.
- A swap that stopped half way is finished by the next click: a leftover "(new)" that is not worn is
  made again from the plan; one that is worn only needs the old one deleted and the name.
- `C_ClassTalents.RenameConfig` is on the offline check's list of allowed writes. It renames and
  never changes talents.

## Acceptance

- [x] The worn drifted loadout is made new, worn, the old deleted and the new renamed. proves: offline-check "Reset to plan swaps the loadout you are wearing"
- [x] With the talent window open it waits, does nothing, and runs once on close. proves: same block, "with the talent window open it waits" and "and only once"
- [x] A switch that does not take keeps the old loadout and says what to do. proves: "a switch that did not take keeps the old one"
- [x] A refused rename leaves the plan worn and says to rename it. proves: "a refused rename is said"
- [ ] In a live client, "Reset to plan" on the worn loadout ends with one loadout of the old name, worn, holding the plan. proves: manual

## Not this card

- The "[CP] " tag (card 0059). The tag plus " (new)" does not fit 30 letters for a 24-letter build
  name; 0059 must shorten one of them.

## Comments

**2026-09-24, builder.** Built and deployed as v0.47.3. 19 mutations over the new code all turned
the offline check red (`%TEMP%\mutswap.py`); the 0053 and 0058 lists still have no survivors; 36
non-druid specs pass. Not proven: that the game lets `RenameConfig` and `DeleteConfig` run straight
after a switch, and that the switch lands inside `PlanTab.GIVE_UP` (15 s). Only a client answers
that.

**2026-09-25, adversarial review (first pass) of 3198c3f. Back to todo.**

What held. `lua offline-check.lua` at the repo root: exit 0, no FAIL line, output read whole. The
APIs were checked against `wow-ui-source` (live, 09b9db794): `C_ClassTalents.RenameConfig(configID,
name) -> success` and `DeleteConfig(configID) -> success` are both in
`ClassTalentsDocumentation.lua`, `AllowedWhenUntainted`, and neither is under `Blizzard_Deprecated*`.
`RenameConfig` is the call behind the rename box (`Blizzard_ClassTalentLoadoutEditDialog.lua:56`), as
the card says. `C_ClassTalents.SwitchToLoadoutByName` is `HasRestrictions` and "loads the first one
found in the case of duplicate names". Mutations in a scratch copy under `%TEMP%`: dropping the
"only once" clear, skipping the switch, finishing before the new one is worn, and not replacing a
leftover "(new)" all turn the check red.

What broke.

1. **The wait replays a stale plan, and can delete the loadout you are wearing.** With the talent
   window open, `makeLoadouts` saves `jobs` and `swaps` in a closure and replays them on close. Both
   were worked out at the click: which loadout is worn, and the `replace` ids. The window is where
   you change loadouts, and the old message told Rob to do exactly that. Proved in the scratch copy:
   after the "waiting" check, `selected = 9` stands for a switch made in the window. On close the
   check still ran `import (new)|wear (new)|delete|rename`, so the character was switched onto
   Nek'Zali without asking. Worse, found by reading the code and not run: a *second*
   drifted loadout that was not worn at the click is a plain job with `replace = saved[name]`. Put
   it on in the window, close it, and `importOne` calls `DeleteConfig(job.replace)` with no check
   on what is selected. That drops the character to the starter build, which is the harm this card
   and `selectedConfigID`'s comment exist to prevent. Fix: on close, run the ask again
   (`resetDrifted` / `createMissing` / the spare), not the saved jobs. Or have `importOne` refuse
   to delete the selected config whatever the caller does. A check has to switch the selection
   while the window is open.
2. **Survivors in the code that deletes.** Each ran green: removing the `selectedConfigID() ~= swap.oldID`
   guard in `finishSwap` (the one thing that stops it deleting the worn loadout), ignoring
   `DeleteConfig`'s result (the "old kept" path is never exercised), removing the
   `InCombatLockdown()` check in `swapSelected` (combat that starts while the queue runs), and
   removing `not InCombatLockdown()` from the wait path. The builder's "19 mutations, all red" did
   not cover these four.
3. **"A swap that stopped half way is finished by the next click" is only true for half the stops.**
   If the rename is refused after the old one is deleted, the character wears "<name> (new)" and
   no "<name>" exists. The next prompt offers **Create**, not Reset. `createMissing` then imports a
   second copy of the plan as "<name>", and the worn "(new)" is left orphaned in a loadout slot.
   Either pick this state up (a missing name whose "(new)" is worn needs only the rename), or cut
   the claim from the card.
4. Minor. The stopped-swap branch never checks that the worn "(new)" still holds the plan. If it
   was edited, the old one is deleted and "now holds the plan" is said when it does not.

Security. *Weakest point:* two `DeleteConfig` paths that trust ids captured earlier. Someone who
switches loadouts in the talent window during the wait loses the loadout they are wearing (finding
1). *Unchecked:* the `OnHide` replay (checks combat and the fence again, but not what is selected),
and `importOne`'s delete of `job.replace`. There is no outside input: the build strings are
baked in and nothing crosses the network. *Leaks:* nothing. Failures print to the local chat
frame only.

Not looked at in a client: there is no browser surface, and the game cannot be run from here. The
manual criterion stays open. Deploy was not touched.


**2026-09-25, Claude. The first review's findings, fixed in v0.48.1.** Card `0059` landed first
(v0.48.0), so the swap's new loadout is `[CP+] <build>` now, not `<name> (new)`, and it is renamed
`[CP] <build>`.

1. **The wait asks again, and never replays.** `makeLoadouts` takes the ask that worked the jobs out
   (`PlanTab.createMissing` or `PlanTab.resetDrifted`) and runs that when the talent window closes,
   so a switch made in the window is seen. And `importOne` refuses to delete `job.replace` when it
   is the loadout you are wearing, whoever asked.
2. **The four survivors have checks**: the old loadout on again at the end (`finishSwap` now also
   renames nothing onto its name, which would have made two), a refused delete, combat before the
   switch, and combat with the window open.
3. **A rename refused after the old one went is finished by the next Create**: a worn `[CP+] X`
   with no `[CP] X` is renamed, not made twice. One not worn is replaced by the tagged one.
4. **A stopped swap is finished only if the worn new loadout still holds the plan**
   (`PlanTab.holdsPlan`); otherwise it says so and touches nothing.

Checked: `lua offline-check.lua` under Lua 5.1.5, exit 0, no FAIL line. Spec mode 250, 62, 1467, 73
clean; 102 gives its usual 8. Mutations (`%TEMP%\mut0060.ps1`): the reviewer's four and five more
for the new code, 9 of 9 caught, after one check was added for an unworn leftover.

**2026-09-25, adversarial review (second pass) of f48cdcd. Back to todo.**

What held. `lua offline-check.lua` at the repo root: exit 0, no FAIL line, output read whole. The
first review's findings:

1. *Stale replay*: closed as stated. `makeLoadouts` hands `again` to `whenTalentsClose` and never the
   saved jobs, and `importOne` refuses a `job.replace` that is `selectedConfigID()`. But the re-ask
   opens a new hole; see finding 1 below.
2. *Survivors*: closed. `%TEMP%\mut0060.ps1` run by me: 9 of 9 caught, including the four named in
   the first review. The `"old worn"` branch in `finishSwap` cannot be reached from
   `swapSelected`'s poll, which only calls it once `selectedConfigID() == newID`. It is a guard for
   direct callers. That is fine, but the check calls it directly and does not follow a real flow.
3. *Refused rename not finished*: closed. A worn `[CP+] X` with no `[CP] X` is renamed by Create,
   and one that is not worn is replaced (`replace = temp`). Both have checks.
4. *Edited leftover*: closed. `PlanTab.holdsPlan` fences both the Reset and the Create branch, and
   each says so.

APIs checked in `wow-ui-source` (live, 09b9db794): `RenameConfig(configID, name) -> success` and
`GetLastSelectedSavedConfigID(specID) -> configID?` are in `ClassTalentsDocumentation.lua` as the
code uses them, and `ClassTalentHelper.SwitchToLoadoutByName` is a thin wrapper over
`C_ClassTalents.SwitchToLoadoutByName`.

What broke.

1. **The re-ask on close is wider than the click, and wipes edits made in the window.** The prompt
   lists the spec and the loadouts it will reset or create (`offerLoadouts`). The click only
   agreed to those. On close, `again` runs `resetDrifted` / `createMissing` from scratch, for
   whatever spec and whatever drift is there *then*. The talent window is where talents are
   edited. Proved in a scratch copy (`%TEMP%\rev0060`): the prompt offered only "Raid: Nek'Zali".
   With the window open, "[CP] Raid: Entombed Sentinels" was edited so that it differs from its
   plan. On close the calls were `delete [CP] Raid: Entombed Sentinels|import [CP] Raid: Entombed
   Sentinels|delete [CP] Raid: Nek'Zali|import ...`. The player's edits to a loadout they were
   never asked about are deleted. Had that loadout been the worn one, it would have gone through
   the swap. Found by reading and not run: the Specialization tab is in the same window. Change
   spec there and close it, and Reset or Create runs on the *other* spec's loadouts, which nobody
   was shown. `spareOnHide` already refuses both cases (`w.spec ~= playerSpec() or w.selected ~=
   ...`, the 0040 third review). Fix: keep the spec and the confirmed names with `again`. On close,
   drop the ask if the spec changed, and only act on names still both confirmed and drifted or
   missing. Needs a check that edits an unlisted loadout during the wait and one that changes spec.
2. Minor. When the re-ask on close finds nothing left to do, `makeLoadouts` returns `"nothing"`
   and says nothing. The player was told "this goes ahead then". And `whenTalentsClose` keeps only
   the last ask, so Create and then Reset with the window open drops the Create without a word.
   The second part predates this fix.

Security. *Weakest point:* the deferred ask on `OnHide`. It runs destructive `DeleteConfig` work
on state that was not what the player confirmed (finding 1). *Unchecked:* the spec and the
confirmed name set on that path. Combat and the fence are checked again, and `importOne` now
guards the worn id. There is no outside input: the build strings are baked in and nothing
crosses the network. *Leaks:* nothing. Messages go to the local chat frame only.

Not looked at in a client. There is no browser surface and the game cannot be run from here. The
manual criterion stays open. Deploy was not touched.