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

Written after the build (the review's finding 4), so attack the code, not these ticks.

- [x] The old saved data is copied once per account and once per character, deep, into a table
      made before login too, never writing the old tables, and it says so.
      proves: `PlanTab.renameChecks`
- [x] The copy runs first at `PLAYER_LOGIN`, so the minimap icon gets the old position.
      proves: `offline-check.lua`, "the rename" block (fires the real login handler)
- [x] The `.toc` keeps `DjinnisCPDB`, `DjinnisCPCharDB` and the old Class Profiles'
      `DjinnisClassProfilesDB`, loads the stub first, and has every `## ` line before anything else.
      The stub declares the two tables the copy reads.
      proves: `offline-check.lua`, the `.toc` block
- [x] No text the player sees names a slash command, old or new.
      proves: `offline-check.lua`, the card 0053 scan
- [x] The public repository ships the Ace3 licence, `Libs/CallbackHandler-1.0/LICENSE.txt`.
      proves: `git ls-files Libs`
- [ ] In the game: the message, the data, the stub in the add-on list, no second message after
      `/reload`. proves: manual (Rob; see What I need from you)

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

**2026-09-24, Claude (adversarial review of 905b395, 1535c6e, 3b16a73 and workspace 2c91b52). Back
to todo: the old name is still on screen, the wiring that does the copy is unchecked, and the
public repository lost its library licence.**

How I tried it: a scratch copy (`%TEMP%\rev0058`). The builder's `mut0058.py` and `mut0053.py`
were adapted to the scratch copy (`mut0058cp.py`, `mut0053cp.py`), and my own list is `revmut.py`.
One run at a time. Nothing ran on the real files, and nothing in `C:\Games` was read.

Findings, in the order to fix them:

1. **The copy's wiring has no check.** Eight of my nine mutations for this card stay green:
   - the `moveSavedData` call removed from `PLAYER_LOGIN`, or moved after everything else
     (DjinnisClassProfiles.lua:8146)
   - either SavedVariables line in the `.toc` given the wrong name (DjinnisClassProfiles.toc:8-9).
     That would lose all saved data at the next logout, with nothing said.
   - `## OptionalDeps` dropped (line 12)
   - `copyOld` writing into the old table, which `## What` says never happens
   - a table made before the login thrown away, though a check is named "into a table made before
     the login"
   - the message emptied

   `renameChecks` proves `copyOld` and `moveSavedData` well, but not that anything calls them. Fix:
   the harness already keeps every frame's handlers (`registered`). Set `DjinnisBiSDB` and
   `DjinnisBiSCharDB`, fire `PLAYER_LOGIN` at the loader, then check both new tables. Read both
   `.toc` files. Check the new one declares exactly `PlanTab.SAVED_VARIABLES` and lists
   `DjinnisBiS` in its OptionalDeps. Check the stub declares the two names `moveSavedData` reads.
   Check the old table is unchanged after the copy.
2. **The old name is still where a player sees it.**
   - **More > "Open the BiS window"** (line 7963). The window is titled "Djinni's Class Profiles"
     now. The menu check pins the old text (lines 9214 and 9217), so renaming the item turns it red.
   - **The "BiS plan" tab beside the talent window** (line 6434). That tab is the talent build
     list, which is the thing you said "BiS" cannot describe.
   - **"(DBiS plan)" in the /simc export** (line 5004), and the **"DBiS " equipment set prefix**
     (line 4525). The set prefix may be worth keeping, so the sets you already saved still match.
     If so, say so under Kept on purpose, as Auctionator's list name is. Nothing depends on the
     export comment.
   - The spare loadouts' "BiS: " prefix (line 6864) is card 0059's, which says so. Not this card's.
3. **The public repository now ships the Ace3 libraries with no licence.** The merge (905b395)
   deleted `Libs/CallbackHandler-1.0/LICENSE.txt`. The old Class Profiles repository carried it.
   `CallbackHandler-1.0.lua` has no notice of its own. The BSD terms need the notice kept, and
   github.com/RobertLCraig/DjinnisClassProfiles is public and pushed. Fix: `git checkout
   legacy-0.3.1 -- Libs/CallbackHandler-1.0/LICENSE.txt`. The workspace docs 2c91b52 left behind
   also need fixing. `docs/HANDOVER.md:377-379` still names DjinnisClassProfiles as one of three
   that carry the file. `docs/PRD.md:90` still says DjinnisBiS has no remote.
4. **The card has no acceptance.** `## Acceptance` still says "To write with the build". Write the
   criteria with `proves:`: the `renameChecks` names, the check from finding 1, and `proves: manual`
   for the list below.
5. **The old Class Profiles' own saved data was not considered.** The card says the old addon is
   "Not installed in the game". But the workspace HANDOVER says its code was last in a client in
   April. If that left `WTF\Account\<account>\SavedVariables\DjinnisClassProfiles.lua` behind, the
   new addon now loads that file under its own name. The first logout rewrites it with `DjinnisCPDB`
   only. The old addon's profiles would then be gone. `AddOns.txt` may also still hold a disabled
   state for that folder name. Nothing here can see the WTF folder. So this goes first on your list,
   and the card should say what happens to that file.
6. Small: the data broker and the minimap button were renamed too, from "DjinnisBiS" to
   "DjinnisClassProfiles" (lines 4031 and 4044). The minimap position carries over, because it sits
   in the copied table. A broker display you set up for "DjinnisBiS" (card 0026's data bar line)
   will lose the line. Either keep the old broker name, as Auctionator's and Baganator's were kept,
   or put it on your list. Line 1 of the file also reads "Djinni's Class Profiles (was Djinni's
   Class Profiles until 0.47.0".

**The load-order claim, against `wow-ui-source` (12.1.0, 09b9db794).** The source does not say
when saved data arrives or what `## OptionalDeps` does to load order.
- `AddOnsDocumentation.lua` has `ADDON_LOADED` (line 391) and `GetAddOnOptionalDependencies`
  (line 211), and nothing on ordering.
- `SystemDocumentation.lua` has `PLAYER_LOGIN` (line 131), and nothing on what comes before it.
- The nearest evidence is Blizzard's own talent frame. It reads its saved variables only once its
  own add-on's `ADDON_LOADED` has fired (`Blizzard_ClassTalentsFrame.lua:106`, `:161`, through
  `EventUtil.ContinueOnAddOnLoaded`). That fits "an add-on's saved data is there from its own
  `ADDON_LOADED`", and says nothing about another add-on's.

So "the old data is loaded by the new addon's `PLAYER_LOGIN`" cannot be read from the source. It
rests on the client's behaviour: every add-on that is not load-on-demand loads before
`PLAYER_LOGIN`. The workspace DECISIONS entry of 2026-09-02 rests on the same. If that holds, the
stub's data is there at login whatever the order. OptionalDeps only matters if the copy ever moves
to this addon's own `ADDON_LOADED`.

One more thing the source cannot settle. In the new `.toc`, `## OptionalDeps` comes after a `#`
comment line in the middle of the directives. No `.toc` in `wow-ui-source` does that, and none of
the reference add-ons here do. So whether the client still reads that line is for your list.

What held:
- **The copy itself.** Both old tables are copied (the old `.toc` declared exactly those two). The
  copy is deep, keys too, and runs first at `PLAYER_LOGIN`. Each new table carries its own
  `fromBiS` mark, so the account's is copied once and each character's at its own first login. A
  table that already has the mark is left alone, and the old tables are only read. It all sits in
  a `pcall`. If it throws, the next login copies again into the table made meanwhile.
- **The rest of the rename.** Slash commands, chat prefix, window title, prompts, frame names,
  `DjinnisClassProfiles_Toggle`, the tooltip title and Baganator's label are all renamed. The
  offline scan catches `/djbis`, `/bis`, `/dcp` and `/djcp` in text. The kept names (Auctionator's
  list, Baganator's widget id, the "[BiS]" roll lines) are the ones the card lists.
- **The stub.** Its `.toc` declares the two old tables and nothing else runs. Its `deploy.ps1`
  mirrors only inside its own folder. Its `pkgmeta.yaml` keeps the tooling out. The workspace
  `.gitignore` tracks only `DjinnisBiS/`.
- **Tests.** `offline-check.lua` exits 0 under Lua 5.1 and 5.4.6. I read the whole output: no load
  error, no FAIL line. All 36 non-druid specs pass spec mode; 102 to 105 fail it, as expected. No
  new main-chunk local; the file loads under 5.1.
- **Mutations.** The builder's 7 (`mut0058.py`): 7 caught. The builder's 54 (`mut0053.py`,
  adapted): 54 caught. My 9: 1 caught (renaming the menu item, caught only because the check pins
  the old text), 8 missed (finding 1).
- **What went public.** I scanned the merged history for tokens, keys and passwords and found
  none. `research/` (other authors' add-ons) was never committed. The commits carry
  `r@craig.ooo`, `djinni.rc@gmail.com` and, since the merge, `djinni@localhost` as author
  addresses; you chose to push those.

Security, where the card produced code:
1. *Weakest point:* two `.toc` lines and one line at `PLAYER_LOGIN`. Get one wrong and every
   saved layout, profile and gear target is dropped at the next logout, with nothing said. Nothing
   checks any of them (finding 1).
2. *Unchecked:* the old saved data is copied whole with no validation. It is your own file, so
   that is fine. The legacy `DjinnisClassProfiles.lua` saved-data file (finding 5) is not handled.
3. *Leaks:* nothing in the game. The repository is now public with the whole DjinnisBiS history:
   no credentials, the author addresses above, and the Ace3 notice missing (finding 3).

**No browser, no game client.** The surface is the game's add-on loader and saved-data files. After
the fix, before you log in:
1. If `WTF\Account\<account>\SavedVariables\DjinnisClassProfiles.lua` exists, copy it somewhere
   safe. It is the old Class Profiles' data.
2. Check the game's `AddOns\DjinnisBiS` folder holds only `DjinnisBiS.toc` and `DjinnisBiS.lua`. If
   the old addon is still there, both addons will run.

Then:
3. Restart the game fully.
4. Chat says "Djinni's BiS is now Djinni's Class Profiles...".
5. `/dump C_AddOns.GetAddOnOptionalDependencies("DjinnisClassProfiles")` shows `DjinnisBiS`.
6. The window has your saved bars, profiles, gear targets and sim imports. The minimap button is
   where it was.
7. `/reload`: no message this time.
8. On a second character: the message again, and that character's loadouts and spares are its own.
9. Your broker display still shows the plan line, or you re-add it.

**2026-09-24, Claude. The review's findings, fixed in v0.47.1.**

1. **The copy's wiring is checked.** The offline check fires the real `PLAYER_LOGIN` handler with old
   data and a fake minimap library: the data must arrive, the icon must get the old position (so the
   copy runs first), the old tables must be unwritten, and the message must say "copied over". The
   `.toc` is read too (names, `OptionalDeps`, directive order), and the stub's names are matched to
   the code's. `renameChecks` adds: keeps what a table made before login held, the old table unwritten,
   the message text.
2. **Old name on screen.** The talent tab is "Builds", the menu item "Open the main window", the /simc
   marker "(CP plan)". Kept on purpose, with a comment: the equipment set prefix "DBiS " (Rob's saved
   sets are found by it) and the broker text "BiS: on plan" (it counts gear against the BiS plan).
3. **Licence.** `Libs/CallbackHandler-1.0/LICENSE.txt` is back, from tag `legacy-0.3.1`. The workspace
   `docs/HANDOVER.md` and `docs/PRD.md` lines are corrected.
4. **Acceptance** written above, marked as written after the build.
5. **The old Class Profiles' data.** Too late for one file: Rob loaded v0.47.0 at 03:09, and the
   game rewrote `WTF\Account\DJINNWRAITH\SavedVariables\DjinnisClassProfiles.lua` at 03:13. Whether it
   held old Class Profiles data before cannot be told now. The other account, `958357#1`, still had
   it (`DjinnisClassProfilesDB`, action bar profiles, May 2026). Every such file was copied, read only,
   to `C:\Dev\WoWAddons\.wtf-backup-2026-09-24\`, and the `.toc` now declares
   `DjinnisClassProfilesDB` so the game keeps it. No `AddOns.txt` has `DjinnisClassProfiles` disabled.
6. **Smaller.** Line 1 of the Lua file fixed. The broker and minimap names stay `DjinnisClassProfiles`;
   a data bar that showed the old broker needs it added again (on Rob's list).

The copy worked in Rob's client: after his 03:09 login, `DjinnisClassProfiles.lua` in each
SavedVariables folder is the size of its `DjinnisBiS.lua`.
