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
- [x] WHEN Rob clicks "Send to KeystoneLoot" and KeystoneLoot is loaded, THE ADDON SHALL add every planned item for each druid spec as a Best in Slot favourite for that spec. proves: `plan items become keystoneloot favourites per spec`
- [x] WHEN the plan drops an item that DjinnisBiS sent before, THE ADDON SHALL remove that favourite, and SHALL never remove one it did not add. proves: `only favourites the addon added are removed`
- [x] WHEN KeystoneLoot is not loaded, THE BUTTON SHALL not show. proves: `no keystoneloot button without keystoneloot`
- [x] AFTER a send, THE ADDON SHALL say in one line how many items it added and removed. proves: `send reports added and removed counts`
<!-- AC:END -->

## Tasks

- [x] Remember what was sent, in `DjinnisBiSDB`, to know what to remove later.
- [x] Wait for `KeystoneLootAPI:RegisterCallback("READY")` before the first call.
- [x] Send bonus ids, gems and enchant from the plan, so KeystoneLoot's link matches the planned copy.
- [x] Offline checks with a pretend `KeystoneLootAPI`.

## Comments

- 2026-09-22 Claude: written from Rob's "B" in a SecondBrain session. Ideation only.
- 2026-09-22 Claude: built, in a worktree, in `DjinnisBiS.lua` only. Three functions on `PlanTab`,
  no new top-level local (177 stay). `PlanTab.keystoneLoot()` is the guard on the global.
  `PlanTab.keystoneLootWanted()` is pure: every item in every filled cell of every spec, keyed
  `specId:itemId`, so today it is Feral's 1 target and Mythic+ cells and 19 distinct items.
  `PlanTab.sendToKeystoneLoot()` pcalls every method on `KeystoneLootAPI` (colon calls, per its
  `modules\api.lua`), asks `IsReady()` first and registers once for `READY` when it is not, then
  `AddFavorite(item, spec, Tier.BIS, { bonusIds, gems, enchant, characterKey })` for each wanted
  item with `GetCurrentCharacterKey()` passed in so the selected character in KeystoneLoot's own
  window does not matter. What went over is remembered in `DjinnisBiSDB.keystoneLoot[characterKey]`,
  and only entries in that record are ever passed to `RemoveFavorite` when the plan no longer wants
  them. Every wanted item is re-sent on every click, because KeystoneLoot's `Favorites:Add`
  overwrites, so a changed gem or enchant lands; "added" counts only what was not in the record.
  An item its lists do not know (its `AddFavorite` answers false) is counted as refused and said.
  One chat line after a send: "N favourites added to KeystoneLoot, M removed, K refused as not in
  its item lists". The row and its "KeystoneLoot" button sit at the foot of the Plan tab and are
  drawn only when the global exists. No Blizzard API is new here; the only calls are into the other
  addon and `db()`. 33 checks in `selfTest` with a pretend `KeystoneLootAPI` that refuses one item;
  `print` is swapped to record and still forward, so a FAIL line reaches `offline-check.lua`. Both
  `lua offline-check.lua` and the 5.1 build exit 0. Mutation-tested in a temp copy: deleting the
  `sent[key] = nil` line turns "and forgotten" red, deleting `if not okAdd then return nil end`
  turns "a refusal is caught" red, both exit 1.

  What a person must look at in the game (nothing here was run in a client):
  1. Open `/bis`, Plan tab, with KeystoneLoot loaded: the last row says "Every planned item, every
     spec, as a Best in Slot favourite in KeystoneLoot" with a KeystoneLoot button. The label is
     one letter longer than "Auctionator" in the same 70 pixel button, so check it is not cut off.
  2. Click it: one chat line with the counts. Then open KeystoneLoot's window on Feral and expect
     the planned pieces with the BiS tier mark. Note how many were refused; KeystoneLoot ships
     `data\raids.lua` as well as dungeons, so raid pieces should land, but the number says.
  3. Hover a planned item in a bag or on the character sheet: KeystoneLoot's own mark and tooltip
     line should now show. Enter a Mythic dungeon: its loot spec card should fire.
  4. Click the button a second time: "0 favourites added, 0 removed". Then remove one planned
     favourite by hand in KeystoneLoot and click again: it comes back, because the plan still
     wants it, and the line still says 0 added, because the record never let go of it.
  5. Disable KeystoneLoot, `/reload`: the row is gone and nothing errors.
- 2026-09-22 Claude (review, in a worktree off `fea30be`): attacked the four criteria, the three
  functions and the row, against KeystoneLoot 2.18.0's installed source, not the card's account of
  it. `modules\api.lua` confirmed: every method is a colon method on the global, `AddFavorite`
  takes `(itemId, specId, tier, options)` with `{ bonusIds, gems, enchant, characterKey }`, refuses
  with `false` for an item `Query:GetItemSource` cannot place in a dungeon, raid, catalyst or custom
  list, for a spec its `ItemDatabase` does not list the item for, for a wrong slot under
  `TIER_SLOT_RULE`, and before READY; `RemoveFavorite(itemId, specId, characterKey)` and
  `IsFavorite` match the calls; `RegisterCallback("READY")` fires at once when already ready;
  `GetCurrentCharacterKey()` is `realm-name-classId` from `string.format`, a fresh plain string,
  so keying `DjinnisBiSDB.keystoneLoot` on it does not touch the secret-value trap, and the addon
  registers no event and reads no unit here. `db()` is only reached from a click, after
  ADDON_LOADED. Both offline checks exit 0 on 5.4 and 5.1; 177 top-level locals, unchanged.

  One real finding, fixed in place. `Favorites:Add` at `modules\favorites.lua` line 412 replaces
  the whole entry (tier, bonus ids, gems, enchant) for an item that is a favourite already. So a
  favourite Rob made by hand for an item the plan also wants was overwritten to BiS with the plan's
  gems, then recorded as this addon's, then removed by this addon the day the plan dropped it: the
  second criterion's "never remove one it did not add" broken, and "Not this card" with it. Now the
  send asks `IsFavorite` first, and an item that is a favourite already and not in the record is
  left exactly as Rob made it, not recorded, and counted: the line ends ", N left as yours" when
  N is above 0. Four checks cover it, and `sendToKeystoneLoot` returns `kept` fourth. A second,
  trivial gap: the `api.AddFavorite` shape guard in `PlanTab.keystoneLoot()` had no check, so a
  global without the method (an older KeystoneLoot) drew the button untested; one check added.

  Mutation-tested in a temp copy, eight mutants, all red with exit 1: remove-everything (drop the
  `not wanted[key]` guard), draw the row without the global, count a refusal as added, drop the
  hand-made guard (the tier goes 2 to 3), change the report wording, drop the `AddFavorite` shape
  guard, skip the READY wait, and stop forgetting on remove. 38 checks in the block now.

  What held: only entries in `DjinnisBiSDB.keystoneLoot[charKey]` reach `RemoveFavorite`; a
  hand-made favourite outside the plan is never touched; a refused item is not recorded; a thrown
  error from any method is caught, said, and stops the send with nil; the row is drawn only when
  the global has `AddFavorite`. Accepted as documented, not changed: a favourite Rob deleted by
  hand that the plan still wants comes back on the next click, because it stays in the record.
  Security: weakest point is the other addon's global, which any addon can replace, and every call
  into it is pcalled and its answers are only ever a boolean, a string key and a number, so a
  hostile `KeystoneLootAPI` gets one chat line and no error. Unchecked: nothing comes in from
  outside the client; the only inputs are the generated plan and KeystoneLoot's answers. Leaks:
  the failure line prints the error text KeystoneLoot threw and nothing else.

  Verdict: pass with the one guard added, to `human-review/`. Nothing was run in a client; the
  five looks above stand, plus one more:
  6. Before the first click, favourite one planned Feral piece by hand in KeystoneLoot at "Must
     have". Click: the line ends "1 left as yours", KeystoneLoot still shows it at Must have, and
     it is absent from `DjinnisBiSDB.keystoneLoot` in the saved variables after a `/reload`.

## What I need from you

- The six looks in the game listed in the two comments above, in a client with KeystoneLoot 2.18.0
  loaded. Look 6 is the new one and is the only way to see the overwrite guard work against the
  real `Favorites:Add`.
- Say whether ", N left as yours" is the wording you want for a favourite you made yourself.

  Left out: nothing KeystoneLoot's settings touch, and no favourite Rob made by hand is read or
  removed, both per "Not this card". The pending `READY` wait cannot be seen from a click after
  login because KeystoneLoot is ready long before; it is covered by a check only. Card `0015`'s
  dungeon half is now a decision for Rob, as the card says.
