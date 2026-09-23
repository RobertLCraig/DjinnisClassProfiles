# 0041 The list beside the talent window shows your own loadouts too

## Why

Rob, 2026-09-23: "Additionally should show all existing blizzard builds in the list on the side
(which is MUCH easier to use!)"

## Built, v0.36.0

- `PlanTab.sidebarList` takes `stringOf` and adds a group, **Your loadouts**. It holds each saved
  loadout of the spec whose name no stored build has, sorted by name, with a book icon.
- The tick compares the live tree with that loadout's own string. The row is marked active when
  it is selected. Hover paints the tree diff from its string (`showTreeDiff(name, code)`).
- Double-click switches through `loadTalents`, the same path as every other row.
- The spare loadout (card `0040`) is never listed. Its build's row stands for it.
- `sidebarChecks`: 7 new checks.

## What I need from you

1. Open the talent window. Pass: a **Your loadouts** group at the bottom, holding every loadout
   of yours that is not a plan build. Compare it with Blizzard's dropdown.
2. Double-click one. Pass: it is worn, and it gets the tick.
3. Hover one. Pass: the tree shows what it would change.

## Acceptance

- [ ] WHEN the talent window opens, THE LIST SHALL show every saved loadout of the spec, the plan's and the player's own.
- [ ] WHEN an own loadout is double-clicked, THE ADDON SHALL switch through Blizzard's helper only.
