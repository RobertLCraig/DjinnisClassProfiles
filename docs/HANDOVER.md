# HANDOVER: Djinni's BiS (DBiS)

> A World of Warcraft Retail addon that answers one question about a dropped item: which druid specs
> want it. Scoped to Season 2, The Venomous Abyss. Read this, then `docs/board/`, before changing
> anything.

**Stage:** built, unreleased
**Category:** addon
**Status:** v0.19.1, `/djbis` (and `/bis`), `Interface: 120100`. No remote.
**2026-09-22, latest: card `0009` is built, reviewed and in `human-review/` at v0.19.1.** Mythic+
is a third plan cell beside the raid ones, `mplus`, filed by the generator off `simbot.fightStyle`
starting `Dungeon`; the cell is empty until Rob runs one DungeonSlice Top Gear. **The content rule
changed: where you stand beats the pinned switch now** (before, the pin won), so a key shows the
Mythic+ plan whatever was pinned in a city. The review fixed the strip button sticking on 2 targets
inside a raid, greyed both switches inside an instance, and made zoning rebuild the bag glows.
Seven looks are on the card. The fix is inside `3e181ba`, a concurrent session's board commit.
**2026-09-22, earlier: card `0010` is built, reviewed and in `human-review/` at v0.18.1.** A lower
rank of the planned enchant or gem is "lesser" now, a grey "rank" mark and "Plan: fine.", and the
Plan tab lists the higher rank under "Higher ranks exist" instead of "To buy". The ranks come from
a fourth generated block written by `update-plan-ranks.py` out of Raidbots. Its review turned the
gem order round (quality first, then item level: Wowhead's stats say the rare at 278 beats the
uncommon at 295) and added three checks against the tab as drawn. Four looks in the game are on
the card.
**2026-09-22, earlier: card `0008` is in `done/`, confirmed by Rob in the game.**
The Plan tab has buttons now: Talents opens the talent window and loads nothing, Equip puts the
exact bag copy in the planned slot, Search AH runs the auction house's own search. Its review
fixed three faults at 0.17.1: an unnamed enchant searched by item id, a refused equip left on
the cursor, and a redraw that only worked once the character sheet had been opened. Rob then saw
all three buttons work, and 0.17.2 made them look like buttons. **`todo/` holds one card, `0009`**, a Mythic+ plan beside the raid plan, written
by Rob the same night; six cards wait on one trip to a live client.
**2026-09-21: card `0007` is built, reviewed and in `human-review/`.** A
fourth tab, Plan, names the talent loadout per boss, the slots to change and what to buy. Its review
made the checks read the drawn tab and fixed three small faults at 0.16.1. It wants eight looks in
the game. **`todo/` is now empty**, and six cards wait on one trip to a live client. The main chunk
of `DjinnisBiS.lua` has nine top-level locals left of Lua's 200: add to a table, not a local.
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
Baganator is not loaded. It passed its adversarial review the same day, with one taint fix, and
is now in `human-review/` for five looks in the game.
**2026-09-21, last: card `0003` is now in `human-review/`, not `ai-review/` or `todo/`.** Its in-combat
zero was fixed at 0.15.1, a second adversarial pass stopped a proc from emptying the rating cache
mid-fight, and what is left is six looks only a game client can settle.
_Last updated: 2026-09-22 (card 0009 reviewed and in human-review, v0.19.1)_

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
- `update-plan-ranks.py` - **author tooling, never shipped.** Writes the fourth generated block,
  `GENERATED PLAN RANKS`: every id in the family of every enchant and gem the gear plan asks for,
  with its rank, from Raidbots' `enchantments.json` and `gems.json` (**it fetches**, with a curl
  user agent because the default one gets 403). An enchant family is the scroll's item name and
  its rank is `craftingQuality`; a gem family is the name without "Flawless " or "Perfect " and its
  rank is its place ordered by quality then item level. Run it after `update-gear-plan.ps1` adds
  an enchant or gem the table has never seen; `--check` exits 1 when it must be run.
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
**2026-09-22, card 0009: where you stand beats the pinned switch, at v0.19.0 and 0.19.1.**
`statContext()` answers the instance first (`party` is Mythic+, `raid` is Raid), then the stat
pane's pinned switch, then Raid. Until this card the pin won, and a Raid pin from a city followed
Rob into a key. `planScenario(spec)` is `mplus` whenever that content is Mythic+, else the saved
1 or 2 target raid cell, so the stat targets, slot glows, bag glows and Plan tab read one rule.
Inside an instance both switches are greyed because the content is not a choice there; the strip's
button cycles 1, 2, Mythic+ outside, 1, 2 in a raid, and stays put in a dungeon.

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
**`docs/board/` owns this.** `todo/` holds `0011`, a Talents button through Blizzard's own
helper, `0012`, a Blizzard equipment set after Equip all, `0020`, the game-window look (its rule 11
is the three-button Raid / Mythic+ row the Plan tab still lacks), and `0013` to `0027`, ideas from
other addons, one card each (as of 2026-09-22). All carry `not_for_the_loop:` because Rob builds
this addon by hand on msiraider. Whoever builds one adds to the `PlanTab` table rather than a new
top-level local: the main chunk holds 189 of Lua's 200.

Eight cards sit in `human-review/`, `0001`, `0002`, `0003`, `0005`, `0006`, `0007`, `0009` and
`0010`, all wanting a live client. **They are one trip**, and each card lists its own checks under
`## What I need from you`. Open `/bis` for `0001` and `0002`; open the character sheet, hit a
dummy and hover a ring for `0003` and `0005`; open Baganator for `0006`; open the Plan tab for
`0007`; click the strip's button round and zone into a dungeon for `0009`, then run one DungeonSlice
Top Gear; hover the wrist with the rank 3 garnet in it for `0010`. The buttons (`0008`) are
confirmed working; only the Equip all ring-order path is unseen.

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
- **2026-09-22, last** Card `0009` reviewed, four fixes and four checks, deployed at v0.19.1.
  Worth carrying: a button that cycles a list must be told which stops the place has removed, or
  it sticks on the last one it can reach; a switch the place overrides should be greyed, not left
  writing a pin nobody sees; and a cached list keyed on the content needs a zone event, because
  gear and spec events do not fire on a loading screen. Also: two sessions on this repo at once,
  and the other's `git commit` took my staged files into its board commit (`3e181ba`). Stage and
  commit in one step, and check `git log -1` before staging anything.
- **2026-09-22, later** Card `0010` reviewed, one fix and three checks, deployed at v0.18.1.
  Worth carrying: a sort key that "reads right" is a claim until the data is checked, and here
  Wowhead's tooltips said the opposite of the builder's reading; and a drawn row nobody asserts
  on can be deleted without a check noticing, so the tab-as-drawn checks from the 0007 review are
  the pattern for anything new on the Plan tab. Also: two sessions gave `0010` to two cards the
  same night; the unbuilt equipment-set card is `0012` now. Check `ls docs/board/*/` for the
  highest number before allocating, not the lane you are in.
- **2026-09-22** Card `0008` reviewed, three fixes, deployed at v0.17.1. Worth carrying: a check
  with nothing to act on cannot fail, and the equip checks were exactly that until `selfTest` got
  a pretend bag; `a and b or c` is wrong the moment `b` may be nil; and the slot-mark watcher does
  not exist until the character sheet is first opened, so anything that must run from login rides
  the bag-mark watcher instead.
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
