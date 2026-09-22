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
