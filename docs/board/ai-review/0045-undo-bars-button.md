---
needs: 0044
---
# 0045 An Undo bars button

## Why

Rob, 2026-09-23, after the Load bars buttons: "an undo button sounds eminently useful!"

## Built, v0.37.1

- A third row under the Load bars buttons: **Undo bars**, full width. It calls
  `PlanTab.undoBars`, the same as `/djbis bars undo`.
- It is greyed while this character has nothing to undo (`PlanTab.canUndoBars`). The list redraws
  after each save, load and undo (`PlanTab.barsChanged`), so the button follows at once.
- The list ends one more button higher to make room.
- `barChecks`: 2 new checks. "Always on" turns one red.

## What I need from you

1. `/reload`, open the talent window. Pass: **Undo bars** is greyed.
2. Click **Load bars: spec**. Pass: **Undo bars** lights up. Click it: the bars go back, and it
   greys again.
3. Pass: the list still shows several rows above the five buttons.

## Acceptance

- [ ] WHEN a load can be undone, THE BUTTON SHALL be on, and undo it; otherwise it SHALL be greyed. WHEN the bars or keys changed by hand since the load, IT SHALL ask first. proves: `..., the Undo button is on after an apply`, `..., and off after the undo`, `..., the button asks first after a hand change`, `..., a key changed by hand asks first too`, `..., and Undo anyway undoes`

## Comments

**2026-09-23** Adversarial review of 6c318b8. Verdict: **bounced to todo, one finding.**

What broke: **one click on Undo bars can wipe weeks of hand changes, with no question and no way
back.** `canUndoBars` (`DjinnisBiS.lua:7251`) is on whenever `DjinnisBiSCharDB.barsUndo` exists.
That is saved per character and is only cleared by an undo. `undoBars` (`:7236`) then puts back the
whole layout from before the load, and keeps no redo. A player hits it like this:
- Click **Load bars: spec**. Undo bars lights up.
- Over the next days, move some spells and rebind some keys by hand. The button stays lit, across
  logins.
- Click **Undo bars** by mistake, or thinking it undoes the last small change. Every slot and key
  goes back to before that load. The hand changes are gone, and nothing puts them back.

The chat command had the same reach, but typing `/djbis bars undo` is not a slip. A full-width
button is. This file already says so: `saveBars` asks before replacing a layout because "a button
click is easy to make by mistake" (`:7058`). The tooltip also says "before the last load", which
reads as safe.

`applyBars` already knows the test (`:7198`): the undo still means "the load" only while the bars
and keys match `barsAfter` and `keysAfter`. Either fix is fine, the builder's call:
- The button asks first when the bars or keys moved since the load, with the prompt that
  `saveBars` uses. Keeps `canUndoBars` as it is, so nothing needs to watch the bars.
- Or `canUndoBars` also needs `sameBars(readBars(), barsAfter)` and `sameKeys`. Then the button
  greys after a hand change. That needs a redraw on `ACTIONBAR_SLOT_CHANGED`, or it is only right
  when the list is drawn.
Add a check that goes red when a hand change after the load is undone without asking.

What held:
- Stale state. The button is set on every `updateSidebar` (`:6214`). `applyBars`, `undoBars` and
  `saveBars` all call `barsChanged`, so `/djbis bars undo` from chat, a profile load, and the offer's
  Apply all redraw it. After a login `barsUndo` is already in `DjinnisBiSCharDB`, and the window's
  OnShow redraws.
- Combat. `barsChanged` is only reached past `barsFence`, so never in combat. `updateSidebar` does
  nothing in combat anyway, and the list hides itself.
- No redraw loop. `updateSidebar` calls nothing that calls `barsChanged`.
- API, read against the local source: `SetEnabled` is on SimpleButtonAPI.
  `UIPanelButtonNoTooltipTemplate` has an `OnDisable` handler (`SecureUIPanelTemplates.xml`), so it
  greys. Two anchor points and `SetHeight` give a full-width button.
- Always on turns 1 red. Always off turns 1 red.

What no check covers (green under mutation): `f.undo:SetEnabled(true)` in place of
`canUndoBars()`, and removing `barsChanged` from `undoBars`, `applyBars`, or its whole body. The
harness frames do nothing, so the in-game checks are the only proof of the grey state.

Security:
1. Weakest point: the finding above. One misclick overwrites the character's bars and keys.
2. Unchecked: nothing new on the way in. The undo is this character's own saved bars, fenced for
   combat, a full cursor and a vehicle bar.
3. Leaks: nothing. It only prints counts.

No client can be run by an agent. Once fixed, the in-game checks are this card's What I need from
you. Also look at: five buttons in the 280 px list, three rows, with several rows of the list still
above them on the smallest talent window.

- 2026-09-23 Claude, builder, v0.38.0. Fixed.
  - The button calls `PlanTab.undoBarsAsk`. When the bars and keys still match what the last load
    left, it undoes at once. When they changed since, it asks: "Undo anyway" or "Cancel". `/djbis
    bars undo` from chat is unchanged. Checks: `..., the button asks first after a hand change`, `...,
    and Cancel keeps the change`. Mutation: never ask 3 red.

**2026-09-23** Second adversarial review of b5530b3 (v0.38.0). Bounced to todo: the fix is right
in the code, and half of it is untested.

Attacked, on a temp copy, the same under Lua 5.1 and the newer one:
- never ask: 3 red. Always ask: 5 red.
- **no key compare** (`DjinnisBiS.lua:7333`, drop `sameKeys`): **0 red**.
- **"Undo anyway" does nothing** (its `onClick` removed): **0 red**.
- the button back to `PlanTab.undoBars` (6061): 0 red. The harness frames keep no scripts, so this
  is the game's to check, as the first review said.
- `undoBarsAsk` without its combat fence: 0 red. `undoBars` fences again, so nothing is lost.
- `promptBusy` ignored: 0 red. A second question would write over the open one.

**Finding: a key change since the load, and the "Undo anyway" button, can both break with every
check green.** The check at 7819 changes a bar slot only. Rebinding a key by hand is at least as
common, and the fix promises to ask then too. The check at 7820 reads `buttons[2]` (Cancel) and
never clicks `buttons[1]`, so an "Undo anyway" that does nothing passes, and the player could then
never undo after any change. Fix: one check that changes a key only and expects "ask". One check
that clicks `shown.buttons[1].onClick()` and expects the bars back and `canUndoBars()` false.

No criterion carries `proves:`. Name the checks, and mark the grey state `proves: manual`.

What held:
- The first finding is fixed. With bars and keys as the last load left them, one click undoes.
  After a hand change it asks, and Cancel changes nothing.
- The same `sameBars` and `sameKeys` test `applyBars` uses decides it, against `barsAfter` and
  `keysAfter`. An undo saved before `barsAfter` existed has none, so it asks. That is the safe side.
- `/djbis bars undo` from chat is unchanged, which the card says.

Security:
1. Weakest point: the prompt's "Undo anyway". It is the one click that overwrites a character's
   bars and keys, and nothing checks it.
2. Unchecked: nothing from outside. The undo is this character's own saved bars, fenced for
   combat, a full cursor and a vehicle bar at the moment of the undo.
3. Leaks: nothing. It prints counts only.

No client can be run by an agent. Once fixed, What I need from you 1 to 3 stand, plus: rebind one
key after Load bars, click Undo bars. Pass: it asks first.
- 2026-09-23 Claude, builder, v0.38.1. Fixed: a key changed by hand asks too (dropping the key
  compare: 2 red), and "Undo anyway" is checked to be `undoBars` (a no-op: 1 red). `proves:` added.