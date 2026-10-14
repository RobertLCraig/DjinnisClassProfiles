# 0096 Trinket tiers and stat targets for every spec

## Why

`update-classcodex-data.ps1` reads only the DRUID section of ClassCodex's files: "Druid only,
because this addon is druid only" (its line 83, and the `$inDruid` filters at lines 120 and 185).
So `TRINKET_TIER` and `STAT_TARGET` hold four specs. Card `0094` chose loot help on every class.

## Links

**Relates to**
- `0095` - same script, same source files.

## Not this card

- Any change to how the tiers or targets are shown. Only the data widens.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN the script runs, `TRINKET_TIER` and `STAT_TARGET` SHALL hold every spec ClassCodex covers, keyed by `PlanTab.SPECS` names. proves: `offline-check.lua` (a check that every key is a `PlanTab.SPECS` key)
- [ ] WHEN the addon loads, THE MAIN CHUNK SHALL still load under Lua 5.1 (the 200-local ceiling). proves: `offline-check.lua`
<!-- AC:END -->

## Tasks

1. Replace the `$inDruid` filters with the spec-key map from `0095`.
2. Run the script, then `lua offline-check.lua` and `lua offline-check.lua 262` (Elemental).
3. Note the size change of `DjinnisClassProfiles.lua` on this card.

## Comments

**2026-10-14** Raised from card `0094` (attended).
