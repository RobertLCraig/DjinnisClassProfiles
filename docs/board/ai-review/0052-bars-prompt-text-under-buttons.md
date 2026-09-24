# 0052 The action bars prompt draws a wrapped line under its buttons

## Why

Rob, 2026-09-24, with a screenshot: "bug in displaying the popup where text and buttons overlap each
other." The "Djinni's BiS: action bars" prompt asked "Replace the saved Feral layout from 2026-09-24
with the bars and keys you have now? It is used for every Feral build that has no layout of its
own." The last sentence ran under the Replace and Cancel buttons.

`PlanTab.prompt` sized its height at 18 a line of text given, and its own comment said that held
only while no line wraps. Both of those lines wrap at 380 wide.

## What

- `PlanTab.prompt` sets its width first, on the frame and on the text, then sizes its height from
  the text's measured height (`GetStringHeight`, in `SimpleFontStringAPIDocumentation.lua`).
- `PlanTab.promptHeight(textHeight, lineCount)` is the sum, pure. A height that cannot be read (a
  secret, or no client) falls back to 18 a line.
- `PlanTab.popup` (the zone-in popup) is not affected: its lines do not wrap (`SetWordWrap(false)`).

## Acceptance

- [x] WHEN the prompt's text wraps, THE PROMPT SHALL be tall enough that no text sits under the buttons. proves: the four "prompt height" checks in `PlanTab.barChecks`, the last on the real prompt
- [ ] Rob sees the action bars prompt with every line above the buttons. proves: manual

## What I need from you

`/reload`, then `/djbis bars save` on a spec that already has a saved layout. Pass: the question
and "It is used for every ..." sit above Replace and Cancel, with a gap. Fail: any text touches a
button.

## Comments

**2026-09-24** Builder, v0.41.2.
- The three checks: a measured height is used, an unmeasured one is 18 a line, and a secret one is
  never compared. A copy with the measured height ignored fails "from the measured text".
- Not proven offline: that `GetStringHeight` returns the wrapped height at once after `SetWidth`
  and `SetText`. The stub frames have no text layout. Rob's look above is the proof.
- The self-test and the spec run pass under Lua 5.1 and 5.4.

**2026-09-24** Adversarial review of `94faef6` (v0.41.2). **Verdict: findings, back to `todo/`.**
The fix is right and matches how Blizzard measures wrapped text. But the named proof cannot see the
fix being reverted, and an offline check that can is cheap to write.

What held:
- Harness, from `git show 94faef6` copies in `$TEMP`, output read whole. The self-test exits 0
  under Lua 5.1.5 and 5.4.6. The 250 spec run exits 0.
- The API. `GetStringHeight` is in `SimpleFontStringAPIDocumentation.lua:325`, returns `uiUnit`,
  and carries `SecretWhenAnchoringSecret`. So the `canRead` guard is needed, and it runs before the
  compare. `SetText` (line 664) only adds a Text aspect to a secret string.
- Blizzard measures in the same frame, right after `SetWidth` and `SetText`, with no wait:
  `ScrollingFontMixin:OnSizeChanged` and `:SetText` (`ScrollTemplates.lua:321-350`),
  `ProfessionsRecipeSchematicForm` (`:1464-1475`), `TutorialMainFrame.lua:97-99`. Blizzard's
  Description sets its height to 600 first, because its last draw set a fixed height on it. The
  prompt never sets a height on its text, only one point and a width, so it needs no such step.
- Every caller. All five go through `PlanTab.prompt`: the group joined prompt (`offerSetup`), the
  loadouts offer (up to three buttons), the bars Replace question (Rob's), the Undo anyway question
  and the Apply bars offer. "Undo puts back the ones from before that load, and those changes are
  lost." is the same kind of line and was wrong the same way. One fix covers all five.
- Other frames with the old bug: none. `PlanTab.popup`, the main window rows and the sidebar rows
  set `SetWordWrap(false)` on fixed-height rows, so a long line is cut short, never drawn under a
  button. The loot card is fixed cells. The stat pane footer already measures with
  `GetStringHeight`.
- Mutations caught: the measured height ignored, the `canRead` guard dropped, the fallback made 12
  a line, the padding dropped.

**Finding 1 (test gap): the proof cannot see the fix reverted.** The three checks prove the pure sum
`promptHeight`. Nothing checks that `PlanTab.prompt` feeds it the measured height, or measures after
the width is set. These mutations stay green under both Luas: `f:SetHeight(PlanTab.promptHeight(nil,
#lines))`, which is the old line count back; deleting `f.text:SetWidth(width - 32)`, so nothing
wraps and the text runs off the right edge; and moving that `SetWidth` after the measure. The
self-test already drives the real prompt ("the prompt frame builds with its buttons"). So a check
can do it. A probe on a `$TEMP` copy swapped `f.text.SetWidth`, `SetText` and `GetStringHeight`
(returning 100) and `f.SetHeight`, called the prompt, and put them back. It read height 186 and
order "width, text, measure" on the commit. It read 122 on the first mutation, and "text, measure"
and "text, width, measure" on the other two. Fix: add that check to `PlanTab.barChecks`, and name it
in the acceptance's `proves:`.

**Finding 2 (wording): "a secret height is never compared" proves less than it says.** It proves a
secret height is not used. Moving `PlanTab.canRead` after `textHeight > 0` still passes, because 70
is a plain number offline and compares fine. No plain Lua value can make `type()` say "number" and
also throw on compare. So the order cannot be checked here. Fix: rename it "a secret height is not
used", and keep `canRead` first.

Trap met on the way: appending a four-local `do` block to the end of the main chunk hit "main
function has more than 200 local variables". The new check belongs inside `barChecks`, as it is.

Security:
1. Weakest point: the frame's height comes from a number the game can hand back as a secret. It is
   guarded, and the guard is first. The fallback is the old 18 a line, so the worst case is the old
   overlap, not an error.
2. Unchecked: the prompt's text is built from spec keys, build names and one place name from the
   group finder. That name is `canRead`-checked in `onAccepted` before it is used. Nothing else in
   the text comes from another player.
3. Leaks: nothing. The frame draws only on the player's own screen and sends nothing.

No client here. Rob's look above stands once the check is in.

**2026-09-24** Builder, v0.42.0: the two findings.
1. `PlanTab.barChecks` now drives the real prompt with its own text's `SetWidth`, `SetText` and
   `GetStringHeight` shadowed (returning 100) and `SetHeight` recorded, then removes the shadows.
   "prompt height, the real prompt measures its wrapped text" expects "width, text, measure 186" at
   today's button size. Your three mutations each fail it: the line count back, the text's width
   deleted, and the width moved after the measure.
2. Renamed "a secret height is not used". `canRead` stays first.
- The self-test passes under Lua 5.1 and 5.4.
