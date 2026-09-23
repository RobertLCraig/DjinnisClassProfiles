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

- [ ] Rob picks 1 or 2.
