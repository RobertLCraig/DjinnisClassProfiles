# 0039 Say when all loadout slots are full, before making any

## Why

Rob, 2026-09-23: "Create 3" made nothing. Blizzard's dropdown said "You've reached the maximum
number of loadouts. Delete a loadout from any of your specializations to free up a slot." The cap
is `Constants.TraitConsts.MAX_COMBAT_TRAIT_CONFIGS`, 40, over every spec of the character. The
queue did not know: each build waited 15 s for `CanCreateNewConfig`, twice, then failed with a
vague reason.

## Built, v0.35.2

- `PlanTab.freeLoadoutSlots()` counts `GetConfigIDsBySpecID` over each of the player's specs and
  takes it from the cap. Nil when the game will not say.
- `PlanTab.loadoutFence()` refuses when that is 0 and says: "All 40 loadout slots are used, over
  all your specs. Delete some you do not use, then try again." Create and Reset both pass the fence.
- `loadoutChecks`: 5 new checks. Removing the fence turns 4 red.

## Not this card

- Fewer free slots than builds still starts; the builds past the cap fail as before.
- It is not proven that `GetConfigIDsBySpecID` answers for a spec that is not active. If it returns
  nothing, the count is too low and the fence stays open, which is the old behaviour.

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN every loadout slot is used, THE ADDON SHALL say so and make nothing. proves: `no loadout is made in combat or with the talent window open, all slots full`, `..., and it says so`, `..., slots are counted over every spec`
- [x] WHEN a slot is free, THE ADDON SHALL make loadouts as before. proves: `no loadout is made in combat or with the talent window open, a free slot is counted`, `Create makes every missing build, and nothing else`
- [x] WHEN every slot is used, **More > Delete old loadouts** (`/dcp tidy`) SHALL still list and delete. proves: `tidy removes only the old Dreamgrove names, and only on yes, even with every slot used`
- [ ] `/reload`. With all 40 slots used, **More > Make the planned loadouts**. Pass: chat says "N builds have no loadout of their own and no room for one", no Create button, no "Making" line. proves: manual
- [ ] With all 40 slots used, **More > Delete old loadouts**. Pass: the old loadouts are listed in chat, and the box's Delete deletes them. proves: manual
- [ ] Free 5 slots with no `[CP*]` spare on the character, then **More > Make the planned loadouts** > Create. Pass: Create 3 (fewer if fewer are missing), then "Made 3 of 3". proves: manual
<!-- AC:END -->

## Comments

**2026-09-23** Adversarial review of 8eeaecf. Bounced to todo: one defect.

**Finding: at the cap, `/djbis tidy` is refused, and it is the command that frees slots.**
`PlanTab.tidy` calls `PlanTab.loadoutFence()` first (`DjinnisBiS.lua:6744`). Since this card the
fence refuses when `freeLoadoutSlots()` is 0 (`DjinnisBiS.lua:6453`). So with 40 used,
`/djbis tidy yes` says "All 40 loadout slots are used. Delete some you do not use" and deletes
nothing. Proved in a temp copy: `PlanTab.tidy(false)` at the cap answered 0 with that line. Fix:
keep the slot check out of the fence tidy uses. Put it in `makeLoadouts`, or give tidy a fence
without it. Add a check that tidy still lists at the cap.

What held:
- Harness green under Lua 5.1 and 5.4.
- Mutations, red count each under both: fence slot check off, 4. Count only the active spec, 14.
  Ignore used slots, 14.
- The cap is 40 in `TraitConstantsDocumentation.lua:319`. Blizzard's own New button is disabled by
  `CanCreateNewConfig` alone (`Blizzard_ClassTalentsFrame.lua:516`).
- Reset to plan being fenced at the cap loses nothing. `importOne` already needed
  `CanCreateNewConfig` before its delete, so Reset could never work at the cap.

Small note, not the reason for the bounce: `C_SpecializationInfo.GetSpecializationInfo` returns
`specId` with `Default = 0` (`SpecializationInfoDocumentation.lua:247`). 0 is true in Lua, so on
a 3-spec class the loop at `DjinnisBiS.lua:6467-6468` does not stop at index 4. It then asks
`GetConfigIDsBySpecID(0)`. A druid has 4 specs, so Rob never hits it. `specID == 0` should break.

No criterion carries `proves:`. The checks exist; name them on the criteria.

Security:
1. Weakest point: the count comes from the game's config list. If an inactive spec's list is empty,
   the fence stays open. That is the old behaviour, and the card says so.
2. Unchecked: nothing comes in from outside. The inputs are game API answers, each `pcall`ed.
3. Leaks: nothing leaves the client. The refusal prints only the cap number.

No client can be run by an agent. The in-game checks are the card's What I need from you. Also look
at: `/djbis tidy` with all slots full, once the fix lands.

- 2026-09-23 Claude, builder, v0.38.0. Fixed.
  - `loadoutFence(anySlots)` skips the slot count. `tidy` passes true, so it runs at the cap. Check:
    `tidy removes only ..., even with every slot used`. Putting the old fence back: 1 red.
  - `freeLoadoutSlots` stops at a spec id of 0 too.

**2026-09-23** Second adversarial review, of b5530b3 (v0.38.0). Verdict: **clean, to human-review**
for the in-game checks.

Attacked:
- Both harnesses (Lua 5.1 and the newer one) print "no FAIL lines".
- Mutations on a temp copy, red count the same under both:
  - tidy back on the plain fence: 1 red.
  - `anySlots` ignored in the fence: 1 red.
  - the slot check gone: 4 red.
  - slots counted for the active spec only: 15 red.
  - no stop at spec id 0: 0 red. That is the small note from the first review. A druid never
    reaches it, so it is not a finding.
  - the spare's fence (`makeLoadouts(jobs, wear)`) back to the slot check: 0 red. That belongs to
    0040. It only matters when the game's list lags a delete, and `wearSpare` checks the slots itself
    first.
- Every other caller of `loadoutFence`: `makeLoadouts` for Create and Reset still counts slots. Only
  tidy and the spare skip the count.

What held: the finding is fixed. At the cap, tidy lists and deletes. Create and Reset are still
refused at the cap with the same line.

What broke: nothing in the code. The criteria had no `proves:`, which the first review noted and
the fix left. I fixed that in place: each criterion now names the checks above, and a third
criterion covers tidy at the cap.

Security:
1. Weakest point: the count trusts `GetConfigIDsBySpecID` for specs that are not active. If it
   answers short, the fence stays open, which is the old behaviour.
2. Unchecked: nothing comes from outside. `tidy` only deletes names on the retired list, never the
   selected one, and only on `yes`.
3. Leaks: nothing leaves the client. The refusal prints the cap number only.

No agent can run the game. A person still owes What I need from you 1 and 2, and one more look:
with all 40 slots used, `/djbis tidy` lists the old names and `/djbis tidy yes` deletes them.

**2026-10-11** Clear-down (attended, Rob asked): ticked all three criteria (checks `no loadout is made in combat or with the talent window open, ...` (all slots full, and it says so, slots are counted over every spec, a free slot is counted), `Create makes every missing build, and nothing else` and `tidy removes only the old Dreamgrove names, and only on yes, even with every slot used` exist and pass in the Lua 5.1 offline check); looks rewritten for v0.69.0. The code changed what look 1 can see: since 0043 the loadouts box offers no Create at all when there is no room, and says the builds are worn through the spare, so the "All 40 loadout slots" line is no longer reachable from Create; the look now checks the no-room line. `/dcp tidy` and `/dcp tidy yes` both open the same list-and-ask box as the menu item, so the review's extra tidy look is the second look. Moves to ai-review/ with only in-game looks open.