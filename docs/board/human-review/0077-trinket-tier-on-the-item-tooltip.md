# Trinket tier on the item tooltip

## Why
Rob, 2026-09-30: ClassCodex put a trinket's tier on its tooltip. With ClassCodex off, that line is
gone. Card `0002` brought the tiers into this addon, but only into the window (By Slot tab and the
ranked list), not onto the tooltip where a loot roll or a bag is read.

## What was built (v0.57.0)
`PlanTab.tierLine(spec, id, name)` gives one line, `Trinket tier: Feral S  Guardian A/S ...`: every
druid spec that rates the trinket, your own spec first. `u.gg/Icy Veins` when they disagree, as in
the window. The item tooltip hook adds it on a druid (`gearHere`). It stands aside when ClassCodex is
loaded, through `tiersFor`, so the line is not doubled.

Checks in `selfTest`: your spec comes first, an unrated trinket adds nothing. Broken on purpose once
(spec-first removed) and the check failed.

The tiers are still the 2026-09-02 ClassCodex read. To refresh, see the HANDOVER (`update-classcodex-data.ps1`).

## Acceptance
<!-- AC:BEGIN -->
- [x] #1 WHEN a druid hovers a rated trinket, IT SHALL add one tier line, own spec first. proves: `selfTest` tier line checks
- [x] #2 WHEN the trinket is unrated, IT SHALL add nothing. proves: `selfTest`
- [ ] #3 WHEN Rob hovers Voracious Heart of Ula'tek in the game, the tooltip SHALL show the line. proves: none
<!-- AC:END -->

## Comments
