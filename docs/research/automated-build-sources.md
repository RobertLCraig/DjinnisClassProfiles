# Pulling builds automatically, the way Archon shows them

**Question.** Can `update-builds.py` pull talent builds by script with the metadata archon.gg
shows (last updated, total parses, sample basis, the top build's export string, alternatives,
per-talent popularity), from a legitimate source, for raid per boss and difficulty and for Mythic+?

**Date.** 2026-09-25. Everything below was fetched on this date from this machine with `curl`,
`gh api` or Python. No live Warcraft Logs query was run: that needs a client id and secret, which
only Rob can create. Nothing was run in a game client.

**Access, recorded as a finding.** Every page on `www.warcraftlogs.com` that is not the API itself
answered `curl` with `403` and the header `cf-mitigated: challenge` (Cloudflare "Just a moment...
Enable JavaScript and cookies to continue"): `/api/docs`, `/v2-api-docs/warcraft/`,
`/v2-api-docs/warcraft/rankings.doc.html` (also refused to WebFetch), `/api/clients/`,
`/help/terms`, `/robots.txt`, and `articles.warcraftlogs.com`. The sister sites'
docs (`www.fflogs.com/api/docs`, `www.esologs.com/api/docs`, `classic.warcraftlogs.com/api/docs`)
are challenged the same way. On archon.gg only `robots.txt` resolves; `/`, `/terms`, `/privacy`,
`/about`, `/api`, `/sitemap.xml` and the Guardian raid builds page all return the same challenge.
None of this was worked around, and no archived copy was used in its place.

So the Warcraft Logs schema below is read from what RPGLogs LLC (Warcraft Logs' publisher) ships
outside Cloudflare: its SDK on npm, which contains the full introspection result of the live API,
and its GitHub organisation.

---

## 1. Warcraft Logs API v2

### Where the schema was read

- `@rpglogs/api-sdk` 2.0.1, published 2026-07-21 by "RPGLogs LLC", described as "Sends HTTP
  requests to the RPGLogs v2 API" (`package.json` in
  https://registry.npmjs.org/@rpglogs/api-sdk/-/api-sdk-2.0.1.tgz). The tarball carries
  `src/schema.json`, which its own `src/downloadSchema.ts` makes by sending
  `getIntrospectionQuery()` to `https://www.warcraftlogs.com/api/v2/client` with a bearer token
  (https://api.github.com/repos/RPGLogs/RPGLogsApiSdk/contents/src/downloadSchema.ts). So
  `schema.json` is the live server's own description of itself as of that publish, argument
  descriptions and defaults included. Quotes below are from it unless another URL is given.
- Without a token the API refuses introspection: `POST https://www.warcraftlogs.com/api/v2/client`
  with `{__schema{queryType{name}}}` returned `404` and `{"message": ""}` (run 2026-09-25).

### Can rankings return talents, or the export string?

Two routes. Only the second is documented to give the export string itself.

**a. `worldData.encounter(id).characterRankings(...)`, type `JSON`.** Described as "Player rankings
information for a zone. This data is not considered frozen, and it can change without notice. Use at
your own risk." Its arguments, with defaults, exactly as the schema has them:

| Argument | Type = default | Schema's description |
|---|---|---|
| `bracket` | Int = 0 | "A specific bracket (e.g., item level range) to use instead of overall rankings. For WoW, brackets are item levels or keystones." |
| `difficulty` | Int = 0 | "A specific difficulty to fetch rankings for. If omitted, the highest difficulty is used." |
| `filter` | String = "" | "A filter string for advanced searching. The syntax matches the one used on the web site exactly, so you can filter encounter rankings on the site to figure out the string to use." |
| `page` | Int = 1 | "Which page of rankings to fetch." |
| `partition` | Int = 0 | "By default, the latest partition is chosen." |
| `serverRegion`, `serverSlug` | String = "" | region / server filters |
| `size` | Int = 0 | raid size |
| `leaderboard` | LeaderboardRank = Any | "Controls whether to include ranks without backing logs in games & content types that support this." The enum's own description: "some games (ESO) and content types (Retail WoW M+) support leaderboard ranks with no backing log"; values `Any`, `LogsOnly`. |
| `hardModeLevel` | HardModeLevelRankFilter = Any | not relevant here |
| `metric` | CharacterRankingMetricType = default | includes `dps`, `hps`, and `playerscore` ("Score. Used by WoW Mythic dungeons and by ESO trials.") |
| `includeCombatantInfo` | Boolean = false | "Whether or not to include detailed combatant info such as gear in the results." |
| `includeOtherPlayers` | Boolean = false | other characters in the kill |
| `className`, `specName` | String = "Any" | "The slug for a specific class" / "spec" |
| `externalBuffs`, `covenantID`, `soulbindID` | | not relevant here |

There is **no** `timeframe`, date, or percentile argument on this field. (`timeframe` and
`compare`, whose value `Parses` is described as "Compare against all parses in a two week window",
exist only on a single character's `encounterRankings`/`zoneRankings`, not on the encounter's
leaderboard.) Source: the `EncounterCharacterRankingsArgs` and `CharacterEncounterRankingsArgs`
types in `dist/tsc/sdk.d.ts` of the same tarball.

The JSON shape, from RPGLogs' own snapshot of a live call (encounter 2333, difficulty 5, `dps`,
DemonHunter / Vengeance, **without** `includeCombatantInfo`; snapshot last updated 2026-07-21,
https://api.github.com/repos/RPGLogs/RPGLogsApiSdk/contents/src/queries/__snapshots__/getEncounterCharacterRankings.test.ts.snap):

```json
{ "characterRankings": {
    "count": 100, "hasMorePages": true, "page": 1,
    "rankings": [ {
      "amount": 255365, "bracketData": 482, "class": "DemonHunter", "spec": "Vengeance",
      "duration": 79259, "hardModeLevel": 0, "name": "Xyä", "startTime": 1602097935818,
      "guild":  { "faction": 1, "id": 369203, "name": "Reaction" },
      "report": { "code": "ANw6Fynq8W3P1Bkg", "fightID": 15, "startTime": 1602092886405 },
      "server": { "id": 304, "name": "Kazzak", "region": "EU" } } ] } }
```

That page held exactly 100 rankings with `hasMorePages: true`, so `count` is the number **on the
page**, not the total. A total must be counted by paging to the end.

What `includeCombatantInfo: true` adds to each ranking is **not** in any first-party source I could
reach. Leads only, not evidence: RPGLogs' own old M+ site read `ranking["talents"]` as a list of
`{"talentID", "points"}` from the **v1** endpoint `/v1/rankings/encounter/...&includeCombatantInfo=true`
(https://api.github.com/repos/RPGLogs/mplus.subcreation.net/contents/mplus.py, lines 1962-2004 and
3601; last pushed 2024-01-26), and a third-party v2 client typed it as
`talents?: {name, id, talentID, points, icon}[]` (https://api.github.com/repos/oBusk/warcraftlogs-search/contents/src/lib/wcl/rankings.ts,
last commit 2026-08-06). Whether that list carries hero talents, the hero-tree choice and choice-node
entries for 12.1 is unknown. **Most adverse reading: it gives per-talent ids but not enough to
rebuild a string that imports, or nothing at all.**

**b. `ReportFight.talentImportCode(actorID: Int!)`, type `String`.** "The import/export code for a
Retail Dragonflight talent build. Will be null for a classic or pre-Dragonflight fight." The
argument: "The friendly player actor to generate talents for. Result will be null for unknown or
non-player actors. Use the ReportMasterData or the friendlyPlayers field on this type to get the
list of friendly player actor IDs." This is the documented way to get the exact string. A ranking
gives `report.code` and `report.fightID`; `reportData.report(code).masterData.actors(type: "Player")`
gives `{id, name, server, subType}` for matching the ranked name to an actor id. Related, also in
the schema: `Report.playerDetails` ("including their specs, talents, gear, etc.", JSON, also
"not considered frozen").

A sketch of the two calls (field and argument names are the schema's; not run):

```graphql
query ($enc: Int!, $diff: Int, $page: Int) {
  worldData { encounter(id: $enc) { name
    characterRankings(className: "Druid", specName: "Guardian", difficulty: $diff,
                      metric: dps, page: $page, includeCombatantInfo: true) } } }

query { reportData {
  r1: report(code: "ANw6Fynq8W3P1Bkg") {
    masterData { actors(type: "Player") { id name server } }
    fights(fightIDs: [15]) { id encounterID kill talentImportCode(actorID: 7) } } } }
```

(`actorID: 7` stands for the id read from `actors` in the same or a prior call. GraphQL aliases
`r1`, `r2` ... put several reports in one request; that is standard GraphQL, and whether the API
charges them as one is unknown.) Unknown: whether `talentImportCode` works for archived reports
(`Report.archiveStatus`: "Events, tables, and graphs for archived reports are inaccessible unless
the retrieving user has a subscription including archive access"). Reports from the last two weeks
are unlikely to be archived, but that is inference.

### Raid per spec and difficulty, Mythic+ per spec

- Zones, encounters, difficulties: `worldData.zones(expansion_id)` / `worldData.zone(id)` return
  `encounters {id name}`, `difficulties {id name sizes}`, `partitions {id name compactName default}`
  and `brackets {min max bucket type}` (schema types `Zone`, `Difficulty`, `Partition`, `Bracket`).
  The numeric ids for Midnight season 2's raid and dungeons, and which difficulty id is Mythic,
  must be read from these at run time. I did not verify them.
- Raid: one `characterRankings` call per boss, with `className`, `specName`, `difficulty`,
  `metric: dps` or `hps`. For tanks, the schema's `krsi` is "Deprecated. Only supported for some
  older WoW zones", so tanks rank on `dps` (that follows from the enum; what Archon uses for tanks
  is unknown).
- Mythic+: one call per dungeon encounter with `metric: playerscore`; `bracket` selects a keystone
  level ("For WoW, brackets are ... keystones"); `leaderboard: LogsOnly` keeps only ranks that have
  a log behind them, which route (b) needs. Archon's "+7 to +21" is a range; the schema's `bracket`
  takes one Int, so a range means one call per level or no bracket at all. Unverified live.

### A recent window, a percentile band

- No date argument. The `filter` string is "the one used on the web site", and RPGLogs' own site
  built one as `date.<startMs>.<endMs>` for v1 rankings (`mplus.py` lines 3582-3601, link above).
  That the same string works in v2 is **unverified**; if it does not, the window has to be applied
  client-side from each ranking's `startTime`, which means paging further.
- No percentile argument. A "top 50%" band has to be computed: page through the whole list,
  count it, keep the first half. Rankings are ordered by `amount` in the snapshot above. Whether the
  list is one best parse per character (as the snapshot's distinct names suggest) or every parse is
  **unverified**; Archon's "parses" may not be the same unit.

### Rate limits and costing

- The schema exposes `rateLimitData { limitPerHour pointsSpentThisHour pointsResetIn }`:
  "The total amount of points this API key can spend per hour" and "The number of seconds remaining
  until the points reset" (`RateLimitData`; the SDK ships this as `getRateLimit`,
  https://api.github.com/repos/RPGLogs/RPGLogsApiSdk/contents/src/queries/getRateLimit.graphql).
- How a query is costed is not documented anywhere I could reach. The only first-party hints:
  the SDK README says the `include*` variables "use up more of your rate limit"
  (https://api.github.com/repos/RPGLogs/RPGLogsApiSdk/contents/README.md), and the schema says
  `Report.phases` "does not double-charge API points if you load fights and phases".
- **The hourly number is not settled.** Adverse model: small enough that a talent string per
  ranked player (route b) for 40 specs x (8 bosses + 8 dungeons) does not fit in one hour. The
  script should read `rateLimitData` first, spend at most a set share, and stop cleanly.

### Terms of use

**Not settled.** The API terms and site terms are behind the challenge (`/help/terms` tried; the
real terms URL is not known to me). The only first-party line reachable is RPGLogs' own old
contributor guide: "Please note the rate limit and be a good netizen"
(https://api.github.com/repos/RPGLogs/mplus.subcreation.net/contents/CONTRIBUTING.md, line 41).
Rob needs to read the terms in a browser before this is built.

### What Rob does by hand to get a client id and secret

What the first-party sources say, and no more:

1. Have a Warcraft Logs account and be logged in (the clients page is on the site and is challenged
   for scripts; a browser passes it).
2. Create a client at https://www.warcraftlogs.com/api/clients/ ("fill in your client id/secret
   from https://www.warcraftlogs.com/api/clients/", SDK README above). The form's fields were not
   visible to me.
3. Keep the id and secret out of the repo (inference: this folder is git and replicated). The SDK
   reads them from `RPGLOGS_API_CLIENT_ID` and `RPGLOGS_API_CLIENT_SECRET`
   (https://api.github.com/repos/RPGLogs/RPGLogsApiSdk/contents/.env.example).
4. The script then gets a token itself: `POST https://www.warcraftlogs.com/oauth/token` with
   `Authorization: Basic base64(id:secret)`, `Content-Type: application/x-www-form-urlencoded`,
   body `grant_type=client_credentials`, and reads `access_token` from the JSON
   (`getAccessToken` in `downloadSchema.ts`, link above). The endpoint is live and outside the
   challenge: a POST with no credentials returned `400`, error `invalid_request`, hint "Check the
   client_id parameter" on 2026-09-25. Queries go to `https://www.warcraftlogs.com/api/v2/client`
   with `Authorization: Bearer <token>`.

---

## 2. Does Archon offer an API, an export, or terms that allow reading?

- `https://www.archon.gg/robots.txt` (200): `User-agent: *`, `Allow: /`,
  `Sitemap: https://www.archon.gg/sitemap.xml`. Robots allows crawling, but the site serves a
  human check to scripts, and robots.txt is not a licence to pass it.
- No API, export or terms page could be reached: everything else is behind the challenge (list at
  the top). No first-party Archon API documentation was found on GitHub either. **Not settled.**
- Archon and Warcraft Logs share an owner as far as GitHub shows: the `RPGLogs` organisation holds
  `ArchonTooltip_Data` and `Uploaders-archon-lite`
  (https://api.github.com/search/repositories?q=org:RPGLogs). That Archon's build pages are computed
  from Warcraft Logs data is what the brief says; I could not read Archon's own statement of it.
- `ArchonTooltip_Data`'s releases are per-region character parse databases for a tooltip addon,
  last published 2024-07-30 (https://api.github.com/repos/RPGLogs/ArchonTooltip_Data/releases),
  not build data.

## 3. Other sources, and what each exposes

| Source | Content | Verified 2026-09-25 | Build string | Metadata |
|---|---|---|---|---|
| **wowvalor.app** (already used) | Mythic+ and PvP only; its spec pages link `m+`, `2v2`, `3v3`, `blitz`, `rbg`, `solo`, no raid | https://wowvalor.app/en/stats/druid/guardian/m+ (200, 78 KB) | `recommendedBuild.importString`; the Guardian one on this date is not the same string as Archon's pinned one | `updatedAtTime:"2026-09-25T00:31:16.898Z"`; `methodology:{leaderboardCoverage:"complete",targetCharacters:50}`; page text "Starting at the top of the rankings, we work down until we have everything we need for 50 characters."; `recommendedBuild.amount:12` (characters on that exact build), `highestKey`, `medianPerformance`; per node `{id, amount, maxRank, spells:{spellId:{amount}}, ranks}` ("how many of the 50 characters in this dataset selected each talent"); `topHeroTalentTrees:{24:50}`; per character `score` and `talents` as `{id (node), spellId, rank}` |
| **Murlok.io** | Mythic+ and PvP; hero-tree filter pages | https://murlok.io/druid/guardian/m+ (200); https://murlok.io/about (200); `/terms` is 404 | none in the HTML served to `curl` (the app is Go/WebAssembly) | "Built using real-time data from the top 50 Guardian Druid Tanks across the US, EU, KR, and TW regions"; "Data is refreshed every 8 hours via Blizzard's Battle.net API"; "Updated 4 hours ago"; "From 3742 to 3951 Rating"; hero-tree split "49 Elune's Chosens 1 Druid Of The Claw"; per-talent anchors. /about says the backend has "An API that provides the necessary data for the user interface"; it is not documented as public |
| **Raidbots** | Static game data | https://www.raidbots.com/static/data/live/talents.json (200); https://www.raidbots.com/robots.txt: `Disallow: /wowapi/`, `Disallow: /api/` ("Polite crawlers should stay off the API namespaces") | none | Tree only: per spec `fullNodeOrder`, `classNodes`/`specNodes`/`heroNodes`/`subTreeNodes` with `id`, `type`, `maxRanks`, `freeNode`, `entries[{id, definitionId, spellId, maxRanks, index}]`. No popularity data found |
| **SimulationCraft** | One default profile per spec per tier | https://api.github.com/repos/simulationcraft/simc/contents/profiles/MID2 lists `MID2_Druid_Feral.simc` and no Guardian | `talents=` line | Last change date from git (Feral: 2026-09-10, "[Feral] Add MID2 Feral Wildstalker profile (#11862)"). No sample, no popularity |

Robots signal, a finding: https://wowvalor.app/robots.txt carries
`Content-Signal: ai-train=no, search=yes, ai-input=no`. `update-builds.py` reading it is a script,
not AI input (inference), but an agent session reading wowvalor pages to answer questions is what
`ai-input=no` asks against. This research read one wowvalor page and its robots.txt, before the
signal was seen; nothing further.

## 4. Rebuilding an export string from node id + rank

Yes. The format is written out at the top of Blizzard's own file, and it was tested here.

- Format: `wow-ui-source/Interface/AddOns/Blizzard_PlayerSpells/ClassTalents/Blizzard_ClassTalentImportExport.lua`
  (checkout `live`, commit `09b9db79`, "12.1.0 (69933)", 2026-09-22):
  - lines 8-17: header = version (8 bits, `C_Traits.GetLoadoutSerializationVersion`), spec id
    (16 bits), tree hash (128 bits) which "For third-party sites that want to generate loadout
    strings, this can be ommitted and zero-filled, which will ignore the extra validation on
    import";
  - lines 21-48: per node, in `C_Traits.GetTreeNodes` order ("ascending order by the nodeID"):
    selected (1), purchased (1), partially ranked (1), ranks (6), choice node (1), entry index (2);
  - lines 70-104 `WriteLoadoutContent` (granted = `activeRank - ranksPurchased > 0`; choice =
    `Selection` or `SubTreeSelection` node type); lines 116-160 `ReadLoadoutContent`;
    lines 289-296 `WriteLoadoutHeader`.
- Bit packing: `wow-ui-source/Interface/AddOns/Blizzard_SharedXMLBase/ExportUtil.lua`
  lines 6-71 (6 bits a character, least significant bit first, alphabet `A-Z a-z 0-9 + /`).
  `update-builds.py`'s `Bits` and `encode` already implement both directions.
- Node order for a script: Raidbots `talents.json` `fullNodeOrder` (282 nodes for Guardian), which
  `update-builds.py` already walks.

Needed per node: the node id, ranks held, and for choice and hero-tree (`subtree`) nodes the entry
index. Nodes with `freeNode: true` in talents.json are written selected-but-granted (`1,0`).

Test (script at `%TEMP%\rebuild_check.py`, not kept in the repo): decode a string to
`{node: (ranks, entry index)}` with no granted flag, rebuild from that plus talents.json with a
zeroed hash, compare. Content bits came back **identical** for wowvalor's Guardian string, Archon's
pinned Guardian string and Archon's pinned Feral string. All three have a zero hash and version 2.
Two things the test showed: the granted nodes are exactly talents.json's `freeNode` nodes (for
Guardian: Verdant Heart, Frenzied Regeneration, Swipe, and hero keystones); and wowvalor's string
marks **both** hero keystones granted (Boundless Moonlight and Ravage) where Archon's marks only the
live tree's. A rebuild must copy whichever the source gives. That both forms import is inference
from both being pinned or fetched and shipped already, not something tested here.

Caveats: the test proves the encoding, not an API's data. If an API gives WCL-v1-style
`talentID` values, those must be mapped to talents.json entries (RPGLogs' old encoder matched them
to `entries[].id`: https://api.github.com/repos/RPGLogs/mplus.subcreation.net/contents/encode_talent_string.py;
that encoder predates the "purchased" bit, so it is the old format and not to be copied). Without
the hero-tree choice the string cannot be built.

---

## Recommendation

**Build one fetcher on the Warcraft Logs v2 API, taking each ranked player's string from
`ReportFight.talentImportCode`.** It is the only reachable, first-party, documented source that
gives the exact export string per ranked player, for raid bosses and dungeons alike. Per spec and
per encounter: page `characterRankings` (raid: difficulty, `dps`/`hps`; M+: `playerscore`,
`leaderboard: LogsOnly`), keep the rankings inside the window, keep the top share of them, then
fetch `talentImportCode` for each kept ranking, batched with aliases. Count strings; decode each
with the existing `points()` walk for per-node counts. Run `includeCombatantInfo: true` once in the
first session: if its `talents` list turns out to carry everything (hero tree and choices), the
per-report calls can be dropped and strings rebuilt as in section 4, which is cheaper.

wowvalor stays as it is for Mythic+ until this works; it already gives most of the metadata (above),
from Blizzard leaderboards, not logs.

**What Rob must do by hand**

1. Read the Warcraft Logs API terms in a browser and say whether a personal script that pulls
   rankings and stores build strings in a published addon is allowed. (Not settled here.)
2. Create an API client at https://www.warcraftlogs.com/api/clients/ and put the id and secret in
   two user environment variables (for example `WCL_CLIENT_ID`, `WCL_CLIENT_SECRET`), never in the repo.
3. Let the first run be a probe: `rateLimitData`, one `characterRankings` page with
   `includeCombatantInfo: true`, one `talentImportCode`, one `filter: "date.<start>.<end>"`, and the
   current zone's ids. That settles most of the list below in one go.

**Archon's metadata, and whether this approach reproduces it**

| Archon shows | Reproducible? | How |
|---|---|---|
| Last updated | Yes | The run's own time; or the newest `startTime` among the rankings used |
| Total parses (e.g. 6,851) | Approximately | Page `characterRankings` to `hasMorePages: false` and count, after the window. `count` is per page, not a total. Whether one entry per character equals Archon's "parse" is unknown, so the number may differ |
| Sample basis ("top 50% of data in the last 14 days") | Approximately | Window: `filter: "date..."` if v2 accepts it (unverified), else by `startTime` client-side. Top 50%: computed from the full count, no API argument. Archon's own definition of both is unread |
| Most popular build's export string | Yes | Most frequent `talentImportCode` among kept rankings (identical strings); or rebuilt, section 4 |
| Alternatives (other popular builds) | Yes | The next most frequent strings, with their counts and share |
| Per-talent popularity | Yes | Decode each string over talents.json (`points()`'s walk) and count picks per node and per choice entry, as a share of the sample |

**Cannot be settled here**

- Warcraft Logs API terms of use (behind the challenge).
- The hourly point limit for a client-credentials key and how a query is costed.
- What `includeCombatantInfo: true` returns on 12.1 rankings, and whether it includes hero talents
  and choice entries.
- Whether v2's `filter` accepts `date.<start>.<end>`.
- Whether `characterRankings` is one entry per character or per parse, and so whether a count
  matches Archon's "parses".
- The Midnight season 2 zone, encounter and difficulty ids (need a key).
- Whether `talentImportCode` answers for archived reports.
- Whether Archon has an API, export or terms that allow scripts, and Archon's exact method for
  "top 50%" and the 14-day window (every page but robots.txt is challenged).
- Whether Murlok offers its build string or a public API (its HTML has none; its terms page is 404).
