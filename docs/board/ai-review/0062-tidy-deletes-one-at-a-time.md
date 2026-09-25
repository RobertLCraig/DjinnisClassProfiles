# 0062 `/dcp tidy yes` deletes one loadout at a time

## Why

The 0059 review, 2026-09-25: `PlanTab.tidy` (`DjinnisClassProfiles.lua`, near line 7580) sends every
`DeleteConfig` in one frame. The server takes one loadout change in flight and refuses the rest with
"You can't do that right now". Rob saw exactly that from "Tag them" (card 0059). A druid with more
than one old Dreamgrove loadout would see "Could not delete" for all but one.

## What to do

Send tidy's deletes through the same queue as "Tag them" (`PlanTab.tagging` / `PlanTab.tagNext`):
one delete, wait until the config is gone, one beat more, then the next. A refusal is tried again.
Its end line says "Deleted N old loadouts." rather than "Tagged".

## Done when

1. `lua offline-check.lua` passes, with a check against the timed server model in `tagChecks` that
   two deletes both land and none is refused.
2. In game, on a druid with two or more old Dreamgrove loadouts: `/dcp tidy yes` deletes them all
   with one command, and chat says "Deleted N old loadouts."

## Comments

### 2026-09-25: hit in a live client, built in v0.48.9

Rob, Balance, 12:27: `/dcp tidy` listed six (EC M+, EC Raid Cleave, EC Raid ST, KotG M+, KotG Raid Cleave, KotG Raid ST). Delete then said "Could not delete" for five and "Deleted 1". His dropdown afterwards still showed all six (the dropdown may not have refreshed).

The same session showed why Balance offered nothing on a spec change: Balance had none of its four planned builds, but the character's druid specs held about 38 of the 40 loadout slots, `loadoutRoom` keeps two for the spare, so `missing` was emptied and the box stayed quiet. The six old Dreamgrove loadouts were the room, and the box never mentioned them.

Built:
1. `PlanTab.retiredLoadouts(saved, selected)`: the `PlanTab.RETIRED` names on a druid, never a live build for the spec in hand, the worn one marked `stays`. `PlanTab.beforeTag` joins them to card 0059's untagged ones, so the login and spec-change box lists them ("deleted: an old Dreamgrove loadout", in red) and "Tag them" deletes them.
2. `PlanTab.startTagging(todo)` runs any list through 0059's queue: one change, wait for it to land, one beat, retry a refusal. Deletes of old Dreamgrove loadouts count apart: "Deleted N old Dreamgrove loadouts." `PlanTab.tidy(true)` now starts that queue and answers "started".
3. Checks: the list (druid only, a name live for the spec kept, the worn one staying), the box rows, Tag them deleting two with none refused and no "Tagged" line, tidy deleting three with none refused. 7 new mutants and the 23 earlier ones all caught.

## What I need from you

On Balance: `/reload`, then change spec away and back (or open More > Make the planned loadouts).

**Pass:** the box lists the old EC and KotG loadouts as "deleted: an old Dreamgrove loadout". "Tag them" deletes them all with one click, a second or so apart, then "Deleted N old Dreamgrove loadouts." A second later the box offers "Create" for the Balance builds.

**Fail:** a "would not delete" line, a loadout of yours deleted, or a Lua error.
