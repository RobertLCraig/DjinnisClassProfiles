# 0042 The list shows which builds have their own action bars

## Why

Rob, 2026-09-23, with a screenshot of the list: "Need to show if a loadout has different saved
bars for its build."

## Built, v0.36.1

- `PlanTab.sidebarList` sets `bars` on a row when `DjinnisBiSDB.bars` holds `<spec> / <build>`
  (card `0033`'s per-build layout).
- The row's second line ends in blue **own bars**. The tooltip says: "Has its own action bars.
  Switching to it offers them."
- `saveBars` redraws the list when it is open, so the mark shows at once after **Save bars: build**.
- `sidebarChecks`: 2 new checks. "Never set" and "always set" both turn one red.

## What I need from you

1. `/reload`, open the talent window. Pass: builds you saved bars for say **own bars** in blue.
2. Pick a build with no bars. Click **Save bars: build**. Pass: its row says **own bars** at once.

## Acceptance

- [ ] WHEN a build has its own saved action bars, ITS ROW SHALL say so, and no other row SHALL.

## Comments

**2026-09-23** Adversarial review of 42414e4, and of 6c318b8 where it moved the redraw into
`barsChanged`. Verdict: clean, to human-review for the in-game checks above.

What I attacked. The key built from `spec .. " / " .. name` with a nil spec, a spec layout marking
build rows, own loadouts and spare-worn builds, and whether each check goes red when broken. The
harness is clean on the real file under Lua 5.1 and 5.4. Mutations ran on a copy in
`$TEMP/rev-0041-45`.

What held:
- A nil spec cannot reach the concat at `DjinnisBiS.lua:5927`. With no spec every group is empty:
  `BOSSES[nil]` and `BUILDS[nil]` give no rows, and own rows read `spec and saved or {}`. So the
  loop body never runs.
- The key is the same one `saveBars` writes (`:7069`) and `barsKey` reads: `playerSpec()` both
  sides, and `activeLoadoutName` maps a spare `BiS: X` back to `X`. So a spare-worn build's row
  shows its mark.
- The spec-wide layout marks no row. It is keyed `Feral`, never `Feral / <name>`.
- Always set turns 1 red. Never set turns 1 red. Marking from the spec layout turns 1 red.

What no check covers (green under mutation): the redraw after **Save bars: build**. Removing
`barsChanged()` from `saveBars` at `:7092` stays green, because the harness frame is never shown.
Check 2 above is the only proof.

Smaller things, not blocking:
- Own loadouts (card 0041) get the mark too, and their bars are offered on switch the same way. No
  check covers own rows. That is right, just untested.
- `sidebarList` is headed "Pure, for /bis test" but now reads `db().bars`. The check swaps
  `db().bars` to cope. Worth passing the table in if it grows.
- The acceptance has no `proves:` names, which the board README asks for.

Security:
1. Weakest point: a hand-edited saved file where `bars` is not a table. `sidebarList` checks
   `type(db().bars) == "table"` first, so the list still draws with no marks.
2. Unchecked: nothing new. The key is built from the spec and a name the game gave and `canRead`
   passed. Nothing is written.
3. Leaks: nothing. It shows whether a layout exists for a build, to the player who saved it.

No client can be run by an agent. The in-game checks are this card's What I need from you. Also
look at: the blue "own bars" fits on the second line after the boss names on a raid row, and is
not cut off by the tick.
