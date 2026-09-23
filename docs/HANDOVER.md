# HANDOVER: Djinni's BiS (DBiS)

> A World of Warcraft Retail addon that answers one question about a dropped item: which druid specs
> want it. Scoped to Season 2, The Venomous Abyss. Read this, then `docs/board/`, before changing
> anything.

**Stage:** built, unreleased
**Category:** addon
**Status:** v0.39.1, `/djbis` (and `/bis`), `Interface: 120100`. No remote. `ai-review/` holds `0046` (bar preview). `0029`, `0039` to `0045` passed review and sit in `human-review/`. `todo/` holds `0035` and `0038` (the action button taint error, waits on a taint log from Rob); `0036` and `0037` (Save bars buttons, named profiles) passed review and sit in `human-review/`; `0031` to `0034` passed review (0033 on its sixth pass, at v0.33.4) and sit in `human-review/`; forty-one cards sit in `human-review/` and every one waits on one trip to a live client.
_Last updated: 2026-09-23 (v0.39.1: point at a Load bars button or an "own bars" row and the saved layout shows on your real bars, card 0046. Older entries: `docs/build/SESSION-LOG-ARCHIVE.md`.)_

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
`DjinnisBiSDB`, one account-wide SavedVariables table declared in the `.toc`, and since v0.28.0
`DjinnisBiSCharDB`, per character, which holds only the action bar undo (card 0033). **Its shape lives in
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

**Two Lua 5.1 ceilings in `DjinnisBiS.lua`, and both are hit.** The main chunk holds 200 locals, so
a new helper goes on `PlanTab`, not in a new `local function` (met on card `0034`). `selfTest`
holds 60 upvalues, so a new card's checks go in a `PlanTab.<name>Checks(check)` function called
from the end of `selfTest` (`loadoutChecks`, `barChecks`, `sidebarChecks`, `treeChecks`).

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
  scenario (`st` one target, `2t` two, `3t` three or more, `mplus` a dungeon fight style), and cells it was not given are kept, because a report
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
- **DjinnisDreamgrove merges into this addon, and builds are stored here but worn as Blizzard
  loadouts** (Rob, 2026-09-23). The builds live in one account-wide list so every druid gets the
  same ones; each character gets them as real loadouts through `ImportLoadout`; switching stays
  on `ClassTalentHelper`. Writing talent nodes from addon code is the frozen-action-bar route
  (`0002`), which is why TalentLoadoutsEx's way is out. Reasons in
  `docs/research/talent-loadout-addons.md`; the work is cards `0030` to `0035`.
- **The planned build is the plan cell's own `talents` string, never the saved loadout** (Rob,
  2026-09-22, Option A). Blizzard writes a hand edit into the saved loadout on Apply, so a
  compare against it can never see an edit. A cell without a `talents` string has no planned
  build and says nothing. Every scenario gets its own cell and string; see card `0028`.
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
**2026-09-22, traps from the sub-agent build (v0.20.0 to v0.25.0).**
- **Parallel builds conflict in three places only**: the tail of `selfTest` (every card appends its checks there), the loader's `PLAYER_LOGIN` arm list, and the Plan tab's boss rows in `PlanTab.lines`.
  All resolve by keeping both sides; a `do ... end` check block needs its own `end` when two land together. A review that lands after a builder branched from older code (0013 review vs 0017 build) needs a hand merge of the shared function, not both sides.
- **A Raidbots paste must be the whole `/simc` export, checksum line included.** Trimming the bag list flips the page to Unverified Input. Card 0018 appends its block after the checksum for the same reason.
- **The `st` cell was simmed on "DotC Raid ST *" but four `st` boss rows load "WS Raid Most Bosses" or "WS Raid Coiled Altar".** So the cell's talents string judges a row only when the loadout in play is the cell's own; other rows are judged by name and never say edited. Card `0028`'s sims close that gap.
- **The Feral Mythic+ cell is filled** (report `ttC3zNmZSvC7C2XQNSe6Bi`, DungeonSlice, loadout `WS M+`). Checks that need an empty cell take it away for the check and put it back; do not empty the block to test.
- **Not proven anywhere but offline**: every card merged today (0011 to 0028). Each lists its looks under `## What I need from you`; none has been seen in a client. `/bis test` in a client is itself a look: several blocks swap globals such as `InCombatLockdown` and restore them, which may taint the session until `/reload`.
- **One shared popup frame** (`DjinnisBiSPopup`, `PlanTab.popup`) serves 0013, 0017 and 0024. `PlanTab.hideSetup` takes down only 0013's own; a new card must not call `hidePopup` blind.
- The main chunk holds 177 top-level locals of Lua's 200. Add to `PlanTab`, never a local.

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
**`docs/board/` owns this.** Cards `0031` to `0034` are built (loadouts per character, the list's look, shared action bars, tree highlight). All four passed review and wait for a client. On `0033`, watch for a key prompt that returns every login while **Apply** does nothing (sixth review note). `0035`, retire DjinnisDreamgrove and DjinnisClassProfiles, stays in `todo/` until `0031` and `0033` pass in a client. Rob's own work: the Raidbots sims on card `0028` (one per spec per scenario, `3t` on a 3+ target loadout), then `.\update-gear-plan.ps1 <ids>` and a `BOSSES` row or two set to `3t`.

Forty-one cards in `human-review/` are one trip to a live client; each lists its own looks. Type `/reload` first: the game folder holds v0.39.1 (deployed 2026-09-23). **Refresh the builds** when Dreamgrove updates a guide: `python update-builds.py --check`, then without `--check`. Guardian and Resto have no boss rows until Rob says which raid build fits which boss.

## Blockers / open questions
- **Rob's sims for `0028`**: which loadout each spec uses at 3+ targets, and a Top Gear run per spec per scenario. Nothing else on the board is blocked.
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
- **2026-09-23, later** Four fresh reviewers bounced `0031` to `0034`; fixed at v0.33.0, one commit each.
  Worth carrying: Dreamgrove strings mark granted talents and a client export through SimC does
  not, so talent strings are compared node by node (`PlanTab.nodeKey`), never as text. A check that
  fakes an edit by changing the last character changes only padding. Character macros start at 121.
- **2026-09-23** Cards `0031` to `0034` built in one session, one commit each, v0.27.0 to v0.30.0.
  Worth carrying: `talentStringsDiffer` could not compare a Dreamgrove build at all (a zero-filled
  tree hash never matched the client's), so every drift and "edited" check on those rows was blind
  until `0031`; and the first bar check that failed was a real fault, two empty slots not counting
  as the same. Break one check on purpose after a first-try pass: it proves the checks ran.
- **2026-09-22, last** Seventeen cards built by sub-agents, each in its own git worktree (`.claude/worktrees/`), merged one branch at a time with both Lua checks after each merge, then reviewed the same way. `git log --format='%ad %s'` has the order.
  Worth carrying: resume a rate-limited agent with a message rather than relaunching, its worktree keeps the edits; a builder started before a review lands needs a hand merge.
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
