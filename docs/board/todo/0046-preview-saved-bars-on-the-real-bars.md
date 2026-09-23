---
needs: 0044
model: fable  # interface work
---
# 0046 Point at a saved layout and see it on the real bars

## Why

Rob, 2026-09-23: "I wonder if there is a way to preview actionbars for saved actionbars". Offered a
hover list or icons drawn over the real bars, he picked the second: "1 is okay but it lacks
positioning infomation about the bars which is a major visual queue".

## Built, v0.39.0

- Point at **Load bars: build**, **Load bars: spec**, or a list row that says **own bars**. The
  saved layout is drawn over your real action bars: each button shows the saved icon for its slot.
- **Amber edge:** a load changes that slot. A dark square with an amber edge: the load empties it.
- The main bar shows the slot of the form you are in (`button.action`), so in Cat Form you see the
  saved Cat page.
- Move the mouse away and it goes. It also goes in combat, and never shows in combat.
- Click Load while pointing at the button: the amber goes, as the bars now match.
- **Our own frames only.** Each is placed on `UIParent` from the button's `GetRect()` and scale.
  Nothing is written to, parented to or anchored on Blizzard's buttons. Button names are
  `ActionButtonUtil.ActionBarButtonNames` (Shared/ActionButtonUtil.lua:31).
- Icons: spell `C_Spell.GetSpellTexture`, item `C_Item.GetItemIconByID`, macro by name
  (`findMacro`, then `GetMacroInfo`), mount `C_MountJournal.GetMountInfoByID`. Any other kind, or
  one not found, is a question mark.
- `PlanTab.loadKey` is pulled out of `loadBars`, so the hover and the click use one key.
- `barChecks`: 15 new checks on `ghostPlan`, `ghostIcon` and `showGhost`. Six mutations, all red:
  always changed, skyriding page kept, no question mark, no combat fence, macro by index, hide
  keeps the key. The frame drawing is not tested: the harness stubs every frame.

## What I need from you

1. `/reload`, open the talent window. Point at **Load bars: spec**. Pass: icons sit exactly on
   your bars, the same size, on every bar you have shown.
2. Pass: slots that differ have an amber edge. Slots that match have none.
3. Move away. Pass: all of it goes.
4. Point at a row that says **own bars**. Pass: that build's bars show.
5. Change UI scale, or a bar's scale in Edit Mode, and do step 1 again. Pass: still on top.
6. In Cat Form, step 1 again. Pass: the main bar shows the saved Cat page.

## Acceptance

- [ ] WHEN a Load bars button or an "own bars" row is pointed at, THE ADDON SHALL draw that layout's icons over the shown action buttons, amber where a load changes the slot. proves: `..., a slot the load clears is marked`, `..., the same action is not marked`, `..., a macro is matched by name`, `..., shown for a saved layout`
- [ ] WHEN the mouse leaves, or in combat, THE PREVIEW SHALL not show. proves: `..., and hidden`, `..., nothing in combat`
- [ ] THE PREVIEW SHALL never write to Blizzard's action buttons. proves: manual (read `PlanTab.showGhost`)
- [ ] Rob sees the icons line up on his bars in a client.

## Comments

**2026-09-23, adversarial review (review-card), verdict: findings, back to todo.**

No browser and no game client here, so step 4 was replaced by reading the frame code against
Blizzard's source in `wow-ui-source` (branch `live`). Nothing below was seen in a client.

Harness: `offline-check.lua` prints "no FAIL lines" under both Lua 5.1 interpreters. Fifteen
mutations on a `$TEMP` copy. Caught under both: skyriding filter gone, always changed, never
changed, no combat fence, hide keeps the key, no question mark, macro by index, `loadKey` dropping
the build. Survived under both: the seven in finding 2.

Findings:

1. **A slot the load fills is never previewed when its bar hides empty buttons.**
   `ActionBarMixin:UpdateShownButtons` (Blizzard_ActionBar/Shared/ActionBar.lua:198-206) calls
   `SetShown(false)` on an empty button unless the grid is shown ("Always Show Buttons" off). So
   `ghostButtons` drops it through `b:IsVisible()`, and the case the amber edge is there for (the
   load puts something where there is nothing now) draws nothing on that bar. The button still has
   its `action` and its rect. Suggested test: the bar's visibility plus
   `index <= bar.numButtonsShowable` and not `statehidden`, not the button's own `IsVisible`.
2. **Criterion 2's proves do not prove the wiring.** `..., and hidden` calls `hideGhost` directly.
   Taking `hideGhost` out of `sidebarTipOff`, out of the combat `OnEvent`, or out of the `barsChanged`
   re-show all stay green, as do dropping the rect guard, the scale conversion, the `IsVisible`
   filter and the loop that hides frames beyond `#plan`. `sidebarTipOff` is a plain function: a
   check that shows a ghost, calls it and expects `ghostKey` nil costs two lines. `ghostButtons`
   can be checked with stub `_G` buttons.
3. **Two secret-capable reads are unguarded.** `IsVisible` has `SecretReturnsForAspect = Shown` and
   `GetEffectiveScale` has `SecretReturnsForAspect = Scale` (SimpleFrameAPIDocumentation.lua:968,
   381). Only `GetRect` (`SecretWhenAnchoringSecret`) goes through `canRead`. The `pcall` catches the
   error, so the worst case is a preview that stops partway through; per DECISIONS it should still
   go through `canRead`.

What held:
- The placement. `GetRect` is in the button's own scaled units, so `l * ES(button) / ES(UIParent)`
  in UIParent units, anchored at UIParent's BOTTOMLEFT on a scale-1 child, is right for UI scale and
  Edit Mode bar scale.
- `button.action` is Blizzard's own field (`ActionBarActionButtonMixin:UpdateAction`,
  ActionButton.lua:535), and it is set whether or not the button is shown. `ActionBarButtonNames` is the
  eight bars (ActionButtonUtil.lua:31).
- No taint. Only reads (`IsVisible`, `GetRect`, `GetEffectiveScale`, a field) touch Blizzard's
  buttons. The ghosts are plain non-mouse frames on UIParent, so they cannot steal `OnLeave`, and
  showing one in combat could not be blocked anyway.
- Stale frames: `showGhost` hides every pooled frame first.
- `barsChanged` re-show: the redraw only happens while `ghostKey` is set, meaning the mouse is on the
  source. `applyBars` reads back synchronously, so the amber goes after a load.
- Spec change or the talent window closing while pointing: the sidebar hides, and that fires
  `OnLeave` on whatever is under the mouse. That is believed, not seen, and it goes with the in-game
  check.

Fixed in place: `f.bar =CreateFrame` had lost a space in ec07325.

Security: **Weakest point:** the `SavedVariables` layout, which anyone can edit by hand, supplies
`entry.type`/`id`/`name`. An unknown type or an id that does not resolve becomes the question mark,
and nothing from it is executed or written. **Unchecked:** the two secret-capable reads in finding 3.
**Leaks:** nothing. It is all local, the tooltip line carries no data, and a failure only means no
preview.

**2026-09-23** Builder, v0.39.1. All three findings fixed.
1. `ghostButtons` also counts a hidden button when its container is shown.
   `ActionBarMixin:UpdateShownButtons` shows the container while the bar has room for that slot.
   The ghost is then placed on the container.
2. The combat hide is now `PlanTab.sidebarCombat`, so it can be checked. The new checks run on fake
   frames that record what was done to them. They cover:
   - which buttons count;
   - the position and size, in UIParent's scale;
   - the ghost goes on `sidebarTipOff` and on `sidebarCombat`;
   - `barsChanged` redraws, and hides a place that is gone.

   Seven mutations, all red: no container, unguarded `IsVisible`, tip-off keeps the ghost, combat
   keeps it, no redraw, no scale, no leftover hide.
3. `IsVisible` and both `GetEffectiveScale` reads go through `canRead`.

**2026-09-23** Rob, in game, on v0.39.0, with a screenshot in the chat: "That looks great! and
responsive". He pointed at the "own bars" row for Raid: Lost Explorers:
- the icons sat on his real bars;
- slots a load changes had amber edges;
- slots a load empties showed as dark squares.

That covers steps 1, 2 and 4 of What I need from you, and the last criterion. It was seen before
the v0.39.1 fixes.

**2026-09-23, second adversarial review (review-card) of 2b9ce6b, verdict: findings, back to todo.**

No browser and no game client here, so step 4 was replaced by reading the frame code against
Blizzard's source in `wow-ui-source` (branch `live`, 782825221). Rob saw v0.39.0 in game; nothing
from v0.39.1 has been seen in a client.

Harness: `offline-check.lua` prints "no FAIL lines" under both Lua 5.1.5 and 5.4.6. Fifteen
mutations on a `$TEMP` copy, the same result under both interpreters. Caught: no container, container
visibility unguarded, combat keeps the ghost, tip-off keeps it, no redraw, no scale conversion, no
hide before a redraw, hidden button's slot read through its own `IsVisible`, no `SetPoint` (that one
throws rather than FAILs). Survived: the six in findings 1 to 3.

Findings:

1. **The container fix is not proven by its test.** The fake `TestBar2` and its container have the
   same rect (x 200), so placing the ghost on the hidden button instead of the container
   (`frame = b` for `frame = place`) stays green. The point of the fix is to place on the shown
   container, not on the hidden button, and nothing checks it. Fix: give the container a
   different x and check `drawn[2].x`.
2. **The two new scale guards are untested.** Removing `canRead(scale)`, or the
   `if not canRead(top) then return 0 end` line, stays green: no fake returns a secret scale.
   This is the finding 3 fix from the first review. Fix: one fake with a secret `GetEffectiveScale`,
   plus one run with a secret `UIParent` scale.
3. **The fakes are swapped in and back without protection, and the swap itself is a taint risk.**
   - The new block sets `canRead` (the file-local every secret guard uses), `CreateFrame`,
     `UIParent` and `ActionButtonUtil`, then puts them back on line 8256 with no `pcall`.
   - Offline, a throw kills the run, so it is loud there. In a client, `/djbis test` is called
     straight from `SlashCmdList` with no `pcall`. A throw anywhere from line 8220 to 8256 would
     leave all four swapped for the session. `canRead` would then treat a real secret as readable,
     and `CreateFrame`/`UIParent` would stay stub tables.
   - The harness cannot see this. Taking out the restore line, or only its `canRead` part, or
     only its `CreateFrame`/`UIParent` part, stays green.
   - Worse, even when the values are put back, addon code has written to the globals
     `UIParent`, `CreateFrame` and `ActionButtonUtil`. Under WoW's taint model, a global written by
     addon code stays tainted until `/reload`, and Blizzard code that reads it runs tainted. That
     is the class of failure card 0038 is chasing ("Secret values are only allowed during
     untainted execution"). This is reasoning from the taint model, not something seen in a
     client.
   - HANDOVER already warns that `/djbis test` swaps globals such as `InCombatLockdown`. But
     `UIParent` and `CreateFrame` are read by almost every Blizzard file, and `ActionButtonUtil` by
     the action buttons themselves. A `/djbis test` before Rob's 0038 taint log would muddy it.
   - Suggested fix: let the ghost code take its three dependencies through `PlanTab` fields the
     test can swap, for example `PlanTab.ghostNames()`, `PlanTab.newGhost()` and
     `PlanTab.ghostTop()`. Then no Blizzard global and no `canRead` are touched. If a swap remains,
     run the block in a `pcall` and restore after it.
   - Note: `barChecks` already swaps `C_ActionBar`, `C_Spell`, `InCombatLockdown` and
     `db().bars` without a `pcall`, from card 0033. That predates this card and is not a finding
     here, but it belongs on 0038 as a suspect too.

What held:
- **`button.container` is right for all eight bars.** Every name in
  `ActionButtonUtil.ActionBarButtonNames` (ActionButtonUtil.lua:31-40) is a bar inheriting
  `EditModeActionBarTemplate` → `ActionBarTemplate`:
  - `MainActionBar` (MainActionBar.xml:29);
  - `MultiBarBottomLeft`/`BottomRight`/`Left`/`Right` and `MultiBar5`-`7` (MultiActionBars.xml:45-220).
  `ActionBar_OnLoad` (ActionBar.lua:13-34) gives every button a container, including
  `ActionButton1`-`12` through the `MainActionBar` branch. `noSpacers` is false in
  ActionBarTemplate.xml:39. It is true only in `StanceBar.xml` and `PossessActionBar.xml`,
  and neither bar is in the list. So `UpdateShownButtons` (ActionBar.lua:208) shows the container
  for every slot up to `numButtonsShowable`, and the Edit Mode icon count sets that value
  (EditModeSystemTemplates.lua:1064). Icon size is `container:SetScale`
  (EditModeSystemTemplates.lua:1087), and the code reads the container's own
  `GetEffectiveScale`, so the size is right.
- **A hidden button has the right `action` for the form page.** Paging sets `actionpage` on
  `MainActionBar`, and every registered button inherits it (`useparent-actionpage`,
  ActionButton.lua:456). `ActionBarController_UpdateAll` and `ResetToDefault`
  (ActionBarController.lua:143-189) then call `UpdateAction` on every frame in
  `ActionBarButtonEventsFrame.frames`, shown or not. `UpdateAction` (ActionButton.lua:529-535)
  sets `self.action` before any visibility check.
- In a vehicle or override bar, `MainActionBar` is hidden, so `IsVisible` on its containers is
  false and nothing is drawn on the main bar.
- Edge case, noted only: a button hidden by the `statehidden` attribute keeps a shown container,
  so it would be previewed. No Mainline Blizzard code sets `statehidden` on these buttons. Only
  another addon's state driver could.
- The `sidebarCombat` extraction is the same three calls as the old inline handler.

Security: **Weakest point:** `/djbis test` in a client, finding 3. **Unchecked:** a secret
scale (finding 2). **Leaks:** nothing. It is all local, and a failure only means no preview.
