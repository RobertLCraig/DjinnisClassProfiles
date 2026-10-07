# 0087 Macros that take a button's place, not a new key

## Why

Rob, 2026-10-07, on GearInsight's macro pages: the burst macros are not worth a key, "but worth
checking for useful macros for other classes and specs". He likes the mouseover kind, the way his
own Moonfire and Sunfire macros work.

All 40 spec pages were read on 2026-10-07 (`https://gearinsight.app/wow/en/macros/<class>/<spec>`,
329 macros). The raw list is in `%TEMP%\gimac\list.txt` and will not last. **The rule this card
keeps: a macro is worth having only when it takes the place of a button that is already on the
bars.** It casts the same spell on the same key and does more. A macro that needs a new key is out.

These are common macro patterns, not GearInsight's work. Write our own bodies. Copy no text.

## The patterns that pass the rule

1. **Mouseover, else target, for help spells.** `/cast [@mouseover,help,nodead][] <spell>`.
   Battle res, dispels, externals (Blessing of Protection, Sacrifice, Freedom, Power Infusion,
   Innervate, Ironbark), Tiger's Lust, Rescue, Leap of Faith, and every healer's heals.
2. **Mouseover, else target, for DoTs.** Moonfire and Sunfire (Rob has these), Shadow Word: Pain,
   Vampiric Touch, Flame Shock, Corruption, Agony, Outbreak, Wildfire Bomb.
3. **Interrupt focus, else target.** `/cast [@focus,harm,nodead][] <kick>`. Also tank taunts on
   mouseover: Growl, Taunt, Torment, Provoke.
4. **Ground spells at the cursor, with no targeting circle.** `/cast [@cursor] <spell>`. Ursol's
   Vortex, Death and Decay, Rain of Fire, Healing Rain, Efflorescence, traps, Heroic Leap.
5. **Do not break a channel.** `/stopmacro [channeling:<x>]` in front of a filler. For example
   Starsurge that cannot cut Convoke, Mind Blast during Void Torrent, fillers during Rapid Fire and
   Fists of Fury.
6. **Whichever talent you have, on one key.** `/cast [known:<A>] <A>; <B>`. **This one fits
   card `0079` best:** two builds of a spec that pick different talents on a choice node can share
   one button.
7. **Small fixes on the same key.** Guardian's Thrash that first cancels Blessing of Protection
   (`/cancelaura Blessing of Protection`). A form key that does not shift back out when pressed
   twice (`/cast [noform:1] Bear Form`).

## Out

- Burst macros (trinkets plus cooldowns). Rob said no. Nothing here replaces the one-button
  assistant: a macro can cast only one spell on the global cooldown per press.
## Not out (Rob, 2026-10-07: "these are not auto fails")

8. **A spell on a set person: focus, a name, or the tank.** Tricks of the Trade, Misdirection,
   Power Infusion, Innervate. Rob's Innervate goes on his focus. `[@focus,help,nodead][]` casts on
   the focus without a target change. A macro that changes target and changes back is also fine,
   because it is too fast to see.
   - **Idea:** the addon can fill the name for you. When the group changes, out of combat, write
     the group's tank into the macro with `EditMacro`. `EditMacro` does not work in combat.
   - **Check first:** in 12.1 a unit name can be a secret value (workspace `docs/DECISIONS.md`).
     If the tank's name comes back secret, the addon cannot write it. Then use focus.
9. **Macros that change target or focus to work.** For example the hunter "kick anything" macro.
   Judge each one by the button rule, like the rest.
10. **Ctrl modifiers.** Write them with Shift or Alt. Rob does not use Ctrl (see his key reach).

## Check before building

- How Make bars places macros today (`0067`, `0068`, `0082`), and whether a per-spec macro list
  fits there.
- A `known:` with a spell id must use a 12.1 id. Check each one in the game data, not from the page.
- Macro slots are limited (120 account, 18 character). Count how many this adds per spec.

## Acceptance

- [ ] For each spec, a list of the macros that pass the rule, keyed to the button each one replaces.
- [ ] Make bars puts the macro on that button only when the character knows the spell.
- [ ] No macro that needs a new key.
- [ ] Rob's own Moonfire and Sunfire macros are kept and not made twice.
- [ ] `lua offline-check.lua` passes.
