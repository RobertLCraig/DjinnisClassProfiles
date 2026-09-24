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

- [ ] Neither addon is in `Interface\AddOns`, and DjinnisBiS does everything `/dg` did.
- [ ] Both repositories still exist, and say where their work went.

**2026-09-24, Claude.** Changed by card `0058`: DjinnisClassProfiles is not retired. Its repository
now holds this addon (Djinni's BiS renamed). Only DjinnisDreamgrove is retired by this card.