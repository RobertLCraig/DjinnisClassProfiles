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
- 2026-09-22 Claude (review): **pass with two real faults fixed in place**, both in feature
  commit `0dad3e4`, both invisible to the offline checks because the checks faked the thing that was
  wrong. Attacked: the three criteria and their checks, the wrapper against the installed
  Simulationcraft 12.1.0-03 source, and the pure functions against the real export
  `2026-09-22 Feral v1.txt`.
  **Fault 1, the feature never armed.** `armSimc` read `_G.Simulationcraft`. That global does not
  exist: `core.lua` line 4 is `local _, Simulationcraft = ...` and line 6 assigns the Ace addon
  object to that same local, and neither `extras.lua` nor `bonusrolls.lua` exports it. In the game
  `armSimc` returned false at every login and `/simc` was untouched. Fixed: the addon object comes
  from `LibStub("AceAddon-3.0", true):GetAddon("Simulationcraft", true)`, which is the only handle
  to it; the check now fakes that registry instead of a global, and a mutant reading the global goes
  red (4 FAIL lines).
  **Fault 2, the block broke the addon's checksum.** The SimC addon ends its text with
  `# Checksum: <adler32 of everything before it>` (`core.lua` line 1410). The block was inserted
  after the last `# talents=` line, inside the checksummed text. Raidbots reads a mismatch as a
  tampered paste: on simc-addon issue 47 the Raidbots author asks loadout addons not to touch the
  checksum, which is why they append after it. Verified against the real export: its checksum
  matches an adler32 of the text before the line, and a one-line insert in the middle does not.
  Fixed: the block goes after the checksum line; `simcInsert` and its three checks are gone, the
  wrapper check now asserts the addon's text survives byte for byte and the block follows the
  checksum, and a mutant inserting before the checksum goes red (4 FAIL lines). The third mutant,
  dropping the `not saved[]` guard, goes red as before (5).
  **Held:** the read of saved names is guarded by `canRead` before any key use; the plan's `WS M+`
  string equals the one the game had saved in the real export; ten boss lines follow the checksum;
  the chat line names an unsaved loadout with no plan string once; a `simcPrintError` from the addon
  passes through with no block; a non-Feral spec leaves the text alone. Both offline checks exit 0
  under Lua 5.4 and 5.1, 31 checks on this card (three gone, two added), and the top-level local
  count is still 177.
  **Security:** weakest point is the wrapper itself, one swapped field on another addon's table,
  which a later Simulationcraft release can rename and the feature then silently does nothing, which
  is the safe direction; unchecked path is none, every input is plan data or a `canRead`-guarded
  name and every game read is inside `pcall`; on failure it leaks nothing, the addon's own text is
  returned unchanged and the only new output is loadout names Rob wrote.
  **Not verified here, and this is the whole check:** whether Raidbots reads `# Saved Loadout` pairs
  placed after its checksum line. The evidence is issue 47 (the author says loadout addons append
  after it) and that TLM's users get their loadouts simmed; look (d) below settles it.

## What I need from you

- (a) `/simc` on Feral: the `# Djinni's BiS plan (Feral): boss -> loadout` block is now the last
  thing in the window, after `# Checksum:`, ten boss lines. If it is not there at all, the Ace
  registry path failed and `/dump LibStub("AceAddon-3.0"):GetAddon("Simulationcraft")` is the first
  thing to look at.
- (b) Delete or rename `WS Raid Coiled Altar`, `/simc` again: one grey chat line names it.
- (c) Delete `WS M+` instead: a `# Saved Loadout: WS M+ (DBiS plan)` pair in the block.
- (d) Paste that export into Raidbots: no "modified" or checksum warning, and `WS M+ (DBiS plan)`
  is offered as a talent set. This is the one that decides the card.
- (e) Disable Simulationcraft, log in: no error, `/simc` unknown as before.
