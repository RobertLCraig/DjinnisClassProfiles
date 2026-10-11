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
- [x] #4 WHEN Rob runs two dungeons in a live client, `Logs\` SHALL hold one new file for each. proves: manual (read off `Logs\`, 2026-10-11: see Comments)
<!-- AC:END -->

## Comments

**2026-10-11** Clear-down (attended, Rob asked). Read `C:\Games\World of Warcraft\_retail_\Logs\` (read only). Since 2026-09-30 there are 11 `WoWCombatLog-*.txt` files, each opening on a `ZONE_CHANGE` into an instance: for example 2026-10-01 15:10 opens in Temple of Sethraliss and 19:52 in Kings' Rest, two files on one evening. Two files half an hour apart on 2026-10-10 (16:01 and 16:33) show that each `LoggingCombat(true)` opens a new file, which was the open question under Not proven. So #4 is ticked and the card goes to done/.

Two limits seen in the same files, neither a fault of the criteria as written:
- **The garrison turns logging on.** 2026-10-08 11:17 (2.5 KB) and both 2026-10-10 files open in instance 1159, Lunarfall: `GetInstanceInfo` calls a garrison `party`. Raised as card 0089.
- **Instance to instance with no open world between them is one file.** 2026-10-08 18:23 runs 2813, 2923, Kings' Rest, Ruby Life Pools, Karazhan and Emerald Dreamway back to back in one 287 MB file, because the off switch waits for a zone-in outside an instance. A new file per instance would be one more rule in `PlanTab.autoCombatLog`; no card is raised for it, since the criteria ask for one file per run with the open world between runs.
