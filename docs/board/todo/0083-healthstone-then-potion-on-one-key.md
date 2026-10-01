---
needs: 0082
---
# 0083 Healthstone, then the healing potion, on one key

## Why

Rob, 2026-10-01: "Shift 2 should be healing potion on all classes and specs, shift s healthstone
(ideally I would like them on the same key, with healthstones being prioritised)".

Today the two heals are on two keys, Shift+S (Healthstone, item 5512) and Shift+2 (Potent Healing
Potion, item 258138). In a bad moment he has to choose a key, and the stone, which costs nothing,
should always go first.

A plain macro cannot do it. Two `/use` lines use both items in one press when both are ready, which
wastes the potion. `/castsequence reset=combat Healthstone, Potent Healing Potion` sticks on its
first step when there is no stone in the bags, so the potion never fires. Rob: "Your healthstone
macro doesnt account for not having one I think (Id still have to press the button twice when I
didnt have one)". A macro has no conditional for "I have this item".

## Links

- Depends on `0082`: the key plan that puts both items on bars (`docs/research/2026-10-01-keybind-layout.html`).
- `PlanTab.ITEM_JOBS` in `DjinnisClassProfiles.lua` knows Healthstone and Damage Potion, not the healing potion.

## Not this card

- Choosing which potion. The item is 258138 until Rob says otherwise.
- Any change to the keybind page.
- Moving bars or keys. The macro goes on the key Rob names; the addon does not place it.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN the bags hold a Healthstone, THE ADDON SHALL write the macro as a cast sequence of the stone then the potion. proves: `heal macro: stone then potion when a stone is in the bags`
- [ ] WHEN the bags hold no Healthstone, THE ADDON SHALL write the macro to use the potion alone. proves: `heal macro: potion alone with no stone`
- [ ] WHEN the bag contents change in combat, THE ADDON SHALL wait and rewrite the macro after combat ends. proves: `heal macro: no rewrite in combat, one after`
- [ ] WHEN `PlanTab.jobOf` reads item 258138, THE ADDON SHALL name its job "Healing Potion". proves: `a known item's job` (extend the existing check)
<!-- AC:END -->

## Tasks

- [ ] Add 258138 = "Healing Potion" to `PlanTab.ITEM_JOBS`, with a short label.
- [ ] One character macro, created if missing, rewritten on `BAG_UPDATE_DELAYED` and `PLAYER_REGEN_ENABLED` with `EditMacro` (present in 12.1: `Blizzard_MacroUI.lua:344`; protected in combat).
- [ ] The self-test checks named above, run by `lua offline-check.lua`.
- [ ] In-game look for Rob: with a stone, one press uses the stone and the next the potion; with none, one press drinks the potion.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisClassProfiles`. Read `docs/DECISIONS.md` on protected events and
secret values first: `BAG_UPDATE_DELAYED` must register (check it is not refused) and an item count
must be readable outside combat. Use `C_Item.GetItemCount` (see
`wow-ui-source/Interface/AddOns/Blizzard_APIDocumentationGenerated/ItemDocumentation.lua`). Run
`"C:\Program Files (x86)\Lua\5.1\lua.exe" offline-check.lua`; it ends with no FAIL lines.

## Comments

**2026-10-01, Claude.** Opened from Rob's two messages quoted in `## Why`, during card `0082`.
