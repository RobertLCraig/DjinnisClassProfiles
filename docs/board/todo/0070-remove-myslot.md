---
needs: 0068, 0069
not_for_the_loop: it deletes an addon folder in the game install, and the proof is a live client
---
# Remove Myslot

## Why

Rob, 2026-09-26: "do we need MySlot anymore?" Myslot is a third-party addon in
`C:\Games\World of Warcraft\_retail_\Interface\AddOns\Myslot`. It is not one of the `Djinnis*`
addons, so `bin\deploy.ps1` never touches it. It is only safe to remove once this addon does what
Rob uses it for: bars, key bindings, macros, and a backup outside the game. The bars and the keys
are built (`0033`), but most of the bar cards are still in `human-review/` and have not been
checked in a client.

## Links

- **Blocked by** `0068`: macros.
- **Blocked by** `0069`: a backup string.
- **Relates to** `0036`, `0037`, `0044`, `0045`, `0046`: bar cards still waiting for an in-game
  check.

## Not this card

- No change to addon code. This is a check and a folder delete.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN `0068` and `0069` are done and the bar cards above have passed in a client, THE MYSLOT FOLDER SHALL be deleted. proves: manual
- [ ] WHEN Myslot is gone, a `/reload` and one session SHALL show no error that names it. proves: manual
<!-- AC:END -->

## Tasks

1. First, open Myslot in the game and export one string for each class. Save them in a text file
   outside the game folder. That is the fallback.
2. Check the bar cards above in a client.
3. Delete `C:\Games\World of Warcraft\_retail_\Interface\AddOns\Myslot`.
4. `/reload` and play one session.

## Comments

**2026-09-26** Raised from the Myslot question. Task 1, the Myslot exports, can be done today,
before anything else is built.
