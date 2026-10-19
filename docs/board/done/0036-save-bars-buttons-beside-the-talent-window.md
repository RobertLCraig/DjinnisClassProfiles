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
  build of the spec that has no layout of its own. Rob then asked for named profiles too; they
  are card `0037`.
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

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN Rob clicks **Save bars: build** with a loadout selected, THE ADDON SHALL save his bars and keys for that build. proves: `the Save bars buttons, a build with no layout saves at once`, `..., and asks nothing`
- [x] WHEN Rob clicks **Save bars: spec**, THE ADDON SHALL save them as the spec's layout. proves: `the Save bars buttons, Replace saves it`
- [x] WHEN a layout of that name exists, THE ADDON SHALL ask before replacing it. proves: `the Save bars buttons, replacing the spec layout asks first`, `..., and keeps it until Replace`, `..., Cancel does nothing`, `..., a stale Replace saves nothing`, `..., with another question up, it waits`
- [ ] `/reload`, open the talent window. Pass: **Save bars: build** and **Save bars: spec** sit side by side under the list, labels not cut, nothing overlapping the list. proves: manual
- [ ] Select a loadout, click **Save bars: build**. Pass: chat says "Saved N action bar slots and N key bindings as the <Spec> / <loadout> layout". proves: manual
- [ ] With a spec layout already saved, click **Save bars: spec**. Pass: a box asks "Replace the saved <Spec> layout ...?" with Replace and Cancel. proves: manual
- [ ] Hover each Save button. Pass: tooltips read "Save bars to this build" and "Save bars for the spec". proves: manual
<!-- AC:END -->

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

### 2026-09-23, second adversarial review of 2ae2239

What I attacked. I checked the bounced finding's fix, its placement, and its check. Mutations ran
on copies in `$TEMP/review3637`. The harness is clean on the real code under Lua 5.1 and 5.4.

What held:
- `DjinnisBiS.lua:6918` is the line proposed in the last review. It sits after the stale `expect`
  guard and before the prompt. It waits only when there is a layout to replace and a question is
  up.
- A new layout still saves at once while a question is up. That is right, because it asks
  nothing and so takes no frame.
- The Replace click passes `ask` as nil, so it never meets the guard. It does not get stuck on its
  own prompt.
- The check goes red without the fix. With the guard turned to `if false`, "with another question
  up, it waits" fails with `ask/table`, which means the prompt was shown. The other seven checks are
  unchanged.

What broke: nothing.

Security:
1. Weakest point: an account-wide spec layout replaced by a mis-click. Replace asks first, and now
   it waits instead of taking the frame from another question.
2. Unchecked input: none. The key comes from `playerSpec()` and a loadout name that passed
   `canRead`.
3. What it leaks on failure: nothing. The player gets one chat line.

There is no browser surface. The layout and tooltips can only be checked in a client.

Verdict: CLEAN, human-review next.

**2026-10-11** Clear-down (attended, Rob asked): ticked the build save, the spec save and the ask-before-replace criteria (checks `the Save bars buttons, ...`: a build with no layout saves at once, and asks nothing, Replace saves it, replacing the spec layout asks first, and keeps it until Replace, Cancel does nothing, a stale Replace saves nothing, with another question up it waits; all exist and pass in the Lua 5.1 offline check); looks rewritten for v0.69.0: the list's foot now holds a Premade bars row, the Save row, the Load row (0044) and a full-width Undo bars button, the chat line and tooltip titles are quoted from the code, and the layout criterion became the first look; moves to ai-review/ with only in-game looks open.

### 2026-10-19 review (v20261019111410-7e1d)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I checked the three ticked criteria against the code. All three hold.

**#1, Save bars: build.** `buildSidebar` in `DjinnisClassProfiles.lua` sets the click on `f.saveBuild` to `PlanTab.saveBars(true, true)`. In `PlanTab.saveBars` the key is "spec / loadout name", taken from `activeLoadoutName`. If no layout has that key, it saves at once with `captureBars`, which keeps both the bars and the keys. The self-test checks "a build with no layout saves at once" and "and asks nothing" are in `PlanTab.barChecks` and test this.

**#2, Save bars: spec.** `f.saveSpec` calls `PlanTab.saveBars(false, true)`, and the key is the spec. The check "Replace saves it" tests that the new layout is written.

**#3, ask before replacing.** In `PlanTab.saveBars`, if a layout exists and `ask` is set, it shows a prompt with Replace and Cancel. Cancel has no click action, so it does nothing. Replace calls `saveBars` again with `expect`, so if the build changed, nothing is saved. If another question is open, it waits and shows nothing. Each of these cases has its own check.

The four `proves: manual` criteria are not findings. They can only be checked in the game.

VERDICT: sound

**scope: sound**

The work for card 0036 is all there. I found nothing that goes past what the card asks for.

**What I checked:**
- **Buttons:** both buttons exist. Look in `buildSidebar`, in `DjinnisClassProfiles.lua`.
- **Tooltips:** they say "Save bars to this build" and "Save bars for the spec", as the look list asks.
- **Save:** `PlanTab.saveBars(forBuild, ask, expect)` asks before it replaces a layout. It skips the save if the spec or build changed in the meantime. It waits if another question is already open (`promptBusy`). That was the fix from the first review.
- **Self-test:** the checks for this card are in the file (`saveButtonTest = "the Save bars buttons"`).

**About the big diff:** it is the whole branch, not only this card. Most of it is other cards' work: the rename (0058), the More menu (0053), the Load and Undo buttons (0044, 0045), and research files. Each of those has its own card. None of it changes what this card's buttons do.

The "More" menu also has "Save bars for this spec" and "Save bars for this build". Card 0053 ("every command has a button") added those. They call the same `saveBars(..., true)`, so they also ask before they replace a layout. That is not this card growing.

**Nothing half done:** the only open items are the four in-game checks, marked `proves: manual`. They are for Rob to try in the game. They are not a finding.

**What you do now:** nothing. The card can go to done. The four in-game checks wait for Rob.

VERDICT: sound

**breakage: sound**

I tried to break card 0036 and could not.

- **Save code:** `PlanTab.saveBars` in `DjinnisClassProfiles.lua` still works after the rename. It still checks "is another question up?" (`promptBusy`) before it asks to replace a layout. The check also needs `ask` and an old layout, as the card says.
- **Chat line:** the code says "Saved %d action bar slots and %d key bindings as the %s layout." This matches the manual look.
- **Replace box:** it asks "Replace the saved %s layout ... with the bars and keys you have now?" This matches the manual look.
- **Tooltips:** the titles are "Save bars to this build" and "Save bars for the spec". This matches the manual look.
- **Old name:** the rename deleted `DjinnisBiS.lua`. I found no caller of `saveBars` that still uses an old path.

Only the `proves: manual` looks are open. Rob checks those in the game, so they are not findings.

VERDICT: sound

