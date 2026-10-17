# The window has no decent way to open

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Why

Opening the window is the weakest part of the addon, and it has already failed once in front of a
raid.

The `.toc` declares `## AddonCompartmentFunc: DjinnisBiS_Toggle`, which should put an entry in the
minimap addon drawer. On 2026-08-19 that entry did not appear, while `DjinnisDelveTracker` and
`DjinnisWarbandManager` both did, **and neither of those two declares that field at all**. So the
drawer is populated by something other than the field the addon is relying on, and nobody has
established what. The working theory at the time was that WoW only reads `.toc` files at startup and
Rob had only reloaded, but that was never confirmed by a restart, and the two addons that do show up
without the field make it a weak theory.

The fallback shipped in its place is a 32x32 druid claw icon parented to `UIParent`, dropped at
screen centre minus 180, draggable, position saved in `DjinnisBiSDB.button`. It works, and it is
crude: a bare floating texture with no frame, no minimap docking, and no relationship to any of the
other nine addons' UI conventions.

Rob's own suggestion is worth taking seriously: surface the information as a **data text**, the way
`DjinnisDataTexts` does. A data text panel is somewhere he already looks, it needs no floating
icon, and the useful summary is short. Something like *"3 BiS here"* while standing in an instance,
clicking to open the full window.

## Not this card

The window's contents. Both tabs, the paper doll, the item level picker and the sim import are all
working and are not in question here. This card is only about **how you get to it**.

The loot roll warning and the bonus roll verdict, which are event driven and never needed a button.

Rebuilding `DjinnisDataTexts` or changing anything inside it beyond, at most, registering a new
module.

## Direction

**2026-08-20, Rob: standalone.** No dependency on `DjinnisDataTexts`, in either direction.

That turned out to cost nothing, because LibDataBroker already solves it. The addon now registers a
broker **data source**, which is the open standard every data text display reads, and LibDBIcon
turns the same object into a minimap button. So the data text Rob asked for arrives through ElvUI or
any other broker display, the minimap button arrives for free, and `DjinnisBiS` depends on nothing
but its own embedded libraries.

`DjinnisDataTexts` was checked and would not have helped anyway: it is a **producer** of broker
objects, one per module, not a generic display, so it would not have picked up a foreign source
without new code inside it.

Libraries chosen to match the house pattern rather than invented: `DjinnisWarbandManager`,
`DjinnisDelveTracker` and `DjinnisClassProfiles` all already register a minimap button this way.
Four libraries embedded, LibStub, CallbackHandler-1.0, LibDataBroker-1.1, LibDBIcon-1.0, listed
directly in the `.toc` rather than through an `embeds.xml`.

The floating claw button is gone, not kept as a fallback.

**Still open, and it is why this card is not done:** nobody has established why the addon compartment
entry never appeared, and the tooltip summary has never been seen in a live client.

**2026-08-21** bin/decision-prep.ps1 prepared this card unattended and wrote an ask. The agent returned no report of what it assumed, so what it read and what it could not determine is not recorded here. The run is in storage/logs/decision-prep.log.

## Acceptance

<!-- AC:BEGIN -->
- [ ] #1 THE ADDON SHALL open its window from a control that survives a `/reload` and a full client restart. Look: quit WoW fully and start it (not a `/reload`); the claw button is on the minimap ring and a click opens the window; `/reload`, and it still does. proves: manual
- [ ] #2 THE COMPARTMENT FINDING SHALL be written down. Look: after that full restart, open the minimap addon drawer; pass is exactly one "Djinni's Class Profiles" entry that opens the window. None or two: write which on the card and move it to `todo/` (the fix is LibDBIcon's `showInCompartment = true` with the `.toc` field dropped). proves: manual
- [x] #3 THE ADDON SHALL depend on no other addon, and SHALL expose its summary through an open
      interface rather than a private one.
- [x] #4 THE FLOATING CLAW BUTTON SHALL either be removed or become an opt-in, not the only route.
- [ ] Hover the minimap button in a city: the tooltip reads "Djinni's Class Profiles" and "Click to open"; inside the Venomous Abyss it also shows a green "N BiS items drop here" line. proves: manual
<!-- AC:END -->

## Tasks

- [ ] Restart the client fully and record whether the compartment entry appears
- [ ] Find out what actually puts `DjinnisDelveTracker` and `DjinnisWarbandManager` in that drawer,
      given neither declares `AddonCompartmentFunc`
- [x] Read how `DjinnisDataTexts` registers a module: it produces broker objects rather than
      consuming them, so coupling would have needed new code inside it
- [x] Put the standalone-versus-coupled question to Rob with the cost of each
- [x] Build the chosen route: LibDataBroker data source plus a LibDBIcon minimap button
- [ ] Check the minimap button and its tooltip summary in a live client

## Plan

Answer the question before writing anything. The compartment mystery is cheap to settle and it
decides whether there is a bug to fix or a field to abandon, and the answer changes what gets built.

A data text is the likely destination, because the information genuinely suits one. The summary
line has an obvious value in an instance, "N BiS items drop here", which is the same lookup the
bonus roll verdict already does, so the data would come from `bisFrom()` and no new logic is
needed. Outside an instance it can show the count of BiS items you already own, which is the same
count the paper doll ticks.

Keep the standalone fallback whatever is decided. An addon that only works alongside another
private addon cannot be published, and publishing is now on the table.

## Comments

**2026-10-11** Clear-down (attended, Rob asked): ticked nothing new (#3 and #4 were already ticked; no criterion names a check). Looks rewritten for v0.69.0: #1 and #2 are now `proves: manual` looks, and the tooltip look from Tasks is added. The `.toc` still carries `## AddonCompartmentFunc: DjinnisClassProfiles_Toggle` and the LibDBIcon db is still `{ hide = false }` (`buildBroker`), so the restart answers which route works; the old route table under What I need from you is folded into look #2. Moves to ai-review/ with only in-game looks open.

### 2026-10-17 review (v20261017043854-1bf3)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I checked each acceptance criterion against the code. The code supports every criterion that is ticked. The open ones are in-game checks (`proves: manual`) for Rob to do.

- **#3 (depends on no other addon, open interface): met.** In `DjinnisClassProfiles.lua`, the function `buildBroker` makes a LibDataBroker "data source" with `NewDataObject`. LibDataBroker is the open standard that data text displays read. LibDBIcon then turns it into a minimap button. The four libraries are inside the addon, in `Libs\`, and `DjinnisClassProfiles.toc` lists them. The addon needs no other addon.
- **#4 (floating claw button gone): met.** `DjinnisBiSButton`, `buildButton` and `DjinnisBiSDB.button` are gone. The only button left is the LibDBIcon one.
- **#1 (button survives restart and `/reload`): manual.** The code can pass. Startup code calls `buildBroker`. The button's position saves in `DjinnisCPDB.minimap`. A click calls `DjinnisClassProfiles_Toggle`.
- **#2 (one drawer entry): manual.** `.toc` still has `## AddonCompartmentFunc: DjinnisClassProfiles_Toggle`. `buildBroker` does not set `showInCompartment`. So the restart will show which route works, as the card plans.
- **Tooltip look: manual.** The function `summaryLines` writes the title and "Click to open". In an instance, it also writes the green "N BiS items drop here" line. It gets that count from `bisFrom(GetInstanceInfo())`.

VERDICT: sound

**scope: sound**

**Scope review of card 0001: no scope defect found.**

**What the card asked for, and what the code does:**
- In `DjinnisClassProfiles.lua`, `buildBroker` registers a LibDataBroker "data source". It then hands that same object to LibDBIcon, which makes the minimap button. This is the route the card chose on 2026-08-20.
- `summaryLines` shows the "N BiS items drop here" line. It gets the count from `bisFrom()`, as the card's Plan said it should.
- The old floating claw button (`DjinnisBiSButton`) is gone. Criterion #4 holds.
- The addon loads only its own copies of the four libraries, and nothing in the code needs another Djinni addon. Criterion #3 holds.
- The code does not touch `DjinnisDataTexts`. That part of the "Not this card" fence holds.

**Over the fence?** The git diff is very large: 172 files and a full rename to Class Profiles. That is work from about 100 other cards, not this one. The code that belongs to this card stays inside its fence.

**Left half done (not a defect):**
- The Plan said that outside an instance, the tooltip shows how many BiS items you already own. `summaryLines` does not do this. It shows "Nothing BiS drops here" instead. No criterion asks for the owned count, so I name no criterion.
- The `.toc` still has `## AddonCompartmentFunc`. The minimap settings in `buildBroker` still have no `showInCompartment`. Criterion #2 says to keep it this way until a full restart shows the result, and #2 is a manual check that is only open.

**What you do now:** nothing until you play. Then try the three manual checks on the card (#1, #2 and the tooltip check).

VERDICT: sound

**breakage: defect**

I found one defect. The minimap tooltip cannot show "N BiS items drop here" inside the raid. So the tooltip look (the 5th criterion, which has no number) cannot pass.

**Defect: the tooltip asks the wrong question inside the raid**

- `summaryLines` in `DjinnisClassProfiles.lua` takes the zone name from `GetInstanceInfo()`. Inside the raid, that name is "The Venomous Abyss". It then sends that name to `bisFrom`.
- `bisFrom` checks the name against each item's boss name, such as "Ula'tek" or "Vashnik". It uses a loose text match in both directions.
- No item in the BiS list has "Venomous Abyss" as its boss. No raid boss name is part of "the venomous abyss" either.
- So inside the raid, `bisFrom` finds nothing. The tooltip then says "Nothing BiS drops here".
- The match only works in dungeons, where the boss text is the dungeon name, for example "Temple of Sethraliss".
- The old `/bis here` command and the end-of-key check have the same problem inside the raid. A boss kill still works, because it gives a boss name.

**Small, not counted against a criterion**

- The comment at the top of the minimap button section in `DjinnisClassProfiles.lua` says the button copies what "DjinnisClassProfiles already use". This addon now has that name, so the comment no longer makes sense.

**What I checked and found correct**

- The libraries load before the main file.
- `buildBroker` runs at login, after the saved data moves over.
- The `.toc` names the open function `DjinnisClassProfiles_Toggle`, and that global function exists.
- The old claw button and `DjinnisBiSDB.button` are gone.

UNMET: #5 inside The Venomous Abyss, summaryLines asks bisFrom about the raid's name, but bisFrom only matches boss names, so the tooltip says "Nothing BiS drops here" and never shows a green "N BiS items drop here" line.

VERDICT: defect

**acceptance**

- **#5 was named by the breakage lens and is not a ticked criterion here**, so nothing was changed: inside The Venomous Abyss, summaryLines asks bisFrom about the raid's name, but bisFrom only matches boss names, so the tooltip says "Nothing BiS drops here" and never shows a green "N BiS items drop here" line.

