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

**2026-09-24, Claude. The review's findings, fixed in v0.46.0.**

1. **Saved data.** `DjinnisBiSDB` and `DjinnisBiSCharDB` are deep-copied before the run and written
   back in place after, clean run or throw. The harness now proves a throw after the checks wiped
   `bars` and set `statContext` leaves both as they were.
2. **Globals the run made** are removed after it, unless they are frames (userdata at `[0]`), and
   unless an add-on loaded during the run (then a new global may be real, and it says so). Fields a
   run added to a noted table go the same way. The harness proves a fake `PlayerSpellsFrame` made
   by the run is gone after, as are a new `Enum` field and a swapped `SlashCmdList` entry.
3. **Every write-back is in `pcall`**, and `restore` itself is too; a refused write is a FAIL line
   that says to reload.
4. **Equip all's set save** goes through `PlanTab.later`, and the check holds it, so nothing fires on
   the real equipment manager after the test.
5. `loadoutChecks` now puts a shown prompt in place, as the client had, so the `promptBusy` pin is
   proven. The harness proves the Reload now offer.

**2026-09-24, Claude (second adversarial review, of 7a81698). Back to todo: the net leaves new
PlanTab fields, can still skip your saved data, and half of it has no check.**

How I tried it: a scratch copy (`%TEMP%\rev5556`), `mut.py` for mutations and `exp.py` for a throw
or a failing compare at a chosen point. Nothing ran on the real file.

Findings, in the order to fix them:

1. **A PlanTab field the run adds is never removed, and the fix added one.** `restore` puts back
   only PlanTab fields that existed at the snapshot (DjinnisBiS.lua:11933). `loadoutChecks` now sets
   `PlanTab.promptFrame` to a fake with only `IsShown` (line 8272). If no prompt has been shown this
   session, the snapshot has no `promptFrame`. A throw before line 8487 then leaves the fake. I put
   the throw right after the first offer check. The net's Reload box then throws `attempt to index
   field 'title'` (line 4682), so the slash command ends in a Lua error. `promptBusy()` answers true
   from then on, and every later prompt throws the same way until a reload. That includes the
   login loadout offer and the bars prompts. Fix: in `restore`, remove PlanTab fields the snapshot
   did not have, unless they are widgets (as for globals). Add the case to the net's proof.
2. **The saved data is still written back last, after the steps that can throw.** Finding 3 asked
   for each `put` in a `pcall`. Only the `rawset` is guarded. The `rawequal(rawget(t, k), v)` in
   `put` (line 11893) and the `snap.g[k] == nil` in the removal loop (line 11910) run outside it.
   DECISIONS says a secret may not be compared. The source cannot say whether `rawequal` counts. If
   one of them throws, `restore` stops before the saved data (line 11923). The FAIL line at 11945
   then says "Reload the interface now", and the reload writes the test's saved data to disk. That
   is finding 1 of the first review again. I simulated it by making `rawequal` throw on one global.
   After the net, `bars` was empty and `statContext` was "raid". Fix: write the saved data back
   first, since those are the addon's own tables. Move the compare inside the `pcall`.
3. **Half of the net can be broken without the check going red.** Each of these mutations stays green:
   - `deepCopy` one level deep. A nested write in place then stays. I ran it: fake spare id 24 is
     left in `DjinnisBiSCharDB.spares`. That is the write the first review named, and the proof
     only swaps whole fields (`bars = {}`).
   - `DjinnisBiSCharDB` dropped from `SAVED_VARIABLES`. Card 0055's third finding is closed by this
     table, and nothing checks it.
   - `put` without `pcall`, `restore` without `pcall`, and the "refused" line removed. The harness
     can test these: swap the global `rawset` to throw on one key.
   - `isWidget` always false. A named frame made during a run would then lose its global. The
     harness has no widget. A global with userdata at `[0]` (`io.stdout`) is one.
   - `keepNew` always false. No check loads an add-on during a run.

A note, not a finding: `PlanTab.recheckSoon` (line 5627) still calls the real `C_Timer`. The popup
button checks (lines 11449 and 11691) click buttons that call it, so `checkSetup` runs 2 seconds
after the test, against the real game. That only reads the real setup. At worst the real reminder
shows, and it saves nothing. Route it through `PlanTab.later` when you are next in there.

Each earlier finding:
- 1 (saved data): **closed for a whole-field swap and a replaced table**, and the proof checks both.
  **Open when a compare in `restore` throws** (finding 2). **Unproven for nested writes and the
  character's table** (finding 3).
- 2 (globals the run made): **closed for globals and noted tables.** The proof goes red for a fake
  `PlayerSpellsFrame`, a new `Enum` field and a swapped `SlashCmdList` entry. **Open for PlanTab**
  (finding 1).
- 3 (`restore` unguarded): **half closed.** The writes and the call are guarded. The compares are
  not, and none of it is checked (findings 2 and 3).
- 4 (Equip all's set save): **closed.** It goes through `PlanTab.later`, and "saves the set once,
  later" goes red with the old `C_Timer` call back.
- 4b (a second `DjinnisBiSPrompt`): that one does not happen. New PlanTab fields are kept, so the
  real frame stays, and finding 1 is that same rule the other way round.

What held:
- `offline-check.lua` exits 0 under Lua 5.1.5 and 5.4.6. I read the whole output: no load error,
  no FAIL line. The builder's 40 mutations each go red on the scratch copy.
- My 17 mutations for this card: 9 caught (saved data not restored, not cleared, new globals kept,
  new table fields kept, `keepNew` always true, the fake `promptFrame` not put back by
  `loadoutChecks`, the set save not held, no Reload offer, `C_` namespaces not noted). 8 missed
  (finding 3).
- A clean run leaves the character's saved table as it found it (checked before and after on the
  scratch copy).
- `C_AddOns.GetNumAddOns` and `IsAddOnLoaded` exist in 12.1.0 (AddOnsDocumentation.lua:256, 322).
  `IsAddOnLoaded` takes a `uiAddon`, the same type `GetAddOnName` takes as an index (line 187), so
  counting by index is sound. Whether the count
  includes Blizzard's load-on-demand add-ons (`Blizzard_PlayerSpells`) cannot be read from the
  source. So `keepNew` may not notice the load that matters most. No check in the self-test loads
  one, so this is a note.

Security, where the card produced code:
1. *Weakest point:* what `restore` does when a step throws. It stops before the saved data and
   tells you to reload (finding 2).
2. *Unchecked:* nested saved data, the character's table, refused writes, widgets and the
   add-on-loaded path (finding 3), and new PlanTab fields (finding 1).
3. *Leaks:* nothing leaves the client. A FAIL line names up to five globals, which are public.

**No browser, no game client.** The surface is in-game UI. After the fix: `/reload`, then
`/djbis test` **before** opening the talent window or spellbook. Chat ends with the pass line, and
no Lua error shows. Click **Later**. Open the spellbook, then the talent window, twice each: both work.
**More > Make the planned loadouts** opens its box, so the prompt frame is real. **More > Offer the
saved bars** still knows your layouts. Then click **Reload now**.
**2026-09-24, Claude. The review's findings, fixed in v0.46.1.**

1. **PlanTab fields a run adds are removed**, unless they hold a frame (`[0]` userdata). Proven with
   a field no session had.
2. **Saved data goes back first, on its own** (`PlanTab.restoreSaved`, in its own `pcall`, before
   `restore`). It fills the tables the run started with and puts those back as the globals. Every
   compare in `restore` goes through `same()`, a guarded `rawequal`. The net's two functions are
   read before the run, so a run cannot swap them.
3. **The net's other parts are proven in `offline-check.lua`**, in four runs: a throw (with a
   nested saved table, a frame global, a fake and a real PlanTab frame), a refused write-back (a
   `write` that throws for one key), an add-on loading mid-run (`addOns` raised), and a run that
   breaks the net's own helper (saved data still back, the failure said). All 8 missed mutations
   from the review are in `mut0053.py` and red.

Not changed: `recheckSoon` still uses the real timer. It re-reads the real setup after 2 seconds,
which is what a click does anyway.

**2026-09-24, Claude (third adversarial review, of 96974cd, read on the renamed file at 3b16a73).
Back to todo: one finding. The guarded compare, the fix for the last review's finding 2, has no
check.**

How I tried it: a scratch copy (`%TEMP%\rev0058`). The builder's `mut0053.py` was adapted to the
renamed file (`mut0053cp.py`), and my own list is `revmut.py`. One run at a time. Nothing ran on
the real file.

Finding:

1. **Take the `pcall` out of `same()` and the check stays green** (DjinnisClassProfiles.lua:11984,
   `return rawequal(a, b)`). That guard was the last review's finding 2: a compare that throws on a
   secret stops `restore` part way, and a reload then writes whatever is left. The saved data now
   goes back first, which limits the damage, but nothing shows the rest of the restore survives a
   compare that throws. Fix: add a fifth net run to `offline-check.lua` that swaps the global
   `rawequal` to throw for one value. Then check the other values still go back and the run says
   so. The second review did exactly this by hand.

Each earlier finding:
- Second review 1 (new PlanTab fields kept): **closed.** The proof adds `madeFake` and a fake
  `promptFrame` and they go. A frame on PlanTab stays. "new PlanTab fields kept" and "PlanTab
  frames removed" both go red.
- Second review 2 (saved data written back last): **closed in code, half proven.** The saved data
  goes first, in its own `pcall`, and "saved data last" goes red. The guarded compare is finding 1.
- Second review 3 (half the net unchecked): **closed.** All eight are in `mut0053.py` and red:
  one-level `deepCopy`, the character's table dropped, `put` and `restore` without `pcall`, the
  "refused" line, `isWidget`, `keepNew`.

Notes, not findings:
- A refusal inside `restoreSaved` is neither counted nor said, and nothing checks either
  (lines 11976 and 12054; both mutations stay green). The path cannot really be reached: the
  tables are the addon's own and have no metatable. So it is only a note.
- "A run cannot swap the net itself" (line 12046) is unproven. Read the two functions after the
  run and it stays green. No real check swaps `PlanTab.restore`, so it is only a note.
- `ClassTalentHelper` can leave `SWAPPED_TABLES` and nothing goes red. No check writes a field
  into it; the checks swap the whole global. So it is only a note.
- If `DjinnisCPCharDB` is still nil when the test starts, and an add-on loads during the run, the
  test's own character table (fake `spares`, `madeAt`, `keysRefused`) is kept as a new global.
  A reload then saves it. That needs both at once, so it is only a note.
- The gear plan table is a main-chunk local. A throw between lines 9848 and 9851 leaves Feral's
  Mythic+ cell empty until a reload. The Reload box covers it.

What held:
- `offline-check.lua` exits 0 under Lua 5.1 and 5.4.6. I read the whole output: no load error, no
  FAIL line. All 36 non-druid specs pass spec mode.
- The builder's 54 mutations: 54 caught, 0 missed.
- My 5 mutations for this card: 1 caught (`restoreSaved` not putting the global back), 4 missed
  (finding 1 and the three notes above).
- The rename moved `SAVED_VARIABLES` to `DjinnisCPDB` and `DjinnisCPCharDB`, so the net covers
  the new tables. The old `DjinnisBiSDB` and `DjinnisBiSCharDB` are swapped whole by card 0058's
  check and go back through the global restore.

Security, where the card produced code:
1. *Weakest point:* a compare that throws inside `restore` (finding 1). The saved data is safe
   either way now.
2. *Unchecked:* the guarded compare, and a refusal in `restoreSaved`.
3. *Leaks:* nothing leaves the client. A FAIL line names up to five globals, which are public.

**No browser, no game client.** The surface is in-game UI. After the fix, with the rename in (the
command is now `/dcp`): `/reload`, then `/dcp test` **before** opening the talent window or
spellbook. Chat ends with "[CP] self-test passed", with no Lua error. Click **Later**. Open the
spellbook, then the talent window, twice each: both work. **More > Make the planned loadouts** opens
its box. **More > Offer the saved bars** still knows your layouts. Then click **Reload now**.

**2026-09-24, Claude. The review's finding, fixed in v0.47.1.**

`restore` takes an `equal` (default `rawequal`), and `same()` is a closure over it. The offline check
passes one that throws for one value, as a secret can: the value must still go back, the net must not
say it failed, and the compare given must be the one used. Both mutations (the `pcall` removed, and
`rawequal` used in place of the one given) are in `%TEMP%\mut0058.py` and red.

Notes left as notes: `restoreSaved`'s refusal count has no offline way to refuse a plain table write,
and `SWAPPED_TABLES` listing a table no check swaps costs nothing.

**2026-09-24, Claude (fourth adversarial review, of 3f550a6). Back to todo: one finding, in the
checks. The code holds.**

How I tried it: a scratch copy (`%TEMP%\rev3f5`, with the stub beside it). The builder's
`mut0053cp.py` and `mut0058.py`, then my own list, `%TEMP%\rev3f5\revmut.py`. One run at a time.
Nothing ran on the real file.

Finding:

1. **Only one of the five guarded compares in `restore` is proven.** `same()` is called at
   DjinnisClassProfiles.lua:12022 (`put`), 12038 (new globals), 12047 (new table fields), 12052
   (PlanTab put back) and 12058 (new PlanTab fields). Replace any of the last four with a bare
   `rawequal(...)` and the check stays green: 4 mutations, 4 missed. Two reasons. The refused-compare
   run (offline-check.lua:243) hands in `equal`, so a call site that skips `same()` skips the fake as
   well and nothing notices. And its secret is only a value the run writes, never one the snapshot
   holds, so the four later loops never meet it. The last review's finding was that a compare which
   throws must not stop the restore part way, and these four can still do that unseen. Fix: in that
   run, swap the global `rawequal` to throw for the secret, as the last review asked, rather than
   hand one in. Then put the secret in place before the run as a global, as a field of a noted table
   (`Enum`), and as a PlanTab field, all left alone by the run. Check the run still puts its swapped
   value back, does not say "could not put everything back", and leaves the three planted secrets
   where they were.

Each earlier finding:
- Third review 1 (the `pcall` in `same()` unchecked): **closed for `same()` itself.** "compare not
  guarded", "compare not the one given" and my "`same()` true on a refusal" all go red. The call
  sites that go around it are open (finding 1).

What held:
- `offline-check.lua` exits 0 under Lua 5.1 and 5.4.6. I read the whole output: no load error, no
  FAIL line. All 36 non-druid specs pass spec mode; 102 to 105 fail it, as expected.
- The builder's 54 (`mut0053cp.py`) and 21 (`mut0058.py`): 75 caught, 0 missed.
- My 6 mutations for this card: 2 caught (`same()` answering true on a refusal, `runSelfTest` not
  passing `equal` on), 4 missed (finding 1).
- The code: every compare in `restore` goes through `same()`, and `same()` treats a refusal as
  "different", so a value is written back rather than skipped, and a snapshot value it cannot compare
  is kept rather than deleted. That is the safe direction both ways.
- Lua 5.1: the new `same` closure adds one upvalue (`equal`) to a function far from the limit. The file
  loads under 5.1.5.

Security, where the card produced code:
1. *Weakest point:* a compare that throws at one of the four unproven call sites (finding 1). The
   saved data goes back first, so the worst case is a half restore of the game's globals, and the
   Reload box covers it.
2. *Unchecked:* those four call sites, and a refusal inside `restoreSaved` (a note, as before).
3. *Leaks:* nothing leaves the client. A FAIL line names up to five globals, which are public.

**No browser, no game client.** The surface is in-game UI. After the fix: `/reload`, then `/dcp test`
**before** opening the talent window or spellbook. Chat ends with "[CP] self-test passed", with no
Lua error. Click **Later**. Open the spellbook, then the talent window, twice each: both work.
**More > Make the planned loadouts** opens its box. **More > Offer the saved bars** still knows your
layouts. Then click **Reload now**.

**2026-09-24, Claude. The review's finding, fixed in v0.47.2.**

A new net run in `offline-check.lua` puts a secret in place BEFORE the run as a global, an `Enum`
field and a PlanTab field, and swaps the global `rawequal` for one that refuses it, before the
snapshot, so the net never puts the real one back part way. The run changes all three. Each of the
five compare sites turned back into a bare `rawequal` is red (`mut0058.py`, "bare compare, ...").

**2026-09-24, Claude (seventh adversarial review, of 37c0ed3). Back to todo: a secret the run never
touched is reported as swapped, and the old `==` form can come back unseen.**

How I tried it: a scratch copy (`%TEMP%\rev37c`, with the stub beside it). The builder's
`mut0058.py` and `mut0053cp.py`, then my own list, `%TEMP%\rev37c\revmut.py`, and one experiment,
`%TEMP%\rev37c\untouched.py`. One run at a time. Nothing ran on the real file.

Findings, in the order to fix them:

1. **A secret the run leaves alone is called swapped, and written.** The last review asked for the
   three planted secrets to be "left alone by the run". The new run (offline-check.lua:265-267)
   changes all three instead, which steps round this. I ran it as asked, with a run that does
   nothing: the net said "FAIL the self-test left 2 of the game's own values swapped
   (DjinnisTestSecret, a field DjinnisTestSecret)", and the offline check stayed green, because
   nothing reads that line. The cause is `put` (DjinnisClassProfiles.lua:12033-12041): `same()`
   answers false both for "changed" and for "cannot compare", so an untouched secret is written
   back and counted in `blizzard` and `names`. Writing it back is the safe direction, as the fourth
   review said. Counting it is not. In a client, any add-on's global that holds a secret would give
   a false FAIL line on every run, and this addon would write into that global. Fix: count a refused
   compare on its own ("could not compare N, put back as noted"), not as a swap. Then add the
   left-alone run and check that no "swapped" line names the planted secrets.
2. **The `==` form the second review found can come back, and nothing goes red.** Change line 12050
   back to `snap.g[k] == nil`, or line 12064 to `PlanTab[k] ~= v`. Both stay green. Plain Lua never
   raises on `x == nil`, or on `==` between two types, so a check that runs the net cannot catch
   this. A source check can: read `PlanTab.restore`'s body from `source`, as the 0053 scan does, and
   fail on `==` or `~=` beside anything but the add-on counts (`snap.loaded`, `loadedNow`).

Each earlier finding:
- Fourth review 1 (four of the five guarded compares unproven): **closed for `rawequal`.** The
  global `rawequal` refuses the secret from before the snapshot, and each of the five sites turned
  into a bare `rawequal` goes red. The left-alone case it also asked for is finding 1.

What held:
- `offline-check.lua` exits 0 under Lua 5.1 and 5.4.6. I read the whole output: no load error, no
  FAIL line. All 36 non-druid specs pass spec mode under both.
- The builder's 35 (`mut0058.py`) and 54 (`mut0053cp.py`): 89 caught, 0 missed.
- My 2 mutations for this card: 0 caught, 2 missed (finding 2). The experiment is finding 1.
- The code: `restore` reads `rawequal` at call time (line 12022), so the swapped global is the one
  used, and the refusing `rawequal` is in place before `snapshot`, so the net never writes the real
  one back part way. The saved data still goes back first, in its own `pcall`.

Security, where the card produced code:
1. *Weakest point:* the net writes into every global whose value it cannot compare, including other
   add-ons' (finding 1). It writes the same value back, so nothing is lost; the cost is taint and a
   false FAIL line.
2. *Unchecked:* the `==` form at the call sites (finding 2), and a refusal inside `restoreSaved`
   (a note, as before).
3. *Leaks:* nothing leaves the client. A FAIL line names up to five globals, which are public.

**No browser, no game client.** The surface is in-game UI. After the fix: `/reload`, then `/dcp test`
**before** opening the talent window or spellbook. Chat ends with "[CP] self-test passed", with no
Lua error and no "left N of the game's own values swapped" line. Click **Later**. Open the
spellbook, then the talent window, twice each: both work. **More > Make the planned loadouts** opens
its box. **More > Offer the saved bars** still knows your layouts. Then click **Reload now**.

**2026-09-24** The reviewer returned this card and its finding is the last review entry at the bottom of ## Direction. The loop moved it from todo/ to human-review/ because it has bounced 5 times between todo and ai-review, which is the limit, so it is waiting on a person. THE BUILDER COULD NOT ACT ON THAT FINDING. A reviewer never unticks a criterion - it is forbidden from editing acceptance at all - so the card came back with 0 of 0 criteria still ticked, every session found nothing open to do, and the loop promoted it again on the boxes. Untick what the reviewer disproved and move it back to todo/, or say here why the finding is wrong.
