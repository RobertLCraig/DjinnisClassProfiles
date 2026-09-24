# 0056 The self-test puts the game's own parts back, even when a check throws

## Why

Rob, 2026-09-24, after clicking More > Run the self-test on a level 81 Warlock: "The talent window is
no longer openable after closing it." Chat showed three FAIL lines from the loadout checks and no
closing "passed / failed" line.

- A real prompt was open in the client (the login loadout offer), so `offerLoadouts` answered "busy",
  where offline it always answers "shown". The next line indexed the missing prompt and threw.
- The throw skipped `loadoutChecks`' restore, so `PlayerSpellsFrame`, `C_ClassTalents`, `C_Traits`,
  `InCombatLockdown`, `print` and more stayed as the checks' fakes. The talent window was a fake
  table until a reload. The screenshot also shows the list titled "Feral builds" on the Warlock and a
  test popup left up, both from the same run.

## What

- `PlanTab.runSelfTest(run)` is what `/djbis test` runs: it notes every global, the fields of every
  `C_` namespace and of the tables in `PlanTab.SWAPPED_TABLES`, and every PlanTab field, runs the
  test in a `pcall`, and puts back whatever changed. A throw is a FAIL line; a Blizzard value it had
  to put back is a FAIL line naming it. In a client it then offers **Reload now**, because a write
  to a Blizzard global taints it until the interface reloads.
- The net found a real leak on its first run: a check reused the local name `wasInstance`, so its
  block restored a fake `GetInstanceInfo` for good. Renamed `lockInstance`.
- `loadoutChecks` pins `PlanTab.promptBusy` to false, and no longer indexes a prompt that was not
  shown.
- The self-test is off the More menu. It is a check for whoever changes the addon, not a way to use
  it. Typed `/djbis test` still runs it.

## Acceptance

- [x] A run that swaps a global, a `C_` field and a PlanTab field and then throws leaves all three as they were, and says so. proves: `offline-check.lua` "the self-test net"
- [x] The self-test leaves no Blizzard value swapped. proves: `offline-check.lua` (the net would print a FAIL line naming it)
- [x] No self-test item in More. proves: self-test `menuChecks`
- [x] Mutation: the net's restore removed turns the offline check red (`%TEMP%\mut0053.py`, "self-test net off").
- [ ] In game: `/reload` first (the old run is still in effect). Then `/djbis test`, close the Reload box with Later, open and close the talent window twice. It works. Then click Reload now. proves: manual (Rob)

## Not this card

- Card `0038` (taint) still stands: the checks write Blizzard globals at all. The net limits the
  damage to "until the reload"; it does not remove the taint.

## Comments

**2026-09-24, Claude.** Built in v0.45.0, deployed. Offline check green under Lua 5.1 and 5.4; all 36
non-druid specs pass spec mode.
