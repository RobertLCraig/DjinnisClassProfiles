# 0067 The spare deletes old spares in a loop, then imports in the same frame

## Why

Card `0063`'s review, 2026-09-25. `PlanTab.wearSpare` deletes every old spare this character made
in one `for` loop, then starts the import queue at once. The server takes one loadout change in
flight (the trap in `docs/HANDOVER.md`), so the second delete and the import can be refused. The
queue's quiet retry usually makes the spare anyway, so nobody has seen it fail. It still breaks the
rule: a list goes through `PlanTab.startTagging`, never a loop.

## What to do

- Send the old spares' deletes through `startTagging`, and start the spare's import once that queue
  ends. `PlanTab.afterTagging` is the hook, as `setupStep` uses it.
- Or give the spare job a `replace` for the one old spare, as Reset does (card `0063`). The queue
  then deletes it, waits for the delete to land, and imports.
- Keep the worn spare: it is never deleted (card `0040`).

## Done when

1. `lua offline-check.lua` passes, with a check against `swapChecks`' timed server model: two old
   spares and a new one, and no call refused.
2. In game: double-click three different unsaved builds, one after the other. Each is worn through
   the spare, and chat never says "You can't do that right now".

## Comments

**2026-09-25, Claude.** Built, v0.52.5. I took the second way. The new spare's job gets a
`replace` for the old spare, and the queue from card `0063` deletes it, waits for the delete to
land, then imports. There is only one old spare to replace: a worn spare stays until the next one
is on, so there is one spare that is not worn, at most. A second, left by some fault, is deleted
at the next wear. This is why the check has one old spare and one worn spare, not two old ones.
`wearMadeSpare` forgets the replaced spare's id once it is gone (`job.oldSpare`). The no-room
check now counts the old spare as the room.

The check is in `swapChecks`, on the timed server. It expects "delete 3|import|wear", no refused
call, and the worn spare kept. Breaking the fix three ways made 6, 9 and 1 checks fail.

**2026-09-25, Claude (adversarial review of 7bae4dd).** Does not hold: one regression, and the
"second spare goes at the next wear" claim is false. Stays in `ai-review/`. Line numbers are at
7bae4dd.

Run: `offline-check.lua` and `offline-check.lua 250` under Lua 5.1 on a temp copy, both end "no
FAIL lines". Then five probes added to `swapChecks` on the temp copy only, on the same timed server:

1. **Every slot full with an old spare now fails every time (regression).** The no-room check
   (`:7125`) lets the job through because the old spare "is the room". But `importOne` asks
   `C_ClassTalents.CanCreateNewConfig()` (`:7160`) BEFORE it reaches the replace's delete, and at
   the cap that is false: the addon's own refusal text says "or all slots are full", and Blizzard
   greys out New and Import on the same call (`Blizzard_ClassTalentsFrame.lua:516, 541`). Probe:
   cap 3, loadouts Mine, old spare 3, worn spare 4. Result: `wearing`, then no call at all, the
   quiet retry fails the same way, and it prints "failed". The old spare is never deleted, so every
   later double-click fails too. v0.52.4 deleted first and could wear a spare at the cap. Fix: for
   a job with `replace`, skip the `CanCreateNewConfig` gate on the delete step (the string has
   already parsed, so the old loadout is still never lost to a bad string), and let the retry after
   the delete lands check it before the import, which `waitThenStep` already waits for. Add a
   `swapChecks` case with `CanCreateNewConfig` false at the cap. Reset's replace (card 0063) goes
   through the same gate and fails the same way at the cap.
2. **A leftover spare never goes.** The comment at `:7119` and the entry above say it "goes at the
   next wear". Each wear deletes one spare and makes one, so the count never goes down. Probe:
   spares 3, 4, 6, three wears in a row. Result: 3 live and 3 recorded after each one ("delete 3 |
   delete 4 | delete 6"). One slot out of the 40 shared by every spec stays used for good, where
   v0.52.4's loop cleared it. Fix: when more than one spare is not worn, send the extras'
   deletes through `startTagging` and start the spare from `afterTagging`. Or say plainly in the
   comment that a leftover stays.
3. **Wrong name in the failure messages (low).** The spare job's name is the NEW spare. So an import
   refused after the delete landed says `The old "[CP*] Raid: Vashnik" was deleted and not made
   again. More > Make the planned loadouts offers to create it.` (`:7295`), but the old one was
   `[CP*] Raid: Sszorak`, and that menu item never makes spares. A delete that never lands says
   `The old "[CP*] Raid: Vashnik" did not go` (`:7345`), with the same wrong name. Fix: for a job
   with `oldSpare`, name `configName(oldSpare)` (read before the delete) and leave out the menu
   hint.

What held:
- Every slot full with no old spare: answers `full` before any call.
- The old spare becomes the worn one mid-queue: probe E (server busy at the click, then selected
  = 3). `importOne`'s check that the loadout is not the worn one refuses, nothing is deleted, and
  id 3 stays recorded.
- A delete that never lands: probe D. It is sent again once in the final pass and never imported
  over, and id 3 stays in `spareIDs` because `configName` still sees it (`:7245`). If that delete
  lands later, the dead id stays recorded. That is harmless unless the game reuses config ids, and
  v0.52.4 had the same gap.
- An import fails after the delete landed: probe C. `spareIDs[3]` is cleared, and `q.jobs[1]` is the
  same table after `finishLoadouts` swaps in the retry list, so `oldSpare` survives the final pass.
- `spareOnHide`: wearSpare runs from the start 0.5 s after the window closes, so it picks `old`,
  `selected` and `free` again then, and it bails out if the spec or the selected loadout changed.

Security:
- **Weakest point:** deletes go by recorded config id (`DjinnisCPCharDB.spares`). An id that is
  recorded but dead (point D above) would delete somebody else's loadout if the game ever reused it.
  Nothing here checks the name before `DeleteConfig`. Adding `configName(old)` starts with
  `PlanTab.SPARE` to the loop at `:7122` closes it.
- **Unchecked:** the build string goes to Blizzard's own header reader, and a bad one is refused
  before any delete. SavedVariables are trusted as written by this addon. There is no network path.
- **Leaks:** nothing. The messages go to local chat and name only the player's own loadouts.

No UI surface to screenshot: the change is in the queue. The in-game check is still Done-when 2,
plus: at 40 of 40 slots, double-click an unsaved build that has an old spare, and see whether it is
worn.

**2026-09-25, Claude.** Review findings fixed, v0.53.1.

1. Fixed. `importOne` asks `CanCreateNewConfig` just before the import, not before a replace's
   delete. Before the delete it waits only for a busy server: a false answer with free slots.
   With every slot used, the delete goes ahead and frees the slot. This also fixes Reset's
   replace at the cap (card `0063`).
2. Fixed. With more than one spare that is not worn, the extra ones are deleted first through
   `startTagging`, one at a time. That queue now takes an `after` function, run a beat after the
   list ends. The spare is then asked for again, and replaces the last old one. The dead ids are
   forgotten.
3. Fixed. A job carries `oldName`. The two failure lines name the old spare and leave out the menu
   hint.
4. Security point fixed. A spare is taken only through `spareBuild`: its name must start with
   `[CP*] ` and its id must be recorded. A recorded id whose loadout has another name is never
   deleted.

There are new checks: the cap with an old spare, four spares, and a recorded id with another name.
Breaking each fix made 1, 3, 1 and 2 checks fail.

**2026-09-25, Claude (re-review of ab17ce1).** Does not hold: the new leftover path can loop
forever. Stays in `ai-review/`. Line numbers are at ab17ce1. Both offline checks pass under Lua
5.1. I reran the five probes, and added six more, on a temp copy.

Held: the cap with an old spare (A: delete, import, wear). The cap with no old spare answers
`full`. Three leftovers reach two spares, and they stay at two (B). The failure lines name
`[CP*] Raid: Sszorak` (C, D). The old spare picked mid-queue is not deleted (E). A recorded id with
another name is never taken.

1. **:7184–7186 with :7777, medium. A leftover that will not go loops forever.** The `after`
   callback runs whenever the list ends, whether or not the deletes landed. It calls `wearSpare`,
   which finds the same leftover and starts tagging again. Probe F: the delete is taken but never
   lands. After 500 ticks it had been deleted 16 times and was still going. Probe F2: the game
   refuses the delete. 501 calls, still going. Meanwhile `PlanTab.tagging` stays set, so every
   loadout action answers "Still working through old loadouts". Chat repeats "Deleted 0 of 1
   leftover spare loadout" and "The game would not delete" until combat or `/reload`. Fix: tidy
   once per click. Either `after` calls `wearSpare(name, code, true)` and a tidied call skips the
   extras, or it runs only when `t.gone` equals `#extra`.
2. **:7782, low. Combat mid-list gives the wrong instruction.** Probe G says "1 old loadout were
   not done. After the fight, click More > Make the planned loadouts again". That menu never makes
   spares, and nothing says to double-click the build again. The wording is also wrong ("1 ...
   were"). Fix: let the words table carry the combat line.
3. **:7127, low. Combat in the beat between the list's end and `after` gives no word.**
   `wearSpare` returns `combat` silently. Probe H: chat says only "Deleted 1 of 1 leftover spare
   loadout", and no spare is made. Fix: say it when called from `after`.
4. **:7236, low. At the cap the gate cannot tell a busy server from a full one.** So the delete
   goes into a busy server. Probe A2: `delete 3|refused|delete 3|import|wear`. It recovers through
   the quiet retry, but a call is refused. In game a silent drop would cost the 15 s give-up.
5. **The 0063 claim is false (low).** "This also fixes Reset's replace at the cap": Reset goes
   through `makeLoadouts`, whose `loadoutFence(false)` (:7290, :7050) refuses at 0 free slots
   before `importOne` runs. Probe I: "All 40 loadout slots are used". Reset at the cap is unchanged.
   Strike the claim, or pass `anySlots` when every job is a replace.
6. **Note:** two spares with one name share one key in `savedLoadoutNames` (`:4328`), so one is
   never seen and never deleted (probe J). I found no path that makes such a pair. This was the
   same before.

Security: the weakest point from the first pass is closed, because a delete now needs the spare's
name and a recorded id. Unchecked and leaks are unchanged: no network, local chat only.

**2026-09-25, Claude.** Re-review findings fixed, v0.53.3.

1. Fixed. Leftovers are tidied once per click. The call after the tidy run passes `tidied`, and
   that call skips the extras. A leftover whose delete never lands is sent once, and the queue ends.
2. Fixed. Each words table carries its own combat line, with "was" or "were". The spare's says to
   double-click the build again. Your builds' says to rename or delete in the talent window.
3. Fixed. Combat in the beat after the tidy says "In combat, so X was not put on".
4. Not fixed. At the cap the game gives no signal that tells a busy server from a full one. The
   quiet retry recovers, so the cost is one refused call.
5. Fixed, not struck. `makeLoadouts` skips the slot count when every job is a replace and there is
   no swap: each replace deletes before it imports. Reset of a loadout you are not wearing now
   works at the cap. A swap (Reset on the worn one) still needs a free slot for its new loadout.
6. Noted only, as the review says.

New checks: a leftover that never goes, combat in the list, combat after it, a replace at the cap,
and a new loadout at the cap. Breaking each fix made 3, 2, 2 and 2 checks fail. All three modes end
"no FAIL lines".

**2026-09-25, Claude (third review of c6b7af6).** Does not hold: at the slot cap every job now waits
out the 15 s give-up. Stays in `ai-review/`. Line numbers are at c6b7af6.

Run: `offline-check.lua`, `250` and `62` under Lua 5.1 all end "no FAIL lines", and I read the whole
output. Then eight probes and nine mutations, on a temp copy only.

1. **:7520, medium. At the cap the queue stalls 15 s after each import.** After an import,
   `waitThenStep` waits for `CanCreateNewConfig()` to be true. At the cap it stays false, as the code
   itself says at :7324 and :7339, because the import has just used the freed slot. So the wait only
   ends at `GIVE_UP`. On the timed server the spare at the cap took 34 ticks against 8 with room.
   A Reset of two loadouts at the cap took 68 against 16: two stalls. In game that is "Making the
   spare loadout", then nothing for about 15 s, then the build goes on. A second double-click in that
   time says "Still making loadouts". The spare's cap path came in v0.53.1. This commit adds Reset
   to it, where each job adds 15 s. The check "a replace at the cap goes ahead" only reads the calls,
   so it cannot see this. Fix: at the cap, count ready as populated plus one beat, as the delete wait
   does. Add a check that counts `now` at the cap against the same run with room.
2. **:7330 with :7462, low. A wrong message at the cap.** The fence no longer stops a replace at the
   cap. If the replace's old loadout is already gone and another loadout holds the slot, no call is
   made. Chat then says `The old "Raid: Vashnik" was deleted and not made again`. This addon deleted
   nothing. Before this commit the fence said "All N slots are used", which was true. It needs a
   stale id, so it is rare.
3. **:7380, low. The swap clause is untested and too strict.** Setting `replaces = true` whatever the
   swaps are fails no check. The clause is not needed either. A swap whose new loadout must be made has
   a job with no `replace`, and the loop already catches that. A swap with nothing to make (`newID`
   set) only renames and deletes. So Reset at the cap with a stopped swap is fenced for no reason.
4. **Low, wording.** Removing `MINE_WORDS.combat` fails no check. Delete old loadouts (`PlanTab.tidy`)
   still uses `TAG_WORDS`, so combat there says to click "More > Make the planned loadouts". The
   right item is "More > Delete old loadouts". That was the same before this commit.

What held:
- `tidied`: a leftover that never lands is sent once, and `tagging`, `q` and the timers all end.
  The talent window opening in the beat before the tidied call gives "Close the talent window", with
  nothing stuck. Its OnHide call tidies once more, but only because the player acted.
- The combat lines: all three tables take count, s, was/were, GOLD and GREY, for one and for two,
  with no format error. Only the tag line uses GOLD and GREY. Lua ignores the extra arguments.
- Mixed jobs at the cap are fenced with no call. A replace of the worn loadout at the cap makes no
  call, and the old one stays. Reset never sends one, since the worn one goes by swap.
- `createMissing` never reaches the new path at the cap. `loadoutRoom` (:7696) is 0 there, so it
  stops before any job. Only `resetDrifted` and `wearSpare` use it.
- Mutations caught: dropping `not tidied` (3 fail), the fence change (2), the job loop (10), the
  spare's combat words (2), the "In combat, so" line (2), "was"/"were" (2), and the tidied argument (3).

Security:
- **Weakest point:** a replace deletes by config id with no name check (:7332). `tagNext` checks the
  name before it acts, and `importOne` does not. With the stall, a Reset of three at the cap deletes
  the third id more than 30 s after the click. A loadout renamed in that time is still deleted.
  Fix: carry the name in the job and skip the delete when `configName` differs.
- **Unchecked:** the build string goes to Blizzard's header reader, and a bad one is refused before
  any delete. SavedVariables are trusted. There is no network path.
- **Leaks:** nothing. Chat is local and names only the player's own loadouts.

No UI surface to screenshot: the change is in the queue. The in-game check is Done-when 2, plus
Reset and a double-click at 40 of 40 slots, timing how long each takes to finish.

**2026-09-25, Claude.** Third review's findings fixed, v0.54.1.

1. Fixed. At the slot cap `waitThenStep` takes "filled, and one beat more" as ready, since
   `CanCreateNewConfig` stays false there. New checks time the spare, and two Resets, at the cap
   against the same with room.
2. Fixed. `importOne` says "deleted" only when this queue sent the delete (`job.sentDelete`).
3. Fixed. The swap clause is gone: every job a replace is the only test.
4. Fixed. "Delete old loadouts" has its own words (`TIDY_WORDS`), and a check reads all the combat
   lines.
5. Security point fixed. `makeLoadouts` notes each replace's name (`replaceName`). `importOne`
   will not delete a loadout renamed since the click.

Breaking each fix made 3, 2, 2 and 2 checks fail. All three modes end "no FAIL lines".

**2026-09-25, Claude (fourth review of 127aa5a).** Does not hold: at the cap a refused delete is
now retried after one second and then given up. Stays in `ai-review/`. Line numbers are at fc0c27c,
which touched only card 0054's code.

Run: `offline-check.lua`, `250` and `62` under Lua 5.1 all end "no FAIL lines", and I read the whole
output. Then nine probes and six mutations, on a temp copy only.

1. **:7606–7612, medium. At the cap a busy server now fails the job for good.** The cap beat runs
   after every step, a failed one too, and `stepLoadouts` clears `pendingID` first (:7535). So a
   delete refused at the cap is tried again two polls later, and the final pass two polls after
   that. At the cap `importOne` cannot tell busy from full (:7398), so it sends the delete into the
   busy server both times. Probe P8, the spare at the cap with the server busy at the click: busy
   for 1 s it recovers, busy for 1.5 s or 2.5 s it ends `delete 3|refused|delete 3|refused` and
   "Raid: Vashnik failed: the game would not delete the old one". With room, the same three all wear
   the spare. At 56e4111 all three recover at the cap: the 15 s wait was slow, but it waited out
   the server. In game this is Done-when 2 at 40 of 40: double-click a build while the last
   switch is still in flight, and the spare is not made. Fix: take the cap beat only after an
   import (`q.lastMade` set). After a failed step at the cap, back off several seconds, or keep
   the old wait.
2. **:7605–7611 with :8573, low. Without `pendingID`, the cap beat does not wait for the import to
   fill.** With no id to watch, `populated` stays true, so the queue steps one beat after the new
   loadout is listed. The Dreamgrove note at :7109 says that is not the finish line. With room,
   `CanCreateNewConfig` covered the fill. Probe P1/P2, the server filling 3 ticks after the list:
   two Resets at the cap end `delete 5|refused|delete 5|refused`, and the spare says "is made but
   the server has not filled it in yet", where room and the event both give "Made 2 of 2" and
   "Putting on". `pendingID` is nil only when `TRAIT_CONFIG_CREATED` was refused, which the addon
   says, and that line says "waits longer". At the cap it now waits less. Fix: with no
   `pendingID`, find the made loadout by name, as `noteMade` does, and ask it.
3. **:11532–11543, low. The beat is untested.** Stepping at once, with no beat, fails no check.
   The two-at-cap run then goes `delete 5|refused|delete 5|import`, and the check reads only the
   ticks. Dropping `populated` from the cap clause fails nothing either, because the timed server
   is always filled and fires no event. Fix: check the calls of the two-at-cap run, with no
   "refused". Add a case with the event and a late fill.

What held:
- `replaceName` on a loadout from before the tag (P4): it is noted from the live name, so an
  untagged "Raid: Vashnik" is deleted and imported at the cap. The guard never refuses a real Reset.
- The retry path (P5): a delete taken and never landing is sent again in the final pass, the name
  still matches, then import, "Made 1 of 1". Renamed during the give-up (P6): one delete only, the
  renamed loadout is kept, and the job fails with the renamed line. `sentDelete` survives the retry,
  so "deleted" stays right.
- A swap with a leftover "[CP+]" at the cap (P7): `delete 5|import|wear|delete 1|rename`, done.
- With the event, the cap beat waits for the fill: P1 and P2 match the runs with room.
- `freeLoadoutSlots()` reading 0 mid-queue with room: I found no path. The import goes only after
  the old one reads gone, and a delete that never lands ends in the give-up, which steps anyway.
  The only 0 with room is the queue filling the last slot, where the game is full and stepping is
  right (finding 2 aside).
- Mutations caught: the rename guard (1 fail), `sentDelete` always true (1), no `replaceName` (1),
  the cap beat with slots free (2). Not caught: no beat (0), no fill check at the cap (0).
- `TIDY_WORDS` and the combat-line check hold.

Security:
- **Weakest point:** the rename guard compares `configName` with no `canRead` (:7411), where
  `savedLoadoutNames` guards each name. If a loadout name ever came back secret, the compare would
  throw inside `stepLoadouts`, which is not in a `pcall`, and `PlanTab.q` would stay set: every
  loadout action says "Still making loadouts" until `/reload`. `noteMade` has the same compare, so
  this is not new. A reused id with the same name is still not caught, and is negligible.
- **Unchecked:** the build string goes to Blizzard's header reader, and a bad one is refused before
  any delete. SavedVariables are trusted. There is no network path.
- **Leaks:** nothing. Chat is local and names only the player's own loadouts.

No UI surface to screenshot. The in-game check is Done-when 2 at 40 of 40, double-clicking the next
build straight after "Putting on", plus Reset of two at the cap.
