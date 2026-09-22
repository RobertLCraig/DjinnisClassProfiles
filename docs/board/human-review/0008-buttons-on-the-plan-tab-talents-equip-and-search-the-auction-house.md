---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
needs: 0007
---
# 0008 Buttons on the Plan tab: talents, equip, and search the auction house

## Why

The Plan tab (`0007`) tells Rob what to do and then leaves him to do it by hand: open the talent
window and find the loadout, open the bags and find the right copy of seven items, open the
auction house and type each enchant and gem. Rob, 2026-09-22, on first seeing the tab: "planner
should have a button to change talents / gear / shop for gems and enchants on the AH".

What it costs: three windows and about a dozen finds and drags every time the plan changes, and a
wrong ring copy (the lower-track twin) when a drag picks the wrong one.

How it came to be: `0007` was scoped to say, not to do, because applying a loadout is fenced off.

## Links

**Blocked by**
- `0007` - the tab the buttons sit on.

## Not this card

- Loading a talent loadout from addon code. `C_ClassTalents.LoadConfig` and `CommitConfig` from an
  addon is the known route to action bars that freeze in combat (`0002`). The Talents button opens
  the talent window and Rob clicks the loadout.
- Buying anything. The button searches; Rob buys.
- Equipping from the bank.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the Search AH button is clicked for an enchant, THE ADDON SHALL search the auction house for the enchant's name without its rank. proves: `auction search term drops the enchant rank`
- [x] WHEN the Equip button is clicked in combat, THE ADDON SHALL do nothing. proves: `equip button does nothing in combat`
- [x] WHEN the planned piece is not in the bags, THE ADDON SHALL offer no Equip and equip nothing. proves: `equip button does nothing when the piece is not in the bags`
- [x] WHEN Search AH is clicked with the auction house closed, THE ADDON SHALL say to open it and search nothing. proves: `search button without the auction house open`
- [x] WHEN the Talents button is clicked, THE ADDON SHALL open the talent window and load no loadout. proves: manual
<!-- AC:END -->

## Tasks

- [x] A right-hand action button on Plan tab rows, sharing the BiS tabs' item level button.
- [x] Talents: `PlayerSpellsUtil.OpenToClassTalentsTab()`.
- [x] Equip: pick the exact bag copy up, `EquipCursorItem` into the planned slot. Equip all.
- [x] Search AH: the auction house's own search bar, `SetSearchText` then `StartSearch`.
- [x] The tab redraws on `PLAYER_EQUIPMENT_CHANGED`.

## Comments

- **2026-09-22** WRITTEN AFTER THE WORK. Rob asked for the buttons in chat from a screenshot of
  the tab; the card was written with the code. Attack the code, not the boxes.
- 2026-09-22 Claude: built at v0.17.0 and deployed. Offline check passes under Lua 5.4 and the
  game's 5.1. **No frame seen in a client.** What was applied, and where from:
  - Talents opens the window through `PlayerSpellsUtil.OpenToClassTalentsTab`
    (`Blizzard_FrameXMLUtil/Mainline/PlayerSpellsUtil.lua:31`). Loading the loadout itself is the
    fence above, and it is Rob's to lift; my answer is no, for `0002`'s reason.
  - Equip uses `C_Container.PickupContainerItem` then `EquipCursorItem(slotID)` rather than
    `C_Item.EquipItemByName`, because the plan matches item id AND item level and only the pickup
    names one exact bag slot. Both are `AllowedWhenUntainted` in the generated docs, not deprecated.
    A bind-on-equip piece will raise the game's own confirm box, which is right.
  - Search AH drives `AuctionHouseFrame.SearchBar` the way a typed search does
    (`Blizzard_AuctionHouseSearchBar.lua:194-207`). The house must be open; the addon is
    load-on-demand and the frame does not exist before then. An enchant is searched by name
    without its rank, so both ranks show.
  - The tab redraws itself on an equip by riding `0005`'s watcher, which already registers
    `PLAYER_EQUIPMENT_CHANGED`. No new event registration, so no new refusal to detect.
  - A gem the client has not cached yet gets no Search AH button, because the search term would
    be "item 240908". Reopening the tab after the cache fills fixes it.
