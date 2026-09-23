---
needs: 0048
---
# 0049 DjinnisBiS works on every class, not only druids

## Why

Rob, 2026-09-24: "Expand this to work for all classes (not just druids)". His characters include a
Death Knight, a Shaman, Hunters, Rogues, Monks and a Demon Hunter (from SavedInstances).

## What

- `SPEC_BY_ID` (`DjinnisBiS.lua`, near `playerSpec`) knows only 102 to 105. It becomes every
  spec, keyed by spec id. Spec names repeat across classes (Frost, Restoration, Holy), so the key
  must carry the class: for example `Frost DK` and `Frost Mage`, or the id itself. Druid names stay
  as they are, so saved data (`db().bars.Feral`, the loadout names) keeps working.
- Talents: the loadout list, the spare loadout, the Reset to plan flow and the boss reminder work
  for any spec that has stored builds (card `0050`).
- Bars: Save, Load, Undo, profiles and the preview already work per spec key. They must work under
  the new keys.
- Gear plan and boss rows stay druid-only (`0048` question 2, decided: later). On another class
  they say so in one line, and do not error.
- `/djbis test` passes, with checks on a non-druid spec (for example 250 Blood).

## Acceptance

- [x] WHEN a non-druid logs in, THE ADDON SHALL load with no error and offer its bar and talent features for that spec. proves: a new `offline-check.lua` run as spec 250
- [x] WHEN a druid logs in, THE SAVED DATA SHALL still be found under the old keys. proves: the existing checks, unchanged
- [ ] Rob logs in on one alt and sees the list and the bar buttons. proves: manual

## What I need from you

On one alt that is not a druid (the Death Knight, say), after `/reload`:
1. Open the talent window. Pass: the list beside it shows, titled "Blood builds" (your own
   loadouts) or "No stored builds for Blood yet". Stored builds come with card `0050`. Fail: a Lua
   error, or no list.
2. `/djbis bars save`. Pass: it says the bars are saved for your spec. Then `/djbis bars undo` works.
3. Hover any piece of gear. Pass: no "BiS" or "Not BiS" line.
4. `/djbis here`. Pass: one line saying the BiS list is druid gear.

## Comments

**2026-09-24** Builder, v0.41.0.
- `PlanTab.SPECS` holds all 40 specs as { id, key, class id, role }, from Raidbots' talents.json.
  `SPEC_BY_ID`, `PlanTab.CLASS_OF` and `PlanTab.ROLE_SPECS` (class, then role) are built from it.
  Druid keys are unchanged. A name two classes share carries the class: `Frost Mage`, `Frost Death
  Knight`, `Holy Paladin`, `Holy Priest`, `Protection Paladin`, `Protection Warrior`,
  `Restoration Shaman`.
- The group finder's role prompt (`specForRole`) now picks among the class's own specs. Before, a
  Death Knight accepted as tank was offered Guardian. A Mage asked to tank gets no prompt.
- `PlanTab.gearHere()` (the class is druid) gates what is druid gear: the tooltip's BiS and plan
  lines, the loot roll and boss kill verdicts (a raid warning and sound on every kill, on any class,
  before this), `/djbis here`, the journal pool walk, the loot spec card and the KeystoneLoot send.
  The Plan tab's no-plan text on another class is one line: "Gear plans are for druids only, for
  now."
- The bar messages no longer say bars "are for druids"; with every spec known, a nil spec means the
  game has not said the spec yet.
- The pool walk now filters the journal by the player's class and that class's specs only. It set a
  druid spec on the player's class before, which on a non-druid was a nonsense filter.
- Left as is: the main window (`/djbis`) is the druid gear browser, with its four druid spec
  buttons, on any class. Hindsight's spec keys stay druid: they are read only for boss rows.
- Checks: `PlanTab.specChecks` (40 specs, keys once, druid keys, shared names, the one line), and
  five role checks. `offline-check.lua <spec id>` loads as that spec, types 11 slash commands, hovers
  a helm and fires `ENCOUNTER_END` and `CHALLENGE_MODE_COMPLETED`. All 36 non-druid specs pass
  under Lua 5.1 and 5.4. The self-test passes under both.
- Mutations on a `$TEMP` copy, each caught: `gearHere` always true (spec 250 run: 2 FAIL lines), the
  roll event gate removed (2), roles druid-only (5), "Frost Mage" renamed "Frost" (1), the one-line
  text removed (1). Run as 103, the spec mode fails as it should, because Feral gets the gear lines.
- Found on the way: the first version of the checks pushed `selfTest` past Lua 5.1's 60 upvalues.
  The error prints no FAIL line, so a filtered run looked green. The checks moved to
  `PlanTab.specChecks`, as the handover says, and the handover now warns to read the output whole.
- Deployed with `-WhatIf -Only DjinnisBiS` first: 2 files, 0.40.1 to 0.41.0.
