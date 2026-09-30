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
finds every quality of a reagent; the price is the first quality's. v0.59.1: the Auctionator list carries each count, through Auctionator's ConvertToSearchString, exact for a reagent only.

v0.59.2: Rob found in game that Hunter's Ritual Stone goes on blacksmithing weapons only (Darkmoon Sigil: Hunt is weapons too). The plan's cloak takes Arcanoweave Lining instead, the best armor embellishment in a local SimC run (Arcanoweave on both: +2.49 ST / +3.01 M+, against +2.84 / +3.50 claimed for the stone). The four Feral cells' dps are scaled by that. Uncertain: whether two Arcanoweave Linings may be worn; SimC's own MID2 Feral profile wears two.

v0.59.3: each recipe also lists its missive, the item that sets the crafted stats: Thalassian Missive of the Peerless (crit/mastery) on the cloak, of the Feverflare (haste/mastery) on the bracers. Local SimC put all six pairs on each piece within 0.1% of each other, so these are SimC's defaults kept, not a real gain.

Checks in `selfTest` (`PlanTab.craftChecks`): 11 lines for the two pieces, Tantalum counted twice,
Arcanoweave Lining counted twice, nothing when worn at another item level or held. Broken on purpose once
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
