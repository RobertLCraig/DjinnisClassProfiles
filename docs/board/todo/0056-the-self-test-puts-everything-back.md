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

**2026-09-24, Claude (adversarial review of 552c380). Back to todo: the net misses your saved data
and anything the run creates.**

How I tried it: a scratch copy, seeded with saved variables as a client has them, and a throw put at
a chosen point (`%TEMP%\rev56\driver.lua` and `throw.py`, run on the copy only).

Findings, in the order to fix them:

1. **A throw can wipe your saved action bars for good.** The net does not cover `DjinnisBiSDB` or
   `DjinnisBiSCharDB`. A throw in `barChecks` after line 8794 leaves `DjinnisBiSDB.bars` as the
   test's `{ Feral = { slots = {} } }`, so every saved layout is gone. Any throw anywhere leaves
   `statContext` as "raid": `selfTest` sets it at line 9364 and puts it back only at its last line.
   The net then offers **Reload now**, and a reload writes the saved variables to disk, so the loss
   stays. Even a clean run changes them: fake config ids 24, 40, 41 and 42 land in
   `DjinnisBiSCharDB.spares`. The spare checks write into the real table, and `keptSpares` is that
   same table, so putting it back changes nothing. With a level the game gives, fake ids land in
   `madeAt` too (card `0055`). Fix: `runSelfTest` gives the run deep copies of both tables and puts
   the real ones back afterwards, whatever happened. Add it to the net's proof: a run that replaces
   `db().bars` and throws leaves it as it was.
2. **A global the run creates is left behind, and that is your talent window again.** `restore`
   only walks names that existed at the snapshot. `Blizzard_PlayerSpells` is `LoadOnDemand` (its
   `.toc`). Until the talent window or spellbook is first opened, `PlayerSpellsFrame` and
   `ClassTalentImportExportMixin` do not exist. `loadoutChecks` sets both to fakes. A throw there
   (tried: right after the first offer check) leaves both fakes in place. Blizzard then never loads
   the real window: `PlayerSpellsUtil.lua:1-3` loads it only `if not PlayerSpellsFrame`, and the
   callers then call methods the fake does not have (`IsInspecting`, `TrySetTab`). So the talent window and the spellbook will not
   open until a reload. `importOne` would also make real loadouts through the fake mixin. Fix: in
   `restore`, remove every name in `_G`, and in each noted table, that the snapshot did not have,
   and count those in the FAIL line.
3. **`restore` itself is not guarded.** It runs outside the `pcall`, over every global of every
   addon. 12.1 has `table.freeze` (LuaTableUtilDocumentation.lua) and secret values and secret
   tables (FrameScriptDocumentation.lua: `issecretvalue`, `issecrettable`, `canaccesstable`). The
   source cannot say whether `rawequal` on another addon's secret throws. If one `put` throws, the
   rest of the restore is skipped and no FAIL line prints. Fix: `pcall` each `put`, and count what
   could not be put back.
4. Smaller, the same root: things that outlive the run.
   - The Equip all check (line 11410) calls the real `equipAll`. That schedules
     `saveSetAndSay("Feral", "st")` on the real `C_Timer`, which runs two seconds after the test
     against the real equipment manager. On the warlock it prints "No equipment set saved: not worn:
     ...". On a Feral druid wearing the whole plan it saves the addon's own "DBiS" set. The
     loadout queue's polls are safe: they check `PlanTab.q`, which the net puts back.
   - The prompt and popup frames are built on first use. If the test builds them, `restore` sets
     `PlanTab.promptFrame` and `popupFrame` back to nil. The Reload box then builds a second
     `DjinnisBiSPrompt`, and the first stays hidden. Harmless, but it happens on every first run
     after a login.

What held:
- **The net, for names that already existed.** A throw is a FAIL line, and each value put back is
  counted and named. My four throws put back 8, 7, 5 and 1 of the game's values, named each time,
  and the offline check went red each time.
- **The shadowed `wasInstance` fix is real.** Putting the shadow back turns the check red through
  the net.
- **Nested Blizzard tables.** Every nested write in the checks goes into a fake the check made
  first: `Constants` (lines 8282, 8363), `Auctionator` (10379), `KeystoneLootAPI`, `C_Container`.
  `Enum.TraitConfigType` is a top-level field of `Enum`, which the net notes. I found no write into
  a real nested Blizzard table.
- **Reload from a button is allowed.** `ReloadUI` is `C_UI.Reload`
  (Blizzard_SharedXML/InterfaceUtil.lua:1), which has no restriction in
  UIManagerDocumentation.lua:65. Blizzard's own `AddonList_OnOkay` calls it on a click.
- **Cost.** A pretend `_G` of 150,000 globals and 400 `C_` namespaces takes about 60 ms to note
  and 30 ms to compare under Lua 5.1. One hitch on a typed command.
- **Tests.** `offline-check.lua` exits 0 under Lua 5.1 and 5.4.6, output read whole, no load error.
  All 36 non-druid specs pass spec mode. The builder's 31 mutations each go red. My mutations
  emptying `SWAPPED_TABLES`, dropping the reload offer and dropping the `promptBusy` pin stay green.
  The harness has no `ReloadUI` and no open prompt, so those are read, not tested.

Security, where the card produced code:
1. *Weakest point:* the self-test writes into your saved data and the game's own tables, and the
   net covers only part of it (findings 1 and 2).
2. *Unchecked:* `restore` runs over every global of every addon with no guard (finding 3).
3. *Leaks:* nothing leaves the client. A FAIL line names up to five globals, which are public.

**No browser, no game client.** The surface is in-game UI. After the fix: `/reload`, then
`/djbis test` **before** opening the talent window or spellbook. Click **Later**. Open the
spellbook, then the talent window, twice each. Both work. **More > Offer the saved bars** still
knows your layouts. Then click **Reload now**.
