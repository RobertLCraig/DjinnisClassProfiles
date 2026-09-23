# 0047 Each spec's dungeon build is the one players run (began with Feral's Double-Clawed Rake)

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
- [ ] WHEN `update-builds.py` runs, EACH SPEC'S `Dungeon` BUILD SHALL be its pinned Archon string, and a pinned string that fails the points check SHALL stop the run. proves: `python update-builds.py --check` exits 0; the broken-string run above exits 1
- [ ] Each spec's `Dungeon` loadout, reset to plan, matches Archon's recommended +7 to +21 tree. proves: manual

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

**2026-09-24** Builder, after the review.
1. The class-tree change is real, and it is the right row. In Rob's pasted page, the first
   `exportCode` comes straight after the "Recommended Class Tree" row (64.7%). wowvalor's top 50 M+
   Feral players take Lycara's Inspiration 100%, Ursine Vigor 82%, Innervate 12% and Forestwalk 2%.
   So the string stays. What was wrong was my description: the `PIN` comment now names all three
   swaps, and so does step 2 below. The commit message of `a8ddeb1` stays wrong, and this comment
   corrects it.
2. `block()` stops when `PIN` names a spec that `SPEC_ID` does not. Tested on a copy with
   `"feral"`: exit 1, and "PIN names a spec SPEC_ID does not: ['feral']".
3. `/djbis talents` labels BUILDS rows "(plan)", not "(Dreamgrove)". `BUILD_SOURCE` and the two
   comments now name the pinned builds.
4. The pinned-name checks use `sys.exit`, not `assert`.

`--check` exits 0. `offline-check.lua` shows no FAIL lines under both Luas.

**2026-09-24** Re-review of `b84b841`, the fixes for the four findings above. **Verdict: `b84b841`
is clean, but the card stays in `ai-review/`.** While this pass ran, at 00:23, uncommitted changes
appeared in `DjinnisBiS.lua` and `update-builds.py`. They replace the string reviewed here (see the
end of this comment). Every check below ran on a clean tree at `b84b841` and finished by 00:22:43.

Finding 1 holds: the right row, and the description now matches it.
- Rob's pasted page: the first `exportCode` sits under "Recommended Feral Druid Talent Tree Build"
  (Spec & Hero Popularity 39.5%, 2,600 runs). Within that build it is the "Recommended Class
  Tree" alternative (64.7%). It matches the `PIN` string character for character. The next three
  codes are Alternative Class Trees #1 to #3 (8.3%, 6.3%, 2.6%).
- wowvalor, fetched with `curl` today: Lycara's Inspiration 50 of 50, Ursine Vigor 41, Innervate 6,
  Forestwalk 1. That is 100%, 82%, 12% and 2%, as claimed. Double-Clawed Rake is 47 of 50 and
  Tireless Energy 3.
- The `PIN` comment and step 2 name all three swaps. The message on `a8ddeb1` stays wrong, and the
  builder's comment above says so.

Finding 2 holds. On copies in `$TEMP`, under `--check`, a write, and `-O --check`: `"feral"`
exits 1 ("PIN names a spec SPEC_ID does not: ['feral']"). `"Feral "` with a broken string, which
used to exit 0, now exits 1 with the same message. The Lua is untouched in both cases.

Finding 3 holds. `/djbis talents` prints "(plan)", `BUILD_SOURCE` names `PIN`, and the Python and
Lua copies of that line match. No test or doc expects "(Dreamgrove)". Not blocking:
- Two comments still call every build Dreamgrove's: the block header at `DjinnisBiS.lua` line 514
  and the `BOSSES` header at line 568 ("The loadout is Dreamgrove's build for that boss"). So does
  the `update-builds.py` docstring.
- "(plan)" prints just under the gear-plan cell rows, which print "(st)", "(2t)" and so on, so it
  can read as "from the gear plan". "(stored)" would not.

Finding 4 holds. A `PICK` name, a quote, and a 34-letter name each exit 1 with a `sys.exit`
message and no traceback, and they do the same under `-O`. A 29-letter name is written, as it
should be. The `PICK` loop's own `assert` (line 168) predates this card and guards constant names,
so I have not raised it.

Newly broken: nothing in code. `PYTHONDONTWRITEBYTECODE=1 python update-builds.py --check` exits
0 and leaves no `__pycache__`. `offline-check.lua` prints "no FAIL lines" under Lua 5.1.5 and
5.4.6. A broken pinned string still exits 1. That settles acceptance 2's `proves:`, but I have not
ticked it: the uncommitted change replaces the string it covers. One doc slip: `docs/HANDOVER.md`
line 219 says v0.39.5 was "deployed 2026-09-23". The game folder's copy is byte-identical to
`b84b841` and was written at 00:19 on 2026-09-24. I have not fixed it, because the uncommitted
work will move that line again.

Step 4 (look at it in a browser) does not apply. There is no game client, and the only UI effect
is a stored talent string and one label in `/djbis talents`. The in-game check stays with Rob,
below.

Security, for the fixes:
1. **Weakest point:** unchanged. The points check is the only guard on a pasted string, so a string
   with the right counts and the wrong talents still passes. Finding 1 was settled against the
   source page, not by the tool.
2. **Unchecked:** `PIN`'s spec keys are checked now. Nothing else new takes input.
3. **Leaks:** nothing. The new messages print a spec key or a loadout name.

**Why the card does not move.** At 00:23:05 and 00:23:19 another session changed `update-builds.py`
and `DjinnisBiS.lua` and did not commit. It pins a `Dungeon` build from "Archon M+ +7 to +21 #1"
for all four specs. That drops `Elune's Chosen M+`, `Razeless` and `M+ #HealersHeal` from `PICK`,
turns Resto's "Dungeon: heal only" into "Dungeon", and gives Feral a different string from the one
reviewed here. None of it is reviewed, and the step 2 pass line below may not hold for it. Moving
the card to `human-review/` would hand Rob an unreviewed build. Next: when that work is committed,
review it on this card.

**2026-09-24** Builder, v0.40.0: all four specs. Rob: "replicate what we have done for Feral, for
all the other specs too".
- wowvalor's top 50 M+ players per spec first showed where Dreamgrove's dungeon builds differ from
  what is played. Guardian's is the wrong hero tree (Druid of the Claw; players 100% Elune's
  Chosen). Balance has 7 talents different. Each Resto build has 4 to 6 different.
- Rob's pasted Archon pages for Balance, Guardian and Resto rendered the right spec. But their
  embedded `exportCode`s were all Feral's (spec 103, and `totalParses` 2600, the first page's). So
  Rob copied each recommended build with Archon's Export button, at Mythic+ +7 to +21, all
  dungeons, and pasted the four strings.
- Each string decodes to its own spec, with 34/34/13 points. Against the build each replaces
  (corrected in v0.40.1: generated node by node, live hero tree only, not written by hand. "(2)" is
  the rank. A talent in both lists changed rank, for example Matted Fur 1 to 2):
  - Balance, against Dreamgrove's `Elune's Chosen M+`: hero tree Elune's Chosen.
    - Takes: Astral Influence, Elune's Guidance, Fluid Form, Lycara's Inspiration, Orbit Breaker,
      Sunseeker Mushroom.
    - Leaves: Killer Instinct (2), Meteorites, Perfectly-Honed Instincts, Stellar Amplification,
      Sundered Firmament.
  - Feral, against Dreamgrove's `DOTC`: hero tree Druid of the Claw.
    - Takes: Convoke the Spirits, Double-Clawed Rake, Hunger for Battle, Lycara's Inspiration,
      Ursine Vigor.
    - Leaves: Ashamane's Guidance, Forestwalk, Incarnation: Avatar of Ashamane, Innervate, Tireless
      Energy.
  - Guardian, against Dreamgrove's `Razeless`: hero tree Druid of the Claw to Elune's Chosen.
    - Takes: Atmospheric Exposure, Bask in Moonlight, Elune's Chosen, Fury of Nature (2), Glistening
      Fur, Lunar Calling, Lunar Insight, Lunation, Matted Fur (2), Moon Guardian, Moondust, Penumbral
      Swell, Perfectly-Honed Instincts, Star Cascade, Stellar Command, The Eternal Moon, The Light
      of Elune.
    - Leaves: Aggravate Wounds, Bestial Strength, Claw Rampage, Dreadful Wound, Druid of the Claw,
      Empowered Shapeshifting, Exacerbating Wounds, Fluid Form, Fount of Strength, Harnessed Rage,
      Instincts of the Claw, Killing Blow, Killing Strikes, Limb from Limb, Matted Fur, Pack's
      Endurance, Strike for the Heart, Twin Claw, Wildshape Mastery.
  - Resto, against Dreamgrove's `M+ #HealersHeal`: hero tree Wildstalker.
    - Takes: Forestwalk (2), Grievous Wounds, Heart of the Wild, Innervate, Rake, Rip, Swipe,
      Thriving Vegetation (2), Wild Charge.
    - Leaves: Astral Influence, Forestwalk, Killer Instinct, Lore of the Grove, Nurturing Dormancy,
      Perfectly-Honed Instincts, Starfire, Starsurge, Thriving Vegetation, Tiger Dash, Ursine Vigor.
- **Resto's "Dungeon: heal only" is renamed "Dungeon"**, because the new build weaves cat. Every
  spec's main dungeon build is now "Dungeon". Balance and Feral boss rows already use that name.
  Guardian and Resto have no boss rows. Rob's old "Dungeon: heal only" loadout will list under
  Your loadouts.
- These keep Dreamgrove: Guardian "Dungeon: survive more", and Resto "Dungeon: cat damage" and
  "Dungeon: caster damage".
- The re-review's three wording notes are fixed: the two comments and the docstring now name the
  pins, and the `/djbis talents` label reads "(stored build)".

**2026-09-24** Adversarial review of `dabbba2` (v0.40.0, all four specs). **Verdict: findings, back
to `todo/`.** Every string is sound and every guard holds. What fails is the description of two of
the four strings, a comment that regressed, and two small gaps around the Resto rename.

What held:
- `PYTHONDONTWRITEBYTECODE=1 python update-builds.py --check` exits 0 ("BUILDS block already
  current") and leaves no `__pycache__`. The first run timed out on the Raidbots handshake, and the
  retry passed. `offline-check.lua` prints "no FAIL lines" under Lua 5.1.5 and 5.4.6.
- Each pinned string decodes, with `update-builds.py`'s `Bits` and `points` and Raidbots'
  `talents.json`, to version 2, its own spec (102, 103, 104, 105) and 34/34/13 points. Guardian's
  live hero tree is Elune's Chosen. The other three keep theirs.
- Rob's three Archon pages: the builder's claim is right. Each renders its own spec ("Balance
  Druid" and so on, 11 times each), but all 9 embedded `exportCode`s on each page begin `CcGA`,
  which is spec 103, and `totalParses` is 2600 on all three. That is the Feral High Keys page's
  payload. The rendered numbers match the `PIN` comments: Balance Elune's Chosen 98.7% of 110,634,
  Guardian Elune's Chosen 99.2% of 177,831, Resto Wildstalker 88.0% of 78,289.
- The GENERATED block holds the four `PIN` strings character for character. The game folder's
  `DjinnisBiS.lua` and `.toc` are byte-identical to `dabbba2`.
- Mutations of a copy in `$TEMP`, never the repo:
  - Resto's pin with 3 characters broken, Guardian's pin holding Resto's string, Balance's
    truncated by 10: each exits 1 with a points or spec message, and the Lua is not written.
  - Resto's pin renamed to `Dungeon: cat damage`, and Guardian `"Razeless": ["Dungeon"]` put back
    in `PICK`: each exits 1 ("already a PICK name").
  - Balance's `PIN` entry deleted: `--check` exits 1. See finding 4 for the write run.
- The attack on the rename. Nothing in `DjinnisBiS.lua` still expects "Dungeon: heal only",
  "Razeless", "Elune's Chosen M+" or "M+ #HealersHeal". Guardian and Resto have no `BOSSES` rows,
  and neither has a gear-plan cell, so `setupSteps` offers them no loadout at all. The prompt
  checks at lines 10112 to 10216 name only Feral's `Dungeon`. Their Healer case checks the change
  to Resto, and no loadout. The only Guardian check that names builds, line
  8324, expects "Dungeon; Dungeon: survive more" and passes. `offline-check.lua` names none of
  them. The "M+ Razeless" and "M+ HealersHeal" in `RETIRED` are DjinnisDreamgrove 0.6.0's names,
  not these.
- Row order is not a problem. `PlanTab.BUILDS` is a hash, and its readers sort (`sidebarList` at
  line 5919, `loadoutGaps` at 6459) or do not care (`sayTalents`). `--check` compares text, and
  the generator is deterministic (`SPEC_ID` order, then `PICK`, then `PIN`), so the order cannot
  make a false "out of date".
- Balance's "against" list is exact, to the rank. So is Feral's against the High Keys pin (Convoke
  and Hunger for Battle for Incarnation and Ashamane's Guidance). Neither hero tree changed.

**Finding 1 (wording): the Guardian and Resto "against" lists are wrong.** Decoded node by node
against `Razeless` and `M+ #HealersHeal` from today's compendiums, live hero tree only, by rank:
- Guardian, class and spec trees: the pin adds Matted Fur 1 to 2, Perfectly-Honed Instincts and
  Fury of Nature 2. That is 4 points. It drops **Fluid Form, Instincts of the Claw, Harnessed Rage
  and Killing Blow**, which the list leaves out. Moondust is not a class or spec talent: it is
  node 94597 in the Elune's Chosen hero tree.
- Resto: the list is right except that it leaves out **Forestwalk 1 to 2**. The adds come to 9
  points and the drops to 9, and the list has 8 adds.
The same mistake was finding 1 of the first pass. Rob's step 2 does not use these lists, so it does
not break his check, but the card is the only record of what each string changed.

**Finding 2 (wording, a regression): the Feral `PIN` comment names 1 of 5 swaps.** It says
"replaced "DOTC": Double-Clawed Rake, not Tireless Energy". Against `DOTC` the string now makes five:
Double-Clawed Rake for Tireless Energy, Lycara's Inspiration for Forestwalk, Ursine Vigor for
Innervate, Convoke for Incarnation, and Hunger for Battle for Ashamane's Guidance. `b84b841`
named the first three, and this commit dropped them.

**Finding 3 (minor, code): "Dungeon: heal only" is not in `PlanTab.RETIRED`.** The addon made that
loadout, but now it lists under Your loadouts, as if Rob had made it. `/djbis tidy` will not remove
it, and it takes a loadout slot from the new "Dungeon". Every rename before this one went into
`RETIRED`, for example Balance's per-boss names. Adding it is one entry. No live build has that
name, so `tidy`'s live-name guard is not a problem. Step 3 below then becomes `/djbis tidy`.

**Finding 4 (minor, guard): nothing stops Resto's `Dungeon` from vanishing.** Deleting a spec's
`PIN` entry and running without `--check` exits 0 ("BUILDS block written") and removes that spec's
`Dungeon`. The harness catches it for Balance and Feral ("every boss row has a stored build") and
for Guardian (the sidebar check at 8324). It does not catch it for Resto: with Resto's `Dungeon` row
deleted, renamed back to "Dungeon: heal only", or holding Guardian's string, `offline-check.lua`
prints "no FAIL lines" under both Luas. Acceptance 2 promises a `Dungeon` for each spec. The fix
is one line in `block()`: stop when a spec has no `Dungeon` after `PICK` and `PIN`.

Not findings. These are for Rob, because the card's title says "the one players run":
- **Feral**: this string differs from Archon's High Keys #1 (the old pin) on 2 nodes, and on both
  it is the minority choice among wowvalor's top 50 M+ Feral players: Convoke 19 and Incarnation
  31, Hunger for Battle 17 and Ashamane's Guidance 31. The same string is an alternative in the High
  Keys page's own `exportCode` list. Double-Clawed Rake, the card's reason, is 47 of 50.
- **Resto**: wowvalor's top 50 agree with 10 of the 18 point moves. Archon's Top 100 tree (rendered
  on Rob's Resto page, which is the right spec) shows the same split. The pin takes Swipe (27.4%
  of the top 100, 11 of 50 on wowvalor), Grievous Wounds (43.6%, 17), Nature's Bounty (25.5%, 6)
  and Regenerative Heartwood (27.2%, 6). It leaves out Nurturing Dormancy (68.8%, 33). Rake and Rip
  are 23 of 50. The +7 to +21 pick is the most-run build, and not what the top players run. It is
  also why "heal only" was renamed.
- **Balance** agrees with wowvalor on all 11 point moves, and **Guardian** on all 33.
- Guardian's "Dungeon: survive more" is still Dreamgrove's `Razeless sustain`, a Druid of the
  Claw build, while "Dungeon" is now Elune's Chosen. The name suggests a variant of the same build.

Step 4 (look at it in a browser) does not apply. There is no browser and no game client. The only
UI effects are four stored talent strings, one renamed loadout (Resto "Dungeon: heal only" to
"Dungeon") and one label in `/djbis talents` ("(stored build)"). The in-game check stays with Rob,
below.

Security:
1. **Weakest point:** unchanged. The points check is the only guard on a pasted string. Three of the
   four strings could not be checked against Archon's own export, because the pages embed Feral's.
   They were checked against the rendered hero-tree share, Archon's Top 100 tree and wowvalor.
2. **Unchecked:** that each spec keeps a `Dungeon` (finding 4). The fetches trust the network as
   before, and this is author tooling that never ships.
3. **Leaks:** nothing. Messages print a spec id, point counts or a loadout name. The strings are
   public.

**2026-09-24** Builder, v0.40.1: the four findings.
1. The v0.40.0 comment's "against" lists are replaced with generated ones. A script decodes each
   pin and the Dreamgrove build it replaced, node by node, live hero tree only, by rank. Feral is
   now against `DOTC`, the build it replaced, not the High Keys pin.
2. The Feral `PIN` comment names all five swaps against `DOTC`.
3. `PlanTab.RETIRED` holds "Dungeon: heal only", so `/djbis tidy` offers it. Step 3 below uses that.
4. `block()` stops when a spec has no `Dungeon` row after `PICK` and `PIN`. On a `$TEMP` copy with
   Resto's `PIN` entry removed, a write run exits 1 ("Resto has no "Dungeon" build") and the Lua is
   byte-identical.
- `update-builds.py --check` exits 0. `offline-check.lua`: "no FAIL lines" under Lua 5.1 and 5.4.
  Deployed with `-WhatIf -Only DjinnisBiS` first: 2 files, 0.40.0 to 0.40.1.
- The reviewer's notes for Rob (Feral's Convoke pick, the Resto split, Guardian "survive more" still
  Druid of the Claw) are relayed to him. They are his calls, not findings.

## What I need from you, now

For each spec, Balance, Feral, Guardian and Resto:
1. `/reload`. Open the talent window. Pass: the `Dungeon` row shows as not matching its loadout,
   because the stored build moved. On Resto, a character with no "Dungeon" loadout shows it as not
   saved.
2. `/djbis loadouts`, then **Reset to plan** (or Create) for `Dungeon`. Pass: the tree matches
   Archon's recommended +7 to +21 tree for that spec. Guardian's hero tree is Elune's Chosen.
3. Resto: `/djbis tidy`. Pass: it lists "Dungeon: heal only" as old. `/djbis tidy yes` deletes it.
   If it is the loadout you have selected, pick another first.
