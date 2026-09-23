---
needs: 0030
---
# 0031 The builds become real loadouts on every character, and a drifted one is replaced

## Why

Rob, 2026-09-23: he plays several characters of one class and wants talents the same on all of
them. He left TalentLoadoutsEx because it did not work across characters, and found
ImprovedTalentLoadouts' single temporary loadout a sticking point.

Wearing a build by writing nodes from addon code is the frozen-action-bar route (`0002`, `0008`,
`0011`). So the builds are kept as ordinary Blizzard loadouts, one per build, and worn through
`ClassTalentHelper` as the Talents button already does.

## What

- The import queue from `DjinnisDreamgrove/Core.lua` moves here: one `C_ClassTalents.ImportLoadout`
  at a time, waiting on `IsConfigPopulated`, refusing while the talent window is open. Every lesson
  on DjinnisDreamgrove card `0001` comes with it.
- On login and on spec change, out of combat, the addon says which planned builds this character
  is missing and offers one button to create them. It does not create them unasked.
- **A drifted loadout is replaced, not written into.** When the saved loadout named for a build no
  longer matches the stored string, the fix is `DeleteConfig` then `ImportLoadout` from the stored
  string. This closes card `0029`'s dead end ("there is no build to load back").
- The addon owns a name only if it is in its own build list. A loadout Rob named himself is never
  deleted or replaced.
- The old 0.6.0 names are listed and removed on request, the job `/dg tidy` was going to do.

## Not this card

- The list's look. That is `0032`.

## Acceptance

- [ ] WHEN a planned build has no loadout of its name on this character, THE ADDON SHALL offer to create it, and SHALL create nothing without a click.
- [ ] WHEN a loadout named for a build has drifted, THE ADDON SHALL offer "Reset to plan", which deletes and re-imports it, and SHALL NOT call `CommitConfig`, `LoadConfig`, `PurchaseRank` or `SetSelection`.
- [ ] WHEN the selected loadout is the one to replace, THE ADDON SHALL say so and wait, because deleting the worn loadout drops to the starter build.
- [ ] IN combat, or with the talent window open, THE ADDON SHALL refuse and say why.
- [ ] In a client: no frozen action bar after creating, replacing and switching builds, then one pull on a dummy.
