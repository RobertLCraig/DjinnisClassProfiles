# 0065 Save one build to the game from its row; nothing is offered on its own

## What I need from you

In the game, v0.51.0:

1. `/reload`, then log in or switch spec. **No loadout box should appear.**
2. Open the talent window. In the list beside it, right-click a grey build (one marked "spare").
   A menu opens: Wear it, Save to the game, Export. **A right-click alone does nothing else.**
3. Choose Save to the game on two grey builds, then close the talent window. Both are saved as
   "[CP] <build>" when the window closes.
4. On a saved build, the menu shows "Saved in the game" greyed out. Hover it: the tip still shows.
5. Choose Export. A box shows the string, selected. Ctrl+C, then Escape closes it.
6. Change a saved build's talents, then right-click it: "Reset to the plan..." With the talent
   window open it asks you to close it first; shut, it asks before it resets.

Pass: no box on login or spec change, a right-click only opens a menu, and each item does what it
says.

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
- The sidebar row takes the right button (`sidebarClick(row, button)`), which opens a menu (see the
  v0.51.0 comment below).
- `PlanTab.saveOneChecks` covers `saveOne`, the menu's items, `rowState` and `resetAsk`.

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

### 2026-09-25: a right-click opens a menu (v0.51.0)

Rob: "not sure I like a single right click doing any action. right clicks should open menus. (this
could be part of the menu I also suggested previously about being able to edit/import/export/delete
each build". That menu is card `0057`. This is its first part.

- `sidebarClick` on the right button calls `PlanTab.openRowMenu`. That opens `MenuUtil.CreateContextMenu`
  with `PlanTab.rowMenuItems(e, PlanTab.rowState(name))`, drawn by the More menu's `fillMenu`.
- The items:
  - **Wear it**, whose tip depends on the row's state.
  - **Save to the game**, missing builds only. It is greyed out, with the reason, when the game
    would refuse the build or it is an untagged old one.
  - **Saved in the game**, greyed out.
  - **Reset to the plan...**, for drifted builds. `PlanTab.resetAsk` asks first, and refuses while the
    talent window is open, because the window's close holds one job.
  - **Export...**. `PlanTab.showExport` puts the string in a copy box. There is no Export for a
    string the game would refuse.
- In combat, a right-click says so and opens nothing. A header has no menu.
- `whenTalentsClose` drops `saveWaiting` when another job replaces the save.

A fresh review found no item that acts without its click. Its three risks are fixed:
- Reset with the talent window open.
- The Wear tip on "old" rows.
- The Wear tip on drifted rows.

Its nits are fixed too: the warning order, Export on a refused string, `buildFor`, the tooltip, and
combat. The API checks passed against `wow-ui-source`.

Copy, import, rename and delete need "your builds" stored in SavedVariables, which is card `0057`.

## Done when

1. The offline check passes (`lua offline-check.lua`, and `250`).
2. Rob's steps above pass in the game.
