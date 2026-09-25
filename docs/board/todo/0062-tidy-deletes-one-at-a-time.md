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
