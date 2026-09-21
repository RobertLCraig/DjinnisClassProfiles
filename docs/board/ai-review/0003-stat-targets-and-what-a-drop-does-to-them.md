# 0003 Stat targets, and what a drop does to them

## Ask

Rob, 2026-09-07: "want to consider what the optimum stats are, and rank new gear in a way that
shows what gets me closest to those optimum stats. ClassCodex showed this as you want xxx haste,
yyy mastery and showed how close you were to each breakpoint."

Then, in the same session: "show relevant bars, showing the changes in how that affects me reaching
the relevant breakpoints of the gear I am looking at and potentially the change when comparing gear
against what I have equipped."

Two decisions were put to Rob and answered:

- **Where the numbers come from.** Hero-talent aware, not one set per spec. The reason is a measured
  gap, not a preference: for Feral raid, Druid of the Claw wants 1225 crit and the all-hero
  aggregate says 775. A pane showing the aggregate to a Druid of the Claw player would be wrong by
  more than half, which is worse than showing nothing.
- **Where it appears.** All three: a Stats tab in the `/bis` window, a pane beside the character
  sheet, and lines on the item tooltip.

## Direction

**"Breakpoint" is the wrong word for what this data is, and the addon does not use it.** These are
the ratings the top 20% of each spec are observed to be wearing, harvested by u.gg out of logs. A
few genuinely are mechanical breakpoints, where a haste value fits one more tick into a channel.
Most are just where good gear settles. Calling all of them breakpoints would claim something the
data does not say, so the panel says "targets" and the comment block above the table says why.

## Plan

- [x] Find whether the numbers exist anywhere reachable. They do: ClassCodex ships
      `Data/db_ugg.lua` with `statTargets` per spec, per hero talent, per context, per percentile
      bin, and `Data/Druid/archon-stats.lua` with a simpler one-set-per-spec table. The richer one
      was chosen.
- [x] Bake them in at author time, as the trinket tiers already are. `update-trinket-tiers.ps1`
      is renamed `update-classcodex-data.ps1` and now writes two generated blocks from the one walk
      of the one source, so they cannot disagree about which ClassCodex version they read.
- [x] Read the player's current ratings, their spec and their hero talent at runtime.
- [x] Work out what an item would change, against the piece it would actually replace.
- [x] Draw it as four bars, in all three places.
- [x] Offline checks for everything that is pure logic.

## What was built

**One generated table, four helpers, three surfaces.**

`STAT_TARGET` in `DjinnisBiS.lua`, between `-- BEGIN/END GENERATED STAT TARGETS`. Four specs, three
hero keys each (`all` plus the two real hero trees), raid and Mythic+, four stats. 24 rows. The
top-20% bin only: u.gg also publishes top 50% and top 80%, and a selector between three bins is a
control nobody asked for.

The helpers, all in `DjinnisBiS.lua`:

- `ratingOf(stat)` reads `GetCombatRating`, out of combat only, and serves the last good reading
  during combat. Ratings move with every proc, so a mid-fight read makes a bar that jitters and a
  comparison that means nothing.
- `targetsFor(spec, context)` returns the four targets **and** the hero key they came from. A nil
  hero means the aggregate was used, and the pane says so on screen rather than quietly showing a
  number that can be half the right one.
- `deltaAgainstEquipped(link)` returns four rating deltas against the piece the item would replace.
- `statVerdict(current, target)` says at, above or below, with a 5% band around the target.

The surfaces: a Stats tab in `/bis`, a pane anchored beside `CharacterFrame`, and lines added to any
gear tooltip by the post-call that was already there.

## Three things worth knowing before changing this

**The pane never touches Blizzard's character frame.** It is anchored to its outside edge and
nothing Blizzard owns is moved, resized, reparented or hidden. That is what lets it coexist with
Chonky Character Sheet, which reskins that frame hard: two addons editing the same textures would
fight, and riding alongside takes that fight off the table.

**For a slot you wear two of, the comparison is against the WEAKER piece, measured by summed
secondary rating and not by item level.** A higher-item-level ring with the wrong two stats is
exactly the thing this pane exists to catch, so measuring "weaker" by item level would have the
comparison ignore the question it was built to answer. An empty slot counts as zero rather than
being skipped: an empty ring finger is a real comparison and the honest answer is "all of it".

**`GetCombatRating` is flagged `SecretWhenUnitStatsRestricted` in Blizzard's own API
documentation.** There is a documented state where every rating arrives as a 12.1 secret value,
which may not be compared or used in arithmetic, and `type()` still answers `"number"` for one. The
guard used is `canaccessvalue`, falling back to `issecretvalue`. **This is a workspace-level
finding**: `docs/DECISIONS.md` records that the `type()` guard cannot see a secret and does not yet
name the two globals that can.

## Refreshing the data

Two commands, in this order. The first is new to this card's write-up and was not previously
recorded anywhere in this addon:

```powershell
python C:\Dev\WoWAddons\WoWClassCodexDownloader\download_classcodex.py
.\update-classcodex-data.ps1 -WhatIf
.\update-classcodex-data.ps1
```

The Python tool pulls ClassCodex straight from its own CDN, so the data no longer waits on
CurseForge. `update-classcodex-data.ps1` reads disk only. It is idempotent, and it now ignores the
date stamp when deciding whether anything changed, so re-running it on a later day no longer reports
a change that is only a moved date.

## Checks

Offline, via `/bis test`, all passing:

- every spec has an `all` fallback set, with both contexts and all four stats
- every hero key in the table is a slug `heroSlug()` can actually build, or the lookup would miss
  and every player would silently get the aggregate
- `heroSlug` handles spaces, the plain apostrophe and the typographic one
- `statVerdict` at its 5% boundaries
- `barX` clamps, climbs, and leaves headroom above the target

**The bar checks were rewritten after a mutation test found them worthless.** The first version
asserted `barX(1000, 1000) == BAR_W / BAR_SCALE`, which is the formula restated and agrees with any
value of `BAR_SCALE`. Setting `BAR_SCALE = 1.0` did not fail it. They now assert facts about the
drawing instead, and that same mutation does fail them.

## What a person has to look at

**None of the three surfaces has been seen by anybody.** No agent can run a game client, so this is
built and parsed and offline-checked, and not verified.

- [ ] `/bis`, third tab, "Stats". Four bars, a Raid/Mythic+ button, the spec buttons above.
- [x] Open the character sheet. A pane should appear on its right, following it open and closed.
      **Seen 2026-09-07. It appeared and it overlapped**, which is the Comments entry below.
- [x] With Chonky Character Sheet enabled, the pane clear of the stat columns. **Confirmed
      2026-09-07 at v0.11.2.** Dragging the sheet carries it, confirmed at the same time.
- [x] The pane the same width as the stat column beside it, rows on the same backing, title centred
      like Chonky's section titles. **Confirmed 2026-09-07 at v0.11.3.**
- [x] Drag the sheet to the right edge of the screen. The pane should swap to its left side.
      **Confirmed 2026-09-07 at v0.11.3.**
- [ ] **The heading must name your hero talent, not say "all hero talents".** It said the wrong one
      through every look so far and nobody caught it, because the fallback is a sentence rather than
      an error. Fixed at v0.12.0 and not looked at.
- [ ] **Hover a one-handed weapon while wearing a two-hander.** The footer should name the
      two-hander, not "an empty slot", and mastery should go DOWN. Fixed at v0.12.0 and not looked
      at.
- [ ] Hover a piece of gear in your bags. Both open panes should show a ghost segment, and the
      tooltip should gain a line per stat the item carries.
- [ ] Hover a ring when you are wearing two. The comparison should be against the weaker one.
- [ ] The heading should name your hero talent. If it says "all hero talents" while you have one
      chosen, the slug did not match and that is a bug, not a display choice.

## Comments

**2026-09-07, first look in a live client (Rob).** The pane worked and sat **on top of** Chonky
Character Sheet's stat columns, and looked like a bolted-on box rather than part of the sheet.
Fixed at v0.11.1.

**The anchoring bug is worth writing down, because the obvious fix is the wrong one.** The pane was
anchored to `CharacterFrame`'s own `TOPRIGHT`, which reads as correct and is not: **a child frame is
not clipped to its parent**, so a sheet replacement can widen what is on screen without
`CharacterFrame`'s own bounds moving at all. Chonky does exactly that. Its stat sections descend
from `CharacterStatsPane` and reach several hundred pixels past the frame they belong to, so
`CharacterFrame:GetRight()` was still reporting the narrow default and the pane landed inside the
sheet.

The fix measures rather than asks: `sheetRightEdge()` walks `CharacterFrame`'s shown descendants to
depth 4 and takes the furthest right any of them reaches. That is correct for a plain sheet, for
Chonky, and for whatever replaces Chonky, and it needs to know nothing about any of them. It runs
when the sheet opens, again on the next frame (hook order is not ours to assume, and a sheet
replacement lays its panels out in its own `OnShow`), and on resize and drag.

**Styling now matches rather than resembles.** The pane wears the same backdrop Chonky's own
sections wear: `UI-DialogBox-Border`, `edgeSize` 6, insets of 2. **Chonky's border colour is read off
the finished article, not copied from its source.** It lets the player recolour borders, including
"use my class colour", and keeps that choice in a private table this addon cannot see; but every
section it draws is a named global frame, and a frame's backdrop colour is public. So
`CCS_Section_SECONDARY:GetBackdropBorderColor()` is asked, and Blizzard's grey is the fallback.
Nothing is copied out of Chonky's code, which matters: it ships **All Rights Reserved, may not be
redistributed or modified**, unlike ClassCodex, which is MIT.

The pane also now sizes itself to its footer instead of guessing. The footer is one line or two
depending on what it is saying, and the guess is what put text outside the border in the screenshot.

**2026-09-07, second look (Rob). The v0.11.1 fix overshot: the pane landed in the middle of the
screen, and it did not follow the sheet when it was dragged.** Two separate faults in one change,
and both are worth keeping written down because both looked right.

**The measurement was too trusting.** `sheetRightEdge()` walked every descendant of
`CharacterFrame` and took the furthest right of them. Other addons parent frames to
`CharacterFrame`, and **a frame's own `IsShown` flag reads true even when an ancestor is hidden**, so
`IsShown()` is not "visible": the walk found something far away, believed it, and put the pane there.
It now asks three named Blizzard frames instead, `CharacterFrame`, `CharacterFrameInsetRight` and
`CharacterStatsPane`, and takes the widest. Those are what the sheet is made of, a replacement fills
them rather than escaping them, and a fixed list cannot run away. `IsVisible()` is used now, not
`IsShown()`.

**Anchoring to coordinates is not anchoring.** The point was set to `UIParent` with a measured x and
y, so it was correct at the instant it was set and then sat still while the sheet was dragged out
from under it. The point is now set to the widest sheet frame itself, so a drag carries the pane
along for nothing. `OnSizeChanged` and `OnDragStop` are still hooked, but only for the two things an
anchor cannot do: the sheet changing width, and a drag that carries it near enough to the edge of
the screen that the pane should swap to the other side.

**It swaps sides now rather than going off screen**, which was an open question on the first pass
and is answered rather than left.

**2026-09-07, third look (Rob).** Position confirmed good, dragging confirmed glued. Two things
left, and both are fixed at v0.11.3.

**Swapping sides only worked on a window resize, not on a drag.** `CharacterFrame` is not movable in
Blizzard's own UI, so whatever is dragging it in Rob's client is another addon, and that addon starts
and stops the move by calling the frame's own `StartMoving` and `StopMovingOrSizing` rather than
through `CharacterFrame`'s drag scripts. Hooking `OnDragStop` therefore caught nothing. It now also
hooks the METHOD, with `hooksecurefunc(CharacterFrame, "StopMovingOrSizing", place)`, which catches
any addon moving it the ordinary way. The script hook stays for one that moves it another way.

**"Still doesn't quite match."** Chonky's numbers are now used rather than approximated, and they
were read out of its source rather than guessed at: content rows on `0.05` black at 60%, section
headers on `0.1` black at 40%, sections 238 wide. Three changes follow. Each stat row now sits on the
row background, so the pane reads as a list of rows instead of four floating bars. The title bar is
the header colour and the title is centred, which is where Chonky puts its section titles. And the
pane takes its width from `CCS_Section_SECONDARY:GetWidth()` when that exists, so it lines up with
the column beside it instead of being 300 wide next to 238.

**That width read forced a build-order change worth knowing about.** Chonky builds those sections
when the character sheet is FIRST OPENED, in its own `OnShow`, so at `PLAYER_LOGIN` there is nothing
to read and the pane would take its fallback width and keep it for the session. The pane is now
built on the first frame after the sheet is first opened. That also makes hook order irrelevant,
which the placement code had been working around with a deferred re-place.

**The bar maths is no longer tied to one width.** `barX` takes the width as an argument and the
check for it now includes a narrow pane, because a bar sized off another addon's frame is a bar that
can be any width.

**2026-09-07, fourth look (Rob). Styling and side-swap both accepted.** But his screenshots carried
**two faults he did not flag**, and both are the card's actual subject rather than its chrome. Fixed
at v0.12.0.

**The hero talent was never being read, so every player was getting the aggregate.** The pane said
"all hero talents" and the footer said "No targets for your hero talent" while Rob had one chosen.
The cause: **`C_Traits.GetSubTreeInfo` takes `(configID, subTreeID)`, both of them**, and this addon
was calling it with the subtree alone. It returns nothing, the `pcall` succeeds, `activeHero()`
answers nil and the fallback runs. **That is the whole point of the card failing silently and
looking like a design choice**: for Feral raid the aggregate wants 775 crit and Druid of the Claw
wants 1225. Checked against `wow-ui-source`'s `SharedTraitsDocumentation.lua`. ClassCodex gets this
right by trying one argument and falling back to two, which is why its panel worked and this one did
not.

**A one-handed weapon was compared against an empty off-hand while a two-hander was equipped.** Rob
hovered a dagger while wearing a staff and the pane said "vs an empty slot", reading as pure gain,
when what actually happens is the staff comes off and its mastery goes with it. **An empty slot wins
on a total of zero, always**, which is correct for a bare ring finger and wrong the moment a slot
that cannot be used is in the list. Anything one-handed, main hand or off hand, now compares against
slot 16 when the main hand holds a two-hander.

**The pick is now a pure function, `weakestOf`, with five checks on it**, including both sides of
that rule. A mutation test confirmed they bite: flipping `<` to `>` fails three of them.

## Links

- `0002` is where the trinket tiers came from, and this card renames the script that card wrote,
  from `update-trinket-tiers.ps1` to `update-classcodex-data.ps1`. Read that card's Refresh section
  before running either.
- `WoWAddons` `docs/DECISIONS.md` holds the two 12.1 traps this card had to work inside, and is
  missing the `canaccessvalue` / `issecretvalue` finding above.

## Comments

- 2026-09-21 Claude, from two of Rob's in-game screenshots at 0.12.0, Feral, Druid of the Claw,
  with Chonky Character Sheet and Baganator open:
  - **Working, out of combat.** The pane sits beside the sheet with four bars against the Mythic+
    targets. Hovering Ula'tek's Bind in Baganator drew ghost segments on all four bars and added
    tooltip lines "Against your Mythic+ targets, versus what it replaces: Crit -61, Haste +148,
    Mastery -80", naming Vile Alchemist's Band as the piece replaced. So the hero talent is now read
    (the header says "druid of the claw") and the hover path works through Baganator.
  - **Broken in combat.** An earlier screenshot the same day, taken while hitting a dummy, showed
    every bar as `0 / <target>` and the sheet's GCD line as `<Secret>`. The ratings come back
    secret in combat and the pane draws them as zero. It should hold the last value read out of
    combat, the way the Feral combo point module in `DjinnisUIEnhancements` does, or hide until
    combat ends. Not yet fixed.
  - **Not seen:** whether the Mythic+ / Raid switch in the pane's header works. Rob raids, so it
    matters which one is showing.
