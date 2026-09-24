# 0058 Rename the addon to DjinnisClassProfiles, and tag its loadouts "[CP]"

## Why

Rob, 2026-09-24, on card `0050`'s tag question: "I dont like using BiS because it litterally means
'Best in Slot' which a talent loadout cannot be. this is really why I had a seperate addon for talents
originally being ClassProfiles so CP as the prefix would have worked." Then: "rename the addon to
DjinnisClassProfiles and drop the BiS part. replacing DjinnisClassProfiles with this one". Asked
whether that meant the gear side goes too, he answered **A: rename only, everything stays**.

## What

- **The name.** Folder, `.toc`, title "Djinni's Class Profiles", every chat line, window title and
  frame name. The gear side keeps its words where they describe gear ("BiS list" is still a list of
  best-in-slot items).
- **The tag.** Every loadout the addon makes is named `[CP] <build name>`. The longest build name is
  24 letters, so 29 of Blizzard's 30. `[CP] ` is how "Set up this character" (card `0057`) tells the
  addon's loadouts from Rob's own, the way Improved Talent Loadouts uses `[ITL]`.
- **The saved data.** The game keeps saved data in a file named after the addon's folder, so a new
  folder starts empty. For one version, a stub `DjinnisBiS` folder holds only the old saved data
  (`DjinnisBiSDB`, `DjinnisBiSCharDB`). The new addon copies it over the first time it loads on each
  character, and says when it has. Rob deletes the stub once every character he plays has logged in.
- **The old DjinnisClassProfiles.** Not installed in the game. Its repository keeps its history;
  its code is replaced by this addon's. Card `0035` no longer retires it.
- **The old loadouts.** Loadouts named without the tag are cleaned up through the existing Delete
  old loadouts path, once per character, with Rob's say-so (he accepted this, 2026-09-24).

## Acceptance

To write with the build. The pure parts (the tag, the length check, the copy of saved data) go in
the self-test; the load on a real client is Rob's.

## Not this card

- The build manager and the internal keys `Class - Spec - Instance - Build`: card `0057`.
- Making the GitHub repository public: Rob's call, asked separately.

## Comments

**2026-09-24, Claude.** Written from Rob's answer. Open question for Rob before the repository
moves: DjinnisBiS is a private GitHub repository and the old DjinnisClassProfiles is public.

**2026-09-24, Claude. Built, v0.47.0. The tag moved to card `0059`.**

Rob, 2026-09-24: "want to fulyl merge and rename. sure push into the DjinnisClassProfiles".

- **One repository.** This repository's history is merged into the old DjinnisClassProfiles (merge
  commit, `git read-tree` of this tree), so both histories are kept. The old Class Profiles code is
  at tag `legacy-0.3.1`. The remote is the public github.com/RobertLCraig/DjinnisClassProfiles.
- **Names.** `DjinnisClassProfiles.lua` and `.toc`, title "Djinni's Class Profiles", chat prefix,
  prompts, window title, frame names `DjinnisCP*`, `DjinnisClassProfiles_Toggle`, slash `/dcp` and
  `/djcp` (`/djbis` and `/bis` are gone; the offline scan flags all four in text). Kept on purpose:
  Auctionator's list name "DjinnisBiS plan" and Baganator's widget id `djinnisbis_plan`, so Rob's
  list and corner setting carry over; the roll lines' "[BiS]" (they are about gear).
- **Saved data.** `DjinnisCPDB` and `DjinnisCPCharDB`. `PlanTab.moveSavedData`, first thing at
  `PLAYER_LOGIN`, copies `DjinnisBiSDB` and `DjinnisBiSCharDB` once each, deep, marked `fromBiS`,
  and says so. The old tables are never written.
- **The stub.** `C:\Dev\WoWAddons\DjinnisBiS\`: a `.toc` that declares the two old tables, an
  empty `.lua`, and its own mirroring `deploy.ps1`, so the deploy clears the old code out of the
  game folder. Tracked by the workspace repository. The new `.toc` has `## OptionalDeps: DjinnisBiS`
  so the stub loads first.
- **The old local folder** moved to `%TEMP%\DjinnisBiS-old-2026-09-24`, not deleted.

Checks: `PlanTab.renameChecks` (copy, deep, once, a new character's at its login, the message).
`%TEMP%\mut0058.py` has 7 breaks, all red. Both Luas green; all 36 non-druid specs pass.

## What I need from you

After `/reload` (a full restart is safer: the folder list changed):
1. Chat says "Djinni's BiS is now Djinni's Class Profiles, and your saved data is copied over."
2. Open the window from the minimap button. Pass: your saved bars profiles, gear targets and sim
   imports are all there.
3. The add-on list shows "Djinni's BiS (old saved data)". Leave it on until every character you play
   has logged in once, then turn it off.