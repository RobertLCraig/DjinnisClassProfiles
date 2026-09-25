# 0067 The spare deletes old spares in a loop, then imports in the same frame

## Why

Card `0063`'s review, 2026-09-25. `PlanTab.wearSpare` deletes every old spare this character made
in one `for` loop, then starts the import queue at once. The server takes one loadout change in
flight (the trap in `docs/HANDOVER.md`), so the second delete and the import can be refused. The
queue's quiet retry usually makes the spare anyway, so nobody has seen it fail. It still breaks the
rule: a list goes through `PlanTab.startTagging`, never a loop.

## What to do

- Send the old spares' deletes through `startTagging`, and start the spare's import once that queue
  ends. `PlanTab.afterTagging` is the hook, as `setupStep` uses it.
- Or give the spare job a `replace` for the one old spare, as Reset does (card `0063`). The queue
  then deletes it, waits for the delete to land, and imports.
- Keep the worn spare: it is never deleted (card `0040`).

## Done when

1. `lua offline-check.lua` passes, with a check against `swapChecks`' timed server model: two old
   spares and a new one, and no call refused.
2. In game: double-click three different unsaved builds, one after the other. Each is worn through
   the spare, and chat never says "You can't do that right now".

## Comments

**2026-09-25, Claude.** Built, v0.52.5. I took the second way. The new spare's job gets a
`replace` for the old spare, and the queue from card `0063` deletes it, waits for the delete to
land, then imports. There is only one old spare to replace: a worn spare stays until the next one
is on, so there is one spare that is not worn, at most. A second, left by some fault, is deleted
at the next wear. This is why the check has one old spare and one worn spare, not two old ones.
`wearMadeSpare` forgets the replaced spare's id once it is gone (`job.oldSpare`). The no-room
check now counts the old spare as the room.

The check is in `swapChecks`, on the timed server. It expects "delete 3|import|wear", no refused
call, and the worn spare kept. Breaking the fix three ways made 6, 9 and 1 checks fail.

**2026-09-25, Claude (adversarial review of 7bae4dd).** Does not hold: one regression, and the
"second spare goes at the next wear" claim is false. Stays in `ai-review/`. Line numbers are at
7bae4dd.

Run: `offline-check.lua` and `offline-check.lua 250` under Lua 5.1 on a temp copy, both end "no
FAIL lines". Then five probes added to `swapChecks` on the temp copy only, on the same timed server:

1. **Every slot full with an old spare now fails every time (regression).** The no-room check
   (`:7125`) lets the job through because the old spare "is the room". But `importOne` asks
   `C_ClassTalents.CanCreateNewConfig()` (`:7160`) BEFORE it reaches the replace's delete, and at
   the cap that is false: the addon's own refusal text says "or all slots are full", and Blizzard
   greys out New and Import on the same call (`Blizzard_ClassTalentsFrame.lua:516, 541`). Probe:
   cap 3, loadouts Mine, old spare 3, worn spare 4. Result: `wearing`, then no call at all, the
   quiet retry fails the same way, and it prints "failed". The old spare is never deleted, so every
   later double-click fails too. v0.52.4 deleted first and could wear a spare at the cap. Fix: for
   a job with `replace`, skip the `CanCreateNewConfig` gate on the delete step (the string has
   already parsed, so the old loadout is still never lost to a bad string), and let the retry after
   the delete lands check it before the import, which `waitThenStep` already waits for. Add a
   `swapChecks` case with `CanCreateNewConfig` false at the cap. Reset's replace (card 0063) goes
   through the same gate and fails the same way at the cap.
2. **A leftover spare never goes.** The comment at `:7119` and the entry above say it "goes at the
   next wear". Each wear deletes one spare and makes one, so the count never goes down. Probe:
   spares 3, 4, 6, three wears in a row. Result: 3 live and 3 recorded after each one ("delete 3 |
   delete 4 | delete 6"). One slot out of the 40 shared by every spec stays used for good, where
   v0.52.4's loop cleared it. Fix: when more than one spare is not worn, send the extras'
   deletes through `startTagging` and start the spare from `afterTagging`. Or say plainly in the
   comment that a leftover stays.
3. **Wrong name in the failure messages (low).** The spare job's name is the NEW spare. So an import
   refused after the delete landed says `The old "[CP*] Raid: Vashnik" was deleted and not made
   again. More > Make the planned loadouts offers to create it.` (`:7295`), but the old one was
   `[CP*] Raid: Sszorak`, and that menu item never makes spares. A delete that never lands says
   `The old "[CP*] Raid: Vashnik" did not go` (`:7345`), with the same wrong name. Fix: for a job
   with `oldSpare`, name `configName(oldSpare)` (read before the delete) and leave out the menu
   hint.

What held:
- Every slot full with no old spare: answers `full` before any call.
- The old spare becomes the worn one mid-queue: probe E (server busy at the click, then selected
  = 3). `importOne`'s check that the loadout is not the worn one refuses, nothing is deleted, and
  id 3 stays recorded.
- A delete that never lands: probe D. It is sent again once in the final pass and never imported
  over, and id 3 stays in `spareIDs` because `configName` still sees it (`:7245`). If that delete
  lands later, the dead id stays recorded. That is harmless unless the game reuses config ids, and
  v0.52.4 had the same gap.
- An import fails after the delete landed: probe C. `spareIDs[3]` is cleared, and `q.jobs[1]` is the
  same table after `finishLoadouts` swaps in the retry list, so `oldSpare` survives the final pass.
- `spareOnHide`: wearSpare runs from the start 0.5 s after the window closes, so it picks `old`,
  `selected` and `free` again then, and it bails out if the spec or the selected loadout changed.

Security:
- **Weakest point:** deletes go by recorded config id (`DjinnisCPCharDB.spares`). An id that is
  recorded but dead (point D above) would delete somebody else's loadout if the game ever reused it.
  Nothing here checks the name before `DeleteConfig`. Adding `configName(old)` starts with
  `PlanTab.SPARE` to the loop at `:7122` closes it.
- **Unchecked:** the build string goes to Blizzard's own header reader, and a bad one is refused
  before any delete. SavedVariables are trusted as written by this addon. There is no network path.
- **Leaks:** nothing. The messages go to local chat and name only the player's own loadouts.

No UI surface to screenshot: the change is in the queue. The in-game check is still Done-when 2,
plus: at 40 of 40 slots, double-click an unsaved build that has an old spare, and see whether it is
worn.
