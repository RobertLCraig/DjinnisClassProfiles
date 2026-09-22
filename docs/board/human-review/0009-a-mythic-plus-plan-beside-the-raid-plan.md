---
needs: 0004, 0007
---
# 0009 A Mythic+ plan beside the raid plan

## What I need from you

**Six looks in the game at 0.19.1 after a `/reload`, then one Top Gear run.**

1. In a city, open the character sheet. The strip under the stat pane has a button on its right
   reading "1 target". Click: "2 targets". Click: "Mythic+", and the stat pane's header button
   above reads "Mythic+" too. Click: "1 target" again, and the header reads "Raid".
2. With the strip on "Mythic+" it says "No Mythic+ gear plan for Feral yet. Click for how." Click
   that text. The Plan tab opens with "> Mythic+, any key   WS M+   Mythic+" as the picked row,
   red if your loadout is "DotC M+", and under "2. Gear to change" it says to run a Top Gear sim
   with the DungeonSlice fight style.
3. On the Plan tab, click the Nek'zali row. The gear list is the raid one again. That row is for
   looking only: the strip and the glows stay on Mythic+ until you click the strip's button.
4. Zone into any dungeon, a normal one will do. Touch nothing: the strip reads "Mythic+", its
   button and the stat pane's Raid / Mythic+ button are greyed out, and no bag item glows green
   (there is no Mythic+ plan yet). Leave: both buttons come back, the strip reads "1 target" or
   "2 targets", and the bag glows are back.
5. Zone into the raid. The strip button reads "1 target" and clicks go "2 targets", "1 target",
   never "Mythic+". The stat pane's header reads "Raid *" and its button is greyed.
6. Card `0003`'s look 3, the Raid / Mythic+ button changing the targets, is only true outside an
   instance now. Do it in a city.
7. Run one Top Gear on Raidbots with the DungeonSlice fight style, then
   `.\update-gear-plan.ps1 <report link> -Deploy` and `/reload`. The tool says it filed the report
   as `Feral    mplus`, and the Plan tab's Mythic+ row lists gear.

**Pass** is all seven as written.

**Fail** is any one. Say which number and what you saw in `## Comments`; the card goes back to
`todo/`. If look 7's tool run refuses the report, paste its message: the value Raidbots writes for
a dungeon fight style has never been seen on a real report, only assumed to start with `Dungeon`.

**Why it needs you.** Every look is a frame in a game client, and the fight style value is on a
report only your Raidbots account can make. One decision is taken and is yours to overturn: your
note that the Plan tab has no Raid / M+ switch is left to `0020`, whose acceptance already names
the three-button row. This review only made the strip's round-robin button honest.

## Why

The gear plan only knows raid. Rob raids and runs keys on the same druid, sometimes on the same
evening (Rob, 2026-09-22: "consider needing to gear and spec for both Raid and M+"), on all four
specs. When he zones into a key, the character sheet glows (`0005`), bag glows (`0006`) and the
Plan tab (`0007`) all still show the raid setup, so they point at the wrong gear and the wrong
loadout for the whole run.

What it costs: the M+ and raid best sets differ (the addon's own Feral M+ stat targets are not the
raid ones), so following the raid plan in a key gears him for the wrong content.

How it came to be: `update-gear-plan.ps1` files a report by its enemy count only, `1` as `st` and
`2` as `2t` (`$SCENARIOS`, line 75). A dungeon fight style was never a case it knew about. The stat
pane already has a Mythic+ / Raid switch from `0003`; the plan never used it.

## Links

- Needs `0004`: extends its generator and its plan table. Needs `0007`: its Plan tab gains the view.
- Uses `0003`'s Mythic+ / Raid switch as the fallback content choice, so one switch drives both;
  `0005` and `0006` change only by asking for the current content.

## Not this card

- Per-dungeon talent builds. One M+ loadout per spec is enough to start.
- Per-affix or per-key-level gear.
- Changing how raid scenarios (`st`, `2t`) are filed.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN a Top Gear report's fight style is a dungeon style (Raidbots `DungeonSlice` or `DungeonRoute`), THE TOOL SHALL file it under the `mplus` content, and every other report under `raid` as today. proves: `generator files a report under raid or mplus by fight style`
- [x] WHEN the player is in a raid instance, THE ADDON SHALL use the raid plan; WHEN in a Mythic Keystone dungeon, the Mythic+ plan; ELSE the content chosen on the stat pane's Mythic+ / Raid switch. proves: `current content follows instance type then the switch`
- [x] WHEN one item is in both the raid and the Mythic+ plan, THE ADDON SHALL show it as one wanted item in the bags. proves: `an item planned for both contents is wanted once`
- [x] WHEN the Plan tab is open, THE ADDON SHALL show the current content's loadout, gear changes and shopping list, and let the other content be viewed. proves: `plan tab shows the current content and can switch`
- [x] WHEN there is no Mythic+ plan for the current spec, THE ADDON SHALL say so and not fall back to the raid plan silently. proves: `missing mplus plan is said, not filled from raid`
<!-- AC:END -->

## Tasks

- [x] Read the fight style field in a real dungeon Top Gear report and write down its exact values.
- [x] Add a `content` level above `scenario` in the plan table and in the generator.
- [x] One M+ loadout per spec, from the Dreamgrove M+ builds.
- [x] Current-content rule, shared by `0005`, `0006`, `0007`.
- [x] Offline checks under the names above.

## Plan

Built; the build plan is in the comments. Stand in `C:\Dev\WoWAddons\DjinnisBiS`, read
`docs/HANDOVER.md`. Rob's SimC export for a dungeon sim is `C:\Users\r\OneDrive\Desktop\2026-09-21
Feral v1.txt`. Checks: `lua offline-check.lua` and `.\update-gear-plan.ps1 -SelfTest`, both exit 0.
Deploy: `C:\Dev\WoWAddons\bin\deploy.ps1 -WhatIf -Only DjinnisBiS`, then without `-WhatIf`.

## Comments

- 2026-09-22 Claude: card written from Rob's ask in a SecondBrain session, after cards `0004` to
  `0008` had been built by another session for raid only. Nothing on this card is built.
- 2026-09-22 Claude: built at v0.19.0 and deployed. Offline check passes under Lua 5.4 and 5.1; `update-gear-plan.ps1 -SelfTest` passes with a new case. What was done, and where it differs from the plan:
  - **The fight style field is `simbot.fightStyle`**, read off the real report `ttktB9kVE77x2zkadhVgPn` (value `Patchwerk`). The generator files any style starting `Dungeon` as `mplus`; the raid ones still go by enemy count. The self-test fixture `dungeonSliceSelfTest0000` is the raid report with that one field changed by hand, because no dungeon report exists yet. **A real dungeon Top Gear run is still needed** to fill the cell and to confirm `DungeonSlice` is the value Raidbots writes.
  - **No content level was added above scenario.** `mplus` is a third scenario key beside `st` and `2t`. Smaller, and every reader of the table (`0005`, `0006`, `0007`) changed by one function only: `planScenario` answers `mplus` when the content is Mythic+.
  - **The content rule is `statContext`, shared with the stat pane, and its order changed**: where you stand first, then the pinned switch, then Raid. Before, the pin beat the instance. The strip's button now cycles 1 target, 2 targets, Mythic+, and pins the stat pane's switch with it.
  - `any 5-player instance` counts as Mythic+, not only a keystone: that is `autoContext`'s existing rule from `0003`, and a normal dungeon wants the key gear more than the raid gear.
  - One Mythic+ row in the Plan tab, `WS M+`, from the two-target sim numbers. Its cell is empty, so the tab says so and names the fight style to sim.
- 2026-09-22 **Rob, in the game at v0.19.0: "Plan currently doesnt show me how to change between M+ and Raid for example".** Relayed by Claude from a SecondBrain session. The switch lives only on the character sheet strip, as one button that goes round 1 target, 2 targets, Mythic+ (`PlanTab.nextScenario`). The Plan tab has none, and a button that goes round hides its choices. Suggested fix, and rule 11 on `0020`: three buttons at the top of the Plan tab, `Raid - 1 target`, `Raid - 2 targets`, `Mythic+`, the chosen one lit; inside a raid or a dungeon the others are greyed, with the reason in their tooltip. For this card's review to decide: fix it here, or leave it to `0020`.
- 2026-09-22 Claude, review: **passed to `human-review/` at v0.19.1, four fixes, seven looks above.** Each `proves:` check was broken in a temp copy and went red: the content order, a raid fallback in `PlanTab.lines`, the Mythic+ row, `planScenario`'s content read, the fight style wording, the label table. The generator's `^Dungeon` test was broken and its self-test failed; a null `fightStyle`, `DungeonRoute`, lower case, and a re-run with three cells (idempotent, `st` before `mplus`) all hold; the fixture's `input.txt` is byte-identical to the raid report's and its JSON differs by the one added field. **Found and fixed:** (1) in a raid the strip's button stuck on 2 targets for good, because `nextScenario` offered Mythic+ and the instance refused it; it takes `autoContext` now and a raid goes 1, 2, 1. (2) In any instance both switches looked alive and each click silently rewrote the saved pin; both are greyed and a click writes nothing. (3) Nothing rebuilt the bag glow list on zoning, so a key kept the raid glows until gear changed; `PLAYER_ENTERING_WORLD` rebuilds it. (4) `PLAN_SCENARIOS` was dead, and `autoContext`'s comment still called the instance read overridable. `an item planned for both contents is wanted once` could not fail (it read one plan through `wantedFrom`), so two checks now rebuild the bag list outside and in a dungeon and read `bagScenario`. Main chunk holds 189 of 200 locals. The fix landed inside `3e181ba`, a concurrent session's board commit that swept the staged index; see `git show 3e181ba -- DjinnisBiS.lua`. Rob's switch note is left to `0020`, whose acceptance already names the three-button row. **Security.** Weakest: `db().statContext` and `db().planScenario`, saved variables a hand edit sets to anything; both are compared against literals only and anything else reads as Raid, 1 target. Unchecked: nothing new. `GetInstanceInfo`'s returns carry no secret annotation in `InstanceDocumentation.lua`, and the generator reads the fight style through `[string]`, so a missing field is an empty string, never a throw. Leaks: a missing cell prints a fixed sentence and a refused report throws with its own id, nothing else. No browser applies; the only surface is a game client and no in-game behaviour is claimed.
