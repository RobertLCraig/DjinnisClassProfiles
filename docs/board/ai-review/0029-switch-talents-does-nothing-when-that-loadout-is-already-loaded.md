---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0011, 0013, 0014
---
# 0029 "Switch talents" does nothing when that loadout is already loaded

## Why

Rob, 2026-09-22, on zone-in to Altar of Fangs: the wrong-setup popup said
`Talents  planned WS M+, now WS M+ (edited)` and offered **Switch talents**. Clicking it did
nothing at all.

It could not do anything. The popup only appears because the build differs from the plan's string;
the loadout NAME is already the right one and already selected. `PlanTab.loadTalents` asked
Blizzard's helper for that same name, the helper called `LoadConfig` on the config already loaded,
the game answered `NoChangesNecessary`, and nothing moved
(`Blizzard_ClassTalentsFrame.lua:1084` `LoadConfigInternal`). Blizzard's Apply writes a hand edit
INTO the selected loadout, so the saved copy carries the drift too: there is no build to load back.

The button was a dead click with no message. That is the fault.

**Which drift this is, is still open.** Either the saved "WS M+" really has moved away from the
simmed build, or the plan's baked string and this client's export differ past the header and
`(edited)` is a false mark. Card `0014` item 4 asked the same question. `/djbis talents` now
answers it.

## Links

- `0011` built the Talents button; this is a guard inside its `PlanTab.loadTalents`, so the Plan
  tab's own Talents button and the loadout list beside Blizzard's window get it too.
- `0013` draws the popup; `0014` owns the `(edited)` compare.

## Not this card

- Applying the planned build from the addon. `C_ClassTalents.LoadConfig` / `CommitConfig` from
  insecure code is the known route to frozen action bars (`0002`), and importing by name would
  make a second loadout with the same name.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the asked-for loadout is the one already selected, THE ADDON SHALL not ask the helper, and SHALL open the talent window and say in chat that the build must be saved over it. proves: `talents button says so when that loadout is loaded already`
- [x] WHEN the popup's loadout is the row's own name with the wrong build, THE ADDON SHALL label the button "Fix talents", not "Switch talents". proves: `the row's own loadout with the wrong build is not a switch, the button says Fix talents`
- [x] WHEN that is the case, THE ADDON SHALL say on the line that the build is not the one simmed, instead of "planned X, now X (edited)". proves: `the row's own loadout with the wrong build is not a switch, the line says the build is not the one simmed`
- [x] WHEN Rob types `/djbis talents`, THE ADDON SHALL print the build in play and every planned build of the spec, each marked same, different or cannot compare. proves: run in a client 2026-09-22, three lines, both cells marked `different`
<!-- AC:END -->

## Tasks

- [x] `PlanTab.loadTalents` returns `"same"` on the already-selected loadout.
- [x] `PlanTab.wrongHere` marks `wrong.drifted`; `PlanTab.setupPopup` reads it for the line and
  the button label.
- [x] `PlanTab.sayTalents` and `/djbis talents`.
- [x] Offline checks under the names above. The "reads only" check now expects
  `GetStarterBuildActive` and `GetLastSelectedSavedConfigID` too; both are reads.

## What I need from you

1. `/reload` (the game folder holds v0.24.2), then walk into a dungeon on Feral so the popup comes
   back. The talents line should read `WS M+ is loaded, but its build is not the one simmed` and
   the button should say **Fix talents**.
2. Click it. The talent window should open and one gold chat line should say to import the planned
   build and save it over "WS M+". Nothing else should happen.
3. ~~`/djbis talents`~~ **Done, 2026-09-22.** Answered card `0014` item 4: the saved loadout has
   really drifted. Same 25-character header and same first 58 characters as the plan's `WS M+`,
   then divergent, 118 characters against 117. The mark is true and the baked string is fine.
   Rob's own fix is to delete the saved `WS M+` and import the plan's string under that name.
4. With a genuinely wrong loadout loaded (say "DotC Raid ST *" in a key), the popup should still
   say **Switch talents** and that button should still work.

## Comments

- 2026-09-22 Claude: built and deployed at v0.24.2. Not seen in a client.
