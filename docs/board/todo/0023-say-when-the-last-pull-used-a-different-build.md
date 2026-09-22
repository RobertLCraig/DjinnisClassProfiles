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
- [ ] WHEN Hindsight has a saved pull for a planned boss and its build differs from the planned loadout, THE PLAN TAB SHALL say so on that boss's row, with the spec used. proves: `boss row says the last pull used a different build`
- [ ] WHEN the build matched, THE ROW SHALL say nothing about it. proves: `no build line when the pull matched the plan`
- [ ] WHEN Hindsight is not loaded, or its saved layout is not the one known, THE ADDON SHALL show nothing and raise no error. proves: `no error without hindsight or with a new layout`
<!-- AC:END -->

## Tasks

- [ ] Guard on `HindsightDB.schema == 1`; anything else means "unknown layout, show nothing".
- [ ] Read only. Never write to Hindsight's tables.
- [ ] Offline checks with a pretend `HindsightCharDB`.

## Comments

- 2026-09-22 Claude: written from Rob's "B" in a SecondBrain session. Ideation only. Hindsight's
  saved layout is private and can change with any update.
