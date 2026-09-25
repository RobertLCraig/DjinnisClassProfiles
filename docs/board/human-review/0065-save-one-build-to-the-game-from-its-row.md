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
- `PlanTab.saveOne(name)` makes a missing build through `createMissing`, for that name only. A
  saved build is only described, whether it holds the plan or not.
- The sidebar row takes the right button (`sidebarClick(row, button)`). It does nothing on the
  player's own loadouts or on group headers. On a row with a warning, it says the warning. The
  tooltip names the right-click on unsaved rows.
- `PlanTab.saveOneChecks`: 22 checks.

## Comments

### 2026-09-25: review fixes

A fresh reviewer found 3 bugs and 2 risks. All five are fixed:
- **Several right-clicks now wait together.** With the talent window open, each build is added to
  `PlanTab.saveWaiting`. `saveWaited` makes them all in one queue when the window closes. Before
  this, the window's single close slot kept only the last click.
- **OnDoubleClick takes the left button only.** A double right-click also wore the build.
- **An untagged "X" from before the tag is refused**, with a pointer to the box. Before, a second
  "[CP] X" was made, and the next tag pass deleted the player's "X".
- **A changed saved build is never reset from a right-click.** It is only described; the box's Reset
  asks first.
- **No room is said plainly**, counting the builds already waiting.

Stale wording about the box coming back was fixed too. Left as a nit: with two loadouts of one
name, `loadoutGaps` reads only one.

## Done when

1. The offline check passes (`lua offline-check.lua`, and `250`).
2. Rob's steps above pass in the game.
