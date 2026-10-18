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
- [ ] `/reload` first (the game folder holds v0.69.0). `/dcp`, Plan tab, with KeystoneLoot loaded: the last row reads `Every planned item, every spec, as a Best in Slot favourite in KeystoneLoot.` with a `KeystoneLoot` button whose label is not cut off. proves: manual
- [ ] Click `KeystoneLoot`: one chat line `N favourites added to KeystoneLoot, M removed` (plus `, K refused as not in its item lists` if any). KeystoneLoot's window on Feral shows the planned pieces at the BiS tier. proves: manual
- [ ] After the send, hover a planned item in a bag or on the character sheet: KeystoneLoot's own mark and tooltip line show. Enter a Mythic dungeon: its loot spec card fires. proves: manual
- [ ] Click `KeystoneLoot` again: `0 favourites added to KeystoneLoot, 0 removed.` Remove one planned favourite by hand in KeystoneLoot and click: it comes back and the line still says 0 added. proves: manual
- [ ] Disable KeystoneLoot, `/reload`: the row and its button are gone and nothing errors. proves: manual
- [ ] Before any send, favourite one planned Feral piece by hand at Must have, then click: the line ends `, 1 left as yours` (pass if that wording reads right), KeystoneLoot still shows it at Must have, and after `/reload` it is absent from `DjinnisCPDB.keystoneLoot` in the saved variables. proves: manual
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

**2026-10-11** Clear-down (attended, Rob asked): ticked 4 criteria, all ticked already and confirmed (checks `plan items become keystoneloot favourites per spec`; `only favourites the addon added are removed`; `no keystoneloot button without keystoneloot`; `send reports added and removed counts` exist in `DjinnisClassProfiles.lua` and pass in the Lua 5.1 offline check); the six looks rewritten for v0.69.0 (`/bis` is `/dcp`; the record lives in `DjinnisCPDB.keystoneLoot`, not `DjinnisBiSDB`; the button is now `ILVL_WIDTH` 100 px wide, so the label worry is one glance in look 1); the wording question folded into look 6. Carried from the old ask: card 0015's dungeon half is a decision for Rob; moves to ai-review/ with only in-game looks open.

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

### 2026-10-18 review (v20261018165156-a56a)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I read the code against each of the four built criteria. I tried to break each one and could not.

- **#1 (plan items become favourites per spec):** This passes. `PlanTab.keystoneLootWanted` collects every item in every filled plan cell, for each druid spec. `PlanTab.sendToKeystoneLoot` then sends each one with `AddFavorite` at `Tier.BIS`. It also sends the bonus ids, gems, enchant and character key.
- **#2 (only favourites the addon added are removed):** This passes. In `PlanTab.sendToKeystoneLoot`, only keys in the `DjinnisCPDB.keystoneLoot[charKey]` record ever reach `RemoveFavorite`. Hand-made favourites are skipped: a favourite that exists already but is not in the record is not sent and not recorded. So it can never be removed later.
- **#3 (no button without KeystoneLoot):** This passes. `PlanTab.keystoneLoot` returns nothing when the global is missing or has no `AddFavorite`. The Plan tab row is drawn only when that check passes.
- **#4 (one line with the counts):** This passes. `PlanTab.sendToKeystoneLoot` prints one line: "added" and "removed" counts, plus "refused" and "left as yours" when those are above 0.

One small note, and it is not a defect. When two plan cells have the same item, the gems and enchant of whichever cell `pairs` visits first win. That order is not fixed. It does not break any criterion.

The six open criteria are `proves: manual`, so they are not findings. Rob tries them in the game.

VERDICT: sound

**scope: sound**

I checked the KeystoneLoot code against the card. It does not go over the fence.

**What I checked:** `DjinnisClassProfiles.lua`, functions `PlanTab.keystoneLoot`, `PlanTab.keystoneLootWanted` and `PlanTab.sendToKeystoneLoot`.

- **KeystoneLoot settings:** the code never changes them. It calls only `IsReady`, `RegisterCallback`, `GetCurrentCharacterKey`, `IsFavorite`, `AddFavorite` and `RemoveFavorite`. "Not this card" allows all of these.
- **Rob's own favourites:** the code removes only items in its saved record (`sent`). An item that is a favourite but not in the record is left as it is and counted as "left as yours". So a favourite made by hand is never removed or changed.
- **The druid check:** `PlanTab.gearHere()` stops the send on a character that is not a druid. That check came from card 0049, not from this card. It agrees with "each druid spec", so it is not extra scope.
- **The big diff:** most of the diff (the rename, the other cards, the research files) belongs to other cards. It is not part of this card's code.

**Nothing is half done.** All four tasks are in the code: the record, the wait for READY, sending bonus ids, gems and enchant, and the offline checks. The open criteria are all `proves: manual`, and the code does not stop any of them from passing.

**One known gap:** a favourite that Rob deletes by hand comes back on the next click if the plan still wants it. The card already writes this down and accepts it in look 4.

No criterion is disproved.

VERDICT: sound

**breakage: sound**

I tried to break the KeystoneLoot send and could not. I found nothing that fails a criterion.

**What I checked** (all in `DjinnisClassProfiles.lua`):

- **The plan list** (`PlanTab.keystoneLootWanted`). It now goes through the specs of every class. Only the druid specs have a gear plan, so other classes add nothing. The item fields (`bonus`, `gems`, `enchant`) have the names that `parsePlanLine` gives them.
- **The send** (`PlanTab.sendToKeystoneLoot`).
  - It removes only items that are in its own record.
  - It does not record a refused item.
  - It does not touch a favourite that Rob made by hand.
  - It sends again an item that Rob deleted by hand, and it does not count that item as added. Manual look 4 expects this.
- **The chat line.** Its words are the same as the words the manual looks expect.
- **The row.** The game draws it only when `KeystoneLootAPI.AddFavorite` exists.

**Small problems. They fail no criterion:**

1. Say KeystoneLoot is not ready and you click more than once. Each click adds one more READY listener, so the send runs more than once and you get more than one chat line.
2. Say a call into KeystoneLoot fails in the middle of a send. The record is already part-written, and you get the error line but no count line.
3. A non-druid character with KeystoneLoot loaded still sees the row. If they click, the addon says "druids only".

The open looks are all `proves: manual`. Rob does them in the game.

VERDICT: sound

