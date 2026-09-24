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
