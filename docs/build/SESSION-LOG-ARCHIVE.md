# Session log archive

Folded out of docs/HANDOVER.md; the commit log is the narrative.

## Status block folded 2026-09-22

**2026-09-22, latest: card `0009` is built, reviewed and in `human-review/` at v0.19.1.** Mythic+
is a third plan cell beside the raid ones, `mplus`, filed by the generator off `simbot.fightStyle`
starting `Dungeon`; the cell is empty until Rob runs one DungeonSlice Top Gear. **The content rule
changed: where you stand beats the pinned switch now** (before, the pin won), so a key shows the
Mythic+ plan whatever was pinned in a city. The review fixed the strip button sticking on 2 targets
inside a raid, greyed both switches inside an instance, and made zoning rebuild the bag glows.
Seven looks are on the card. The fix is inside `3e181ba`, a concurrent session's board commit.
**2026-09-22, earlier: card `0010` is built, reviewed and in `human-review/` at v0.18.1.** A lower
rank of the planned enchant or gem is "lesser" now, a grey "rank" mark and "Plan: fine.", and the
Plan tab lists the higher rank under "Higher ranks exist" instead of "To buy". The ranks come from
a fourth generated block written by `update-plan-ranks.py` out of Raidbots. Its review turned the
gem order round (quality first, then item level: Wowhead's stats say the rare at 278 beats the
uncommon at 295) and added three checks against the tab as drawn. Four looks in the game are on
the card.
**2026-09-22, earlier: card `0008` is in `done/`, confirmed by Rob in the game.**
The Plan tab has buttons now: Talents opens the talent window and loads nothing, Equip puts the
exact bag copy in the planned slot, Search AH runs the auction house's own search. Its review
fixed three faults at 0.17.1: an unnamed enchant searched by item id, a refused equip left on
the cursor, and a redraw that only worked once the character sheet had been opened. Rob then saw
all three buttons work, and 0.17.2 made them look like buttons. **`todo/` holds one card, `0009`**, a Mythic+ plan beside the raid plan, written
by Rob the same night; six cards wait on one trip to a live client.
**2026-09-21: card `0007` is built, reviewed and in `human-review/`.** A
fourth tab, Plan, names the talent loadout per boss, the slots to change and what to buy. Its review
made the checks read the drawn tab and fixed three small faults at 0.16.1. It wants eight looks in
the game. **`todo/` is now empty**, and six cards wait on one trip to a live client. The main chunk
of `DjinnisBiS.lua` has nine top-level locals left of Lua's 200: add to a table, not a local.
**Built and deployed locally and never published**, which `CHANGELOG.md` states in as many words:
everything is under `[Unreleased]`.
**Three live cards and every one of them is waiting on a live client.** `0001` and `0002` sit in
`human-review/` and are Rob's: `0001`, "the window has no decent way to open", needs a **full client
restart**, not a `/reload`. `0002`, "trinket tiers borrowed from ClassCodex", needs ten minutes with
ClassCodex disabled and then enabled. `0003`, "stat targets, and what a drop does to them", is in
`ai-review/`; Rob has now looked four times. Placement, dragging, side-swapping and the styling are
all **confirmed working at 0.11.3**. What is fixed and **not looked at** is 0.12.0, and it is the
card's actual subject rather than its chrome: the hero talent was never being read, and a one-handed
weapon was compared against an empty off-hand while a two-hander was equipped.
**2026-09-21: card `0004` is built and in `ai-review/`**, a gear plan table baked in from a Raidbots
Top Gear report, data only. One cell of it is filled, Feral single target. Cards `0005`, `0006` and
`0007` in `todo/` draw it and none is started.
**2026-09-21, later: card `0005` is built at 0.14.0 and in `ai-review/`.** Slots on the character
sheet that differ from the gear plan now glow, red for a wrong item and amber for a wrong enchant
or gem. Not yet seen in a client. **It passed its adversarial review the same day, with three
fixes, and is now in `human-review/` for four looks in the game.** `0004` is in `done/`, and `0003` is back in `todo/` on its
in-combat zero. The four open cards carry `not_for_the_loop:` because Rob builds this addon by hand
on msiraider.
**2026-09-21, later still: card `0006` is built at 0.15.0.** A planned piece that sits in the bags
unworn glows green, through Baganator's corner widget API, or on Blizzard's bag buttons when
Baganator is not loaded. It passed its adversarial review the same day, with one taint fix, and
is now in `human-review/` for five looks in the game.
**2026-09-21, last: card `0003` is now in `human-review/`, not `ai-review/` or `todo/`.** Its in-combat
zero was fixed at 0.15.1, a second adversarial pass stopped a proc from emptying the rating cache
mid-fight, and what is left is six looks only a game client can settle.
