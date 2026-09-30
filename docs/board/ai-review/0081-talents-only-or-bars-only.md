---
needs: 0057, 0033
---
# 0081 Talents only, or bars only, from a build's menu

## Why
Rob, 2026-09-30: "need a way to apply just a build, or just the bars from the menu". A build row's
right-click menu had only **Wear it**, which switches the talents and then offers that build's
bars.

## What was built (v0.62.0)
Two items under **Wear it** in a build row's right-click menu (not on a row the plan has shadowed,
which cannot be worn):
- **Wear talents only**: `PlanTab.wearTalentsOnly(name)`. Marks the build's bars key
  (`barsKey(spec, name)`) as already offered (`PlanTab.barsSeen`), then `loadTalents`. The offer
  after the switch answers "seen" and stays quiet. More > Offer the saved bars still offers them.
- **Load bars only**: `PlanTab.loadBarsOnly(name)`. `applyBars` on the build's own layout, else the
  spec's. The talents are not touched. Undo bars puts the old bars back, as after any load.

**Wear it** is unchanged: talents, then the bars offer.

Checks: `PlanTab.barOnlyChecks`, 7 lines, and the row-menu label checks now list the two items.
Four mutations each made 1 to 8 checks fail. Lua 5.1: "no FAIL lines".

## Uncertain
- If the talent switch fails, the build's bars stay marked as offered, so the next switch back to
  that same build does not offer them. More > Offer the saved bars still works.

## Acceptance
<!-- AC:BEGIN -->
- [x] #1 WHEN Rob picks Wear talents only, THE talents SHALL switch AND no bars offer SHALL show. proves: `PlanTab.barOnlyChecks`
- [x] #2 WHEN Rob picks Load bars only, THE build's bars (or the spec's) SHALL load AND the talents SHALL NOT change. proves: `PlanTab.barOnlyChecks`
- [ ] #3 In a client: right-click a build, Wear talents only: no bars prompt. Right-click another, Load bars only: its bars go on, talents stay. proves: none
<!-- AC:END -->

## Comments
