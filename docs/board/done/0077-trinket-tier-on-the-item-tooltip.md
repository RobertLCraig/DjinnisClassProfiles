# Trinket tier on the item tooltip

## Why
Rob, 2026-09-30: ClassCodex put a trinket's tier on its tooltip. With ClassCodex off, that line is
gone. Card `0002` brought the tiers into this addon, but only into the window (By Slot tab and the
ranked list), not onto the tooltip where a loot roll or a bag is read.

## What was built (v0.57.0)
`PlanTab.tierLine(spec, id, name)` gives one line, `Trinket tier: Feral S  Guardian A/S ...`: every
druid spec that rates the trinket, your own spec first. `u.gg/Icy Veins` when they disagree, as in
the window. The item tooltip hook adds it on a druid (`gearHere`). It stands aside when ClassCodex is
loaded, through `tiersFor`, so the line is not doubled.

Checks in `selfTest`: your spec comes first, an unrated trinket adds nothing. Broken on purpose once
(spec-first removed) and the check failed.

The tiers are still the 2026-09-02 ClassCodex read. To refresh, see the HANDOVER (`update-classcodex-data.ps1`).

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Acceptance
<!-- AC:BEGIN -->
- [x] #1 WHEN a druid hovers a rated trinket, IT SHALL add one tier line, own spec first. proves: `selfTest` tier line checks
- [x] #2 WHEN the trinket is unrated, IT SHALL add nothing. proves: `selfTest`
- [ ] #3 On a druid with ClassCodex off, after `/reload`, hover Voracious Heart of Ula'tek: the tooltip has one `Trinket tier:` line naming your own spec first. proves: manual
<!-- AC:END -->

## Comments

**2026-10-11** Clear-down (attended, Rob asked): ticked nothing new: #1 and #2 were already ticked, and their checks (`tooltip tier line, your spec first`, which uses this very trinket, id 270175, and `tooltip tier line, unrated says nothing`) exist and pass in the Lua 5.1 offline check. #3 said `proves: none`; it is a look, so it now says `proves: manual`, rewritten for v0.69.0. Moves to ai-review/ with only the in-game look open.

### 2026-10-20 review (v20261020155414-3773)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I checked the tier line code against the card's three criteria. Nothing in the code breaks it.

**#1 (a rated trinket gets one tier line, own spec first): met.**
- `PlanTab.tierLine` in `DjinnisClassProfiles.lua` builds the line.
- It adds your own spec first, then the other druid specs.
- It returns one `Trinket tier:` string.
- The item tooltip hook adds it one time, and only on a druid (`gear and PlanTab.tierLine(playerSpec(), id, name)`).
- The `selfTest` check `tooltip tier line, your spec first` uses item 270175. It tests that Guardian comes before Feral when Guardian is your spec.
- If either spec is missing from the line, the check fails. So the check is strong enough.

**#2 (an unrated trinket adds nothing): met.**
- `PlanTab.tierLine` returns `nil` when no spec rates the item.
- The hook adds a line only when the result is not `nil`.
- The `selfTest` check `tooltip tier line, unrated says nothing` tests this.

**#3 (manual):** this is open, and the owner must try it in the game. The code does not stop it from passing. The ClassCodex stand-aside goes through `tiersFor`, as the card says.

I could not run `selfTest`. The project has no suite that I can run here.

VERDICT: sound

**scope: sound**

**What I checked:** I read the code to see if this card did more than it asked, or left work half done.

**Findings:**

- The card's own code is in place. `PlanTab.tierLine` exists. The tooltip hook calls it only when `gear` is set. The two `selfTest` checks are there: `tooltip tier line, your spec first` uses item 270175, and `tooltip tier line, unrated says nothing`.
- The diff is big: 130 files. It has a new gear plan, new builds, crafted reagents, rank data, research files and moves for many cards. These changes are not this card's work. The diff covers a range of commits from many sessions. This card's own change is the 8 lines in its card file, from the 2026-10-11 clear-down.
- The card has no "Not this card" fence, so nothing crossed one.
- Nothing is half done. Only #3 is open, and it is `proves: manual`. That is Rob's in-game check, not a finding.

**What you do now:** Nothing. The card can go to `done/`. Rob does the in-game check (#3) later.

VERDICT: sound

**breakage: sound**

I tried to break the trinket tier line. I found no defect.

- `PlanTab.tierLine` in `DjinnisClassProfiles.lua` puts your own spec first. Then it adds the other druid specs. It gives nothing (nil) when no spec rates the trinket.
- When ClassCodex is loaded, `tiersForId` and `tiersFor` give nil. So the tooltip does not show the line twice.
- The tooltip hook adds the line only on a druid, through `gearHere`. It skips items that you cannot equip.
- The spec names agree everywhere: `Balance`, `Feral`, `Guardian` and `Resto` are the same in `TRINKET_TIER`, `BIS` and the loop.
- `selfTest` uses item 270175, Voracious Heart of Ula'tek. Two specs rate it: Feral (`u=C`, `iv=S`) and Guardian (`iv=S`). So the "your spec first" check can really fail. It does not pass by accident.
- The new gear plan still lists 270175, so the in-game look (#3) can still pass.
- This large change does not touch the tier code or the code that calls it.

Criterion #3 is a manual look. It is still open, and that is correct. It is not a finding.

VERDICT: sound

