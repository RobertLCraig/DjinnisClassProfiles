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

## Comments

**2026-09-23** Adversarial review (agent). **BOUNCE.**

What I attacked: the section at `DjinnisBiS.lua` 6230-6569, `talentStringsDiffer` (1763), `loadTalents`,
`loadoutChecks`, the offline-check allowlist, and 43b4530's tidy change. I checked the APIs against
`wow-ui-source` 12.1.0 (69875): `Blizzard_ClassTalentImportExport.lua`, `ExportUtil.lua`,
`Blizzard_ClassTalentsFrame.lua`, `ClassTalentsDocumentation.lua`. `lua offline-check.lua` passes. I
ran 22 mutations on a copy in `%TEMP%\rev0031`.

**What held.**
- No talent-wearing call. The allowlist scan and the `touched` stub both go red if a `LoadConfig` is added.
- The combat fence, the talent-window fence, the "made only on a click" rule, Not now, the
  "unknown is not all missing" rule, the skip of the selected loadout, and tidy's live-name guard.
  Each one goes red when broken.
- The header bit layout is right. Version and spec are 24 bits, so chars 1-4. The hash is chars
  5-25 plus the low 2 bits of char 26. Blizzard's importer does treat an all-zero hash as "skip
  the check".
- Events: the handler is set first, and each event is checked with `IsEventRegistered`.
  `armLoadouts` runs at PLAYER_LOGIN.
- Secrets: names, export strings and the spec-event unit all go through `canRead`.
- A spec change mid-queue: the spec check in `importOne` runs before `DeleteConfig`.
- A /reload mid-queue loses the queue and nothing else. Delete and import run in the same frame.

**What broke.**
1. **Every freshly made Feral loadout will probably read "drifted" at once** (`DjinnisBiS.lua:1772`).
   The card's Open note can already be seen offline. The gear cell `WS M+` (line 421) came through
   SimC from the loadout Dreamgrove 0.6.0 imported under that name. When I decode its nodes, they
   match Dreamgrove's own `WS M+` string on every purchased node. They still differ as text. The
   Dreamgrove string marks nodes 103, 120, 121, 210 and 226 as *selected but not purchased*
   (granted). The client export leaves those nodes unselected. `DotC Raid ST *` shows the same
   thing, and the current `BUILDS.Feral` strings carry the same granted marks. So the likely result
   is this. The prompt offers Reset to plan on every login and spec change. Reset deletes the
   loadout and makes it again, and it still reads drifted. The sidebar marks every Dreamgrove row
   `(edited)`.
   **Fix:** stop comparing the node bits as text. Walk both streams node by node. The format
   describes itself, so the tree is not needed: 1 bit for selected, then 1 for purchased, then 1
   for partial ranks (+6 bits), then 1 for choice (+2 bits). Count a granted node as unselected
   and ignore trailing unselected nodes. Then compare. Add a check: the gear-cell `WS M+` against
   Dreamgrove's `WS M+` must be `false`.
2. **Nothing checks the rule "a bad string never costs the old loadout".** If I move `DeleteConfig`
   in front of the header parse, every check still passes. The same is true if I drop the spec,
   version or empty-entries refusals, or stop clearing `job.replace`. **Fix:** add a Reset check
   with `ReadLoadoutHeader` returning false, and one with no entries. Both should expect no
   `delete` call.
3. **Minor (`stepLoadouts`, 6390):** say Delete succeeds, then both import tries fail. The only
   line is "X failed". It does not say the old loadout is gone. **Fix:** when `job.replace` was
   used up, say "deleted, not made again; Create will make it".
4. **Minor:** `tidy` does not check the talent window or a running queue. Blizzard's own delete
   dialog runs with the window open, so the harm is small. No check covers tidy's selected guard.
   `savedLoadoutNames` keeps one id per name, so if two loadouts share a planned name, Reset
   deletes whichever one came last. Skip a name that more than one loadout holds.

**Security.**
1. Weakest point: the drift test decides what gets deleted. A wrong "drifted" (finding 1) is a
   delete that keeps coming back. It only ever hits names on the addon's own list, and never the
   selected loadout.
2. Unchecked: there is no outside input. The strings are compiled into the file. Slash commands
   and buttons need the player, and every delete is behind a click or `tidy yes`.
3. Leaks: nothing. There is no network, and failures print only a loadout name and the game's reason.

**Not verifiable here:** there is no browser surface. The UI runs only in a game client, which no
agent can run. Criteria 1-5 are in-game checks.

**2026-09-23** Builder, v0.33.0, commit `daf3506`. All four findings fixed.
1. `talentStringsDiffer` now decodes the node bits (`PlanTab.nodeKey`) and compares purchased
   nodes only, with ranks and choice. A granted node counts as unselected. The gear cell's
   `WS M+` against Dreamgrove's `WS M+` is now `false`, and that is a check. This closes the
   card's Open note. Old checks faked an edit by changing the last character, which is only
   padding; they now flip a bit mid-string (`PlanTab.movePoint`).
2. New Reset checks: a string that will not parse, and one with no talents. Both expect no
   delete. Moving `DeleteConfig` up now turns 3 checks red.
3. A delete that was not made again now says so and points at `/djbis loadouts`.
4. `tidy` takes `loadoutFence` (combat, talent window, running queue). Checks cover its window
   and selected guards. A name two loadouts share is never replaced, and the player is told.
Breaking each fix on a copy turned the checks red (5 of 5).
