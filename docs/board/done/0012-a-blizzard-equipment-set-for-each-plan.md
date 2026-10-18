---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0008
---
# 0012 A Blizzard equipment set for each plan

## Why

After Equip all (`0008`) puts the planned gear on, nothing remembers it. To go back to it after a
key, a transmog try or a tank night, Rob has to open `/bis`, find the Plan tab and press Equip all
again. Rob plays four specs and, with `0009`, two contents, so there are up to eight setups to go
between.

AskMrRobot's addon saves a Blizzard Equipment Manager set, named after the setup, every time it
equips one (`Gear.lua`, `createAmrEquipmentSet`, read 2026-09-22; see the SecondBrain output
"2026-09-22 What DjinnisBiS can learn from AskMrRobot"). Blizzard then does three jobs for free:

- the item tooltip says "Equipment Sets: DBiS Feral Raid ST", so a bag item shows which plan wants it
- the character sheet's own equipment set list swaps the whole set in one click, and `/equipset`
  does it from a macro, with no `/bis` window
- bag addons that know about equipment sets can mark those items. Whether Baganator does needs
  checking; do not assume it

What it costs: a set can be saved only from what is worn (`C_EquipmentSet.CreateEquipmentSet` and
`SaveEquipmentSet` read the worn gear). So the set is saved right after a full Equip all works,
never before.

## Links

- Needs `0008`: its Equip all is the moment to save.
- Helps `0009`: a raid set and a Mythic+ set can share one item, and Blizzard already handles that.
- Helps a later junk list: "in no equipment set" is one of its tests.

## Not this card

- Swapping sets by itself on a spec change or on zone-in. That is a later card if Rob wants it.
- Deleting sets Rob made himself. The addon touches only sets whose name starts "DBiS ".

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN Equip all finishes with every planned slot worn, THE ADDON SHALL save a Blizzard equipment set named "DBiS <spec> <content> <scenario>", creating it or updating the one with that name. proves: `equip all saves the plan as an equipment set`
- [x] WHEN Equip all finishes with a planned slot not worn, THE ADDON SHALL save no set and say which slot is missing. proves: `no set is saved from a half-worn plan`
- [x] WHEN a set is saved, THE ADDON SHALL leave the shirt and tabard slots out of it. proves: `the set ignores shirt and tabard`
- [x] THE ADDON SHALL never change or delete an equipment set whose name does not start "DBiS ". proves: `sets Rob made are never touched`
- [x] WHEN the player is in combat, THE ADDON SHALL save no set. proves: `no set is saved in combat`
- [ ] On Feral with a planned piece in the bags, `/dcp`, Plan tab, Equip all: about two seconds later chat says "Saved as equipment set DBiS Feral ST" (ST, 2T, 3T or M+ follows the content choice). "No equipment set saved: not worn: <slot>" after a real full equip: press Save set and say so. proves: manual
- [ ] Open the equipment manager on the character sheet: the set is there with the Feral icon (not the default one), and shirt and tabard are ignored. proves: manual
- [ ] Hover a piece of the set: the tooltip says "Equipment Sets: DBiS Feral ST". proves: manual
- [ ] Press Equip all again: the same set is updated, and no second set appears. proves: manual
- [ ] Wear a piece that is not the plan, open the Plan tab: no Save set button, and the slot is listed under "2. Gear to change". proves: manual
- [ ] Tick a slot ignore on the paper doll, press Save set: note whether the tick stays drawn. If it does, that is the cosmetic mismatch in comment (7), a small card of its own, not a fail here. proves: manual
<!-- AC:END -->

## Tasks

- [x] Check `C_EquipmentSet` in `C:\Dev\WoWAddons\wow-ui-source` at 12.1: create, save, ignore
  slot, and whether any of them has restrictions.
- [x] Save after a full Equip all. One chat line: "Saved as equipment set DBiS Feral ST".
- [ ] Find out whether Baganator marks equipment set items, and whether that doubles up with the
  green bag glow from `0006`. If it does, say so on this card; do not change `0006` here.
- [x] Offline checks under the names above.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisBiS`. Read `docs/HANDOVER.md`, then the Equip all code from
`0008`. AMR's pattern, for reference only: `ClearIgnoredSlotsForSave`, `IgnoreSlotForSave(INVSLOT_BODY)`
and `(INVSLOT_TABARD)`, then `GetEquipmentSetID(name)`, then `SaveEquipmentSet(id, icon)` or
`CreateEquipmentSet(name, icon)`. Use the spec icon from `GetSpecializationInfo`.

## Comments

- 2026-09-22 Claude: written from Rob's "A" to the AskMrRobot ideas, in a SecondBrain session.
  Ideation only. Nothing is built.
- 2026-09-22 Claude, reviewing `0010`: this card was `0010` too. Two sessions allocated the same
  number the same night, and the lower-rank card had three commits under it by the time it was
  seen, so this one, unbuilt and referenced nowhere by number, took the next free one.
- 2026-09-22 Claude, built in a worktree. Everything sits in the `PlanTab` table, no new
  top-level local. `PlanTab.saveSet(spec, scenario)` is the whole thing: out of combat, plan
  present, gear readable, every planned piece on (`PlanTab.missingSlots`, which counts a wrong
  item and not a wrong enchant or gem), then `ClearIgnoredSlotsForSave`, ignore 4 and 19, and
  `SaveEquipmentSet` into the set of that name or `CreateEquipmentSet` with the spec icon. It
  refuses when the manager answers our name with a set that is not ours, and when Rob already
  has Blizzard's ten. `C_EquipmentSet` was read from `EquipmentManagerDocumentation.lua`: no
  secret predicate, no protected call, and `CanUseEquipmentSets` exists and is asked. Equip all
  calls it two seconds after its last pickup, because a pickup is a server round trip and the
  slots read stale until it lands. A `Save set` button sits under the gear list whenever every
  planned piece is on, so a set can be saved when the timer read too early or when there was
  nothing to equip. One chat line either way.
  **The name is "DBiS Feral ST", not "DBiS Feral Raid ST".** Blizzard's own name box caps at
  16 letters (`SharedUIPanelTemplates.xml`, `IconSelectorEditBox letters="16"`) and "DBiS
  Guardian Raid 2T" is 21. If the server cut it, the name would never be found again and a
  new set would be created on every Equip all. ST and 2T are raid cells, so "Raid" is implied;
  Mythic+ is "M+". "DBiS Guardian 2T" is exactly 16. A check holds every spec and scenario to
  16. If Rob wants "Raid" spelt out, it is one table.
  Checks: 47 new, under the names on the card plus the name cap, the ten-set cap and the tab
  as drawn offering Save set. Both `lua offline-check.lua` and Lua 5.1 exit 0. Five mutations
  in a temp copy each went red on its own check: half-worn guard removed, combat guard removed,
  tabard ignore removed, ownsSet guard removed, "Raid " put back into the name.
  What a person must look at, none of it seen in a client: (1) press Equip all with a piece in
  the bags and read the chat line two seconds later; is it "Saved as equipment set DBiS Feral
  ST", and does the set appear in the character sheet's equipment manager with the Feral icon
  and shirt and tabard greyed out; (2) hover a planned item in the bag, does the tooltip say
  "Equipment Sets: DBiS Feral ST"; (3) press Equip all again, is the same set updated and not
  a second one made; (4) if the chat line says "not worn: Finger" after a real full equip, the
  two seconds were short, press Save set, and say so on this card; (5) the icon is passed as a
  fileID number where the API says cstring, as Blizzard's own popup does; if the set gets the
  default icon, that is why; (6) `ClearIgnoredSlotsForSave` clears the paper doll's ignore
  ticks too, so if Rob had a slot ticked ignore in the manager it is unticked after a save.
  Left out: the Baganator question, because its source lives only under `C:\Games`, which this
  build does not read. Nothing here changes `0006`. The Equip all timer path has no offline
  check: `C_Timer` is a frame-side thing the stub does not have.
- 2026-09-22 Claude, adversarial review in a worktree. Pass, with two checks added. What was
  attacked: `PlanTab.saveSet`, `setName`, `ownsSet`, `missingSlots`, `saveSetAndSay`, the
  Equip all timer and the Save set row in `PlanTab.lines`, all read whole. Every
  `C_EquipmentSet` call was checked against `EquipmentManagerDocumentation.lua` on the local
  `wow-ui-source`: `CanUseEquipmentSets`, `ClearIgnoredSlotsForSave`, `IgnoreSlotForSave`,
  `GetEquipmentSetID`, `GetEquipmentSetInfo` (name is the first return, as the code reads it),
  `GetNumEquipmentSets`, `CreateEquipmentSet` and `SaveEquipmentSet` all exist with those
  arguments, none is marked secret-returning or protected, and `MAX_EQUIPMENT_SETS_PER_PLAYER`
  is 10 in `Blizzard_FrameXMLBase/Constants.lua`. The pcall of `GetSpecializationInfo` takes
  the fourth return, which the documentation names `icon`, a fileID, and Blizzard's own
  `GearManagerPopupFrameMixin:OkayButton_OnClick` passes the same fileID to
  `CreateEquipmentSet`, so the cstring in the documentation is not a worry. The spec is always
  the player's own: production draws `PlanTab.lines()` with no argument, so the icon and the
  name agree.
  Eleven mutations in a temp copy, each run against the offline check: the five the builder
  listed went red again, and so did the shirt ignore removed, the ten-set cap off by one, a
  save into the wrong id, create-always-never-save. Two survived: the Save set button offered
  on a half-worn plan (only the positive case was drawn) and `ClearIgnoredSlotsForSave`
  skipped (the stub started with nothing ignored, so a stale tick could not show). Both were
  gaps in the checks, not the code, and both are fixed in place: the stub now starts with Head
  ticked on the paper doll before the first save, so "4,19" can only pass if the clear ran,
  and the tab is drawn once more with Head off and must offer no Save set. Both mutations go
  red on the new checks. Both `lua offline-check.lua` and Lua 5.1 exit 0. No new top-level
  local.
  Security. Weakest point: the name is the key. A set Rob names "DBiS Feral ST" himself is
  taken as ours and saved over; the card's Not this card says exactly that, so it is the
  design, and the read-back of the name before the save is the only guard. Unchecked path:
  the two-second timer after Equip all runs `saveSet` afresh, which re-reads the worn gear and
  every guard, so a spec or scenario change inside those two seconds saves the plan captured
  at the click, never a mixed one; a refused equip leaves a slot off and the timer then says
  "not worn: Slot" rather than saving. Leaks: the chat line for a set that is not ours prints
  Blizzard's own set id, a small local number, and nothing else leaves the client.
  Not verified here and cannot be: everything under "What a person must look at" in the
  previous comment still stands, and one more: (7) with a slot ticked ignore on the paper doll
  the tick may stay drawn after our save while the manager no longer ignores it, until a set
  is selected in the pane, because `PaperDollFrame_ClearIgnoredSlots` is what clears the
  drawing and we call only the API under it.

**2026-09-29** Attended unblock pass. The ask said to deploy with `deploy.ps1 -Only DjinnisBiS`.
That folder is the rename stub since card `0058`, so the command would have deployed the stub and
not this addon. The ask now says `/reload`, because the game folder holds v0.54.12, and `/bis` is
`/dcp`. The set names and chat lines were checked against `PlanTab.setName` and `saveSet` and
still read as the steps say.

**2026-10-11** Clear-down (attended, Rob asked): ticked nothing new; the five `proves:` checks (`equip all saves the plan as an equipment set`, `no set is saved from a half-worn plan`, `the set ignores shirt and tabard`, `sets Rob made are never touched`, `no set is saved in combat`) were already ticked and still exist and pass in the Lua 5.1 offline check. Looks rewritten for v0.69.0: the set name is still `PlanTab.SET_PREFIX` "DBiS " plus ST/2T/3T/M+ (3T is new since card 0028), the chat lines and the Save set button read as the looks say. The Baganator task stays open; it is not a criterion. Moves to ai-review/ with only in-game looks open.

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

### 2026-10-18 review (v20261018064135-4c9b)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I tried to break all five code criteria. I could not break any of them. All the code is in `DjinnisClassProfiles.lua`.

- **#1 (save after a full Equip all):** `PlanTab.equipAll` waits two seconds, then calls `PlanTab.saveSetAndSay`. That calls `PlanTab.saveSet`, which uses `GetEquipmentSetID`. It then calls `SaveEquipmentSet` if the set exists, or `CreateEquipmentSet` if it does not. `PlanTab.setName` gives "DBiS <spec> <ST|2T|3T|M+>". The card's comments explain why "Raid" was dropped: Blizzard caps a set name at 16 letters. The M+ suffix still shows raid or Mythic+, and the manual steps use the same short names. So I count this as met.
- **#2 (no set from a half-worn plan):** `PlanTab.saveSet` gets the missing slots from `PlanTab.missingSlots`. If any are missing, it stops and says "not worn: <slots>".
- **#3 (shirt and tabard left out):** `PlanTab.saveSet` clears the old ignore ticks first (`ClearIgnoredSlotsForSave`). Then it ignores slots 4 and 19 (`IgnoreSlotForSave`).
- **#4 (Rob's own sets never touched):** The addon has no code that deletes or modifies a set. `PlanTab.saveSet` reads the set name back with `PlanTab.ownsSet` before it saves over a set. The other set call, `UseEquipmentSet`, only puts a set on. It does not change the set.
- **#5 (no save in combat):** `PlanTab.saveSet` stops at once if `InCombatLockdown()` is true.

The open criteria all say `proves: manual`. They are Rob's to try in the game. They are not findings.

VERDICT: sound

**scope: sound**

I found no scope defect in the card 0012 code. I only read the code. I changed nothing.

**What I checked**
- `PlanTab.saveSet` in `DjinnisClassProfiles.lua` does what the card asks, and nothing more:
  - It stops in combat.
  - It stops when a planned slot is not worn, and names the slot.
  - It clears the ignore ticks, then ignores slots 4 (shirt) and 19 (tabard).
  - It saves into the set with the same name, or makes a new set.
- `PlanTab.ownsSet` makes sure the code saves only over sets whose name starts "DBiS ".
- No card 0012 code calls `DeleteEquipmentSet` or `ModifyEquipmentSet`. Only the test stub has them, and the tests use them to prove they are never called.

**The "Not this card" fence**
- There is one `UseEquipmentSet` call, in the setup step code for card 0024 (the spec prompt when a group takes you). It runs only after a click. It does not swap sets by itself on a spec change or when you enter a zone. So it is not over the fence, and it is not card 0012 work.

**Half done**
- The Baganator task is still open. The card says it is not an acceptance item, so this is not a defect.
- The name is "DBiS Feral ST" and not "DBiS Feral Raid ST". The builder wrote down why: Blizzard's name box takes 16 letters at most. The first acceptance item uses the short form, so this is not a defect.

**The large diff**
- The big git diff (the addon rename, the other cards, the research files) is the whole branch. It is not card 0012 work. I did not count it against this card.

There are no `UNMET:` lines. Only the in-game `proves: manual` items are open, and nothing in the code stops them from passing.

VERDICT: sound

**breakage: sound**

I tried to break the equipment-set work for card 0012. I could not.

**What I checked:**

- **Combat guard.** `PlanTab.saveSet` stops in combat. It returns before it calls any `C_EquipmentSet` function.
- **Half-worn guard.** `PlanTab.saveSet` stops when `PlanTab.missingSlots` lists a slot. The chat line then names that slot through `PlanTab.saveSetAndSay`.
- **Shirt and tabard.** `PlanTab.saveSet` first clears the ignored slots. Then it ignores slots 4 and 19, before both the save path and the create path.
- **Rob's own sets.** `PlanTab.ownsSet` reads the set's name back before a save over it. A set with no "DBiS " prefix is never changed. No code path deletes a set.
- **Name.** `PlanTab.setName` gives "DBiS Feral ST". Criterion 1 says "<spec> <content> <scenario>". The builder dropped "Raid" on purpose, because Blizzard's name box takes only 16 letters. The card comment records this, and the manual criteria expect "DBiS Feral ST". This is a deviation the card accepts, so it is not a defect.
- **Callers.** `PlanTab.equipAll` serves both the Plan tab and the 0013 popup. It sends spec and scenario through `PlanTab.later`. The Save set button sends the same pair.
- **Rename.** The rename to DjinnisClassProfiles kept `SET_PREFIX` as "DBiS ". Sets saved before the rename are still found.

I found no stale comment and no caller that the change missed. The open criteria are all `proves: manual`, so they are not findings.

VERDICT: sound

