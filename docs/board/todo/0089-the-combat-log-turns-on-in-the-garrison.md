# 0089 The combat log turns on in the garrison (1159)

## Why

Card `0076` turns the combat log on in every dungeon and raid. It also turns it on in the Warlords
garrison. `Logs\` holds three files that open in instance 1159, Lunarfall, and nothing else:
`WoWCombatLog-100826_111756.txt` (2.5 KB), `WoWCombatLog-101026_160107.txt` (435 bytes) and
`WoWCombatLog-101026_163344.txt` (16 KB).

What it costs: a near-empty log file every time Rob visits the garrison, and logging left running
when he flies out, so the next real run may share a file with whatever came between.

How it came to be: `PlanTab.autoCombatLog` counts an instance as inside when `GetInstanceInfo`'s
type is `party` or `raid`, and the game calls a garrison `party`.

## Links

**Relates to**
- `0076` - the rule this narrows; its 2026-10-11 comment lists the log files that show it.

## Not this card

- A new file per instance when one instance follows another with no open world between them. That
  is a separate limit, noted on `0076`.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN the player enters a garrison (either faction, any garrison level), THE ADDON SHALL not turn the combat log on. proves: `combatLogChecks` (a new case: the garrison read as a `party` instance stays off)
- [ ] WHEN the player enters a real dungeon or raid, THE ADDON SHALL still turn it on, as card `0076` does. proves: `combatLogChecks`
- [ ] WHEN Rob visits the garrison after `/reload`, `Logs\` SHALL gain no new file. proves: manual
<!-- AC:END -->

## Tasks

1. Find how a garrison reads through `GetInstanceInfo` in `C:\Dev\WoWAddons\wow-ui-source\`
   (instance type, difficulty id, map id, and every garrison map id for both factions). Prefer a
   rule a reader can check against Blizzard's source, not a guess.
2. Add it to `PlanTab.autoCombatLog`, and a case to `PlanTab.combatLogChecks`; break the rule on
   purpose once and see the check go red.
3. `"C:\Program Files (x86)\Lua\5.1\lua.exe" offline-check.lua`, exit 0.

## Comments

**2026-10-11** Raised in the clear-down (attended, Rob asked) when card `0076` went to done/.
