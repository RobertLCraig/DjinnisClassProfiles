# Healthstone-then-potion on one key: how AutoPotion and EQOL do it, and why it may fail in 12.1

Research for card `0083`. Read-only. Date 2026-10-01. Blizzard source: `C:\Dev\WoWAddons\wow-ui-source`, branch `live`, commit `09b9db794` "12.1.0 (69933)". Paths below marked `UI:` are relative to `wow-ui-source/Interface/AddOns/`.

## Summary

1. Both addons do the same thing: outside combat they rewrite an account-wide macro to `/castsequence reset=combat item:5512, item:<best potion>`, and leave the stone out when the bags hold none. Neither uses a secure button.
2. Blizzard's `/castsequence` code is essentially unchanged from 11.2.7 to 12.1, and `C_Item.GetItemCount` and `C_Item.GetItemCooldown` carry no secret flag. So nothing in the 12.1 API stops the technique.
3. Most likely causes of the failures Rob saw: a step that is on cooldown stalls the sequence until combat ends (AutoPotion #23, #77, #80); each addon adds only its single "best" potion, and Potent Healing Potion ranks below the Silvermoon potions in both; and Rob's own files show three duplicate `EnhanceQoLHealthMacro` macros, plus EQOL and AutoPotion macro bodies saved with no stone or potion in them.
4. Recommended: the same castsequence rewrite, but as a character macro found by index, with no duplicates and only the two items, rewritten when the stone's cooldown ends. The in-game test card must cover the stalls.

## AutoPotion

**Source.** https://github.com/ollidiemaus/AutoPotion, read at `fbc54bef` (2026-09-30, v3.16.2, `## Interface: 120100, 120105`). CurseForge project 312940, Wago `yQKybBG7` (from `AutoPotion.toc`). Below, `code.lua:N` means https://github.com/ollidiemaus/AutoPotion/blob/fbc54bef7edeebd6850a020a2c1c4a8a6c4829e6/code.lua#LN.

**Technique.**
- **Macro, not a secure button.** It creates the macro with `CreateMacro(macroName, "INV_Misc_QuestionMark")` if `GetMacroInfo(macroName)` is nil (`code.lua:157-166`). There is no `perCharacter` argument, so this is an **account** macro (compare Blizzard's call `CreateMacro(text, iconTexture, nil, isCharacterMacro)`, `UI:Blizzard_MacroUI/Blizzard_MacroIconSelector.lua:109`).
- **Body.** `"/castsequence [@player" .. combatCondition .. "] reset=" .. resetType .. " "`, followed by the class spells, then the items as `item:<id>` (`code.lua:433-442`, item formatting at `code.lua:253-271`). If Recuperate is known, it first adds `/cast [nocombat] Recuperate` and the condition becomes `[@player,combat]` (`code.lua:427-431`). The reset is `combat`, or `combat/<shortest spell CD>` if the user sets the "CD reset" option (`code.lua:217-223`).
- **Write.** `EditMacro(macroName, macroName, nil, macroStr)` inside a `pcall` that throws away any error (`code.lua:459-462`).
- **Order.** Tinker first, then Healthstone (unless "raidStone" moves it last), then potions (skipped in arenas and battlegrounds), then Cavedweller's Delight (`code.lua:126-155`). Class spells come before every item in the sequence (`code.lua:434-441`).
- **Item IDs and counts.** `ham.healthstone = Item.new(5512)` and `ham.demonicHealthstone = Item.new(224464)` (`Core/Potions.lua:39-40`). Counts use `C_Item.GetItemCount(self.id, false, false)`, which leaves out the bank and charges (`Core/Item.lua:23-25`). **Only one potion is ever added:** the loop `break`s on the first potion in the priority list that the bags hold (`code.lua:116-123`). In the retail list, Potent Healing Potion 258138 comes after six Concentrated/Fleeting/plain Silvermoon entries (`Core/Potions/Retail.lua:17-25`).
- **Events.** `ADDON_LOADED`, `BAG_UPDATE` (debounced 3 s), `PLAYER_ENTERING_WORLD`, `PLAYER_EQUIPMENT_CHANGED`, `TRAIT_CONFIG_UPDATED`, `PLAYER_REGEN_ENABLED` (+0.5 s), `UNIT_PET` (`code.lua:561-609`). Every event except `ADDON_LOADED` is dropped while `InCombatLockdown()` is true (`code.lua:580-582`).
- **Combat lockdown.** `MakeMacro` retries 4 times at 0.5 s intervals if it is in lockdown, then gives up (`code.lua:521-531`).
- **Spell detection** calls the global `IsSpellKnown` (`Core/Spell.lua:45-54`). The defaults enable Recuperate and a list of class and racial spells (`Core/DB.lua:14-20`). Druid Renewal was taken out for 12.0 (`Core/Spells/Retail.lua:8-14`).

**Issue tracker** (https://github.com/ollidiemaus/AutoPotion/issues). None of the titles mention Midnight, 12.0 or 12.1. The relevant ones:
- #23 "Cooldown issues" (2023-04-21, closed). The macro "stays on the previously used item" after a cooldown finishes. The author says the addon "just maintains a castsequence macro" and that `reset` cannot track different cooldowns. https://github.com/ollidiemaus/AutoPotion/issues/23
- #77 "[Bug?] Defaulting to Healthstone while on cooldown" (2025-02-24, closed). After combat the macro goes back to the stone even though the stone is on cooldown. The author: "currently intended ... because of the reset condition combat." https://github.com/ollidiemaus/AutoPotion/issues/77
- #80 "Addon stops at fortitude of the bear and does not consume the healing potion and healthstone" (2025-04-06, closed 2026-09-19). A spell step blocked the items. https://github.com/ollidiemaus/AutoPotion/issues/80
- #101, #102 (2026-03-21, 2026-04-01): requests to support 258138. Support was added in `12249ec` (2026-03-06) and moved down the priority list in `176cfae` (2026-03-11). https://github.com/ollidiemaus/AutoPotion/issues/102
- #112 "Potent Healing Potion is not adding to macro" (2026-08-22, closed 2026-09-19). The author confirms that only the single highest-healing potion is added, by design. https://github.com/ollidiemaus/AutoPotion/issues/112

**Midnight commits.** `2471b62` (2026-02-03) leaves potions and Recuperate out in instanced PvP. `6a19aed`, `78df2da` and `e7b3150` (2026-02-10) only change the TOC. `747a0eb` (2026-06-02) updates bandages. `db02052` (2026-08-04) adds the 12.1 potions. No commit touches macro writing or combat handling for 12.x.

## EQOL (EnhanceQoL)

**Source.** The upstream repository named in the addon's own README, `R41z0r/EnhanceQoL`, returns HTTP 404 (`gh api repos/R41z0r/EnhanceQoL` and `https://github.com/R41z0r/EnhanceQoL`, checked 2026-10-01). Without it there is **no public issue tracker**. The `Numynum/EnhanceQoL` mirror has issues turned off and stops at 2025-10-01. The newest public fork read was https://github.com/Yarnus/EnhanceQoL at `20ee7569` (2026-07-13). The copy Rob has installed is newer (`## Version: 13.6.2`, `## Interface: 120100`) and its macro core is the same apart from Earthen and mage-food lines. The references below are to that installed copy (read only, not edited): `C:\Games\World of Warcraft\_retail_\Interface\AddOns\EnhanceQoL\Modules\Food\`, written `EQOL:<file>:<line>`.

**Technique.**
- **Off by default.** `init("healthMacroEnabled", false)` (`EQOL:EnhanceQoLHealthMacro.lua:30`). It is on in Rob's SavedVariables.
- **Creation.** `EnsureGlobalMacro` checks `GetMacroInfo(name)`, refuses in `InCombatLockdown()`, checks `GetNumMacros()` against `MAX_ACCOUNT_MACROS or 120`, then calls `CreateMacro(name, icon)`. That makes an **account** macro (`EQOL:Init.lua:419-435`). The seed body is `/use item:224464` or `/use item:5512` (`EQOL:EnhanceQoLHealthMacro.lua:75-97`).
- **Body.** `/castsequence reset=%s %s`, or `/castsequence [combat] ...` when a Recuperate or mage-food line comes first (`EQOL:EnhanceQoLHealthMacro.lua:589-591`). It holds at most 4 steps (`:555`). Tokens are `"item:" .. id` (`EQOL:Init.lua:396-399`). The reset is `combat` by default (`:33`).
- **Order.** Priority categories, by default `{ "stone", "potion", combatpotion?, "none" }` (`:259`). It picks **one item per category**: whichever has the least cooldown remaining, then the highest `heal` value (`:282-318`, cooldown from `C_Item.GetItemCooldown` at `:167`).
- **Item list.** `Health.lua:72-82`: 5512 and 224464 as type `stone`. 258138 has `heal = 175000`, below Silvermoon 241305 (205956) and 241304 (241303), so it is only chosen when no Silvermoon potion is in the bags. Before `34e2d2ea` (2026-03-16, Yarnus fork history), 258138 was listed at `requiredLevel = 5, heal = 1500` and so lost to almost every other potion.
- **Write.** If the generated key has changed, it checks `InCombatLockdown()` again, then calls `EditMacro(healthMacroName, healthMacroName, nil, macroBody)` (`:606-611`). `updateHealthMacro` returns early while `UnitAffectingCombat("player")` (`:621-631`).
- **Events.** `PLAYER_LOGIN`, `PLAYER_REGEN_ENABLED`, `BAG_UPDATE_DELAYED`, `PLAYER_LEVEL_UP`, `UNIT_MAXHEALTH`, `PLAYER_EQUIPMENT_CHANGED`, plus `BAG_UPDATE_COOLDOWN` when "reorder by cooldown" is on (`:635-662`). On a cooldown change it rebuilds the macro, but only out of combat.
- **12.x handling.** Added for the Midnight beta in `e0412122` (2025-11-13): `issecretvalue` guards around `C_Spell.GetSpellCooldown` (`:62-72`). Item cooldowns are not guarded, and per the API docs below they do not need to be.

**Evidence from Rob's install** (read only):
- `C:\Games\World of Warcraft\_retail_\WTF\Account\958357#1\macros-cache.txt:157-168` holds **three** account macros named `EnhanceQoLHealthMacro` (ids 0x129, 0x133, 0x134). `EditMacro(name, ...)` edits one of them, so a copy dragged to the bar can stay stale for ever. The likely cause is `GetMacroInfo(name)` returning nil before the macro list has loaded, so a new macro is created. This is inferred, not proven.
- `...\WTF\Account\DJINNWRAITH\macros-cache.txt:149-153` (written 2026-10-01 12:43): the EQOL macro body is `#showtooltip /stopcasting /cast [nocombat] Recuperate`, with **no castsequence line**, even though `SavedVariables\EnhanceQoL.lua:24233-24238` has the order stone, potion, combatpotion, spell. At the last write EQOL therefore found no stone and no potion. Either the bags really held neither, or the count came back 0.
- The same file at `:26-30` keeps an `AutoPotion` macro whose castsequence has **no steps**: `/castsequence [@player,combat] reset=combat ` with nothing after it. AutoPotion is no longer in `Interface\AddOns`, so that body is stale. A step-less castsequence does nothing in combat.

## Blizzard 12.1 API facts

- **`EditMacro`, `CreateMacro` and `GetMacroIndexByName` are not in `Blizzard_APIDocumentationGenerated`.** Only `C_Macro.GetMacroName`, `GetSelectedMacroIcon`, `RunMacroText` and `SetMacroExecuteLineCallback` are there (`UI:Blizzard_APIDocumentationGenerated/UIMacrosDocumentation.lua:10-62`). `RunMacroText` is `HasRestrictions = true` (`:41-43`). The globals still exist in 12.1, because Blizzard calls them: `CreateMacro(text, iconTexture, nil, isCharacterMacro)` and `EditMacro(actualIndex, text, iconTexture)` (`UI:Blizzard_MacroUI/Blizzard_MacroIconSelector.lua:109,112`), and `EditMacro(actualIndex, nil, nil, body)` (`UI:Blizzard_MacroUI/Blizzard_MacroUI.lua:344`). The source does not show that they are blocked in combat. Both addons assume it, and card `0068` records it.
- **Macro limits:** `MAX_ACCOUNT_MACROS = 120`, `MAX_CHARACTER_MACROS = 30` (`UI:Blizzard_APIDocumentationGenerated/MacroConstantsDocumentation.lua:10-11`).
- **`C_Item.GetItemCount(itemInfo, includeBank, includeUses, includeReagentBank, includeAccountBank)`** carries only `SecretArguments = "AllowedWhenUntainted"`, with no secret return (`ItemDocumentation.lua:429-445`). **`C_Item.GetItemCooldown`** is the same (`ItemDocumentation.lua:412-427`), as is `C_Container.GetItemCooldown` (`ContainerDocumentation.lua:337-352`). The `ContainerItemInfo` fields carry no secret flag (`ContainerDocumentation.lua:766-783`).
- **Spell cooldowns are secret in restricted states. Item cooldowns are not.** `C_Spell.GetSpellCooldown` is `SecretWhenCooldownsRestricted` (`SpellDocumentation.lua:268-271`). That flag applies "when combat, encounter, challenge mode, or PvP match addon restrictions are in effect" (`SecretPredicatesDocumentation.lua:89-92`), and its predicate is `C_Secrets.ShouldCooldownsBeSecret` (`SecretPredicateAPIDocumentation.lua:129-137`). So the Healthstone's spell (6262) cooldown read through `C_Spell` can be secret in combat, while `C_Item.GetItemCooldown(5512)` is documented as plain.
- **Restriction states are wider than combat:** Combat, Encounter, ChallengeMode (a whole M+ key), PvPMatch, Map, Chat (`RestrictedActionsConstantsDocumentation.lua:26-31`). `InCombatLockdown` has no annotation (`RestrictedActionsDocumentation.lua:45-53`). The source does not say whether `EditMacro` is refused out of combat inside an M+ key.
- **How `/castsequence` works in 12.1** (`UI:Blizzard_ChatFrameBase/Shared/CastSequenceManager.lua`):
  - A step counts as an item only if `C_Item.GetItemInfo(action)` returns data or it parses as a bag/slot (`:18-23`). Otherwise it is treated as a spell name.
  - The sequence advances **only** on `UNIT_SPELLCAST_SUCCEEDED` whose spell ID matches the current step (`:63-93`). A failed use (no item, item on cooldown) leaves the step where it is.
  - `reset=combat` resets on `PLAYER_REGEN_ENABLED` (`:97-108`). It also resets on death (`:55-59`) and after the last step (`:44-50`).
  - State is keyed by the **sequence text** (`:145-159`). Rewriting the macro out of combat therefore starts the sequence again at step 1. Rewriting it with identical text does not.
  - Since 11.2.7 (`74fbbd65a`) the file has changed only to use `C_SpellBook.Find*` and `RegisterUnitEvent("...", "player", "pet")` (12.0.0 `e97025bc5`, 12.0.1 `1aeafa3b6`).
- **Spellcast event payloads stay readable for the player.** `UNIT_SPELLCAST_SUCCEEDED` is `SecretWhenUnitSpellCastRestricted` (`UnitDocumentation.lua:4701-4713`), but that applies only "if the unit being queried ... is not the player or their pet", with a caveat that "individual spells may be flagged as never or always secret" (`SecretPredicatesDocumentation.lua:109-111`).
- **`/use item:ID` path:** `SecureCmdItemParse` / `SecureCmdUseItem` (`UI:Blizzard_ChatFrameBase/Shared/ChatFrameUtil.lua:1129-1152`). The `/castsequence` and `/use` handlers carry no 12.x note. `SecureCmdOptionParse` (macro conditionals) is engine-side and not in this source.
- **Secure buttons:** `SECURE_ACTIONS.item` (`UI:Blizzard_FrameXML/SecureTemplates.lua:415-436`) and `SECURE_ACTIONS.macro` with `macrotext` via `C_Macro.RunMacroText` (`:447-461`). The restricted snippet environment offers no bag-count or item-cooldown function (`UI:Blizzard_RestrictedAddOnEnvironment/RestrictedEnvironment.lua:81-159`), so a secure handler cannot choose stone or potion in combat either.
- **The global `IsSpellKnown` (used by AutoPotion) is defined only in `UI:Blizzard_DeprecatedSpellBook/Deprecated_SpellBook.lua:16-20`, behind `if not GetCVarBool("loadDeprecationFallbacks") then return end` (`:4-6`).** The CVar is not set in Rob's `WTF\Config.wtf`, and its default is not in the source. If it is off, AutoPotion's `isKnown` throws, and the macro update aborts before `EditMacro`. The Recuperate line in Rob's saved AutoPotion macro shows it worked at some point.

## Recommended technique

Keep `/castsequence`, which is the only in-combat fallback a macro offers. Build it so the known stalls cannot happen:

1. **One character macro** (`CreateMacro(name, icon, body, true)`, signature as in `Blizzard_MacroIconSelector.lua:109`). It uses one of the 30 character slots, not one of the shared 120, and no other character can overwrite it. Look it up with `GetMacroIndexByName`, and do not create it until the macro list is loaded, so the EQOL duplicates do not happen. If more than one exists, warn rather than create another.
2. **The body is only the two items**, as item IDs: `#showtooltip` / `/castsequence reset=combat item:5512, item:258138` with a stone in the bags, or `/use item:258138` with none. No class spells and no Recuperate line, so no extra step can block (AutoPotion #80).
3. **Rewrite only out of combat**, on `BAG_UPDATE_DELAYED`, `PLAYER_REGEN_ENABLED` and login. Register each event separately and confirm with `IsEventRegistered` (`docs/DECISIONS.md`, 2026-08-21). Check `InCombatLockdown()` right before `EditMacro`.
4. **Stone on cooldown out of combat:** write the potion first, or the potion alone. Read the cooldown with `C_Item.GetItemCooldown(5512)`, which carries no secret flag. Schedule a rewrite for when the cooldown ends, if still out of combat. This is EQOL's "reorder by cooldown" idea, applied across the stone and the potion. EQOL applies it only within each category.
5. **Count with `C_Item.GetItemCount(id, false, false)`.** The return carries no secret flag, so a plain `> 0` is safe. `issecretvalue` costs little as a guard anyway.

## Traps

- **A failed step stalls the sequence until combat ends.** It advances only on success (`CastSequenceManager.lua:63-93`). A stone on cooldown, or one used up in combat, blocks the potion for the rest of the fight (AutoPotion #23, #77).
- **`EditMacro` cannot help in combat.** Both addons skip combat (`code.lua:580`, `EQOL:EnhanceQoLHealthMacro.lua:621-631`). The macro you start the fight with is the one you have all fight.
- **`reset=combat` does not cover use out of combat.** Use the stone out of combat, keep the charges, and the macro text is unchanged, so step 2 (the potion) is still current when the next fight starts. Only a change of text or the end of a combat resets it (`:97-108`, `:145-159`).
- **Healthstone rules are not in the UI source.** EllesmereUI's code says plain stone 5512 has a once-per-combat lockout (spell 6262) and "Demonic stones are reusable in combat": https://github.com/EllesmereGaming/EllesmereUI/blob/main/EllesmereUICooldownManager/EllesmereUICooldownManager.lua (preset `healthstone`, around line 625-636). AutoPotion's comment says the Demonic stone has a 1-minute cooldown (`Core/Potions.lua:40`). Both are third-party claims. The macro should accept 224464 as the stone too.
- **Account macros:** both addons create account macros (`code.lua:164`, `EQOL:Init.lua:432`). Every character rewrites the same body, a character without the addon keeps a stale one, and duplicates go unnoticed (Rob's `958357#1` file).
- **"Best potion only":** both pick one potion. With any Silvermoon potion in the bags, 258138 is never used (#112, `Health.lua:80-82`).
- **Item cache:** a step becomes an item only if `GetItemInfo` answers when the sequence is first used (`CastSequenceManager.lua:18`). An uncached item ID is treated as a spell name and fails.
- **Deprecated global:** AutoPotion's `IsSpellKnown` depends on `loadDeprecationFallbacks` (`Deprecated_SpellBook.lua:4-20`). Ours must use `C_SpellBook`, if it needs spells at all.
- **Macro limits:** 120 account and 30 character (`MacroConstantsDocumentation.lua:10-11`). `CreateMacro` returns nothing useful when you are at the limit. EQOL counts first (`EQOL:Init.lua:424-430`).

## Must test in game

1. With a stone and 258138 in the bags: in combat, press 1 uses the stone and press 2 the potion. Without a stone, press 1 uses the potion.
2. The stone on cooldown when combat starts: does the potion-first rewrite land, and does the plain sequence really stall?
3. Is 5512 once per combat in 12.1? How many charges does it have, and does `GetItemCount(5512, false, true)` differ from `false, false`?
4. Does the rewrite happen inside a Mythic+ key between pulls (ChallengeMode restriction), or is `EditMacro` refused there out of combat?
5. `/dump GetCVar("loadDeprecationFallbacks")` and `/dump IsSpellKnown`, to settle why AutoPotion's macro on DJINNWRAITH has an empty sequence.
6. At login, is `GetMacroIndexByName` non-zero for an existing macro at `PLAYER_LOGIN`, or only after `UPDATE_MACROS` / `PLAYER_ENTERING_WORLD`? This decides how to avoid duplicates.
7. With EQOL enabled and 258138 in the bags, does `EnhanceQoLHealthMacro` gain a castsequence line? This tests whether the empty body Rob has was an empty bag or a counting fault.
8. Out of combat: use the stone, then pull. Is the stone-first order back, or is the potion first?
