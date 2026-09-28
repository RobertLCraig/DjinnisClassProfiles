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
- [x] WHEN Rob clicks Export on a layout, THE ADDON SHALL show one string in a box he can copy. proves: `export gives one string for a layout`
- [x] WHEN that string is imported, THE ADDON SHALL rebuild the same layout: slots, keys and macros. proves: `export then import gives the same layout`
- [x] WHEN the string is damaged or is for another class, THE ADDON SHALL refuse it and save nothing. proves: `a damaged string is refused and nothing is saved`
- [x] WHEN a layout is imported, THE ADDON SHALL only save it. Apply stays a separate click. proves: `import saves and does not apply`
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

**2026-09-29**
RESULT: partial
TESTS: +15 new checks in `PlanTab.barChecks`, all green
TOUCHED: DjinnisClassProfiles.lua
TOUCHED: docs/board/in-progress/0069-a-layout-as-a-string-to-keep-outside-the-game.md
OUT-OF-SCOPE: none

Built on the named profiles (card `0037`). They are the only layouts with buttons of their own. A
profile's menu has Export beside Load and Delete. The Action bars menu has "Import a profile...". To
export a spec or build layout, save the bars as a profile first. Export reuses the build export box
(`PlanTab.showExport`), which now takes its own line of text.

The string is `DCP1:` and then base64 in `PlanTab.B64`'s alphabet, with no library. Inside is an
Adler-32 checksum and length-prefixed fields: class id, name, date, 8 per slot, 2 per key. It holds
each macro's body, icon and kind from card `0068`. `PlanTab.readLayoutString` takes the whole string
or refuses it. It refuses a wrong tag, bad base64, a bad checksum, a bad structure, or a class other
than the player's. Import saves under the string's own name and replaces a profile of that name. The
chat line says which. Import never applies. It strips spaces and line breaks from a text file first.

Assumed: `captureBars` now stores `class` (the player's class id) on each layout it saves, so the
header names the class the bars were made on. A profile saved before this has no class. For that
one, Export uses the class of the character exporting it.

Watched red first: the export, round-trip and whitespace checks failed against empty stubs, because
no string was made and nothing was saved. The refusal checks and "does not apply" pass against a
stub that does nothing. So after green, five mutants tested them: no checksum, no class check, an
apply inside import, no keys in the string, no macro bodies in the string. Each one turned a check
red. The first checksum mutant lived: a flipped base64 letter broke the parse before the checksum
was read. I added a check with a spell id one off that still parses. That mutant is red now.

The offline check passes under Lua 5.1, and in spec modes 250 and 71. There is no PHP here, so
`pest` and `pint` do not apply. No version bump and no deploy: the card asks for neither.

Left open: the manual criterion. Rob, in the game: More > Profile: X > Export, and copy the string
into a text file. On another character of the class: More > Import a profile..., paste, OK. Check
that chat says Saved and nothing on the bars moved. Then More > Profile: X > Load. Check that the
bars, the keys and any character macro match. Also check that a long string (many macros) pastes
whole into the box. The offline check cannot see a frame.
