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

## Comments

**2026-10-14** Built in an attended session from Rob's screenshot. Not yet in a live client.
