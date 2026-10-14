# 0101 Credits, licence and a README for a public release

## Why

Card `0094` publishes the addon. `master` has no `LICENSE`: MIT was chosen (workspace card `0004`)
but it sits only on branch `claude/licence`. Three more branches are unmerged (`claude/0038`,
`claude/0069`, `claude/0072`), and `claude/0069` duplicates `master`'s `2f14756`. The addon ships
data from ClassCodex (MIT), Bellular's keybinding sheet, Dreamgrove, Warcraft Logs, Method and
Icy Veins, and credits none of them where a user can see it. There is no user README.

## Not this card

- Asking Bellular for permission, or publishing. Both are outward and Rob's; they are on `0102`.

## Acceptance

<!-- AC:BEGIN -->
- [ ] WHEN `master` is read, IT SHALL carry `LICENSE` (MIT), and `claude/licence` SHALL be merged. proves: none, a git state; check with `git ls-files LICENSE`
- [ ] WHEN `claude/0069` is compared with `master`, ONE SHALL be dropped and the reason written here. proves: none, a git state
- [ ] WHEN the release zip is built, IT SHALL hold `LICENSE` and a credits section naming every data source and ClassCodex's MIT notice. proves: manual (`release.ps1` then list the zip)
- [ ] WHEN a stranger reads `README.md`, IT SHALL say what the addon does on any class, how to open it, and that the data is for one season. proves: manual
<!-- AC:END -->

## Tasks

1. Merge `claude/licence`. Decide `claude/0069` against `2f14756`.
2. Write `README.md` for players, with a Credits section.
3. Check `pkgmeta.yaml` does not ignore `LICENSE` or `README.md`.

## Comments

**2026-10-14** Raised from card `0094` (attended).
