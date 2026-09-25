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
