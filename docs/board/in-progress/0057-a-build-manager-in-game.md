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

**2026-09-25, Claude (adversarial review of c6f3f46).** Verdict: **bounce**. One high finding, which
is card `0059`'s trap coming back for your builds, and five smaller ones. The card stays in
`ai-review/` for now because another session is editing `DjinnisClassProfiles.lua` for `0063`; move
it to `todo/` when that session is done. Line numbers are c6f3f46's.

What I ran and attacked:
- `offline-check.lua`, `offline-check.lua 250` and `offline-check.lua 62` under Lua 5.1, in a copy
  of c6f3f46. All three end "no FAIL lines". I read the output whole.
- Seven mutations of `myBuildChecks`' guards. Five went red: the `[CP` refusal, the plan winning a
  name clash, the combat fence in Rename, the worn-loadout guard in Delete, and the own-loadout
  name check. **Delete's fence survived its removal**: no check covers it (finding 5).
- Five probe checks added to the copy only, never to the repo. All five failed as predicted
  (findings 1, 2 and 3).
- Checked against `wow-ui-source` (live, 09b9db794): `ImportLoadout(configID, entries, name,
  importString?)`, Blizzard's loadout name box is `letters="30"`, and Blizzard's import box has
  `maxLetters` 1000 (`Blizzard_ClassTalentLoadoutImportDialog.xml:38`). The talent frame
  listens for `TRAIT_CONFIG_DELETED` and `TRAIT_CONFIG_LIST_UPDATED`, so renaming or deleting
  with the window open is fine, as the card says.
- No browser applies here. This is a game addon and no agent can run the client. The six in-game
  looks on this card are still Rob's.

**Findings**

1. **HIGH. A loadout of yours named like one of your builds is taken for that build's loadout,
   and Reset deletes it.** `savedLoadoutNames` (4250) passes only the plan's builds to
   `loadoutKey`. So an untagged "Mine" is filed as `saved["Mine"]`, the key the build "Mine" is
   looked up by. The name check at creation (`myNameProblem`, 7874) covers only this character,
   at that moment. How it happens: you make the build "Mine" on your druid. Your alt already has a
   loadout "Mine" it made itself, or you later make one on either character. The row then reads as
   saved or drifted, never missing. Wear switches to your own loadout. That loadout disappears from
   Your loadouts (6367), and the build's action bars go with it. Reset to the plan... asks
   "Reset '[CP] Mine'?" and then deletes **your** "Mine". A probe showed it: the job came out as
   `[CP] Mine replace 21`, and 21 is the id of your own loadout (7522, then `importOne`). If you
   are wearing it, the swap deletes it instead. The comment at 4247 reasons that your builds came
   after the tag. That is true of the build and not of your loadout.
   *Fix:* in `savedLoadoutNames`, file an untagged loadout named like one of your builds for this
   spec apart from `names` (a fourth table). List it under Your loadouts by its own name. Then only
   "[CP] Mine" is ever the build's loadout. Add a check that `saved.Mine` is nil and that
   `rowState` answers missing.
2. **MEDIUM. Deleting or renaming a build the plan has since named acts on the plan's loadout.**
   `mineLoadout` (7967) finds "[CP] Dungeon". That is now the loadout for the plan's "Dungeon",
   which `buildsOf` puts first. A probe showed `deleteMine("Dungeon")` sending
   `delete [CP] Dungeon`. Rename takes it to "[CP] <new name>", and the plan's row then reads
   missing. *Fix:* in `renameMine` and `deleteMine`, when `PlanTab.BUILDS[spec][name]` exists, leave
   the loadout alone and change the saved list only. The Delete box should say so. Add a check.
3. **MEDIUM-LOW. Rename and Delete check the fence only when this character has the loadout**
   (7991, 8029). How it happens: Save to the game on "Mine" starts the queue making "[CP] Mine",
   and you delete or rename "Mine" before the loadout lands. The build is changed and the queue
   still makes "[CP] Mine", which is left with no build and shows under Your loadouts. A probe
   showed Delete answering `deleted` while `PlanTab.q` was running. *Fix:* call `changeFence()`
   first, whether or not a loadout exists.
4. **LOW-MEDIUM. An import from an older tree is kept with a note, and then its row hides it.**
   `sidebarList` (6386) warns with `buildProblem`, which gives `TREE_CHANGED`. With a warning,
   `rowMenuItems` (7786) drops Copy and Export and greys Save, but a double-click still wears it
   through the spare. The note says the game accepts it, and the row says the reverse. *Fix:* on a
   row of yours, show `TREE_CHANGED` as a note, not a warning, and always offer Export of your
   own string.
5. **LOW (test gap).** With Delete's `changeFence` removed, every check still passes. Rename is
   tested for combat only, and nothing tests a queue, a tag run or a swap in progress, which
   acceptance line 5 promises. *Fix:* check Delete in combat, and both actions with `q`,
   `tagging` and `swapping` set.
6. **LOW. The import box has no limit, and only the header is checked.** `importAsk` (7952)
   passes 0, and `importProblem` reads only the header. So a real header with a long tail after it
   is kept in the account file and later sent as `ImportLoadout`'s `importString`. The same holds
   for a hand-edited name in `myBuilds`: `buildsOf` and `sidebarList` accept any string key, even
   one with `|` codes, over 24 letters, or starting `[CP`, none of which the name box would allow.
   *Fix:* cap the box at 1000, as Blizzard does, and refuse anything but `[%w+/=]`. Pass saved
   names through a name-shape check before they are listed or made.

What held: you cannot pick a plan's name, and the plan's table is never written. `buildsOf`
drops keys and values that are not strings. Stored strings lose their whitespace. The worn
loadout is never deleted: this is checked when you click and again when the change is sent.
Delete looks the loadout up again after its box. `tagNext` checks the name by id before it
changes anything. Each byte counts as a letter in the name check, so a 24-letter name with the
6-letter mark always fits Blizzard's 30. You cannot type `|` or `[CP`. A plan build that later
takes your name wins, has no Wear or Save, and shows its warning.

**Security**
1. *Weakest point:* the key that loadouts are looked up by (finding 1). Any loadout the player
   makes can take over a build's name on any character, and the addon's delete then goes to it.
2. *Unchecked:* the account file edited by hand (names used without their rules), the pasted
   string past its header, and the Rename and Delete fence when there is no loadout yet.
3. *What it leaks:* nothing leaves the client. The only harm is local: a loadout you made yourself
   deleted, or left behind with no build (findings 1 to 3).

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
