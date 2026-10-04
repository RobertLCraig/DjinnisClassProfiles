---
needs: 0046, 0079
---
# 0080 Compare a build's bars with yours, and pick

## Why
Rob, 2026-09-30, on card `0079`'s match: "that's not really what I'm going for... I was more
thinking like being able to compare and pick between them." The problem is the same as `0079`'s:
abilities set up on his Dungeon build were missing on his other Feral builds, and he dragged them
onto his bars mid-fight.

His two answers (asked 2026-09-30):
- Compare **on the real bars**, not in a list window.
- A pick goes **only to the builds he ticks**, not to every build of the spec.

## What was built (v0.61.0)
- Three ways in: a build row's right-click menu, **Compare its bars with yours** (rows with their
  own bars only); More > **Compare your bars with...** > a build or the spec layout;
  `/dcp bars compare <build>`.
- Compare mode draws that layout's buttons over the real bars, only where they differ, as `0046`'s
  preview does, with a separate pool of frames (`PlanTab.compareGhosts`) that take the mouse.
  - Amber: theirs differs. Click takes theirs onto your bar. Shift-click keeps yours. Both are picks.
  - Green: a pick. Click it again to undo that pick (your button comes back).
  - The tooltip names theirs and yours.
- A small window (`DjinnisCPCompare`, draggable like the prompt) says how many picks, with
  **Save picks to...**, **Put mine back** (every pick undone) and **Done**. Combat closes it and
  the ghosts (`PLAYER_REGEN_DISABLED`).
- **Save picks to...** lists this build, the spec layout, then every other build layout of the
  spec, one tick each; only this build is ticked to start. Save writes ONLY the picked buttons into
  each ticked layout, and its other buttons and keys stay. This build with no layout of its own
  gets a new one: all the bars now.
- More > **Put back the build bars** (from `0079`) undoes the last Save picks too; they share
  `db().matchUndo`.

Pure parts: `PlanTab.comparePlan`, `compareTargets`. Checks: `PlanTab.barCompareChecks`, 23 lines,
on a model of the bars and cursor. Twelve mutations on temp copies each made 1 to 3 checks fail
(one guard, the spec-changed message, needed a sharper check first). Lua 5.1: "no FAIL lines".

## Uncertain (in-game only)
- The ghosts are placed from Blizzard's action button rects (`ActionButtonUtil.ActionBarButtonNames`),
  as `0046`'s. Buttons from a bar addon (Bartender, Dominos) get no ghost.
- A ghost frame takes the mouse over a real action button. Out of combat only, and it closes in
  combat, but a click lands on the ghost, not the button, while compare mode is on.
- `UICheckButtonTemplate` in the Save picks box: its own label is not used; a font string beside it is.

## Acceptance
<!-- AC:BEGIN -->
- [x] #1 WHEN compare mode is on, A GHOST SHALL show only where the layout's button differs from the bar, or where picked. proves: `PlanTab.barCompareChecks`
- [x] #2 WHEN Rob clicks a ghost, ITS action SHALL go onto his bar; a second click SHALL put his back. proves: `PlanTab.barCompareChecks`
- [x] #3 WHEN Rob saves picks, ONLY the ticked layouts SHALL change, and only on the picked buttons. proves: `PlanTab.barCompareChecks`
- [ ] #4 In a client: on the Dungeon build, right-click a raid build with bars > Compare its bars with yours. The amber icons sit on the right buttons; clicking one swaps it; Save picks to... with that raid build ticked; switch to it and load its bars. proves: none
<!-- AC:END -->

## Comments

**2026-10-04** REVIEW (adversarial, separate agent). Holds. To `done/` with #4, the in-game look,
still open (board README, "A look waits on the product").

Attacked:
- `offline-check.lua` under Lua 5.1: "no FAIL lines", output read whole.
- Six mutations on a temp copy. Four went red: no ghost for a pick (2 FAIL lines), Save writes
  all of theirs instead of the picks (2), a second click no longer puts yours back (4), and the
  spec guard (the builder's). Two survived, both frame code the offline stubs cannot see:
  - Ticking every target in Save picks to... by default instead of only this build. That default
    is Rob's answer ("only the builds he ticks"); the Save itself is proved to write only what is
    ticked, so he still sees and can untick, but nothing guards the default.
  - Dropping the `PLAYER_REGEN_DISABLED` registration. Then the ghosts, which take the mouse,
    stay over real buttons into a fight. Keybinds still work; mouse clicks do not.
- The code: every bar change goes through `barsFence` (combat, cursor, vehicle), ghosts are drawn
  only out of combat, `GetRect` and scales pass `canRead`. Left-click only on a ghost; a
  right-click does nothing, so Rob's right-click rule is not crossed.

Minor, not blocking (worth a card if Rob meets them):
- Entering combat, Done, or starting another compare drops the picks and the "yours" copies, so
  taken buttons stay and **Put mine back** can no longer undo them. Done meaning "keep" is fair;
  combat discarding the undo is not said anywhere.
- With no saved loadout active (starter build), the first target, ticked by default, is the
  spec layout, which every build with no bars of its own loads.
- No ghost redraw on `ACTIONBAR_SLOT_CHANGED`, so a hand drag during compare leaves stale ghosts
  until the next click.
- `DjinnisCPCompare` is draggable but not in Edit Mode; nothing in this addon is, so this card
  does not make that worse.
- The `proves:` names are a function, not the printed check names ("compare bars and pick, ...").

Security:
1. Weakest point: a ghost is a mouse-taking frame over real action buttons. Combat closes it and
   every action is fenced, so the worst is a missed mouse click out of combat.
2. Unchecked: `/dcp bars compare <name>` takes any text, but it only selects a key of Rob's own
   `barsDB`, and an unknown key is answered "No saved ... layout".
3. Leaks: nothing leaves the client. Tooltip and chat show only his own spell and macro names.

Not looked at in a client: there is none here. #4 is the look.
