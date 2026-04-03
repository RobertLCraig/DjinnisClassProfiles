# Djinni's Class Profiles — Agent Guide

## Project Overview

A standalone World of Warcraft addon for saving/restoring action bar profiles (and eventually talent loadouts) across characters of the same class. Built for WoW Retail (The War Within, 12.0.1+).

**Abbreviation:** DCP / DjinnisClassProfiles

## Architecture

This is a **standalone addon** (not a module of a larger framework like DDT), but it reuses patterns from DDT:

- **Core.lua** — Addon object (`DCP`), module system (`ns:RegisterModule`), SavedVariables init, shared helpers (tooltip factory, fonts, clipboard, scrollbars, click resolver, hint builder)
- **Settings.lua** — Blizzard Settings panel integration with widget helpers (checkbox, slider, dropdown, editbox, collapsible sections)
- **ActionBarProfiles.lua** — Action bar module: profile CRUD, action bar read/write, restore logic, export/import, MySlot decoder, LDB data source, tooltip UI
- **DjinnisClassProfiles.toc** — TOC file targeting interface 120001

### Key Patterns

- Namespace: `local addonName, ns = ...` — all modules share `ns`
- Addon object: `ns.addon` (aliased as `DCP`)
- Module registration: `ns:RegisterModule(key, mod, defaults)`
- Database: `ns.db` initialized from `DjinnisClassProfilesDB` SavedVariables, merged with `ns.defaults`
- Tooltip: `ns.CreateTooltipFrame()` factory with `FinalizeLayout()`, scroll support, row/header/separator pools
- Fonts: Named `DCPFont*` (Header, Normal, Small) — internal lookup keys used by `ns.FontString()`
- Slash command: `/dcp`

### Data Flow

```
SavedVariables (DjinnisClassProfilesDB)
  └─ ns.db
       └─ ns.db.actionbarprofiles
            ├─ profiles[classToken][profileName] = { slots, savedAt, savedBy, specID, specName }
            ├─ activeProfile[classToken] = profileName
            ├─ previousLayout[classToken] = profileData (auto-backup)
            └─ autoLoadSpec[classToken-specID] = profileName
```

### Profile Slot Format

```lua
slots[slotID] = { type = "spell"|"macro"|"item"|"flyout"|"summonpet", id = number, name = string?, index = number? }
```

- Slot range: 1–180
- Empty slots omitted
- Macros store both `name` (stable) and `index` (volatile hint)

## Important: Race/Profession Differences

When profiles are shared across characters of the same class, abilities may differ due to:
- **Racial abilities** (e.g., Blood Elf Arcane Torrent vs Orc Blood Fury)
- **Profession skills** (e.g., Engineering tinkers, Herbalism gathering)
- **Covenant/expansion-specific abilities** that may have been on bars

The restore system already handles this gracefully — `PlaceActionInSlot()` checks `GetCursorInfo()` after each pickup attempt, and missing spells simply fail silently (counted as "skipped" in the summary). No special handling needed for the current implementation, but future work should consider:
- Showing which specific abilities were skipped and why
- Suggesting replacements (e.g., "Blood Fury was skipped — you have Arcane Torrent instead")

## WoW API Notes

- **Action bar reading:** `C_ActionBar.HasAction()`, `GetActionInfo()`, `C_ActionBar.GetActionText()`
- **Action bar writing:** `PickupAction()`, `PlaceAction()`, `ClearCursor()`, `C_Spell.PickupSpell()`, `C_Item.PickupItem()`, `PickupMacro()`, `C_SpellBook.PickupSpellBookItem()`, `C_PetJournal.PickupPet()`
- **Combat safety:** `InCombatLockdown()` blocks saves; restores deferred via `PLAYER_REGEN_ENABLED`
- **Override bars:** `C_ActionBar.HasVehicleActionBar()` / `HasOverrideActionBar()` — block both save AND restore
- Mounts are spells — no special handling needed
- Flyouts require spellbook scanning via `C_SpellBook` API
- Macro indices are volatile; always match by name first

## External References

- **WoW UI Source:** `C:\Dev\WoWAddons\wow-ui-source` — Primary reference for WoW API calls, Blizzard widget templates, and UI patterns. Always consult this when working with WoW APIs.
- **MySlot Addon:** `C:\Dev\WoWAddons\myslot` — Original inspiration for action bar profile saving. Reference for slot handling patterns and import/export approaches.

## Coding Conventions

- Lua 5.1 (WoW embedded), no external build tools
- Local functions for internal logic; methods on module tables for public API
- String colors use WoW escape sequences: `|cffRRGGBB...|r`
- Print helper: `DCP:Print(msg)` prefixed with colored addon name
- No semicolons, no trailing commas in tables
- Comments use `-- description` style, section separators use `---...---` bars
- Indentation: 4 spaces
- Libraries bundled in `Libs/` (LibStub, CallbackHandler, LibDataBroker)

## Testing

There is no automated test suite. Testing is done in-game:
1. `/reload` to reload the addon
2. `/dcp` to open settings
3. Test profile save/load/rename/delete operations manually
4. Test import/export with sample strings

## Common Tasks

- **Adding a new setting:** Add default to `DEFAULTS` table in ActionBarProfiles.lua, add widget in Settings.lua's `SetupOptions`
- **Adding a new action type:** Update `ReadActionBarSlots()`, `PlaceActionInSlot()`, and export/import serialization
- **Adding a new click action:** Add to `CLICK_ACTIONS` table, handle in the tooltip's `OnClick`
- **Adding a new module** (e.g., TalentProfiles): Create new .lua file, register via `ns:RegisterModule()`, add to TOC
