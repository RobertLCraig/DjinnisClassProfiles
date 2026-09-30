---
needs: 0051, 0080
---
# 0082 One job, one key, across every druid spec and build

## Why
Rob, 2026-09-30: "Want to normalize my bars across all specs and builds (especially abilities that
are not unique to each build). Need you to pull in and analyse my bars and keybinds, work with me
to identify which are the correct ones that they should be (might need to see an overlay) ...
potentially fill in the bellular spreadsheet for me, updating the keybinds to match my druid too,
that way we can expand it to work for all classes too later."

His active bars are 1, 4 and 7; bars 5 and 8 hold utilities, professions, toys and mounts. Forms
are on OPie rings.

## Done (2026-09-30, analysis only, no addon code)
- `docs/research/2026-09-30-druid-bars-by-job.md`: every ability button by spec, each Bellular job's
  button in each spec, shared spells' keys per spec, and a proposal with Feral as the model.
- `docs/research/Midnight Keybind Planner (Rob's druid keys).xlsx`: Bellular's planner with Rob's
  key for 29 jobs. Every class page follows, which is the start of the "all classes later" step.

Headline: the keys are identical in every spec, so this is only about which spell sits on which
button. Only five shared things agree everywhere (Heart of the Wild, Stampeding Roar, Rebirth,
Dash, Innervate). Each spec also carries its own copy of the cat, bear and moonkin pages.

## Open, and Rob's to say
1. **The model.** Feral for every job (Bellular's way: a tank's Frenzied Regeneration takes Ferocious
   Bite's key), or Feral only for the shared spells, each spec keeping its own rotation keys.
2. **The overlay.** A job name drawn on each real button (from this card's table), toggled from
   More, so Rob can see and say "that one is wrong" in game.

## Then (build)
- Each spec's layout rewritten from the agreed job -> key table: `translateBars` (card `0051`)
  already moves an ability by job; the table becomes Rob's keys, not Bellular's.
- Form pages: every spec's Cat page from Feral, Bear page from Guardian, Moonkin page from Balance.
- Loaded through the usual preview (`0046`), compare (`0080`) and Undo.

## Acceptance
<!-- AC:BEGIN -->
- [ ] #1 Rob agrees a job -> key table. proves: this card's comments
- [ ] #2 WHEN a spec's layout is made from it, EVERY shared spell SHALL sit on the same key as on Feral. proves: a check on fixture layouts
- [ ] #3 In a client: switch Feral -> Guardian -> Balance -> Resto; Barkskin, Soothe, Roots, Skull Bash / Solar Beam, Regrowth are on the same keys in each. proves: none
<!-- AC:END -->

## Comments

**2026-09-30, Rob.** 1: "B (Although Guardian is for the most part setup relatively well for me, so would need to review any changes)". 2: "yes" to the overlay.

**2026-09-30, Claude.** Overlay built, v0.63.0. More > Show jobs on the bars (`/dcp bars jobs`). Each Blizzard bar button with a job gets its short name (C1 to C11, Kick, Def1, Heal4 and so on): green when it sits on its Feral button, amber with "to <key>" when it belongs elsewhere. The job table is `PlanTab.JOB_BUTTONS`, read off Feral / Dungeon: the 27 Bellular jobs Rob has a key for, plus Healthstone, Damage Potion and his own extras (Recuperate, Incapacitating Roar, Ursol's Vortex, Thorn Bloom). A macro counts as its spell (`GetMacroSpell`, which Blizzard's own `ActionButtonOverrides.lua` calls; it is not in the API docs). Redrawn on bar, form, spec and binding changes; hidden in combat. Tiger Dash joins `BAR_ALIASES` as Dash. Checks: `PlanTab.barJobChecks`, 14 lines; six mutations each made 1 to 2 fail.

Next: Rob reviews each spec with the overlay on (Guardian first, as he asked), says which amber ones are wrong, and the table changes to suit. Then each spec's layout is made from the table, Guardian's only after he has seen its changes.

**2026-09-30, Rob, Guardian review with the overlay (screenshots):** "keep Frenzied Regeneration on Alt+Q, keep Survival Instincts on Alt+1, keep Lunar Beam on Alt+3".

**2026-09-30, Claude.** v0.63.1. `PlanTab.JOB_SPEC.Guardian` holds those three (Combat 4 on Alt+Q, Personal Defensive 2 on Alt+1, Combat 8 on Alt+3), read through `PlanTab.jobHome`. That takes Rip's key (Alt+3, Combat 3) from Maul, so **Maul goes to Alt+4** (Combat 8's Feral key, free once Ursol's Vortex moves to Alt+R): proposed, for Rob to confirm. Also fixed from the screenshots: a job with no short name drew its whole name ("Class 7 (Raid Defensive)"); every Bellular job now has one, and a job with no agreed key is grey with no "to". Three more mutations each made 1 to 2 checks fail.

**2026-09-30, Rob, on Balance:** the overlay's moves for Sunfire, Moonfire, Wrath and Starfire are the keys of his core rotation, "not sure I could deal with moving" them. Given two choices he picked the casters keeping their core keys; "starfire is on 4".

**2026-09-30, Claude.** v0.63.2. `PlanTab.JOB_SPEC.Balance` and `.Resto`: Sunfire 1 (Combat 4), Moonfire 2 (Combat 3), Wrath 3 (Combat 1), Starfire 4 (Combat 2). Combat 7 (Lunar Eclipse, Lifebloom) then takes Alt+3, Rip's Feral key, which Moonfire leaves: proposed, for Rob to confirm with the overlay. Every other job still follows Feral.
