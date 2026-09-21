---
model: fable  # Rob, 2026-09-21: the gear plan cards go to Fable
---
# 0004 A gear plan from Raidbots, baked into the addon

## Why

Rob plays all four druid specs and the sims say what each should wear, but the answer lives in a
browser tab. On 2026-09-21 a Raidbots Top Gear run said Feral should wear the Season 2 Dreamwatcher
tier and Vestment of the Awakening; he was still in the Season 1 Luminous Bloom set at 289 an hour
later, with a ring showing "Enchant Missing". The gap between his current and best Feral setup was
about 36% in the sim, most of it talents and gear that sat in his bags.

What it costs: every raid night he gears from memory, and his heroic parses fell from a 50-60
best average in earlier expansions to 11 as Balance and 14 as Guardian in Season 2 (Warcraft Logs,
`C:\Users\r\OneDrive\Desktop\SecondBrain\outputs\2026-09-21 Raid DPS as Feral or Balance.md`).

How it came to be: AskMrRobot used to put this in the game and no longer works for Retail. Nothing
else Rob has turns a sim result into something the game can show.

This card is the data half only. Cards `0005`, `0006` and `0007` draw it.

## Links

- Blocks `0005`, `0006`, `0007`: all three read the table this card writes.
- Follows the pattern of `0002` and `0003`: author-time generated block, no network at runtime.

## Not this card

- No frame, glow, tab or tooltip. Only the data table, its generator and its offline checks.
- No running of sims. The generator reads finished Raidbots reports.
- No talent import. The plan names a loadout; it never applies one.
- No consumables.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the generator is given a Raidbots Top Gear report id, THE TOOL SHALL write the winning combo's item id, bonus ids, enchant id and gem ids for every slot into the `GENERATED GEAR PLAN` block of `DjinnisBiS.lua`. proves: `gear plan block holds a slot table per spec and scenario`
- [x] WHEN a slot line carries `enchant_id` or `gem_id`, THE ADDON SHALL expose them as numbers on that slot's plan entry. proves: `plan parses enchant and gem ids from a simc gear line`
- [x] WHEN a plan entry is asked whether an equipped item link matches it, THE ADDON SHALL compare item id and item level, not name. proves: `plan match compares item id and item level`
- [x] WHEN a ring or trinket pair is planned, THE ADDON SHALL match the pair in either order. proves: `paired slots match in either order`
- [x] WHEN the generator runs twice on the same reports, THE TOOL SHALL write nothing the second time. proves: `generator is idempotent`
- [x] WHEN the generator is given a full report URL instead of an id, THE TOOL SHALL accept it the same. proves: `generator accepts a report url or a bare id`
- [x] WHEN a report is not a Top Gear report, or its spec cannot be read, THE TOOL SHALL stop, name the report and write nothing. proves: `generator refuses a report it cannot place`
<!-- AC:END -->

## Tasks

- [x] Read the report format and write down which field holds the winning combo (see Plan).
- [x] Generator script `update-gear-plan.ps1` beside `update-classcodex-data.ps1`, same marker discipline.
- [x] Plan table: `spec` (Feral, Balance, Guardian, Restoration) by `scenario` (`st`, `2t`) by slot.
- [x] Per scenario, the loadout name to use and its export string.
- [x] Offline checks in `offline-check.lua` under the names above.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md` there first, then
`C:\Dev\WoWAddons\docs\DECISIONS.md`.

**Where the data comes from.** A Raidbots report is public JSON at
`https://www.raidbots.com/reports/<id>/data.json`, no login (checked 2026-09-21 on report
`ttktB9kVE77x2zkadhVgPn`, 420 KB). The DPS of each Top Gear combo is in `sim.profilesets.results`
(`name`, `mean`). The gear of a combo is in `simbot.input` as lines of the form
`profileset."Combo 142"+=head=,id=271528,enchant_id=7991,bonus_id=...`. **Open question to settle
first:** in that report the winning combo (`Combo 145`) had no `profileset` lines in `simbot.input`,
only 142 did. Either the winner equals the base profile (the lines above the profilesets) or Smart
Sim's staging keeps its lines somewhere else. Find out before writing the parser; do not guess.

**Which reports, and who runs it.** The 2026-09-21 session's reports are listed in the output file
named in `## Why`. **Both routes must work** (Rob, 2026-09-21): usually he asks a session to re-sim,
and the session runs this generator and deploys; sometimes he runs Top Gear himself and runs the
generator with no agent. So the generator is a command Rob can type: it takes one or more report
links or ids, says which spec and scenario each one fills, prints what changed slot by slot, and
deploys only when asked (`-Deploy`). Its usage goes in `docs/HANDOVER.md` under How to pick up.

**Shape.** Mirror `GENERATED TRINKET TIERS`: a Lua table between begin and end markers, a date stamp
shown in the UI, and a generator that refuses to write if the markers are missing. Key slots by the
simc slot names (`head`, `neck`, `shoulder`, `back`, `chest`, `wrist`, `hands`, `waist`, `legs`,
`feet`, `finger1`, `finger2`, `trinket1`, `trinket2`, `main_hand`, `off_hand`) and map them to
inventory slot ids in one place.

**Item level.** Bonus ids decide item level. Store the level Raidbots reports for the item if the
JSON carries it; if it does not, match on item id plus the bonus ids and say so on the card.

**Checks.** `lua offline-check.lua` must exit 0. It proves data and pure logic, no frame.

Deploy with `C:\Dev\WoWAddons\bin\deploy.ps1 -WhatIf -Only DjinnisBiS`, then without `-WhatIf`.

## Comments

- 2026-09-21 Claude: card written from Rob's ask in a SecondBrain session: "build in this advice to
  an addon that gives me the changes you are proposing in game (similar to AskMrRobot)", then
  "highlight / glow items to equip / change from bags / character frame", and "DjinnisBiS may be a
  better place for this". Nothing is built yet.
- **2026-09-21** Built, at v0.13.0, deployed. **The open question is settled, and the answer is a
  different file.** `simbot.input` in `data.json` is one chunk of the last Smart Sim stage, which is
  why it held Combo 142 and not the winner. Every combo is in
  `https://www.raidbots.com/reports/<id>/input.txt`, each gear line under a comment giving the
  item's name and item level, so the level is stored and the match is id plus level as asked. The
  form data also lists the gear but without the gems Top Gear adds (the winner's wrist gem is not
  in it), so it is not read. The base actor is Combo 1 and has no `profilesets.results` row; it is
  compared separately and can win.
- **2026-09-21** **Only one cell is filled: Feral `st`, from `ttktB9kVE77x2zkadhVgPn`.** The four
  reports named in the SecondBrain output are Advanced sims comparing talent builds, not Top Gear,
  and the generator refuses them by name, which is criterion 7 doing its job. Feral `2t` and both
  Balance cells need a Top Gear run each. Spec key is `Resto`, not `Restoration`, to match every
  other table in the addon.
- **2026-09-21** Where each `proves:` runs. The first four are `check` labels in `/bis test`, run by
  `lua offline-check.lua`; the first is also asserted on the generator's output. The last three, and
  the first again, are `.\update-gear-plan.ps1 -SelfTest`, against trimmed copies of two real
  reports in `fixtures/gear-plan/`. Both exit 0. A mutation that made the match ignore item level
  turned `plan match compares item id and item level` red, so that check bites. The self-test also
  caught a real fault on its first run: indexing an `[ordered]` table with an int is by position, so
  one enemy was filed as `2t`. **Nothing here has been in a game client, and nothing in it draws.**
- **2026-09-21** **The code for this card is in commit `5e208a0`, whose message is about card 0006.
  That is not a mistake in the code.** Two sessions built this card at once, one here and one
  unattended on the other PC, because Syncthing replicates `C:\Dev` with its `.git` folders. This
  session's files synced across and a `git add` there swept them into that commit. The other build
  was on branch `card/0004` (`ca83a6a`, now deleted; Rob chose this one). It was set aside for three
  reasons: its pair match indexed a nil and threw on a bare ring finger, it wrote the report's text
  into the Lua file unfiltered, and it fetched a report per Smart Sim chunk where one `input.txt`
  holds every combo. **Two things of its were better and are worth taking when card 0007 draws the
  plan:** a slot list in paper-doll order, and a `levelOf` argument on the link match so it can be
  tested without a client. This card still wants its adversarial pass.
