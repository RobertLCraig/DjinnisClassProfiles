---
needs: 0058
---
# 0059 The "[CP] " tag on every loadout the addon makes

## What I need from you

1. Deploy v0.48.4 (`.\bin\deploy.ps1 -WhatIf -Only DjinnisClassProfiles`, then without `-WhatIf`),
   `/reload` on a character with loadouts from before the tag, and click "Tag them".

**Pass:**
- The box lists each old loadout with what happens to it (renamed, or deleted in red).
- The talent window then shows `[CP] <build>` names with the same talents, and the one you wore is
  still on.
- The list beside the talent window shows those builds as saved, not grey.

**Fail:** a loadout lost, the worn one dropped to the starter build, or a Lua error. Move the card
to `todo/` with what you saw.

**Why it needs you:** no agent can run the game client; every offline check and mutation is green.

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

**2026-09-25, Claude. The second review's finding, fixed in v0.48.3.** No empty box: when the
renaming was declined and nothing is missing or drifted, the login offer stays quiet, and an
explicit ask (More > Make the planned loadouts) shows the renaming's own box again, with its list.
"Tag old loadouts" on the Create / Reset box now opens that list first and changes nothing itself.
Checked: three new checks in `PlanTab.tagChecks`; `%TEMP%\mut-round3.ps1` breaks "empty box back"
and "Tag old acts at once" are both red. The card's length (the review's minor) is its comment
thread; pruning it is Rob's call under the board rules, so it is left.

**2026-09-25, Claude (third adversarial review, of 91f8591's 0059 part). Bounced to todo: one
finding.**

What was run. `lua offline-check.lua` in the repo (clean tree at 91f8591) under Lua 5.4.6 and 5.1.5:
exit 0 both, "no FAIL lines", `[CP] self-test passed`, output read whole. `%TEMP%\mut0059b.ps1`: 8
caught, "no Tag old button" now PATTERN MISSING (the code it targeted was rewritten; my own version
of it below is caught). `%TEMP%\mut-round3.ps1`: 8 of 8 caught, including "empty box back" (2) and
"Tag old acts at once" (1). My own, in `%TEMP%\rev0059c4`: the Tag old button removed (caught 2),
`doable and asked` loosened to `doable` (caught 1), the button not clearing `oldDismissed` (caught
1), the button re-opening as a login offer rather than an ask (missed; see lower). No new API call.

Earlier findings: the first review's two and the second review's empty box are closed. The second
box never renders with no lines (line 7470 returns before it), and "Tag old loadouts" now opens the
renaming's list, delete lines included, and changes nothing itself.

**Finding: "Not now" on the renaming, from an explicit ask with nothing else to do, re-opens the
same box for ever.** The "Not now" closure sets `oldDismissed[spec] = true` and re-offers with the
same `asked` (line 7457). With nothing missing or drifted, the new branch at line 7473 (`doable and
asked`) clears `oldDismissed` and recurses into the renaming box again. Probe in
`%TEMP%\rev0059c3` (`later` run at once, `loadoutGaps` stubbed to `{}, {}`, after the check at line
9739): three clicks of "Not now" give `Not now->Tag them/3` each time, `oldDismissed` nil at the end.
In the client the box closes and is back 0.2 s later. Only Escape or the X gets out; the two
buttons are "Tag them" and a "Not now" that does not. This is the second review's own path: a player
who kept an untagged "Raid", let Create make `[CP] Raid`, then asks More > Make the planned loadouts,
sees "Raid deleted" and a "Not now" that keeps offering it until they press the button that deletes
it. No check clicks "Not now" on that box. Fix: the re-offer after "Not now" must not land in the
"asked, show the renaming again" branch (for example re-offer with a marker that the renaming was
just declined, and in that case say "Every planned build is saved" and stop), plus a check that
clicks "Not now" there and sees no box.

Lower, not blocking: "Tag old loadouts" re-offers with `offerLoadouts(true)`; a mutation making it
`offerLoadouts()` survives (the login path would then return "dismissed" after an earlier login
"Not now", and the button would do nothing). A one-line check would pin it.

Security. Unchanged: identity is a name; game names pass `canRead`; no new event registration or
input path; nothing leaves the client.

UI surface: the two offer boxes. Not looked at: no agent can run the client. The last criterion
stays `proves: manual`.

**2026-09-25, Claude. The third review's finding, fixed in v0.48.4.** "Not now" on the renaming now
tells the next offer it was declined (`offerLoadouts(asked, declined)`, carried through the busy
retry too). With nothing else to do it closes, and chat says the old untagged loadouts are left as
they are; it does not come back. The minor is closed too: "Tag old loadouts" is checked to reopen
as an ask even when the login offer was dismissed. `%TEMP%\mut-round4.ps1`: 3 of 3 caught, and
`mut-round3.ps1` still all red. Offline check exit 0 under 5.1.5 and 5.4.6.

**2026-09-25, Claude (fourth adversarial review, of 1956cea). Clean: to human-review, only the
in-game criterion is open.**

What was run. `lua offline-check.lua` in the repo (clean tree at 1956cea) under 5.1.5 (the `lua` on
PATH is now 5.1.5) and 5.4.6 (`%LOCALAPPDATA%\Programs\Lua\bin\lua.exe`): exit 0 both, "no FAIL
lines", `[CP] self-test passed`, the 20 lines identical and read whole. `mut-round4.ps1` 3 of 3
caught, `mut-round3.ps1` 8 of 8, `mut0059b.ps1` 8 caught and "no Tag old button" PATTERN MISSING
(its target was rewritten in round 3; covered by round 3's own). Mine (`%TEMP%\mut-rev0059d.ps1`,
scratch `rev0059d`): the "left as they are" line dropped (caught), the declined branch removed
(caught), `declined` also skipping the Create / Reset box (caught 3), each busy retry dropping
`declined` (both survive; see below). No new API call; the DECISIONS secret and protected-event
entries do not apply.

Earlier findings: all closed. The third review's box that came back for ever: "Not now" re-offers
with `declined`, and with nothing missing or drifted line 7479 says so in chat and stops; the check
at line 9747 clicks it and sees no box. Its minor: "Tag old loadouts" reopening as a login offer is
pinned by `offerDismissed = { Feral = true }` before the click (round 4 catches it). The first two
reviews' findings are unchanged since they were closed.

Attacked, held: declined with builds missing still reaches Create / Reset (`declined` only acts in
the nothing-to-do branch); a later explicit ask with nothing to do shows the renaming again, as it
should; a spec change between the click and the 0.2 s re-offer marks only the old spec and offers
the new spec's own box; `room == 0` emptying `missing` falls into the declined line, not a blank box;
`Tag old loadouts` → `Not now` → the Create box again, which has its own "Not now", so no trap. The
login path now prints one chat line after its own "Not now"; the player just clicked, so that is
an answer, not noise.

Lower, not blocking: the two busy-retry survivors are harmless. The first retry is reached only when
the renaming is not dismissed, where `declined` does nothing; the second only with builds missing,
and `declined` matters there only if another prompt stays open 3 s and the plan fills meanwhile.
The card is over the board's 100 lines; pruning its thread is Rob's call.

Security. Unchanged: identity is a name, so a `[CP] X` anyone makes is the addon's; game names pass
`canRead`; no new event, input path or API call; nothing leaves the client.

UI surface: the two offer boxes and the talent window. Not looked at: no agent can run the client.
The last criterion stays `proves: manual`; the ask is at the top of the card.
### 2026-09-25 — failed in a live client, fixed in v0.48.5

Rob pressed "Tag them" with 4 old loadouts on Guardian. Each press renamed one. The game said "You can't do that right now" and chat said "The game would not rename" for the rest.

Cause: `tagOld` sent every rename in one frame. The server takes one loadout change at a time and refuses the others (`RenameConfig` returns false). No API says it is busy.

Fix: `tagOld` starts a queue and `PlanTab.tagNext` sends one change, polls `configName` every `PlanTab.POLL` until it lands, then sends the next. A change that never shows is waited out after `PlanTab.GIVE_UP` and said. A refused one is said and skipped. A second click while it runs says "Still renaming". Combat stops the queue.

Checks: `tagChecks` now models one change in flight. Five mutants (all at once, no busy guard, refused stops, never gives up, landed ignores name) are all caught; "never gives up" hangs the check, which fails it.

In-game check again: `/reload`, open the loadout box, press "Tag them" once. All old loadouts should be renamed in turn, about half a second apart, then one "Tagged N old loadouts." line.

**2026-09-25, Claude (fifth adversarial review, of f7c5dae only). Findings: bounce to todo. Not
moved and not committed; the brief said no commit.**

What was run. `offline-check.lua` under Lua 5.1.5 in the repo (clean tree at f7c5dae): exit 0, "no
FAIL lines". A `git archive` copy in `%TEMP%\rev0059e` with the `DjinnisBiS` stub, probes spliced
into `tagChecks` (`probe.lua`, `patch.py`) and six mutations (`muts.sh`). API re-read in
`wow-ui-source` (09b9db794): `RenameConfig` / `DeleteConfig` return `success`, nothing says "busy"
(`CanChangeTalents` is about staged changes, `CanEditTalents` about switching). `TraitConfigInfo.name`
is a plain string and no `C_Secrets` predicate covers traits, so the name comparison in the poll
cannot throw on a secret.

**The stuck queue held.** Every path out of `tagNext` either clears `PlanTab.tagging`, recurses, or
schedules a poll, and every poll either reschedules or calls `tagNext`. `/reload` wipes the flag;
the rest are then offered on the next login. A loadout deleted by the player before its turn is
refused, said, skipped; one deleted while its rename is in flight reads nil, is waited out for 15 s,
said, and the queue goes on. `configName` is `pcall`ed. No stuck state found.

**Finding 1: one refusal empties the whole queue in the same frame, which is the bug this commit
fixes.** The refused branch (line 7435) says it and calls `tagNext` at once, with no wait, so the
next one is sent while the same change is still in flight and is refused too. Probe A (server busy
at the click, free a moment later): `refused 1|refused 2`, "Tagged 0 old loadouts." Probe A2 (the
new name reads before the server lets go, by one poll): `rename 1|refused 3|refused 2`, "Tagged 1
old loadout." That is Rob's live result exactly. It happens whenever "landed" (a client-side name
read, line 7443) comes before the server's one-change lock clears, which no source confirms either
way, and on any click while another change is in flight: a spec change (the login offer appears 2 s
after it), a loadout the player just picked, the addon's own Create or swap. Fix: on a refusal, wait
`POLL` and retry the same one, a few times, before skipping it; and wait one extra `POLL` after a
landing before sending the next. A check whose fake refuses while locked (A2's model).

**Finding 2: nothing else waits for the queue.** `loadoutFence` checks `PlanTab.q`, not
`PlanTab.tagging` (probe B: fence nil while tagging), and `wearSpare` checks only `q`. So while it
runs, Create / Reset to plan (from the new spec's offer after a spec change), a double-click in the
list beside the talent window (a build not renamed yet reads missing, so it goes through the spare:
import, delete, rename), the Talents button (a loadout switch), or `/dcp tidy yes` all send changes
that collide with a rename in flight, and each collision feeds Finding 1. Create during the queue
also makes `[CP] X` for a build whose old `X` is about to be renamed to `[CP] X`: two of one name.
Fix: `loadoutFence` and `wearSpare` say "Still renaming" while `PlanTab.tagging` is set.

**Finding 3: "never the worn one" is checked at the click, not at the delete.** The queue now spans
seconds (up to 15 s per item). Probe C: the player picks the untagged "Raid: Vashnik" in the talent
window after the click; the queue still deletes it (`rename 1 to [CP] Dungeon|delete 2`, selected
= 2), which drops them to the starter build. Rare, but it is the one loss the card promises never
happens. Fix: `tagNext` re-reads `selectedConfigID()` before a delete and skips it with the
"stays" line.

**Coverage.** My mutations: giving up after one poll (M6), no combat stop inside `tagNext` (M1),
no stale-poll guard (M2), no re-offer at the end (M3), a delete landing on any name (M4) all
**survive**; only "a refused one leaves `tagging` set" is caught. M6 matters: the fake lands every
change before the first poll, so nothing proves a slow landing is waited for, which is the point of
the fix. A check where the name appears on the third poll would pin it.

Spec change mid-queue: config ids are per loadout, so the id renamed is still the loadout that was
listed, not another spec's. The risk is the spec change itself being a change in flight (Finding 1).

Lower, not blocking: `tidy`'s delete loop (line 7578) still sends every delete in one frame, the
same refusal on a druid with more than one old Dreamgrove loadout. Pre-existing, not this commit.

Security. No new API call, event or input path; `RenameConfig` / `DeleteConfig` are
`AllowedWhenUntainted` and get the addon's own ids and names. Weakest point: "landed" is inferred
from a client-side name read, not from the server. Nothing leaves the client.

UI surface: chat lines and the talent window. Not looked at: no agent can run the client. The
in-game criterion stays `proves: manual`.

### 2026-09-25 — review fixes, v0.48.6

1. **A refusal now waits and tries again.** `tagNext` retries the same loadout up to `PlanTab.TAG_TRIES` (8) times, a `POLL` apart, before it says "would not". After each change lands it waits one more beat before the next, so the normal case sends no change the server must refuse.
2. **Nothing else changes a loadout while the queue runs.** `loadoutFence` (Create, Reset, tidy, the spare), `wearSpare` and `loadTalents` (double-click, the Talents button) answer "Still renaming old loadouts" while `PlanTab.tagging` is set.
3. **The worn loadout is read again before each delete.** One picked after the click stays, and chat says so.
4. **Checks:** `tagChecks` now runs against a timed server model: a change shows `lag` beats after it is sent, and the server is busy one beat past that. New checks: server busy at the click, a slow rename (12 beats), a loadout picked mid-queue, combat mid-queue, a stale poll alone and beside a new queue, the box coming back at the end, a delete that never lands, and the three fences. 14 mutants (the reviewer's five survivors among them) are all caught.
5. **Not fixed here:** `tidy` still deletes in one frame. That is card 0062.

**2026-09-25, Claude (sixth adversarial review, of f7c5dae and 687b844). Findings: bounce to todo.
Not moved and not committed; the brief said no commit.**

What was run. `offline-check.lua` under Lua 5.1.5 in the repo (clean tree at 687b844): exit 0, "no
FAIL lines", `[CP] self-test passed`. A `git archive` copy in `%TEMP%\rev0059f` with the `DjinnisBiS`
stub, 18 mutations (`%TEMP%\rev0059f\muts.py`). API re-read in `wow-ui-source`: `RenameConfig` and
`DeleteConfig` answer `success` and nothing else; nothing says "busy". The "You can't do that right
now" text is not in the Lua source, so it cannot be confirmed from there that each refused retry puts
up the red error, but Rob saw one for each refused call.

**The three earlier findings are fixed.** (1) A refusal waits a `POLL` and retries the same loadout up
to `TAG_TRIES`, and each landing gets one more beat: no retry (TAG_TRIES 1), a retry that steps on,
a retry with no wait, and no extra beat are all caught. (2) `loadoutFence`, `wearSpare` and
`loadTalents` answer "Still renaming" while `PlanTab.tagging` is set, and removing any one of the three
is caught. (3) The worn loadout is read again before a delete, and removing that is caught. The last
review's coverage survivors are all caught now: the stale-poll guard, the combat stop, the end offer,
giving up after one poll, and a landing counted on any name.

**The queue can end.** Every path out of `tagNext` clears the flag, recurses, or schedules an
`after` that re-checks `tagging == t`. Retries stop at 8, and a poll gives up after 15 s, so one item
takes at most about 20 s. The only calls a timer runs outside a `pcall` are `say`,
`selectedConfigID` (whose own reads are `pcall`ed), `InCombatLockdown`, and a `format` of a name that
has passed `canRead`. No error was found that leaves `tagging` set. `/dcp test` during a queue is
safe too: the self-test runs in one frame and puts `PlanTab` back before any real timer fires.
Removing the end-of-queue clear is caught (11 lines). The end offer runs after the clear, so the
fence never blocks it, and no step of the queue goes through the fence.

**Finding 1: `setupStep` takes "busy" as "done" and drops the loadout.** It is the one caller that
reads `loadTalents`' answer, and it goes on to the gear on anything but "loaded" (line 4846), then
clears `pendingSetup`. Its comment ("the window is open and one line said so") is not true of the new
"busy". Scenario: Rob clicks Tag them, a group accepts him while the queue runs, and he clicks Set up
on "Group joined". The spec change goes out through `SwitchToSpecializationByIndex`, which is not
fenced, while a rename is still in flight. One second after the spec lands, `loadTalents` answers
"busy" and the gear goes on without the loadout, and nothing tries the loadout again. Chat says only
"Still renaming old loadouts". A spec change mid-queue also makes the delete re-read ask about the
new spec's worn loadout, not the old spec's. Fix: in `setupStep`, keep `steps.loadout` on "busy" and
try again when the queue ends, as "waiting" does for combat; or refuse Set up while `tagging` is set.
Add a check for it.

**Finding 2 (next to this card, card 0060's code): the fence does not cover a swap in progress, and
the swap sends two changes in one frame.** `finishLoadouts` clears `PlanTab.q` before
`swapSelected`, and a swap with no jobs never sets it. For up to 15 s nothing marks the addon busy
while the switch is polled. More > Make the planned loadouts, then Tag them, passes the fence then,
and its renames collide with the swap's changes. Worse, `finishSwap` sends `DeleteConfig(old)` and
then `RenameConfig(new)` in the same frame (lines 7265 and 7271), right after the switch has landed.
By this card's own live result, the rename is refused and Reset on the worn loadout ends at "Rename it
in the talent window". `importOne`'s delete-then-import (line 7042 then 7045) is the same kind of pair.
Card 0062 names only tidy. This wants its own card, or 0060's in-game check should look for it.

**Coverage.** Two mutations survive: the combat stop skipped on a retry (`and not again`), and the
worn re-read skipped on a retry. The code is right today, but only the first attempt is checked. A
refused delete that is then picked in the talent window before its retry would go unguarded by any
check. The server model is also fitted to the code: the lock ends exactly one beat after the name
reads, and that is the one beat the code waits. So the normal path's "no refusal" holds only for a
lock of 0.5 s or less after the name updates, and past that the retries carry it (about 3.5 s). The
model does not model a switch or a spec change as a change in flight.

Lower, not blocking:
- `offerLoadouts` does not look at `tagging`. The spec-change offer, 2 s after a spec change
  mid-queue, shows a box whose every button answers "Still renaming".
- Closing the talent window and clicking Tag them within 0.5 s means `spareOnHide`'s `wearSpare`
  answers "busy", and the double-clicked build is dropped with only that line.
- "Combat started ... Click again after the fight" does not say where to click (More > Make the
  planned loadouts).
- `C_ClassTalents.RenameConfig = keptRename` has the next comment on the same line (line 9861):
  harmless, a lost newline.

Security. No new API call, event, or input path. `RenameConfig` and `DeleteConfig` are
`AllowedWhenUntainted` and get the addon's own ids and names. Weakest point, unchanged: "landed" is
read from a client-side name, not from the server. Unchecked: nothing new. Leaks: nothing leaves the
client.

UI surface: chat lines, the offer box, and the talent window. Not looked at: no agent can run the
client. The in-game criterion stays `proves: manual`.

### 2026-09-25 — second review fixes, v0.48.7

Live result before these fixes (Rob, Feral, 10:47): 10 old loadouts, "Tagged 8" with two "would not rename" in the same second, then "Tagged 2" on a second click. The same-second timing is 0.48.5's cascade (0.48.6 reached the game folder at 10:46:10 and the client was not reloaded), so it confirms the first review's finding 1 rather than testing its fix.

1. **A group setup waits for the queue.** `setupStep` answers "renaming" and keeps its steps while `PlanTab.tagging` is set; `PlanTab.afterTagging` runs it again when the queue ends, whether it finished or combat stopped it. setupStep then waits out combat itself.
2. **The loadout offer waits too.** Mid-queue `offerLoadouts` answers "renaming" (and says so when asked); the queue's end offers again.
3. **Checks:** combat and the worn loadout before a retry; the setup held and resumed at the end and after combat; the offer mid-queue. 19 mutants, all caught.
4. The combat line names the button (`More > Make the planned loadouts`), not a slash command. The comment that lost its line break is fixed.
5. **Not here:** `finishSwap` and `importOne` send two changes in one frame. That is card 0063. A double-click made with the talent window open is dropped if Tag them starts within 0.5 s of the window closing; chat says "Still renaming", so it is left.
