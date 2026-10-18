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
- [ ] `/reload` first (the game folder holds v0.69.0). In a raid with no flask on, start a ready check: the wrong-setup popup lists `Flask   missing` in red after the talents and gear lines, plus `Food`, `Augment rune`, `Weapon oil` as they apply. Flask up and ready-check again: the Flask line goes. If your flask is on and the line still says missing, its aura is not among the ids in `PlanTab.CONSUMABLES` (432021, 431971-431974, 1235057, 1235108, 1235110, 1235111) and must be added. proves: manual
- [ ] In a dungeon with something missing, open the keystone slot at the font: the same popup shows with no ready check. proves: manual
- [ ] With the planned talents, the planned gear and all four consumables on (any flask above; any Well Fed food buff, found by its icon 136000; an augment rune, aura 1295329, 1264426 Void-Touched, 1234969, 1242347, 453250, 393438 or 347901; any oil on the main hand, slot 16): a ready check shows nothing. proves: manual
- [ ] With the auction house open, click a red `Flask   missing` line: the search runs for `Flask`; click `Augment rune   missing`: it runs for `Augment Rune`; click `Food   missing`: it runs for `Harandar Celebration`; click `Weapon oil   missing`: it runs for `Thalassian Phoenix Oil`. With the house closed: one grey line `Open the auction house first, then click Search AH.` If a search finds nothing because the item has another name this season, say which. proves: manual
- [ ] Click the popup's talents line when it reads `planned X, now Y`: the loadout loads. Click a red gear line with the planned piece in your bags: it equips. proves: manual
- [ ] On a live client none of the four consumable lines reads `cannot check (12.1 hides this aura)`. If only Food does, `PlanTab.auraByIcon` is the place to look. proves: manual
- [ ] At login no line says `could not register CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN`. proves: manual
- [ ] The popup still drags from its body, and hovering a line shows its tooltip to the right. proves: manual
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

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

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

**2026-10-11** Clear-down (attended, Rob asked): ticked 4 criteria, all ticked already and confirmed (checks `checklist lists what is missing`; `no checklist when nothing is missing`; `a secret aura is not reported missing`; `checklist lines link to their fix` exist in `DjinnisClassProfiles.lua` and pass in the Lua 5.1 offline check); looks rewritten for v0.69.0 with the real ids from `PlanTab.CONSUMABLES`: the flask and rune lines search `Flask` and `Augment Rune` and are matched by the aura ids now written into the looks; food is matched by the Well Fed icon 136000 and oil by the main-hand temporary enchant, neither by an item. The code names no food or oil item, so those two lines still have no click (the `TODO Rob:` above `PlanTab.CONSUMABLES` stands); naming them needs `search = "<item name>"` on the Food and Weapon oil entries, a code change not made here. Old look 9 folded into look 1; moves to ai-review/ with only in-game looks open.

**2026-10-11** Agent first, done (same clear-down). The food and oil are now named in `PlanTab.CONSUMABLES` on branch `cleardown/djcp` (`6e2edb8`): Food searches "Harandar Celebration" and Weapon oil "Thalassian Phoenix Oil", the two SimC's own Season 2 Feral profile uses (`C:\Dev\WoWAddons\3rdParty\simc\profiles\MID2\MID2_Druid_Feral.simc`, `food=harandar_celebration`, `temporary_enchant=main_hand:thalassian_phoenix_oil_2`). Source of the choice, applied rather than asked: SimC's default consumables are the ones its maintainers sim the spec with. The `TODO Rob:` is gone, and a new check, "checklist lines link to their fix, every consumable names what to search for", fails if a line is left with no search. The entry above saying those two lines have no click is out of date; the AH look now covers all four.

### 2026-10-18 review (v20261018142112-7eaa)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I tried to break the four ticked criteria. I could not. Each one maps to real code in `DjinnisClassProfiles.lua`, and each has a check of its own in the self-test.

- **#1 The list shows what is missing.** `PlanTab.onSetupEvent` starts the list on `READY_CHECK` and on `CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN`. The keystone event is in `PlanTab.SETUP_EVENTS`. `PlanTab.checkSetup` gives `PlanTab.wrongHere` the loadout, the gear plan, the worn gear and `PlanTab.buffsHere()`. `PlanTab.setupPopup` writes the talents, slot, enchant, gem and consumable lines.
- **#2 Nothing missing shows nothing.** When `wrongHere` finds nothing, `checkSetup` calls `PlanTab.hideSetup` and returns "matches".
- **#3 A secret aura is not called missing.** `PlanTab.auraById`, `PlanTab.auraByIcon` and `PlanTab.consumableState` ask `C_Secrets` before each read and `PlanTab.canRead` after it. A secret read, or a missing API, gives "cannot check". `setupPopup` prints that line in grey, never as "missing".
- **#4 Each line clicks through to its fix.** In `setupPopup`, the talents line loads the loadout. A gear line in your bags equips it. A missing consumable line runs `PlanTab.searchClick(b.search)`. All four entries in `PlanTab.CONSUMABLES` now name a search term. The "cannot check" lines have no click. That is correct, because nothing is known to be missing.

The open criteria (#5 to #12) are `proves: manual`. They are not findings. Rob tries them in the game.

VERDICT: sound

**scope: sound**

I found no scope problem in the 0017 work.

**What I checked:**
- **The "Not this card" fence (no buying or using a consumable):** `PlanTab.CONSUMABLES` in `DjinnisClassProfiles.lua` gives each line only a `search` string. I searched the file for calls that buy, post or use an item. None of them are in the checklist code. The only `C_Item.PickupItem` call is in the action bar code, which is a different card.
- **Running keys and boss fights:** The comments on the card say `PlanTab.buffsWanted` drops the consumable lines at a pull, at a key start and at a zone-in. That keeps the work out of the second fenced area.
- **0013's popup:** The builder changed one 0013 check, and said so on the card. A ready check is meant to ask for consumables, so this change is in the card's scope. It is not hidden growth.
- **Food and oil names:** The builder picked these instead of asking Rob. They came from SimC's own Season 2 Feral profile (SimC is the simulator the gear plan uses). This finishes the last open task on the card and does not go past it. A check now fails if any line has no search.
- **The big diff:** About 160 files changed. That is the whole branch history, with many other cards on it. It is not 0017 growing. Nothing in it does work this card fenced out.

**Nothing left half done:** All three tasks on the card are ticked and done. The open criteria are all `proves: manual`, which means Rob tries them in the game. I found nothing that stops any of them passing.

No criterion was disproved, so there are no `UNMET:` lines.

VERDICT: sound

**breakage: sound**

I tried to break this card's code and found nothing broken.

**What I checked** (all in `DjinnisClassProfiles.lua`):

- **`PlanTab.CONSUMABLES`**: all four lines now carry a `search` term. So every consumable line has a click. The old comment says "A line with no `search` has no click". That is still true as a general rule.
- **`PlanTab.auraById` and `PlanTab.consumableState`**: before a read, the code asks `C_Secrets.ShouldSpellAuraBeSecret`. After the read, it checks `canRead`. A secret read gives "cannot check". It never gives "missing". This meets criterion #3.
- **`PlanTab.auraByIcon`**: a secret aura slot gives "cannot check", not "missing".
- **Weapon oil**: `C_PaperDollInfo.GetTemporaryEnchantmentInfo` gives nothing when no oil is on. Blizzard's own docs (`PaperDollInfoDocumentation.lua`) say this. So `info and "on" or "missing"` is correct.
- **`PlanTab.onSetupEvent`**: `READY_CHECK` and `CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN` both set `buffsWanted`. A pull, a key start or a zone-in clears it. The event is in `PlanTab.SETUP_EVENTS`.
- **The offline checks**: they test the keystone event and the search term on every consumable.

I found no caller that the change missed. I found no comment that the change made false. The criteria still open are all `proves: manual`, so they are for you to try in the game. They are not findings.

**What you do now:** nothing. On this verdict the card goes to `done/`. The in-game checks wait there for you.

VERDICT: sound

