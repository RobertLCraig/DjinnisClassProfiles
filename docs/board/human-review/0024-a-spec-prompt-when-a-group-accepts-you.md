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
- [ ] THE PROMPT SHALL have one button that changes spec, then loads the planned loadout, then equips the planned set, out of combat only. proves: manual (built; `set up changes spec, then loadout, then set, out of combat` proves the order and the combat guard against stubs, only the game proves the changes)
- [x] WHEN the current spec already fits the role, THE PROMPT SHALL offer only the loadout and gear parts that differ, or not show at all. proves: `no prompt when spec, loadout and gear already fit`
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

## What I need from you

Out of combat, on a druid, none of it seen in a client:

1. Apply to a Mythic+ listing as Healer while Feral and get accepted: a small "Group joined" window
   names Healer, the dungeon and "Plan: Resto, Mythic+", with Set up and Not now. Escape closes it;
   it drags; the text does not run under the buttons.
2. Set up: the spec changes, then (if a Resto Mythic+ cell exists) the loadout loads and the set
   equips, one grey chat line for each set not saved. If Blizzard's frame says "commit in progress"
   after the spec change, the one-second wait in `PlanTab.onGroupEvent` is short: say so here.
3. Taint: after Set up, pull a target dummy and press every bar button for 30 seconds. An
   `ADDON_ACTION_FORBIDDEN` or "blocked from an action only available to the Blizzard UI" at the
   click means the `HasRestrictions` helpers are closed to addons and the prompt must open the
   Specializations tab instead.
4. Accepted as Damage while Feral with the Mythic+ loadout loaded and the set on: no window.
5. The same with the raid loadout loaded: a window offering only the loadout.
6. Set up, then change spec by hand to a third spec before the first lands: nothing more happens,
   and later spec changes do nothing.
7. Set up while in combat, then have a party member change spec before combat ends: nothing until
   combat ends, then the spec change once.
8. If the role reads as nil (nothing shows, nothing in chat), `GetApplicationInfo`'s fifth return has
   moved; the read in `PlanTab.onAccepted` is the place.
