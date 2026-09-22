---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0013
---
# 0017 A ready check and pre-key checklist

## Why

At the 2026-09-21 Twin Fangs kill Rob had no augment rune, and the top player had one all fight
(SecondBrain output "2026-09-21 Raid DPS as Feral or Balance"). Missing enchants and gems are
already found for the glows (`0005`). Flask, food, rune and weapon oil are not checked anywhere.

EnhanceQoL's ClassBuffReminder checks flask, food, rune and weapon oil on `READY_CHECK`,
`CHALLENGE_MODE_START` and `ENCOUNTER_START`. It checks `C_Secrets.ShouldSpellAuraBeSecret` and
`issecretvalue` before it reads an aura (read 2026-09-22).

## Links

- Needs `0013`: the same "what differs here" test, and the same window if both show at once.
- Uses `0005` (enchants, gems), `0008` (Equip, Search AH) and `0014` (edited talents).

## Not this card

- Buying or using a consumable. Each line says what is missing and links to a fix.
- Anything in a running key or a boss fight.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN a ready check starts, or the player opens the keystone slot, THE ADDON SHALL list what is missing: loadout, planned slots, enchants, gems, flask, food, augment rune, weapon oil. proves: `checklist lists what is missing`
- [ ] WHEN nothing is missing, THE ADDON SHALL show nothing. proves: `no checklist when nothing is missing`
- [ ] WHEN an aura cannot be read because it is secret, THE LINE SHALL say "cannot check" and not "missing". proves: `a secret aura is not reported missing`
- [ ] EACH LINE SHALL click through to its fix where one exists: Switch talents, Equip, Search AH. proves: `checklist lines link to their fix`
<!-- AC:END -->

## Tasks

- [ ] Find the aura and item ids for this season's flask, food buff, augment rune and weapon oil.
- [ ] The keystone slot open event in 12.1 (`CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN` or the
  current name). Check it in `wow-ui-source`.
- [ ] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" in a SecondBrain session. Ideation only.
  **Uncertain:** what 12.1 lets an addon read at a ready check.
