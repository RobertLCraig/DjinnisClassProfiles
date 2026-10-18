# 0106 Old loadout deletes never land, and the drift step after them is skipped

## What I need from you

Nothing now. One check after a `/reload` would settle the first question below: are "DotC M+",
"DotC Raid ST *", "WS M+" and "WS Raid Most Bosses" still in the Feral loadout list?

## Why

Rob, 2026-10-18 22:35 to 22:37, Feral, talent window closed, after `/dcp loadouts`. He picked
the delete on the old-loadouts prompt. Chat:

```
"DotC M+" did not change in time; the next is tried anyway.
"DotC Raid ST *" did not change in time; the next is tried anyway.
"WS M+" did not change in time; the next is tried anyway.
"WS Raid Most Bosses" did not change in time; the next is tried anyway.
Deleted 0 of 4 old loadouts.
```

So `C_ClassTalents.DeleteConfig` answered success for each one (otherwise `tagNext` says "The game
would not delete"), and `C_Traits.GetConfigInfo(id)` still returned the name 15 seconds later
(`PlanTab.GIVE_UP`). Card `0063` already records the same failure: success returned, the change
dropped by the server.

Two separate faults:

1. **The delete does not land, or lands and is not seen.** Unknown which. If the loadouts are gone
   after a `/reload`, `GetConfigInfo` reads a stale cache and the poll should wait for
   `TRAIT_CONFIG_DELETED` (the event Blizzard_ClassTalentsFrame.lua listens for) and not the name.
   If they are still there, the server refused them, and the cause is not known.
2. **The drifted-loadout step never runs after a tag or delete pass.** In `offerLoadouts`, only
   **Not now** goes on to `loadoutGaps` (missing and drifted builds). The **Tag them / Delete them**
   button calls `PlanTab.tagOld`, which starts the queue with no `after`. On 2026-10-18 nine of
   Rob's ten `[CP]` Feral loadouts differed from the addon's builds, and none was offered. The
   workaround now: run `/dcp loadouts` again and click **Not now** on the old-loadouts prompt.

## Acceptance

- [ ] After a delete pass, the count matches what is in the loadout list after a `/reload`.
      `proves: manual`
- [ ] Clicking Tag/Delete on the old-loadouts prompt goes on to offer drifted and missing builds,
      as Not now does. Self-test check.
