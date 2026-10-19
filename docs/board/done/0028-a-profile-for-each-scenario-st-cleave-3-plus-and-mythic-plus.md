---
needs: 0014
---
# 0028 A profile for each scenario: raid single target, raid cleave, raid 3+ targets, Mythic+

## Why

Rob, 2026-09-22, choosing Option A on the planned-build question: "this leads onto something I
want to add, which is a profile for each scenario: RAID Single Target, RAID Cleave, Raid multi
Target (3+), M+."

Today a spec has three cells (`st`, `2t`, `mplus`) and only `st` and `mplus` carry a `talents`
string, so a 2-target boss has gear but no planned build, and there is no cell at all for a
3+ target fight. A profile is one cell: loadout name, talents string, gear, stat targets.

## Links

- Needs `0014`: the compare against the cell's own `talents` string is what makes a profile's
  build mean something.
- Extends `0004` (`update-gear-plan.ps1`), `0007` (Plan tab rows), `0009` (the scenario button).

## Not this card

- Choosing which boss is 3+ targets. The `BOSSES` rows say that already, one edit each.
- Running the sims. That is a Raidbots trip per spec per scenario; see below.

## Direction

- Add scenario `3t` beside `st`, `2t`, `mplus`: `SCENARIO_LABEL` "3+ targets", the strip's
  button cycles 1, 2, 3+, Mythic+ (in a raid: 1, 2, 3+, 1), `update-gear-plan.ps1` maps
  `enemyCount` 3 and above to `3t`, `SCENARIO_ORDER` gains it, the self-test covers it.
- Every cell carries `talents`. The bake script already writes it from the report's loadout
  string; a report simmed on the wrong loadout writes the wrong build, so the script prints the
  loadout name it baked and the cell's `loadout` must match a name in `BOSSES`.
- Nothing else changes shape: a cell is a cell, the Plan tab draws whatever cells exist.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN a report simmed at three or more enemies is baked, THE SCRIPT SHALL fill the spec's `3t` cell with gear, stat targets, loadout and talents. proves: `a 3+ target report fills the 3t cell`
- [x] WHEN the strip's scenario button is pressed in a raid, THE ADDON SHALL cycle 1 target, 2 targets, 3+ targets, 1 target. proves: `the scenario button reaches 3+ targets`
- [x] WHEN a boss row names scenario `3t`, THE PLAN TAB SHALL draw that cell's gear and build for it. proves: `a 3t boss row draws the 3t cell`
- [x] WHEN a cell has no `talents` string, THE ADDON SHALL show no build for it and mark nothing edited. proves: `a cell without talents has no planned build`
- [ ] WHEN the twelve Raidbots Top Gear runs under "What I need from you" are baked with `.\update-gear-plan.ps1 <links> -Deploy`, THE PLAN SHALL hold all four cells for Balance, Guardian and Resto, beside Feral's. proves: manual (Rob runs the sims; the script's own listing is the check)
- [ ] LOOK, after `/reload`, outside an instance: press the strip's scenario button under the character sheet from "1 target". It reads "2 targets", "3+ targets", "Mythic+", "1 target", and "3+ targets" fits the button. In a raid it reads 1, 2, 3+, 1. The Plan tab shows four content buttons with "Raid - 3+ targets" third. proves: manual
<!-- AC:END -->

## Tasks

- [x] `3t` in `SCENARIO_LABEL`, `nextScenario`, `planScenario`, the bag and stat readers, the
  self-test's scenario loops.
- [x] `update-gear-plan.ps1`: `$SCENARIOS` 3 and above, `$SCENARIO_ORDER`, self-test.
- [x] Offline checks under the names above.

## What I need from you

**Twelve Raidbots Top Gear runs, then paste the twelve report links into a session.** You decided
2026-10-11 that every druid spec gets a gear plan (see Comments). Only your Raidbots account can run
a sim, so these are yours. Nothing else on this card waits on you.

For each run: switch to the spec in game, type `/simc`, copy the WHOLE export including the
checksum line (a trimmed export turns the page to Unverified Input), and paste it into
raidbots.com > **Top Gear** (not Advanced: the bake refuses an Advanced report). Pick the loadout
below in Top Gear's talent dropdown. Leave everything else at Raidbots' default (5 minute fight).

| # | Spec | Scenario | Fight style | Bosses | Loadout to pick |
|---|---|---|---|---|---|
| 1 | Balance | 1 target | Patchwerk | 1 | `[CP] Raid: Single Target` |
| 2 | Balance | 2 targets | Patchwerk | 2 | `[CP] Raid: Cleave` |
| 3 | Balance | 3+ targets | Patchwerk | 3 | `[CP] Raid: Cleave` |
| 4 | Balance | Mythic+ | Dungeon Slice | - | `[CP] Dungeon` |
| 5 | Guardian | 1 target | Patchwerk | 1 | `[CP] Raid` |
| 6 | Guardian | 2 targets | Patchwerk | 2 | `[CP] Raid` |
| 7 | Guardian | 3+ targets | Patchwerk | 3 | `[CP] Raid` |
| 8 | Guardian | Mythic+ | Dungeon Slice | - | `[CP] Dungeon` |
| 9 | Restoration | 1 target | Patchwerk | 1 | `[CP] Raid` |
| 10 | Restoration | 2 targets | Patchwerk | 2 | `[CP] Raid` |
| 11 | Restoration | 3+ targets | Patchwerk | 3 | `[CP] Raid` |
| 12 | Restoration | Mythic+ | Dungeon Slice | - | `[CP] Dungeon` |

The loadouts are the builds each spec has today (`PlanTab.BUILDS`): Guardian and Restoration
have one raid build, so all three raid runs use it. Balance has no 3+ target build, so its 3+ run
uses the cleave one. Each spec's runs can go in any order and on any day; a report lasts 30 days.

**To bake them**, from `C:\Dev\WoWAddons\DjinnisClassProfiles`, or hand the links to a session:

    .\update-gear-plan.ps1 <link 1> <link 2> ... <link 12> -Deploy

It says which spec and scenario each report filled. Then `/reload`.

**Pass:** the script lists twelve cells, `Balance st` to `Resto mplus`, and refuses none.

**Fail:** a refusal. Paste its message into `## Comments`; it names the report and why.

**One thing you might choose differently.** Raidbots' Top Gear ranks gear by damage done. For
Guardian and Restoration that is the damage-best set, not the most survival or the most healing.
If you want those two judged another way, say so before running 5 to 12.

## Comments

- 2026-09-22 Claude: written from Rob's Option A answer. The addon side is one agent's build;
  the sims are Rob's trips.
- 2026-09-22 Claude (build, worktree branch): `3t` added everywhere the addon enumerates a
  scenario: `SCENARIO_LABEL`, `planScenario`'s accepted set, `PlanTab.nextScenario` (2t goes to
  3t; 3t goes to Mythic+ outside and to 1 target in a raid), `PlanTab.CHOICES` and
  `CHOICE_LABEL` (four buttons), `PlanTab.CONTENT_WORD` (3t is raid content, so the stat
  targets, tooltip lines and item list treat it as raid), `PlanTab.SET_SUFFIX` ("DBiS Feral
  3T"), `buildPlanIndex` (now walks `PlanTab.CHOICES`), and the data check on every cell's
  scenario. `GEAR_PLAN` has no `3t` cell and nothing minds, as the Mythic+ cell used to be.
  Script: `$SCENARIOS` gains `3 = '3t'` and `Read-Plan` clamps the enemy count to 3, so seven
  enemies file as `3t`; `$SCENARIO_ORDER` is `st, 2t, 3t, mplus`; each report's line now ends
  `simmed on loadout "..."` and `Get-BossLoadouts` reads the target file's `PlanTab.BOSSES`
  rows for that spec and warns when the name is not among them. `-SelfTest` makes the 3- and
  7-enemy reports from the 1-enemy fixture in a temp folder rather than shipping two more
  8 KB fixtures; seven checks pass. Offline: three `do` blocks at the tail of `selfTest`,
  both interpreters exit 0; each behaviour was mutated once on a temp copy and went red
  (old cycle: 5 FAIL; saved `3t` refused: 4 FAIL; Plan tab drawing the st cell for a 3t row:
  1 FAIL; a cell without talents borrowing the st string: 1 FAIL; `3t` dropped from
  `$SCENARIO_ORDER`: 1 FAIL; clamp removed: the script's own "cannot place" throw; warning
  inverted: 1 FAIL). The fourth criterion is half proven here: `gearPlanFor` hands over
  `talents = nil` for such a cell and the `/simc` export leaves the loadout out rather than
  borrowing a string. "Mark nothing edited" is the compare `0014` is rebuilding around
  `PlanTab.plannedTalents(spec, scenario)`; that card's review should tick it, so it is left
  open here. Not touched: `PlanTab.talentsEdited`, `activeLoadoutName`, `loadoutState`. No
  version bump. The `a 3+ target report fills the 3t cell` proof is the PowerShell self-test,
  not a Lua block.
- 2026-09-22 Claude (review, worktree branch): attacked against the merged code, not the ticks.
  Every `"2t"` and `"mplus"` literal in `DjinnisBiS.lua` was read and sorted: the ones that
  enumerate a scenario (`SCENARIO_LABEL`, `planScenario`, `nextScenario`, `CHOICES`,
  `CHOICE_LABEL`, `CONTENT_WORD`, `SET_SUFFIX`, `buildPlanIndex`, the data check,
  `keystoneLootWanted` and the set-name loop, which walk `SCENARIO_LABEL`) all know `3t`; the
  rest (`statContext`, the stat pane's switch, `rowHere`, `sidebarRows`, the stat-target loop,
  `offerSetup`, the boss-id check) are a raid-or-Mythic+ split where `3t` is raid and falls
  through correctly. The bag glow, the equipment set names ("DBiS Guardian 3T" is 16), the
  simc export (walks the spec's cells with `pairs`) and the Plan tab's four buttons (ends at
  x=620 in a 900-wide window) need nothing. Script: `Get-BossLoadouts` run against the real
  file answers Feral's ten names and an empty list for Balance and Resto, so a bake for a spec
  with no rows warns, as its comment says; `Read-ExistingCells` keys on `\w+` so a `3t` cell
  survives a re-run; a missing `enemyCount` clamps to 0 and throws rather than filing. All
  three checks green before and after. The fourth criterion is now ticked end to end:
  `plannedTalents` returns nil for a cell with no or an empty string (checks under the
  `a cell without talents marks nothing` name), `activeLoadoutName` passes that nil to
  `talentsEdited`, which returns nil without a read, `loadoutState` then judges by name and
  `sidebarRows` marks "edited" only on a truthy `edited`. Found and fixed in place, comments
  only: three that still said "three buttons" / "row of three" / "the 1 and 2 target rows",
  and the HANDOVER's key-files line that named two scenarios. Security: the weakest point is
  `Get-BossLoadouts` trusting the target file's `PlanTab.BOSSES` block by regex, which is the
  author's own file at author time; the unchecked path is `enemyCount` from a Raidbots JSON
  the author chose to fetch, cast to int and clamped, so a bad value throws and writes
  nothing; nothing leaks, the script prints a loadout name Rob typed into Raidbots himself.
  No UI could be looked at here (no client), so this goes to human-review for the two looks
  already listed under "What I need from you", plus one more: the strip's 90-wide button with
  "3+ targets" on it, which is one glyph wider than "2 targets" was.

- 2026-09-23 Claude: Feral `3t` cell baked from report `r4XdLNcxvUod46NbgqQrMP` (Patchwerk, 3 bosses, 5 min). Two Dreamgrove builds were simmed; Wildstalker won at 300,916 dps against Druid of the Claw at 277,227. Loadout name `WS Raid 3T`. No boss row is `3t` yet: Rob picks which. The bake script now splices the game's talent header onto a website build (`Repair-TalentHeader`), since a blank header would make the addon's edited-compare refuse it.

**2026-09-29** Attended unblock pass. The ask is rewritten to what is still open. Feral's `2t`
and `mplus` cells were re-baked on their own loadouts in commit `09c637c` (`[CP] Raid: Lost
Explorers`, `Dungeon (new)`), so "re-bake the 2-target cells" is done for Feral. The old second
look, the empty-`3t` message, cannot be seen on Feral any more, because its `3t` cell is baked.

**2026-10-11** **Decided:** Rob, relayed in the clear-down. 1. 3+ bosses: none for now ("agree, just build it"); no boss row changes. 2. Gear plans for ALL specs: Balance, Guardian and Restoration as well as Feral.

**2026-10-11** Clear-down (attended, Rob asked). Answer 1 needs no change. Answer 2 needs twelve Top Gear runs that only Rob's Raidbots account can make; the exact list and the bake command are now the ask above and one `proves: manual` criterion, and the strip look is the other. Found while writing it: `PlanTab.lines` draws the Plan tab from `PlanTab.BOSSES`, which has rows for Feral and Balance only, so a baked Guardian or Resto plan would reach the strip and the bag glows but not the Plan tab ("No boss plan for Guardian yet"). That is card 0091. The build itself is done and its four criteria ticked, so this moves to ai-review/ with only the manual criteria open (board README, A look waits on the product).

### 2026-10-19 review (v20261019062436-bb26)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I checked each of the four ticked criteria against the code. All four hold. I found no defect.

- **#1 (a 3+ target report fills the 3t cell):** This is in `update-gear-plan.ps1`. The `$SCENARIOS` table gains `3 = '3t'`. `Read-Plan` caps the enemy count at 3, so 7 enemies still go to `3t`. `$SCENARIO_ORDER` is `st, 2t, 3t, mplus`. The `-SelfTest` check "a 3+ target report fills the 3t cell" makes a 3-enemy and a 7-enemy report. It asserts loadout, talents and slots in exactly one `["3t"]` cell.
- **#2 (the button reaches 3+ targets):** This is `PlanTab.nextScenario` in `DjinnisClassProfiles.lua`. 2t goes to 3t. Then 3t goes to Mythic+, or to 1 target in a raid. `planScenario` accepts `3t`. Self-test checks in `selfTest` cover both cycles.
- **#3 (a 3t boss row draws the 3t cell):** `PlanTab.CHOICES` and `CHOICE_LABEL` include `3t`. `PlanTab.bossFor` selects a 3t row. `gearPlanFor("Feral","3t")` gives back the 3t cell, not the st one. A self-test covers this.
- **#4 (a cell without talents has no planned build):** `PlanTab.plannedTalents` gives back nil when `talents` is missing or empty. So nothing shows as "edited".

Criteria #5 and #6 are manual. They are only open, which is not a finding.

VERDICT: sound

**scope: sound**

I looked for work that goes past the card, and for work that is half done. I found no fault.

**What the diff is.** The diff has 158 files. It covers the whole branch: the rename to DjinnisClassProfiles and about 60 other cards. This card is only one of them. For this card, I checked the scenario code. `DjinnisClassProfiles.lua` has 29 `"3t"` uses, so the scenario is in all the places the card's tasks name. The extra files belong to other cards, so they are not scope growth from this card.

**Inside the fence.** Nothing crosses "Not this card." No boss row was changed to `3t`. Rob decided on 2026-10-11 to have no 3+ bosses for now. The build ran no sims. The Feral `3t` cell was baked from a report, on a separate day (2026-09-23).

**Small extra.** `Repair-TalentHeader` in `update-gear-plan.ps1` was not in the card. It supports the "every cell carries talents" direction, so I count it as part of the work, not growth.

**Half done.** The Guardian and Resto Plan tab gap is already on card 0091. Criteria #5 and #6 are `proves: manual` and only open. Nothing I read shows that they cannot pass.

No criterion is disproved.

VERDICT: sound

**breakage: sound**

I tried to break this card. It held up.

- **The bake script** (`update-gear-plan.ps1`, in `Read-Plan`): 3 or more enemies go to `3t`. A dungeon fight style goes to `mplus`. Any other report stops with a clear message and writes nothing. The script lists `3t` third, before `mplus`.
- **The scenario button** (`PlanTab.nextScenario`): outside a raid it goes 1, 2, 3+, Mythic+. In a raid it goes 1, 2, 3+, 1. The self-test checks both orders.
- **Where the addon lists scenarios** (`SCENARIO_LABEL`, `planScenario`, `PlanTab.CHOICES`, `CHOICE_LABEL`, `CONTENT_WORD`, `SET_SUFFIX`): all of them know `3t`. I found no missed caller.
- **Pressing the button** calls `PlanTab.pickScenario(PlanTab.nextScenario(planScenario(spec), autoContext()))`. So in a raid it uses the raid order.
- **A `3t` boss row:** the self-test draws the `3t` cell for it. Then it puts the real Feral `3t` cell back.
- **A cell with no build:** the earlier review traced it through `plannedTalents`, `talentsEdited` and `loadoutState`. I found nothing that breaks that path.

The two open criteria are `proves: manual`. Rob does those, so they are not findings.

No defect found. No criterion disproved.

VERDICT: sound

