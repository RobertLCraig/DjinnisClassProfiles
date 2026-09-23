# 0033 Action bars the same on every character of the class

## Why

Rob, 2026-09-23: "I play multiple characters of the same class, and I want as much as possible to be
the same between them. especially actionbars and talents." TalentLoadoutsEx never saved action bars;
ImprovedTalentLoadouts did, and that is why he preferred it. `DjinnisClassProfiles` was his own
attempt and went dormant: "couldn't get it working properly the way I wanted".

## What

- One saved layout per class and spec, account-wide. Save it on one character, apply it on another.
- **Reuse the engine in `C:\Dev\WoWAddons\DjinnisClassProfiles\ActionBarProfiles.lua`**, not its UI:
  slot read and place, macros matched by name with the index as a hint, flyouts found through the
  spellbook, a backup before every apply and one-step undo. Its talent half targets
  `ClassTalentFrame`, the Dragonflight window, and is not carried over.
- Apply only out of combat and only on a click. A spell this character does not know is skipped
  and listed, not guessed.

## Open, and Rob's to say

- **One layout per spec, or one per build?** ImprovedTalentLoadouts tied bars to a loadout. This
  card assumes per spec, because most builds in a spec share buttons, with per-build as a later card.
- Keybindings too? `DjinnisClassProfiles/KeybindingProfiles.lua` exists.

## Acceptance

- [ ] WHEN Rob saves on one druid and applies on another, THE ADDON SHALL place every spell both know in the same slot, and SHALL list what it skipped.
- [ ] WHEN a layout is applied, THE ADDON SHALL keep the previous layout for one undo.
- [ ] IN combat, THE ADDON SHALL refuse and say why.
- [ ] In a client: after an apply, one pull on a dummy with no frozen button. Writing slots from addon code is how MySlot works, but it is not yet proven clear of the fault in `0002`.
