# 0095 A BiS list for every spec, from ClassCodex, keyed by item id

## Why

`BIS` at the top of `DjinnisClassProfiles.lua` is hand-written, druid only, and matched by item
NAME, so it only works on an English client. Card `0094` chose loot help on every class, and a
hand-written list for 40 specs cannot be kept current.

ClassCodex 1.5.0 ships each spec's gear list in `Data\db_icyveins.lua` and `Data\db_ugg.lua`
(`ClassCodexSource["icyveins"].data.<CLASS>.<spec>.gear`), by item id, for every class. ClassCodex
is MIT. `update-classcodex-data.ps1` already reads ClassCodex's files for the trinket tiers.

## Links

**Relates to**
- `0096` - the same script, widened for the other two ClassCodex blocks; do them in one sitting.
- `0084` - matching a planned item by stats when the id differs; an id-keyed list makes that card matter more.

## Not this card

- Opening `gearHere()` to other classes. That is `0098`.
- Deleting the hand-written druid list. Keep it until Rob has compared the generated druid rows
  against it once.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN `update-classcodex-data.ps1` runs, THE SCRIPT SHALL write a `GENERATED BIS LIST` block with an entry for every spec in `PlanTab.SPECS` that ClassCodex covers, each item carrying its id, slot and site. proves: `offline-check.lua` (a new check that every spec key in the block is a `PlanTab.SPECS` key)
- [ ] WHEN a spec has no ClassCodex gear list, THE SCRIPT SHALL name it in its output and not invent rows. proves: manual
- [ ] WHEN the addon matches a dropped item against the generated list, IT SHALL match by item id, so a non-English client gets the same answer. proves: `offline-check.lua` (a check that matches by id with the name changed)
<!-- AC:END -->

## Tasks

1. Read the `gear` shape in `db_icyveins.lua` and `db_ugg.lua` for two classes before writing the reader.
2. Extend the spec-key map in `update-classcodex-data.ps1` (line 83) to every class, keyed to `PlanTab.SPECS` names.
3. Write the new block between new BEGIN/END markers; the script refuses to write without them.
4. Make the lookup that reads `BIS[spec]` read the generated block by id for non-druid specs.
5. Run `lua offline-check.lua`, then `lua offline-check.lua 71` (Arms), and read the whole output.

## Comments

**2026-10-14** Raised from card `0094` (attended).
