# 0047 Which Feral dungeon build carries Double-Clawed Rake

## Why

Rob, 2026-09-24: "recheck builds, the dungeon build for example doesnt seem to have double clawed
rake which seems like a no brainer to me".

## What was checked

- `python update-builds.py --check` says the BUILDS block matches Dreamgrove's four compendiums
  today. No build is stale.
- `Dungeon` (Feral) is the guide's `DOTC` build, copied exactly. The guide leaves out Double-Clawed
  Rake (node 82086) on purpose and takes Tireless Energy (node 82121) instead: "a simple single
  target vs AoE choice. I went with Tireless Energy in the default build, as Incarnation: Avatar of
  Ashamane does lose you a bit of single target, but they are both compelling options."
- The two are separate nodes, not one choice node. Swapping them means moving points, not flipping
  a choice bit.
- The guide's `Wildstalker` build takes Double-Clawed Rake. `PICK` in `update-builds.py` leaves it
  out. The guide says Wildstalker "is just as good" for M+, and "For Wildstalker you should be
  playing Double Clawed Rake most of the time".
- Other guide builds `PICK` leaves out: Balance `Keeper of the Grove - Single Target` and
  `Keeper of the Grove M+`; Guardian `Apex`, `EC Raid 1m Convoke`, `EC Raid Incarn`, `Nopex`,
  `Nopex w/ Raze`, `Raze`. Not raised: Rob did not ask for them.

## What I need from you

Pick one. This is a preference: both are sound by the guide.

1. **Add the guide's Wildstalker build as `Dungeon: Wildstalker`** (recommended). One line in
   `PICK`, then `python update-builds.py`. It comes from Dreamgrove and is refreshed with the rest.
   Costs one more loadout slot per Feral character, or a trip through the spare.
2. **An own Druid of the Claw dungeon build with Double-Clawed Rake in place of Tireless Energy.**
   The updater would have to rebuild it by moving points after every guide change, and no guide
   checks it. Next question if picked: which talent gives up its point on the path to Double-Clawed
   Rake.

## Acceptance

- [x] Rob picks 1 or 2. (2, through Archon's string; see Comments.)
- [ ] WHEN `update-builds.py` runs, THE FERAL `Dungeon` BUILD SHALL be the pinned Archon string, and a pinned string that fails the points check SHALL stop the run. proves: `python update-builds.py --check` exits 0; the broken-string run above exits 1
- [ ] Rob's `Dungeon` loadout, reset to plan, has Double-Clawed Rake and not Tireless Energy. proves: manual

## Comments

**2026-09-24** What players run. Archon is behind a human check, so Rob pasted its page and a
screenshot: Feral, Mythic+, High Keys, all dungeons. That is the top 5% of keys over 14 days,
2,600 parses, +20 and +21. It is not +12 to +18. I decoded the page's `exportCode` strings with
`update-builds.py`'s reader and the Raidbots tree:
- Druid of the Claw 98.5%, Wildstalker 1.4%.
- **Every build on the page takes Double-Clawed Rake. None takes Tireless Energy.**
- The recommended build (39.5%) is Dreamgrove's `DOTC` with one change: Double-Clawed Rake in place
  of Tireless Energy. So option 2 needs no hand-moved points. It is Archon's string as it stands.
- Alt #1 (28.4%): Convoke and Hunger for Battle, in place of Incarnation and Ashamane's Guidance.
- wowvalor.app, top 50 Feral players: Double-Clawed Rake 94%, Tireless Energy 6%.

A second Archon page from Rob: +7 to +21, 47,977 runs. Druid of the Claw 91.9%. Its recommended
build (33.1%) has Double-Clawed Rake on and Tireless Energy off. None of its three alternatives
change either talent.

That makes option 1 (Wildstalker) the 1.4% choice, and moves the recommendation to **option 2**.
Its cost is now smaller: `update-builds.py` would keep Archon's string pinned, since Archon cannot
be fetched unattended. The points check still fails loudly when a tree change breaks it.

**2026-09-24** Rob: "Option 1 looking good so far". In the chat, option 1 was: replace the Feral
`Dungeon` build with Archon's High Keys recommended build. That is this card's option 2, with
Archon's string rather than hand-moved points.

**2026-09-24** Builder, v0.39.4.
- `update-builds.py` gains `PIN`: builds no guide publishes, each with its source. They get the
  same spec and points check as guide builds, and are never refreshed. Feral `Dungeon` is pinned to
  Archon's High Keys #1 string. `DOTC` leaves `PICK`.
- The BUILDS block is regenerated. Only Feral `Dungeon` and the read date change.
- Checked: `--check` then passes. A pinned string with 3 characters broken is refused
  ("points {'specNodes': 13, 'classNodes': 17}"). `offline-check.lua` shows no FAIL lines under
  both Luas.

## What I need from you, now

1. `/reload`. Open the talent window as Feral. Pass: the `Dungeon` row shows as not matching its
   loadout (the stored build moved).
2. `/djbis loadouts`, then **Reset to plan** for `Dungeon`. Pass: the tree has Double-Clawed Rake
   and no Tireless Energy, with every other talent the same as before.
