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

## Comments

### 2026-09-23, adversarial review of 67ff695

What I attacked. I checked the acceptance, a question already up, combat and the fences, a click
with no loadout, the sidebar layout, and whether each check goes red without its fix. The
mutations ran on copies in `$TEMP/review36`. The harness is clean on the real code under Lua 5.1
and 5.4.

What held:
- Each check goes red when its fix is removed. With no ask, 2 checks go red. With no stale guard, 1
  goes red. When Replace saves nothing, 1 goes red. When Cancel saves, 1 goes red. When Replace
  drops `expect`, "a stale Replace saves nothing" goes red.
- Replace runs the whole of `saveBars` again. So combat, a full cursor and a vehicle bar at Replace
  time are fenced again, and a spec that is no longer a druid spec saves nothing. The sidebar hides
  itself on `PLAYER_REGEN_DISABLED`, and the buttons are plain, not secure.
- With no loadout selected, or the starter build active, `activeLoadoutName` answers nil. Chat then
  says there is no build, and nothing is saved.
- Layout, read against `SharedUIPanelTemplates.xml` and `ScrollTemplates.xml`. The ScrollBox and
  its bar end 40 px above the bottom, and the buttons sit from 8 to 32 px, so there is an 8 px gap.
  Each button is 128 px wide, `(280 - 24) / 2`, with an 8 px gap between them. The close button is
  at the top right, so nothing overlaps it. The labels fit in 128 px at GameFontNormal. Only a
  client can confirm that.

What broke: **saveBars writes over a question that is already up.** `DjinnisBiS.lua:6916` calls
`PlanTab.prompt` without asking `PlanTab.promptBusy()`. The addon's own rule at `:6542` says a
second question waits rather than writing over the first. A player can hit it like this:
- Double-click a build in this sidebar. 0033's bars offer comes up.
- Click **Save bars: build** or **Save bars: spec** beside it while that layout exists. The Replace
  question takes the frame.
- The offer is gone, and `barsSeen` is already set, so it does not come back until the key changes.
- A "Group joined" setup offer (0024) is lost the same way, and there is no command to call it back.

The fix is one line before `:6916`, and I checked it in a copy:
`if ask and old and PlanTab.promptBusy() then PlanTab.say("Answer the open question first, then click again.") return "busy" end`.
Also add a check that stubs `promptBusy` to true and expects no prompt. With the fix it passes, and
without it it fails. Both Luas are clean with the fix.

Security:
1. Weakest point: an account-wide spec layout can be replaced by a mis-click. The Replace question
   guards against that, apart from the fault above.
2. Unchecked input: none new. The key is built from `playerSpec()` and from a loadout name that
   passed `canRead`. Nothing from outside the client comes in.
3. What it leaks on failure: nothing. A failure prints a chat line to the player only.

There is no browser surface. Acceptance can only be checked in a client.

Verdict: BOUNCE, to todo, with the finding above.

**2026-09-23** Builder, v0.35.0, commit `2ae2239`. Fixed as proposed: with a layout to replace and
another question up, the button says "Answer the open question first" and changes nothing. New
check with `promptBusy` stubbed true; it goes red without the line. Card `0037` (named profiles)
was built in the same version.
