---
not_for_the_loop: Rob, 2026-09-21: building DjinnisBiS by hand in a session on msiraider
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
needs: 0004
---
# 0006 Glow the bag items the plan wants equipped

## Why

Rob carries more than 300 pieces of gear across his bags (his SimC export of 2026-09-21 lists
them), with several copies of the same item at different item levels. Finding the one the sim
picked means hovering bag slots one at a time. On 2026-09-21 he wore Pyrewalker's Mantle while
the Fireproof Drape the sim wanted sat in his bags.

What it costs: a planned upgrade that is already owned is skipped because it cannot be found
quickly, and the wrong copy of a duplicate item gets equipped.

How it came to be: nothing in the default bags knows about a plan. AskMrRobot did this and stopped
working on Retail.

## Links

- Needs `0004`: the plan table.
- Shares the "which copy is the planned one" rule with `0005`; use the same pure function.

## Not this card

- Character sheet (`0005`), shopping list (`0007`), equip button.
- Bank and warband bank windows: not this card.
- Bag addons other than Baganator (Bagnon, ElvUI bags, AdiBags): not this card.
- EnhanceQoLBags is also installed, but Rob uses Baganator (see Comments), so it is not this card.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN the bags are open AND a bag item matches a planned slot that is not currently equipped with it, THE ADDON SHALL show a green glow on that bag slot. proves: `bag item is wanted when it matches an unfilled plan slot`
- [ ] WHEN two copies of the planned item are in the bags, THE ADDON SHALL glow only the copy whose item level matches the plan. proves: `only the planned copy of a duplicate is wanted`
- [ ] WHEN the planned item is already equipped, THE ADDON SHALL not glow any bag copy of it. proves: `equipped planned item glows no bag copy`
- [ ] WHEN a glowing bag item is hovered, THE ADDON SHALL add a tooltip line naming the slot and the scenario it is planned for. proves: `wanted bag item names its slot and scenario`
- [ ] WHEN the player is in combat, THE ADDON SHALL not rescan the bags until combat ends.
<!-- AC:END -->

The last criterion is checked in the client by Rob.

## Tasks

- [ ] Scan bags with `C_Container` on `BAG_UPDATE_DELAYED` and bag open, out of combat.
- [ ] Glow on the default container item buttons (combined and separate bags).
- [ ] Offline checks under the names above.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md` and
`C:\Dev\WoWAddons\docs\DECISIONS.md`.

Check against `C:\Dev\WoWAddons\wow-ui-source\`: `C_Container.GetContainerItemLink`,
`C_Container.GetContainerNumSlots`, the container frame item buttons in `Blizzard_ContainerUI`, and
how the combined bag view enumerates its buttons.

**Rob's bags are Baganator** (installed in `C:\Games\World of Warcraft\_retail_\Interface\AddOns`,
2026-09-21), so the default bag buttons may never be on screen. Baganator has a public API in
`Baganator\API\Main.lua`, and three of its hooks fit this card better than drawing on its buttons:
`RegisterCornerWidget` (line 229, an icon in a corner of each item), `RegisterUpgradePlugin`
(line 129, feeds Baganator's own upgrade marker) and `RegisterItemSetSource` (line 265, lets the
plan appear as a named set). Read those before choosing, prefer one of them over hooking its
frames, and support the default bags as well when Baganator is not loaded. Baganator is not in
`C:\Dev\WoWAddons`; read it in the game folder and never edit it there.

Deploy: `C:\Dev\WoWAddons\bin\deploy.ps1 -WhatIf -Only DjinnisBiS`, then without `-WhatIf`.

## Comments

- 2026-09-21 Claude: card written from Rob's ask, "highlight / glow items to equip / change from
  bags". Nothing is built yet.
- 2026-09-21 Rob: **Decided:** Baganator is the bag he opens, not EnhanceQoL Bags. Build for
  Baganator first; the default bags are the fallback when it is not loaded.
