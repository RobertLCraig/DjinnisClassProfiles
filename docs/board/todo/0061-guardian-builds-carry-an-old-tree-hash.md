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

## Done when

1. `python update-builds.py --check` passes, and no string in the BUILDS block has a non-zero hash.
2. In game, as Guardian: `/reload`, open the talent window. None of the three rows shows the warning.
   Double-click `Raid: Druid of the Claw`. The tree it shows is a Druid of the Claw raid tree.
