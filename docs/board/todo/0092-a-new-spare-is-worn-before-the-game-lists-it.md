# 0092 A new spare loadout is worn before the game lists it

## What I need from you

Nothing to decide. One in-game look once it is built: see Acceptance.

## Why

Rob, 2026-10-11, Resto on Bloodfeather, double-clicked the Resto **Raid** row (no saved loadout,
so it goes through the spare, card 0040). Chat said, in order: "Close the talent window to put on
"Raid"", "Making the spare loadout for "Raid"", "Putting on "Raid"". The game then showed
**"Failed to find the specified loadout for your current specialization"** in red, and the talent
window stayed on "Default Loadout" with Apply Changes lit. Screenshot:
`C:\Users\r\.t3\userdata\attachments\c5e0fbb0-a841-455e-83d5-6a4e9c1a033b-990fae68-8257-4774-8a35-c837ef82cd28.png`.

**Likely cause (not proven in a client).** `PlanTab.wearMadeSpare` takes the new config's id from
`q.pendingID` when `C_Traits.GetConfigInfo` already names it, and only falls back to
`savedLoadoutNames()` (the spec's `C_ClassTalents.GetConfigIDsBySpecID` list) when it does not. It
then calls `ClassTalentHelper.SwitchToLoadoutByName`, which resolves the name against the spec's
loadout list ("Loads loadout for the current specialization by name",
`ClassTalentsDocumentation.lua`). So a config that exists and is populated, but is not on the spec's
list yet, passes every check and then fails by name. The code's own comment says "the list can lag
the import".

## What to build

In `PlanTab.wearMadeSpare`, switch by name only once the name is on `savedLoadoutNames()`. Until
then, wait and look again a few times (short `PlanTab.later` steps, out of combat, window shut),
and only after that say the existing "made but the game does not list it yet" line. Keep the
`spareIDs()[id] = true` record as now, so the next double-click switches straight to it.

## Acceptance

<!-- AC:BEGIN -->
- [ ] A self-test case: a made spare whose id `GetConfigInfo` names but the spec list lacks is not switched to by name. proves: `/dcp test`
- [ ] On a spec with no saved loadout for a build, one double-click on the row ends wearing `[CP*] <build>`, with no red "Failed to find the specified loadout" line. proves: manual
<!-- AC:END -->
