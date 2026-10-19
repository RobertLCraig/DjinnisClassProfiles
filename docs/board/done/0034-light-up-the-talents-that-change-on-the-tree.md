---
needs: 0032
---
# 0034 Light up, on the tree, the talents a build would change

## Why

Rob, 2026-09-23: "there are just too many talents now, I dont know what they all do, how they
interact with each other. what my actual 'choice' nodes are vs what the 'essential' nodes are."

A document answered it the same day (vault `outputs/2026-09-23 Druid talents, fixed or a
choice.md`): 50 to 57 talents per spec sit in every Dreamgrove build. Showing it on the tree itself
is better, and TalentTreeTweaks' `inspectDiff` module shows it can be done
(`research/TalentTreeTweaks/modules/inspectDiff.lua`).

## What

- Hover a row in the `0032` list: every node the build would add glows one colour, every node it
  would drop another. Nothing glows that stays the same.
- Optional second mode: nodes that differ between the stored builds of this spec are marked as
  "choices", the rest left plain.
- Drawing only: textures laid over Blizzard's node buttons from a table of ours, the same care as
  the slot glows in `0005`. No field written on a Blizzard frame.

## Built, v0.30.0, 2026-09-23

- New section in `DjinnisBiS.lua`, "What a build would change, drawn on the tree". Both the build
  and the talents in play are decoded with Blizzard's own `ReadLoadoutContent`, so the compare is
  node by node, not text.
- **Hover a build row**: green on a node it adds, red on one it drops, amber on another choice or
  another rank. These are TalentTreeTweaks' default colours. The tint goes when the hover ends.
- **Hover a group header** (the optional second mode): blue on every node the group's builds do
  not agree on. That is "which talents are choices". The rest are in every build of the group.
- Drawing only, after TalentTreeTweaks' `inspectDiff.lua`: one texture per node button, masked to
  its icon, kept in our own weak table. No field is written on a Blizzard frame. The only new game
  call is `C_Traits.GetTreeNodes`, a read, now on `offline-check.lua`'s allowlist.
- `/bis test`: `PlanTab.treeChecks`, 12 checks: add, drop, choice, rank, the choices across
  builds, the tint on exactly the marked buttons, gone after, and none in combat.
- **Trap met on the way**: the file's main chunk reached Lua's limit of 200 locals. New helpers now
  go on `PlanTab`; the handover says so.

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN a row is hovered, THE TREE SHALL mark exactly the nodes that differ from the current build, and SHALL clear them when the hover ends. proves: `hovering a row lights what that build changes, the dropped node is red`, `..., the added node is green`, `..., the kept node is plain`, `..., and it all goes when the hover ends`, `the tint lands on the marked buttons only`
- [ ] `/reload`, open the talent window, hover a build row that is not the one in play. Pass: a few nodes tint green (adds), red (drops) or amber (changes), matching the build; moving off clears them. proves: manual
- [ ] In the talent window, hover the **Raid** group header in the list beside it. Pass: blue on the nodes the raid builds disagree on, nothing else. proves: manual
- [ ] `/console taintLog 1`, `/reload`, hover a build row and a header, one pull on a dummy, log out. Pass: `Logs\taint.log` names nothing from DjinnisClassProfiles. proves: manual
<!-- AC:END -->

## Comments

**2026-09-23** Adversarial review of ccd5754. **BOUNCE.**

Attacked: every API claim against `wow-ui-source` 12.1.0 (69875). The mutation run used a copy in
`%TEMP%\rev0034`, with 11 mutants and `lua offline-check.lua` on each. The unhappy paths, taint and
secret values were read in the code, not run.

Held:
- `ReadLoadoutHeader` and `ReadLoadoutContent` only touch `self.bitWidth*`, so passing the mixin as
  `self` works (`Blizzard_ClassTalentImportExport.lua:116`, `:298`).
- Both functions walk `C_Traits.GetTreeNodes(treeID)` in the same order as the export (`:30`,
  `:72`, `:119`).
- `EnumerateAllTalentButtons` gives the active buttons in the pool (`Blizzard_SharedTalentFrame.lua:934`).
  `GetNodeID` returns `self.nodeID` (`Blizzard_TalentButtonBase.lua:91`).
- Hero nodes are ordinary buttons. Only the `SubTreeSelection` node is left out
  (`Blizzard_ClassTalentsFrame.lua:678`), so a hero-tree swap shows as red on the hero nodes and
  nothing on the swap itself.
- Choice buttons inherit `TalentButtonArtTemplate`, so every button has `IconMask`.
- Taint: `CreateTexture(nil, ...)` without a name or parentKey writes no Lua field. Nothing in
  SharedTalentUI or ClassTalents calls `GetRegions`. That is the same pattern as TalentTreeTweaks.
- The combat guard, the colour words, the choices and hide all held under mutation. M1-M4, M10 and
  M11 were killed.

Broke:
1. **`decodeBuild` (`DjinnisBiS.lua:6138`) skips the header checks** that `PlanTab.buildProblem`
   (`:5888`) already makes: version, spec and tree hash. `ImportDataStreamMixin:ExtractValue`
   returns nil once the stream runs out, and nil reads as "not selected" (`ExportUtil.lua:115`,
   `ImportExport.lua:121`). So a short string, or one exported against an older tree, still gets
   drawn. It lines up with the wrong nodes, or turns the whole tree red. That happens on the very
   row that shows the "tree changed" warning. It breaks "exactly the nodes that differ".
   Fix: `if PlanTab.buildProblem(code) then return nil end` at the top of `decodeBuild`.
2. **The wiring is untested.** These mutants all survived:
   - `sidebarTipOff` stops calling `hideTreeDiff` (M5). That is the "clears when the hover ends"
     half of the criterion.
   - `sidebarTip` stops calling `showTreeDiff` (M6).
   - `decodeBuild` always returns nil (M7).
   - Header `names` left empty (M8).
   - `have` and `want` swapped, so add and drop invert (M9).

   Fix: in `treeChecks`, stub `buildFor`, `liveTalents` and `decodeBuild`. Then check that
   `showTreeDiff` paints "add" where the build adds, and that `sidebarTipOff` hides a lit glow.

Minor, no bounce: if the tree reloads mid-hover (a spec swap or a spent point), buttons are
recycled and a glow can sit on the wrong node until the mouse leaves. Nothing in Lua shows
whether `GenerateImportString(activeConfigID)` includes staged, unapplied edits. It needs a client.

Security:
1. Weakest: a stored build string. It goes into the decoder without the header check (finding 1).
   The worst it can do is draw wrong tints. It cannot write talents.
2. Unchecked: the header of the string, as above. There is no network, event or slash input.
   Everything is local and read-only.
3. Leaks: nothing. Failures sit inside `pcall`, and an unreadable build draws nothing.

No browser surface. The UI runs in a game client and no agent can run one, so both acceptance
criteria still need a person at the client once this is fixed.

**2026-09-23** Builder, v0.33.0, commit `3d67af9`. Both findings fixed.
1. `decodeBuild` returns nil when `buildProblem` finds one (version, spec, tree), so such a
   row draws nothing. A granted node counts as unselected, as in 0031's fix.
2. `treeChecks` now drives `sidebarTip` and `sidebarTipOff` to the tree with the lookup, the
   decoder and the tooltip stubbed. It checks the colour on each node, the clear, a header's
   choices, the header's `names`, and the decoder's refusal. All five breaks that survived
   before now go red, and so does add/drop swapped.

**2026-09-23** Re-review of the v0.33.0 fixes (agent). **CLEAN.**

What I attacked: `3d67af9`, with 2 mutations on a copy in `%TEMP%\rereview`. I read the granted
change against `ClassTalentImportExportMixin:WriteLoadoutContent` and `ReadLoadoutContent`.

What held:
- Remove `buildProblem` from `decodeBuild` and the "another game version" check goes red. The live
  string comes from `GenerateImportString` for the current spec and tree, so the new check never
  stops the player's own talents from being drawn.
- The granted change is right. The client's export writes a granted node as selected but not
  purchased, and `ReadLoadoutContent` sets `isNodeGranted` for it. A Dreamgrove string marks the
  same node the same way. Both sides now count it as unselected, so a free talent never glows.
- The hover wiring checks (colour per node, the clear, the header's names and choices) all stand.

What is weak (no bounce): nothing checks the granted rule in `nodeWord` (`DjinnisBiS.lua:6193`).
Put back plain `isNodeSelected` and everything stays green. Fix: add one check,
`PlanTab.nodeWord({ isNodeSelected = true, isNodeGranted = true }, { isNodeSelected = false })`
must be nil.

Security: unchanged. The decoder is read-only, and a header this client would refuse now draws
nothing.

Verdict: CLEAN. Acceptance is in-game only, so the card goes to human-review next.

**2026-10-11** Clear-down (attended, Rob asked): ticked the hover criterion (checks `hovering a row lights what that build changes, ...` and `the tint lands on the marked buttons only, ...` exist and pass in the Lua 5.1 offline check; the review's granted-node check exists too, as `the nodes a build would change, a granted node is not a pick`); looks rewritten for v0.69.0, the addon is DjinnisClassProfiles now so the taint look names that, and the hover and header looks moved into Acceptance from What I need from you; moves to ai-review/ with only in-game looks open.

### 2026-10-19 review (v20261019094225-95c2)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I read the code that the hover criterion (#1) depends on. I did not run it, because there is no test suite here and no game client. Each part of the criterion goes to real code. I found nothing that breaks it.

**Criterion #1: hover marks exactly the nodes that differ, and clears them when the hover ends.**
- Hover start: `PlanTab.sidebarTip` calls `PlanTab.showTreeDiff`. That function decodes the build and your live talents with `PlanTab.decodeBuild`. Then `PlanTab.nodeDiff` and `PlanTab.nodeWord` compare them node by node, and `PlanTab.paintTree` puts a tint on only the marked buttons.
- "Exactly": `PlanTab.nodeWord` gives back nil for a node that does not change, so that node gets no tint. It treats a granted node (a free talent from the game) as not picked. `PlanTab.decodeBuild` refuses a build string whose header is wrong (old game version, other spec, old tree) because it calls `PlanTab.buildProblem`. So a bad string draws nothing. It does not draw wrong tints.
- Hover end: `PlanTab.sidebarTipOff` calls `PlanTab.hideTreeDiff`, which hides every tint.
- Tests: in `DjinnisClassProfiles.lua`, the self-test hovers a row through `PlanTab.sidebarTip` and checks red, green and plain on the right nodes. It then calls `PlanTab.sidebarTipOff` and checks that nothing is left. It also checks a group header, a granted node and a refused header. These checks are in the code. I did not run them.

**#2 to #4** are `proves: manual`. A person must try them in the game. They are not findings. I saw nothing in the code that stops them from passing.

VERDICT: sound

**scope: sound**

I checked one thing: does the change do more than card 0034 asked for?

**What I found**

- The tree-diff code is all in `DjinnisClassProfiles.lua`: `PlanTab.decodeBuild`, `PlanTab.nodeWord`, `PlanTab.showTreeDiff`, `PlanTab.hideTreeDiff` and `PlanTab.treeChecks`. The card asked for all of these. I saw nothing extra in them.
- The diff has 165 files. Most of them belong to other cards: the rename (0058), the bars work, the WCL scripts, a `.xlsx` and many board cards. This looks like a diff of the whole branch, not of card 0034's own commits (`ccd5754`, `3d67af9`). So I do not count that as growth of this card. A person should check which range the review script diffs.
- Nothing is half done. Both fixes from the first review are in. The note about "the tree reloads mid-hover" was marked minor, and the card does not ask for it.
- The three open criteria (#2, #3, #4) are `proves: manual`. Each one is only open, not broken, so none is a finding.

**What you do now:** nothing on this card. Do the three in-game checks when you play.

VERDICT: sound

**breakage: sound**

I tried to break card 0034 and could not.

**What I checked:**
- **The callers are all updated.** The tip on a build row calls `PlanTab.showTreeDiff` with the row's own string, `e.code`. That covers your own loadouts (0041) and a build of yours that has the same name as a plan build. A group header calls `PlanTab.showChoices`. When the hover ends, `PlanTab.sidebarTipOff` calls `PlanTab.hideTreeDiff`.
- **The early returns are safe.** A premade-bars row returns before it draws anything on the tree. No old glow stays, because `PlanTab.paintTree` hides all glows first, and every hover end hides them too.
- **The header check is the same in both places.** `PlanTab.decodeBuild` now calls `PlanTab.buildProblem` (version, spec, tree). So a string the client would refuse draws nothing.
- **The live talents still draw.** `PlanTab.liveTalents` makes its string for the spec in play, so that check never blocks the player's own tree.
- **A granted node does not glow.** `PlanTab.nodeWord` counts a granted node (a free talent from the game) as not picked, on both sides, so it never glows.
- **The rename broke nothing here.** After the rename and the move to every class, `playerSpec` finds the spec from `PlanTab.SPECS`, so `buildFor` still finds the build.
- **The comments are still true.** The comment above `decodeBuild` matches the code.

**What is left:** The only open criteria are `proves: manual`. Those are yours to try in the game. They do not count as a finding.

VERDICT: sound

