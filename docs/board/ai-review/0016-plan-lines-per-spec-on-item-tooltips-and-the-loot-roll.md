---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0009
---
# 0016 Plan lines per spec on item tooltips and the loot roll

## Why

The addon's first goal is "when an item drops, say which druid specs want it, without the player
leaving the loot roll" (`docs/HANDOVER.md`, Goal). The BiS tabs answer that in the `/bis` window.
The gear plan (`0004`, `0009`) is a better answer, and it is not on the item.

Pawn puts one line per scale on the tooltip ("Feral: ↑ +3% upgrade") and a badge on the loot roll
frame (`PawnUI`, `GroupLootFrame` hooks, read 2026-09-22). KeystoneLoot adds "Favorite" and "In your
bags/bank" lines.

## Links

- Needs `0009`: the raid and Mythic+ plans for each spec.
- The addon's tooltip hook already exists (`TooltipDataProcessor`); add lines there, not a second hook.

## Not this card

- A % upgrade. That needs sim data per item per spec. This card says yes or no only.
- Pawn's scales or weights.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN an item's tooltip shows and the item is in a druid spec's plan, THE ADDON SHALL add one line per spec and content that plans it, for example "Feral raid: in plan", current spec first. proves: `tooltip lists each plan that has the item`
- [x] WHEN the item is planned and already owned, THE LINE SHALL say "owned". proves: `tooltip says a planned item is owned`
- [ ] WHEN a loot roll starts for an item in any druid plan, THE ADDON SHALL mark the roll frame and name the specs in its tooltip. proves: manual
- [x] WHEN the item is in no plan, THE ADDON SHALL add no plan line. proves: `no plan line for an unplanned item`
<!-- AC:END -->

## Tasks

- [x] Plan lookup by item id, all specs and contents, built once when the plan loads.
- [x] Loot roll: `START_LOOT_ROLL` and the roll frame's item link. Check in `wow-ui-source` how
  12.1 draws the group loot frame before hooking it.
- [x] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" in a SecondBrain session. Ideation only.
- 2026-09-22 Claude: built, in a worktree, in `DjinnisBiS.lua` only. No new top-level local; the
  index, the lines, the ownership read and the roll mark sit on `PlanTab`. What `0021` already
  covers and what this adds: KeystoneLoot marks only the items the plan sent it, says "Favorite"
  with no spec or content, and does nothing when KeystoneLoot is not loaded. This card's line
  names the spec and the content ("Feral raid: in plan", "Guardian Mythic+: in plan, owned") from
  the addon's own plan, so it stands with no other addon. Both can show on one tooltip; that is
  two addons agreeing, not a duplicate.

  `PlanTab.buildPlanIndex()` is pure: every filled cell of every spec into `{ [itemId] = { {
  spec, content, ilvl } } }`, one row per spec and content, with the two raid cells collapsed to
  one "raid" row at the higher planned level. `PlanTab.planIndex()` builds it once, because the
  plan is baked into the file. `PlanTab.planLines(index, id, current, owned, ilvl)` is pure and
  gives the current spec's lines first, then spec order. The match is by item id alone, not id
  and level as the slot marks use, because a roll cannot choose the track; when the hovered
  copy's level is below the planned one the line says "in plan at 723" so a Champion copy is not
  read as the piece. `PlanTab.planOwned(id)` reads the worn slots first (`C_Item.GetItemCount`
  does not count what is worn), then `GetItemCount` with bank, reagent bank and account bank on.
  Every game-supplied value (the link, the tooltip's id, the roll id, the count) goes through
  `canRead` before it is matched, keyed or compared; the existing `START_LOOT_ROLL` handler
  gained the same guard on its link, which it did not have.

  The tooltip lines ride the one existing `TooltipDataProcessor.AddTooltipPostCall` after the
  bag line, green, no second hook. The loot roll: `GroupLootFrame_OnShow` is the global the
  template's `OnShow` calls (`Blizzard_UIPanels_Game/Mainline/GroupLootFrame.lua`, read
  2026-09-22), and `hooksecurefunc` on it runs `PlanTab.markRollFrame(frame)` after Blizzard has
  read the item: a green glow (`newBagGlow`, the bag marks' own) over `frame.IconFrame`, kept in
  `PlanTab.ROLL_GLOWS[frame]` and never in a field on Blizzard's frame, no button touched. The
  roll icon's tooltip is `GameTooltip:SetLootRollItem`, an item tooltip, so the spec lines land
  there through the same hook with no code of their own. One chat line too, "[BiS] PLAN <link>
  -> Feral raid; Guardian Mythic+", beside the BiS list's existing ROLL / pass line.

  23 checks in `selfTest` under the three `proves:` names. `lua offline-check.lua` (5.4) and the
  5.1 build both exit 0. Mutation-tested in a temp copy, two mutants, both red with exit 1:
  `local into = later` (drop current-spec-first) turns three ordering checks red; `if false
  then return true end` in `planOwned` (stop counting worn gear) turns "worn counts as owned"
  and "the hovered line says so" red.

  What a person must look at in the game (nothing here was run in a client):
  1. Hover the planned Feral head piece anywhere (bag, bank, Encounter Journal, a chat link):
     one green line "Feral raid: in plan" under the BiS and stat lines, ", owned" when it is
     worn or in a bag or bank. Hover an unplanned piece: no such line.
  2. As Guardian, hover an item both specs plan: Guardian's line first.
  3. Hover a Champion-track copy of a Myth plan piece: "in plan at <planned level>".
  4. A group loot roll for a planned item: a green glow over the item icon on the roll frame,
     the spec lines in the icon's tooltip, and the "[BiS] PLAN" chat line. Need, Greed and Pass
     still click with no taint error. A roll for an unplanned item: no glow, no line.
  5. Two rolls at once, one planned, one not: only the planned one glows, and the glow does not
     linger on that frame's next, unplanned roll.

  Left out: a percentage upgrade and Pawn's weights, per "Not this card". No new event: the
  roll frame's own show is the trigger, and `START_LOOT_ROLL` was already registered. The
  "manual" criterion stays unticked until look 4.
