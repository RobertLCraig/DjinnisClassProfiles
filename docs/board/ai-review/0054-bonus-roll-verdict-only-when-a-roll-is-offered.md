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

**2026-09-25, Claude (review of e09a451, 3a2a6de). Does not hold: stays in ai-review.**

Ran `offline-check.lua` and `offline-check.lua 250` on HEAD (`ab17ce1`, which adds 0067 on top and
leaves the 0054 code alone): both end "no FAIL lines", output read whole. Checked against
`wow-ui-source` 12.1.0 (69933): `EventImplementation.lua:389` (HandleSpellConfirmationPrompt),
`:804` (the PLAYER_ENTERING_WORLD replay), `GroupLootFrame.lua:286` (BonusRollFrame_StartBonusRoll),
`UnitDocumentation.lua:3935` (payload), `SpellConstantsDocumentation.lua` (BonusRoll = 1),
`EncounterInfoDocumentation.lua:38` (ENCOUNTER_END). Arg positions are right: confirmType is arg2.

Mutations, on a temp copy:

| Mutation | Result |
|---|---|
| kill always gives the verdict | 5 FAIL, caught |
| `bonusSplit` ignores owned | 2 FAIL, caught |
| any prompt type gives the verdict | 2 FAIL, caught |
| kill does not set the source | 6 FAIL, caught |
| `bonusOnOffer = true` instead of `IsEventRegistered` | **green** |
| `SPELL_CONFIRMATION_PROMPT` never registered | **green** |
| YES flashes when not offered (the `here` path) | **green** |
| `/dcp here` passes `offered = true` | **green** |

Findings:

1. **Medium. Acceptance 4 is not proved.** `DjinnisClassProfiles.lua:1743-1744`, `offline-check.lua:37`.
   The self-test sets `bonusOnOffer` by hand, and the offline stub's `IsEventRegistered` always answers
   true, so deleting the registration or hard-coding the flag stays green. A later edit that drops the
   line ships an addon that waits for an event it never gets and never gives a verdict. Fix: make the
   stub's `IsEventRegistered` answer from `registered[event]`, assert in offline-check that a frame with
   an `OnEvent` handler holds `SPELL_CONFIRMATION_PROMPT`, and add a run where `RegisterEvent` refuses
   that one event and `bonusOnOffer` must come out false.
2. **Medium. Owned means "same item id", at any item level.** `DjinnisClassProfiles.lua:1641`, via
   `planOwned` at `:2506`. A Heroic copy of a BiS trinket (same id as the Mythic one) in bags or bank
   makes the Mythic offer flash "Bonus roll: NO" and "you own every BiS item. Keep the coin", though the
   roll rolls at vault level and would be an upgrade. The clipping says an item **won from a bonus roll**
   leaves the table, not any owned copy. The card asked for `planOwned`, so this is the card's premise;
   Rob decides. Fix: count a copy as owned only at or above the plan row's `ilvl` (the tooltip already
   does "in plan at 723"), or compare against the offer's `difficultyID` (arg7).
3. **Low. The `here` question is not held to "never flashes".** `DjinnisClassProfiles.lua:1666-1668`,
   `bonusChecks` ("and lists the owned one beside the wanted" does not count `flashed`). Only the NO path
   checks for no flash. Fix: add `#flashed` to that check, as the NO one has it.
4. **Low. The source is never cleared or tied to a place.** `:1697`, `:1701`. It lives until the next
   kill or key. An offer with no `ENCOUNTER_END` success in front of it (a world boss if it does not
   send one; not provable offline) gets the verdict for the last raid boss killed this session. Fix:
   store the instance id (8th return of `GetInstanceInfo`) with the source, use it only if it matches at
   the offer, and clear it on `PLAYER_ENTERING_WORLD`.
5. **Low. A /reload between the kill and the offer gives no verdict.** The client does not send
   `SPELL_CONFIRMATION_PROMPT` again. Blizzard re-shows the roll from `GetSpellConfirmationPromptsInfo()`
   at PLAYER_ENTERING_WORLD (`EventImplementation.lua:804`). So a reload does not double the flash,
   but the verdict is silently missed. Fix, if wanted: on PLAYER_ENTERING_WORLD with `isUIReload`, scan
   that list for BonusRoll and answer for the instance.
6. **Low. The verdict can flash twice, or for a roll you cannot take.** `BonusRollFrame_StartBonusRoll`
   (`GroupLootFrame.lua:289`) ignores a second prompt for the same spellID, and returns at `:301` when
   you hold 0 coins. The addon does neither, so it can sound twice, or say YES with no roll frame shown.
   Fix: remember the offered spellID until `SPELL_CONFIRMATION_TIMEOUT`, and check the currency
   (arg5, or `BONUS_ROLL_REQUIRED_CURRENCY` when 0) before flashing.
7. **Low, carried over from before this card.** `:1697` stores the boss name unchecked, then
   `bisFrom` compares, lowers and concatenates it. No doc marks `encounterName` secret, but DECISIONS says
   any string can be one. Fix: `if not canRead(arg2) then` fall back to the instance name.

What held: the offer is the right event with the right enum value. The handler is set before each
event is registered on its own. A wipe is not a source. Off a druid nothing speaks. Bank and account-bank
copies count as owned (`GetItemCount(id, true, false, true, true)`, pcall plus `canRead`). An item with
no link counts as wanted. `/dcp here` does not flash.

Security, three questions:
- **Weakest point:** the refused-event fallback (finding 1). It is unproved offline. It also runs at
  file scope and remembers nothing, so a refusal would bring `ADDON_ACTION_FORBIDDEN` back at every
  login (the 2026-09-02 entry in DECISIONS).
- **Unchecked path:** payload values go straight into comparisons and concatenation: `arg2` (the
  confirmType, compared) and the boss name (finding 7). Neither is documented secret.
- **What it leaks:** nothing. Chat and raid warning are local only. Nothing is saved and nothing is sent.

No browser surface. Rob checks it in game: the existing manual line, plus: the addon loads with its
other features working (the new registration sits mid-file), and the verdict comes at the offer, not at
the kill.

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
