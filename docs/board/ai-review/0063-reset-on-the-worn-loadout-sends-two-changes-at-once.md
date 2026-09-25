# 0063 Reset on the worn loadout sends two loadout changes in one frame

## Why

The second 0059 review, 2026-09-25. The server takes one loadout change in flight and refuses the
rest ("You can't do that right now"; Rob saw it from "Tag them", card 0059).

- `finishSwap` sends `DeleteConfig(old)` and then `RenameConfig(new)` in the same frame, just after
  the switch lands. The rename is likely refused, so Reset to plan on the worn loadout ends at
  "Rename it in the talent window".
- `importOne` deletes and then imports in the same frame.
- The fence does not cover a swap in progress: `PlanTab.q` is cleared before `swapSelected`, so
  "Tag them" can start during the swap's wait.

## What to do

Send each second change only once the first has landed, the way `PlanTab.tagNext` does: wait for
the config to read the new state, one beat more, and retry a refusal. Hold `loadoutFence` for the
whole swap.

## Done when

1. `lua offline-check.lua` passes, with checks against a timed server model (one change in flight)
   for `finishSwap` and `importOne`.
2. In game: wear a loadout whose build has drifted from the plan, click Reset to plan. Chat says it
   now holds the plan, with no "You can't do that right now" and no "Rename it in the talent window".

## Comments

**2026-09-25, Claude.** Built, v0.51.1.

- `importOne` with a replace now only deletes and answers `"deleted"`. `stepLoadouts` runs the same
  job again once `waitThenStep` sees the old config gone and one beat more; the second run only
  imports.
- `finishSwap` sends the delete, waits for the old config to read gone and one beat more, then the
  rename, and waits for the new name. Each refusal is tried again, `TAG_TRIES` times a `POLL` apart,
  as `tagNext` does. It answers `"working"` at once; `swap.result` holds how it ended.
- `PlanTab.swapping` holds the fence from the switch in `swapSelected` to the end of the rename.
  `loadoutFence`, `wearSpare`, `loadTalents` and `saveOne` refuse while it is set.
- `PlanTab.swapChecks` runs both against the timed server model from `tagChecks`. With the fix
  broken on purpose, five of its checks failed ("refused" in the calls); with it, none.
- Not changed: `setupStep` (a group setup's spec change) waits for `tagging` only, not a swap.

Done-when 1 passes (`offline-check.lua` under Lua 5.1, both modes). Done-when 2 is Rob's, in game.

**2026-09-25, Claude (adversarial review of 2cf88bf).** One medium finding, two low, and the
checks miss two of the waits. Left in `ai-review/` at the caller's request (another session holds
the Lua file for `0057`); the verdict is a bounce to `todo/` for finding 1. Line numbers are 2cf88bf's.

What I ran. `offline-check.lua` and `offline-check.lua 250` under Lua 5.1 in the repository: both end
"no FAIL lines". Then eleven mutations on a copy of 2cf88bf (the repository file was not touched):

| Broken on purpose | Checks that went red |
|---|---|
| `importOne` deletes and imports in one frame (the old code) | 3 |
| no retry of a refused change in `finishSwap` | 1 |
| no beat after a change lands | 1 |
| `swapSelected` or `finishSwap` sets no fence; `loadoutFence` ignores it; `stop` never lets go | 10, 6, 2, 80 |
| `finishSwap` renames without waiting for the delete to read gone (`:7367` made `true`) | **0** |
| `waitThenStep` skips the `goneID` wait (`:7241` made `false`) | **0** |
| `loadTalents` or `saveOne` ignores `PlanTab.swapping` | **0**, 0 |

The first zero is the model: with `lag = 1` a change lands in the same beat the retry comes round, so
"waits until it lands" and "waits one beat" look the same. With `lag = 3` at `:10605` the checks still
pass and that mutation goes red. The second zero is the model too: its `CanCreateNewConfig` reads the
same busy flag, so the `goneID` wait never changes anything there. Nobody knows yet whether the real
`CanCreateNewConfig` reports a delete in flight.

Findings:

1. **Medium. `waitThenStep` imports anyway when the delete never lands (`:7241` to `:7249`).** Once
   `GIVE_UP` passes with the old config still listed, it sets `goneID` to nil, and because
   `q.waited >= GIVE_UP` it calls `stepLoadouts` straight away. The second run only imports. What
   goes wrong: `DeleteConfig` returns true but the server drops it (the "You can't do that right now"
   from `0059` may come after the call, not as its return value; `ClassTalentsDocumentation.lua` only
   says `success: bool`), or it is slow. The import then makes a second "[CP] Raid: X" next to the old
   one. `savedLoadoutNames` keys by name, so one of the two is invisible to the addon, and nothing in
   the talent window checks for a duplicate name. If that import fails as well, `:7201` says "The old X was
   deleted", which is not true. Fix: if the config still reads as there at `GIVE_UP`, put the id
   back on `job.replace`, clear `job.deleted` and add the job to `q.retry` (the final pass deletes
   again), or drop it with "The old X did not go; nothing was made". Add a check where the model
   accepts the delete and never applies it.
2. **Low. A group setup during a swap loses its loadout step (`:4840`, `:4862`).** `setupStep` waits
   for `tagging` and not for `swapping`. Clicking Set up during the 5 to 20 seconds of a swap makes
   `loadTalents` answer "busy", `setupStep` treats that as missing, and the gear goes on without the
   loadout. A spec change in the setup is not fenced at all, and it can use up the 8 tries on the
   swap's delete or rename, ending at "old kept" or "unnamed". The builder named this. Fix: in
   `setupStep`, treat `PlanTab.swapping` the way it treats `tagging` (set `afterTag`, answer
   "renaming"), and call `PlanTab.afterTagging()` from `finishSwap`'s `stop`.
3. **Low, not this card's code: `wearSpare` is the same bug (`:7036`, `:7046`).** It deletes old
   spares in a loop and then starts the import in the same frame. The import is usually refused and
   then retried by the queue, so this mostly fixes itself, but it breaks the handover's rule of never
   sending changes in a loop. Suggest a new card.
4. **Low, checks.** Change `lag` to 3 in `swapChecks`. Add a model whose `CanCreateNewConfig` ignores
   a delete in flight, so the `goneID` wait is actually tested. Add one line each for `loadTalents`,
   `saveOne` and `wearSpare` refusing while `swapping` is set.

What held: `swapping` is let go on every way out (the switch timing out, no helper, each `stop`), so
the fence cannot stay stuck until a `/reload`. The `after` wrapper drops stale timers. An old loadout
worn again is still never deleted. The switch counts as landed only when `GetLastSelectedSavedConfigID`
changes, which Blizzard updates on the commit's `TRAIT_CONFIG_UPDATED`
(`Blizzard_ClassTalentsFrame.lua:380-389`), so the delete is not sent before the switch has taken.

No browser surface: this is an in-game addon, so there was nothing to screenshot. Done-when 2 still
has to be checked in the game.

Security:
1. **Weakest point:** a delete the call reports as done but the server never applies. That is how a
   duplicate "[CP]" loadout gets made (finding 1). Someone can cause it from the game only by
   keeping the server busy, which is not an attack on anyone else.
2. **Unchecked:** `setupStep`'s spec change and loadout switch skip the swap fence (finding 2), and
   `wearSpare`'s loop has no queue (finding 3). Nothing comes from outside the client: the stored
   strings are parsed by Blizzard's own import code before anything is deleted.
3. **What it leaks:** nothing. Failures go to the player's own chat frame as loadout names, and no
   data leaves the client.
