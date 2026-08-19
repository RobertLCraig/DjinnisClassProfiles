# Release Notes

<!--
  This file is the PENDING release, not a record of the last one. The version
  heading below names the next tag; everything under it is copied verbatim into
  CHANGELOG.md when release.ps1 runs, and release.ps1 also rewrites the .toc to
  match this version.

  AFTER EVERY RELEASE: clear the body and bump the heading.

  This is not housekeeping, it is the trap that already bit its sibling. In
  DjinnisDataTexts the shipped notes were left here through a whole cycle, and a
  later release run picked up that stale version, rewrote a newer .toc backwards,
  and published the newer code to GitHub and CurseForge under the older tag. The
  habit that avoids a repeat is clearing this file in the same sitting as the
  release, not "next time". Shipped notes live in CHANGELOG.md, which is where
  release.ps1 has already put them, so nothing here needs preserving.

  Do NOT write a version heading inside a comment like this one. release.ps1
  extracts the version by regex BEFORE it strips comments, so the first match in
  the file wins even if it is commented out.
-->

## Version: 0.9.1

First packaged version. Not yet released anywhere.

Shows which of your four druid specs want a dropped item, in the moment the roll
timer is running.

- Raid warning and a sound on a group loot roll for a BiS item
- A BiS / Not BiS line on every gear tooltip
- A window with two tabs: by boss, and a character-sheet paper doll by slot
- Your equipped item shown above each BiS target, with a tick on ones you own
- A per item target item level, Champion / Hero / Myth ranks, saved per account
- A bonus roll verdict when a Mythic+ finishes and when a raid boss dies
- Raidbots Droptimizer import, read from the report's data.csv by item id

Item data covers Midnight Season 2, The Venomous Abyss.
