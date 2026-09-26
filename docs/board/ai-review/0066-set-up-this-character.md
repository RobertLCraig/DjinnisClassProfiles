---
needs: 0057
---
# 0066 Set up this character: one button that brings its loadouts in line with the list

## Try this in game (v0.54.11)

On your main, rename one of your builds (right-click its row). Log on to an alt of the same class
and spec. Click **More > Delete old loadouts**. Chat lists "[CP] old name  (no build is called old
name now)". Click **Delete** in the box. The old loadout goes, one at a time. Then click **More >
Make the planned loadouts** to make the new name.

Pass: no loadout you named yourself is listed, never the one you are wearing, and nothing goes
before the click.

## Why

Split from card `0057`, 2026-09-25. Rob, 2026-09-24: "I accept if we have to clean up and reload
talents across all characters. (lets build in a way to do that easily." Then, 2026-09-25, on card
`0065`: park loading all loadouts automatically.

It also has a job now that `0057` is built. Rename or delete one of your builds, and every other
character keeps a "[CP] old name" loadout. That loadout shows under Your loadouts until it is
deleted by hand.

Rob, 2026-09-26, given the choice: build the clean-up part only. Nothing is made, and there is no
login offer, so the park on `0065` holds.

## What

- One button, and one offer on login when this character is out of date with the list. The login
  offer is the part Rob parked.
- It lists what it will do and asks first:
  - delete each "[CP] X" loadout that no build names any more;
  - make a loadout for each build that has none;
  - make each drifted one again.
- Keep to the slot limit (the spare, card `0040`). Never delete the loadout you are wearing. Send
  one change at a time (`startTagging`, `makeLoadouts`).
- Only tagged loadouts are touched (card `0059`), so no loadout of the player's own is deleted.

## What was built (v0.54.9)

- `PlanTab.orphanLoadouts(saved, selected, skip)`: each "[CP] X" on this spec whose X is not in
  `buildsOf(spec)`. The real name must be the tag, so an untagged loadout is never listed. The worn
  one is marked `stays`. Ids in `skip` (the retired ones) are not listed twice. With no builds read
  it lists nothing.
- `PlanTab.tidy` lists the retired ones and then the orphans, each orphan with "(no build is called
  X now)". It deletes through `startTagging`, one at a time, only on yes. `tagNext` still checks
  the name and the worn one before each delete.
- **Delete old loadouts** is on every class now, not druids only. The old Dreamgrove names stay
  druids' only, because `retiredLoadouts` checks the class.
- **Changed on purpose:** on Balance, "[CP] WS M+" is deleted now, because no Balance build is
  called "WS M+". A card `0062` check kept it; that check now expects it gone.
- **Not built (still parked):** the one button that also makes and resets, and the login offer.
  **More > Make the planned loadouts** does the making by hand.
- `PlanTab.orphanChecks` covers it. Five breaks (untagged counted, no skip, nil builds, the worn
  one not kept, tidy ignoring orphans) fail 19, 4, 1, 1 and 5 checks.

## Acceptance

- [x] What Delete old loadouts would delete is pure and checked: orphans, the worn one kept, only
  tagged ones. proves: self-test
- [x] Nothing changes without the click. proves: self-test
- [ ] In game, on an alt after a rename on the main: the old "[CP]" loadout goes. proves: manual
  (Rob)
- [ ] Parked: one button that also makes and resets, and the login offer. Waits on Rob unparking
  card `0065`.

## Comments

### 2026-09-26, adversarial review of bcb8bf6: bounced, it stays in ai-review

**Verdict: one real defect.** The click deletes a list worked out at the click, not the list shown
in chat. The selection logic itself holds.

**Offline check:** Feral, `250` and `62` each end "no FAIL lines", with no load error in the whole
output. The `250` and `62` runs stop tidy at "The game will not list this spec's loadouts yet", so
`orphanLoadouts` never runs as a non-druid with real data. Only `orphanChecks`' stubbed Feral
reaches it.

**Findings**

1. **Defect: Delete deletes what it finds at the click, not what chat listed.**
   `DjinnisClassProfiles.lua:9619`: the box's Delete calls `PlanTab.tidy(true)`, and `tidy` works
   the list out again (`:8570-8580`). The box stays open until clicked, and nothing closes it on a
   spec or loadout change. Probed on a temp copy:
   - **Spec changed with the box open:** tidy listed 3. The spec then changed and Delete was
     clicked. Configs 21 and 22 from the other spec were deleted, and chat had never shown either.
   - **Worn loadout switched:** chat said "[CP] Worn Out ... is the loadout you have selected, so
     it stays. Pick another, then tidy again", and the box asked about 2. The player does as told,
     picks another, then clicks Delete in the box that is still open. Three are deleted, the one
     chat said stays among them.

   `tagNext` checks again only that each loadout still has its name and is not worn now. Neither
   check sees a list that has changed. This hole was already there for druids' old Dreamgrove names
   (card `0062`). Card 0066 opens it to every class and to every "[CP]" loadout. Fix: keep the
   `todo` that `tidy(false)` built, together with its spec, and have the click run that list
   through `startTagging`. Refuse the click if the spec has changed. `tagNext`'s own checks cover
   the rest.

2. **Check gap on the most important rule: an orphan you are wearing is never deleted.** The tidy
   check wears config 1, a live build (`:12064`). So nothing runs an orphan you are wearing through
   `tidy` and `tagNext`. Mutant M14 took the worn guard off for orphans in both places (`:8577` and
   `tagNext`'s `o.id == PlanTab.selectedConfigID()`), and every mode still passes. Taking off only
   tidy's guard (M5) also passes. The card says "the worn one not kept" fails 1 check, but that
   check covers `orphanLoadouts`' `stays` mark only.

3. **Check gap: `buildsOf` and `goodMine` now decide what gets deleted, and `orphanChecks` stubs
   them.** Mutant M16 made `goodMine` reject any name with a space. The result: an ordinary build
   of yours such as "My M+" drops out of `buildsOf`, and its "[CP] My M+" is offered for deletion.
   Every mode still passes. Wanted: one check through the real `buildsOf`, with one of your builds
   in `DjinnisCPDB.myBuilds`.

4. **Risk, not a code fault: saved data that fails to load or is lost.** With `myBuilds` gone
   (the saved file reset, or unreadable so `db()` starts an empty one), every loadout of your
   builds is listed as "[CP] My M+  (no build is called My M+ now)". Probe C listed all 4. Those
   loadouts are then the last copy of those builds' talents. The box asks first, so this is Rob's
   call. One cheap guard: when an orphan was never a plan build, say "not a plan build, and not one
   of your builds" rather than only "no build is called X now".

5. **A decision reversed, and the docs still state the old one.** The `0064` review ruled that
   "a '[CP] ' copy of an older name ... is not the addon's" (`:7143-7146`). Card `0062` finding 4
   called this exact deletion a bug. The card says "changed on purpose" but does not answer that
   reasoning. Now wrong:
   - `docs/HANDOVER.md:258`: "a retired name from before the tag keeps its tagged copy".
   - `:7118-7119`: "The addon touches a name only if it is in BUILDS or RETIRED".
   - `:7143-7146`: the `RETIRED_TAGGED` comment. Tagged retirement is now mostly redundant with
     orphans.
   - `:11177-11178`: "neither is touched". True of `retiredLoadouts` alone, not of tidy.

   The handover is still at v0.54.8.

6. **Wording, minor.**
   - Menu tip (`:9547`): "Lists the [CP] loadouts ... (... or one the old DjinnisDreamgrove addon
     made)". Most Dreamgrove leftovers are untagged ("EC M+"). They are not "[CP]" loadouts.
   - The card's "Pass: only [CP] loadouts are listed" is false on a druid who still has those.
   - "Your own loadouts are not touched" (`:8582`, the tip, the box) does not hold for a "[CP] X"
     you edited by hand on that character: Blizzard saves hand edits into the loadout on Apply.
   - "These 1 old loadouts" and "Delete the 1 old loadouts" are older than this card.
   - "tidy again" is the slash word, and the menu calls it Delete old loadouts.

7. **Minor: two loadouts with one name.** Two "[CP] Old" orphans on one spec: `savedLoadoutNames`
   keeps one id per key and `tidy` ignores `twice`. Only one goes per run. It never deletes the
   wrong loadout.

**What held**

- **Only tagged loadouts.** `real == PlanTab.tag(key)` on the config's own name. An untagged
  "X" of yours that shares the key "X" is never listed (M1 and M8 are each caught by 20).
- **These are never listed:**
  - the spare "[CP*] X" and the swap "[CP+] X": `untag` refuses both, and `tag(key)` cannot match
    them;
  - a clash key "X (your loadout)";
  - a loadout from another spec: `GetConfigIDsBySpecID` takes the current spec, which is a real
    API in `ClassTalentsDocumentation.lua`.
- **A live build, of the plan or yours, is never listed** (M3 caught).
- **Nothing is deleted when there are no builds:** `buildsOf` nil lists nothing (M4 caught).
- **Retired names are never listed twice** (M2 caught), and stay druids' only (M11 caught).
- **The reason text is checked** (M10). The Death Knight menu entry is checked (M9b).
- **One change at a time** through `startTagging`.
- **Rechecked before each delete:** `tagNext` checks the name and the worn loadout again (M6 and
  M7 caught).
- **API, checked against `wow-ui-source` (live):**
  - `DeleteConfig` returns `success` as a bool.
  - `GetLastSelectedSavedConfigID` can return nil, and nil only means nothing is marked as staying.
  - `GetConfigInfo` has no secret returns, and there is no `C_Secrets` predicate for traits.
    `savedLoadoutNames` keeps its `canRead` guard anyway.
  - The loadout name box takes 30 letters (`Blizzard_ClassTalentLoadoutDialogTemplates.xml:25`).
    The tag's 5 plus `NAME_MAX` 24 is 29, so a name is never cut short into an orphan.
- **No protected event:** this card registers no new events.

Mutation harness and probes: `%TEMP%\dcp66_mut.py`, `%TEMP%\dcp66_probe.py` on the temp copy
`%TEMP%\dcp66`. Addon code untouched.

### 2026-09-26: review fixes, v0.54.10

- **Finding 1, the defect.** `tidy(false)` answers its list and spec. The box's Delete runs exactly
  that list (`tidy(true, asked)`), and refuses if the spec changed. `tagNext` still checks the name
  and the worn one before each delete.
- **Finding 2.** New checks: an orphan you are wearing goes through `tidy` and stays.
- **Finding 3.** New check through the real `buildsOf` and `goodMine`, with one of your builds in
  `DjinnisCPDB.myBuilds`.
- **Finding 4.** Each orphan now reads "(no plan build or build of yours is called X now)". When
  any is listed, chat adds: "If one of these is a build you still use, click Cancel".
- **Finding 5.** On purpose: Rob picked every "[CP]" loadout no build uses (2026-09-26), which
  answers the 0062 and 0064 reasoning. The code comments and `HANDOVER.md` now say so.
- **Finding 6.** Tip and chat say "Loadouts you named yourself"; "1 old loadout" is singular; the
  stay line names Delete old loadouts. The pass line above is fixed.
- **Checked.** All three offline modes pass. Four breaks (the click works the list out again, no spec
  guard, tidy's worn guard off, `goodMine` refusing spaces) fail 2, 1, 4 and 1 checks.

### 2026-09-26, second adversarial review of 897fe17: bounced, it stays in ai-review

**Verdict: the box is fixed, and another way in still deletes a list chat never showed.** That
second way is `/dcp tidy yes`. The fix also brought in one narrow new hole of its own.

**Offline check:** Feral, `250` and `62` each end "no FAIL lines", with no load error in the whole
output. As before, `250` and `62` stop tidy at "The game will not list this spec's loadouts yet".

**Findings**

1. **Defect: `/dcp tidy yes` deletes a list worked out when it is typed, and it prints none of
   it.** `DjinnisClassProfiles.lua:15220` calls `PlanTab.tidy(true)` with no `asked`, so tidy works
   the list out again (`:8580-8585`) and hands it straight to `startTagging` (`:8606`). Chat shows
   only the stay lines and then "Deleted 3 of 3 old loadouts". Probe P4 did this on the temp copy:
   nothing was printed, and ids 6, 2 and 5 went.
   This is finding 1 again, reached by a second way in. Card 0066 widened what it can delete.
   Before, it could delete about six Dreamgrove names, on druids only. Now it can delete every
   "[CP] X" orphan, on every class. The fix's safety line ("If one of these is a build you still
   use, click Cancel") never shows on this path. Now take finding 4's case, where saved data is
   lost. There, `/dcp tidy yes` deletes the loadout of every build of yours on that spec, and each
   may be the last copy of its talents. There is no list, no box and no warning.
   Nothing in game tells the player about `tidy yes`, but the slash command still works. Fix: make
   `tidy yes` call `tidyAsk`, or drop it. Either way, `tidy(true)` without `asked` should no longer
   delete anything.

2. **New with the fix: a loadout that stops being an orphan while the box is open is still
   deleted.** The box runs the list it was given (`:8576-8578`). `tagNext` checks only the name and
   the worn loadout (`:8023`, `:8029`). Nothing checks whether a build names it now. Scenario, probe
   P1: chat lists "[CP] Old Name (no plan build or build of yours is called Old Name now)". With the
   box still open, the player keeps it by making a build called "Old Name". They can do that with
   Import a build, Copy the talents in play, or a rename. All three use `askFrame`, not the prompt,
   so the open box does not block them. `myNameProblem` (`:8262-8265`) refuses a name only when an
   untagged loadout has it, so "[CP] Old Name" does not stop the new build. Then the player clicks
   Delete. `orphanLoadouts` would now list only 5, but 6, 2 and 5 are deleted, and 2 is the loadout
   of a live build.
   Before the fix, the list was worked out again at the click, so 2 was kept. The build string is
   saved in `myBuilds`, so Make the planned loadouts can make the loadout again. Any hand edits in
   it are lost. Fix: at the click, work the list out again and delete only the entries that are on
   both lists. That keeps finding 1's fix, and a loadout can only drop off the list, never be added.

3. **Check gap: nothing checks the fence on the box's Delete.** Mutant M4 applied `loadoutFence`
   only when there was no `asked`, and every mode still passed. The fence itself works. Probe P3
   ran the real `loadoutFence`, with `tagging`, `q` or `swapping` set, or in combat, at the click.
   Each time nothing was deleted, the queue already running was left alone, and chat said why. But
   no check stops a change from removing the fence. Without it, `startTagging` would overwrite a
   running `PlanTab.tagging`.

4. **Low, and older than this card: a spec change during the queue.** `tagNext` never checks the
   spec, and `selectedConfigID` (`:7189`) reads the current spec's worn loadout. Scenario: the list
   is made on Feral, and the player then puts on "[CP] C", which is on the list. They click Delete
   and switch to Guardian while the queue runs. Each delete takes about a second (`POLL` 0.5, plus
   one beat), so ten orphans take about ten seconds. Once the switch lands, "[CP] C" is checked
   against Guardian's worn loadout, and deleted. It is the loadout Feral was wearing. Fix: store
   the spec in `t` and stop the queue when it changes, the way combat stops it.

5. **Wording, minor.** Run Delete old loadouts a second time with the box still open (probe P2).
   Chat prints a fresh list and "Click Delete in the box that opens". Then it says "Answer the open
   question first". The box that is open still holds the older list. `tidyAsk` should check
   `promptBusy` before `tidy(false)` prints anything (`:9629-9631`). The older list does no harm
   here: the loadout picked since was kept by `tagNext`.

6. **Docs, minor.** `docs/HANDOVER.md:9` still says v0.54.8. The card's "Try this in game" heading
   says v0.54.9.

**What held**

- **Finding 1, for the box.** Delete runs the list `tidy(false)` answered (M1 and M3 each fail 2
  checks). A spec change refuses it (M2 fails 1), and so does a nil `asked.spec` (M9 fails 1). A
  worn loadout is never in `asked` (M8 fails 1). Spec away and back (P8) runs the same list, and
  that is correct: it is the same spec's loadouts.
- **Stale entries are skipped by `tagNext`.** A listed loadout renamed or deleted before the click
  (P7) is skipped, and chat says so. So is one put on before the click (P6). Combat after the first
  delete stops the queue and says how many are left (P5).
- **Finding 2.** A worn orphan now goes through `tidy` (M7 fails 4). `tagNext`'s worn guard is
  checked (M5 fails 2), and so is its name guard (M6 fails 1).
- **Finding 3.** The real `buildsOf` and `goodMine` are checked (M10 fails 1). Untagged loadouts
  are still never listed (M12 fails 22).
- **Finding 4.** Each orphan line and the warning are checked (M11 fails 1), on the box path.
- **Finding 5.** The comments at `:7118-7120`, `:7146-7149` and `:11195-11196`, and
  `HANDOVER.md:258`, now state the new rule.
- **Finding 6.** The tip, the singular, the stay line and the pass line are fixed. "Loadouts you
  named yourself" is true now, and it covers a "[CP] X" edited by hand.
- **The card's counts match:** the four breaks it names fail 2, 1, 4 and 1.
- **API, checked against `wow-ui-source` (live):** `DeleteConfig` returns `success` as a bool.
  `GetLastSelectedSavedConfigID` takes a spec id and may return nil. Blizzard's own frame sets it
  per spec (`Blizzard_ClassTalentsFrame.lua:655`), which is why finding 4 exists. This fix registers
  no new events and reads no new unit or resource values.

Mutation and probe scripts: `%TEMP%\dcp66r2_mut.py` and `%TEMP%\dcp66r2_probe.py`, run against the
temp copy `%TEMP%\dcp66r2`. The copy was put back after each run. Addon code untouched.
### 2026-09-26: second review fixes, v0.54.11

- **Finding 1.** `/dcp tidy yes` now goes through `tidyAsk`: it lists, warns and asks, as the menu
  does. No command reaches `tidy(true)` without a list.
- **Finding 2.** The click deletes only what is on the list chat showed AND on a list worked out at
  the click. A loadout given a build again, renamed, or worn since the question is left, and chat
  says which.
- **Finding 3.** New check: the click is fenced (combat, a change running) as the list was.
- **Finding 5.** `tidyAsk` checks for an open box first, so a second click prints no new list.
- **Finding 6.** `HANDOVER.md` and the heading above say v0.54.11.
- **Finding 4, not fixed here.** `tagNext` does not recheck the spec during a run. It is older than
  this card and is shared by every queue; left for a card of its own if Rob wants it.
- **Checked.** All three offline modes pass. Four breaks (`tidy yes` deleting at once, no
  intersection at the click, the click not fenced, the open-box check late) each fail 1 check.