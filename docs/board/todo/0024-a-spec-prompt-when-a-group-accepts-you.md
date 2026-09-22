---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0009, 0011, 0012
---
# 0024 A spec prompt when a group accepts you

## Why

Rob tanks, heals and deals damage. When a group finder listing accepts him as a healer for a key,
he has to change spec, loadout and gear by hand before the group is ready. KeystoneLoot and
Keystone Polaris both show a "group joined" popup (on `LFG_LIST_APPLICATION_STATUS_UPDATED`) with
the dungeon and the role; neither changes the setup.

## Links

- Needs `0009` (the Mythic+ plan), `0011` (load the loadout), `0012` (the equipment set).
- Shares its window with `0013` if both would show.
- Draws by `0020`'s rules.

## Not this card

- Changing anything without a click.
- Raid invites. Group finder acceptance only.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN a group finder application is accepted and the role given needs another spec than the current one, THE ADDON SHALL show a prompt naming the role, the place and the planned spec. proves: `prompt names role, place and spec on acceptance`
- [ ] THE PROMPT SHALL have one button that changes spec, then loads the planned loadout, then equips the planned set, out of combat only. proves: manual
- [ ] WHEN the current spec already fits the role, THE PROMPT SHALL offer only the loadout and gear parts that differ, or not show at all. proves: `no prompt when spec, loadout and gear already fit`
<!-- AC:END -->

## Tasks

- [ ] **Test first, by hand, in the game:** can an addon change spec? Try
  `/run ClassTalentHelper.SwitchToSpecializationByName("Restoration")` out of combat, the same route
  as `0011`. If it taints, the prompt opens the spec tab instead.
- [ ] Role and place from `C_LFGList.GetApplicationInfo` and the listing. Check the names in `wow-ui-source`.
- [ ] The three steps wait for each other: spec change finishes, then loadout, then gear.
- [ ] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "B" in a SecondBrain session. Ideation only.
