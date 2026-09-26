---
needs: 0057
---
# 0066 Set up this character: one button that brings its loadouts in line with the list

## Try this in game (v0.54.9)

On your main, rename one of your builds (right-click its row). Log on to an alt of the same class
and spec. Click **More > Delete old loadouts**. Chat lists "[CP] old name  (no build is called old
name now)". Click **Delete** in the box. The old loadout goes, one at a time. Then click **More >
Make the planned loadouts** to make the new name.

Pass: only "[CP]" loadouts are listed, never the one you are wearing, and nothing goes before the
click.

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
