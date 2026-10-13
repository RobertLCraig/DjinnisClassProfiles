# 0093 Ask to save the bars you have before a load replaces them

## What I need from you

One call before it is built (see "The case against"): build it as below, or leave it to Undo bars.
Then one in-game look: see Acceptance.

## Why

Rob, 2026-10-13: "consider asking if I want to save my current bar layout when switching to a new
one". Today every load (`PlanTab.applyBars`: the build-switch offer's Apply, Load bars, a profile,
premade bars) replaces the bars without a word about the ones it replaces.

## The case against

**Undo bars already keeps the old bars.** `applyBars` writes `DjinnisCPCharDB.barsUndo` and
`keysUndo` before it places anything, so nothing is lost on the first load. The gaps it leaves:

- It holds one step. A second load after a hand change writes over it (`barsAfter` check).
- It is per character and is not a layout: it cannot be loaded on another build or character.
- It is not offered again. Once Undo is used, or the next load lands, the hand-tuned bars are gone.

So the question earns its click only when the bars hold hand changes that no saved layout has. If
it asks on every switch it is noise, and Rob will learn to click past it.

## What to build

In `PlanTab.applyBars`, before `placeBars`:

1. **Are the bars saved?** They are when `readBars()` and `readKeys()` match `barsAfter` and
   `keysAfter` (nothing moved since the last load), or match any layout in `barsDB()` or
   `profilesDB()` for this spec (`sameBars` / `sameKeys`). Then load with no question, as now.
2. **If not, ask** through `PlanTab.prompt` (one frame; check `promptBusy()` as `saveBars` does):
   - Lines: "Your bars and keys now are not in any saved layout." and "Save them before the
     <key> layout replaces them?"
   - **Save, then load**: save to the layout the bars came from (`PlanTab.barsSeen`, the last key
     offered or loaded) when there is one, else ask for a profile name (`askProfileName`), then
     load. Say in chat where they went.
   - **Load anyway**: load as now. Undo bars still works.
   - **Cancel**: nothing changes.
3. The prompt can outlive the build it asked about, as the offer's can: re-check the key on click
   (same guard as `offerBars`' Apply).
4. A new `askSave` flag through `applyBars` so the self-test and Undo never ask.

Main chunk is at the 200-local ceiling: new helpers go on `PlanTab`. Checks go in
`PlanTab.barChecks` or a new `PlanTab.<name>Checks(check)`.

## Acceptance

<!-- AC:BEGIN -->
- [ ] A load straight after a load, with no hand change, does not ask. proves: `/dcp test`
- [ ] A load over bars that match a saved spec, build or profile layout does not ask. proves: `/dcp test`
- [ ] A load over hand-changed bars asks, and "Save, then load" writes the old bars to the key they came from before it loads. proves: `/dcp test`
- [ ] Move one spell by hand, switch build, click Apply on the offer: the question shows; "Save, then load" then loading the old build puts the moved spell back. proves: manual
<!-- AC:END -->
