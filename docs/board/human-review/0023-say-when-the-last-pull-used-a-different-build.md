---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0014, 0027
---
# 0023 Say when the last pull used a different build

## Why

Hindsight 1.8.9 saves Rob's last pull on each boss, with the spec and the talent string used:
`HindsightCharDB.pulls[encounterID].build` and `.specKey` (read 2026-09-22; 15 boss pulls over four
specs). It compares that build with top players. It does not compare it with Rob's own plan.

What it gains: after a bad pull, the Plan tab says whether the build was the planned one, so Rob
knows if it was the build or the play.

## Links

- Needs `0014`: the same talent string compare.
- Needs `0027`: Hindsight keys pulls by encounter id.
- Draws by `0020`'s rules.

## Not this card

- Showing Hindsight's own grades. Hindsight's window does that (`/hind`).

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN Hindsight has a saved pull for a planned boss and its build differs from the planned loadout, THE PLAN TAB SHALL say so on that boss's row, with the spec used. proves: `boss row says the last pull used a different build`
- [x] WHEN the build matched, THE ROW SHALL say nothing about it. proves: `no build line when the pull matched the plan`
- [x] WHEN Hindsight is not loaded, or its saved layout is not the one known, THE ADDON SHALL show nothing and raise no error. proves: `no error without hindsight or with a new layout`
<!-- AC:END -->

## Tasks

- [x] Guard on `HindsightDB.schema == 1`; anything else means "unknown layout, show nothing".
- [x] Read only. Never write to Hindsight's tables.
- [x] Offline checks with a pretend `HindsightCharDB`.
- [x] The planned string is the plan cell's own `talents` through `PlanTab.plannedTalents`, never
  the saved loadout (Rob, 2026-09-22, Option A), and it judges only when the row's loadout is the
  one the cell was simmed under, the same guard as `0014`.

## Comments

- 2026-09-22 Claude: written from Rob's "B" in a SecondBrain session. Ideation only. Hindsight's
  saved layout is private and can change with any update.
- 2026-09-22 Claude: built, not seen in a client. Each boss row on the Plan tab can end with
  "last pull: other build, as Feral" (or Guardian, Balance, Restoration), red on the picked boss
  and grey on the rest, following the tab's rule that only the picked boss is judged loudly.
  What is read: `HindsightDB.schema` must be 1 and `HindsightCharDB.pulls[tostring(encounterID)]`
  must be a table, else nothing is read or drawn. The pull's `specKey` and `build` are compared
  with the plan: another spec is another build whether or not a string was saved (Rob's real
  file has Guardian pulls with no `build`), the same spec compares the pull's string with the
  import string of the saved loadout named on the row through `talentStringsDiffer` (card 0014).
  The planned string comes from the game's own saved loadout, so a boss whose loadout is not
  saved in the game says nothing rather than guessing. Everything is read only.
  New in `PlanTab`: `savedLoadoutString`, `HINDSIGHT_SPEC`, `hindsightPulls`, `pullSpec`, and
  `savedLoadoutNames` now maps name to config id (still truthy for its one caller). No new
  top-level local. Checks: 21 under the three criterion names, on a pretend `HindsightCharDB`
  and as drawn. Both interpreters exit 0. Two mutations went red: the schema guard removed
  (2 checks), and the other-spec branch removed (2 checks).
  In the game, with Hindsight loaded, please look at: (1) the Plan tab after a pull on a
  planned boss with the planned loadout loaded, which should show no pull line for that boss.
  The risk is a false red: Hindsight's `build` is its own encoder's string, verified
  byte-for-byte against `C_Traits.GenerateImportString` by `/hind encode` but only for the
  active config. If it draws red after a pull on the right loadout, the compare needs to move
  from the whole string to the node bits, as the 0014 note says. (2) The same tab after a pull
  on Guardian, which should read "last pull: other build, as Guardian". (3) Disable Hindsight
  and open the tab: no pull lines, no error.
  Left out: a fallback to the plan cell's own talent string when the loadout is not saved in
  the game (only two cells carry one); Hindsight's grades, as the card says.
- 2026-09-22 Claude (review, bounced to todo): attacked the three criteria, the code at
  `savedLoadoutNames`, `savedLoadoutString`, `hindsightPulls`, `pullSpec`, `HINDSIGHT_SPEC` and the
  boss loop in `lines`, and the checks. Hindsight's shape verified against its installed 1.8.9
  source and Rob's saved files, not the card: `Rotation.lua` 1371 to 1373 writes
  `HindsightCharDB.pulls[tostring(p.encounterID)] = p` with `p.specKey` from `CurrentSpecKey`
  ("Druid:Restoration" for Resto, so the `HINDSIGHT_SPEC` map is right) and `p.build` set only when
  its own encoder produced a string (`Rotation.lua` 1271); `HindsightDB.schema` is stamped at
  `ADDON_LOADED` (`Core.lua` 3459) and is 1 in the account file, which also holds
  `encoderOK = true`. On Djinni-Bloodfeather the 15 pulls are Guardian, Balance and Restoration, four
  with a `build`, none Feral, so in the game today every planned row but Mythic+ will read "last
  pull: other build, as <spec>" and the same-spec string compare has never run on a real pull.
  `GenerateImportString` and `GetLoadoutSerializationVersion` are in `SharedTraitsDocumentation.lua`,
  `AllowedWhenUntainted`, not secret-restricted. Both interpreters exit 0, 177 top-level locals. Ten
  mutations in a temp copy, eight red (schema guard, other-spec branch, compare forced equal,
  number key not stringified, picked row not red, prefix not stripped, pulls type unchecked, the
  new encoder guard); two survived and are benign, both change no result (`specKey` type unchecked
  still returns nil, no id still looks up "nil").

  **Fixed in place, two.** (1) The self-test drew its `wrong`, `right`, `unknown` and `touched`
  fixtures with whatever `HindsightDB` really holds, so in the game with Hindsight loaded `/bis test`
  went red on three checks ("a match is not red", "unknown is never red", "not loaded draws no pull
  line") while the feature worked: proved offline by setting Rob's live state (schema 1, Twin Fangs
  last pulled as Balance) before the draw. `HindsightDB` is now nil for those four draws and put
  back after. (2) The pull's string is Hindsight's own encoder's, which its `VerifyEncoder` checks
  byte for byte against `C_Traits.GenerateImportString` and records in `HindsightDB.encoderOK`; on a
  mismatch Hindsight disables its own import strings but still writes `p.build`, so a client build
  that breaks the encoder would have drawn a false red on every same-spec pull. The string compare
  now runs only when `encoderOK == true`; another spec is still said. Two checks added.

  **What broke, and why this is a bounce: the "planned" string is the one thing a hand edit
  overwrites.** `savedLoadoutString` reads `GenerateImportString` on the saved loadout named on the
  row. Blizzard's talent frame writes a hand edit into that loadout on Apply: `ApplyConfig` in
  `Blizzard_PlayerSpells/ClassTalents/Blizzard_ClassTalentsFrame.lua` 1133 to 1148 calls
  `C_ClassTalents.SaveConfig(selectedConfig)` when nothing is pending and `CommitConfig(selected)`
  when it is, the same finding that bounced `0014`. So the case the Why names (Rob moves a point,
  applies, pulls, wipes, asks whether it was the build) draws nothing: the pull's string equals the
  loadout's, because the loadout is now the edited build. The reverse is a false red: a pull on
  the clean loadout reads "other build" the moment a later edit is applied to it. The compare is
  "pull against the loadout's current contents", not "pull against the plan", and criterion 1 is
  unticked for that case. It could not be settled offline because the checks stub the planned
  string. The fix is Rob's call, and it is the same call as `0014`, which this card `needs:` and
  which sits in `todo/` on exactly this point: compare against the plan's own `talents` string
  (`GEAR_PLAN`, only the ST and Mythic+ cells carry one today, so the other three loadout names
  would need one baked in by `update-gear-plan.ps1`, or say nothing) or accept the saved loadout
  and say on the row that a hand edit applied to it counts as the plan. Whichever it is, 0014 and
  0023 must read the same thing.

  Smaller, for the rebuild, not fixed here: `savedLoadoutString` calls `savedLoadoutNames` once per
  distinct loadout name per draw (five spec-wide list reads); in combat it returns nil so a
  same-spec line vanishes mid-fight and comes back after, where `0014` chose to hold the last
  reading instead. Neither errors.

  Security, for the record: weakest point is a read of two third-party tables on every tab draw,
  bounded by the schema and type guards, no loop past the ten boss rows; unchecked path none, the
  talent reads are pcalled, Hindsight's tables are never written and a pull with a non-string
  `specKey` is skipped before `gsub`; leaks nothing, the strings never print and never leave the
  client.
- 2026-09-22 Claude (rebuilt on Option A): the pull is now judged against the plan cell's own
  `talents` string, never the saved loadout. The boss loop in `PlanTab.lines` calls
  `PlanTab.plannedTalents(spec, row.scenario)` (card 0014, signature kept) and hands
  `PlanTab.pullSpec` that string only when the loadout it was simmed under is the row's own
  loadout, the guard 0014 wrote for `activeLoadoutName`; otherwise, or when the cell has no
  string, the pull's string is not judged. Another spec is still said whatever the string, as
  before: a Guardian pull is not a Feral plan and needs no string to say so. The `encoderOK`
  guard from the review stays. `PlanTab.savedLoadoutString` is deleted, its only caller gone; the
  in-combat gap the review named goes with it, since the cell's string is a table read.
  `savedLoadoutNames` still maps name to config id (its comment no longer names the deleted
  reader). `pullSpec`, `hindsightPulls`, `talentStringsDiffer` unchanged. No new top-level local
  (177). What that means with today's data: only the two `st` rows on "DotC Raid ST *" (Entombed
  Sentinels, Sszorak) are judged by string; the "WS Raid" rows and the 2 target rows are judged by
  spec alone until `0028` gives each loadout its cell.
  Checks retargeted, 30 under the three criterion names: the fixture pulls sit on the rows the
  rule needs (other build on the cell's loadout, the matched one, the 2t cell without a string,
  a row whose loadout is not the cell's, another game build's header, other spec, no string, no
  spec), proved through `pullSpec` and as drawn with nothing stubbed but `activeLoadoutName`. New:
  the three "says nothing" cases (cell without a string, both by the 2t cell and by taking the
  `st` cell's string away and putting it back; pull without a readable string; header mismatch),
  the loadout-name guard, and `C_Traits.GenerateImportString` counted at zero across every draw,
  which is the proof the saved loadout is never read. Both `lua offline-check.lua` and Lua 5.1
  exit 0. Two mutations in a temp copy, both red: the loadout-name guard removed (1 check, the
  "row's loadout is not the cell's" draw), the planned string forced nil at the call site (2
  checks, the red picked row and the grey unpicked one). Not seen in a client.
- 2026-09-22 Claude (review of the Option A rebuild, to human-review): attacked the three criteria,
  `PlanTab.pullSpec`, `hindsightPulls`, `savedLoadoutNames`, the boss loop in `lines`, the
  deletion of `savedLoadoutString` (no caller left, grep clean), and the 31 checks. Coherent with
  the merged 0014 review: both read `PlanTab.plannedTalents` and hand the string on only when the
  cell's `loadout` is the one in question (`activeLoadoutName` against the loaded name, this card
  against the row's), and `talentsEdited`'s per-string hold is not touched by this card. APIs
  re-checked against `wow-ui-source` `Blizzard_APIDocumentationGenerated`: `GetConfigIDsBySpecID`,
  `GetLastSelectedSavedConfigID`, `GetStarterBuildActive` (ClassTalents), `GenerateImportString`,
  `GetConfigInfo` (SharedTraits, `AllowedWhenUntainted`), `GetSpecialization`,
  `GetSpecializationInfo` (SpecializationInfo); nothing from `Blizzard_Deprecated*`. Hindsight
  1.8.9 re-read from the installed source: `Rotation.lua` 1197 `p.specKey = CurrentSpecKey()`, a
  plain string by its own comment; `Core.lua` 3459 stamps `schema`; `Encode.lua` 464 to 530 sets
  `encoderOK` true or false. Both interpreters exit 0; 177 top-level locals, none added.
  Held: the schema and type guards, the string-key lookup, the `encoderOK` and loadout-name guards
  (both mutated red again here: "encoder unverified, no string compare" and "the row's loadout is
  not the cell's, drawn"), `GenerateImportString` counted at zero across the draws, and every
  fixture global put back.
  **Fixed in place, one.** `pullSpec` type-guarded `pull.specKey` and then compared it and, on the
  row, `gsub`'d it, but `type()` passes a secret (DECISIONS.md 2026-08-21) and the rule for a
  third-party table is canRead before any compare. Now `PlanTab.canRead(pull.specKey)` or nothing
  is said; one check, "a secret spec key says nothing", red with the guard removed. Also the loop's
  inner `local planned` shadowed the loot-spec `planned` table two lines up inside its block; it is
  `cellString, cellLoadout` now, no behaviour change, so the next merge in this loop (HANDOVER names
  it as one of three conflict points) cannot pick the wrong one.
  Security: weakest point is still two third-party tables read on every tab draw, bounded to the
  ten boss rows by `BOSSES`, every field type-guarded and now canRead-guarded; unchecked path none,
  `encoderOK` is read only after `hindsightPulls` proved `HindsightDB` a table, nothing in Hindsight
  is written, no talent API is called by this card at all; leaks nothing, the pull string never
  prints and the only text drawn is the spec name after its class prefix.
  Not seen in a client; the looks below stand.

## What I need from you

With Hindsight loaded, as Feral:

1. Open `/bis`, Plan tab. On today's saved pulls (Guardian, Balance, Restoration, none Feral)
   every raid row should end "last pull: other build, as Guardian" (or Balance, Restoration),
   grey except the picked boss in red. Mythic+ says nothing.
2. `/bis test` with Hindsight loaded: no red. Only the game can show this with real pulls.
3. Pull Entombed Sentinels or Sszorak on "DotC Raid ST *", untouched. The row should say nothing.
   If it goes red, Hindsight's string and the cell's baked string differ past the header and the
   compare has to move to the node bits (0014 task 2), or the cell needs re-baking from this
   client (0014 item 4).
4. Move one point by hand, Apply, pull the same boss again. The row should now say "other build,
   as Feral". This is the criterion the saved-loadout compare could not meet.
5. Pull Nek'zali on "WS Raid Most Bosses", clean, then with a point moved. The row says nothing
   either time: that loadout has no cell of its own until `0028`, so only the spec is judged.
6. Disable Hindsight, open the tab: no pull lines, no error.
