---
needs: 0048
---
# 0049 DjinnisBiS works on every class, not only druids

## Why

Rob, 2026-09-24: "Expand this to work for all classes (not just druids)". His characters include a
Death Knight, a Shaman, Hunters, Rogues, Monks and a Demon Hunter (from SavedInstances).

## What

- `SPEC_BY_ID` (`DjinnisBiS.lua`, near `playerSpec`) knows only 102 to 105. It becomes every
  spec, keyed by spec id. Spec names repeat across classes (Frost, Restoration, Holy), so the key
  must carry the class: for example `Frost DK` and `Frost Mage`, or the id itself. Druid names stay
  as they are, so saved data (`db().bars.Feral`, the loadout names) keeps working.
- Talents: the loadout list, the spare loadout, the Reset to plan flow and the boss reminder work
  for any spec that has stored builds (card `0050`).
- Bars: Save, Load, Undo, profiles and the preview already work per spec key. They must work under
  the new keys.
- Gear plan and boss rows stay druid-only until `0048` question 2 says otherwise. On another class
  they say so in one line, and do not error.
- `/djbis test` passes, with checks on a non-druid spec (for example 250 Blood).

## Acceptance

- [ ] WHEN a non-druid logs in, THE ADDON SHALL load with no error and offer its bar and talent features for that spec. proves: a new `offline-check.lua` run as spec 250
- [ ] WHEN a druid logs in, THE SAVED DATA SHALL still be found under the old keys. proves: the existing checks, unchanged
- [ ] Rob logs in on one alt and sees the list and the bar buttons. proves: manual
