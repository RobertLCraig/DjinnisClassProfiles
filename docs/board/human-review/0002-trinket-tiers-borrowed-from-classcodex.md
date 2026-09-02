# Trinket tiers borrowed from ClassCodex

## What I need from you

Ten minutes in a live client, with **ClassCodex still disabled**, which is how you have it today.
Open `/bis`, go to the **By Slot** tab, and work through the four spec buttons. Four things to
report:

1. Under the two columns there is a new **Trinket ranks** block. Does it list trinkets with a
   coloured letter beside each, and do the names resolve to real item links rather than `item
   249343`? A cold item cache shows bare ids on the very first open and is right on the second, so
   check twice before calling it broken.
2. Do the trinkets already on the BiS list carry a letter too, and does a tick appear next to any
   trinket you are actually wearing?
3. Run `/bis test`. It should end `[BiS] self-test passed`.
4. Then **re-enable ClassCodex and reload**. The Trinket ranks block must be replaced by a single
   grey line saying the ranks are off because ClassCodex is loaded, and every letter elsewhere in
   the window must be gone. Disable it again and they come back.

The fourth is the one worth doing carefully, because it is the thing you asked for and it is the
only part that cannot be checked from here.

## Why

You asked for the S/A/B/C trinket ranks that ClassCodex shows, inside this addon. The ranks exist as
plain data in ClassCodex's own `Data/db_ugg.lua` and `Data/db_icyveins.lua`, keyed by item id, one
list per spec, so the Druid rows were read out of those two files and generated into a
`TRINKET_TIER` table in `DjinnisBiS.lua`. Two sources, `u` for u.gg and `iv` for Icy Veins, which is
the same two-source-and-show-the-disagreement shape the BiS list above it already uses.

**This is a copy, and a copy of a moving thing goes stale.** ClassCodex re-ships its data every time
the sites move; this table cannot. That is the whole reason for the auto-disable rather than a
merge: when ClassCodex is loaded it wins outright and this addon draws no tiers at all. Two panels
of the same letters, one of them stale, is worse than one panel.

**The join is by item id, never by name.** The BiS list above is name-matched, which is an English
client only and was always marked as such. The tier table is id-keyed because that is how ClassCodex
stores it, and an id does not care about spelling or locale. A trinket only gets a letter once the
Encounter Journal harvest has given its name a link, and a link gives an id. A trinket with no
resolved link gets no letter, which is the correct outcome rather than a wrong one.

## Not this card

**Making the tiers refresh themselves.** They will not. Regenerating means re-reading those two
ClassCodex files, which is a person's job and a small one. Nothing here pretends otherwise, and the
comment above the table says so.

**Reading ClassCodex's data live instead of copying it.** That was considered and dropped. It would
be a runtime dependency on an addon you have disabled, which is a dependency on nothing, and it is
the same reasoning already written into `DjinnisBiS.lua` above `SLOT_INVENTORY` about
`DjinnisCharacterFrame`.

**Anything about ClassCodex's own bug.** See Direction; it is a finding, not work.

## Direction

**Your suspicion about ClassCodex and the action bars is well founded, and the addon's own author
already knows.** Two things found while reading it, neither of them fixable from here:

- It ships `Shared/ReduceTaint.lua`, whose functions are named `FixMultiActionBarTaint`,
  `FixMicroButtonTaint`, `FixOnHideTaint` and `FixCastbarTaint`. An addon does not write a file like
  that unless it has been tainting those exact frames.
- `Core/LoadoutDock.lua:189` calls `C_ClassTalents.LoadConfig` and `Shared/ImportExport.lua:527`
  calls `C_ClassTalents.CommitConfig`, both from insecure addon code. That is the classic route by
  which taint reaches the action bar update path, and the symptom is precisely the one you have:
  bars that stop updating once you are in combat.

`ReduceTaint.lua` is a set of workarounds, not a cure. Keeping ClassCodex disabled is a reasonable
call, and it is also why the borrowed tiers are worth having.

**DjinnisBiS itself is clear of that class of fault.** It never touches talents, action bars or any
secure frame; it creates plain frames, reads the Encounter Journal and adds a tooltip line. Checked
for the other conflicts too: the slash commands do not clash (`/bis` against `/cc` and
`/classcodex`), the globals are prefixed apart, and both addons adding an item tooltip post-call is
additive rather than a fight.

**The letters mean the same thing in both addons on purpose.** The five hex colours in `TIER_COLOUR`
are copied from ClassCodex's `Shared/GearingUtils.lua`, which are WoW's own item quality colours.
Do not "tidy" them to something else.

**One Icy Veins entry graded `F-` was dropped rather than given a colour.** It is a joke, not a
tier, and carrying it would have meant a sixth colour for one item.

## Acceptance

<!-- AC:BEGIN -->
- [x] #1 THE ADDON SHALL carry the u.gg and Icy Veins trinket tiers for all four druid specs, keyed
      by item id, with both sources kept where they disagree.
- [x] #2 WHEN ClassCodex is loaded, THE ADDON SHALL draw no tier of its own anywhere, and SHALL say
      why in place of the ranked list rather than going silently missing.
- [x] #3 THE ADDON SHALL survive an item id it has no tier for, a spec it has no table for, and a
      name whose link has not resolved, returning nothing in each case rather than throwing.
- [ ] #4 THE RANKED TRINKET LIST SHALL render in a live client with real item links, verified by a
      person, both with ClassCodex disabled and with it enabled.
<!-- AC:END -->

## Tasks

- [x] Read ClassCodex and find where the tiers actually live
- [x] Generate `TRINKET_TIER` from `db_ugg.lua` and `db_icyveins.lua`, dropping PvP contexts
- [x] Draw a letter on every trinket cell the By Slot tab already had
- [x] Add the ranked list of every rated trinket, best first, capped and saying what it cut
- [x] Suppress the lot when ClassCodex is loaded, and say so on screen
- [x] Extend `/bis test` to cover the tier table, the badge and the suppression
- [x] Check the two addons for slash, global and tooltip conflicts
- [ ] Run the four in-game checks at the top of this card

## Plan

Done, apart from the in-game pass. The build order was: read ClassCodex's data files, generate the
table, then wire it into the one tab that knows which spec you are looking at.

**Tab 1, By Boss, deliberately shows no tiers.** A tier is per spec, and that tab lists an item once
for every spec that wants it. There is no single letter to draw, so it draws none.

The three item-shaped cell builders had eight identical layout lines each; those are now one
`beginItemCell` call, which is why the diff is smaller than the feature. The new `setTierCell`
follows the same cold-cache pattern `setSimCell` already used, so an id the client has never seen
resolves on the next open instead of erroring.

`373` offline checks were run against the generated table and the tier helpers before deploying:
every letter has a colour and a rank, every entry rates at least one source, the badge collapses on
agreement and keeps both letters on disagreement, and the suppression returns nothing for every spec
once ClassCodex is loaded. **That proves the data and the pure logic and nothing else.** No frame in
this addon has been drawn outside a game client, which is what acceptance #4 is for.
