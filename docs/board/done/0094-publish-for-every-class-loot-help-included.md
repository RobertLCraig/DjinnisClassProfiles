# 0094 Publish for every class, loot help included

## Why

Rob, 2026-10-14: what is needed to publish this addon for other people, "assuming they will
probably not be playing druid"?

Today a non-druid gets saved bars and talent builds and nothing else. The loot answer ("which spec
wants this drop"), the BiS list, the trinket tiers, the stat targets and the gear plan all stop at
`PlanTab.gearHere()`, which is true only on a druid. The title and `.toc` Notes still promise the
druid loot answer, so a non-druid installs it and finds the headline feature missing.

## Options

1. **Publish as "bars and talent builds for every class, loot help for druids".** Rename and reword
   to match. Cost: small. The gear side stays as it is.
2. **Give every class the loot help.** Cost: data for 40 specs instead of 4, kept current every
   season. Raises one more decision: the gear plan is one character's own sim (card `0097`).

## Recommendation

Option 1. The bars and builds already work on every class, and option 2 makes the seasonal data
refresh forty specs wide.

## Comments

**2026-10-14** Asked and recommended in an attended session.

**2026-10-14** **Decided:** Option 2 (Rob: "B"). The work is cards `0095` to `0102`.

A finding made while scoping it, which makes option 2 cheaper than the recommendation assumed:
ClassCodex 1.5.0's `Data\db_icyveins.lua` and `Data\db_ugg.lua` (dated 2026-09-23 on disk) carry
gear, enchants, consumables and crafting for every class and spec, keyed by item id. ClassCodex is
MIT. So the BiS list for every spec can be generated the same way the trinket tiers already are,
and the seasonal refresh stays one command.
