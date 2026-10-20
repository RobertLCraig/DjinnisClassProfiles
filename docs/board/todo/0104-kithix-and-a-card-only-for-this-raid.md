---
---
# 0104 Kith'ix, and a setup card only for the raid you are in

## Why

Rob, 2026-10-14, the day 12.1.5 came out, in The Unbinding of Kith'ix: the setup card said
"The Unbinding of Kith'ix: Nek'zali" and offered the Nek'zali talents and trinkets. Then the talent
change failed twice with a bare `CONFIG_COMMIT_FAILED` line and no reason.

Two causes:

1. `PlanTab.rowHere` took every raid row for any raid. A raid the plan does not know started at the
   first row, Nek'zali.
2. `CONFIG_COMMIT_FAILED` carries only a config id. The game says why only in its red error text,
   `UI_ERROR_MESSAGE`, which the addon did not read. So the chat line could not say why.

## What changed

- Every raid row in `PlanTab.BOSSES` has `map`, the instance id (GetInstanceInfo's eighth return),
  copied from BigWigs' `BigWigs:NewBoss(name, map, journal)`: The Venomous Abyss 3004, Nymrissa's
  lair 2987, The Unbinding of Kith'ix 3095.
- `rowHere` takes the map and offers only that instance's rows. A raid with no rows, or a map that
  will not read, gives no row, so no card.
- A Kith'ix row (encounter 3513, from BigWigs_TheUnbindingOfKithix). Feral: `Raid: Vashnik`, `st`.
  Method's Feral page names the Vashnik build for a fight of stacked adds then a burn; Kith'ix has
  no build of its own yet. Balance: `Raid: Cleave`, `2t`, a guess.
- `CONFIG_COMMIT_FAILED` now names the game's red error text when one came within a second, either
  way round. A second refusal within two seconds prints nothing more (the screenshot had two
  identical lines).
- `offline-check.lua`: stubs `GetTime`, and `GetBuildInfo` now says 12.1.5 / 120105.

The offline check passes under Lua 5.1 except one line that was already failing: the DjinnisBiS stub's
`.toc` still says `Interface: 120100`. That stub is tracked by the workspace repo (card `0088`).

## Known trade-offs

- Nymrissa's row is in her own lair now. Before, after Ula'tek the Abyss card named her once; it no
  longer does, and in her lair the card names her.
- Kith'ix shares the `Raid: Vashnik` loadout. The next `wcl-builds.py` run pools Kith'ix logs into
  that row, and `update-builds.py` will first say the row's bosses changed and to run it again.
  When Kith'ix logs exist, a row of its own is one line and one loadout slot.
- Any red error within a second before the refusal is named as the reason, even if unrelated.
  Out of combat, standing at a raid boss, that is rare.

## Looks (proves: manual)

1. In The Unbinding of Kith'ix as Feral: the card says "The Unbinding of Kith'ix: Kith'ix" and
   names `Raid: Vashnik`, not Nek'zali.
2. In The Venomous Abyss: the card still starts at the next living boss, as before.
3. In any other raid (an old one, or a new one with no rows): no card.
4. Make a talent change fail (for example, click Talents while it is still applying): the chat line
   ends with "The game said: ..." or a second line "the game said why: ...".

## Acceptance
<!-- AC:BEGIN -->
- [ ] #1 THE CHANGE FOR 0104 SHALL contain only the map-scoped rows, `rowHere`, the `CONFIG_COMMIT_FAILED` reason and the offline-check stubs; the GEAR_PLAN regeneration, `aimLink`/TRACKS bonus ids and the full BUILDS regeneration SHALL be split out to their own cards. proves: `git diff` of the 0104 commit touches only those parts
<!-- AC:END -->

## Comments

**2026-10-14** Built in an attended session from Rob's screenshot. Not yet in a live client.

### 2026-10-20 review (v20261020190436-eb17)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I could not break any of the card's four checks. Each one traces to real code in `DjinnisClassProfiles.lua`.

1. **Kith'ix shows the right boss.** `PlanTab.BOSSES` has a Kith'ix row: id 3513, map 3095, loadout `Raid: Vashnik`. Every raid row now has a `map`. `PlanTab.rowHere` only keeps rows whose map matches. `PlanTab.bossHere` gets that map from `PlanTab.mapHere`, which reads the eighth value from `GetInstanceInfo`. The self-test checks that map 3095 gives Kith'ix with `Raid: Vashnik`.
2. **The Venomous Abyss works as before.** The 3004 rows keep their order. The kill and lockout skip logic did not change. The self-test checks Nek'zali first, then Entombed Sentinels after a kill.
3. **Any other raid shows no card.** An unknown map gives an empty list, so `rowHere` returns nil. A map that cannot be read gives nil too, so no card shows.
4. **A failed talent change says why.** The event watcher sends `UI_ERROR_MESSAGE` to `PlanTab.onUIError`. That function reads the second value, which is the message text. `PlanTab.onTalentEvent` adds "The game said: ..." when a red error came in the last second. If the error comes in the second after the failure, `onUIError` prints "the game said why: ..." on its own line. A second failure within two seconds prints nothing.

All four checks are `proves: manual`, so Rob must still try them in the game.

VERDICT: sound

**scope: defect**

Four of the card's changes are in the code: the `map` field on Kith'ix rows (`PlanTab.BOSSES`), `PlanTab.rowHere(..., map)`, the `UI_ERROR_MESSAGE` handler, and the stubs in `offline-check.lua`.

The change also carries a lot of work that card 0104 did not ask for:

1. **The gear plan is all new.** `GEAR_PLAN` in `DjinnisClassProfiles.lua` was replaced by a SimC droptimiser run from 2026-10-15, for all four Feral scenarios. The card says nothing about gear. This changes which items the addon tells the player to get.
2. **New item-level code from card 0105.** The `TRACKS` table now has `bonus` ids, and there is a new `PlanTab.aimLink` plus its self-test lines. That is the work of card 0105, "planned item shown at the worn level", and it shipped inside this card.
3. **Every class's builds were changed.** `PlanTab.BUILDS` was regenerated for every class and spec. Some talent strings changed (Feral Sszorak, Fury, Havoc, Windwalker and others), and a Feral Ula'tek row now comes from one Heroic log. The card names only one effect: Kith'ix pooled into the `Raid: Vashnik` row. It does not ask for a full re-run. `update-builds.py` and `docs/builds/*` changed with it.
4. **About 45 board cards moved or were rewritten.** None of them is card 0104.

So none of this extra work was reviewed against its own card. It cannot be reverted apart from the Kith'ix fix.

There is no way to tick a box for this. The card has no acceptance block, and its four checks are all manual.

ADD: THE CHANGE FOR 0104 SHALL contain only the map-scoped rows, `rowHere`, the `CONFIG_COMMIT_FAILED` reason and the offline-check stubs; the GEAR_PLAN regeneration, `aimLink`/TRACKS bonus ids and the full BUILDS regeneration SHALL be split out to their own cards. proves: `git diff` of the 0104 commit touches only those parts

VERDICT: defect

**breakage: sound**

I tried to break this work. I did not find a defect.

**What I checked:**

- `PlanTab.rowHere` and `PlanTab.bossHere`: only `bossHere` calls `rowHere`, and it now gives the map from `PlanTab.mapHere`. A raid with no rows gives nil. A map that will not read gives nil. A kill from a different raid does not move the row.
- The Mythic+ path in `rowHere` does not need a map, so dungeons still work.
- The row lists in `PlanTab.BOSSES`: Kith'ix is the last row, so the self-tests that use fixed row positions (`PlanTab.sidebarRows`, `PlanTab.bossFor`) still point at the same rows. Nymrissa now has map 2987, so the "after the last kill nothing" test in The Venomous Abyss stays true.
- The talent-failure lines: the event watcher gives `PlanTab.onUIError` the second argument, which is the message text. The code handles both orders:
  - Error text first, refusal after: `PlanTab.onTalentEvent` adds "The game said: ..." to the chat line.
  - Refusal first, error text after: a second line "the game said why: ..." comes out.
  - A second refusal within 2 seconds prints nothing.
- A secret message is never kept or compared.

The four "Looks" checks are `proves: manual`. Rob must try them in the game. They are not findings.

VERDICT: sound

**acceptance written**, because the card had none

- [ ] #1 THE CHANGE FOR 0104 SHALL contain only the map-scoped rows, `rowHere`, the `CONFIG_COMMIT_FAILED` reason and the offline-check stubs; the GEAR_PLAN regeneration, `aimLink`/TRACKS bonus ids and the full BUILDS regeneration SHALL be split out to their own cards. proves: `git diff` of the 0104 commit touches only those parts

