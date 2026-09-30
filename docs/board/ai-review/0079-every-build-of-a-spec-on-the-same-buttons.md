---
needs: 0033, 0036
---
# 0079 Every build of a spec on the same buttons

## Why
Rob, 2026-09-30: "need to do the work that I talked about before for normalising my bars ...
between builds of the same spec. There are a lot of abilities and things that I use on my dungeon
build, that get lost on other builds. I just spent the whole of the last fight pulling abilities to
my bars during combat."

His saved layouts (`DjinnisCPDB.bars`, read from a copy of his SavedVariables on 2026-09-30):
`Feral` (09-24), `Feral / Dungeon` (09-30), and four raid builds. Three raid builds (Lost Explorers,
Nek'Zali, Twin Fangs) still held the Feral bars from before he moved about 45 buttons from bars 4-5
to bar 7 (slots 157-168). Against the Dungeon layout they differed on 45 to 50 slots. The rest of
the differences were real talent swaps on the same button: Berserk for Incarnation, Feral Frenzy
for Frantic Frenzy, Lunar Inspiration's Moonfire, Tiger Dash for Dash.

Not card `0051`. That one makes another spec's bars from a druid template through Bellular's
categories. This one keeps the builds of ONE spec in step.

## What was built (v0.60.0)
- More > **Make every <spec> build use these bars** (`/dcp bars match`). It asks first, naming each
  build layout it changes. On Match: the bars and keys on screen become the spec layout and the
  selected build's layout, and every other saved build layout of the spec is rebuilt from them.
- `PlanTab.matchLayout(master, own)` is pure. A build keeps its own spell on a button only where
  both hold a spell and its spell is nowhere on master (a talent swap). A spell master has on
  another button follows master, so old positions go. Keys are master's. Answers the swaps kept and
  the build's spells no longer placed; chat prints both per build.
- More > **Put back the build bars** (`/dcp bars unmatch`), shown only on the spec matched: every
  layout the match replaced comes back, and one that did not exist is removed. It changes saved
  layouts only, never the bars on screen.
- Nothing moves on the bars until a layout is loaded, as before: switching build offers it, or Load
  bars: build.

Run on a copy of Rob's real layouts with Dungeon as master: the three old raid builds go from 45-50
different slots to 6-7, each one a talent swap. They lose Travel Form, Bear Form, Treant Form,
Mount Form and Hibernate, which the Dungeon bars do not hold anywhere. Chat lists them.

Checks: `PlanTab.barMatchChecks`, 22 lines. Ten mutations on temp copies (the swap rule, spell-only
swaps, key copy, slot copy, busy guard, stale guard, put back removing a new layout, put back on
another spec, the spec prefix, the ask) each made 1 to 14 checks fail. Lua 5.1: "no FAIL lines".
Lua 5.4 stops at line 14171 (`unpack`, from commit 417b207 on 2026-09-27); that predates this card.

## Uncertain
- The swap rule is a guess from the data. A build whose spell on a button is one master does not
  use, but which is drift and not a talent (an ability Rob dropped), is kept as a swap. Chat lists
  every kept swap, so Rob can see one.
- A build with a talent the spec layout does not place loses nothing it had; a build with NO saved
  layout still falls back to the spec layout and its talent-swap buttons may be empty. Not solved
  here.

## Acceptance
<!-- AC:BEGIN -->
- [x] #1 WHEN Rob clicks Match, EVERY saved build layout of the spec SHALL hold master's buttons, except its own talent swaps on the same button. proves: `PlanTab.barMatchChecks`
- [x] #2 WHEN Rob clicks Put back the build bars, EACH layout SHALL be as before the match. proves: `PlanTab.barMatchChecks`
- [x] #3 Another spec's layouts SHALL NOT change. proves: `PlanTab.barMatchChecks`
- [ ] #4 In a client: on Feral with the Dungeon loadout, Match, then switch to a raid build and load its bars. The abilities from the Dungeon bars are on the same buttons, with Berserk / Feral Frenzy etc. where that build talents them. proves: none
<!-- AC:END -->

## Comments

**2026-09-30, Rob.** "That's not really what I'm going for... more being able to compare and pick between them." Card `0080` is that. This one stays in: its Put back is shared with `0080`, and a whole-spec match is still one click.

**2026-09-30 22:30, after the heroic raid.** The "no saved layout" gap under Uncertain bit in use. Nymrissa, Entombed Sentinels and Vashnik have no build layout, so their builds loaded the 09-24 spec layout, which holds neither Berserk nor Feral Frenzy; the load cleared those buttons. Match was not run (the 09-23 raid layouts are unchanged). Full read of the saved layouts: SecondBrain `outputs/2026-09-30 Feral saved bars review`. A macro naming both spells of a talent choice would fill a swap button in every build.
