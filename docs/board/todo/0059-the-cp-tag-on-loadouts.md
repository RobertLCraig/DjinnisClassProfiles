---
needs: 0058
---
# 0059 The "[CP] " tag on every loadout the addon makes

## Why

Card `0050`'s finding: the addon knows its loadouts only by name, so a loadout Rob made and called
"Raid" reads as the addon's, and "Reset to plan" would delete it. Rob, 2026-09-24: a tag, like
Improved Talent Loadouts' `[ITL]`, and it is `[CP]` (Class Profiles), not `BiS`. He accepted a
clean-up of the old loadouts on every character.

Split from card `0058` so the rename could ship first; the rename changes no loadout.

## What

- Every loadout the addon makes is named `[CP] <build name>`. 24 letters is the longest build name,
  so 29 of Blizzard's 30.
- Only tagged loadouts are the addon's. `savedLoadoutNames`, wearing by name
  (`ClassTalentHelper.SwitchToLoadoutByName`), the build in play, the queue's watched name and every
  message go through one pair of functions, tag and untag, so no caller builds a name by hand.
- The spare (card `0040`) needs a name that is still the addon's and fits in 30 letters. Decide in
  the build; `[CP] ` plus a marker plus 24 letters is over 30.
- **The clean-up.** "Delete old loadouts" (today druid-only, the Dreamgrove names) also lists this
  spec's untagged loadouts whose name is exactly a plan build name, asks first, never deletes the
  selected one. Offered once per character after the update.

## Acceptance

Written with the build, from the card's What. The checks are `PlanTab.tagChecks` unless named.

<!-- AC:BEGIN -->
- [x] WHEN the addon makes a loadout for a build (Create, Reset), THE APP SHALL name it `[CP] <build>`. proves: `Create makes every missing build, and nothing else, each under the tag (card 0059)`, `Reset to plan deletes a drifted loadout and makes it again, delete then import, by name`
- [x] WHEN a loadout is untagged and named exactly as a build, THE APP SHALL NOT read it as that build, in the list, the build in play or a replace. proves: `a loadout's key, an untagged one named as a build is from before the tag`, `an untagged loadout named as a build is not read as the build`
- [x] WHEN a build is worn by name, THE APP SHALL ask Blizzard's helper for the tagged name. proves: `talents button loads a saved loadout through ClassTalentHelper, by its tagged name (card 0059)`, `drawn Talents button loads the picked boss's loadout`
- [x] WHEN the worn loadout is reset, THE APP SHALL make it as `[CP+] <build>` and rename it `[CP] <build>`. proves: `Reset to plan swaps the loadout you are wearing, made new, worn, old deleted, renamed`
- [x] WHEN a build is worn through the spare, THE APP SHALL name the spare `[CP*] <build>`. proves: `a build with no loadout of its own is worn through the spare, made once the window is shut`
- [x] WHEN any stored build is made under any of the three marks, THE APP SHALL keep the name within 30 letters. proves: `the [CP] tag, every build's made names fit in 30 letters`
- [x] WHEN loadouts from before the tag exist, THE APP SHALL ask first, then rename each to its tagged name, delete one only where a tagged one is there already, and never delete the one you are wearing. proves: `the loadouts from before the tag, renamed, or deleted where a tagged one is there`, `... the one you are wearing is never deleted`, `the offer asks about them first, and made nothing`
- [ ] WHEN Rob logs in on a character with old untagged loadouts, THE APP SHALL offer "Tag them", and afterwards the talent window lists `[CP] ` names holding the same talents. proves: manual
<!-- AC:END -->

## Not this card

- The build manager: card `0057`.

## Comments

**2026-09-24, Claude.** Written when `0058` was split.

**2026-09-24, Claude.** Card `0060` added a second made name: the worn loadout is reset through
`<name> (new)` (`PlanTab.SWAP_SUFFIX`), then renamed. With the tag that is 5 + 24 + 6 = 35 letters,
over 30. Shorten the suffix, or treat it as the spare's name is treated.


**2026-09-25, Claude. Built, v0.48.0.** WRITTEN WITH THE BUILD: the criteria were written from the
card's What while building, not agreed in advance. Attack the code, not the boxes.

What was decided in the build, and why:
- **The spare is `[CP*] <build>`, and the swap's new loadout is `[CP+] <build>`.** Both are the
  addon's by their mark and fit 30 letters with a 24-letter build name (6 + 24). The tag plus
  " (new)" did not (35). A check reads every stored build of every spec under all three marks.
- **The clean-up renames rather than deletes.** `C_ClassTalents.RenameConfig` keeps the talents
  and the slot, and works on the loadout you are wearing, so nothing drops to the starter build and
  nothing is made again. It deletes an old one only where a tagged one of that build is there
  already, and never the worn one. Old `BiS: ` spares this character recorded become `[CP*] `.
- **Where it is offered.** In the login offer (and More > Make the planned loadouts), before
  Create: until the old ones are renamed their builds read as missing, and Create would make each a
  second time. It is offered on every class, not only druids. "Delete old Dreamgrove loadouts"
  is unchanged.
- **One translation point.** `PlanTab.savedLoadoutNames()` keys a tagged loadout by its build
  (`PlanTab.loadoutKey`), a player's own by its own name, and puts pre-tag ones in a third return.
  So every `saved[build]` in the file finds the tagged loadout without change. Wearing by name reads
  the config's own name (`PlanTab.loadoutNameOf`). The /simc export reads the same keys.

Checked: `lua offline-check.lua` under Lua 5.1.5, exit 0, no FAIL line. Spec mode 250, 62, 1467, 73
clean; the druid specs 102 to 105 give 8 FAIL lines each, the same count as at HEAD before this
card. Mutations (`%TEMP%\mut0059`): 12 of 12 caught after one check was added for Create's names.

Left for card `0057`: a tagged loadout whose build is no longer stored reads as the player's own
under Your loadouts. Card `0060`'s review findings are fixed separately, on that card.

Rob's look, after `/reload` on a character that has loadouts from before this version:
1. A box says "N loadouts were made before this addon tagged its own" and lists each with what
   happens to it. Click Tag them.
2. The talent window lists them as `[CP] <build>`, with the same talents, and the one you wore is
   still on.
3. The list beside the talent window shows those builds as saved (not grey).

**2026-09-25, Claude (adversarial review of 5f04660). Bounced to todo: two findings, one coverage
hole of four survivors.**

What was run. A copy of 5f04660 (`git archive`) in `%TEMP%\rev0059`, with the `DjinnisBiS` stub
copied beside it (without it the stub check FAILs, which is the scratch copy, not the build).
`lua offline-check.lua` under Lua 5.1.5 (`C:\Program Files (x86)\Lua\5.1\lua.exe`; the `lua` on
PATH is 5.4.6) and under 5.4.6: exit 0, no FAIL line, whole output read. Spec mode 250, 62, 1467,
73, 66, 262, 577: clean. 105: 8 FAIL lines (`RaidWarningUtil` nil, and the hover lines), the known
druid count. The working copy was not used: it holds card `0060`'s edits in progress.

API claims checked against `wow-ui-source` (live, 09b9db794). `C_ClassTalents.RenameConfig(configID,
name) -> success` and `DeleteConfig(configID) -> success` exist, both `SecretArguments =
"AllowedWhenUntainted"`; the addon passes only its own plain strings and ids, so that holds. The
edit dialog calls `RenameConfig` on whichever loadout it was opened for
(`Blizzard_ClassTalentLoadoutEditDialog.lua:56`), which supports, but does not prove, renaming the
worn one. `letters="30"` is at `Blizzard_ClassTalentLoadoutDialogTemplates.xml:25`; it counts
characters and Lua's `#` counts bytes, so the 30-letter check is on the safe side.
`ClassTalentHelper.SwitchToLoadoutByName` loads the first of duplicate names, as the code assumes.

Mutations, 20 in `%TEMP%\rev0059m` (driver `%TEMP%\mut0059rev.ps1`). 14 caught: untagged build name
read as the build, Create or Reset or the swap's rename untagged, `loadoutNameOf` answering the key,
the worn old one deleted, the old-first offer skipped or shown when only a "stays" is left, the
active loadout read by raw name, `savedLoadoutNames` keyed by raw name, an old spare renamed with the
tag, `tagOld` unfenced, the sidebar listing `[CP+] `, an unrecorded `BiS: ` read as ours. **Six
survive:**
- **M09, `savedLoadoutNames` never fills its third return** (`elseif before then old[name] = id end`
  removed): every check green. The whole clean-up enters through that return, and the tag checks
  replace `savedLoadoutNames` with a stub, so nothing proves that a real listing ever offers "Tag
  them". **Finding 1.**
- M20, `simcAppend` with an empty `saved` (its read rewritten onto `savedLoadoutNames` in this
  commit): green. The /simc export's "saved" marks are untested through the real read.
- M14, `noteMade`'s fallback lookup without `untag`: green (the `pendingID` path covers the usual
  case; the fallback is card `0055`'s level note when the list lags).
- M17, `loadoutNameOf`'s fallback when the game will not list loadouts answering the bare build:
  green. The criterion "wearing by name asks for the tagged name" is only proved when the list reads.
- M18, M19: the failure message's label, and the re-offer after "Tag them". Cosmetic; noted only.

**Finding 2: declining the clean-up locks out Create and Reset from the menu.** `offerLoadouts(true)`
shows the "Tag them" box first whenever any renamable old loadout exists, and its "Not now" sets
only `offerDismissed`, which `asked` ignores. So a player who wants to keep their own untagged
"Raid" (the very case in `## Why`) can never reach Create or Reset to plan through More > Make the
planned loadouts; the only way forward is to let the addon rename or delete it. And since untagged
builds read as missing, Create there would make `[CP] X` beside it with no clash, so the ordering
the build comment gives ("Create would make each a second time") is a slot cost, not a harm. Fix:
let "Not now" on the old box fall through to the missing/drifted offer, or put "Tag them" as one
more button on that offer.

Held, and looked at: every caller named in the brief. `SwitchToLoadoutByName` (loadTalents via
`loadoutNameOf`; the spare and swap with their marks), `ImportLoadout` (takes `job.name`, which
Create, Reset, spare and swap all build tagged or marked), `RenameConfig` (swap to `tag(name)`,
`tagOld` to `o.to`), `GetConfigInfo` readers (`savedLoadoutNames`, `activeLoadoutName`,
`configName`, `wearMadeSpare`), `resetDrifted`'s `twice` and swap lookups (`[CP+] X` is keyed by its
own name, since it does not start with `[CP] `), `tidy` (an untagged Dreamgrove name keys as itself
and is still found). No caller compares a build to a raw config name any more.

Lower, not blocking, for whoever picks it up:
- `## What` says "no caller builds a name by hand"; `PlanTab.SPARE .. name` and
  `PlanTab.SWAP_MARK .. name` are still concatenated in about eight places (`wearSpare`,
  `wearMadeSpare`, `swapSelected`, `finishSwap`, `resetDrifted`, `oldLoadouts`, the sidebar tooltip).
  Consistent today; a pair of functions like `tag` would keep them so.
- `## What` says the clean-up is "offered once per character after the update"; it is offered on
  every login and spec change while one is left, until "Not now" for the session.
- The deletion branch removes an untagged loadout named as a build when a tagged one exists. That
  one may be the player's own. It is asked first with a red line, which is what Rob accepted.
- `old` is keyed by name, so two untagged loadouts of one name list as one; the second is offered
  for deletion on the next pass. The count line says "1 loadouts".
- A worn untagged one that "stays" is said only inside `tagOld`; when it is the only one, the offer
  skips it without a word.

Security. **Weakest point:** identity is still a name. Anyone who names a loadout `[CP] X` (the
player, or an import string shared with that name) makes it the addon's, and Reset to plan will
delete and remake it. That is the design; the tag narrows it from "any name equal to a build" to "a
name that asks for it". **Unchecked:** loadout names from the game pass `canRead` before use as keys
or in chat; build names are the addon's own data. No new event registration, so the protected-event
trap does not apply. **Leaks:** nothing leaves the client; failures print a loadout name to the
player's own chat.

UI surface: the "Tag them" box, the renamed loadouts in Blizzard's talent window, and the sidebar.
In-game only; no agent can run the client, so the last criterion stays `proves: manual` and
unticked.

**2026-09-25, Claude. The review's findings, fixed in v0.48.2.**

1. **The real listing is checked.** `PlanTab.tagChecks` now runs the real `savedLoadoutNames` over a
   pretend game list: tagged loadouts keyed by build, a tagged name held twice, the player's own and
   a `[CP*] ` spare under their own names, an untagged build name and a recorded `BiS: ` spare in the
   third return, and the real offer then asks "Tag them" (the review's M09 is red, 3 lines).
2. **"Not now" on the renaming skips only the renaming**, for the session and spec
   (`PlanTab.oldDismissed`), and goes straight on to the Create / Reset box, which then carries a
   "Tag old loadouts" button. So a player can keep an untagged "Raid" and still reach Create and
   Reset. Create then makes `[CP] Raid` beside it: a slot, not a clash.

Also, from the lower notes: `PlanTab.spareName` and `PlanTab.swapName` replace every hand-joined
spare and swap name (13 places); "1 loadout was made" reads right; and checks now cover M14
(`noteMade` finding a made loadout by its build when the watched id is lost), M17 (wearing by the tag
when the game will not list) and M20 (the /simc export reading the real keys). "Offered once per
character" stays as built: it is offered while one is left, until "Not now" for the session.

Checked: `lua offline-check.lua` under Lua 5.1.5 and 5.4.6, exit 0, no FAIL line. Spec mode 250, 62,
1467, 73 clean; 102 its usual 8. Mutations (`%TEMP%\mut0059b.ps1`): M09, M14, M17, M20 and five for
the new code, 9 of 9 caught after one check was added.

**2026-09-25, Claude (second adversarial review, of b566a62's 0059 part). Bounced to todo: one
finding.**

What was run. `lua offline-check.lua` in the repo (clean tree at b566a62) under Lua 5.4.6 and 5.1.5:
exit 0 both, "no FAIL lines", 20 lines of output read whole, `[CP] self-test passed`. The builder's
`%TEMP%\mut0059b.ps1` (scratch copy): 9 of 9 caught, M09 (3), M20, M14, M17, the `oldDismissed`
removal (3), the missing Tag button, `askAgain` ignoring the spec, `onlyAsked` filtering nothing,
Create acting on all. `RenameConfig`, `DeleteConfig`, `GetConfigIDsBySpecID` re-read in
`ClassTalentsDocumentation.lua`: present, `AllowedWhenUntainted`; this commit adds no API call.

Earlier findings, each closed:
- **Finding 1 (M09): closed.** The check now calls the real `savedLoadoutNames` (`kept[1]`) over a
  pretend `GetConfigIDsBySpecID` / `GetConfigInfo`: tagged keyed by build, a doubled tag in `twice`,
  the player's own and a `[CP*] ` spare under their own names, an untagged build name and a recorded
  `BiS: ` spare in the third return, then the real offer answers "old". M09 goes red.
- **Finding 2 (the lock-out): closed for the case it named.** "Not now" on the renaming sets
  `oldDismissed[spec]` and re-offers; with anything missing or drifted the Create / Reset box follows,
  carrying "Tag old loadouts". Checked by the new lines and by two of the mutations.
- M14, M17, M20: each now has a check and each mutation goes red. `spareName` / `swapName` replace
  every hand-joined `SPARE ..` and `SWAP_MARK ..` in the file (grep: none left outside the helpers).

**Finding: declining the renaming can show an empty box.** The second pass of `offerLoadouts` goes
on to the Create / Reset box whenever `doable`, even with nothing missing or drifted (line 7470 now
reads `and not doable`). Then `lines` is empty and the buttons are only "Tag old loadouts" and "Not
now". Probe in `%TEMP%\rev0059b2` (a scratch copy; `loadoutGaps` stubbed to `{}, {}`, saved
`{ Dungeon = 9 }`, old `{ Dungeon = 1 }`): the first box lists "Dungeon deleted: a tagged one is
there"; after "Not now" the next box has `lines=0 text=[] buttons=Tag old loadouts,Not now`. That
state is the path this fix opened: keep an untagged "Raid", click Create, and `[CP] Raid` is made
beside it. From the next /reload on, every login and spec change offers to delete "Raid", and
declining leads to a blank box whose "Tag old loadouts" would delete it with no line saying so. The
same blank box appears when `room == 0` empties `missing`. Fix: when nothing is missing or drifted
after the renaming is declined, stop there (return "complete" or "dismissed"), and give the second
box one line naming what "Tag old loadouts" does, delete included. A check for the blank case.

Lower, not blocking: the card is now about 200 lines, twice the board's 100; the thread could be
cut to the verdicts when this comes back.

Security. Unchanged from the first review: identity is a name, so a `[CP] X` anyone makes is the
addon's; names from the game pass `canRead` before use; no new event registration; nothing leaves
the client. The new code adds no input path.

UI surface: the two offer boxes. Not looked at: no agent can run the client. The last criterion
stays `proves: manual`.