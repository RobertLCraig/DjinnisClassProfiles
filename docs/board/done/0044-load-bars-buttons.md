---
needs: 0036
---
# 0044 Load bars buttons beside the Save bars buttons

## Why

Rob, 2026-09-23: "so far addon looks to be working well. Need to add a 'load bars' build and spec."

## Built, v0.37.0

- Under the Save bars buttons in the list beside the talent window: **Load bars: build** and
  **Load bars: spec**. The list ends one button higher to make room.
- `PlanTab.loadBars(forBuild)` picks `<spec> / <build>` or `<spec>` and calls `applyBars`, the
  same apply as the offer's Apply. It keeps the undo, and it is out of combat only.
- It asks nothing first, because `/djbis bars undo` puts the old bars back.
- With no layout saved, it says so and changes nothing.
- `barChecks`: 4 new checks. Two mutations, each turned red.

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN Load bars is clicked, THE ADDON SHALL apply that saved layout, or say none is saved. proves: `the Load bars buttons, the build's own`, `..., the spec's`, `..., a build with none loads nothing`, `..., no loadout selected, nothing`
- [ ] `/reload`, open the talent window. Pass: a Save bars row, a Load bars row and a full-width **Undo bars** under the list, none over it, no label cut. proves: manual
- [ ] Change one action bar slot, click **Load bars: spec**. Pass: the slot comes back; chat says "Applied the <Spec> layout: N slots and N keys changed". proves: manual
- [ ] On a build with no bars of its own, click **Load bars: build**. Pass: chat says "No saved <Spec> / <build> layout yet", nothing changes. proves: manual
<!-- AC:END -->

## Comments

**2026-09-23** Adversarial review of 68db0fa. Verdict: clean, to human-review for the in-game
checks above.

What I attacked. The key `loadBars` picks, a nil build, the offer's stale-build guard, what undo
holds after one or two loads, combat, and the layout of the buttons. The harness is clean on the
real file under Lua 5.1 and 5.4. Mutations ran on a copy in `$TEMP/rev-0041-45`.

What held:
- The key is read at click time (`DjinnisBiS.lua:7220`). There is no prompt in between, so the
  stale-build case the offer guards against (`:7291`) cannot happen here. The offer's guard is
  unchanged.
- A spare-worn build loads its own layout: `activeLoadoutName` maps `BiS: X` back to `X`.
- No loadout selected, or the starter build: `activeLoadoutName` is nil and chat says so. Removing
  that guard crashes the harness at the concat on `:7227`, so it is covered.
- No layout of that key: chat says so and nothing moves. Removing the guard turns 2 red. Loading the
  spec's layout for "build" turns 3 red.
- Undo after a load: `applyBars` keeps the character's own bars over a second load straight after,
  and takes the bars as they are now when anything moved since the last load (`:7198`). So one
  undo always goes back to before the loads, not to a stale point.
- Combat, a full cursor, a vehicle bar: `applyBars` is fenced by `barsFence`. The list also hides
  itself in combat.
- Layout, read against `SharedUIPanelTemplates.xml`: each button is 128 px, `(280 - 24) / 2`.
  After 0045 the rows sit at 8, 36 and 64 px, 24 px tall, 4 px apart. The list ends at 96 px, so
  there is an 8 px gap above the top row.

What no check covers (green under mutation): which button calls which. Swapping **Load bars: spec**
to `loadBars(true)` stays green, because the harness frames do nothing. Check 2 and 3 above are the
only proof.

Smaller things, not blocking:
- The load asks nothing, and relies on undo. That is fine only while undo is safe to press. See
  card 0045, bounced for that.
- A hand-edited saved file where the layout under a key is not a table errors in `applyBars`. That
  was already so for the offer and is the player's own file.
- The acceptance has no `proves:` name, which the board README asks for.

Security:
1. Weakest point: one click overwrites this character's bars and keys with no question. Undo is
   the only way back.
2. Unchecked: nothing new. The key is built from the spec and a name `canRead` passed, and the
   apply is fenced for combat.
3. Leaks: nothing. The chat line names the layout key and counts, to the player.

No client can be run by an agent. The in-game checks are this card's What I need from you. Also
look at: "Load bars: build" and "Save bars: build" fit in 128 px without being cut.

**2026-10-11** Clear-down (attended, Rob asked): ticked the one criterion (checks `the Load bars buttons, ...` (the build's own, the spec's, a build with none loads nothing, no loadout selected, nothing) exist and pass in the Lua 5.1 offline check); looks rewritten for v0.69.0: the foot of the list is now three rows (Save bars, Load bars, a full-width Undo bars from card 0045) under a Premade bars row, not "four buttons, two rows", and the chat lines are quoted from the code; which button calls which is still proved only in game, as the review said; moves to ai-review/ with only in-game looks open.

### 2026-10-19 review (v20261019220644-410a)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

The one ticked criterion (#1) holds. I found no defect.

**#1: Load bars applies the saved layout, or says none is saved.** This is met.
- `PlanTab.loadBars` in `DjinnisClassProfiles.lua` gets the key from `PlanTab.loadKey`. "Build" gives `<spec> / <build>`. "Spec" gives `<spec>`.
- When no loadout is selected, chat tells you, and the function returns `"none"`.
- When no layout is saved under that key, chat says "No saved <key> layout yet". The function returns `"none"` and does not call `applyBars`.
- When a layout is saved, it calls `PlanTab.applyBars(key)`. This is the same apply that the offer uses.
- The two buttons connect to the right calls. **Load bars: build** calls `loadBars(true)`. **Load bars: spec** calls `loadBars(false)`.
- The four named checks are in the offline check block (`loadButtonTest`). They test all four cases: the build's layout, the spec's layout, a build with no layout, and no loadout selected.

**#2 to #4 are manual checks.** They are still open, and they are Rob's to try in game. The code does not block them:
- #4: the "no layout" chat line in `loadBars` matches the text the criterion expects.
- #3: the chat line for a successful load comes from `applyBars`, and that function was not changed here.

VERDICT: sound

**scope: sound**

I checked how far the change goes. It stays inside the card.

**Findings (lens: scope)**

- The card asks for two buttons. They exist in `DjinnisClassProfiles.lua`, in the Save bars list setup. **Load bars: build** calls `PlanTab.loadBars(true)`. **Load bars: spec** calls `PlanTab.loadBars(false)`.
- `PlanTab.loadBars` is in the same file. It keeps the card's rules: one apply through `applyBars`, no question first, and a "none saved" path that changes nothing.
- The four named checks are in the offline self-test block, beside the `loadButtonTest` checks. They cover the build's layout, the spec's layout, a build with no layout, and no loadout selected.
- The diff is big: 166 files, plus a rename to DjinnisClassProfiles. That is not this card growing. It is the whole branch range, and other cards in `done/` own those parts (0058 for the rename, 0045 for Undo bars, 0081 for `PlanTab.loadBarsOnly`). None of it is here because of card 0044.
- Nothing is half done. The open criteria are all `proves: manual`, and nothing in the code stops them from passing.
- The card has no "Not this card" section, so there is no stated limit to cross.

VERDICT: sound

**breakage: sound**

I tried to break the card 0044 work. I could not break it.

**What I checked:**
- **The buttons.** In `DjinnisClassProfiles.lua`, the **Load bars: build** button calls `PlanTab.loadBars(true)`. The **Load bars: spec** button calls `PlanTab.loadBars(false)`. The wiring is correct. The earlier review said the offline check does not cover this wiring. That is still true.
- **Which layout loads.** `PlanTab.loadKey` uses the spec name alone, or the spec name plus the build name. If the game has not said the spec, or if no loadout is selected, it gives a reason. `PlanTab.loadBars` then shows that reason in chat and changes nothing.
- **No saved layout.** `PlanTab.loadBars` writes "No saved <key> layout yet. Save bars first." and returns "none". This matches manual criterion #4.
- **Two load paths.** The row menu has a "Load bars only" item that uses `PlanTab.loadBarsOnly`. That is a different path, with its own checks. It does not change what the buttons do.
- **Comments after the rename.** The comments now say `/dcp bars undo`, not `/djbis bars undo`. No comment is now false.
- **Offline checks.** The four `the Load bars buttons, ...` checks still exist. They stub `applyBars` and `activeLoadoutName`, and then put the real ones back.

Criteria #2, #3 and #4 are manual checks. They are still open, and that is expected. #1 is ticked and holds.

**What you do now:** Try the three in-game checks on the card when you can.

VERDICT: sound

