# 0054 The bonus roll verdict only when the game offers a roll, and only for BiS not owned

## Why

Rob asked on 2026-09-24 whether the WoW clippings page helps
(`C:\Dev\SecondBrain\wiki\summaries\WoW (Clippings).md`). Two lines in it, from SignsOfKelani's weekly news
of 2026-08-29, apply to `bonusRollVerdict`:

- Since a mid-week hotfix, **a bonus roll works only on a boss you can still loot**. That is once per
  boss, per difficulty, per week. Today the verdict fires on every `ENCOUNTER_END` success and every
  `CHALLENGE_MODE_COMPLETED`, so a re-clear of a boss already looted this week still flashes "Bonus
  roll: YES" for a roll the game will not offer.
- **An item won from a bonus roll leaves your future bonus roll table.** Today the verdict lists every
  BiS item from the source, including the ones already owned. An owned item cannot make the
  verdict YES.

## What

- Ask at the moment the game offers the roll. Blizzard's retail code does this in
  `Blizzard_Game/Mainline/EventImplementation.lua`: `SPELL_CONFIRMATION_PROMPT` with
  `confirmType == Enum.ConfirmationPromptUIType.BonusRoll` calls `BonusRollFrame_StartBonusRoll`.
  The same event gives `difficultyID` and `displayItemID`. The boss name still comes from the last
  `ENCOUNTER_END` (or the instance name after a key).
- Keep `ENCOUNTER_END` only to remember the source, not to show the verdict.
- Drop items `PlanTab.planOwned(id)` says are owned. If all BiS from the source are owned, the
  verdict is NO, and the chat line says they are all owned.
- The "Bonus roll here?" check (slash `here`, and the button from `0053`) stays a question about the
  place, and marks owned items as owned instead of hiding them.

## Acceptance

- [ ] The verdict does not show on `ENCOUNTER_END` alone. proves: offline-check, spec mode and self-test
- [ ] The verdict shows on `SPELL_CONFIRMATION_PROMPT` with the BonusRoll type, for the last boss. proves: self-test
- [ ] Owned BiS does not count toward YES. proves: self-test, with `planOwned` swapped on PlanTab
- [ ] `SPELL_CONFIRMATION_PROMPT` registration is checked for a refusal (the protected-event trap in
  `docs/DECISIONS.md`). proves: self-test
- [ ] In game: kill a boss already looted this week. No verdict shows. proves: manual (Rob)

## Not this card

- Which boss to spend coins on across the week. That is a planner, not a verdict.

## Comments

**2026-09-25, Claude.** Built, v0.53.0.

- `PlanTab.onBonusEvent` handles the events. A kill (`ENCOUNTER_END`, success) or a finished key
  (`CHALLENGE_MODE_COMPLETED`) only sets `PlanTab.bonusSource`. `SPELL_CONFIRMATION_PROMPT` with
  `confirmType == Enum.ConfirmationPromptUIType.BonusRoll` (1, `SpellConstantsDocumentation.lua`)
  gives the verdict for that source, or for the instance when there is none.
- The frame sets its handler first, registers each event on its own, and checks the offer event
  with `IsEventRegistered` (`PlanTab.bonusOnOffer`). If the game refuses it, the kill gives the
  verdict as before, so nothing goes silent.
- `PlanTab.bonusSplit` puts owned items (`planOwned` on the id from the harvested link) apart. All
  owned is NO, with "you own every BiS item". An item with no link has no id to check, so it
  counts as wanted.
- "Bonus roll here?" (`/dcp here`) never flashes, and it lists owned items marked "owned".
- The `difficultyID` and `displayItemID` in the payload are not used: the source is the boss name,
  as before.
- `PlanTab.bonusChecks` holds 12 checks. Breaking the fix three ways made 5, 2 and 2 fail.

The in-game acceptance line is still Rob's: kill a boss already looted this week, and no verdict
shows. If the verdict comes at the kill and not at the offer, the game refused the event and the
fallback is running.

**2026-09-24, Claude.** Written from the clippings page. Not started. `SPELL_CONFIRMATION_PROMPT` and
its payload are read from `wow-ui-source` on branch `live`; whether 12.1 protects the event is not
known offline.
