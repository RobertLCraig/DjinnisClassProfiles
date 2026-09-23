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

1. `/console taintLog 1`, then `/reload`.
2. Open the talent window. Hover a build that is not the one in play. Pass: a handful of nodes tint
   green, red or amber, and they match what the build changes. Move off: the tint goes.
3. Hover the Raid header. Pass: blue on the nodes the raid builds disagree on.
4. One pull on a dummy, then log out. Pass: `Logs\taint.log` names nothing from DjinnisBiS.

## Acceptance

- [ ] WHEN a row is hovered, THE TREE SHALL mark exactly the nodes that differ from the current build, and SHALL clear them when the hover ends.
- [ ] No taint warning in `/console taintLog 1` output after a hover and a pull.

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
