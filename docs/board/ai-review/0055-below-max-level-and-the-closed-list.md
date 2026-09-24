# 0055 Below max level a loadout is the plan as far as it can be, and a closed list comes back

## Why

Rob, 2026-09-24, on a level 81 Warlock:

- "Reset to plan" made the same loadout again on every click ("Making 1 loadout ... Made 1 of 1",
  three times in 30 seconds). Below the level cap the game saves only the part of a build the
  character can hold: fewer points, and each spec's apex node (a `Tiered` node) opens its ranks at 81,
  84 and 90 (`rankLevels` in Raidbots' talents.json). The fresh loadout never matched the plan, so it
  read as drifted forever. The strings themselves are clean: no stored build buys a free node or has
  a bad rank or choice (checked with `%TEMP%\free_check.py`).
- "the side panel next to the talent window has disappeared and I cant see how to get it back".
  `updateSidebar` placed the frames only when the list was open. A list closed on another character
  (`sidebarClosed` is account-wide) and built closed on this one had a "BiS plan" tab with no anchor,
  so it was never drawn.

## What

- `PlanTab.partOfPlan(have, planned)`: every node the loadout buys is in the plan, with the same
  choice and no more ranks. `PlanTab.planDiffers(have, planned, short)` uses it when `short`.
- `PlanTab.belowCap()`: `UnitLevel("player") < GetMaxLevelForPlayerExpansion()`, false when either
  cannot be read. `loadoutGaps` (offer, Create, Reset) and `talentsEdited` pass it. At the cap a
  loadout must match exactly, as before. After a level-up the trimmed loadout reads as drifted
  again, so Reset makes the fuller one.
- `updateSidebar` places the frames in "tab" mode too. More sits 6 pixels from the close button.
  The window's More menu has "Show the build list" while the list is closed.

## Acceptance

- [x] Part of the plan is the plan below the cap, and not at it; an added node or another choice is still drifted. proves: self-test "below the level cap, part of the plan is the plan"
- [x] The tab is placed when the list is closed. proves: self-test "sidebar stays closed, the tab is placed when the list is closed"
- [x] "Show the build list" is in the window menu only while the list is closed. proves: self-test `menuChecks`
- [x] Mutations: level trim off, the cap ignored in gaps, more ranks allowed, another choice allowed, the tab not placed, no menu item. Each turns the offline check red (`%TEMP%\mut0053.py`).
- [ ] In game, on the level 81 Warlock: `/reload`. The loadout offer does not list the loadouts it already made. Open the talent window: the list is beside it, or its "BiS plan" tab is. proves: manual (Rob)

## Not this card

- The sidebar's green tick (`sidebarList`) still compares exactly, so below the cap no row may show
  the tick. Cosmetic; say if it matters.
- "Dungeon" is selected on the Warlock, so Reset leaves it; it now reads as the plan anyway, as long
  as it is part of it.

## Comments

**2026-09-24, Claude.** Built in v0.44.0, deployed. Offline check green under Lua 5.1 and 5.4; all 36
non-druid specs pass spec mode. Rob confirmed the level: "I am currently on an 81 warlock".
