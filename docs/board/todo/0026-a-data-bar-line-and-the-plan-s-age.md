---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0005
---
# 0026 A data bar line, and how old the plan is

## Why

To know if anything is off plan, Rob has to open `/bis`. A line on his data bar or minimap
tooltip could say it at a glance: "BiS: 2 slots off plan". The addon already bundles
`LibDataBroker-1.1`.

The plan is baked in from Raidbots reports, and a plan goes stale: a patch, a new drop, a new
Dreamgrove build. Nothing on the Plan tab says how old it is. Raidbots keeps reports for a limited
time, so an old report link may also stop opening.

## Links

- Needs `0005`: the "what differs" count.
- Draws by `0020`'s rules.

## Not this card

- Fetching a new plan. Rob or Claude re-sims, as today.

## Acceptance

<!-- AC:BEGIN -->
- [ ] THE ADDON SHALL give its data broker text as "BiS: N off plan" for the current spec and content, and "BiS: on plan" when N is 0. proves: `data broker text counts slots off plan`
- [ ] THE PLAN TAB SHALL show the date of the report each plan cell came from, and how many days old it is. proves: `plan tab shows the report date and age`
- [ ] WHEN a plan cell is older than 14 days, or older than the last game patch the addon knows, THE AGE SHALL show in amber with "re-sim?" in its tooltip. proves: `an old plan is marked`
<!-- AC:END -->

## Tasks

- [ ] `update-gear-plan.ps1` writes the report date into each cell. Check whether it already does.
- [ ] Update the broker text on the same events that redraw the glows.
- [ ] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "B" in a SecondBrain session. Ideation only. The 14 days is
  a first guess; Rob sets it.
