---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0009
---
# 0022 The best loot spec for each raid boss

## Why

A boss drops one item from the pool for your loot spec. The smaller the pool, the better the chance
of a planned item. KeystoneLoot shows this for dungeons ("X has a smaller loot pool than Y") but
not for raid bosses.

## Links

- Needs `0009`: which items each spec plans.
- Uses the Encounter Journal harvest the BiS tabs already have.
- Pairs with `0015`, `0021` (the loot spec button) and `0013` (the popup can name the spec).
- Draws by `0020`'s rules.

## Not this card

- Changing the loot spec by itself.

## Acceptance

<!-- AC:BEGIN -->
- [ ] FOR each raid boss with a planned item, THE PLAN TAB SHALL name the loot spec with the best chance of a planned item, and show that spec's planned items and pool size, for example "Guardian: 2 of 5". proves: `plan tab names the best loot spec per boss`
- [ ] WHEN two specs tie, THE ADDON SHALL name the current spec if it is one of them. proves: `a tie goes to the current spec`
- [ ] WHEN no spec has a planned item from a boss, THE ADDON SHALL show no loot spec line for it. proves: `no loot spec line without a planned item`
<!-- AC:END -->

## Tasks

- [ ] Pool size per spec with `C_EncounterJournal.SetLootFilter(classID, specID)` and the loot list,
  once, out of combat, cached for the session. Check the names in `wow-ui-source`.
- [ ] Chance = planned items in the pool / pool size.
- [ ] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "B" in a SecondBrain session. Ideation only.
