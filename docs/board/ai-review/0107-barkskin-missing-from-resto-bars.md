# 0107 Barkskin was not on Rob's Resto bars

## What I need from you

In game, as Resto, after `/reload` (v0.70.0 is deployed):

1. Open the talent window. Right-click the **Premade bars** row at the bottom of the build list.
   Click **Make premade bars: each job on its key**. Chat lists each move.
2. Hover the row: your bars show what changes. Double-click it to put them on.
3. Look: Barkskin on Alt+W, Efflorescence on Alt+1.
4. If it is right: More > **Save bars for this spec**. If not: **Undo bars**.

Step 4 matters. Your saved Resto layout has no Barkskin, so a later Load bars would take it away again.

## Why

Rob, 2026-10-21, after Heroic Ula'tek as Resto: "Barkskin was missing from my bars! (need to fix
that in the bar planner!)". He died on all 7 pulls and cast Barkskin 0 times. Most deaths were 5 to
6 second drains (Blight Vein, Necrotic Vapors, Putrid Membrane, Deadly Venom) that Barkskin covers.
The night's review is in the vault: `C:\Dev\SecondBrain\outputs\2026-10-21 Resto heroic Ula'tek raid night log.md`.

## What is known

- The data has it. `PlanTab.BAR_ABILITIES["Resto"]` puts Barkskin in "Personal Defensive 1", the
  same as Feral, Balance and Guardian.
- The job table places Def1 on `MULTIACTIONBAR6BUTTON2` (bar 7 #2, Alt+W), and `PlanTab.JOB_SPEC`
  has no Resto override for it.
- The 2026-09-30 bar analysis (`docs/research/2026-09-30-druid-bars-by-job.md`, lines 137 and 179)
  already found Barkskin on Resto "not on bars 1/4/7 (page 2)", with Alt+W as the proposed key.
  So the old Resto bars never had it on a key, and the planned fix (card `0082`) has not reached
  the Resto layout Rob loaded.
- Not known: whether Rob's Resto bars were made by the planner, or are his own saved bars from
  before `0082`. That decides whether this is a planner fault or a layout that was never rebuilt.

**Rob, 2026-10-21 22:13, chat after loading the Resto layout and turning on the jobs overlay:**

```
Applied the Resto layout: 0 slots and 0 keys changed, 2 skipped. Undo bars puts the old ones back.
  slot 43: not known: Carve Meat
  slot 44: not known: Sharpen Your Knife
Jobs on your bars: 41 buttons. Green: on its key. Amber: it belongs on the key shown. Blue across the middle: the spell that belongs on this key (grey: not learned).
```

So the saved Resto layout matches the bars he wears: the layout itself has no Barkskin, and loading
it cannot fix this. The layout is not being made from the job table. Slots 43 and 44 hold two
cooking-themed entries the game does not know; say what they are.

Also from the same night: Efflorescence was cast 0 times on 7 pulls. The planner puts it in
"Class 7 (Raid Defensive)" for Resto. Check that it is on a key too.

## Acceptance
<!-- AC:BEGIN -->
- [x] #1 WHEN Resto bars are made by the planner, Barkskin SHALL sit on the Def1 key (Alt+W) as on Feral. proves: `PlanTab.jobLayoutChecks`, "Barkskin moves onto Alt+W"
- [x] #2 WHEN Resto bars are made by the planner, Efflorescence SHALL sit on a keyed button. proves: same, "Efflorescence, on no bar, goes onto Alt+1"
- [ ] #3 In a client: Resto, Barkskin and Efflorescence are on keyed buttons after a bar load. proves: none
<!-- AC:END -->

## Root cause (2026-10-21, Claude)

Read from a copy of `WTF\Account\DJINNWRAITH\SavedVariables\DjinnisClassProfiles.lua` (written 20:40).

- `bars.Resto` (saved 2026-10-11) is Rob's own bars, a snapshot. Barkskin is on slot 20 (bar 1
  page 2) and slot 62 (bottom-left bar), neither on a key he presses. Alt+W (slot 158) and Alt+1
  (slot 7) are empty. Loading it changes nothing, which is the "0 slots changed".
- No code ever made a druid spec's own bars from the job table. The only maker was the Feral copy
  (`translateBars`, card `0051`). For a druid it puts Feral's spells on Feral's buttons, so
  `premade.Resto` (2026-10-04) had Starfire on 1 and Wrath on 2, against Rob's agreed core keys. It
  also skipped the planned keys for any druid ("Not for a druid: its bar 1 is form pages"). That
  copy did have Barkskin on Alt+W, but wearing it would have wrecked his rotation, so it was never
  worn. Card `0082`'s "Then (build): each spec's layout rewritten from the job table" was not built.
- Efflorescence had no key in the addon at all. It is Bellular's "Class 7 (Raid Defensive)", which
  has no Feral key and no Resto entry in `JOB_SPEC`. The keybind page proposed Alt+1 on 2026-10-01.

**Slots 43 and 44, "not known: Carve Meat / Sharpen Your Knife".** These are Midnight Skinning
specialisation abilities (spells 1226037 and 1223388; AllTheThings' Skinning data lists both under
specialisation). They sit on bar 4 buttons 7 and 8 in the saved Resto layout, and on bar 4 buttons
3 and 4 in the Feral one. "Not known" means `C_Spell.PickupSpell` put nothing on the cursor, so the
game would not hand them over by spell id. Two likely causes, not proven: the character in play has
not learned those Skinning points, or a profession ability cannot be picked up by id. Harmless: a
slot that cannot be placed keeps what it has.

## Built (2026-10-21, Claude, v0.70.0, deployed)

- `PlanTab.agreedHome(spec, i)`: the key a job is agreed on. The spec's own choice (`JOB_SPEC`), or,
  for a spell Feral has too, Feral's key for it (Rob's answer B on `0082`). Resto's heals get none
  (Clique, Rob 2026-10-04). Barkskin gets Alt+W.
- `JOB_SPEC.Resto["Class 7 (Raid Defensive)"] = "ACTIONBUTTON7"`: Efflorescence on Alt+1.
- `PlanTab.jobLayout(here, spec, api)`, pure: the bars on screen with each agreed job on its key. A
  spell elsewhere is swapped with what the key holds, so nothing is lost; one not on the bars goes
  onto an empty key. Never takes a spell off a form page. A key holding a macro, or another spell
  when the job's spell is not on the bars, stays and is listed.
- For Balance, Guardian and Resto, Make premade bars (row menu, More, `/dcp bars from`) now runs
  that on the spec's own bars. Load premade bars and the double-click make them fresh first, so the
  old Feral copy is never put on. `/dcp bars from feral` still makes the Feral copy. Undo bars as before.
- `barsApi` gained `macroSpell`, so Rob's ProwlMeld macro counts as Prowl on Shift+3.

What it does to Rob's saved Resto bars (run offline on the copy):

| Move | What the key held |
|---|---|
| Barkskin from slot 20 to Alt+W | empty |
| Efflorescence onto Alt+1 | empty |
| Entangling Roots from Alt+A to Alt+F | Revitalize, which goes to Alt+A |
| Soothe from Alt+4 to Shift+R | empty; Alt+4 is then empty |

Left, and said in chat: Starfire (key 4 holds the OneButton macro), Regrowth (Shift+1 holds
EnhanceQoLHealthMacro), Lifebloom (Alt+3 holds Tranquility; Lifebloom is on Clique, not on a bar).
Innervate showed as left offline only because the offline run cannot read a macro's spell.

Checks: `PlanTab.jobLayoutChecks`, 25 lines. Mutants that turn it red: no Efflorescence key (5
fails), no jobs route (2), a form page as a source (1), JOB_SPEC ignored (8), a swap that loses the
old button (2), a macro displaced (1). `lua offline-check.lua` has 1 FAIL line before and after this
change: the `DjinnisBiS` stub's Interface (120100, not 120105), a workspace file. The druid spec runs
(`102`, `104`, `105`) have 3 FAIL lines before and after (Feral plan lines on a tier token).

Not done: the jobs overlay (`jobHome`) still reads Resto's heal jobs as Feral's keys, so it draws
them amber. It should read `agreedHome`. A follow-up, not part of this fix.
