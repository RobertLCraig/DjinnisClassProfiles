# Crafting reagents on the list to buy

## Why
Rob, 2026-09-30: the plan now asks for a crafted cloak (Adherent's Silken Shroud) and crafted bracers
(Silvermoon Agent's Deflectors), with Hunter's Ritual Stone and Arcanoweave Lining. His professions
are engineering and skinning, so both go through a crafting order and he brings the reagents. The
Plan tab's "3. To buy" listed only enchants and gems.

## What was built (v0.59.0)
`PlanTab.CRAFTED` holds each recipe's reagents, from Wowhead's "Created by" listing read 2026-09-30
(tailoring recipe 1228950, leatherworking recipe 1237514). `PlanTab.EMBELLISHMENT` maps the plan
line's embellishment bonus id to its reagent. `PlanTab.shoppingList` adds them as kind `item` for a
planned crafted piece that is neither worn (at any item level) nor in the bags or open bank. Search
AH, the Auctionator price and the Auctionator list take them like gems. The search is by name, so it
finds every quality of a reagent; the price is the first quality's.

Checks in `selfTest` (`PlanTab.craftChecks`): 11 lines for the two pieces, Tantalum counted twice,
one of each embellishment, nothing when worn at another item level or held. Broken on purpose once
(embellishments dropped) and three checks failed.

Uncertain: whether Wowhead's list has every required slot right. A reagent slot that takes one of
two items would show both here.

## Acceptance
<!-- AC:BEGIN -->
- [x] #1 WHEN a planned crafted piece is not worn or held, IT SHALL list its reagents and embellishment to buy. proves: `PlanTab.craftChecks`
- [x] #2 WHEN the piece is worn at any item level or held, IT SHALL list nothing for it. proves: `PlanTab.craftChecks`
- [ ] #3 WHEN Rob opens the Plan tab as Feral, "3. To buy" SHALL show the reagents, and the crafting order window SHALL agree with them. proves: none
<!-- AC:END -->

## Comments
