# Twelve talent addons, read for what to take

**Question.** Rob likes the look of TalentLoadoutsEx and the features of
ImprovedTalentLoadouts, and has used both and moved away. What should a Djinni
addon take from them, and from the other ten he downloaded?

**Date.** 2026-09-23. Source is the code in `research/` (gitignored, never
deployed), read on this machine. Nothing here was run in a client.

## The one design choice that matters

There are two ways to keep a list of builds, and every addon here picks one.

| | Blizzard's saved loadouts | The addon's own list |
|---|---|---|
| How a build is stored | `C_ClassTalents.ImportLoadout`, one server slot each | A string in SavedVariables |
| Limit | 40 slots (`MAX_COMBAT_TRAIT_CONFIGS`) | None |
| How a build is worn | Blizzard's `LoadConfig` | The addon writes each node into the active config, then commits |
| Shows in Blizzard's dropdown | Yes | No |
| Who uses it | DjinnisDreamgrove, DjinnisBiS today | **TalentLoadoutsEx**, TalentLoadoutManager, ImprovedTalentLoadouts (which wears builds through one temporary Blizzard loadout of its own) |

**The own-list way removes three problems this workspace keeps hitting.** No
40-slot cap. No name to break when a loadout is renamed (DjinnisBiS's boss table
names DjinnisDreamgrove's loadouts, so `/dg tidy` would orphan it). And no
"edited" drift, because the check is by content: see the tick below.

## TalentLoadoutsEx (Morizo, 3.14.14, 2,769 lines, Interface 120100)

What makes it look good, all in `modules/list.lua` and `frame.lua`:

- **A panel docked to the right of the talent window**, built on Blizzard's own `ScrollBox` and list templates, so it reads as part of the game. It shifts the talent window left by half its own width, unless BlizzMove has placed it.
- **A 36 px icon on every row.** Raid builds get the boss's own portrait (a table of Season 2 encounter icon IDs in `preset.lua`), hero-tree builds get the hero atlas, and you can pick any icon.
- **Groups that fold open**, with a coloured stripe: blue for yours, another for presets.
- **A green tick on the row that matches your tree right now**, worked out by comparing every node (`IsTextLoaded`), never by name. A hand edit simply loses the tick.
- **A warning icon on a string the current tree cannot read** (`validator.lua`), so a stale build shows before you click it.
- Double-click to wear. Shift-click to link in chat.
- **Presets from two data addons** (PeaversTalentsData, from parses.gg, and MurlokExport), shown as read-only groups: "Raid: Heroic", "Mythic+", one row per boss.
- Locks itself in combat and hides its popups.

How it wears a build: reads the string with Blizzard's importer, then writes
class, spec and hero nodes into the active config one by one, then commits
(`import.lua`). No saved-loadout slot is used.

Weak spots: the list is per character spec only, with no gear or action bars
attached. 

## ImprovedTalentLoadouts (Lardeck, v3.14.2, 4,178 lines in one file)

The features, from its right-click menu and function list:

- **Categories with sub-categories**, exportable and importable as a group.
- **Per loadout: a gear set, an Edit Mode layout, and saved action bars**, all loaded with the talents.
- **Class tree and spec tree saved separately**, so one class tree can pair with several spec trees.
- Update a loadout from the current tree or from a pasted string. Custom sort order.
- Spec buttons for fast spec switching. Post a build in chat. Rewrites talent macros.
- Its own account-wide store (`TalentLoadoutProfilesDB`), shared across characters of the class.

Weak spots, from the code: it **replaces Blizzard's loadout dropdown** with its
own menu, which is the part most likely to break on a patch. It ships the
`TaintLess` library to cope with taint from doing that. To wear a build it
keeps one temporary Blizzard loadout of its own, resets it, writes the nodes
in top-to-bottom order and commits (`LoadAsBlizzardLoadout`, `CommitLoadout`),
cleaning up stray temporary ones at login (`DeleteTempLoadouts`). That is one
slot and more moving parts than TalentLoadoutsEx's direct write into the active
config.

## The other ten, one line each

| Addon | Does | Worth taking |
|---|---|---|
| TalentTreeTweaks (Numy) | 20 small fixes to the talent window | **`inspectDiff`**: highlights which nodes differ between two builds, on the tree itself. That is the "which talents are my choices" view, drawn where you look |
| TalentLoadoutManager (Numy) | Own-list manager with a sidebar | Its sidebar mixin, as a second reference; Numy maintains carefully |
| TalentTreeViewer (Numy) | View any spec's tree from any character | Seeing a Guardian build while on Feral |
| PeaversTalents | Picks builds from parses.gg | The data source TalentLoadoutsEx reads |
| TalentLoadoutReminder | Asks you to switch on entering content | Same job as DjinnisBiS card 0013 |
| TalentLoadoutBroker | Switch loadout from a data bar | Same job as DjinnisBiS card 0026 |
| FlashTalent, TalentMacros, Talentless | Interface 90001 to 90200 | Nothing. Shadowlands-era, pre-talent-tree |

## What a Djinni version would be

**Home: the DjinnisBiS sidebar** that already sits beside the talent window
(card 0019). Not a new addon, and not DjinnisDreamgrove, which becomes the data
source only.

1. **Own list, not Blizzard slots.** Wear a build the TalentLoadoutsEx way.
2. **The TalentLoadoutsEx look**: boss portraits, folding groups, the green tick by content, the warning icon.
3. **Groups by where you are**: one per raid boss, one for dungeons. Rows inside are the builds for that boss, per spec.
4. **From ImprovedTalentLoadouts, only what Rob used.** Gear set per build is already in DjinnisBiS (card 0012). Action bars and layout are open questions.
5. **The TalentTreeTweaks diff**: hover a row and the tree lights up the nodes that would change. That answers "what is a choice" in the game, not in a document.

## Settled by Rob

- **The temporary loadout was a sticking point with ImprovedTalentLoadouts** (Rob, 2026-09-23). So a Djinni version does not wear builds through a Blizzard loadout it owns and rewrites. It writes into the active config, the TalentLoadoutsEx way.

## Could not settle

- **Why Rob left TalentLoadoutsEx**, and whether the temporary loadout was the only problem with ImprovedTalentLoadouts. A Djinni version that repeats the reason is wasted work.
- Which ImprovedTalentLoadouts features he used.
- Whether writing nodes directly still works in 12.1 for every node type. TalentLoadoutsEx declares 120100 and its last change is recent, which is evidence, not proof.
