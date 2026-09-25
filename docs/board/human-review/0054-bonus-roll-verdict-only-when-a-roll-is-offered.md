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

**2026-09-25, Claude (third review of fc0c27c). Holds: moved to human-review.**

The false NO after a reload is gone, and the four gaps the second review found are now proved. What
is left is Low: one rare wrong boss, two test gaps and a safe miss.

Ran `offline-check.lua`, `250` and `62` on the committed code (a `git archive` of `fc0c27c`; the
Lua is unchanged at HEAD `62559af`). All three end "no FAIL lines", output read whole. The working
tree had another session's uncommitted edit to `DjinnisClassProfiles.lua`, so the runs and mutations
used the archive, not the tree. Checked against `wow-ui-source` 12.1.0 (69933): `DjinnisCPCharDB` is
this addon's `SavedVariablesPerCharacter` (`.toc` line 9, and offline-check's 0058 check reads it).
Saved variables are in place before PLAYER_ENTERING_WORLD, and ENCOUNTER_END can only come later, so
the 2026-09-02 rule holds. `time()` is a plain Lua global Blizzard's own Mainline code calls
(`ChatFrameOverrides.lua:535`). `GetInstanceInfo` (`InstanceDocumentation.lua:103`) has no secret
returns. Its `instanceType` values in Blizzard's code are "none", "party", "raid", "scenario",
"pvp" and "arena". Open world is "none", with the continent as the instance. Delves are scenarios.
Nymrissa Wavecaller, the one BiS source outside the eight, is a lair boss inside the raid (`:5802`),
so "raid" covers her.

Mutations, on a temp copy of the archive:

| Mutation | Result |
|---|---|
| no time limit on the kept kill | 3 FAIL, caught |
| `<=` for `<` at the limit | 3 FAIL, caught |
| the kill not written to the character | 4 FAIL, caught |
| the kept kill never read | 5 FAIL, caught |
| the kill written without its time | 4 FAIL, caught |
| "no boss" never, or always | 5 and 2 FAIL, caught |
| "no boss" says nothing in chat | 2 FAIL, caught |
| the kept kill's place not checked | 3 FAIL, caught |
| `carriedLevels` returns `{}`, skips bags, skips worn gear | 2 FAIL each, caught |
| `bonusCoins` always nil, or no 0 fallback | 2 FAIL each, caught |
| TIMEOUT, PLAYER_ENTERING_WORLD or ENCOUNTER_END not registered | 2 FAIL each, caught |
| a kill does not clear the offered spell | 2 FAIL, caught |
| the self-test throws right after the swap | 2 FAIL, caught, and the table comes back |
| `carriedLevels` ignores the item id | **green** |
| a finished key saved without its time | green (harmless, see 4) |
| the kept kill used even with a kill this session | green (same table, no change) |
| the self-test leaves the fake table in place | green: the outer net puts the real one back |

Findings:

1. **Low. A crash can name the boss before this one.** `DjinnisClassProfiles.lua:1789`. Saved
   variables reach disk only at a reload or a logout. Kill Nek'zali, /reload, kill Entombed
   Sentinels, crash with the roll open, log back in within 10 minutes. The file still holds
   Nek'zali, in the same raid and inside `BONUS_KEEP`, so the verdict is for Nek'zali. That is a
   YES or NO for the wrong loot table. Whether a roll survives a crash is not known offline. Fix, if
   wanted: bound it by the roll's own time left (`duration`, arg4 of the prompt and `p.duration` in
   the login list) instead of a flat 600 s.
2. **Low. The id filter in `carriedLevels` is not proved.** `:2644`. The fixture's other item
   (`|Hitem:333::|h[Other]|h`, `:11720`) has no level in `ilvl` (`:11722`), so it is dropped even
   with the id test gone. Scenario: a later edit drops the id test, any worn item at 723 makes every
   planned item "owned", and the verdict turns NO. Fix: give 333 a level in `ilvl`. A probe with 999
   there still returns `710,723,723` on the real code.
3. **Low, a safe miss.** `:1818` writes only when `DjinnisCPCharDB` is already a table. It is made
   lazily (`madeAt`, `spareIDs`, `applyBars`, or the 0058 copy). On a druid with none of those, the
   kill is not kept, and a reload with the roll open gives "no boss", not a verdict. The failure is
   silence, not wrong advice. Fix: `DjinnisCPCharDB = DjinnisCPCharDB or {}` at the write. That is
   safe there: ENCOUNTER_END is always after ADDON_LOADED.
4. **Note.** A finished key's time (`:1770`) is not proved. It does not matter today: in a dungeon,
   the fallback is the place, which has the same name.
5. **Note, true before this card.** Outside a raid or dungeon ("none", "scenario") the fallback is
   still the place name (`:1797`). No BiS source is an open-world boss today, so nothing is wrong
   now. If one is added, give the place verdict only for "party". The boss-name mismatch is small:
   `bisFrom` matches substrings both ways, so "Nek'zali the Soulcoiler" finds "Nek'zali". Only a name
   where neither holds the other misses.

Asked about and held:
- **The self-test swap.** Everything runs inside one slash call. WoW does not deliver events in
  the middle of Lua, and nothing called inside fires one, so nothing else can write the real table
  while it is swapped. The swap is inside the `pcall` (`:11643`), and the restore after it cannot
  throw (`:11753`). Under that, `runSelfTest` (`:14895`) deep-copies both saved tables first, and
  `restoreSaved` (`:14817`) puts the real table and its contents back even if the check's own
  restore is removed. Two mutations above show both layers.
- **Growth.** One key, `bonusSource`, overwritten on each kill with three fields. It never grows.
  It is only written on a druid (the `gearHere` gate comes first).
- **The fallback when `bonusOnOffer` is false.** The kill is written first, then the verdict is
  given at the kill as before. The login scan answers "no list", and the kept kill is never read.
- **Stale data.** A kill from last week, or from another raid, is refused by the time and the place.
- **Secret values.** The name is `canRead`-guarded before it is kept. The place, kind and `time()`
  are not secret-annotated. What comes back from the saved file is plain Lua.

Security, three questions:
- **Weakest point:** the flat 10 minutes as a stand-in for "this roll's kill" (finding 1).
- **Unchecked path:** only a live client can show the save and read across a real /reload, and
  whether a roll outlives a crash. Rob's in-game line: /reload with the roll open after a kill, and
  the verdict names that boss.
- **What it leaks:** the boss name, instance id and time of the last kill now sit in the
  character's saved variables on disk. They stay local and are never sent. Nothing else changed.

**2026-09-25, Claude.** Second review's findings fixed, v0.54.2.

1. Fixed, both ways the review gave. The kill is kept on the character (`DjinnisCPCharDB.bonusSource`,
   with its time), and an offer after a reload uses it for 10 minutes (`BONUS_KEEP`). With no
   known boss in a raid there is no verdict: chat says the boss is not known and points at "Bonus
   roll worth it here?". In a dungeon the place is still the source, as its BiS is listed by place.
2. Fixed. `carriedLevels` is run on stubbed worn gear and bags: a match, another item, an empty
   slot and a second bag.
3. Fixed. The roll frame is checked by name for the offer, its end, the loading screen and the kill.
4. Fixed. `bonusCoins` is run: currency 0 asks for 697, and a read that throws gives nil.
5. For Rob, in game: the verdict names the boss just killed.

Also: a new kill clears the "already shown" guard, and a check says so. The self-test keeps the
kill in its own table, not on the real character.

Breaking each fix made 2 to 5 checks fail (eight breaks). All three modes end "no FAIL lines".

**2026-09-25, Claude (re-review of 79a4f34). Does not hold: stays in ai-review.**

The seven fixes are in and each does what the comment below says. One of them brings a new wrong
answer, and the new owned-at-level code has no offline proof.

Ran `offline-check.lua`, `250` and `62` on HEAD (`9286940`). All three end "no FAIL lines", output
read whole. Checked against `wow-ui-source` 12.1.0 (69933): `EventImplementation.lua:389` (payload
order, currencyID is arg5), `:804` (the login replay runs on every PLAYER_ENTERING_WORLD and reads
`spellID`, `confirmType`, `currencyID`), `GroupLootFrame.lua:286-303` (same-spell guard, 0 means
`BONUS_ROLL_REQUIRED_CURRENCY`, no frame at 0 coins), `Constants.lua:186` and `:473`
(`NUM_TOTAL_EQUIPPED_BAG_SLOTS`, 697), `InstanceDocumentation.lua:115` (8th return is `instanceID`,
not nilable), `UnitDocumentation.lua:3956` (TIMEOUT payload is spellID first),
`ContainerDocumentation.lua`, `CurrencyInfoDocumentation.lua`. `GetSpellConfirmationPromptsInfo` is
not in the generated docs; Blizzard's live code calls it, as the code comment says.

Mutations, on a temp copy:

| Mutation | Result |
|---|---|
| owned needs `>` the plan level, not `>=` | caught |
| lowest planned level, not highest | caught |
| TIMEOUT does not clear the offered spell | caught |
| verdict uses `planOwned` again | caught |
| login scan takes any prompt type | caught |
| `registerRoll` checks the wrong event | caught |
| place match removed | caught |
| no planned level answers false | caught |
| no coin check | caught |
| `carriedLevels` returns `{}` | **green** |
| `carriedLevels` skips the bags | **green** |
| `carriedLevels` skips worn gear | **green** |
| `carriedLevels` ignores the item id | **green** |
| TIMEOUT and PLAYER_ENTERING_WORLD not registered | **green** |
| `bonusCoins` always nil, or the 0 fallback dropped | **green** |
| a kill does not clear the offered spell | **green** |
| secret boss name unguarded | green (said so in the fix comment) |

Findings:

1. **Medium. After a reload or a relog in the raid, the verdict is a false NO.**
   `DjinnisClassProfiles.lua:1724`, reached from the login scan at `:1728`. A reload empties
   `bonusSource`, so the verdict is for the instance name. Raid BiS is listed by boss name, so
   `bisFrom("The Venomous Abyss")` finds nothing. Probed with the real `bisFrom`: it flashes "Bonus
   roll: NO The Venomous Abyss" and prints "nothing BiS drops from The Venomous Abyss. Keep the
   coin." Scenario: kill Nek'zali, disconnect or /reload before answering the roll. The addon tells
   you to keep a coin on a boss that drops two BiS items. Before fix 5 this was a silent miss. Now it
   is wrong advice. The self-test at `:11357` expects this NO, so it is written in as correct. Fix:
   in a raid with no source from this instance, give no YES/NO. Say the boss is not known, or keep
   the source in `DjinnisCPCharDB` at the kill and read it back at PLAYER_ENTERING_WORLD (that is
   after ADDON_LOADED, so the 2026-09-02 rule holds).
2. **Medium. Owned-at-level has no offline proof.** `carriedLevels`, `:2567-2583`. The self-test
   swaps it for a stub (`:11382`). The offline harness has no `C_Container` and no worn items. Four
   mutations stay green, including "always `{}`". Scenario: a later edit breaks the bag loop. Every
   planned item then reads not owned, the verdict can never be NO for ownership, and nothing fails.
   That is acceptance 3 for every item that has a plan level. Fix: one check that gives it worn and
   bag links (a nil slot, another id, the id at 710 and at 723) and asserts the levels. A probe with
   exactly that returned `723,723` and did not throw on nil slots, so the code is right today.
3. **Low. The two new registrations are not checked.** `:1752`. Dropping SPELL_CONFIRMATION_TIMEOUT
   and PLAYER_ENTERING_WORLD stays green. The DECISIONS rule says confirm each event. Only the offer
   is confirmed. Scenario: an edit drops PLAYER_ENTERING_WORLD from the list, and fix 5 is gone with
   no FAIL. Fix: assert in the self-test that `rollFrame` holds all six.
4. **Low. `bonusCoins` is never run.** `:1689`. The self-test stubs it and the harness has no
   `C_CurrencyInfo`. Breaking it stays green. Its failure mode is safe (nil means "show it"), so this
   is a gap, not a bug.
5. **Low, in-game only.** The source is the last kill. If the client ever sends the prompt before
   ENCOUNTER_END, the verdict is for the previous boss in the same raid, and the kill after it wipes
   the guard. Not provable offline. Add to Rob's in-game line: the verdict names the boss just killed.

Asked about and held:
- The protected-event trap. The handler is set before any registration. A refusal raises no Lua
  error, so the loop goes on. PLAYER_ENTERING_WORLD is already registered by other frames in this
  file. A refused TIMEOUT would only keep the guard until the next kill.
- The PLAYER_ENTERING_WORLD recursion. One level, into the prompt branch, first BonusRoll entry only.
  The same-spell guard stops a second flash on the next loading screen. A reload resets the guard,
  which is the point of fix 5.
- `bonusSource.name` at `:1745` is never nil-indexed. Only the kill and key branches reach it, and
  both set a table first. The offer path guards with `source and`. The fallback name is `here`.
- `carriedLevels` does not throw on nil slots, a nil `GetContainerNumSlots`, or a throwing
  `GetDetailedItemLevelInfo` (pcall). A secret link is dropped by `canRead` before `match`.
- The bank change is sensible. It errs toward YES, which costs a coin at worst, and items with no
  plan level still count the bank. One edge for Rob: a bank copy won from a bonus roll is off the
  roll table, so a YES resting only on it wastes the coin.

Security, three questions:
- **Weakest point:** finding 1. A lost source turns into a confident NO with a raid warning.
- **Unchecked path:** `carriedLevels` and `bonusCoins` run only in game. Neither is reached offline.
- **What it leaks:** nothing. Chat and raid warning are local. Nothing is saved or sent.

**2026-09-25, Claude.** Review findings fixed, v0.53.2.

1. Fixed. The events are registered by `PlanTab.registerRoll(frame)`. The self-test gives it a
   frame that refuses the offer event, and `bonusOnOffer` must come out false. It also checks that
   the real roll frame holds `SPELL_CONFIRMATION_PROMPT`. The offline stub's `IsEventRegistered`
   now answers only for events that frame registered.
2. Fixed, the first way the review gave. `PlanTab.bonusOwned` counts a copy as owned only at or
   above the plan's item level. It reads worn and bag copies (`carriedLevels`); the bank's cannot be
   read while it is shut, so a bank copy no longer makes the verdict NO. An item the plan has no
   level for counts as owned as before, any copy.
3. Fixed. "Lists the owned one beside the wanted" also counts the flashes.
4. Fixed. The source keeps the instance id, and the offer uses it only in the same instance.
   Anywhere else the verdict is for the instance.
5. Fixed. On `PLAYER_ENTERING_WORLD` the addon reads `GetSpellConfirmationPromptsInfo()`, as
   Blizzard's own login code does, and gives the verdict for an open bonus roll. On every loading
   screen, not only a reload: the next point stops a second flash.
6. Fixed. The verdict is given once per roll spell, until `SPELL_CONFIRMATION_TIMEOUT` or the next
   kill. With 0 coins nothing flashes, as Blizzard shows no roll. Coins that cannot be read do not
   stop it.
7. Fixed. A boss name that is a secret is replaced by the instance name. Not checked offline: the
   self-test cannot hand this path a secret.

I broke each fix on purpose, one at a time: the offer event not registered 2 FAIL, the level
ignored 2, no second-flash guard 4, no place match 2, no coin check 3, no login scan 4,
`bonusOnOffer` hard-coded to true 2. All three modes end "no FAIL lines" with the fixes in.

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
