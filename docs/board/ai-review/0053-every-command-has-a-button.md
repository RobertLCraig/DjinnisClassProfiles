# 0053 Every command has a button

## Why

Rob, 2026-09-24: "lets make sure that all comands have a button in the UI. I shouldnt need to type
any commands to make use of the addon".

## Command inventory

| Typed | Click |
|---|---|
| `/djbis` | Minimap button (existing) |
| `/djbis <boss>` | The By Boss tab (existing) |
| `/djbis here` | More > Bonus roll worth it here? (druids only, as the verdict is druid gear) |
| `/djbis test` | More > Run the self-test |
| `/djbis talents` | More > Compare talents with the plan |
| `/djbis loadouts` | More > Make the planned loadouts |
| `/djbis tidy`, `tidy yes` | More > Delete old Dreamgrove loadouts (druids only). It lists, then asks Delete / Cancel |
| `/djbis bars` | More > Offer the saved bars |
| `/djbis bars save`, `save build` | Save bars: spec / build, beside the talent window (existing) |
| `/djbis bars undo` | Undo bars beside the talent window (existing), and More > Undo bars in the main window |
| `/djbis bars save <name>` | More > Save bars as a profile... opens a name box (Enter is OK, Escape is Cancel) |
| `/djbis bars load <name>` | More > Profile: <name> > Load |
| `/djbis bars delete <name>` | More > Profile: <name> > Delete, which asks first |
| `/djbis bars list` | More lists every profile, or a greyed "No profiles yet" |

"More" is a button in the main window (left of Import sim) and in the list beside the talent window
(left of its close button). It opens Blizzard's own menu (`MenuUtil.CreateContextMenu`). The sidebar's
menu also has "Open the BiS window".

Every message that said "Type /djbis ..." now names the button. The slash commands still work.
Typed `tidy` now asks the same question as the menu; `tidy yes` still deletes at once.

## Acceptance

- [x] Each command in the table reaches its function from the menu. proves: self-test `menuChecks`
- [x] The menu is drawn as the items say: titles, dividers, a greyed item, a submenu, tooltips; a click passes no arguments. proves: self-test `menuChecks`, with a fake menu root
- [x] Delete old loadouts and Delete profile ask first, and delete only on Delete. proves: self-test `menuChecks`
- [x] Off a druid, no tidy item and no bonus roll item. proves: self-test `menuChecks`, class swapped to 6
- [x] No text the player sees names a slash command. proves: `offline-check.lua` source scan (comments and the two `SLASH_` lines are allowed)
- [x] All 36 non-druid specs still pass the spec mode. proves: `lua offline-check.lua <spec id>`, each
- [ ] In game: the More button in the main window and beside the talent window opens the menu; each item works; the name box saves a profile. proves: manual (Rob)

## What Rob checks in game

1. `/reload`. Open the BiS window from the minimap button. Click **More** (top right, left of Import sim).
2. Click **Save bars as a profile...**. Type a name. Press Enter. Chat says it saved.
3. Click **More** again. Point at **Profile: <name>**. Click **Load**. Then **More > Undo bars**.
4. **More > Profile: <name> > Delete**. A box asks. Click Delete.
5. Open the talent window. The list beside it has a small **More** at the top. The title does not run under it.
6. Look at each menu item once. No item should do nothing, and no message should say to type a command.

## Not this card

- New features. Only the existing commands got clicks.

## Comments

**2026-09-24, Claude.** Built in v0.43.0, deployed. Mutations: 12 breaks of the menu, the questions,
the drawing, the sorting, the source scan and the typed `tidy` route each turn the offline check red
(`%TEMP%\mut0053.py`). The menu API was read from `wow-ui-source` `Blizzard_Menu` (`CreateButton`,
`CreateTitle`, `CreateDivider`, `SetEnabled`, `SetTitleAndTextTooltip`). The harness has no
`MenuUtil`, so the real menu is only drawn in game.
