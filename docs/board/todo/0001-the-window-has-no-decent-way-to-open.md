# The window has no decent way to open

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

## The open question this card carries

Whether to depend on `DjinnisDataTexts` at all.

Making `DjinnisBiS` a data text module inside `DjinnisDataTexts` is the least code and the best
placement, but it couples an addon that might go to CurseForge to one that is already published,
and it means `DjinnisBiS` does nothing useful for anyone who does not run both. Registering from
`DjinnisBiS` into `DjinnisDataTexts` if present, and falling back to its own button if absent, is
more code but keeps the addon standalone. That is a call for Rob, not for an agent.

## Acceptance

<!-- AC:BEGIN -->
- [ ] #1 THE ADDON SHALL open its window from a control that survives a UI reload and a full client
      restart, verified in a live client rather than reasoned about.
- [ ] #2 WHEN the addon compartment entry is investigated, THE FINDING SHALL be written down: either
      the entry works and the earlier failure is explained, or the field is abandoned with a reason.
- [ ] #3 IF the data text route is chosen, THE ADDON SHALL still open its window when
      `DjinnisDataTexts` is absent or disabled.
- [ ] #4 THE FLOATING CLAW BUTTON SHALL either be removed or become an opt-in, not the only route.
<!-- AC:END -->

## Tasks

- [ ] Restart the client fully and record whether the compartment entry appears
- [ ] Find out what actually puts `DjinnisDelveTracker` and `DjinnisWarbandManager` in that drawer,
      given neither declares `AddonCompartmentFunc`
- [ ] Read how `DjinnisDataTexts` registers a module and what a module has to provide
- [ ] Put the standalone-versus-coupled question to Rob with the cost of each
- [ ] Build the chosen route
- [ ] Check it in a live client, both with and without `DjinnisDataTexts` enabled

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
