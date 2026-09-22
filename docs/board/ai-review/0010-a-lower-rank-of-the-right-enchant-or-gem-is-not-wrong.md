---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
needs: 0008
---
# 0010 A lower rank of the right enchant or gem is not wrong

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
