# 0042 The list shows which builds have their own action bars

## Why

Rob, 2026-09-23, with a screenshot of the list: "Need to show if a loadout has different saved
bars for its build."

## Built, v0.36.1

- `PlanTab.sidebarList` sets `bars` on a row when `DjinnisBiSDB.bars` holds `<spec> / <build>`
  (card `0033`'s per-build layout).
- The row's second line ends in blue **own bars**. The tooltip says: "Has its own action bars.
  Switching to it offers them."
- `saveBars` redraws the list when it is open, so the mark shows at once after **Save bars: build**.
- `sidebarChecks`: 2 new checks. "Never set" and "always set" both turn one red.

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN a build has its own saved action bars, ITS ROW SHALL say so, and no other row SHALL. proves: `a row says when its build has its own action bars`, `a row says when its build has its own action bars, and only that row`
- [ ] `/reload`, open the talent window. Pass: only builds you saved bars for end their second line in blue **own bars**, not cut off by the tick on raid rows. proves: manual
- [ ] Wear a build with no bars, click **Save bars: build**. Pass: its row says **own bars** at once, without a reload. proves: manual
<!-- AC:END -->

## Comments

**2026-09-23** Adversarial review of 42414e4, and of 6c318b8 where it moved the redraw into
`barsChanged`. Verdict: clean, to human-review for the in-game checks above.

What I attacked. The key built from `spec .. " / " .. name` with a nil spec, a spec layout marking
build rows, own loadouts and spare-worn builds, and whether each check goes red when broken. The
harness is clean on the real file under Lua 5.1 and 5.4. Mutations ran on a copy in
`$TEMP/rev-0041-45`.

What held:
- A nil spec cannot reach the concat at `DjinnisBiS.lua:5927`. With no spec every group is empty:
  `BOSSES[nil]` and `BUILDS[nil]` give no rows, and own rows read `spec and saved or {}`. So the
  loop body never runs.
- The key is the same one `saveBars` writes (`:7069`) and `barsKey` reads: `playerSpec()` both
  sides, and `activeLoadoutName` maps a spare `BiS: X` back to `X`. So a spare-worn build's row
  shows its mark.
- The spec-wide layout marks no row. It is keyed `Feral`, never `Feral / <name>`.
- Always set turns 1 red. Never set turns 1 red. Marking from the spec layout turns 1 red.

What no check covers (green under mutation): the redraw after **Save bars: build**. Removing
`barsChanged()` from `saveBars` at `:7092` stays green, because the harness frame is never shown.
Check 2 above is the only proof.

Smaller things, not blocking:
- Own loadouts (card 0041) get the mark too, and their bars are offered on switch the same way. No
  check covers own rows. That is right, just untested.
- `sidebarList` is headed "Pure, for /bis test" but now reads `db().bars`. The check swaps
  `db().bars` to cope. Worth passing the table in if it grows.
- The acceptance has no `proves:` names, which the board README asks for.

Security:
1. Weakest point: a hand-edited saved file where `bars` is not a table. `sidebarList` checks
   `type(db().bars) == "table"` first, so the list still draws with no marks.
2. Unchecked: nothing new. The key is built from the spec and a name the game gave and `canRead`
   passed. Nothing is written.
3. Leaks: nothing. It shows whether a layout exists for a build, to the player who saved it.

No client can be run by an agent. The in-game checks are this card's What I need from you. Also
look at: the blue "own bars" fits on the second line after the boss names on a raid row, and is
not cut off by the tick.

**2026-10-11** Clear-down (attended, Rob asked): ticked the one criterion (checks `a row says when its build has its own action bars` and `..., and only that row` exist and pass in the Lua 5.1 offline check); looks rewritten for v0.69.0, with the review's fit-beside-the-tick look folded into the first; the redraw after Save bars: build is still proved only in game, as the review said; moves to ai-review/ with only in-game looks open.

### 2026-10-19 review (v20261019191338-fef3)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I checked the one ticked rule (#1) against the code. It holds. The two open rules (#2 and #3) need a person in the game, so they are not findings.

**#1: a row says when its build has its own bars, and no other row does.**
- `PlanTab.sidebarList` in `DjinnisClassProfiles.lua` marks a row only when the saved bars hold the key `<spec> / <build>`.
- The bars for the whole spec use the key `Feral`, with no build name. So they cannot mark a row.
- If the saved bars are not a table, no row gets a mark. Nothing breaks.
- The row draw in `DjinnisClassProfiles.lua` adds a blue "own bars" to the second line only when the row has the mark. The tooltip says "Has its own action bars. Switching to it offers them."
- There are two checks. One gives bars only to "Raid: Sszorak" and proves that row is marked. The other proves "Raid: Nek'Zali", a real Feral raid row, is not marked.

**#3 (open, needs a person):** `saveBars` calls `PlanTab.barsChanged()` to redraw the "own bars" mark. That is the code this check depends on. No offline check covers it. Only the in-game look proves it.

What you do now: nothing for this rule. Do the two in-game looks when you play.

VERDICT: sound

**scope: sound**

I found no work outside this card's fence, and no part of the card is left half done.

- **The diff is not this card's work.** It spans the whole rename to DjinnisClassProfiles and about 60 other cards. This card's last change was the 2026-10-11 clear-down. That edit changed only the card file. The other changes belong to their own cards, so I do not count them against 0042.
- **The feature is all there.** The row draw in `DjinnisClassProfiles.lua` (the `row.bosses:SetText` line) adds a blue "own bars" text when `e.bars` is set. It puts a space in front only when the row has boss names.
- **The redraw is all there.** `PlanTab.barsChanged` runs after a save, a load and an undo. So the mark shows at once, as criterion 3 asks.
- **The extra code is shared code, not creep.** The undo button and other cards also call `barsChanged`. The "own bars" row menu belongs to cards 0044, 0045 and 0080, not to this card.
- **Criterion #1 is ticked**, and its two named checks are in the file. Criteria #2 and #3 are in-game checks. They wait for Rob and are not findings.

VERDICT: sound

**breakage: sound**

I checked the "own bars" mark in `DjinnisClassProfiles.lua`. I could not break it.

**Findings (I looked for breakage):**

- **The rename did not break the mark.** `PlanTab.sidebarList` reads `db().bars`. `PlanTab.barsKey` reads `barsDB()`, and that returns the same `db().bars` table. So the list and the save use one table and one key, `spec .. " / " .. build`.
- **The spec-wide layout marks no row.** It is saved under the key `Feral`, never `Feral / <name>`. `PlanTab.barsKey` keeps the two keys apart.
- **The list redraws after a save.** `PlanTab.saveBars` still calls `PlanTab.barsChanged()`. That redraws the list when it is open. Load and undo also call it now, so the mark also changes after those.
- **A bad saved file is safe.** If `bars` is not a table, `sidebarList` uses an empty table. The list still draws, with no marks.
- **The text fits next to the boss names.** In the row draw code, "own bars" goes after the boss names with a gap. With no bosses, it has no gap. Whether the tick cuts it off on screen is the open manual check. I see nothing in the code that stops it passing.
- **One gap is still open.** No offline check covers the redraw after **Save bars: build**. Only the manual check proves it. That check is manual, so it is not a defect.

I found no unmet criterion.

VERDICT: sound

