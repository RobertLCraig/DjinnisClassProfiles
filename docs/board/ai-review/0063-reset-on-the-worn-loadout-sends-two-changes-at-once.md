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
