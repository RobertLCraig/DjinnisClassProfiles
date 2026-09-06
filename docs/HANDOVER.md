# HANDOVER: Djinni's Class Profiles (DCP)

> A World of Warcraft Retail addon that saves and restores action bar layouts as named profiles,
> shared across every character of the same class on the account, with MySlot import. Read this,
> then `docs/board/`, before changing anything.

**Stage:** dormant
**Category:** addon
**Status:** v0.3.1, `Interface: 120100`. The tree is clean and **three commits sit on `master`
unpushed**. Note the remote name does not match the folder: it is
`github.com/RobertLCraig/DjinnisActionBarProfiles`, the addon's earlier name. Last commit
`2026-08-15`, "chore: ignore the releases/ build output, as the other addons do".
**It is NOT installed in the game**, so nothing here has been run against 12.1.0 by anybody. Rob
narrowed active scope to four addons and this is not one of them.
_Last updated: 2026-08-26 (board and handover created; no addon code was touched)_

## Goal & success criteria
**No PRD exists. This section is an interim home and a real gap.** What follows is lifted from
`README.md`, which states the problem and the solution plainly, and is not a spec Rob signed off.

Goal: stop a player with several characters of one class setting up action bars on each of them by
hand.

What `README.md` claims the addon does, and what a change here must not break:
- **Save** the current action bar layout as a named profile.
- **Load** a profile on any character of the same class, account-wide.
- **Undo** the last restore, from an automatic backup taken before every load.
- **Import** MySlot exports, with the protobuf format auto-detected.
- **Export** in a native format for sharing or backup.
- Macros matched by name, with an index hint as fallback, because macro indexes are volatile.
- Flyout spells restored by scanning the spellbook.
- **Combat-safe:** saves refused in combat, restores deferred until combat ends.

**Talent loadouts are stated as "soon" in both the `.toc` and the README**, and `TalentProfiles.lua`
exists. Whether it works is not recorded anywhere. **The non-goals are unknown and need Rob.**

## Canonical data shape
`DjinnisClassProfilesDB`, one account-wide SavedVariables table declared in the `.toc`, keyed by
class. **Its shape lives in `ProfileManager.lua` and `Settings.lua` and nowhere else**; there is no
`DATA-MODEL.md`, and that is a gap rather than a decision.

The other data shape here is not Rob's: **the MySlot protobuf export format**, read by
`ActionBarProfiles.lua`. `C:\Dev\WoWAddons\myslot` is a checkout of that addon and is the authority
on it. Do not guess at that format from memory.

## Architecture / stack
Lua against the Blizzard Retail API, with bundled libraries under `Libs/`. `## OptionalDeps: Myslot`
is a compatibility declaration. 11 Lua files. No build step beyond `release.ps1` and no test suite:
**every check that matters happens in a live game client, which no agent can run.**

## Key files / structure
- `Core.lua` - load and event wiring.
- `ProfileManager.lua` - the profiles themselves and `DjinnisClassProfilesDB`.
- `ActionBarProfiles.lua` - reading and writing action bar state, and the MySlot import.
- `KeybindingProfiles.lua`, `TalentProfiles.lua` - the two extensions beyond action bars.
- `CompanionFrame.lua`, `Settings.lua` - the UI.
- `Libs/` - bundled third-party libraries. **Tracked on purpose**, as `WoWAddons#0003` settled.
- `deploy.ps1` and `release.ps1` - this addon owns its own, with their own exclusion lists.
- `TODO.md`, `CHANGELOG.md`, `RELEASE_NOTES.md`, `baseprompt.md` - **history and scratch, not a
  plan.** Anything still owed belongs on `docs/board/`, and `TODO.md` in particular is the file most
  likely to disagree with the board; treat the board as the authority.

## Decisions locked
- **Profiles are class-scoped, not character-scoped.** That is the whole point of the addon.
- **Macros are matched by name, with an index hint only as a fallback**, because macro indexes move
  under you. Reversing that is a data-loss change, not a preference.
- **Every load takes a backup first**, which is what makes Undo possible.
- **`Libs/` is tracked.** See `WoWAddons#0003`.

## Current state
Dormant and out of the game. The 12.1.0 sweep across the workspace updated `.toc` files and one
renamed function and **checked nothing else**, so this addon has been cleared of neither of the two
known 12.1 faults: secret values and protected events. See `C:\Dev\WoWAddons\docs\DECISIONS.md`.

## What's next (in order)
**`docs/board/` owns this.** The board is empty because nothing has been triaged into it yet, not
because nothing is owed - the unpushed commits, the unfinished talent half and the unaudited 12.1
sweep are all real. `TODO.md` is where the previous plan sat and is a good source to triage from,
but it is not the board.

## Blockers / open questions
- **Three unpushed commits on `master`.** `WoWAddons#0007` is the workspace card covering merge and
  push across the repos; check it before pushing from here.
- **The remote is named for the old addon name**, `DjinnisActionBarProfiles`. Renaming it is a call
  for Rob, not a thing to do unasked: it breaks anybody's existing clone.
- **Is the talent half finished?** `TalentProfiles.lua` exists and the `.toc` still says "soon".
- **Never run on 12.1.0.** Expect Lua errors on first deploy rather than assuming none.

## How to pick up
1. Read this file, then `docs/board/README.md` and any card in `docs/board/`.
2. Read `CLAUDE.md` in this repository root, then `C:\Dev\WoWAddons\docs\DECISIONS.md` for the two
   12.1 traps before touching event registration or anything keyed on a unit.
3. Deploy from the workspace and never edit the game folder:
   `C:\Dev\WoWAddons\bin\deploy.ps1 -WhatIf -Only DjinnisClassProfiles`, then the same without
   `-WhatIf`. The dry run is the plan.
4. Check any API against `C:\Dev\WoWAddons\wow-ui-source\`, never from memory, and the MySlot format
   against `C:\Dev\WoWAddons\myslot`.

## Sibling docs
- `README.md` in the repository root is the goal statement until a `docs/PRD.md` exists.
- `CLAUDE.md` in the repository root, for agent instructions specific to this addon.
- Workspace: `C:\Dev\WoWAddons\docs\HANDOVER.md` and `docs\DECISIONS.md`.
- **Gaps:** no `PRD.md`, no `DATA-MODEL.md`, no `DECISIONS.md`.

## Branch status
One branch, `master`. Clean, three commits ahead of `origin/master`.

## Session log
- **2026-08-26** Board and handover created, so this stops showing on `board:map` as an
  unidentifiable nested folder. No addon code was touched.
