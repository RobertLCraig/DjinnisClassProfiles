---
needs: 0009, 0022
---
# 0085 One farm route for all four specs

## Why

Rob, 2026-10-07: "sounds very useful", on GearInsight's druid farm route
(`https://gearinsight.app/wow/en/farming/druid`, clipped to SecondBrain as `Clippings\Druid
Multi-Spec Gear Farming Route — Midnight Season 2.md`).

That page lists every source of planned gear for all four druid specs in one place: raid bosses,
dungeons, crafted and tier tokens. Each source shows which spec wants which item, and the loot spec
that covers the most. It sorts the sources by how many planned items they give.

We have parts of this already. `0022` names the best loot spec for each raid boss on the Plan tab.
`0015` shows a loot spec card when you enter a place. Neither shows the whole route on one page, and
neither covers dungeons, crafted and tier together.

## Data

- Our own plans only (`GEAR_PLAN`, the BiS list, `PlanTab.plannedIds` per spec). Do not take data
  from gearinsight.app. It has no licence or terms, so its numbers may not ship in our addon.
- Drop sources from the Encounter Journal pools that `0022` already harvests (`PlanTab.POOL`).
- Join by item id, never by name.

## Scope

- One list, one row per source: the source, each spec's planned items from it, and the loot spec
  that covers the most. Sort by planned items, most first.
- Raid bosses, Mythic+ dungeons, crafted, tier/catalyst.
- Reuse `0022`'s tie rule: a tie goes to the current spec.
- No loot spec change without a click. Draw by `0020`'s rules.

## Acceptance

- [ ] Every source with a planned item for any druid spec has one row.
- [ ] Each row names the loot spec that covers the most planned items there.
- [ ] Rows sort by planned item count, most first.
- [ ] An item already owned at its planned item level drops off the route.
- [ ] `lua offline-check.lua` passes, with checks for the sort, the tie and the owned case.
