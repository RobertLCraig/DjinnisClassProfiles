---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0009, 0011
---
# 0013 A "wrong setup here" popup before the pull

## Why

Rob plays four specs. The plan knows what each place wants: a loadout per boss (`0007`), gear and
enchants (`0005`), and raid or Mythic+ (`0009`). Nothing tells Rob when he walks into a place set up
wrong. He finds out in the pull, or in the log afterwards.

EnhanceQoL's "Wrong talents" popup (`TalentReminder.lua`, read 2026-09-22) and BtWLoadouts'
"activate this?" popup both do this job. EnhanceQoL shows the current build in red, the planned one
in green, and two buttons, Switch and Open Talents. BtWLoadouts waits while you are in combat and says
why ("Waiting for combat to end").

What it costs now: a pull in the wrong build is a lost pull, and Rob's parses show it (SecondBrain
output "2026-09-21 Raid DPS as Feral or Balance": the talent string in use simmed 22% under the plan).

## Links

- Needs `0011`: its Switch talents button is the popup's first button.
- Needs `0009`: which content the place is.
- Uses `0008`'s Equip all, and `0012`'s equipment set if it is built.
- Shares its "what is wrong" test with `0017`, the ready check list. Build one test, not two.

## Not this card

- Finding the boss from a nameplate, target or mouseover. `UnitGUID` is secret under 12.1's identity
  restriction. Map, subzone and `ENCOUNTER_END` only.
- Changing anything without a click.
- Anything inside a running key or a boss fight. 12.1 fences `ChallengeMode` and `Encounter`.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN the player enters a raid or dungeon the plan covers, or a ready check starts, and the loadout, a planned slot or an enchant differs from the plan, THE ADDON SHALL show one popup that names the place, what is planned and what is worn. proves: `popup names what differs from the plan here`
- [ ] WHEN nothing differs, THE ADDON SHALL show no popup. proves: `no popup when the setup matches`
- [ ] THE POPUP SHALL have Switch talents, Equip all and Open Plan buttons, and each is shown only when its part differs. proves: `popup buttons follow what differs`
- [ ] WHEN the player is in combat, in a running key or in a boss fight, THE ADDON SHALL not show the popup, and SHALL show it when that ends if the player is still in the place. proves: `popup waits for combat, keys and fights`
- [ ] WHEN the player closes the popup, THE ADDON SHALL not show it again in that place until the plan's answer for that place changes. proves: `a closed popup stays closed here`
<!-- AC:END -->

## Tasks

- [ ] One "what differs here" test, shared with `0017`.
- [ ] Triggers: `ZONE_CHANGED_NEW_AREA`, `ZONE_CHANGED` (subzone), `READY_CHECK`, `ENCOUNTER_END`
  (next boss). A short delay after a zone change, as EnhanceQoL does (2 seconds).
- [ ] Wait-and-retry on `PLAYER_REGEN_ENABLED` and `ADDON_RESTRICTION_STATE_CHANGED`.
- [ ] Offline checks under the names above.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md`. Check the restriction names in
`C:\Dev\WoWAddons\wow-ui-source` (`RestrictedActionsConstantsDocumentation.lua`,
`C_RestrictedActions.IsAddOnRestrictionActive`). For the next boss in a raid, the boss table from
`0007` plus the last `ENCOUNTER_END` is enough; do not build BtWLoadouts' subzone-to-boss table
unless the order of bosses is not fixed.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" (every idea gets a card) in a SecondBrain
  session, from other addons' UI. Ideation only. Nothing is built.
