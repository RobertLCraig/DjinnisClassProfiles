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

**2026-09-24, Claude.** Written from the clippings page. Not started. `SPELL_CONFIRMATION_PROMPT` and
its payload are read from `wow-ui-source` on branch `live`; whether 12.1 protects the event is not
known offline.
