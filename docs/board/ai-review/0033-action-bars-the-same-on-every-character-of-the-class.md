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

**2026-09-23** Builder, v0.33.1, commit `487ed86`. Both findings fixed.
1. `applyBars` saves `barsAfter` and `keysAfter` once it is done. The next apply keeps the old
   undo only while the bars and keys still match them; otherwise it takes a new undo. Undo clears
   both. New check: apply, a spell put in slot 9 by hand, apply, undo, and slot 9 holds that spell.
   It goes red when the match test is removed.
2. `keysRefused` maps key -> the refused action, and only that pair is skipped. New check:
   another action wanted on the refused key still counts 1.

**2026-09-23** Third review (agent). **BOUNCE.**

What I attacked: `487ed86` (`sameBars`, `sameKeys`, `applyBars`, `undoBars`, `keysDiffer`,
`placeKeys`) on a copy in `%TEMP%\rereview33`, under Lua 5.1. I ran 12 mutations and 5 new order
scenarios, each added to `barChecks` on the copy:
- S1: a layout with no keys, then one with keys, then undo.
- S2: apply, a `/reload` (a deep copy of `DjinnisBiSCharDB` and a cleared `keysRefused`), apply,
  undo.
- S3: apply, undo, apply, undo.
- S4: apply, a key bound by hand, apply, undo.
- S5: a layout with keys, then one with none, then undo.

What held:
- S2 to S5 pass. The undo survives a `/reload`: `barsAfter` and `keysAfter` are plain tables of
  strings and numbers, and `sameAction` compares by type and id or macro name, never by table
  identity.
- `keysAfter` is always written together with `barsAfter`, and `readKeys` always returns a table.
  So `c.keysAfter or {}` can only matter in a hand-edited file, and there it takes a fresh undo,
  which is the safe side.
- `DjinnisBiSCharDB` is read only at click time, so the ADDON_LOADED rule in `DECISIONS.md` is met.
- `keysRefused` is right: a refused key and action pair is skipped in both loops, and any other
  action on that key still counts.
- The cost is small. An apply now reads the keys twice and the bars three times, about 3 x
  `GetNumBindings` calls to `GetBindingContextForAction`, once, on a click.
- 8 of 12 mutations went red: always taking a fresh undo, dropping `sameBars`, not writing
  `barsAfter`, taking `keysAfter` from before the apply, `keysRefused[key] = true`, the key-only
  want loop, and going back to the `6d2fc63` rule.

What broke:
1. **Undo no longer brings back the keys after a layout with no keys, then one with keys**
   (`DjinnisBiS.lua:6899-6901`). The first apply takes the undo with `keysUndo = nil`, because that
   layout has no keys. The second apply keeps that undo, since nothing moved in between, and never
   fills in `keysUndo`. Undo then puts the bars back but leaves the second layout's keys, which may
   be the account binding set. This is the card's own path: a spec layout saved before v0.32.0 has
   no keys, and a build layout does. `6d2fc63` had `keysUndo = keysUndo or (...)`, so this is a
   regression. S1 goes red on the real code. **Fix:** add
   `else c.keysUndo = c.keysUndo or (withKeys and nowKeys or nil)` to that `if`. The keys have not
   moved since the first apply, so `nowKeys` is the right undo. On the copy that turns S1 to S5
   green and all the existing checks stay green. Add S1 as a check.
2. Minor, no check guards it: removing `sameKeys` from the keep test (`:6899`), making `sameKeys`
   one-way (`:6881`), or going back to the key-only refusal in the `have` loop (`:6796`) leaves the
   suite green. S4 catches the first two; add it. Clearing `barsAfter` in `undoBars` (`:6921`) is
   dead code, because `barsUndo` is nil after an undo anyway. It is harmless.

Aside, not this card: under Lua 5.4 (the `lua` on PATH here) the 0031 check "the nodes decode as
Blizzard's reader does" is red. Under 5.1 it is green.

Security:
1. Weakest point: unchanged. A hand-edited `DjinnisBiSDB.bars` with a small key set unbinds
   everything else in the binding set in use. A non-table `keysAfter` in `DjinnisBiSCharDB` would
   throw in `sameKeys`. Both are the player's own files.
2. Unchecked: saved key and action strings still go to `SetBinding` without validation. There is
   no new entry point. The slash command still only offers, and apply needs a click.
3. Leaks: nothing leaves the client. Chat lines name slots, keys and spells, locally.

There is no browser surface. Acceptance is in-game only.

Verdict: BOUNCE on finding 1.

**2026-09-23** Builder, v0.33.2. Both findings fixed, as the review proposed.
1. When the undo is kept, it now takes the keys from before this apply if it had none. New
   check: a layout without keys, then one with keys, then undo: the keys are back.
2. New check: a key bound by hand between two applies is what undo puts back. Removing
   `sameKeys` from the keep test turns it red.
Also, off this card: `nodeKey` returns an integer, so its check passes under Lua 5.4 as well
as 5.1. Both interpreters run the harness clean.

**2026-09-23** Fourth review (agent). **BOUNCE.**

What I attacked: `22c8418`, then the whole save, offer, apply, undo and key path again, on copies in
`%TEMP%\rereview33b`. The real tree is green under Lua 5.1 and 5.4. I ran 9 mutations and 4 new
scenarios, each added to `barChecks` on a copy:
- S6: apply, a key unbound by hand, apply, undo.
- S7: a layout with no keys, a `/reload` (a deep copy of `DjinnisBiSCharDB` and a cleared
  `keysRefused`), a layout with keys, undo.
- S8: a layout whose one extra key the game refuses, applied, then a `/reload`, then the login offer.
- S9: the offer shown for Feral, the spec changed to Guardian, then **Apply**.

What held:
- The third review's finding 1 is fixed. Dropping the new `else` line (`DjinnisBiS.lua:6904`) turns
  "the keys too after a layout that had none" red. Making it always overwrite `keysUndo` turns
  "the keys too" red.
- Finding 2 is fixed as claimed. Dropping `sameKeys` from the keep test turns "with a key bound by
  hand in between" red. Two of its parts are still unguarded: `sameKeys` made one-way (`:6881`) and
  the key-only refusal in the `have` loop (`:6796`) both leave the suite green. The shipped code is
  right on both. S6 passes on the real code and goes red on the one-way `sameKeys`. It is worth
  adding as a check.
- Also red when broken: `sameBars` dropped from the keep test, an undo taken on every apply, and
  `keysAfter` taken from before the apply. Clearing `barsAfter` in `undoBars` is still dead code, and
  it is harmless.
- S6 and S7 pass. The kept undo gets its keys back across a `/reload`, because `keysUndo` is filled
  on the second apply from `nowKeys`, and the keys have not moved since the first apply.
- Other orders, traced by hand: keys then no keys then undo; a hand change and then a keyless apply;
  apply, undo, apply. Each puts back what the player had before the last apply that moved something.
- `GetBinding` returns `action, category, key1, key2` (`Blizzard_Keybindings.lua:369`), and
  `SaveBindings(GetCurrentBindingSet())` is what the key binding window does
  (`Blizzard_Keybindings.lua:144`).

What broke:
1. **A prompt left open applies the wrong spec's layout** (`DjinnisBiS.lua:6961`). The prompt frame
   stays up until a button or ESCAPE closes it, and its **Apply** captures `key` when it is shown.
   Say Rob logs in and sees "The Feral layout would change 5 slots", then switches to Guardian and
   clicks **Apply**. Feral's layout is written into Guardian's bars, and into the keys if the binding
   set is per character. If Guardian has no layout, nothing says so. Undo recovers it. A build switch
   inside Feral does the same with the wrong build's layout, though the queued re-offer follows up
   there. S9 is red on the real code. **Fix:** in that `onClick`, first check
   `if PlanTab.barsKey(playerSpec(), (PlanTab.activeLoadoutName())) ~= key then PlanTab.say("The spec
   or build changed since this was offered. Type /djbis bars.") return end`. On the copy that turns
   S9 green, and every other check stays green under both interpreters. Add S9 as a check.
2. Minor: `keysRefused` (`:6788`) is lost on every `/reload`. So a character that lacks one addon's
   binding gets the login prompt "would change 0 slots and 1 keys" on every login, and **Apply** does
   nothing (S8). Addons can be turned on for one character and not another, so Rob could hit this.
   **Fix:** keep it in `DjinnisBiSCharDB.keysRefused`, read at offer time, which is after
   ADDON_LOADED.

Security:
1. Weakest point: unchanged. A hand-edited `DjinnisBiSDB.bars` with a small, non-empty key set
   unbinds every other normal-context key in the binding set in use, and on the account set that
   reaches every character. An undo on an older character can also write weeks-old keys back over
   the account set. Both need the player's own files or clicks.
2. Unchecked: saved key and action strings still reach `SetBinding` without validation. There is no
   new entry point. The slash command only offers, and a write needs a click. Finding 1 is a stale
   click, not a new way in.
3. Leaks: nothing leaves the client. Chat lines name slots, keys and spells, locally.

There is no browser surface. Acceptance is in-game only.

Verdict: BOUNCE on finding 1.

**2026-09-23** Fifth review (agent). **BOUNCE.**

What I attacked: `c10c1b0` (the stale-offer check in `offerBars`, `refusedKeys`, `keysDiffer`,
`placeKeys`), then the offer, apply and undo path again, on a copy in `%TEMP%\rereview33c`. The real
tree is green under Lua 5.1 and 5.4. I ran 3 mutations and 1 new scenario:
- S10: a layout applied on a druid that lacks an addon, so its key F is refused; then that addon is
  turned on for this druid, and the player types `/djbis bars`.

What held:
- The fourth review's finding 1 is fixed. With the stale check removed, "a stale offer's Apply does
  nothing" goes red. The check compares the key that fits now, so a build switch that falls back to
  the same spec layout still applies it, which is right. A non-druid or no-layout state gets `nil`
  and refuses.
- Finding 2 is fixed as asked. With `refusedKeys` back to the session table, "and that is kept across
  a /reload" goes red. `applyBars` creates `DjinnisBiSCharDB` before `placeKeys` writes to it, so no
  refusal falls into the session table on an apply. The login offer only reads it.
- Earlier reviews covered macros at 121+, binding context, slots 121-144, undo order, empty key sets
  and refused keys. I did not repeat those.

What broke:
1. **A refused key is now never offered again, even after its addon is turned on**
   (`DjinnisBiS.lua:6803`, with `:6806-6807`). `DjinnisBiSCharDB.keysRefused` is saved and only
   cleared when `SetBinding` works in `placeKeys` (`:6822`). But `keysDiffer` skips the pair, so the
   offer counts 0 for it, and `/djbis bars` says "already match". The only way to apply is the
   prompt's **Apply**, so if nothing else differs, the key is never bound. Before `c10c1b0`, a
   `/reload` cleared it, and turning an addon on always needs one. The clear at `:6822` only runs if
   some other change starts an apply: removing it leaves the suite green. S10 is red on the real code
   ("expected shown, got same"). **Fix:** in `keysDiffer`, keep a refusal only while its action is not
   one of this client's binding commands. Build `listed[action] = true` from `GetBinding(1 ..
   GetNumBindings())`, and skip the pair only when `refused[key] == want[key] and not listed[want[key]]`.
   An addon that is not loaded has no `Bindings.xml` entries, so its action is not listed. On the copy,
   with the model's `GetBinding` leaving out `MYADDON_X` while that addon is missing, S10 goes green and
   every other check stays green under both interpreters. Add S10 as a check. Whether a disabled
   addon's binding really drops out of `GetBinding` has to be checked in a client.

Security:
1. Weakest point: unchanged. A hand-edited `DjinnisBiSDB.bars` with a small, non-empty key set
   unbinds every other normal-context key in the binding set in use. `keysRefused` is new saved state,
   but a bad entry there can only hide a key from the offer. It cannot bind anything.
2. Unchecked: saved key and action strings still go to `SetBinding` without validation. There is no
   new entry point. The stale check makes a stale click do less, not more.
3. Leaks: nothing leaves the client. Chat lines name slots, keys and spells, locally.

There is no browser surface. Acceptance is in-game only.

Verdict: BOUNCE on finding 1.

**2026-09-23** Builder, v0.33.3, commit `c10c1b0` (written late: the note missed that commit).
The fourth review's two findings, as the fifth review confirmed: the prompt's **Apply** checks
that the layout that fits now is still the one it offered, and refused keys are kept in
`DjinnisBiSCharDB.keysRefused`.

**2026-09-23** Builder, v0.33.4. The fifth review's finding fixed as proposed. `keysDiffer` skips
a refused pair only while `GetBinding` lists no such action, so once the addon behind it is on,
the key is offered again. New checks: turning the addon on adds exactly one key to the count, and
the refusal goes once the game takes the binding. Both go red when their line is removed. Still for
a client: whether a disabled addon's binding drops out of `GetBinding`.
