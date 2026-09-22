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
