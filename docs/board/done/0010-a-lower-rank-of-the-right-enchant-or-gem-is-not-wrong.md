---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
needs: 0008
---
# 0010 A lower rank of the right enchant or gem is not wrong

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

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
- [ ] LOOK 1. On the Feral druid, `/reload`, strip under the stat pane on "1 target". Socket a LOWER rank of Masterful Garnet (any but the top one, for example item 240907) in the second ring, Lightwarden's Bind, which the plan wants with the top rank (240908). The ring slot shows a grey "rank" mark, not an amber "gem" one. Hovering it says "Plan: fine. Masterful Garnet (rank 3 of 4) is on; a higher rank exists", naming the rank you socketed. If you would rather read the game's own gem name there, say so: it is one line. proves: manual
- [ ] LOOK 2. Same setup, `/dcp`, Plan tab. The second ring's row under "2. Gear to change" says "Plan: fine. ..." in the same words. The garnet is not under "3. To buy". A grey "Higher ranks exist, if you want to spend on them:" lists "1x Masterful Garnet (rank 4 of 4)" with a Search AH button. proves: manual
- [ ] LOOK 3. Take the garnet out of that ring, or socket a Quick Peridot instead. The mark turns amber and says "gem", and "To buy" lists Masterful Garnet again. No red Lua error box at any step. proves: manual
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

**2026-10-11** Clear-down (attended, Rob asked). `update-plan-ranks.py --check` said the rank table was out of date: the plan had gained enchant 8689 (Rite of the Hash'ey) and dropped Versatile Peridot. Ran it on branch `cleardown/djcp`: the block now holds 8688 and 8689 and no Versatile Peridot, `--check` exits 0, and the Lua 5.1 offline check passes. The old looks used a garnet in the WRIST, which no plan cell gems any more; they are rewritten against the second ring, Lightwarden's Bind, where the Feral 1 target, 2 target and Mythic+ cells all plan Masterful Garnet rank 4 (240908). The Search AH look is dropped: card 0008 already proved Search AH. Moves to ai-review/ with only the three in-game looks open (board README, A look waits on the product).

### 2026-10-18 review (v20261018012954-faf2)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I tried to break the four code criteria. I could not break them.

**#1, the "lesser" mark and the "Plan: fine." line.**
- `PlanTab.rankState` gives "lesser" only when the worn rank is lower in the same family.
- `slotState` returns "enchant" or "gem" only for a wrong item. It returns "lesser" for a lower rank, and only after all wrong-item checks are done.
- `planLineFor` (the "lesser" branch) starts the line with "Plan: fine." and gives the worn rank's name from `PlanTab.rankName`.

**#2, keep it off "To buy" and list it under "Higher ranks exist".**
- In `PlanTab.shoppingList`, a "lesser" enchant goes into `better`, not into `count`. A "lesser" gem pair goes into `better.gem` with the planned id.
- The grey header line is drawn from that list.

**#3, another family or an unknown id is still wrong.**
- `rankState` returns "wrong" when either id is missing from the table, or when the families are different.
- `PlanTab.gemKey` falls back to the item name, or to the id. That key does not match a family that is in the table, so `gemMatch` marks the gem as missing, which means "gem".

**#4, two planned gems of one family and one worn: want one more.**
- `PlanTab.gemMatch` takes each worn gem out of the pool after it matches one planned gem.
- So the second planned gem stays in `missing`. The state becomes "gem", and the shopping list counts it.

LOOK 1 to 3 are open manual checks. The code does not stop them from passing.

VERDICT: sound

**scope: sound**

I checked the code for this card's work only. Nothing crosses the "Not this card" fence, so my verdict is sound.

**What I checked**

- **No choosing a rank for Rob.** `PlanTab.rankState` in `DjinnisClassProfiles.lua` only sorts a slot into "ok", "lesser" or "wrong". The plan still names the sim's rank.
- **No rank glows in the bags.** The bag glows (card 0006) do not call `PlanTab.rankState` or `PlanTab.gemMatch`.
- **One other caller is not scope creep.** The pre-pull popup lists slots to fix and calls `PlanTab.gemMatch` there. It only uses the result to pick a Search AH term. It adds nothing new for this card.
- **Nothing is half done.** The script, the three helpers, the grey mark, the "Plan: fine." line and the "Higher ranks exist" rows are all in place. Offline checks cover each one.

**What the diff shows**

- The diff holds 157 files: the rename to DjinnisClassProfiles, about 80 other cards, and research files. This is the whole branch, not this card's own work.
- This card's only new change on 2026-10-11 was the regenerated rank table. I did not judge the rest, because it belongs to other cards.

**What you do now**

- The three LOOK checks are still open. You try them in the game. They are not findings.

VERDICT: sound

**breakage: sound**

**What I did:** I read the rank table, `PlanTab.rankState`, `PlanTab.gemMatch`, and the rank checks in the offline-check block of `DjinnisClassProfiles.lua`. I tried to find something this change breaks. I could not.

**What held:**
- The table now has every planned enchant and gem. That includes the new enchant 8689 and the new gem Quick Peridot 240888.
- Masterful Garnet 240907 is rank 3. So LOOK 1 ("rank 3 of 4") matches the data.
- `gemMatch` reports "gem" when a planned gem is missing, even if another gem is a lower rank. Two planned gems of one family with only one worn still asks for one more.
- Gem 240894 (Versatile Peridot) is no longer in the table. It is still in the tests. There it correctly reads as "wrong", "gem" or "change".
- The drawn "Higher ranks exist" check uses a fixed test plan (`pinPlanFixture`). So the live plan dropping the wrist gem does not break it.

**Small stale text:** Two check labels in the rank block still say "rank 2". They are "gem rank 2 of 4 for rank 4" and "gem rank 4 for rank 2 is fine". Since the 0010 review, 240907 is rank 3. Only the label is wrong. The asserted values are right. No criterion fails.

**What you do now:** Nothing. The three LOOK checks are yours to try in game.

VERDICT: sound

