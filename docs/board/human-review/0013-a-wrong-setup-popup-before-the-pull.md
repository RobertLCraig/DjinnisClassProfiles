---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0009, 0011
---
# 0013 A "wrong setup here" popup before the pull

## What I need from you

One trip into The Venomous Abyss as Feral, out of combat, with the build deployed. Nothing here
can be settled from the repository: every frame, anchor and event is unproven until a client
draws it. Report each as seen or not.

1. Load a loadout that is not "WS Raid Most Bosses", walk in. Two seconds after the loading
   screen: a small window titled "The Venomous Abyss: Nek'zali", a Talents line green and red, a
   Switch talents button. Click it: the talent cast bar, then the window goes by itself.
2. With a planned piece in the bags and its slot wearing something else: a red slot line and an
   Equip all button. Click it: the piece goes on, the window goes.
3. Close it with the X, start a ready check: no window. Load a third loadout, ready check: the
   window is back.
4. Close it with the X, leave the instance, walk back in with the same wrong loadout: the window
   is back (a closed answer lasts one visit; fixed in review).
5. Pull Nek'zali with the wrong loadout: the window is gone during the fight and back two seconds
   after a wipe; after a kill it names Entombed Sentinels ("DotC Raid ST *"), or does not show if
   that loadout is loaded.
6. Start a key: no window during it.
7. Drag the window; Escape closes it. The title sits clear of the template's own title bar and
   the first line clear of the inset edge (the frame is `BasicFrameTemplateWithInset`, lines
   start 30 px down; unseen).
8. Log in (not `/reload`) standing inside the raid with the wrong loadout. If no window comes
   after two seconds, the talent configs were not loaded yet at that moment
   (`activeLoadoutName` answers nil, which is "unknown", not "wrong"); the ready check will
   still catch it. Say which happened.
9. At login, any grey line saying `could not register` names an event 12.1 refuses this addon.
10. `/djbis test` in the game: if any `popup` check goes red, the stubbed reads differ from the
    real ones; say which line.

## Why

Rob plays four specs. The plan knows what each place wants: a loadout per boss (`0007`), gear and
enchants (`0005`), and raid or Mythic+ (`0009`). Nothing tells Rob when he walks into a place set up
wrong. He finds out in the pull, or in the log afterwards.

EnhanceQoL's "Wrong talents" popup (`TalentReminder.lua`, read 2026-09-22) and BtWLoadouts'
"activate this?" popup both do this job. EnhanceQoL shows the current build in red, the planned one
in green, and two buttons, Switch and Open Talents. BtWLoadouts waits while you are in combat and says
why ("Waiting for combat to end").

What it costs now: a pull in the wrong build is a lost pull, and Rob's parses show it (SecondBrain
output "2026-09-21 Raid DPS as Feral or Balance": the talent string in use simmed 22% under the plan).

## Links

- Needs `0011`: its Switch talents button is the popup's first button.
- Needs `0009`: which content the place is.
- Uses `0008`'s Equip all, and `0012`'s equipment set if it is built.
- Shares its "what is wrong" test with `0017`, the ready check list. Build one test, not two.

## Not this card

- Finding the boss from a nameplate, target or mouseover. `UnitGUID` is secret under 12.1's identity
  restriction. Map, subzone and `ENCOUNTER_END` only.
- Changing anything without a click.
- Anything inside a running key or a boss fight. 12.1 fences `ChallengeMode` and `Encounter`.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the player enters a raid or dungeon the plan covers, or a ready check starts, and the loadout, a planned slot or an enchant differs from the plan, THE ADDON SHALL show one popup that names the place, what is planned and what is worn. proves: `popup names what differs from the plan here` (the content as built; the frame itself is unseen, see What I need from you)
- [x] WHEN nothing differs, THE ADDON SHALL show no popup. proves: `no popup when the setup matches`
- [x] THE POPUP SHALL have Switch talents, Equip all and Open Plan buttons, and each is shown only when its part differs. proves: `popup buttons follow what differs`
- [x] WHEN the player is in combat, in a running key or in a boss fight, THE ADDON SHALL not show the popup, and SHALL show it when that ends if the player is still in the place. proves: `popup waits for combat, keys and fights`
- [x] WHEN the player closes the popup, THE ADDON SHALL not show it again in that place until the plan's answer for that place changes. proves: `a closed popup stays closed here`
<!-- AC:END -->

## Tasks

- [x] One "what differs here" test, shared with `0017`. `PlanTab.wrongHere(row, active, edited, plan, worn)`, pure.
- [x] Triggers: `ZONE_CHANGED_NEW_AREA`, `ZONE_CHANGED` (subzone), `READY_CHECK`, `ENCOUNTER_END`
  (next boss). A short delay after a zone change, as EnhanceQoL does (2 seconds). Built with
  `PLAYER_ENTERING_WORLD` (2 seconds) in place of the two zone events: an instance is always a
  loading screen, and the next boss comes from `ENCOUNTER_END`, not the subzone.
- [x] Wait-and-retry on `PLAYER_REGEN_ENABLED` and `ADDON_RESTRICTION_STATE_CHANGED`.
- [x] Offline checks under the names above.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md`. Check the restriction names in
`C:\Dev\WoWAddons\wow-ui-source` (`RestrictedActionsConstantsDocumentation.lua`,
`C_RestrictedActions.IsAddOnRestrictionActive`). For the next boss in a raid, the boss table from
`0007` plus the last `ENCOUNTER_END` is enough; do not build BtWLoadouts' subzone-to-boss table
unless the order of bosses is not fixed.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" (every idea gets a card) in a SecondBrain
  session, from other addons' UI. Ideation only. Nothing is built.
- 2026-09-22 Claude, built in a worktree branch, no version bump, not deployed, no frame seen in
  a client. Everything sits in `PlanTab`, no new top-level local (177).
  **What was built.** `PlanTab.wrongHere(row, active, edited, plan, worn)` is the one test: the
  loadout name in play when it is not the row's (the name compare `loadoutState` already does,
  not a talent-string compare; the planned-build decision that holds `0014` and `0023` does not
  touch it), the slots wearing the wrong item (`change`), and the slots wanting an enchant or a
  gem (`fix`). A lower rank of the right thing is not a difference (`0010`). `0017` should call
  it rather than write a second one. `PlanTab.rowHere(bosses, here, killedID)` picks the row: in
  a dungeon the Mythic+ row, in a raid the row after the last kill `ENCOUNTER_END` reported
  (matched through `0027`'s `bossRow`, only a success and only a known id advance it), the first
  row on zone-in, nothing after the last. `PlanTab.fenced()` says why not now: `InCombatLockdown`,
  then `C_RestrictedActions.IsAddOnRestrictionActive` for `ChallengeMode` and `Encounter`
  (`RestrictedActionsDocumentation.lua`, `SecretArguments = AllowedWhenUntainted`; it answers
  false while its own event is being dispatched, so the retry waits two seconds), then
  `C_ChallengeMode.IsChallengeModeActive` and `C_InstanceEncounter.IsEncounterInProgress`.
  `PlanTab.checkSetup()` reads the game and answers what it did (`elsewhere`, `no plan`,
  `fenced`, `matches`, `closed`, `shown`), and `PlanTab.onSetupEvent` routes seven events, each
  registered one at a time and verified with `IsEventRegistered` in `PlanTab.armSetupWatch`
  (from `PLAYER_LOGIN`): `PLAYER_ENTERING_WORLD` (two seconds later, and the boss count starts
  over), `READY_CHECK` (at once), `ENCOUNTER_START` and `CHALLENGE_MODE_START` (take it down,
  keep it pending), `ENCOUNTER_END` (record the kill, two seconds later check for the next
  boss), `PLAYER_REGEN_ENABLED` and `ADDON_RESTRICTION_STATE_CHANGED` (retry when pending).
  The popup names the place (`GetInstanceInfo`'s name, behind `canRead`) and the boss, then one
  line per part: `Talents planned X, now Y`, `Head <what the plan wants>` in red for a wrong
  item, amber for an enchant or gem. Buttons only for the part that differs: Switch talents is
  `PlanTab.loadTalents` (`0011`), Equip all is `PlanTab.equipAll`, which is the Plan tab's own
  Equip all pulled out into one function (the pickups, then `saveSetAndSay` two seconds on,
  `0012`), and Open Plan for what those two cannot do (an enchant, a gem, a piece not owned).
  A click re-judges the popup two seconds later, so it goes when everything matches. Closing it
  (the X or Escape) remembers `PlanTab.setupKey`: place, boss and what differs; the same answer
  is not shown again, a changed one is. The addon taking it down itself remembers nothing.
  **The frame is shared.** `PlanTab.popup(title, lines, buttons, onClose)` is a
  `BasicFrameTemplateWithInset` window (`Blizzard_UIPanelTemplates/Mainline/UIPanelTemplates.xml`)
  named `DjinnisBiSPopup`, movable, on `UISpecialFrames`, drawn by `0020`'s rules: `GameFontNormal`
  title, `GameFontHighlight` lines, `UIPanelButtonTemplate` buttons at `PlanTab.SIZE.button` high,
  130 wide, in a row along the bottom. `lines` are strings with their colour codes, `buttons` are
  `{ label, tip, onClick }`, `onClose` runs on the X or Escape and not on `PlanTab.hidePopup()`.
  Card `0024` should call `PlanTab.popup` with its own lines and buttons rather than build one;
  one frame, whichever card shows last wins it, which is what "shares its window" asks for.
  **Checks.** `lua offline-check.lua` (5.4) and `C:\Program Files (x86)\Lua\5.1\lua.exe` both
  exit 0. 61 checks in one `do` block in `selfTest` under the five `proves:` names, driving
  `checkSetup` through the stubbed worn gear, instance, loadout name, bags and fences the other
  blocks use, every global put back after. `PlanTab.readWorn` was added for the checks alone:
  `selfTest` sits at Lua 5.1's 60-upvalue limit and one more local reference broke the 5.1 run.
  **Mutations**, each in a temp copy, each red on its own checks: the combat fence deleted (3
  red on the popup, and 3 on the Talents button, which shares the line); the closed key
  forgotten (2 red); a kill never advancing the boss (4 red).
  **What a person must look at, in the game, Feral, out of combat.** (1) Load a loadout that is
  not "WS Raid Most Bosses", walk into The Venomous Abyss: two seconds after the loading screen
  a small window, "The Venomous Abyss: Nek'zali", a Talents line in green and red, a Switch
  talents button. Click it: the talent cast bar, then the window goes by itself. (2) With a
  planned piece in the bags and its slot wearing something else: a red Head (or whichever)
  line and an Equip all button; click it, the piece goes on, the window goes. (3) Close it
  with the X, start a ready check: no window. Change loadout to a third one, ready check: the
  window is back. (4) Pull Nek'zali with the wrong loadout: the window is gone during the
  fight and back two seconds after a wipe; after a kill it names Entombed Sentinels (whose
  loadout is "DotC Raid ST *"), or does not show if that loadout is the one loaded. (5) Start a
  key: no window during it. If `/djbis test` in the game goes red on any `popup` check, the
  stubbed reads differ from the real ones; say which. (6) Drag the window; Escape closes it.
  (7) At login, any grey line saying `could not register` names an event 12.1 refuses this
  addon, and that part will not fire.
  **Left out, and why.** `ZONE_CHANGED_NEW_AREA` and `ZONE_CHANGED`: an instance is a loading
  screen (`PLAYER_ENTERING_WORLD`) and the next boss is the last kill, not a subzone, as the
  Plan asks. A subzone-to-boss table: not built, per the Plan; the cost is one popup naming
  Nymrissa Wavecaller (a lair row, last in the table) after Ula'tek dies, marked `ponytail:` in
  `rowHere`. Anything for a spec without a boss table (only Feral has one): `rowHere` answers
  nil and nothing shows. Bosses in a raid without a loading screen between wings: not a case
  here. The bag glow and the Plan tab are untouched beyond Equip all moving into `equipAll`.
  **Edit Mode:** a popup that shows itself is not a HUD element and is not registered; it is
  movable by drag and clamped to the screen.
- 2026-09-22 Claude, adversarial review in a worktree. **Attacked.** Every Blizzard call against
  `wow-ui-source` `Blizzard_APIDocumentationGenerated`: `C_RestrictedActions.IsAddOnRestrictionActive`
  and `ADDON_RESTRICTION_STATE_CHANGED` (`RestrictedActionsDocumentation.lua`, the "always false
  during dispatch" note is real and the two-second retry is the right answer to it),
  `Enum.AddOnRestrictionType` Encounter 1 and ChallengeMode 2 (`RestrictedActionsConstantsDocumentation.lua`),
  `ENCOUNTER_START` and `ENCOUNTER_END` payloads (`EncounterInfoDocumentation.lua`: id, name,
  difficulty, size, success, and the code's `(event, id, name, _, _, success)` matches),
  `READY_CHECK` (`PartyInfoDocumentation.lua`, flagged `SecretInChatMessagingLockdown`; its
  payload is never touched, so nothing to guard), `CHALLENGE_MODE_START` and
  `C_ChallengeMode.IsChallengeModeActive`, `C_InstanceEncounter.IsEncounterInProgress`,
  `GetInstanceInfo` (`InstanceDocumentation.lua`), `InCombatLockdown`. None is deprecated. No
  `C_Secrets.Should*BeSecret` predicate exists for any of these reads (`SecretPredicateAPIDocumentation.lua`
  lists 26, all unit, aura, cooldown and totem), so `canRead` after the read is the whole guard
  and it is on every game string and number that is compared: the instance name, the loadout
  name, `ENCOUNTER_END`'s id, name and success, every worn link. Escape and the X both reach
  `frame:Hide()` (`UIParentPanelManager.lua` `CloseSpecialWindows`, `UIPanelCloseButtonDefaultAnchors`),
  so `OnHide` runs `onClose` on both and `hidePopup` clears it first; checked, not assumed.
  The fence at the wrong moment: `PLAYER_ENTERING_WORLD` and `ENCOUNTER_END` both wait two
  seconds and `checkSetup` re-asks `fenced()` itself, `READY_CHECK` asks at once, which is right
  because nothing is dispatching. Each of the 61 checks' names was matched to a criterion; the
  builder's three mutations were read, and two more were run here (below). **Held:** the five
  criteria as written, the 200-local and 60-upvalue limits (no new top-level local, nothing new
  captured by `selfTest`), `PlanTab.wrongHere` and `PlanTab.popup` signatures untouched for
  `0017`. **Broke, fixed in place, each red on its own check before green:** (1) a closed answer
  outlived the visit: leave the raid, come back the next night with the same wrong loadout, no
  popup, which is the exact case in `## Why`; `PLAYER_ENTERING_WORLD` now forgets
  `popupClosed` with `lastKill` (check "a fresh zone-in forgets the closed answer"). (2)
  `checkSetup`'s "elsewhere", "no plan" and "matches" hid whatever was on the shared frame,
  so a ready check in a city would have taken down `0024`'s spec prompt or `0017`'s list;
  `PlanTab.hideSetup` hides only a popup this card put up (`popupModel.setup`; check "another
  card's popup on the shared frame is left up"). Both checkers exit 0 under 5.4 and 5.1.
  **Not fixed, said:** a login inside the raid may read no loadout name two seconds in and show
  nothing until the ready check (look 8); `rowHere`'s Nymrissa-after-Ula'tek is the builder's
  marked ponytail. **Security:** weakest point is the frame's `OnHide` running a closure the
  addon set, which only records a string; unchecked path is none, every event payload is behind
  `canRead` before a compare; it leaks nothing, nothing leaves the client. **Browser:** none, this
  is a game frame, and the ten looks above are what a client must answer, so the card goes to
  `human-review/`, not `done/`.
