# Djinni's Class Profiles — Task List

Based on the original implementation plan (baseprompt.md) and CoPilot review.

## Status Legend

- [x] Complete — implemented and present in codebase
- [ ] Not started — needs implementation
- [~] Partial — started but incomplete or needs refinement

---

## Phase 1: Core Engine (Action Bar Read/Write)

- [x] `ReadActionBarSlots()` — scan slots 1–180, capture type/id/subType
- [x] `PlaceActionInSlot()` — restore a single action to a slot (spell, macro, item, flyout, summonpet)
- [x] `FindMacro(savedName, savedIndex)` — name-based lookup with index hint fallback
- [x] `FindFlyoutInSpellbook(targetFlyoutID)` — spellbook scan for flyout restoration
- [x] Combat safety — `InCombatLockdown()` blocks save, defers restore via `pendingRestore`
- [x] Vehicle/override bar detection — warns on save
- [x] Block restore during vehicle/override bars (CoPilot recommendation — currently only blocks save)
- [x] Clear-phase optimization — only clear slots that differ instead of all populated slots (CoPilot recommendation)
- [x] Flyout cache — cache flyout→spellbook slot mappings per session to avoid repeated scans (CoPilot recommendation)
- [x] Macro name normalization — strip trailing spaces/whitespace before comparison (CoPilot recommendation)

## Phase 2: Profile CRUD

- [x] `SaveProfile(name)` — read bars, store with metadata, enforce 1000-profile limit
- [x] `RestoreProfile(name)` — two-phase clear→place with success/failure count
- [x] `RestoreFromData(profileData)` — generic restore from raw data (used by Previous Layout and MySlot)
- [x] `RestorePreviousLayout()` — single-level undo (does not overwrite previousLayout)
- [x] `DeleteProfile(name)` — removes profile and cleans up activeProfile/autoLoadSpec references
- [x] `RenameProfile(oldName, newName)` — collision check, updates activeProfile/autoLoadSpec
- [x] `GetSortedProfileList()` — sorted by name
- [x] `DuplicateProfile(name, newName)` — CopyTable clone (CoPilot recommendation: "users love this in MySlot")

## Phase 3: Data Architecture

- [x] `DEFAULTS` table with all settings
- [x] Profile storage format: `profiles[classToken][profileName] = { slots, savedAt, savedBy, specID, specName }`
- [x] Previous Layout auto-backup before every restore
- [x] `autoLoadSpec` mapping: `classToken-specID → profileName`
- [x] `activeProfile` per class

## Phase 4: Export / Import

- [x] Native format serialization — `SerializeProfile()` with base64 body and header comment
- [x] Native format deserialization — `DeserializeProfile()` with pipe-escape handling
- [x] Full config export — `ExportFullConfig()` serializes all profiles + settings
- [x] Full config import — `ImportFullConfig()` merges profiles, autoLoadSpec, activeProfile, previousLayout
- [x] Auto-detect import format — ABP-FULL, ABP single, MySlot
- [x] Export version tag (`ABP_EXPORT_VERSION = 1`)
- [x] Multi-line import editbox in Settings (currently single-line `InputBoxTemplate`)

## Phase 5: MySlot Compatibility

- [x] Base64 decode/encode
- [x] Minimal protobuf varint decoder
- [x] `DecodeSlot()` — protobuf field parser for slot messages
- [x] `DecodeMySlotPayload()` — extract repeated Slot fields from Charactor message
- [x] MySlot type mapping — SPELL, ITEM, MACRO, FLYOUT, SUMMONPET, SUMMONMOUNT, COMPANION, EQUIPMENTSET, EMPTY
- [x] Mount conversion — `C_MountJournal.GetMountInfoByID()` → spellID
- [x] Header detection — bytes `{42, 86, 4, 22}`
- [x] `GetMySlotProfiles()` — read from `MyslotExports` SavedVariables
- [x] `RestoreMySlotProfile(index)` — decode and restore directly

## Phase 6: Label Template & LDB

- [x] Tag expansion: `<profile>`, `<count>`, `<class>`, `<spec>`
- [x] Presets in settings: Default, With Count, Class, Spec Bars
- [x] LDB data object — `DCP-ActionBarProfiles` with OnEnter/OnLeave/OnClick
- [x] Click action executor — loadnext, loadprev, savecurrent, undorestore, opensettings, none

## Phase 7: Tooltip

- [x] Tooltip frame via `ns.CreateTooltipFrame()` factory
- [x] Row pool, header pool, separator pool
- [x] Profile list with active highlight (green bar + "Active" label)
- [x] Previous Layout row with "Undo" label
- [x] MySlot profiles section (conditional on `showMySlot`)
- [x] Inline save EditBox with "Save" button
- [x] Hint bar with click action labels
- [x] Show/hide timer
- [x] Scroll support (vertical + horizontal)

## Phase 8: Settings Panel

- [x] Label Template section — editbox, tag buttons, presets
- [x] Tooltip section — scale, width, max height, grow direction
- [x] Profile Management section — save bar, profile list with Load/Rename/Delete buttons
- [x] Auto-Load on Spec Change section — per-spec dropdown
- [x] Import/Export section — export current, export all, import editbox, MySlot toggle
- [x] Click Actions section — 9 modifier+button dropdowns
- [x] Collapsible sections with +/- toggle
- [x] Profile row metadata alignment cleanup (meta text overlaps buttons on narrow panels)

## Phase 9: Event Handling

- [x] `PLAYER_ENTERING_WORLD` — initial data refresh + auto-load check
- [x] `PLAYER_SPECIALIZATION_CHANGED` — update data + check auto-load
- [x] `PLAYER_REGEN_ENABLED` — process deferred restore
- [x] `ACTIONBAR_SLOT_CHANGED` — detect external bar changes and mark active profile as "modified"

## Phase 10: Polish & Improvements (from CoPilot review)

- [x] Block restore during override/vehicle bars (not just save)
- [x] Clear-phase optimization (only clear changed slots)
- [x] Flyout spellbook cache per session
- [x] Macro name normalization (trim whitespace)
- [x] Duplicate Profile button in settings panel
- [x] Multi-line import editbox (for large exports)

---

## Phase 11: Race & Profession Handling

Cross-character profile sharing means abilities may differ between characters of the same class due to race, profession, or expansion-specific content.

### Current Behavior (already works)
- [x] Missing spells are skipped silently — `PlaceActionInSlot()` checks `GetCursorInfo()` after pickup, fails gracefully
- [x] Skipped actions counted in restore summary ("X placed, Y skipped")
- [x] Rest of profile loads normally — one missing ability doesn't break the restore

### Planned Improvements
- [x] **Detailed skip report** — show *which* specific abilities were skipped and why (spell not known, item not owned, etc.)
- [x] **Spell availability check before restore** — pre-scan profile slots via `CanPlaceAction()` used by partial restore and optimized clear phase
- [x] **Racial ability substitution hints** — detect racial ability slots and suggest the character's own racial as a replacement
- [x] **Profession skill detection** — identify profession-specific abilities in skip reports via spellbook skill line scanning
- [ ] **Per-slot override system** — allow users to set per-character overrides for specific slots (e.g., "slot 45 is always my racial ability on this character")
- [x] **"Partial restore" mode** — option to only restore slots the character can actually fill, leaving other slots untouched rather than clearing them

---

## Future Features (Post-MVP)

- [ ] **Talent profile sync** — save and restore talent loadouts alongside action bar profiles (core goal of the "Class Profiles" vision)
- [ ] **Keybinding profiles** — save/restore keybinding layouts
- [ ] **Profile sharing** — in-game profile sharing between players (addon comms)
- [x] **Minimap button** — standalone minimap icon via LibDBIcon with settings toggle
- [ ] **Drag-and-drop profile ordering** — custom sort order in tooltip
- [ ] **Profile categories/tags** — organize profiles by purpose (PvP, PvE, etc.)
- [ ] **Per-bar profiles** — save/restore individual bars instead of all 180 slots
