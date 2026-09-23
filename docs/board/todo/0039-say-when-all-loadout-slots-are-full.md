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

1. With all slots full, `/djbis loadouts`, click Create. Pass: the "All 40 loadout slots" line,
   at once, and no "Making" line.
2. Delete loadouts to make 3 free slots. Create again. Pass: "Made 3 of 3".

## Acceptance

- [ ] WHEN every loadout slot is used, THE ADDON SHALL say so and make nothing.
- [ ] WHEN a slot is free, THE ADDON SHALL make loadouts as before.

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
