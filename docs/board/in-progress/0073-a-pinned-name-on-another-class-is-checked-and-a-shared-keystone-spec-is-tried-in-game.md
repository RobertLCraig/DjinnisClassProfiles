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
- [ ] #1 IF a `PIN` entry for a non-druid spec names a loadout over `NAME_MAX` letters or containing a `"`, THEN `update-builds.py` SHALL exit 1 naming the spec and the name, and leave `DjinnisClassProfiles.lua` byte-identical (settled by running it on a copy with such a pin, since the script has no harness). proves: none
- [ ] #2 WHEN Rob, on a Beast Mastery Hunter after `/reload`, has the addon make its loadouts, THE GAME SHALL show `[CP] Dungeon` and `[CP] Raid` in the talent window's dropdown, and each SHALL load without Blizzard calling the import invalid. proves: manual
<!-- AC:END -->

## Tasks
- [ ] `other_classes()` in `update-builds.py`: refuse a pinned name over `NAME_MAX` or with a `"`, with the same message `block()` gives a druid pin. Put the check in one helper both paths call, so the two cannot drift again
- [ ] Prove #1 on a copy in `%TEMP%`: one pin too long, one with a quote. Each exits 1, and the Lua file's hash is unchanged. Write both results into `## Comments`
- [ ] Add a `## What I need from you` for Rob that is the #2 check, with its Pass and Fail, naming the addon command that makes the loadouts as it stands after `0059`

## Plan
Stand in `C:\Dev\WoWAddons\DjinnisClassProfiles`. The druid check to copy is in `block()`: it
compares a pinned name against `NAME_MAX` and looks for a `"` before calling `checked()`.
`other_classes()` calls `checked()` for pinned names in two places, and both need the check.

For #2, Beast Mastery is the pick because the review found `ungrant()` changed its string and
proved the bits offline. A game client is the only thing that can prove the import. If Beast
Mastery passes, the other nine carry the same shape.
