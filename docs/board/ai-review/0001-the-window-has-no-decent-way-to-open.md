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
