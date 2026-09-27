# 0071 The pre-pull popup asks for worse gear than you wear

## Why

Rob, 2026-09-27, on heroic Coiled Altar, with a screenshot of the popup: "This was originally
helpful. but now it is out of date, its annoying".

The popup asked for three pieces from his bags. Each is worse than what he wears:

| Slot | Popup asks for | Rob wears |
|---|---|---|
| Feet | Miststalker's Striders 298 | Breakwater Boots 318 |
| Finger | Omission of Light 276 | Colubrine Band 308 |
| Main hand | Abyssal Broodfiend's Bardiche 308 | Toxin-Coated Warstaff 334 |

Pressing Equip all would have cost him 26 item levels on the weapon alone, on a raid night.

## What was checked

- The gear plan is `GEAR_PLAN` in `DjinnisClassProfiles.lua`, from a Top Gear sim `simmed =
  "2026-09-21"`. Its header already says it "goes stale the moment a better piece drops, and the
  fix is a fresh Top Gear run". Nothing in the popup acts on that.
- The plan stores the item level Raidbots printed for each slot, so the popup has what it needs to
  see that the worn piece outranks the planned one.
- The Augment rune line on the same popup is right: Rob had none. Keep that line as it is.

## The idea

1. **A slot whose worn item has a higher item level than the planned item is not a problem.** Drop
   it from the popup. The sim never saw that item, so its advice for the slot is void.
2. **Say the plan is old once, not per slot.** When any slot is dropped for this reason, one grey
   line at the bottom: `Gear plan from 2026-09-21 - you have upgraded since. Rerun Top Gear.`
3. **Equip all only equips what the popup still shows.**

Not in scope: comparing stats or sim value. Item level is a blunt test and will sometimes let a
worse piece through. The worn piece was won or crafted after the sim, and Rob picked it. That is the
right default.

## What was built, v0.54.12, 2026-09-27

Rob, mid-raid: "do it for me please".

- `outranks(entry, worn)` beside `slotState`: the worn item level is above the planned one.
  `slotState` no longer says `change` for such a slot. Every gear check routes through `slotState`
  (slot glows, bag glows, the Plan tab, the popup, Equip all), so all of them go quiet on it at once.
- Its enchant and gems are still judged against the plan, so a bare ring still asks for one.
- `PlanTab.wrongHere` sets `wrong.stale` to the plan's `simmed` date when any slot outranks, and
  `PlanTab.setupPopup` adds one grey line: `Gear plan from <date>. You have upgraded since: rerun
  Top Gear.` It only shows when the popup is already up for something else.
- Two offline checks: a 334 piece against a 308 plan is `ok`, and without its enchant is `enchant`.
  `lua offline-check.lua` passes.
- Not checked: the popup in a live client.

## Done when

With Rob's gear from the 2026-09-27 SimC export and today's `GEAR_PLAN`:

1. The Coiled Altar popup shows no feet, finger or main hand line.
2. It shows the stale-plan line with the date `2026-09-21`.
3. The Augment rune line still shows when there is no rune.
4. After a fresh `update-gear-plan.ps1` run, the stale-plan line is gone.
