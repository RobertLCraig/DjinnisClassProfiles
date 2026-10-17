---
not_for_the_loop: Rob, 2026-09-21: building DjinnisBiS by hand in a session on msiraider
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
needs: 0004
---
# 0006 Glow the bag items the plan wants equipped

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

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
- [ ] On Feral with a planned piece in the bags and not worn, open Baganator: that piece glows green; a lower copy of the same item does not. Nothing glows: check Baganator's Icon Corners lists "Djinni's Class Profiles: gear plan". proves: manual
- [ ] Hover the glowing piece: the tooltip gains a "Plan: equip in <slot>, 1 target" line (the last words follow the plan's content choice). proves: manual
- [ ] Equip it: its glow goes. proves: manual
- [ ] WHEN the player is in combat, THE ADDON SHALL not rescan the bags until combat ends. Look: hit a dummy with Baganator open and swap a weapon: no glow changes until combat ends, then they catch up. Right-click a potion or food in combat: it is used, no "action blocked". proves: manual
- [ ] Disable Baganator, `/reload`: the default bags, combined and separate, show the same glow, and an item used from them in combat works with no "action blocked". No Lua error through any of this. proves: manual
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

**2026-10-11** Clear-down (attended, Rob asked): ticked nothing new; the four `proves:` checks (`bag item is wanted when it matches an unfilled plan slot`, `only the planned copy of a duplicate is wanted`, `equipped planned item glows no bag copy`, `wanted bag item names its slot and scenario`) were already ticked and still exist and pass in the Lua 5.1 offline check. Looks rewritten for v0.69.0: the Baganator corner widget is now "Djinni's Class Profiles: gear plan"; the five looks are `proves: manual` criteria, the combat one carrying the original combat criterion. Moves to ai-review/ with only in-game looks open.

### 2026-10-17 review (v20261017163218-c515)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I could not break any of the four ticked criteria. The other five are manual checks for you to do in the game.

**What I checked, all in `DjinnisClassProfiles.lua`:**

- **#1, a bag item glows when the plan wants it in a slot.**
  - `wantedFrom` keeps only the slots where the plan wants a "change".
  - `wantedSlotForLink` checks each bag item against that list.
  - `buildBagGlows` adds the glow. It uses Baganator's corner widget when Baganator is loaded, and Blizzard's own bag buttons when it is not.
  - The offline check `bag item is wanted when it matches an unfilled plan slot` covers this.
- **#2, only the planned copy glows.**
  - `wantedSlot` uses `planMatches`, which compares item id and item level.
  - A lower copy, a higher copy and a copy with no item level yet all return nil. The check tests all three.
- **#3, a worn planned item makes no bag copy glow.**
  - `slotStates` leaves a worn planned piece out of the "change" list.
  - The check `equipped planned item glows no bag copy` covers this.
- **#4, the tooltip names the slot and the scenario.**
  - `addBagLine` adds a line made by `wantedLine`. The text is "Plan: equip in <slot>, <scenario>".
  - The check tests it, and it also checks that every plan slot has a label.

**Combat (part of #8):** `rebuildBagWanted` and the default-bag refresh both stop at once in combat (`InCombatLockdown()`). `armBagMarks` rebuilds the list on `PLAYER_REGEN_ENABLED`, which fires when combat ends. Nothing I read stops #8 passing.

**What you do now:** nothing for this review. Try the five manual looks in the game when you can.

VERDICT: sound

**scope: sound**

**What I did:** I checked the card's code only for scope (work the card did not ask for, or work left half done). I read the bag glow code in `DjinnisClassProfiles.lua`, in the Baganator part and in the default-bag part (the `refreshBagGlows` closure).

**What I found:**

- **Baganator:** The code uses only `RegisterCornerWidget`. That is the hook the card's Plan told it to prefer. It does not use the upgrade plugin or the item set source.
- **Default bags:** The fallback reads only `ContainerFrameCombinedBags` and `ContainerFrameContainer.ContainerFrames`. These are the normal bags, not the bank.
- **Fence:** The glow code does not touch the bank, the warband bank, Bagnon, AdiBags, ElvUI bags or EnhanceQoL Bags. It adds no character sheet, shopping list or equip button.
- **Combat:** The rebuild stops in combat, because it checks `InCombatLockdown()`, as the card asks.
- **Big diff:** The diff has 162 files. That is the rename to DjinnisClassProfiles and the history of many other cards. This card did not grow that work. Other `bank` and `EnhanceQoL` hits in the file belong to other features, not to the glow.
- **Half done:** I found nothing. Only the `proves: manual` checks are open, and those wait for Rob in the game.

I disproved no criterion.

**What you do now:** Nothing. Plan mode was on, so I edited nothing.

VERDICT: sound

**breakage: sound**

I checked the bag glow code to see if it breaks anything. I found no break.

- **Same match rule (#1 - #3).** `wantedFrom` and `wantedSlot` in `DjinnisClassProfiles.lua` use `planMatches`. Card `0005` uses that same rule (item id and item level). So only the planned copy glows. A planned piece that you already wear makes no "change" slot, so no bag copy glows.
- **Tooltip line (#4).** `addBagLine` uses `wantedLine`. The offline check tests this with "Plan: equip in Back, 1 target". The manual look expects the same text.
- **Rename.** `buildBagGlows` now shows the widget name "Djinni's Class Profiles: gear plan". The card looks use the same name. The widget id is still `djinnisbis_plan`. Baganator stores your corner choice by id, so the rename keeps it.
- **Default bags.** I checked `ContainerFrame_GenerateFrame`, `ContainerFrame_UpdateAll` and `EnumerateValidItems` in `wow-ui-source` (`Blizzard_UIPanels_Game\Mainline\ContainerFrame.lua`). All three are there, so the hooks attach.
- **Combat.** `rebuildBagWanted` and the default-bag `refreshBagGlows` both stop when `InCombatLockdown()` is true. `PLAYER_REGEN_ENABLED` rebuilds the list after combat.

All open criteria are `proves: manual`. You check them in the game.

What you do now: the card goes to `done/`. Do the five looks in the game when you can.

VERDICT: sound

