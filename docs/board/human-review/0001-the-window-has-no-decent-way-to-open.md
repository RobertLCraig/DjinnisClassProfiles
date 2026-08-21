# The window has no decent way to open

## What I need from you

Five minutes in a live client. Nothing left on this card can be settled from the repository or from
research: the code is written, and the only remaining question is whether Blizzard's UI actually
shows the control, which only a running client answers. Do a **full client restart**, not a
`/reload`, then report three things. Does *Djinni's BiS* appear in the minimap addon drawer. Does
the minimap button appear on the ring. Does hovering it show the summary tooltip.

One of the open tasks no longer needs chasing, because the answer is in this repository.
`Libs\LibDBIcon-1.0\LibDBIcon-1.0.lua:508-526` calls `AddonCompartmentFrame:RegisterAddon(...)`
whenever a button's saved settings carry `showInCompartment = true`. That is what puts
`DjinnisDelveTracker` and `DjinnisWarbandManager` in the drawer with no `AddonCompartmentFunc` line
anywhere: the library registers them at runtime, the `.toc` never comes into it. Their own files sit
outside this sandbox, so that last step is read off the shared library rather than off their code.

Which leaves this addon on the single route that has already failed once:

| Route into the drawer | Where it lives | On in DjinnisBiS today |
|---|---|---|
| `## AddonCompartmentFunc: DjinnisBiS_Toggle` | `DjinnisBiS.toc:7` | yes, and it is the only one |
| `showInCompartment = true` in the LibDBIcon db | `DjinnisBiS.lua:1143` | **no**, the table is `{ hide = false }` |
| Minimap ring button (not the drawer) | `DjinnisBiS.lua:1144` | yes |

Both compartment routes on together would almost certainly show two *Djinni's BiS* entries, so it is
one or the other. My reading is that the `.toc` field is sound and only ever needed the restart, but
the sibling addons prove the library route works in your client and it costs one word to switch to
it. If the restart shows no drawer entry, take the library route and drop the `.toc` field.

That last bit is a choice, not a build, and it is the only choice left on the card. It is left
inline rather than split into its own decision card, because the observation comes first and may
settle it without anyone having to choose. Split it if you would rather decide it separately.

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
- [ ] #1 THE ADDON SHALL open its window from a control that survives a UI reload and a full client
      restart, verified in a live client rather than reasoned about.
- [ ] #2 WHEN the addon compartment entry is investigated, THE FINDING SHALL be written down: either
      the entry works and the earlier failure is explained, or the field is abandoned with a reason.
- [x] #3 THE ADDON SHALL depend on no other addon, and SHALL expose its summary through an open
      interface rather than a private one.
- [x] #4 THE FLOATING CLAW BUTTON SHALL either be removed or become an opt-in, not the only route.
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
