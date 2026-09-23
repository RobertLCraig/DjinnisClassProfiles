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

## Built, v0.27.0, 2026-09-23

- New section in `DjinnisBiS.lua`, "The plan's builds as real loadouts on every character".
  The import queue is DjinnisDreamgrove's, every guard kept: one import in flight, readiness by
  `IsConfigPopulated` plus `CanCreateNewConfig`, a quiet second pass, no import with the talent
  window open, the tree asked of the spec.
- 5 seconds after login, and 2 seconds after a spec change, a prompt lists the missing and the
  drifted builds. Buttons: **Create N**, **Reset to plan**, **Not now**. `/djbis loadouts` asks
  again, even after Not now.
- **Reset to plan** parses the stored string first and only then calls `DeleteConfig`, then
  `ImportLoadout`, so a bad string never costs the old loadout. The selected loadout is skipped
  with a line that says why.
- `/djbis tidy` lists the old 0.6.0 names on this spec; `/djbis tidy yes` deletes them. The list
  is `PlanTab.RETIRED`, copied from `DjinnisDreamgrove/Data.lua`. **It includes `WS M+`,
  `WS Raid 3T` is not in it, and `DotC Raid ST *` is.** Two of the gear cells were simmed under
  those names; deleting the loadout does not touch the cell.
- **Fixed on the way: `talentStringsDiffer` could not compare any Dreamgrove build.** Balance and
  Feral strings carry a zero-filled tree hash, and the compare demanded the whole header match,
  so every one read "cannot compare". A zero hash now agrees with any hash, which is what
  Blizzard's own format note says it means. This also changes the `(edited)` mark and the
  sidebar for the Dreamgrove rows: they can now read edited. One old check expected the blind
  spot and was updated.
- `/bis test`: `PlanTab.loadoutChecks`, 36 checks against a stubbed game: gaps, the offer,
  both fences, Create with a busy first try, Reset, the selected one, tidy, and that no
  talent-wearing call is reached. `offline-check.lua`'s allowlist now carries `ImportLoadout`
  and `DeleteConfig` by name, with the reason. `lua offline-check.lua`: no FAIL lines.

**Open.** The node bits are compared as text. If Dreamgrove's exporter and the client encode one
build differently, a fresh import will read "drifted" at once. `/djbis talents` after a Create
shows it: the new loadout should say `same`.

## What I need from you

1. `/reload` on a Feral druid that lacks the `Raid: <boss>` loadouts. Close the talent window.
   After about 5 seconds a prompt lists them. Pass: nothing is made until you click.
2. Click **Create N**. Pass: one `Made N of N` line, no red lines, no talent change.
3. Open the talent window. Pass: the loadouts are in the dropdown. Pick one; `/djbis talents`
   says `same` for it.
4. Edit one talent in a `Raid:` loadout, Apply, then pick a different loadout. `/djbis loadouts`.
   Pass: it is listed as drifted, and **Reset to plan** puts it back.
5. With the edited one still selected, **Reset to plan**. Pass: a line says it is selected, and
   nothing is deleted.
6. `/djbis tidy`, read the list, then `/djbis tidy yes` if it is right.
7. Switch between two made loadouts, then one pull on a dummy. Pass: no frozen action button.

## Acceptance

- [ ] WHEN a planned build has no loadout of its name on this character, THE ADDON SHALL offer to create it, and SHALL create nothing without a click.
- [ ] WHEN a loadout named for a build has drifted, THE ADDON SHALL offer "Reset to plan", which deletes and re-imports it, and SHALL NOT call `CommitConfig`, `LoadConfig`, `PurchaseRank` or `SetSelection`.
- [ ] WHEN the selected loadout is the one to replace, THE ADDON SHALL say so and wait, because deleting the worn loadout drops to the starter build.
- [ ] IN combat, or with the talent window open, THE ADDON SHALL refuse and say why.
- [ ] In a client: no frozen action bar after creating, replacing and switching builds, then one pull on a dummy.
