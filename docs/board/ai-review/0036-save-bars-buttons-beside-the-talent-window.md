---
needs: 0033
---
# 0036 Save the action bars from a button, to the build or for the whole spec

## Why

Rob, 2026-09-23: "give me a way to save my action bar loadout (both to the build and separately as
a global profile". Card `0033` saves both, but only by slash command (`/djbis bars save build`,
`/djbis bars save`), and nothing on screen says so.

## What

- Two buttons under the plan list beside the talent window (`0032`): **Save bars: build** and
  **Save bars: spec**. They run the same save as the two slash commands.
- "Global profile" is read as the spec layout: account-wide, used on every character for every
  build of the spec that has no layout of its own. A named profile loadable on any spec is not
  built; say if that is what was meant.
- Replacing a saved layout asks first, because a button is easy to click by mistake and the spec
  layout reaches every character. A new layout saves at once.

## Built, v0.34.0, 2026-09-23

- `buildSidebar` puts the two buttons at the foot of the list; the list ends above them. Each has a
  tooltip saying what it keeps and for whom.
- `PlanTab.saveBars(forBuild, ask, expect)`. The buttons pass `ask`: when a layout of that key
  exists, the prompt asks **Replace** or **Cancel** and names the date it was saved. The slash
  commands still save at once.
- **Replace** checks the spec and build are still the ones asked about (`expect`), the same guard
  0033's Apply got in its fourth review. If they changed, nothing is saved and chat says so.
- `/bis test`: 8 checks in `PlanTab.barChecks`: a new build layout saves without asking, replacing
  the spec layout asks and keeps the old one until Replace, Cancel does nothing, Replace saves, and
  a stale Replace saves nothing. Removing the ask, the stale guard or Replace's save turns checks
  red. Clean under Lua 5.1 and 5.4.

## What I need from you

1. `/reload`, open the talent window. Pass: two buttons sit at the bottom of the plan list, and
   the list scrolls above them without overlapping.
2. Select a loadout, click **Save bars: build**. Pass: chat says how many slots and keys were
   saved as `<Spec> / <loadout>`.
3. Click **Save bars: spec**. If a spec layout exists, pass: a prompt asks before replacing it.
4. Hover each button. Pass: the tooltip says which it saves.

## Acceptance

- [ ] WHEN Rob clicks **Save bars: build** with a loadout selected, THE ADDON SHALL save his bars and keys for that build.
- [ ] WHEN Rob clicks **Save bars: spec**, THE ADDON SHALL save them as the spec's layout.
- [ ] WHEN a layout of that name exists, THE ADDON SHALL ask before replacing it.
- [ ] In a client: both buttons show under the list and do not overlap it.
