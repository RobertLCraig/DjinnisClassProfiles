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
