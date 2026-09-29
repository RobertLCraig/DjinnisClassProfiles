# The other druid spec modes of the offline check fail

## Why
`lua offline-check.lua 104` (and 102, 105) ends with FAIL lines on untouched code. Seen on
2026-09-29 at `2aebf7a`, card `0074`: 5 FAIL lines as spec 104.

- `START_LOOT_ROLL as spec 104: DjinnisClassProfiles.lua:1881: attempt to index global 'RaidWarningUtil' (a nil value)`
- `the roll events as spec 104 printed 1 [BiS] line(s)`
- three `hovering Enigmatic Dreamwatcher's Somnolent Stare as spec 104 adds: ...` lines

Cards `0049`, `0055`, `0059` and `0064` each noted this in prose as known and left it. A mode that
always fails cannot catch anything, so a real fault in these specs would pass unseen.

## Not this card
Not a change to what the addon shows. Decide per line whether the fault is the harness (a missing
stub, an expectation written for a non-druid) or the addon, and fix that one.

## Acceptance
<!-- AC:BEGIN -->
- [ ] #1 WHEN `lua offline-check.lua` is run with 102, 104 or 105, IT SHALL end `no FAIL lines`. proves: none
<!-- AC:END -->

## Comments
