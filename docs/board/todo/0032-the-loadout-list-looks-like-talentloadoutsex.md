---
needs: 0031
model: fable  # interface work
---
# 0032 The loadout list beside the talent window looks like TalentLoadoutsEx

## Why

Rob, 2026-09-23: "Visually I like TalentLoadoutsEx." The sidebar from card `0019` already sits
beside Blizzard's talent window. This gives it that addon's look. The source is in
`research/TalentLoadoutsEx/modules/list.lua` and `frame.lua` (gitignored), and what makes it look
good is written up in `docs/research/talent-loadout-addons.md`.

## What

- Blizzard's own `ScrollBox` list, 36 px icon per row. A raid boss row shows the boss's portrait
  (TalentLoadoutsEx `preset.lua` has the Season 2 icon IDs); a dungeon row the Mythic+ icon.
- Groups that fold open: one per boss in the current raid, one for dungeons.
- **A green tick on the row whose build matches the tree right now**, compared by content
  (`PlanTab.talentStringsDiffer`), never by name.
- A warning mark on a stored string this client cannot read.
- Double-click switches through `PlanTab.loadTalents`. Nothing else writes.
- Hidden in combat.

## Acceptance

- [ ] WHEN the talent window opens, THE LIST SHALL show every stored build for the spec, grouped, with the current raid's boss first.
- [ ] WHEN the tree matches a stored build, THE LIST SHALL tick that row and no other.
- [ ] WHEN a row is double-clicked, THE ADDON SHALL switch through Blizzard's helper only.
- [ ] Rob accepts the look in a client, against a screenshot of TalentLoadoutsEx.
