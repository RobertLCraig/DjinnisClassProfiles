---
not_for_the_loop: a product decision for Rob
---
# 0097 The gear plan is one character's sim. What does another player get?

## Why

`GEAR_PLAN` is generated from Raidbots Top Gear reports of Rob's own character: "what the sim said
Djinni should wear out of what Djinni owned" (its comment block). It is wrong for any other player,
whatever their class. Card `0094` publishes the addon to other players, so this table cannot ship
as it is. An addon cannot fetch a report itself: there is no HTTP call in Blizzard's API.

## What I need from you

Pick 1 or 2.

## Options

1. **Hide the gear plan for everyone but you.** The published build ships an empty `GEAR_PLAN`, and
   the plan tab, the bag glow and the equip buttons say nothing when it is empty. Cost: small. Other
   players lose nothing they had.
2. **Let a player paste their own SimC or Raidbots result in game.** The addon parses it into the
   same shape `update-gear-plan.ps1` writes. Cost: large; a new parser in Lua, and a new screen.
   Raises one more question: which text the player pastes (the `/simc` addon's output, or a
   Raidbots report link, which the game cannot open).

## Recommendation

Option 1 for the first release. Option 2 can come later as its own card, if players ask for it.

## Comments

**2026-10-14** Raised from card `0094` (attended).
