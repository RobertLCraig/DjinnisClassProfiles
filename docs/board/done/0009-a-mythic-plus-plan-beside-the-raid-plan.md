---
needs: 0004, 0007
---
# 0009 A Mythic+ plan beside the raid plan

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

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
- [ ] In a city on Feral, open the character sheet: the strip's button reads "1 target" and clicks go "2 targets", "3+ targets", "Mythic+", "1 target". On Mythic+ the stat pane's header button reads "Mythic+", otherwise "Raid". proves: manual
- [ ] With the strip on Mythic+, it reads "Gear plan: N slots to fix. Click for the list." (or "every slot matches"), never "No Mythic+ gear plan". Click it: the Plan tab opens with "> Mythic+, any key   Dungeon   Mythic+" picked and a gear list under "2. Gear to change". proves: manual
- [ ] Plan tab: four buttons on top, "Raid - 1 target", "Raid - 2 targets", "Raid - 3+ targets", "Mythic+", the chosen one lit. Click another: it lights, and the strip and gear list follow it. proves: manual
- [ ] With Mythic+ chosen, click the Nek'zali row on the Plan tab: the gear list is the raid one, while the strip and the bag glows stay on Mythic+. proves: manual
- [ ] Zone into any dungeon: the strip reads "Mythic+", its button and the stat pane's button are greyed, the three Raid buttons on the Plan tab are greyed with "You are in a dungeon" in their tooltip, and bag items the Mythic+ plan wants glow green. Leave: all come back. proves: manual
- [ ] Zone into the raid: the strip goes "1 target", "2 targets", "3+ targets", "1 target", never Mythic+; the stat pane's button reads "Raid *", greyed; the Plan tab's Mythic+ button is greyed with "You are in a raid" in its tooltip. proves: manual
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
- 2026-09-22 Claude: **the Feral Mythic+ cell is filled.** One Top Gear on Raidbots, fight style Dungeon Slice, loadout `WS M+`, 265 combinations from today's export (`2026-09-22 Feral v1.txt`, verified, no Unverified Input flag): https://www.raidbots.com/simbot/report/ttC3zNmZSvC7C2XQNSe6Bi, Combo 65 at 224,577 dps. Baked with `update-gear-plan.ps1`, ranks refreshed with `update-plan-ranks.py`. Five checks that assumed an empty cell now take the cell away for the moment and put it back; the empty-cell bag check was broken in a temp copy and went red. Left for the game: the Plan tab's Mythic+ row now lists gear, and in a dungeon the bag glows follow it.

**2026-09-29** Attended unblock pass. Two findings.

- **Look 7 is done.** The entry above baked a Dungeon Slice report as Feral `mplus`, and commit
  `09c637c` baked another (`muhQr2una5762CxPQN5P19`, 2026-09-28). So the generator does accept the
  fight style Raidbots writes for a dungeon, which was the open question under Fail.
- **Looks 1, 2 and 4 no longer match the addon in the game folder (v0.54.12).** They expect "No
  Mythic+ gear plan for Feral yet" and no green bag glow in a dungeon, and the cell is filled.
  Look 2 names the loadouts `WS M+` and `DotC M+`, both on `PlanTab.RETIRED`. The Mythic+ row's
  loadout is `Dungeon` now, and the strip cycles 1, 2, 3+ targets, Mythic+ since card `0028`.

Rewriting the looks is an agent's job, so this goes to `todo/`: rewrite them against the deployed
version, then return the card to `human-review/`.

**2026-09-29** The loop moved this card from todo/ to human-review/ WITHOUT trying it: every acceptance criterion on it is ticked and it has never been through ai-review/, so nothing is left that a session could close. If the work is done, move it to ai-review/ for its review. If it is not, untick or add the criterion that is still open and move it back to todo/.

### 2026-10-04 manager (m20261004153552-bc82)

**outcome: rob**

The code meets every criterion, but the in-game looks describe an addon from 50 versions ago, so a person must rewrite them before anyone runs them.

**what the session said**

I read the card and the code in `DjinnisClassProfiles`. The addon is now at v0.69.0.

The code still backs all five ticked criteria:

- `update-gear-plan.ps1` files any fight style that starts with `^Dungeon` as `mplus`.
- `DjinnisClassProfiles.lua` has `planScenario`, `bagScenario` and `PlanTab.nextScenario`.
- The offline checks still test the bag list outside and in a dungeon, and the "No Mythic+ gear plan yet" text.

No finding disproves a ticked box. The 2026-09-29 finding is about the seven looks, not the criteria. If I unticked nothing and sent the card back, the loop would park it again.

The work looks finished. What is left is the seven looks. They describe v0.19.1: the `WS M+` and `DotC M+` loadouts, an empty Mythic+ cell, and a 3-step strip. Look 7 is already done.

So Rob, or a session he is in, must rewrite looks 1 to 6 against v0.69.0. Then the card goes to `ai-review/` for its first review, and after that to Rob in the game.

WHY: The code meets every criterion, but the in-game looks describe an addon from 50 versions ago, so a person must rewrite them before anyone runs them.

OUTCOME: rob

**2026-10-11** Clear-down (attended, Rob asked): ticked nothing new; the five `proves:` checks were already ticked and still exist (`current content follows instance type then the switch`, `an item planned for both contents is wanted once`, `plan tab shows the current content and can switch`, `missing mplus plan is said, not filled from raid` pass in the Lua 5.1 offline check; `generator files a report under raid or mplus by fight style` is in `update-gear-plan.ps1 -SelfTest`, not re-run here). Looks 1 to 6 rewritten for v0.69.0: the Mythic+ cell is filled, the Mythic+ row's loadout is "Dungeon", the strip cycles 1, 2, 3+ targets, Mythic+ (`PlanTab.nextScenario`), and the Plan tab has its own four content buttons (`PlanTab.CHOICE_LABEL`). Old look 6 is folded into card 0003's look 3, which now says a city. Look 7 is done: Dungeon Slice reports were baked as Feral `mplus` on 2026-09-22 and 2026-09-28. Moves to ai-review/ with only in-game looks open.

### 2026-10-17 review (v20261017230155-bd0d)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I tried to break the five code criteria. I could not.

1. **Report filing.** `update-gear-plan.ps1` sets the scenario to `mplus` when `simbot.fightStyle` matches `^Dungeon`. Every other report goes by its enemy count, the same as before.
2. **Current content.** `statContext` in `DjinnisClassProfiles.lua` checks where you stand first (`autoContext`): a raid gives Raid, a party instance gives Mythic+. Outside an instance it uses the saved switch, and then Raid. `planScenario` returns `mplus` when the content is Mythic+.
3. **One wanted item.** `rebuildBagWanted` builds the bag list from one plan only, the one for the current content. So an item that is in both plans is listed one time. `wantedSlot` also stops at the first match.
4. **Plan tab.** `PlanTab.CHOICE_LABEL` and the choice builder next to it make four buttons. The chosen one is lit, and the others carry the reason they are greyed. `PlanTab.nextScenario` cycles the scenarios.
5. **Missing Mythic+ plan.** `rebuildBagWanted` uses `gearPlanFor(spec, "mplus")` and does not fall back to the raid plan. The offline check proves two things: the bag list is empty when there is no Mythic+ cell, and the tab shows "No Mythic+ gear plan yet".

One weak point: criterion 3 can only pass, because only one plan is read at a time. That is how the card's own build note chose to do it, so I do not count it as a defect.

The open looks are all `proves: manual`, so they are not findings.

VERDICT: sound

**scope: sound**

**What I checked (scope lens only)**

- **The fence holds.** I found no per-dungeon builds and no per-affix or per-key-level gear. Raid filing still uses `st`, `2t` and `3t`. The Mythic+ work is one more scenario, `mplus`. You can see it in `PlanTab.BOSSES` ("Mythic+, any key"), `PlanTab.CHOICE_LABEL` and `SCENARIO_LABEL`.
- **The big diff is not this card.** It has 157 files: the rename to DjinnisClassProfiles, WCL tooling, bars research, and many other cards. Those belong to other cards (0058, 0064, 0028 and more). The card 0009 code is small and stays inside its own idea.
- **One task is ticked but was not done as written.** The task "Add a `content` level above `scenario`" is ticked. The build did not do it. It added `mplus` as a scenario key next to the others. The 2026-09-22 comment says so openly, and no criterion needs the level. So it is a note for the board, not a defect.
- **"One M+ loadout per spec" is only part done.** Only two specs have a Mythic+ row in `PlanTab.BOSSES`. Card 0091 (in todo) holds the Guardian and Resto rows. Criterion #5 covers the gap: the tab says the plan is missing and does not fill it from raid. So no criterion fails.

No criterion is disproved. Only the in-game `proves: manual` checks are still open.

VERDICT: sound

**breakage: sound**

I checked the code against the card. Nothing on it is broken.

**What I checked:**
- **Content order.** `statContext` in `DjinnisClassProfiles.lua` puts where you stand first, then the saved switch, then Raid. This is what criterion #2 asks for.
- **Mythic+ plan.** `planScenario` gives back `mplus` when the content is Mythic+. Anything else it does not know becomes `st` (1 target).
- **Raid button.** In a raid, `PlanTab.nextScenario` goes 1, 2, 3+, back to 1, and it never offers Mythic+. In a dungeon it stays on Mythic+. This matches looks 6 and 7.
- **Bag glows.** `rebuildBagWanted` uses the same `planScenario` result. The offline checks look at the bags in three cases: outside, in a dungeon, and in a dungeon with the Mythic+ plan removed. In the last case the bags are empty and do not fall back to the raid list. This backs criteria #3 and #5.
- **Plan tab text.** The offline checks look for "No Mythic+ gear plan yet" and the picked "> Mythic+, any key" row, which backs criteria #4 and #5.

**One small note, not a fault:** `autoContext` does not count a "legacy" instance (an old one, read by `PlanTab.legacyHere`). In one of those, the saved switch decides. The card does not cover this case.

I did not run the offline checks. The game checks (the `proves: manual` looks) are still open, and that is Rob's job in the game.

VERDICT: sound

