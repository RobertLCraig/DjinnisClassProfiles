# 0064 Pull every spec's builds from Warcraft Logs, with the numbers behind them

## What I need from you

Rob, 2026-09-25: the addon is for his own use and is not to be published, so the terms question is
about personal use only. He already has a client, **PersonalSelfImprovementAIBot** (client id
`01a0c2df-a16b-7247-8c60-9d3b0a52824b`). Its secret is not on this machine.

1. Put that client's secret in a Windows user environment variable, `WCL_CLIENT_SECRET`, and its id in
   `WCL_CLIENT_ID`. Never in the repo or in chat: this folder is git and Syncthing-replicated.

   Or, instead: say the Regenesis site's client may be used. Its id and secret are already in
   `C:\Dev\Regenesis\.env` (gitignored). It shares its rate limit with the guild site's own pulls.
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
