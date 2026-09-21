# HANDOVER: Djinni's BiS (DBiS)

> A World of Warcraft Retail addon that answers one question about a dropped item: which druid specs
> want it. Scoped to Season 2, The Venomous Abyss. Read this, then `docs/board/`, before changing
> anything.

**Stage:** built, unreleased
**Category:** addon
**Status:** v0.15.0, `Interface: 120100`. No remote.
**Built and deployed locally and never published**, which `CHANGELOG.md` states in as many words:
everything is under `[Unreleased]`.
**Three live cards and every one of them is waiting on a live client.** `0001` and `0002` sit in
`human-review/` and are Rob's: `0001`, "the window has no decent way to open", needs a **full client
restart**, not a `/reload`. `0002`, "trinket tiers borrowed from ClassCodex", needs ten minutes with
ClassCodex disabled and then enabled. `0003`, "stat targets, and what a drop does to them", is in
`ai-review/`; Rob has now looked four times. Placement, dragging, side-swapping and the styling are
all **confirmed working at 0.11.3**. What is fixed and **not looked at** is 0.12.0, and it is the
card's actual subject rather than its chrome: the hero talent was never being read, and a one-handed
weapon was compared against an empty off-hand while a two-hander was equipped.
**2026-09-21: card `0004` is built and in `ai-review/`**, a gear plan table baked in from a Raidbots
Top Gear report, data only. One cell of it is filled, Feral single target. Cards `0005`, `0006` and
`0007` in `todo/` draw it and none is started.
**2026-09-21, later: card `0005` is built at 0.14.0 and in `ai-review/`.** Slots on the character
sheet that differ from the gear plan now glow, red for a wrong item and amber for a wrong enchant
or gem. Not yet seen in a client. **It passed its adversarial review the same day, with three
fixes, and is now in `human-review/` for four looks in the game.** `0004` is in `done/`, and `0003` is back in `todo/` on its
in-combat zero. The four open cards carry `not_for_the_loop:` because Rob builds this addon by hand
on msiraider.
**2026-09-21, later still: card `0006` is built at 0.15.0.** A planned piece that sits in the bags
unworn glows green, through Baganator's corner widget API, or on Blizzard's bag buttons when
Baganator is not loaded. Not yet seen in a client.
_Last updated: 2026-09-21 (card 0006: bag marks, deployed at 0.15.0)_

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
- `update-classcodex-data.ps1` - **author tooling, never shipped** (it is in `pkgmeta.yaml`'s ignore
  list). Rewrites **two** blocks in `DjinnisBiS.lua`, `GENERATED TRINKET TIERS` and `GENERATED STAT
  TARGETS`, from ClassCodex's data files. **Its header carries the full reasoning for why that
  source and not the sites**, including what each site actually answered when tried. Read it before
  proposing a scraper. Those markers are load-bearing: the script refuses to write without them
  rather than guessing where a table is. **It reads disk and does not fetch**, so run
  `python C:\Dev\WoWAddons\WoWClassCodexDownloader\download_classcodex.py` first to force ClassCodex
  itself current. It was called `update-trinket-tiers.ps1` until 2026-09-07.
- `update-gear-plan.ps1` - **author tooling, never shipped.** Writes the third generated block,
  `GENERATED GEAR PLAN`, from finished Raidbots Top Gear reports: one report fills one cell, spec by
  scenario (`st` one target, `2t` two), and cells it was not given are kept, because a report
  expires after 30 days. **Unlike the ClassCodex script it fetches**, two files per report. Its
  header says where the winning combo really is, which is `input.txt` and not the `simbot.input`
  field that looks like it. `.\update-gear-plan.ps1 -SelfTest` runs its checks against
  `fixtures/gear-plan/`, trimmed copies of two real reports.
- `offline-check.lua` - **author tooling, never shipped.** Runs the addon's own `/bis test` outside
  the game, under plain Lua, by stubbing enough of Blizzard's API to load the file: `lua
  offline-check.lua`, exit code 0 for a pass. **It proves the data and the pure logic and it proves
  no frame**, because every stubbed frame method does nothing, so a layout, anchor or event fault
  passes straight through it.
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
  `update-classcodex-data.ps1`. **The sites themselves were tried and are closed to a script:**
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
**2026-09-21, card 0004: a gear plan, at v0.13.0. Data only, nothing draws it yet.** `GEAR_PLAN` in
`DjinnisBiS.lua` holds, per spec and scenario, the gear a Top Gear sim chose: each slot's item id,
item level, enchant, gems and bonus ids, plus the talent loadout's name and import string.
`gearPlanFor(spec, scenario)` hands it over parsed, and `planMatches` compares **item id and item
level, never name**, because the same id drops on every track. **Only Feral `st` is filled.** The
other reports from that day were Advanced sims, which the generator refuses by name; each missing
cell wants one Top Gear run.

Built, deployed locally, unpublished, and **blocked on in-game observation**. The board has three
cards: `0001` and `0002` in `human-review/`, `0003` and `0004` in `ai-review/`. `todo/` holds `0005`, `0006` and `0007`, which all draw the gear plan `0004` built.

**2026-09-07, card 0003: stat targets, at v0.11.0.** The ratings the top 20% of each druid spec are
observed to run, per hero talent, for raid and Mythic+, out of the same ClassCodex files the trinket
tiers came from. They are drawn as four bars in three places: a new Stats tab in `/bis`, a pane
anchored beside the character sheet, and lines on any gear tooltip. Hovering an item anywhere shows
a ghost segment on every open bar, and lines on the tooltip, saying what that item would do against
the piece it would actually replace.

**Hero talent, not one set per spec, and that is the whole point of the card.** For Feral raid,
Druid of the Claw wants 1225 crit and the all-hero aggregate says 775. When there is no entry for
the player's hero talent the pane falls back to the aggregate **and says so on screen**, because a
silent fallback here can be wrong by more than half.

**v0.11.1, same day, after Rob's first look in a client: the character sheet pane sat on top of
Chonky Character Sheet.** Worth knowing because the obvious anchor is the wrong one. **A child frame
is not clipped to its parent**, so a sheet replacement widens what is on screen without
`CharacterFrame`'s own bounds moving, and `CharacterFrame:GetRight()` still reports the narrow
default. The pane now measures the furthest right any shown descendant reaches, which is right for
a plain sheet and for any replacement. It also wears Chonky's own section backdrop and **reads
Chonky's border colour off a named global frame rather than out of its source**, which matters:
Chonky ships All Rights Reserved, no modification and no redistribution, unlike ClassCodex, which is
MIT.

**v0.11.2, the fix to the fix, and two traps worth carrying to any other addon here.** 0.11.1 walked
every descendant of `CharacterFrame` and took the furthest right; the pane landed in the middle of
the screen. **`IsShown()` is not "visible"**: a frame's own flag reads true while an ancestor is
hidden, and other addons parent frames to `CharacterFrame`, so the walk found something far away and
believed it. It asks three named Blizzard frames now and uses `IsVisible()`. Second: **a point set
from coordinates is not an anchor.** It was correct when set and then sat still while the sheet was
dragged away from it. The point is set to a frame now, so a drag carries the pane for free.

**v0.11.3, two more, both about reading another addon's finished frames rather than guessing.**
`CharacterFrame` is not movable in Blizzard's UI, so whatever drags it here is an addon calling the
frame's own `StopMovingOrSizing`, not its drag scripts, which is why hooking `OnDragStop` caught
nothing and swapping sides only worked on a window resize; the METHOD is hooked now. And the pane
takes Chonky's actual row colours, header colour and section width, the last read at runtime off
`CCS_Section_SECONDARY`. **That forced the pane to be built on the first frame after the sheet is
first opened rather than at login**, because a sheet replacement builds those panels in its own
`OnShow` and at login there is nothing there to read.

**v0.12.0, two faults Rob's screenshots carried that nobody flagged, and both were the point of the
card rather than its chrome.** First, **the hero talent was never being read at all**, so every
player got the aggregate: `C_Traits.GetSubTreeInfo` takes `(configID, subTreeID)`, both of them, and
this addon passed the subtree alone. It returns nothing, the `pcall` succeeds, and the fallback runs
and says so in a sentence that reads like a design choice. **That is the risk with a soft fallback:
it cannot be told apart from working.** Second, **an empty slot always wins on a total of zero**,
which is right for a bare ring finger and wrong the moment an unusable slot is in the list: a
one-hander hovered against a two-hander compared itself with the empty off-hand and read as pure
gain. The pick is a pure function with five checks on it now.

**"Breakpoint" is deliberately not the word used.** These numbers are observed from logs, not
solved. A few are real mechanical breakpoints; most are just where good gear settles. The addon says
"targets" and the comment above the generated table says why.

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
**`docs/board/` owns this**, and the next buildable work is `0005`, `0006` and `0007` in `todo/`. Ahead of them are three cards, `0001`, `0002` and `0003`, all wanting a
live client. **They are one trip.** Open `/bis` once and `0001`'s and `0002`'s checks are in front of
you; click the new Stats tab, open the character sheet and hover a ring in your bags and `0003`'s
are too. `0003` also wants an adversarial pass before it can move on, which is what `ai-review/` is
for and does not need Rob.

## Blockers / open questions
- **Card `0001` needs Rob in a live client.** Full restart, then three answers: does *Djinni's BiS*
  appear in the minimap addon drawer, does the minimap button appear on the ring, and does hovering
  it show the summary tooltip.
- **Card `0002` needs Rob in a live client too.** The ranked trinket block with ClassCodex disabled,
  then the same window with it enabled to confirm every tier disappears.
- **The tier table and the stat targets go stale on somebody else's schedule**, exactly as the BiS
  list does, but that is now **two commands** rather than a hand edit:
  `python C:\Dev\WoWAddons\WoWClassCodexDownloader\download_classcodex.py` to force ClassCodex
  itself current, then `.\update-classcodex-data.ps1 -WhatIf` and the same without. It is
  idempotent, so running it when nothing has moved prints `Already current` and writes nothing, and
  since 2026-09-07 it ignores its own date stamp when deciding that, so a re-run on a later day no
  longer reports a change that is only a moved date. The panel shows the stamp it was generated
  with, so staleness is on screen rather than in somebody's memory. **The BiS list above it still
  has no such tool** and is still hand-maintained from method.gg and Icy Veins.
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
4. To refresh the gear plan after a Top Gear run, with or without an agent. It takes ids or full
   report links, several at once, and says which spec and scenario each one fills:
   `.\update-gear-plan.ps1 -WhatIf <report link>`, then the same without `-WhatIf`, adding
   `-Deploy` to put it in the game.
5. Check any API against `C:\Dev\WoWAddons\wow-ui-source\`, never from memory. Anything defined only
   under `Blizzard_Deprecated*/` is CVar-gated and is not safe to rely on.

## Sibling docs
- `RELEASE_NOTES.md` in the repository root, for what the first release will say.
- Workspace: `C:\Dev\WoWAddons\docs\HANDOVER.md` and `docs\DECISIONS.md`.
- **Gaps:** no `README.md`, no `PRD.md`, no `DATA-MODEL.md`, no `DECISIONS.md`.

## Branch status
One branch, `master`. Clean. No remote, so "unpushed" is not a meaningful count here.

## Session log
- **2026-09-21, second session** Card `0005`. Slot marks, a scenario button and a plan strip under
  the stat pane, deployed at v0.14.0. Worth carrying: Chonky moves Blizzard's slot buttons rather
  than drawing its own, and an item link carries enchant and gem item ids in fields 2 to 6, so
  neither needs an API call.
- **2026-09-21** Card `0004`. The gear plan table, `update-gear-plan.ps1` and its fixtures, deployed
  at v0.13.0. Worth carrying: a Raidbots `data.json` does not hold the winning combo's gear, the
  report's `input.txt` does. And in PowerShell, `[ordered]@{ 1 = 'st' }[1]` indexes by position;
  the script's self-test caught that filing one enemy as two.
- **2026-09-07** Card `0003`. Stat targets and their bars, deployed at v0.11.0. Three side effects
  worth knowing about. `update-trinket-tiers.ps1` is renamed `update-classcodex-data.ps1`, because
  it now writes two generated blocks rather than one. `offline-check.lua` is new: it runs `/bis
  test` outside the game, and a mutation test through it caught a bar check that was the formula
  restated and therefore worthless. And a workspace-level finding that is **not yet in
  `C:\Dev\WoWAddons\docs\DECISIONS.md`**: the guard for a 12.1 secret value is `canaccessvalue`,
  falling back to `issecretvalue`. That log already records that `type()` cannot see a secret; it
  does not yet name the two globals that can.
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
