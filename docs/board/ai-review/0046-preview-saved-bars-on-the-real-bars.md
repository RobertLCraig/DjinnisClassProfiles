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
