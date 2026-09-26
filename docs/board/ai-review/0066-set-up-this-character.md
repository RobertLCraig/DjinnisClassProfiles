---
needs: 0057
---
# 0066 Set up this character: one button that brings its loadouts in line with the list

## Try this in game (v0.54.9)

On your main, rename one of your builds (right-click its row). Log on to an alt of the same class
and spec. Click **More > Delete old loadouts**. Chat lists "[CP] old name  (no build is called old
name now)". Click **Delete** in the box. The old loadout goes, one at a time. Then click **More >
Make the planned loadouts** to make the new name.

Pass: only "[CP]" loadouts are listed, never the one you are wearing, and nothing goes before the
click.

## Why

Split from card `0057`, 2026-09-25. Rob, 2026-09-24: "I accept if we have to clean up and reload
talents across all characters. (lets build in a way to do that easily." Then, 2026-09-25, on card
`0065`: park loading all loadouts automatically.

It also has a job now that `0057` is built. Rename or delete one of your builds, and every other
character keeps a "[CP] old name" loadout. That loadout shows under Your loadouts until it is
deleted by hand.

Rob, 2026-09-26, given the choice: build the clean-up part only. Nothing is made, and there is no
login offer, so the park on `0065` holds.

## What

- One button, and one offer on login when this character is out of date with the list. The login
  offer is the part Rob parked.
- It lists what it will do and asks first:
  - delete each "[CP] X" loadout that no build names any more;
  - make a loadout for each build that has none;
  - make each drifted one again.
- Keep to the slot limit (the spare, card `0040`). Never delete the loadout you are wearing. Send
  one change at a time (`startTagging`, `makeLoadouts`).
- Only tagged loadouts are touched (card `0059`), so no loadout of the player's own is deleted.

## What was built (v0.54.9)

- `PlanTab.orphanLoadouts(saved, selected, skip)`: each "[CP] X" on this spec whose X is not in
  `buildsOf(spec)`. The real name must be the tag, so an untagged loadout is never listed. The worn
  one is marked `stays`. Ids in `skip` (the retired ones) are not listed twice. With no builds read
  it lists nothing.
- `PlanTab.tidy` lists the retired ones and then the orphans, each orphan with "(no build is called
  X now)". It deletes through `startTagging`, one at a time, only on yes. `tagNext` still checks
  the name and the worn one before each delete.
- **Delete old loadouts** is on every class now, not druids only. The old Dreamgrove names stay
  druids' only, because `retiredLoadouts` checks the class.
- **Changed on purpose:** on Balance, "[CP] WS M+" is deleted now, because no Balance build is
  called "WS M+". A card `0062` check kept it; that check now expects it gone.
- **Not built (still parked):** the one button that also makes and resets, and the login offer.
  **More > Make the planned loadouts** does the making by hand.
- `PlanTab.orphanChecks` covers it. Five breaks (untagged counted, no skip, nil builds, the worn
  one not kept, tidy ignoring orphans) fail 19, 4, 1, 1 and 5 checks.

## Acceptance

- [x] What Delete old loadouts would delete is pure and checked: orphans, the worn one kept, only
  tagged ones. proves: self-test
- [x] Nothing changes without the click. proves: self-test
- [ ] In game, on an alt after a rename on the main: the old "[CP]" loadout goes. proves: manual
  (Rob)
- [ ] Parked: one button that also makes and resets, and the login offer. Waits on Rob unparking
  card `0065`.
