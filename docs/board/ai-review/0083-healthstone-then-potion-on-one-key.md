---
needs: 0082
---
# 0083 Healthstone, then the healing potion, on one key

## Why

Rob, 2026-10-01: "Shift 2 should be healing potion on all classes and specs, shift s healthstone
(ideally I would like them on the same key, with healthstones being prioritised)".

Today the two heals are on two keys, Shift+S (Healthstone, item 5512) and Shift+2 (Potent Healing
Potion, item 258138). In a bad moment he has to choose a key, and the stone, which costs nothing,
should always go first.

A plain macro cannot do it. Two `/use` lines use both items in one press when both are ready, which
wastes the potion. `/castsequence reset=combat Healthstone, Potent Healing Potion` sticks on its
first step when there is no stone in the bags, so the potion never fires. Rob: "Your healthstone
macro doesnt account for not having one I think (Id still have to press the button twice when I
didnt have one)". A macro has no conditional for "I have this item".

## Links

- Depends on `0082`: the key plan that puts both items on bars (`docs/research/2026-10-01-keybind-layout.html`).
- `PlanTab.ITEM_JOBS` in `DjinnisClassProfiles.lua` knows Healthstone and Damage Potion, not the healing potion.

## Not this card

- Choosing which potion. The item is 258138 until Rob says otherwise.
- Any change to the keybind page.
- Moving bars or keys. The macro goes on the key Rob names; the addon does not place it.

## Acceptance

<!-- AC:BEGIN -->
- [x] WHEN the bags hold a Healthstone, THE ADDON SHALL write the macro as a cast sequence of the stone then the potion. proves: `heal macro: stone then potion when a stone is in the bags`
- [x] WHEN the bags hold no Healthstone, THE ADDON SHALL write the macro to use the potion alone. proves: `heal macro: potion alone with no stone`
- [x] WHEN the bag contents change in combat, THE ADDON SHALL wait and rewrite the macro after combat ends. proves: `heal macro: no rewrite in combat, one after`
- [x] WHEN `PlanTab.jobOf` reads item 258138, THE ADDON SHALL name its job "Healing Potion". proves: `jobs on the bars, a known item's job`
<!-- AC:END -->

## Tasks

- [x] Add 258138 = "Healing Potion" to `PlanTab.ITEM_JOBS`, with a short label.
- [x] One character macro, created if missing, rewritten on `BAG_UPDATE_DELAYED` and `PLAYER_REGEN_ENABLED` with `EditMacro` (present in 12.1: `Blizzard_MacroUI.lua:344`; protected in combat).
- [x] The self-test checks named above, run by `lua offline-check.lua`.
- [x] In-game look for Rob: with a stone, one press uses the stone and the next the potion; with none, one press drinks the potion.

## Plan

Stand in `C:\Dev\WoWAddons\DjinnisClassProfiles`. Read `docs/DECISIONS.md` on protected events and
secret values first: `BAG_UPDATE_DELAYED` must register (check it is not refused) and an item count
must be readable outside combat. Use `C_Item.GetItemCount` (see
`wow-ui-source/Interface/AddOns/Blizzard_APIDocumentationGenerated/ItemDocumentation.lua`). Run
`"C:\Program Files (x86)\Lua\5.1\lua.exe" offline-check.lua`; it ends with no FAIL lines.

## Comments

**2026-10-01, Claude.** Opened from Rob's two messages quoted in `## Why`, during card `0082`. The criteria above were written before the code; the check names were fixed to the printed names after.

**2026-10-01, Rob:** "there are a number of addons that purpotedly do the healthstone macro (autopotion/eqol) but I've not had much luck with them in midnight." So the in-game look is the real test, and the first task is finding why those fail; read their source (CurseForge or GitHub via `gh`) before writing ours. One fact checked: `C_Item.GetItemCount` has no secret return in 12.1 (`ItemDocumentation.lua:429`, `SecretArguments = "AllowedWhenUntainted"` only).

**2026-10-01, Claude.** Why the others fail, with sources: `docs/research/2026-10-01-healthstone-macro-addons.md`. Nothing in 12.1 broke them: `/castsequence` advances only on a use that worked, so a stone on cooldown holds the potion back all fight; both pick one "best" potion (not 258138); both write account macros, and Rob's account has three `EnhanceQoLHealthMacro` copies; AutoPotion calls `IsSpellKnown`, which 12.1 defines only behind `loadDeprecationFallbacks`.
Built in v0.65.0, deployed: `PlanTab.healBody`, `healRewrite`, `healMake`, `healWatch` beside the bars command. More > Make the heal macro makes one character macro, `DCP Heal`, never a second. Out of combat it is rewritten on `BAG_UPDATE_DELAYED`, `BAG_UPDATE_COOLDOWN`, `PLAYER_REGEN_ENABLED` and `PLAYER_ENTERING_WORLD`: stone ready, `/castsequence reset=combat item:<stone>, item:258138`; no stone or the stone cooling down, `/use item:258138`, and a timer puts the stone back first when it is ready. Demonic Healthstone (224464) counts as a stone. The addon never puts the macro on a key. `lua offline-check.lua` and `lua offline-check.lua 250` end with no FAIL lines. Six mutants (the cooldown test, the combat guard, the same-text guard, the item job, the secret guard, the Demonic stone) each turn the suite red.
In-game looks, for Rob, `/reload` first:
1. More > Make the heal macro. Chat says it was made. Esc > Macros > Character Specific Macros shows `DCP Heal`. Drag it onto Shift+S.
2. With a Healthstone and a Potent Healing Potion in the bags, on a dummy: press 1 uses the stone, press 2 drinks the potion.
3. Out of combat, with no stone (or right after using it): the macro's text reads `/use item:258138`, and one press drinks the potion.
4. Make the macro again from the menu: chat says you already have it, and the macro list still holds one.
5. Inside a Mythic+ key, between pulls, after using the stone: does the macro change to the potion? The research could not settle whether `EditMacro` is allowed there.
Pass: all five as written, and no Lua error with `/console scriptErrors 1`.

**2026-10-01, Rob:** "will this work with other healing potions for midnight? (as well as say rogues thistle tea?) ... maybe recuperate? ... and will the icon update to show what it will do?" Then, on the potion order: "1 (but healthstones always go first)".

**2026-10-01, Claude.** v0.65.1, deployed: `PlanTab.HEAL_POTIONS`, the first in the bags is the potion: Fleeting Silvermoon (245918, 245919), Concentrated Silvermoon (271884, 271883), Silvermoon (241304, 241305), Potent (258138); the higher rank first (AutoPotion's `Core/Potions.lua` names). The stone stays first. None in the bags writes 258138. All seven are the Healing Potion job. Not added: Thistle Tea (energy, a different job) and Recuperate (a step that fails, no combo points, holds the potion back; AutoPotion #80). Five more checks; three mutants (the pick, the rank order, the job list) each turn the suite red.
Two more looks for Rob:
6. With a Fleeting and a Potent potion in the bags and no stone: one press drinks the Fleeting one.
7. The macro's icon is the stone while a stone is ready, the potion after it is used, grey with neither.

**2026-10-01, Rob**, on Feral's Frenzied Regeneration: "if the macro works. I guess it could go on shift S". **Claude:** so the macro goes on Shift+2 (the healing potion key, every spec), not Shift+S as look 1 says; drag it there. When looks 1 to 7 pass, the key page drops the Healthstone from Shift+S in all 40 specs, and Feral's Frenzied Regeneration moves from Shift+4 to Shift+S. Not done before then: a failed macro would leave the stone with no key.

**2026-10-01, Rob:** "macro seems to work okay!" **Claude:** the in-game task ticked. Look 5 (a rewrite between pulls in a Mythic+ key) is still open unless Rob says he saw it. The key page now gives the Healthstone no key in any spec, and Feral Frenzied Regeneration is on Shift+S.
