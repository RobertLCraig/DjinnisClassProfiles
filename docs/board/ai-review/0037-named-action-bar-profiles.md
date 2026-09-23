---
needs: 0033
---
# 0037 Named action bar profiles, loadable on any spec

## Why

Rob, 2026-09-23, choosing option 2 on card `0036`: besides the build and spec layouts, he wants
named profiles, saved under a name of his and loadable on any spec.

## What

- `/djbis bars save <name>` saves this character's bars and keys under that name, account-wide.
- `/djbis bars load <name>` puts them on the character, any spec. What it cannot place is skipped
  and listed, as with every layout. `/djbis bars undo` takes it off.
- `/djbis bars list` and `/djbis bars delete <name>`.
- Profiles are never offered on their own. Only the spec and build layouts are.

## Built, v0.35.0, 2026-09-23

- `PlanTab.captureBars` is the one read of bars and keys, shared with `saveBars`.
- Profiles live in `DjinnisBiSDB.barProfiles`, apart from `DjinnisBiSDB.bars`, so a profile name can
  never be taken for a spec or build layout and offered.
- A name is 1 to 40 characters, without `|` (it starts a chat colour code). Names match without
  case: `save main` replaces `Main` and keeps the stored spelling.
- `load` goes through `applyBars(name, profiles)`: the same fences, the same undo, the same skip
  list. It does not set `barsSeen`, so the spec or build offer is not silenced.
- `save build` still saves the build layout, so no profile can be called `build`.
- `/bis test`: 16 checks at the end of `PlanTab.barChecks`. Making the match case-sensitive, not
  reading the profile table on load, or letting `save build` fall through to a profile turns
  checks red. Clean under Lua 5.1 and 5.4.

## What I need from you

1. `/djbis bars save Main`. Pass: chat says how many slots and keys were saved.
2. `/djbis bars list`. Pass: `Main` with today's date.
3. On another character or spec: `/djbis bars load main`. Pass: the bars change, and a list names
   what was skipped.
4. `/djbis bars undo`. Pass: the old bars are back.
5. `/djbis bars delete Main`, then `/djbis bars list`. Pass: it is gone.

## Acceptance

- [ ] WHEN Rob types `/djbis bars save <name>`, THE ADDON SHALL keep his bars and keys under that name for every character.
- [ ] WHEN Rob types `/djbis bars load <name>` on any spec, THE ADDON SHALL apply them, list what it skipped, and keep one undo.
- [ ] THE ADDON SHALL never offer a named profile on its own.
