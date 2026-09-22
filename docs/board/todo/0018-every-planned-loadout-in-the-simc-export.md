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
- [ ] WHEN `/simc` builds its export and the Simulationcraft addon is loaded, THE ADDON SHALL add one commented talents line per planned loadout of the current spec, named after the loadout. proves: `simc export carries each planned loadout`
- [ ] WHEN the Simulationcraft addon is not loaded, THE ADDON SHALL do nothing and show no error. proves: `no error without the simc addon`
- [ ] WHEN a planned loadout is not saved in the game, THE ADDON SHALL leave it out and name it in one chat line. proves: `a missing loadout is left out and named`
<!-- AC:END -->

## Tasks

- [ ] Read how TLM adds its lines (`TalentLoadoutManager`, SimulationCraft module) and the exact
  line format Raidbots reads for a named talent set (`# Saved Loadout: name` then `# talents=...`).
- [ ] Hook with `hooksecurefunc` on the Simulationcraft table, after `ADDON_LOADED` for it.
- [ ] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" in a SecondBrain session. Ideation only.
