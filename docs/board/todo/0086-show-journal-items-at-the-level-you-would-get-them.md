# 0086 Show journal items at the level you would get them

## Why

Rob, 2026-10-07: "my main problem with the encounter journal is that it doesnt let you compare
levels (will always be comparing normal/heroic or mythic0 gear against say hero 4/6 or myth 3/6
gear, would prefer it to match the gear level to get a better comparison."

Where the addon shows an item from the Encounter Journal, its link comes at the journal's base
level. Compared with worn gear that has upgrades, the drop always looks worse than it is.

## What the API gives (checked in `wow-ui-source`, branch `live`, 2026-10-07)

- `C_EncounterJournal.SetPreviewMythicPlusLevel(level)`: journal links for dungeon loot at a keystone
  level (`EncounterJournalDocumentation.lua`).
- `EJ_SetDifficulty`: raid links at LFR, Normal, Heroic or Mythic.
- Neither one sets an upgrade rank (for example Hero 4/6). For that, compare at the item level from
  our own `TRACKS` table (`DjinnisClassProfiles.lua`, near line 891).

## Scope

- The level used is the one you would wear the drop at: the same track and rank as the worn piece
  in that slot, or the track the source drops on if that is higher.
- Item level, stats and the stat pane's preview (`0003`) all use that level.
- Put the journal back as you found it (difficulty, keystone level, filters), the same as `0022`.
- Out of combat only.

## Acceptance

- [ ] A Heroic raid drop, compared with a worn Hero 4/6 piece, is shown at Hero 4/6 item level.
- [ ] A dungeon drop is shown at the keystone level picked in the plan.
- [ ] After the addon reads the journal, the journal's own difficulty and keystone level are as
      they were.
- [ ] `lua offline-check.lua` passes, with checks for the level picked.
