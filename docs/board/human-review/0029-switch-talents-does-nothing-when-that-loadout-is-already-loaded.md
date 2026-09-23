---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0011, 0013, 0014
---
# 0029 "Switch talents" does nothing when that loadout is already loaded

## Why

Rob, 2026-09-22, on zone-in to Altar of Fangs: the wrong-setup popup said
`Talents  planned WS M+, now WS M+ (edited)` and offered **Switch talents**. Clicking it did
nothing at all.

It could not do anything. The popup only appears because the build differs from the plan's string;
the loadout NAME is already the right one and already selected. `PlanTab.loadTalents` asked
Blizzard's helper for that same name, the helper called `LoadConfig` on the config already loaded,
the game answered `NoChangesNecessary`, and nothing moved
(`Blizzard_ClassTalentsFrame.lua:1084` `LoadConfigInternal`). Blizzard's Apply writes a hand edit
INTO the selected loadout, so the saved copy carries the drift too: there is no build to load back.

The button was a dead click with no message. That is the fault.

**Which drift this is, is still open.** Either the saved "WS M+" really has moved away from the
simmed build, or the plan's baked string and this client's export differ past the header and
`(edited)` is a false mark. Card `0014` item 4 asked the same question. `/djbis talents` now
answers it.

## Links

- `0011` built the Talents button; this is a guard inside its `PlanTab.loadTalents`, so the Plan
  tab's own Talents button and the loadout list beside Blizzard's window get it too.
- `0013` draws the popup; `0014` owns the `(edited)` compare.

## Not this card

- Applying the planned build from the addon. `C_ClassTalents.LoadConfig` / `CommitConfig` from
  insecure code is the known route to frozen action bars (`0002`), and importing by name would
  make a second loadout with the same name.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the asked-for loadout is the one already selected and its build moved, THE ADDON SHALL not ask the helper, and SHALL open the talent window and point at Reset to plan in chat. WHEN its build did not move, THE ADDON SHALL only say it is on already. proves: `talents button says so when that loadout is loaded already`, `..., unmoved it is on already`
- [x] WHEN the popup's loadout is the row's own name with the wrong build, THE ADDON SHALL label the button "Fix talents", not "Switch talents". proves: `the row's own loadout with the wrong build is not a switch, the button says Fix talents`
- [x] WHEN that is the case, THE ADDON SHALL say on the line that the build is not the one simmed, instead of "planned X, now X (edited)". proves: `the row's own loadout with the wrong build is not a switch, the line says the build is not the one simmed`
- [x] WHEN Rob types `/djbis talents`, THE ADDON SHALL print the build in play and every planned build of the spec, each marked same, different or cannot compare. proves: run in a client 2026-09-22, three lines, both cells marked `different`
<!-- AC:END -->

## Tasks

- [x] `PlanTab.loadTalents` returns `"same"` on the already-selected loadout.
- [x] `PlanTab.wrongHere` marks `wrong.drifted`; `PlanTab.setupPopup` reads it for the line and
  the button label.
- [x] `PlanTab.sayTalents` and `/djbis talents`.
- [x] Offline checks under the names above. The "reads only" check now expects
  `GetStarterBuildActive` and `GetLastSelectedSavedConfigID` too; both are reads.

## What I need from you

1. `/reload` (the game folder holds v0.38.1). On Feral, select `Dungeon`, move one talent and
   click Apply, then walk into a dungeon. The talents line should read `Dungeon is loaded, but its
   build is not the one simmed` and the button should say **Fix talents**.
2. Click it. The talent window should open and one gold chat line should point at
   `/djbis loadouts` and Reset to plan. Nothing else should happen.
2a. Put the talent back. Click the Plan tab's **Talents** button on that loadout. Chat should say
   it is on already, and nothing about Reset.
3. ~~`/djbis talents`~~ **Done, 2026-09-22.** Answered card `0014` item 4: the saved loadout has
   really drifted. Same 25-character header and same first 58 characters as the plan's `WS M+`,
   then divergent, 118 characters against 117. The mark is true and the baked string is fine.
   Rob's own fix is to delete the saved `WS M+` and import the plan's string under that name.
4. With a genuinely wrong loadout loaded (say `Raid: Nek'Zali` in a key), the popup should still
   say **Switch talents** and that button should still work.

## Comments

- 2026-09-22 Claude: built and deployed at v0.24.2. Not seen in a client.
- 2026-09-23 Claude, adversarial review against v0.37.1 (the code has moved on through 0031 and
  0040). **Bounced to todo, three findings.**

  **Attacked.** Every criterion against the current `DjinnisBiS.lua`. Both harnesses (Lua 5.1 and the
  newer one) print "no FAIL lines". Ten mutations on a temp copy, never the real file:
  - no "same" guard in `loadTalents` (3946): 6 red.
  - `drifted` never set (5031): 3 red.
  - `drifted` always set: 3 red.
  - button always "Switch talents" (5271): 1 red.
  - old "planned X, now X" line kept (5226): 1 red.
  - window not opened on "same" (3947): 1 red.
  - helper still asked on "same": 1 red.
  - no chat line on "same" (3950): 2 red.
  - `/djbis talents` verdict swapped (4648): 0 red. That is expected, because criterion 4 is a client run and says so.
  - `drifted` also needs `edited`: 0 red. That is an equivalent mutation, not a gap. `loadoutState` only answers mismatch for the same name when it is edited.

  **What held.** The API claim is right. `ClassTalentHelper.SwitchToLoadoutByName` fires an event
  that runs `LoadConfigByName`. `LoadConfigInternal` answers `NoChangesNecessary` for the loaded config
  (`Blizzard_ClassTalentsFrame.lua:1084` and `:1110`). The popup guard is sound. Every Feral and
  Balance row's loadout is a `PlanTab.BUILDS` name, so the Reset to plan route the chat line points
  at does cover every row the popup can name. Every name compared has passed `canRead` first. There
  is no new event registration.

  **Broke 1: the chat line claims drift that is not there.** `PlanTab.loadTalents` (3946) compares
  the name only. It never checks `edited`. The popup only calls it after a mismatch, but two other
  callers do not. The Plan tab's Talents button (4818) is always shown. The double-click in the list
  beside the talent window (6161) works on the ticked, active row too. Click either one on the
  loadout already loaded, with its build unchanged, and chat says `"X" is loaded already, but its
  build is not the planned one`. That is false. Before this card the same click did nothing. Fix:
  read `local active, edited = PlanTab.activeLoadoutName(playerSpec())`. Give the drift line only
  when `edited` is true. Otherwise say it is on already, as `wearSpare` does (6504). Add a check that
  an unedited active loadout gets no drift line. A second path goes wrong the same way.
  `activeLoadoutName` maps the spare back to its build name (4626). If the spare wears "X" and a real
  "X" was saved later by `/djbis loadouts`, then asking for "X" returns "same". The helper is never
  asked, and it could have switched to the saved one.

  **Broke 2: criterion 1 no longer says what the code does.** It promises a line saying the build
  "must be saved over it". Card 0031 changed that line, and the test (8941) now looks for "Reset to
  plan". The tick sits on a sentence the test no longer proves. Reword the criterion to the
  current behaviour.

  **Broke 3: "What I need from you" is stale.**
  - Step 1 says the game holds v0.24.2. It holds v0.37.1.
  - Step 1 expects `WS M+` on the Feral dungeon row. That row's loadout is now `Dungeon` (596), and
    `WS M+` is on the retired list that `/djbis tidy yes` deletes (6391).
  - Step 2 expects a line about importing and saving over. The line now says to pick another
    loadout and run `/djbis loadouts`.
  - Step 3's fix (delete `WS M+` and import under that name) is now what Reset to plan does.
  - Step 4 uses `DotC Raid ST *`, which is also retired and may have been deleted.

  Rewrite the steps for `Dungeon` or a `Raid:` name at the deployed version. Add one step: click
  the Plan tab's Talents button on an unedited active loadout and confirm no drift claim.

  **Security.**
  1. Weakest point: the name-only compare in `loadTalents`. Any caller can make it tell the player
     something untrue (finding 1). It cannot make the addon write anything, because the "same"
     branch only opens a window and prints.
  2. Unchecked: nothing comes from outside. The names printed come from the plan data or a
     `canRead` loadout name. `/djbis talents` takes no argument. `GenerateImportString` is wrapped in
     `pcall` and its result passes `canRead`.
  3. Leaks: `/djbis talents` prints the build string to the player's own chat frame only. Nothing is
     sent, and there is no stack trace.

  **Not checked in a client.** No agent can run the game. A person still owes the rewritten steps
  above in a dungeon, including the Fix talents click and a genuine Switch talents.

- 2026-09-23 Claude, builder, v0.38.0. All three findings fixed.
  1. `loadTalents` reads `edited` from `activeLoadoutName(playerSpec())`. An unmoved loadout answers
     `"on"` and says it is on already. The drift line needs `edited`. It also needs the selected
     config to be that name's own loadout: when the spare wears the build and the build has its own
     loadout, the helper switches to it. New checks: `..., unmoved it is on already`, `..., and says
     nothing of Reset`, `..., the build's own loadout is switched to past the spare`. Mutations: no
     unmoved guard 3 red, `selectedIt` always true 1 red.
  2. Criterion 1 reworded to the current behaviour.
  3. Steps rewritten for `Dungeon` at v0.38.0, with the added Talents button step (2a).
  Also: the comment above `loadTalents` no longer says the file writes nothing to `C_ClassTalents`.

- 2026-09-23 Claude, second adversarial review of b5530b3 (v0.38.0). **Bounced to todo, one
  finding.** The three first-review findings are fixed in the code and on the card.

  **Attacked.** Both harnesses print "no FAIL lines". Mutations on a temp copy, same under both:
  - no unmoved guard (`DjinnisBiS.lua:3953`): 4 red.
  - `selectedIt` always true (3952): 1 red.
  - the unmoved branch opens the window: 1 red.
  - `activeLoadoutName()` called without the spec (3951): **0 red**.

  **Broke: the drift line can vanish and every check stays green.** `edited` comes from
  `PlanTab.activeLoadoutName(playerSpec())` at 3951. Without the spec, `buildFor(nil, name)` finds
  nothing, `edited` is never true, and the popup's Fix talents says "is on already" for a build that
  moved. That is criterion 1's main case going wrong. The checks cannot see it: they replace
  `activeLoadoutName` with a stub that ignores its argument (9063, and again before 9073). Fix:
  make the stub answer `edited` only when it is passed the harness's spec, for example
  `function(spec) return "Raid: Twin Fangs", spec == "Feral" end`, or check the argument it got.

  **What held.**
  - An unmoved loadout says "is on already" and opens nothing. A moved one opens the window and
    points at Reset to plan.
  - With the spare wearing a build that also has its own loadout, `selectedIt` is false and the
    helper switches to the build's own loadout.
  - Criterion 1's wording and the What I need from you steps match v0.38.0.

  **Noted, not a finding.** Two loadouts with the same name as the build: `saved[name]` holds one
  id (`savedLoadoutNames`, 3890). If the other one is selected, `selectedIt` is false, the helper
  is asked, and Blizzard loads the first one by that name (`ClassTalentHelper.lua`,
  "Loads the first one found"). That can be the dead click this card fixed. `resetDrifted`
  already refuses a name used twice, so this needs a player to make that duplicate.

  **Security.**
  1. Weakest point: the `edited` answer. If it is wrong, the player is told a moved build is fine.
     No write follows: "on" only prints.
  2. Unchecked: nothing comes from outside. Names are from plan data or a loadout name that passed
     `canRead`.
  3. Leaks: nothing leaves the client. One chat line to the player only.

  **Not checked in a client.** No agent can run the game. The What I need from you steps (1, 2, 2a
  and 4) still stand once the check above is fixed.
- 2026-09-23 Claude, builder, v0.38.1. Fixed: the checks' stubs now answer `edited` from the spec
  argument, so dropping `playerSpec()` from the call goes red (5 red).

**2026-09-23** Third adversarial review of e1b2ecb (v0.38.1). **Clean. Moved to human-review for
the in-game steps.**

**Attacked.** Both harnesses print "no FAIL lines". Mutations on a temp copy, same count under
Lua 5.1 and the newer one:
- `activeLoadoutName()` without the spec (`DjinnisBiS.lua:3952`), the second review's finding: 5 red.
- `selectedIt` always true (3953): 1 red.
- no unmoved guard (3954): 3 red.
- `loadTalents` no longer clears a spare wish (3935, card 0040's change in this function): 3 red.

**What held.**
- The second review's finding is fixed. Both stubs now answer `edited` from the argument they get,
  so the drift line cannot vanish silently.
- An unmoved loadout says "is on already" and opens nothing. A moved one opens the window and
  points at Reset to plan. With the spare wearing a build that also has its own loadout, the
  helper is asked for the build's own loadout.
- Every criterion names a check that exists and ran. Criterion 4 is a client run and says so.
- The game folder holds v0.38.1, byte for byte the same file as the repository.

**Still a note, not a finding.** Two loadouts with the build's name: `savedLoadoutNames` keeps one
id, and Blizzard's helper loads the first by name. It needs the player to make the duplicate.

**Security.**
1. Weakest point: the `edited` answer. If it is wrong the player is told a moved build is fine.
   No write follows, because "on" only prints.
2. Unchecked: nothing comes from outside. Names come from plan data or a loadout name that passed
   `canRead`.
3. Leaks: nothing leaves the client. One chat line to the player only.

**Not checked in a client.** No agent can run the game. A person owes What I need from you steps
1, 2, 2a and 4.