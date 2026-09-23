# 0033 Action bars the same on every character of the class

## Why

Rob, 2026-09-23: "I play multiple characters of the same class, and I want as much as possible to be
the same between them. especially actionbars and talents." TalentLoadoutsEx never saved action bars;
ImprovedTalentLoadouts did, and that is why he preferred it. `DjinnisClassProfiles` was his own
attempt and went dormant: "couldn't get it working properly the way I wanted".

## What

- One saved layout per class and spec, account-wide. Save it on one character, apply it on another.
- **Reuse the engine in `C:\Dev\WoWAddons\DjinnisClassProfiles\ActionBarProfiles.lua`**, not its UI:
  slot read and place, macros matched by name with the index as a hint, flyouts found through the
  spellbook, a backup before every apply and one-step undo. Its talent half targets
  `ClassTalentFrame`, the Dragonflight window, and is not carried over.
- Apply only out of combat and only on a click. A spell this character does not know is skipped
  and listed, not guessed.

- **Per spec by default, per build as an option** (Rob, 2026-09-23). A build may carry its own
  layout; when it does, switching to that build offers to apply it. A build without one uses the
  spec's layout. ImprovedTalentLoadouts tied bars to a loadout, which is the per-build half.

## Open, and Rob's to say

- ~~Keybindings too?~~ **Yes** (Rob, 2026-09-23). Built at v0.31.0, below.

## Built, v0.28.0, 2026-09-23

- New section in `DjinnisBiS.lua`, "Action bars the same on every character of the spec". The
  slot engine is `ActionBarProfiles.lua`'s core only: read slots 1 to 180, macros by name with the
  index as a hint, flyouts through the spellbook, pick up then place. No profiles UI, no MySlot
  import, no racial and profession hints.
- Every call checked against `wow-ui-source`: `HasAction`, `GetActionText`, the vehicle and
  override checks and `PickupSpellBookItem` are documented; `GetActionInfo`, `PickupAction`,
  `PlaceAction`, `PickupMacro`, `GetMacroInfo` and `GetNumMacros` are not, but Blizzard's own
  `Blizzard_ActionBar/Shared/ActionButton.lua` calls them. None carries a secret flag; each read
  goes through `canRead` anyway.
- Commands: `/djbis bars save` saves this spec's layout, `/djbis bars save build` saves it for the
  selected loadout, `/djbis bars` offers the layout that fits now, `/djbis bars undo` puts back the
  bars from before the last apply.
- Layouts sit in `DjinnisBiSDB.bars`, account-wide, keyed `Feral` or `Feral / Raid: Sszorak`.
  The undo sits in the new per-character `DjinnisBiSCharDB` (added to the `.toc`).
- The offer: 8 seconds after login and after every `TRAIT_CONFIG_UPDATED`, when the layout that fits
  now is not the one last offered, and it would change a slot. It waits while the prompt holds
  another question; the loadout offer (card 0031) waits the same way now.
- A slot whose action this character cannot pick up keeps what it has and is listed. A slot that
  is empty in the layout is emptied. Nothing runs in combat, with a vehicle bar up, or with
  something on the cursor.
- `/bis test`: `PlanTab.barChecks`, 24 checks on a model of the bars and the cursor with two
  druids. It caught one real fault before any client did: two empty slots did not count as the
  same, so every empty slot read as a change.

## Key bindings, v0.31.0, 2026-09-23

- A layout now holds the key bindings too, as key -> action, and save, apply, undo and the offer
  all carry them. The core is `DjinnisClassProfiles/KeybindingProfiles.lua`, cut down.
- Apply unbinds a key the layout does not name, binds a key it names to its action, and leaves the
  rest. A binding the game refuses (another addon's action this character lacks) is listed with
  the skipped slots. Then `SaveBindings(GetCurrentBindingSet())`, which writes to the set in use,
  account or character, as Blizzard's key binding window does.
- **If your bindings are account-wide, they are the same on every character already**, and the
  offer counts 0 keys.
- The binding calls are not in `Blizzard_APIDocumentationGenerated`; Blizzard's key binding window
  uses all of them. Each read goes through `canRead`.
- A layout saved before v0.31.0 has no keys and leaves them alone. Save it again to add them.
- `/bis test`: 7 more checks in `PlanTab.barChecks`, with a model of the binding table. Breaking the
  unbind step made 2 of them fail, so they run.

**Extra step for step 3 below:** after **Apply**, press a few keys. Pass: they fire the same
buttons as on the first druid.

## What I need from you

1. On the druid whose bars are right, as Feral: `/djbis bars save`.
2. Log in on another druid, as Feral. After about 8 seconds a prompt says how many slots would
   change. Pass: nothing moves before you click **Apply**.
3. Click **Apply**. Pass: the same spells sit in the same slots, a chat list names what was
   skipped (racials, macros that character lacks), and the skipped slots keep what they had.
4. Shift into cat, bear and moonkin form. Pass: the form bars match too.
5. `/djbis bars undo`. Pass: the old bars are back.
6. Apply again, then one pull on a dummy. Pass: no frozen button.
7. Optional: on one build, `/djbis bars save build`, then switch loadouts to it and away. Pass: its
   own layout is offered on the way in, the spec's on the way out.

## Acceptance

- [ ] WHEN Rob saves on one druid and applies on another, THE ADDON SHALL place every spell both know in the same slot, and SHALL list what it skipped.
- [ ] WHEN Rob switches to a build that has its own layout, THE ADDON SHALL offer that layout; WHEN it has none, THE ADDON SHALL use the spec's layout.
- [ ] WHEN a layout is applied, THE ADDON SHALL keep the previous layout for one undo.
- [ ] IN combat, THE ADDON SHALL refuse and say why.
- [ ] In a client: after an apply, one pull on a dummy with no frozen button. Writing slots from addon code is how MySlot works, but it is not yet proven clear of the fault in `0002`.
