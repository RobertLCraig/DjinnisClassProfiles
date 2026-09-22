---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0007
---
# 0018 Every planned loadout in the /simc export

## Why

To compare the per-boss builds, each one has to be pasted into Raidbots by hand. On 2026-09-21 that
took a separate talent sim for each spec (SecondBrain output "2026-09-21 Raid DPS as Feral or
Balance", section "Talents against Dreamgrove").

Talent Loadout Manager hooks the Simulationcraft addon's `PrintSimcProfile` and adds every saved
loadout to the export, so one Raidbots Top Gear or Advanced run sims them all (read 2026-09-22).
The installed Simulationcraft addon has `Simulationcraft:PrintSimcProfile` (`core.lua` line 1418) and
`Simulationcraft:GetSimcProfile` (line 1045).

What it saves: one paste instead of one per build, for Rob's own runs and for "Claude re-sims".

## Links

- Needs `0007`: the loadout names the plan uses.

## Not this card

- Running a sim. Rob pastes the export as today.
- Loadouts the plan does not name. TLM adds all; this adds only the planned ones, so the export
  stays short.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN `/simc` builds its export and the Simulationcraft addon is loaded, THE ADDON SHALL add one commented talents line per planned loadout of the current spec, named after the loadout. proves: `simc export carries each planned loadout`
- [x] WHEN the Simulationcraft addon is not loaded, THE ADDON SHALL do nothing and show no error. proves: `no error without the simc addon`
- [x] WHEN a planned loadout is not saved in the game, THE ADDON SHALL leave it out and name it in one chat line. proves: `a missing loadout is left out and named`
<!-- AC:END -->

## Tasks

- [x] Read how TLM adds its lines (`TalentLoadoutManager`, SimulationCraft module) and the exact
  line format Raidbots reads for a named talent set (`# Saved Loadout: name` then `# talents=...`).
  TLM is not installed here; the format was read off the SimC addon's own `GetExportString`
  (`core.lua` line 380) and a real export, `2026-09-22 Feral v1.txt`.
- [x] Hook with `hooksecurefunc` on the Simulationcraft table, after `ADDON_LOADED` for it.
  A plain wrapper, not `hooksecurefunc`: the block has to go into the returned string, and
  `hooksecurefunc` cannot change a return. Armed at `PLAYER_LOGIN`, by which time Simulationcraft
  (not load-on-demand, loads after D) is present or is not.
- [x] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" in a SecondBrain session. Ideation only.
- 2026-09-22 Claude: built. **Most of the need was already met before this card.** The installed
  Simulationcraft addon (12.1.0-03) writes every saved loadout of the current spec into the export
  on its own, unconditionally, as `# Saved Loadout: NAME` then `# talents=...` (`core.lua` line
  1198 onwards), and the real export from this morning carries all six loadouts the Feral plan
  names. So the first criterion holds for any planned loadout that is saved in the game, with no
  code from here. What was genuinely missing, and is what this card adds, inserted just after the
  SimC addon's own loadout lines:
  1. A comment block naming which loadout each plan boss wants, one `# boss -> loadout` line per
     row of `PlanTab.BOSSES`, so one paste tells Rob or a re-simming Claude which build goes with
     which fight.
  2. For a planned loadout that is not saved in the game: when the gear plan carries its talent
     string (`GEAR_PLAN[spec][scenario].talents`, today `DotC Raid ST *` and `WS M+`), the plan's
     string is written as `# Saved Loadout: NAME (DBiS plan)` plus `# talents=...`, so Raidbots
     still sims it. When it does not, the loadout is left out and named in one chat line, as the
     third criterion asks.
  Code: `PlanTab.simcLines` (pure), `PlanTab.simcInsert` (pure), `PlanTab.simcAppend` (reads the
  saved names through `C_ClassTalents.GetConfigIDsBySpecID` and `C_Traits.GetConfigInfo`, both
  checked against `SharedTraitsDocumentation.lua` and `ClassTalentsDocumentation.lua`, name guarded
  by `canRead`) and `PlanTab.armSimc` (wraps `Simulationcraft.GetSimcProfile` once, only when that
  global is a table with that function). No new top-level local; the count is still 177. 32
  checks under the three criterion names plus `simc block sits with the addon's own loadouts`;
  `lua offline-check.lua` and Lua 5.1 both exit 0. Mutation-tested in a temp copy: dropping the
  `not saved[...]` guard, dropping the `type(simc) ~= "table"` guard, and dropping the search for
  the last `# talents=` line each turned their own checks red (4, 2 and 2 FAIL lines).
  **What a person must look at in the game, none of it seen here:** (a) `/simc` on Feral, then find
  the `# Djinni's BiS plan (Feral): boss -> loadout` block under the last `# Saved Loadout` pair,
  ten boss lines; (b) rename or delete one saved loadout that has no plan string (say `WS Raid
  Coiled Altar`), `/simc` again, and expect one grey chat line naming it; (c) delete `WS M+`
  instead and expect a `# Saved Loadout: WS M+ (DBiS plan)` pair in the block; (d) paste the export
  into Raidbots and confirm it still parses and the extra loadout is offered as a talent set; (e)
  disable Simulationcraft, log in, and expect no error at login and no change. **Left out:** the
  `SimulationcraftAPI.GetSimcProfile` copy other addons call is not wrapped, because `/simc` does
  not go through it and nothing here needs it; offspec loadouts, because the plan is per current
  spec; and TLM itself was not read, because it is not installed on this machine.
