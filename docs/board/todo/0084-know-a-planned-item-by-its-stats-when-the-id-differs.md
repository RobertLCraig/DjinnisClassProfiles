# 0084 Know a planned item by its stats when the id differs

## Why

Rob, 2026-10-07, on what GearInsight 0.95.11 does that we could learn from: "useful".

The plan matches gear by item id (`planMatches`, with `itemLevelOf`). GearInsight found that a
catalysed or look-swapped piece can carry a different item id from the one the BiS list names, so
an id match says "you do not have it" when you do. Their fix (`core\CatalystResolve.lua:39-90` in
their zip, read only): put each candidate's id into the worn item's link, ask
`C_Item.GetItemStats` for both, and call it the same item when the secondaries and armor agree. A
fixed alias table is only their fallback.

GearInsight has no licence, so this is the idea only. Write our own code. Copy nothing.

## Check this first

1. **Does the problem exist for us?** Find out if any planned druid piece (tier first, then
   catalyst pieces) can be worn under an item id the plan does not name. Look at the tier ids in
   `GEAR_PLAN` and the BiS list against what the catalyst gives. If every catalysed piece takes the
   set's own id, write that here and discard the card.
2. **Secret values.** `C_Item.GetItemStats` on a link the addon built must give plain numbers. If
   it can give a secret, stop and write it here (see the workspace `docs/DECISIONS.md`).

## Scope

- Only when the id match fails, and only for the same slot.
- Same item = same secondary stats and same armor, read from links at the same item level.
- No new frames. The result feeds the places that already say "owned" or "planned".

## Acceptance

- [ ] Check 1 done and the answer written here.
- [ ] A worn piece with a different id but the planned stats reads as the planned item in the plan,
      the tooltip lines and the bag glow.
- [ ] A worn piece with the same slot but other stats still reads as not planned.
- [ ] `lua offline-check.lua` passes, with checks for both cases above.
