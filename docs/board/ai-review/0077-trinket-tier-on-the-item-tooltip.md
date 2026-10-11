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

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Acceptance
<!-- AC:BEGIN -->
- [x] #1 WHEN a druid hovers a rated trinket, IT SHALL add one tier line, own spec first. proves: `selfTest` tier line checks
- [x] #2 WHEN the trinket is unrated, IT SHALL add nothing. proves: `selfTest`
- [ ] #3 On a druid with ClassCodex off, after `/reload`, hover Voracious Heart of Ula'tek: the tooltip has one `Trinket tier:` line naming your own spec first. proves: manual
<!-- AC:END -->

## Comments

**2026-10-11** Clear-down (attended, Rob asked): ticked nothing new: #1 and #2 were already ticked, and their checks (`tooltip tier line, your spec first`, which uses this very trinket, id 270175, and `tooltip tier line, unrated says nothing`) exist and pass in the Lua 5.1 offline check. #3 said `proves: none`; it is a look, so it now says `proves: manual`, rewritten for v0.69.0. Moves to ai-review/ with only the in-game look open.
