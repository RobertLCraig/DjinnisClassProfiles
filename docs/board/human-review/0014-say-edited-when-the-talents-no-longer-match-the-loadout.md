---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0007
---
# 0014 Say "(edited)" when the talents no longer match the loadout

## Why

The Plan tab reads the loadout by its name. If Rob loads "DotC Raid ST *" and then moves one point
by hand, the tab still says he is on the planned loadout. That is the ceiling written at
`activeLoadoutName`.

EnhanceQoL compares talent strings instead of names:
`C_Traits.GenerateImportString(C_ClassTalents.GetActiveConfigID())` against the stored string
(`TalentReminder.lua`, read 2026-09-22). `GenerateImportString` is in the 12.1 docs
(`SharedTraitsDocumentation.lua`).

What it costs now: a hand edit can drop the build 20% (the drifted string in the 2026-09-21 sims),
and the tab says all is well.

## Links

- Needs `0007`: the tab that names the loadout.
- `0013` and `0017` use the same test.

## Not this card

- Fixing the edit. `0011`'s button reloads the loadout.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the active talents differ from the planned loadout's talent string, THE ADDON SHALL show the loadout name with "(edited)" after it. proves: `edited talents are marked`
- [x] WHEN they match, THE ADDON SHALL show the name with nothing after it. proves: `matching talents are not marked`
- [x] THE ADDON SHALL read the talent string only out of combat. proves: `talent string read out of combat only`
- [x] WHEN the picked boss's plan cell has no `talents` string, THE ADDON SHALL mark nothing. proves: `a cell without talents marks nothing`
<!-- AC:END -->

## Tasks

- [x] The planned string is the plan cell's own `talents` (`GEAR_PLAN`, baked by
  `update-gear-plan.ps1` from the report's export), never the saved loadout: Blizzard's talent
  frame writes a hand edit INTO the saved loadout on Apply (`Blizzard_ClassTalentsFrame.lua`
  1134 to 1155, `SaveConfig(selectedConfig)`), so a compare against it can never see the edit
  (Rob, 2026-09-22, Option A). `PlanTab.plannedTalents(spec, scenario)` hands it over.
- [x] A string from another game build says nothing: the 152-bit header (version, spec, tree
  hash) must agree before the node bits are compared, else the answer is nil, never "edited".
  Whether a clean load ever produces a differing header is item 4 below.
- [x] Redraw on `TRAIT_CONFIG_UPDATED`.
- [x] Offline checks under the names above.

## What I need from you

1. Load "DotC Raid ST *" through the talent window, open `/bis`, Plan tab, pick Entombed
   Sentinels. Line 1 should read `your loadout now: DotC Raid ST *` with nothing after it, and
   the row green.
2. Move one talent point by hand and Apply. Line 1 should now say `DotC Raid ST * (edited)`, the
   picked boss row red, and the "Click Talents to load ..." line present, without reopening the
   window (that is the `TRAIT_CONFIG_UPDATED` redraw). This is the case the saved-loadout
   compare could not catch.
3. Load the loadout clean again. The mark should go.
4. If step 1 shows "(edited)" straight after a clean load, the plan's baked string and the
   client's export differ past the header and the string in `GEAR_PLAN` needs re-baking from
   this client; if it shows nothing after an edit, the headers differ and the guard is hiding
   it. Say which. Blizzard's own UI never calls `GenerateImportString`, so there was nothing in
   `wow-ui-source` to read it off.
5. Pick Nek'zali (a 1 target boss on "WS Raid Most Bosses", which the `st` cell was not simmed
   on) while on that loadout, clean. The row should be green with no mark: the cell's string is
   not that loadout's plan and only the name is judged. This is the case Option A does not
   cover until card `0028` gives every loadout its own cell.
6. Hit a dummy with the tab open: no error, and the mark holds whatever it said before the pull.
   Then, still in combat, click Nek'zali in the boss list: its row must NOT go red and line 1
   must not say "(edited)", because that cell has no planned build for the loadout in play and
   the held reading is per cell, not one for the tab (the 0014 review's fix).
7. The `TRAIT_CONFIG_UPDATED` registration itself: no "could not register" line in chat at login.
   Nothing offline can prove an event is registered.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" in a SecondBrain session. Ideation only.
- 2026-09-22 Claude: built. `PlanTab.activeLoadoutName()` returns a second value, edited, from
  the new `PlanTab.talentsEdited(savedConfigID)`: `C_Traits.GenerateImportString` on
  `C_ClassTalents.GetActiveConfigID()` against the same on the last selected saved config, both
  pcalled, both passed through `canRead` (checked against `SharedTraitsDocumentation.lua` and
  `ClassTalentsDocumentation.lua`; the trait functions are `AllowedWhenUntainted`, none is
  secret-restricted). The compare is `PlanTab.talentStringsDiffer`, a pure function, whole string.
  In combat the reader returns the last reading it took rather than nothing, per DECISIONS.md.
  `PlanTab.loadoutState` takes the flag and answers mismatch on it, so the picked boss goes red
  and the existing "Open talents and pick" line is the fix, which is what 0011's button does.
  Line 1 draws "(edited)" after the name. `TRAIT_CONFIG_UPDATED` is on the bag-mark watcher, the
  one that already redraws the tab and exists from login. No new top-level local (177 of 200).
  Both `lua offline-check.lua` and Lua 5.1 exit 0. Mutation-tested four ways in a temp copy: the
  edited branch removed from `loadoutState` (3 red), the combat guard removed from
  `talentsEdited` (3 red), the "(edited)" text removed from the drawn line (1 red), the compare
  forced to false (3 red). Left out: the planned string baked into `GEAR_PLAN` is not used, the
  saved loadout is, as the card prefers; a planned loadout that is not the selected one is
  already the name mismatch and needs no string. The header question is task 2 and item 4 above,
  and it is a look in the game, not something this checkout can answer. Not seen in a client.
- 2026-09-22 Claude (review, bounced to todo): attacked the three criteria, the code at
  `talentsEdited`, `talentStringsDiffer`, `loadoutState`, `activeLoadoutName`, `lines` and the
  bag-mark watcher, and the three APIs against `SharedTraitsDocumentation.lua` and
  `ClassTalentsDocumentation.lua` (all present, none secret-restricted, `TRAIT_CONFIG_UPDATED`
  carries a configID and is not deprecated). Both offline checks exit 0, 177 top-level locals. Nine
  mutations in a temp copy: seven went red (the edited branch, the combat guard, the "(edited)"
  text, the compare forced false, the last reading not kept, the saved id read from the active id,
  the empty-string guard). Two survived and are gaps, not faults: dropping `TRAIT_CONFIG_UPDATED`
  from the watcher's list is caught by nothing offline (registration is only provable in the game,
  same as 0011's two events), and the `canRead` guard in `talentStringsDiffer` cannot be exercised
  because the harness has neither `canaccessvalue` nor `issecretvalue`, so `canRead` is captured as
  always true. Neither is the reason for the bounce.

  **What broke: the thing the compare reads is overwritten by the edit it is meant to catch.** The
  code compares the active config's string against the LAST SELECTED SAVED config's. Blizzard's
  own talent frame writes a hand edit into that loadout when Apply is clicked:
  `Blizzard_PlayerSpells/ClassTalents/Blizzard_ClassTalentsFrame.lua` 1134 to 1155, `ApplyConfig`
  calls `CommitConfig(self.LoadSystem:GetSelectionID())`, and the docs name that argument
  `savedConfigID`; with no tree change pending it calls `C_ClassTalents.SaveConfig(selectedConfig)`
  under the comment "Selected config is a loadout, save to that config". So after step 2 of the
  in-game list (move a point, apply) the saved string equals the active one and "(edited)" cannot
  show. The only state where they differ is a staged edit before Apply, which does nothing to the
  fight. Criterion 1 is not met for the case the card's Why describes, so it is unticked. This
  could not be settled by the offline checks because they stub both strings.

  The fix is small and is Rob's call, which is why this is a bounce and not an edit: compare the
  active string against the plan's own `talents` string for the picked boss's cell
  (`GEAR_PLAN`, lines 378 and 400) instead of the saved loadout's. `update-gear-plan.ps1` 171 to
  173 takes that string from the report's `rawString`, the export Rob pasted in from the game, so
  its header is the game's; both plan strings share the same 31-character header. That is what
  EnhanceQoL does (its own stored string, not the loadout), and it is the "string baked into the
  plan" option task 1 turned down. It reads: not the simmed build. Task 1's "prefer the saved
  loadout" should be flipped to say why. `activeLoadoutName` then needs no `talentsEdited`
  argument, and the three `talentsEdited` checks want the plan string as their stub. Item 4 of the
  in-game list still stands, header included.

  Security, for the record: weakest point is a redraw per `TRAIT_CONFIG_UPDATED`, two cheap
  string reads, no loop; unchecked path none, both reads are pcalled and the event handler takes
  no payload; leaks nothing, the strings never leave the client and never print.
- 2026-09-22 Claude (rebuilt on Option A): the compare now reads the plan cell's own `talents`
  string. New `PlanTab.plannedTalents(spec, scenario)` returns the cell's string and, second, the
  loadout it was simmed under, or nil when the cell has none; `0023` is to call it next, name and
  signature kept. `PlanTab.talentsEdited(planned)` takes that string and reads only the active
  config (one `GenerateImportString`, not two); `PlanTab.activeLoadoutName(spec, scenario)` looks
  the cell up and passes it through, and its three callers (`lines`, `checkSetup`, the sidebar)
  hand over the picked boss's scenario, `checkSetup`'s row's, and `planScenario` for the sidebar.
  `talentStringsDiffer` answers nil when the first 25 characters (150 of the header's 152 bits)
  disagree, so another build's string is never "edited". One guard the decision did not name and
  the data forces: four `st` boss rows use "WS Raid Most Bosses" or "WS Raid Coiled Altar", and
  the `st` cell was simmed on "DotC Raid ST *", so without it a clean load of "WS Raid Most
  Bosses" on Nek'zali read as edited and went red. The cell's string judges only when the active
  loadout is the one it was simmed under; otherwise the row is judged by name alone, as before
  this card. `0028` removes the gap by giving every loadout its cell. Item 5 in-game is that case.
  No new top-level local (177). Both `lua offline-check.lua` and Lua 5.1 exit 0. Four mutations in
  a temp copy, all red: `plannedTalents` forced nil (3), the header guard removed (1), the
  loadout-name guard removed (1), the compare forced false (3). Not seen in a client; the
  `TRAIT_CONFIG_UPDATED` registration is still provable only there.
- 2026-09-22 Claude (review, to human-review): attacked the four criteria and the code at
  `plannedTalents`, `talentStringsDiffer`, `talentsEdited`, `activeLoadoutName` and its three
  callers (`lines`, `checkSetup` through `wrongHere`, the sidebar through `sidebarRows`), plus
  `loadoutState` and the bag-mark watcher. APIs checked against `Blizzard_APIDocumentationGenerated`:
  `GenerateImportString`, `GetConfigInfo`, `GetLastSelectedSavedConfigID` are `AllowedWhenUntainted`
  with no `SecretWhen` flag; `GetActiveConfigID` and `GetStarterBuildActive` are unflagged;
  `TRAIT_CONFIG_UPDATED` and `CONFIG_COMMIT_FAILED` are in `SharedTraitsDocumentation.lua` with a
  `configID` payload the handler ignores. None is under `Blizzard_Deprecated*`. The header claim
  verified against `Blizzard_ClassTalentImportExport.lua` (8 + 16 + 128 = 152 bits) and
  `ExportUtil.lua` (`BitsPerChar = 6`): 25 chars is 150 bits, so the guard misses the hash's last two
  bits, which is the documented ceiling and not a fault. The watcher attaches `SetScript` first,
  registers one event at a time and checks `IsEventRegistered`, per DECISIONS.md.

  **What broke, fixed here:** `talentsEdited` held ONE last reading for the whole tab. In combat it
  returned that reading for any caller, including `talentsEdited(nil)`, so a cell with no planned
  build (criterion 4: Nek'zali on "WS Raid Most Bosses" while the last read was the st cell on
  DotC) drew "(edited)" and went red mid-pull, and the sidebar and the Plan tab, which ask about
  different cells, could hand each other's answer back. Fix: `if not planned then return nil end`
  first, and the held reading is `PlanTab.lastEdited[planned]`, one per plan string. Two checks
  added under the existing names (`a cell without talents marks nothing, in combat too` and
  `talent string read out of combat only, another cell's string is not the held one`); both were
  red on the unfixed code and are green now. Signatures of `plannedTalents` and
  `talentStringsDiffer` untouched for 0023. No new top-level local (177).

  Mutations in a temp copy against the fixed file: edited branch removed from `loadoutState` (4
  red), header guard removed (1), loadout-name guard removed (1), compare forced false (8), held
  reading not kept (1), planned-nil guard removed (the harness errors out with "table index is
  nil", exit 1). Both `lua offline-check.lua` and Lua 5.1 exit 0.

  Not for this card, noted: `PlanTab.lines` still calls `savedLoadoutString` for 0023's last-pull
  compare, which is the saved-loadout read Option A ruled out; 0023 is being rebuilt on
  `plannedTalents` in parallel and owns that line.

  Security: weakest point is one `GenerateImportString` per redraw per `TRAIT_CONFIG_UPDATED`,
  which fires once per commit, not per node; the read is pcalled and bounded. Unchecked path:
  none, the event payload is ignored, and the plan string is a literal in this file, so the
  table key is never a game value. Leaks: nothing, the strings never print and never leave the
  client. Not seen in a client: looks 1 to 7 above are Rob's.

- 2026-09-22 Claude, item 4 answered in a client. `/djbis talents` on Feral in Altar of Fangs:
  the build in play and the plan's `WS M+` share the same 25-character header and the first 58
  characters, then diverge, and are 118 and 117 characters long. **The "(edited)" mark is true and
  the compare is sound**: the saved loadout has drifted from the simmed build, the headers agree,
  and no re-baking of the baked string is needed. Card `0029` carries the button that was offering
  to fix it by loading the same drifted loadout back.
