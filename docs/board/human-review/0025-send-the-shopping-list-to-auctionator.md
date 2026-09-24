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
<!-- AC:END -->

## Tasks

- [x] Read the API's argument order in Auctionator's `Source\API\v1\` files; the first argument is
  the caller's addon name.
- [x] Search terms from `0008`'s `searchTerm`, the rank stripped.
- [x] Offline checks with a pretend `Auctionator.API.v1`.

## What I need from you

In the game, with Auctionator loaded and a wrong or missing gem on a planned piece:

1. Open `/bis`, Plan tab. Under "3. To buy", each gem line Auctionator has seen should end in a
   grey price (count times unit price), and a grey "Total ..g ..s" row should sit under the list
   with an "Auctionator" button on the right. Enchant lines carry no price; see the comment below.
2. Click the button. Chat should say "N items sent to Auctionator's "DjinnisBiS plan" list".
   Open the auction house, Auctionator's Shopping tab: a list named "DjinnisBiS plan" should hold
   one search term per line, the family name with no rank ("Masterful Garnet", not "rank 4 of 4").
   Click it again: the same list, replaced, not a second one.
3. Does the label "Auctionator" fit the 70px action button? "Send to Auctionator" did not, on paper.
4. Disable Auctionator, `/reload`: no prices, no Total row, no button, nothing in chat.
5. (review) With a lesser gem on as well, the "Higher ranks exist" lines carry a grey price too, but
   they are not in the Total. Say if that reads wrong; the code prices every list it draws.
6. (review) Wear a wrong gem the rank table has never seen (the line reads "gem 12345"), so nothing
   on the list has a name. The button should say "Nothing on the list has a name yet; the
   Auctionator list is left as it was." and the old "DjinnisBiS plan" list should survive.

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
