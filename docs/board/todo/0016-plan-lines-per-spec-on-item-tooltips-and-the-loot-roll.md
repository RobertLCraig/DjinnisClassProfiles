---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0009
---
# 0016 Plan lines per spec on item tooltips and the loot roll

## Why

The addon's first goal is "when an item drops, say which druid specs want it, without the player
leaving the loot roll" (`docs/HANDOVER.md`, Goal). The BiS tabs answer that in the `/bis` window.
The gear plan (`0004`, `0009`) is a better answer, and it is not on the item.

Pawn puts one line per scale on the tooltip ("Feral: ↑ +3% upgrade") and a badge on the loot roll
frame (`PawnUI`, `GroupLootFrame` hooks, read 2026-09-22). KeystoneLoot adds "Favorite" and "In your
bags/bank" lines.

## Links

- Needs `0009`: the raid and Mythic+ plans for each spec.
- The addon's tooltip hook already exists (`TooltipDataProcessor`); add lines there, not a second hook.

## Not this card

- A % upgrade. That needs sim data per item per spec. This card says yes or no only.
- Pawn's scales or weights.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN an item's tooltip shows and the item is in a druid spec's plan, THE ADDON SHALL add one line per spec and content that plans it, for example "Feral raid: in plan", current spec first. proves: `tooltip lists each plan that has the item`
- [ ] WHEN the item is planned and already owned, THE LINE SHALL say "owned". proves: `tooltip says a planned item is owned`
- [ ] WHEN a loot roll starts for an item in any druid plan, THE ADDON SHALL mark the roll frame and name the specs in its tooltip. proves: manual
- [ ] WHEN the item is in no plan, THE ADDON SHALL add no plan line. proves: `no plan line for an unplanned item`
<!-- AC:END -->

## Tasks

- [ ] Plan lookup by item id, all specs and contents, built once when the plan loads.
- [ ] Loot roll: `START_LOOT_ROLL` and the roll frame's item link. Check in `wow-ui-source` how
  12.1 draws the group loot frame before hooking it.
- [ ] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" in a SecondBrain session. Ideation only.
