---
not_for_the_loop: Rob, 2026-09-21: building DjinnisBiS by hand in a session on msiraider
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
needs: 0004
---
# 0005 Glow the slots on the character sheet that the plan would change

## Why

With the character sheet open, nothing tells Rob which of his sixteen slots are wrong. On
2026-09-21 he sent three screenshots in a row of the sheet as he fixed his Feral gear, and each
one still had a wrong slot he could not see: the old tier, then a ring with no enchant, then a
cloak and a trinket the sim had replaced. Each round trip went through a chat window.

What it costs: a wrong slot stays wrong until somebody else reads the sheet for him, and he raids
in it.

How it came to be: AskMrRobot marked the slots in the game and stopped working on Retail.
DjinnisBiS already draws a pane beside the sheet (card `0003`) but has never marked the slots
themselves.

## Links

- Needs `0004`: the plan table it compares against.
- Shares the character sheet with the `0003` stat pane; read that card's comments for the anchor
  traps (Chonky Character Sheet, `IsShown()` against `IsVisible()`).

## Not this card

- No bag glow (`0006`), no shopping list (`0007`), no equip button.
- No change to the `0003` stat pane.
- Inspect frame: not this card.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the character sheet is open AND a slot's equipped item does not match the plan for the current spec and chosen scenario, THE ADDON SHALL show a red glow on that slot button. proves: `slot state is change when item differs from plan`
- [x] WHEN the equipped item matches the plan but lacks the planned enchant, THE ADDON SHALL show an amber glow and "enchant" on the slot. proves: `slot state is enchant when enchant differs`
- [x] WHEN the equipped item matches but a socket is empty or holds a different gem, THE ADDON SHALL show an amber glow and "gem". proves: `slot state is gem when a socket differs`
- [x] WHEN a marked slot is hovered, THE ADDON SHALL add a tooltip line naming the planned item and where it is (bags, bank, not owned). proves: `planned item location resolves to bags bank or missing`
- [x] WHEN the plan has no entry for the current spec, THE ADDON SHALL mark nothing and say so once in the pane. proves: `no plan for spec marks no slots`
- [ ] WHEN the player enters combat, THE ADDON SHALL change no frame until combat ends.
<!-- AC:END -->

The last criterion has no offline test: it is checked in the client by Rob.

## Tasks

- [x] Pure function: equipped link against plan entry gives one of `ok`, `change`, `enchant`, `gem`.
- [x] Scenario picker (`st` / `2t`) in the pane, saved per spec.
- [x] Glow on `PaperDollItemSlotButton`s, refreshed on `PLAYER_EQUIPMENT_CHANGED` and sheet show.
- [x] Offline checks under the names above.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md`, card `0003`, and
`C:\Dev\WoWAddons\docs\DECISIONS.md` (secret values, event registration).

Check every API named here against `C:\Dev\WoWAddons\wow-ui-source\`, never from memory:
the slot buttons in `Blizzard_UIPanels_Game/Mainline/PaperDollFrame.lua`, `GetInventoryItemLink`,
and how an enchant id and gem ids sit in an item link (`C_Item` and the item link field order).
A socket count comes from the item, so an empty socket is "sockets > gems found".

Glow: prefer a Blizzard atlas or `ActionButton_ShowOverlayGlow`-style art already in the client over
bundled textures, as the combo point module in `DjinnisUIEnhancements` did (its card `0001`).

Rob uses Chonky Character Sheet and DjinnisCharacterFrame may be installed later. Both replace or
augment the slot buttons; test that the glow lands on whatever button is actually visible, and
record what was found.

Deploy: `C:\Dev\WoWAddons\bin\deploy.ps1 -WhatIf -Only DjinnisBiS`, then without `-WhatIf`.

## Comments

- 2026-09-21 Claude: card written from Rob's ask, "highlight / glow items to equip / change from
  bags / character frame". Nothing is built yet.
- 2026-09-21 Claude, by hand on msiraider: built at 0.14.0 and deployed. `lua offline-check.lua`
  passes, and two mutations (the enchant compare flipped, the ring order flipped) made it fail, so
  the checks bite. **The ticks prove the logic and no frame.** Nothing here has been in a client.
  What was found, as the Plan asked:
  - Chonky Character Sheet moves Blizzard's own slot buttons and draws none of its own
    (`ChonkyCharacterSheet/Modules/MOP.lua`), so the glow is anchored to the Blizzard button.
    DjinnisCharacterFrame was not checked, because it is not installed.
  - The glow is the client's own `bags-glow-white` atlas, tinted. No bundled texture.
  - Enchant and gems are read out of the item link. The field order is Blizzard's own, in
    `Blizzard_PTRFeedback/Blizzard_Reports.lua`. A gem field holds the gem's item id, as simc does.
  - The scenario button and the "no plan" line sit in a new strip UNDER the stat pane, because
    this card says not to change that pane.
  To look at in the client, with the sheet open on Feral:
  1. Wrong slots glow red. A right item with a wrong enchant or gem glows amber with a word on it.
  2. Hover a marked slot. The tooltip gains a gold "Plan:" line with bags, bank or not owned.
  3. Click "1 target". It reads "2 targets" and the strip says there is no plan for it.
  4. Change a piece in combat. Nothing moves until combat ends.
  Three known soft spots. `C_Item.GetItemNumSockets` is assumed to count filled sockets too. The
  bank is asked by item id only, so a lower-track copy reads as "bank". An EMPTY marked slot loses
  its Plan line when the sheet redraws the tooltip.
