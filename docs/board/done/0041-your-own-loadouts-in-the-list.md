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

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the talent window opens, THE LIST SHALL show every saved loadout of the spec, the plan's and the player's own. proves: `the player's own loadouts are listed too`, `..., never the spare`, `..., nor a swap's new loadout (card 0059)`, `..., ticked by its own string`, `..., and marked when selected`
- [x] WHEN an own loadout is double-clicked, THE ADDON SHALL switch through Blizzard's helper only. proves: `talents button loads a saved loadout through ClassTalentHelper`, `no talent-changing call in the file, the button reads only`
- [ ] `/reload`, open the talent window. Pass: a **Your loadouts** group last in the list holds every loadout in Blizzard's dropdown that is not a plan build or `[CP...]`; long names cut, not wrapped. proves: manual
- [ ] Double-click a row under **Your loadouts**. Pass: it is worn, and it gets the tick. proves: manual
- [ ] Hover a row under **Your loadouts**. Pass: the tree tints what it would change (green, red, amber). proves: manual
<!-- AC:END -->

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

**2026-10-11** Clear-down (attended, Rob asked): ticked both criteria (checks `the player's own loadouts are listed too, ...` cover the list; the double-click criterion is ticked on `talents button loads a saved loadout through ClassTalentHelper` and `no talent-changing call in the file, the button reads only`, since the row's OnDoubleClick calls `loadTalents` and nothing else; all exist and pass in the Lua 5.1 offline check); looks rewritten for v0.69.0: the list now also has a **Your builds** group (card 0057), so **Your loadouts** is the last group rather than "at the bottom" alone, and `[CP*]`/`[CP+]` loadouts are kept out of it; the review's long-name look is folded into the first look; moves to ai-review/ with only in-game looks open.

### 2026-10-19 review (v20261019173903-df82)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

**What I did:** I checked each criterion against the code. I could not break it.

**#1 (the list shows every saved loadout).** The list is built in `PlanTab.sidebarList` in `DjinnisClassProfiles.lua`. It adds a **Your loadouts** group. That group leaves out plan builds, the spare `[CP*]` loadout and the `[CP+]` loadout from a swap. All five named checks are in the self-test in `DjinnisClassProfiles.lua`:
- `the player's own loadouts are listed too`
- `..., never the spare`
- `..., nor a swap's new loadout (card 0059)`
- `..., ticked by its own string`
- `..., and marked when selected`

**#2 (double-click switches through Blizzard's helper only).** A double-click on a row calls `PlanTab.loadTalents`. That function ends in `ClassTalentHelper.SwitchToLoadoutByName`. Both named checks exist:
- `talents button loads a saved loadout through ClassTalentHelper` is in the self-test.
- `no talent-changing call in the file, the button reads only` is in the self-test. `offline-check.lua` also scans the whole file for any talent-changing call.

**#3 to #5** are `proves: manual`. They wait for Rob in the game. The code does not stop any of them from passing.

**One small gap. It is not a failure.** No check would fail if someone broke the hover diff for an own row or the sort by name. Only the manual hover look proves those.

VERDICT: sound

**scope: sound**

**What I checked:** I checked whether this change goes past what card 0041 asks for.

**What I found:**

1. **The diff is not 0041's work alone.** It covers 163 files. These include the addon rename (card 0058), the build manager (0057), the Warcraft Logs tooling (0064), bar research, and about 60 other board cards. Each of those cards is its own work, with its own review. They are not extra work done under 0041. The reason is the commit range the script gave me. It is too wide. The builder of 0041 did not cause this.

2. **The 0041 feature stays in its scope.** `DjinnisClassProfiles.lua` has the **Your loadouts** group, and `PlanTab.sidebarList` takes `stringOf`. The 2026-10-11 clear-down added two changes: it keeps `[CP...]` loadouts out of the group, and it puts the group last because of the 0057 **Your builds** group. Cards 0059 and 0057 caused these changes, and the acceptance text names them. So this is not quiet growth.

3. **Nothing is half done.** The criteria that are still open are `proves: manual` checks. They wait for Rob to try them in the game.

None of these findings shows that a criterion fails.

**What to do now:** Nothing for this card. The script should pass a narrower commit range next time. With this wide range, every scope review shows other cards' work.

VERDICT: sound

**breakage: sound**

I tried to break card 0041. I could not.

**What I checked**

- **Where names come from.** The list gets its names from `PlanTab.savedLoadoutNames`. That function removes the `[CP] ` tag first, and it drops old untagged loadouts. So a plan loadout never shows under **Your loadouts** as a second row.
- **Your builds (card 0057).** `PlanTab.sidebarList` filters names through `PlanTab.buildsOf`, and that includes your own builds. So no loadout shows in two groups.
- **The spare and the swap loadout.** `PlanTab.spareBuild` and the `SWAP_MARK` test keep out the addon's spare (`[CP*] `) and its swap loadout (`[CP+] `).
- **Callers.** The function's only caller, `PlanTab.refreshSidebar`, passes `savedLoadoutNames` in the new order. Nothing calls it the old way.

**One small note.** It does not block the card. Manual look #3 says loadouts named `[CP...]` stay out of the list. But a loadout that *you* named `[CP*] ...` stays in the list. That is on purpose: the 0040 review decided it is yours, and a check proves it. When you do look #3, read it as "the addon's own `[CP...]` loadouts stay out." It still passes.

**What you do now.** Nothing in the code. The three in-game looks wait for you.

VERDICT: sound

