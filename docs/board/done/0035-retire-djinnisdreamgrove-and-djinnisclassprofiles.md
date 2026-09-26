---
needs: 0031, 0033
---
# 0035 Retire DjinnisDreamgrove and DjinnisClassProfiles

## Why

Rob, 2026-09-23: merge DjinnisDreamgrove into DjinnisBiS "and remove DjinnisDreamgrove going
forward". DjinnisClassProfiles' job, action bars across characters, moves here in `0033`.

## What

- Only after `0031` and `0033` have passed in a client.
- Remove both from the game folder. `bin\deploy.ps1` mirrors; check its dry run for how it removes
  an addon rather than deleting the game folder by hand.
- Keep both repositories. Each `README.md` and `docs/HANDOVER.md` gets one line at the top: retired
  on this date, the work lives in DjinnisBiS, cards `0030` to `0033`.
- The Dreamgrove generator already moved in `0030`; `C:\Dev\WoWAddons\.dreamgrove-tmp\` can go.
- Workspace `README.md` and `docs/HANDOVER.md` updated to say which addons are active.

## Acceptance

- [x] Neither addon is in `Interface\AddOns`, and DjinnisBiS does everything `/dg` did.
- [x] Both repositories still exist, and say where their work went.

**2026-09-24, Claude.** Changed by card `0058`: DjinnisClassProfiles is not retired. Its repository
now holds this addon (Djinni's BiS renamed). Only DjinnisDreamgrove is retired by this card.

**2026-09-26, Claude.** Done, after Rob passed `0031` and `0033` in a client the same day.
- **Not in the game.** `Interface\AddOns` had no `DjinnisDreamgrove` folder already. `bin\deploy.ps1`
  found it by authorship, so a deploy without `-Only` would have put it back. The script now skips
  the names in `$retired`, even when `-Only` names one (workspace commit `8cae086`).
- **Everything `/dg` did is here.** `/dg` listed the builds (the sidebar), imported one (a row's
  right-click, card `0065`), imported all (More > Make the planned loadouts), and tidied the 0.6.0
  names (More > Delete old loadouts).
- **Both repositories stay.** DjinnisDreamgrove has a new `README.md` and a first line in its
  `docs/HANDOVER.md` saying it is retired and where its work went (its commit `323cab7`). Its card
  `0001` is discarded. The workspace `README.md` table and `docs/HANDOVER.md` say it is retired.
- **`.dreamgrove-tmp\`** went to the Recycle Bin, not deleted outright. The generator is
  `update-builds.py` here since card `0030`.