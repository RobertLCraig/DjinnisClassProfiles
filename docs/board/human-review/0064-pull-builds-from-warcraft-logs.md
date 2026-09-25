# 0064 Pull every spec's builds from Warcraft Logs, with the numbers behind them

## What I need from you

One trip to the game, v0.49.0:

1. `/reload`.
2. As Balance, Guardian and Resto, one at a time: the loadout box should list the retired rows
   (`[CP] Raid: Elune's Chosen`, `Raid: Druid of the Claw`, `Raid: short on mana`,
   `Raid: mana is fine`, `Raid: Nek'Zali, Nymrissa`, whichever you have) as "deleted: a build this
   addon no longer makes". Click **Delete them**, wait for the count, then **Create**.
3. Open the talent window on each druid spec. No row should show the "out of date" triangle except
   Guardian `Dungeon: survive more` and Resto `Dungeon: cat damage` / `Dungeon: caster damage`
   (Dreamgrove strings with a tree hash, card `0061`).
4. Balance `Raid: Single Target` is now Keeper of the Grove (it was Elune's Chosen). If an action-bar
   profile was saved for it, check the bars when you wear it.
5. Feral: the raid rows are now mostly Wildstalker. The stat targets were simmed on other builds.

Pass: each spec's planned loadouts are made with no error, and the rows load.
## Why

Rob, 2026-09-25: "I would really like to find a way to automate pulling those builds. As there is
much more information on that page that you could use to make more informed decisions", naming
Archon's "Last updated", "Total Parses" and "Based on the top 50% of data in the last 14 days", and
"what the alternatives are". He also chose to compare every spec's builds against Archon's, not only
Guardian's (his file `2026-09-25 WoW Archon Talent Builds.txt` holds Archon's raid and M+ string for
most specs).

Archon serves a human check to scripts (curl, 2026-09-25), and `update-builds.py` does not work
around one. `docs/research/automated-build-sources.md` found the source it draws on: the Warcraft
Logs v2 API gives each ranked player's exact export string (`ReportFight.talentImportCode`).

## What to build

In `update-builds.py`, per spec, for raid and Mythic+:
- page `characterRankings`, keep a recent window and the top share, fetch each kept ranking's
  `talentImportCode` (batched);
- the most common string is the build; the next ones are the alternatives, each with its count and
  share; per-talent popularity from decoding each string with the existing `points()` walk;
- write the build into the BUILDS block, and the numbers (run time, sample size, window, share,
  alternatives) somewhere a person reads before accepting a change.

First run is a probe (research file, "What Rob must do by hand", step 3): `rateLimitData`, one
rankings page with `includeCombatantInfo: true`, one `talentImportCode`, one date filter, and the
season's zone ids. It settles most of the research file's "Cannot be settled here" list.

Card 0061 (three Guardian builds out of date) is settled by this card's first run for Guardian.

## Done when

1. `python update-builds.py --check` passes, and each spec's raid and Mythic+ build comes from a run
   whose report states when it ran, how many rankings it used, the window and the share.
2. The report lists the alternatives and per-talent popularity for each.
3. In game: each changed spec's rows load without the "out of date" warning.

## Comments

### 2026-09-25: built the reader and the report

Rob gave his client's id and secret in `.secrets/warcraftLogsClientSecrets.txt` (gitignored, never shipped; `wcl.py` reads it, or `WCL_CLIENT_ID` / `WCL_CLIENT_SECRET`).

Probe results, settling most of the research file's open list:
- The limit is 3600 points an hour. One rankings page of 100 costs about 1 point; all 40 specs, raid and Mythic+, top 100 a boss or dungeon, cost about 800.
- Current ids: raid zone 53 (The Venomous Abyss), Mythic = 5; Mythic+ zone 55 (Season 2), difficulty 10.
- `characterRankings(..., includeCombatantInfo: true)` gives each ranking's `talents` as `{talentID, points}`. Every id is a Raidbots talents.json entry id, hero tree and hero choice included; a tiered (apex) node lists each tier as its own entry, summed. The export string rebuilt from that was **byte-identical** to `ReportFight.talentImportCode` for three Guardian players, so no per-report calls are needed.
- Mythic+ ranked by `playerscore` gives the key level in `hardModeLevel`. About one ranking in eight has no talents (a log without combatant info); those are left out and counted.
- One ranking is one character's best logged kill or run this season, not Archon's "top 50% in the last 14 days". The report states its dates.

Built: `wcl.py` (token, query) and `wcl-builds.py`, which writes `docs/builds/wcl-report.md` and `docs/builds/wcl-builds.json`: per spec, raid and Mythic+, the sample, dates, key levels, hero-tree split, the most common build, four alternatives with what each changes, the talents players split on, and each of the addon's own builds with its share and its difference from the top. It does not change BUILDS. Answers are cached 12 hours in `.cache/wcl/`.

First full run, 40 specs: of BUILDS' 86 rows, 20 are the most common build, 35 are run by some of the sample, 31 by none. Guardian: `Dungeon` is the most common M+ build; both raid rows and `Dungeon: survive more` are run by no one, and every raid Guardian plays Elune's Chosen (card 0061's finding, now with 623 rankings).

Open: the druids' per-boss raid rows are compared with the all-boss sample; they should be compared with their own boss's rankings. Then Rob decides how BUILDS takes these builds.

### 2026-09-25: automatic, option A (Rob: "A", twice)

Rob chose automatic builds, then fewer rows grouped by what players run over one row a boss (slots).

- `wcl-builds.py` picks each sample's **typical** build: the medoid, the ranked build nearest all the others talent by talent. The most common exact string was often 2% of a sample. On Guardian M+ the typical is Archon's #1 exactly. Agreement is reported over contested talents only (taken by under 90%).
- Druid boss rows are pooled per loadout: each row's typical is over every boss it backs, and each boss is also shown alone.
- `update-builds.py` reads `docs/builds/wcl-builds.json`. Precedence is PIN, then Warcraft Logs, then Dreamgrove, then wowvalor or SimC. The druids' Archon pins are gone. A JSON older than 14 days stops the run. A row regrouped since the last run is refused until `wcl-builds.py` runs again. Guardian and Resto get one `Raid`. A `Dungeon`, `Raid` or boss row with no source stops the run.
- Balance `PlanTab.BOSSES` has 3 rows: `Raid: Cleave` (Sentinels, Explorers, Twin Fangs; Elune's Chosen), `Raid: Nek'Zali, Altar` (Elune's Chosen), and `Raid: Single Target` (Vashnik, Sszorak, Ula'tek, Nymrissa; Keeper of the Grove, 92%).
- Feral Twin Fangs (10 rankings), Coiled Altar and Ula'tek (none with talents) keep Dreamgrove's builds.
- `PlanTab.RETIRED_TAGGED` holds 5 names the addon made tagged and no longer makes. `retiredLoadouts` offers "[CP] X" for those only. An older retired name's tagged copy is still never touched. The box wording no longer says every retired row is Dreamgrove's.
- Names are capped at 24 letters (`NAME_MAX`), because the 30-letter box takes a 6-letter mark.

Two fresh reviews found no bug that deletes a wanted loadout. Fixed from them:
- A refused Warcraft Logs build now falls back to the older source.
- Stale specs are dropped from the JSON.
- Boss rows are matched on the Lua's current rows.
- `agreement` was misleading.
- The report text was false in four places.
- Guardian and Resto `Raid` could drop out silently.
- Tagged retirement was too broad.
- The wording was fixed.

Offline check: Feral and 250 pass. The 102, 104 and 105 modes show 8 FAIL lines. Those are a missing `RaidWarningUtil` stub in `offline-check.lua` and were there before this card.

Not done here:
- The sidebar lists Guardian and Resto `Raid` under "Other builds", because neither spec has boss rows.
- Three Dreamgrove M+ rows keep a non-zero tree hash (card 0061).
