---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0008
---
# 0010 A Blizzard equipment set for each plan

## Why

After Equip all (`0008`) puts the planned gear on, nothing remembers it. To go back to it after a
key, a transmog try or a tank night, Rob has to open `/bis`, find the Plan tab and press Equip all
again. Rob plays four specs and, with `0009`, two contents, so there are up to eight setups to go
between.

AskMrRobot's addon saves a Blizzard Equipment Manager set, named after the setup, every time it
equips one (`Gear.lua`, `createAmrEquipmentSet`, read 2026-09-22; see the SecondBrain output
"2026-09-22 What DjinnisBiS can learn from AskMrRobot"). Blizzard then does three jobs for free:

- the item tooltip says "Equipment Sets: DBiS Feral Raid ST", so a bag item shows which plan wants it
- the character sheet's own equipment set list swaps the whole set in one click, and `/equipset`
  does it from a macro, with no `/bis` window
- bag addons that know about equipment sets can mark those items. Whether Baganator does needs
  checking; do not assume it

What it costs: a set can be saved only from what is worn (`C_EquipmentSet.CreateEquipmentSet` and
`SaveEquipmentSet` read the worn gear). So the set is saved right after a full Equip all works,
never before.

## Links

- Needs `0008`: its Equip all is the moment to save.
- Helps `0009`: a raid set and a Mythic+ set can share one item, and Blizzard already handles that.
- Helps a later junk list: "in no equipment set" is one of its tests.

## Not this card

- Swapping sets by itself on a spec change or on zone-in. That is a later card if Rob wants it.
- Deleting sets Rob made himself. The addon touches only sets whose name starts "DBiS ".

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN Equip all finishes with every planned slot worn, THE ADDON SHALL save a Blizzard equipment set named "DBiS <spec> <content> <scenario>", creating it or updating the one with that name. proves: `equip all saves the plan as an equipment set`
- [ ] WHEN Equip all finishes with a planned slot not worn, THE ADDON SHALL save no set and say which slot is missing. proves: `no set is saved from a half-worn plan`
- [ ] WHEN a set is saved, THE ADDON SHALL leave the shirt and tabard slots out of it. proves: `the set ignores shirt and tabard`
- [ ] THE ADDON SHALL never change or delete an equipment set whose name does not start "DBiS ". proves: `sets Rob made are never touched`
- [ ] WHEN the player is in combat, THE ADDON SHALL save no set. proves: `no set is saved in combat`
<!-- AC:END -->

## Tasks

- [ ] Check `C_EquipmentSet` in `C:\Dev\WoWAddons\wow-ui-source` at 12.1: create, save, ignore
  slot, and whether any of them has restrictions.
- [ ] Save after a full Equip all. One chat line: "Saved as equipment set DBiS Feral Raid ST".
- [ ] Find out whether Baganator marks equipment set items, and whether that doubles up with the
  green bag glow from `0006`. If it does, say so on this card; do not change `0006` here.
- [ ] Offline checks under the names above.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md`, then the Equip all code from
`0008`. AMR's pattern, for reference only: `ClearIgnoredSlotsForSave`, `IgnoreSlotForSave(INVSLOT_BODY)`
and `(INVSLOT_TABARD)`, then `GetEquipmentSetID(name)`, then `SaveEquipmentSet(id, icon)` or
`CreateEquipmentSet(name, icon)`. Use the spec icon from `GetSpecializationInfo`.

## Comments

- 2026-09-22 Claude: written from Rob's "A" to the AskMrRobot ideas, in a SecondBrain session.
  Ideation only. Nothing is built.
