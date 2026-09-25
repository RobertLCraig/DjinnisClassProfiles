---
needs: 0050, 0059
---
# 0057 A build manager in the game: copy, export, import, rename, delete, and set up this character

## Why

Rob, 2026-09-24: "I accept if we have to clean up and reload talents across all characters. (lets
build in a way to do that easily. - which also leads me back to a thought I had earlier about being
able to copy, export, import, delete (etc...) builds ingame".

`docs/research/talent-loadout-addons.md` already settled the shape: **store** builds in the addon's
own account-wide list (no slot cap, the same on every character), **keep** them as real Blizzard
loadouts on each character (`ImportLoadout`, which creates and does not commit), and **wear** them
through Blizzard's `ClassTalentHelper`. Never write talent nodes from addon code (the frozen action
bar fault, cards `0002`, `0011`).

## What

**The list.** Per spec, two kinds of build:
- **Plan builds**: the ones the addon ships (Dreamgrove, Archon, wowvalor, SimC). Read only. They
  change when the addon updates.
- **Your builds**: account-wide, in SavedVariables, made by you. Every action below works on them.

**Actions on a build** (right-click a row in the list beside the talent window, and in the More menu):
- **Copy**: a plan build or the talents in play become one of your builds, under a name you type.
- **Export**: shows the build's import string in a box, selected, ready for Ctrl+C. The same string
  Blizzard's own Import, Wowhead and Archon use.
- **Import**: paste a string, type a name. Refused with a reason if the string is for another spec
  or will not read.
- **Rename** and **Delete** (Delete asks first).
- **Wear**: as today, through Blizzard's helper.

**Set up this character.** One button: every addon loadout on this character that no build in the
list names any more is deleted, every build missing a loadout gets one, and every drifted one is made
again. It says what it will do and asks first. It keeps to slot limits (the spare, card `0040`) and
never deletes the loadout you have selected. Loadouts live on the server per character, so each
character is set up when you log into it: the addon offers it on login when that character is out of
date with the list.

**Addon loadouts are told apart by their name tag**, the choice on card `0050`, so "Set up" can
never delete one of your own.

## Acceptance

Written with the build, 2026-09-25. "Set up this character" is not in it: Rob parked making
loadouts on its own (card `0065`), so it moved to card `0066`.

- [x] WHEN a build or loadout with a string is copied, or a string imported, under a free name,
  THE ADDON SHALL keep it in `DjinnisCPDB.myBuilds[spec]`, for every character of the class.
  proves: self-test `myBuildChecks`
- [x] WHEN the name is empty, over 24 letters, carries `|` or `[CP`, is a plan build's, is one of
  yours already, or is one of your own loadouts on this character, THE ADDON SHALL refuse it and
  say why. proves: self-test
- [x] WHEN the string will not read, is from another game version or is for another spec, THE
  ADDON SHALL refuse it; one from an older tree is kept with a note. proves: self-test
- [x] Your builds are saved, reset, worn and exported as the plan's are, and the plan's table is
  never written. proves: self-test (`buildsOf`, `buildFor`, `rowState`)
- [x] WHEN one of yours is renamed or deleted, ITS LOADOUT ON THIS CHARACTER SHALL be renamed or
  deleted through the one-at-a-time queue, never the one you are wearing, and in combat or with a
  queue running nothing changes. proves: self-test
- [x] WHEN the plan later takes the name of one of yours, THE LIST SHALL warn on it and offer only
  Copy, Rename, Delete and Export. proves: self-test
- [ ] In game: the boxes, the menu and the Your builds group look and behave right. proves: manual
  (Rob)

## Not this card

- Action bars per build: cards `0033` to `0046` already cover them, and `0051` copies layouts across
  classes.
- Sharing with other players beyond the export string.

## Comments

**2026-09-25, Claude.** Built, v0.52.0.

- **Storage.** `PlanTab.myBuilds(spec)` is `DjinnisCPDB.myBuilds[spec]`: name -> import string.
  `PlanTab.buildsOf(spec)` is the plan's builds plus yours under any name the plan does not use.
  The loadout code reads it (Create, Reset, Save, Wear, the spare, the retired-name guard,
  `/dcp talents`). `savedLoadoutNames` and `activeLoadoutName` still pass the plan's table only to
  `loadoutKey`, so your own untagged "X" is never taken for a loadout from before the tag.
- **The list.** A "Your builds" group, between Other builds and Your loadouts, icon
  `INV_Misc_Note_01`.
- **The row menu.** Every row with a string gets "Copy to your builds...". Your builds also get
  "Rename..." and "Delete..." (Delete asks first).
- **The More menu.** Two new items: "Import a build..." (paste the string, then a name) and "Copy
  the talents in play...".
- **The name box.** `PlanTab.askName` takes a starting text and a letter limit. A refused name is
  said in chat and the box opens again with what you typed.
- **Rename and Delete** send this character's loadout change through `startTagging`, one at a
  time, under `PlanTab.changeFence`. That fence refuses combat and a running queue or swap, but
  not the talent window: Blizzard's own dropdown renames and deletes there. Other characters keep
  their "[CP] old name". It shows under Your loadouts until it is deleted by hand, or until card
  `0066` exists.
- Old menu checks updated for the new Copy item. `myBuildChecks` failed with its guards broken on
  purpose.

**What Rob looks at in game:**
1. Right-click a plan build, then Copy to your builds. It shows under Your builds.
2. Right-click it: Save to the game, then Wear it.
3. Rename it. The "[CP]" loadout in the talent window gets the new name.
4. Delete it.
5. More > Import a build with a Wowhead string. Then the same with another spec's string: it is
   refused.
6. Check that the icon shows. A green square means the icon path is wrong.

**2026-09-25, Claude.** The row menu exists (card `0065`, v0.51.0): a right-click in the list
beside the talent window opens `PlanTab.rowMenuItems`, with Wear it, Save to the game, Reset to the
plan... and Export.... Rob: "right clicks should open menus... part of the menu I also suggested
previously about being able to edit/import/export/delete each build". Export is done. Copy, Import,
Rename and Delete go into that same menu once "your builds" are stored. The "Set up this character"
button is on hold: Rob parked making loadouts automatically (card `0065`).

**2026-09-24, Claude.** Written from Rob's message. Not started. Prior art to read first:
`docs/research/talent-loadout-addons.md` (TalentLoadoutsEx's list, ImprovedTalentLoadouts'
account-wide builds) and `DjinnisClassProfiles` (card `0035`).
