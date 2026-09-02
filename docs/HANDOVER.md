# HANDOVER: Djinni's BiS (DBiS)

> A World of Warcraft Retail addon that answers one question about a dropped item: which druid specs
> want it. Scoped to Season 2, The Venomous Abyss. Read this, then `docs/board/`, before changing
> anything.

**Stage:** built, unreleased
**Category:** addon
**Status:** v0.10.0, `Interface: 120100`. No remote.
**Built and deployed locally and never published**, which `CHANGELOG.md` states in as many words:
everything is under `[Unreleased]`.
**Two live cards and both are waiting on Rob**, both in `human-review/` and both wanting a live
client. `0001`, "the window has no decent way to open", needs a **full client restart**, not a
`/reload`. `0002`, "trinket tiers borrowed from ClassCodex", needs ten minutes with ClassCodex
disabled and then enabled.
_Last updated: 2026-09-02 (card 0002: trinket tiers copied out of ClassCodex, deployed at 0.10.0;
this file was untracked until this commit)_

## Goal & success criteria
**No PRD exists. This section is an interim home and a real gap.** What follows is read off the
`.toc` Notes and card `0001`, not from a stated spec.

Goal: when an item drops, say which druid specs want it, without the player leaving the loot roll to
go and look it up.

Success, as it appears to operate: the answer is correct for Season 2, The Venomous Abyss, and it is
reachable fast enough to use during a roll.

**The non-goals are unknown and need Rob.** The obvious open one: is this druid-only on purpose, or
druid-first?

## Canonical data shape
`DjinnisBiSDB`, one account-wide SavedVariables table declared in the `.toc`. **Its shape lives in
`DjinnisBiS.lua` and nowhere else**; there is no `DATA-MODEL.md`, and that is a gap rather than a
decision.

The BiS data itself is season-scoped. **That is the thing about this addon that goes stale on a
schedule somebody else sets**: a new season invalidates the answers without changing a line of code.

The BiS list is matched by **name**; the trinket tier table added on 2026-09-02 is keyed by **item
id**. That is not an inconsistency to tidy: the tier data came out of ClassCodex, which stores ids,
and an id survives spelling and locale where a name does not. The two join at runtime, because the
Encounter Journal harvest turns a name into a link and a link carries an id.

## Architecture / stack
Lua against the Blizzard Retail API. **One Lua file**, plus four bundled libraries
under `Libs/`: `LibStub`, `CallbackHandler-1.0`, `LibDataBroker-1.1` and `LibDBIcon-1.0`. No build
step beyond `release.ps1` and no test suite: **every check that matters happens in a live game
client, which no agent can run** - which is exactly why card `0001` is a question for Rob rather
than a task.

## Key files / structure
- `DjinnisBiS.lua` - the whole addon.
- `update-trinket-tiers.ps1` - **author tooling, never shipped** (it is in `pkgmeta.yaml`'s ignore
  list). Rewrites the block between the `-- BEGIN/END GENERATED TRINKET TIERS` markers in
  `DjinnisBiS.lua` from ClassCodex's data files. **Its header carries the full reasoning for why
  that source and not the sites**, including what each site actually answered when tried. Read it
  before proposing a scraper. Those two markers are load-bearing: the script refuses to write
  without them rather than guessing where the table is.
- `Libs/LibDBIcon-1.0/` - the minimap button and, at `LibDBIcon-1.0.lua:508-526`, the runtime
  `AddonCompartmentFrame:RegisterAddon(...)` call that card `0001` turns on. **Read that card before
  touching how the window opens**; the two routes into the addon drawer are mutually exclusive and
  turning both on would show two entries.
- `deploy.ps1`, `release.ps1`, `pkgmeta.yaml` - this addon owns its own, with their own exclusions.
- `CHANGELOG.md`, `RELEASE_NOTES.md` - `RELEASE_NOTES.md` is what the first release will say.

## Decisions locked
- **Trinket tiers come from ClassCodex's shipped data files, not from the sites** (2026-09-02).
  A WoW addon cannot make a network request: there is no HTTP call anywhere in Blizzard's API
  surface, checked against `wow-ui-source`. So tier data is baked in at author time by
  `update-trinket-tiers.ps1`. **The sites themselves were tried and are closed to a script:**
  Archon answers a plain GET with `403`, Wowhead, Icy Veins and u.gg publish no API, and
  Bloodmallet is reachable but documents no endpoint (guesses returned `500` and `404` on
  2026-09-02). ClassCodex already scrapes u.gg and Icy Veins, maintains those parsers and ships
  the result as parseable Lua keyed by item id, and **CurseForge refreshes those files on disk
  whether or not the addon is enabled in the game**, which is what makes this work while
  ClassCodex stays disabled. The cost is that this is second-hand data; the script fails loudly
  rather than writing a partial table if ClassCodex changes shape or goes away.
- **Raidbots is not the source for tiers, and that is not an oversight.** Its Droptimizer CSV is
  already imported elsewhere in this addon, for the thing it is genuinely better at: your own
  character's dps gain per item. It is a per-character sim, not a public per-spec ranking, so it
  cannot answer "what tier is this trinket for Feral".
- **One route into the addon compartment, not two.** Today it is the `.toc`
  `## AddonCompartmentFunc: DjinnisBiS_Toggle` line. The alternative is `showInCompartment = true`
  in the LibDBIcon saved settings. Card `0001` decides which, and both on at once is wrong.
- **`Libs/` is tracked.** See `WoWAddons#0003`, which reversed its own criterion on that point:
  bundled libraries ship inside the addon, so they are part of the artefact.

## Current state
Built, deployed locally, unpublished, and **blocked on in-game observation**. The board has two
cards and both are in `human-review/`. Nothing is in `todo/`.

**2026-09-02, card 0002: the S/A/B/C trinket tiers now live in this addon, at v0.10.0.** They were
generated out of ClassCodex 1.3.1's own `Data/db_ugg.lua` and `Data/db_icyveins.lua`, which store
tiers as plain data keyed by item id, one list per spec. All four druid specs are covered, PvP
contexts dropped. Every trinket cell in the By Slot tab now carries a coloured letter, and a new
ranked block underneath lists every trinket those two sites rate, best first, not only the ones on
the BiS list. The By Boss tab deliberately shows none: a tier is per spec and that tab lists an item
once per spec that wants it.

**The tiers turn themselves off whenever ClassCodex is loaded**, and say so on screen rather than
going quietly missing. The reason is that this is a copy of a moving thing: ClassCodex re-ships its
data when the sites move and this table cannot, so two panels of the same letters with one stale is
worse than one panel. `373` offline checks passed against the table and the tier helpers before
deploy, which proves the data and the pure logic and **no frame**.

## What's next (in order)
**`docs/board/` owns this**, and today that is two cards, `0001` and `0002`, both waiting on Rob and
both wanting a live client. They are one trip: open `/bis` once and both cards' checks are in front
of you.

## Blockers / open questions
- **Card `0001` needs Rob in a live client.** Full restart, then three answers: does *Djinni's BiS*
  appear in the minimap addon drawer, does the minimap button appear on the ring, and does hovering
  it show the summary tooltip.
- **Card `0002` needs Rob in a live client too.** The ranked trinket block with ClassCodex disabled,
  then the same window with it enabled to confirm every tier disappears.
- **The tier table goes stale on somebody else's schedule**, exactly as the BiS list does, but it
  is now **one command** rather than a hand edit: `.\update-trinket-tiers.ps1 -WhatIf` then the
  same without. It is idempotent, so running it when nothing has moved prints `Already current`
  and writes nothing. The panel shows the stamp it was generated with, so staleness is on screen
  rather than in somebody's memory. **The BiS list above it still has no such tool** and is still
  hand-maintained from method.gg and Icy Veins.
- **No GitHub remote and never published.** `WoWAddons#0004` is the remote question for the
  workspace. Publishing is a separate call.
- **Season-scoped data.** Nothing here records who refreshes it or when.

## How to pick up
1. Read this file, then `docs/board/README.md`, then card `0001` in `docs/board/human-review/`.
2. Read `C:\Dev\WoWAddons\docs\DECISIONS.md` for the two 12.1 traps before touching event
   registration or anything keyed on a unit.
3. Deploy from the workspace and never edit the game folder:
   `C:\Dev\WoWAddons\bin\deploy.ps1 -WhatIf -Only DjinnisBiS`, then the same without `-WhatIf`. The
   dry run is the plan.
4. Check any API against `C:\Dev\WoWAddons\wow-ui-source\`, never from memory. Anything defined only
   under `Blizzard_Deprecated*/` is CVar-gated and is not safe to rely on.

## Sibling docs
- `RELEASE_NOTES.md` in the repository root, for what the first release will say.
- Workspace: `C:\Dev\WoWAddons\docs\HANDOVER.md` and `docs\DECISIONS.md`.
- **Gaps:** no `README.md`, no `PRD.md`, no `DATA-MODEL.md`, no `DECISIONS.md`.

## Branch status
One branch, `master`. Clean. No remote, so "unpushed" is not a meaningful count here.

## Session log
- **2026-09-02** Card `0002`. Trinket tiers copied out of ClassCodex, deployed at v0.10.0. Also a
  finding about ClassCodex itself, written up on that card: it ships a `ReduceTaint.lua` whose
  functions are named `FixMultiActionBarTaint` and `FixMicroButtonTaint`, and it calls
  `C_ClassTalents.LoadConfig` and `CommitConfig` from insecure code, which is the known route to
  action bars that stop updating in combat. Rob's decision to disable it stands. This addon is clear
  of that class of fault: it touches no talent, action bar or secure frame. This handover was
  untracked until this commit.
- **2026-08-26** Handover created. The board already existed; this repository was showing on
  `board:map` as a project with no category, which is what this page fixes. No addon code was
  touched.
