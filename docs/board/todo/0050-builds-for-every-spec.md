---
needs: 0049
---
# 0050 A dungeon and a raid build for every spec

## Why

Rob, 2026-09-24, for all classes. Dreamgrove covers druids only.

## What is known

- **Archon cannot be read by an agent.** It asks every visitor to prove they are human. The Archon
  desktop app (`%LOCALAPPDATA%\Programs\Archon App`) is archon.gg inside an Overwolf window. Its
  cache holds no build strings. Reading it without a person would mean reusing its human-check
  cookie, which we do not do. Rob can still copy a string with Archon's Export button, as he did
  for card `0047`. A Playwright browser on 2026-09-24 got archon.gg's "Just a moment..." check
  (HTTP 403) and stopped there. Rob's own Edge cannot be driven by an agent.
- **wowvalor.app can be read.** `curl --compressed` with a browser user agent works for any class
  and spec, for example `https://wowvalor.app/en/stats/warrior/arms/m+`. It is the top 50
  characters per spec, so keys of about +20 and up. The page holds per-talent counts and at least
  one full talent string. The Feral check in `0047` showed the two sources agree on the big calls
  (hero tree, Double-Clawed Rake), and differ on smaller ones (Convoke).

## What

- `update-builds.py` fetches a `Dungeon` build (`/m+`) and a `Raid` build (`/raid`) for every
  non-druid spec from wowvalor. Which string on the page is the most-played build must be
  settled first: the Balance page had two.
- A pasted Archon string in `PIN` wins over wowvalor for that spec and name, as it does for druids.
- Every string passes the same spec and points check. The points per tree come from the Raidbots
  tree, not a constant, because other classes may differ from 34/34/13.
- Druid builds are unchanged.

## Acceptance

- [x] WHEN `update-builds.py` runs, EVERY SPEC SHALL have a `Dungeon` build that decodes to its own spec with a full set of points, or the run SHALL stop. proves: `python update-builds.py --check`, and the self-test's "a Dungeon build for each other spec"
- [x] WHEN SimulationCraft has a sound profile for a spec, THAT SPEC SHALL have a `Raid` build, and every spec without one SHALL be named in the run's output. proves: the run's "No Raid build" line
- [x] WHEN a spec has a `PIN` entry, THE PIN SHALL win. proves: a check on a copy
- [ ] Rob, on one alt: `/djbis loadouts` makes "Dungeon" (and "Raid"), and each loads. proves: manual

Acceptance 1 and 2 changed on 2026-09-24 from "a `Dungeon` and a `Raid` for every spec". wowvalor has
no raid pages (its stats are Mythic+ and PvP), and SimulationCraft keeps no profile for the 5
healers or the 3 Evoker specs. See the comment below.

## What I need from you

On one alt that is not a druid (the Death Knight, say), after `/reload`:
1. Open the talent window. Pass: the list beside it shows "Dungeon" under Mythic+ and "Raid" under
   Other builds.
2. `/djbis loadouts`, then Create. Pass: loadouts named "Dungeon" and "Raid" appear in the talent
   window's dropdown, and each one loads without an error. Fail: Blizzard says the import is
   invalid.
3. Optional: if you would rather a spec used Archon's build, copy it with Archon's Export button and
   paste it to me. It goes in `PIN`, and it wins.

## Comments

**2026-09-24** Builder, v0.42.0.
- **Which string on a wowvalor page:** its `recommendedBuild` object, one per page, holding the
  exact build (`importString`), how many of the top 50 run it (`amount`, 8 of 50 for Blood today)
  and the hero tree. The other strings on a page belong to single runs. `valor_dungeon` reads only
  the 800 characters after `recommendedBuild:`.
- **Raid:** wowvalor has none (`/raid` answers "This page does not exist!"). Icy Veins and Wowhead
  answer 403 to a script, and Archon has its human check; none is worked around.
  SimulationCraft's `profiles/MID2/MID2_<Class>_<Spec>.simc` holds a `talents=` line for 28 specs,
  read with `gh api`. `SIMC_TIER` must move with the season.
- **SimC marks the free hero keystone as purchased.** Blizzard's import
  (`CreateImportLoadoutEntryInfoFromSingleNode`) would then buy it, 14 hero ranks against 13, so the
  string would fail in the game. `ungrant` rewrites the free nodes as granted, the way the game
  exports them, with a writer that round-trips all 32 Dreamgrove strings bit for bit. It changed 2
  strings today. Their rows say "free keystone read as granted".
- **A bad string:** a `Dungeon` or a pinned string that fails the check stops the run. SimC's `Raid`
  drops out and is named, because SimC keeps some profiles on a stale tree. Frost Death Knight's
  spends 9 class points. One stale file should not hold back 35 other specs.
- **No Raid today (9):** Holy Paladin, Discipline, Holy Priest, Restoration Shaman, Mistweaver,
  Devastation, Preservation, Augmentation (no profile) and Frost Death Knight (stale).
- **Points:** the check stays 34/34/13, not per tree. All 63 strings from the new sources pass it, so
  it holds for every class. A class that differs one day fails loudly rather than writing.
- **Keys:** from `PlanTab.SPECS` in the Lua, parsed by `lua_specs` (exits unless it reads 40 rows).
  A key with a space is written `["Frost Mage"] = {`. Druid rows are unchanged.
- **Proofs:** `update-builds.py` on a copy with a Blood `PIN`: the pinned string is written. With a
  broken pin, or a pin for "Bloood", it exits 1 and the Lua is byte-identical. In the self-test,
  "a Dungeon build for each other spec" and "a Death Knight's list" (`[Mythic+]; Dungeon; [Other
  builds]; Raid`). Mutations caught: Blood's Dungeon renamed, Arcane's Dungeon removed, Blood's
  Raid removed.
- The list files "Raid" under Other builds, as it does Guardian's raid builds (card `0032`'s rule
  for a build no boss row names). There are no boss rows for other classes, so no zone-in reminder
  either.
- `--check` goes stale whenever wowvalor's recommended build moves, which can be daily. Rerun it
  without `--check` before a deploy.

**2026-09-24** Adversarial review of `a63f003` (v0.42.0). **Verdict: findings, back to `todo/`.**
The tooling is sound and `ungrant` is right. But the Dungeon source is not what the card says it
is, and the generic names can reach a player's own loadouts.

What held:
- Harness. The self-test exits 0 under Lua 5.1.5 and 5.4.6. Spec runs 250, 62, 70 and 1473 exit 0
  under both. `python update-builds.py --check` in the repo: exit 0, "already current", same 9 specs
  with no Raid, tree clean.
- `ungrant`, against Blizzard's own code (`Blizzard_ClassTalentImportExport.lua:70-160`,
  `ExportUtil.lua`). The game exports a granted node as selected 1, purchased 0 and nothing more,
  and that is what `ungrant` writes. My own decoder and writer (`%TEMP%\rv_decode.py`, from those
  two files, not from the script) agree bit for bit on all 27 SimC strings. It changes exactly 2
  (Beast Mastery, Marksmanship), and in each only the two free hero keystones differ; every other
  node reads the same. Hero points go 14 to 13. Every stored string that has a granted keystone,
  bought my way then ungranted, comes back bit for bit (84 of 86; the other 2 differ only in
  trailing padding). `encode` pads as `ConvertToBase64` does.
- Import shape. After `ungrant` the keystone imports as `ranksGranted` 1 and `ranksPurchased` 0
  (`CreateImportLoadoutEntryInfoFromSingleNode`, :315-352). Both keystones granted is the same
  shape Dreamgrove's and Archon's strings have, so the import gets 13 purchased hero ranks.
  `nodeKey` ignores granted nodes, so the made loadout will not read as drifted.
- All 86 stored strings decoded myself against Raidbots talents.json: right spec, 34/34/13 in the
  live hero tree, no bad partial or choice bits. All 36 Dungeon strings equal the page's
  `importString` today, and each decodes to the page's `heroTreeId`.
- SimC. One `talents=` line in each of the 47 MID2 profiles. Frost Death Knight is stale in both
  its files (`_Rider` too: 9 class points), so dropping it is right.
- On copies in `%TEMP%`: a `Frost Mage` Dungeon PIN (a key with a space) is written as
  `["Frost Mage"]` and wins; a Holy Paladin Raid PIN fills the gap and leaves the "No Raid" line; a
  wrong-spec Raid PIN exits 1 with the Lua byte-identical. The builder's six mutations all go red,
  and renaming `["Frost Mage"]` turns "a Dungeon build for each other spec" red.
- Lua: `sayTalents`, `tidy` (druids only), `RETIRED`, the spare and the tree diff all take a
  non-druid key and its strings without a special case.

**Finding 1 (data): wowvalor's `recommendedBuild` is not the most-played build.** Its `amount` is 1
to 13 of 50. Holy Paladin, Frost Mage and Preservation are 1: one character's build. Frost Mage's
is Frostfire, which 14 of the top 50 run; 36 run Spellslinger (the page's own
`topHeroTalentTrees`). Survival's is Pack Leader, 21 against Sentinel's 29. The docstring says "the
exact build most of its top 50 characters of the spec run", and the card asked for the most-played
build. Fix: refuse a recommended build whose `heroTreeId` is not the page's top hero tree, and name
the spec as the Raid gaps are (PIN fills it); print `amount` in the run; correct the wording. If
Rob would rather keep wowvalor's pick as it is, the card should say so.

**Finding 2 (a player's loadout): "Dungeon" and "Raid" are names a player uses.** On every
non-druid alt, a loadout the player named "Raid" now counts as the planned build. At login
(`armLoadouts`, 5 seconds) and on a spec change, `offerLoadouts` lists it as "no longer holds the
planned build", and "Reset to plan" (`resetDrifted`) deletes it and makes SimC's. The sidebar also
takes it out of Your loadouts. The addon's own rule, above `PlanTab.RETIRED`, is that Rob's own
loadouts are never touched, and 0049's review kept `tidy` off other classes for this reason. Fix:
names a player would not choose (within 30 letters), or reset only loadouts this character made,
kept by config id as spares are. A check with an own "Raid" on a Death Knight.

**Finding 3 (minor): a pinned name on another class is not checked.** The druid path refuses a name
over 30 letters or with a `"`. `other_classes` does not. On a copy, a PIN named `Dungeon "q"`
exited 0 and wrote a Lua file that will not load (`']' expected near 'q'`).

**Finding 4 (the manual step):** the Death Knight alt does not test the new risk. Ten Dungeon
strings (Holy and Protection Paladin, Beast Mastery, Marksmanship, Fire, Frost Mage,
Mistweaver, Windwalker, Devastation, Augmentation) mark the other spec's copy of a shared hero
keystone as granted. No druid string does. The import passes it on as `ranksGranted` 1. Add one of
those specs to Rob's check.

Security:
1. Weakest: third-party text becomes Lua. The wowvalor regex takes base64 only, and a SimC string
   with any other character stops at the decoder before anything is written. The one open path is
   finding 3, which is author-typed.
2. Unchecked: which talents a string picks. The spec and points check passes any legal build, so a
   thin or minority pick goes through unseen (finding 1).
3. Leaks: the fetch sends a browser user agent to wowvalor and `gh` reads a public repository. In
   game nothing is sent.

No client here. Scripts: `%TEMP%\rv_decode.py`, `rv_foreign.py`, `rv_valor_all.py`, `rv_pin.py`.
