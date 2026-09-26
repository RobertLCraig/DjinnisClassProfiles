---
needs: 0068
---
# A bars layout as a string, to keep outside the game

## Why

Rob, 2026-09-26, on whether Myslot is still needed. Myslot gives an export string for a whole
layout. Rob can paste it into a text file, and get the bars back after a lost `WTF` folder, a new
machine, or a bad Apply. The layouts this addon saves live only in its saved variables. If those go,
every layout goes with them, and there is no copy outside the game.

## Links

- **Blocked by** `0068`: the string has to hold the macro bodies, or it is a worse backup than
  Myslot's.
- **Blocks** `0070`: Myslot cannot go while it is the only backup.

## Not this card

- No sharing with other players. It is a backup for Rob. It needs only enough of a header for import
  to refuse a bad string.
- No import of Myslot's own strings.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN Rob clicks Export on a layout, THE ADDON SHALL show one string in a box he can copy. proves: `export gives one string for a layout`
- [ ] WHEN that string is imported, THE ADDON SHALL rebuild the same layout: slots, keys and macros. proves: `export then import gives the same layout`
- [ ] WHEN the string is damaged or is for another class, THE ADDON SHALL refuse it and save nothing. proves: `a damaged string is refused and nothing is saved`
- [ ] WHEN a layout is imported, THE ADDON SHALL only save it. Apply stays a separate click. proves: `import saves and does not apply`
- [ ] WHEN Rob exports in the game, imports the string on another character and applies it, THE BARS SHALL match. proves: manual
<!-- AC:END -->

## Tasks

1. Pick an encoding. The addon already reads talent strings (six bits a character, as
   `ExportUtil.lua` does). Reuse that before adding a library.
2. Add Export and Import beside the layout's other buttons. A right-click opens a menu, it never
   acts.
3. Add the four checks to `PlanTab.barChecks`.
4. Run the offline check under Lua 5.1:
   `"C:\Program Files (x86)\Lua\5.1\lua.exe" offline-check.lua`.

## Comments

**2026-09-26** Raised from the Myslot question. Nothing is built yet.
