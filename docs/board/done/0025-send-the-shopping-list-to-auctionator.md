---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0008
---
# 0025 Send the shopping list to Auctionator, with prices

## Why

The Plan tab's Search AH (`0008`) searches one thing per click. Auctionator, which Rob has installed,
has shopping lists that search everything in one go, and it knows prices.

Its public API exists in Rob's install: `Auctionator.API.v1.CreateShoppingList` and
`Auctionator.API.v1.GetAuctionPriceByItemID` (read 2026-09-22). ClassCodex edits Auctionator's saved
data by hand instead; do not copy that.

## Links

- Needs `0008`: the shopping list and its search terms.
- Draws by `0020`'s rules: the price is a fourth column at most.

## Not this card

- Buying anything.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN Rob clicks "Send to Auctionator" and Auctionator is loaded, THE ADDON SHALL make or replace one Auctionator shopping list named "DjinnisBiS plan" with every item to buy. proves: `shopping list sent to auctionator`
- [x] WHEN Auctionator has a price for an item, THE SHOPPING LIST SHALL show it, and the total. proves: `shopping list shows auctionator prices`
- [x] WHEN Auctionator is not loaded, THE BUTTON SHALL not show and no price column SHALL show. proves: `no auctionator parts without auctionator`
- [ ] `/reload` first (the game folder holds v0.69.0). With Auctionator loaded and a wrong or missing gem on a planned piece: `/dcp`, Plan tab, under `3. To buy` each gem line Auctionator knows ends in a grey price, and a grey `Total ..g ..s` row (`, N without an Auctionator price yet` if any) sits under it with an `Auctionator` button whose label fits. Enchant lines carry no price. proves: manual
- [ ] Click `Auctionator`: chat says `N items sent to Auctionator's "DjinnisBiS plan" list.` Auctionator's Shopping tab holds a `DjinnisBiS plan` list, one search per thing to buy (gem family name, no rank). Click again: the same list replaced, not a second one. proves: manual
- [ ] Disable Auctionator, `/reload`: no prices, no Total row, no button, nothing in chat. proves: manual
- [ ] With a lesser-rank gem on as well, the `Higher ranks exist, if you want to spend on them:` lines carry a grey price but are not in the Total. Pass if that reads right; else say so on the card. proves: manual
- [ ] Wear a wrong gem the rank table has never seen (its line reads `gem 12345`) so nothing on the list has a name, and click `Auctionator`: chat says `Nothing on the list has a name yet; the Auctionator list is left as it was.` and the old list survives. proves: manual
<!-- AC:END -->

## Tasks

- [x] Read the API's argument order in Auctionator's `Source\API\v1\` files; the first argument is
  the caller's addon name.
- [x] Search terms from `0008`'s `searchTerm`, the rank stripped.
- [x] Offline checks with a pretend `Auctionator.API.v1`.

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Comments

- 2026-09-22 Claude: written from Rob's "B" in a SecondBrain session. Ideation only.
- 2026-09-22 Claude: built, in `PlanTab` (no new top-level local; the file holds 177). Five
  functions: `auctionator()` (the global's `API.v1` or nil), `gold(copper)`, `priceOf(kind, id)`
  (a `pcall` round `GetAuctionPriceByItemID("DjinnisBiS", id)`), `pricedLines(list, nameOf)`
  (`shoppingLines` with a grey price on each priced line, plus total and an unpriced count) and
  `sendToAuctionator(list)` (a `pcall` round `CreateShoppingList("DjinnisBiS", "DjinnisBiS plan",
  terms)`, the terms out of `searchTerm`, a thing with no name yet left out and said in chat; the
  refusal message printed on failure). The Plan tab draws the Total row and its button only when
  `auctionator()` answers and the list is not empty. Signatures read off
  `Auctionator/Source/API/v1/ShoppingLists.lua` and `GetAuctionPrice.lua` (version 339): caller
  name first, both of them, and `CreateShoppingList` deletes a list of the same name before it
  creates. 25 checks under three names matching the criteria, a stub `Auctionator.API.v1` swapped
  in and out; `lua offline-check.lua` and Lua 5.1 both exit 0. Six mutations in a temp copy all go
  red: the no-Auctionator guard in `pricedLines`, the enchant guard in `priceOf`, the `pcall` in
  `sendToAuctionator`, the caller name, the Total row drawn with nothing to buy, and an unnamed
  term not dropped. Not verified in a client; the four looks above are the check.
  **Left out, on purpose.** Enchants get no price: the list carries the enchant id, and
  Auctionator prices by item id, so asking it for 7967 returns a stranger's price. Pricing them
  means `update-plan-ranks.py` writing the scroll's item id into `PlanTab.RANK`, which is a
  generator change, not this card. The Total row says how many lines are unpriced. The list holds
  plain family names, not Auctionator's exact-match or quantity search strings, the same terms
  Search AH already uses; exact terms would need `ConvertToSearchString` and one more stub.
  The button label is "Auctionator", not "Send to Auctionator": the action button is 70px.
- 2026-09-22 Claude (adversarial review, worktree branch): **pass to human-review, one small fix
  and one test gap closed in place.** Attacked: the three criteria's checks (all ran, both Lua 5.4
  and 5.1 exit 0), then 13 mutations in a temp copy. Twelve went red first time, including the
  six the build named plus the gold divisor, the wrong item id asked, a total that ignores the
  count, the not-loaded message, and the Total row without Auctionator. **One survived**: the
  `ok and type(price) == "number"` guard in `priceOf` could be replaced with a bare `return price`
  and nothing noticed, because the stub never threw and never answered a non-number. Two checks
  added (id 98 answers a string, id 99 throws; both are no price) and that mutation is red now.
  **Found in the code, fixed in place**: with every line unnamed (a gem the rank table has never
  seen and the client has not cached), `sendToAuctionator` built an empty `terms` and still called
  `CreateShoppingList`, which deletes the existing "DjinnisBiS plan" list before it creates, so
  one click wiped the last good list and chat said "0 items sent". Now it refuses, says the list
  is left as it was, and returns false; three checks and a mutation cover it. Auctionator's
  signatures re-read from the installed source (version 339): `CreateShoppingList(callerID, name,
  searchStrings)` and `GetAuctionPriceByItemID(callerID, itemID)` both verify the caller is a
  non-empty string and `error()` on a bad argument, `AppendItems` asserts every term is a string
  (ours are), and `GetPrice` returns the database's `.m` or nil. Held: the enchant guard, the
  `pcall`s, the caller name, the rank-stripped terms, the Total row drawn only with Auctionator and
  something to buy. Second caller: `searchRows(better, GREY)` also runs `pricedLines`, so "Higher
  ranks exist" lines carry a price too and their total is discarded; harmless, listed as look 5.
  **Security.** Weakest: the terms handed to Auctionator, which are family names from the
  generated rank table or `C_Item.GetItemInfo` names behind `canRead`, so a 12.1 secret string
  cannot reach the concatenation or the list. Unchecked: nothing reads a unit, a resource or an
  event; the only inputs are plain item ids from the plan table and worn links. Leaks: on refusal,
  chat shows Auctionator's own error text, which names this addon and its usage string, nothing
  else. Not seen in a client; looks 1 to 6 above are the check.

**2026-10-11** Clear-down (attended, Rob asked): ticked 3 criteria, all ticked already and confirmed (checks `shopping list sent to auctionator`; `shopping list shows auctionator prices`; `no auctionator parts without auctionator` exist in `DjinnisClassProfiles.lua` and pass in the Lua 5.1 offline check); looks rewritten for v0.69.0 (`/bis` is `/dcp`; the button is now 100 px wide, so the label look folds into look 1; the send now goes through Auctionator's `ConvertToSearchString` when it has one, so the list shows Auctionator's own search lines); moves to ai-review/ with only in-game looks open.

### 2026-10-19 review (v20261019023814-0a19)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I traced the three ticked criteria to the code. I could not break them.

- **#1 (send the list):** `PlanTab.sendToAuctionator` in `DjinnisClassProfiles.lua` makes the list. It calls `CreateShoppingList("DjinnisClassProfiles", "DjinnisBiS plan", terms)` inside a `pcall` (a guarded call that catches errors). Auctionator deletes a list with the same name first, so the list is replaced. The "Auctionator" button on the Total row calls this function. Items with no name yet are left out, and chat says so. When nothing has a name, it refuses and keeps the old list.
- **#2 (prices and total):** `PlanTab.priceOf` asks Auctionator for each gem's price. Enchants get no price. `PlanTab.pricedLines` adds a grey price to each line and adds up the total. The Plan tab draws the Total row with the unpriced count.
- **#3 (nothing without Auctionator):** `PlanTab.auctionator()` returns nil when Auctionator is not loaded. Then `pricedLines` returns a nil total, and the Plan tab draws no Total row and no button. With no Total row, there is no button to click.

The offline checks cover all three, under the names the card gives. The other criteria are `proves: manual`. They are open, and Rob tries them in the game.

VERDICT: sound

**scope: sound**

I checked the Auctionator code against card 0025's scope. I found nothing that crosses the card's fence or is half done.

**What I looked at:** the `PlanTab.sendToAuctionator`, `PlanTab.pricedLines` and `PlanTab.auctionator` functions in `DjinnisClassProfiles.lua`, and the checks that test them.

- **The fence is kept.** The card says "Not this card: buying anything". Nothing buys. The code only makes a shopping list and reads prices, through Auctionator's public API.
- **Two things grew since the build. Neither is a defect.**
  - The send now goes through Auctionator's `ConvertToSearchString` and passes a quantity and an "exact" flag. The `item` kind is a crafting reagent, which is card `0078`, and `0078` is in `done/`. The clear-down note on this card records the change. A gem term still goes as the family name with no rank and `isExact = false`, so manual look 2 can still pass.
  - The caller name is now `"DjinnisClassProfiles"`, not `"DjinnisBiS"`. That comes from the rename card `0058`, which is also done. The list name stays `"DjinnisBiS plan"`, which is what criterion 1 asks for.
- **Nothing is half done.** The tests cover the empty-list refusal, an Auctionator refusal, and prices that come back wrong (a string, or an error).
- **The diff is far bigger than this card.** It has 163 files, mostly other cards and the rename. That is branch history, not work done under this card. I did not judge it.

No criterion is disproven. The open criteria are all `proves: manual`, so they wait for Rob to try in game.

VERDICT: sound

**breakage: sound**

I looked for things this change breaks. I found nothing that breaks.

**What I checked** (all in `DjinnisClassProfiles.lua`):
- **The guard in `PlanTab.auctionator()`.** Without Auctionator, `PlanTab.pricedLines` gives back no total. The Plan tab's `searchRows` caller then draws no Total row and no button. This keeps criterion #3.
- **`PlanTab.priceOf`.** It gives no price for an enchant. It also gives no price when the answer is not a number, or when Auctionator throws an error.
- **`PlanTab.sendToAuctionator`.**
  - The list name is still `"DjinnisBiS plan"` (`PlanTab.AUCTIONATOR_LIST`).
  - When no item has a name, it does not touch the old list. It prints the exact chat text from the card.
  - The success text matches the card: `N items sent to Auctionator's "DjinnisBiS plan" list.`
  - The caller name is now `"DjinnisClassProfiles"`. That came with the rename. Auctionator only needs a name that is not empty, so this is fine.
- **The "Higher ranks exist" lines.** They also go through `searchRows`. Their total is thrown away, so the Total row does not count them. This matches look 5.
- **The tests still fit the code.** The pretend Auctionator includes `ConvertToSearchString`. The tests check the quantity terms.

**One small thing, not a defect.** The card's comments still say the caller name is `"DjinnisBiS"`. Look 2 says the list holds "gem family name, no rank". Now the terms go through `ConvertToSearchString`, so Auctionator's list may show its own search lines. The 2026-10-11 note on the card already says this. That look is for Rob to try in the game.

**What you do now:** nothing. The card can go to `done/`. Only the in-game looks are left.

VERDICT: sound

