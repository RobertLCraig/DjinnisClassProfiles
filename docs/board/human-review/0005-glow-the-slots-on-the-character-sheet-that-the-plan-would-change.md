---
not_for_the_loop: Rob, 2026-09-21: building DjinnisBiS by hand in a session on msiraider
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
needs: 0004
---
# 0005 Glow the slots on the character sheet that the plan would change

## What I need from you

**Four looks in the game, on Feral, with the character sheet open.** `/reload` first.

1. Look at the slots. Wrong items glow red. A right item with a wrong enchant or gem glows amber
   and has the word "enchant" or "gem" on it.
2. Hover a glowing slot. The tooltip gains a gold "Plan:" line ending in "in your bags", "in the
   bank" or "not owned".
3. Click "1 target" in the strip under the stat pane. The button reads "2 targets" and the strip
   says there is no gear plan for it. Click again to go back.
4. Hit a training dummy, then swap a weapon and hover a glowing slot. No glow moves and no "Plan:"
   line shows until combat ends. Then the glows catch up.

**Pass** is all of:
- all four steps look as written
- no Lua error, with `/console scriptErrors 1` on
- slots still click, drag and equip as before

**Fail** is anything else. Say which step and what you saw in `## Comments`, with a screenshot if
you can, and the card goes back to `todo/`.

**Why it needs you.** The glows and the tooltip only exist in a running game, and no agent can
run one. The offline checks prove the logic behind steps 1 to 3 and prove no frame. Step 4 has no
offline check at all.

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
- [ ] WHEN the player enters combat, THE ADDON SHALL change no frame until combat ends. proves: manual
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
- 2026-09-21 Claude, adversarial pass. I did not build this. Three fixes, one commit, `1585109`.
  **Attacked the acceptance.** Twelve mutations of the guarded logic, each in a temp copy, never in
  the real file. All five named checks go red when their logic is broken: item compare, bare slot,
  enchant compare, "the plan wants none", empty socket, wrong gem, bank, bags, the no-plan guard,
  the ring order, and the link field order.
  **One check could not fail, fixed.** "same gems in another order" stayed green with one of
  `sameGems`' two sorts removed, because its planned list was already in order. Both lists are
  unordered now, and removing either sort fails it.
  **One path broke the combat criterion, fixed.** `refresh` holds the glows still in combat, but
  the tooltip "Plan:" line was still added in combat, from marks that can be stale, with a bag scan
  on every tooltip redraw. `addPlanLine` and the empty-slot `OnEnter` hook now do nothing in combat.
  The scenario click, the sheet's `OnShow` and `glowFor` all go through `refresh`, which returns
  first thing in combat, so no frame of this card's is made or changed there. The criterion had no
  `proves:` and now says `proves: manual`.
  **Checked against `wow-ui-source`, and held.**
  - `C_Item.GetItemNumSockets` counts filled sockets too. Blizzard's only caller,
    `PaperDollItemSocketDisplayMixin:SetItem`, shows a socket for each index up to the count and
    draws the gem inside it. That soft spot is closed.
  - `C_Item.GetItemCount` is `(item, bank, uses, reagent bank, account bank)`, which is the order
    used, and its count is not nilable.
  - `bags-glow-white` is a real atlas (`ContainerFrame.lua:1702`).
  - The slot buttons are not protected, and nothing is written onto them: the glows sit in our own
    table keyed by button, and the hook is `HookScript`. Taint risk is low.
  - No item, link or bag API here is documented as returning a secret, and `C_Secrets` has no item
    predicate. The `canRead` guard on the link is extra. Item level and socket count are compared
    unguarded, which is right for today's documentation.
  - A missing colour, a missing label, a nil `entry.ilvl` in the format, and `owner:GetID()` on a
    stranger's frame cannot happen: all three states have a colour, all 15 plan lines carry
    `ilevel`, and the owner is only used if it is a button we made a glow for.
  - A bare finger scores zero either way round and marks red. An off hand worn against a planned
    two-hander is not marked itself; the main hand is, and fixing that empties the off hand.
  - Events: handler first, one at a time, each checked with `IsEventRegistered`.
  **Left, none of them blocking.**
  - If a worn link ever came back secret, `refresh` returns after the scenario button's text has
    changed, so the button and the glows can disagree until the next event. Not reachable on
    today's API.
  - An item level the client has not cached reads as a wrong item, so a slot can flash red on the
    first open after login. The next refresh clears it.
  - The bag scan reads an item level for every bag slot on each tooltip redraw. Hover only.
  **Security.** 1. Weakest: the saved scenario, which is the one value here that comes off disk.
  It was trusted as read, and anything but `st` or `2t` reached `string.format` as nil and threw
  on every sheet open. Fixed: `planScenario` falls back to `st`, with three checks, and removing
  the guard fails one. 2. Unchecked: the only input is the player's own item links and a baked-in table. No chat, no
  addon message, no other player's data reaches this code. 3. Leaks: nothing. It prints one line
  if an event is refused and it sends nothing anywhere.
  **No client.** There is no browser surface, and the UI exists only in a running game that no
  agent can run. I have not seen a single frame of this. `lua offline-check.lua` passes and the fix
  is deployed at 0.14.0. The four looks at the top of the card are Rob's, so this goes to
  `human-review/` and not `done/`.
