# 0063 Reset on the worn loadout sends two loadout changes in one frame

## What I need from you

Nothing now. Built; the open looks are the `proves: manual` criteria under Acceptance, tried from the product's look list (board README, A look waits on the product).

## Why

The second 0059 review, 2026-09-25. The server takes one loadout change in flight and refuses the
rest ("You can't do that right now"; Rob saw it from "Tag them", card 0059).

- `finishSwap` sends `DeleteConfig(old)` and then `RenameConfig(new)` in the same frame, just after
  the switch lands. The rename is likely refused, so Reset to plan on the worn loadout ends at
  "Rename it in the talent window".
- `importOne` deletes and then imports in the same frame.
- The fence does not cover a swap in progress: `PlanTab.q` is cleared before `swapSelected`, so
  "Tag them" can start during the swap's wait.

## What to do

Send each second change only once the first has landed, the way `PlanTab.tagNext` does: wait for
the config to read the new state, one beat more, and retry a refusal. Hold `loadoutFence` for the
whole swap.

## Acceptance

<!-- AC:BEGIN -->
- [x] `lua offline-check.lua` passes, with checks against a timed server model (one change in flight) for `finishSwap` and `importOne`. proves: `PlanTab.swapChecks`, among them `one loadout change at a time, the delete goes alone`, `..., then the import, and nothing is refused`, `..., the rename once the delete has landed, and nothing is refused`, `..., it ends holding the plan under its name`
- [ ] Wear a `[CP]` loadout, change a talent by hand and apply it, close the talent window, then **More > Make the planned loadouts > Reset to plan**. Pass: chat says it "now holds the plan, and you are wearing it"; no "You can't do that right now", no "Rename it". proves: manual
<!-- AC:END -->

## Comments

**2026-09-25, Claude.** Built, v0.51.1.

- `importOne` with a replace now only deletes and answers `"deleted"`. `stepLoadouts` runs the same
  job again once `waitThenStep` sees the old config gone and one beat more; the second run only
  imports.
- `finishSwap` sends the delete, waits for the old config to read gone and one beat more, then the
  rename, and waits for the new name. Each refusal is tried again, `TAG_TRIES` times a `POLL` apart,
  as `tagNext` does. It answers `"working"` at once; `swap.result` holds how it ended.
- `PlanTab.swapping` holds the fence from the switch in `swapSelected` to the end of the rename.
  `loadoutFence`, `wearSpare`, `loadTalents` and `saveOne` refuse while it is set.
- `PlanTab.swapChecks` runs both against the timed server model from `tagChecks`. With the fix
  broken on purpose, five of its checks failed ("refused" in the calls); with it, none.
- Not changed: `setupStep` (a group setup's spec change) waits for `tagging` only, not a swap.

Done-when 1 passes (`offline-check.lua` under Lua 5.1, both modes). Done-when 2 is Rob's, in game.

**2026-09-25, Claude (adversarial review of 2cf88bf).** One medium finding, two low, and the
checks miss two of the waits. Left in `ai-review/` at the caller's request (another session holds
the Lua file for `0057`); the verdict is a bounce to `todo/` for finding 1. Line numbers are 2cf88bf's.

What I ran. `offline-check.lua` and `offline-check.lua 250` under Lua 5.1 in the repository: both end
"no FAIL lines". Then eleven mutations on a copy of 2cf88bf (the repository file was not touched):

| Broken on purpose | Checks that went red |
|---|---|
| `importOne` deletes and imports in one frame (the old code) | 3 |
| no retry of a refused change in `finishSwap` | 1 |
| no beat after a change lands | 1 |
| `swapSelected` or `finishSwap` sets no fence; `loadoutFence` ignores it; `stop` never lets go | 10, 6, 2, 80 |
| `finishSwap` renames without waiting for the delete to read gone (`:7367` made `true`) | **0** |
| `waitThenStep` skips the `goneID` wait (`:7241` made `false`) | **0** |
| `loadTalents` or `saveOne` ignores `PlanTab.swapping` | **0**, 0 |

The first zero is the model: with `lag = 1` a change lands in the same beat the retry comes round, so
"waits until it lands" and "waits one beat" look the same. With `lag = 3` at `:10605` the checks still
pass and that mutation goes red. The second zero is the model too: its `CanCreateNewConfig` reads the
same busy flag, so the `goneID` wait never changes anything there. Nobody knows yet whether the real
`CanCreateNewConfig` reports a delete in flight.

Findings:

1. **Medium. `waitThenStep` imports anyway when the delete never lands (`:7241` to `:7249`).** Once
   `GIVE_UP` passes with the old config still listed, it sets `goneID` to nil, and because
   `q.waited >= GIVE_UP` it calls `stepLoadouts` straight away. The second run only imports. What
   goes wrong: `DeleteConfig` returns true but the server drops it (the "You can't do that right now"
   from `0059` may come after the call, not as its return value; `ClassTalentsDocumentation.lua` only
   says `success: bool`), or it is slow. The import then makes a second "[CP] Raid: X" next to the old
   one. `savedLoadoutNames` keys by name, so one of the two is invisible to the addon, and nothing in
   the talent window checks for a duplicate name. If that import fails as well, `:7201` says "The old X was
   deleted", which is not true. Fix: if the config still reads as there at `GIVE_UP`, put the id
   back on `job.replace`, clear `job.deleted` and add the job to `q.retry` (the final pass deletes
   again), or drop it with "The old X did not go; nothing was made". Add a check where the model
   accepts the delete and never applies it.
2. **Low. A group setup during a swap loses its loadout step (`:4840`, `:4862`).** `setupStep` waits
   for `tagging` and not for `swapping`. Clicking Set up during the 5 to 20 seconds of a swap makes
   `loadTalents` answer "busy", `setupStep` treats that as missing, and the gear goes on without the
   loadout. A spec change in the setup is not fenced at all, and it can use up the 8 tries on the
   swap's delete or rename, ending at "old kept" or "unnamed". The builder named this. Fix: in
   `setupStep`, treat `PlanTab.swapping` the way it treats `tagging` (set `afterTag`, answer
   "renaming"), and call `PlanTab.afterTagging()` from `finishSwap`'s `stop`.
3. **Low, not this card's code: `wearSpare` is the same bug (`:7036`, `:7046`).** It deletes old
   spares in a loop and then starts the import in the same frame. The import is usually refused and
   then retried by the queue, so this mostly fixes itself, but it breaks the handover's rule of never
   sending changes in a loop. Suggest a new card.
4. **Low, checks.** Change `lag` to 3 in `swapChecks`. Add a model whose `CanCreateNewConfig` ignores
   a delete in flight, so the `goneID` wait is actually tested. Add one line each for `loadTalents`,
   `saveOne` and `wearSpare` refusing while `swapping` is set.

What held: `swapping` is let go on every way out (the switch timing out, no helper, each `stop`), so
the fence cannot stay stuck until a `/reload`. The `after` wrapper drops stale timers. An old loadout
worn again is still never deleted. The switch counts as landed only when `GetLastSelectedSavedConfigID`
changes, which Blizzard updates on the commit's `TRAIT_CONFIG_UPDATED`
(`Blizzard_ClassTalentsFrame.lua:380-389`), so the delete is not sent before the switch has taken.

No browser surface: this is an in-game addon, so there was nothing to screenshot. Done-when 2 still
has to be checked in the game.

Security:
1. **Weakest point:** a delete the call reports as done but the server never applies. That is how a
   duplicate "[CP]" loadout gets made (finding 1). Someone can cause it from the game only by
   keeping the server busy, which is not an attack on anyone else.
2. **Unchecked:** `setupStep`'s spec change and loadout switch skip the swap fence (finding 2), and
   `wearSpare`'s loop has no queue (finding 3). Nothing comes from outside the client: the stored
   strings are parsed by Blizzard's own import code before anything is deleted.
3. **What it leaks:** nothing. Failures go to the player's own chat frame as loadout names, and no
   data leaves the client.

**2026-09-25, Claude.** Review findings fixed, v0.52.1.

1. Fixed. If the old loadout is still there at `GIVE_UP`, `waitThenStep` sends no import. It puts
   the id back on `job.replace` and queues the job for the final pass, which deletes it again. On
   the final pass it says "The old X did not go, so it was not made again."
2. Fixed. `setupStep` waits for `swapping` as it waits for `tagging`. Every way a swap ends goes
   through the new `PlanTab.swapEnded`, which lets go of the fence and calls `afterTagging`.
3. Moved to card `0067`. It is older code.
4. Fixed. `lag` is 3. A `canNewFree` model tests the `goneID` wait on its own. A `lost` model is
   a delete that is taken and never lands, for the queue and for the swap. There are new checks
   that wear, save, the spare and a group setup all wait for a swap.

I broke each fix on purpose, one at a time. Each break made the checks fail: the `goneID` wait 3
FAIL, the landed wait 3, the `setupStep` fence 1, the replace put back 2.

**2026-09-25, Claude (second review, 86c46f7).** The fixes hold. Moved to `human-review/` for
Done-when 2, which Rob checks in the game. Line numbers are from 86c46f7.

Both runs of `offline-check.lua` under Lua 5.1 end "no FAIL lines". I ran my mutation list again on
a copy of 86c46f7 and added seven breaks for the new code, 18 in all. 15 turn the checks red, and
the three that do not are small. Among the 15: the lost delete importing anyway, the job not queued
again, `swapEnded` not calling `afterTagging`, `setupStep` ignoring the swap, and `wearSpare`
ignoring it. Both zeros from my first review now fail too (the rename not waiting for the delete, 2
FAIL; the `goneID` wait skipped, 3).

How each finding was fixed:
1. Fixed (`:7302-7316`). A lost delete sends no import, and the job goes back as a replace. The
   job it picks up is the right one: `stepLoadouts` has already stepped `q.i` back, so
   `q.jobs[q.i + 1]` is the same job, on either pass.
2. Fixed (`:4880`, `:7392`). A swap now ends only through `swapEnded`: the switch timing out, no
   helper, and every `stop`. `afterTagging` checks `pendingSetup == steps` before it runs anything,
   so a setup that was dropped in the meantime is not started.
3. Now card `0067`.
4. Fixed. `lag` is 3, and there are the `canNewFree` and `lost` models.

Still open, all low, none worth another bounce:
- **A delete that lands after the 15 seconds costs the loadout.** When the retry pass comes round,
  `job.replace` names a config that has since gone. `importOne` (`:7118`) calls `DeleteConfig` on
  it, which most likely returns false (not confirmed in Blizzard's source), and the job fails with
  "the game would not delete the old one". The old loadout is gone, no new one is made, and the
  message says the opposite of what happened. More > Make the planned loadouts will make it again.
  Fix: in `importOne`, treat a `job.replace` whose `configName` reads nil as already deleted and
  import straight away.
- **Three breaks the checks still miss.** (a) The extra beat after the old config reads as gone
  (`:7303`). (b) Leaving `job.deleted` set on the lost path (`:7311`), which only changes a
  message. (c) The `swapping` guard in `loadTalents`: the check asks for a build with no saved
  loadout, so it goes to `wearSpare`, whose own guard answers "busy". Asking for a saved name would
  test it.

Security: nothing new. The new paths are timers and messages in the player's own chat. They read no
input and send nothing out of the client.

**2026-09-25, Claude.** The late delete is fixed, v0.52.2. When a replace's old loadout is already
gone, `importOne` imports at once and sends no delete. A new check in `swapChecks` covers it, and
it fails when the fix is taken out. The three checks the reviewer said were missing are left as
they are: two only change a message or a beat, and the third is covered by `wearSpare`'s own
guard.

**2026-10-11** Clear-down (attended, Rob asked): ticked Done-when 1 (checks `one loadout change at a time, the delete goes alone`, `then the import, and nothing is refused`, `the rename once the delete has landed, and nothing is refused`, `it ends holding the plan under its name` in `PlanTab.swapChecks` exist and pass in the Lua 5.1 offline check); `## Done when` became `## Acceptance` in the AC block, wording kept; looks rewritten for v0.69.0: the one in-game Reset, with the chat line the code prints ("now holds the plan, and you are wearing it"); it is the same action as 0060's first look, so one try answers both; moves to ai-review/ with only in-game looks open.

### 2026-10-20 review (v20261020070323-ef81)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: defect**

I checked criterion #1 against the code and ran the offline check. Criterion #1 is not met, so the verdict is defect. Criterion #2 is manual, so it is not a finding.

**Criterion 1: what is there.** The checks live in `PlanTab.swapChecks` in `DjinnisClassProfiles.lua`, and `PlanTab.selfTest` calls it. All four named checks are present:
- "the delete goes alone"
- "then the import, and nothing is refused"
- "the rename once the delete has landed, and nothing is refused"
- "it ends holding the plan under its name"

None of the four printed a FAIL.

**Criterion 1: why it fails.** The criterion says `lua offline-check.lua` passes. I ran it today and it does not pass. It ends `offline-check: 1 FAIL lines`. The failing line is: `the stub's Interface: 120100, not 120105 (card 0058)`. That check belongs to card 0058, not to this card's swap code. But the box claims the whole script passes, and today that is not true.

**Criterion 2.** The chat line "now holds the plan, and you are wearing it" does exist, in the `stop("done", ...)` call inside `finishSwap`. So the manual look can pass.

UNMET: #1 `lua offline-check.lua` does not pass: it ends with 1 FAIL line (the DjinnisBiS stub says Interface 120100, the check wants 120105). So "passes" is false, even though the four swap checks pass.

VERDICT: defect

**scope: sound**

**Scope check of card 0063: no defect found.**

**What I did.** I read the card's three code commits: `2cf88bf`, `86c46f7` and `389c941`.

**What I found.**
- The big diff you gave me (157 files) is not this card's work. It covers many cards across the whole history. I did not judge the card on it.
- The three commits change only `DjinnisClassProfiles.lua`, the `.toc` version line, and this card's own file.
- One commit also adds a new card, `0067`. That is correct. It moves the out-of-scope `wearSpare` loop to its own card.
- The changes stay inside what the card asks for:
  - `importOne` waits for the delete to land before it imports.
  - `finishSwap` waits for the delete to land before it renames.
  - A refused change is tried again.
  - The fence (`PlanTab.swapping`) is held for the whole swap.
- Two changes go a little past the card's text: the `setupStep` swap fence and the `swapEnded` helper. The first review asked for both, and they close the same bug (a second change sent during a swap). That is not quiet growth.
- Nothing is half done. The only open item is the in-game Reset check. Rob does that one by hand, so it is not a finding.

**What you do now.** Nothing. The card can go to `done/`. The in-game check waits on Rob's list of things to try.

VERDICT: sound

**breakage: sound**

I tried to break it, and I could not find a fault.

- **`finishSwap`:** the delete and the rename now go out at different times. The rename goes only after the old loadout reads as gone, plus one beat. When the game refuses a change, the code tries it again. A late timer from an earlier swap is dropped, because the `after` wrapper checks `PlanTab.swapping == swap`.
- **The fence:** `swapSelected` holds `PlanTab.swapping` from the switch. Every way out goes through `swapEnded`, so the fence lets go each time. That includes no helper, a timeout, and every `stop`.
- **Old loadout worn again:** it is never deleted, and the new one is not renamed onto its name. Nothing changes here from before.
- **Chat line:** the success text in `finishSwap` is exactly the line the manual check looks for: "now holds the plan, and you are wearing it".
- **Offline checks:** `PlanTab.swapChecks` has the named checks, for example "it ends holding the plan under its name". I did not run the checks myself. I only read the code.

The only open item is the in-game check (#2). That is Rob's to try in the game, so it is not a finding.

VERDICT: sound

**acceptance**

- **#1 was named by the acceptance lens and is not a ticked criterion here**, so nothing was changed: `lua offline-check.lua` does not pass: it ends with 1 FAIL line (the DjinnisBiS stub says Interface 120100, the check wants 120105). So "passes" is false, even though the four swap checks pass.

