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

## Comments

**2026-09-23** Adversarial review of 68db0fa. Verdict: clean, to human-review for the in-game
checks above.

What I attacked. The key `loadBars` picks, a nil build, the offer's stale-build guard, what undo
holds after one or two loads, combat, and the layout of the buttons. The harness is clean on the
real file under Lua 5.1 and 5.4. Mutations ran on a copy in `$TEMP/rev-0041-45`.

What held:
- The key is read at click time (`DjinnisBiS.lua:7220`). There is no prompt in between, so the
  stale-build case the offer guards against (`:7291`) cannot happen here. The offer's guard is
  unchanged.
- A spare-worn build loads its own layout: `activeLoadoutName` maps `BiS: X` back to `X`.
- No loadout selected, or the starter build: `activeLoadoutName` is nil and chat says so. Removing
  that guard crashes the harness at the concat on `:7227`, so it is covered.
- No layout of that key: chat says so and nothing moves. Removing the guard turns 2 red. Loading the
  spec's layout for "build" turns 3 red.
- Undo after a load: `applyBars` keeps the character's own bars over a second load straight after,
  and takes the bars as they are now when anything moved since the last load (`:7198`). So one
  undo always goes back to before the loads, not to a stale point.
- Combat, a full cursor, a vehicle bar: `applyBars` is fenced by `barsFence`. The list also hides
  itself in combat.
- Layout, read against `SharedUIPanelTemplates.xml`: each button is 128 px, `(280 - 24) / 2`.
  After 0045 the rows sit at 8, 36 and 64 px, 24 px tall, 4 px apart. The list ends at 96 px, so
  there is an 8 px gap above the top row.

What no check covers (green under mutation): which button calls which. Swapping **Load bars: spec**
to `loadBars(true)` stays green, because the harness frames do nothing. Check 2 and 3 above are the
only proof.

Smaller things, not blocking:
- The load asks nothing, and relies on undo. That is fine only while undo is safe to press. See
  card 0045, bounced for that.
- A hand-edited saved file where the layout under a key is not a table errors in `applyBars`. That
  was already so for the offer and is the player's own file.
- The acceptance has no `proves:` name, which the board README asks for.

Security:
1. Weakest point: one click overwrites this character's bars and keys with no question. Undo is
   the only way back.
2. Unchecked: nothing new. The key is built from the spec and a name `canRead` passed, and the
   apply is fenced for combat.
3. Leaks: nothing. The chat line names the layout key and counts, to the player.

No client can be run by an agent. The in-game checks are this card's What I need from you. Also
look at: "Load bars: build" and "Save bars: build" fit in 128 px without being cut.
