---
needs: 0095, 0096, 0097
---
# 0098 Loot help on every class

## Why

`PlanTab.gearHere()` (`DjinnisClassProfiles.lua:1424`) returns true only on a druid, and it is the
one gate for the loot card, the item tooltip lines, the bonus-roll verdict and the plan tab.
`PlanTab.DRUID` names the class the gear side is for. Card `0094` chose loot help on every class.

## Links

**Blocked by**
- `0095` - there is no BiS list for other specs until it lands.
- `0096` - there are no trinket tiers or stat targets for other specs until it lands.
- `0097` - what the gear plan does for a player who is not Rob.

## Not this card

- Any new data. This card only opens the gate and fixes what assumes four druid specs.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN a non-druid hovers an item on their specs' BiS lists, THE TOOLTIP SHALL say which of their specs want it. proves: `offline-check.lua 71` (hover mode)
- [ ] WHEN a non-druid kills a boss, THE LOOT CARD SHALL list their specs, not druid specs. proves: `offline-check.lua 71` (boss-kill mode)
- [ ] WHEN the `.toc` is read, its Title and Notes SHALL not say druid. proves: `offline-check.lua` (the `.toc` block)
- [ ] WHEN a non-druid opens the window in a live client, THE PLAN TAB SHALL show their own specs with no Lua error. proves: manual
<!-- AC:END -->

## Tasks

1. List every caller of `gearHere()` and `PlanTab.DRUID`; decide each one on this card before editing.
2. Replace the druid test with "this spec has data".
3. Find every place that assumes four specs (`0091` lists two of them) and make it read the class's specs from `PlanTab.ROLE_SPECS`.
4. Reword the `.toc` Notes and the header comment.
5. Run `lua offline-check.lua` and one spec id from each class.

## Comments

**2026-10-14** Raised from card `0094` (attended).
