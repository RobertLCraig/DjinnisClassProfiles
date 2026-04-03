# Djinni's Class Profiles

A World of Warcraft addon that saves and restores action bar layouts (and soon talent loadouts) as named profiles, shared across all characters of the same class on an account.

## The Problem

Players with multiple characters of the same class must manually set up their action bars and talents on each character individually. This is tedious, error-prone, and time-consuming — especially when maintaining different setups for PvP, raiding, Mythic+, and leveling.

## The Solution

Djinni's Class Profiles lets you:

- **Save** your current action bar layout as a named profile
- **Load** profiles on any character of the same class (account-wide)
- **Switch** between setups instantly (PvP, Raid, M+, Leveling, etc.)
- **Undo** the last restore with a single click (auto-backup before every load)
- **Import** from MySlot exports (protobuf format auto-detected)
- **Export** profiles in a native format for sharing or backup

## Features

- **Class-scoped profiles** — profiles are organized by class, so your Warrior profiles are available on all your Warriors
- **Smart macro handling** — macros are matched by name with index hint fallback, handling index volatility gracefully
- **Flyout support** — flyout spells are restored via spellbook scanning
- **Combat-safe** — saves are blocked in combat; restores are deferred until combat ends
- **Vehicle/override bar detection** — warns when vehicle or override bars are active
- **Previous Layout undo** — auto-snapshots your bars before every restore, providing single-level undo
- **Auto-load by spec** — optionally assign profiles to specializations for automatic loading on spec change
- **Race/profession awareness** — gracefully handles abilities that differ between characters (racial abilities, profession skills) by skipping missing spells without breaking the rest of the profile
- **MySlot import** — minimal protobuf decoder reads MySlot exports without requiring their library
- **LDB data source** — integrates with any LibDataBroker display (data text bars, minimap buttons, etc.)
- **Blizzard Settings integration** — full settings panel accessible via `/dcp` or the game's addon settings

## Installation

1. Copy the `DjinnisClassProfiles` folder into your `World of Warcraft/_retail_/Interface/AddOns/` directory
2. Restart WoW or `/reload` if already running
3. The addon will appear in your AddOns list

### Dependencies

- **Bundled:** LibStub, CallbackHandler-1.0, LibDataBroker-1.1
- **Optional:** [MySlot](https://www.curseforge.com/wow/addons/myslot) (for import compatibility)

## Usage

### Slash Command

- `/dcp` — Opens the settings panel

### Quick Actions (via LDB tooltip)

- **Left-click** a profile row to load it
- **Right-click** the data text to save to the current profile
- The inline save box at the bottom of the tooltip lets you save as a new profile

### Profile Management (Settings Panel)

- Save, load, rename, and delete profiles
- Import/export profiles (native format + MySlot)
- Configure click actions for the LDB data source
- Adjust tooltip appearance (scale, width, max height, grow direction)
- Set up auto-load rules per specialization

## Slot Coverage

Scans and restores **slots 1–180**, covering all 6 main action bar pages plus multi-bar slots. Supports:

| Action Type | Handling |
|---|---|
| Spells | Direct placement via `C_Spell.PickupSpell` |
| Macros | Name-based lookup with saved index hint |
| Items | Direct placement via `C_Item.PickupItem` |
| Flyouts | Spellbook scan for matching flyout ID |
| Battle Pets | Restored via `C_PetJournal.PickupPet` |
| Mounts | Treated as spells (mounts ARE spells in WoW) |

## Race & Profession Differences

When loading a profile created on a different character of the same class, some abilities may not exist on the target character (e.g., racial abilities, profession-specific skills). The addon handles this gracefully:

- Missing spells are **skipped** and counted in the restore summary
- The rest of the profile loads normally — one missing ability doesn't break the entire restore
- The slot where the missing ability was is left empty rather than erroring

## Data Storage

Profiles are stored in `DjinnisClassProfilesDB` (SavedVariables), persisted across sessions and shared account-wide.

## Future Plans

- **Talent profile sync** — save and restore talent loadouts alongside action bar profiles
- Keybinding profiles
- Additional import/export format support

## Compatibility

- **WoW Version:** The War Within (12.0.1+)
- **Game Modes:** Retail only (uses modern C_SpellBook, C_ActionBar APIs)

## License

All rights reserved. This addon is provided as-is for personal use.

## Author

**Djinni** (Robert Craig)
