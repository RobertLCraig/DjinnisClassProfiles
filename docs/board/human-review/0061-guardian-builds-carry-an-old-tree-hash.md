# 0061 Three Guardian builds will not load: they carry an old tree hash

## Why

Rob, 2026-09-24, screenshot of the Guardian sidebar: `Raid: Druid of the Claw` shows "Error: The
loadout you are trying to import is out of date". `Raid: Elune's Chosen` and `Dungeon: survive more`
carry the same warning triangle. `Dungeon` does not.

## What was checked

- The message is `LOADOUT_ERROR_TREE_CHANGED`, from `PlanTab.buildProblem`
  (`DjinnisClassProfiles.lua` line 6311). It mirrors Blizzard's import check,
  `Blizzard_ClassTalentImportExport.lua` lines 214 to 217: a string whose tree hash is not empty must
  equal `C_Traits.GetTreeHash`, or the import is refused.
- The three failing strings start `CgGA8cL7tpvige+kkmGM9zUPWD`. After the 4-character version and
  spec header, that is a non-zero 128-bit tree hash. The working Guardian `Dungeon` (Archon, pinned)
  starts `CgGAAAAAAAAA...`: an empty hash, so the check is skipped. Every Feral string is empty-hash
  too, which is why Feral never shows this.
- The three are the Dreamgrove Guardian compendium strings (`update-builds.py`), copied as written.
  `update-builds.py` has no hash handling (no match for "hash" in the file).

## The choice

1. **Zero the hash in `update-builds.py` for every string it writes.** One line in the writer. Safe
   only because the script already decodes each build against today's Raidbots tree and refuses one
   that does not spend 34 / 34 / 13. A build that passes that check is readable on today's tree.
2. **Leave the hash, and replace the three strings** when Dreamgrove re-exports. Correct by
   construction, but waits on someone else.

Recommend 1. It is the same state every working string is already in.

Risk with 1: the hash exists to catch a tree whose node order moved. The point-count check catches
most of that, not all. A build that spends the right points on the wrong nodes would pass. Rob sees
it on the tree in step 2 below.

## Recheck, 2026-09-25: the hash is the smaller problem

Rob: "recheck guardian talent builds". Rob's Guardian SimC export (`2026-09-24 Guardian v1.txt`)
decoded, then compared with the top 10 Guardians by Warcraft Logs rank on Altar of Fangs, Temple
of Sethraliss, Mythic Sszorak and Mythic Vashnik (40 players). Swipe, Frenzied Regeneration,
Verdant Heart and Boundless Moonlight are left out below: every loadout "lacks" them, so they are
free nodes the comparison miscounts.

- **All 40 play Elune's Chosen.** None play Druid of the Claw, in raid or in dungeons.
- `Dungeon` (Archon, pinned) matches the top players exactly. Keep it.
- `Raid: Druid of the Claw` is Druid of the Claw: 0 of 20 raid Guardians play it. It is the
  same build as Rob's own `DotC Raid`.
- `Raid: Elune's Chosen` is the right hero tree but takes Convoke (2 of 20) where 18 of 20 take
  Incarnation: Guardian of Ursoc, and skips Ursoc's Guidance (20 of 20), Gory Fur (19), Elune's
  Grace (17), Natural Recovery (17) and Improved Stampeding Roar (16).
- `Dungeon: survive more` is Druid of the Claw: 0 of 20 dungeon Guardians play it.

So option 1 above (zero the hash) would load builds nobody at the top plays. **Option 2 is the
answer, with a different source**: replace the three strings with the builds top players run,
the way `Dungeon` already is (card `0047`). Uncertain: Warcraft Logs ranks tanks by damage, which
may favour an offensive build over a safe one.

## Done when

1. `python update-builds.py --check` passes, and no string in the BUILDS block has a non-zero hash.
2. In game, as Guardian: `/reload`, open the talent window. None of the three rows shows the warning.
   Double-click `Raid: Druid of the Claw`. The tree it shows is a Druid of the Claw raid tree.

## Comments

### 2026-09-25: two of the three are gone (card 0064, v0.49.0)

Guardian's two raid rows became one `Raid`, the Warcraft Logs typical build (zero hash). `Dungeon`
is the logs' typical too. What is left, with a non-zero hash: Guardian `Dungeon: survive more`, and
Resto `Dungeon: cat damage` and `Dungeon: caster damage` (Dreamgrove M+ variants). No top player in
the 0064 sample runs any of the three exactly. The choice for Rob is the one above, narrowed:

1. **Zero the hash** on Dreamgrove strings in `update-builds.py`, so the three load.
2. **Drop the three rows**, leaving each spec its `Dungeon`. That frees 3 slots.

Recommend 2: the logs say nobody at the top plays them, and slots are short on druids.
