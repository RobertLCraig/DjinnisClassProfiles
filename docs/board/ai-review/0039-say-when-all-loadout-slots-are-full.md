# 0039 Say when all loadout slots are full, before making any

## Why

Rob, 2026-09-23: "Create 3" made nothing. Blizzard's dropdown said "You've reached the maximum
number of loadouts. Delete a loadout from any of your specializations to free up a slot." The cap
is `Constants.TraitConsts.MAX_COMBAT_TRAIT_CONFIGS`, 40, over every spec of the character. The
queue did not know: each build waited 15 s for `CanCreateNewConfig`, twice, then failed with a
vague reason.

## Built, v0.35.2

- `PlanTab.freeLoadoutSlots()` counts `GetConfigIDsBySpecID` over each of the player's specs and
  takes it from the cap. Nil when the game will not say.
- `PlanTab.loadoutFence()` refuses when that is 0 and says: "All 40 loadout slots are used, over
  all your specs. Delete some you do not use, then try again." Create and Reset both pass the fence.
- `loadoutChecks`: 5 new checks. Removing the fence turns 4 red.

## Not this card

- Fewer free slots than builds still starts; the builds past the cap fail as before.
- It is not proven that `GetConfigIDsBySpecID` answers for a spec that is not active. If it returns
  nothing, the count is too low and the fence stays open, which is the old behaviour.

## What I need from you

1. With all slots full, `/djbis loadouts`, click Create. Pass: the "All 40 loadout slots" line,
   at once, and no "Making" line.
2. Delete loadouts to make 3 free slots. Create again. Pass: "Made 3 of 3".

## Acceptance

- [ ] WHEN every loadout slot is used, THE ADDON SHALL say so and make nothing.
- [ ] WHEN a slot is free, THE ADDON SHALL make loadouts as before.
