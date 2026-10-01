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

**2026-09-30, Rob:** "note click casting (clique?) for Restoration (can you pull those keys out?)"

**2026-09-30, Claude. Resto click casting, read from Clique.** Source: a `%TEMP%` copy of `SavedVariables\Clique.lua` (written 2026-09-30 23:53), profile `Djinni - Bloodfeather`, the profile this character uses in all four specs (`specswap` off). Every binding is in set `default` (all unit frames) with no spec filter.

| Mouse | Spell | Job (Bellular) |
|---|---|---|
| Left | Lifebloom | Combat 7 |
| Right | Rejuvenation | heal |
| Shift+Left | Ironbark | External Defensive |
| Shift+Right | Regrowth | heal |
| Alt+Left | Swiftmend | heal |
| Alt+Right | Wild Growth | heal |
| Wheel up | Nature's Cure, and Remove Corruption | Dispel |
| Wheel down | Remove Corruption (twice) | Dispel |
| Ctrl+Left | target | - |
| Ctrl+Right | unit menu | - |

What this means for the job keys:
- **Lifebloom is on Left click, not Alt+3.** The Alt+3 proposal for Resto Combat 7 above is weaker: the button only matters for a target that is not on a raid frame.
- **Wheel up has two spells.** Nature's Cure (Resto) and Remove Corruption (the others) share it with no spec filter; which one fires is up to Clique. Worth a look in game.
- **No clash with the keyboard.** Clique binds mouse buttons on unit frames only; no keyboard key is used, so the job table and Clique do not fight.
- **The healer sets match across characters.** The shared `Druid` profile (older druids) and `Whispylydia - Silvermoon` hold the same set plus Cenarion Ward on Alt+Shift+Left; `Druid` also has Innervate on Middle click. Bloodfeather has neither. Rob's other healers keep the same pattern (main heal Left, second heal Right, Shift and Alt for the rest, dispel on the wheel), so "one job, one click" already holds across classes.

**2026-10-01, Rob:** Resto keeps Lifebloom on Alt+3 as a backup to Left click, for a target that is not on a raid frame. Combat 7 on Alt+3 is now agreed for Resto (Balance's Lunar Eclipse still to confirm). No code change: v0.63.2 already has it.

**2026-10-01, Rob:** Cenarion Ward on Alt+Shift+Left looked like a missing bind, but he cannot find the spell in talents or the spellbook. **Claude:** it is gone in Midnight. SimulationCraft's druid module names `cenarion_ward` 19 times on branch `thewarwithin` and 0 times on `midnight`, which still models Lifebloom, Ironbark and Wild Growth. The Alt+Shift+Left binds in the `Druid` and `Whispylydia` Clique profiles are dead. Nothing to add. Alt+Shift+Left is free on Bloodfeather.

**2026-10-01, Rob:** "Remove corruption gets replaced with natures cure when in resto spec." **Claude:** so wheel up is not a clash. The game swaps the spell by spec, so both Clique entries cast the dispel that spec has. The earlier "worth a look in game" is withdrawn. Nothing to change.

**2026-10-01, Rob:** "the thing missing from your overlay in general I think is what spell should be there if that spell isnt currently on my bars" (after asking what goes on 2 in Guardian: nothing, the bear page's key 2 is empty; the plan puts Mangle there).

**2026-10-01, Claude.** v0.63.3. `PlanTab.jobFor(spec, binding, api)` names the job whose key a button is, and that spec's spell for it (Rob's extras and items by their own name). `jobPlan` adds `need` when the button does not hold that job; `drawJobs` writes it across the middle of the button: blue when learned, grey when not in this build. An empty key now gets a label too (its job in blue on top). 5 checks; 3 of 4 mutations fail the test, the fourth (`drawJobs` skipping empty buttons) is drawing code only a client runs.

In-game check: Guardian bear page, key 2 reads C1 over "Mangle" in blue. A key with a spell of the wrong job shows amber on top, "to <key>" at the bottom and the right spell in the middle; the three lines must stay readable on Rob's button size.

**2026-10-01, Rob:** "really S3 should be growl? when everywhere else its shadowmeld/prowl?"

**2026-10-01, Claude.** v0.63.4. Bellular's Guardian column puts Growl in Taunt/Quick Access (Feral, Balance and Resto have Prowl there) and Prowl in Class 7. Rob's bars already agree with him: slot 165 (Shift+3) is Prowl on Guardian / Dungeon and Feral / Dungeon; Balance and Resto have a `Druid -ProwlMeld` macro. `JOB_SPEC.Guardian` now sends Class 7 (Prowl) to `MULTIACTIONBAR6BUTTON9` and gives Taunt/Quick Access (Growl) no key (`""`, which `jobHome` reads as none). `JOB_SHORT_SPEC` draws Guardian's Class 7 as "Prowl". 2 checks, 3 mutations each fail the test.

Open: Growl's key in Guardian. Feral / Dungeon and Resto have Growl on the bear page's key 2 (slot 98); Guardian / Dungeon has it on slot 14 (bar 1, page 2), which Rob does not see in bear form. That bears on the Mangle question: Growl on bear key 2 as in the other specs would keep Mangle on 1.

**2026-10-01, Rob:** "I think I normally have growl on alt+2 (I tried having it on 2 before, but 1. some builds require use of 2 for things like raze/sundering roar, 2. I was prone to growling at things I shouldnt!" Then: "that does then mean convoke needs to go somewhere on builds that take convoke?" and "I dont just need you to agree with me. I need you to argue the case against where relevant too".

**2026-10-01, Claude.** v0.63.5. `JOB_SPEC.Guardian`: Taunt/Quick Access (Growl) on `ACTIONBUTTON8` (Alt+2); Combat 1 (Mangle) on `ACTIONBUTTON1`, Combat 2 (Thrash) on `ACTIONBUTTON4`, where both are now; Combat 10 (Convoke) none until Rob picks. Guardian's bear page has 2 (slot 98) and Shift+Q (slot 107) empty; Alt+2 (slot 104) was empty too. Open: Convoke's key in Guardian, and whether key 2 floats by build (Rob's practice) or gets one job (the system's aim).

**2026-10-01, Rob:** "1. what does that replace in feral and resto? 2. if sundering roar goes on T where does moonfire go? (which is on t in guardian and feral) - I think I am open to moving it.. 3. shift q works sure I think there used to be an extra defensive that went there but no longer."

**2026-10-01, Claude.** v0.63.6.
- Convoke (Guardian Combat 10) on Shift+Q (`ACTIONBUTTON11`).
- That clashed: the sheet's Guardian Combat 6 is Moonfire, whose Feral key is Shift+Q. Proposed and built, for Rob to overrule: Moonfire keeps T in Guardian, as in Feral and on his Guardian bars (one spell, one key beats one category, one key). Sundering Roar (Combat 11, Feral's T) takes 2, where his builds already put it.
- `BAR_ALIASES.raze = "Maul"`: SimulationCraft midnight `sc_druid.cpp` makes Maul not ready while Raze is talented.
- New check: no key holds two jobs in any druid spec. It caught the Moonfire and Convoke clash when the Moonfire line is removed.
- Answer to 1, from his bars: Alt+2 on the Feral and Resto bear pages holds Skull Bash, whose job key is Shift+E, and Shift+E is empty on both. Balance's bear page already has Growl on Alt+2. Shift+Q on the Feral and Resto bear pages holds Frenzied Regeneration (Guardian: Alt+Q), likely the "extra defensive" Rob remembers.
- Limit: the overlay judges a form page by the spec's own jobs, so Growl on a Feral or Resto bear page has no job to show. Moving it there is by hand, or part of the form-page normalising.

**2026-10-01, Rob:** "when you recomend a change / move, I need you to tell me what was already there, not just what you want to move there. 1 sounds good. kick should always be on shift+E. 2. agree. 3. what normally goes there? I think it was a guardian only defensive from TWW doesnt matter anymore, Shift Q on feral is feral frenzy by the looks of it"

**2026-10-01, Claude.** Decided: Growl on Alt+2 in every spec's bear form; the interrupt on Shift+E on every page it is on; Moonfire keeps T and Sundering Roar takes 2 in Guardian. The by-hand moves, each with what the target key holds now (read from SavedVariables 2026-10-01):

| Spec, page | Move | Target key now holds |
|---|---|---|
| Feral, bear | Skull Bash Alt+2 to Shift+E | empty |
| Feral, bear | Growl 2 to Alt+2 | Skull Bash (moving out); 2 is then empty |
| Resto, bear | Skull Bash Alt+2 to Shift+E | empty |
| Resto, bear | Growl 2 to Alt+2 | Skull Bash (moving out); 2 is then empty |
| Resto, cat | Skull Bash Alt+2 to Shift+E | empty; Alt+2 is then empty |
| Resto, moonkin | Skull Bash Alt+3 to Shift+E | empty; Alt+3 is then free for Lifebloom |
| Balance, moonkin | Solar Beam Alt+3 to Shift+E | empty; Alt+3 is then free for Lunar Eclipse |
| Balance, cat | Solar Beam Alt+2 to Shift+E | empty |
| Balance, caster (bar 1) | Solar Beam Alt+3 to Shift+E | **Rejuvenation**: open, where it goes |
| Balance, bear | Growl on Alt+2 already | - |
| Guardian | Skull Bash on Shift+E (bear), the Kick macro (cat) already | - |

Not moved: Resto's caster Shift+E holds Incapacitating Roar; Resto has no interrupt out of form.

Withdrawn: moving Frenzied Regeneration to Alt+Q in Feral and Resto. Alt+Q is bar 7 button 1 (slot 157), which does not change with form, and holds Survival Instincts on Feral, Nature's Swiftness on Resto, nothing on Balance, Frenzied Regeneration on Guardian. The move would have pushed Survival Instincts and Nature's Swiftness out in every form. Frenzied Regeneration stays on Shift+Q on the Feral and Resto bear pages (Feral's cat Shift+Q is Frantic Frenzy); Guardian keeps it on Alt+Q, an accepted exception.

Rob's old Guardian Shift+Q defensive: likely Rage of the Sleeper, which SimulationCraft names 22 times on branch `thewarwithin` and 0 on `midnight`.

**2026-10-01, Rob**, on Solar Beam to Shift+E over Rejuvenation on Balance's caster bar: "Do the change."

**2026-10-01, Claude.** v0.64.0. No session can press a button in the client, so the overlay does it: an amber label now takes a left click (`PlanTab.jobMove`) and swaps its spell with what its key's button holds (`PlanTab.jobSwap`: PickupAction, PlaceAction, the old action back onto the first slot; the same calls compare mode already makes). Nothing is lost. Its tooltip says what the key holds now and where that goes. `PlanTab.jobUndo` keeps the swaps for the session; More > Undo the last job move (and `/dcp bars jobs undo`) swaps the last one back. Only amber labels take the mouse; the rest let clicks through. Fenced in combat, with something on the cursor, or on a vehicle bar. A key whose button is not on screen says to move it by hand. 7 checks; 4 mutations each fail the test.

For Rob's Balance caster bar: Solar Beam (Alt+3) to Shift+E swaps Rejuvenation onto Alt+3. Alt+3 is Lunar Eclipse's key (Combat 7), but on the caster bar Rejuvenation is the only thing that needs a place.

In-game check: as Balance in caster form, hover Solar Beam's amber label (the tooltip names Rejuvenation), click it, see the swap and the chat line; More > Undo the last job move puts it back. And a non-amber label must not block a mouse click on its button.

**2026-10-01, Rob:** "You already had me move thrash to 1" (asked what goes on Guardian key 4; Claude had answered Thrash, from the 01:00 save).

**2026-10-01, Claude.** Error owned: v0.63.5 set Mangle 1 and Thrash 4 from Rob's key-2 answer without asking, after the earlier proposal (Thrash 1, Mangle 2) he had already acted on. v0.64.1: Guardian Thrash (Combat 2) on 1, Feral's default (Rake's key); Mangle (Combat 1) on 4, assumed from a swap since the saved bars predate his move. To confirm with a fresh save. The case against: Mangle is Guardian's most-pressed button and 4 is the furthest of 1 to 4; 2 is taken by Sundering Roar.

**2026-10-01, Rob:** "4 is pretty easy, 5 is the harder and 6 is not really usable". So Mangle on 4 stands, and the case against it is withdrawn. Key 6 has no binding (T is `ACTIONBUTTON6`). For every class: most-pressed spells on 1 to 4, a less frequent one on 5, nothing on 6.

**2026-10-01, Rob:** "similarly, qwer easy, t stretch / shift, and alt are usable, ctrl not really". Reach, for every class: easy 1 to 4 and Q W E R; harder 5; stretch T; 6 unused; Shift and Alt usable, Ctrl not. Fits the plan so far: Moonfire on T (Feral, Guardian) is not a most-pressed spell. To check against this when the layouts are built: no job's key uses Ctrl.

**2026-10-01, Rob:** "can you build me a page showing all classes and specs and what buttons you propose to put where?"

**2026-10-01, Claude.** `docs/research/2026-10-01-keys-for-every-class.html`, written by `docs/research/bars-analysis/keys_page.lua` from the addon's own tables (it loads the addon through `offline-check.lua`) and Rob's bindings (a `%TEMP%` copy of the SavedVariables). Druid specs show the keys agreed so far; every other spec shows proposal 1, which Rob has not picked yet: its role's druid spec (casters and healers: Balance's and Resto's 1 to 4 and Alt+3; tanks: Guardian's keys without Prowl), less druid-only reasons. Guardian habits copied to other tanks are marked for review (Combat 6 on T: Purifying Brew, Ignore Pain). Each spec lists the jobs with no key yet. 13 classes, 0 clashes. Rerun the script after any key change.

**2026-10-01, Rob:** "dispels and heals go on mouse buttons that are only triggered on a unitframe hover (clique/click casting). I was more hoping for a more visual representation (see the screenshots I posted before, can you give me that layout please with visual icons that can be hovered over? Bonus points if you can make use of the bellular site to give it the ability to show spells and icons, and let me drag abilities around / hover over them to see what they are"

**2026-10-01, Claude.** `docs/research/2026-10-01-keybind-layout.html` replaces the table page. Bars as on Rob's screen (his 2026-09-30 screenshots): bar 1 above the minimap, bar 7 left, bar 4 right, each 2 rows with buttons 7 to 12 on top and 1 to 6 below; bar 5 (Num keys) to the right. A class and spec picker; every button has its icon, key and job; hovering shows Wowhead's tooltip and why the spell is there. Drag to swap, drag a spare spell on, drag one to the tray to take it off; changes are kept in the browser (localStorage) and "Copy my changes" writes them as lines that say what each key held. A Clique panel per spec: Rob's real profile for the five classes that have one (Druid: Djinni - Bloodfeather; Priest: Djcloud; Monk: Zuhlah; Paladin: Loamint; Shaman: Shortnbitter), the spells that spec has, and the dispel proposed on the mouse wheel where missing. The dispel job is no longer a key.
Built by: `keys_page.lua` (the addon's tables to `keys_data.json`), `bellular_spells.py` (Bellular's web tool carries 691 spells with ids and icons, `bellular_spells.json`), `build_keys_page.py` (names to icons, falling back to wago.tools SpellName with SkillLineAbility and TraitDefinition, and Wowhead's tooltip API; caches `name_icons.json`, `item_icons.json`). 4 generic names have no icon (Mount, Poisons, Res, Weapon Buffs). Checked in a browser: renders, drag to swap, drag from the tray, Wowhead tooltip on hover, changes kept on reload.

**2026-10-01, Rob** (changes copied from the page): Blood Path of Frost from Wheel up to Num1. Devourer Spectral Sight to Num1, Darkness to Alt+Q, Void Nova to Alt+1. Havoc Darkness to 5 (Essence Break from 5 to 4), Spectral Sight to Num1, Chaos Nova to Shift+W, Rain from Above to Alt+2. Arcane: Arcane Intellect from Alt+G to Num1. "Can you extrapolate? (Also, non spec specific spells should automatically be changed for all specs I think)"

**2026-10-01, Claude.** Rules taken from those moves, in `keys_page.lua`, for every class:
- Num1 holds the raid buff. Bellular's own sheet swaps its Buff and Res rows for Paladin, Rogue, Priest, Shaman, Mage and Monk (Priest: Buff "Res", Res "Power Word: Fortitude"), which is why Arcane Intellect sat on Alt+G. The page swaps them back. The addon's `BAR_ABILITIES` carries the same swap, so `translateBars` puts these buffs on the Res key too. Not fixed in the addon yet: needs a card.
- A class with no raid buff puts its out-of-combat utility on Num1: Death Knight Path of Frost, Demon Hunter Spectral Sight.
- Only a real dispel goes on the Clique wheel. Bellular's "Class 6" is Path of Frost for a Death Knight and Imprison for a Demon Hunter.
- Bellular's "CC" goes on Shift+W (a druid's Incapacitating Roar key) for every class: Storm Bolt, Hammer of Justice, Kidney Shot, Psychic Scream, Asphyxiate, Capacitor Totem, Frost Nova, Leg Sweep, Chaos Nova.
- Rob's own picks stay as he made them (Havoc, Devourer), source "rob", green.
- Bellular lists Unholy's Death Coil twice (Combat 3, Self-Heal 3): it gets one key.

40 specs, 0 clashes. Not extrapolated: Darkness (Havoc 5 and Devourer Alt+Q disagree, and Bellular's "Raid Defensive" row holds different kinds of spell per class); Rain from Above (a PvP talent).

The page now moves a spell in every spec of the class that uses it: drop it on a key (what was there takes its old key, or the tray), or drag it to the tray. It says which specs also moved. Checked in a browser: Spectral Sight moved in Havoc also moved in Vengeance and Devourer; Essence Break moved in Havoc only.

**2026-10-01, Rob:** "can we make bar 1 change based on stance? Like in game? (stance for warriors, shapeshift form for druids)"

**2026-10-01, Claude.** Bar 1 on the page has a tab per page the game swaps to: a druid's Caster, Cat Form, Prowl, Bear Form, Moonkin Form; a rogue's Normal and Stealth. Each spec opens on the page it fights on (`PlanTab.FORM_PAGE`). That page is the plan; a druid's other pages are his saved bars (`Feral / Dungeon`, `Guardian / Dungeon`, `Balance`, `Resto`, saved 2026-09-30), grey, as they are. A macro shows the spell it casts (its `index`). The rogue Stealth page starts as a copy of bar 1 (no rogue bars saved). A class-wide move on a form page moves the copy on the same form page in the other specs.
Warriors not done: Blizzard's bar 1 does not page for warrior stances. Dominos' retail bar states (`Dominos/core/barStates/Standard.lua`) page a rogue and an Evoker on `[bonusbar:1]` but a warrior on `form`, an addon option. Rob's bars are Blizzard's (Edit Mode). Asked Rob whether to add warrior stance tabs anyway.
Checked in a browser: tabs, each spec's home page, Growl moved to Alt+2 on Feral's bear page also moved on Resto's (Guardian and Balance already had it there), the change list names the right old key, old saved changes move onto the home page.
