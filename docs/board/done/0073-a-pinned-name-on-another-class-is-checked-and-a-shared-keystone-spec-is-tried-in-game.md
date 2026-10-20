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
- [ ] #2 On a Beast Mastery Hunter, `/reload`, then `/dcp loadouts` (or More > Make the planned loadouts) and Create both: the talent window's dropdown shows `[CP] Dungeon` and `[CP] Raid`, and picking each loads it with no Blizzard line calling the import invalid. proves: manual
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

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

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

**2026-10-11** Clear-down (attended, Rob asked): ticked nothing new: #1 was already ticked and is an `update-builds.py` proof, not a Lua check. #2 is rewritten for v0.69.0 (`/dcp loadouts` and More > Make the planned loadouts both reach `offerLoadouts`; Beast Mastery still has a Dungeon and a Raid build in `BUILDS`). Moves to ai-review/ with only the in-game look open.

### 2026-10-20 review (v20261020122406-7500)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

**#1 (a bad pinned name stops the run): met.** The check is in `block()` in `update-builds.py`. Before it reads any source, `block()` checks every `PIN` entry for every class. A name longer than `NAME_MAX` (24) or a name with a `"` makes the script exit with an error. The message names the spec and the name.

The script exits before it builds or writes anything. So `DjinnisClassProfiles.lua` does not change. The druid check and the non-druid check are now one loop, so they cannot drift apart.

`other_classes()` still has an `assert` on the name. The loop in `block()` always runs first, so that `assert` is only a second guard. It does no harm.

**#2 (Beast Mastery loadouts in the game): open, and that is correct.** It is a `proves: manual` check, so it waits for you. Nothing in the code stops it from passing:
- `PlanTab.TAG = "[CP] "` is in `DjinnisClassProfiles.lua`.
- `PlanTab.BUILDS["Beast Mastery"]` has a `Dungeon` row and a `Raid` row.
- The addon text still points to "More > Make the planned loadouts".

What you do now: nothing for this review. Do the Beast Mastery check in the game when you can.

VERDICT: sound

**scope: sound**

**What I checked:** I checked only scope. That means two questions: did the change do more than the card asked, and did it leave anything half done?

**What I found:**

- The card's own commit is `9779b5b`. It changes two files: `update-builds.py` (8 lines) and the card file.
- In `update-builds.py`, function `block()`, one loop now checks the pinned names of every class before any source is read. It replaces the old druid-only check, so the druid and non-druid paths cannot drift apart again. This is the "one helper both paths call" that the card's task asked for.
- It does not cross the "Not this card" fence. The `[CP] ` tag (`0059`), the `valor_dungeon()` finding and the CurseForge release are untouched.
- The large diff in the brief is not from this card. The range also holds other cards' commits: the gear plan, the bar research and the Warcraft Logs build refresh. None of them is in this card's commit, so this card did not grow.
- #1 is met by `block()`. `sys.exit` with a text message exits with code 1.
- #2 is open and `proves: manual`. Nothing in the code stops it from passing, so it is not a finding.

VERDICT: sound

**breakage: sound**

I tried to break the fix and could not, so the verdict is sound. I only read the code. I ran nothing.

**What the fix does.** In `update-builds.py`, `block()` now checks the name of every `PIN` entry, for every class. This happens before any source is read and before anything is written. So `other_classes()` gets only names that passed the check. Its two `checked()` calls (the WCL fallback and the "pinned but not filled" loop) are both covered. The druid check and the other-class check are now one loop, so the two cannot drift apart. The `assert` on `PICK` names stays separate, but no `PIN` name goes through it.

**Criterion #1 holds.** The run exits through `sys.exit` with a string message, which gives exit code 1. The message names the spec and the name. It exits before `main` writes the Lua file, so the file stays byte-identical.

**One small gap. It is not a defect against the card.** A pinned name with a `\` passes the check. For example, `Dungeon \` would make `["Dungeon \"]` in `checked()`. That is also Lua the game will not load. The card asks only for "over `NAME_MAX`" and `"`, so I raise no `UNMET:` for it. Adding `\` and newlines to the check would be a cheap fix later.

**Criterion #2** is a `proves: manual` check. It is open, and that is expected, so it is not a finding. You do it in the game.

VERDICT: sound

