---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0008
---
# 0012 A Blizzard equipment set for each plan

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
- [x] WHEN Equip all finishes with every planned slot worn, THE ADDON SHALL save a Blizzard equipment set named "DBiS <spec> <content> <scenario>", creating it or updating the one with that name. proves: `equip all saves the plan as an equipment set`
- [x] WHEN Equip all finishes with a planned slot not worn, THE ADDON SHALL save no set and say which slot is missing. proves: `no set is saved from a half-worn plan`
- [x] WHEN a set is saved, THE ADDON SHALL leave the shirt and tabard slots out of it. proves: `the set ignores shirt and tabard`
- [x] THE ADDON SHALL never change or delete an equipment set whose name does not start "DBiS ". proves: `sets Rob made are never touched`
- [x] WHEN the player is in combat, THE ADDON SHALL save no set. proves: `no set is saved in combat`
<!-- AC:END -->

## Tasks

- [x] Check `C_EquipmentSet` in `C:\Dev\WoWAddons\wow-ui-source` at 12.1: create, save, ignore
  slot, and whether any of them has restrictions.
- [x] Save after a full Equip all. One chat line: "Saved as equipment set DBiS Feral ST".
- [ ] Find out whether Baganator marks equipment set items, and whether that doubles up with the
  green bag glow from `0006`. If it does, say so on this card; do not change `0006` here.
- [x] Offline checks under the names above.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md`, then the Equip all code from
`0008`. AMR's pattern, for reference only: `ClearIgnoredSlotsForSave`, `IgnoreSlotForSave(INVSLOT_BODY)`
and `(INVSLOT_TABARD)`, then `GetEquipmentSetID(name)`, then `SaveEquipmentSet(id, icon)` or
`CreateEquipmentSet(name, icon)`. Use the spec icon from `GetSpecializationInfo`.

## Comments

- 2026-09-22 Claude: written from Rob's "A" to the AskMrRobot ideas, in a SecondBrain session.
  Ideation only. Nothing is built.
- 2026-09-22 Claude, reviewing `0010`: this card was `0010` too. Two sessions allocated the same
  number the same night, and the lower-rank card had three commits under it by the time it was
  seen, so this one, unbuilt and referenced nowhere by number, took the next free one.
- 2026-09-22 Claude, built in a worktree. Everything sits in the `PlanTab` table, no new
  top-level local. `PlanTab.saveSet(spec, scenario)` is the whole thing: out of combat, plan
  present, gear readable, every planned piece on (`PlanTab.missingSlots`, which counts a wrong
  item and not a wrong enchant or gem), then `ClearIgnoredSlotsForSave`, ignore 4 and 19, and
  `SaveEquipmentSet` into the set of that name or `CreateEquipmentSet` with the spec icon. It
  refuses when the manager answers our name with a set that is not ours, and when Rob already
  has Blizzard's ten. `C_EquipmentSet` was read from `EquipmentManagerDocumentation.lua`: no
  secret predicate, no protected call, and `CanUseEquipmentSets` exists and is asked. Equip all
  calls it two seconds after its last pickup, because a pickup is a server round trip and the
  slots read stale until it lands. A `Save set` button sits under the gear list whenever every
  planned piece is on, so a set can be saved when the timer read too early or when there was
  nothing to equip. One chat line either way.
  **The name is "DBiS Feral ST", not "DBiS Feral Raid ST".** Blizzard's own name box caps at
  16 letters (`SharedUIPanelTemplates.xml`, `IconSelectorEditBox letters="16"`) and "DBiS
  Guardian Raid 2T" is 21. If the server cut it, the name would never be found again and a
  new set would be created on every Equip all. ST and 2T are raid cells, so "Raid" is implied;
  Mythic+ is "M+". "DBiS Guardian 2T" is exactly 16. A check holds every spec and scenario to
  16. If Rob wants "Raid" spelt out, it is one table.
  Checks: 47 new, under the names on the card plus the name cap, the ten-set cap and the tab
  as drawn offering Save set. Both `lua offline-check.lua` and Lua 5.1 exit 0. Five mutations
  in a temp copy each went red on its own check: half-worn guard removed, combat guard removed,
  tabard ignore removed, ownsSet guard removed, "Raid " put back into the name.
  What a person must look at, none of it seen in a client: (1) press Equip all with a piece in
  the bags and read the chat line two seconds later; is it "Saved as equipment set DBiS Feral
  ST", and does the set appear in the character sheet's equipment manager with the Feral icon
  and shirt and tabard greyed out; (2) hover a planned item in the bag, does the tooltip say
  "Equipment Sets: DBiS Feral ST"; (3) press Equip all again, is the same set updated and not
  a second one made; (4) if the chat line says "not worn: Finger" after a real full equip, the
  two seconds were short, press Save set, and say so on this card; (5) the icon is passed as a
  fileID number where the API says cstring, as Blizzard's own popup does; if the set gets the
  default icon, that is why; (6) `ClearIgnoredSlotsForSave` clears the paper doll's ignore
  ticks too, so if Rob had a slot ticked ignore in the manager it is unticked after a save.
  Left out: the Baganator question, because its source lives only under `C:\Games`, which this
  build does not read. Nothing here changes `0006`. The Equip all timer path has no offline
  check: `C_Timer` is a frame-side thing the stub does not have.
