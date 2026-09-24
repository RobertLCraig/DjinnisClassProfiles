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
- [x] THE ADDON SHALL give its data broker text as "BiS: N off plan" for the current spec and content, and "BiS: on plan" when N is 0. proves: `data broker text counts slots off plan`
- [x] THE PLAN TAB SHALL show the date of the report each plan cell came from, and how many days old it is. proves: `plan tab shows the report date and age`
- [x] WHEN a plan cell is older than 14 days, or older than the last game patch the addon knows, THE AGE SHALL show in amber with "re-sim?" in its tooltip. proves: `an old plan is marked`
<!-- AC:END -->

## Tasks

- [x] `update-gear-plan.ps1` writes the report date into each cell. Check whether it already does. It does: `simmed = "YYYY-MM-DD"` per cell, from `simbot.date`. Generator untouched.
- [x] Update the broker text on the same events that redraw the glows.
- [x] Offline checks under the names above.

## What I need from you

1. Hover the minimap button, or read the line on any broker display (ElvUI data text, Titan, Bazooka). It should say "BiS: on plan" or "BiS: N off plan", with N the same as "N slots to fix" under the character sheet. Swap one piece and see it change without opening anything.
2. Open `/bis`, Plan tab, pick Nek'zali. Under "2. Gear to change" there is a line "Report simmed 2026-09-21, N days old". Hover it: a tooltip about the Raidbots report.
3. The plan is from 2026-09-21, so after 2026-10-05 (or after the next client build) that line goes amber and the hover ends "Re-sim?". If you would rather see it sooner, set `PlanTab.STALE_DAYS` to 0 and `/reload`.
4. Cycle the strip's 1 target / 2 targets button. The broker line should follow the switch (the 2 target cell is empty, so it reads plain "BiS" there).
5. From the review: swap a piece while in combat (a training dummy will do), then leave combat. The line should hold its old number during combat and correct itself when combat ends, without a `/reload`. Same on a spec change: switch to Guardian and the line should drop to plain "BiS", back to Feral and the count returns.
6. From the review: hover the "Report simmed" line, then move to an item row above it and back. The item tooltip and the plain-text tooltip should not stick to the wrong row (the rows are pooled and the hover reads whichever of link or tip the row carries).

## Comments

- 2026-09-22 Claude: written from Rob's "B" in a SecondBrain session. Ideation only. The 14 days is
  a first guess; Rob sets it.
- 2026-09-22 Claude: built. Broker text: `PlanTab.brokerText`, `PlanTab.offPlanCount` and
  `PlanTab.updateBroker`, the last called at the end of `rebuildBagWanted`, which the bag-mark
  watcher runs from login on every event that redraws the glows, and which the scenario button
  calls too, so the line cannot disagree with the glows. `buildBroker` keeps the broker object
  on `PlanTab.broker`. Age: `PlanTab.planAge(simmed, now, buildDate)` says days and whether it
  is old. "The last game patch the addon knows" is read as the client build date from
  `GetBuildInfo()` (third return, `BuildDocumentation.lua`), which needs no hand-kept date and
  marks a report simmed before the build the client is running. A report over
  `PlanTab.STALE_DAYS` (14) is old too. The Plan tab's row frame gained a plain-text `tip` hover
  for a row with no item link. No new top-level local (177 before and after), and no generator
  change: the block already carried `simmed` per cell.
  Checks: 30 new, under the three names above, plus the tab as drawn. Both Lua 5.4 and 5.1 exit
  0. Three mutations on temp copies, each went red on its own check: the build-date clause
  dropped from `planAge` ("before the game build" failed), `count == 0` broken in `brokerText`
  ("on plan" failed), the age line not added in `PlanTab.lines` (the three "drawn" checks failed).
  Lua 5.1 also refused a first version for a 60-upvalue limit on `selfTest`; the broker check
  stubs `GetInventoryItemLink` instead of reading `readWorn` and `playerSpec` for that reason.
  Not proved here and needs a person: that the broker line moves on the events (a frame path the
  offline stub cannot fire), the tooltip on the row, and the amber colour on screen.
  Left out: no stale mark on the character-sheet strip or the broker tooltip, only on the Plan
  tab, which is what the card asked for. No per-boss date on the boss rows: one cell feeds the
  drawn section and the line sits under it. Not built: a "days until Raidbots drops the report"
  countdown; the 30-day figure is in the hover instead.
- 2026-09-22 Claude (review): adversarial pass on `313629b`, in a worktree off `ba3951f`. Verdict:
  pass with one trivial fix, to `human-review/` for the looks above.
  Read: `brokerText`, `offPlanCount`, `updateBroker`, `rebuildBagWanted` and the bag-mark watcher's
  event list, `buildBroker`, `attachItemHover` and `renderList` (the `tip` hover), `STALE_DAYS`,
  `isoBuildDate`, `daysSince`, `planAge`, `ageLine`, the age line in `PlanTab.lines`, the strip's
  own slot count, and the two stub lines in `offline-check.lua`. `GetBuildInfo`'s third return is
  `buildDate`, a cstring, per `BuildDocumentation.lua` in the local wow-ui-source; the pattern
  allows the double space a C `__DATE__` puts before a one-digit day. The broker counts the same
  sixteen slots the strip counts (`PLAN_SLOT_INVENTORY` and `SLOT_BUTTONS` are one set), so
  "N off plan" and "N slots to fix" cannot disagree. LibDataBroker's `__newindex` fires
  `AttributeChanged` on `text =`, so a display picks the write up without being told.
  Checks: `lua offline-check.lua` (5.4) and Lua 5.1 both exit 0 before and after the fix.
  Mutations, eleven, in a temp copy, each proved red on its own named check: `offPlanCount` off by
  one, `updateBroker` writing nil, `>` to `>=` on `STALE_DAYS`, the build clause dropped, the build
  compare reversed, the age line not added to `lines`, always amber, the half-day rounding dropped,
  a month mis-numbered in `MONTHS`, `count == 0` broken, and the `updateBroker()` call removed
  from `rebuildBagWanted`.
  What broke: that last one survived. The offline check called `PlanTab.updateBroker()` directly,
  so the one thing the first criterion leans on in the game, that the events which redraw the
  glows also write the line, had no check: delete the call and everything stayed green. Fixed in
  place: the broker check now drives `rebuildBagWanted()` with the stub broker and reads what it
  wrote, and calls it again after the stub is put back so `/bis test` in the game leaves the bag
  list and the real line on the real gear. No new top-level local (177), no new `selfTest`
  upvalue (`rebuildBagWanted` was already one). The mutation goes red now.
  What held, noted for the reader: in combat, or when a worn link is secret, `rebuildBagWanted`
  returns before `updateBroker`, so the line holds its last value rather than blanking, which is
  the DECISIONS rule for a secret. Without LibDataBroker `PlanTab.broker` is nil and `updateBroker`
  does nothing. A row carrying both `link` and `tip` shows the item; the age line has no link.
  `simmed < build` is a string compare of two ISO dates, both plain strings from baked data and
  `GetBuildInfo`, neither a secret candidate.
  Security. Weakest point: none reachable; every input is baked plan data or a client build
  string, matched by pattern before use, and the only output is a count on a broker any addon
  can read. Unchecked path: `GetBuildInfo` is trusted but pattern-matched, and an unreadable date
  never marks a plan old. Leaks: the line says how many slots differ and the tab says a date;
  the report id is not in the broker text.
  Not proved here, only in a client: that the line moves on the events, the tooltip on the row,
  the amber on screen. Items 5 and 6 under "What I need from you" are the review's additions.
