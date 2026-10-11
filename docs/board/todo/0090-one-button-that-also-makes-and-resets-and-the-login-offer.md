---
not_for_the_loop: Rob parked this on 2026-09-25 ("park loading all loadouts automatically"), and it waits for him to unpark it
---
# 0090 One button that brings a character's loadouts in line with the list, and the login offer

## Why

Card `0066` built only the clean-up half of "set up this character". A character can still be out of
date with the build list in two other ways: a build with no loadout here, and a loadout that has
drifted from its build. Each is fixed by hand today, from More > Make the planned loadouts, and
nothing tells the player when they log on that this character is behind.

Rob, 2026-09-24: "I accept if we have to clean up and reload talents across all characters. (lets
build in a way to do that easily." Then, 2026-09-25, on card `0065`: "Lets park loading all
loadouts automatically."

## Not this card

- Not Delete old loadouts: that is built, card `0066`.
- Not saving one build from its row: card `0065`.

## Acceptance

<!-- AC:BEGIN -->
- [ ] Parked: one button that also makes and resets, and the login offer when this character is out of date with the list. Waits on Rob unparking card `0065`'s park on automatic loadouts. proves: manual
<!-- AC:END -->

## Tasks

- [ ] Rob says whether the park on automatic loadouts is lifted
- [ ] If it is: one button that lists the deletes, the makes and the resets, asks once, and runs them one at a time (`startTagging`, `makeLoadouts`), within the slot limit and never touching the worn loadout
- [ ] If it is: the login offer when the character is out of date

## Comments

**2026-10-11** Split off 0066 in the clear-down: this is the half Rob parked on 2026-09-25, when he
asked to stop loading loadouts automatically. The clean-up half is built on `0066`. Rob unparks it,
or discards it.
