---
not_for_the_loop: Rob, 2026-09-22: building DjinnisBiS by hand in a session on msiraider
needs: 0011
---
# 0019 The plan's loadouts beside Blizzard's talent window

## Why

When Rob opens the talent window, the plan is in another window (`/bis`, Plan tab). The choice
should sit where the change is made.

Talent Loadout Manager puts a sidebar on Blizzard's talent window: a list of loadouts with Apply,
and Create, Import, Save and Config buttons (`SideBarMixin`, read 2026-09-22). Its ReduceTaint module
exists because attaching to that window can taint Blizzard's own loadout menu.

## Links

- Needs `0011`: the Apply button is its route.
- Uses `0007`'s boss table and `0009`'s content.
- Talent Loadout Manager may be installed too. Check; if it is, a second sidebar is clutter, and
  this card may be dropped for a line in TLM's list instead.

## Not this card

- Creating, importing or saving loadouts.
- Any change to Blizzard's own loadout dropdown.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN the talent window opens out of combat, THE ADDON SHALL show beside it the plan's loadouts for the current spec and content, each with the boss it is planned for. proves: manual
- [x] EACH LOADOUT SHALL have an Apply button that loads it through `0011`'s route, and the active one SHALL be marked. proves: `sidebar marks the active loadout`
- [x] WHEN the player is in combat, THE ADDON SHALL not build or change the sidebar. proves: `sidebar not changed in combat`
- [x] THE SIDEBAR SHALL have a close button, and SHALL stay closed until the player opens it again. proves: `sidebar stays closed`
<!-- AC:END -->

## Tasks

- [x] A plain frame anchored to `PlayerSpellsFrame`, parented to `UIParent`, not to the talent
  frame, to keep Blizzard's frame untouched. Check that anchoring alone does not taint. (Built
  that way; the taint check is the game's, see the 2026-09-22 build comment.)
- [ ] Read TLM's `ReduceTaint` module before starting. (Not on this machine outside the game
  folder, which is never read. The build avoids what such a module fixes: nothing of Blizzard's
  is written, parented into or pre-hooked.)
- [x] Offline checks under the names above.

## Comments

- 2026-09-22 Claude: written from Rob's "Option B" in a SecondBrain session. Ideation only.
  **Uncertain:** whether anchoring to `PlayerSpellsFrame` taints in 12.1.
- 2026-09-22 Claude, later: ClassCodex (installed, 1.3.1) does a stronger version. In the talent
  window it glows the nodes a build would add (green), remove (red) or change (amber). ClassCodex
  also carries a `ReduceTaint.lua` for this. Compare the two before building; the glow shows what
  changes, while a list only shows names.
- 2026-09-22 Claude: **built, in a worktree branch, no version bump, not deployed, no frame seen
  in a client.** All in `DjinnisBiS.lua`, no new top-level local (177), everything on `PlanTab`.
  **What was built.** `PlanTab.armSidebar` runs once at `ADDON_LOADED` for `Blizzard_PlayerSpells`
  (the loader now registers that event after its handler and verifies it), or at login when
  something loaded the talent window first. It post-hooks `PlayerSpellsFrame`'s `OnShow` (one
  frame later, since Blizzard's own OnShow may still be resizing it), `OnHide` and
  `OnSizeChanged`, and nothing else touches that frame. The sidebar is `DjinnisBiSTalentSidebar`,
  a `BackdropTemplate` frame parented to `UIParent` and anchored to the window's right edge (its
  left when the screen has no room, the same flip the stat pane makes beside the character
  sheet), 280 wide, wearing the stat pane's backdrop. Its title names the content ("Plan
  loadouts: Raid" or "Mythic+", from `statContext()`), and it lists one 40-high row per loadout
  the boss table wants for that content, in table order, each with its bosses on a second line:
  Raid shows the five raid loadouts, Mythic+ the one key loadout. The active loadout (the same
  `activeLoadoutName` and `loadoutState` the Plan tab reads, so the two cannot disagree) is
  green with the word "active" and has no button; an edited one (card 0014) is amber with
  "edited" and keeps its Apply; every other row is white with a 70 by 24 Apply that calls
  `PlanTab.loadTalents(name)`, card 0011's route. `UIPanelCloseButton` in the corner writes
  `DjinnisBiSDB.sidebarClosed = true` and the sidebar gives way to one 110 by 24 "BiS plan"
  button in its place; clicking that clears the pin. `PlanTab.updateSidebar` returns "combat" and
  touches nothing in combat, and it also runs from `PlanTab.redraw`, so a loadout landing, a
  spec change or the end of combat refreshes it through the bag-mark watcher's events that are
  already registered. If `TalentLoadoutManager` is loaded the sidebar is not built and one grey
  chat line says so at arm time, per the card's "a second sidebar is clutter". Fonts are
  `GameFontNormal` and `GameFontHighlight` only. Every template was checked in `wow-ui-source`:
  `PlayerSpellsFrame` (Blizzard_PlayerSpellsFrame.xml, parent UIParent, `LoadOnDemand: 1` in
  the toc), `BackdropTemplate`, `UIPanelCloseButton`, `UIPanelButtonTemplate`.
  **Checks** (all in `selfTest`, 23 lines under the three `proves:` names): the raid rows are
  one per loadout with the active one marked and its bosses listed, the key row is out of the
  raid list and alone in the Mythic+ one, edited is said and not active, unknown marks nothing,
  no boss table gives no rows, the active row is green with no Apply, a plain row has one, an
  edited row is amber with one; in combat `updateSidebar` answers "combat" and builds nothing,
  and closing still writes the pin; the mode is off without the window, tab when closed, open
  otherwise; the row height is at least 32. `lua offline-check.lua` (5.4) and Lua 5.1.5 both
  exit 0. **Mutations, each in a temp copy:** the combat guard deleted, 4 red; the content
  filter flipped, 7 red (the first run of this one crashed the test on a `[3]` of a short list,
  so the index checks are nil-safe now); the close pin not written, 2 red; every known loadout
  marked active and the active row keeping its Apply, 6 red.
  **What a person must look at, out of combat, on Feral, after `/reload`:**
  1. Press N. A "Plan loadouts: Raid" box stands beside the talent window's right edge with five
     rows, each a loadout name over its bosses in grey, and an Apply button on every row but
     the one you have loaded, which is green and says "active". If the box is missing, say
     whether Talent Loadout Manager is enabled (that turns it off, with a grey chat line).
  2. Click Apply on another row: the talent cast bar, the loadout loads, and that row goes
     green on its own while the old one gets its Apply back.
  3. Then pull a target dummy and press every action bar button for 30 seconds: no frozen bar,
     no "blocked" message. That is the card's own taint question, from an anchor and three
     post-hooks.
  4. Click the box's close button: it goes, a "BiS plan" button sits where it was. Close the
     talent window, `/reload`, press N: still only the button. Click it: the box is back.
  5. Drag the window and toggle its maximise button: the box follows and stays beside it. Move
     the window to the right edge of the screen and reopen it: the box sits on its left.
  6. In a dungeon, press N: the title reads "Plan loadouts: Mythic+" with the one key row.
  7. Move one talent point by hand: the active row turns amber, says "edited", and has Apply.
  **Left out and why:** the `ReduceTaint` read, since TLM's source is only in the game folder;
  a glow on the talent nodes as ClassCodex does, which the card names as a comparison and not
  an ask, and which would mean drawing inside Blizzard's frame; a loadout row for a boss with no
  plan, since the boss table is the plan; Edit Mode placement, since the box is anchored to a
  window and not a HUD element.
- 2026-09-22 Claude, adversarial review in a worktree: **one defect, fixed; to `human-review/`
  because the frame, the anchor, the three post-hooks and the taint question can only be seen in
  a client.** Reviewed against `f1cc2ef` as merged.
  **Attacked.** Every Blizzard name the code touches, against `wow-ui-source`: `PlayerSpellsFrame`
  (a `UIParent` child, `LoadOnDemand: 1`, shown through `RegisterUIPanel` so `OnShow`/`OnHide`
  fire), `BackdropTemplate`, `UIPanelCloseButton`, `UIPanelButtonTemplate` (all in
  `Blizzard_SharedXML`), `C_AddOns.IsAddOnLoaded`, `C_Timer.After`, `ADDON_LOADED`'s payload
  (`addOnName` first, so `name` is right), and `C_Traits.GetConfigInfo`'s `name`, which carries no
  secret marker in `SharedTraitsDocumentation.lua` and is guarded by `canRead` anyway. Nothing
  used is under `Blizzard_Deprecated*`. Every string the sidebar compares, concatenates or keys on
  is the addon's own (loadout names from `PlanTab.BOSSES`, spec from `SPEC_BY_ID`), so the
  secret-value trap has no way in. The loader registers `ADDON_LOADED` after its handler and
  verifies it, per DECISIONS. Top-level locals still 177. Then the three `proves:` tests, each
  broken in a temp copy: rival guard removed, 2 red; the active mark never set, 4 red; the content
  filter flipped, 8 red. Both checkers exit 0 on the fixed file.
  **Broke.** The TLM opt-out only stopped the hooks. `PlanTab.redraw` calls `updateSidebar` on
  every equip, spec change, zoning, combat end and loadout landing, and `updateSidebar` never
  asked about TLM, so with TLM loaded and the talent window open the first such event (including
  `TRAIT_CONFIG_UPDATED` from TLM's own Apply) built the very sidebar the card said to leave off.
  Same hole if TLM loads after `Blizzard_PlayerSpells`, which it does when it depends on it.
  **Fixed:** `sidebarMode` takes `rival` and answers "off" for it; `PlanTab.rivalLoaded()` is
  asked on every update, not once at arm time. Three checks under `sidebar stays closed`.
  **Held.** The combat guard is first in `updateSidebar` and `placeSidebar` is guarded on the
  size hook. `sidebarRows` dedupes by name, so a loadout on three bosses is one row. The `edited`
  mark cannot coincide with `active` because `loadoutState` says mismatch whenever `edited`. Mode
  "off" with no sidebar built returns before `CreateFrame`, so a player who never opens the
  talent window never gets the frame. `db()` is only read from hooks and clicks, all after
  SavedVariables. `armSidebar` is idempotent, so the login fallback and the `ADDON_LOADED` route
  cannot double-hook.
  **Noted, not changed.** (1) `/bis test` in a client swaps the `InCombatLockdown` global and
  puts it back; this card's checks do it too, following 0011, 0012, 0015 and 0024. A global
  written from addon code stays tainted after the restore, and secure code reads that one
  constantly, so an in-game `/bis test` may taint the session until `/reload`. House pattern,
  one decision for Rob, not this card's. (2) `redraw` wraps `updateSidebar` in `pcall`, so a
  sidebar fault stops the sidebar silently rather than the Plan tab; the Plan tab is the more
  important of the two, but a silent stop is the "cannot be told from working" shape. (3) The
  talent window closed in combat leaves the sidebar standing until `PLAYER_REGEN_ENABLED`; that
  is what the third criterion asks for, and hiding a plain frame in combat would be allowed. (4)
  `SIDEBAR_RIVAL = "TalentLoadoutManager"` is the CurseForge folder name from memory; TLM is not
  installed here, so it could not be checked against a folder. (5) The `SIDEBAR_ROW >= 32` check
  guards a constant; it fails only if someone shrinks `SIZE.row`.
  **Security.** Weakest: the Apply button hands a name from the addon's own table to
  `PlanTab.loadTalents`, card 0011's route through `ClassTalentHelper`; nothing a player types
  reaches it. Unchecked: `DjinnisBiSDB.sidebarClosed` is read as truthy without a type check,
  and any value only closes a sidebar, so there is nothing to gain by editing it. Leaks: one
  grey chat line naming TLM when it is loaded, and nothing on failure, since `pcall` swallows.

## What I need from you

Out of combat, on Feral, after `/reload`; the game folder holds v0.21.0 and this branch is not
deployed, so deploy it first. The seven looks in the build comment stand, and these are the
review's additions:

1. With Talent Loadout Manager **not** installed (it is not, today): press N, then equip any
   item while the window is open. The box redraws and stays one box.
2. If TLM is ever installed: press N, apply a loadout from TLM's own sidebar. **No** "Plan
   loadouts" box appears beside it at any point, and one grey chat line at login says why.
3. After `/bis test` in the client: pull a target dummy and press every action bar button for
   30 seconds, then open and close the talent window. Any "blocked" message here is finding (1)
   above, and belongs to every card that swaps `InCombatLockdown`, not to this one.
