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

**2026-09-24, Claude (adversarial review of 5675332). Back to todo: two findings, one small.**

Findings, in the order to fix them:

1. **With TalentLoadoutManager loaded, `/djbis bars save` and `bars save build` have no click.**
   `PlanTab.sidebarMode` returns `"off"` whenever `PlanTab.SIDEBAR_RIVAL` is loaded, so the sidebar,
   its Save bars: spec / build buttons and its More never show. The window's More has no save item
   for the spec or the build, so on that setup those two commands can only be typed. The table's
   "(existing)" row assumes the sidebar is there. `offerBars(true)` then tells the player to "Click
   Save bars: spec beside the talent window", a button that is not there. Fix: add "Save bars for
   this spec" and "Save bars for this build" to the window menu (`PlanTab.saveBars(false, true)` and
   `(true, true)`, as the sidebar buttons call them), with a `menuChecks` line for each. Rob does not
   run TalentLoadoutManager today, but the rival gate exists for players who do.
2. **The source scan cannot see `/bis` inside a string.** It flags `/djbis` anywhere but `/bis` only as
   `"/bis` at the start of a literal. A mutation to `PlanTab.say("Type /bis tidy yes to delete them.")`
   and one to `"Type /BIS ..."` both left `offline-check.lua` green. The code has no such text today
   (a grep for `/bis` outside comments found none), so this is a hole in the proof for the fifth
   criterion, not text a player sees. Fix: match `/bis` and `/djbis` case-insensitively wherever they
   occur in a line, and allow only the two `SLASH_` lines.
3. Small: **Make the planned loadouts does nothing in combat and says nothing.** `offerLoadouts`
   returns `"combat"` before any message. The other bar and loadout items say "Not in combat" through
   `barsFence` or `loadoutFence`. The
   typed command was silent before this card, but a menu item that does nothing on click is what
   step 6 of Rob's check looks for. Fix: say it when `asked`.

What held:
- **Tests.** `offline-check.lua` passes under Lua 5.1 and under 5.4.6 (exit 0, output read whole, no
  load error). All 36 non-druid specs pass spec mode.
- **Mutations.** The builder's 12 mutations each go red again (run on a scratch copy, not the repo).
  My own run (`%TEMP%\rev0053.py`, 11 mutations): a wrong profile on Load and a dropped tooltip go
  red. Six survive because the harness draws no frame and has no `MenuUtil`, so I read those paths
  against the source instead: the sidebar passing `"window"`, the generator's argument order, Enter
  on the name box, OK passing the typed text, a callback on a submenu parent, and `tidyAsk` skipping
  its busy check. Those paths are right as written. The two `/bis` mutations are finding 2.
- **The menu API, read in `wow-ui-source` 12.1.0 (69933).** `Menu.PopulateDescription` calls the
  generator as `(ownerRegion, description)`, so `function(_, root)` is right. A callback that returns
  nothing gives a nil response, and `MenuManagerMixin` closes the menus on nil (Menu.lua:2233).
  `MergeFunctions` puts every inserter on each button description, so a nested `CreateButton` makes
  a child, and the submenu opens through `CheckForSubmenu`, not `onEnter`, so a tooltip on "Profile:
  X" does not stop it. `SetEnabled` is on the description proxy (Menu.lua:830) and
  `SetTitleAndTextTooltip` is a MenuUtil utility merged onto it. A profile item with no callback has
  no responder, so clicking it does nothing and does not close the menu.
- **The name box.** `InputBoxTemplate` and `BasicFrameTemplateWithInset` both exist. Escape is taken
  by `OnEscapePressed` while the box has focus, and `UISpecialFrames` covers Escape once it does not.
  `SetMaxLetters(40)` counts letters and `saveProfile` counts bytes, so a 40-letter name with accents
  is refused with a message. That is a small mismatch, not a fault.
- **Inventory.** The slash handler and `barsCommand` hold exactly the commands in the table. With the
  sidebar showing, each one has a click. Every function the menu names exists at runtime
  (`undoBarsAsk`, `sayTalents`, `offerLoadouts` and the rest). Layout: the four spec buttons end at
  x=494 and More sits at 666 to 756, so they do not overlap.
- **Combat.** Nothing in the menu can do something protected. Bars go through `barsFence`, loadouts
  and tidy through `loadoutFence`, and both refuse in combat. Saving a profile only reads the bars,
  and deleting one only touches SavedVariables.

Security, where the card produced code:
1. *Weakest point:* the profile names shown in the menu come from account-wide SavedVariables.
   `saveProfile` refuses `|`, but a hand-edited or older file could put a `|T` texture or colour code
   into a menu line. That only changes how the text is drawn. Only the player can write that file.
2. *Unchecked:* typed `tidy yes` still deletes at once, and the menu's Delete runs `tidy(true)`
   again, which lists the loadouts afresh rather than deleting the ones shown in chat. Both still
   delete only loadouts with the addon's own retired names, behind `loadoutFence`. A non-table profile
   value or a number key in `profilesDB` would make the menu fail to build, the same way
   `listProfiles` already would.
3. *Leaks:* nothing. It makes no network call, sends no chat message to anyone else and reads no other
   player.

**This review ran in no browser and no game client.** The surface is in-game UI, which no agent can
run. After the fix, Rob still owes the six steps above. He should also look at two things. First,
whether the tooltip on "Profile: X" sits over its Load / Delete submenu. Second, whether a long
sidebar title such as "Beast Mastery Hunter builds" gets cut short at More.

**2026-09-24, Claude. The three findings, fixed in v0.44.0.**

1. The window's More has "Save bars for this spec" and "Save bars for this build"
   (`saveBars(false, true)`, `saveBars(true, true)`), not shown in the sidebar's menu, which has
   the buttons. Checked in `menuChecks`.
2. The scan finds `/djbis` anywhere and `/bis` followed by a space, a quote, `|` or the end, in any
   case. "/BiS: Raid" in a check's text is a loadout name and is not flagged. Your two mutations
   ("Or type /BIS tidy yes") now go red.
3. Make the planned loadouts says "Not in combat" when clicked in combat. No check: the only way to
   fake combat is to swap `InCombatLockdown`, a Blizzard global.

Also from Rob's first look (card `0055`): the window's More has "Show the build list" while the list
is closed, and More sits 6 pixels from the sidebar's close button. `mut0053.py` now has 20 mutations,
all red.

**2026-09-24, Claude (second adversarial review, of 5d86315). Back to todo: one leftover of finding 1.**

Finding:

1. **The message still sends the player to a button that may not be there.** Finding 1 said that
   `offerBars(true)` tells the player to "Click Save bars: spec beside the talent window", and with
   Talent Loadout Manager loaded that button does not exist. The menu items are in now, but the
   message is unchanged (DjinnisBiS.lua:7842, printed in spec mode: "No saved layout for
   Affliction. Click Save bars: spec beside the talent window"). Fix: name **More > Save bars for
   this spec**, which is always there, or name the sidebar button only when `sidebarMode` is not
   "off". It is one line, but this pass commits only the card.

Each earlier finding:
- Finding 1, the menu part: **closed.** The window's More has "Save bars for this spec" and "for
  this build", calling `saveBars(false, true)` and `(true, true)` as the sidebar buttons do, and
  `menuChecks` proves each. The message part is the finding above.
- Finding 2: **closed.** The scan lowercases the line and finds `/djbis` anywhere, and `/bis`
  followed by a space, a quote, `|` or the end of the line. My two mutations ("Type /bis tidy yes"
  and "/BIS") go red. It still misses `/bis` followed by a full stop or a comma ("Type /bis."). No such
  text exists today, so this is a note, not a finding.
- Finding 3: **closed.** `offerLoadouts(true)` says "Not in combat" in combat. There is no check,
  because faking combat means swapping `InCombatLockdown`, and my mutation removing the message
  stays green. The line is read and right.

What held:
- `offline-check.lua` exits 0 under Lua 5.1 and 5.4.6, output read whole, no load error. All 36
  non-druid specs pass spec mode. The builder's 20 mutations each go red, run on a scratch copy.
- The two new items are only in the window's menu, not the sidebar's, which has the buttons. The
  gap between More and the close button is `-6` on More's own anchor, so the title still stops at
  More.

Security: the same as the first review. Profile names come from the player's own SavedVariables, and
the new items only call `saveBars`, which reads the bars and writes SavedVariables behind `barsFence`.
Nothing leaks.

**No browser, no game client.** Rob's six steps above still apply, plus: with the build list closed,
**More** in the main window shows **Show the build list**, and clicking it brings the list back
the next time the talent window opens.
**2026-09-24, Claude. The second review's leftovers, fixed in v0.45.0.** The no-layout message says
"More > Save bars for this spec". The scan also flags `/bis` before `.`, `,`, `;`, `!`, `?` and `)`.
"Show the build list" is hidden while Talent Loadout Manager is loaded. And from Rob's first click:
**Run the self-test is off the menu** (card `0056`): it swaps the game's own tables while it runs
and broke the talent window until a reload. It is a check for whoever changes the addon.