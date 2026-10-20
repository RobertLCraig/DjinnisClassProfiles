# 0071 The pre-pull popup asks for worse gear than you wear

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

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

## Acceptance

<!-- AC:BEGIN -->
- [x] A slot whose worn item has a higher item level than the planned item is not asked for; its enchant and its own sockets still are. proves: `slot state` checks ", not when the worn piece outranks the plan", ", an outranking piece still needs the planned enchant", ", an outranking piece with no socket is not asked for the planned gem"
- [x] The stale-plan line shows when another item outranks the plan, and not for the planned item raised or a lower item. proves: `the popup says the plan is old when another item outranks it`, `the popup does not say the plan is old for the planned item raised`, `the popup does not say the plan is old for a lower item`
- [ ] Raid night as Feral, after `/reload`: when the pre-pull popup comes up, no gear line asks for a piece with a lower item level than the one you wear, and Equip all takes off nothing better than what goes on. proves: manual
- [ ] On the same popup: if you have won a piece since 2026-09-30 that beats the plan's, one grey line says `Gear plan from 2026-09-30. You have upgraded since: rerun Top Gear.`; if not, there is no such line; the Augment rune line still shows when you have no rune. proves: manual
<!-- AC:END -->

## Comments

**2026-09-29** Adversarial review, unattended. Two defects found and fixed in v0.54.13. Moved to
`human-review/` for the one look above.

What was attacked:
- The rule. `outranks` made to return false: both of the build's checks went red. They can fail.
- **Defect 1, fixed.** An outranking piece was still asked for the plan's gems, counted against the
  planned piece's sockets. A newer ring with no socket stayed on the popup as "gem" for good, and
  nothing could fix it. Every Feral ring in the plan has a gem, so this was live. Now another item is
  judged on the sockets it has. An empty socket still asks for a gem. The planned piece is judged as
  before.
- **Defect 2, fixed.** The stale line also showed when you raised the planned piece itself with
  crests. The plan is still right then, and a rerun changes nothing. Now only a different item sets it.
- The stale line had no check. Three added: another item above, the planned item raised, a lower item.
- Rings swapped between fingers: `PlanTab.entries` pairs them first, and an outranking ring is `ok`
  either way round. Holds.
- Equip all and the bag glows read the same `change` marks, so they go quiet with the popup. Holds.
- Criterion 2 as written cannot be met now: the st, 2t and M+ cells were resimmed on 2026-09-28. No
  boss row uses the 3t cell, so its old date never reaches the popup.
- Not fixed, latent: a plan with a one-hander and an off hand, against a worn two-hander above it,
  still asks for the off hand, and equipping that takes the two-hander off. No druid plan has an
  off hand today. Worth a card if a Balance or Restoration plan gets one.
- Offline check passes, as Feral and as spec 250.

Security. Weakest point: the item level read. A level the client has not cached is nil, and nil never
outranks, so the popup falls back to asking, which is the old behaviour. Unchecked input: none from
outside. Every value is the player's own gear from the game's item links. It leaks nothing. There is
no network call and no chat output.

No browser: this is a game popup. No agent can run the client, so the look is the ask above.

**2026-10-11** Clear-down (attended, Rob asked): converted Done when to an Acceptance block and ticked the two offline criteria (the `slot state` outrank checks and the three `the popup says / does not say the plan is old ...` checks exist and pass in the Lua 5.1 offline check). Done when 1, 2 and 4 could not be met as written: the Coiled Altar popup cannot come back and the Feral plans were resimmed (now `simmed = "2026-09-30"`), so the rule they stood for is the two ticked lines. Looks rewritten for v0.69.0: the stale date is now 2026-09-30, not 2026-09-28. Moves to ai-review/ with only in-game looks open.

### 2026-10-20 review (v20261020101343-f543)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: defect**

I checked the two ticked criteria in the code. Both hold. One open manual check cannot pass as written.

**#1: holds.** `outranks` and `slotState` in `DjinnisClassProfiles.lua` do this. A worn item with a higher item level is not marked `change`. Its enchant is still judged. Its gems are judged against the sockets it really has. The offline checks for this are in the self-test, under the "slot state is change when item differs from plan" group.

**#2: holds.** `PlanTab.wrongHere` sets `wrong.stale` only when a different item outranks the plan (`on.id ~= entry.id`). `PlanTab.setupPopup` then adds the grey line. All three named checks are present.

**#3: no fault found.** It waits on Rob to try it in the game.

**#4: cannot pass.** This check expects the exact text `Gear plan from 2026-09-30`. But this diff gives every Feral cell in `GEAR_PLAN` the date `simmed = "2026-10-15"`. The line prints `plan.simmed`, so it will say 2026-10-15. Also, almost every planned slot is now 334, and the rest are the items Rob already wears. So "won a piece since 2026-09-30 that beats the plan's" now means something different. The check needs new words before anyone tries it.

UNMET: #4 the popup prints the plan's `simmed` date, which this diff sets to 2026-10-15, so the expected text "Gear plan from 2026-09-30" can never appear

VERDICT: defect

**scope: defect**

I tried to break this change from the scope angle. It does not do what the card says.

**Findings**

1. **This change does more than the card asks.** The diff holds about 40 other cards' work: bar layouts, crafted reagents, every class's builds, research files and a full plan resim. None of it is card 0071. The 0071 code itself (`outranks`, `wrong.stale`, the popup line) stays inside the card.

2. **Criterion #4 cannot pass as written.** Every Feral cell in `GEAR_PLAN` in `DjinnisClassProfiles.lua` now says `simmed = "2026-10-15"`. The popup line in `PlanTab.setupPopup` prints `plan.simmed`. So the popup will say "Gear plan from 2026-10-15". The criterion asks for 2026-09-30.

3. **The line text is out of date.** `GEAR_PLAN_SOURCE` now says the plan comes from "local SimC droptimiser". But the line in `PlanTab.setupPopup` still says "rerun Top Gear". This tells the player to take the wrong step.

**What you do now:** Update criterion #4 to the current date. Change the line text in `PlanTab.setupPopup` so it names the droptimiser, not Top Gear.

UNMET: #4 the plan is now simmed 2026-10-15, so the popup can never print "Gear plan from 2026-09-30", and its advice "rerun Top Gear" names a tool the plan no longer comes from.

VERDICT: defect

**breakage: defect**

I checked the code and found one real problem. The gear logic works, but one manual check can never pass as written.

**What works:**
- `outranks` and `slotState` in `DjinnisClassProfiles.lua` work as the card says.
- A worn piece with a higher item level is no longer asked for. Its enchant and its sockets are still checked.
- `PlanTab.wrongHere` only shows the "plan is old" line when a different item outranks the plan.
- The three offline checks for that line exist.
- Equip all and the bag glows read the same `slotState` result, so they also go quiet.

**What is broken:** criterion 4 asks for the line `Gear plan from 2026-09-30. You have upgraded since: rerun Top Gear.` But the gear plan in this change was re-made. All four Feral cells in `GEAR_PLAN` now say `simmed = "2026-10-15"`. `PlanTab.setupPopup` prints `plan.simmed`, so the line can only ever say 2026-10-15. The card's own comment of 2026-10-11 still says 2026-09-30, so that comment is now wrong too.

**Also:** every planned slot in the new plan is item level 334 or 331. So a worn piece will almost never outrank it, and the "yes" half of criterion 4 is very hard to test in game.

UNMET: #4 GEAR_PLAN Feral cells are now simmed 2026-10-15, so PlanTab.setupPopup can never print "Gear plan from 2026-09-30"; the criterion's expected text is out of date.

VERDICT: defect

**acceptance**

- **#4 was named by the acceptance lens and is not a ticked criterion here**, so nothing was changed: the popup prints the plan's `simmed` date, which this diff sets to 2026-10-15, so the expected text "Gear plan from 2026-09-30" can never appear
- **#4 was named by the scope lens and is not a ticked criterion here**, so nothing was changed: the plan is now simmed 2026-10-15, so the popup can never print "Gear plan from 2026-09-30", and its advice "rerun Top Gear" names a tool the plan no longer comes from.
- **#4 was named by the breakage lens and is not a ticked criterion here**, so nothing was changed: GEAR_PLAN Feral cells are now simmed 2026-10-15, so PlanTab.setupPopup can never print "Gear plan from 2026-09-30"; the criterion's expected text is out of date.

