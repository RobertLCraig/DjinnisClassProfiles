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

- [ ] WHEN `update-builds.py` runs, EVERY SPEC SHALL have a `Dungeon` and a `Raid` build that decodes to its own spec with a full set of points, or the run SHALL stop. proves: `python update-builds.py --check`
- [ ] WHEN a spec has a `PIN` entry, THE PIN SHALL win. proves: a check on a copy
