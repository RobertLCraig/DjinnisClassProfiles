---
not_for_the_loop: Rob, 2026-09-21: building DjinnisBiS by hand in a session on msiraider
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
needs: 0004
---
# 0006 Glow the bag items the plan wants equipped

## What I need from you

**Five looks in the game, on Feral, with a planned piece in your bags and not worn.** `/reload`
first, with `/console scriptErrors 1` on.

1. Open Baganator. The planned piece glows green. A lower copy of the same item does not.
2. Hover it. The tooltip gains a green "Plan: equip in <slot>, 1 target" line.
3. Equip it. The glow goes.
4. Hit a training dummy with Baganator open, and swap a weapon. No glow changes until combat
   ends. Then the glows catch up. Right-click a potion or food in the bag while in combat: it is
   used, with no "action blocked" message.
5. `/reload` with Baganator disabled. The default bags show the same glow, combined or separate.
   Use an item from them in combat, as in step 4.

**Pass** is all of:
- all five steps look as written
- no Lua error
- bag items still click, drag, equip and use as before

**Fail** is anything else. Say which step and what you saw in `## Comments`, with a screenshot if
you can, and the card goes back to `todo/`. If nothing glows at step 1, first check Baganator's
settings, Icon Corners: "Djinni's BiS: gear plan" should be listed top right.

**Why it needs you.** The glow only exists in a running game, and no agent can run one. The
offline checks prove which item is wanted and prove no frame. Step 4 has no offline check at all,
and whether drawing on Blizzard's bag buttons blocks item use can only be seen in combat.

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
- [x] WHEN the bags are open AND a bag item matches a planned slot that is not currently equipped with it, THE ADDON SHALL show a green glow on that bag slot. proves: `bag item is wanted when it matches an unfilled plan slot`
- [x] WHEN two copies of the planned item are in the bags, THE ADDON SHALL glow only the copy whose item level matches the plan. proves: `only the planned copy of a duplicate is wanted`
- [x] WHEN the planned item is already equipped, THE ADDON SHALL not glow any bag copy of it. proves: `equipped planned item glows no bag copy`
- [x] WHEN a glowing bag item is hovered, THE ADDON SHALL add a tooltip line naming the slot and the scenario it is planned for. proves: `wanted bag item names its slot and scenario`
- [ ] WHEN the player is in combat, THE ADDON SHALL not rescan the bags until combat ends. proves: manual
<!-- AC:END -->

The last criterion is checked in the client by Rob.

## Tasks

- [x] Scan bags with `C_Container` on `BAG_UPDATE_DELAYED` and bag open, out of combat.
- [x] Glow on the default container item buttons (combined and separate bags).
- [x] Offline checks under the names above.

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
- 2026-09-21 Claude, by hand on msiraider: built at 0.15.0 and deployed. `lua offline-check.lua`
  passes, and three mutations made it fail, so the checks bite. **The ticks prove the logic and no
  frame.** Nothing here has been in a client. What was chosen and why:
  - Baganator's `RegisterCornerWidget`, out of the three hooks the Plan names. The upgrade plugin
    allows one active plugin at a time, so taking it would switch off whatever Rob has there. An
    item set source gives a search word and no glow. The widget shows as "Djinni's BiS: gear plan"
    in Baganator's icon corner settings, top right by default.
  - The widget's frame is 1 pixel. The glow inside it is pinned to the whole item button, so it
    reads as a green glow and not as a corner icon. It is the client's `bags-glow-white` atlas.
  - Without Baganator the same glow goes on Blizzard's own buttons, combined or separate.
  - "Which copy" is `planMatches`, the rule card `0005` uses: item id and item level.
  - The wanted list is rebuilt out of combat only. In combat the last list stands.
  To look at in the client, on Feral, with a planned piece in the bags and not worn:
  1. Open Baganator. That piece glows green. A lower copy of the same item does not.
  2. Hover it. The tooltip gains a green "Plan: equip in <slot>, 1 target" line.
  3. Equip it. The glow goes.
  4. `/reload` with Baganator disabled. The default bags show the same glow.
  Known soft spot: if Rob has removed the widget from every corner in Baganator's settings,
  nothing glows, and nothing here says so.
- 2026-09-21 Claude, adversarial pass. I did not build this. One fix, commit `c51b6d8`, redeployed
  at 0.15.0. Passed to `human-review/` for the five looks above.
  - **The checks bite.** Ten mutations in a temp copy, never the real file. Wanting every marked
    slot, wanting none, ignoring what is worn, dropping item level from the match, matching on id
    alone, dropping the scenario from the line, a wrong label and a missing label each turned the
    named check red. None errored. One mutation passed: removing `ilvl ~= nil` from `planMatches`.
    It is equivalent, because a plan entry always has a level and `311 == nil` is already false.
    That is card `0004`'s function and I left it.
  - **Broke and fixed.** The default-bag path called `ContainerFrameUtil_EnumerateContainerFrames`
    at login. `ContainerFrame.lua:2088` builds its cached frame list on first use, so built from
    addon code the list is tainted for every secure caller after. Bag taint is how item use gets
    blocked in combat. The frames are now read off `ContainerFrameCombinedBags` and
    `ContainerFrameContainer.ContainerFrames`, which is read only. There are six container frames
    and none is a bank frame, so the bank stays out of this card.
  - **Taint, said honestly.** `CreateTexture` on Blizzard's button writes no field on it, and the
    glows are kept in a table of ours. `hooksecurefunc` runs after the secure call and its taint
    is dropped. A child frame would be no safer than the texture. I rate the rest low, not zero,
    and step 5 is the only real test. With Baganator loaded none of this path runs.
  - **`readWorn` held.** The secret-link path still returns before any mark moves, and the no-plan
    path still reaches `slotStates(nil, {})`. Card `0005` behaves as before.
  - **Baganator, read from its source.** `onUpdate` is only called for a slot with an item id, after
    the item is cached, and it is NOT wrapped in `pcall`, so an error of ours would break its
    buttons. Ours cannot error: nil link, secret link, pet and keystone links all return false.
    The holder is reparented to the button's `widgetContainer`, pointed at the corner, and shown
    or hidden by Baganator. The glow is the holder's child, so it hides with it, and it is
    anchored to the button it was made for, so pooling cannot leave it stale. Auto-insert runs
    once per id and is remembered, so a second login does nothing and a removed widget stays
    removed. The assert cannot fire on `/reload`. `RequestItemButtonsRefresh()` with no argument
    is valid, and we only call it out of combat.
  - **Combat held by reading.** Every rebuild and every default-bag pass is behind
    `InCombatLockdown()`. In combat Baganator still asks the widget, and the tooltip still asks,
    but both only match a link against the last list. Neither reads gear or bags.
  - **Left, all small.** Our widget is first in the top right corner, and Baganator shows one
    widget per corner, so on a wanted item it hides whatever else Rob keeps there. A button
    Baganator built before login would not get the widget until a settings change; none should
    exist that early. At a cold login worn item levels can read nil, so a bag twin of a worn
    planned piece could glow until the next gear change. `TooltipUtil` link matching at line 1088
    has no secret guard and is card `0003`'s code. The `{ ..., nil }` event table is fine under
    `ipairs`. APIs checked in `Blizzard_APIDocumentationGenerated`: `GetContainerItemLink`,
    `GetDetailedItemLevelInfo` and `GetItemNumSockets` carry no secret return flag.
  - **Security.** 1. Weakest: the un-`pcall`ed Baganator callback, where one Lua error of ours
    would blank his bag widgets. 2. Unchecked: `details.itemLink` and the tooltip link are outside
    input; both go through `canRead` and a pattern match before use. The saved scenario is
    validated by `planScenario`. 3. Leaks: nothing. No chat, no network, no saved data added; a
    failed event registration prints the event name only.
  - **No client.** There is no browser surface and no agent can run the game, so no frame here
    has been seen by anyone. That is a stated claim, and it is why this is not in `done/`.
