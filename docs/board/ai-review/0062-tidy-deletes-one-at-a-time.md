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

**Pass:** the box lists the old EC and KotG loadouts as "deleted: an old Dreamgrove loadout". "Delete them" deletes them all with one click, a second or so apart, then "Deleted N of N old Dreamgrove loadouts." A second later the box offers "Create" for the Balance builds.

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