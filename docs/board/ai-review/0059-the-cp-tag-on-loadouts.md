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

Written with the build, from the card's What. The checks are `PlanTab.tagChecks` unless named.

<!-- AC:BEGIN -->
- [x] WHEN the addon makes a loadout for a build (Create, Reset), THE APP SHALL name it `[CP] <build>`. proves: `Create makes every missing build, and nothing else, each under the tag (card 0059)`, `Reset to plan deletes a drifted loadout and makes it again, delete then import, by name`
- [x] WHEN a loadout is untagged and named exactly as a build, THE APP SHALL NOT read it as that build, in the list, the build in play or a replace. proves: `a loadout's key, an untagged one named as a build is from before the tag`, `an untagged loadout named as a build is not read as the build`
- [x] WHEN a build is worn by name, THE APP SHALL ask Blizzard's helper for the tagged name. proves: `talents button loads a saved loadout through ClassTalentHelper, by its tagged name (card 0059)`, `drawn Talents button loads the picked boss's loadout`
- [x] WHEN the worn loadout is reset, THE APP SHALL make it as `[CP+] <build>` and rename it `[CP] <build>`. proves: `Reset to plan swaps the loadout you are wearing, made new, worn, old deleted, renamed`
- [x] WHEN a build is worn through the spare, THE APP SHALL name the spare `[CP*] <build>`. proves: `a build with no loadout of its own is worn through the spare, made once the window is shut`
- [x] WHEN any stored build is made under any of the three marks, THE APP SHALL keep the name within 30 letters. proves: `the [CP] tag, every build's made names fit in 30 letters`
- [x] WHEN loadouts from before the tag exist, THE APP SHALL ask first, then rename each to its tagged name, delete one only where a tagged one is there already, and never delete the one you are wearing. proves: `the loadouts from before the tag, renamed, or deleted where a tagged one is there`, `... the one you are wearing is never deleted`, `the offer asks about them first, and made nothing`
- [ ] WHEN Rob logs in on a character with old untagged loadouts, THE APP SHALL offer "Tag them", and afterwards the talent window lists `[CP] ` names holding the same talents. proves: manual
<!-- AC:END -->

## Not this card

- The build manager: card `0057`.

## Comments

**2026-09-24, Claude.** Written when `0058` was split.

**2026-09-24, Claude.** Card `0060` added a second made name: the worn loadout is reset through
`<name> (new)` (`PlanTab.SWAP_SUFFIX`), then renamed. With the tag that is 5 + 24 + 6 = 35 letters,
over 30. Shorten the suffix, or treat it as the spare's name is treated.


**2026-09-25, Claude. Built, v0.48.0.** WRITTEN WITH THE BUILD: the criteria were written from the
card's What while building, not agreed in advance. Attack the code, not the boxes.

What was decided in the build, and why:
- **The spare is `[CP*] <build>`, and the swap's new loadout is `[CP+] <build>`.** Both are the
  addon's by their mark and fit 30 letters with a 24-letter build name (6 + 24). The tag plus
  " (new)" did not (35). A check reads every stored build of every spec under all three marks.
- **The clean-up renames rather than deletes.** `C_ClassTalents.RenameConfig` keeps the talents
  and the slot, and works on the loadout you are wearing, so nothing drops to the starter build and
  nothing is made again. It deletes an old one only where a tagged one of that build is there
  already, and never the worn one. Old `BiS: ` spares this character recorded become `[CP*] `.
- **Where it is offered.** In the login offer (and More > Make the planned loadouts), before
  Create: until the old ones are renamed their builds read as missing, and Create would make each a
  second time. It is offered on every class, not only druids. "Delete old Dreamgrove loadouts"
  is unchanged.
- **One translation point.** `PlanTab.savedLoadoutNames()` keys a tagged loadout by its build
  (`PlanTab.loadoutKey`), a player's own by its own name, and puts pre-tag ones in a third return.
  So every `saved[build]` in the file finds the tagged loadout without change. Wearing by name reads
  the config's own name (`PlanTab.loadoutNameOf`). The /simc export reads the same keys.

Checked: `lua offline-check.lua` under Lua 5.1.5, exit 0, no FAIL line. Spec mode 250, 62, 1467, 73
clean; the druid specs 102 to 105 give 8 FAIL lines each, the same count as at HEAD before this
card. Mutations (`%TEMP%\mut0059`): 12 of 12 caught after one check was added for Create's names.

Left for card `0057`: a tagged loadout whose build is no longer stored reads as the player's own
under Your loadouts. Card `0060`'s review findings are fixed separately, on that card.

Rob's look, after `/reload` on a character that has loadouts from before this version:
1. A box says "N loadouts were made before this addon tagged its own" and lists each with what
   happens to it. Click Tag them.
2. The talent window lists them as `[CP] <build>`, with the same talents, and the one you wore is
   still on.
3. The list beside the talent window shows those builds as saved (not grey).