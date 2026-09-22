---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0009
---
# 0015 A loot spec card when entering a raid or dungeon

## Why

With four specs, the loot spec is the easiest thing to forget. A planned Guardian trinket that
drops while loot spec is Feral is lost for a week.

KeystoneLoot shows a card on entering a dungeon: the wanted items that drop there, per spec, and
"Correct loot specialization set?" (read 2026-09-22). `SetLootSpecialization` is in the 12.1 docs
(`PlayerScriptDocumentation.lua`).

## Links

- Needs `0009`: which plan (raid or Mythic+) covers the place.
- Uses the Encounter Journal harvest the BiS tabs already have, to know what drops here.
- `0013` shows on the same triggers. Show one window, not two: put this card inside `0013`'s popup
  if both are built.

## Not this card

- Changing loot spec without a click.
- Items outside the four druid plans.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN the player enters a raid or dungeon where a planned item for any druid spec drops, THE ADDON SHALL show each spec that wants something here, with its items. proves: `loot card lists planned drops per spec`
- [ ] THE CARD SHALL mark the current loot spec, and SHALL have a Set loot spec button for each other spec shown. proves: `loot card marks the loot spec and offers the others`
- [ ] WHEN no planned item drops here, THE ADDON SHALL show no card. proves: `no loot card when nothing planned drops`
- [ ] WHEN the player is in combat, THE ADDON SHALL not change the loot spec. proves: `loot spec not changed in combat`
<!-- AC:END -->

## Tasks

- [ ] The instance's drop list from the Encounter Journal, joined to the four plans.
- [ ] Spec icons from `GetSpecializationInfo`. Loot spec from `GetLootSpecialization`; 0 means
  "current spec".
- [ ] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" in a SecondBrain session. Ideation only.
- 2026-09-22 Claude, later: **KeystoneLoot already does the dungeon half of this card**, and Rob has
  it installed. It stays silent because Rob has no favourites (`Bloodfeather-Djinni-11` is empty in
  `WTF\Account\DJINNWRAITH\SavedVariables\KeystoneLoot.lua`). Its public API,
  `KeystoneLootAPI:AddFavorite(itemId, specId, tier, options)` (`modules\api.lua` line 536), can fill
  it from the plan. Before building this card, decide: send the plan to KeystoneLoot and keep only
  the raid half here, or drop the card.
