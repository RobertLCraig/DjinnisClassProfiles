---
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
- [ ] WHEN the character sheet is open AND a slot's equipped item does not match the plan for the current spec and chosen scenario, THE ADDON SHALL show a red glow on that slot button. proves: `slot state is change when item differs from plan`
- [ ] WHEN the equipped item matches the plan but lacks the planned enchant, THE ADDON SHALL show an amber glow and "enchant" on the slot. proves: `slot state is enchant when enchant differs`
- [ ] WHEN the equipped item matches but a socket is empty or holds a different gem, THE ADDON SHALL show an amber glow and "gem". proves: `slot state is gem when a socket differs`
- [ ] WHEN a marked slot is hovered, THE ADDON SHALL add a tooltip line naming the planned item and where it is (bags, bank, not owned). proves: `planned item location resolves to bags bank or missing`
- [ ] WHEN the plan has no entry for the current spec, THE ADDON SHALL mark nothing and say so once in the pane. proves: `no plan for spec marks no slots`
- [ ] WHEN the player enters combat, THE ADDON SHALL change no frame until combat ends.
<!-- AC:END -->

The last criterion has no offline test: it is checked in the client by Rob.

## Tasks

- [ ] Pure function: equipped link against plan entry gives one of `ok`, `change`, `enchant`, `gem`.
- [ ] Scenario picker (`st` / `2t`) in the pane, saved per spec.
- [ ] Glow on `PaperDollItemSlotButton`s, refreshed on `PLAYER_EQUIPMENT_CHANGED` and sheet show.
- [ ] Offline checks under the names above.

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
