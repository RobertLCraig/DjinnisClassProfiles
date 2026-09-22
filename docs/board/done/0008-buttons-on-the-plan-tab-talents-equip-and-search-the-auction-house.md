---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
needs: 0007
---
# 0008 Buttons on the Plan tab: talents, equip, and search the auction house

## What I need from you

**Six looks in the game, on your Feral druid, out of combat.** It is v0.17.1 and already deployed.
Have at least one planned piece sitting in your bags first, so step 2 has something to do.

1. Type `/reload`, then `/bis`, then click "Plan". The "1. Talents" line has a **Talents** button
   at its right end. Click it: the talent window opens on the class talents tab, and the loadout
   you had picked is still the one picked. Nothing is changed for you.
2. Under "2. Gear to change", a row whose item is in your bags ends "in your bags" and has an
   **Equip** button. Click it: that copy (not a lower-level twin) goes into that slot, and the row
   goes away on its own without you reopening the window. A bind-on-equip piece shows the game's
   own "bind it?" box first; say yes and the same happens.
3. With two or more in your bags, a grey line "N of these are in your bags" has **Equip all**.
   Click it: every one goes on, and each ring lands on the finger the row named for it.
4. Under "3. To buy", each row has **Search AH**. With the auction house closed, click one: one
   grey line in chat says to open the auction house first, and nothing else happens.
5. Go to an auctioneer, open the house on its Buy tab, open `/bis` Plan again, click Search AH:
   the search box fills with the name without "(rank 2)" and the results list comes up.
6. Click the "By Boss" tab: every item row still has its item level target on the right, none says
   Equip or Search AH, and hovering that button still says "Click to set the item level".

**Pass** is all of:
- every step shows what it says
- no red Lua error box
- after step 2 and 3 nothing is left stuck to your mouse cursor

**Fail** is any step that differs. Write the step number and what you saw in `## Comments`. If a
ring went on the wrong finger in step 3, say which, and whether both planned rings were in your
bags or one was already worn: that is the one path the checks outside the game cannot see.

**Why it needs you:** the only place these buttons exist is inside the game, and no agent can run
it. Everything checkable outside it has been checked and says nothing about what is on screen.

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
- 2026-09-22 Claude: built at v0.17.0 (`e311422`) and deployed; checks pass under Lua 5.4 and the
  game's 5.1. **No frame seen in a client.** Equip picks the bag copy up and `EquipCursorItem`s it
  rather than `EquipItemByName`, because only the pickup names one exact bag slot. Search AH drives
  `AuctionHouseFrame.SearchBar` as a typed search does; the house must be open. A gem the client
  has not cached gets no Search AH button until the tab is reopened.
- 2026-09-22 Claude, adversarial review, a different session from the build. **Passed to
  human-review with three fixes, `b0c6943`, v0.17.1, deployed. No frame was seen: the only surface
  is a game client, no agent can run one, so nothing in-game is claimed.**
  **Broke:** (1) The two equip checks could not fail: the harness has no bags, so `equip` returned
  false with the combat guard deleted. They run against a pretend bag now, and deleting either
  guard, the bag slot or the inventory slot goes red. (2) `searchTerm` was `a and b or c`, so an
  enchant id missing from `ENCHANT_NAME` fell through to `C_Item.GetItemInfo(enchantId)`, an item
  lookup by the wrong id. (3) A failed pickup or a refused equip left the item on the cursor, where
  a click on the world is the destroy prompt; `equip` makes Blizzard's own two `CursorHasItem`
  checks now. (4) The redraw rode `0005`'s watcher, which only exists once the character sheet has
  been opened; it rides the bag-mark watcher now, alive from login.
  **Held:** the rank strip and the house guard go red when broken. Ring pairs are turned to match
  what is worn, and Equip all finishes its loop before the game delivers `PLAYER_EQUIPMENT_CHANGED`;
  both rings in the bags at once is the one path unproven outside the game (step 3). The shared
  button resets `onClick` and `tip` on every draw. All seven APIs are in the generated docs at
  12.1.0, none deprecated, none secret; one click is one query, so the house's own throttle
  applies. No `LoadConfig`, `CommitConfig` or purchase call in the file. Locals: 191 of 200.
  **Security.** Weakest: Equip trusts the plan's slot id, and a wrong one asks the game to put a
  ring on a head, which it refuses and the cursor is cleared. Unchecked: the search term is our own
  table or the client's item name, never player text. Leaks: nothing leaves the machine; a failure
  prints one grey line or does nothing.
- **2026-09-22** **Decided:** Rob, in the game at 0.17.1: step 1 confirmed, step 2 works, step 5 confirmed. Steps 3, 4 and 6 not reported and not asked for again. Rob's one note: the Equip button looked like "a little bit of text". Fixed at 0.17.2: Plan tab actions are now real buttons (`UIPanelButtonTemplate`); the item level target on the BiS tabs stays plain text. Card closed; if step 3 ever puts a ring on the wrong finger, open a new card.
- 2026-09-22 Rob, in the game at 0.17.2: the three buttons look like buttons. **Equip all pressed at the bank, with the bank window open: the button went away, nothing was equipped, the rows stayed.** Cause not proven. At 0.17.4 Equip is now step for step Blizzard's own equipment set code (checks the slot can take the item and is not locked, then PickupInventoryItem), and every refusal prints one chat line saying why. Next try tells us. If it fails again, open a new card with the chat line.
