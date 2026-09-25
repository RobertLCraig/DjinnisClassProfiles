# 0062 `/dcp tidy yes` deletes one loadout at a time

## Why

The 0059 review, 2026-09-25: `PlanTab.tidy` (`DjinnisClassProfiles.lua`, near line 7580) sends every
`DeleteConfig` in one frame. The server takes one loadout change in flight and refuses the rest with
"You can't do that right now". Rob saw exactly that from "Tag them" (card 0059). A druid with more
than one old Dreamgrove loadout would see "Could not delete" for all but one.

## What to do

Send tidy's deletes through the same queue as "Tag them" (`PlanTab.tagging` / `PlanTab.tagNext`):
one delete, wait until the config is gone, one beat more, then the next. A refusal is tried again.
Its end line says "Deleted N old loadouts." rather than "Tagged".

## Done when

1. `lua offline-check.lua` passes, with a check against the timed server model in `tagChecks` that
   two deletes both land and none is refused.
2. In game, on a druid with two or more old Dreamgrove loadouts: `/dcp tidy yes` deletes them all
   with one command, and chat says "Deleted N old loadouts."

## Comments

### 2026-09-25: hit in a live client, built in v0.48.9

Rob, Balance, 12:27: `/dcp tidy` listed six (EC M+, EC Raid Cleave, EC Raid ST, KotG M+, KotG Raid Cleave, KotG Raid ST). Delete then said "Could not delete" for five and "Deleted 1". His dropdown afterwards still showed all six (the dropdown may not have refreshed).

The same session showed why Balance offered nothing on a spec change: Balance had none of its four planned builds, but the character's druid specs held about 38 of the 40 loadout slots, `loadoutRoom` keeps two for the spare, so `missing` was emptied and the box stayed quiet. The six old Dreamgrove loadouts were the room, and the box never mentioned them.

Built:
1. `PlanTab.retiredLoadouts(saved, selected)`: the `PlanTab.RETIRED` names on a druid, never a live build for the spec in hand, the worn one marked `stays`. `PlanTab.beforeTag` joins them to card 0059's untagged ones, so the login and spec-change box lists them ("deleted: an old Dreamgrove loadout", in red) and "Tag them" deletes them.
2. `PlanTab.startTagging(todo)` runs any list through 0059's queue: one change, wait for it to land, one beat, retry a refusal. Deletes of old Dreamgrove loadouts count apart: "Deleted N old Dreamgrove loadouts." `PlanTab.tidy(true)` now starts that queue and answers "started".
3. Checks: the list (druid only, a name live for the spec kept, the worn one staying), the box rows, Tag them deleting two with none refused and no "Tagged" line, tidy deleting three with none refused. 7 new mutants and the 23 earlier ones all caught.

## What I need from you

On Balance: `/reload`, then change spec away and back (or open More > Make the planned loadouts).

**Pass:** the box lists the old EC and KotG loadouts as "deleted: an old Dreamgrove loadout". "Delete them" deletes them all with one click, a second or so apart, then "Deleted N of N old loadouts." A second later the box offers "Create" for the Balance builds.

**Fail:** a "would not delete" line, a loadout of yours deleted, or a Lua error.

### 2026-09-25: adversarial review of 692b6ed, bounced to todo

Attacked: the diff and every function it touches (`retiredLoadouts`, `beforeTag`, `tagOld`,
`startTagging`, `tagNext`, `offerLoadouts`, `tidy`, `tidyAsk`, the slash handler, `savedLoadoutNames`
and `loadoutKey`). `offline-check.lua` passes (exit 0, no FAIL). I ran 11 mutants on a copy under
%TEMP%: dropping the live-build guard, the druid guard, `stays`, the queue's worn-one recheck, the
`gone` count, the "Tagged" suppression, `beforeTag` in the box, tidy's `retired` flag and the
`done + gone` return. All but one went red. The survivor was tidy's own "selected" skip, and it
survives only because `tagNext` checks the worn one again before each delete. That is harmless.

What held:
- The worn one is never deleted. Both lists mark it, and `tagNext` asks `selectedConfigID` again
  before each delete.
- A name that is live for this spec is never retired.
- Other classes are never touched.
- Deletes go one at a time and a refusal is retried.
- No caller of `tidy` reads the count: `/dcp tidy yes` and the Delete button ignore it, and `tidyAsk`
  only reads `tidy(false)`, which still answers a number.

No loop: a retired-only box answered "Not now" does not come back at login, and the end-of-queue
re-offer is a one-shot.

Findings, most severe first (reproduced with probes spliced into a %TEMP% copy of `tagChecks`):

1. **The consent box for a delete says "Tag them" and "Renaming keeps the talents".** On Rob's
   Balance, the case this card was built for, every row is a deletion. The box heading reads "2
   loadouts were made before this addon tagged its own with "[CP] ":", the footer reads "Renaming
   keeps the talents. Your other loadouts are not touched.", and the button that deletes six
   loadouts is labelled "Tag them". Only the red row text says "deleted". Before this card, a
   RETIRED name was deleted only after `/dcp tidy` listed it and a Delete button was clicked. Now
   the login and spec-change box does it under a rename label. The comment at `PlanTab.RETIRED`
   ("Deleted only by /dcp tidy yes, after /dcp tidy has listed them") is now false.
2. **"Not now" on that box says every build is saved when none is.** Probe: Balance, two retired
   rows, the slot cap reached (`freeLoadoutSlots` 2), and three builds missing. Clicking Not now
   prints "Every planned Balance build is saved. Your old untagged loadouts are left as they are."
   `missing` was emptied by `loadoutRoom` and the `doable and declined` branch reads that as
   complete. The text is older than this card, but before it only untagged build loadouts made
   `doable` true. Now the card's own headline case reaches it, and it also calls the Dreamgrove
   loadouts "untagged".
3. **When every delete is refused, the end line says "Tagged 0 old loadouts."** Probe: `tidy(true)`
   with DeleteConfig always false prints three "would not delete" lines, then "Tagged 0 old
   loadouts.". The condition `t.done > 0 or t.gone == 0` treats "nothing landed" as a rename run.
   A delete that times out ("did not change in time") also counts in neither total. The card asks
   for "Deleted N old loadouts.", and no check pins the zero case.
4. **Latent: a tagged loadout can read as retired.** `savedLoadoutNames` keys "[CP] EC M+" as "EC
   M+", and `retiredLoadouts` then lists it as an old Dreamgrove row (probe: through the real
   `savedLoadoutNames`, config 21 "[CP] EC M+" came back as a retired row with id 21). Today no
   tagged build name is both in RETIRED and not live on its own spec. Feral's live "Raid: Vashnik"
   and the others are excluded by `live`. It stops being safe the day Feral's plan drops those
   per-boss names, as Balance's did. Every "[CP] Raid: X" on Feral would then be deleted as "an old
   Dreamgrove loadout". A fix is to test the raw config name rather than the key, or to skip any
   name `PlanTab.untag` accepts.
5. Minor: when combat starts mid-tidy, the queue says "N old loadouts were not tagged".

Security:
- Weakest point: a name match alone decides a DeleteConfig. The name belongs to the player, so a
  druid's own loadout named "WS M+" or "DotC M+" is deleted by one click on a box they did not ask
  for.
- Unchecked: the tagged/untagged distinction is lost in the key (finding 4).
- Leaks: nothing. Every output is local chat.

No browser: this is a WoW addon and no agent can run the client. The in-game check under "What I need
from you" still stands.

Needed to pass: finding 1 (box wording or a separate "Delete old Dreamgrove loadouts" button),
finding 2, finding 3 with a check, and finding 4 guarded or ruled out in DECISIONS.

### 2026-09-25: review fixes, v0.48.10

1. **The box says what it does.** Heading "N old loadouts on this spec, from before this addon tagged its own"; "Renaming keeps the talents." only when something is renamed; "The old Dreamgrove loadouts are deleted: this addon no longer makes them, and they use slots." when something is deleted. The button is "Tag them", "Delete them" or "Tag and delete". The `PlanTab.RETIRED` comment now says a box and a click delete them.
2. **Not now with no room** says "N planned Balance builds have no loadout and no room for one; they are worn through the spare", not "Every planned build is saved".
3. **The end line counts against what was asked:** "Tagged d of R old loadouts." / "Deleted g of D old Dreamgrove loadouts.", so an all-refused tidy says "Deleted 0 of 3", never "Tagged 0".
4. **A tagged loadout is never taken for an old one:** `retiredLoadouts` needs the config's real name (`PlanTab.configName`) to be the listed name, so "[CP] WS M+" filed under "WS M+" is left. `tidy` now builds its list from `retiredLoadouts` too, so both paths share the guard.
5. Combat mid-queue says "were not done", not "were not tagged".

Checks for each; 8 mutants, all caught (tidy's own worn-loadout line needed a new check; the queue already refused the delete).

### 2026-09-25: second adversarial review of 692b6ed and b220c3d, bounced to todo

Attacked: both commits, and every function they touch (`retiredLoadouts`, `beforeTag`, `tagOld`,
`startTagging`, `tagNext`, `offerLoadouts`, `tidy`, `tidyAsk`, the `/dcp tidy` and `/dcp tidy yes`
handler, `savedLoadoutNames`, `loadoutKey`, `untag`, `configName`, `loadoutFence`). Checked
`DeleteConfig` (returns `success`) and `GetConfigInfo` (`MayReturnNothing`) against
`Blizzard_APIDocumentationGenerated`. `offline-check.lua` passes (exit 0, no FAIL). 13 mutants and 3
probes ran on a copy under %TEMP%.

The five first-review findings are fixed:
1. The box is worded by what it does: "Delete them" and the Dreamgrove line when every row is a
   retired delete, "Tag and delete" and both lines for a mix, "Tag them" for renames only. A box of
   "stays" rows alone is not shown, because `doable` is false.
2. Not now with no room says "N planned Balance builds have no loadout and no room for one", not
   "Every planned build is saved".
3. The end line counts against what was asked. A tidy where every delete is refused says "Deleted 0 of
   3 old Dreamgrove loadouts." and there is no "Tagged" line. There is a check for it.
4. A tagged loadout is never read as an old one. `configName(id) == name` fails for "[CP] X" filed
   under X. If `configName` is nil or stale, the row is hidden, which is harmless: it reads the same
   `GetConfigInfo` that `savedLoadoutNames` read in the same frame. If "EC M+" and "[CP] EC M+" both
   exist, one id wins the key. If the tagged one wins, the old one is hidden and is not deleted. I
   found no way for the guard to let a wrong loadout through at list time. `tidy` shares the guard.
5. Combat now says "were not done".

What held: `tidy(true)` is fenced by `loadoutFence`, which refuses while `PlanTab.tagging` runs, so
two queues never overlap. `tidyAsk` reads only `tidy(false)`, which still answers a number or "not
druid". The slash handler ignores the result. Nothing loops: the re-offer at the end of the queue
happens once per click.

Findings, most severe first:

1. **A loadout renamed while the queue runs is still deleted.** The name is checked when the player
   clicks, and `tagNext` deletes by id seconds later. Before each delete it checks only whether the
   loadout is worn. Probe: Balance, `tidy(true)` on EC M+ (11), KotG Raid ST (13) and Raid: Vashnik
   (12). After the first delete is sent, 12 is renamed "Mine now". Result: `delete 11|delete 13|delete
   12` and "Deleted 3 of 3". A loadout whose name is no longer on RETIRED is deleted. The 0059 delete
   rows ("a tagged one is there") have the same gap. The fix is one line in `tagNext`, next to the
   worn-one check: skip `o.delete` when `PlanTab.configName(o.id) ~= o.from`, and say so.
2. **A 0059 delete is still called a rename.** Only `o.retired` counts as a delete, so an untagged
   loadout deleted because "[CP] X" is there counts as a rename. Probe: old `Dungeon` (1) with
   `[CP] Dungeon` present. The box says "Tag them" and "Renaming keeps the talents.", and the end line
   says "Tagged 1 of 1 old loadout." for `delete 1`. The existing check at "renamed and deleted"
   expects "Tagged 2" for one rename plus one delete. This wording is from 0059, but fix 1 claims
   "worded by what it does", and this case contradicts it.
3. **"Tagged 0 of 0 old loadouts."** Probe: the box lists EC M+, then the player picks EC M+ and clicks
   Delete them. `tagOld` says it stays, then `startTagging({})` prints "Tagged 0 of 0". A queue of
   nothing should print no count, or say that nothing was done.
4. Minor wording: during a delete-only queue, `loadoutFence`, `tagOld` and `offerLoadouts` all say
   "Still renaming", and the combat line says "then Tag them" for a tidy or "Delete them" run. The
   second box's button still says "Tag old loadouts" when every row it opens is a delete. When the
   delete box's Not now is clicked from an asked offer, it prints two near-identical "no room" lines
   (lines 7606 and 7619).
5. **Mutants that survived** (the rest were caught). Each one breaks a promise in the fix comment:
   - the "Tag and delete" label replaced by "Delete them";
   - the "The old Dreamgrove loadouts are deleted" line removed;
   - the "Tagged d of R" and "Deleted g of D" denominators replaced by `#t.todo`, which is wrong only in
     a mixed run;
   - worn ("stays") rows counted in the box's renames and deletes;
   - the combat line reverted to "not tagged";
   - tidy's own worn-one skip (harmless, because `tagNext` refuses the delete).

   No check drives a mixed rename-and-delete box or queue.

Security:
- Weakest point: a name match alone still decides a DeleteConfig. It is now asked for unprompted at
  login and on a spec change. A druid who never ran DjinnisDreamgrove and names their own loadout "WS
  M+" or "EC M+" (ordinary hero-talent shorthand) is offered its deletion under "old Dreamgrove
  loadout". It needs a click, and the row names it, so I am not blocking on this. A guard would be to
  offer the box rows only when there is evidence DjinnisDreamgrove ran on this character, and leave
  `/dcp tidy` as the explicit route.
- Unchecked: the name between the click and the delete (finding 1).
- Leaks: nothing. Every output is local chat.

No browser: this is a WoW addon and no agent can run the client. The in-game check under "What I need
from you" still stands. It should also cover a mixed box (an untagged build loadout plus old
Dreamgrove ones) and read the "Tag and delete" label.

Needed to pass: finding 1, with a check that a loadout renamed mid-queue is not deleted. Findings 2
and 3, and checks for the mixed box and the mixed end line, should be done in the same pass.
### 2026-09-25: second review fixes, v0.48.11

1. **A loadout renamed or gone since the click is left.** `tagNext` reads `PlanTab.configName(o.id)` before each change; if it is no longer `o.from` it says "changed since the click, so it is left as it is" and goes on. Checked: one renamed mid-tidy survives, the other two are deleted, "Deleted 2 of 3".
2. **Every delete counts as a delete.** An untagged loadout deleted because its tagged copy exists now counts with the deletes: the box says "One whose tagged copy is there already is deleted", the button is "Tag and delete" for a mix, and the end lines are "Tagged d of R old loadouts." and "Deleted g of D old loadouts."
3. **Nothing to do starts nothing:** when every row stays, `tagOld` answers "nothing" and prints no count.
4. **Wording:** "Still working through old loadouts", the combat line says "click More > Make the planned loadouts again", the second box's button is "Old loadouts", and an asked "Not now" with no room says the no-room line once.
5. **Checks** for a mixed box (label, all three lines, both counts), a worn row counting for neither, combat mid-tidy, and an unlanded delete not counted. 11 new mutants caught; the earlier rounds re-run with the new wording, all caught.

Moved to `human-review/`: the open criterion is the in-game one above.