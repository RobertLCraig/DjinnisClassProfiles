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
