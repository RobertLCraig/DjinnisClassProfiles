---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0009
---
# 0021 Send the gear plan to KeystoneLoot

## Why

KeystoneLoot 2.18.0 is installed. It has a loot spec card on entering a Mythic dungeon, a "Favorite
dropped!" alert with a whisper button, party sharing, marks on bag and character sheet icons, and
tooltip lines. All of it works from a favourites list, and Rob has none: `Bloodfeather-Djinni-11`
is empty in `WTF\Account\DJINNWRAITH\SavedVariables\KeystoneLoot.lua` (checked 2026-09-22). So none
of it has ever fired.

Its public API is the global `KeystoneLootAPI` (`modules\api.lua` line 700):
`AddFavorite(itemId, specId, tier, options)` at line 536, where options is
`{ bonusIds, gems, enchant, characterKey }`; `KeystoneLootAPI.Tier.BIS`; `RemoveFavorite`,
`GetFavorites`, and `RegisterCallback("READY", ...)`.

What it gains: a whole addon's reminders turn on for four specs, and DjinnisBiS draws none of them.

## Links

- Needs `0009`: the raid and Mythic+ plans for all four specs.
- Covers most of `0015`'s dungeon half. After this is built, decide `0015`.
- Draws by `0020`'s rules (one button, one line of result).

## Not this card

- Changing KeystoneLoot's settings or turning its features on or off.
- Favourites Rob made by hand. DjinnisBiS removes only what it added.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN Rob clicks "Send to KeystoneLoot" and KeystoneLoot is loaded, THE ADDON SHALL add every planned item for each druid spec as a Best in Slot favourite for that spec. proves: `plan items become keystoneloot favourites per spec`
- [ ] WHEN the plan drops an item that DjinnisBiS sent before, THE ADDON SHALL remove that favourite, and SHALL never remove one it did not add. proves: `only favourites the addon added are removed`
- [ ] WHEN KeystoneLoot is not loaded, THE BUTTON SHALL not show. proves: `no keystoneloot button without keystoneloot`
- [ ] AFTER a send, THE ADDON SHALL say in one line how many items it added and removed. proves: `send reports added and removed counts`
<!-- AC:END -->

## Tasks

- [ ] Remember what was sent, in `DjinnisBiSDB`, to know what to remove later.
- [ ] Wait for `KeystoneLootAPI:RegisterCallback("READY")` before the first call.
- [ ] Send bonus ids, gems and enchant from the plan, so KeystoneLoot's link matches the planned copy.
- [ ] Offline checks with a pretend `KeystoneLootAPI`.

## Comments

- 2026-09-22 Claude: written from Rob's "B" in a SecondBrain session. Ideation only.
