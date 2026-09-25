# 0064 Pull every spec's builds from Warcraft Logs, with the numbers behind them

## What I need from you

1. Read the Warcraft Logs API terms in a browser. Say whether a personal script that reads rankings
   and ships build strings in a published addon is allowed.
2. Create an API client at https://www.warcraftlogs.com/api/clients/ (logged in to Warcraft Logs).
3. Put the id and secret in two Windows user environment variables, `WCL_CLIENT_ID` and
   `WCL_CLIENT_SECRET`. Never in the repo: this folder is git and Syncthing-replicated.

Nothing below starts until 1 says yes.

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
