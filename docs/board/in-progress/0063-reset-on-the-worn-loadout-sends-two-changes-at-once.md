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
