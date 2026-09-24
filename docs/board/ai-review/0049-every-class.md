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
5. Open the character sheet. Pass: the strip under it says "Gear plans are for druids only, for
   now." and has no scenario button.
6. On your next loot roll: no glow on the item's icon, and no "[BiS]" line in chat.

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

**2026-09-24** Adversarial review of `9936f19` (v0.41.0). **Verdict: findings, back to `todo/`.**
The spec table is right and the bars and role prompt hold. But one druid gear surface still reaches
every class: the loot roll glow. And the new spec mode cannot see that kind of leak.

What held:
- Harness, read whole, under Lua 5.1.5 and 5.4.6. The self-test exits 0 with "self-test passed".
  All 36 non-druid spec runs exit 0, 14 lines each. All four druid runs exit 1: 103 as designed,
  and 102, 104 and 105 the same way ("Not BiS" and the RaidWarningUtil stub).
- `PlanTab.SPECS` against Raidbots `talents.json` (fetched today): 40 of 40 spec ids and class ids
  match. Every name matches except `Resto`, which is the old druid key on purpose. The roles are the
  game's (Augmentation and Devourer damage, Vengeance and Brewmaster tank). `wow-ui-source` has no
  static role table to settle them. It names 1480 "Devourer DH" (`TrackedCooldowns.lua:35`).
- Saved data. Druid keys are unchanged and the self-test still finds them. All 40 keys are unique.
  None holds " / ", so a spec key cannot collide with a build key. Profiles live in their own table.
- The role prompt. `specForRole` stays inside the class, and a Mage asked to tank gets nothing.
  `specIndexOf` walks 1 to 4 under `pcall`, so three-spec classes and Devourer (index 3) resolve.
  A non-druid already in the role gets no prompt: `setupSteps` has no plan, so no steps.
- Other gates read right: tooltip, `/djbis here`, roll and kill verdicts, loot card, pool walk,
  KeystoneLoot, bag glows (no plan, so an empty wanted list), stat lines (no `STAT_TARGET`), the
  wrong-setup popup and `simcAppend` (no `BOSSES` row).
- No new global writes. A `luac -l` SETGLOBAL list of the file before and after is identical. No
  new main-chunk local. The game folder's `.lua` and `.toc` are byte-identical to `9936f19`.
- Mutations on a `$TEMP` copy. Caught: `playerClass` ignoring the spec, `specForRole` ignoring its
  class argument, Blood's id changed, the `/djbis here` gate removed.

**Finding 1 (bug): the loot roll glow shows druid gear on every class.** `PlanTab.markRollFrame`
(line 2213) calls `planLinesForLink` with no `gearHere()` gate. A probe ran as 250 Blood and 264
Restoration Shaman. It rolled Pendant of Malefic Fury (251142, a neck in Feral's plan), and the
hook answered `true`: the glow shows. The tooltip on that roll is gated, so the frame glows and the
hover says nothing. Fix: gate `planLinesForLink` itself, so every caller is covered, or gate
`markRollFrame`.

**Finding 2 (test gap): the spec mode cannot catch a plan line.** It hovers item 1, which is in no
plan, and it fails only on text holding "BiS". Plan lines read "Feral raid: in plan". Mutation:
ungate `planLines` in the tooltip. The 250 run stays green, and the probe shows "Feral raid: in
plan" on a Blood tooltip. Fix: hover 251142 and fail on any added line. Also fire the roll hook.

**Finding 3 (test gap): four gates and the role data have no check that can fail.** These
mutations survived the self-test and the 250 and 1480 runs: the `lootCardModel` gate removed, the
`sendToKeystoneLoot` gate removed, the `harvestPools` gate removed, the pool walk's class filter
removed, Devourer made a tank, and Vengeance made damage. Also, `lua offline-check.lua 9999` exits
0. An unknown id runs as "no spec", so a wrong id in `SPECS` passes its own spec run. Fix: the spec
mode fails when the id does not resolve to a key. Add non-druid checks that `lootCardModel` and
`sendToKeystoneLoot` answer nil. Pin a role or two per class in `specChecks`.

**Finding 4 (wording): the character sheet still offers a gear plan on another class.** The strip
reads "No 1 target gear plan for Blood yet. Click for how." Its scenario button still cycles. The
Plan tab shows the four scenario buttons above the one line. The card says a gear surface says so
in one line. Fix: on `not gearHere()`, the strip says "Gear plans are for druids only, for now."
and the scenario button and the Plan tab choices hide.

**Finding 5 (druid assumption): `/djbis tidy` works on any class.** `PlanTab.RETIRED` holds
DjinnisDreamgrove's druid names. Several are generic, such as "Raid: Vashnik", "M+ Apex" and
"Dungeon: heal only". On a Death Knight, tidy would list a hand-made loadout with one of those
names as an old Dreamgrove loadout, and `tidy yes` deletes it. The code path predates this card.
But this card is the one that says the addon works on every class. And card `0050` brings
"Raid: <boss>" names to other specs. It needs "tidy yes" after a listing, so it is not silent.
Fix: tidy says "No old Dreamgrove loadouts on this spec." when the class is not druid.

Security:
1. Weakest point: druid-only is enforced at eight call sites, not at the data. Every new consumer of
   `planIndex` has to remember the gate. The roll glow is the one that did not (finding 1).
2. Unchecked: the spec id from the game goes through `SPEC_BY_ID`, and an unknown one is nil. So a
   spec added in a patch reads "The game has not said which spec you are in yet" for good. That is
   wrong, but it is safe. Saved keys are only matched as exact strings. Nothing new is read from
   another player.
3. Leaks: nothing leaves the client. The one outward send, to KeystoneLoot, is gated. Failures
   print only to the player's own chat.

No browser or client here. For Rob, once this is fixed, add to the alt checks above: 5. Roll on any
item in a group (or watch a roll in a raid). Pass: no glow on the roll icon for a piece a druid
plan holds. 6. Open the character sheet. Pass: the strip says gear plans are for druids, with no
scenario button.

**2026-09-24** Builder, v0.41.1: the five findings.
1. The roll glow: `PlanTab.planLinesForLink` returns `{}` off a druid. The tooltip, the roll's chat
   line and `markRollFrame` all read it, so one gate covers all three.
2. The spec run now hovers the first item of the gear plan block, by its real id and name (a helm
   in Feral's plan), and fails on ANY tooltip line. It also fires `START_LOOT_ROLL` for that item,
   and fails on any "[BiS]" chat line during the three events. A spec id not in `PlanTab.SPECS`
   fails the run. As 103 the run now fails 8 ways, as designed.
3. Each gate returns "not druid" and sits first in its function: `harvestPools`, `lootCardModel`
   (second return), `sendToKeystoneLoot`, `tidy`. `PlanTab.specChecks` swaps only
   `PlanTab.playerClass` (never a Blizzard global) and checks each, plus the plan lines. The pool
   walk's class filter is `PlanTab.poolSpecs(classID)`, checked for 11 and 6. The tank and healer
   lists are checked in full: nothing on disk states roles, so the check is the record.
4. The character sheet strip is `PlanTab.stripText` and `PlanTab.stripScenario`: off a druid it
   reads "Gear plans are for druids only, for now." with no scenario button. The Plan tab hides its
   scenario buttons there too. Both checked.
5. `/djbis tidy` off a druid says "Nothing to tidy: the old loadouts were only ever made on
   druids." and deletes nothing.
- Mutations on a `$TEMP` copy, 13, each caught: every gate above, the class filter, a swapped role,
  the strip text and button, the roll event gate, the tooltip gate and the `here` gate. The
  plan-lines gate is caught by the self-test. The spec run stays green for it, because the tooltip
  and the roll handler also gate on their own.
- The self-test and all 36 non-druid spec runs pass under Lua 5.1 and 5.4, output read whole.
- Rob's steps 5 and 6 above are the reviewer's two, now in "What I need from you".
