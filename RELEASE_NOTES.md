# Release Notes

## Version: 0.2.0

### Action Bar Profiles + Talent Profiles

#### Core Features
- Save and restore action bar layouts as named profiles, shared across characters of the same class
- Save and restore talent loadouts using Blizzard export strings
- MySlot import/export compatibility
- LDB data source with configurable click actions
- Minimap button via LibDBIcon

#### Action Bar Restore Engine
- Optimized clear phase: only clears/replaces slots that differ from target profile
- Partial restore mode: leave unfillable slots untouched instead of clearing
- Vehicle/override bar detection blocks restore during special bars
- Flyout spellbook cache per session for faster restores
- Macro name normalization for reliable cross-character matching

#### Skip Reporting
- Detailed per-slot skip reasons (spell not known, macro not found, item not owned)
- Racial ability detection with substitution hints (lists your own racials)
- Profession spell identification in skip reports

#### Profile Management
- Full CRUD: save, load, rename, delete, duplicate profiles
- Auto-load profiles on spec change
- Previous Layout undo (single-level)
- Action bar change detection with "Modified" indicator
- Profile metadata (saved by, spec, date) with proper alignment

#### Settings Panel
- Label template with tag expansion (<profile>, <count>, <class>, <spec>)
- Tooltip customization (scale, width, max height, grow direction)
- Click action configuration (9 modifier+button combos)
- Import/export with multi-line editbox
- Collapsible sections
