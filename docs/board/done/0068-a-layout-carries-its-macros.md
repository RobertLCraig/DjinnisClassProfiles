# A bars layout carries the text of its macros, and makes a missing one

## Why

Rob, 2026-09-26: "do we need MySlot anymore? I think ClassProfiles covers this now."

It covers the bars and the key bindings (card `0033`). It does not cover macros. A layout stores a
macro slot as `{ type = "macro", name, index }` (`PlanTab.readSlot`), with no body and no icon. On
Apply, `findMacro` looks the name up, and a character that lacks the macro gets the slot skipped
as "no macro named X". So a character macro, which lives on one character only, never reaches the
other characters of the class. Myslot saves the macro body and makes the macro again. That is the
one thing Myslot still does for Rob that this addon does not.

## Links

- **Relates to** `0033`: its slot engine is where a macro is read and placed.
- **Blocks** `0069`: the backup string has to carry the macro bodies.
- **Blocks** `0070`: Myslot cannot go while this is the one thing only it does.

## Not this card

- No macro editor. The addon copies a macro that exists. It never lets you write one.
- No change to a macro that already exists by that name. A same-named macro with other text is
  left alone and reported, never overwritten.
- No export string. That is `0069`.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN a layout is saved and a slot holds a macro, THE ADDON SHALL store its name, body, icon and whether it is an account or a character macro. proves: `a saved macro slot keeps its body and icon`
- [x] WHEN a layout is applied and no macro has that name, THE ADDON SHALL make it (a character macro as a character macro) and place it. proves: `apply makes a missing macro and places it`
- [x] WHEN a macro with that name exists and its body differs, THE ADDON SHALL place the existing one and list the difference in chat. proves: `a same-named macro is never overwritten`
- [x] WHEN the macro slots are full, THE ADDON SHALL skip the slot and say so, as it does now. proves: `full macro slots skip the slot and say why`
- [x] WHEN undo runs after an apply that made macros, THE ADDON SHALL delete only the macros that apply made. proves: `undo deletes only the macros apply made`
- [x] WHEN a layout saved before this card is applied, THE ADDON SHALL behave as today (name lookup, skip if missing). proves: `an old layout with no macro body still applies`
- [ ] WHEN Rob applies a layout with a character macro on a second character of that class, THE MACRO SHALL appear on the bar and work. proves: manual
<!-- AC:END -->

## Tasks

1. Read the body and icon in `PlanTab.readSlot` through `GetMacroInfo`. Put each read through
   `canRead`.
2. In `pickUp`, when `findMacro` finds nothing and the slot has a body, call `CreateMacro`, then
   place it.
3. Write the made macros into the undo in `DjinnisCPCharDB`, so undo removes them.
4. Add the six checks to `PlanTab.barChecks`, with `CreateMacro` and `DeleteMacro` in its model.
   Put them back afterwards, as the other swapped globals are.
5. Run the offline check under Lua 5.1:
   `"C:\Program Files (x86)\Lua\5.1\lua.exe" offline-check.lua`. Break one new check on purpose to
   prove it runs.

## Plan

- `CreateMacro`, `EditMacro` and `DeleteMacro` are not in `Blizzard_APIDocumentationGenerated`.
  The call shape is in `wow-ui-source/Interface/AddOns/Blizzard_MacroUI/Blizzard_MacroIconSelector.lua:109`:
  `CreateMacro(text, iconTexture, nil, isCharacterMacro)`. Check it there, not from memory.
- `CreateMacro` is refused in combat. Apply already refuses in combat, so there is no new gate.
- Character macros start at `MAX_ACCOUNT_MACROS + 1` (121). `findMacro` already knows this.
- Myslot does this and is in the game folder (`Interface/AddOns/Myslot/Myslot.lua`), under
  Apache 2.0. Read it for the order of calls. If code is copied, keep its licence notice.
- The main chunk is near Lua's 200-local limit. New helpers go on `PlanTab`.

## Comments

**2026-09-26** Raised from the Myslot question. Nothing is built yet.

**2026-09-28**
RESULT: partial
TESTS: +19 new checks in `PlanTab.barChecks`, all green
TOUCHED: DjinnisClassProfiles.lua
OUT-OF-SCOPE: none

Built. `readSlot` keeps each macro's `body`, `icon` and `char` (true or false), each read through
`canRead`. `pickUp` makes a missing macro through `PlanTab.makeMacro` only when the slot has a
body; `CreateMacro(name, icon, body, perCharacter)` is Myslot's call (`FindOrCreateMacro`), and
Blizzard's icon selector makes the same one. A full kind is a skip, never the other kind: a
character macro made account-wide would reach every class. A same-named macro with other text is
placed, left alone, and one chat line per macro shows both texts (`PlanTab.noteMacro`). The made
macros go in `DjinnisCPCharDB.macrosMade`; undo deletes them after the bars go back, newest first,
and only one that still holds the text it was made with (`PlanTab.deleteMade`). When apply starts a
fresh undo, `macrosMade` is cleared, because those macros are part of the bars undo puts back.
`barsDiffer` counts a macro it would make as a change, without making it.

Watched red first: 11 of the new checks failed for the reason each criterion names. Three passed
before the code and are guards on today's behaviour, which is what their criteria ask: the old
layout's two checks, and "the existing one is placed". Two mutants run after green (no body check on
undo, no full check) each turned their checks red.

Re-examined one existing test: the `0051` check's stub of `placeBars` returned the old two values;
it now returns the third, `{ made, notes }`, as the real one does.

Offline check under Lua 5.1: self-test passed. Its one FAIL line is this worktree, not this card:
`../DjinnisBiS` is not beside the worktree. There is no PHP here, so `pest` and `pint` do not apply.

Left open: the manual criterion. Rob, on a second druid with a character macro in the layout:
Load bars, then check the macro is on the bar, works, and is in the character tab of `/macro`. Then
Undo bars and check it is gone. Also look at the chat lines for a same-named macro with other text.
No version bump and no deploy: neither is in the card's Plan.

**2026-09-28** The loop moved this card from in-progress/ to human-review/ WITHOUT trying it. All 1 of its open acceptance criteria say proves: manual, so there is nothing left an unattended session could close and starting one would change nothing. Each open criterion names what to look at and what a pass is: tick what passes and move the card on, or say what failed and move it back to todo/.

**2026-09-29** Moved to `ai-review/` by an attended agent under Rob's rule that human-review holds
only what he must decide. No reviewer has read this card's code: `git log` shows the build
(`3655baf`), a count fix (`3d76035`), then the loop's move straight from `in-progress/` to
`human-review/` (`0aa1193`). The code writes macros (`CreateMacro`) and deletes them on undo
(`PlanTab.deleteMade`), so it needs the adversarial pass before Rob loads it. After the review, write
`## What I need from you` from the builder's "Left open" paragraph above, and say whether the build
has been deployed to the game folder, because the builder did not bump the version or deploy.

**2026-10-04** REVIEW (adversarial, separate agent). Holds. To `done/` with the manual criterion
open. It is deployed: commit `3655baf` is inside v0.69.0, which HANDOVER records in the game folder
since 2026-10-02. The look is the builder's "Left open" paragraph above.

Attacked:
- `offline-check.lua` under Lua 5.1, self-test and spec 250: "no FAIL lines". All six `proves:`
  names print.
- Three mutations on a temp copy. Red: making every macro account-wide (7 FAIL lines), undo
  deleting a made macro whatever its text (2). **Green, and fixed:** not clearing `macrosMade`
  when a load starts a fresh undo. Then a load, a hand change, a second load and an undo would
  put the bars back holding the made macro and then delete it. The code was right; nothing held
  it. One check added in `437d9ac` ("and not one a later load's undo holds"); with the clear
  removed it goes red.
- `CreateMacro(name, icon, body, perCharacter)` matches `Blizzard_MacroIconSelector.lua:109`.
  `EditMacro` returning an index there shows the game re-sorts macros by name, so an index moves on
  every make. `findMacro` checks the index hint by name before trusting it and `deleteMade` finds
  by name, so neither depends on an index staying put.
- Combat: every path that makes or deletes a macro is behind `barsFence`.
- Reads: body, icon and name all go through `canRead`.

Minor, not blocking:
- An account macro made by a load is deleted by that character's undo, and by then another
  character may have placed it.
- `compareTake` (card 0080) passes a `ctx` to `pickUp`, so it can make a macro too, but does not
  record it, so Put mine back leaves it.

Security:
1. Weakest point: since card 0069 a layout can arrive as a pasted string, and its macro bodies are
   written by `CreateMacro` on Load, unread. A stranger's string could put a macro with any text,
   `/run` included, on a bar under a familiar name. It still takes a Load and a press. Before this
   addon is released, the load's chat line should print each made macro's text, or ask first for a
   layout that came from a string.
2. Unchecked: body length and content are not validated; the game caps the length itself.
3. Leaks: an exported string carries every macro's text, so a macro holding anything private goes
   with it. Nothing leaves the client by itself.

Not looked at in a client: there is none here.
