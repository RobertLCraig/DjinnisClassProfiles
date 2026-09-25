---
needs: 0057
waiting_on: Rob to unpark making loadouts on their own (card 0065) - recheck 2026-10-09
---
# 0066 Set up this character: one button that brings its loadouts in line with the list

## Why

Split from card `0057`, 2026-09-25. Rob, 2026-09-24: "I accept if we have to clean up and reload
talents across all characters. (lets build in a way to do that easily." Then, 2026-09-25, on card
`0065`: park loading all loadouts automatically. So this waits for him.

It also has a job now that `0057` is built. Rename or delete one of your builds, and every other
character keeps a "[CP] old name" loadout. That loadout shows under Your loadouts until it is
deleted by hand.

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

## Acceptance

- [ ] The plan of what Set up would do is pure and checked: orphans, missing, drifted, the worn one
  kept. proves: self-test
- [ ] Nothing changes without the click. proves: self-test
- [ ] In game, on an alt after a rename on the main: the old "[CP]" loadout goes and the new one
  comes. proves: manual (Rob)
