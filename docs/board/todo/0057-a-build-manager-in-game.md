---
needs: 0050, 0058
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

To write with the build, once `0050` is settled. The frame parts need Rob in game; the list, the
string checks and the "what would Set up do" plan are pure and go in the self-test.

## Not this card

- Action bars per build: cards `0033` to `0046` already cover them, and `0051` copies layouts across
  classes.
- Sharing with other players beyond the export string.

## Comments

**2026-09-24, Claude.** Written from Rob's message. Not started. Prior art to read first:
`docs/research/talent-loadout-addons.md` (TalentLoadoutsEx's list, ImprovedTalentLoadouts'
account-wide builds) and `DjinnisClassProfiles` (card `0035`).
