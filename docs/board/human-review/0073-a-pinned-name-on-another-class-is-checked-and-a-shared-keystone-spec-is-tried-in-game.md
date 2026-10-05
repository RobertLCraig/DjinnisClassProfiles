---
needs: 0059
---
# A pinned name on another class is checked, and a shared-keystone spec is tried in game

## Why
Two gaps were left open when card `0050` gave every non-druid spec a Dungeon and a Raid build.

**A typo in a pinned build name breaks the whole addon.** A build pasted into `PIN` in
`update-builds.py` for a druid has its name checked: over `NAME_MAX` letters, or containing a `"`,
and the run stops. For every other class, `other_classes()` writes the name straight into the Lua
unchecked. The 2026-09-24 review of `0050` pinned `Dungeon "q"` on a copy. The run exited 0 and
wrote a Lua file the game will not load (`']' expected near 'q'`), which takes down every feature
of the addon, not just builds.

**Nobody has loaded the riskiest builds in the game.** Ten non-druid `Dungeon` strings mark the
*other* spec's copy of a shared hero keystone as granted: Holy and Protection Paladin, Beast
Mastery, Marksmanship, Fire, Frost Mage, Mistweaver, Windwalker, Devastation and Augmentation. No
druid string does that. `0050`'s in-game check was planned on a Death Knight, which has none of
them, so it would pass without testing the one thing that could fail.

## Links

**Blocked by**
- `0059` - puts the `[CP] ` tag on every loadout the addon makes. The in-game check below looks
  for the tagged names, so it needs the tag in first.

**Relates to**
- `0050` - the decision this card carries out. Option 1 (the tag, `[CP] `) was chosen, and its
  2026-09-29 answer names findings 3 and 4 of its review as still owed. They are this card.

## Not this card
Not the tag itself, which is `0059`. Not the druid path in `block()`, which already checks. Not
finding 1 of `0050`'s review (`valor_dungeon()` takes wowvalor's `recommendedBuild`, which is not
always the most-played build): since card `0064`, Warcraft Logs comes first and wowvalor is a
fallback, and the answer did not ask for it. Not a release to CurseForge.

## Acceptance
<!-- AC:BEGIN -->
- [x] #1 IF a `PIN` entry for a non-druid spec names a loadout over `NAME_MAX` letters or containing a `"`, THEN `update-builds.py` SHALL exit 1 naming the spec and the name, and leave `DjinnisClassProfiles.lua` byte-identical (settled by running it on a copy with such a pin, since the script has no harness). proves: none
- [ ] #2 WHEN Rob, on a Beast Mastery Hunter after `/reload`, has the addon make its loadouts, THE GAME SHALL show `[CP] Dungeon` and `[CP] Raid` in the talent window's dropdown, and each SHALL load without Blizzard calling the import invalid. proves: manual
<!-- AC:END -->

## Tasks
- [x] `other_classes()` in `update-builds.py`: refuse a pinned name over `NAME_MAX` or with a `"`, with the same message `block()` gives a druid pin. Put the check in one helper both paths call, so the two cannot drift again
- [x] Prove #1 on a copy in `%TEMP%`: one pin too long, one with a quote. Each exits 1, and the Lua file's hash is unchanged. Write both results into `## Comments`
- [x] Add a `## What I need from you` for Rob that is the #2 check, with its Pass and Fail, naming the addon command that makes the loadouts as it stands after `0059`

## Plan
Stand in `C:\Dev\WoWAddons\DjinnisClassProfiles`. The druid check to copy is in `block()`: it
compares a pinned name against `NAME_MAX` and looks for a `"` before calling `checked()`.
`other_classes()` calls `checked()` for pinned names in two places, and both need the check.

For #2, Beast Mastery is the pick because the review found `ungrant()` changed its string and
proved the bits offline. A game client is the only thing that can prove the import. If Beast
Mastery passes, the other nine carry the same shape.

## What I need from you
Criterion #2. Any game build with card `0059`'s tag works (the game folder held v0.54.12 on
2026-09-27). This card changed only `update-builds.py`, so nothing new needs deploying.

1. Log in on a Beast Mastery Hunter and type `/reload`.
2. Type `/dcp loadouts` (the same as **More > Make the planned loadouts**) and make both builds.
3. Open the talent window. Pick `[CP] Dungeon`, then `[CP] Raid`.

**Pass:**
- The dropdown shows `[CP] Dungeon` and `[CP] Raid`.
- Each one loads. No Blizzard line calls the import invalid.

**Fail:** either name is missing, or Blizzard says a string is invalid. Write down which build and the
exact red line.

## Comments
**2026-09-29**
RESULT: partial
TESTS: +0 new, all green
TOUCHED: update-builds.py, docs/board/in-progress/0073-a-pinned-name-on-another-class-is-checked-and-a-shared-keystone-spec-is-tried-in-game.md
OUT-OF-SCOPE: none

#1 is met. #2 is open: it needs Rob in a game client (see `## What I need from you`).

The fix: `block()` now checks the name of every `PIN` entry, of every class, once, before it reads
any source. That one loop replaces the druid-only check, so the druid and non-druid paths cannot
drift. The message is the old druid one.

Proof, on a copy in `%TEMP%\cp0073` (the script, the Lua and `docs/builds/wcl-builds.json`), with a
driver that sets `PIN = {"Beast Mastery": {<name>: (its WCL Dungeon string, ...)}}` and calls `main()`:
- Before the fix, `Dungeon "q"`: `BUILDS block written.`, exit 0, and line 600 of the Lua became
  `["Dungeon "q""] = ...`. That is the fault.
- After, `Dungeon "q"`: `Beast Mastery pinned 'Dungeon "q"': over 24 letters, or a quote.`, exit 1.
- After, `Dungeon but far too long a name`: the same message with that name, exit 1.
- The Lua's SHA-256 was `3aae11e4...1effd` before and after both runs.
- With no pin, `update-builds.py --check` said `BUILDS block already current.`, exit 0.

The Pest and Pint commands in the brief do not apply: this repository has no PHP, no `vendor` and no
test suite. `update-builds.py` has no harness, which is why #1 says `proves: none`.

**2026-09-29** The loop moved this card from in-progress/ to human-review/ WITHOUT trying it. All 1 of its open acceptance criteria say proves: manual, so there is nothing left an unattended session could close and starting one would change nothing. Each open criterion names what to look at and what a pass is: tick what passes and move the card on, or say what failed and move it back to todo/.

### 2026-10-05 manager (m20261005011444-5a24)

**outcome: rob**

The code fix is done and the blocker is done; only Rob's in-game check of the Beast Mastery loadouts is left.

**what the session said**

I read the code. The fix is there. In `update-builds.py`, the function `block()` now checks the name of every `PIN` entry, for every class, before it reads any source. A name with more than `NAME_MAX` letters, or with a `"`, stops the run. That is criterion #1, and the code agrees with the card's proof.

The blocker card `0059` (the `[CP] ` tag) is in `done/`.

Criterion #2 is the only open item. It needs a person in a live game client:

1. Log in on a Beast Mastery Hunter and type `/reload`.
2. Type `/dcp loadouts` and make both builds.
3. Open the talent window and pick `[CP] Dungeon`, then `[CP] Raid`.

**Pass:** both names are in the dropdown, and each one loads with no Blizzard "invalid" message.

**Fail:** a name is missing, or Blizzard calls a string invalid. Write down which build and the exact red line.

No agent can run the game, so the builder has nothing to do.

WHY: The code fix is done and the blocker is done; only Rob's in-game check of the Beast Mastery loadouts is left.

OUTCOME: rob

