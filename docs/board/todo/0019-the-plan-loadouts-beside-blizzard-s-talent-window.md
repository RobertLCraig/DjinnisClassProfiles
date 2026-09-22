---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0011
---
# 0019 The plan's loadouts beside Blizzard's talent window

## Why

When Rob opens the talent window, the plan is in another window (`/bis`, Plan tab). The choice
should sit where the change is made.

Talent Loadout Manager puts a sidebar on Blizzard's talent window: a list of loadouts with Apply,
and Create, Import, Save and Config buttons (`SideBarMixin`, read 2026-09-22). Its ReduceTaint module
exists because attaching to that window can taint Blizzard's own loadout menu.

## Links

- Needs `0011`: the Apply button is its route.
- Uses `0007`'s boss table and `0009`'s content.
- Talent Loadout Manager may be installed too. Check; if it is, a second sidebar is clutter, and
  this card may be dropped for a line in TLM's list instead.

## Not this card

- Creating, importing or saving loadouts.
- Any change to Blizzard's own loadout dropdown.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN the talent window opens out of combat, THE ADDON SHALL show beside it the plan's loadouts for the current spec and content, each with the boss it is planned for. proves: manual
- [ ] EACH LOADOUT SHALL have an Apply button that loads it through `0011`'s route, and the active one SHALL be marked. proves: `sidebar marks the active loadout`
- [ ] WHEN the player is in combat, THE ADDON SHALL not build or change the sidebar. proves: `sidebar not changed in combat`
- [ ] THE SIDEBAR SHALL have a close button, and SHALL stay closed until the player opens it again. proves: `sidebar stays closed`
<!-- AC:END -->

## Tasks

- [ ] A plain frame anchored to `PlayerSpellsFrame`, parented to `UIParent`, not to the talent
  frame, to keep Blizzard's frame untouched. Check that anchoring alone does not taint.
- [ ] Read TLM's `ReduceTaint` module before starting.
- [ ] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" in a SecondBrain session. Ideation only.
  **Uncertain:** whether anchoring to `PlayerSpellsFrame` taints in 12.1.
