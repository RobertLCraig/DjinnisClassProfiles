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

## Comments

### 2026-09-23, adversarial review of 2ae2239

What I attacked. I checked the acceptance, the slash parsing, how profiles stay apart from the
offered layouts, undo, loading on another spec, the fences, and whether each check goes red without
its code. Mutations and probe checks ran on copies in `$TEMP/review3637`. The harness is clean on
the real code under Lua 5.1 and 5.4.

What held:
- **The checks go red without their code.** These eight mutations each turned checks red: a
  case-sensitive match, a load that does not read the profile table, `save build` falling through
  to a profile, no trim, no `|` rule, no 40 limit, profiles stored in `db().bars`, a delete that
  does nothing, and a replace stored under the new spelling.
- **Names.** A name with spaces works. So do `100% %s`, a UTF-8 `é`, `[x]` and a backslash. The
  name only ever goes into `format` as an argument, never as the format string. Exactly 40 bytes
  saves and 41 is refused. An empty name cannot reach `saveProfile`, because
  `/djbis bars save` with no name is the spec layout's command.
- **Kept apart from the offered layouts.** Profiles live in `DjinnisBiSDB.barProfiles`. `barsKey`
  and `offerBars` read only `barsDB()`, so a profile called `Feral` is never offered.
  `applyBars(key, from)` leaves `barsSeen` alone. A probe checked that loading a profile leaves
  `barsSeen` at `Feral`.
- **Undo.** I cleared `barsUndo` first, then loaded a profile and ran undo. It answered `undone`
  and took the slot back off. So a profile load keeps its own undo, through the same code as 0033.
- **Another spec.** `loadProfile` never reads the spec. What this spec cannot pick up is skipped
  and listed by `placeBars`, and an empty slot in the profile clears the slot here. That is the
  card's "any spec", and undo covers it.
- **Fences.** In combat, both `load` and `save` are refused.
- No new Blizzard API is used. Profile names are typed by the player, so none is a secret value.

What broke. Nothing a player loses by, but there are three notes:
- **The card says "no profile can be called `build`". That is not quite true.**
  `/djbis bars save Build`, `save BUILD` or `save  build` (two spaces) makes a profile called
  `Build`, because `DjinnisBiS.lua:7115` compares case and spacing exactly. Chat says "Saved the
  Build profile", so the player sees it, and nothing is overwritten. If it matters, refuse
  `name:lower() == "build"` in `saveProfile`.
- **The verbs are case-sensitive.** `/djbis bars Load main` falls through to the spec offer. That
  is a prompt, so it changes nothing without a click. The rest of the slash commands behave the
  same way.
- **The check "and undo takes it off" is weak.** It still passes when the profile load keeps no
  undo, because an undo left by the 0033 checks puts slot 11 back anyway. Clearing
  `DjinnisBiSCharDB.barsUndo` before the load makes it real, and I checked that version goes red.
  Two more mutations also pass: the `barsSeen` guard (`:7048`) and the fence on save.

Security:
1. Weakest point: `/djbis bars save <name>` and `delete <name>` act at once and account-wide. A
   profile saved on one character can be replaced or deleted from another without a question. Chat
   says "Replaced" or "Deleted". It is a typed command, and the card asks for no confirmation.
2. Unchecked input: the name is checked for length, trim and `|`. It is used only as a table key
   and as a `format` argument. A tampered SavedVariables entry that is not a table would error in
   `list`, but only the player's own files can do that.
3. What it leaks on failure: nothing. The player gets one chat line. A second, older risk is not
   new here: `/bis test` swaps out `barProfiles`, as it swaps `bars`. A Lua error partway through
   the checks followed by a `/reload` would save the test data over the real profiles.

There is no browser surface. Acceptance can only be checked in a client.

Verdict: CLEAN, human-review next.

**2026-09-23** Builder, v0.35.1. Two of the notes taken: `saveProfile` refuses "build" in any case
and spacing, with a check, and the undo check clears `barsUndo` before the load so it can only
pass on the load's own undo. Case-sensitive verbs are left as they are, the same as every other
slash command here.
