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

- ~~Keybindings too?~~ **Yes** (Rob, 2026-09-23). Built at v0.32.0, below.

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

## Key bindings, v0.32.0, 2026-09-23

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
- A layout saved before v0.32.0 has no keys and leaves them alone. Save it again to add them.
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

## Comments

**2026-09-23, adversarial review (agent). Verdict: BOUNCE.**

**Attacked.** I read commits 99c0348, 198e102 and fa454ac. I checked each API claim against
`wow-ui-source` (live, 2026-09-18). I ran `lua offline-check.lua`, which was green. Then I ran 18
mutations on a temp copy.

**Held.** 15 of the 18 mutations turned a check red. They covered the combat and cursor fences, the
two-empties rule, macro by name, emptying a slot, the undo being written and used up, the build key,
the "seen" rule, unbinding, `SaveBindings`, the skip list, apply only on a click, and the probe
clearing the cursor. `GetActionText`, `HasAction`, `PickupSpell`, `PickupItem` and
`PickupSpellBookItem` have no secret returns. Flyout matching is right: `GetSpellBookItemType`'s
`actionID` is the flyoutID. `DjinnisBiSCharDB` is in the `.toc` and is only read at click time.

**Broke.**
1. **Character macros are never found.** `findMacro` (`DjinnisBiS.lua:6617-6620`) loops
   `1..account+character`. Character macros live at 121-150
   (`Blizzard_MacroUI.lua:240`, `macroBase = MAX_ACCOUNT_MACROS`). So a per-character macro is
   skipped as "no macro named X" when it exists. I proved it by modelling a macro at index 121 in the
   harness: 2 checks went red. The prior art (`ActionBarProfiles.lua:276`) has the same bug. Myslot
   (`Myslot.lua:451,460`) gets it right. Fix: loop `1..account`, then
   `MAX_ACCOUNT_MACROS+1 .. MAX_ACCOUNT_MACROS+character`. Add a check with a macro at 121.
2. **Key bindings ignore binding context.** `readKeys` (`:6703`) builds one key->action table
   across all contexts. `Bindings_Standard.xml:1637+` has housing-editor bindings in their own
   contexts, so they can share a key with a gameplay binding. The later entry wins, and the gameplay
   binding for that key drops out of the layout. `placeKeys` (`:6726,6730`) then calls `SetBinding`
   with no context. It could bind a housing command on a gameplay key, which kills that key in
   combat. Blizzard (`Blizzard_Keybindings.lua:164-167`) and Myslot (`:1292-1296`) both pass
   `C_KeyBindings.GetBindingContextForAction(action)`. Fix: skip any action whose context is not
   nil or `Enum.BindingContext.None`, or key the table by context and key and pass the context.

**Weaker, fix while there.**
- `BAR_SLOTS = 180` (`:6585`) also reads and writes pages 11-12 (slots 121-144). Those are not
  player bars. `MultiActionBars.xml` pages are 3-6 and 13-15, and `ActionButtonUtil.lua:189-229`
  treats the other pages as bonus, vehicle, override and temp-shapeshift bars. An empty slot there in
  the layout clears the other character's skyriding bar. Fix: skip 121-144.
- A second apply overwrites the undo (`:6791`). Apply the spec layout, then a build layout, and the
  original bars are gone. Fix: `barsUndo = barsUndo or readBars()`, and the same for keys.
- `keysDiffer` (`:6715`) counts a key the game refuses. So `/djbis bars` never says "already match"
  once one addon binding is missing.
- Three mutations survived: removing `ClearCursor` after `PlaceAction`, removing the vehicle and
  override fence, and ignoring `promptBusy` in `offerBars`. No check guards them.
- In a macro slot, `GetActionInfo`'s second return is the spell ID, not the macro index
  (`AssistedCombatManager.lua:148-150`). That makes the "index hint" wrong. It is harmless because
  the name decides.

**Security.**
1. Weakest point: the account-wide `DjinnisBiSDB.bars` is trusted as-is. If an edited or broken
   layout holds `keys = {}`, applying it unbinds every key, including ESCAPE and movement. It does
   so in the account binding set, so every character that shares the set loses them too. Undo
   repairs this only on the character where the layout was applied.
2. Unchecked: the saved key and action strings go to `SetBinding` without validation. There is no
   other way in. The slash command only offers; it never applies.
3. Leaks: nothing leaves the client. Failures print slot numbers and spell names to the local chat
   frame only.

**Not verifiable here.** There is no browser surface. The UI runs in a game client, which no agent
can run, so these need a person: the form bars at 73-120, whether spell-override IDs keep a slot
looking "changed", the grid flicker from up to 180 pick-ups in the automatic probe, and the
frozen-button test.

**2026-09-23** Builder, v0.33.0, commit `6d2fc63`. Both faults and all smaller issues fixed.
1. `findMacro` searches 1 to account, then 121 onward for character macros
   (`Constants.MacroConsts.MAX_ACCOUNT_MACROS`, 120 if absent).
2. Keys are read only for actions in the normal context (`C_KeyBindings.GetBindingContextForAction`
   0 or nil). `SetBinding` with no context writes that same context, so housing keys are never
   touched.
3. Slots 121-144 are never read or written (`PlanTab.barSlot`).
4. The undo is kept from before the first apply since the last undo.
5. A key the game refused this session is not counted again by the offer.
6. An empty key set is never saved and never placed.
New checks cover each one, plus ClearCursor after the swap, the vehicle fence and the busy-prompt
wait. Breaking each fix on a copy turned the checks red (10 of 10).

**2026-09-23** Re-review of the v0.33.0 fixes (agent). **BOUNCE.**

What I attacked: `6d2fc63`, with 14 mutations and one new scenario on a copy in `%TEMP%\rereview`.
I checked the API claims against `wow-ui-source`:
- `MacroConstantsDocumentation.lua` has `MAX_ACCOUNT_MACROS = 120`, and `Blizzard_MacroUI.lua:155`
  puts character macros at `macroBase` + i.
- `Enum.BindingContext.None = 0`, and housing is 1-8 (`KeyBindingsDocumentation.lua:192`).
- `MultiActionBars.xml` uses pages 3-6 and 13-15, so slots 145-180 are player bars.
- `SetBinding` is not in the generated docs. `Blizzard_Keybindings.lua:164` passes whatever
  `GetBindingContextForAction` returns, which is nil or None for a normal action. So leaving the
  context out is what Blizzard does for these actions.

What held: 13 of 14 breaks went red. They covered the macro loop, the context filter (including
letting context 1 through), slots 121-144, the "or" on both undos, the refused-key memory, and
the two empty-key guards. `keysRefused` is not saved, so a /reload clears it. An addon can only be
installed across a reload, so a key refused before the install is not ignored after it.

What broke:
1. **The undo can now throw away the player's own bar changes** (`DjinnisBiS.lua:6877`). The fix
   keeps the first undo until `/djbis bars undo`. It lives in `DjinnisBiSCharDB`, so it can be
   weeks old. Say the player applies a layout, then moves things by hand, then applies again, then
   undoes. They get back the bars from before the first apply, and the hand changes are gone.
   Before this fix they would have been kept. I proved it on the copy: put a spell in slot 9
   between the two applies in `barChecks`, and after the undo slot 9 is empty.
   **Fix:** at the end of `applyBars`, save `DjinnisBiSCharDB.barsAfter = PlanTab.readBars()`.
   On the next apply, keep the old undo only when every slot of `readBars()` still `sameAction`s
   `barsAfter`. Otherwise take a new one. Do the same for keys. Add the slot 9 case as a check.
2. Minor: `keysRefused` is keyed by the key alone (`:6792-6793`, `:6809`). Once Feral's layout has
   F refused, a Guardian layout that wants F for something else stops counting F for the rest of
   the session. **Fix:** store the action (`keysRefused[key] = action`) and skip a key only when
   `want[key] == PlanTab.keysRefused[key]`.

Security: an empty key set is now refused on save and on apply. A small but non-empty broken key
set can still unbind the rest. That was already noted, and it is still only the player's own saved
file.

Verdict: BOUNCE on finding 1.
