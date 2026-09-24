# 0038 Action button cooldowns throw "secret values" thousands of times a session

## Why

Rob, 2026-09-23, BugSack, 17,695 times in one session:

```
Blizzard_ActionBar/Shared/ActionButton.lua:847: bad argument #1 to 'SetCooldown'
(... Secret values are only allowed during untainted execution for this argument.)
cooldown=MultiBarBottomLeftButton4Cooldown  start=<secret number>  duration=<secret number>
```

Blizzard's own cooldown update runs tainted, so something has tainted the action buttons. Addon
code touched them first, and Blizzard's code may no longer use protected values after that. The
spell book shows the same error (`Blizzard_SpellBookItem.lua:383`), so the taint is wider than one
bar.

## What is known

- **It is older than the bars code.** `!BugGrabber.lua` first holds it on 2026-09-22 at 21:29
  (spell book) and 21:35 (action bar, 16,860 times, session 355). Cards `0031` to `0034` were built
  on 2026-09-23. No character's `DjinnisBiSCharDB` held a bars undo at the last logout, so no bars
  Apply had run.
- There is no `Logs\taint.log`, so nothing names the addon yet.
- Suspects, not findings:
  - any addon that calls `C_ClassTalents.LoadConfig` or `CommitConfig` from addon code (see card
    `0002`'s Direction on ClassCodex);
  - DjinnisBiS's own talent switch through `ClassTalentHelper.SwitchToLoadoutByName`, because it is
    still called from addon code;
  - card `0033`'s `PickupAction` and `PlaceAction`, but only from now on.
  - `/djbis test` in the client. `PlanTab.barChecks` writes over the Blizzard globals
    `C_ActionBar`, `GetActionInfo`, `PickupAction`, `PlaceAction`, `C_Spell`, `C_Item` and
    `InCombatLockdown`, then puts them back. `sidebarChecks` does the same with `GameTooltip`. A global written by addon code stays tainted until
    `/reload`, and Blizzard's action buttons read these. The 0046 second review found this. Only a
    suspect if the error follows a `/djbis test`.
- Card `0002` says "DjinnisBiS never touches talents, action bars or any secure frame". That was
  true on 2026-09-02 and is not true since `0031` and `0033`.

## What I need from you

1. `/console taintLog 2`, then `/reload`. Level 2 also logs taint that blocks no action, which is
   this kind.
2. Play until the error comes back. Note what you did just before: switched talents from the
   list, clicked Apply on the bars, or changed spec.
3. Log out. Send `C:\Games\World of Warcraft\_retail_\Logs\taint.log`.
4. `/console taintLog 0` afterwards. The log grows fast.

## Acceptance

- [ ] The addon that taints the action buttons is named from `taint.log`.
- [ ] WHEN it is DjinnisBiS, THE ADDON SHALL stop that call, and a session with the same steps SHALL log no `SetCooldown` error.
