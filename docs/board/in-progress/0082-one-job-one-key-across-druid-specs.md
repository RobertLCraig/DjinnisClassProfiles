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
**2026-10-01, Rob:** "1 I seem to remember that they did but maybe that changed in the years since I last played warrior." Decided: no warrior stance tabs. They did page in older expansions; the stances that came back in Dragonflight do not (Dominos' current retail code pages a warrior by `form`, not `bonusbar`).
Checked in a browser: tabs, each spec's home page, Growl moved to Alt+2 on Feral's bear page also moved on Resto's (Guardian and Balance already had it there), the change list names the right old key, old saved changes move onto the home page.

**2026-10-01, Rob:** "also recheck for talents/abilities that are effectively toggles (I think from memory you cannot have mighty bash AND incapacitating roar at the same time, so both can be on the same bind. since you would only have 1 or other and they mostly do the same job (although in the current game, I cant think of a single reason to take mighty bash over incap roar...."

**2026-10-01, Claude.** `choice_nodes.py` writes `choice_nodes.json`: every talent choice node (`TraitNode.Type` 2, per `TraitConstantsDocumentation.lua`), from wago.tools at the live build (12.1.0.69933), trees tied to a class by `SkillLineXTraitTree`. 402 nodes; it includes passives and some stale nodes, and the class comes from the tree, not the spec. Mighty Bash / Incapacitating Roar confirmed (node 82237).
Rule in `build_keys_page.py`: one option on a key and the other with no key, the other shares that key. Applied: every druid spec, Shift+W "Incapacitating Roar / Mighty Bash" and Alt+R "Ursol's Vortex / Mass Entanglement". Bellular already shares Fury's Avatar/Bladestorm and Demonology's Implosion/Power Siphon. Both options on separate keys, not merged: Arms (Bladestorm Alt+2, Avatar Alt+S) and Windwalker (Whirling Dragon Punch Shift+Q, Strike of the Windlord 5). Bellular keeps these apart for these specs, so the node may be another spec's only. To check in game.
**2026-10-01, Rob:** "Avatar does a different job to Bladestorm (I think Avatar is a buff? and bladestorm is aAOE, looking in game, they look like seperate abilities and are NOT on a choice node. I do not think they should share a key". Kept apart: Arms Bladestorm Alt+2, Avatar Alt+S. The data's node 90415 (Avatar / Bladestorm, warrior tree 850) is not on Arms' tree in game. Rob, 2026-10-01: "ahh it IS a choice node for Fury". Fury already shares one key (Alt+S), from Bellular's sheet.
**2026-10-01, Rob:** "even then, I do not think they should share a key, they do fundamentally different things." The rule is now: either/or talents share a key only when they do the same job. `keys_page.lua` `SPLIT`: Fury Avatar stays on Alt+S, Bladestorm to Alt+2 (empty in Fury; Arms' key). Kept shared, same job: Incapacitating Roar / Mighty Bash (crowd control), Ursol's Vortex / Mass Entanglement (area control). Asked Rob: Demonology's Bellular cell Implosion / Power Siphon on 5 (Implosion is damage, Power Siphon a resource builder).

**2026-10-01, Rob:** "Whirling Dragon Punch and Strike of the Windlord are a choice node yes. looks to me from reading the tooltip they both are frontal aoe, so can share a key. warlock could make better use of alt 1 and alt 2?"

**2026-10-01, Claude.** `keys_page.lua`:
- `MERGE`: Windwalker "Strike of the Windlord / Whirling Dragon Punch" on 5; Shift+Q (held Whirling Dragon Punch) is free.
- `SPLIT`: Demonology Implosion stays on 5, Power Siphon to Alt+1 (was empty).
- `PROPOSED`: Destruction Havoc (had no key) to Alt+1 (was empty).
Still free: Alt+1 Affliction (no keyless combat spell in Bellular's data for it), Alt+2 Demonology, T Affliction and Demonology. Every warlock has Mortal Coil, Curse of Tongues, Soulburn, Demonic Gateway and Subjugate Demon with no key: utility, for bars 7 and 4, not bar 1. Not done: Windwalker's 4 is empty while Rising Sun Kick (its main spell) is on Alt+3 and Fists of Fury on Alt+1, a leftover of copying Feral (a finisher on Alt+1). Proposed to Rob, not applied.

**2026-10-01, Rob:** "need to do a beter job of distinguishing buffs from teleports (monk has trancendance spells that work much the same as a warlock demonic circle/gateway. these are not buffs that go on num1. warlock num 1 I typically have underwater breathing I think"

**2026-10-01, Claude.** Bellular's Buff and Res rows are not just swapped for some classes: a warlock's hold Demonic Circle and Demonic Circle: Teleport, which the class-based swap put on Num1 and the Res key. `keys_page.lua` now sorts each row's spell by what it is (`IS_BUFF`, `IS_RES`); anything else is placed by `TELEPORT`. One pair of keys for a place-and-return teleport in both classes: set the spot on Shift+2, teleport on Alt+E (both free in both classes). Monk's Shift+R (held Transcendence, under Bellular's Purge row) and Shift+V (held Transcendence: Transfer) are now free. Warlock Num1: Unending Breath. Demonic Gateway (a portal for the group) stays with no key. The addon's `BAR_ABILITIES` has the same rows, so `translateBars` makes the same mistake: still to card.

**2026-10-01, Rob** (changes copied from the page): Blood Asphyxiate and Arcane Frost Nova off Shift+W. Havoc and Devourer Imprison to Wheel up, then "Devourer: Imprison (no key before) to Alt+R". Every monk spec: Touch of Death to T (Brewmaster's T held Purifying Brew, Mistweaver's Celestial Conduit, both now off the bars), Tiger's Lust to V, Roll from V to Alt+E, Ring of Peace to Alt+R, Disable to Shift+A, Zen Flight to Num2; Windwalker Flying Serpent Kick to Num1. "on druid alt e is for charge, I feel like roll is more of a charge than a movement".

**2026-10-01, Claude.** In `keys_page.lua`: `ROB_PICKS` (monk), `ROB_OFF` (Asphyxiate and Frost Nova off for every DK and mage spec), `ROB_CLASS` (Imprison on Alt+R for every Demon Hunter; Clique's wheel only fires over a unit frame). Monk's teleport moves from Alt+E to Shift+V, where Bellular had it. 0 clashes. Asked Rob: keys for Purifying Brew (2 is empty in Brewmaster) and Celestial Conduit (Alt+1 is empty in Mistweaver); whether the warlock teleport leaves Alt+E (the charge key) for Shift+V like the monk; whether Shift+W keeps the single-target stuns (Storm Bolt, Hammer of Justice, Intimidation, Kidney Shot) now that Asphyxiate left it.

**2026-10-01, Rob:** "can you have both roll and flying serpent kick? I deffinately dont like that on num 1. Shift 2 should be healing potion on all classes and specs, shift s healthstone (ideally I would like them on the same key, with healthstones being prioritised)"

**2026-10-01, Claude.** Both: Flying Serpent Kick is in no choice node (Roll's node is Celerity / Chi Torpedo). `SPELL_KEY` in `keys_page.lua`: Healing Potion (item 258138, Potent Healing Potion, already on Rob's Feral Shift+2) on Shift+2 in all 40 specs; Flying Serpent Kick on C (was free); the teleport place spells (Transcendence, Demonic Circle) from Shift+2 to Shift+R; Banish from Shift+R to Alt+R (free; a Demon Hunter's Imprison key). Healthstone stays on Shift+S. One key for both: offered Rob a `/castsequence reset=combat` macro, stone first; not tried in 12.1, and the addon's `ITEM_JOBS` has no healing potion yet.

**2026-10-01, Rob** (changes copied from the page): Balance Wild Mushroom to Alt+1 (Moonkin). Every DK spec: Wraith Walk Shift+V, Death Grip Shift+V to Shift+A, Raise Dead Alt+F, Chains of Ice Alt+R, Lichborne Shift+1, Anti-Magic Zone Alt+1, Asphyxiate T; Blood Gorefiend's Grasp Shift+W; Frost and Unholy Death and Decay Alt+Q. Every mage spec: Time Warp off Alt+D, Mirror Image Alt+2, Cone of Cold Alt+1, Mass Invisibility Num2, Frost Nova Alt+R, Slow Fall X; Fire and Frost Arcane Explosion Alt+4. Brewmaster Purifying Brew Alt+Q (Breath of Fire to 2), Chi Burst Alt+1, Expel Harm Wheel down. Windwalker Strike of the Windlord 5 and Whirling Dragon Punch Shift+Q, split again. "Your healthstone macro doesnt account for not having one ... shift + w could be used for any stun".

**2026-10-01, Claude.** All in `keys_page.lua` (`ROB_PICKS`, `ROB_CLASS`, `ROB_OFF`, `ROB_MOUSE`), 0 clashes. The page's class-wide move had pushed spells off other specs: Asphyxiate on T took Frost's Remorseless Winter; Anti-Magic Zone on Alt+1 took Frostscythe and Putrefy; Lichborne on Shift+1 took Frost's and Unholy's Death Strike. Fixed in the page: a class-wide move now skips a spec where the key is taken and the spell had no key, and says so. On Rob's "any stun" rule, Frost's and Unholy's Asphyxiate go to Shift+W, so Frost keeps Remorseless Winter on T. Still with no key, asked Rob: Blood Vampiric Blood, Frost and Unholy Death Strike, Frostscythe, Putrefy, mage Time Warp, Mistweaver Celestial Conduit. Shift+W rule now: any stun or group control, so Storm Bolt, Hammer of Justice, Intimidation and Kidney Shot stay. Healthstone then potion on one key: card `0083` (an addon-written macro; a plain macro cannot see whether a stone is in the bags).

**2026-10-01, Rob:** "okay" to the proposed keys. Built: Blood Vampiric Blood 2; Frost and Unholy Death Strike 4; Unholy Putrefy Alt+2; Mistweaver Celestial Conduit Alt+1; mage Time Warp back on Alt+D. Frostscythe stays with no key. 0 clashes. Death Strike is on 5 in Blood and on 4 in Frost and Unholy: one spell on two keys across the class, raised with Rob. Rob: "2", keep it: Blood's Heart Strike keeps 4 and Death Strike 5; an accepted exception to one spell, one key. This is why the rule never merges two keyed options. Windwalker still to check.

**2026-10-01, Rob:** "1": Claude proposes keys for the spells with none, class by class, and Rob fixes them on the page. **Claude**, druid first (`PROPOSED`, source role): Hibernate Num2 in all four; Feral Frenzied Regeneration 4 (empty on the cat page) and Maim Shift+4; Guardian Bristling Fur Shift+4; Resto Efflorescence Alt+1 and Starsurge Shift+E. Mass Entanglement and Mighty Bash were never gaps: the page joins each with its either/or partner (Alt+R, Shift+W). Ironbark is on Clique Shift+click. 0 clashes. Asked Rob: Feral 4 for Frenzied Regeneration or Maim.

**2026-10-01, Rob:** "druid is my main class. Not sure about frenzied regen on 4. it requires bear form and I'd rather not risk pressing it by accident". **Claude:** swapped, Feral Maim 4 and Frenzied Regeneration Shift+4. 0 clashes.

**2026-10-01, Rob:** "if the macro works. I guess it could go on shift S". Waits on card `0083`: when its in-game looks pass, the Healthstone leaves Shift+S in every spec (the macro is on Shift+2) and Feral Frenzied Regeneration moves Shift+4 to Shift+S.

**2026-10-01, Rob:** "macro seems to work okay!" **Claude:** done as planned: no Healthstone key in any of the 40 specs (Shift+S is free outside Feral), Feral Frenzied Regeneration Shift+S, Shift+4 empty again. 0 clashes. The addon's own `JOB_BUTTONS` still sends the Healthstone job to Shift+S; that changes when the plan is built into the addon.

**2026-10-02, Rob:** "I want to play my rogue right now. are we ready to import and setup the rogue yet?", then "can the addon not just do it?" and "and setup the bars please". **Claude:** the copy from Feral (More > Make bars from your druid's) already moves each spell to its job's Feral key, but skips a job Feral has no button for: Blind, Vanish, Tricks of the Trade, Gouge, Distract, Thistle Tea, and Kidney Shot unless the rogue already had it. v0.66.0, deployed: `PlanTab.JOB_SPEC` holds those keys for the three rogue specs (Blind Alt+R, Vanish Shift+S, Thistle Tea C, Distract Num3, Tricks 4, Kidney Shot Shift+W, Gouge Shift+A), and `translateBars` fills them (`PlanTab.bindingSlot`, never for a druid, never over a spell the copy moved). The page matches; Vanish moved there from Shift+4 because bar 6's Shift+4 may not be on screen. Both offline modes end with no FAIL lines; six mutants turn the suite red. In-game look: on the rogue, More > Make bars from your druid's, then Load bars: spec; the seven are on their keys; Stealth stays where the rogue had it.

**2026-10-02, Rob:** "can also place the non class specific abilities, toys, macros and set keybinds". **Claude:** v0.67.0, deployed. Keys already went with Load bars (the layout's keys, `placeKeys`); spells any class knows and items already carried. New: a mount (`C_MountJournal.Pickup` by display index; the random favourite is index 0) and a toy (`C_ToyBox.PickupToyBoxItem` when it is in no bag) are placed; a character macro goes to another class when every /cast, /use and /castsequence name in it is known there, an item:<id> or a slot number (`PlanTab.macroCarries`), and placeBars makes it there. Not done: a racial maps only when both characters share a race; a mount hidden by the journal's filters is listed, not placed. Both offline modes end with no FAIL lines; seven mutants turn the suite red. In-game looks: a mount, a toy and the heal macro land on the rogue's bars from the druid's.
