# Changelog

All notable changes to Djinni's Class Profiles will be documented in this file.

---

## [0.3.0-alpha] - 2026-04-03

### Keybinding Profiles, Per-Bar Filtering, Slot Overrides, JSON Export, Profile Organization

#### New: Keybinding Profiles
- Save and restore keybinding layouts as named profiles
- Full CRUD: save, load, rename, delete, duplicate
- JSON export/import via copy+paste
- Confirmation dialog before restoring (replaces all bindings)

#### New: Per-Bar Profiles
- Choose which action bars to include in save/restore operations
- Bar filter checkboxes in Options (Main, Stance, Right 1/2, Bottom Right/Left, Extra 1/2/3)

#### New: Per-Character Slot Overrides
- Override specific action bar slots on a per-character basis
- Overridden slots use the current bar action instead of the profile's saved action during restore
- Useful for racial abilities, profession skills, or character-specific abilities
- Settings UI to add, view, and remove overrides

#### New: JSON Export/Import
- All profile types now export as minified JSON for easy copy+paste sharing
- Action bar profiles: export single or all profiles as JSON
- Talent profiles: export all talent profiles as JSON
- Keybinding profiles: export as JSON
- Import auto-detects JSON format alongside legacy ABP and MySlot formats

#### New: Custom Profile Ordering
- Up/down arrow buttons on each profile row in Settings
- Custom order respected in tooltip, loadnext/loadprev cycling

#### New: Profile Tags
- Click-to-cycle tag button per profile: PvE, PvP, Raid, M+, Solo, Farm, Alt
- Color-coded tag labels shown in both Settings and tooltip


