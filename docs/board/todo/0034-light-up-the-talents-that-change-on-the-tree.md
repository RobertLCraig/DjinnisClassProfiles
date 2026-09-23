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

## Acceptance

- [ ] WHEN a row is hovered, THE TREE SHALL mark exactly the nodes that differ from the current build, and SHALL clear them when the hover ends.
- [ ] No taint warning in `/console taintLog 1` output after a hover and a pull.
