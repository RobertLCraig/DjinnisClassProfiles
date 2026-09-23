# 0041 The list beside the talent window shows your own loadouts too

## Why

Rob, 2026-09-23: "Additionally should show all existing blizzard builds in the list on the side
(which is MUCH easier to use!)"

## Built, v0.36.0

- `PlanTab.sidebarList` takes `stringOf` and adds a group, **Your loadouts**. It holds each saved
  loadout of the spec whose name no stored build has, sorted by name, with a book icon.
- The tick compares the live tree with that loadout's own string. The row is marked active when
  it is selected. Hover paints the tree diff from its string (`showTreeDiff(name, code)`).
- Double-click switches through `loadTalents`, the same path as every other row.
- The spare loadout (card `0040`) is never listed. Its build's row stands for it.
- `sidebarChecks`: 7 new checks.

## What I need from you

1. Open the talent window. Pass: a **Your loadouts** group at the bottom, holding every loadout
   of yours that is not a plan build. Compare it with Blizzard's dropdown.
2. Double-click one. Pass: it is worn, and it gets the tick.
3. Hover one. Pass: the tree shows what it would change.

## Acceptance

- [ ] WHEN the talent window opens, THE LIST SHALL show every saved loadout of the spec, the plan's and the player's own.
- [ ] WHEN an own loadout is double-clicked, THE ADDON SHALL switch through Blizzard's helper only.

## Comments

**2026-09-23** Adversarial review of 5c6b3ff (the 0041 half). Verdict: clean, to human-review for
the in-game checks above.

What I attacked. Secret or unreadable names, the one-tick rule, what a double-click on an own row
can reach, and whether each new check goes red when its code is broken. The harness is clean on the
real file under Lua 5.1 and 5.4. Mutations ran on a copy in `$TEMP/rev-0041-45`.

What held:
- No secret name reaches the list. Own rows come only from `savedLoadoutNames`
  (`DjinnisBiS.lua:3872`), which drops any name `canRead` refuses before it is a key. The string
  for the tick and the hover comes from `loadoutString` (`:6423`), which is `canRead` checked too.
- Exactly one tick. `ticked` is a single variable, and a plan build and an own loadout with the
  same string tick the plan build unless the own one is selected. Ticking every match turns 1 red.
  Letting the last match win turns 1 red.
- A double-click on an own row only reaches `loadTalents`. The name is in `saved`, so the spare
  path (card 0040) is never taken. It ends in `ClassTalentHelper.SwitchToLoadoutByName`, or a chat
  line. The talent-write scan still passes.
- Listing the spare turns 2 red. An empty own group turns 3 red. No active mark turns 1 red.
  Dropping the own string turns 1 red. Listing plan builds as own turns 2 red.

What no check covers (green under mutation, so the in-game hover check is the only proof):
- The hover's tree diff for an own row. Dropping `e.code` at `:6124`, or `code or` at `:6348`,
  leaves the harness green. Check 3 above is what proves it.
- The sort by name. Only one own row is in the check, so removing `table.sort` at `:5917` stays
  green.

Smaller things, not blocking:
- Double-click the own loadout that is already selected, and chat says "its build is not the
  planned one ... offers Reset to plan" (`:3950`). An own loadout has no planned build, so the
  line is wrong for it. Harmless: it only opens the window.
- An own loadout the player has hand-edited still shows green "active", where a plan build would
  show amber "edited". `talentsEdited` only knows plan strings.
- A player's own loadout named `BiS: ...` is hidden here, and card 0040's `wearSpare` deletes it
  on the next spare wear (`:6508`). That is 0040's to answer, not this card's.
- The acceptance has no `proves:` names, which the board README asks for.

Security:
1. Weakest point: a loadout name the game hands back secret. It is dropped at the read, before any
   compare, concat or table key, so the row is simply missing.
2. Unchecked: nothing new. The row's name goes only to `ClassTalentHelper`, and the list is
   rebuilt from the game each time.
3. Leaks: nothing. The list shows only this character's own loadouts, to this character.

No client can be run by an agent. The in-game checks are this card's What I need from you. Also
look at: a long own loadout name is cut, not wrapped over the next row.
