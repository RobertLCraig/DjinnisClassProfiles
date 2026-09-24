---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
needs: 0008
---
# 0010 A lower rank of the right enchant or gem is not wrong

## What I need from you

**Four looks in the game, on your Feral druid, out of combat, with the Flawless Masterful Garnet
still in your wrist.** It is v0.18.1 and already deployed.

1. `/reload`, open the character sheet. The wrist has a grey ring saying "rank", not an amber
   one saying "gem". Hover it: "Plan: fine. Masterful Garnet (rank 3 of 4) is on; a higher rank
   exists".
2. `/bis`, click "Plan". Under "2. Gear to change" the wrist row says "Wrist: fine. ..." in the
   same words. Under "3. To buy": green "Nothing to buy" (if every other slot is right), then a
   grey "Higher ranks exist, if you want to spend on them:" with "1x Masterful Garnet (rank 4 of
   4)" and a Search AH button.
3. At the auction house, click that Search AH: the box says "Masterful Garnet" and the results
   include both the plain and the Flawless ones.
4. Put a Peridot in the wrist instead, or take the garnet out: the ring turns amber and says
   "gem", and "To buy" lists the garnet again.

**Pass** is all four steps as written and no red Lua error box.
**Fail** is any step that differs. Write the step number and what you saw in `## Comments`.

**Why it needs you:** the marks exist only inside the game, and no agent can run it. One thing is
a call, not a check: the tab names your gem "Masterful Garnet (rank 3 of 4)" where the game says
"Flawless Masterful Garnet". If you would rather read the game's name, say so; it is one line.

## Why

The plan names one enchant id and one gem id per slot, and the addon called anything else wrong.
Enchants come in two ranks and gems in four, all under one name, and the sim always asks for the
top one. Rob bought a Flawless Masterful Garnet on 2026-09-22 and the addon kept saying the wrist
wanted one, because the house had sold him rank 2 of 4 and the plan wanted rank 4.

What it costs: a red mark that never clears, a shopping list that never empties, and a push to
spend top-rank gold on gear he expects to replace. Rob, 2026-09-22: "a lower quality gem/enchant
isn't wrong, but it is also not as good as it could be", and on Champion gear he may pick the
cheaper rank on purpose.

How it came to be: the game has no call from an enchant id to a name, so the addon could only
compare ids, and nothing told it which ids were the same thing at another rank.

## Links

**Blocked by**
- `0008` - the Plan tab and its shopping list, which this changes.

## Not this card

- Choosing a rank for Rob. The plan still names the sim's rank; the addon only stops calling a
  lower one wrong.
- Rank-aware glows in the bags (`0006` marks a piece to equip, and ranks are about what is on it).

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the worn enchant or gem is a lower rank of the planned one, THE ADDON SHALL mark the slot "lesser", not "enchant" or "gem", and its line shall start "Plan: fine." proves: `a lower rank of the planned gem or enchant is lesser, not wrong`
- [x] WHEN the worn enchant or gem is a lower rank of the planned one, THE ADDON SHALL leave it off "To buy" and list the planned rank under "Higher ranks exist". proves: `a lower rank of the planned gem or enchant is lesser, not wrong`
- [x] WHEN the worn enchant or gem is another family, or the id is not in the rank table, THE ADDON SHALL still call it wrong. proves: `slot state is enchant when enchant differs`
- [x] WHEN a planned gem has two of one family and one is worn, THE ADDON SHALL want one more. proves: `two planned gems of one family, one worn, wants one more`
<!-- AC:END -->

## Tasks

- [x] `update-plan-ranks.py`: every id in the family of every planned enchant and gem, from Raidbots.
- [x] `PlanTab.rankState`, `rankName`, `gemMatch`; `slotState` and `shoppingList` on top of them.
- [x] A grey "rank" mark on the sheet, a "Plan: fine." line, and "Higher ranks exist" on the tab.

## Comments

- **2026-09-22** WRITTEN AFTER THE WORK. Rob asked in chat; the card was written with the code.
  Attack the code, not the boxes.
- 2026-09-22 Claude: built at v0.18.0. Offline check passes under Lua 5.4 and 5.1. No frame seen.
  Rank data is a fourth generated block, `GENERATED PLAN RANKS`, written by `update-plan-ranks.py`
  from `raidbots.com/static/data/live/enchantments.json` and `gems.json` (a plain user agent gets
  403; the script sends one). An enchant's family is its scroll's item name and its rank is
  `craftingQuality`; a gem's family is its name without "Flawless " or "Perfect " and its rank is
  its place by item level then quality. That gem order is my reading, not Raidbots' word: the four
  Masterful Garnets are 278 and 295 item level in uncommon and rare, and I ranked 295 uncommon
  above 278 rare. If the stat numbers say otherwise, the sort key is one line in the script.
  Re-run the script whenever the gear plan gains a new enchant or gem; `--check` says if it must.
- 2026-09-22 Claude, adversarial review, a different session from the build. **Passed to
  human-review with one fix and three new checks, `1b40f27`, v0.18.1, deployed. No frame was
  seen: the only surface is a game client, no agent can run one, so nothing in-game is claimed.**
  **Broke:** (1) The gem order was the wrong way round. Wowhead's tooltips: Flawless Masterful
  Garnet 278 gives 14 crit and 6 mastery, plain Masterful Garnet 295 gives 12 and 5, so quality is
  the major key and Rob's garnet is rank 3 of 4, not 2. Blizzard's enchant ids 8150 to 8153 run
  the same way. One line in the script, block regenerated, only the four swapped rows moved.
  (2) Three mutations passed every check: `gemMatch` returning "lesser" when a gem is also
  missing, and deleting either drawn "Higher ranks exist" row. Each has a check now, the last two
  against the tab as drawn with the planned wrist worn at rank 3.
  **Held:** every other guard goes red when broken. `gemMatch` on nil worn, an empty plan, an
  extra worn gem, a higher worn rank (ok), two planned of one family against one worn; the pool
  is removed from after the inner loop. `planLineFor` for "lesser" reads `mark.worn.enchant`
  unguarded, and every such mark comes from `slotStates`, which sets `worn`. `wantedFrom` takes
  "change" only, so 0005 and 0006 are unchanged. Search AH for an enchant is the scroll's item
  name, confirmed on 0008 step 5. The script keeps the line ending, gets 200, `--check` exits 0
  when current, rewrites only the marked block; no planned family collides with a "Perfect " gem
  from an old expansion. Locals: 190 of 200.
  **Security.** Weakest: the table trusts Raidbots at author time, so a wrong family name there
  would make two gems read as one; the script refuses to write when a planned id is missing.
  Unchecked: every id reaching `PlanTab.RANK` is a plan constant or parsed from a link that
  passed `canRead`, and `gemKey`'s name fallback is behind `canRead`, so no secret value reaches
  a table key or a comparison. Leaks: nothing leaves the machine; two GETs to Raidbots, author only.
