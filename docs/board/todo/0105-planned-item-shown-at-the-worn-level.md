---
---
# 0105 A planned item is shown at the level of the piece it replaces

## Why

Rob, 2026-10-15, after the gear plan was rebuilt from a local droptimiser: "Would be good too, if
we could show what items we are trying to aim for (at the same ilvl as the gear we are trying to
replace. (if the default is lower))".

The Plan tab's "slots to change" rows already name each target item, and pointing at one shows its
tooltip. That tooltip came from `C_Item.GetItemInfo(id)`, so it showed the item at its default
level. A default below the worn piece makes an upgrade look like a downgrade.

## What changed

- `TRACKS` carries each rank's track bonus id (Champion 12833-12838, Hero 12841-12846, Myth
  12849-12854), from KeystoneLoot's `upgrade_tracks.lua` for 12.1.5.
- `PlanTab.aimLink(link, wornIlvl)`: when the link's own level is below the worn piece, it returns
  the link with one track bonus id, at the lowest track rank at or above the worn level. Otherwise
  the link is unchanged.
- The Plan tab's slot rows use it, so the tooltip, the icon and a shift-click all carry that level.
- `PlanTab.aimChecks`: six checks in the self-test.

## Acceptance

- [ ] In game, a Plan tab row for a slot whose target's default level is below the worn piece shows
      the target at the worn level (or the next track rank up) when pointed at.
- [ ] A target whose default is at or above the worn level shows as before.

## Known trade-offs

- Only the Plan tab rows. The slot tooltip on the character sheet and the loot roll stay text and
  glow; neither shows a target's tooltip.
- A link with no level field is built from scratch; the game's reading of a bare track bonus id is
  untested in a live client.

## Comments

### 2026-10-20 review (v20261020220550-28f9)

**suite**

No suite this job could find in WoWAddons:DjinnisClassProfiles, so none ran. That is not a pass.

**acceptance: sound**

I checked the code for card 0105 against its two acceptance criteria. Both have real code behind them, so the verdict is sound.

**#1, a lower default is shown at the worn level.**
- `PlanTab.aimLink` in `DjinnisClassProfiles.lua` does this. It finds the lowest track rank at or above the worn level, using the new `bonus` ids in `TRACKS`. Then it rebuilds the item link with that one bonus id.
- The Plan tab's slot-row builder calls it on each row: `PlanTab.aimLink(link, mark.worn and mark.worn.ilvl)`. The changed link goes to the row's tooltip.
- I counted the fields in the new link. After the item id there are 11 fields (enchant, four gems, suffix, unique, level, spec, modifier mask, context). Then come the count `1` and the bonus id. That is the correct order.
- `PlanTab.aimChecks` tests three cases: shown at rank 12838, a level between ranks goes up to 12853, and no link at all.

**#2, a default at or above the worn level shows as before.**
- `PlanTab.aimLink` gives back the same link when the default is equal or higher.
- It also does this when no piece is worn, and when the worn level is above every track. The self-test covers all three.

**Risks, not failures:**
- The rebuilt link drops the item's own bonus ids.
- No one has tried a link with only a track bonus id in a live game. The card says so itself.

Both criteria are `proves: manual`, so they wait for you in the game. I wrote no `UNMET:` lines. Nothing was edited, because plan mode was on.

**What you do now:** in the game, point at a Plan tab row whose target's default is below your worn piece. Check that the tooltip shows your worn level, or the next track rank up.

VERDICT: sound

**scope: defect**

I tried to break card 0105 on scope only. Verdict: defect. The new item-level code stays inside what the card asked for. The diff around it does not.

**Findings**

1. **Big changes the card did not ask for.**
   - In `DjinnisClassProfiles.lua`, the whole `PlanTab.BUILDS` block was regenerated: every spec's builds and the source date.
   - `GEAR_PLAN` swaps Feral `trinket1` from Font of Venomous Rage to Zul'jin's Guillotine Technique, with a new pair-sim note.
   - About 40 other cards were moved between board lanes (0104 and 0077, for example).
   - `update-builds.py` changed, and both files in `docs/builds/` were rewritten.
   - Card 0105 names none of these.

2. **The card's own code is not in this diff.** `TRACKS.bonus`, `PlanTab.aimLink`, its use in the Plan tab rows and `PlanTab.aimChecks` all exist in the file. But they shipped inside card 0104's change. The open card `docs/board/todo/0104-kithix-and-a-card-only-for-this-raid.md` already says so, and asks for the split. So the work went in under the wrong card.

3. **Half done.** `PlanTab.aimLink` builds a new item string with only the item id, the level and one track bonus id. The link's own enchant, gems and other bonus ids are dropped. The card says the link is "otherwise unchanged". It does not say this loss is accepted.

None of these findings disproves either acceptance criterion. Both criteria are game checks (manual). So I wrote no `UNMET:` line. Expect the card to come back to me.

**What you do now:** nothing. The script sends the card back to `todo/`. The next build session splits the extra changes out to their own cards.

VERDICT: defect

**breakage: sound**

**Breakage review of card 0105: no break found.**

I tried to break `aimLink` and its one caller. Each check held:

- **Link shape.** `PlanTab.aimLink` in `DjinnisClassProfiles.lua` builds `item:id` plus 11 empty fields, then `1`, then one bonus id. This puts the bonus count in the right field.
- **Rank choice.** The code picks the lowest rank across all three tracks that is at or above the worn level. For example, worn 308 gives Champion 6/6 (12838), not Hero 2/6. Both are 308, so the level is right.
- **Fallbacks.** These cases give the link back unchanged: no link, no worn level, a default level that is not lower, or a worn level above Myth 6/6 (for example 344). The six `PlanTab.aimChecks` checks cover these cases, and the self-test calls them.
- **Caller.** `PlanTab.planLines` is the only caller. It still uses `mark.entry.id` for Equip and for matching. Only the shown link changes, so the bag glow, the planned-copy match and Equip are not touched.
- **Comments.** The `TRACKS` comment and the `aimLink` docblock agree with the code.

**Known gap, not a defect.** A bare track bonus id may not set the level in a live client. The card already lists this as a trade-off, and the manual check #1 will test it.

Both criteria say "in game", so only Rob can check them. That is not a finding.

VERDICT: sound

