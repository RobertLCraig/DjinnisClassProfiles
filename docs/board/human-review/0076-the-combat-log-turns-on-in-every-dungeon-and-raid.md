# The combat log turns on in every dungeon and raid

## Why
On 2026-09-29 Rob turned `/combatlog` on by hand part way through a +10 Voidscar Arena, so the log
(`WoWCombatLog-092926_200357.txt`) starts at the second boss. The first half of the key is lost.

## What was built (v0.55.0)
`PlanTab.autoCombatLog()` runs 2 s after every `PLAYER_ENTERING_WORLD`, on the setup watcher that
card `0013` already arms for every class. Inside a `party` or `raid` instance, with logging off, it
calls `LoggingCombat(true)`, the call Blizzard's own `/combatlog` makes. It never turns logging off.
Blizzard prints its own chat line, so the addon says nothing. `PlanTab.combatLogChecks` covers it
offline, and was broken on purpose once to prove it runs.

EnhanceQoL has the same option (`Settings/CombatDungeon.lua`). If both are on, the second call
finds logging already on and does nothing.

## Acceptance
<!-- AC:BEGIN -->
- [x] #1 WHEN the player enters a dungeon or raid with logging off, IT SHALL turn logging on. proves: `combatLogChecks`
- [x] #2 WHEN logging is already on, or the player is outside an instance, IT SHALL do nothing. proves: `combatLogChecks`
- [ ] #3 WHEN Rob zones into a dungeon in a live client, chat SHALL show Blizzard's "Combat being logged" line. proves: none
<!-- AC:END -->

## Comments
