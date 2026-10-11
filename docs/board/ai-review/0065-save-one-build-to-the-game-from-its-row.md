# 0065 Save one build to the game from its row; nothing is offered on its own

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

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

## Acceptance

<!-- AC:BEGIN -->
- [x] The offline check passes (`lua offline-check.lua`, and `250`). proves: the `save one build` checks in `PlanTab.saveOneChecks`
- [ ] After `/reload`, log in and then switch spec and back: no loadout box opens on its own. proves: manual
- [ ] Open the talent window and right-click a grey row marked `spare` in the list beside it: only a menu opens (Wear it, Save to the game and Export... among its items), and nothing else changes. proves: manual
- [ ] Choose Save to the game on two grey rows, then close the talent window: both are made as `[CP] <build>`, and their rows are no longer grey. proves: manual
- [ ] Right-click a saved build: "Saved in the game" is greyed out, and hovering it still shows its tip. proves: manual
- [ ] Choose Export... on a row: a box shows the string, selected; Ctrl+C copies it and Escape closes the box. proves: manual
- [ ] Change a saved build's talents in the talent window, then right-click its row and choose Reset to the plan...: chat says "Close the talent window first, then choose Reset to the plan." and nothing changes. proves: manual
<!-- AC:END -->

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

**2026-10-11** Clear-down (attended, Rob asked): ticked the offline-check criterion (checks `save one build, a spec change offers nothing`, `save one build, right-click on a build row opens its menu, and makes nothing`, `save one build, both made when the window shuts` and the rest of `PlanTab.saveOneChecks` exist and pass in the Lua 5.1 offline check); looks rewritten for v0.69.0, one `proves: manual` line each, in a new Acceptance block that replaces Done when. The menu now also holds Wear talents only, Load bars only and Copy to your builds... (cards 0081, 0057). The old step 6 said Reset asks first once the window is shut, but the build list only shows while the talent window is open (`updateSidebar`), so from the row Reset always gives the close-first line; the look asks only for that. A drifted build is reset from More > Make the planned loadouts. Moves to ai-review/ with only in-game looks open.
