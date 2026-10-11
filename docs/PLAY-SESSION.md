# Play session: every open look, in one trip

Every built card is waiting only on these. Each step names its cards; the exact pass for each
look is the unticked `proves: manual` line on that card (`docs/board/ai-review/` or `done/`).
Tick what passes. For a fail, tell a session the step, the card and what you saw: it reopens that
card in `todo/` with the fix. Written 2026-10-11 for v0.69.0 plus that day's fixes (0010, 0017,
0055, 0056), deployed the same day. Card 0064's four looks wait until its Warcraft Logs refresh.

1. **Full restart, not `/reload`** (0001). The claw button is on the minimap ring and opens the
   window. The minimap addon drawer has exactly one "Djinni's Class Profiles". Hover the button:
   "Click to open".

2. **Character sheet, in a city, as Feral** (0003, 0009, 0010, 0028). The strip button goes
   1 target, 2 targets, 3+ targets, Mythic+, and "3+ targets" fits. On Mythic+ it offers the gear
   list, never "No Mythic+ gear plan". The pane's Raid / Mythic+ button changes the targets.
   Hover a one-hander while wearing a two-hander, and a third ring: the footer names the right piece.
   Socket a lower Masterful Garnet in Lightwarden's Bind: a grey "rank" mark, "Plan: fine.".

3. **Bags** (0006, 0016, 0077). A planned piece glows green in Baganator, its tooltip says
   "Plan: equip in <slot>", the glow goes once worn. Planned items say "Feral raid: in plan".
   Voracious Heart of Ula'tek has one "Trinket tier:" line. Disable Baganator, `/reload`: the
   default bags glow the same.

4. **Main window, `/dcp`** (0002, 0009, 0010, 0011, 0012, 0021, 0022, 0025, 0029, 0053). Plan tab:
   four content buttons, the Nek'zali row, Talents (hover, click, click while moving), loot spec
   lines per boss, Equip all saves "DBiS Feral ST", the Auctionator prices and button, the
   KeystoneLoot row (click twice). By Slot: trinket letters, gone with ClassCodex on. More: click
   every item once; none says to type a command.

5. **Talent window, as Feral** (0032, 0034, 0036, 0041, 0042, 0044, 0045, 0046, 0052, 0053). The
   list on the right: Raid portraits, Mythic+, Other builds, Your loadouts, one tick, folds that
   stay. Hover a row: the tree tints. Save, Load and Undo bars rows fit and work. Point at Load
   bars: spec: the preview sits on your bars, after a UI scale change too, and in Cat Form.

6. **Spare and saved builds** (0040, 0065, 0067). Double-click grey "spare" rows: each is worn as
   `[CP*] <build>`, full tree, five in a row, also with all 40 slots used. Right-click a row: a
   menu only. Save to the game, Export..., and Reset refused while the window is open.

7. **The loadout box** (0039, 0060, 0063, 0066). More > Make the planned loadouts > Reset to plan
   on a hand-edited worn `[CP]` loadout: one loadout, worn, holding the plan, with the window shut
   and again with it open. At 40 slots: no Create, and Delete old loadouts works.

8. **Bar profiles and alts' bars** (0037, 0049, 0068, 0069). `/dcp bars save Main`, list, load on
   another character, undo, delete. Export a profile, Import it on another character of the class,
   Load: bars, keys and character macros match.

9. **Training dummy** (0003, 0006, 0011, 0015, 0022, 0024, 0034, 0040). Bars keep their numbers in
   combat; `/reload` mid-fight says "Ratings are hidden right now". After a Talents load, a spare
   wear and a Set up: 30 seconds on every button, no frozen bar, no "blocked". Set loot spec in
   combat is refused. With `/console taintLog 1`, `Logs\taint.log` names nothing of this addon.

10. **Self-test** (0016, 0027, 0056). `/reload`, `/dcp test` before opening anything: "[CP]
    self-test passed", no "values swapped" line. Click Later; spellbook and talent window open and
    close twice each. Then Reload now.

11. **Group finder** (0024). As Guardian, accepted as Damage for a key: Set up changes spec, loads
    `Dungeon`, equips the M+ set. As Feral accepted as Healer: "Plan: Resto, Mythic+". Already set
    up: no window.

12. **Mythic+ night** (0009, 0015, 0017, 0021, 0029). In a dungeon the content switches are
    greyed and the Mythic+ plan glows. The keystone font, with something missing, opens the
    checklist. A hand-edited `Dungeon` shows "Fix talents". No loot spec card from this addon.

13. **At the auction house** (0017, 0025). Click each red consumable line: Flask, Augment Rune,
    Harandar Celebration, Thalassian Phoenix Oil. Send the shopping list to Auctionator twice: one
    list, replaced.

14. **Raid night, the Venomous Abyss** (0001, 0009, 0015, 0016, 0017, 0027, 0043, 0054, 0071). The
    loot spec card on entry. A ready check lists what is missing. The pre-pull popup asks for no
    worse gear. Kill Nek'zali: the popup names Entombed Sentinels. A bonus roll verdict only when a
    roll is offered. A planned item's loot roll glows.

15. **Other characters, and Raidbots** (0028, 0049, 0055, 0059, 0066, 0073). Level 81 Warlock:
    Compare says "as far as this level allows". Beast Mastery Hunter: `[CP] Dungeon` and
    `[CP] Raid` load. Any non-druid: no BiS lines, `/dcp here` says druid gear. An alt with old
    loadouts: "Tag them". Then the twelve Top Gear runs listed on 0028, and paste the links.
