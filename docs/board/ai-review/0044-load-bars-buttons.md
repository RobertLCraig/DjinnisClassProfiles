---
needs: 0036
---
# 0044 Load bars buttons beside the Save bars buttons

## Why

Rob, 2026-09-23: "so far addon looks to be working well. Need to add a 'load bars' build and spec."

## Built, v0.37.0

- Under the Save bars buttons in the list beside the talent window: **Load bars: build** and
  **Load bars: spec**. The list ends one button higher to make room.
- `PlanTab.loadBars(forBuild)` picks `<spec> / <build>` or `<spec>` and calls `applyBars`, the
  same apply as the offer's Apply. It keeps the undo, and it is out of combat only.
- It asks nothing first, because `/djbis bars undo` puts the old bars back.
- With no layout saved, it says so and changes nothing.
- `barChecks`: 4 new checks. Two mutations, each turned red.

## What I need from you

1. `/reload`, open the talent window. Pass: four buttons, two rows, not over the list.
2. Change one action bar slot. Click **Load bars: spec**. Pass: it comes back, and chat says how
   many changed.
3. On a build with no bars of its own, click **Load bars: build**. Pass: chat says none is saved.

## Acceptance

- [ ] WHEN Load bars is clicked, THE ADDON SHALL apply that saved layout, or say none is saved.
