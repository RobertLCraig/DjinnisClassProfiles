---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0008
---
# 0011 A Talents button that loads the loadout through Blizzard's own command

## Why

The Talents button on the Plan tab (`0008`) opens the talent window and loads nothing. Rob then
finds the loadout by name in a dropdown. Between bosses that is the slow part, and with a loadout
per boss (`0007`) he does it up to eight times a raid night.

It loads nothing on purpose. `C_ClassTalents.LoadConfig` and `CommitConfig` from addon code is the
known route to action bars that freeze in combat (`0002`, `0008` "Not this card"). AskMrRobot does
change talents from addon code, and its own comments call its route "janky AF" and say the direct
calls leave "the UI in a broken state" (`Gear.lua`, `setTalents`, v17, read 2026-09-22).

A third route exists. Blizzard's `Blizzard_ChatFrame\Shared\ClassTalentHelper.lua` registers a slash
command, `SlashCmdList["TALENT_LOADOUT_BY_NAME"]`, which calls
`C_ClassTalents.SwitchToLoadoutByName(name)`. The generated docs mark that function
`HasRestrictions = true` and `SecretArguments = "AllowedWhenUntainted"`. A secure macro button whose
macro text is that slash command runs on Rob's own click, the same as if he had typed it. No addon
code touches talents.

**Simpler still, found the same day.** `C_ClassTalents.SwitchToLoadoutByName` does not load
anything itself. It fires `CLASS_TALENTS_SWITCH_TO_LOADOUT_BY_NAME`, and Blizzard's own callback
(`ClassTalentHelper.lua` lines 15-18) calls `PlayerSpellsFrame.TalentsFrame:LoadConfigByName`. The
file's comment: "These utils require going through the Class Talent Frame to ensure the UI can
manage and react to change flows correctly." Talent Loadout Manager (`BlizzardLoadoutChangerV2.lua`)
and EnhanceQoL (`TalentReminder.lua`, its Switch button) both call `ClassTalentHelper.SwitchToLoadoutByIndex`
straight from addon code in 12.x. So route 1 is a plain call to `ClassTalentHelper.SwitchToLoadoutByName`
from the button, and the secure macro button is route 2, only if route 1 taints.

What it costs, if it works: one click per boss instead of a window and a dropdown.

## Links

- Needs `0008`: the button it changes.
- Uses the loadout names from `0007`'s per-boss table.

## Not this card

- Making or importing a loadout. The button loads a loadout Rob already saved, by its exact name.
  If there is none, it says so.
- Changing talents by itself on zone-in or on a boss. That is a later card.
- Any `C_Traits` or `C_ClassTalents` call from addon code.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN the Talents button is clicked out of combat and the planned loadout exists, THE ADDON SHALL load it through Blizzard's `ClassTalentHelper`, or through its slash command on a secure macro button if the direct call taints. proves: manual (built; `talents button loads a saved loadout through ClassTalentHelper` proves the call, only the game proves the load)
- [x] WHEN the planned loadout name is not among the spec's saved loadouts, THE ADDON SHALL open the talent window as today and say in one line which name is missing. proves: `talents button falls back when the loadout is missing`
- [x] THE ADDON SHALL call no `C_ClassTalents` or `C_Traits` function that changes talents. proves: `no talent-changing call in the file` (twice: the in-game check records every `C_ClassTalents` and `C_Traits` key the button touches, and `offline-check.lua` scans the file's code against a list of readers)
- [x] WHEN the player is in combat, THE ADDON SHALL not change the button's macro text. proves: `talents button does nothing in combat` (there is no macro text, route 2 was not needed; in combat the button calls nothing and opens nothing)
<!-- AC:END -->

## Tasks

- [x] **Route 1, test it first, by hand, in the game.** Passed, Rob 2026-09-22 (see Comments). Out of combat:
  `/run ClassTalentHelper.SwitchToLoadoutByName("DotC Raid ST *")`, then pull a target dummy and
  press every action bar button for 30 seconds. If the loadout loads and no bar freezes and no
  "blocked" message shows, build route 1: the button calls it, guarded by `InCombatLockdown`, and
  the tab redraws on `TRAIT_CONFIG_UPDATED`. Say `CONFIG_COMMIT_FAILED` in one chat line.
- [ ] **Route 2, only if route 1 taints.** Not built: Rob's hand test passed route 1. Find the slash word: `/dump SLASH_TALENT_LOADOUT_BY_NAME1`
  (it lives in Blizzard's global strings, not in `wow-ui-source`). A `SecureActionButtonTemplate`
  button, `type` = `macro`, `macrotext` = the command and the name, set only out of combat.
- [x] Check the loadout name against `C_ClassTalents.GetConfigIDsBySpecID` and `C_Traits.GetConfigInfo`
  (read only) for the fallback. `PlanTab.savedLoadoutNames`, the same two calls Blizzard's own dropdown makes.
- [x] Offline checks under the names above.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md` and card `0002` first: they hold why
talents are fenced. A loadout name with a `;` or a new line would break the macro text; the names
come from our own table, so refuse any such name rather than escape it.

## Comments

- 2026-09-22 Claude: written from Rob's "A" to the AskMrRobot ideas, in a SecondBrain session.
  Ideation only. Nothing is built. **Uncertain:** the slash word, and whether a secure macro button
  may run it with no taint. The first two tasks settle both before any code.
- 2026-09-22 **Rob, in the game: route 1 works.** `/run ClassTalentHelper.SwitchToLoadoutByName("DotC Raid ST *")`
  out of combat showed the talent-change cast bar and the unlearned spells in chat. Over a minute on
  a target dummy afterwards, no errors. Build route 1; route 2 is not needed. Still unproven: the
  same call from a button's OnClick rather than `/run`, which the build's own check in the game settles.
- 2026-09-22 Claude: **built, route 1, in a worktree branch; no frame seen in a client.** The Talents
  button now calls `PlanTab.loadTalents(picked.loadout)`: out of combat it reads the spec's saved
  loadout names (`C_ClassTalents.GetConfigIDsBySpecID` then `C_Traits.GetConfigInfo`, the same two
  reads Blizzard's dropdown makes, each behind `pcall` and `canRead`), and if the planned name is
  saved it calls `ClassTalentHelper.SwitchToLoadoutByName(name)`. If the name is not saved it opens
  the talent window as before and prints one grey line naming it. If the game will not list the
  loadouts it still asks the helper, and Blizzard's frame says `ERR_TALENT_FAILED_INVALID_CONFIG`
  itself. The bag-mark watcher registers two more events, each verified with `IsEventRegistered`:
  `TRAIT_CONFIG_UPDATED` redraws the tab's "your loadout now", `CONFIG_COMMIT_FAILED` prints one
  line and redraws. The red mismatch line now reads `Click Talents to load "X" before Y.` No new
  top-level local (177). Both `lua offline-check.lua` (5.4) and the game's 5.1 exit 0.
  **Checks** (all in `selfTest`): `talents button does nothing in combat` (and asks nothing, opens
  nothing), `talents button falls back when the loadout is missing` (opens the window once, asks
  nothing, names the loadout in one line), `talents button loads a saved loadout through
  ClassTalentHelper` (by name, without opening the window), `no talent-changing call in the file,
  the button reads only` (a proxy `C_ClassTalents`/`C_Traits` records every key touched: exactly
  `GetConfigIDsBySpecID,GetConfigInfo`), `a loadout landing says nothing`, `a refused talent commit
  says so in one line`, `drawn Talents button loads the picked boss's loadout`. `offline-check.lua`
  adds a file scan: every `C_ClassTalents.`/`C_Traits.` call in code must be on a list of readers.
  **Mutations, each in a temp copy:** (1) delete the `InCombatLockdown` guard: 3 red; (2) turn the
  missing-name fallback into `if false`: 6 red; (3) replace the helper call with
  `C_ClassTalents.SwitchToLoadoutByName`: 3 red in the game check and 1 in the file scan; (4) a
  dead `C_ClassTalents.LoadConfig(1)` in code: 1 red in the file scan. The first pass of (1) and (2)
  stayed green: the check swaps `print` to capture the chat line, and `check()` reports through
  `print`, so five red checks read as a pass. Fixed by forwarding the red marker to the real print,
  and `offline-check.lua` now also counts the addon's own "N check(s) failed" summary, a gap that
  predates this card.
  **What a person must look at, out of combat, Feral:** (a) `/reload`, `/bis`, Plan, pick a boss
  whose loadout is red, click Talents: the talent cast bar shows, the loadout loads, and the line
  goes green on its own with the window still open. If instead the game says "no data" or nothing
  happens on the very first click after login, say so: Blizzard's `LoadConfigByName` refuses until
  its frame has loaded its saved variables, and the fix would be to open the window once first.
  (b) Then pull a target dummy and press every bar button for 30 seconds: no frozen bar, no
  "blocked" message. That is the taint question from the card's own task, now from OnClick rather
  than `/run`. (c) Pick a boss, rename its loadout in the talent window to something else, click
  Talents: the window opens and one grey chat line names the missing loadout; rename it back. (d)
  Click Talents while moving or mid-cast so the commit fails: one grey line about
  `CONFIG_COMMIT_FAILED`. (e) Hover Talents: the tip names the loadout it will load.
  **Left out and why:** route 2, the secure macro button, because route 1 passed Rob's hand test;
  the `;` and newline refusal from the Plan, because it guarded macro text and there is none;
  loading on zone-in or on a boss, which the card fences off.
- 2026-09-22 Claude, adversarial review in a worktree (merge `d62c4e3`, feature `519d400`), no
  game client. **Passes offline; the load itself is the game's to prove, so human-review, not done.**
  **Attacked:** every `proves:` check ran green under Lua 5.4 and 5.1 (both exit 0), then each guard
  was broken in a temp copy: combat guard deleted (3 red), missing-name fallback turned off (6 red),
  helper call swapped for `C_ClassTalents.SwitchToLoadoutByName` (4 red), a dead
  `C_ClassTalents.LoadConfig(1)` in code (red), the `CONFIG_COMMIT_FAILED` line removed (1 red), the
  drawn button put back to open-only (1 red), the helper call replaced by opening the window (3 red).
  Dropping `canRead` on the loadout name stays green, as expected: no offline check can hand the file
  a secret, so that guard is proved by reading only. **Checked against `wow-ui-source` (branch
  `live`):** `ClassTalentHelper.SwitchToLoadoutByName` exists and only calls
  `C_ClassTalents.SwitchToLoadoutByName` (`HasRestrictions`, `SecretArguments = AllowedWhenUntainted`),
  whose event Blizzard answers with `PlayerSpellsFrame.TalentsFrame:LoadConfigByName`;
  `GetConfigIDsBySpecID`, `C_Traits.GetConfigInfo`, `C_SpecializationInfo.GetSpecialization` and
  `GetSpecializationInfo` are documented with the signatures used; `TRAIT_CONFIG_UPDATED` and
  `CONFIG_COMMIT_FAILED` are documented events, both registered one at a time after the handler and
  verified with `IsEventRegistered`. Every `C_ClassTalents` / `C_Traits` call in the file is a read
  and the file scan in `offline-check.lua` enforces it. The name is used as a table key only after
  `canRead`, and the printed name is our own table's, so the three 12.1 traps are covered. No new
  top-level local (177). **Held, with two notes, neither changed:** (1) Blizzard's `LoadConfigByName`
  matches case-insensitively (`strcmputf8i`); our missing-name check is exact, so a loadout saved as
  `dotc raid st *` would get the grey "no saved loadout" line where Blizzard would have loaded it.
  The names are Rob's own table and the red mismatch line (`0007`) is exact too, so this is
  consistent rather than wrong. (2) `CONFIG_COMMIT_FAILED` fires for any refused commit, including a
  hand edit in the talent window, and the line says "click Talents again" either way. Harmless, one
  grey line. **The one thing only the game can settle, and the builder already named it:**
  `LoadConfigByPredicate` refuses with `ERR_TALENT_FAILED_NO_DATA` until the talent frame's
  `variablesLoaded` is set, which happens on `Blizzard_PlayerSpells`'s `ADDON_LOADED`. The helper
  loads that addon on demand, so the very first click after login, with the talent window never
  opened, may say "no data". If it does, the fix is one line: `C_AddOns.LoadAddOn("Blizzard_PlayerSpells")`
  when the Plan tab first draws. Not added before the game says it is needed. **Security:** weakest
  point is the loadout name handed to Blizzard's frame, and it comes from the addon's own baked table,
  never from chat, a tooltip or another player. Unchecked paths in: none, the only inputs are two game
  events with a numeric configID that is not read, and a click. On failure it leaks one grey chat
  line naming a loadout from our own table, nothing else. Nothing fixed, nothing bounced.

## What I need from you

Out of combat, on Feral, after `/reload`:

1. `/bis`, Plan tab, pick a boss whose loadout line is red, click Talents once. Expected: the
   talent-change cast bar, the loadout loads, the line goes green on its own. If the game says
   "no data" or nothing happens on this very first click, say so: that is the `variablesLoaded`
   note above, and the one-line fix is named there.
2. Then pull a target dummy and press every action bar button for 30 seconds. Expected: no frozen
   bar, no "blocked" message. This is the taint question from a button's OnClick, which `/run` did
   not settle.
3. Rename the picked boss's loadout in the talent window, click Talents. Expected: the window opens
   and one grey chat line names the missing loadout. Rename it back.
4. Click Talents while moving so the commit fails. Expected: one grey line about
   `CONFIG_COMMIT_FAILED`.
5. Hover Talents. Expected: the tip names the loadout it will load.

Say which of the five you saw, and this card can go to done.
