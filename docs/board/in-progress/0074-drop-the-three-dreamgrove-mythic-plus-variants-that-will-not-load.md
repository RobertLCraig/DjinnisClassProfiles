# Drop the three Dreamgrove Mythic+ variants that will not load

## Why
Three druid builds in the talent sidebar show a warning triangle, and loading them fails with
"The loadout you are trying to import is out of date". They are Guardian `Dungeon: survive more`,
and Resto `Dungeon: cat damage` and `Dungeon: caster damage`. Checked on 2026-09-29: they are the
only 3 of the 93 strings in the `BUILDS` block with a non-zero tree hash, and the game refuses a
string whose hash does not match today's tree.

They were copied as written from the Dreamgrove guide by `update-builds.py`. Card `0064` then
replaced the other guide builds with what top Warcraft Logs players run, and no top player in its
sample runs any of these three exactly. So they are broken builds that nobody plays, and they take
up three loadout slots on druids, where slots are short.

## Links

**Relates to**
- `0061` - the decision this card carries out. Option 2 was chosen on 2026-09-29: drop the three
  rows, leaving each spec its Warcraft Logs `Dungeon`.
- `0066` - "Set up this character" lists an existing `[CP]` loadout of a dropped name under More >
  Delete old loadouts, and asks before deleting. That is how a player's copies go, not this card.

## Not this card
Not zeroing the hash on Dreamgrove strings in `update-builds.py`, which was option 1 and was not
chosen. Not deleting anyone's existing loadouts in the game. Not Guardian's or Resto's `Dungeon` or
`Raid` rows, which stay.

## Acceptance
<!-- AC:BEGIN -->
- [x] #1 WHEN the Guardian list beside the talent window is built, THE ADDON SHALL show `Dungeon` under Mythic+ and `Raid` under Other builds, and no `Dungeon: survive more`. proves: `the list beside the talent window, Guardian's builds with no boss row sit under Other builds`
- [x] #2 WHEN the Resto list beside the talent window is built, THE ADDON SHALL show one `Dungeon` and neither `Dungeon: cat damage` nor `Dungeon: caster damage`. proves: `the list beside the talent window, Resto keeps one Dungeon and no guide variants`
- [x] #3 WHEN the self-test reads the `BUILDS` block, EVERY build string SHALL carry an empty tree hash. proves: `every build string has an empty tree hash`
<!-- AC:END -->

## Tasks
- [x] `update-builds.py`: remove the `Guardian` and `Resto` entries from `PICK`, keeping the comment above them that says why their raid rows went
- [x] Run `python update-builds.py`, then `python update-builds.py --check`, which must pass
- [x] Self-test in `DjinnisClassProfiles.lua`: change the Guardian sidebar expectation to `[Mythic+]; Dungeon; [Other builds]; Raid`, and add the Resto and tree-hash checks named in Acceptance
- [x] `lua offline-check.lua` exits 0

## Plan
Stand in `C:\Dev\WoWAddons\DjinnisClassProfiles`. `PICK` is the table at the top of
`update-builds.py`. Check whether the loop over it in `block()` still copes with a spec missing
from `PICK`, and give each an empty entry if it does not.

A build string is base64. Its first 4 characters are the version and spec, and the next 128 bits
are the tree hash, so an empty hash reads as a run of `A`. The three being dropped start
`CgGA8cL7...` or `CkGADBD3...`, and every good string reads `A` from its fifth character.

## Comments
**2026-09-29** RESULT: done
TESTS: +2 new (Resto list, empty tree hash) and 1 changed (Guardian list), all green
TOUCHED: update-builds.py
TOUCHED: DjinnisClassProfiles.lua
TOUCHED: docs/board/todo/0075-the-other-druid-spec-modes-of-the-offline-check-fail.md
OUT-OF-SCOPE: 0075

`PICK` keeps `"Guardian": {}` and `"Resto": {}` rather than losing the keys: `block()` indexes
`PICK[spec]` for every druid spec and would raise `KeyError` on a missing one. The three checks
were written first and failed for the stated reason (the three names listed, and the stale hash
on exactly those three). `update-builds.py` then removed only those three rows; `--check` says
current. `offline-check.lua` passes under Lua 5.1 and plain `lua`, and in spec 250 mode. Spec 104
mode shows 5 FAIL lines (`RaidWarningUtil` stub, hover lines); the same 5 show on untouched
`2aebf7a`, so card `0075` carries them. The brief's `pest`/`pint` do not apply: this repo has no
PHP. Still needs a live client: `/reload`, open the talent window as Guardian and Resto, and see
no warning triangle and no dropped rows.
