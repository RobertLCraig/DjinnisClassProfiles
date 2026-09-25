---
needs: 0058
---
# 0059 The "[CP] " tag on every loadout the addon makes

## Why

Card `0050`'s finding: the addon knows its loadouts only by name, so a loadout Rob made and called
"Raid" reads as the addon's, and "Reset to plan" would delete it. Rob, 2026-09-24: a tag, like
Improved Talent Loadouts' `[ITL]`, and it is `[CP]` (Class Profiles), not `BiS`. He accepted a
clean-up of the old loadouts on every character.

Split from card `0058` so the rename could ship first; the rename changes no loadout.

## What

- Every loadout the addon makes is named `[CP] <build name>`. 24 letters is the longest build name,
  so 29 of Blizzard's 30.
- Only tagged loadouts are the addon's. `savedLoadoutNames`, wearing by name
  (`ClassTalentHelper.SwitchToLoadoutByName`), the build in play, the queue's watched name and every
  message go through one pair of functions, tag and untag, so no caller builds a name by hand.
- The spare (card `0040`) needs a name that is still the addon's and fits in 30 letters. Decide in
  the build; `[CP] ` plus a marker plus 24 letters is over 30.
- **The clean-up.** "Delete old loadouts" (today druid-only, the Dreamgrove names) also lists this
  spec's untagged loadouts whose name is exactly a plan build name, asks first, never deletes the
  selected one. Offered once per character after the update.

## Acceptance

To write with the build. Tag, untag and the clean-up list are pure and go in the self-test.

## Not this card

- The build manager: card `0057`.

## Comments

**2026-09-24, Claude.** Written when `0058` was split.

**2026-09-24, Claude.** Card `0060` added a second made name: the worn loadout is reset through
`<name> (new)` (`PlanTab.SWAP_SUFFIX`), then renamed. With the tag that is 5 + 24 + 6 = 35 letters,
over 30. Shorten the suffix, or treat it as the spare's name is treated.
