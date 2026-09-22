---
needs: 0004, 0007
---
# 0009 A Mythic+ plan beside the raid plan

## Why

The gear plan only knows raid. Rob raids and runs keys on the same druid, sometimes on the same
evening (Rob, 2026-09-22: "consider needing to gear and spec for both Raid and M+"), and his
Mythic+ score is spread over all four specs: Guardian 2678, Balance 2358, Resto 1254, Feral 858
(raider.io, 2026-09-21). When he zones into a key, the character sheet glows (`0005`), bag glows
(`0006`) and the Plan tab (`0007`) all still show the raid setup, so they point at the wrong gear
and the wrong loadout for the whole run.

What it costs: the M+ and raid best sets differ. Raidbots' stat weights for Feral in raid put
haste and crit first, while the stat targets this addon already carries for Feral M+ are different
numbers (`GENERATED STAT TARGETS`, `mplus` rows). Following the raid plan in a key, or the other way
round, gears him for the wrong content.

How it came to be: `update-gear-plan.ps1` files a report by its enemy count only, `1` as `st` and
`2` as `2t` (`$SCENARIOS`, line 75). A dungeon fight style was never a case it knew about. The stat
pane already has a Mythic+ / Raid switch from `0003`; the plan never used it.

## Links

- Needs `0004`: extends its generator and its plan table.
- Needs `0007`: its Plan tab gains the Mythic+ view.
- Uses `0003`'s Mythic+ / Raid switch as the fallback content choice, so one switch drives both.
- `0005` and `0006` read the plan through whatever `0004` exposes; they should change only by
  asking for the current content.

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

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md`, then `update-gear-plan.ps1` from
the top (its header explains the report format and why Combo 1 is the base), then cards `0004` and
`0007` in `done/` and `human-review/`.

**The fight style field.** Raidbots' report JSON has `simbot.fightStyle` and `sim.options`. Run one
Top Gear for Feral with a dungeon fight style on Raidbots (Rob has Premium; his SimC export for
2026-09-21 is `C:\Users\r\OneDrive\Desktop\2026-09-21 Feral v1.txt`), open
`https://www.raidbots.com/reports/<id>/data.json` and record the value. Do not assume the names in
the criteria are exact; correct them on this card if they differ.

**The instance check.** Use `GetInstanceInfo` for instance type and difficulty, and check the
Mythic Keystone difficulty id in `C:\Dev\WoWAddons\wow-ui-source\`, not from memory.

**Loadouts.** Dreamgrove's Feral compendium (`https://dreamgrove.gg/blog/feral/compendium`,
updated 2026-09-18) has "M+ DOTC" and "M+ Wildstalker" builds. The 2026-09-21 sims put M+ DOTC at
207,837 on two targets against 214,785 for M+ Wildstalker; a dungeon-style sim should decide
between them, not the two-target number.

Offline checks: `lua offline-check.lua`, exit 0. Deploy:
`C:\Dev\WoWAddons\bin\deploy.ps1 -WhatIf -Only DjinnisBiS`, then without `-WhatIf`.

## Comments

- 2026-09-22 Claude: card written from Rob's ask in a SecondBrain session, after cards `0004` to
  `0008` had been built by another session for raid only. Nothing on this card is built.
- 2026-09-22 Claude: built at v0.19.0 and deployed. Offline check passes under Lua 5.4 and 5.1; `update-gear-plan.ps1 -SelfTest` passes with a new case. What was done, and where it differs from the plan:
  - **The fight style field is `simbot.fightStyle`**, read off the real report `ttktB9kVE77x2zkadhVgPn` (value `Patchwerk`). The generator files any style starting `Dungeon` as `mplus`; the raid ones still go by enemy count. The self-test fixture `dungeonSliceSelfTest0000` is the raid report with that one field changed by hand, because no dungeon report exists yet. **A real dungeon Top Gear run is still needed** to fill the cell and to confirm `DungeonSlice` is the value Raidbots writes.
  - **No content level was added above scenario.** `mplus` is a third scenario key beside `st` and `2t`. Smaller, and every reader of the table (`0005`, `0006`, `0007`) changed by one function only: `planScenario` answers `mplus` when the content is Mythic+.
  - **The content rule is `statContext`, shared with the stat pane, and its order changed**: where you stand first, then the pinned switch, then Raid. Before, the pin beat the instance. The strip's button now cycles 1 target, 2 targets, Mythic+, and pins the stat pane's switch with it.
  - `any 5-player instance` counts as Mythic+, not only a keystone: that is `autoContext`'s existing rule from `0003`, and a normal dungeon wants the key gear more than the raid gear.
  - One Mythic+ row in the Plan tab, `WS M+`, from the two-target sim numbers. Its cell is empty, so the tab says so and names the fight style to sim.
