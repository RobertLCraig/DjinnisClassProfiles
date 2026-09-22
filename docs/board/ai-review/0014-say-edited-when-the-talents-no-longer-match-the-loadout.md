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
- [ ] WHEN the active talents differ from the planned loadout's talent string, THE ADDON SHALL show the loadout name with "(edited)" after it. proves: `edited talents are marked`
- [x] WHEN they match, THE ADDON SHALL show the name with nothing after it. proves: `matching talents are not marked`
- [x] THE ADDON SHALL read the talent string only out of combat. proves: `talent string read out of combat only`
<!-- AC:END -->

## Tasks

- [x] Find where the planned string comes from: the saved loadout (`C_Traits.GenerateImportString`
  on that config) or a string baked into the plan by `update-gear-plan.ps1`. Prefer the saved loadout.
- [ ] Compare the tree choices, not the whole string, if the header differs between two strings of
  the same build. Check this with two exports of one loadout.
- [x] Redraw on `TRAIT_CONFIG_UPDATED`.
- [x] Offline checks under the names above.

## What I need from you

1. Load "DotC Raid ST *" through the talent window, open `/bis`, Plan tab. Line 1 should read
   `your loadout now: DotC Raid ST *` with nothing after it, and Entombed Sentinels green.
2. Move one talent point by hand and apply. Line 1 should now say `DotC Raid ST * (edited)`, the
   picked boss row should go red, and the "Open talents and pick ..." line should appear, without
   reopening the window (that is the `TRAIT_CONFIG_UPDATED` redraw).
3. Load the loadout again. The mark should go.
4. The one thing I could not settle offline: whether `GenerateImportString` on a SAVED config
   returns the same string as on the active config after that loadout is loaded, header included.
   If step 1 shows "(edited)" straight after a clean load, the header differs and the comparison
   must start at the node bits. Blizzard's own UI never calls this function, so there was nothing
   in `wow-ui-source` to read it off.
5. Hit a dummy with the tab open: no error, and the mark holds whatever it said before the pull.

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
