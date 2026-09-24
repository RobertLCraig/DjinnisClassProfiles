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

## HANDOVER Last updated line, retired 2026-09-23 at v0.39.0

_Last updated: 2026-09-23 (v0.38.2: a spare waiting on the window yields to a loadout picked in the dropdown, card 0040; v0.38.1: second review fixes; a waiting spare is dropped by a new ask or a spec change, a "BiS: X" the addon did not make is never doubled, the spare is found by the watched config id; v0.38.0: review fixes for 0029, 0039, 0040, 0043 and 0045; the spare is made with the talent window shut and worn through ClassTalentHelper once filled, and only spares this character made are touched; v0.37.1: an Undo bars button, card 0045; v0.37.0: Load bars buttons, build and spec, card 0044; v0.36.2: the reminder skips bosses dead on the lockout, and the offer asks only for builds that fit, card 0043; v0.36.1: a build with its own action bars says "own bars" in the list, card 0042; v0.36.0: a spare loadout `BiS: <build>` wears builds with no slot, card 0040, and your own loadouts in the list, card 0041; v0.35.2: Create and Reset say when all 40 loadout slots are used, card 0039; v0.35.1: no profile named "build"; v0.35.0: named action bar profiles, `/djbis bars save|load|list|delete <name>`, card 0037; v0.34.0: Save bars buttons under the talent window list, to the build or for the spec, card 0036; v0.33.4: a refused key is offered again once its addon is on, card 0033; v0.33.3: a stale bars offer applies nothing, refused keys kept per character, card 0033; v0.33.2: the bars undo keeps the keys after a layout without them, card 0033; v0.33.1: the bars undo is retaken when the bars moved since the last apply, card 0033; v0.33.0: review fixes for 0031 to 0034, talent strings compared node by node; v0.32.0: key bindings go with the action bars, card 0033; v0.31.0: Balance builds named by fight, `Raid: Single Target`, `Raid: Cleave`, `Raid: Nek'Zali, Nymrissa`; a build for one boss keeps `Raid: <boss>` (Rob); v0.30.0: hover a build to see on the tree what it changes, card 0034; v0.29.0: the talent window list looks like TalentLoadoutsEx, card 0032; v0.28.0: action bar layouts per spec and per build, `/djbis bars`, card 0033; v0.27.0: the planned builds become real loadouts, `/djbis loadouts` and `/djbis tidy`, card 0031)_
