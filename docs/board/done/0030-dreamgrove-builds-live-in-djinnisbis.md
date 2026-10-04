# 0030 Dreamgrove's builds live in DjinnisBiS, one per boss and spec

## Why

Rob, 2026-09-23: "DjinnisBiS, using Dreamgrove's builds. I would actually suggest we merge them and
remove DjinnisDreamgrove going forward." Two addons picking talents per boss disagreed: the boss
table here names DjinnisDreamgrove 0.6.0 loadouts (`WS Raid Most Bosses`, `DotC Raid ST *`), and
Dreamgrove 0.7.0 renamed them `Raid: <boss>`. Running `/dg tidy` today would orphan this table.

Dreamgrove itself moved Feral to one build per boss on 2026-09-18; six of nine bosses are now
Wildstalker.

## What

- The generator in `C:\Dev\WoWAddons\.dreamgrove-tmp\` (`extract.py`, `gen_data.py`) moves into
  this repo as author tooling beside `update-gear-plan.ps1`, and writes a `BEGIN GENERATED BUILDS`
  block into `DjinnisBiS.lua` the way the gear plan block is written.
- Every row of `PlanTab.BOSSES` gets its own `talents` string and a `build` name, for all four
  specs, not only Feral. Names are the ones Rob accepted in Dreamgrove 0.7.0: `Raid: <boss>`,
  `Dungeon`, `Dungeon: <when>`.
- `PlanTab.plannedTalents` answers for a boss row first and falls back to the scenario cell.
  The gear plan cells keep their simmed `talents`; they say which build the gear was simmed on.

## Built, v0.26.0, 2026-09-23

- `update-builds.py` fetches the four compendiums with `gh api` and Raidbots' `talents.json`,
  checks every build is its own spec with 34 / 34 / 13 points, and writes `PlanTab.BUILDS`.
  28 builds.
- `PlanTab.buildFor(spec, name)` is the one lookup: Dreamgrove's build for the name, else the
  gear cell simmed under it. The Plan tab, the sidebar, the "edited" mark, Hindsight's
  last-pull line, the /simc export and the setup prompt all go through it or the rows.
  `plannedTalents` is left for the gear cells, which is what it always described.
- Feral rows renamed to one build per boss. **Balance got rows too.** Ula'tek has no Balance
  build in the guide, so its row borrows `Raid: Vashnik`, marked uncertain in the code.
- **Guardian and Resto have no rows.** The guide gives two raid builds each and does not say
  which fits which boss. That is Rob's pick.
- The setup prompt now offers the scenario's first boss row's loadout (Mythic+: `Dungeon`),
  not the gear cell's simmed name, so the prompt and the Plan tab agree.
- `lua offline-check.lua`: self-test passed, with new checks that every row has a stored
  build and that `buildFor` prefers Dreamgrove's.

**To look at in a client.** `/reload`, then open the Plan tab as Feral and as Balance. Each
boss row names a `Raid: <boss>` loadout. Those loadouts exist only if DjinnisDreamgrove 0.7.0
already imported them; if not, the rows show and the Talents button says the name is not
saved. Card `0031` makes them.

## Not this card

- Creating the loadouts in the game. That is `0031`.
- Retiring DjinnisDreamgrove. That is `0035`.

## Acceptance

- [x] WHEN the generator runs, THE SCRIPT SHALL refuse to write if a picked build is missing from a compendium page, or decodes to the wrong spec. proves: none, `update-builds.py` has no suite; its refusals were probed by the 2026-10-04 review
- [x] WHEN a boss row has a `talents` string, THE ADDON SHALL treat it as the planned build for that boss. proves: `every boss row has a stored build, Dreamgrove's before the gear cell`
- [x] `/bis test` covers `plannedTalents` for a boss row with and without its own string. proves: `every boss row has a stored build` (one line per row), `every boss row has a stored build, the gear cell's for its own name`
- [x] The build decodes to 34 class, 34 spec and 13 hero points for every row (`choices.py` check, carried over). proves: none, `update-builds.py` refuses any other count on every write, and `--check` said current on 2026-10-04

## Comments

**2026-09-29** Attended unblock pass. This card was built at v0.26.0 (commits `6a0ec78` and
`c986b4b`) and put in `human-review/` without an adversarial review: it has no review entry and
no `## What I need from you`. Three of its four criteria are checks an agent can run (the
generator's refusal, the offline self-test, the 34 / 34 / 13 decode). Only the Plan tab look
needs a client, and its expectation is stale: Balance's rows are `Raid: Nek'Zali, Altar` and
`Raid: Cleave` since card `0064` regrouped them, not one `Raid: <boss>` a boss. So it goes to
`ai-review/`. The reviewer names each criterion's proving check, and writes a current in-game ask
if the card then needs Rob.

**2026-10-04** REVIEW (adversarial, separate agent). Holds, after one check was made able to fail.
To `done/`. The criteria were never ticked; I ticked them from the runs below and named each one's
proof on its line. The code has moved a long way since v0.26.0 (Warcraft Logs builds, card 0064;
`plannedTalents` is now `buildFor`), so this reviews what the card promised, in today's code.

Attacked:
- `offline-check.lua` under Lua 5.1, self-test, 250 and 62: "no FAIL lines".
  `python update-builds.py --check`: "BUILDS block already current".
- The generator's refusals, by a probe that loads `update-builds.py` and runs it against Raidbots'
  live `talents.json`: a Guardian string offered as Feral is refused (spec 104), a cut-short Feral
  string is refused (29 spec points, 2 class), and with the guide and Warcraft Logs both emptied,
  `block()` exits "the guide no longer has ... Change PICK, do not guess" and writes nothing.
- `buildFor`'s order, by swapping it on a temp copy (gear cell first). **Every check passed**:
  no gear cell shares a name with a stored build, so "Dreamgrove's before the gear cell" could not
  fail. Fixed in place in `41632e2`: the check puts a gear cell named "Raid: Sszorak" in for
  itself and takes it out. With the order swapped it now fails.

Minor, not blocking:
- Two Feral gear cells name their loadout `[CP] Raid: Nek'Zali` and `[CP] Raid: Lost Explorers`:
  `update-gear-plan.ps1` copies the tagged name out of the Raidbots report. `buildFor` is asked
  with untagged names, so those cells' talents are never its fallback. Nothing is lost today,
  because the stored builds have both names. The script should strip the tag (card 0059's trap).
- The old ask ("each boss row names a `Raid: <boss>` loadout") is stale, as the 2026-09-29 entry
  says, and Rob has raided on these builds since; the in-game side is covered by cards 0031 and
  0064. No ask is written.

Security: author tooling and data. The generator reads GitHub through `gh`, Raidbots and Rob's
own Warcraft Logs JSON, and writes only strings that pass the spec and points check, escaped as
Lua strings. Nothing leaves the client at run time.

Not looked at in a client: there is none here.
