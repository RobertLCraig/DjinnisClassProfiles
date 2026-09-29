# The combat log turns on in every dungeon and raid, and off on the way out

## Why
On 2026-09-29 Rob turned `/combatlog` on by hand part way through a +10 Voidscar Arena, so the log
(`WoWCombatLog-092926_200357.txt`) starts at the second boss. The first half of the key is lost.
The same file then ran on through the next key (Altar of Fangs): one file per night grows huge.
Rob's follow-up: stop at the end of each run and start at the next, so each run is its own file.

## What was built
v0.55.0 turned logging on. v0.56.0 also turns it off, and is the version to test.

`PlanTab.autoCombatLog()` runs 2 s after every `PLAYER_ENTERING_WORLD`, on the setup watcher that
card `0013` already arms for every class. Inside a `party` or `raid` instance, with logging off, it
calls `LoggingCombat(true)`, the call Blizzard's own `/combatlog` makes. On the first zone-in
outside an instance after one (`PlanTab.logInside`), it calls `LoggingCombat(false)`. It never
turns off logging that was started by hand in the open world. A ghost outside the instance
(`UnitIsDeadOrGhost`) is not a leave, so a death does not cut the file. Blizzard prints its own chat
line for each change.

`PlanTab.combatLogChecks` walks one night zone by zone offline. It was broken on purpose twice (the
first rule, then the ghost rule) and failed both times.

EnhanceQoL has the same option (`Settings/CombatDungeon.lua`). If both are on, they may disagree
about turning it off. Keep only one on.

## Not proven
That each `LoggingCombat(true)` opens a new file. The file names carry a start time
(`WoWCombatLog-MMDDYY_HHMMSS.txt`), which suggests it does, but no one has seen two runs make two
files yet.

## Acceptance
<!-- AC:BEGIN -->
- [x] #1 WHEN the player enters a dungeon or raid with logging off, IT SHALL turn logging on. proves: `combatLogChecks`
- [x] #2 WHEN the player leaves the instance alive, IT SHALL turn logging off. proves: `combatLogChecks`
- [x] #3 WHEN logging was turned on by hand in the open world, or the player is a ghost outside, IT SHALL do nothing. proves: `combatLogChecks`
- [ ] #4 WHEN Rob runs two dungeons in a live client, `Logs\` SHALL hold one new file for each. proves: none
<!-- AC:END -->

## Comments
