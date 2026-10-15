---
---
# 0105 A planned item is shown at the level of the piece it replaces

## Why

Rob, 2026-10-15, after the gear plan was rebuilt from a local droptimiser: "Would be good too, if
we could show what items we are trying to aim for (at the same ilvl as the gear we are trying to
replace. (if the default is lower))".

The Plan tab's "slots to change" rows already name each target item, and pointing at one shows its
tooltip. That tooltip came from `C_Item.GetItemInfo(id)`, so it showed the item at its default
level. A default below the worn piece makes an upgrade look like a downgrade.

## What changed

- `TRACKS` carries each rank's track bonus id (Champion 12833-12838, Hero 12841-12846, Myth
  12849-12854), from KeystoneLoot's `upgrade_tracks.lua` for 12.1.5.
- `PlanTab.aimLink(link, wornIlvl)`: when the link's own level is below the worn piece, it returns
  the link with one track bonus id, at the lowest track rank at or above the worn level. Otherwise
  the link is unchanged.
- The Plan tab's slot rows use it, so the tooltip, the icon and a shift-click all carry that level.
- `PlanTab.aimChecks`: six checks in the self-test.

## Acceptance

- [ ] In game, a Plan tab row for a slot whose target's default level is below the worn piece shows
      the target at the worn level (or the next track rank up) when pointed at.
- [ ] A target whose default is at or above the worn level shows as before.

## Known trade-offs

- Only the Plan tab rows. The slot tooltip on the character sheet and the loot roll stay text and
  glow; neither shows a target's tooltip.
- A link with no level field is built from scratch; the game's reading of a bare track bonus id is
  untested in a live client.
