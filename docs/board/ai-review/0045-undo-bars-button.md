---
needs: 0044
---
# 0045 An Undo bars button

## Why

Rob, 2026-09-23, after the Load bars buttons: "an undo button sounds eminently useful!"

## Built, v0.37.1

- A third row under the Load bars buttons: **Undo bars**, full width. It calls
  `PlanTab.undoBars`, the same as `/djbis bars undo`.
- It is greyed while this character has nothing to undo (`PlanTab.canUndoBars`). The list redraws
  after each save, load and undo (`PlanTab.barsChanged`), so the button follows at once.
- The list ends one more button higher to make room.
- `barChecks`: 2 new checks. "Always on" turns one red.

## What I need from you

1. `/reload`, open the talent window. Pass: **Undo bars** is greyed.
2. Click **Load bars: spec**. Pass: **Undo bars** lights up. Click it: the bars go back, and it
   greys again.
3. Pass: the list still shows several rows above the five buttons.

## Acceptance

- [ ] WHEN a load can be undone, THE BUTTON SHALL be on, and undo it; otherwise it SHALL be greyed.
