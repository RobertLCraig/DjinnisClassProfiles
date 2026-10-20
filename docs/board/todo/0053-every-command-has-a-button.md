# 0053 Every command has a button

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Why

Rob, 2026-09-24: "lets make sure that all comands have a button in the UI. I shouldnt need to type
any commands to make use of the addon".

## Command inventory

| Typed | Click |
|---|---|
| `/djbis` | Minimap button (existing) |
| `/djbis <boss>` | The By Boss tab (existing) |
| `/djbis here` | More > Bonus roll worth it here? (druids only, as the verdict is druid gear) |
| `/djbis test` | None on purpose, since v0.45.0 (card `0056`): typed only |
| `/djbis talents` | More > Compare talents with the plan |
| `/djbis loadouts` | More > Make the planned loadouts |
| `/djbis tidy`, `tidy yes` | More > Delete old Dreamgrove loadouts (druids only). It lists, then asks Delete / Cancel |
| `/djbis bars` | More > Offer the saved bars |
| `/djbis bars save`, `save build` | Save bars: spec / build, beside the talent window (existing), and More > Save bars for this spec / build in the main window |
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

<!-- AC:BEGIN -->
- [x] Each command in the table reaches its function from the menu. proves: self-test `menuChecks`
- [x] The menu is drawn as the items say: titles, dividers, a greyed item, a submenu, tooltips; a click passes no arguments. proves: self-test `menuChecks`, with a fake menu root
- [x] Delete old loadouts and Delete profile ask first, and delete only on Delete. proves: self-test `menuChecks`
- [x] Off a druid, no tidy item and no bonus roll item. proves: self-test `menuChecks`, class swapped to 6
- [x] No text the player sees names a slash command. proves: `offline-check.lua` source scan (comments and the two `SLASH_` lines are allowed)
- [x] All 36 non-druid specs still pass the spec mode. proves: `lua offline-check.lua <spec id>`, each
- [ ] `/reload`, open the main window from the minimap button, click **More** (left of **Import sim**), and click each item once. Pass: every item does something, and no message says to type a command. proves: manual
- [ ] **More > Save bars as a profile...**, type a name, press Enter. Pass: chat says "Saved the <name> profile". proves: manual
- [ ] **More > Profile: <name> > Load**, then **More > Undo bars**. Pass: the profile's bars go on, then your old bars come back. proves: manual
- [ ] **More > Profile: <name> > Delete**. Pass: a box asks "Delete the <name> profile?"; **Delete** removes it from the menu. proves: manual
- [ ] Open the talent window. Pass: the list beside it has a small **More** left of its X, the title stops short of it, and its menu has **Open the main window**. proves: manual
- [ ] Close the build list with its X, then click **More** in the main window. Pass: it shows **Show the build list**; click it, open the talent window, and the list is back. proves: manual
<!-- AC:END -->

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

**2026-09-24, Claude (third adversarial review, of 552c380). Clean: to human-review.**

Each earlier finding:
- The no-layout message: **closed.** It says "More > Save bars for this spec", which is always
  there. No check covers the text (my mutation putting the old words back stays green). It is one
  string and it reads right.
- `/bis` before `.`, `,`, `;`, `!`, `?` or `)`: **closed.** The builder's "/bis." mutation goes red.
- "Show the build list" hidden while Talent Loadout Manager is loaded: **closed.** No check covers
  the gate (my mutation removing it stays green). It is one `and not PlanTab.rivalLoaded()` and it
  is right.

Fixed in place, on the card only: the command table still said `/djbis test` is "More > Run the
self-test". It now says there is no button, on purpose. The first criterion is about the table, so
the table had to say so. The `bars save` row now names the window's two new items too. "What Rob
checks in game" became `## What I need from you` at the top, with the build list step added.

What held:
- `offline-check.lua` exits 0 under Lua 5.1 and 5.4.6. I read the whole output; no load error.
  All 36 non-druid specs pass spec mode.
- The builder's 31 mutations (`%TEMP%\mut0053.py`) each turn it red, run on a scratch copy.

Security: unchanged from the first review. Profile names come from the player's own
SavedVariables. Nothing is sent anywhere, and no other player is read.

**No browser, no game client.** The surface is in-game UI, so "look at it in a real browser" does
not apply. Rob's seven steps and the self-test question are under `## What I need from you`.

**2026-10-11** Clear-down (attended, Rob asked): ticked nothing new (the six built criteria were already ticked; `PlanTab.menuChecks` and the `offline-check.lua` source scan exist and pass in the Lua 5.1 offline check); looks rewritten for v0.69.0: the seven steps became six (step 6, every item once, folded into step 1), "the BiS window" is now the main window, and the one manual criterion was split into them. Dropped the self-test question: the code keeps it off the menu on purpose (card 0056, check `no self-test in the menu`), so it is not a look; a new card if Rob wants it back. Note: the ticked "off a druid, no tidy item" half is superseded by card 0066, which gives every class "Delete old loadouts" (check `a Death Knight can delete old loadouts too (card 0066)`); the bonus roll half still holds. Moves to ai-review/ with only in-game looks open.

### 2026-10-20 review (v20261020010509-e6a2)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: defect**

I checked each ticked box against the code. Five of the six hold. One is now false.

**What holds:**
- #1, #2 and #3: `PlanTab.menuChecks` in `DjinnisClassProfiles.lua` clicks each menu item and checks the function it calls. It also checks the confirm boxes.
- #5: the source scan in `offline-check.lua` is still there.
- #6: the spec-mode checks are in `offline-check.lua`. I did not run them.

**What fails: #4.** It says a class that is not a druid gets "no tidy item". That is no longer true. Card 0066 gives every class "Delete old loadouts" in `PlanTab.menuChecks`' menu builder, which calls `PlanTab.tidyAsk`. `PlanTab.menuChecks` now checks the opposite: "a Death Knight can delete old loadouts too (card 0066)". The 2026-10-11 clear-down saw this and still left the box ticked. The bonus-roll half of #4 may still be true, but the box as a whole is false. The fix is small: change #4 so it only says "no bonus roll item off a druid", and keep the check for that.

The open `proves: manual` boxes are not findings. They are Rob's in-game checks.

UNMET: #4 card 0066 gives every class "Delete old loadouts", and `PlanTab.menuChecks` checks that a Death Knight gets it, so "off a druid, no tidy item" is false.

VERDICT: defect

**scope: defect**

**Scope review of card 0053: I found one defect.**

**Finding: criterion #4 is no longer true.**
- Criterion #4 says: "Off a druid, no tidy item and no bonus roll item."
- In `DjinnisClassProfiles.lua`, the window's More menu adds "Delete old loadouts" for every class. There is no druid gate on it.
- The self-test `menuChecks` now checks the opposite. Its check is "a Death Knight can delete old loadouts too (card 0066)".
- The card's own 2026-10-11 note says card 0066 replaced this rule. But the box is still ticked, and the card still claims it.
- The bonus roll half still holds. "Bonus roll worth it here?" is druid only.
- Fix: rewrite #4 to say only "no bonus roll item". Then point the tidy half at card 0066.

**Finding: this diff is much more than card 0053.**
- It has 161 files and about 52,000 added lines.
- That includes the rename to DjinnisClassProfiles (card 0058), new gear plans, Warcraft Logs builds, bar categories and crafted reagents. It also moves about 40 other cards.
- None of that is a button for a command. "Not this card" says: no new features.
- The diff range looks too wide. I cannot pin that growth on this card's own commits, so I do not count it as a defect here.

UNMET: #4 "Delete old loadouts" is now on every class's More menu (card 0066), and `menuChecks` asserts a Death Knight has it, so "off a druid, no tidy item" is false.

VERDICT: defect

**breakage: defect**

I read the menu code and the self-test checks. I did not run anything. I found one fault.

**The finding: criterion #4 is false as written.**
- The card says that off a druid, the menu has no tidy item. The command table also marks "Delete old Dreamgrove loadouts" as druids only.
- The code does not match. In `DjinnisClassProfiles.lua`, the window menu builder adds "Delete old loadouts" (`PlanTab.tidyAsk`) for every class. It does not check the class.
- The self-test agrees with the code, not with the card. `PlanTab.menuChecks` has the check `a Death Knight can delete old loadouts too (card 0066)`, and it expects `tidyAsk`.
- So the box is ticked, but the code does the opposite of what the box says. The card's own clear-down note says card 0066 replaced this rule, but the box stayed ticked.
- The bonus-roll half of #4 is still true. The check `a Death Knight has no bonus roll verdict` covers it.
- To fix: rewrite #4 and the table row to say every class gets "Delete old loadouts" and only a druid gets the bonus roll item. Then tick it again on the existing check.

**What held:**
- Each item in the window menu calls the function the card says it does.
- `no self-test in the menu` holds.
- The chat messages name **More > ...**, not a slash command.

UNMET: #4 the menu gives every class "Delete old loadouts" (card 0066, checked by `a Death Knight can delete old loadouts too`), so "off a druid, no tidy item" is false

VERDICT: defect

**acceptance**

- **#4 was named by the acceptance lens and is not a ticked criterion here**, so nothing was changed: card 0066 gives every class "Delete old loadouts", and `PlanTab.menuChecks` checks that a Death Knight gets it, so "off a druid, no tidy item" is false.
- **#4 was named by the scope lens and is not a ticked criterion here**, so nothing was changed: "Delete old loadouts" is now on every class's More menu (card 0066), and `menuChecks` asserts a Death Knight has it, so "off a druid, no tidy item" is false.
- **#4 was named by the breakage lens and is not a ticked criterion here**, so nothing was changed: the menu gives every class "Delete old loadouts" (card 0066, checked by `a Death Knight can delete old loadouts too`), so "off a druid, no tidy item" is false

