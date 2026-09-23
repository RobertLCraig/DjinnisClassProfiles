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
