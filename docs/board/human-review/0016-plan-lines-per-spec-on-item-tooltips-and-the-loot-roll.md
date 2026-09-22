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

- 2026-09-22 Claude (review): adversarial pass on `b2cc37a`, in a worktree, nothing run in a
  client. Two findings, both fixed in place in `DjinnisBiS.lua`; the card goes to human-review
  because the manual criterion still needs a person.

  **Attacked and held.** All three `proves:` names ran under Lua 5.4 and 5.1, exit 0 both. Three
  mutants in temp copies, all red with exit 1: `return nil` for an unplanned id (turns "from a
  link" red), `local into = later` (three ordering checks red), and the early return put back
  in `markRollFrame` (the new "old glow is hidden" check red). Checked against
  `wow-ui-source`: `GroupLootFrame_OnShow` is the template's `OnShow` global and its early
  `GroupLootContainer_RemoveFrame` path still runs the post-hook, which now hides the glow;
  the roll icon's `OnEnter` calls `GameTooltip:SetLootRollItem`, which
  `TooltipDataHandler.lua:538` maps to `C_TooltipInfo.GetLootRollItem`, an item tooltip, so the
  post-call fires; `C_Item.GetItemCount(itemInfo, includeBank, includeUses,
  includeReagentBank, includeAccountBank)` matches the call's `(id, true, false, true, true)`.
  `GetLootRollItemLink` is not in the generated docs; it is the legacy global Blizzard's own
  icon `OnClick` uses. Secret values: the link, the tooltip's id, the roll id and the count
  all pass `canRead` before any match, key or compare, and nothing keys a table on a
  game-supplied string; the only table keyed on a game object is `ROLL_GLOWS[frame]`. Stale
  index: `GEAR_PLAN` is never written at runtime, so a cache built once is right until
  `/reload`, which is also the only way the client sees what `update-gear-plan.ps1` wrote; the
  self-test's temporary `2t` swap calls `buildPlanIndex()` directly, not the cache. Taint: the
  hook reads `frame.rollID` and adds a texture region to `IconFrame`; no field is written on
  Blizzard's frame and no roll button is touched.

  **Broke, fixed.** (1) The self-test read the real character. Four checks called the live
  `GetInventoryItemLink`, `C_Item.GetItemCount` and `C_Item.GetDetailedItemLevelInfo`, so
  `/bis test` in a client goes red for anyone who owns the planned head, and for everyone if a
  bare `item:271528` link levels below the planned 321. Proved in a temp copy by stubbing the
  three to owned and 300: four FAIL lines. The block now stubs all three for its whole length
  and restores them; the same copy is green with the fix. (2) `markRollFrame` returned early
  on a missing or unreadable roll id without hiding the glow it already held, so a pooled
  frame's next roll could keep the last roll's glow. The show is now computed as false on that
  path and the one `SetShown` always runs; one check added under the third `proves:` name.

  **Security.** Weakest point: the tooltip post-call runs on every item tooltip redraw with
  values the game supplied, and a throw there is a throw inside Blizzard's tooltip code; the
  `canRead` guards on the link and the id are what stand between a secret and that. Unchecked
  paths: none found; the chat line concatenates the link only after `canRead`. Leaks: nothing
  leaves the client; the PLAN line is a local `print`, not a sent message.

  Not a finding, for the look: a worn planned piece on the character sheet now carries the
  slot mark's gold line and this card's green line, two lines saying nearly the same thing.
  Decide whether that is fine after seeing it.

## What I need from you

Nothing here ran in a client. The five looks in the build comment stand, and two are sharper
after this review:

1. `/bis test` in the client, wearing or holding the planned Feral head (Enigmatic
   Dreamwatcher's Somnolent Stare, 271528): the 0016 checks must still pass. Before the fix
   they could not.
2. Two group loot rolls close together, the first for a planned item and the second for an
   unplanned one landing on the same roll frame: the glow must go out on the second. Then a
   third roll on a frame whose item info is not yet cached (the frame flickers and vanishes):
   no glow left behind and no error.
3. Looks 1 to 4 from the build comment: the green line on any planned item's tooltip with
   ", owned" and "at 321" behaving as written, the glow and the spec lines on the roll icon's
   tooltip, the "[BiS] PLAN" chat line, and Need, Greed and Pass clicking with no taint error.
4. The character sheet's worn head: say whether the gold slot line plus the green plan line
   together read as one answer or as a duplicate.
