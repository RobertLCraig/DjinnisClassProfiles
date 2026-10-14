---
needs: 0088
---
# 0100 Take the Rob-only parts out of what ships

## Why

Card `0094` publishes the addon. Some parts exist only for Rob's own account and confuse anyone
else: More > "Delete old loadouts" talks about the old DjinnisDreamgrove addon, the
`BAR_ABILITIES` keys hold Rob's own choices (Healing Potion on Shift+2, line 10837, card `0083`),
and the rename migration from DjinnisBiS (card `0088`) is still wired in.

## Links

**Blocked by**
- `0088` - the DjinnisBiS stub goes first.

**Relates to**
- `0099` - if Rob's layout ships as the default template, his key choices stay, as data and not as code.

## Not this card

- `DjinnisClassProfilesDB` in the `.toc`. Removing it deletes Rob's old data at logout. For other
  users it is an empty file and costs nothing.
- `PlanTab.moveSavedData`. With no old tables it copies nothing.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN a user who never had DjinnisDreamgrove opens More, THE MENU SHALL not mention Dreamgrove. proves: manual
- [ ] WHEN the user-visible strings are searched, NONE SHALL name Rob or Djinni's characters. proves: `offline-check.lua` (a new check over the strings the menus and tooltips build)
<!-- AC:END -->

## Tasks

1. Grep user-visible strings for "Rob", "Djinni" (not the addon title), "Dreamgrove".
2. Show the Dreamgrove part of the tidy only when a Dreamgrove loadout exists.
3. List each Rob-only key choice on this card and ask Rob which stay as defaults.

## Comments

**2026-10-14** Raised from card `0094` (attended).
