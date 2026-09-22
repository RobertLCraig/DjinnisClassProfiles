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
- [ ] WHEN the Talents button is clicked out of combat and the planned loadout exists, THE ADDON SHALL load it through Blizzard's `ClassTalentHelper`, or through its slash command on a secure macro button if the direct call taints. proves: manual
- [ ] WHEN the planned loadout name is not among the spec's saved loadouts, THE ADDON SHALL open the talent window as today and say in one line which name is missing. proves: `talents button falls back when the loadout is missing`
- [ ] THE ADDON SHALL call no `C_ClassTalents` or `C_Traits` function that changes talents. proves: `no talent-changing call in the file`
- [ ] WHEN the player is in combat, THE ADDON SHALL not change the button's macro text. proves: `the secure button is not changed in combat`
<!-- AC:END -->

## Tasks

- [x] **Route 1, test it first, by hand, in the game.** Passed, Rob 2026-09-22 (see Comments). Out of combat:
  `/run ClassTalentHelper.SwitchToLoadoutByName("DotC Raid ST *")`, then pull a target dummy and
  press every action bar button for 30 seconds. If the loadout loads and no bar freezes and no
  "blocked" message shows, build route 1: the button calls it, guarded by `InCombatLockdown`, and
  the tab redraws on `TRAIT_CONFIG_UPDATED`. Say `CONFIG_COMMIT_FAILED` in one chat line.
- [ ] **Route 2, only if route 1 taints.** Find the slash word: `/dump SLASH_TALENT_LOADOUT_BY_NAME1`
  (it lives in Blizzard's global strings, not in `wow-ui-source`). A `SecureActionButtonTemplate`
  button, `type` = `macro`, `macrotext` = the command and the name, set only out of combat.
- [ ] Check the loadout name against `C_ClassTalents.GetConfigIDsBySpecID` and `C_Traits.GetConfigInfo`
  (read only) for the fallback.
- [ ] Offline checks under the names above.

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
