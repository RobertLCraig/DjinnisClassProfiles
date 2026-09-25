# 0065 Save one build to the game from its row; nothing is offered on its own

## What I need from you

In the game, v0.50.0:

1. `/reload`, then log in or switch spec. **No loadout box should appear.**
2. Open the talent window. In the list beside it, hover a grey build (one marked "spare"). The
   tooltip ends "Right-click to save it to the game as a loadout."
3. Right-click two grey builds, then close the talent window. Both should be saved as
   "[CP] <build>". The game cannot make a loadout while the window is open, so the addon makes them
   when the window closes.
4. Right-click a build that is saved already. Chat says whether it holds the plan. Nothing changes:
   a right-click never overwrites a loadout.

Pass: no box on login or spec change, and a right-click saves that one build only.

## Why

Rob, 2026-09-25: "I think I'm getting a little tired of this process. Lets park loading all
loadouts automatically. lets just save them in the addon, and give the user an option per loadout
to save to the game".

## What was built

- `PlanTab.armLoadouts` no longer offers the loadout box at login, and `PlanTab.onLoadoutEvent`
  no longer offers it on a spec change. The end of the old-loadout queue (`tagNext`) no longer
  opens it either. The box is still there on demand: More > Make the planned loadouts, or
  `/dcp loadouts`.
- `PlanTab.saveOne(name)`: a missing build goes through `createMissing` and a drifted one through
  `resetDrifted`, each for that one name only. So the same guards apply: room, the spare, the
  talent window, and one change in flight. A build that is saved and on plan is only said.
- The sidebar row takes the right button (`sidebarClick(row, button)`). It does nothing on the
  player's own loadouts or on group headers. The tooltip names the right-click.
- `PlanTab.saveOneChecks`: 11 checks.

## Done when

1. The offline check passes (`lua offline-check.lua`, and `250`).
2. Rob's steps above pass in the game.
