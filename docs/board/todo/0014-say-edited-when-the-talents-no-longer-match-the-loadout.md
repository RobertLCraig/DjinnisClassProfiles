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
- [ ] WHEN they match, THE ADDON SHALL show the name with nothing after it. proves: `matching talents are not marked`
- [ ] THE ADDON SHALL read the talent string only out of combat. proves: `talent string read out of combat only`
<!-- AC:END -->

## Tasks

- [ ] Find where the planned string comes from: the saved loadout (`C_Traits.GenerateImportString`
  on that config) or a string baked into the plan by `update-gear-plan.ps1`. Prefer the saved loadout.
- [ ] Compare the tree choices, not the whole string, if the header differs between two strings of
  the same build. Check this with two exports of one loadout.
- [ ] Redraw on `TRAIT_CONFIG_UPDATED`.
- [ ] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" in a SecondBrain session. Ideation only.
