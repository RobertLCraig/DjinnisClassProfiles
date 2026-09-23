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

**2026-09-24** Adversarial review of a8ddeb1. **Verdict: findings, back to `todo/`.** One finding
blocks the card; three are small.

What held:
- `PYTHONDONTWRITEBYTECODE=1 python update-builds.py --check` exits 0 ("BUILDS block already
  current"), and leaves no `__pycache__`. `offline-check.lua` prints "no FAIL lines" under Lua 5.1.5
  and Lua 5.4.6.
- The `Dungeon` string in the GENERATED BUILDS block is the `PIN` string, character for character.
  The old `Dungeon` string is today's Dreamgrove `DOTC`.
- Mutations of `PIN`, each run on a copy in `$TEMP`, both `--check` and write:
  - A pinned name that is a `PICK` name (`Raid: Sszorak`): exit 1, `AssertionError`, nothing written.
  - Three characters broken: exit 1, "points {'specNodes': 111, 'classNodes': 25, 'heroNodes': 8}".
  - A character that is not base64: exit 1 (`KeyError: '!'`).
  - Truncated, empty, or Guardian's `Razeless` pinned under Feral: exit 1 (spec 104 is refused).
  - A `"` in the name: exit 1.
- Row order: `PIN` rows follow `PICK` rows within a spec. `Dungeon` was already Feral's last row,
  so the block's order is unchanged and `--check` agrees. A second pinned name lands after it.
- Nothing in `DjinnisBiS.lua` depends on the old string. No code names nodes 82086 or 82121, or
  Tireless Energy. `ferals` (line 9069) is a local fixture (`"BBBB"`). The `dreamgrove` string at
  line 7663 is `WS M+` against the gear cell, not `Dungeon`. The checks that use `Dungeon` read it
  from `PlanTab.BUILDS` by reference. Among them, `movePoint(feral.Dungeon)` still makes a real
  edit, and those checks pass.

**Finding 1 (blocks the card): the pinned string is not "DOTC with Double-Clawed Rake for
Tireless Energy".** I decoded both strings node by node with `update-builds.py`'s `Bits` reader
and Raidbots' `talents.json` (spec 103), comparing rank and choice as well as which nodes are
taken. Both are version 2 and spec 103, with 34/34/13 points.
- Spec tree: exactly the claimed swap. `DOTC` has Tireless Energy (82121) at 1 of 2. The pin has
  Double-Clawed Rake (82086) at 1 of 1. Every other spec node matches, rank and choice included.
- Hero tree: identical. `DOTC` also marks Wildstalker's Thriving Growth as granted, which spends
  nothing.
- **Class tree: two more points moved.** `DOTC` takes Forestwalk (82243, 1 of 2) and Innervate
  (82244). The pin drops both and takes Lycara's Inspiration (92229) and Ursine Vigor (100174).
  Nurturing Instinct is 1 of 2 in both.

So the card, the commit message and the `PIN` comment all describe the change wrongly. Step 2
below then fails as written, because "every other talent the same as before" is false: Rob loses
Innervate and Forestwalk. The build is still sound by the guide, which lists all four as flex
talents (yellow or white). What is wrong is the description, the pass line, and an informed
choice about Innervate. Only Archon can say whether its #1 build really drops Innervate, or
whether a different row's `exportCode` was copied, and Archon needs a human check. That makes
this Rob's to settle, not a fix I can make here. Next step: Rob checks the string against Archon's
High Keys #1. If it is right, correct the claim in the `PIN` comment and on this card, and change
step 2's pass line to name the four class talents. If it is wrong, copy the right one in.

**Finding 2 (minor): a `PIN` spec key outside `SPEC_ID` is dropped silently.** `block()` walks
`SPEC_ID` and reads `PIN.get(spec)`. With `"feral"` for `"Feral"`, a write run exits 0 with "BUILDS
block written" and deletes Feral `Dungeon`. A key `"Feral "` holding a broken string also exits 0
under `--check`, because the broken string is never read. For `Dungeon` the harness catches it
("every boss row has a stored build, Feral Mythic+, any key: expected string, got nil"). A pinned
name with no boss row would vanish unnoticed. The fix is one line: exit when
`set(PIN) - set(SPEC_ID)` is not empty.

**Finding 3 (minor, wording): Archon's build is labelled Dreamgrove's.** `/djbis talents`
(`PlanTab.sayTalents`, line 4668) prints "(Dreamgrove)" beside every `PlanTab.BUILDS` row, including
this one. `BUILD_SOURCE` still says "dreamgrove.gg compendiums", though nothing reads it. The
comments at lines 555 and 592 also still call the Mythic+ build Dreamgrove's.

**Finding 4 (minor):** the name checks on a pinned row are `assert`. `python -O` strips them, and a
failure shows a traceback where the other checks print a `sys.exit` message.

Step 4 (look at it in a browser) does not apply. There is no browser and no game client, and the
only UI effect is a changed stored talent string. The in-game check stays with Rob, below.

Security:
1. **Weakest point:** the pinned string is pasted text, and the points check is its only guard. A
   string with the right spec and point counts but the wrong talents passes. Finding 1 is that
   case.
2. **Unchecked:** `PIN`'s spec keys (finding 2). The Raidbots and `gh` fetches trust the network,
   as they did before this card. It is author tooling that never ships (`pkgmeta.yaml` ignores
   `update-builds.py`), and there is no input from a player.
3. **Leaks:** nothing. A failure prints the spec id and point counts, and the addon holds only a
   public talent string.

## What I need from you, now

1. `/reload`. Open the talent window as Feral. Pass: the `Dungeon` row shows as not matching its
   loadout (the stored build moved).
2. `/djbis loadouts`, then **Reset to plan** for `Dungeon`. Pass: the tree has Double-Clawed Rake
   and no Tireless Energy, with every other talent the same as before.
