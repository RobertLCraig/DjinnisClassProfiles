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
