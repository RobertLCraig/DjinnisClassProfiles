---
not_for_the_loop: Rob, 2026-09-21: building DjinnisBiS by hand in a session on msiraider
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
needs: 0004
---
# 0007 A Plan tab: talents per boss, and a shopping list

## What I need from you

**Eight looks in the game, on your Feral druid, out of combat.** It is v0.16.1 and already deployed.

1. Type `/reload`, then `/bis`. The window has a fourth button at the top, "Plan".
2. Click "Plan". You see nine bosses. Each has a talent loadout name and "1 target" or "2 targets".
3. Click a boss. The `>` moves to it. Its loadout name is **red** if it is not the one you have
   picked now, with a red line under the list telling you which to pick.
4. Open talents, pick the loadout it named, close and reopen `/bis`. That name is now **green**.
5. With a "1 target" boss picked, "Gear to change" names about seven slots. Hover a row that names
   an item: its tooltip shows.
6. Click a "2 targets" boss. It says there is no 2 target plan yet and how to make one.
7. "To buy" lists enchants and gems by name with a count, such as "2x Eyes of the Eagle (rank 2)".
8. Open your character sheet. Click the strip under it that says "N slots to fix. Click for the
   list." The Plan tab opens. Then on the "By Boss" tab, shift-click an item: it still links in chat.

**Pass** is all of:
- every step shows what it says
- no red Lua error box
- "your loadout now" at the top of the tab names the loadout you really have picked

**Fail** is any step that differs. Write the step number and what you saw in `## Comments`. If
"your loadout now" says "not known" while a saved loadout is picked, say so: that is the one call
nobody could test outside the game.

**Why it needs you:** the only place this shows is inside the game, and no agent can run the game.
Everything that can be checked outside it has been, and says nothing about what is on screen.

## Why

Two parts of the 2026-09-21 advice have nowhere to live in the game. **Talents:** the best Feral
build differs by boss. The saved "DotC Raid ST *" loadout is best on one target, while Dreamgrove's
Twin Fangs build sims 18% higher than it on two targets (Raidbots report `woaue4bCT5xSu46yWFoL7W`).
Rob has to remember which loadout goes with which boss. **Enchants and gems:** the plan's rings
need Eyes of the Eagle and a haste gem he did not have, and there is no list of what to buy.

What it costs: the wrong loadout on a boss is worth up to 18% on its own; a missing enchant stays
missing until somebody reads his sheet.

How it came to be: the per-boss builds only appeared on Dreamgrove on 2026-09-18, and the plan data
did not exist in the game until card `0004`.

## Links

- Needs `0004`: the plan table, which carries the loadout per scenario and the planned enchant and
  gem ids.
- `DjinnisDreamgrove` (`C:\Dev\WoWAddons\DjinnisDreamgrove`) already imports Dreamgrove builds as
  Blizzard loadouts; its `Data.lua` was last generated 2026-09-02 and every Feral build has changed
  since. This card names loadouts; refreshing that addon is its own card there.

## Not this card

- Applying a talent loadout. **An addon must not call `C_ClassTalents.LoadConfig` or
  `CommitConfig`**: DjinnisBiS card `0002` found ClassCodex doing so from insecure code, the known
  route to action bars that stop updating in combat. This tab tells Rob which loadout to pick; he
  clicks it.
- Glows (`0005`, `0006`). Consumables. An equip button.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the Plan tab is open, THE ADDON SHALL list each boss of the current raid with the planned loadout name and scenario for the current spec. proves: `plan tab lists a loadout per boss for the spec`
- [x] WHEN the active loadout's name differs from the planned one for the boss selected in the tab, THE ADDON SHALL show the planned name in red. proves: `loadout mismatch is flagged by name`
- [x] WHEN any planned slot lacks its enchant or gem, THE ADDON SHALL list each missing enchant and gem once, by name, with a count. proves: `shopping list counts each missing enchant and gem once`
- [x] WHEN nothing is missing, THE ADDON SHALL say "Nothing to buy". proves: `empty shopping list says nothing to buy`
<!-- AC:END -->

## Tasks

- [x] Boss-to-scenario table per spec in the generated plan block (from Dreamgrove's per-boss builds).
- [x] Active loadout name via `C_ClassTalents` read-only calls.
- [x] Tab in the existing `/bis` window beside Stats.
- [x] Offline checks under the names above.

## Plan

Built. Stand in `C:\Dev\WoWAddons\DjinnisBiS`; the code is `PlanTab` in `DjinnisBiS.lua`. The boss
to build mapping is `https://dreamgrove.gg/blog/feral/compendium` (updated 2026-09-18). Talent APIs
are read-only and checked against `C:\Dev\WoWAddons\wow-ui-source\`. Checks: `lua offline-check.lua`.
Deploy: `C:\Dev\WoWAddons\bin\deploy.ps1 -WhatIf -Only DjinnisBiS`, then without `-WhatIf`.

## Comments

- 2026-09-21 Claude: card written from the same session as `0004`. The talent and enchant advice it
  carries is in `C:\Users\r\OneDrive\Desktop\SecondBrain\outputs\2026-09-21 Raid DPS as Feral or
  Balance.md`. Nothing is built yet.
- 2026-09-21 Claude: built at v0.16.0 (`bc3b651`) and deployed. `lua offline-check.lua` passes, and
  a copy broken on purpose in four places failed all four named checks, so the checks can fail.
  **No frame has been seen in a client.** Four things differ from the plan above:
  1. **The boss table is outside the generated block**, straight after its END marker, and is kept
     by hand. `update-gear-plan.ps1` rewrites the block from Raidbots reports and a boss list is
     not in a report, so inside the block it would be deleted on the next run.
  2. **The loadout names are the ones DjinnisDreamgrove imported on 2026-09-02**, because those are
     what exist in the game to click. The hero tree per boss follows Dreamgrove's 2026-09-18 page.
     The newer per-boss builds have no loadout yet; when that addon is refreshed, change the names
     in `PlanTab.BOSSES`.
  3. **Enchant names are a hand table**, `PlanTab.ENCHANT_NAME`. The game has no call from an
     enchant id to a name (checked in `wow-ui-source`). Names came from
     `raidbots.com/static/data/live/enchantments.json`. An id not in the table prints as
     `enchant 1234`.
  4. **Rob's screenshots mid-build: "7 slots to fix" did not say which slots or what to do.** So the
     tab also lists each slot to change, and the strip under the character sheet now says "Click
     for the list" and opens this tab. That touches `0005`'s strip, text and one click only.
  A planned piece that is not worn is left out of the shopping list, and the tab says so, because
  the bag copy may already carry its enchant.
  **Trap for the next card:** `DjinnisBiS.lua` is at Lua's limit of 200 top-level locals. The first
  build would not load. Everything new went into one `PlanTab` table. Add to a table, not a local.
- 2026-09-21 Claude, adversarial review, a different session from the build. **Passed to
  human-review with four small fixes, `235f8c2`, v0.16.1, deployed. No frame was seen: the only
  surface is a game client, no agent can run one, so nothing in-game is claimed to work.**
  **Broke:** (1) The checks for criteria 1 and 2 proved the tables only. A copy that drew a
  mismatch in green, and one that drew no loadout name at all, both passed. They now draw the tab
  and read it back, and both copies go red. Criteria 3 and 4 went red when broken, five ways.
  (2) With the starter build active the game still reports the last saved loadout, so the tab could
  show a stale green. It now asks `GetStarterBuildActive` first, as Blizzard's talent frame does.
  (3) The strip counts the scenario saved for the sheet and the tab opened on the first boss, so
  "slots to fix" on 2 targets opened a 1 target list. It opens on a boss of the strip's scenario.
  (4) "Click for how" on a spec with no boss table led to a line that did not say how. It does now.
  **Held:** nil paths (no spec, not a druid, no saved loadout, nil into `GetSpecializationInfo`
  under `pcall`, an uncached item name or link). The loadout name goes through `canRead` before it
  is compared or formatted, and is only ever a format argument, so `%` in a name is inert; a `|` in
  a name could bend one line's colour and no more. In combat the tab says gear cannot be read if a
  worn link is secret. No bag, item or talent call it makes has a secret return in the generated
  docs. The strip and window are our own plain frames, nothing secure is touched. Shared rows:
  `row.onClick` is reset on every draw, so By Boss rows and the ilvl button act as before. The
  `slotStates` refactor is the same loop, and the `0005` and `0006` checks pass. All five APIs are
  in `Blizzard_APIDocumentationGenerated` at 12.1.0 (69875), none only under `Blizzard_Deprecated*`.
  The fence held: nothing calls `LoadConfig` or `CommitConfig`. **Locals:** `lua` on this PATH is
  5.4.6, not 5.1. Under the real 5.1.5 in `C:\Program Files (x86)\Lua\5.1` the file parses, the
  checks pass, and the main chunk has 191 of 200 live at its end: nine left.
  **Security.** Weakest: the tab trusts "last selected loadout", so talents changed by hand after
  picking one still read green; the code says so. Unchecked: a loadout name is player text drawn
  raw into a coloured line; it is your own and goes nowhere. `/bis test` swaps
  `PlanTab.activeLoadoutName` for a moment and puts it back. Leaks: nothing leaves the machine; a
  failure shows "not known" or a grey line, never an id or a trace. **Not fixed, for you to weigh:**
  a red gear row's tooltip is the base item, not the planned item level, and the tab does not
  redraw itself when you swap talents or gear while it is open.
