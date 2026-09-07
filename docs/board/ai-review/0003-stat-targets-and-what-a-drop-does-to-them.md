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
- [ ] Open the character sheet. A pane should appear on its right, following it open and closed.
- [ ] With Chonky Character Sheet enabled, the same pane, still not overlapping.
- [ ] Hover a piece of gear in your bags. Both open panes should show a ghost segment, and the
      tooltip should gain a line per stat the item carries.
- [ ] Hover a ring when you are wearing two. The comparison should be against the weaker one.
- [ ] The heading should name your hero talent. If it says "all hero talents" while you have one
      chosen, the slug did not match and that is a bug, not a display choice.

## Links

- `0002` is where the trinket tiers came from, and this card renames the script that card wrote,
  from `update-trinket-tiers.ps1` to `update-classcodex-data.ps1`. Read that card's Refresh section
  before running either.
- `WoWAddons` `docs/DECISIONS.md` holds the two 12.1 traps this card had to work inside, and is
  missing the `canaccessvalue` / `issecretvalue` finding above.
