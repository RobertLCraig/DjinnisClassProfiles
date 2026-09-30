# Rob's druid bars by job (Bellular's categories), 2026-09-30

Card `0082`. Rob, 2026-09-30: "Want to normalize my bars across all specs and builds (especially
abilities that are not unique to each build) ... analyse what abilities and importantly, types of
abilities I have where, (potentially fill in the bellular spreadsheet for me, updating the keybinds
to match my druid too) that way we can expand it to work for all classes too later."

## What was read
- **The bars and keys:** `DjinnisCPDB.bars` from the account SavedVariables, written 2026-09-30
  23:16. Layouts: Feral (09-24), Feral / Dungeon (09-30), five Feral raid builds, Guardian and
  Guardian / Dungeon (09-30), Balance (09-30), Resto (09-30), Destruction (09-24).
- **Spell names:** wago.tools `SpellName` (live). Items from Wowhead's tooltip API: 245898 Fleeting
  Light's Potential (damage potion), 258138 Potent Healing Potion, 5512 Healthstone.
- **Bellular:** `SecondBrain\raw\processed\Midnight Keybind Planner (Oldschool Edition).xlsx`
  (downloaded 2026-09-24), sheets `ENTER YOUR BINDS HERE` and `Druid`. Summary:
  SecondBrain `wiki/summaries/Bellular Keybinding System (Clippings).md`.
- **Which slots are which bar:** `wow-ui-source` `Blizzard_ActionBar/Shared/MultiActionBars.lua`
  (pages 3 to 6 and 13 to 15). Druid form pages (Cat 73-84, Prowl 85-96, Bear 97-108, Moonkin
  109-120) from Dominos and Bartender, as card `0051` found.
- **Rob's own use (2026-09-30):** abilities on bars 1, 4 and 7; utilities, professions, toys and
  mounts on bars 5 and 8. Forms are on OPie rings, not the bars.

Scripts: `docs/research/bars-analysis/` (`dumpall.lua` then `bars_analyse.py`, then the three
report scripts). They read a copy of the SavedVariables in `%TEMP%`, never the game folder.

## Findings
1. **The keys are the same in every spec.** All four druid specs and Destruction hold one identical
   set of 180 bindings; only the old raid layouts (09-23, 09-27) differ. Keys belong to buttons, so
   normalising means putting the same job on the same button.
2. **Feral is the developed layout; the others follow a different plan.** Balance and Resto put
   Sunfire on 1, Moonfire on 2, Wrath on 3. Feral puts Rake on 1, Shred on 2, Swipe on 3. Guardian
   has its defensives on the number row (Barkskin 5, Survival Instincts Alt+1) where Feral has its
   finishers.
3. **Every shared spell but three sits on a different key somewhere.** Only Heart of the Wild (Z),
   Stampeding Roar (Shift+V), Rebirth (Alt+D), Dash (V) and the Innervate macro (X) agree in every
   spec on the active bars. Soothe is Shift+R on Feral and Guardian, Alt+4 on Balance and Resto.
   Entangling Roots is Alt+F on Feral, Alt+A elsewhere, and Alt+A is the damage potion on Feral and
   Balance. Resto has Incapacitating Roar on Shift+E, which is Skull Bash (the interrupt) on Feral
   and Guardian.
4. **Each spec has its own copy of every form page.** The cat page a Balance druid gets on shifting
   is not the Feral cat page (Rake 1, Bite 2, Shred T). The same holds for bear and moonkin. So
   normalising covers the form pages too: every spec's Cat page could be Feral's, its Bear page
   Guardian's, its Moonkin page Balance's.
5. **Rob's keys against Bellular's:** they agree only on the jobs that have no Bellular key clash.
   Rob's rotation sits on 1 to 5, T and Alt+1 to 4; Bellular's on 1 to 4, Q, E, R, F and Shift+1 to
   4. Rob's movement is on V (Bellular: X) and his interrupt on Shift+E (Bellular: V). Neither is
   wrong; the point of the system is only that each job keeps its key across specs.

## The filled planner
`docs/research/Midnight Keybind Planner (Rob's druid keys).xlsx` is a copy with Rob's key for 29
jobs in `ENTER YOUR BINDS HERE` column B, read off Feral / Dungeon. Every class sheet reads that
column by formula, so every class page shows his keys (Excel recalculates on open). Written by XML
surgery on that one sheet (`bell_fill.py`); the original is untouched. Jobs Rob has no key for keep
Bellular's. Not mapped, because no Bellular job fits: Recuperate (C), Incapacitating Roar
(Shift+W), Ursol's Vortex (Alt+R), Thorn Bloom (Shift+A), Potent Healing Potion (Shift+2).

## Proposal: Feral as the model

Each job's key on Feral, then what would move in each other spec. Bellular names the ability for each job. A macro (Druid - Mangle, Druid - Fur, Druid - CA/Trink) is not matched to a job, so a spec can read "not on the bars" when a macro holds it.

### Your key for each job, read off your Feral bars

| Job | Bellular's key | Your key (Feral) | Feral ability |
|---|---|---|---|
| Combat 1 | 1 | **2** | Shred |
| Combat 2 | 2 | **1** | Rake |
| Combat 3 | 3 | **Alt+3** | Rip |
| Combat 4 | 4 | **Alt+1** | Ferocious Bite |
| Combat 5 | Q | **5** | Tiger's Fury |
| Combat 6 | E | **Shift+Q** | Frantic Frenzy |
| Combat 7 | R | **3** | Swipe |
| Combat 8 | F | **Alt+4** | Primal Wrath |
| Combat 9 | S1 | **Alt+S** | Berserk |
| Combat 10 | S2 | **Alt+2** | Convoke the Spirits |
| Class 1 (Movement) | SQ | **Shift+V** | Stampeding Roar |
| Class 3 (Tag) | SR | **Alt+F** | Entangling Roots |
| Self-Heal 1 | C1 | **Shift+1** | Regrowth |
| Self-Heal 4 (Emergency/Overflow) | C4 | **Z** | Heart of the Wild |
| Class 5 (Purge) | CQ | **Shift+R** | Soothe |
| Class 8 (Lust/BRes) | CF | **Alt+D** | Rebirth |
| Personal Defensive 1 | Z | **Alt+W** | Barkskin |
| Personal Defensive 2 | SZ | **Alt+Q** | Survival Instincts |
| Movement Ability | X | **V** | Dash |
| CC 2 | SC | **Shift+D** | Typhoon |
| Interrupt | V | **Shift+E** | Skull Bash |
| Immune/Spell Immune/Movement | CC | **Alt+E** | Wild Charge |
| Taunt/Quick Access | CV | **Shift+3** | Prowl |

### Guardian: what would move to match Feral

| Job | Guardian ability (Bellular) | Now on | Would go to |
|---|---|---|---|
| Combat 1 | Mangle | not on bars 1/4/7 (Bar 1 (Cat)) | **2** |
| Combat 2 | Thrash | 4 | **1** - now holds macro: Druid - Mangle |
| Combat 3 | Maul | not on the bars | **Alt+3** - now holds Lunar Beam |
| Combat 4 | Frenzied Regeneration | Alt+Q | **Alt+1** - now holds Survival Instincts |
| Combat 5 | Ironfur | not on bars 1/4/7 (Bottom left (bar 2)) | **5** - now holds Barkskin |
| Combat 6 | Moonfire | not on bars 1/4/7 (Bar 1) | **Shift+Q** |
| Combat 7 | Swipe | 3 | ✓ same |
| Combat 8 | Lunar Beam | Alt+3 | **Alt+4** - now holds Ursol's Vortex |
| Combat 9 | Berserk | Alt+S | ✓ same |
| Combat 10 | Convoke the Spirits | not on the bars | **Alt+2** |
| Class 1 (Movement) | Stampeding Roar | Shift+V | ✓ same |
| Class 3 (Tag) | Entangling Roots | Alt+A | **Alt+F** |
| Self-Heal 1 | Regrowth | Shift+1 | ✓ same |
| Self-Heal 4 (Emergency/Overflow) | Heart of the Wild | Z | ✓ same |
| Class 5 (Purge) | Soothe | Shift+R | ✓ same |
| Class 8 (Lust/BRes) | Rebirth | Alt+D | ✓ same |
| Personal Defensive 1 | Barkskin | 5 | **Alt+W** - now holds macro: Druid - Fur |
| Personal Defensive 2 | Survival Instincts | Alt+1 | **Alt+Q** - now holds Frenzied Regeneration |
| Movement Ability | Dash | V | ✓ same |
| CC 2 | Typhoon | not on bars 1/4/7 (Bottom right (bar 3)) | **Shift+D** |
| Interrupt | Skull Bash | Shift+E | ✓ same |
| Immune/Spell Immune/Movement | Wild Charge | Alt+E | ✓ same |
| Taunt/Quick Access | Growl | not on bars 1/4/7 (page 2) | **Shift+3** - now holds Prowl |

### Balance: what would move to match Feral

| Job | Balance ability (Bellular) | Now on | Would go to |
|---|---|---|---|
| Combat 1 | Wrath | 3 | **2** - now holds Moonfire |
| Combat 2 | Starfire | not on the bars | **1** - now holds Sunfire |
| Combat 3 | Moonfire | 2 | **Alt+3** - now holds Solar Beam |
| Combat 4 | Sunfire | 1, 4 | **Alt+1** - now holds Thorn Bloom |
| Combat 5 | Starsurge | not on bars 1/4/7 (Bar 1) | **5** - now holds Fury of Elune |
| Combat 6 | Starfall | not on bars 1/4/7 (page 2) | **Shift+Q** - now holds Lunar Eclipse |
| Combat 7 | Lunar Eclipse | Shift+Q | **3** - now holds Wrath |
| Combat 8 | Fury of Elune | 5 | **Alt+4** - now holds Soothe |
| Combat 9 | Celestial Alignment | not on the bars | **Alt+S** - now holds macro: Druid - CA/Trink |
| Combat 10 | Convoke the Spirits | not on bars 1/4/7 (page 2) | **Alt+2** - now holds Incapacitating Roar |
| Class 1 (Movement) | Stampeding Roar | Shift+V | ✓ same |
| Class 3 (Tag) | Entangling Roots | not on bars 1/4/7 (Bottom right (bar 3)) | **Alt+F** |
| Self-Heal 1 | Regrowth | not on bars 1/4/7 (Bottom right (bar 3)) | **Shift+1** |
| Self-Heal 4 (Emergency/Overflow) | Heart of the Wild | Z | ✓ same |
| Class 5 (Purge) | Soothe | Alt+4 | **Shift+R** |
| Class 8 (Lust/BRes) | Rebirth | Alt+D | ✓ same |
| Personal Defensive 1 | Barkskin | not on bars 1/4/7 (page 2) | **Alt+W** |
| Personal Defensive 2 | - (no Balance ability) | not on the bars | leave Alt+Q free |
| Movement Ability | Dash | V | ✓ same |
| CC 2 | Typhoon | not on bars 1/4/7 (page 2) | **Shift+D** |
| Interrupt | Solar Beam | Alt+3 | **Shift+E** |
| Immune/Spell Immune/Movement | Wild Charge | Alt+E | ✓ same |
| Taunt/Quick Access | Prowl | not on bars 1/4/7 (Bar 1 (Prowl)) | **Shift+3** |

### Resto: what would move to match Feral

| Job | Resto ability (Bellular) | Now on | Would go to |
|---|---|---|---|
| Combat 1 | Wrath | 3 | **2** - now holds Moonfire |
| Combat 2 | Starfire | not on the bars | **1** - now holds Sunfire |
| Combat 3 | Moonfire | 2 | **Alt+3** - now holds Tranquility |
| Combat 4 | Sunfire | 1 | **Alt+1** |
| Combat 5 | Rejuvenation | not on the bars | **5** - now holds Cat Form |
| Combat 6 | Regrowth | not on bars 1/4/7 (Bottom right (bar 3)) | **Shift+Q** |
| Combat 7 | Lifebloom | not on the bars | **3** - now holds Wrath |
| Combat 8 | Swiftmend | not on the bars | **Alt+4** - now holds Soothe |
| Combat 9 | Tranquility | Alt+3 | **Alt+S** |
| Combat 10 | Incarnation: Tree Of Life | Alt+2 | ✓ same |
| Class 1 (Movement) | Stampeding Roar | Shift+V | ✓ same |
| Class 3 (Tag) | Entangling Roots | Alt+A | **Alt+F** - now holds Revitalize |
| Self-Heal 1 | Nature's Swiftness | Alt+Q | **Shift+1** - now holds macro: EnhanceQoLHealthMacro |
| Self-Heal 4 (Emergency/Overflow) | Heart of the Wild | Z | ✓ same |
| Class 5 (Purge) | Soothe | Alt+4 | **Shift+R** |
| Class 8 (Lust/BRes) | Rebirth | Alt+D | ✓ same |
| Personal Defensive 1 | Barkskin | not on bars 1/4/7 (page 2) | **Alt+W** |
| Personal Defensive 2 | - (no Resto ability) | not on the bars | leave Alt+Q free - now holds Nature's Swiftness |
| Movement Ability | Dash | V | ✓ same |
| CC 2 | Typhoon | not on bars 1/4/7 (Bottom right (bar 3)) | **Shift+D** |
| Interrupt | - (no Resto ability) | not on the bars | leave Shift+E free - now holds Incapacitating Roar |
| Immune/Spell Immune/Movement | Wild Charge | not on bars 1/4/7 (Bottom left (bar 2)) | **Alt+E** |
| Taunt/Quick Access | Prowl | not on the bars | **Shift+3** |

## Shared spells: the key in each spec

Every spell or item on the bars of two or more specs. A plain key is on the spec's active bars (its fighting page, bar 4 or bar 7). "Cat bar (1)" means that spec's own cat page. Sorted with the ones that disagree first.

| Spell or item | Feral | Guardian | Balance | Resto | Same key? |
|---|---|---|---|---|---|
| Barkskin | page 2 (no key), Alt+W | 5 | page 2 (no key), Bottom left (bar 2) (no key) | page 2 (no key), Bottom left (bar 2) (no key) | **no** |
| Carve Meat | Right bar 2 (bar 5) (NUMPAD4) | Right bar 2 (bar 5) (no key) | Right bar 2 (bar 5) (no key), Bar 8 (NUMPAD8) | Right bar 2 (bar 5) (no key) | **no** |
| Cat Form | Bar 1 bar (5) | - | - | 5 | **no** |
| Convoke the Spirits | page 2 (no key), Alt+2 | - | page 2 (no key), Bottom left (bar 2) (no key) | Alt+2, page 2 (no key), Bottom left (bar 2) (no key) | **no** |
| Dash | V | V, Prowl bar (1) | V, Prowl bar (1) | V, Prowl bar (2) | **no** |
| Entangling Roots | Alt+F | Alt+A, Prowl bar (Alt+1) | Bottom right (bar 3) (no key) | Alt+A | **no** |
| Ferocious Bite | page 2 (no key), Alt+1 | Cat bar (4) | Cat bar (2) | Cat bar (Alt+1) | **no** |
| Frenzied Regeneration | Bear bar (Shift+Q) | page 2 (no key), Alt+Q | Bottom left (bar 2) (no key), Bear bar (3) | Bear bar (1), Bear bar (Shift+Q) | **no** |
| Growl | Bear bar (2) | page 2 (no key) | Bear bar (Alt+2) | Bear bar (2) | **no** |
| Healthstone | Shift+S | Bottom right (bar 3) (no key) | Bottom right (bar 3) (no key) | Bottom right (bar 3) (no key) | **no** |
| Heart of the Wild | Z | Bar 1 bar (Alt+1), Z | Z | Z, Moonkin bar (Alt+1) | **no** |
| Incapacitating Roar | Shift+W | Bar 1 bar (Alt+2), Shift+W | Bar 1 bar (Alt+2), Bear bar (Alt+1), Alt+2 | Shift+E, Bear bar (Alt+1), Moonkin bar (Alt+2) | **no** |
| Innervate | Bar 1 bar (Alt+2) | Bar 1 bar (1) | Bottom left (bar 2) (no key) | X | **no** |
| Ironfur | - | Bottom left (bar 2) (no key) | Bear bar (T) | Bear bar (5) | **no** |
| Moonfire | Bar 1 bar (2), Bar 1 bar (Alt+3) | Bar 1 bar (2), Moonkin bar (2) | 2 | 2, Moonkin bar (2) | **no** |
| Potent Healing Potion | Shift+2 | Bottom right (bar 3) (no key) | Bottom right (bar 3) (no key) | Bottom right (bar 3) (no key) | **no** |
| Prowl | Prowl bar (Shift+E), Shift+3 | Bottom right (bar 3) (no key), Prowl bar (Shift+E), Shift+3 | Cat bar (Alt+4), Prowl bar (Shift+E) | Prowl bar (Shift+E) | **no** |
| Rake | 1 | Cat bar (1) | Cat bar (1) | Prowl bar (1) | **no** |
| Rebirth | Alt+D | Alt+D, Right bar 2 (bar 5) (NUMPAD3) | Alt+D | Alt+D | **no** |
| Recuperate | C | C | C, Bottom right (bar 3) (Shift+4) | C | **no** |
| Regrowth | Bar 1 bar (4), Shift+1 | Bottom right (bar 3) (no key), Shift+1 | Bottom right (bar 3) (no key) | Bottom right (bar 3) (no key) | **no** |
| Revive | - | page 2 (no key), Alt+G | Alt+G | Alt+G | **no** |
| Rip | page 2 (no key), Alt+3 | Cat bar (Alt+1) | Cat bar (Alt+3) | Cat bar (5) | **no** |
| Sharpen Your Knife | Right bar 2 (bar 5) (NUMPAD3) | Right bar 2 (bar 5) (no key) | Right bar 2 (bar 5) (no key) | Right bar 2 (bar 5) (no key) | **no** |
| Shred | 2 | Cat bar (2) | Cat bar (T) | - | **no** |
| Skull Bash | Bar 1 bar (Shift+E), Shift+E, Bear bar (Alt+2) | Shift+E, Moonkin bar (Alt+2) | - | Cat bar (Alt+2), Bear bar (Alt+2), Moonkin bar (Alt+3) | **no** |
| Soothe | Shift+R | Bar 1 bar (Alt+4), Moonkin bar (Alt+3), Shift+R | Bar 1 bar (Alt+4), Bear bar (Alt+3), Alt+4 | Alt+4, Cat bar (Alt+3), Moonkin bar (Alt+4) | **no** |
| Stampeding Roar | Shift+V | Shift+V, Prowl bar (2) | page 2 (no key), Shift+V, Prowl bar (2), Bear bar (Shift+Q) | Shift+V, Prowl bar (3) | **no** |
| Starfire | Bar 1 bar (Shift+Q) | Bar 1 bar (4) | Bar 1 bar (4) | Moonkin bar (4) | **no** |
| Starsurge | - | - | Bar 1 bar (T), page 2 (no key), Bottom left (bar 2) (no key) | Moonkin bar (5) | **no** |
| Sunfire | Bar 1 bar (1), Moonkin bar (1), Moonkin bar (2) | Bar 1 bar (Alt+3), Moonkin bar (1) | 1, 4 | 1, Moonkin bar (1) | **no** |
| Survival Instincts | Alt+Q | page 2 (no key), Alt+1 | - | - | **no** |
| Swipe | 3 | 3 | Cat bar (3) | - | **no** |
| Thorn Bloom | Shift+A | Shift+A | Alt+1 | Bottom right (bar 3) (no key) | **no** |
| Typhoon | Shift+D, Prowl bar (T) | Bottom right (bar 3) (no key) | page 2 (no key), Bottom right (bar 3) (no key), Prowl bar (T) | Bottom right (bar 3) (no key) | **no** |
| Ursol's Vortex | Alt+R | Alt+4 | Bar 1 bar (Shift+Q), Bottom left (bar 2) (no key), Alt+R | page 2 (no key), Bottom left (bar 2) (no key) | **no** |
| Wild Charge | page 2 (no key), Alt+E | page 2 (no key), Bottom left (bar 2) (no key), Alt+E | Alt+E | Bottom left (bar 2) (no key) | **no** |
| Wrath | Bar 1 bar (3) | Bar 1 bar (3), Moonkin bar (3) | Bar 1 bar (3), 3 | 3, Moonkin bar (3) | **no** |
| companion 264058 | Bar 8 (NUMPADDECIMAL, Shift+\) | - | Bar 8 (no key) | Bar 8 (no key) | **no** |
| item 134020 | Bar 8 (no key) | Bar 8 (NUMPAD0) | - | Bar 8 (no key) | **no** |
| item 156833 | Bar 8 (no key) | Bar 8 (no key) | - | Bar 8 (NUMPAD0) | **no** |
| macro: 0 - OneButton | Prowl bar (1), Prowl bar (2), Prowl bar (3), Prowl bar (4), Bear bar (1), Bear bar (3), Bear bar (4) | Cat bar (3) | - | 4, Cat bar (1), Cat bar (2), Cat bar (3), Cat bar (4) | **no** |
| macro: Druid - Moonfire | T, Alt+T | Bar 1 bar (T), Cat bar (T), T | Bar 1 bar (2) | - | **no** |
| summonpet BattlePet-0-00000928664F | Bar 8 (NUMPAD8) | Bar 8 (NUMPAD9) | Bar 8 (no key) | Bar 8 (no key) | **no** |
| summonpet BattlePet-0-0000109502EE | - | Bar 8 (NUMPAD7) | Right bar 2 (bar 5) (no key) | - | **no** |
| Find High-Value Beasts | Right bar 2 (bar 5) (NUMPAD2) | Right bar 2 (bar 5) (NUMPAD2) | - | - | yes |
| Fleeting Light's Potential (damage potion) | Alt+A | - | Alt+A | - | yes |
| Mark of the Wild | Right bar 2 (bar 5) (NUMPAD1) | Right bar 2 (bar 5) (NUMPAD1) | Right bar 2 (bar 5) (NUMPAD1) | Right bar 2 (bar 5) (NUMPAD1) | yes |
| Remove Corruption | - | Bottom right (bar 3) (no key) | Bottom right (bar 3) (no key) | - | yes |
| Switch Flight Style | Bar 8 (NUMPAD0) | - | Bar 8 (NUMPAD0) | - | yes |
| item 6948 | Moonkin bar (Shift+E) | Moonkin bar (Shift+E) | - | - | yes |
| item 85500 | - | Bar 8 (NUMPADDECIMAL, Shift+\) | - | Bar 8 (NUMPADDECIMAL, Shift+\) | yes |
| macro: Druid - Innervat | X | X | X | - | yes |
| macro: Druid -ProwlMeld | - | - | Bottom right (bar 3) (no key) | Bottom right (bar 3) (no key) | yes |
| macro: TSMMacro | - | Bar 8 (\) | Bar 8 (\) | Bar 8 (\) | yes |
| summonpet BattlePet-0-00000F7A34C9 | Bar 8 (NUMPAD9) | - | Bar 8 (NUMPAD9) | - | yes |

## Every ability button, by spec



| Button | Key | Feral (Dungeon) | Guardian | Balance | Resto |
|---|---|---|---|---|---|
| Bar 1 #1 | 1 | Rake *(Combat 2)* | macro: Druid - Mangle | Sunfire *(Combat 4)* | Sunfire *(Combat 4)* |
| Bar 1 #2 | 2 | Shred *(Combat 1)* | · | Moonfire *(Combat 3)* | Moonfire *(Combat 3)* |
| Bar 1 #3 | 3 | Swipe *(Combat 7)* | Swipe *(Combat 7)* | Wrath *(Combat 1)* | Wrath *(Combat 1)* |
| Bar 1 #4 | 4 | · | Thrash *(Combat 2)* | Sunfire *(Combat 4)* | macro: 0 - OneButton |
| Bar 1 #5 | 5 | Tiger's Fury *(Combat 5)* | Barkskin *(Personal Defensive 1)* | Fury of Elune *(Combat 8)* | Cat Form *(Stance 2)* |
| Bar 1 #6 | T | macro: Druid - Moonfire | macro: Druid - Moonfire | · | · |
| Bar 1 #7 | Alt+1 | Ferocious Bite *(Combat 4)* | Survival Instincts *(Personal Defensive 2)* | Thorn Bloom | · |
| Bar 1 #8 | Alt+2 | Convoke the Spirits *(Combat 10)* | · | Incapacitating Roar | Convoke the Spirits *(Combat 10)* |
| Bar 1 #9 | Alt+3 | Rip *(Combat 3)* | Lunar Beam *(Combat 8)* | Solar Beam *(Interrupt)* | Tranquility *(Combat 9)* |
| Bar 1 #10 | Alt+4 | Primal Wrath *(Combat 8)* | Ursol's Vortex | Soothe *(Class 5 (Purge))* | Soothe *(Class 5 (Purge))* |
| Bar 1 #11 | Shift+Q | Frantic Frenzy *(Combat 6)* | · | Lunar Eclipse *(Combat 7)* | · |
| Bar 1 #12 | Shift+E | Skull Bash *(Interrupt)* | Skull Bash *(Interrupt)* | · | Incapacitating Roar |
| Bar 4 #1 | Z | Heart of the Wild *(Self-Heal 4 (Emergency/Overflow))* | Heart of the Wild *(Self-Heal 4 (Emergency/Overflow))* | Heart of the Wild *(Self-Heal 4 (Emergency/Overflow))* | Heart of the Wild *(Self-Heal 4 (Emergency/Overflow))* |
| Bar 4 #2 | X | macro: Druid - Innervat | macro: Druid - Innervat | macro: Druid - Innervat | Innervate *(Self-Heal 3 (Overflow))* |
| Bar 4 #3 | C | Recuperate | Recuperate | Recuperate | Recuperate |
| Bar 4 #5 | Shift+D | Typhoon *(CC 2)* | · | · | · |
| Bar 4 #6 | Shift+V | Stampeding Roar *(Class 1 (Movement))* | Stampeding Roar *(Class 1 (Movement))* | Stampeding Roar *(Class 1 (Movement))* | Stampeding Roar *(Class 1 (Movement))* |
| Bar 4 #7 | Alt+A | Fleeting Light's Potential | Entangling Roots *(Class 3 (Tag))* | Fleeting Light's Potential | Entangling Roots *(Class 3 (Tag))* |
| Bar 4 #8 | Alt+S | Berserk *(Combat 9)* | Incarnation: Guardian of Ursoc *(Combat 9)* | macro: Druid - CA/Trink | · |
| Bar 4 #9 | Alt+D | Rebirth *(Class 8 (Lust/BRes))* | Rebirth *(Class 8 (Lust/BRes))* | Rebirth *(Class 8 (Lust/BRes))* | Rebirth *(Class 8 (Lust/BRes))* |
| Bar 4 #10 | Alt+F | Entangling Roots *(Class 3 (Tag))* | · | · | Revitalize |
| Bar 4 #11 | Alt+G | macro: Druid - SmartRez | Revive *(Res)* | Revive *(Res)* | Revive *(Res)* |
| Bar 4 #12 | V | Dash *(Movement Ability)* | Dash *(Movement Ability)* | Dash *(Movement Ability)* | Dash *(Movement Ability)* |
| Bar 7 #1 | Alt+Q | Survival Instincts *(Personal Defensive 2)* | Frenzied Regeneration *(Combat 4)* | · | Nature's Swiftness *(Self-Heal 1)* |
| Bar 7 #2 | Alt+W | Barkskin *(Personal Defensive 1)* | macro: Druid - Fur | · | · |
| Bar 7 #3 | Alt+E | Wild Charge *(Immune/Spell Immune/Movement)* | Wild Charge *(Immune/Spell Immune/Movement)* | Wild Charge *(Immune/Spell Immune/Movement)* | · |
| Bar 7 #4 | Alt+R | Ursol's Vortex | · | Ursol's Vortex | · |
| Bar 7 #5 | Alt+T | macro: Druid - Moonfire | · | · | · |
| Bar 7 #6 | Shift+S | Healthstone | · | · | macro: 2- InviteAllOfMe |
| Bar 7 #7 | Shift+1 | Regrowth *(Self-Heal 1)* | Regrowth *(Self-Heal 1)* | · | macro: EnhanceQoLHealthMacro |
| Bar 7 #8 | Shift+W | Incapacitating Roar | Incapacitating Roar | · | · |
| Bar 7 #9 | Shift+3 | Prowl *(Taunt/Quick Access)* | Prowl *(Class 7 (Raid Defensive))* | · | · |
| Bar 7 #10 | Shift+R | Soothe *(Class 5 (Purge))* | Soothe *(Class 5 (Purge))* | · | · |
| Bar 7 #11 | Shift+A | Thorn Bloom | Thorn Bloom | · | · |
| Bar 7 #12 | Shift+2 | Potent Healing Potion | · | · | · |

## Each Bellular job: where it sits now

A job in brackets is on the layout but not on bars 1, 4 or 7.

| Job | Bellular key | Feral | Guardian | Balance | Resto | Same button? |
|---|---|---|---|---|---|---|
| Combat 1 | 1 | Bar 1 #2 [2] | (Bar 1) | Bar 1 #3 [3] | Bar 1 #3 [3] | no |
| Combat 2 | 2 | Bar 1 #1 [1] | Bar 1 #4 [4] | (Bar 1) | (Bar 1 (Prowl)) | no |
| Combat 3 | 3 | Bar 1 #9 [Alt+3] | (Bar 1 (Cat)) | Bar 1 #2 [2] | Bar 1 #2 [2] | no |
| Combat 4 | 4 | Bar 1 #7 [Alt+1] | Bar 7 #1 [Alt+Q] | Bar 1 #1 [1], Bar 1 #4 [4] | Bar 1 #1 [1] | no |
| Combat 5 | Q | Bar 1 #5 [5] | (Bottom left (bar 2)) | (Bar 1) | (Bar 1 (Bear)) | no |
| Combat 6 | E | Bar 1 #11 [Shift+Q] | (Bar 1) | (page 2) | (Bottom right (bar 3)) | no |
| Combat 7 | R | Bar 1 #3 [3] | Bar 1 #3 [3] | Bar 1 #11 [Shift+Q] | - | no |
| Combat 8 | F | Bar 1 #10 [Alt+4] | Bar 1 #9 [Alt+3] | Bar 1 #5 [5] | - | no |
| Combat 9 | S1 | Bar 4 #8 [Alt+S] | Bar 4 #8 [Alt+S] | - | Bar 1 #9 [Alt+3] | no |
| Combat 10 | S2 | Bar 1 #8 [Alt+2] | - | (page 2) | Bar 1 #8 [Alt+2] | no |
| Combat 11 | S3 | (Bar 1) | - | - | (Bottom left (bar 2)) | no |
| Combat 12 | S4 | (page 2) | - | - | (page 2) | no |
| Class 1 (Movement) | SQ | Bar 4 #6 [Shift+V] | Bar 4 #6 [Shift+V] | Bar 4 #6 [Shift+V] | Bar 4 #6 [Shift+V] | yes |
| Class 3 (Tag) | SR | Bar 4 #10 [Alt+F] | Bar 4 #7 [Alt+A] | (Bottom right (bar 3)) | Bar 4 #7 [Alt+A] | no |
| Class 4 (Special) | SF | - | - | (Bottom left (bar 2)) | - | no |
| Self-Heal 1 | C1 | Bar 7 #7 [Shift+1] | Bar 7 #7 [Shift+1] | (Bottom right (bar 3)) | Bar 7 #1 [Alt+Q] | no |
| Self-Heal 2 | C2 | (Bar 1 (Bear)) | - | (Bottom left (bar 2)) | (Bar 1 (Bear)) | no |
| Self-Heal 3 (Overflow) | C3 | (Bar 1) | (Bar 1) | (Bottom left (bar 2)) | Bar 4 #2 [X] | no |
| Self-Heal 4 (Emergency/Overflow) | C4 | Bar 4 #1 [Z] | Bar 4 #1 [Z] | Bar 4 #1 [Z] | Bar 4 #1 [Z] | yes |
| Class 5 (Purge) | CQ | Bar 7 #10 [Shift+R] | Bar 7 #10 [Shift+R] | Bar 1 #10 [Alt+4] | Bar 1 #10 [Alt+4] | no |
| Class 6 (Dispel) | CE | - | (Bottom right (bar 3)) | (Bottom right (bar 3)) | (Bottom right (bar 3)) | no |
| Class 7 (Raid Defensive) | CR | - | Bar 7 #9 [Shift+3] | - | - | no |
| Class 8 (Lust/BRes) | CF | Bar 4 #9 [Alt+D] | Bar 4 #9 [Alt+D] | Bar 4 #9 [Alt+D] | Bar 4 #9 [Alt+D] | yes |
| Personal Defensive 1 | Z | Bar 7 #2 [Alt+W] | Bar 1 #5 [5] | (page 2) | (page 2) | no |
| Personal Defensive 2 | SZ | Bar 7 #1 [Alt+Q] | Bar 1 #7 [Alt+1] | - | - | no |
| Movement Ability | X | Bar 4 #12 [V] | Bar 4 #12 [V] | Bar 4 #12 [V] | Bar 4 #12 [V] | yes |
| CC | C | (Bar 1) | - | - | - | no |
| CC 2 | SC | Bar 4 #5 [Shift+D] | (Bottom right (bar 3)) | (page 2) | (Bottom right (bar 3)) | no |
| Interrupt | V | Bar 1 #12 [Shift+E] | Bar 1 #12 [Shift+E] | Bar 1 #9 [Alt+3] | (Bar 1 (Cat)) | no |
| Buff | CZ | (Right bar 2 (bar 5)) | (Right bar 2 (bar 5)) | (Right bar 2 (bar 5)) | (Right bar 2 (bar 5)) | no |
| Res | CX | - | Bar 4 #11 [Alt+G] | Bar 4 #11 [Alt+G] | Bar 4 #11 [Alt+G] | no |
| Immune/Spell Immune/Movement | CC | Bar 7 #3 [Alt+E] | Bar 7 #3 [Alt+E] | Bar 7 #3 [Alt+E] | (Bottom left (bar 2)) | no |
| Taunt/Quick Access | CV | Bar 7 #9 [Shift+3] | (page 2) | (Bar 1 (Cat)) | (Bar 1 (Prowl)) | no |
| PvP 3 | AC | - | - | - | (Bottom right (bar 3)) | no |
| Stance 1 | F1 | - | (Bar 1 (Cat)) | - | - | no |
| Stance 2 | F2 | (Bar 1) | - | - | Bar 1 #5 [5] | no |
| Stance 4 | F4 | - | - | (Bar 1) | - | no |
