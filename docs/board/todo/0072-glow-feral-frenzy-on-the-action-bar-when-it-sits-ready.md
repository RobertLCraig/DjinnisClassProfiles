# 0072 Glow Feral Frenzy on the action bar when it sits ready

## Why

Rob, 2026-09-27, after 19 Coiled Altar pulls on Heroic (report `TwXyfVJ8hZA2zrvd`). He cast Feral
Frenzy 1.3 times a minute on his two best pulls. The top three heroic Ferals on the boss cast it
1.9 to 2.0 times a minute. He holds it after it comes off cooldown.

Rob wants a nudge: the button glows when Feral Frenzy has been ready for about 2 seconds and is
not pressed.

## The rule Rob set

**Glow the existing action bar button. Add nothing new to the screen.** No new icon, bar, text or
frame that shows what the screen already shows. Rob's words: "do not create new things on the
screen that replicate information already shown."

## Check these before building

1. **Blizzard may already do it.** Look at two native features first:
   - Cooldown Manager alerts: `CooldownViewerAlertEventType.Available` with a Visual alert. Find
     out if the visual is on the action button or only on the Cooldown Manager icon. The icon
     alone does not meet the rule above.
   - Assisted Highlight (the setting that glows the recommended next spell on the bars). Find out
     if it can be limited to one spell. It probably cannot.
   If either one does the job, the card is a settings change and no code.
2. **Secret values.** Since 12.0, cooldown data read in combat can be a secret value. Find out if
   `C_Spell.GetSpellCooldown` for Feral Frenzy gives a usable number in combat. If it does not, a
   timer from our own code cannot know when it came off cooldown. Say so on the card and stop.
3. **Taint.** Card `0038` is open: something taints the action buttons. Calling
   `ActionButton_ShowOverlayGlow` (or any glow on a Blizzard button) from addon code can add more
   taint. Prefer a glow that does not write to the secure button: for example, the button's own
   overlay path Blizzard uses for proc glows, if addon code can call it safely. Test in combat
   with `/console taintLog 2`.

## Scope

- Feral only. Feral Frenzy only. Other spells are a later card if this one helps.
- The glow starts 2 seconds after the spell is ready, and stops when he casts it or leaves combat.
- The delay is one value near the top of the file, so it can be tuned in the game.
- Rob uses Blizzard's default action bars. Find the button by spell on those bars; do not assume
  a slot.

## Acceptance

- [ ] Native option checked and the result written here.
- [ ] In a raid pull, Feral Frenzy's own action button glows when it has sat ready for 2 seconds.
- [ ] The glow stops when he casts it.
- [ ] Nothing new appears on the screen besides the glow on the existing button.
- [ ] `/console taintLog 2` shows no new taint from this addon after a pull.
- [ ] `lua offline-check.lua` passes.
- [ ] After a week of raids: Feral Frenzy casts per minute, before and after, from Warcraft Logs.
