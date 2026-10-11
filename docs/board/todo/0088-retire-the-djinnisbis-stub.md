# 0088 Retire the DjinnisBiS stub

## Why

The rename (card `0058`) left a stub addon, `C:\Dev\WoWAddons\DjinnisBiS\`, whose only job was to
load the old `DjinnisBiSDB` and `DjinnisBiSCharDB` so `PlanTab.moveSavedData` could copy them once.
That copy has run: on 2026-10-11 the saved files showed the account copy marked `fromBiS`, and every
character with real old data copied too. The two that were not hold only `DjinnisBiSCharDB = nil`.
The stub is already out of the game folder.

What it costs to keep: three places still insist on it. The `.toc` lists it under `OptionalDeps`.
`offline-check.lua` fails with "the DjinnisBiS stub is not beside this addon" when the folder is
gone, and checks the stub's own `.toc`. And `docs/HANDOVER.md` tells every session to put it back.
So deleting only the folder turns the offline check red, and nobody can tell that from a real fault.

How it came to be: the stub was meant to go once every character had logged in, and nobody wrote
down when that happened.

## Links

**Relates to**
- `0058` - the rename that made the stub; its 2026-10-11 comment lists which saved files carry the copy.

## Not this card

- `PlanTab.moveSavedData` and `PlanTab.copyOld` stay. With no old tables loaded they copy nothing,
  and their checks in `PlanTab.renameChecks` feed the old tables in by hand.
- `DjinnisClassProfilesDB` stays in the `.toc`. It is the OLD Class Profiles addon's data, not the stub's.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN the stub is retired, THE `.toc` SHALL list no `OptionalDeps` on `DjinnisBiS`, and the offline check SHALL expect none. proves: `offline-check.lua` (the `.toc` block, "the .toc loads the stub first" rewritten to expect no dependency)
- [ ] WHEN `C:\Dev\WoWAddons\DjinnisBiS\` is gone, `offline-check.lua` under Lua 5.1 SHALL exit 0, with no line about the stub. proves: `offline-check.lua`
- [ ] WHEN a character logs in after `/reload`, THE ADDON SHALL load with no Lua error and print no rename message. proves: manual
<!-- AC:END -->

## Tasks

1. In this repo: drop `## OptionalDeps: DjinnisBiS` and its comment from `DjinnisClassProfiles.toc`.
2. In `offline-check.lua`: change the `.toc` expectation from `"DjinnisBiS"` to no `OptionalDeps`,
   and remove the block that opens `../DjinnisBiS/DjinnisBiS.toc` and checks the stub.
3. Run `"C:\Program Files (x86)\Lua\5.1\lua.exe" offline-check.lua`, exit 0, read the whole output.
4. In the workspace repo `C:\Dev\WoWAddons`: `git rm -r DjinnisBiS`, and remove any `DjinnisBiS`
   entry from `C:\Dev\WoWAddons\bin\deploy.ps1`'s addon list if it has one.
5. Rewrite the stub lines in `docs/HANDOVER.md` (Canonical data shape, and the first Blockers
   bullet) to say it is retired.

## Comments

**2026-10-11** Raised in the clear-down (attended, Rob asked) when card `0058` went to done/. The
evidence that the copy ran is on `0058`, read off the game's own saved files.
