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
- [x] WHEN a ready check starts, or the player opens the keystone slot, THE ADDON SHALL list what is missing: loadout, planned slots, enchants, gems, flask, food, augment rune, weapon oil. proves: `checklist lists what is missing`
- [x] WHEN nothing is missing, THE ADDON SHALL show nothing. proves: `no checklist when nothing is missing`
- [x] WHEN an aura cannot be read because it is secret, THE LINE SHALL say "cannot check" and not "missing". proves: `a secret aura is not reported missing`
- [x] EACH LINE SHALL click through to its fix where one exists: Switch talents, Equip, Search AH. proves: `checklist lines link to their fix`
<!-- AC:END -->

## Tasks

- [x] Find the aura and item ids for this season's flask, food buff, augment rune and weapon oil.
  Aura ids taken from EnhanceQoL's ClassBuffReminder (see `PlanTab.CONSUMABLES`); item names for
  the AH search of food and oil are still a `TODO Rob:` in that table.
- [x] The keystone slot open event in 12.1 (`CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN` or the
  current name). Check it in `wow-ui-source`. It is that name:
  `Blizzard_APIDocumentationGenerated/ChallengeModeInfoDocumentation.lua:359`.
- [x] Offline checks under the names above.

## What I need from you

Every one of these is a live-client look; nothing here can run a frame.

1. In the raid, start a ready check with no flask on. The 0013 popup should gain lines after the
   talents and gear ones: `Flask   missing` in red, and the same for food, rune and oil as they
   apply. Then flask up and ready-check again: the flask line goes.
2. Open the keystone slot in a dungeon (walk up to the font) with something missing: the same
   popup, without a ready check.
3. With everything on, the right talents and the right gear: a ready check shows nothing.
4. Click a `missing` consumable line with the auction house open: the search box fills with
   `Flask` or `Augment Rune` and searches. With it closed, one grey chat line says to open it.
   Food and oil have no click until you name their items in `PlanTab.CONSUMABLES`.
5. Click the talents line when it says `planned X, now Y`: the loadout loads (same as the button).
   Click a red gear line with the piece in your bags: it equips.
6. Whether any of the four reads `cannot check (12.1 hides this aura)` on a live client. If food
   does and the others do not, the Well Fed icon scan (`PlanTab.auraByIcon`) is what to look at.
7. Whether `CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN` registers: a refused one prints one line at
   login, "could not register CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN".
8. The popup's lines are now buttons: check the window still drags from its body, and that a
   line's tooltip shows to the right on hover.
9. The flask id list is EnhanceQoL's "TWW + Midnight" set. If your flask is on and the line still
   says missing, the season's flask aura is not in that list and needs adding.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" in a SecondBrain session. Ideation only.
  **Uncertain:** what 12.1 lets an addon read at a ready check.
- 2026-09-22 Claude (worktree agent): built on 0013's popup and its one `wrongHere` test, which
  takes a sixth argument `buffs`. `PlanTab.CONSUMABLES` holds the ids; `PlanTab.consumableState`
  answers on / missing / cannot check, asking `C_Secrets.ShouldSpellAuraBeSecret` before
  `C_UnitAuras.GetPlayerAuraBySpellID` and `issecretvalue` (through `PlanTab.canRead`) after. Food
  is found by the Well Fed icon over `GetAuraSlots` / `GetAuraDataBySlot` as EnhanceQoL does; oil by
  `C_PaperDollInfo.GetTemporaryEnchantmentInfo` because `GetWeaponEnchantInfo` is
  Blizzard_Deprecated-only in 12.1. Consumables join the popup only after a ready check or the
  keystone slot (`PlanTab.buffsWanted`), and leave it at a pull, a key start or a zone-in.
  Each popup line is now a button; `PlanTab.popup` takes an optional fifth `clicks` array, and
  0013's string lines and checks are untouched. One 0013 check changed on purpose: the closed key
  now carries the consumables, since a ready check asks for them. Six mutations on a temp copy each
  produced a FAIL line (buffsHere keeps what is on; READY_CHECK no longer asks; predicate ignored;
  issecretvalue ignored; lines get no click; keystone event dropped). Not done: item names for the
  food and oil AH search (nothing local names them), so those two lines have no click.
