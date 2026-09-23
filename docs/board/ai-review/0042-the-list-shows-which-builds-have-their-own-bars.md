# 0042 The list shows which builds have their own action bars

## Why

Rob, 2026-09-23, with a screenshot of the list: "Need to show if a loadout has different saved
bars for its build."

## Built, v0.36.1

- `PlanTab.sidebarList` sets `bars` on a row when `DjinnisBiSDB.bars` holds `<spec> / <build>`
  (card `0033`'s per-build layout).
- The row's second line ends in blue **own bars**. The tooltip says: "Has its own action bars.
  Switching to it offers them."
- `saveBars` redraws the list when it is open, so the mark shows at once after **Save bars: build**.
- `sidebarChecks`: 2 new checks. "Never set" and "always set" both turn one red.

## What I need from you

1. `/reload`, open the talent window. Pass: builds you saved bars for say **own bars** in blue.
2. Pick a build with no bars. Click **Save bars: build**. Pass: its row says **own bars** at once.

## Acceptance

- [ ] WHEN a build has its own saved action bars, ITS ROW SHALL say so, and no other row SHALL.
