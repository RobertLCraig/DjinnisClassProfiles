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

- [x] WHEN the prompt's text wraps, THE PROMPT SHALL be tall enough that no text sits under the buttons. proves: the three "prompt height" checks in `PlanTab.barChecks`
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
