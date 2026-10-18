---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0009, 0011, 0012
---
# 0024 A spec prompt when a group accepts you

## Why

Rob tanks, heals and deals damage. When a group finder listing accepts him as a healer for a key,
he has to change spec, loadout and gear by hand before the group is ready. KeystoneLoot and
Keystone Polaris both show a "group joined" popup (on `LFG_LIST_APPLICATION_STATUS_UPDATED`) with
the dungeon and the role; neither changes the setup.

## Links

- Needs `0009` (the Mythic+ plan), `0011` (load the loadout), `0012` (the equipment set).
- Shares its window with `0013` if both would show.
- Draws by `0020`'s rules.

## Not this card

- Changing anything without a click.
- Raid invites. Group finder acceptance only.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN a group finder application is accepted and the role given needs another spec than the current one, THE ADDON SHALL show a prompt naming the role, the place and the planned spec. proves: `prompt names role, place and spec on acceptance`
- [ ] THE PROMPT SHALL have one button that changes spec, then loads the planned loadout, then equips the planned set, out of combat only. Look: `/reload` first (the game folder holds v0.69.0). As Guardian, out of combat, get accepted as Damage to a Mythic+ listing: the `Group joined` window lists `Change spec to Feral`, `Load loadout "Dungeon"`, `Equip set DBiS Feral M+`. Click Set up: the spec changes to Feral, then `Dungeon` loads, then the set equips (one grey chat line if the set is not saved), with no "commit in progress" error. proves: manual
- [x] WHEN the current spec already fits the role, THE PROMPT SHALL offer only the loadout and gear parts that differ, or not show at all. proves: `no prompt when spec, loadout and gear already fit`
- [ ] As Feral, get accepted as Healer to a Mythic+ listing: a `Group joined` window reads `Healer for <dungeon>`, `Plan: Resto, Mythic+`, `Change spec to Resto`, with Set up and Not now (no loadout or set line: Resto has no plan). Escape closes it, it drags, the text clears the buttons. Nothing at all means the role read as nil. proves: manual
- [ ] After a Set up, pull a training dummy and press every bar button for 30 seconds: no `ADDON_ACTION_FORBIDDEN` and no "blocked from an action only available to the Blizzard UI". proves: manual
- [ ] As Feral with `Dungeon` loaded and the `DBiS Feral M+` set on, get accepted as Damage to a Mythic+ listing: no window. proves: manual
- [ ] As Feral with a raid loadout loaded (say `Raid: Nek'Zali`) and the M+ set on, accepted as Damage to Mythic+: a window offering only `Load loadout "Dungeon"`. proves: manual
- [ ] Click Set up, then change spec by hand to a third spec before the first lands: nothing more happens, and later spec changes do nothing. proves: manual
- [ ] Click Set up in combat, then have a party member change spec before combat ends: nothing until combat ends, then the spec change once. proves: manual
<!-- AC:END -->

## Tasks

- [ ] **Test first, by hand, in the game:** can an addon change spec? Try
  `/run ClassTalentHelper.SwitchToSpecializationByName("Restoration")` out of combat, the same route
  as `0011`. If it taints, the prompt opens the spec tab instead. Not done: no client here. The build
  goes by index (`SwitchToSpecializationByIndex`) and falls back to opening the Specializations tab.
- [x] Role and place from `C_LFGList.GetApplicationInfo` and the listing. Check the names in `wow-ui-source`.
- [x] The three steps wait for each other: spec change finishes, then loadout, then gear.
- [x] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "B" in a SecondBrain session. Ideation only.
- 2026-09-22 Claude, built in a worktree; no frame seen in a client. Everything sits in `PlanTab`,
  no new top-level local (177). **What it does.** A watcher armed at `PLAYER_LOGIN`
  (`PlanTab.armGroupPrompt`) registers `LFG_LIST_APPLICATION_STATUS_UPDATED`,
  `PLAYER_SPECIALIZATION_CHANGED`, `TRAIT_CONFIG_UPDATED` and `PLAYER_REGEN_ENABLED` one at a time,
  each verified with `IsEventRegistered`. On the first event with the new status `"inviteaccepted"`
  (`PlanTab.onAccepted`) the role is the fifth return of `C_LFGList.GetApplicationInfo`, read the way
  Blizzard's own invite dialog reads it (`LFGList.lua`, `LFGListInviteDialog_Show`); that function
  is not in the generated docs, so the call is `pcall`'d and the role goes through `canRead` before
  it is compared. The place is `GetActivityInfoTable(...).fullName` of the listing's first activity
  and `isMythicPlusActivity` picks the Mythic+ cell; the event's `groupName` is a kstring and is
  never read. The role maps to a spec through `PlanTab.ROLE_SPECS` (Tank Guardian, Healer Resto,
  Damage Feral or Balance: the current one if it is one of them, else the first with a plan cell).
  `PlanTab.setupSteps` is pure and says which of spec, loadout and set differ; a spec change carries
  the other two, the same spec offers only what differs, and nothing differing means no prompt. The
  prompt is `PlanTab.prompt(title, lines, buttons)`, one small `BasicFrameTemplateWithInset` frame,
  draggable, `GameFontNormal` title and `GameFontHighlight` lines, buttons at `PlanTab.SIZE.button`.
  Set up runs `PlanTab.setupStep`: out of combat only, the spec change through
  `ClassTalentHelper.SwitchToSpecializationByIndex` (the index from `GetSpecializationInfo(i)` against
  `SPEC_BY_ID`, so no name and nothing that could be secret), then on `PLAYER_SPECIALIZATION_CHANGED`
  one second later the loadout through card 0011's `PlanTab.loadTalents`, then on the next
  `TRAIT_CONFIG_UPDATED` the set through `C_EquipmentSet.UseEquipmentSet` by card 0012's name. A set
  nobody saved gets one grey line. `UseEquipmentSet`, `SetSpecialization` and `GetActivityInfoTable`
  were read from the generated docs; none is protected or marked secret-returning. No `C_ClassTalents`
  or `C_SpecializationInfo` write is called from this file. **Checks**, all in `selfTest`: the two
  names on the card, `set up changes spec, then loadout, then set, out of combat` (combat waits, a
  talent update during the spec change asks nothing, no helper opens the Specializations tab and
  drops the rest, a set nobody saved is said and not equipped) and `the prompt frame builds with its
  buttons`. `lua offline-check.lua` (5.4) and the game's 5.1 both exit 0. **Mutations, each in a temp
  copy:** combat guard removed (3 red), `setupSteps` never nil (4 red), the talent update stepping
  during the spec change (4 red), the status compared to `"invited"` (12 red), the
  `UseEquipmentSet` call dropped (3 red).
  **What a person must look at, out of combat, on a druid, none of it seen in a client:** (1) apply
  to a Mythic+ listing as Healer while Feral and get accepted: a small "Group joined" window should
  name Healer, the dungeon and "Plan: Resto, Mythic+", with Set up and Not now; (2) Set up: the spec
  changes, then if a Resto Mythic+ cell exists the loadout loads and the set equips, with one chat
  line for each set that is not saved. If Blizzard's frame says "commit in progress" after the spec
  change, the one-second wait in `PlanTab.onGroupEvent` is short: say so on this card; (3) the
  taint question from the card's own task, the same as 0011's: after Set up, pull a target dummy and
  press every bar button for 30 seconds; (4) get accepted as Damage while Feral with the Mythic+
  loadout loaded and the set on: no window at all; (5) the same with the raid loadout loaded: a
  window offering only the loadout; (6) if the role reads as nil (nothing shows and nothing in chat),
  `GetApplicationInfo`'s fifth return has moved, and the read in `PlanTab.onAccepted` is the place.
  **Left out and why:** the hand test of `SwitchToSpecializationByName` (no client; the build goes
  by index and opens the Specializations tab when the helper is missing); a raid listing's
  scenario is the Plan tab's own raid cell rather than a guess from the listing; a saved choice
  between Feral and Balance for Damage, because the current spec wins when it is one of them and
  the plan cell decides otherwise; Edit Mode for the prompt, the same as the main window, which is
  dragged; and the shared frame with card 0013, built at the same time in another worktree: once
  both are merged the two prompts should be one frame, and `PlanTab.prompt(title, lines, buttons)`
  is the shape this side offers.
- 2026-09-22 Claude, adversarial review in a worktree; no client, so the card goes to
  `human-review/`, not `done/`. **Attacked:** every criterion's named check, run and then broken in a
  temp copy; every Blizzard call in `onAccepted`, `setupStep`, `onGroupEvent` and `prompt` against
  `wow-ui-source` (generated docs first, then `LFGList.lua`, `ClassTalentHelper.lua`,
  `PlayerSpellsUtil.lua`); the three 12.1 traps. **Held:** the event payload is as documented
  (`searchResultID`, `newStatus` cstring, `oldStatus`, `groupName` kstring, never read); the fifth
  return of `GetApplicationInfo` is the role, exactly as `LFGListInviteDialog_Show` reads it, and it
  is `pcall`'d and `canRead` before the table lookup; `GetSearchResultInfo` is marked
  `SecretInChatMessagingLockdown` and `GetActivityInfoTable` `SecretArguments`, both are `pcall`'d and
  `fullName` / `isMythicPlusActivity` go through `canRead` before any compare; the four events are
  registered one at a time after `SetScript` and each verified; the spec index comes from
  `GetSpecializationInfo` against `SPEC_BY_ID`, so no name reaches the helper; `UseEquipmentSet`
  takes our own set id; nothing writes without the click. **Broke, and fixed here, one guard each,
  checks added under `set up changes spec, then loadout, then set, out of combat`:** (1)
  `PLAYER_SPECIALIZATION_CHANGED` carries a unit and fires for party members too (Blizzard's
  `ClickBindingUI` filters on `"player"`, `EditModeManager` uses `RegisterUnitEvent`); a party
  member's spec change during a pending setup re-asked our spec change a second later. Now only
  `"player"` counts (mutation: 8 red). (2) A spec change the game refused, or one Rob answered by
  going to a third spec by hand, left `pendingSetup` live for ever: `PLAYER_REGEN_ENABLED` re-asked
  the spec change after every pull, and the next spec change hours later ran the rest. Now combat
  ending resumes only a step combat held (`steps.waiting`; 5 red), and our spec landing anywhere but
  `steps.target` drops the setup with `"abandoned"` (4 red). Both interpreters exit 0 after.
  **Security.** Weakest: the click hands writes to `ClassTalentHelper`, whose two functions call
  `C_ClassTalents.SwitchToSpecializationByIndex` and `SwitchToLoadoutByName`, both `HasRestrictions
  = true` in `ClassTalentsDocumentation.lua`; whether an addon's call taints the spec frame is the
  same open question as card 0011 and only look (3) below answers it. Unchecked: the event's
  `searchResultID` reaches `GetApplicationInfo` and `GetSearchResultInfo` as given, but only inside
  `pcall`, and every value out is `canRead` before use; the loadout and set names are the addon's own
  constants. Leaks: the prompt shows the role and the activity's full name; a failure prints one grey
  chat line naming a set the player has not saved; no id, no group name, no stack.
  **Not proven here:** the frame's height, anchors and button row, the one-second wait, and the
  helpers' taint. Listed below.

**2026-10-11** Clear-down (attended, Rob asked): ticked 2 criteria, all ticked already and confirmed (checks `prompt names role, place and spec on acceptance`; `no prompt when spec, loadout and gear already fit` exist in `DjinnisClassProfiles.lua` and pass in the Lua 5.1 offline check); looks rewritten for v0.69.0 against `PlanTab.offerSetup`: only Feral has a gear plan, so the full spec, loadout, set chain is now looked at as Guardian accepted as Damage (the manual criterion carries it), and the Healer look shows only the spec step; the role-nil diagnosis folded into that look. The hand-test task (`SwitchToSpecializationByName`) stays open as a task: the build goes by index and the taint look answers it; moves to ai-review/ with only in-game looks open.

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

### 2026-10-19 review (v20261019003153-f2ea)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I checked each criterion in `DjinnisClassProfiles.lua`. I did not run the code or the offline check.

**#1, prompt on acceptance: met.**
- `PlanTab.armGroupPrompt` starts the watcher at login (wrapped in `pcall`).
- `PlanTab.onAccepted` acts only on the status `"inviteaccepted"`. It reads the role (fifth return of `GetApplicationInfo`) and the place (`fullName`).
- `PlanTab.offerSetup` shows the window. Its lines are "Healer for <place>", "Plan: Resto, Mythic+" and "Change spec to Resto".
- The check `prompt names role, place and spec on acceptance` is in `selfTest`.

**#3, only what differs, or no prompt: met.**
- `PlanTab.setupSteps` adds the loadout or set step only when it differs from what you have now.
- It returns nil when nothing differs, and then `offerSetup` shows nothing.
- The check `no prompt when spec, loadout and gear already fit` is in `selfTest`.

**#2 and the other open criteria are manual looks.** The code for them is there:
- `PlanTab.setupStep` runs the steps in order: spec, then loadout, then set. It waits while you are in combat.
- `PlanTab.onGroupEvent` only counts the player's own spec change. A spec change to a third spec drops the setup ("abandoned"). The end of combat starts a step again only if combat held that step.
- Nothing I read shows that a manual criterion cannot pass.

VERDICT: sound

**scope: sound**

**What I checked.** I compared the card with the code in `DjinnisClassProfiles.lua`. I looked at `PlanTab.onAccepted`, `PlanTab.offerSetup`, `PlanTab.setupStep`, `PlanTab.onGroupEvent` and `PlanTab.armGroupPrompt`.

**The fence ("Not this card"):**
- **No change without a click.** `PlanTab.offerSetup` changes nothing by itself. All changes start in the "Set up" button's `onClick`. "Not now" does nothing.
- **No raid invites.** Only `LFG_LIST_APPLICATION_STATUS_UPDATED` with status `"inviteaccepted"` starts the prompt. No party or raid invite event is registered.

**Growth.** The diff shows 164 files. That is the whole branch, so it carries many other cards. The part for card 0024 did not grow past its card. One added thing is in `PlanTab.setupStep`: it waits while `PlanTab.tagging` or `PlanTab.swapping` runs. Reviews of cards 0059 and 0063 asked for this wait. It keeps the card's own order (spec, then loadout, then set), so it is not scope creep.

**Half done.** The build comment said the frame shared with card 0013 was left out. The code now has one shared frame, `PlanTab.prompt`, and many prompts use it. So the "Links" promise is kept.

I found no criterion that is not met. The open criteria are all `proves: manual`.

VERDICT: sound

**breakage: defect**

I checked the setup chain in `DjinnisClassProfiles.lua`. I found one break.

**Finding: the set can go on before the loadout lands.**

- In `PlanTab.setupStep`, only a `"loaded"` answer from `PlanTab.loadTalents` stops the chain to wait for `TRAIT_CONFIG_UPDATED`.
- Since card 0040, `PlanTab.loadTalents` can hand the job to `PlanTab.wearSpare`. That happens when a build has no saved loadout of its own.
- `PlanTab.wearSpare` gives other answers: `"worn"` (a loadout switch is sent and is in flight), `"tidying"` (the switch comes later, after the queue), `"waiting"` (it waits for the talent window to close), or an import.
- `setupStep` reads each of these as "missing" and calls `UseEquipmentSet` in the same frame. So the gear goes on while the talent change is still pending, or before it even starts.
- The comment in `setupStep` says only "missing or no helper" falls through. Card 0040 made that comment false.
- The self-test stubs `loadTalents`, so no check builds the spare path.

The other parts held:
- The party-member filter on `PLAYER_SPECIALIZATION_CHANGED`.
- Abandoning the setup when you land on a different spec.
- Resuming after combat only for a step that combat held.
- Resuming through `afterTagging` once the tagging/swap queue ends.

UNMET: #2 when the planned loadout goes through card 0040's spare path, `setupStep` does not wait for `loadTalents` to finish, so the set is equipped before the loadout lands and the spec-then-loadout-then-set order cannot hold.

VERDICT: defect

**acceptance**

- **#2 was named by the breakage lens and is not a ticked criterion here**, so nothing was changed: when the planned loadout goes through card 0040's spare path, `setupStep` does not wait for `loadTalents` to finish, so the set is equipped before the loadout lands and the spec-then-loadout-then-set order cannot hold.

