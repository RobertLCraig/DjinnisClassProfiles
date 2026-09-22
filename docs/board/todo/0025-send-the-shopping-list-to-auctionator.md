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
- [ ] WHEN Rob clicks "Send to Auctionator" and Auctionator is loaded, THE ADDON SHALL make or replace one Auctionator shopping list named "DjinnisBiS plan" with every item to buy. proves: `shopping list sent to auctionator`
- [ ] WHEN Auctionator has a price for an item, THE SHOPPING LIST SHALL show it, and the total. proves: `shopping list shows auctionator prices`
- [ ] WHEN Auctionator is not loaded, THE BUTTON SHALL not show and no price column SHALL show. proves: `no auctionator parts without auctionator`
<!-- AC:END -->

## Tasks

- [ ] Read the API's argument order in Auctionator's `Source\API\v1\` files; the first argument is
  the caller's addon name.
- [ ] Search terms from `0008`'s `searchTerm`, the rank stripped.
- [ ] Offline checks with a pretend `Auctionator.API.v1`.

## Comments

- 2026-09-22 Claude: written from Rob's "B" in a SecondBrain session. Ideation only.
