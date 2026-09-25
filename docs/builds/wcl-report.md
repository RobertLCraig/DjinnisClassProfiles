# What top Warcraft Logs players run

Written by `wcl-builds.py` on 2026-09-25 13:53 UTC, for every class. Card 0064. From `wcl-builds.json`, `update-builds.py` takes every spec's typical Mythic+ build as `Dungeon`, every typical raid build as `Raid` for a spec with no boss rows, and for each druid boss row the typical pooled over its bosses.

- **Raid:** The Venomous Abyss, Mythic, every boss, top 100 a boss by dps (hps for healers).
- **Mythic+:** Mythic+ Season 2, every dungeon, top 100 a dungeon by score.
- **Sample:** one ranking is one character's best logged kill or run this season on that boss or dungeon, so a
  character counts once per boss. Not Archon's "top 50% in the last 14 days"; the dates below say how recent it is.
- **Typical:** the build somebody ran that differs least from all the others, talent by talent (the medoid).
  Agreement is the average share of the sample taking each of its contested talents (those fewer than 90% take).
  The most common exact string is often 2% of a sample and says little; the typical build follows the majority.
- **Split talents:** picked by more than 10% and fewer than 90% of the sample.
- **Ours:** each build in the addon's BUILDS **as it stood when this ran** (run `update-builds.py`, then this
  again, to see the new ones), how many run it exactly, and what the typical build has that it lacks (+) and the
  other way. Every row is compared with the whole sample; a druid boss row is also compared with its own boss below.

## Blood Death Knight

### Raid

805 rankings over 10 bosses, logged 2026-08-26 to 2026-09-25. 520 distinct builds. Hero tree: San'layn 87%, Deathbringer 13%.

**Typical** (San'layn, agreement 81% on 25 contested talents, 13 run it exactly):

`CoPAAAAAAAAAAAAAAAAAAAAAAwYWGzMmxMzMMbzMz0MLmZMmxAAAAAmZmZmZmZYGjBAjZmZGAAADMwMW0YZDw2A2AMjZAAAzMwwA`

**Most common other builds**, each against the typical:

- 18 (2.2%): +Enfeeble; -Death Notes
  `CoPAAAAAAAAAAAAAAAAAAAAAAwYWGzMmxMzMMbzMz0MLmZMmxAAAAAmZmZmZmZYGjBAjZmZGAAADMwMW0YZDw2A2AMjZAAAzMYwA`
- 14 (1.7%): +Enfeeble; -Grip of the Dead
  `CoPAAAAAAAAAAAAAAAAAAAAAAwYWGzMmxMjhZbmZmmZxMjxMGAAAAwMzMzMzMDzYMAYMzMzAAAYgBmxiGLbA2GwGgZMDAAYmBzwA`
- 13 (1.6%): +Subduing Grasp; -Blood Scent
  `CoPAAAAAAAAAAAAAAAAAAAAAAwYWGzMmxMzMMbzMz0MLGzMmxAAAAAmZmZmZmZYGjBAjZmZGAAADMwMW0YZDw2A2AMjZAAAzMwwA`
- 9 (1.1%): +Osmosis; -Grip of the Dead
  `CoPAAAAAAAAAAAAAAAAAAAAAAwYWGzMmxMjhZbmZmmZxMjxMmBAAAAmZmZmZmZYGjBAjZmZGAAADMwMW0YZDw2A2AMjZAAAzMwwA`

**Split talents:** Suppression 89%; Gorefiend's Grasp (choice) 89%; Death's Reach (choice) 89%; Relish in Blood 88%; Sanguinary Burst 88%; Visceral Strength 87%; Transfusion 87%; Thrill of Blood 87%; The Blood is Life 87%; Infliction of Sorrow 87%; Inevitable 87%; Incite Terror 87%; Gift of the San'layn 87%; Frenzied Bloodthirst 87%; Pact of the San'layn (choice) 83%; Blood-Soaked Ground (choice) 82%; Assimilation 81%; Bloody Fortitude (choice) 78%; Bloodied Blade 75%; Vampiric Speed (choice) 74%; Blood Scent 73%; March of Darkness (choice) 72%; Death Notes 64%; Grip of the Dead 46%; Enfeeble 45%; Blinding Sleet 33%; Osmosis 29%; Wraith Walk (choice) 27%; Foul Bulwark 23%; Subduing Grasp 17%; Coldthirst 17%; Bloodworms 16%; Wither Away 13%; Wave of Souls 13%; Swift and Painful 13%; Soul Rupture 13%; Rune Carved Plates (choice) 13%; Grim Reaper 13%; Frigid Resolve 13%; Exterminate 13%; Echoing Fury 13%; Deathly Blows 13%; Bind in Darkness 13%; Dark Talons (choice) 13%; Death Pact 13%; Death's Messenger (choice) 12%; Newly Turned (choice) 12%; Asphyxiate (choice) 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 13 of 805 run it exactly.

### Mythic+

702 rankings over 8 dungeons, logged 2026-09-05 to 2026-09-25, keys 20 to 22 (median 21). 117 distinct builds. Hero tree: San'layn 99%, Deathbringer 1%. 98 left out: their log has no talents.

**Typical** (San'layn, agreement 75% on 4 contested talents, 93 run it exactly):

`CoPAAAAAAAAAAAAAAAAAAAAAAwMzyMzwMmZmhZbmZmmZxMjZmxAAAAAmhZmZmZMzYAAzMzMzAAAYgBmxiGLbA2GwGgZMAAAzMAGA`

**Most common other builds**, each against the typical:

- 110 (15.7%): +Assimilation; -Suppression
  `CoPAAAAAAAAAAAAAAAAAAAAAAwMzyMzMmxMzMMbzMz0MLmZMzMAAAAAmhZmZmZMzYAAzMzMzAAAYgBmxiGLbA2GwGgZMAAAzMAGA`
- 64 (9.1%): +Assimilation; -Blood Scent
  `CoPAAAAAAAAAAAAAAAAAAAAAAwMzyMzMmxMzMMbzMz0MLGjZmxAAAAAmhZmZmZMzYAAzMzMzAAAYgBmxiGLbA2GwGgZMAAAzMAGA`
- 49 (7.0%): +Subduing Grasp; -Suppression
  `CoPAAAAAAAAAAAAAAAAAAAAAAwMzyMzwMmZmhZbmZmmZxMzMzMAAAAAmhZmZmZMzYAAzMzMzAAAYgBmxiGLbA2GwGgZMAAAzMAGA`
- 24 (3.4%): +Death Pact; -Suppression
  `CoPAAAAAAAAAAAAAAAAAAAAAAwMzyMzwMmZmhZbmZmmZZmZMzMAAAAAmhZmZmZMzYAAzMzMzAAAYgBmxiGLbA2GwGgZMAAAzMAGA`

**Split talents:** Death's Reach (choice) 90%; Permafrost 89%; Blood Scent 77%; Suppression 43%; Assimilation 33%; Death Pact 23%; Subduing Grasp 15%; Control Undead 11%; Enfeeble 10%; Death Defiance 10%; Asphyxiate (choice) 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 93 of 702 run it exactly.

## Frost Death Knight

### Raid

705 rankings over 10 bosses, logged 2026-09-06 to 2026-09-25. 259 distinct builds. Hero tree: Deathbringer 100%, Rider of the Apocalypse 0%.

**Typical** (Deathbringer, agreement 69% on 8 contested talents, 13 run it exactly):

`CsPAAAAAAAAAAAAAAAAAAAAAAMAmZMjZYY2mZmZmZZmZkZMGDzMGMzMzMzMzMDAAAAAAAAAjZbgBsAWGmAjFMzYmZgBghZGAzgB`

**Most common other builds**, each against the typical:

- 58 (8.2%): +Enfeeble; -Unholy Endurance
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAmZMjZAz2MzMzMLzMjMjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAMzgB`
- 32 (4.5%): +Enfeeble, +Wraith Walk; -March of Darkness, -Unholy Endurance
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAmZMjZAz2MzMzMbzMjMjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAMzgB`
- 16 (2.3%): +Blinding Sleet; -Unholy Endurance
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAzMjZMDY2mZmZmZZmZkZMGDzMGMzMzMzMzMDAAAAAAAAAjZbgBsAWGmAjFMzYmZgBghZGAzgB`
- 15 (2.1%): +Blood Draw, +Coldthirst, +Enfeeble; -Death Defiance, -Death Pact, -Runic Protection
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAmZMjxYY2mZmZmZxMjmZMGDzMGMzMzMzMzMDAAAAAAAAAjZbgBsAWGmAjFMzYmZgBghZGgZgB`

**Split talents:** Death's Reach (choice) 88%; Assimilation 74%; Death Pact 73%; Runic Protection 67%; Death Notes 67%; Unholy Endurance 63%; Death Defiance 61%; March of Darkness (choice) 57%; Enfeeble 56%; Blood Draw 53%; Blinding Sleet 49%; Wraith Walk (choice) 41%; Coldthirst 35%; Asphyxiate (choice) 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 13 of 705 run it exactly.

### Mythic+

649 rankings over 8 dungeons, logged 2026-09-01 to 2026-09-25, keys 19 to 21 (median 19). 171 distinct builds. Hero tree: Deathbringer 100%. 151 left out: their log has no talents.

**Typical** (Deathbringer, agreement 72% on 8 contested talents, 28 run it exactly):

`CsPAAAAAAAAAAAAAAAAAAAAAAMAzMMjZYY2mZmZmZbmZ0MjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAwgB`

**Most common other builds**, each against the typical:

- 34 (5.2%): +Blood Draw; -Runic Protection
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAzMMjxYY2mZmZmZbmZ0MjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAwgB`
- 27 (4.2%): +Assimilation; -Unholy Endurance
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAzMjZMDY2mZmZmZbmZ0MjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAwgB`
- 23 (3.5%): +Assimilation, +Blood Draw, +Death Notes; -Death Defiance, -Death Pact, -Runic Protection
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAzMjZMGDz2MzMzMbmZ0MjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAYgB`
- 20 (3.1%): +Blood Draw, +March of Darkness; -Runic Protection, -Wraith Walk
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAzMMjxYY2mZmZmZZmZ0MjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAwgB`

**Split talents:** Blood Scent 89%; Coldthirst 89%; Death's Reach (choice) 72%; Unholy Endurance 70%; Death Pact 70%; Wraith Walk (choice) 65%; Runic Protection 60%; Death Defiance 58%; Blood Draw 51%; Assimilation 40%; Death Notes 35%; March of Darkness (choice) 34%; Asphyxiate (choice) 28%; Enfeeble 24%; Grip of the Dead 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 28 of 649 run it exactly.

## Unholy Death Knight

### Raid

656 rankings over 10 bosses, logged 2026-09-07 to 2026-09-25. 396 distinct builds. Hero tree: San'layn 99%, Rider of the Apocalypse 1%.

**Typical** (San'layn, agreement 69% on 11 contested talents, 3 run it exactly):

`CwPAAAAAAAAAAAAAAAAAAAAAAAwMjZMGDz2MzMTjZmxYGDAAAAAAAAzDMMGAsMDzsZmxMzYgBmxmGLLA2GsBgZAMzMzMmBzMYmZMA`

**Most common other builds**, each against the typical:

- 22 (3.4%): +Blood-Soaked Ground, +Bloody Fortitude, +Runic Protection; -Blood Draw, -Desecrate, -Vampiric Aura
  `CwPAAAAAAAAAAAAAAAAAAAAAAAwMjZMDDz2MzMTjZmxYGDAAAAAAAAzDMMGAsMDzsZmxMzYgBmxiGLbA2GsBgZAMzMzMmBzMYmZMA`
- 21 (3.2%): +Runic Protection, +Wraith Walk; -Blood Draw, -Death Notes
  `CwPAAAAAAAAAAAAAAAAAAAAAAAwMjZMDDz2MzMTz2MzYMjBAAAAAAAg5BGGDAWmhZ2MzYmZMwAzYTjlFAbD2AwMAmZmZGzgZGMmxA`
- 21 (3.2%): +Blinding Sleet, +Coldthirst; -Assimilation, -Death Notes
  `CwPAAAAAAAAAAAAAAAAAAAAAAAYmhZMGDz2MzMTjZmxMzYAAAAAAAAYeghxAglZYmNzMmZGDMwM20YZBw2gNAMDgZmZmxMYmBjZMA`
- 11 (1.7%): +Coldthirst, +Commander of the Dead 2/2, +March of Darkness, +Menacing Magus, +Osmosis, +Outnumber; -Blightfall, -Commander of the Dead 1/2, -Death Defiance, -Death Pact, -Insidious Chill, -Scourging 2/2
  `CwPAAAAAAAAAAAAAAAAAAAAAAAwMDjxYY2mZmZaWMzYmZMDAAAAAAAgZGGDAWmxMzmZGzMjBGYGbassAYbwGGwMAMmZGzgZGMjxA`

**Split talents:** Insidious Chill 87%; Scourging 83%; Blightfall 83%; Assimilation 71%; Blood Draw 67%; Death Pact 64%; Vampiric Aura (choice) 55%; Desecrate (choice) 55%; Death Defiance 53%; Runic Protection 53%; Death Notes 53%; Blood-Soaked Ground (choice) 44%; Bloody Fortitude (choice) 44%; March of Darkness (choice) 43%; Wraith Walk (choice) 42%; Coldthirst 35%; Blinding Sleet 30%; Menacing Magus 27%; Osmosis 18%; Outnumber 17%; Grip of the Dead 14%

**Ours, against the whole sample:**

- `Raid`: the typical build. 3 of 656 run it exactly.

### Mythic+

684 rankings over 8 dungeons, logged 2026-09-04 to 2026-09-25, keys 18 to 21 (median 19). 355 distinct builds. Hero tree: San'layn 99%, Rider of the Apocalypse 1%. 116 left out: their log has no talents.

**Typical** (San'layn, agreement 70% on 16 contested talents, 5 run it exactly):

`CwPAAAAAAAAAAAAAAAAAAAAAAAYmhZMGDz2MzMTz2MzYmZMAAAAAAAAMPwYYAwyMY2MzYmZMwAzYTjlFAbD2wAmBwMzMzYGMzghxA`

**Most common other builds**, each against the typical:

- 15 (2.2%): +Blood-Soaked Ground, +Death Notes, +Grip of the Dead, +Runic Protection; -Death Pact, -Desecrate, -Enfeeble, -Suppression
  `CwPAAAAAAAAAAAAAAAAAAAAAAAYmhZMzMDz2MzMTzmZGzMDAAAAAAAAMPwYYAwyMY2MzYmZMwAzYRjlFAbD2wAmBwMzMzYGMzAjxA`
- 14 (2.0%): +Death Defiance; -Wraith Walk
  `CwPAAAAAAAAAAAAAAAAAAAAAAAYmhZMGDz2MzMTjZmxMzYAAAAAAAAYegxwAglZwsZmxMzYgBmxmGLLA2GshBMDgZmZmxMYmBjZMA`
- 9 (1.3%): +Death Defiance, +Unholy Devotion; -Coldthirst, -Ghoulish Frenzy
  `CwPAAAAAAAAAAAAAAAAAAAAAAAYmhZMGDz2MzMTz2MzYMjBAAAAAAAg5BGDDAWmhZ2MzYMjBGYGbassAYbwGGwMAmZmZGzgZGMmxA`
- 9 (1.3%): +Asphyxiate, +Grip of the Dead; -Death Pact, -Death's Reach
  `CwPAAAAAAAAAAAAAAAAAAAAAAAYmhZMmZYWmZmZa2MzYmZMAAAAAAAAMPwYYAwyMY2MzYmZMwAzYTjlFAbD2wAmBwMzMzYGMzghxA`

**Split talents:** Ghoulish Frenzy 86%; Desecrate (choice) 86%; Blood Scent 85%; Permafrost 82%; Unholy Endurance 77%; Reaping 73%; Soul Reaper 71%; Enfeeble 70%; Death Pact 69%; Death's Reach (choice) 64%; Scourging 63%; Blightfall 63%; Blood Draw 62%; Wraith Walk (choice) 59%; Vampiric Aura (choice) 57%; Grip of the Dead 57%; Unholy Devotion 56%; Runic Protection 49%; Death Defiance 45%; Bloody Fortitude (choice) 42%; Outnumber 37%; Asphyxiate (choice) 36%; Infected Claws 24%; March of Darkness (choice) 20%; Assimilation 19%; Death Notes 19%; Morbidity 18%; Blood-Soaked Ground (choice) 14%; Coil of Devastation 13%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 5 of 684 run it exactly.

## Devourer Demon Hunter

### Raid

710 rankings over 10 bosses, logged 2026-08-27 to 2026-09-25. 203 distinct builds. Hero tree: Void-Scarred 55%, Annihilator 45%.

**Typical** (Void-Scarred, agreement 60% on 31 contested talents, 2 run it exactly):

`CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzMzMGmBAAAAAAgxsNYGAAAAAAAAmxMMmZmZmZmZYmtZGjNttAAADwMmZmtZmpZbmlZmxYGA`

**Most common other builds**, each against the typical:

- 88 (12.4%): +Erratic Felheart 1/2, +Gift of the Void, +Soulforged Blades; -Demon Muzzle, -Eradicate, -Star Fragments
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2MmZmZmZmxwMAAAAAAAegxsNYGAAAAAAAAmxMMmZmZMzMzYmtZGjNttAAADwMmZmtZmpZbmlZmxMGA`
- 73 (10.3%): +Annihilator, +Catastrophe, +Celestial Echoes, +Dark Matter, +Emptiness, +Final Hour, +Harness the Cosmos, +Mass Acceleration, +Meteoric Fall, +Meteoric Rise, +Midnight 4/4, +Otherworldly Focus, +Phase Shift, +State of Matter, +Sweet Suffering 2/2, +Swift Erasure, +Voidpurge, +World Killer; -Blind Focus, -Burning Blades, -Demonic Intensity, -Devourer's Bite, -Duty Eternal, -Enduring Torment, -Flamebound, -Focused Hatred, -Hungering Slash, -Monster Rising, -Pursuit of Angriness, -Second Helping, -Set Fire to the Pain, -Singular Strikes, -Soul Glutton, -The Hunt, -Undying Embers, -Untethered Fury, -Violent Transformation, -Void-Scarred, -Voidrush, -Volatile Instinct
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzMzMGmBAAAAAAgxsNYGAAAAAAAAmxMMzMzMzMzMDzsYGjFZhZmZmt2mZmBwwAAwMGMmB`
- 34 (4.8%): +Burn It Out, +Champion of the Glaive, +Erratic Felheart 1/2, +Gift of the Void, +Sweet Suffering 1/2; -Demon Muzzle, -Sigil of Misery, -Soul Cleanse, -Voidrage 2/2
  `CgcBAAAAAAAAAAAAAAAAAAAAAAAWMmZmZmZmBmBAAAAAAY7BGz2gZAAAAAAAAYGzw8AzMzMzMzMjZ2mZM202CAAMAGzMz2Mz0sNzyMzYMDA`
- 31 (4.4%): +Annihilator, +Catastrophe, +Celestial Echoes, +Dark Matter, +Emptiness, +Erratic Felheart 1/2, +Final Hour, +Harness the Cosmos, +Mass Acceleration, +Meteoric Fall, +Meteoric Rise, +Midnight 4/4, +Otherworldly Focus, +Phase Shift, +State of Matter, +Sweet Suffering 2/2, +Swift Erasure, +Voidpurge, +World Killer; -Blind Focus, -Burning Blades, -Demon Muzzle, -Demonic Intensity, -Devourer's Bite, -Duty Eternal, -Enduring Torment, -Flamebound, -Focused Hatred, -Hungering Slash, -Monster Rising, -Pursuit of Angriness, -Second Helping, -Set Fire to the Pain, -Singular Strikes, -Soul Glutton, -The Hunt, -Undying Embers, -Untethered Fury, -Violent Transformation, -Void-Scarred, -Voidrush, -Volatile Instinct
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2MmZmZmZmxwMAAAAAAAegxsNYGAAAAAAAAmxMMzMzMzMzMDzsYGjFZhZmZmt2mZmBwwAAwMGMmB`

**Split talents:** Focused Ire 88%; Demonic Instinct 84%; Felfire Haste 84%; Voidrage 78%; Star Fragments 73%; Eradicate 73%; Sigil of Misery 70%; Sweet Suffering 69%; Gift of the Void 66%; Soul Cleanse (choice) 63%; Second Helping 57%; Erratic Felheart 57%; Volatile Instinct 55%; Voidrush 55%; Violent Transformation 55%; Untethered Fury 55%; Undying Embers 55%; The Hunt 55%; Soul Glutton (choice) 55%; Monster Rising 55%; Hungering Slash 55%; Focused Hatred 55%; Flamebound (choice) 55%; Enduring Torment 55%; Devourer's Bite 55%; Demonic Intensity 55%; Burning Blades 55%; Blind Focus 55%; Pursuit of Angriness (choice) 53%; Duty Eternal (choice) 53%; Singular Strikes 52%; Set Fire to the Pain (choice) 51%; Demon Muzzle 45%; World Killer 45%; Voidpurge 45%; Swift Erasure 45%; Phase Shift 45%; Otherworldly Focus 45%; Midnight 45%; Meteoric Rise 45%; Meteoric Fall 45%; Mass Acceleration 45%; Harness the Cosmos (choice) 45%; Final Hour 45%; Emptiness (choice) 45%; Dark Matter 45%; Celestial Echoes 45%; Catastrophe 45%; State of Matter (choice) 45%; Burn It Out (choice) 33%; Soulforged Blades 29%; Vengeful Bonds 16%; Scythe's Embrace (choice) 16%; Champion of the Glaive (choice) 13%; Master of the Glaive (choice) 13%; Charred Warblades 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 2 of 710 run it exactly.

### Mythic+

679 rankings over 8 dungeons, logged 2026-08-30 to 2026-09-25, keys 18 to 21 (median 19). 54 distinct builds. Hero tree: Annihilator 99%, Void-Scarred 1%. 121 left out: their log has no talents.

**Typical** (Annihilator, agreement 70% on 5 contested talents, 122 run it exactly):

`CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzMzMGmBAAAAAAgxsNYGAAAAAAAAmxMMzMzMzMzMzYmFzYsolFmZmZ2abmZGADDAAGDGzA`

**Most common other builds**, each against the typical:

- 133 (19.6%): +Swallowed Anger; -Felfire Haste
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzYmxwMAAAAAAAMmthZGAAAAAAAAmxMMzMzMzMzMzYmFzYsolFmZmZ2abmZGADDAAGDGzA`
- 52 (7.7%): +Master of the Glaive; -Focused Ire
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzMzMGmBAAAAAAYxY2GMDAAAAAAAAzYwMzMzMzMzMjZWMjxiWWYmZmZrtZmZAMMAAYMYMD`
- 46 (6.8%): +Demonic Instinct 2/2; -Gift of the Void, -Scythe's Embrace
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzMzMGmBAAAAAAgxsNYGAAAAAAAAmxMMzMzMzMzMDzsYGjFZhZmZmt2mZmBwwAAwMGMmB`
- 45 (6.6%): +Demonic Instinct 2/2, +Swallowed Anger; -Felfire Haste, -Gift of the Void, -Scythe's Embrace
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzYmxwMAAAAAAAMmthZGAAAAAAAAmxMMzMzMzMzMDzsYGjFZhZmZmt2mZmBwwAAwMGMmB`

**Split talents:** Focused Ire 86%; Soul Cleanse (choice) 78%; Scythe's Embrace (choice) 71%; Gift of the Void 68%; Felfire Haste 48%; Swallowed Anger 32%; Demonic Instinct 30%; Burn It Out (choice) 15%; Infernal Armor 13%; Master of the Glaive (choice) 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 122 of 679 run it exactly.

## Havoc Demon Hunter

### Raid

791 rankings over 10 bosses, logged 2026-09-02 to 2026-09-25. 305 distinct builds. Hero tree: Fel-Scarred 57%, Aldrachi Reaver 43%.

**Typical** (Fel-Scarred, agreement 58% on 27 contested talents, 29 run it exactly):

`CEkAAAAAAAAAAAAAAAAAAAAAAYmZGzMzmxMzMmZmMmZAAAAAAAzyDMmtZYmBzMWmZMDzMGzyALziZMMbMNmZGDbAAAAAAAAMzgBAAAgB`

**Most common other builds**, each against the typical:

- 125 (15.8%): +Accelerated Blade, +Aldrachi Reaver, +Aldrachi Tactics, +Bladecraft, +Broken Spirit, +Furious Throws, +Fury of the Aldrachi, +Incisive Blade, +Incorruptible Spirit, +Keen Edge, +Keen Engagement, +Reaver's Mark, +Screaming Brutality, +Serrated Glaive, +Shattered Destiny, +Soulscar, +Thrill of the Fight, +Unhindered Assault, +Warblade's Hunger, +Wounded Quarry; -A Fire Inside, -Blind Focus, -Burning Blades, -Burning Wound, -Demonic Intensity, -Enduring Torment, -Fel-Scarred, -Focused Hatred, -Growing Inferno, -Isolated Prey, -Monster Rising, -Pursuit of Angriness, -Ragefire, -Set Fire to the Pain, -Student of Suffering, -Trail of Ruin, -Undying Embers, -Untethered Fury, -Violent Transformation, -Volatile Instinct
  `CEkAAAAAAAAAAAAAAAAAAAAAAYgZmZ2MmZmxMzkxMDAAAAAAYWegxsNDzMz2MzYZmxMWmZYmlZ2mBDjlNmwYmxwCAAAAAAAYmBYAAAAYA`
- 27 (3.4%): +Blind Fury 1/2; -Isolated Prey
  `CEkAAAAAAAAAAAAAAAAAAAAAAYmZGzMzmxMzMmZmMmZAAAAAAAzyDMmtZYmBzMWmZegZYmBzyALziZMMbMNmZGDbAAAAAAAAMzgBAAAgB`
- 24 (3.0%): +Accelerated Blade, +Aldrachi Reaver, +Aldrachi Tactics, +Bladecraft, +Broken Spirit, +Champion of the Glaive, +Furious Throws, +Fury of the Aldrachi, +Incisive Blade, +Incorruptible Spirit, +Keen Edge, +Keen Engagement, +Reaver's Mark, +Screaming Brutality, +Serrated Glaive, +Shattered Destiny, +Soulscar, +Thrill of the Fight, +Unhindered Assault, +Warblade's Hunger, +Wounded Quarry; -A Fire Inside, -Blind Focus, -Burning Blades, -Burning Wound, -Demonic Intensity, -Enduring Torment, -Fel-Scarred, -Focused Hatred, -Growing Inferno, -Isolated Prey, -Master of the Glaive, -Monster Rising, -Pursuit of Angriness, -Ragefire, -Set Fire to the Pain, -Student of Suffering, -Trail of Ruin, -Undying Embers, -Untethered Fury, -Violent Transformation, -Volatile Instinct
  `CEkAAAAAAAAAAAAAAAAAAAAAAYgZmZ2MmZmxMzkxMDAAAAAAY2egxsNDzMz2MzYZmxMWmZYmlZ2mBDjlNmwYmxwCAAAAAAAYmBYAAAAYA`
- 16 (2.0%): +Blind Fury 1/2, +Burn It Out, +Champion of the Glaive, +Demon Muzzle, +Disrupting Fury; -Erratic Felheart 1/2, -Imprison, -Isolated Prey, -Master of the Glaive, -Soul Cleanse
  `CEkAAAAAAAAAAAAAAAAAAAAAAYmZGzMzyMmZmZmZmMmZAAAAAAAzmxsNDjBzMWmZegZYmBzyALziZMMbMNmZGDbAAAAAAAAMzgBAAAgB`

**Split talents:** Felfire Haste 85%; Consume Magic 78%; Soul Cleanse (choice) 77%; Sigil of Misery 71%; Imprison 70%; Master of the Glaive (choice) 60%; Volatile Instinct 57%; Violent Transformation 57%; Untethered Fury 57%; Undying Embers 57%; Monster Rising 57%; Focused Hatred 57%; Enduring Torment 57%; Demonic Intensity 57%; Burning Blades 57%; Blind Focus 57%; Pursuit of Angriness (choice) 56%; Student of Suffering (choice) 54%; Trail of Ruin 51%; Erratic Felheart 51%; Serrated Glaive 51%; Shattered Destiny (choice) 50%; Set Fire to the Pain (choice) 49%; Ragefire 49%; Growing Inferno 49%; Burning Wound 49%; A Fire Inside 49%; Demon Muzzle 44%; Screaming Brutality 43%; Accelerated Blade 43%; Wounded Quarry 43%; Warblade's Hunger 43%; Unhindered Assault (choice) 43%; Thrill of the Fight 43%; Soulscar (choice) 43%; Reaver's Mark 43%; Keen Edge 43%; Incisive Blade 43%; Fury of the Aldrachi 43%; Furious Throws 43%; Broken Spirit 43%; Bladecraft 43%; Aldrachi Tactics 43%; Incorruptible Spirit (choice) 41%; Champion of the Glaive (choice) 40%; Disrupting Fury 39%; Keen Engagement (choice) 39%; Isolated Prey 37%; Blind Fury 34%; Aldrachi Design 28%; Live by the Glaive 20%; Burn It Out (choice) 17%; Infernal Armor 12%

**Ours, against the whole sample:**

- `Raid`: the typical build. 29 of 791 run it exactly.

### Mythic+

684 rankings over 8 dungeons, logged 2026-08-28 to 2026-09-25, keys 18 to 21 (median 19). 163 distinct builds. Hero tree: Fel-Scarred 79%, Aldrachi Reaver 21%. 116 left out: their log has no talents.

**Typical** (Fel-Scarred, agreement 74% on 24 contested talents, 10 run it exactly):

`CEkAAAAAAAAAAAAAAAAAAAAAAYmZGzMz2MmZmZGzkxMDAAAAAAYWMmtZYmBmxyMzMDzMYWGYZ2MjhZhpxMzYYDAAAYAAAAMzgBAAAgB`

**Most common other builds**, each against the typical:

- 95 (13.9%): +Focused Ire; -Disrupting Fury
  `CEkAAAAAAAAAAAAAAAAAAAAAAYmZGzMz2MmZmxYmMmZAAAAAAAzixsNDzMwMWmZmZYmBzyALzmZMMLMNmZGzYDAAAYAAAAMzgBAAAgB`
- 31 (4.5%): +Accelerated Blade, +Aldrachi Reaver, +Aldrachi Tactics, +Bladecraft, +Broken Spirit, +Dancing with Fate 2/2, +Focused Ire, +Furious Throws, +Fury of the Aldrachi, +Incisive Blade, +Incorruptible Spirit, +Keen Edge, +Preemptive Strike, +Reaver's Mark, +Screaming Brutality, +Serrated Glaive, +Soulscar, +Thrill of the Fight, +Unhindered Assault, +Warblade's Hunger, +Wounded Quarry; -A Fire Inside, -Blind Focus, -Blind Fury 2/2, -Burning Blades, -Burning Wound, -Demonic Intensity, -Disrupting Fury, -Enduring Torment, -Fel-Scarred, -Flamebound, -Focused Hatred, -Glaive Tempest, -Growing Inferno, -Monster Rising, -Ragefire, -Set Fire to the Pain, -Undying Embers, -Untethered Fury, -Violent Transformation, -Volatile Instinct, -Wave of Debilitation
  `CEkAAAAAAAAAAAAAAAAAAAAAAYGMzMz2MmZmxYmMmZAAAAAAAzixsNDzMz2MzYZmxMMzwMLzsNDGGbbMhxMjZsAAAAAAAAmZAGAAAAG`
- 30 (4.4%): +Infernal Armor 2/2; -Felbound, -Soul Cleanse
  `CEkAAAAAAAAAAAAAAAAAAAAAAYmZGzMjZMzMzMmJjZGAAAAAAwsYMbjxMDMjlZmZGmZwsMwysZGDzCTjZmxwGAAAwAAAAYmBDAAAAD`
- 28 (4.1%): +Champion of the Glaive, +Infernal Armor 2/2, +Pursuit of Angriness; -Felbound, -Master of the Glaive, -Soul Cleanse, -Wave of Debilitation
  `CEkAAAAAAAAAAAAAAAAAAAAAAYmZGzMjZMzMzMmJjZGAAAAAAwsZMbjxMDMjlZmZGmZwsMwysZGDzGTjZmxwGAAAwAAAAYmBDAAAAD`

**Split talents:** Blind Fury 81%; Volatile Instinct 79%; Violent Transformation 79%; Untethered Fury 79%; Undying Embers 79%; Ragefire 79%; Monster Rising 79%; Growing Inferno 79%; Focused Hatred 79%; Enduring Torment 79%; Demonic Intensity 79%; Burning Wound 79%; Burning Blades 79%; Blind Focus 79%; A Fire Inside 79%; Glaive Tempest 78%; Set Fire to the Pain (choice) 74%; Soul Cleanse (choice) 73%; Flamebound (choice) 73%; Felbound 63%; Disrupting Fury 54%; Wave of Debilitation (choice) 54%; Master of the Glaive (choice) 52%; Champion of the Glaive (choice) 47%; Focused Ire 43%; Infernal Armor 29%; Pursuit of Angriness (choice) 25%; Dancing with Fate 25%; Wounded Quarry 21%; Warblade's Hunger 21%; Unhindered Assault (choice) 21%; Thrill of the Fight 21%; Soulscar (choice) 21%; Serrated Glaive 21%; Screaming Brutality 21%; Reaver's Mark 21%; Keen Edge 21%; Incisive Blade 21%; Fury of the Aldrachi 21%; Furious Throws 21%; Broken Spirit 21%; Bladecraft 21%; Aldrachi Tactics 21%; Accelerated Blade 21%; Incorruptible Spirit (choice) 20%; Preemptive Strike (choice) 18%; Felfire Haste 16%; Shattered Destiny (choice) 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 10 of 684 run it exactly.

## Vengeance Demon Hunter

### Raid

612 rankings over 10 bosses, logged 2026-08-30 to 2026-09-25. 286 distinct builds. Hero tree: Annihilator 97%, Aldrachi Reaver 3%. 1 left out: their log has no talents.

**Typical** (Annihilator, agreement 76% on 11 contested talents, 16 run it exactly):

`CUkAAAAAAAAAAAAAAAAAAAAAAAAYMzMjZmZkZmBziZmZgZMzYGzMzYYmZmxmZmtxAAAAAAAAAmZGbAAAAYwMzMzMbtNzMDAMAAAAG`

**Most common other builds**, each against the typical:

- 28 (4.6%): +Demon Muzzle; -Felfire Haste
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZMmZkZmBziZmZgZMzYGzMzYYmZmxmZmtxAAAAAAAAAmZGbAAAAYwMzMzMbtNzMDAMAAAAG`
- 25 (4.1%): +Demon Muzzle, +Disrupting Fury; -Felbound, -Felfire Haste
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZmxMjMzMYWMzMDMjZGzYmZGDzMzM2MzsNGAAAAAAAAwMzYDAAAADMzMzMbtNzMDAMAAAAG`
- 14 (2.3%): +Erratic Felheart 1/2; -Chaos Nova
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAYMzMjZmZkZmBziZmZgZMzYGzMzYYmZmx2DMzsNGAAAAAAAAwMzYDAAAADGzMzMbtNzMDAMAAAAG`
- 14 (2.3%): +Erratic Felheart 2/2; -Chaos Nova, -Pitch Black
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAYMzMjZmZkZmBziZmZgZMzYGzMzYYmZmx2MzYMAAAAAAAAgZmxGAAAAGMmZmZ2abmZGAYAAAAMA`

**Split talents:** Soul Barrier (choice) 86%; Quickened Sigils 85%; State of Matter (choice) 83%; Pursuit 81%; Final Breath 80%; Feed the Demon 80%; Volatile Flameblood 74%; Chaos Nova 73%; Felbound 73%; Pitch Black (choice) 72%; Erratic Felheart 61%; Felfire Haste 48%; Demon Muzzle 37%; Painbringer 30%; Imprison 25%; Chains of Anger 25%; Retaliation 15%; Path to Oblivion (choice) 15%; Improved Sigil of Misery 11%; Disrupting Fury 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 16 of 612 run it exactly.

### Mythic+

653 rankings over 8 dungeons, logged 2026-08-28 to 2026-09-25, keys 18 to 21 (median 19). 273 distinct builds. Hero tree: Annihilator 95%, Aldrachi Reaver 5%. 147 left out: their log has no talents.

**Typical** (Annihilator, agreement 70% on 12 contested talents, 1 run it exactly):

`CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZmhZkZmxwyMzMDMjZGzYmZGDmZmxmZmtxYGAAAAAAAAmZGbAAAAYgZmZmZrtZmZAAAAAAG`

**Most common other builds**, each against the typical:

- 22 (3.4%): +Fel Flame Fortification, +Improved Sigil of Misery, +Painbringer 2/2; -Consume Magic, -Felfire Fist, -Revel in Pain, -Soul Barrier
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZmhZmMzMYYmZGYGzMmZmZmxgZmZsZmZbMMAAAAAAAAMzM2AAAAwAzMzMzWbzMzAAAAAAMA`
- 19 (2.9%): +Erratic Felheart 1/2; -Consume Magic
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZmhZkZmxwyMzMDMjZGzYmZGDmZmx2DMzsNGGAAAAAAAAmZGbAAAAYgZmZmZrtZmZAAAAAAG`
- 19 (2.9%): +Fel Flame Fortification; -Revel in Pain
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZmhZkZmxYWMzMDMjZGzYmZGDmZmxmZmtxYGAAAAAAAAmZGbAAAAYgZmZmZrtZmZAAAAAAG`
- 17 (2.6%): +Felbound, +Improved Sigil of Misery, +Painbringer 2/2, +Soulmonger; -Disrupting Fury, -Feed the Demon, -Focused Cleave, -Live by the Glaive, -Quickened Sigils
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZMMzkZmxwyMzMDMjZmZMzMzYwwM2MzsNGzAAAAAAAAwMGbAAAAYwMzMzMbtNzMDAAAAAwA`

**Split talents:** Pitch Black (choice) 89%; Live by the Glaive 89%; State of Matter (choice) 86%; Focused Cleave 84%; Soul Barrier (choice) 83%; Quickened Sigils 77%; Feed the Demon 74%; Ascending Flame 74%; Painbringer 64%; Felfire Fist 54%; Consume Magic 51%; Revel in Pain 47%; Fel Flame Fortification 43%; Erratic Felheart 40%; Disrupting Fury 36%; Sigil of Silence 27%; Final Breath 26%; Improved Sigil of Misery 26%; Pursuit 18%; Soulmonger 16%; Volatile Flameblood 14%; Focused Ire 12%; Felbound 12%; Felfire Haste 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 1 of 653 run it exactly.

## Balance Druid

### Raid

823 rankings over 10 bosses, logged 2026-08-30 to 2026-09-25. 432 distinct builds. Hero tree: Elune's Chosen 63%, Keeper of the Grove 37%.

**Typical** (Elune's Chosen, agreement 69% on 31 contested talents, 11 run it exactly):

`CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmBDzYMzyMLmZGbsMzyYMzYBDDwYbbmBjZbAMBAAAYxMzMzgNDjxMAAmZgBA`

**Most common other builds**, each against the typical:

- 35 (4.3%): +Astral Communion, +Blooming Infusion, +Cenarius' Might, +Control of the Dream, +Dryad's Dance, +Early Spring, +Elune's Guidance, +Expansiveness, +Force of Nature, +Harmony of the Grove, +Keeper of the Grove, +Potent Enchantments, +Power of Nature, +Protective Growth, +Rattle the Stars, +Spirit of the Thicket, +Sylvan Beckoning, +Treants of the Moon, +Wild Mushroom; -Astral Insight, -Atmospheric Exposure, -Bask in Moonlight, -Denizen of the Dream, -Elune's Chosen, -Elune's Grace, -Fury of Elune, -Glistening Fur, -Lunar Calling, -Lunar Insight, -Lunation, -Moon Guardian, -Penumbral Swell, -Radiant Moonlight, -Star Cascade, -Starweaver, -Stellar Command, -The Eternal Moon, -Umbral Intensity
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmBDzY2mZZsMjZsZWmxYmZGbYYAGgttxGmmZWGAAAAsZmZmZwmhxYAYmBAGA`
- 32 (3.9%): +Astral Communion, +Blooming Infusion, +Cenarius' Might, +Control of the Dream, +Dryad's Dance, +Early Spring, +Elune's Guidance, +Expansiveness, +Force of Nature, +Harmony of the Grove, +Keeper of the Grove, +Meteor Storm, +Potent Enchantments, +Power of Nature, +Protective Growth, +Rattle the Stars, +Spirit of the Thicket, +Sylvan Beckoning, +Treants of the Moon, +Wild Mushroom; -Aetherial Kindling, -Astral Insight, -Atmospheric Exposure, -Bask in Moonlight, -Denizen of the Dream, -Elune's Chosen, -Elune's Grace, -Fury of Elune, -Glistening Fur, -Lunar Calling, -Lunar Insight, -Lunation, -Moon Guardian, -Penumbral Swell, -Radiant Moonlight, -Star Cascade, -Starweaver, -Stellar Command, -The Eternal Moon, -Umbral Intensity
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmBDzY2mZZsNjZsZWmxYmZGbYYAGgttxGmmZWGAAAAsZmZmZwmhxYAYmBAGA`
- 18 (2.2%): +Killer Instinct 1/2; -Light of the Sun
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMD8AmFzMzMYYGjZWmZxMzYjlZWGjZGLYYAGbbzMYMbDgJAAAALmZmZGsZgxMAAmZgBA`
- 16 (1.9%): +Incapacitating Roar; -Ursine Vigor
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmZhhZMmZZmFzMjNWmZZMmZsghBYstNzgxsNAmAAAAswMzMD2MMGzAAYmBGA`

**Split talents:** Wild Charge (choice) 88%; Twin Moons 88%; Incarnation: Chosen of Elune (choice) 88%; Meteorites 85%; Heart of the Wild 84%; Remove Corruption 84%; Typhoon 81%; Denizen of the Dream 79%; Fluid Form 75%; Umbral Intensity 75%; Light of the Sun 68%; Aetherial Kindling (choice) 67%; Fury of Elune (choice) 67%; The Eternal Moon 63%; Stellar Command 63%; Star Cascade 63%; Penumbral Swell 63%; Moon Guardian 63%; Lunar Insight 63%; Lunar Calling 63%; Glistening Fur 63%; Bask in Moonlight 63%; Atmospheric Exposure 63%; Astral Insight (choice) 63%; Ursine Vigor 61%; Orbit Breaker (choice) 60%; Radiant Moonlight 59%; Lunation (choice) 59%; Starweaver (choice) 59%; Elune's Grace (choice) 57%; Killer Instinct 53%; Improved Stampeding Roar 43%; Rattle the Stars (choice) 41%; Sundered Firmament (choice) 40%; Treants of the Moon 37%; Sylvan Beckoning 37%; Spirit of the Thicket 37%; Protective Growth 37%; Power of Nature (choice) 37%; Harmony of the Grove 37%; Force of Nature 37%; Expansiveness 37%; Dryad's Dance 37%; Control of the Dream (choice) 37%; Cenarius' Might 37%; Blooming Infusion 37%; Astral Communion 37%; Elune's Guidance 26%; Early Spring (choice) 25%; Potent Enchantments (choice) 25%; Wild Mushroom (choice) 24%; Perfectly-Honed Instincts 22%; Meteor Storm (choice) 20%; Incapacitating Roar (choice) 18%; Power of Goldrinn 15%; Grove's Inspiration (choice) 13%; Nature's Balance 13%; Bounteous Bloom (choice) 12%; Convoke the Spirits (choice) 12%; Tiger Dash (choice) 12%

**Ours, against the whole sample:**

- `Raid: Cleave`: the typical build. 11 of 823 run it exactly.
- `Raid: Nek'Zali, Altar`: 3 of 823 run it exactly. Typical has +Orbit Breaker, +Ursine Vigor; lacks Improved Stampeding Roar, Sundered Firmament.
- `Raid: Single Target`: 35 of 823 run it exactly. Typical has +Astral Insight, +Atmospheric Exposure, +Bask in Moonlight, +Denizen of the Dream, +Elune's Chosen, +Elune's Grace, +Fury of Elune, +Glistening Fur, +Lunar Calling, +Lunar Insight, +Lunation, +Moon Guardian, +Penumbral Swell, +Radiant Moonlight, +Star Cascade, +Starweaver, +Stellar Command, +The Eternal Moon, +Umbral Intensity; lacks Astral Communion, Blooming Infusion, Cenarius' Might, Control of the Dream, Dryad's Dance, Early Spring, Elune's Guidance, Expansiveness, Force of Nature, Harmony of the Grove, Keeper of the Grove, Potent Enchantments, Power of Nature, Protective Growth, Rattle the Stars, Spirit of the Thicket, Sylvan Beckoning, Treants of the Moon, Wild Mushroom.

### Mythic+

669 rankings over 8 dungeons, logged 2026-08-30 to 2026-09-25, keys 18 to 21 (median 19). 165 distinct builds. Hero tree: Elune's Chosen 100%. 131 left out: their log has no talents.

**Typical** (Elune's Chosen, agreement 79% on 6 contested talents, 119 run it exactly):

`CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmZhBjZZmlZWYmxGLzsMmZM2wwAM22mZwY2GATAAAAWMzMzMYzwYMAAMzglBA`

**Most common other builds**, each against the typical:

- 67 (10.0%): +Improved Stampeding Roar; -Ursine Vigor
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsMzMzMLMYMLzsMzCzM2YZmlxMjxGGGgx22MDGz2AYCAAAwCzMzMYzwYMAAMzglBA`
- 38 (5.7%): +Perfectly-Honed Instincts; -Ursine Vigor
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmZhBjZZmlZWYmxGLzsMmZM2wwAM22mZwY2GATAAAAWYmZmBbGzYMAAMzglBA`
- 34 (5.1%): +Innervate; -Ursine Vigor
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmZhhZMLzsMzCzM2YZmlxMjxGGGgx22MDGz2AYCAAAwCzMzMYzwYMAAMzglBA`
- 16 (2.4%): +Perfectly-Honed Instincts; -Fluid Form
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmZhBMLzsMzCzM2YZmlxMjxGGGgx22MDGz2AYCAAAwiZmZmBbGzYMAAMzglBA`

**Split talents:** Heart of the Wild 88%; Elune's Guidance 86%; Rattle the Stars (choice) 84%; Sunseeker Mushroom (choice) 83%; Fluid Form 80%; Ursine Vigor 53%; Improved Stampeding Roar 33%; Perfectly-Honed Instincts 32%; Killer Instinct 19%; Stellar Amplification 18%; Starweaver (choice) 16%; Innervate 13%; Meteorites 13%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 119 of 669 run it exactly.

### Boss rows

Each row's typical is pooled over every boss it backs; each boss is also shown alone.

- **`Raid: Nek'Zali, Altar`** for Nek'zali, The Coiled Altar: 191 rankings; Elune's Chosen 100%; typical agreement 74% on 12 contested. Ours: `Raid: Nek'Zali, Altar`: the typical build. 1 of 191 run it exactly.
  typical: `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsMzMzMYYGjZWmZxMzYhlZWGjZGLYYAGbbzMYMbDgJAAAALMzMzgNDjxMAAmZgBA`
  - Nek'zali alone: 100 rankings; Elune's Chosen 100%; against its own typical, the row's typical has +Aetherial Kindling, +Improved Stampeding Roar, +Sundered Firmament; lacks Meteor Storm, Orbit Breaker, Ursine Vigor.
  - The Coiled Altar alone: 91 rankings; Elune's Chosen 100%; against its own typical, the row's typical has +Wild Charge; lacks Tiger Dash.

- **`Raid: Cleave`** for Entombed Sentinels, The Lost Explorers, The Twin Fangs: 300 rankings; Elune's Chosen 100%; typical agreement 73% on 7 contested. Ours: `Raid: Cleave`: the typical build. 10 of 300 run it exactly.
  typical: `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmBDzYMzyMLmZGbsMzyYMzYBDDwYbbmBjZbAMBAAAYxMzMzgNDjxMAAmZgBA`
  - Entombed Sentinels alone: 100 rankings; Elune's Chosen 100%; against its own typical, the same build.
  - The Lost Explorers alone: 100 rankings; Elune's Chosen 100%; against its own typical, the same build.
  - The Twin Fangs alone: 100 rankings; Elune's Chosen 100%; against its own typical, the row's typical has +Ursine Vigor; lacks Incapacitating Roar.

- **`Raid: Single Target`** for Vashnik, Sszorak, Ula'tek, Nymrissa Wavecaller: 332 rankings; Keeper of the Grove 92%, Elune's Chosen 8%; typical agreement 69% on 16 contested. Ours: `Raid: Single Target`: the typical build. 35 of 332 run it exactly.
  typical: `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmBDzY2mZZsMjZsZWmxYmZGbYYAGgttxGmmZWGAAAAsZmZmZwmhxYAYmBAGA`
  - Vashnik alone: 100 rankings; Keeper of the Grove 78%, Elune's Chosen 22%; against its own typical, the row's typical has +Aetherial Kindling; lacks Meteor Storm.
  - Sszorak alone: 100 rankings; Keeper of the Grove 100%; against its own typical, the row's typical has +Aetherial Kindling, +Early Spring, +Elune's Guidance, +Incarnation: Chosen of Elune, +Light of the Sun, +Meteorites, +Orbit Breaker, +Potent Enchantments, +Twin Moons, +Typhoon, +Wild Mushroom; lacks Bounteous Bloom, Convoke the Spirits, Denizen of the Dream, Grove's Inspiration, Killer Instinct 2/2, Nature's Balance, Power of Goldrinn, Soul of the Forest, Sundered Firmament, Umbral Intensity.
  - Ula'tek alone: 32 rankings; Keeper of the Grove 100%; against its own typical, the row's typical has +Fluid Form, +Light of the Sun, +Stellar Amplification, +Umbral Embrace; lacks Denizen of the Dream, Fury of Elune, Improved Stampeding Roar, Lingering Healing.
  - Nymrissa Wavecaller alone: 100 rankings; Keeper of the Grove 96%, Elune's Chosen 4%; against its own typical, the same build.

## Feral Druid

### Raid

610 rankings over 10 bosses, logged 2026-09-02 to 2026-09-25. 468 distinct builds. Hero tree: Wildstalker 88%, Druid of the Claw 12%.

**Typical** (Wildstalker, agreement 79% on 32 contested talents, 1 run it exactly):

`CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZ2YmZmxY2WGLjtZmZMzMAAAAsEMbwYmRNjZZMzMjxMmBAAAAAwADAAAAAwsNzSzyMLbgZGgFzgBAwMDAGA`

**Most common other builds**, each against the typical:

- 10 (1.6%): +Carnivorous Instinct 2/2, +Heart of the Wild, +Matted Fur 1/2, +Typhoon, +Veinripper; -Feral Frenzy, -Focused Frenzy, -Lycara's Inspiration, -Matted Fur 2/2, -Rip and Tear
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZWYmZmxY2WmBbzMzYmZAAAAYJY2MMmZUzYWmZmZGjZMDAAAAAAwAAAAAAMbzs0sMzyGYmHAYxMYAAMzAgB`
- 7 (1.1%): +Ashamane's Guidance, +Entangling Vortex, +Heart of the Wild, +Hunger for Battle, +Incarnation: Avatar of Ashamane, +Primal Wrath, +Tireless Energy 1/2; -Apex Predator's Craving, -Convoke the Spirits, -Flower Walk, -Innervate, -Lunar Inspiration, -Tireless Energy 2/2
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZ2MzMzMGzGWmZZmZm5BmZAAAAYJY2gxMjaGzyMzMzYMDDAAAAAgBGAAAAAgZZmlmlZW2AzMALmBDAgZGAMA`
- 6 (1.0%): +Nurturing Instinct 1/2, +Perfectly-Honed Instincts, +Primal Wrath, +Typhoon, +Ursine Vigor; -Fluid Form, -Lore of the Grove, -Nurturing Instinct 2/2, -Rampant Ferocity
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZ2YMzMGz2yYZsNzMzMzMAAAAsEMbGeAzMqZMLjZmZMmxAAAAAAwADAAAAAwsNzSzyMLbwMzAswMMAAmZAwA`
- 6 (1.0%): +Cyclone, +Forestwalk 1/2, +Hunger for Battle, +Merciless Claws, +Primal Wrath, +Tiger Dash, +Tireless Energy 1/2, +Typhoon; -Fluid Form, -Infected Wounds, -Lore of the Grove, -Lunar Inspiration, -Soothe, -Tireless Energy 2/2, -Wild Charge
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMzmZmZmZGzmxyYbmZm5BmZAAAAYLY2MMmZUzY2GzMzYMzDMAAAAAAMwAAAAAAMbzs0sMzyGYmBYhBDAgZGAMA`

**Split talents:** Panther's Guile 90%; Circle of Life and Death 89%; Focused Frenzy (choice) 89%; Wildstalker's Power 88%; Vigorous Creepers 88%; Strategic Infusion 88%; Rampancy 88%; Patient Custodian 88%; Lethal Preservation 88%; Hunt Beneath the Open Skies 88%; Green Thumb 88%; Bursting Growth 88%; Bond with Nature (choice) 85%; Resilient Flourishing (choice) 83%; Flower Walk (choice) 82%; Convoke the Spirits (choice) 82%; Lycara's Inspiration 81%; Ursol's Vortex (choice) 80%; Twin Sprouts (choice) 79%; Lore of the Grove 79%; Innervate 75%; Infected Wounds 75%; Wild Charge (choice) 74%; Rampant Ferocity 64%; Improved Stampeding Roar 64%; Apex Predator's Craving 63%; Fluid Form 62%; Lunar Inspiration (choice) 61%; Typhoon 59%; Primal Wrath 50%; Rip and Tear (choice) 47%; Carnivorous Instinct 41%; Forestwalk 30%; Merciless Claws 28%; Ashamane's Guidance 27%; Hunger for Battle 27%; Tiger Dash (choice) 26%; Heart of the Wild 26%; Coiled to Spring 25%; Ursine Vigor 25%; Saber Jaws 25%; Perfectly-Honed Instincts 19%; Incarnation: Avatar of Ashamane (choice) 18%; Wildshape Mastery 12%; Twin Claw 12%; Strike for the Heart (choice) 12%; Pack's Endurance 12%; Limb from Limb 12%; Fount of Strength 12%; Exacerbating Wounds 12%; Empowered Shapeshifting (choice) 12%; Dreadful Wound 12%; Claw Rampage 12%; Bestial Strength 12%; Aggravate Wounds 12%; Killing Strikes (choice) 11%

**Ours, against the whole sample:**

- `Raid: Coiled Altar`: no one in the sample runs it exactly. Typical has +Improved Stampeding Roar, +Lycara's Inspiration, +Rip and Tear, +Tireless Energy 2/2; lacks Carnivorous Instinct 1/2, Forestwalk 1/2, Perfectly-Honed Instincts, Primal Wrath, Tireless Energy 1/2.
- `Raid: Entombed Sentinels`: 1 of 610 run it exactly. Typical has +Improved Stampeding Roar, +Rip and Tear; lacks Carnivorous Instinct 1/2, Typhoon.
- `Raid: Lost Explorers`: 1 of 610 run it exactly. Typical has +Feral Frenzy, +Focused Frenzy, +Rip and Tear; lacks Carnivorous Instinct 2/2, Veinripper.
- `Raid: Nek'Zali`: 2 of 610 run it exactly. Typical has +Rampant Ferocity, +Rip and Tear; lacks Carnivorous Instinct 1/2, Primal Wrath.
- `Raid: Nymrissa`: 1 of 610 run it exactly. Typical has +Fluid Form, +Infected Wounds, +Lunar Inspiration, +Tireless Energy 2/2; lacks Hunger for Battle, Merciless Claws, Primal Wrath, Tireless Energy 1/2, Typhoon.
- `Raid: Sszorak`: 1 of 610 run it exactly. Typical has +Apex Predator's Craving, +Bond with Nature, +Bursting Growth, +Circle of Life and Death, +Flower Walk, +Green Thumb, +Hunt Beneath the Open Skies, +Infected Wounds, +Lethal Preservation, +Lunar Inspiration, +Patient Custodian, +Rampancy, +Rampant Ferocity, +Resilient Flourishing, +Rip and Tear, +Strategic Infusion, +Twin Sprouts, +Vigorous Creepers, +Wildstalker, +Wildstalker's Power; lacks Aggravate Wounds, Ashamane's Guidance, Bestial Strength, Carnivorous Instinct 1/2, Claw Rampage, Coiled to Spring, Dreadful Wound, Druid of the Claw, Empowered Shapeshifting, Exacerbating Wounds, Fount of Strength, Killing Strikes, Limb from Limb, Merciless Claws, Pack's Endurance, Saber Jaws 2/2, Strike for the Heart, Twin Claw, Wildshape Mastery.
- `Raid: Twin Fangs`: 1 of 610 run it exactly. Typical has +Convoke the Spirits, +Fluid Form, +Focused Frenzy, +Panther's Guile, +Resilient Flourishing, +Tireless Energy 2/2, +Ursol's Vortex, +Wild Charge; lacks Ashamane's Guidance, Double-Clawed Rake, Incapacitating Roar, Incarnation: Avatar of Ashamane, Primal Wrath, Root Network, Tiger Dash, Typhoon, Wild Slashes.
- `Raid: Ula'tek`: no one in the sample runs it exactly. Typical has +Fluid Form, +Lunar Inspiration, +Tireless Energy 2/2; lacks Heart of the Wild, Hunger for Battle, Primal Wrath, Tireless Energy 1/2.
- `Raid: Vashnik`: 2 of 610 run it exactly. Typical has +Apex Predator's Craving, +Convoke the Spirits, +Lunar Inspiration, +Tireless Energy 2/2; lacks Ashamane's Guidance, Hunger for Battle, Incarnation: Avatar of Ashamane, Primal Wrath, Tireless Energy 1/2.

### Mythic+

681 rankings over 8 dungeons, logged 2026-08-30 to 2026-09-25, keys 19 to 22 (median 19). 145 distinct builds. Hero tree: Druid of the Claw 99%, Wildstalker 1%. 119 left out: their log has no talents.

**Typical** (Druid of the Claw, agreement 78% on 5 contested talents, 205 run it exactly):

`CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmZ2YmZmxY2M2mZZGzMmZAAAAYJY2M8AmZUzYWMzMzsMmhBAAAAAwADAAAgmZZWmZmBAsAzMDwCDGAAAzshB`

**Most common other builds**, each against the typical:

- 145 (21.3%): +Convoke the Spirits, +Hunger for Battle; -Ashamane's Guidance, -Incarnation: Avatar of Ashamane
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmZ2MzMzMGzmx2YbGzMmZAAAAYJY2M8AmZUzYWMzMzsMmhBAAAAAwADAAAgmZZWmZmBAsAzMDwCDGAAAzshB`
- 34 (5.0%): +Innervate; -Ursine Vigor
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmZ2YmZmxY2M2mZZGzMmZAAAAYJY2M8AmZUzYWMzMzsMmxMAAAAAAGYAAAA0MLzyMzMAgFwMDwCDGAAAzshB`
- 22 (3.2%): +Hunger for Battle; -Rip and Tear
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmZYmZmZMmNjtZWmxMjZGAAAAWCmNDPgZG1MmFzMzMLjZYAAAAAAMwAAAAoZWmlZmZAALwMzAswgBAAwMbYA`
- 21 (3.1%): +Tiger Dash; -Wild Charge
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmZ2YmZmxY2M2mZZGzMmZAAAAYLY2M8AmZUzYWMzMzsMmhBAAAAAwADAAAgmZZWmZmBAsAzMDwCDGAAAzshB`

**Split talents:** Double-Clawed Rake 90%; Wild Charge (choice) 88%; Ursine Vigor 82%; Ashamane's Guidance 65%; Incarnation: Avatar of Ashamane (choice) 64%; Hunger for Battle 39%; Convoke the Spirits (choice) 36%; Innervate 14%; Tiger Dash (choice) 12%; Merciless Claws 11%; Tireless Energy 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 205 of 681 run it exactly.

### Boss rows

Each row's typical is pooled over every boss it backs; each boss is also shown alone.

- **`Raid: Nek'Zali`** for Nek'zali: 100 rankings; Wildstalker 95%, Druid of the Claw 5%; typical agreement 76% on 15 contested. Ours: `Raid: Nek'Zali`: the typical build. 2 of 100 run it exactly.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwYmZMmtl5BWGbzMzMzMDAAAALBzGMmZUzYWGzMzYMjZAAAAAAMwAAAAAAMbzs0sMzyGYmBYxMYAAMzAgB`
  - Nek'zali alone: 100 rankings; Wildstalker 95%, Druid of the Claw 5%; against its own typical, the same build.

- **`Raid: Entombed Sentinels`** for Entombed Sentinels: 100 rankings; Wildstalker 96%, Druid of the Claw 4%; typical agreement 74% on 10 contested. Ours: `Raid: Entombed Sentinels`: the typical build. 1 of 100 run it exactly.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwMzMjxstMPwyYbmZGzMDAAAALBzmhxMjaGzCzMzYMjZAAAAAAMwAAAAAAMbzs0sMzyGYmBYxMYAAMzAgB`
  - Entombed Sentinels alone: 100 rankings; Wildstalker 96%, Druid of the Claw 4%; against its own typical, the same build.

- **`Raid: Lost Explorers`** for The Lost Explorers: 100 rankings; Wildstalker 98%, Druid of the Claw 2%; typical agreement 68% on 12 contested. Ours: `Raid: Lost Explorers`: the typical build. 1 of 100 run it exactly.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZWYmZmxY2WmBbzMzYmZAAAAYJY2gxMjaGzyYmZGjZMDAAAAAgBGAAAAAgZbmlmlZW2AzMALmBDAgZGAMA`
  - The Lost Explorers alone: 100 rankings; Wildstalker 98%, Druid of the Claw 2%; against its own typical, the same build.

- **`Raid: Vashnik`** for Vashnik: 100 rankings; Wildstalker 97%, Druid of the Claw 3%; typical agreement 74% on 12 contested. Ours: `Raid: Vashnik`: the typical build. 2 of 100 run it exactly.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZ2MzMzMGzGWmZZmZm5BmZAAAAYJY2gxMjaGzyYmZGjZMDAAAAAgBGAAAAAgZbmlmlZW2AzMALmBDAgZGAMA`
  - Vashnik alone: 100 rankings; Wildstalker 97%, Druid of the Claw 3%; against its own typical, the same build.

- **`Raid: Sszorak`** for Sszorak: 100 rankings; Druid of the Claw 51%, Wildstalker 49%; typical agreement 60% on 25 contested. Ours: `Raid: Sszorak`: the typical build. 1 of 100 run it exactly.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAwghxYmZmxsxDsMz2MzMmZGAAAAWCmNYMzomxsMmZmxYGzAAAAAAYgBAAAQzsMLzMzAAWAzMALmBDAAgZ2wA`
  - Sszorak alone: 100 rankings; Druid of the Claw 51%, Wildstalker 49%; against its own typical, the same build.

- **`Raid: Twin Fangs`** for The Twin Fangs: 10 rankings; Wildstalker 100%; typical agreement 65% on 6 contested. Ours: `Raid: Twin Fangs`: 1 of 10 run it exactly. Typical has +Panther's Guile, +Wild Charge; lacks Tiger Dash, Wild Slashes.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZMzGzMzMGz2ywMLzMzMmZAAAAYJYYYMzomxsMmZmZZMjBAAAAAgBGAAAAAgZbmlmlZ22AzMALmBDAgZGAMA`
  - The Twin Fangs alone: 10 rankings; Wildstalker 100%; against its own typical, the same build.

- `Raid: Coiled Altar` (The Coiled Altar): no rankings with talents.

- `Raid: Ula'tek` (Ula'tek): no rankings with talents.

- **`Raid: Nymrissa`** for Nymrissa Wavecaller: 100 rankings; Wildstalker 92%, Druid of the Claw 8%; typical agreement 73% on 18 contested. Ours: `Raid: Nymrissa`: the typical build. 1 of 100 run it exactly.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMzmZmZmZGzmxyYbmZm5BmZAAAAYJY2MMmZUzYWGzMzYMjBAAAAAgBGAAAAAgZbmlmlZW2AzMALmBDAgZGAMA`
  - Nymrissa Wavecaller alone: 100 rankings; Wildstalker 92%, Druid of the Claw 8%; against its own typical, the same build.

## Guardian Druid

### Raid

623 rankings over 10 bosses, logged 2026-08-27 to 2026-09-25. 282 distinct builds. Hero tree: Elune's Chosen 100%.

**Typical** (Elune's Chosen, agreement 77% on 10 contested talents, 38 run it exactly):

`CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYGjZ2MLGMLLDMbwoJamZWmZmZGjZMDAAAAAYGbzAW2mZwY2GATAAAAbYmBYxMYAbW2GgZGAD`

**Most common other builds**, each against the typical:

- 29 (4.7%): +Ursoc's Endurance; -Gory Fur
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYGjZ2MLGMLLDMbwoJamZWmZmZGjZMDAAAAAYGbzAW2mZwY2GATAAAAbYmBYxMYALW2GgZGAD`
- 11 (1.8%): +Astral Influence, +Starlight Conduit, +Typhoon, +Ursoc's Endurance; -Gory Fur, -Matted Fur 2/2, -Natural Recovery
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYGjZ2MLGMLLDYzMGNRzMzyMzMzYMjZAAAAAAzYbGwy2MDGz2AYCAAAYDzYALmBDYxy2AMzAYA`
- 11 (1.8%): +Astral Insight, +Lycara's Inspiration; -Improved Stampeding Roar, -The Light of Elune
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYGjZ2MLGMLLDMbwoJamZWMzMzYMjZAAAAAAzMbzA22mZwY2GATAAAAbYmBYxMYAbW2GgZGAD`
- 10 (1.6%): +Astral Influence, +Matted Fur 1/2, +Raze, +Starlight Conduit, +Typhoon; -Improved Stampeding Roar, -Matted Fur 2/2, -Reinforced Fur, -Ursol's Vortex
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsMzYMzmZxgxyADzY0ENzMLmZmZMmxMAAAAAgZsNDYZbmBjZbAMBAAAshZegBsYGMgNLbDwMDgB`

**Split talents:** Instincts of the Claw 88%; Natural Recovery 87%; Elune's Grace (choice) 86%; Brambles (choice) 86%; Improved Stampeding Roar 85%; The Light of Elune (choice) 83%; Matted Fur 82%; Ursol's Vortex (choice) 81%; Innervate 61%; Gory Fur (choice) 52%; Typhoon 46%; Ursoc's Endurance (choice) 45%; Astral Influence 32%; Starlight Conduit 26%; Lycara's Inspiration 24%; Astral Insight (choice) 17%; Moondust (choice) 14%; Perfectly-Honed Instincts 13%

**Ours, against the whole sample:**

- `Raid`: the typical build. 38 of 623 run it exactly.

### Mythic+

710 rankings over 8 dungeons, logged 2026-09-03 to 2026-09-25, keys 19 to 22 (median 20). 144 distinct builds. Hero tree: Elune's Chosen 100%. 90 left out: their log has no talents.

**Typical** (Elune's Chosen, agreement 79% on 6 contested talents, 151 run it exactly):

`CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYmZMziZxMmZZZgZzwoJamZWmZmZmlxMAAAAAAMjNDYZbmBjZZAMBAAAshZGgFjhBsYBgZGAD`

**Most common other builds**, each against the typical:

- 51 (7.2%): +Lycara's Inspiration, +Matted Fur 1/2; -Matted Fur 2/2
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYmZMziZxMmZZZgZzwoJamZWmZmZmlxMAAAAAAMzsZALbzMYMLDgJAAAgNMzDAsYMMgFLAMzAYA`
- 36 (5.1%): +Reinvigoration 1/2; -Soul of the Forest
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYmZMziZxMPwMLLDMbGGNRzMzyMzMzsMmBAAAAAAjNDYZbmBjZZAMBAAAshZGgFjhBsYBgZGAD`
- 35 (4.9%): +Elune's Grace; -Moondust
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYmZMziZxMmZZZgZzwoJamZWmZmZmlxMAAAAAAMjNDYZbmBjZbAMBAAAshZGgFjhBsYBgZGAD`
- 27 (3.8%): +Innervate, +Matted Fur 1/2; -Matted Fur 2/2
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYmZMziZxMmZZZgZzwoJamZWmZmZmlxMGAAAAAgZsZALbzMYMLDgJAAAgNMzDAsYMMgFLAMzAYA`

**Split talents:** The Light of Elune (choice) 86%; Primal Fury 83%; Moondust (choice) 81%; Perfectly-Honed Instincts 78%; Soul of the Forest 76%; Reinvigoration 20%; Lycara's Inspiration 19%; Elune's Grace (choice) 19%; Fluid Form 17%; Astral Insight (choice) 14%; Innervate 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 151 of 710 run it exactly.
- `Dungeon: survive more`: no one in the sample runs it exactly. Typical has +Atmospheric Exposure, +Bask in Moonlight, +Dream Guide, +Elune's Chosen, +Fury of Nature 2/2, +Gift of an Ancient Guardian, +Glistening Fur, +Improved Stampeding Roar, +Lunar Calling, +Lunar Insight, +Lunation, +Matted Fur 2/2, +Moon Guardian, +Moondust, +Penumbral Swell, +Perfectly-Honed Instincts, +Star Cascade, +Stellar Command, +The Eternal Moon, +The Light of Elune; lacks Aggravate Wounds, Bestial Strength, Claw Rampage, Dreadful Wound, Dream of Cenarius, Druid of the Claw, Empowered Shapeshifting, Exacerbating Wounds, Fluid Form, Forestwalk 1/2, Fount of Strength, Instincts of the Claw, Killing Blow, Killing Strikes, Limb from Limb, Lingering Healing, Pack's Endurance, Reinvigoration 1/2, Strike for the Heart, Twin Claw, Waking Nightmare, Wildshape Mastery.

## Restoration Druid

### Raid

719 rankings over 10 bosses, logged 2026-08-29 to 2026-09-25. 414 distinct builds. Hero tree: Wildstalker 100%.

**Typical** (Wildstalker, agreement 65% on 8 contested talents, 15 run it exactly):

`CkGAAAAAAAAAAAAAAAAAAAAAAYMmZZmZMzMmthZwsZsNmBAAAAAAAAAALGa2MjpZGgZZmZmZYYGAAAAAGAAAAAAAwsNzSz2Mb2YMzMYGY0MAAzMAMA`

**Most common other builds**, each against the typical:

- 19 (2.6%): +Killer Instinct 1/2, +Rake, +Rip; -Starfire, -Starsurge, -Typhoon
  `CkGAAAAAAAAAAAAAAAAAAAAAAYMmZZmZMzMmthZwsZsNmBAAAAAAAAAALDa2YMNzY4BMLzMzMDDzAAAAAAAAAAAAAwsNzSz2Mb2YMzMYGY0MAAzMAMA`
- 15 (2.1%): +Incapacitating Roar; -Perfectly-Honed Instincts
  `CkGAAAAAAAAAAAAAAAAAAAAAAYMmZZmZMzMmthZwsZsNmBAAAAAAAAAALGa2MjpZGgZZmZmZWMMDAAAAADAAAAAAAY2mZpZbmNbMmZGMDQzAAMzAwA`
- 13 (1.8%): +Tiger Dash; -Wild Charge
  `CkGAAAAAAAAAAAAAAAAAAAAAAYMmZZmZMzMmthZwsZsNmBAAAAAAAAAAbGa2MjpZGgZZmZmZYYGAAAAAGAAAAAAAwsNzSz2Mb2YMzMYGY0MAAzMAMA`
- 10 (1.4%): +Circle of the Wild, +Killer Instinct 1/2, +Rake, +Rip; -Perfectly-Honed Instincts, -Starfire, -Starlight Conduit, -Starsurge
  `CkGAAAAAAAAAAAAAAAAAAAAAAYMmZZmZMzMmthZwsZsNmBAAAAAAAAAALDa2MjpZGDPgZZmZmZYYGAAAAAAAAAAAAAmtZWa2mZzGjZGYmFQzAAMzAwA`

**Split talents:** Master Shapeshifter (choice) 77%; Heart of the Wild 73%; Starlight Conduit 70%; Wild Charge (choice) 69%; Killer Instinct 64%; Starfire 60%; Typhoon 60%; Perfectly-Honed Instincts 58%; Starsurge 54%; Rake 42%; Rip 36%; Tiger Dash (choice) 31%; Liveliness (choice) 23%; Incapacitating Roar (choice) 22%; Moonkin Form 16%; Ursine Vigor 15%

**Ours, against the whole sample:**

- `Raid`: the typical build. 15 of 719 run it exactly.

### Mythic+

609 rankings over 8 dungeons, logged 2026-08-29 to 2026-09-25, keys 17 to 20 (median 18). 309 distinct builds. Hero tree: Wildstalker 94%, Keeper of the Grove 6%. 191 left out: their log has no talents.

**Typical** (Wildstalker, agreement 69% on 24 contested talents, 1 run it exactly):

`CkGAAAAAAAAAAAAAAAAAAAAAAMMmZZMjZmxsNMMmNjNbzAAAAAAAAAAgFDNbzw0MDwsYmZmZxwDMAAAAAMAAzAAAAAgZbmtmtZWsxMzMYmZD0MAAzMAMA`

**Most common other builds**, each against the typical:

- 12 (2.0%): +Circle of the Wild, +Fluid Form, +Grievous Wounds, +Liveliness, +Rake, +Regenerative Heartwood, +Rip, +Swipe; -Circle of the Heavens, -Improved Swiftmend, -Master Shapeshifter, -Moonkin Form, -Starfire, -Starsurge, -Sunfire, -Ursine Vigor
  `CkGAAAAAAAAAAAAAAAAAAAAAAMMmZZMjZmxsNMMmlZsZbGAAAAAAAAAAsMoZzw0MjZwsYmZmZZGegZAAAAAAAwAAAAAgZbmtmtZWsxYmBmZB0MAAzMAMA`
- 10 (1.6%): +Astral Influence, +Circle of the Wild, +Entangling Vortex, +Fluid Form, +Grievous Wounds, +Harmonious Blooming, +Killer Instinct 2/2, +Liveliness, +Rake, +Rip, +Root Network, +Swipe, +Verdant Infusion; -Circle of the Heavens, -Feline Swiftness, -Flower Walk, -Innervate, -Master Shapeshifter, -Matted Fur 2/2, -Moonkin Form, -Nurturing Dormancy, -Prosperity, -Resilient Flourishing, -Starfire, -Starsurge, -Sunfire
  `CkGAAAAAAAAAAAAAAAAAAAAAAMMmZZMjZmxsNMMmFmFbzAAAAAAAAAAglBNbmx0MjZMmFzMzYZGeADAAAAAAAGAAAAAMLzs1sNzmNmZGYmZB0MAAzMAMA`
- 9 (1.5%): +Forestwalk 2/2, +Nature's Bounty, +Perfectly-Honed Instincts, +Root Network, +Starlight Conduit, +Tiger Dash; -Circle of the Heavens, -Forestwalk 1/2, -Heart of the Wild, -Nurturing Dormancy, -Resilient Flourishing, -Typhoon, -Wild Charge
  `CkGAAAAAAAAAAAAAAAAAAAAAAMMmZZMjZmxsNMMzshNbzAAAAAAAAAAgNDNbDmmZAmFmZmZxwMAAAAAMAAzAAAAAgZbmtmtZ2sxMzMDzMwoZAAmZAYA`
- 8 (1.3%): +Astral Influence, +Bond with Nature, +Fluid Form, +Killer Instinct 1/2, +Liveliness, +Matted Fur 1/2, +Root Network, +Stonebark, +Tiger Dash; -Harmonious Constitution, -Improved Ironbark, -Master Shapeshifter, -Matted Fur 2/2, -Resilient Flourishing, -Starsurge, -Ursine Vigor, -Wild Charge
  `CkGAAAAAAAAAAAAAAAAAAAAAAMMmZZMjZmxsNMMmFjNLzAAAAAAAAAAgNoZbmx0MD8AmFzMzMLGegZAAAAAMAAzAAAAAgZbmlmtZ2sxYmHAzMbgmBAYmBgB`

**Split talents:** Typhoon 88%; Flower Walk (choice) 87%; Wild Synthesis 86%; Harmonious Constitution (choice) 85%; Overgrowth (choice) 82%; Incapacitating Roar (choice) 82%; Improved Swiftmend 82%; Feline Swiftness 80%; Matted Fur 78%; Heart of the Wild 74%; Innervate 74%; Wild Charge (choice) 70%; Starfire 69%; Verdancy 67%; Moonkin Form 63%; Sunfire 61%; Nurturing Dormancy 60%; Master Shapeshifter (choice) 60%; Fluid Form 54%; Ursine Vigor 52%; Resilient Flourishing (choice) 51%; Starsurge 50%; Starlight Conduit 47%; Circle of the Heavens (choice) 47%; Rake 47%; Rip 45%; Root Network (choice) 43%; Liveliness (choice) 40%; Circle of the Wild (choice) 38%; Grievous Wounds 37%; Astral Influence 34%; Tiger Dash (choice) 30%; Harmonious Blooming 29%; Killer Instinct 29%; Nature's Bounty 25%; Swipe 23%; Reforestation 23%; Regenerative Heartwood 19%; Perfectly-Honed Instincts 17%; Call of the Elder Druid 13%; Passing Seasons (choice) 11%; Dream of Cenarius 11%; Improved Stampeding Roar 10%; Flash of Clarity 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 1 of 609 run it exactly.
- `Dungeon: caster damage`: no one in the sample runs it exactly. Typical has +Heart of the Wild, +Improved Swiftmend, +Innervate, +Master Shapeshifter, +Thriving Vegetation 2/2, +Ursine Vigor, +Verdancy, +Wild Charge; lacks Astral Influence, Blooming Infusion, Bounteous Bloom, Call of the Elder Druid, Cenarius' Might, Dream of Cenarius, Expansiveness, Grove's Inspiration, Harmony of the Grove, Liveliness, Perfectly-Honed Instincts, Power of Nature, Power of the Dream, Protective Growth, Regenerative Heartwood, Starlight Conduit, Thriving Vegetation 1/2, Tiger Dash, Treants of the Moon.
- `Dungeon: cat damage`: no one in the sample runs it exactly. Typical has +Circle of the Heavens, +Improved Swiftmend, +Innervate, +Master Shapeshifter, +Moonkin Form, +Starfire, +Starsurge, +Sunfire, +Thriving Vegetation 2/2, +Ursine Vigor, +Wild Charge; lacks Blooming Infusion, Bounteous Bloom, Cenarius' Might, Circle of the Wild, Expansiveness, Fluid Form, Grievous Wounds, Grove's Inspiration, Harmony of the Grove, Liveliness, Nature's Bounty, Perfectly-Honed Instincts, Power of Nature, Power of the Dream, Protective Growth, Rake, Regenerative Heartwood, Rip, Swipe, Thriving Vegetation 1/2, Tiger Dash, Treants of the Moon.

## Augmentation Evoker

### Raid

787 rankings over 10 bosses, logged 2026-08-30 to 2026-09-25. 402 distinct builds. Hero tree: Chronowarden 100%, Scalecommander 0%.

**Typical** (Chronowarden, agreement 65% on 9 contested talents, 4 run it exactly):

`CEcBAAAAAAAAAAAAAAAAAAAAAMmZmZbmZGMYmZZmZMjZAAAAAAAAgZGjZwYqxMzMAAAAYGzYMzsMmZgZYgxMWYBGYGGagFMzYmBAG`

**Most common other builds**, each against the typical:

- 24 (3.0%): +Chrono Ward, +Clairvoyant, +Overlord, +Twin Guardian; -Arcane Reach, -Inferno's Blessing, -Mighty Inferno, -Tailwind
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzgZYmZZGzMjZ2AAAAAAAAYmhxMYM1YmZGAAAAMjZMmZWGzMwMMwYGLsADMDDNwCGjZGAYA`
- 22 (2.8%): +Chrono Ward, +Twin Guardian; -Arcane Reach, -Tailwind
  `CEcBAAAAAAAAAAAAAAAAAAAAAMmZmZbmZGMYmZZGjZMzGAAAAAAAAzMMmBjpGzMzAAAAgZMjxMzyYmBmhBGzYhFYgZYoBWwMjZGAYA`
- 15 (1.9%): +Clairvoyant, +Overlord, +Unravel; -Inferno's Blessing, -Mighty Inferno, -Tailwind
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzgZYmZZmZmZMDAAAAAAAAMDjZwYqZmZmBAAAAzYGjZmlxMDMDDMmxCLwAzwQDsgxYmBAG`
- 14 (1.8%): +Chrono Ward, +Clairvoyant, +Overlord, +Unravel; -Arcane Reach, -Inferno's Blessing, -Mighty Inferno, -Tailwind
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzgZYmZZGzMjZ2AAAAAAAAwMMmBjpmZmZGAAAAMjZMmZWGzMwMMwYGLsADMDDNwCGjZGAYA`

**Split talents:** Improved Defy Fate 85%; Scarlet Adaptation 84%; Cauterizing Flame 82%; Quell 73%; Attuned to the Dream 71%; Arcane Reach 59%; Clairvoyant 57%; Chrono Ward (choice) 56%; Tailwind 50%; Mighty Inferno 46%; Inferno's Blessing 46%; Twin Guardian 42%; Foci of Life 40%; Overlord 33%; Unravel 33%; Tomorrow, Today (choice) 22%; Exuberance 20%; Bestow Weyrnstone 19%; Ancient Flame 18%

**Ours, against the whole sample:**

- `Raid`: the typical build. 4 of 787 run it exactly.

### Mythic+

649 rankings over 8 dungeons, logged 2026-08-20 to 2026-09-25, keys 15 to 20 (median 16). 314 distinct builds. Hero tree: Chronowarden 82%, Scalecommander 18%. 151 left out: their log has no talents.

**Typical** (Chronowarden, agreement 77% on 28 contested talents, 1 run it exactly):

`CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzgZYmZZGzMjZ2AAAAAAAAwMMGGjpGzMzAAAAgZmZMmZWGzMwMMwYGLsADMDDNwCGzMzAAD`

**Most common other builds**, each against the typical:

- 18 (2.8%): +Sleep Walk; -Oppressing Roar
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzgZYmZZGzMjZ2AAAAAAAAwMMzAjpGzMzAAAAgZmZMmZWGzMwMMwYGLsADMDDNwCGzMzAAD`
- 14 (2.2%): +Bestow Weyrnstone, +Enkindled 1/2, +Overawe; -Attuned to the Dream 2/2, -Chrono Ward
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzgZYmZZGzMjZAAAAAAAAgZg5BmxYqxMzMAAAAYmZGjZmlxMDMjZgxMWYBGYGGagFMmZmBAG`
- 14 (2.2%): +Ancient Flame, +Enkindled 2/2, +Foci of Life, +Overawe, +Twin Guardian; -Attuned to the Dream 2/2, -Potent Mana, -Scarlet Adaptation, -Source of Magic, -Stretch Time
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzgZYmZZGzMjZ2AAAAAgBAAzMwMzYM1wMzAAAAAzMmxMzyYmBmBwYGLsADMDDNwCGzMzAAD`
- 14 (2.2%): +Enkindled 2/2, +Twin Guardian; -Clobbering Sweep, -Oppressing Roar, -Terror of the Skies
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzgZYmZZGzMjZ2AAAAAAAAYmhxMYM1YmZGAAAAMjZMmZWGzMwMMwYGLsADMDDNwCGjZGAYA`

**Split talents:** Plot the Future 90%; Clairvoyant 85%; Warp 82%; Temporal Burst 82%; Reverberations 82%; Primacy 82%; Overclock 82%; Nozdormu Adept 82%; Instability Matrix 82%; Golden Opportunity 82%; Chronoboon 82%; Chronal Dynamo 82%; Afterimage 82%; Double-time (choice) 81%; Temporality (choice) 81%; Stretch Time 80%; Improved Defy Fate 80%; Draconic Attunements 80%; Time Spiral (choice) 80%; Clobbering Sweep 78%; Rumbling Earth 78%; Chrono Ward (choice) 77%; Overlord 74%; Terror of the Skies 65%; Enkindled 63%; Attuned to the Dream 62%; Oppressing Roar 55%; Scarlet Adaptation 54%; Overawe 47%; Interwoven Threads (choice) 40%; Foci of Life 40%; Sleep Walk 27%; Blistering Scales 26%; Regenerative Chitin (choice) 24%; Wingleader 18%; Unrelenting Siege 18%; Refined Essence 18%; Onslaught 18%; Might of the Black Dragonflight 18%; Melt Armor 18%; Maneuverability 18%; Concentrated Power 18%; Command Squadron 18%; Bombardments 18%; Hardened Scales (choice) 18%; Twin Guardian 15%; Inferno's Blessing 15%; Spatial Paradox (choice) 14%; Mighty Inferno 14%; Ancient Flame 14%; Bestow Weyrnstone 14%; Reactive Hide 12%; Nimble Flyer (choice) 12%; Extended Battle (choice) 12%; Unravel 10%; Timelessness 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 1 of 649 run it exactly.

## Devastation Evoker

### Raid

708 rankings over 10 bosses, logged 2026-08-27 to 2026-09-25. 208 distinct builds. Hero tree: Scalecommander 99%, Flameshaper 1%. 1 left out: their log has no talents.

**Typical** (Scalecommander, agreement 73% on 8 contested talents, 15 run it exactly):

`CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwMDzwMDMYMTjZmpZmx2MzMzMzMzMzAmxMzYmZZmZgBGD2glxox2AYGA2wAzMY4BA`

**Most common other builds**, each against the typical:

- 64 (9.0%): +Strike from Above; -Tailwind
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwMDzwMgBjZaMzMNzM2mZmZmZmZmZGwMmZGzMLzMDMwYwGsMGN2GAzAwGGYmBz4BA`
- 62 (8.8%): +Terror of the Skies; -Foci of Life
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwMDzwMDMYMTjZmpZmx2MzMzMzMzMzAmZmxYmZZmZgBGD2glxox2AYGA2wAzMY4BA`
- 61 (8.6%): +Unravel; -Foci of Life
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwMDzwMDMYMTzMzMNzM2mZmZmZmZmZGwMmxYmZZmZgBGD2glxox2AYGA2wAzMY4BA`
- 22 (3.1%): +Unravel; -Tailwind
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwMDzwMgBjZamZmpZmx2MzMzMzMzMzAmxMzYmZZmZgBGD2glxox2AYGA2wAzMY4BA`

**Split talents:** Heat Wave 90%; Eternity's Span 87%; Iridescence 81%; Font of Magic 81%; Star Salvo 75%; Tailwind 52%; Foci of Life 39%; Unravel 32%; Terror of the Skies 31%; Strike from Above 21%; Twin Guardian 16%; Power Nexus 13%; Cauterizing Flame 12%; Ancient Flame 10%; Ruby Embers 10%; Engulfing Blaze 10%

**Ours, against the whole sample:**

- `Raid`: the typical build. 15 of 708 run it exactly.

### Mythic+

647 rankings over 8 dungeons, logged 2026-08-23 to 2026-09-25, keys 17 to 20 (median 17). 254 distinct builds. Hero tree: Scalecommander 99%, Flameshaper 1%. 153 left out: their log has no talents.

**Typical** (Scalecommander, agreement 70% on 11 contested talents, 36 run it exactly):

`CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwgZGmBGzYMTjZmpZmZ2mZmZmZmZmZGgZmxYmZZmZgBGD2glxox2AYGA2wMYmBDPA`

**Most common other builds**, each against the typical:

- 30 (4.6%): +Foci of Life, +Scarlet Adaptation; -Oppressing Roar, -Overawe
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwgZGmBGYMTjZmpZmZ2mZmZmZmZmZGwMzMzYmZZmZgBGD2glxox2AYGA2wMYmBDPA`
- 27 (4.2%): +Rising Fury 4/4; -Font of Magic, -Iridescence, -Rising Fury 1/4, -Star Salvo
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZAMzwMwYGjZaMzMNjZ2mxMzMzMzMzAMzMGzMLzMDMwYwGsMGN2GAzAwGmBzMYYA`
- 17 (2.6%): +Scarlet Adaptation; -Terror of the Skies
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwgZGmBGzYMTjZmpZmZ2mZmZmZmZmZGwMmxYmZZmZgBGD2glxox2AYGA2wMYmBDPA`
- 15 (2.3%): +Sleep Walk; -Terror of the Skies
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwgZGmBzYGjZaMzMNzMz2MzMzMzMzMzAMmxYmZZmZgBGD2glxox2AYGA2wMYmBDPA`

**Split talents:** Regenerative Magic 86%; Time Spiral (choice) 84%; Clobbering Sweep 84%; Slipstream (choice) 84%; Terror of the Skies 70%; Oppressing Roar 66%; Star Salvo 63%; Font of Magic 61%; Iridescence 60%; Overawe 56%; Scarlet Adaptation 42%; Foci of Life 29%; Enkindled 21%; Sleep Walk 20%; Nimble Flyer (choice) 15%; Unravel 15%; Attuned to the Dream 14%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 36 of 647 run it exactly.

## Preservation Evoker

### Raid

829 rankings over 10 bosses, logged 2026-08-26 to 2026-09-25. 430 distinct builds. Hero tree: Flameshaper 100%, Chronowarden 0%.

**Typical** (Flameshaper, agreement 71% on 10 contested talents, 4 run it exactly):

`CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAMzMDmZMYGzmhZmZbYAAgZMjZMGzImZAAAAmZGZGzMmlZmBAzYGYDsAmhJwmhNDDgZmxA`

**Most common other builds**, each against the typical:

- 37 (4.5%): +Spark of Insight, +Tailwind; -Blast Furnace, -Life-Giver's Flame
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAYmZwMjBzY2MMzMbzYAAgZmZMjxYGhZAAAAmZGZGzMmlZmBAzYGYDsAmhJwmhNDDgZmxA`
- 24 (2.9%): +Stretch Time; -Oppressing Roar
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAMzMDmZMYGzmhZmZbYAAgZMjZwYGZmZAAAAmZGZGzMmlZmBAzYGYDsAmhJwmhNDDgZmxA`
- 13 (1.6%): +Exuberance, +Foci of Life, +Lifecinders, +Scarlet Adaptation, +Stretch Time; -Ancient Flame, -Draconic Instincts, -Enkindled 2/2, -Oppressing Roar
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAMzMDmZMYGzmhZmZbAAAMjZMYGzIzMDAAAwMzMZmZmxsMzMAYGzALgFwMMB2MsZYAMzMGA`
- 13 (1.6%): +Extended Flight 1/2, +Lifecinders; -Blast Furnace, -Draconic Instincts
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAMzMDmZMYGzmhZmZbYAAgZMjZMGzIMDAAAwMzIzYm5BmlZmBAzYGYBsAmhJwmhNDDgZmxA`

**Split talents:** Titan's Gift 88%; Time Spiral (choice) 85%; Ancient Flame 85%; Enkindled 84%; Temporal Artificer 76%; Draconic Instincts (choice) 58%; Blast Furnace 58%; Life-Giver's Flame 55%; Oppressing Roar 46%; Lifecinders (choice) 42%; Extended Flight 38%; Stretch Time 33%; Foci of Life 25%; Spark of Insight 23%; Ouroboros 22%; Scarlet Adaptation 22%; Unravel 20%; Time of Need 19%; Exuberance 15%; Tailwind 15%; Spatial Paradox (choice) 13%; Flow State 12%

**Ours, against the whole sample:**

- `Raid`: the typical build. 4 of 829 run it exactly.

### Mythic+

639 rankings over 8 dungeons, logged 2026-08-28 to 2026-09-25, keys 18 to 21 (median 19). 342 distinct builds. Hero tree: Flameshaper 99%, Chronowarden 1%. 161 left out: their log has no talents.

**Typical** (Flameshaper, agreement 69% on 10 contested talents, 5 run it exactly):

`CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAmZmZ2WGzYYMzsZGw2wAAAzYGzMjhZiZmBAAAMzMTGzMjZZMDAMmBWAbgZYCsxYzwMAzMMA`

**Most common other builds**, each against the typical:

- 17 (2.7%): +Draconic Instincts, +Extended Flight 2/2, +Time Lord 2/2, +Titan's Gift, +Unravel; -Bountiful Bloom, -Clobbering Sweep, -Field of Dreams, -Fluttering Seedlings 2/2, -Foci of Life, -Lifecinders
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAmZmZ2WGYYmZmNzA2GGAAYGGzMjhZaMzMAAAgZmZywMzMLjZAgxMwGYDMDTgNzYzwAYmhB`
- 15 (2.3%): +Terror of the Skies; -Clobbering Sweep
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAmZmZ2WGzYYMzsZGw2wAAAzYGzMjhZiZmBAAAMzMTzYmZMLjZAgxMwCYDMDTgNGbGGAzMMA`
- 10 (1.6%): +Extended Flight 1/2, +Sleep Walk, +Trailblazer; -Ancient Flame, -Foci of Life, -Shape of Flame
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAmZmZ2WGzYYMzsZGw2AAAYGzMzMjhZiZmBAAAMzMTGmZegZZMDAMmBWALgZYCsxYzwMAzMMA`
- 9 (1.4%): +Exhilarating Burst 1/2, +Stretch Time, +Tailwind, +Titan's Gift; -Flow State 2/2, -Oppressing Roar, -Overawe
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAmZmZ2WmHYGDjxsZGw2wAAAzMzYGMMTmZmBAAAMzMTGzMjZZMDAMmBWAbgZYCsZGbGmBYmhB`

**Split talents:** Scarlet Adaptation 81%; Oppressing Roar 77%; Ancient Flame 77%; Flow State 76%; Shape of Flame (choice) 74%; Time Spiral (choice) 73%; Overawe 61%; Foci of Life 60%; Clobbering Sweep 56%; Titan's Gift 50%; Extended Flight 47%; Terror of the Skies 31%; Trailblazer (choice) 25%; Just in Time (choice) 23%; Stretch Time 23%; Protracted Talons 22%; Regenerative Magic 21%; Exhilarating Burst 21%; Unravel 16%; Sleep Walk 15%; Tailwind 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 5 of 639 run it exactly.

## Beast Mastery Hunter

### Raid

696 rankings over 10 bosses, logged 2026-09-03 to 2026-09-25. 406 distinct builds. Hero tree: Pack Leader 100%.

**Typical** (Pack Leader, agreement 67% on 14 contested talents, 1 run it exactly):

`C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzsMzwMmZMzgZGzMMzYmZGmZGzYGMmmBAAAAAAAAzMmBYmNAMLgtBgB`

**Most common other builds**, each against the typical:

- 15 (2.2%): +Catlike Reflexes, +Dire Command, +Dire Frenzy 2/2, +Huntmaster's Call, +Shell Wall, +Wildspeaker; -Beast Cleave, -Emergency Salve, -Laceration, -Misdirection, -Training Expert 2/2, -Wild Thrash
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGGzsMzwMmZMDzMGzMMzYGzwMzYGzghmBAAAAMDAAAzMzMAzsBMMLgtBgB`
- 13 (1.9%): +Kill Cleave, +Thrill of the Hunt 1/2, +Tranquilizing Shot; -Misdirection, -Thrill of the Hunt 2/2
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzs8AzwMzMjZGMzYmhZGzMzwMzYGzghmBAAAAAAAAzMmZAzsBgZBsNAM`
- 11 (1.6%): +Catlike Reflexes, +Dire Command, +Dire Frenzy 2/2, +Huntmaster's Call, +Shell Wall, +Trailblazer, +Wildspeaker; -Beast Cleave, -Binding Shot, -Intimidation, -Laceration, -Misdirection, -Training Expert 2/2, -Wild Thrash
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGGzsMzwMmZMDzMGzMMzYmZGmxYGzghmBAAAAMDAAAzMzAYmNgZxsA2GAG`
- 11 (1.6%): +Guttural Roar, +Kill Cleave, +Thrill of the Hunt 1/2; -Misdirection, -Thrill of the Hunt 2/2
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzs8AzwMzMjZGMzYmhZGzMzYbmZMjZwQzAAAAAAAAgZGzAMzGAmFw2AwA`

**Split talents:** Thrill of the Hunt 89%; Razor Sharp 88%; Scout's Instincts 87%; Disruptive Rounds 84%; Bloody Frenzy 83%; Emergency Salve 82%; Intimidation 74%; Improved Feign Death 73%; Wild Thrash 60%; Beast Cleave 60%; Laceration 60%; Training Expert 58%; Kill Cleave 58%; Catlike Reflexes 53%; Misdirection 52%; Binding Shot 45%; Tranquilizing Shot 41%; Wildspeaker 40%; Shell Wall 40%; Huntmaster's Call 40%; Dire Frenzy 40%; Dire Command 40%; Guttural Roar (choice) 36%; Trailblazer (choice) 22%; Tar Trap (choice) 20%; Aspect of the Beast 16%; Kodo Tranquilizer (choice) 15%; Dire Beast 13%; Horsehair Tether (choice) 11%; Camouflage 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 1 of 696 run it exactly.

### Mythic+

662 rankings over 8 dungeons, logged 2026-08-28 to 2026-09-25, keys 19 to 22 (median 19). 196 distinct builds. Hero tree: Pack Leader 100%. 138 left out: their log has no talents.

**Typical** (Pack Leader, agreement 70% on 6 contested talents, 23 run it exactly):

`C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzsMzwMzMjZGMzYmhZGzMzYbmZMjZwYaGAAAAAAAAYGjBMzGAmFw2AA`

**Most common other builds**, each against the typical:

- 29 (4.4%): +Aspect of the Beast, +Improved Feign Death 1/2, +Kodo Tranquilizer, +Thrill of the Hunt 1/2; -Improved Feign Death 2/2, -Thrill of the Hunt 2/2
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzs8AzYmZmZMzgZGzMMzYmZGbzMjZMDLjpZAAAAAAAAgHYMGwMbAYWAbDAA`
- 24 (3.6%): +Scout's Instincts, +Trailblazer; -Disruptive Rounds, -Guttural Roar
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzsMzwMzMjZGMzYmhZGzMzgZGzYGMmmBAAAAAAAAzMGDYmNALmFw2AA`
- 23 (3.5%): +Binding Shot, +Scout's Instincts; -Disruptive Rounds, -Guttural Roar
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzsMzwMzMjZGMzYmhZGzMzgZGzYGMmmBAAAAAAAAzMmZAzsBgZBsNAA`
- 23 (3.5%): +Kodo Tranquilizer; -Disruptive Rounds
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzsMzwMzMjZGMzYmhZGzMzYzMjZMDLjpZAAAAAAAAgZMGwMbAYWAbDAA`

**Split talents:** Pathfinding 89%; Misdirection 70%; Guttural Roar (choice) 66%; Disruptive Rounds 47%; Scout's Instincts 42%; Kodo Tranquilizer (choice) 37%; Aspect of the Beast 27%; Camouflage 24%; Binding Shot 17%; Shell Wall 14%; Trailblazer (choice) 13%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 23 of 662 run it exactly.

## Marksmanship Hunter

### Raid

820 rankings over 10 bosses, logged 2026-08-31 to 2026-09-25. 369 distinct builds. Hero tree: Sentinel 100%.

**Typical** (Sentinel, agreement 72% on 10 contested talents, 4 run it exactly):

`C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmZxMmZGzgx0MGMbbmZmZmZmZGMzywMDAAYMzwAYGbMMAbMz2MG`

**Most common other builds**, each against the typical:

- 23 (2.8%): +Binding Shot, +Born To Be Wild 1/2, +Guttural Roar, +On Target; -Accuracy By Volume, -Born To Be Wild 2/2, -Emergency Salve
  `C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmxMLbzYmZMDeATzYwsttNzMzMzMzMYmlhZAAAGzMjBwM2YYA2YmtZMA`
- 21 (2.6%): +Camouflage, +Improved Feign Death 2/2, +On Target; -Accuracy By Volume, -Intimidation, -Scout's Instincts, -Tar Trap
  `C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmhZMzMmBjpZMY222mZmZmZmZGYWGmBAAwMzwAYGbMmBYjZ2mxA`
- 20 (2.4%): +Binding Shot, +Born To Be Wild 1/2, +Guttural Roar; -Born To Be Wild 2/2, -Emergency Salve
  `C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmxMLbzYmZMDeATzYwstZmZmZmZmZwMLDzMAAgxMzYAMjNGGgNmZbGD`
- 15 (1.8%): +Guttural Roar, +On Target; -Accuracy By Volume, -Shell Wall
  `C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmZZbGzMjZwYaGDmtttZmZmZmZmBzsMMDAAwYmhBwM2ADwGzsNjB`

**Split talents:** Catlike Reflexes 89%; Light Ammo 87%; Aspect of the Hydra (choice) 87%; Guardian's Hide (choice) 87%; Misdirection 85%; Emergency Salve 77%; Shell Wall 63%; Intimidation 57%; Improved Feign Death 48%; Binding Shot 45%; Accuracy By Volume 44%; On Target (choice) 42%; Tar Trap (choice) 39%; Guttural Roar (choice) 28%; Obsidian Arrowhead (choice) 19%; Trailblazer (choice) 18%; Tranquilizing Shot 15%; Camouflage 14%; Roar of Sacrifice (choice) 13%; Horsehair Tether (choice) 13%; Tenacious (choice) 12%

**Ours, against the whole sample:**

- `Raid`: the typical build. 4 of 820 run it exactly.

### Mythic+

610 rankings over 8 dungeons, logged 2026-08-21 to 2026-09-25, keys 16 to 20 (median 17). 183 distinct builds. Hero tree: Sentinel 95%, Dark Ranger 5%. 190 left out: their log has no talents.

**Typical** (Sentinel, agreement 65% on 8 contested talents, 12 run it exactly):

`C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmx2MmZGzwyYaGDmlttZmZmZmZmZhZWGmBAAwDMGDAzYDMAbMz2MG`

**Most common other builds**, each against the typical:

- 78 (12.8%): +Obsidian Arrowhead, +Open Fire; -On Target, -Stargazer
  `C4PAAAAAAAAAAAAAAAAAAAAAAwGMwMGNWGAzgNAAAAAAAAwMmZmx2MmZGzwyYaGDmltlZmZmZmZmZhZWGmBAAwDMGDAzYDMAbMz2MG`
- 46 (7.5%): +Open Fire; -Stargazer
  `C4PAAAAAAAAAAAAAAAAAAAAAAwGMwMGNWGAzgNAAAAAAAAwMmZmx2MmZGzwyYaGDmlttZmZmZmZmZhZWGmBAAwDMGDAzYDMAbMz2MG`
- 35 (5.7%): +Improved Feign Death 2/2; -Disruptive Rounds, -Improved Feign Death 1/2
  `C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmxmxMzYGWGTzYwsstNzMzMzMzMLMzywMAAAmxYAYGbgBYjZ2mxA`
- 13 (2.1%): +Binding Shot, +Scout's Instincts; -Improved Feign Death 1/2, -Kodo Tranquilizer
  `C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmx2MmZGzgx0MGMLbbzMzMzMzMzCzsMMDAAwYMzAwM2ADwGzsNjB`

**Split talents:** Unerring Vision (choice) 88%; Guttural Roar (choice) 88%; Tenacious (choice) 71%; Disruptive Rounds 64%; Kodo Tranquilizer (choice) 59%; Stargazer (choice) 58%; On Target (choice) 44%; Accuracy By Volume 39%; Open Fire (choice) 37%; Obsidian Arrowhead (choice) 32%; Scout's Instincts 19%; Camouflage 15%; Binding Shot 13%; Kill Shot 12%; Calling the Shots (choice) 12%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 12 of 610 run it exactly.

## Survival Hunter

### Raid

539 rankings over 10 bosses, logged 2026-09-02 to 2026-09-25. 280 distinct builds. Hero tree: Sentinel 94%, Pack Leader 6%. 1 left out: their log has no talents.

**Typical** (Sentinel, agreement 73% on 10 contested talents, 10 run it exactly):

`C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGwmxMzYYZAAAAAAYGzMzgxYGzgx0MAAAADAmxyyMzswMzMzMzAAzYhhxYmZzAA`

**Most common other builds**, each against the typical:

- 50 (9.3%): +Trailblazer; -Emergency Salve
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGwmxMzYYZAAAAAAYGzYGMGzYGMmmBAAAYAwMWWmZmFmZmZmZGAYGLMLGjZmNDA`
- 9 (1.7%): +Disruptive Rounds, +Tranquilizing Shot, +Wilderness Medicine; -Improved Feign Death 2/2, -Shell Wall
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGwmxMzYYZAAAAAAYmZmZGmxYGzgx0MAAAADAmxyyMzswMzMjZGDAzYBMGzMbGAA`
- 8 (1.5%): +Disruptive Rounds, +Guttural Roar, +Tranquilizing Shot; -Improved Feign Death 2/2, -Shell Wall
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGwmxMzYYZAAAAAAYGzMzYbGjZMDGTzAAAAMAYGLLzMzCzMzMmZMAMjFwYMzsZAA`
- 7 (1.3%): +Disruptive Rounds, +Improved Feign Death 1/2, +Trailblazer; -Improved Feign Death 2/2, -Intimidation
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGwmxMzYYZAAAAAAYGzMzwMGzYGMmmBAAAAAmxyyMzswMzMzDMzAAzYhZxYMzsZAA`

**Split talents:** Twin Fangs 89%; Flanked 89%; Savagery 85%; Two Against Many 75%; Twilight Requiem (choice) 75%; Intimidation 75%; Catlike Reflexes 74%; Emergency Salve 73%; Disruptive Rounds 63%; Improved Feign Death 58%; Shell Wall 52%; Trailblazer (choice) 49%; Shellshock 35%; Tranquilizing Shot 33%; Binding Shot 28%; Stalk and Strike (choice) 19%; Guttural Roar (choice) 17%; Explosives Expert 14%; Bombardier 14%; Lethal Calibration 13%; Wilderness Medicine 12%

**Ours, against the whole sample:**

- `Raid`: the typical build. 10 of 539 run it exactly.

### Mythic+

655 rankings over 8 dungeons, logged 2026-08-25 to 2026-09-25, keys 16 to 21 (median 17). 215 distinct builds. Hero tree: Sentinel 57%, Pack Leader 43%. 145 left out: their log has no talents.

**Typical** (Sentinel, agreement 58% on 27 contested talents, 3 run it exactly):

`C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGw2MzMzYmZbGAAAAAAzYmZGbzYMjZwYaGAAAgBAYZbmxyMmZYGjBgZsBGDzsZAA`

**Most common other builds**, each against the typical:

- 30 (4.6%): +Scout's Instincts, +Trailblazer; -Improved Feign Death 2/2
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGw2MzMzYmZbGAAAAAAzYmZGbzYMjZwYaGAAAgBAYZbmxyMmZMGjBgZshFjhZ2MAA`
- 27 (4.1%): +Better Together, +Bloodseeker, +Dire Summons, +Flanked, +Fury of the Wyvern, +Hogstrider, +Kodo Tranquilizer, +Lethal Barbs, +No Mercy, +Pack Leader, +Pack Mentality, +Razor Edge 2/2, +Savagery 2/2, +Sharpened Claws, +Sharpened Fangs, +Shell Cover, +Shrapnel Bomb, +Slicked Shoes, +Stampede!, +Sweeping Spear 1/2, +Vulnerability, +Wyvern's Gaze; -Arcane Talons, -Blackrock Munitions, -Bombardier, -Can't Miss, Won't Miss, -Conditioning, -Disruptive Rounds, -Don't Look Back, -Explosives Expert 2/2, -Flamebreak, -Grenade Juggler, -Improved Wildfire Bomb 2/2, -Invigorating Pulse, -Lunar Calling, -Lunar Storm, -Moon's Blessing, -Moonlight Chakram, -Radiant Edge, -Sanctified Armaments, -Sentinel, -Shellshock, -Stalk and Strike, -Stargazer
  `C8PAAAAAAAAAAAAAAAAAAAAAAMgxMG2gFYGGawiZmZmZGLDAAAAAAzYmZGbGjZMDLjpZAAAAGAMssMz8ALMzMMjxAmZDAjxMzmBA`
- 24 (3.7%): +Bloodseeker, +Flanked, +Improved Feign Death 1/2, +Improved Wildfire Bomb 1/2, +Kodo Tranquilizer, +Shrapnel Bomb, +Sic 'Em, +Twin Fangs; -Flamebreak, -Flanker's Advantage, -Grenade Juggler, -Improved Feign Death 2/2, -Improved Wildfire Bomb 2/2, -Shellshock
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGw2MzMzMjZbeAAAAAAAzYmZGbzYMjZYZMNDAAAwAAjllZGLYmZ8AjxAwM2AjxMzmBA`
- 18 (2.7%): +Better Together, +Bloodseeker, +Devilsaur Tranquilizer, +Dire Summons, +Flanked, +Fury of the Wyvern, +Hogstrider, +Lethal Barbs, +No Mercy, +Pack Leader, +Pack Mentality, +Razor Edge 2/2, +Savagery 2/2, +Sharpened Claws, +Sharpened Fangs, +Shell Cover, +Shrapnel Bomb, +Slicked Shoes, +Stampede!, +Sweeping Spear 1/2, +Vulnerability, +Wyvern's Gaze; -Arcane Talons, -Blackrock Munitions, -Bombardier, -Can't Miss, Won't Miss, -Conditioning, -Don't Look Back, -Explosives Expert 2/2, -Flamebreak, -Grenade Juggler, -Improved Wildfire Bomb 2/2, -Invigorating Pulse, -Lunar Calling, -Lunar Storm, -Moon's Blessing, -Moonlight Chakram, -Pathfinding, -Radiant Edge, -Sanctified Armaments, -Sentinel, -Shellshock, -Stalk and Strike, -Stargazer
  `C8PAAAAAAAAAAAAAAAAAAAAAAMgxMG2gFYGGawiZmZmZGLDAAAAAAzYmZGbzYYMDbjpZAAAAGAMssMz8ALMzMMjxAmZDAjxMzmBA`

**Split talents:** Flanker's Advantage 83%; Pathfinding 82%; Guttural Roar (choice) 80%; Guardian's Hide (choice) 76%; Improved Feign Death 76%; Disruptive Rounds 70%; Stargazer (choice) 57%; Sanctified Armaments 57%; Radiant Edge 57%; Moonlight Chakram 57%; Moon's Blessing 57%; Lunar Storm 57%; Lunar Calling 57%; Invigorating Pulse 57%; Explosives Expert 57%; Don't Look Back 57%; Can't Miss, Won't Miss 57%; Bombardier 57%; Arcane Talons 57%; Conditioning (choice) 57%; Improved Wildfire Bomb 56%; Stalk and Strike (choice) 56%; Shrapnel Bomb (choice) 56%; Blackrock Munitions (choice) 56%; Flanked 55%; Bloodseeker 53%; Kodo Tranquilizer (choice) 50%; Razor Edge 45%; Vulnerability (choice) 44%; Flamebreak (choice) 44%; Grenade Juggler 44%; Stampede! 43%; Slicked Shoes (choice) 43%; Shell Cover 43%; Sharpened Fangs 43%; Pack Mentality 43%; No Mercy 43%; Lethal Barbs 43%; Hogstrider 43%; Fury of the Wyvern 43%; Dire Summons 43%; Better Together 43%; Savagery 43%; Wyvern's Gaze (choice) 43%; Sharpened Claws (choice) 40%; Sweeping Spear 37%; Shellshock 35%; Sic 'Em 31%; Scout's Instincts 28%; Roar of Sacrifice (choice) 24%; Devilsaur Tranquilizer (choice) 19%; Twin Fangs 16%; Camouflage 13%; Shell Wall 11%; Trailblazer (choice) 11%; Binding Shot 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 3 of 655 run it exactly.

## Arcane Mage

### Raid

830 rankings over 10 bosses, logged 2026-08-31 to 2026-09-25. 309 distinct builds. Hero tree: Sunfury 100%.

**Typical** (Sunfury, agreement 74% on 6 contested talents, 97 run it exactly):

`C4DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMDamZGAAAGAwMz0sssMDAgNAAAzMDbWmxMLzYMzMzMswMmZmBAYAAAGgZGwMAYYmZA`

**Most common other builds**, each against the typical:

- 33 (4.0%): +Master of Escape; -Captured Thoughts
  `C4DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMDamxAAAwAAmZmmlllZAAsBAAYmZYzyMmZZGjZmZmhFmZmZmBAYAAAGgZGwMAYYmZA`
- 31 (3.7%): +Master of Escape; -Mana Confluence
  `C4DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMDamZGAAAGAwMz0sssMDAgNAAAzMDbWmxMLzYMzMzMswMzMzMAADAAwAMzAMAYYmZA`
- 30 (3.6%): +Explosive Potential, +Master of Escape; -Lessons in Debilitation, -Mana Confluence
  `C4DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMDamZGAAAGAwMz0sssNDAgNAAAzMDbWmxMLzYMzMzMswMzMzMAADAAwAMzAMAYYmZA`
- 25 (3.0%): +Incantation of Swiftness 1/2, +Master of Escape; -Incantation of Swiftness 2/2
  `C4DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswDMDamZGAAAGAwMz0sssMDAgNAAAzMDbWmxMLzYMzMzMswMzMzMAADAAwAMzAmBADzMD`

**Split talents:** Aether Attunement 89%; Incantation of Swiftness 78%; Captured Thoughts 71%; Lessons in Debilitation (choice) 71%; Mana Confluence 67%; Master of Escape 62%; Explosive Potential (choice) 29%; Supernova (choice) 26%; Remove Curse 18%; Dragon's Breath (choice) 18%; Arcane Familiar 17%; Spellsteal 13%; Energized Familiar 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 97 of 830 run it exactly.

### Mythic+

712 rankings over 8 dungeons, logged 2026-09-05 to 2026-09-25, keys 20 to 22 (median 21). 252 distinct builds. Hero tree: Sunfury 100%. 88 left out: their log has no talents.

**Typical** (Sunfury, agreement 70% on 7 contested talents, 20 run it exactly):

`C4DAAAAAAAAAAAAAAAAAAAAAAMzwMLzMmFMDamZGAAAGAwMz0sssMDAgNAA2YMzMsZZGzsMjxMmZGWYmZmZGAgBAAYAmZAzAghZmB`

**Most common other builds**, each against the typical:

- 45 (6.3%): +Remove Curse; -Mana Confluence
  `C4DAAAAAAAAAAAAAAAAAAAAAAMzwMLzMmFMzQzMzAAAwAAmZmmlllZAAsBAwGjZmhNLzYmlZMmxMzwCzMzMzAAMAAADwMDwAghZmB`
- 21 (2.9%): +Consortium's Bauble, +Master of Time 1/2; -Mana Bomb, -Spellsteal
  `C4DAAAAAAAAAAAAAAAAAAAAAAYGmZZm5BmFMDamZGAAAGAwMz0sssMDAgNAA2gZmhNLzYmlZMmZmZGWYmZmZGAgBAAYAmZAzAghZmB`
- 17 (2.4%): +Master of Time 1/2; -Spellsteal
  `C4DAAAAAAAAAAAAAAAAAAAAAAYGmZZm5BmFMDamZGAAAGAwMz0sssMDAgNAA2YMzMsZZGzsMjxMmZGWYmZmZGAgBAAYAmZAzAghZmB`
- 15 (2.1%): +Master of Time 1/2, +Remove Curse; -Mass Invisibility, -Spellsteal
  `C4DAAAAAAAAAAAAAAAAAAAAAAYGGLzMPwsgZGamZGAAAGAwMz0sssMDAgNAA2YMzMsZZGzsMjxMmZGWYmZmZGAgBAAYAmZAzAghZmB`

**Split talents:** Master of Escape 89%; Lessons in Debilitation (choice) 76%; Master of Time 70%; Mass Invisibility 64%; Mana Confluence 61%; Mana Bomb 61%; Spellsteal 56%; Remove Curse 52%; Consortium's Bauble 38%; Explosive Potential (choice) 24%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 20 of 712 run it exactly.

## Fire Mage

### Raid

333 rankings over 10 bosses, logged 2026-09-02 to 2026-09-25. 144 distinct builds. Hero tree: Sunfury 100%.

**Typical** (Sunfury, agreement 72% on 11 contested talents, 1 run it exactly):

`C8DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMzIzMzAAAwAAmZmmlttZAA2MzM2mZmZGAAAAAwiZmZGAAYGjZmZGzMLDAzMwYMgZYMA`

**Most common other builds**, each against the typical:

- 28 (8.4%): +Dragon's Breath; -Master of Escape
  `C8DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMzIzMzAAAwAAmZmmlttZAA2MzM2mZmZGLAAAAAYxMjZAAgZMmZmZMzsMAMzAjxAmhxA`
- 17 (5.1%): +Spellsteal, +Supernova, +Time Manipulation; -Improved Counterspell, -Incantation of Swiftness 2/2
  `C8DAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzIzMzMAAAGAwMz0sstNDAwmZmx2MzMzYDAAAAALmZmZAAgZMmZmZMzsMAMzAMGwMMGA`
- 16 (4.8%): +Dragon's Breath, +Flamestrike; -Flamestrike, -Master of Escape
  `C8DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMzIzMzAAAwAAmZmmlttZAA2MzM2mZmZGLAAAAAYxMjZAAgZMmZmZMzsNAMzAjxAmhxA`
- 9 (2.7%): +Dragon's Breath, +Lessons in Debilitation; -Explosive Potential, -Master of Escape
  `C8DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMzIzMzAAAwAAmZmmltlZAA2MzM2mZmZGLAAAAAYxMjZAAgZMmZmZMzsMAMzAjxAmhxA`

**Split talents:** Merely a Setback (choice) 89%; Heat Shimmer 89%; Improved Warding 88%; Time Walk (choice) 80%; Remove Curse 80%; Captured Thoughts 80%; Flamestrike (choice) 67%; Incantation of Swiftness 65%; Master of Escape 62%; Improved Counterspell 54%; Explosive Potential (choice) 53%; Lessons in Debilitation (choice) 47%; Spellsteal 46%; Supernova (choice) 40%; Dragon's Breath (choice) 39%; Improved Conjuration 36%; Flamestrike (choice) 33%; Temporal Realignment (choice) 20%; Time Manipulation 15%; Ring of Frost (choice) 15%; Time Twist (choice) 11%; Wildfire 10%

**Ours, against the whole sample:**

- `Raid`: the typical build. 1 of 333 run it exactly.

### Mythic+

512 rankings over 8 dungeons, logged 2026-08-27 to 2026-09-25, keys 16 to 19 (median 16). 204 distinct builds. Hero tree: Sunfury 100%. 288 left out: their log has no talents.

**Typical** (Sunfury, agreement 70% on 9 contested talents, 1 run it exactly):

`C8DAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzIzMzMAAAGAwMz0sstMDAwmZmx2MzMzYDAAAAALmZmZAAgZMmZmZMzsMAMzAMGwMMGA`

**Most common other builds**, each against the typical:

- 47 (9.2%): +Explosive Potential; -Lessons in Debilitation
  `C8DAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzIzMzMAAAGAwMz0sstNDAwmZmx2MzMzYDAAAAALmZmZAAgZMmZmZMzsMAMzAMGwMMGA`
- 23 (4.5%): +Mass Invisibility; -Time Manipulation
  `C8DAAAAAAAAAAAAAAAAAAAAAAMzwMLzMzsgZGZmZGAAAGAwMz0sstMDAwmZmx2MzMzYDAAAAALmZmZAAgZMmZmZMzsMAMzAMGwMMGA`
- 14 (2.7%): +Explosive Potential, +Flamestrike; -Flamestrike, -Lessons in Debilitation
  `C8DAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzIzMzMAAAGAwMz0sstNDAwmZmx2MzMzYDAAAAALmZmZAAgZMmZmZMzsNAMzAMGwMMGA`
- 13 (2.5%): +Conflagration, +Incantation of Swiftness 1/2; -Energized Barriers, -Heat Shimmer
  `C8DAAAAAAAAAAAAAAAAAAAAAAMzwYZGzswDMzIzMzMAAAGAwMz0sstMDAwmZmx2MzMzYDAAAAALmZmZAAgZMmZmZMzsAgZGgxMwMMGA`

**Split talents:** Firestarter 88%; Merely a Setback (choice) 84%; Captured Thoughts 80%; Supernova (choice) 77%; Time Walk (choice) 74%; Heat Shimmer 67%; Flamestrike (choice) 59%; Lessons in Debilitation (choice) 56%; Explosive Potential (choice) 44%; Time Manipulation 41%; Flamestrike (choice) 41%; Mass Invisibility 34%; Improved Counterspell 30%; Temporal Realignment (choice) 25%; Dragon's Breath (choice) 23%; Improved Conjuration 23%; Conflagration 20%; Fire's Ire 16%; Time Twist (choice) 16%; Incantation of Swiftness 16%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 1 of 512 run it exactly.

## Frost Mage

### Raid

654 rankings over 10 bosses, logged 2026-08-27 to 2026-09-25. 289 distinct builds. Hero tree: Spellslinger 73%, Frostfire 27%.

**Typical** (Spellslinger, agreement 75% on 26 contested talents, 91 run it exactly):

`CAEAAAAAAAAAAAAAAAAAAAAAAYGGLzMzsMmZmYmZGzMzMziZmZMjZAAAgZmZWWmZaDAAAAAA2AYbZMzMDmthxMsAAAwMbAzADYGMMA`

**Most common other builds**, each against the typical:

- 40 (6.1%): +Improved Conjuration 2/2; -Improved Warding, -Remove Curse
  `CAEAAAAAAAAAAAAAAAAAAAAAAYGGLzMzsMmZEzMzYmZmZWMzMjZMDAAAMzMzyyMTbAAAAAAwGAbLjZmZGmthxMsAAAwMbAzADYGMA`
- 26 (4.0%): +Blast Radius, +Dragon's Breath, +Dualcasting Adept, +Duality, +Elemental Affinity, +Elemental Conduit, +Flash Freezeburn, +Frostfire, +Frostfire Empowerment, +Frostfire Infusion, +Glacial Shatter, +Hailstones, +Hand of Frost 3/4, +Heat Sink, +Imbued Warding, +Isothermic Core, +Molten Chill, +Piercing Cold, +Rimecaster 2/2, +Thermal Conditioning; -Archmage's Wrath, -Augury Abounds, -Controlled Instincts, -Crystalline Refraction, -Force of Will, -Frigid Focus, -Glaciate, -Hand of Frost 4/4, -Improved Warding, -Infused Splinters, -Polished Focus, -Ray of Frost, -Reactive Barrier, -Shifting Shards, -Signature Spell, -Slippery Slinging, -Spellfrost Teachings, -Spellslinger, -Splintering Orbs, -Splinterstorm
  `CAEAAAAAAAAAAAAAAAAAAAAAAYGGLzMzsMmZmYmZGzYmZWMzMzMMzsMTzMLzCAAAsAAALAAAAAstMmZmBz2MmZGbLAAAgZGMDMgB+AA`
- 18 (2.8%): +Blast Radius, +Dragon's Breath, +Dualcasting Adept, +Duality, +Elemental Affinity, +Elemental Conduit, +Flash Freezeburn, +Frostfire, +Frostfire Empowerment, +Frostfire Infusion, +Glacial Shatter, +Hailstones, +Hand of Frost 3/4, +Heat Sink, +Imbued Warding, +Isothermic Core, +Molten Chill, +Piercing Cold, +Rimecaster 2/2, +Thermal Conditioning; -Archmage's Wrath, -Augury Abounds, -Controlled Instincts, -Crystalline Refraction, -Force of Will, -Frigid Focus, -Glaciate, -Hand of Frost 4/4, -Infused Splinters, -Master of Escape, -Polished Focus, -Ray of Frost, -Reactive Barrier, -Shifting Shards, -Signature Spell, -Slippery Slinging, -Spellfrost Teachings, -Spellslinger, -Splintering Orbs, -Splinterstorm
  `CAEAAAAAAAAAAAAAAAAAAAAAAYGGLzMzsMmZmYmZGzYmZWMzMzMMzsMTzMLzCAAAsAAALAAAAAstMmxMY2mxMzYbBAAAMzgZgBMwHwA`
- 13 (2.0%): +Blast Radius, +Dragon's Breath, +Dualcasting Adept, +Duality, +Elemental Affinity, +Elemental Conduit, +Flash Freezeburn, +Frostfire, +Frostfire Empowerment, +Frostfire Infusion, +Glacial Shatter, +Hailstones, +Hand of Frost 3/4, +Heat Sink, +Imbued Warding, +Isothermic Core, +Molten Chill, +Piercing Cold, +Rimecaster 2/2, +Thermal Conditioning; -Archmage's Wrath, -Augury Abounds, -Captured Thoughts, -Controlled Instincts, -Crystalline Refraction, -Force of Will, -Frigid Focus, -Glaciate, -Hand of Frost 4/4, -Infused Splinters, -Polished Focus, -Ray of Frost, -Reactive Barrier, -Shifting Shards, -Signature Spell, -Slippery Slinging, -Spellfrost Teachings, -Spellslinger, -Splintering Orbs, -Splinterstorm
  `CAEAAAAAAAAAAAAAAAAAAAAAAYGGLzMzsMmZmYmxYGzMziZmZmhZmlZamZZWAAAgFAAYBAAAAgtlxMzMY2mxMzYbBAAAMzgZgBMwHwA`

**Split talents:** Master of Escape 86%; Time Walk (choice) 85%; Frost Conditioning 80%; Glaciate 79%; Ray of Frost 79%; Captured Thoughts 76%; Remove Curse 74%; Splinterstorm 73%; Splintering Orbs 73%; Spellfrost Teachings 73%; Signature Spell 73%; Polished Focus 73%; Infused Splinters 73%; Force of Will 73%; Controlled Instincts 73%; Augury Abounds 73%; Archmage's Wrath 73%; Shifting Shards (choice) 73%; Reactive Barrier (choice) 73%; Improved Warding 73%; Slippery Slinging (choice) 72%; Frigid Focus (choice) 70%; Crystalline Refraction 68%; Rimecaster 33%; Piercing Cold 33%; Hailstones 32%; Dragon's Breath (choice) 31%; Improved Conjuration 31%; Molten Chill 27%; Isothermic Core 27%; Imbued Warding (choice) 27%; Heat Sink 27%; Glacial Shatter (choice) 27%; Frostfire Infusion 27%; Frostfire Empowerment 27%; Flash Freezeburn 27%; Elemental Conduit 27%; Duality 27%; Dualcasting Adept 27%; Blast Radius 27%; Elemental Affinity (choice) 26%; Supernova (choice) 20%; Thermal Conditioning (choice) 20%; Time Manipulation 20%; Temporal Realignment (choice) 15%; Improved Counterspell 13%

**Ours, against the whole sample:**

- `Raid`: the typical build. 91 of 654 run it exactly.

### Mythic+

525 rankings over 8 dungeons, logged 2026-08-28 to 2026-09-25, keys 16 to 20 (median 16). 237 distinct builds. Hero tree: Spellslinger 59%, Frostfire 41%. 275 left out: their log has no talents.

**Typical** (Spellslinger, agreement 63% on 27 contested talents, 8 run it exactly):

`CAEAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzEzMmZmZmZWMzMjZMDAAAMzMzyyMTbAAwGAAAYBgtlxMzMY2GGzwCAAAzsBMDjBMDGGA`

**Most common other builds**, each against the typical:

- 20 (3.8%): +Blast Radius, +Comet Storm, +Dualcasting Adept, +Duality, +Elemental Affinity, +Elemental Conduit, +Flash Freezeburn, +Frost Conditioning, +Frostfire, +Frostfire Empowerment, +Frostfire Infusion, +Glacial Shatter, +Hailstones, +Heat Sink, +Imbued Warding, +Isothermic Core, +Molten Chill, +Piercing Cold, +Rimecaster 2/2, +Severe Temperatures; -Archmage's Wrath, -Augury Abounds, -Controlled Instincts, -Crystalline Refraction, -Force of Will, -Hand of Frost 4/4, -Infused Splinters, -Polished Focus, -Reactive Barrier, -Shifting Shards, -Signature Spell, -Slippery Slinging, -Spellfrost Teachings, -Spellslinger, -Splintering Orbs, -Splintering Ray, -Splinterstorm, -Time Manipulation
  `CAEAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmlhZmYmxYmZmZWMzMzMzMzsMTzMbzCAAAsAAAbAAAAAstMmZmBz2MmZGbLAAAgZGMDjBMAGA`
- 14 (2.7%): +Blast Radius, +Comet Storm, +Dualcasting Adept, +Duality, +Elemental Affinity, +Elemental Conduit, +Flash Freezeburn, +Frostfire, +Frostfire Empowerment, +Frostfire Infusion, +Glacial Shatter, +Hailstones, +Heat Sink, +Imbued Warding, +Isothermic Core, +Molten Chill, +Piercing Cold, +Rimecaster 2/2, +Severe Temperatures; -Archmage's Wrath, -Augury Abounds, -Controlled Instincts, -Crystalline Refraction, -Force of Will, -Hand of Frost 4/4, -Infused Splinters, -Polished Focus, -Reactive Barrier, -Shifting Shards, -Signature Spell, -Slippery Slinging, -Spellfrost Teachings, -Spellslinger, -Splintering Orbs, -Splintering Ray, -Splinterstorm
  `CAEAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzEzMmZmZmZWMzMzMzMzsMTzMbzCAAAsAAAbAAAAAstMmZmBz2MmZGbLAAAgZGMDjBMAGA`
- 13 (2.5%): +Blast Radius, +Comet Storm, +Dragon's Breath, +Dualcasting Adept, +Duality, +Elemental Affinity, +Elemental Conduit, +Flash Freezeburn, +Frostfire, +Frostfire Empowerment, +Frostfire Infusion, +Glacial Shatter, +Hailstones, +Heat Sink, +Imbued Warding, +Isothermic Core, +Molten Chill, +Piercing Cold, +Rimecaster 2/2, +Severe Temperatures; -Archmage's Wrath, -Augury Abounds, -Controlled Instincts, -Crystalline Refraction, -Force of Will, -Hand of Frost 4/4, -Infused Splinters, -Polished Focus, -Reactive Barrier, -Shifting Shards, -Signature Spell, -Slippery Slinging, -Spellfrost Teachings, -Spellslinger, -Splintering Orbs, -Splintering Ray, -Splinterstorm, -Supernova
  `CAEAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzEzMmZmZmZWMzMzMzMzsMTzMbzCAAAsAAALAAAAAstMmZmBz2MmZGbLAAAgZGMDjBMAGA`
- 12 (2.3%): +Dragon's Breath, +Freezing Rain; -Frozen Touch, -Supernova
  `CAEAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzEzMmZmZmZWMzMMjZAAAgZmZWWmZaDAAWAAAALAstMmZmBz2wYmxCAAAzsBMDjBMDGGA`

**Split talents:** Wintertide (choice) 87%; Spellsteal 87%; Improved Warding 79%; Frozen Touch 69%; Blizzard (choice) 68%; Improved Counterspell 65%; Crystalline Refraction 60%; Hand of Frost 60%; Supernova (choice) 59%; Splinterstorm 59%; Splintering Orbs 59%; Spellfrost Teachings 59%; Signature Spell 59%; Shifting Shards (choice) 59%; Reactive Barrier (choice) 59%; Polished Focus 59%; Infused Splinters 59%; Force of Will 59%; Controlled Instincts 59%; Augury Abounds 59%; Archmage's Wrath 59%; Splintering Ray (choice) 58%; Slippery Slinging (choice) 56%; Time Manipulation 55%; Time Walk (choice) 52%; Temporal Realignment (choice) 48%; Frost Conditioning 43%; Rimecaster 41%; Molten Chill 41%; Isothermic Core 41%; Imbued Warding (choice) 41%; Heat Sink 41%; Frostfire Infusion 41%; Frostfire Empowerment 41%; Flash Freezeburn 41%; Elemental Conduit 41%; Duality 41%; Dualcasting Adept 41%; Comet Storm 41%; Blast Radius 41%; Hailstones 41%; Elemental Affinity (choice) 41%; Piercing Cold 41%; Glacial Shatter (choice) 41%; Dragon's Breath (choice) 39%; Severe Temperatures (choice) 34%; Freezing Rain 33%; Blizzard (choice) 32%; Incantation of Swiftness 29%; Captured Thoughts 23%; Mass Invisibility 21%; Improved Conjuration 14%; White Out (choice) 13%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 8 of 525 run it exactly.

## Brewmaster Monk

### Raid

655 rankings over 10 bosses, logged 2026-08-28 to 2026-09-25. 390 distinct builds. Hero tree: Shado-Pan 76%, Master of Harmony 24%.

**Typical** (Shado-Pan, agreement 74% on 26 contested talents, 4 run it exactly):

`CwQAAAAAAAAAAAAAAAAAAAAAAAAAAwMbbGzYGWmxGmZMAAAAAAALLYEzMwMM2YwMzMDz2YmxMLDLb22mtZMLAAwGAAAY2mlmZmZhhNAmZYaMAAgB`

**Most common other builds**, each against the typical:

- 14 (2.1%): +Empty the Cellar, +Energy Transfer, +Save Them All; -Chi Transfer, -Tiger Tail Sweep, -Vital Flame
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAwMbbGzYGWmxGmZMAAAAAAALLYEzMYmhZ2YwMzMDz2wMGLDLb22GzYWAAgNAAAwsNLNzMziZYDgZGmGDAAYA`
- 13 (2.0%): +Ancient Arts 1/2, +Bob and Weave, +Elixir of Determination, +Jade Walk, +Save Them All, +Zen State; -Ancient Arts 2/2, -Black Ox Brew, -Walk with the Ox 2/2, -Windwalking
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAwMbbGzwYWmxGzMjBAAAAAAYZBjYmBmhZ2MDmZmZY2YmxMLPALbW2mtZMLAAwGAAAY2mlmZmZhhNAmZYaMAAgB`
- 13 (2.0%): +Ancient Arts 1/2, +Chi Wave, +Empty the Cellar, +Save Them All, +Silent Sanctuary; -Ancient Arts 2/2, -Chi Burst, -Chi Transfer, -Vital Flame
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAwMbbGzYGWmxGmZMAAAAAAALLYEzMwMMzGDmZmZY2GmxMLPALb22GzYWAAgNAAAwsNLNzMziZYBgZGmGDYAAD`
- 9 (1.4%): +Peace and Prosperity; -Bounding Agility
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAwMbbGzYGWmxGmZMAAAAAAALLYEzMwMM2gxMzMDz2YmxMLDLb22mtZMLAAwGAAAY2mlmZmZhhNAmZYaMAAgB`

**Split talents:** Walk with the Ox 89%; Chi Burst (choice) 88%; Improved Blackout Kick 88%; Vivacious Vivification 87%; Windwalking 83%; Wisdom of the Wall 76%; Weapons of the Wall 76%; Vigilant Watch 76%; Veteran's Eye 76%; Stand Ready 76%; Shado Over the Battlefield 76%; Pride of Pandaria (choice) 76%; One Versus Many 76%; Martial Precision 76%; Efficient Training 76%; Against All Odds 76%; Predictive Training (choice) 76%; Bounding Agility 73%; Tiger Tail Sweep 73%; Fuel on the Fire 67%; Vital Flame (choice) 66%; Combat Stance (choice) 62%; Swift as a Coursing River 60%; Empty the Cellar 52%; Chi Transfer 41%; Zen State 38%; Jade Walk 35%; Save Them All 34%; Peace and Prosperity 32%; Elixir of Determination 29%; Way of a Thousand Strikes (choice) 24%; Purified Spirit (choice) 24%; Potential Energy 24%; Overwhelming Force 24%; Meditative Focus 24%; Mantra of Purity (choice) 24%; Manifestation 24%; Harmonic Surge 24%; Endless Draught 24%; Coalescence 24%; Clarity of Purpose 24%; Balanced Stratagem 24%; Pressure Points 23%; Silent Sanctuary 22%; Tiger's Vigor (choice) 18%; Summon Black Ox Statue 17%; Ox Stance 15%; Initiator's Edge (choice) 14%; High Tolerance 14%; Chi Wave (choice) 12%

**Ours, against the whole sample:**

- `Raid`: the typical build. 4 of 655 run it exactly.

### Mythic+

698 rankings over 8 dungeons, logged 2026-08-24 to 2026-09-25, keys 18 to 22 (median 19). 135 distinct builds. Hero tree: Master of Harmony 97%, Shado-Pan 3%. 102 left out: their log has no talents.

**Typical** (Master of Harmony, agreement 64% on 4 contested talents, 20 run it exactly):

`CwQAAAAAAAAAAAAAAAAAAAAAAAAAAgZbzYGGzyMzGzMjBAAAAAAYZBzEzMwMM2gxMzMDzGzMmZZYZ7B22mNMLAAwysMtMbzsMAAAAG2AzMgpxAAAG`

**Most common other builds**, each against the typical:

- 53 (7.6%): +Transcendence: Linked Spirits; -Tiger Tail Sweep
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAgZbzYGGzyMzGzMjBAAAAAAYZBzEzMwMM2gxMzMDzmtZGjlhltHYbb2wsAAALzy0ysNzyAAAAYYDMzAmGDAAYA`
- 43 (6.2%): +Windwalking; -Tiger Tail Sweep
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAgZbzYGGzyMzGzMjBAAAAAAYZBzEzMwMM2gxMzMDz2YmxYZYZ7B22mNMLAAwysMtMbzsMAAAAG2AzMgpxAAAG`
- 39 (5.6%): +Jade Walk, +Transcendence: Linked Spirits; -Peace and Prosperity, -Tiger Tail Sweep
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAgZbzYGGzyMzGzMjBAAAAAAYZBzEzMwMM2MwMzMDzmtZGjlhltHYbb2wsAAALzy0ysNzyAAAAYYDMzAmGDAAYA`
- 24 (3.4%): +Ironshell Brew, +Jade Walk, +Summon Black Ox Statue; -Expeditious Fortification, -Peace and Prosperity, -Tiger Tail Sweep
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAgZbzYGGzyMzGzMjBAAAAAAYZBzEzMwMM2MwMzMjZWYmxYZYZ7B22mNMLAAwysMtMbzsMAAAAG2AzMgpxAAAG`

**Split talents:** Tiger's Vigor (choice) 84%; Vivacious Vivification 82%; Tiger Tail Sweep 46%; Peace and Prosperity 43%; Jade Walk 37%; Windwalking 26%; Summon Black Ox Statue 25%; Transcendence: Linked Spirits (choice) 25%; Save Them All 14%; Roar from the Heavens (choice) 13%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 20 of 698 run it exactly.

## Mistweaver Monk

### Raid

711 rankings over 10 bosses, logged 2026-09-02 to 2026-09-25. 326 distinct builds. Hero tree: Conduit of the Celestials 98%, Master of Harmony 2%. 6 refused: unknown talents or not 34/34/13 points.

**Typical** (Conduit of the Celestials, agreement 74% on 13 contested talents, 26 run it exactly):

`C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAghx2YZYzixMzyyM2wYGmZZZbmxCzoZMDYwgxsMzMzwsNYwiJAAAAAAYxyMLz2MDAAMgBYGwYYsIjZA`

**Most common other builds**, each against the typical:

- 23 (3.2%): +Revival; -Restoral
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAghx2YZYzixMzyyM2wYGmZZZZmxCzoZMDYwgxsMzMzwsNYwiJAAAAAAYxyMLz2MDAAMgBYGwYYsIjZA`
- 20 (2.8%): +Chi Transfer; -Jade Infusion
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAghx2YZYzixMzyyM2wYGmZZZbmxCzoZMDYwgxYmZmhZbMGsYCAAAAAAWsMzysNzAAADYAmBMGGLyYGA`
- 20 (2.8%): +Crane Style, +Deep Clarity, +Zen Pulse; -Chrysalis, -Healing Elixir, -Mists of Life
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAghx2MwmFzYmllZshZmhZWW2mZswMaGzAGMYMLzMzMMbDGsYCAAAAAAWsMzysNzAAADYAmBMGGLyYGA`
- 14 (2.0%): +Chi Transfer, +Revival; -Jade Infusion, -Restoral
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAghx2YZYzixMzyyM2wYGmZZZZmxCzoZMDYwgxYmZmhZbMGsYCAAAAAAWsMzysNzAAADYAmBMGGLyYGA`

**Split talents:** Silent Sanctuary 90%; Invoke Yu'lon, the Jade Serpent (choice) 89%; Expeditious Fortification (choice) 88%; Windwalking 88%; Jade Infusion (choice) 86%; Energizing Brew (choice) 82%; Improved Touch of Death 77%; Bounding Agility 66%; Healing Elixir 64%; Mists of Life 63%; Chrysalis (choice) 61%; Peace and Prosperity 60%; Restoral (choice) 52%; Crane Style 50%; Revival (choice) 48%; Zen Pulse 41%; Deep Clarity 38%; Tiger Tail Sweep 37%; Ancient Arts 25%; Reinvigoration 14%; Morning Breeze (choice) 12%; Ironshell Brew (choice) 12%; Resplendent Mist 12%; Jade Walk 11%; Invoke Chi-Ji, the Red Crane (choice) 11%; Lifecycles (choice) 10%; Pressure Points 10%; Chi Transfer 10%

**Ours, against the whole sample:**

- `Raid`: the typical build. 26 of 711 run it exactly.

### Mythic+

629 rankings over 8 dungeons, logged 2026-08-27 to 2026-09-25, keys 18 to 21 (median 19). 213 distinct builds. Hero tree: Conduit of the Celestials 98%, Master of Harmony 2%. 132 left out: their log has no talents. 39 refused: unknown talents or not 34/34/13 points.

**Typical** (Conduit of the Celestials, agreement 77% on 9 contested talents, 27 run it exactly):

`C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBWmZZML2mxMz2mBmhZzMbLLzMWYMNjZADGAzMzMMbYGmlZCAAAAAAWsNz2sNzAAADGDwMgxALyYGA`

**Most common other builds**, each against the typical:

- 30 (4.8%): +Peace and Prosperity; -Chi Wave
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBWmZZML2mxMz2mBmhZzMbLLzMWYMNjZADGwYmZmhZDzwsMTAAAAAAwitZ2mtZGAAAGDwMgxALyYGA`
- 24 (3.8%): +Peace and Prosperity, +Swift Art; -Chi Wave, -Vital Clarity
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBWmZZML2mxMz2mBmhZzMbLLzMWYMNjZAjxAGzMzMMbYGmlZCAAAAAAWsNz2sNzAAAwYAmBMALyYGA`
- 21 (3.3%): +Swift Art; -Vital Clarity
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBWmZZML2mxMz2mBmhZzMbLLzMWYMNjZAjxAYmZmhZDzwsMTAAAAAAwitZ2mtZGAAYwYAmBMALyYGA`
- 19 (3.0%): +Improved Touch of Death, +Swift Art; -Tiger Tail Sweep, -Vital Clarity
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBWmZZML2mxMz2mBmhZzMbLLzMWYmpZMDYMGAzMzMMbYGsMTAAAAAAwitZ2mtZGAAYwYAmBMALyYGA`

**Split talents:** Gift of the Celestials (choice) 89%; Energizing Brew (choice) 87%; Pressure Points 85%; Pool of Mists 79%; Diffuse Magic 78%; Chi Wave 76%; Fatal Touch 75%; Xuen's Guidance (choice) 70%; Vital Clarity 59%; Swift Art 41%; Peace and Prosperity 34%; Temple Training (choice) 28%; Amplified Rush 22%; Improved Touch of Death 20%; Jade Infusion (choice) 18%; Mist Wrap 17%; Windwalking 15%; Jade Bond (choice) 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 27 of 629 run it exactly.

## Windwalker Monk

### Raid

781 rankings over 10 bosses, logged 2026-09-02 to 2026-09-25. 413 distinct builds. Hero tree: Conduit of the Celestials 92%, Shado-Pan 8%.

**Typical** (Conduit of the Celestials, agreement 73% on 14 contested talents, 4 run it exactly):

`C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYZmZ2mBAAAAAAAAAAAYZY0wMMMgZMMzMzwsNMDzyMBAsYmtxMmZmZAAsYmlZZMBAAMGAzAMWGAzMzmPA`

**Most common other builds**, each against the typical:

- 31 (4.0%): +Peace and Prosperity, +Shadowboxing Treads, +Song of Chi-Ji; -Ring of Peace, -Rising Star, -Soothing Mist
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYZmZ2mxAAAAAAAAAAAAbDjwMMMgZMjZmZGmthZYWmJAgFmtxMmZmZAAsYmlZZMBAAMGAzAMWGAzMzmPA`
- 19 (2.4%): +Elusive Mists, +Jadefire Stomp, +Peace and Prosperity, +Silent Sanctuary, +Singularly Focused Jade; -Ancient Arts 2/2, -Harmonic Combo, -Jade Ignition, -Tiger Tail Sweep
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYM2GGsMzMbzAAAAAAAAAAAAsMMaGzwwAmxMmZmZY2GmBLmAAWMz2YGzMzMAAWMzysMmAAAYAMDwYZGgZmZzHA`
- 19 (2.4%): +Elusive Mists, +Jadefire Stomp, +Singularly Focused Jade; -Harmonic Combo, -Jade Ignition, -Tiger Tail Sweep
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYM2GGsMzMbzAAAAAAAAAAAAsMMaGzwwAmxwMzMDz2wMYZmAAWMz2YGzMzMAAWMzysMmAAAYAMDwYZAMzMb+A`
- 18 (2.3%): +Elusive Mists, +Jadefire Stomp, +Memory of the Monastery, +Singularly Focused Jade, +Tigereye Brew 2/4; -Inner Peace, -Jade Ignition, -Jade Walk, -Tigereye Brew 3/4
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYM2GGsMzMbzAAAAAAAAAAAAsMMaGzwwAGGmZmZY2GmhZZmAAWMz2MzYMzMAAWMzysMmAAAGDgZAGLDgZmZzFA`

**Split talents:** Detox 89%; Xuen's Bond (choice) 88%; Vigorous Expulsion 88%; Windwalking 86%; Ancient Arts 81%; Harmonic Combo 80%; Tiger Tail Sweep 78%; Rising Star 76%; Niuzao's Protection (choice) 68%; Soothing Mist 66%; Jade Walk 66%; Inner Peace 62%; Elusive Mists 62%; Singularly Focused Jade (choice) 56%; Jadefire Stomp 56%; Jade Ignition 49%; Memory of the Monastery 42%; Peace and Prosperity 31%; Jade Sanctuary (choice) 24%; Silent Sanctuary 22%; Shadowboxing Treads 19%; Bounding Agility 16%; Pressure Points 13%; Touch of the Tiger 12%

**Ours, against the whole sample:**

- `Raid`: the typical build. 4 of 781 run it exactly.

### Mythic+

683 rankings over 8 dungeons, logged 2026-08-31 to 2026-09-25, keys 19 to 22 (median 19). 206 distinct builds. Hero tree: Conduit of the Celestials 99%, Shado-Pan 1%. 117 left out: their log has no talents.

**Typical** (Conduit of the Celestials, agreement 73% on 9 contested talents, 9 run it exactly):

`C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYbmZ2mBAAAAAAAAAAAYZYmmxMMMghhZmZGmNMDzyMBAswsxMmZmZAAsYmlZbMBAAmxAYGgxyAYmZ2M`

**Most common other builds**, each against the typical:

- 40 (5.9%): +Chi Transfer, +Drinking Horn Cover; -Spiritual Focus, -Tiger Tail Sweep
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYZmZ2mBAAAAAAAAAAAYZYmmxMMMghhZmZGmNmZwyMBAswsxMmZmZAAsYmlZbMBAAmxAYGgxyAYmZ2M`
- 32 (4.7%): +Ancient Arts 1/2, +Drinking Horn Cover, +Martial Agility, +Swift Art; -Ancient Arts 2/2, -Inner Peace, -Spiritual Focus
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYZmZ2mBAAAAAAAAAAAYZYmmxMMMGMMMzMzwshZYWegJAgFmtxMGzMDAgFzsMbjJAAwMGAzAMWGAzMzmB`
- 27 (4.0%): +Chi Transfer, +Profound Rebuttal; -Strength of Spirit, -Tiger Tail Sweep
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYbmZ2mBAAAAAAAAAAAYZYmmxMMMghhZmZGmNmZwyMBAswsxMmZmZAAsYmlZbMBAAmxAYGgx2AYmZ2M`
- 27 (4.0%): +Chi Transfer; -Tiger Tail Sweep
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYbmZ2mBAAAAAAAAAAAYZYmmxMMMghhZmZGmNmZwyMBAswsxMmZmZAAsYmlZbMBAAmxAYGgxyAYmZ2M`

**Split talents:** Strength of Spirit (choice) 84%; Vigorous Expulsion 84%; Soothing Mist 74%; Elusive Mists 73%; Jade Sanctuary (choice) 72%; Inner Peace 72%; Tiger Tail Sweep 62%; Spiritual Focus (choice) 50%; Drinking Horn Cover (choice) 50%; Chi Transfer 37%; Martial Agility 36%; Jade Walk 28%; Niuzao's Protection (choice) 26%; Diffuse Magic 24%; Swift Art 21%; Windwalking 14%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 9 of 683 run it exactly.

## Holy Paladin

### Raid

770 rankings over 10 bosses, logged 2026-08-28 to 2026-09-25. 258 distinct builds. Hero tree: Herald of the Sun 100%. 1 left out: their log has no talents.

**Typical** (Herald of the Sun, agreement 81% on 5 contested talents, 275 run it exactly):

`CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwMAAw2MzMjZMzYxYmZYZwMLmpJGGzMDjZLDADYYDsxyMmZZ2mZmtGAAAgFAYzwYGzwMAAmZYGjhB`

**Most common other builds**, each against the typical:

- 32 (4.2%): +Light's Revocation, +Unbound Freedom; -Echoing Blessings, -Hammer of Wrath
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwAAA2mZmZMjZGLGzMDLDmZxMNxYGzMDjZLDADYYDsx2MmZZ2mZmtGAAAgFAYzwYGzwMAAmZYGjhB`
- 23 (3.0%): +Unbound Freedom; -Echoing Blessings
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwMAAw2MzMjZMzYxYmZYZwMLmpJGGzMDjZLDADYYDsx2MmZZ2mZmtGAAAgFAYzwYGzwMAAmZYGjhB`
- 22 (2.9%): +Light's Revocation; -Hammer of Wrath
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwAAA2mZmZMjZGLGzMDLDmZxMNxYGzMDjZLDADYYDsxyMmZZ2mZmtGAAAgFAYzwYGzwMAAmZYGjhB`
- 13 (1.7%): +A Just Reward 1/2, +Empyreal Ward; -A Just Reward 2/2
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwMAAw2MzMjZMzYxYmZYZwMLmpJGGzMDjZLDADYYDsxyMmZZ2mZmtGAAAgFAYzDMGzYGmBAwMDzYMMA`

**Split talents:** Glistening Radiance 90%; A Just Reward 89%; Hammer of Wrath 84%; Blinding Light 82%; Echoing Blessings (choice) 74%; Light's Revocation 33%; Unbound Freedom (choice) 24%; Empyreal Ward 12%

**Ours, against the whole sample:**

- `Raid`: the typical build. 275 of 770 run it exactly.

### Mythic+

692 rankings over 8 dungeons, logged 2026-09-03 to 2026-09-25, keys 20 to 22 (median 21). 357 distinct builds. Hero tree: Lightsmith 93%, Herald of the Sun 7%. 108 left out: their log has no talents.

**Typical** (Lightsmith, agreement 67% on 8 contested talents, 26 run it exactly):

`CEEAAAAAAAAAAAAAAAAAAAAAAAAAgZBAmBAAWGwMzyMzsMjZMsY2MziZaihxMzMGzWGAGA2AbsYmBAAAmZWWWsMzwGbjZwGwMGAgZGAmxY0A`

**Most common other builds**, each against the typical:

- 15 (2.2%): +Unbound Freedom; -Echoing Blessings
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAgZBAmBAAWGwMzyMzsMjZMsY2MziZaihxMzMGzWGAGA2AbsZmBAAAmZWWWsMzwGbjZwGwMGAgZGAmxY0A`
- 13 (1.9%): +Aurora, +Beacon of Virtue, +Blessing of An'she, +Born in Sunlight, +Call of the Righteous 1/2, +Consecrated Ground, +Divine Glimpse, +Endless Gleam, +Eternal Flame, +Gleaming Rays, +Herald of the Sun, +Luminosity, +Pillars of Light, +Reclamation, +Righteous Protection, +Ringing of the Heavens, +Sacrifice of the Just, +Second Sunrise, +Solar Grace, +Sun Sear, +Sun's Avatar, +Truth Prevails, +Walk Into Light, +Will of the Dawn; -Authoritative Rebuke, -Beacon of Faith, -Blessing of the Forge, -Call of the Righteous 2/2, -Divine Favor, -Divine Guidance, -Divine Inspiration, -Empyrean Legacy, -Faith's Armor, -Hammer and Anvil, -Holy Ritual, -Improved Blessing of Protection, -Laying Down Arms, -Lightsmith, -Masterwork, -Reflection of Radiance, -Resounding Strike, -Rising Sunlight, -Rite of Sanctification, -Shared Resolve, -Solidarity, -Tirion's Devotion, -Valiance
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwMAAD2GGmZWmZsYMzMsMPwmZWMaiZxYmZYMbZAYAYDsxiZmZZ2mZmtGAAAgF2YGsBMzGMDAgZGmxYYA`
- 13 (1.9%): +A Just Reward 1/2, +Unbound Freedom; -Brought to Light, -Echoing Blessings
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAgZBAmBAAWGwMzyMzsMjZMsY2MziZaihxMzMGzWGAGA2AbsZmBAAAmZWWWsMzwGbjZwmHAmxAAMzAgxY0A`
- 13 (1.9%): +Light's Revocation, +Vengeful Wrath 1/2; -Vengeful Wrath 2/2
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAgZBAmBAAWGwMzyMzsMjZMsY2MziZaixMmZmxY2yAwAwGYjFzMAAAwMzyyilZG2Yb8AD2AmxAAMzAwMGjGA`

**Split talents:** Holy Ritual 90%; Authoritative Rebuke (choice) 84%; Unwavering Spirit (choice) 75%; Brought to Light 72%; Vengeful Wrath 71%; Improved Blessing of Protection 58%; Echoing Blessings (choice) 58%; Sacrifice of the Just (choice) 45%; Faith's Armor 45%; Unbound Freedom (choice) 41%; A Just Reward 30%; Light's Revocation 28%; Righteous Protection (choice) 26%; Consecrated Ground 22%; Protection of Tyr (choice) 19%; Lead the Charge 13%; Empyreal Ward 12%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 26 of 692 run it exactly.

## Protection Paladin

### Raid

780 rankings over 10 bosses, logged 2026-09-03 to 2026-09-25. 580 distinct builds. Hero tree: Lightsmith 98%, Templar 2%.

**Typical** (Lightsmith, agreement 75% on 22 contested talents, 2 run it exactly):

`CIEAAAAAAAAAAAAAAAAAAAAAAsNDzyMzMzMzMsMGWGWGGAgBAAAAAApZmlZGzMMmt2AwADYGsBAAAAzMLbLtMzYx2GzAgxMMGAMzAgZGwYB`

**Most common other builds**, each against the typical:

- 13 (1.7%): +Blinding Light, +Bulwark of Order, +Empyreal Ward, +Eye for an Eye, +Obduracy 1/2, +Recompense, +Redoubt, +Tyr's Enforcer 2/2; -Afterimage, -Imbued Shield, -Lightbearer, -Obduracy 2/2, -Sacrifice of the Just, -Sanctuary, -Seal of Reprisal, -Sentinel
  `CIEAAAAAAAAAAAAAAAAAAAAAAsNzYWmZmZGzMsNYWGWGGAgBAAAAAANNzsNzYmhZegtAgBGwAbAAAAwMzy2SLzMWstxMAGMDjBAzMAYmBMWA`
- 11 (1.4%): +Bulwark of Order, +Divine Reach, +Tyr's Enforcer 1/2; -Blessing of Protection, -Gift of the Golden Val'kyr, -Sanctuary
  `CIEAAAAAAAAAAAAAAAAAAAAAAsNzDYWmZMzYmhlxYWGWGGAgBAAAAAApZmlZGzgxs1GAGYGYGsBAAAAzMLbLtMzYx2GzAgxMMGAMzAgZGwYB`
- 10 (1.3%): +Blinding Light, +Bulwark of Order, +Cleanse Toxins, +Crusader's Resolve, +Empyreal Ward, +Obduracy 1/2, +Soaring Shield, +Tyr's Enforcer 2/2; -Consecration in Flame 2/2, -Ferren Marcus's Fervor 2/2, -Focused Enmity, -Obduracy 2/2, -Punishment, -Sacrifice of the Just
  `CIEAAAAAAAAAAAAAAAAAAAAAAsNzYWGzYmZmx2yYMLDLzYAAGAAAAAA00MjZGzMMegt2AwAAzgNAAAAYmZZbplZGL2WYGAjxMMGAMzAgZGwYB`
- 9 (1.2%): +Blessing of Dawn, +Blinding Light, +Brought to Light, +Cleanse Toxins, +Empyreal Ward, +Redoubt, +Tyr's Enforcer 1/2; -Consecrated Ground, -Imbued Shield, -Light's Revocation, -Lightforged Blessing, -Punishment, -Sacrifice of the Just, -Seal of Reprisal
  `CIEAAAAAAAAAAAAAAAAAAAAAAsNzDYWmZmZmZmhtxwywyMGAAAAAAAAopZGmxMDjZLAYAgZw2AAAAgZmltlWmZsYbDDgxYGGDAmZAYmZAjF`

**Split talents:** Imbued Shield (choice) 90%; Focused Enmity (choice) 88%; Fist of Justice 88%; Seal of Reprisal (choice) 87%; Sweeping Verdict (choice) 86%; Tempered in Battle (choice) 85%; Ferren Marcus's Fervor 82%; Guided Prayer 82%; Vision of Sanctity 82%; Consecration in Flame 80%; Consecrated Ground 78%; Afterimage 77%; Gift of the Golden Val'kyr 76%; Light's Revocation 74%; Lightbearer 73%; Blessing of Protection 72%; Sanctuary 72%; Lightforged Blessing 71%; Empyreal Ward 63%; Sacrifice of the Just (choice) 62%; Instrument of the Divine (choice) 60%; Bulwark of Order 60%; Punishment 58%; Cleanse Toxins 56%; Crusader's Resolve (choice) 52%; Blinding Light 48%; Tyr's Enforcer 40%; Solace (choice) 39%; Divine Reach 26%; Improved Blessing of Protection 25%; Light of the Titans (choice) 25%; Undying Embers 15%; Blessing of Dawn 14%; Eye for an Eye 13%; Authoritative Rebuke (choice) 13%; Recompense (choice) 12%; Soaring Shield (choice) 11%; Redoubt (choice) 10%

**Ours, against the whole sample:**

- `Raid`: the typical build. 2 of 780 run it exactly.

### Mythic+

694 rankings over 8 dungeons, logged 2026-08-31 to 2026-09-25, keys 18 to 21 (median 19). 289 distinct builds. Hero tree: Lightsmith 100%, Templar 0%. 106 left out: their log has no talents.

**Typical** (Lightsmith, agreement 74% on 11 contested talents, 44 run it exactly):

`CIEAAAAAAAAAAAAAAAAAAAAAAsZYWGzYmZmZWWGjZZWmlZMAADAAAAAAaamZZmxMDDbtBgBGwMYDAAAAmZW2WaZmxilFmBwgZ2wAgZGAMzAGL`

**Most common other builds**, each against the typical:

- 19 (2.7%): +Redoubt; -Imbued Shield
  `CIEAAAAAAAAAAAAAAAAAAAAAAsZYWGzYmZmZW2GjZZWmlZMAADAAAAAAaamZZmxMDDbtBgBGwMYDAAAAmZW2WaZmxilFmBwgZ2wAgZGAMzAGL`
- 14 (2.0%): +Blessed Word, +Redoubt; -Imbued Shield, -Searing Sunlight
  `CIEAAAAAAAAAAAAAAAAAAAAAAsZsNLjZMzMzMLbjxYWmlZMAADAAAAAAaamZZmxMDDbtBgBGwMYDAAAAmZW2WaZmxilFmBwgZ2wAgZGAMzAGL`
- 13 (1.9%): +Lead the Charge; -Righteous Protection
  `CIEAAAAAAAAAAAAAAAAAAAAAAsZYWGzYmZmZWWGjZZWmlZMAADAAAAAAaamZZmxMDDbtBgBGwMYDAAAAmZW2WaZmxilFmBwgZYMAYmBAzMgxC`
- 12 (1.7%): +Brought to Light, +Consecration in Flame 2/2, +Lead the Charge, +Obduracy 2/2; -Afterimage, -Empyreal Ward, -Light of the Titans, -Righteous Protection, -Unbound Freedom, -Undying Embers
  `CIEAAAAAAAAAAAAAAAAAAAAAAsZYWGzMzMzMWWGjZZMLzYAAGAAAAAA00MzyMjZGGzWbAYgBA2AAAAgZmltlWmZsYZhZAAzwYAwMDAzMDYsA`

**Split talents:** Unbound Freedom 90%; Blessing of Protection 89%; Light of the Titans (choice) 89%; Sacrifice of the Just (choice) 88%; Blessing of Spellwarding (choice) 84%; Lightforged Blessing 79%; Empyreal Ward 66%; Searing Sunlight (choice) 65%; Obduracy 60%; Imbued Shield (choice) 57%; Afterimage 56%; Righteous Protection (choice) 54%; Lead the Charge 52%; Redoubt (choice) 43%; Blessed Word (choice) 43%; Lightbearer 21%; Consecration in Flame 12%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 44 of 694 run it exactly.

## Retribution Paladin

### Raid

727 rankings over 10 bosses, logged 2026-09-02 to 2026-09-25. 354 distinct builds. Hero tree: Herald of the Sun 98%, Templar 2%.

**Typical** (Herald of the Sun, agreement 75% on 8 contested talents, 21 run it exactly):

`CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzMzAAAAAAYmyYGmZsNmthZ2mxYMGmxCbAYWmtZmZrBAAAWAMAYMDzgZMzsBMzMMGGMA`

**Most common other builds**, each against the typical:

- 66 (9.1%): +Punishment; -Blessed Calling
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzMzAAAAAAYmyYGmZsNmthZ2mxYMGmxCbAYWmtZmZrBAAAWAMAYMDDMjZmNgZmhxMGMA`
- 32 (4.4%): +Punishment; -Cleanse Toxins
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAANbbzMzyYmZGAAAAAAzUGzwMjtxsNMz2MGjxwMWYDAzysNzMbNAAAwCgBAjZYGMjZmNgZmhxMGMA`
- 19 (2.6%): +Punishment, +Righteous Protection, +Sacrifice of the Just; -Blessed Calling, -Consecrated Ground, -Lead the Charge
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzYGAAAAAAzUmlZYmx2Y2GmZbGjxYYGLsBgZZ2mZmtGAAAYBwAgxMbAzYmZDYmZYMjBD`
- 11 (1.5%): +Lightforged Blessing; -Blessed Calling
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzMzAAAAAAYmyYGmZsNmthZ2mxMjxwMWYDAzysNzMbNAAAwCgBAjZYgZMzsBMzMMGGMA`

**Split talents:** Tempest of the Lightbringer 90%; Lightbearer 85%; Blessed Champion 85%; Blade of Vengeance 79%; Blinding Light 75%; Cleanse Toxins 69%; Consecrated Ground 67%; Blessed Calling 50%; Punishment 47%; Sacrifice of the Just (choice) 28%; Lightforged Blessing 26%; Heart of the Crusader 21%; Recompense (choice) 13%; Holy Reprieve 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 21 of 727 run it exactly.

### Mythic+

682 rankings over 8 dungeons, logged 2026-09-03 to 2026-09-25, keys 19 to 22 (median 20). 151 distinct builds. Hero tree: Herald of the Sun 100%, Templar 0%. 118 left out: their log has no talents.

**Typical** (Herald of the Sun, agreement 66% on 5 contested talents, 121 run it exactly):

`CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZZbmZWGzYGAAAAAAzUmlZYmx2Y2GmZbGjxYYGLsBgZZ2mZmtGAAAYBwAgxMbAzYmZDYmZYMjBD`

**Most common other builds**, each against the typical:

- 69 (10.1%): +Light of Justice; -Swift Justice
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzYGAAAAAAzUmlZYmx2Y2GmZbGjxYYGLsBgZZ2mZmtGAAAYBwAgxMbAzYmZDYmZYMjBD`
- 37 (5.4%): +Consecrated Ground, +Lead the Charge, +Light of Justice; -Righteous Protection, -Sacrifice of the Just, -Swift Justice
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzMzAAAAAAYmyYGmZsNmthZ2mxYMGmxCbAYWmtZmZrBAAAWAMAYMDDMjZmNgZmhxMGMA`
- 30 (4.4%): +Consecrated Ground, +Lead the Charge, +Light of Justice; -Punishment, -Righteous Protection, -Swift Justice
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzMzAAAAAAYmysMDzM2Gz2wMbzYMGDzYhNAMLz2Mzs1AAAALAGAMmhBmxMzGwMzwYYwA`
- 18 (2.6%): +Lead the Charge; -Righteous Protection
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZZbmZWGzYGAAAAAAzUmlZYmx2Y2GmZbGjxYYGLsBgZZ2mZmtGAAAYBwAgxMMwMmZ2AmZGGzYwA`

**Split talents:** Sacrifice of the Just (choice) 87%; Punishment 66%; Lightbearer 62%; Righteous Protection (choice) 60%; Swift Justice (choice) 55%; Lead the Charge 48%; Light of Justice (choice) 45%; Consecrated Ground 41%; Lightforged Blessing 16%; Blessed Calling 15%; Improved Blessing of Protection 12%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 121 of 682 run it exactly.

## Discipline Priest

### Raid

768 rankings over 10 bosses, logged 2026-08-25 to 2026-09-25. 361 distinct builds. Hero tree: Voidweaver 99%, Oracle 1%.

**Typical** (Voidweaver, agreement 67% on 9 contested talents, 2 run it exactly):

`CAQAAAAAAAAAAAAAAAAAAAAAAADsMmxyYmBzwMmZbmZmZmZAAAAAAAAAAYGWmBzMzwMmZATz0YwMDAAwsNbLgxmBAgxYmxgZwMDmJYA`

**Most common other builds**, each against the typical:

- 39 (5.1%): +Lightburst, +Protector of the Frail; -Body and Soul, -Searing Light
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMmxyYmBzgZbmtZmZmZmBAAAAAAAAAgZYZGMzMDzYmBMNTzMYmBAAY2mtFwYzAAwYMzYwMYmBjgB`
- 27 (3.5%): +Lightburst, +Mental Agility, +Protector of the Frail; -Body and Soul, -Psychic Scream, -Searing Light
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMmxyYmBzgZbmtZmZmZmBAAAAAAAAAgZYZGMzMDzwMgpZamBzMAAAz2stAGbGAAGjZGDzMYmBjgB`
- 16 (2.1%): +Protector of the Frail; -Searing Light
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMmxyYmBzgZbmtZmZmZmBAAAAAAAAAgZYZGMzMDzYmBMNTjBzMAAAz2stAGbGAAGjZGDmBzMYmgB`
- 12 (1.6%): +Encroaching Shadows, +Lightburst; -Body and Soul, -Searing Light
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMmxyYmxYGMmZbmZmZmZAAAAAAAAAAYGWmBzMzwMmZATz0MDmZAAAmtZbBM2MAAMGzMGMDmZwIYA`

**Split talents:** Inspiration 82%; Mass Dispel 80%; Pain Suppression 75%; Holy Nova 73%; Body and Soul 68%; Shield Discipline 58%; Void Leech (choice) 57%; Psychic Scream 57%; Searing Light 52%; Lightburst 45%; Embrace the Shadow (choice) 42%; Abyssal Reverie 37%; Dispel Magic 32%; Protector of the Frail (choice) 32%; Mental Agility 23%; Tithe Evasion 17%; Weal and Woe 16%; Encroaching Shadows 16%; Move with Grace 15%

**Ours, against the whole sample:**

- `Raid`: the typical build. 2 of 768 run it exactly.

### Mythic+

638 rankings over 8 dungeons, logged 2026-09-01 to 2026-09-25, keys 17 to 21 (median 18). 346 distinct builds. Hero tree: Oracle 78%, Voidweaver 22%. 162 left out: their log has no talents.

**Typical** (Oracle, agreement 77% on 34 contested talents, 3 run it exactly):

`CAQAAAAAAAAAAAAAAAAAAAAAAADsMDWmZMGzwMbzYmZmZMzAAAAAAAAAAYYWmBzMzwMmZATzEDwMLYIMmlBYMYBAAGzMzYwMAzMzAmB`

**Most common other builds**, each against the typical:

- 21 (3.3%): +Enduring Luminescence, +Revel in Darkness; -Occultist, -Shadow Tap
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMDWmZMmBmZbmtZmZmxMDAAAAAAAAAghZZGMzMDzYmBMNTMAzsghwYWGgxgFAAYMzMjBzAMzMDYG`
- 12 (1.9%): +Angel's Mercy, +Blaze of Light 1/2, +Revel in Darkness, +Tithe Evasion; -Dark Indulgence, -Mindpierce, -Psychic Scream, -Searing Light
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMzDwyMjxMzgZbGzMjZMzAAAAAAAAAAYYWmhZmZGmhZgZamYAmZBDhxsMAjBLAAwYmxYwMAzMzAmB`
- 12 (1.9%): +Blaze of Light 2/2, +Collapsing Void, +Dark Energy, +Darkening Horizon, +Devour Matter, +Divine Procession, +Dominate Mind, +Enduring Luminescence, +Greater Smite, +Inner Quietus, +Overwhelming Shadows, +Petrifying Scream, +Phantasm, +Quickened Pulse, +Touch of the Void, +Void Blast, +Void Infusion, +Void Leech, +Voidheart, +Voidweaver, +Voidwraith; -Angelic Bulwark, -Assured Safety, -Body and Soul, -Borrowed Time 2/2, -Divine Feathers, -Foreseen Circumstances, -Inspiration, -Oracle, -Piety, -Preemptive Care, -Preventive Measures, -Prompt Prognosis, -Prophet's Insight, -Prophet's Will, -Searing Light, -Shield Discipline, -Twinsight, -Unfolding Vision, -Waste No Time, -Weal and Woe, -Words of the Wise
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMzMWYMGzgZzsNzMzMzMDAAAAAAAAAgxYZGMzMjNjZGsZamYwMDAAwsNbLgxmBAgxMzMGMDmZwIYG`
- 11 (1.7%): +Abyssal Reverie 1/2, +Angel's Mercy, +Revel in Darkness, +Tithe Evasion; -Dark Indulgence, -Mindpierce, -Psychic Scream, -Searing Light
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMDWmZMmZmHgZbGzMjZMzAAAAAAAAAAYYWmhZmZGmhZgZamYAmZBDhxsMAjBLAAwYmxYwMAzMzAmB`

**Split talents:** Holy Ray 90%; Dark Indulgence 89%; Borrowed Time 89%; Shadow Mend 87%; Ultimate Penitence (choice) 86%; Divine Aegis 85%; Shield Discipline 83%; Grim Deliverance 83%; Purge the Wicked 80%; Weal and Woe 78%; Words of the Wise 78%; Waste No Time 78%; Unfolding Vision 78%; Twinsight 78%; Prophet's Insight 78%; Prompt Prognosis 78%; Preventive Measures 78%; Preemptive Care 78%; Piety 78%; Foreseen Circumstances 78%; Assured Safety 78%; Prophet's Will (choice) 78%; Angelic Bulwark 76%; Inspiration 76%; Mindpierce 73%; Psychic Scream 72%; Body and Soul 71%; Revel in Darkness 70%; Shadow Tap 56%; Occultist 55%; Divine Feathers (choice) 55%; Searing Light 46%; Blaze of Light 46%; Phantasm 43%; Enduring Luminescence (choice) 35%; Divine Procession 31%; Dominate Mind (choice) 31%; Greater Smite 29%; Save the Day (choice) 23%; Abyssal Reverie 22%; Voidwraith 22%; Voidheart 22%; Void Infusion 22%; Void Blast 22%; Touch of the Void 22%; Quickened Pulse 22%; Overwhelming Shadows 22%; Inner Quietus 22%; Devour Matter 22%; Collapsing Void 22%; Pain and Suffering 22%; Darkening Horizon (choice) 22%; Angel's Mercy 22%; Dark Energy (choice) 21%; Mental Agility 19%; Void Leech (choice) 17%; Improved Purify 16%; Tithe Evasion 13%; Power Word: Barrier (choice) 13%; Petrifying Scream (choice) 12%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 3 of 638 run it exactly.

## Holy Priest

### Raid

746 rankings over 10 bosses, logged 2026-08-26 to 2026-09-25. 281 distinct builds. Hero tree: Oracle 100%.

**Typical** (Oracle, agreement 77% on 7 contested talents, 55 run it exactly):

`CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAYBmZWGzMmZMMDzsMzYGAAAAzYWmBzMzwMMDgZqBwMLYIMmlBYMwiZmZBgZMGjhZGgZmZgB`

**Most common other builds**, each against the typical:

- 41 (5.5%): +Psychic Scream; -Lightburst
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAYBmZWGzMmZMMDzsMzYGAAAAzYWmBzMzwMmZAMTBwMLYIMmlBYMwiZmZBgZMGjhZGgZmZgB`
- 22 (2.9%): +Save the Day; -Divine Feathers
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAYBmZWGzMmZMMDzsMzYGAAAAzYWmBzMzwMMDgZqBwMbYIMmlBYMwiZmZBgZMGjhZGgZmZgB`
- 20 (2.7%): +Psychic Scream; -Mental Agility
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAYBmZWGzMmZMMDzsMzYGAAAAzYWmBzMzwMmZAMTNAmZBDhxsMAjBWMzMLAMjxYMYGgZmZgB`
- 19 (2.5%): +Move with Grace; -Mental Agility
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAYBmZWGzMmZMMDzsMzYGAAAAzYWmBzMzwMjZAMTNAmZBDhxsMAjBWMzMLAMjxYMYGgZmZgB`

**Split talents:** Divine Feathers (choice) 86%; Holy Fire 84%; Prophet's Will (choice) 84%; Seraphic Crescendo (choice) 79%; Painful Invocation 74%; Lightburst 67%; Mental Agility 66%; Move with Grace 45%; Psychic Scream 39%; Dispel Magic 34%; Gales of Song (choice) 21%; Desperate Measures (choice) 16%; Save the Day (choice) 14%; Angel's Mercy 14%

**Ours, against the whole sample:**

- `Raid`: the typical build. 55 of 746 run it exactly.

### Mythic+

663 rankings over 8 dungeons, logged 2026-09-01 to 2026-09-25, keys 18 to 21 (median 19). 365 distinct builds. Hero tree: Oracle 100%. 137 left out: their log has no talents.

**Typical** (Oracle, agreement 71% on 13 contested talents, 2 run it exactly):

`CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAYzMzYWGzMmZMMDsMzMzAAAAYYWmhZmZGmxMDgZKAmZBDhxsMAjBWMmZBgZMzYMYGgZmZgB`

**Most common other builds**, each against the typical:

- 22 (3.3%): +Desperate Measures, +Light of the Naaru 2/2, +Light's Inspiration, +Prismatic Echoes 1/2, +Unwavering Will 1/2; -Light in the Darkness 2/2, -Prophet's Will, -Trail of Light, -Unwavering Will 2/2
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAgZm5BmlxMjZGjZGYZmZmBAAAwwsMzYmZmh5BMzAYmCgZWwQYMbDwYgFDzCAzYmxYwMAzMzAD`
- 16 (2.4%): +Desperate Measures, +Light of the Naaru 2/2, +Light's Inspiration, +Prismatic Echoes 2/2, +Unwavering Will 1/2; -Desperate Times 2/2, -Epiphany, -Prophet's Will, -Trail of Light, -Unwavering Will 2/2
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAghZmlxMjZGjZGYZmZmBAAAwwsMzYmZmh5BMzAYmCgZWwQYMbDwYgFjZWAYGzMGDmBYmZGYA`
- 12 (1.8%): +Desperate Measures, +Divine Image, +Lasting Words, +Petrifying Scream, +Phantasm; -Angel's Mercy, -Body and Soul, -Eternal Sanctity, -Prophet's Will, -Trail of Light
  `CEQAAAAAAAAAAAAAAAAAAAAAAwYAAAAAAAMzMmlxMjZGDzALzMzMAAAAGzsMDmZmx2MmZAMTBwMLYIMmtBYMwiZmBAzYmxYwMAzMDYA`
- 11 (1.7%): +Divine Image; -Trail of Light
  `CEQAAAAAAAAAAAAAAAAAAAAAAwYAAAAAAAMzMmlxMjZGDzALzMzMAAAAGmlZYmZmhZMzAYmCgZWwQYMLDwYgFjZWAYGzMGDmBYmZGYA`

**Split talents:** Inspiration 90%; Psychic Scream 89%; Light in the Darkness 86%; Unwavering Will 86%; Eternal Sanctity (choice) 82%; Restitution (choice) 78%; Desperate Times 77%; Body and Soul 73%; Angel's Mercy 68%; Epiphany 64%; Prismatic Echoes 52%; Desperate Measures (choice) 51%; Prophet's Will (choice) 49%; Phantasm 46%; Light's Inspiration 43%; Light of the Naaru 34%; Dominate Mind (choice) 31%; Trail of Light (choice) 26%; Lasting Words 22%; Guardian Angel (choice) 22%; Healing Focus 19%; Divine Image 18%; Petrifying Scream (choice) 12%; Lightburst 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 2 of 663 run it exactly.

## Shadow Priest

### Raid

786 rankings over 10 bosses, logged 2026-08-30 to 2026-09-25. 271 distinct builds. Hero tree: Archon 91%, Voidweaver 9%.

**Typical** (Archon, agreement 77% on 13 contested talents, 100 run it exactly):

`CIQAAAAAAAAAAAAAAAAAAAAAAMMDDAAAAAAAAAAAAmZxMmZbmxMz2MGzw2MzYmZGbIzYxMNAzAMzmZY2MAkxYBAzMgxMzMmNmZbZAmBDA`

**Most common other builds**, each against the typical:

- 34 (4.3%): +Idol of C'Thun, +Instilled Doubt 2/2, +Spectral Horrors; -Crushing Void, -Descending Darkness, -Mastermind 2/2
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMDzAAAAAAAAAAAAMMLmxYbmxMz2MYG2mZGzMzYDZGLmpBYGgZ2MDzmBgMGLAYmxgxMzMmNmZbZAmBDA`
- 31 (3.9%): +Misery; -Invoked Nightmare
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMDDAAAAAAAAAAAAmZxMmZbmxMzyMGzw2MzYmZGbIzYxMNAzAMzmZY2MAkxYBAzMgxMzMmNmZbZAmBDA`
- 29 (3.7%): +Angelic Bulwark, +Collapsing Void, +Dark Energy, +Dark Thoughts, +Darkening Horizon, +Devour Matter, +Inner Quietus, +Instilled Doubt 2/2, +Move with Grace, +Overwhelming Shadows, +Quickened Pulse, +Shadowy Insight, +Spectral Horrors, +Touch of the Void, +Void Blast, +Void Infusion, +Void Leech, +Voidheart, +Voidweaver, +Voidwraith; -Archon, -Dark Evangelism, -Divine Halo, -Empowered Surges, -Energy Conservation, -Energy Cycle, -Focused Outburst, -Incessant Screams, -Maddening Touch, -Manifested Power, -Mental Decay, -Perfected Form, -Power Surge, -Protective Light, -Psychic Link, -Purify Disease, -Resonant Energy, -Shattered Psyche, -Spiritwell, -Sustained Potency, -Word of Supremacy
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMDzAAAAAAAAAAAAwMLmxMbzMDz2MzYGzmZGzMzYjJDLmpBYmZGAIAz2stAmNGAYwYmZGzGzgZGMDGA`
- 20 (2.5%): +Everlasting Light, +Idol of C'Thun, +Improved Flash Heal, +Inspiration, +Instilled Doubt 2/2, +Spectral Horrors, +Surge of Light; -Crushing Void, -Descending Darkness, -Mass Dispel, -Mastermind 2/2, -Petrifying Scream, -Psychic Voice, -Purify Disease
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMDzAAAAAAAAAAAAMMLmxYbmxMz2MYG2mZGzMzwQzAz0MDMDwMbmhZzAQGjFAMzYwYmZGzGzstMAGMA`

**Split talents:** Sustained Potency (choice) 90%; Psychic Link 88%; Mass Dispel 87%; Incessant Screams (choice) 87%; Shattered Psyche 86%; Descending Darkness 82%; Invoked Nightmare (choice) 81%; Crushing Void 81%; Mastermind 74%; Protective Light 73%; Petrifying Scream (choice) 69%; Psychic Voice (choice) 52%; Purify Disease 51%; Move with Grace 41%; Improved Flash Heal 39%; Spectral Horrors 35%; Instilled Doubt 35%; Angelic Bulwark 26%; Surge of Light 25%; Idol of C'Thun 25%; Misery (choice) 19%; Inspiration 15%; Everlasting Light 14%; Phantasm 12%

**Ours, against the whole sample:**

- `Raid`: the typical build. 100 of 786 run it exactly.

### Mythic+

630 rankings over 8 dungeons, logged 2026-08-29 to 2026-09-25, keys 18 to 21 (median 18). 294 distinct builds. Hero tree: Voidweaver 63%, Archon 37%. 170 left out: their log has no talents.

**Typical** (Voidweaver, agreement 62% on 28 contested talents, 2 run it exactly):

`CIQAAAAAAAAAAAAAAAAAAAAAAMjZMAAAAAAAAAAAAYMLzMGbzMmZ2mZGDz2MzYmZGbID2mpxAzMzAABY2mtNwsxAADGzMzY2GzgZGMDGA`

**Most common other builds**, each against the typical:

- 19 (3.0%): +Psychic Voice; -Improved Flash Heal
  `CIQAAAAAAAAAAAAAAAAAAAAAAMjZMAAAAAAAAAAAAYMLzMGbzMmZ2mZGDz2MzYmZGbIDLbz0AMzMDAEgZb22AzGDAMYMzMjZbMDmZwMYA`
- 12 (1.9%): +Crushing Void, +Idol of C'Thun, +Insidious Ire 1/2, +Shackle Horror; -Idol of Y'Shaarj, -Inescapable Torment, -Mindbender, -Tithe Evasion
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMj5BAAAAAAAAAAAAMMLmxMbzMmZ2mZGDz2MzYmZmZDZwmpxAzMzAABY2mtNwsxAADGzMzY2GzgZGMDGA`
- 11 (1.7%): +False Autonomy, +Purify Disease; -Improved Flash Heal, -Petrifying Scream
  `CIQAAAAAAAAAAAAAAAAAAAAAAMjZMAAAAAAAAAAAAYMLzMGbzMmZ2mZGDz2MzYmZGQmhtZaAmZmBACwsNbbgZjBAGMzMzMmtxMYmBzgB`
- 11 (1.7%): +Move with Grace, +Purify Disease; -Dominate Mind, -Petrifying Scream
  `CIQAAAAAAAAAAAAAAAAAAAAAAMjZMAAAAAAAAAAAAYMLzMGbzMmZ2mZGDz2MzYmZGYyMYmGDMzMDAEgZb22AzGDAMYMzMjZbMDmZwMYA`

**Split talents:** Light's Inspiration 86%; Instilled Doubt 78%; Petrifying Scream (choice) 69%; Shadowy Insight 67%; Tithe Evasion 67%; Subservient Shadows 64%; Shadowfiend 64%; Dominate Mind (choice) 63%; Voidwraith 63%; Voidheart 63%; Void Infusion 63%; Void Blast 63%; Touch of the Void 63%; Quickened Pulse 63%; Overwhelming Shadows 63%; Inner Quietus 63%; Devour Matter 63%; Darkening Horizon (choice) 63%; Collapsing Void 63%; Dark Energy (choice) 63%; Invoked Nightmare (choice) 63%; Embrace the Shadow (choice) 55%; Crushing Void 51%; Insidious Ire 50%; Mindbender 49%; Inescapable Torment 49%; Idol of Y'Shaarj 49%; Improved Flash Heal 48%; Angelic Bulwark 48%; Psychic Voice (choice) 47%; Phantasm 40%; Purify Disease 40%; Misery (choice) 37%; Word of Supremacy (choice) 37%; Spiritwell (choice) 37%; Resonant Energy 37%; Power Surge 37%; Perfected Form 37%; Manifested Power 37%; Focused Outburst 37%; Energy Cycle 37%; Energy Conservation 37%; Empowered Surges 37%; Divine Halo 37%; Sustained Potency (choice) 37%; Incessant Screams (choice) 36%; Mental Decay 33%; Phantom Reach 31%; Dark Evangelism 31%; Shattered Psyche 30%; Mastermind 26%; Idol of C'Thun 20%; Surge of Light 17%; False Autonomy 16%; Move with Grace 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 2 of 630 run it exactly.

## Assassination Rogue

### Raid

783 rankings over 10 bosses, logged 2026-08-25 to 2026-09-25. 345 distinct builds. Hero tree: Fatebound 88%, Deathstalker 12%.

**Typical** (Fatebound, agreement 82% on 26 contested talents, 52 run it exactly):

`CMQAAAAAAAAAAAAAAAAAAAAAAYmlxsYwAAAAAAzygtZAAAAAAZbmZmZmZMWmZmZbmlZmZGjZGjxMzYMAGYBmxoxsBYbAbGAMzMGD`

**Most common other builds**, each against the typical:

- 19 (2.4%): +Airborne Irritant, +Fatal Concoction 1/2, +Scent of Blood 2/2, +Thrown Precision; -Avulsion, -Fatal Concoction 2/2, -Regicide's Reward, -Toxic Stiletto
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAottZmZmZmxYZmZmtZWmZmHwMmZMGmZMGADsAzY0Y2AsNgNDAmZGMA`
- 17 (2.2%): +Thistle Tea; -Thistle Tea
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlxsYwAAAAAAzygtZAAAAAAZbmZmZmZM2mZmZbmlZmZGjZGjxMzYMAGYBmxoxsBYbAbGAMzMGD`
- 15 (1.9%): +Fatal Concoction 1/2, +Scent of Blood 2/2, +Thrown Precision; -Avulsion, -Fatal Concoction 2/2, -Regicide's Reward
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAIbzMzMzMjxyMzMbzsMzMPgZMzYMMzYMAGYBmxoxsBYbAbGAMzMGD`
- 14 (1.8%): +Scent of Blood 1/2; -Regicide's Reward
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlxsYwAAAAAAzygtZAAAAAAZbmZmZmZMWmZmZbmlZmZmHYMzYMMzYMAGYBmxoxsBYbAbGAMzMGD`

**Split talents:** Iron Stomach 89%; Sometimes Lucky 88%; Rush to the Inevitable 88%; Ravenholdt Mint 88%; Overflowing Purse (choice) 88%; Mean Streak 88%; Lucky Coin 88%; Fate Intertwined 88%; Edge Case 88%; Delivered Doom 88%; Deal Fate 88%; Controlled Chaos 88%; Caustic Spatter 87%; Featherfoot 87%; Crimson Tempest 87%; Tempted Fate (choice) 86%; Recuperator 85%; Poison Bomb 80%; Canny Strikes (choice) 80%; Thistle Tea (choice) 75%; Toxic Stiletto 74%; Death's Arrival (choice) 68%; Avulsion 66%; Regicide's Reward 56%; Scent of Blood 44%; Thrown Precision 42%; Airborne Irritant (choice) 41%; Thistle Tea (choice) 25%; Shadowrunner 22%; Doomblade 21%; Internal Bleeding (choice) 20%; Inexorable March (choice) 20%; Systemic Failure 16%; Improved Poisons 15%; Unshakeable Drive 12%; Singular Focus 12%; Shadewalker (choice) 12%; Quietus Celeris 12%; Precise Killer 12%; Momentum of Despair (choice) 12%; Mass Casualty 12%; Lingering Darkness (choice) 12%; Hunt Them Down 12%; Darkest Night 12%; Corrupt the Blood 12%; Clear the Witnesses 12%

**Ours, against the whole sample:**

- `Raid`: the typical build. 52 of 783 run it exactly.

### Mythic+

662 rankings over 8 dungeons, logged 2026-09-05 to 2026-09-25, keys 20 to 22 (median 20). 199 distinct builds. Hero tree: Fatebound 66%, Deathstalker 34%. 138 left out: their log has no talents.

**Typical** (Fatebound, agreement 68% on 20 contested talents, 45 run it exactly):

`CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAotlxMzMzMGbzMzsNzyMz8AmxMjxwMjxAYgFYGjGzCgtBsZAwMzYMA`

**Most common other builds**, each against the typical:

- 42 (6.3%): +Chosen's Revelry; -Tempted Fate
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAotlxMzMzMGbzMzsNzyMz8AmxMjxwMjxAYgFYGjGzCglBsZAwMzYMA`
- 39 (5.9%): +Death's Arrival; -Inexorable March
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAotlxMzMzMGbzMzsNzyMz8AmxMjxwMjxAYgFYGjGzGgtBsZAwMzYMA`
- 33 (5.0%): +Bait and Switch, +Clear the Witnesses, +Corrupt the Blood, +Darkest Night, +Deathstalker, +Hunt Them Down, +Lingering Darkness, +Mass Casualty, +Momentum of Despair, +Precise Killer, +Quietus Celeris, +Shadewalker, +Singular Focus, +Unshakeable Drive; -Controlled Chaos, -Deal Fate, -Delivered Doom, -Edge Case, -Fate Intertwined, -Fatebound, -Inexorable March, -Lucky Coin, -Mean Streak, -Overflowing Purse, -Ravenholdt Mint, -Rush to the Inevitable, -Sometimes Lucky, -Tempted Fate
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAotlxMzMzMGbzMzsNzyMz8AmxMjxwMjxAsZWGYALglhJwwiBzMAjxA`
- 21 (3.2%): +Avulsion, +Sudden Demise; -Zoldyck Recipe 2/2
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAotlxMzMzMGbzMzsNzyMz8AzMmZwMmZMGADsAzY0YWAsNgNDAmZGjB`

**Split talents:** Zoldyck Recipe 88%; Toxic Stiletto 84%; Recuperator 84%; Thistle Tea (choice) 77%; Featherfoot 73%; Sometimes Lucky 66%; Rush to the Inevitable 66%; Ravenholdt Mint 66%; Mean Streak 66%; Lucky Coin 66%; Fate Intertwined 66%; Edge Case 66%; Delivered Doom 66%; Deal Fate 66%; Controlled Chaos 66%; Overflowing Purse (choice) 66%; Tempted Fate (choice) 52%; Iron Stomach 41%; Inexorable March (choice) 36%; Unshakeable Drive 34%; Singular Focus 34%; Quietus Celeris 34%; Precise Killer 34%; Momentum of Despair (choice) 34%; Mass Casualty 34%; Lingering Darkness (choice) 34%; Hunt Them Down 34%; Darkest Night 34%; Corrupt the Blood 34%; Clear the Witnesses 34%; Bait and Switch (choice) 34%; Shadewalker (choice) 33%; Death's Arrival (choice) 31%; Thistle Tea (choice) 23%; Sudden Demise 22%; Avulsion 20%; Shadowrunner 16%; Chosen's Revelry (choice) 15%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 45 of 662 run it exactly.

## Outlaw Rogue

### Raid

598 rankings over 10 bosses, logged 2026-08-30 to 2026-09-25. 205 distinct builds. Hero tree: Trickster 100%.

**Typical** (Trickster, agreement 72% on 8 contested talents, 18 run it exactly):

`CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMzMzsNzMjZmxsAmZbaZw2MAAAAAAbbzMzwMzMziZmZbAAAAYMAYMLGGYgZhFahNGgZGMDG`

**Most common other builds**, each against the typical:

- 45 (7.5%): +Acrobatic Strikes, +Heavy Hitter 1/2, +Stillshroud; -Blade Rush, -Grand Melee, -Shadowrunner
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMmZmtZmZmZMmF4BmZbaZw2MAAAAAAbbzMzwMzMziZmZbAAAAYmBAjZxwADMLsQLsxAMzgBG`
- 32 (5.4%): +Acrobatic Strikes, +Gravedigger 1/4, +Summarily Dispatched 2/2; -Gravedigger 4/4
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMzMzsNzMzMzMmFGmZbaZw2MAAAAAAbbzMzwMzMziZmZbAAAAYMAYMLGGYgZhFahNGgZGMDeA`
- 30 (5.0%): +Acrobatic Strikes, +Heavy Hitter 1/2; -Blade Rush, -Grand Melee
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMmZmtZmZmZMmF4BmZbaZw2MAAAAAAbbzMzwMzMziZmZbAAAAYMAYMLGGYgZhFahNGgZGMDG`
- 28 (4.7%): +Stillshroud; -Shadowrunner
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMzMzsNzMjZmxsAmZbaZw2MAAAAAAbbzMzwMzMziZmZbAAAAYmBAjZxwADMLsQLsxAMzgBG`

**Split talents:** Sleight of Hand 90%; Cheat Death (choice) 89%; Airborne Irritant (choice) 86%; Combat Stamina (choice) 76%; Grand Melee 61%; Acrobatic Strikes 56%; Blade Rush 54%; Heavy Hitter 47%; Shadowrunner 39%; Unbreakable Stride 28%; Stillshroud 24%; Summarily Dispatched 18%; Deadly Pursuit 16%; Shiv 14%; Dancing Steel 13%; Elusiveness (choice) 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 18 of 598 run it exactly.

### Mythic+

716 rankings over 8 dungeons, logged 2026-08-29 to 2026-09-25, keys 18 to 22 (median 19). 141 distinct builds. Hero tree: Trickster 100%. 84 left out: their log has no talents.

**Typical** (Trickster, agreement 66% on 9 contested talents, 89 run it exactly):

`CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMzMzsNzMzMzMjFGPwMbTLD2mBAAAAAMbLzMzwMjZWMzMbDAAAAjBAjZxwADMLsQLsxAMzgBeA`

**Most common other builds**, each against the typical:

- 72 (10.1%): +Gravedigger 4/4, +Improved Between the Eyes, +Zero In; -Acrobatic Strikes, -Gravedigger 1/4, -Heavy Hitter 1/2, -Sleight of Hand, -Summarily Dispatched 2/2
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMjZmtZmZMzMzsAmZbaZw2MAAAAAgZbZmZGmZmZWMzMbDAAAAjBAjZxwADMLsQLsxAMzgBG`
- 43 (6.0%): +Shadowrunner; -Shiv
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMzMzsNzMzMzMjFGPwMbTLD2mBAAAAAYbZmZGmZMziZmZbAAAAYMAYMLGGYgZhFahNGgZGMDeA`
- 38 (5.3%): +Gravedigger 4/4, +Improved Between the Eyes, +Shadowrunner, +Zero In; -Acrobatic Strikes, -Gravedigger 1/4, -Heavy Hitter 1/2, -Shiv, -Sleight of Hand, -Summarily Dispatched 2/2
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMjZmtZmZMzMzsAmZbaZw2MAAAAAAbLzMzwMzMziZmZbAAAAYMAYMLGGYgZhFahNGgZGMDG`
- 32 (4.5%): +Gouge; -Airborne Irritant
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMzMzsNzMzMzMjFGPwMbTLD2mBAAAAAMLLzMzwMjZWMzMbDAAAAjBAjZxwADMLsQLsxAMzgBeA`

**Split talents:** Featherfoot 90%; Iron Stomach 84%; Airborne Irritant (choice) 74%; Sleight of Hand 66%; Acrobatic Strikes 65%; Shiv 59%; Summarily Dispatched 56%; Heavy Hitter 46%; Zero In 44%; Improved Between the Eyes 43%; Shadowrunner 36%; Gouge (choice) 24%; Stillshroud 17%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 89 of 716 run it exactly.

## Subtlety Rogue

### Raid

739 rankings over 10 bosses, logged 2026-08-28 to 2026-09-25. 62 distinct builds. Hero tree: Deathstalker 100%.

**Typical** (Deathstalker, agreement 71% on 2 contested talents, 287 run it exactly):

`CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbbjxMDDzMzMzw8AbzYGbbzMzMzMjBjZ2GAAAAGMmFzyADYBsMMBmFMDzMAzYA`

**Most common other builds**, each against the typical:

- 208 (28.1%): +Bait and Switch; -Ethereal Cloak
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbbjxMDDzMzMzw8AbzYGbbzMzMzMjBjZ2GAAAAGMmNzyADYBsMMBmFMDzMAzYA`
- 41 (5.5%): +Unbreakable Stride; -Airborne Irritant
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbbjxMDDzMzMzw8AbzYG2mZmZmZGDGzsNAAAAmBjZxsMwAWALDTgZBzwMDwMGA`
- 24 (3.2%): +Bait and Switch, +Unbreakable Stride; -Airborne Irritant, -Ethereal Cloak
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbbjxMDDzMzMzw8AbzYG2mZmZmZGDGzsNAAAAmBjZzsMwAWALDTgZBzwMDwMGA`
- 22 (3.0%): +Potent Powder; -Dark Shadow 1/2
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbbjxMDjZmZmZGGbzYGbbzMzMzMjBjZ2GAAAAGMmFzyADYBsMMBmFMDzMAzYA`

**Split talents:** Airborne Irritant (choice) 85%; Ethereal Cloak (choice) 56%; Bait and Switch (choice) 44%; Unbreakable Stride 14%

**Ours, against the whole sample:**

- `Raid`: the typical build. 287 of 739 run it exactly.

### Mythic+

671 rankings over 8 dungeons, logged 2026-08-27 to 2026-09-25, keys 18 to 21 (median 19). 134 distinct builds. Hero tree: Deathstalker 100%, Trickster 0%. 129 left out: their log has no talents.

**Typical** (Deathstalker, agreement 78% on 6 contested talents, 85 run it exactly):

`CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbbjxMDjZmZmZGGbzYGbLzMzMzMjBjZ2GAAAAGMmNzyADYBsMMBmFMDzMAzYA`

**Most common other builds**, each against the typical:

- 51 (7.6%): +Planned Execution; -Warning Signs
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbLjxMDjZmZmZGGbzYGbLzMzMzMjBjZ2GAAAAGMmNzyADYBsMMBmFMDzMAzYA`
- 49 (7.3%): +Shiv; -Iron Stomach
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbbjxMDjZmZmZGGbzYmZbZMzMzMjBjZ2GAAAAGMmNzyADYBsMMBmFMDzMAzYA`
- 35 (5.2%): +Ethereal Cloak; -Bait and Switch
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbbjxMDjZmZmZGGbzYGbLzMzMzMjBjZ2GAAAAGMmFzyADYBsMMBmFMDzMAzYA`
- 21 (3.1%): +Stillshroud; -Iron Stomach
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbbjxMDjZmZmZGGbzYGbLjZmZmZMYMz2AAAAwMMmNzyADYBsMMBmFMDzMAzYA`

**Split talents:** Shadowrunner 87%; Elusiveness (choice) 81%; Featherfoot 79%; Bait and Switch (choice) 76%; Warning Signs (choice) 76%; Iron Stomach 67%; Shiv 51%; Planned Execution (choice) 24%; Ethereal Cloak (choice) 23%; Cheat Death (choice) 19%; Toxic Stiletto 13%; Stillshroud 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 85 of 671 run it exactly.

## Elemental Shaman

### Raid

726 rankings over 10 bosses, logged 2026-08-30 to 2026-09-25. 508 distinct builds. Hero tree: Farseer 100%.

**Typical** (Farseer, agreement 66% on 16 contested talents, 2 run it exactly):

`CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhZAAAAgFzsBDYAzGTgZBAmtZmZM2WMtxMjxyMzMjhlZZmZZYMzsAAMAwMjhhB`

**Most common other builds**, each against the typical:

- 10 (1.4%): +Earthgrab Totem, +Elemental Unity, +Jet Stream, +Preeminence, +Refreshing Waters; -Cleanse Spirit, -First Ascendant, -Poison Cleansing Totem, -Purge, -Swelling Maelstrom
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhBAAAAsYmNYADY2YCMLAwsNzMjx2yMhZmNWmZmZMDzyMzyMGzMbAADAMzYYYA`
- 8 (1.1%): +Feedback Loop 3/4, +Flames of the Firelord, +Jet Stream, +Lava Flows, +Mana Spring, +Preeminence; -Feedback Loop 4/4, -First Ascendant, -Poison Cleansing Totem, -Swelling Maelstrom, -Totemic Focus
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhBAAAAsYmNYADY2YCMLAwsNzMzM2WMhZmtxyMzMjhFLzMLDjZmtBAMAwMjhZ8BA`
- 7 (1.0%): +Earthen Rage, +Earthquake, +Elemental Unity, +Everlasting Elements, +Flames of the Firelord, +Fusion of Elements, +Power of the Maelstrom; -Crackling Fury 2/2, -Earthquake, -Flames of the Cauldron, -Purging Flames, -Swelling Maelstrom, -Voltaic Blaze
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbLzMmZmZZbZMMjBAAAAsYmNYADY2YCMLAwsNzMjx2ipNmZMWmZmZMsMLzYxMDzsMAgBAmZMMMA`
- 7 (1.0%): +Ascending Air, +Earthen Rage, +Elemental Unity, +Everlasting Elements, +Flames of the Firelord, +Fusion of Elements, +Mana Spring, +Power of the Maelstrom, +Preeminence; -Crackling Fury 2/2, -First Ascendant, -Flames of the Cauldron, -Purging Flames, -Swelling Maelstrom, -Totemic Focus, -Voltaic Blaze, -Windveil
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMmZmZZbZMMjBAAAAsYmNYADY2YCMLAwsNzMzM2WMtxMzyYZmZmxwilhFzMMz2AAGAYmxwwA`

**Split talents:** Capacitor Totem 90%; Cleanse Spirit 73%; Purge (choice) 72%; Thunderous Paws (choice) 71%; Earthquake (choice) 70%; First Ascendant (choice) 70%; Windveil 63%; Flames of the Firelord 63%; Voltaic Blaze 59%; Purging Flames 59%; Crackling Fury 59%; Flames of the Cauldron 58%; Totemic Focus 56%; Poison Cleansing Totem (choice) 53%; Elemental Unity 48%; Power of the Maelstrom 41%; Fusion of Elements 41%; Earthen Rage 41%; Everlasting Elements 40%; Jet Stream (choice) 34%; Swelling Maelstrom 31%; Ascending Air (choice) 31%; Preeminence (choice) 30%; Earthquake (choice) 30%; Spirit Wolf (choice) 29%; Earthgrab Totem 29%; Refreshing Waters 28%; Lava Flows 22%; Frost Shock 22%; Totemic Surge 17%; Tremor Totem (choice) 11%; Healing Stream Totem 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 2 of 726 run it exactly.

### Mythic+

693 rankings over 8 dungeons, logged 2026-09-05 to 2026-09-25, keys 20 to 22 (median 21). 401 distinct builds. Hero tree: Farseer 100%. 107 left out: their log has no talents.

**Typical** (Farseer, agreement 70% on 11 contested talents, 16 run it exactly):

`CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhZAAAAgFzsBDYAzGTgZBAmtZmZM2WMtxMz2YZGzMGzysMzsMMmZWAAGAYmxwwA`

**Most common other builds**, each against the typical:

- 11 (1.6%): +Winds of Al'Akir 2/2; -Jet Stream, -Totemic Focus
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhZAAAAgFzsBDYAzGTgZBAmtZmZM2WMtxMjxyMzMjxsYZmZZYMzsAAMAwMjhhB`
- 11 (1.6%): +Spirit Wolf, +Static Charge 1/2; -Jet Stream, -Thunderous Paws
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhZAAAAgFzsBDYAzGTgZBAmlZmZM2WMtxMjxyMmZegxsMLzMLDjZmFAgBAmZMMMA`
- 11 (1.6%): +Totemic Surge; -Jet Stream
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhZAAAAgFzsBDYAzGTgZBAmtZmZM2WMtxMjxyMmZMmlZZmZZYMzsAAMDAmZMMMA`
- 10 (1.4%): +Winds of Al'Akir 2/2; -Hex, -Jet Stream
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhZAAAAgFzsBDYAzGTgZBAmtZmZM2WMtxMjxyMzMjhlZZmZZYMzsAAMAwMjhhB`

**Split talents:** Therazane's Resilience (choice) 85%; Chain Heal 82%; Earthquake (choice) 81%; Earth Shield 80%; Elemental Orbit 80%; Poison Cleansing Totem (choice) 77%; Gust of Wind (choice) 67%; Hex 64%; Thunderous Paws (choice) 55%; Totemic Focus 55%; Winds of Al'Akir 47%; Jet Stream (choice) 45%; Spirit Wolf (choice) 44%; Static Charge 36%; Spirit Walk (choice) 33%; Ancestral Wolf Affinity 24%; Totemic Surge 19%; Earthquake (choice) 19%; Earthgrab Totem 15%; Tremor Totem (choice) 14%; Healing Stream Totem 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 16 of 693 run it exactly.

## Enhancement Shaman

### Raid

666 rankings over 10 bosses, logged 2026-08-28 to 2026-09-25. 309 distinct builds. Hero tree: Stormbringer 100%.

**Typical** (Stormbringer, agreement 69% on 10 contested talents, 12 run it exactly):

`CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZZGzYssMjNmZ2YZmZmhhxMAAzwYmxMTgZGMYMA`

**Most common other builds**, each against the typical:

- 33 (5.0%): +Cleanse Spirit, +Purge, +Static Charge 2/2; -Earthgrab Totem, -Refreshing Waters, -Totemic Focus, -Totemic Projection
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZZGzYssYsxMz2YZmZmZwCzAAMDjZGmJwMDGMGA`
- 30 (4.5%): +Mana Spring; -Poison Cleansing Totem
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZZGzMjllZgZmNWmZmZYYMDAwMMmZMzEYmBDGDA`
- 15 (2.3%): +Cleanse Spirit, +Purge, +Thunderous Paws; -Spirit Wolf, -Totemic Projection, -Totemic Surge
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZbGzYssMjNmZ2GLzMzMMWGzAAMDjZGGBmZwgxA`
- 10 (1.5%): +Cleanse Spirit, +Purge, +Static Charge 2/2, +Thunderous Paws; -Earthgrab Totem, -Refreshing Waters, -Spirit Wolf, -Totemic Projection, -Totemic Surge
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZbGzYssYsxMz2YZmZmZwyYGAgZYMzwIwMDGMGA`

**Split talents:** Jet Stream (choice) 85%; Spirit Walk (choice) 81%; Totemic Focus 80%; Supercharge (choice) 74%; Poison Cleansing Totem (choice) 72%; Earthgrab Totem 70%; Refreshing Waters 66%; Totemic Surge 64%; Spirit Wolf (choice) 57%; Cleanse Spirit 49%; Thunderous Paws (choice) 43%; Totemic Projection 41%; Purge (choice) 40%; Static Charge 40%; Mana Spring 37%; Storm Swell (choice) 26%; Gust of Wind (choice) 19%; Tremor Totem (choice) 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 12 of 666 run it exactly.

### Mythic+

658 rankings over 8 dungeons, logged 2026-09-02 to 2026-09-25, keys 18 to 22 (median 18). 267 distinct builds. Hero tree: Stormbringer 100%. 142 left out: their log has no talents.

**Typical** (Stormbringer, agreement 70% on 7 contested talents, 81 run it exactly):

`CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZbGzYssMjNmZ2GLzMzMMWGzAAMDjZGGBmZwgxA`

**Most common other builds**, each against the typical:

- 25 (3.8%): +Static Charge 2/2, +Totemic Surge; -Earthgrab Totem, -Refreshing Waters, -Totemic Focus
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZbGzYssYsxMz2YZmZmZwCzAAMDjZGmJwMDGMGA`
- 20 (3.0%): +Spirit Wolf, +Static Charge 2/2, +Totemic Surge; -Earthgrab Totem, -Refreshing Waters, -Thunderous Paws, -Totemic Focus
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZZGzYssYsxMz2YZmZmZwCzAAMDjZGmJwMDGMGA`
- 19 (2.9%): +Spirit Wolf; -Thunderous Paws
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZZGzYssMjNmZ2GLzMzMMWGzAAMDjZGGBmZwgxA`
- 16 (2.4%): +Static Charge 1/2; -Totemic Focus
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZbGzYssMjNmZ2GLzMzMPgxCzAAMDjZGGBmZwgxA`

**Split talents:** Jet Stream (choice) 84%; Poison Cleansing Totem (choice) 79%; Purge (choice) 77%; Earthgrab Totem 67%; Refreshing Waters 63%; Thunderous Paws (choice) 62%; Totemic Focus 58%; Static Charge 56%; Spirit Wolf (choice) 38%; Totemic Surge 29%; Hex 18%; Totemic Projection 14%; Tremor Totem (choice) 11%; Ancestral Wolf Affinity 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 81 of 658 run it exactly.

## Restoration Shaman

### Raid

793 rankings over 10 bosses, logged 2026-08-27 to 2026-09-25. 461 distinct builds. Hero tree: Totemic 99%, Farseer 1%.

**Typical** (Totemic, agreement 72% on 10 contested talents, 11 run it exactly):

`CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsssNjZGjZGzMYsAbwMW0YbAMDsZGmBbjZmpZbZmZzMmFWMzMjBzyAAAAzMDmZAgBzA`

**Most common other builds**, each against the typical:

- 58 (7.3%): +Earthgrab Totem, +Improved Purify Spirit, +Winds of Al'Akir 1/2; -Earth Elemental, -Winds of Al'Akir 2/2
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsssNjZGjZGzMDjFYDmxiGbDgZgNzwMYbMmpZbZmZzMmFWMPwMjZYWGAAAYmZwMDAMYG`
- 24 (3.0%): +Primordial Bond; -Wind Shear
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsssNjZGjZGzMYsAbwMW0YbAMDsZGmBbjZmpZbZmZzMmFWmZMjBzyAAAAzMDmZAgBzA`
- 19 (2.4%): +Capacitor Totem, +Improved Purify Spirit, +Winds of Al'Akir 1/2; -Earth Elemental, -Winds of Al'Akir 2/2
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsssNjZGjZGzMDjFYDmxiGbDgZgNzwMMbjxMNbLzMbmxswi5BmZMYWGAAAYmZwMDAMYG`
- 15 (1.9%): +Primordial Bond, +Winds of Al'Akir 1/2; -Winds of Al'Akir 2/2
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsssNjZGjZGzMYsAbwMW0YbAMDsZGmBbjZmpZbZmZzMmFWm5BmZMYWGAAAYmZwMDAMYG`

**Split talents:** Amplification Core (choice) 90%; Winds of Al'Akir 87%; Coalescing Water 87%; Overflowing Shores 87%; Torrent 82%; Thunderous Paws (choice) 76%; Wind Shear 73%; Poison Cleansing Totem (choice) 68%; Ascending Air (choice) 65%; Earth Elemental 49%; Primordial Bond 45%; Capacitor Totem 44%; Improved Purify Spirit 26%; Acid Rain 25%; Jet Stream (choice) 24%; Spirit Wolf (choice) 24%; Earthgrab Totem 23%; Chain Lightning 16%; Tremor Totem (choice) 14%; Fire and Ice 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 11 of 793 run it exactly.

### Mythic+

706 rankings over 8 dungeons, logged 2026-09-04 to 2026-09-25, keys 19 to 22 (median 20). 492 distinct builds. Hero tree: Totemic 99%, Farseer 1%. 94 left out: their log has no talents.

**Typical** (Totemic, agreement 65% on 10 contested talents, 5 run it exactly):

`CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsstMmZmZMzMjhhFYDmxiGbDgZgNMzgZbmxoZZZmZzMmNWMmZMsMLzAAwAYmBzMAMGMA`

**Most common other builds**, each against the typical:

- 15 (2.1%): +Improved Purify Spirit; -Purge
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsstMmZmZMzMjZMsAbwMW0YbAMDshZGMbzMGNLLzMbmxsxixMjBzyMAAMAmZwMDAjBD`
- 10 (1.4%): +Earthweaver, +Improved Purify Spirit; -Improved Earthliving Weapon, -Windveil
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsstMmZmZmZGjZMsAbwMW0YbAMDshZGMbzMGNLLzMbmxsxixMjhlZZAAwAYmBzMAMGMA`
- 10 (1.4%): +Earth Elemental, +Earthweaver, +Improved Purify Spirit, +Primordial Bond; -Improved Earthliving Weapon, -Jet Stream, -Purge, -Wind Rush Totem
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsstMmZmZmZGjZMsAbwMW0YbAMDshZGMbzMzoZZZmZzMGsMjZGDmFDAADgZGMzAwYwA`
- 9 (1.3%): +Improved Purify Spirit; -Windveil
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsstMmZmZMzMjZMsAbwMW0YbAMDshZGMbzMGNLLzMbmxsxixMjhlZZAAwAYmBzMAMGMA`

**Split talents:** Supportive Imbuements (choice) 90%; Wind Rush Totem 88%; Thunderous Paws (choice) 76%; Poison Cleansing Totem (choice) 74%; Earthen Accord 63%; Spirit Walk (choice) 60%; Purge (choice) 55%; Jet Stream (choice) 52%; Windveil 50%; Improved Purify Spirit 48%; Earth Elemental 44%; Primordial Bond 43%; Improved Earthliving Weapon 42%; Gust of Wind (choice) 38%; Soothing Rain 31%; Spirit Wolf (choice) 24%; Tidewaters 23%; Current Control 23%; Earthweaver 21%; Hex 14%; Mana Spring 12%; Tremor Totem (choice) 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 5 of 706 run it exactly.

## Affliction Warlock

### Raid

712 rankings over 10 bosses, logged 2026-08-28 to 2026-09-25. 351 distinct builds. Hero tree: Hellcaller 73%, Soul Harvester 27%.

**Typical** (Hellcaller, agreement 75% on 30 contested talents, 16 run it exactly):

`CkQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMMzMzsMAAAzMLzyMzsMGAwCMwsY0YGAzCYZAAAYGAAYmBzMjZGmZYmxMzYwMzMAAzAD`

**Most common other builds**, each against the typical:

- 65 (9.1%): +Blight of Tongues; -Curse of Tongues
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMMzMzsMAAAzMLzyMzsMGAwCMwsY0YGAzCYZAAAYGAAYmBzMjxsZmhZGzMjBzMzAAMDMA`
- 19 (2.7%): +Banish, +Bleakheart Tactics, +Empowered Drain Life, +Gorefiend's Avarice, +Horrify, +Sudden Onset; -Abyss Walker, -Curse of Exhaustion, -Fel Synergy 2/2, -Hatefury Rituals, -Sacrolash's Dark Strike
  `CkQAAAAAAAAAAAAAAAAAAAAAAsZmxMjmNmxMzYWGAAgZmlZZmZWGDAYBGYWMaMDgZDsMAAAMDAAMzgZmxMMmhZGzMjBzMzMAgZgB`
- 19 (2.7%): +Cull the Weak, +Demoniac's Fervor, +Eternal Hunger, +Eternal Servitude, +Feast of Souls, +Friends In Dark Places, +Hedonic Gorging, +Manifested Avarice, +Necrolyte Teachings, +Nether Plating, +Potent Soul Shards, +Quietus, +Sataiel's Volition, +Seeds of Destruction 2/2, +Shadow of Death, +Shadowfury, +Shared Vessel, +Soul Anathema, +Soul Harvester, +Sow the Seeds, +Sudden Onset, +Wicked Reaping; -Abyss Walker, -Alzzin's Iniquity, -Blackened Soul, -Cascading Calamity, -Curse of the Satyr, -Devil Fruit, -Eye Contract, -Fatal Echoes, -Hatefury Rituals, -Hellcaller, -Malediction, -Malefic Grasp, -Malevolence, -Mark of Peroth'arn, -Mark of Xavius, -Sacrolash's Dark Strike, -Seeds of Their Demise, -Through the Felvine, -Xalan's Cruelty, -Xalan's Ferocity, -Xavius' Gambit 2/2, -Zevrim's Resilience
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbM2mZGzyAAAmZmlZxMzyYAgx2yADYAzwWghtBAAgZAAAMzMzMmZMGzYMzMzYYmZGAgBMA`
- 14 (2.0%): +Gorefiend's Avarice; -Curse of Tongues
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjhZmZmlBAAYmZZWmZmlxAAWgBmFjGzAYWALDAAAzAAAzMYmZMGmZYmxMzYwMzMAAzAD`

**Split talents:** Improved Mortal Coil 89%; Curse of Exhaustion 86%; Xavius' Gambit 86%; Cascading Calamity 85%; Strength of Will (choice) 85%; Frequent Donor (choice) 84%; Malediction 83%; Eye Contract 83%; Malefic Grasp 83%; Frequent Traveler 82%; Fatal Echoes 79%; Xalan's Ferocity 73%; Xalan's Cruelty 73%; Through the Felvine 73%; Seeds of Their Demise 73%; Mark of Xavius 73%; Mark of Peroth'arn 73%; Malevolence 73%; Devil Fruit 73%; Blackened Soul 73%; Alzzin's Iniquity 73%; Foul Mouth 71%; Curse of the Satyr (choice) 70%; Zevrim's Resilience (choice) 70%; Hatefury Rituals (choice) 64%; Sacrolash's Dark Strike 56%; Curse of Tongues 55%; Abyss Walker 55%; Gorefiend's Avarice 42%; Sudden Onset 33%; Empowered Drain Life 29%; Cull the Weak 29%; Blight of Tongues (choice) 28%; Banish 28%; Wicked Reaping 27%; Soul Anathema 27%; Shared Vessel 27%; Shadow of Death 27%; Sataiel's Volition 27%; Quietus 27%; Necrolyte Teachings 27%; Manifested Avarice 27%; Eternal Hunger 27%; Demoniac's Fervor 27%; Shadowfury (choice) 26%; Feast of Souls (choice) 25%; Friends In Dark Places (choice) 22%; Sow the Seeds 21%; Seeds of Destruction 21%; Potent Soul Shards 21%; Eternal Servitude (choice) 20%; Nether Plating 17%; Hedonic Gorging 17%; Ichor of Devils (choice) 15%; Dark Accord (choice) 15%; Fel Pact 14%; Oppressive Darkness 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 16 of 712 run it exactly.

### Mythic+

597 rankings over 8 dungeons, logged 2026-08-27 to 2026-09-25, keys 16 to 19 (median 17). 226 distinct builds. Hero tree: Soul Harvester 97%, Hellcaller 3%. 203 left out: their log has no talents.

**Typical** (Soul Harvester, agreement 65% on 15 contested talents, 2 run it exactly):

`CkQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzYWGAAwMzsMLmZ2GDAM2WGYADYG2CMsNAAAMDAAgZmxMmZ2GjZMmZmZMMzMDAwAG`

**Most common other builds**, each against the typical:

- 43 (7.2%): +Absolute Corruption, +Cascading Calamity, +Eye Contract, +Gorefiend's Resolve, +Malediction, +Malefic Grasp, +Xavius' Gambit 2/2; -Death's Embrace, -Eternal Servitude, -Hedonic Gorging, -Niskaran Methods, -Potent Soul Shards, -Ravenous Afflictions, -Siphon Life, -Sudden Onset
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzYWGAAwMmlZZmZWGDAM22GYADYG2CMsNAAAMAAAMzMmxMzGDzMzMzwMMzMDAwMwA`
- 40 (6.7%): +Gorefiend's Avarice; -Banish
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMjZGNbmx2MzYWGAAwMzsMLmZ2GDAM2WGYADYG2CMsNAAAMDAAgZmxMmZ2GjZMmZmZMMzMDAwAG`
- 26 (4.4%): +Dark Accord, +Empowered Drain Life, +Eye Contract, +Gorefiend's Avarice, +Gorefiend's Resolve; -Curse of Exhaustion, -Empowered Healthstone, -Eternal Servitude, -Potent Soul Shards, -Strength of Will
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMjZGNbmZ2mZGz2AAAmZmlZxMz2YAgx22ADYAzwWghtBAAgZAAAMzMmxM2GjZMmZmhhZmxAAmBG`
- 15 (2.5%): +Abyss Walker; -Curse of Exhaustion
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzMzyAAAmZmlZxMz2YAgx2yADYAzwWghtBAAgZAAAMzMmxM2GjZMmZmZMMzMDAwAG`

**Split talents:** Swift Artifice 90%; Fiendish Stride 87%; Strength of Will (choice) 83%; Blight of Tongues (choice) 78%; Oppressive Darkness 76%; Curse of Exhaustion 69%; Niskaran Methods 61%; Hedonic Gorging 58%; Sudden Onset 57%; Ravenous Afflictions 57%; Death's Embrace 57%; Eye Contract 55%; Siphon Life (choice) 54%; Eternal Servitude (choice) 51%; Banish 50%; Gorefiend's Resolve (choice) 46%; Absolute Corruption (choice) 46%; Malediction 45%; Xavius' Gambit 45%; Cascading Calamity 45%; Malefic Grasp 42%; Potent Soul Shards 42%; Fel Synergy 39%; Gorefiend's Avarice 38%; Abyss Walker 21%; Empowered Drain Life 19%; Dark Accord (choice) 17%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 2 of 597 run it exactly.

## Demonology Warlock

### Raid

717 rankings over 10 bosses, logged 2026-09-01 to 2026-09-25. 410 distinct builds. Hero tree: Diabolist 100%.

**Typical** (Diabolist, agreement 77% on 11 contested talents, 27 run it exactly):

`CoQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMMzMzsMAAAAAAAgxMGWgB2GWohFjZGLzyMzMmBAmZMzMmZAmZGzMAAAjZmZMMsMjBMA`

**Most common other builds**, each against the typical:

- 14 (2.0%): +Banish; -Curse of Exhaustion
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMjZmZmlBAAAAAAAMmxwCMw2wCNsYMzYZWmZmxMAwMjZmxMDwMzYGAAAjZmZMMsMjBMA`
- 12 (1.7%): +Banish, +Howl of Terror; -Abyss Walker, -Curse of Exhaustion
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMzyMzYWGAAAAAAAwYGDLwAbDL0wixMjlZZmZGzAAzMmZGzMAzMjZAAAMmZmxwwyMGwA`
- 11 (1.5%): +Empowered Drain Life, +Gorefiend's Avarice; -Curse of Tongues, -Foul Mouth
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjhZmZmlBAAAAAAAMmxwCMw2wCNsYMzYZWmZmxMAwMjZmxMDgZGjBAAYMzMzMMsMjBMA`
- 11 (1.5%): +Banish, +Gorefiend's Avarice; -Curse of Exhaustion, -Foul Mouth
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjZMzMzsMAAAAAAAgxMGWgB2GWohFjZGLzyMzMmBAmZMzMmZAMzYGAAAjZmZMMsMjBMA`

**Split talents:** Frequent Donor (choice) 90%; Frequent Traveler 85%; Improved Mortal Coil 84%; Practiced Rituals 84%; Mark of Shatug (choice) 83%; Curse of Tongues 81%; Strength of Will (choice) 76%; Foul Mouth 69%; Curse of Exhaustion 63%; Abyss Walker 56%; Banish 54%; Shadowfury (choice) 27%; Dark Accord (choice) 24%; Gorefiend's Avarice 22%; Howl of Terror (choice) 21%; Mark of F'harg (choice) 17%; Summon Felguard 17%; Oppressive Darkness 15%; Demonic Resilience 12%; Empowered Drain Life 12%; Fel Pact 11%; Blight of Tongues (choice) 10%; Ichor of Devils (choice) 10%

**Ours, against the whole sample:**

- `Raid`: the typical build. 27 of 717 run it exactly.

### Mythic+

653 rankings over 8 dungeons, logged 2026-09-02 to 2026-09-25, keys 19 to 22 (median 20). 224 distinct builds. Hero tree: Diabolist 100%. 147 left out: their log has no talents.

**Typical** (Diabolist, agreement 73% on 9 contested talents, 23 run it exactly):

`CoQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzMzyAAAAAAAAGzYYBGYbYhGWMmZsMbzMzYGAYmxMzYmBYMjZsBAAGzMzYYYZGDYA`

**Most common other builds**, each against the typical:

- 26 (4.0%): +Fel Synergy 2/2; -Abyss Walker, -Oppressive Darkness
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMz2MzYWGAAAAAAAwYGDLwAbDL0wixMjlZbmZGzAAzMmZGzMAjZMjNAAwYmZGDDLzYAD`
- 17 (2.6%): +Dark Accord; -Strength of Will
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzMz2AAAAAAAAGzYYBGYbYhGWMmZsMbzMzYGAYmxMzYmBYMjZsBAAGzMzYYYZGDYA`
- 16 (2.5%): +Fel Synergy 1/2; -Abyss Walker
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMegZGNbmZ2mZGzyAAAAAAAAGzYYBGYbYhGWMmZsMbzMzYGAYmxMzYmBYMjZsBAAGzMzYYYZGDYA`
- 14 (2.1%): +Dark Accord, +Frequent Traveler; -Abyss Walker, -Strength of Will
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzY2GAAAAAAAwYGDLwAbDL0wixMjlZbmZGzAAzMmZGzMAzMjZsBAAGzMzYYYZGDYA`

**Split talents:** Fiendish Stride 90%; Frequent Donor (choice) 90%; Improved Mortal Coil 79%; Banish 77%; Blight of Tongues (choice) 74%; Oppressive Darkness 72%; Mark of F'harg (choice) 67%; Strength of Will (choice) 59%; Fel Synergy 49%; Abyss Walker 45%; Dark Accord (choice) 41%; Mark of Shatug (choice) 33%; Curse of Exhaustion 27%; Blight of Weakness (choice) 17%; Gorefiend's Avarice 14%; Empowered Drain Life 12%; Ichor of Devils (choice) 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 23 of 653 run it exactly.

## Destruction Warlock

### Raid

593 rankings over 10 bosses, logged 2026-08-23 to 2026-09-25. 430 distinct builds. Hero tree: Hellcaller 98%, Diabolist 2%.

**Typical** (Hellcaller, agreement 69% on 11 contested talents, 2 run it exactly):

`CsQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjhZmZmlZZmZmZxY2WMDAAmxYmZWsADMLGNmBwshNGAAYMAbAAzMYmZMGAAAmZmBAgxwA`

**Most common other builds**, each against the typical:

- 13 (2.2%): +Backlash 1/2, +Blight of Tongues, +Cataclysm, +Empowered Drain Life, +Ichor of Devils; -Backlash 2/2, -Foul Mouth, -Frequent Donor, -Frequent Traveler
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZhhZmZmlZZmZmZxMz2iHYAAwMGzMziFYgZxoxMAmNsxAAAjBYDAYmBMjxsBAAYmZmBAwYYA`
- 10 (1.7%): +Backlash 1/2, +Blight of Tongues, +Chaotic Inferno; -Backlash 2/2, -Gorefiend's Avarice
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMMzMzsMLzMzMLGz2iHYAAwMzYmZWsADMLGNmBwshNGAAYMAbAAzMYmZMmNAAAzMzAAwYYA`
- 9 (1.5%): +Blight of Tongues; -Gorefiend's Avarice
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMMzMzsMLzMzMLGz2iZAAwMGzMziFYgZxoxMAmNsxAAAjBYDAYmBzMjxsBAAYmZGAAGDD`
- 9 (1.5%): +Banish, +Cataclysm, +Empowered Drain Life, +Ichor of Devils, +Lake of Fire, +Shadowfury; -Abyss Walker, -Backlash 2/2, -Fiendish Stride, -Frequent Donor, -Frequent Traveler
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZhZ2MzYWmlZmZmFzMbLMAAYGjZmZxCMwsY0YGAzG2YAAgxghNAgZGMmxYAAAYmZmBAwYYA`

**Split talents:** Improved Havoc 90%; Curse of Exhaustion 89%; Backlash 82%; Strength of Will (choice) 79%; Frequent Traveler 75%; Curse of the Satyr (choice) 75%; Frequent Donor (choice) 74%; Abyss Walker 73%; Foul Mouth 67%; Havoc (choice) 57%; Gorefiend's Avarice 42%; Chaotic Inferno 39%; Mayhem (choice) 34%; Shadowfury (choice) 31%; Curse of Tongues 31%; Banish 29%; Cataclysm 27%; Ichor of Devils (choice) 26%; Aura of Enfeeblement (choice) 23%; Empowered Drain Life 22%; Dark Accord (choice) 21%; Blight of Tongues (choice) 21%; Practiced Chaos 17%; Demonic Resilience 14%; Howl of Terror (choice) 12%; Lake of Fire 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 2 of 593 run it exactly.

### Mythic+

548 rankings over 8 dungeons, logged 2026-08-25 to 2026-09-25, keys 16 to 20 (median 17). 249 distinct builds. Hero tree: Diabolist 96%, Hellcaller 4%. 252 left out: their log has no talents.

**Typical** (Diabolist, agreement 73% on 12 contested talents, 20 run it exactly):

`CsQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzYWmNzMzsYmZZZMAAYGjZmZBMmxwCMw2wCNWYAAgxgBAYmBYMjZmNAAAzMzAAgZYA`

**Most common other builds**, each against the typical:

- 14 (2.6%): +Fel Synergy 2/2, +Ichor of Devils, +Teachings of the Black Harvest; -Banish, -Blight of Tongues, -Frequent Donor, -Improved Mortal Coil
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMmZGNLzM2mZGzysZmZmFzMLLjBAAzYMzMLgxMGWgB2GWoxCDAAMGMAAzMAjZYGAAAmZmBAAzwA`
- 13 (2.4%): +Fel Synergy 2/2, +Ichor of Devils; -Banish, -Blight of Tongues, -Frequent Donor
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMmZGNLmx2MzYWmNzMzsYmZZZMAAYGjZmZBMmxwCMw2wCNWYAAgxgBAYmBYMjZGAAAmZmBAAzwA`
- 11 (2.0%): +Alythess's Ire, +Devastation 1/2, +Fel Synergy 1/2; -Banish, -Devastation 2/2
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMegZGNbmx2MzYWmNzMzsYmZZZMAAYGjZmZBMmxwCMw2wCNWYAAgxMMAAzMAjZMzsBAAYmZGAA8ADD`
- 10 (1.8%): +Alythess's Ire, +Dark Accord, +Devastation 1/2, +Fel Synergy 1/2; -Curse of Exhaustion, -Devastation 2/2, -Strength of Will
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMegZGNbmZ2mZGz2sZmZmFzMLLjBAAzYMzMLgxMGWgB2GWoxCDAAMmhBAYmBYMjZsBAAYmZGAA8ADD`

**Split talents:** Curse of Tongues 90%; Swift Artifice 88%; Improved Mortal Coil 88%; Infernal Vitality (choice) 87%; Oppressive Darkness 82%; Frequent Donor (choice) 75%; Strength of Will (choice) 74%; Rain of Fire (choice) 73%; Devastation 72%; Blight of Tongues (choice) 70%; Curse of Exhaustion 65%; Fel Synergy 61%; Banish 46%; Alythess's Ire 34%; Rain of Fire (choice) 27%; Dark Accord (choice) 26%; Soul Fire (choice) 25%; Ichor of Devils (choice) 25%; Improved Havoc 21%; Gorefiend's Avarice 20%; Abyss Walker 20%; Frequent Traveler 11%; Avatar of Destruction 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 20 of 548 run it exactly.

## Arms Warrior

### Raid

817 rankings over 10 bosses, logged 2026-08-28 to 2026-09-25. 282 distinct builds. Hero tree: Slayer 100%.

**Typical** (Slayer, agreement 77% on 10 contested talents, 91 run it exactly):

`CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzYmZGAAAghphZGzMWmZmZGMmZAAAAAMzyMDMhxy2ALgBMDTgZwGYmhx2ALzsNAzMAYGGA`

**Most common other builds**, each against the typical:

- 44 (5.4%): +Shockwave; -Second Wind
  `CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzYmZGAAAghphxYmxyMzMzwMmZAAAAAMzyMDMhxy2ALgBMDTgZwGYmhx2ALzsNAzMAYGGA`
- 41 (5.0%): +Bloodborne 2/2, +Fierce Followthrough, +Just Warming Up; -Broad Strokes, -Dreadnaught, -Opportunist, -Powerful Momentum
  `CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzMmZGAAAghphZGzMWmZmZGMmZAAAAAMzyMDIMWWGYBMgZYCMD2AzMM2GYZmlBYmBAzwA`
- 22 (2.7%): +Collateral Damage, +Fervor of Battle; -Bloodsurge, -Fatality
  `CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphZGzMWmZmZGMmZAAAAAMWmZgJMW2GYBMgZYCMD2AzMM2GMLzsNAzMAYGGA`
- 20 (2.4%): +Fearless; -Piercing Howl
  `CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzYmZGAAAghphZGzMbLzMzMDGzMAAAAAmZZmBmwYZbgFwAmhJwMYDMzwwALzsNAzMAYGGA`

**Split talents:** Wrecking Throw (choice) 89%; Broad Strokes (choice) 87%; Powerful Momentum 86%; Fatality 86%; Storm Bolt 78%; Bloodsurge 74%; Dreadnaught 74%; Opportunist (choice) 68%; Piercing Howl (choice) 65%; Second Wind 63%; Shockwave 45%; Fearless (choice) 32%; Fierce Followthrough (choice) 32%; Fervor of Battle 26%; Bloodborne 25%; Collateral Damage 15%; Rumbling Earth 14%; Just Warming Up (choice) 13%; Interpose (choice) 10%

**Ours, against the whole sample:**

- `Raid`: the typical build. 91 of 817 run it exactly.

### Mythic+

679 rankings over 8 dungeons, logged 2026-09-06 to 2026-09-25, keys 20 to 22 (median 21). 97 distinct builds. Hero tree: Slayer 100%. 121 left out: their log has no talents.

**Typical** (Slayer, agreement 74% on 4 contested talents, 122 run it exactly):

`CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphZGmZbZmZmZYGzMAAAAAGLzMwEGLbDsAGwMMBmBbgZGGGMLzsNAzMAYGGA`

**Most common other builds**, each against the typical:

- 86 (12.7%): +Fast Footwork; -Wrecking Throw
  `CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphZGzMbmZmZGmxMDAAAAgxyMDMhxy2ALgBMDTgZwGYmhhBzyMbDwMDAmhBA`
- 51 (7.5%): +Rumbling Earth; -Wrecking Throw
  `CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphZGmZzMzMzYmxMDAAAAgxyMDMhxy2ALgBMDTgZwGYmhhBzyMbDwMDAmhBA`
- 40 (5.9%): +Fast Footwork; -Second Wind
  `CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphxYmZbZmZmZYGzMAAAAAGLzMwEGLbDsAGwMMBmBbgZGGGMLzsNAzMAYGGA`
- 27 (4.0%): +Rumbling Earth; -Field Dressing
  `CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphZGmZbZmZmZMzYmBAAAAwYZmBmwYZbgFwAmhJwMYDMzwwgZZmtBYmBAGGA`

**Split talents:** Fearless (choice) 88%; Field Dressing 84%; Second Wind 71%; Wrecking Throw (choice) 53%; Fast Footwork 45%; Rumbling Earth 32%; Intervene (choice) 16%; Berserker Shout (choice) 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 122 of 679 run it exactly.

## Fury Warrior

### Raid

605 rankings over 10 bosses, logged 2026-08-31 to 2026-09-25. 180 distinct builds. Hero tree: Slayer 98%, Mountain Thane 2%.

**Typical** (Slayer, agreement 73% on 8 contested talents, 23 run it exactly):

`CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDzMmZ2WmZmZmhxMzMzMjZWmxYmZmNzMzAAAxYZbgFwAmhJwMsBMzwAAAMzwYMMGMG`

**Most common other builds**, each against the typical:

- 52 (8.6%): +Cold Steel, Hot Blood, +Enraged Regeneration, +Piercing Howl; -Improved Whirlwind, -Rampaging Ruin, -Wrecking Throw
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDzMmZ2MzMzMDjZmZGzMzsMzMmZmZzYmBAAixy2ALgBMDTgZYDYmhxGAAMzwYMMGMG`
- 43 (7.1%): +Meat Cleaver; -Massacre
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDzMmZ2WmZmZmhxMzMzMjZWmxYmxsZmZGAAIGLbDsAGwMMBmhNgZGGAAgZGGzywYwYA`
- 26 (4.3%): +Interpose, +Meat Cleaver, +Piercing Howl; -Massacre, -Second Wind, -Wrecking Throw
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDjxMzmZmZmZYMzMzMzYmlZMmZMbmZmBAAixy2ALgBMDTgZYDYmZzYDAAmZYMLDjBjB`
- 25 (4.1%): +Enraged Regeneration, +Piercing Howl; -Fearless, -Massacre
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDzMmZsMzMzMDjZmZmZmZmlZMmZMbmZmBAAixy2ALgBMDTgZYDYmhxGAAMzwYMMGMG`

**Split talents:** Field Dressing 89%; Improved Whirlwind 84%; Storm Bolt 83%; Fearless (choice) 78%; Rampaging Ruin 77%; Second Wind 72%; Wrecking Throw (choice) 57%; Piercing Howl (choice) 56%; Massacre 44%; Meat Cleaver (choice) 39%; Enraged Regeneration 36%; Shockwave 30%; Cold Steel, Hot Blood 26%; Interpose (choice) 15%; Rumbling Earth 13%

**Ours, against the whole sample:**

- `Raid`: the typical build. 23 of 605 run it exactly.

### Mythic+

655 rankings over 8 dungeons, logged 2026-08-25 to 2026-09-25, keys 17 to 21 (median 18). 125 distinct builds. Hero tree: Slayer 93%, Mountain Thane 7%. 145 left out: their log has no talents.

**Typical** (Slayer, agreement 79% on 7 contested talents, 191 run it exactly):

`CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDjxMzmZmZmZmZMzMzMzMzDsMjxMjZzMzMAAQMW2GYBMgZYCMDbAzMMAAAzMMmlhxgxA`

**Most common other builds**, each against the typical:

- 39 (6.0%): +Second Wind; -Rumbling Earth
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDzMmZ2MzMzMjZMzMzMzMzDsMjxMjZzMzMAAQMW2GYBMgZYCMDbAzMMAAAzMMmlhxgxA`
- 38 (5.8%): +Wrecking Throw; -Fast Footwork
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDjhZ2WmZmZmZmxMzMzMzMPwyMGzMmNzMzAAAxYZbgFwAmhJwMsBMzwAAAMzwYWGGDGD`
- 25 (3.8%): +Wrecking Throw; -Rumbling Earth
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDjxMz2yMzMzMmxMzMzMzMPwyMGzMmNzMzAAAxYZbgFwAmhJwMsBMzwAAAMzwYWGGDGD`
- 23 (3.5%): +Second Wind; -Fast Footwork
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDzMMzmZmZmZmZMzMzMzMzDsMjxMjZzMzMAAQMW2GYBMgZYCMDbAzMMAAAzMMmlhxgxA`

**Split talents:** Stance Mastery 89%; Storm Bolt 88%; Field Dressing 83%; Enraged Regeneration 77%; Rumbling Earth 75%; Fast Footwork 73%; Wrecking Throw (choice) 40%; Second Wind 29%; Crushing Force 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 191 of 655 run it exactly.

## Protection Warrior

### Raid

638 rankings over 10 bosses, logged 2026-08-27 to 2026-09-25. 413 distinct builds. Hero tree: Mountain Thane 65%, Colossus 35%.

**Typical** (Mountain Thane, agreement 66% on 26 contested talents, 1 run it exactly):

`CkEAAAAAAAAAAAAAAAAAAAAAA0yAAAzMzYmZmZGzmxsMMGjGmZYZmZmZwYmBAAAALjBYGDwAbwyiRjZAMbYmNYGzMY2AgZGAAmBGD`

**Most common other builds**, each against the typical:

- 14 (2.2%): +Shield Specialization; -Armor Specialization
  `CkEAAAAAAAAAAAAAAAAAAAAAA0yAAAzMzYmZGzY2MzsMMGjGmZYZmZmZwYmBAAAALjBYGDwAbwyiRjZAMbYmNYGzMY2AgZGAAmBGD`
- 9 (1.4%): +Tough as Nails; -Armor Specialization
  `CkEAAAAAAAAAAAAAAAAAAAAAA0yAAAzMzYmZGzY2MmlZMGjGmZYZmZmZwYmBAAAALjBYGDwAbwyiRjZAMbYmNYGzMY2AgZGAAmBGD`
- 8 (1.3%): +Arterial Bleed, +Boneshaker, +Celeritous Conclusion, +Colossal Might, +Colossus, +Cut to the Bone, +Decimator, +Deep Wounds, +Dominance of the Colossus, +Martial Expert, +Massacre, +Mountain of Muscle and Scars, +No Stranger to Pain, +Practiced Strikes, +Precise Might, +Second Wind, +Sudden Death, +Tide of Battle; -Armor Specialization, -Avatar of the Storm, -Bloodborne, -Burst of Power, -Capacitance, -Conductivity, -Crashing Thunder, -Flashing Skies, -Ground Current, -Keep Your Feet on the Ground, -Mountain Thane, -Overwhelming Rage, -Storm Shield, -Storm Surge, -Strength of the Mountain, -Thorim's Might, -Thunder Blast, -Thunderlord
  `CkEAAAAAAAAAAAAAAAAAAAAAA02AAAzMzYmZGmZ2MmlhxY0MmZYZmZmZAzMAAAAYZMAzYAgFzYYDGYGWoxMLMmxMDmNAAzMAgZgxA`
- 7 (1.1%): +Barbaric Training, +Deep Wounds, +Massacre, +Snap Induction; -Armor Specialization, -Battle-Scarred Veteran, -Flashing Skies, -Stance Mastery
  `CkEAAAAAAAAAAAAAAAAAAAAAA0yAAAzMzYmZGzMzmxsMMGjGmZGLzMzMDGzMAAAAYZAYGDwAbw2iRjZAMbYmNGzwMY2AgZGAAmBGD`

**Split talents:** Wrecking Throw (choice) 90%; Javelineer 86%; Thunderlord 84%; Field Dressing 79%; Overwhelming Rage 78%; Fast Footwork 75%; Thunder Blast 65%; Strength of the Mountain 65%; Storm Surge 65%; Keep Your Feet on the Ground (choice) 65%; Ground Current 65%; Crashing Thunder 65%; Conductivity 65%; Capacitance 65%; Burst of Power 65%; Avatar of the Storm 65%; Thorim's Might (choice) 64%; Piercing Howl (choice) 64%; Stance Mastery 63%; Fight Through the Flames 61%; Bloodborne (choice) 58%; Battle-Scarred Veteran 54%; Flashing Skies (choice) 48%; Armor Specialization 46%; Storm Shield (choice) 44%; Deep Wounds 42%; Barbaric Training 39%; Shockwave 37%; Sudden Death (choice) 37%; Tough as Nails 35%; Tide of Battle 35%; Precise Might 35%; Practiced Strikes 35%; No Stranger to Pain (choice) 35%; Mountain of Muscle and Scars 35%; Martial Expert 35%; Dominance of the Colossus 35%; Decimator 35%; Cut to the Bone 35%; Colossal Might 35%; Celeritous Conclusion 35%; Fearless (choice) 35%; Arterial Bleed (choice) 34%; Massacre 31%; Intervene 29%; Shield Specialization 21%; Storm Bolts (choice) 21%; Heavy Handed 20%; Boneshaker (choice) 18%; Snap Induction (choice) 17%; Earthquaker (choice) 17%; Resonant Voice 15%; Bloodsurge 14%; Second Wind 13%

**Ours, against the whole sample:**

- `Raid`: the typical build. 1 of 638 run it exactly.

### Mythic+

640 rankings over 8 dungeons, logged 2026-08-28 to 2026-09-25, keys 18 to 21 (median 18). 273 distinct builds. Hero tree: Mountain Thane 95%, Colossus 5%. 159 left out: their log has no talents. 1 refused: unknown talents or not 34/34/13 points.

**Typical** (Mountain Thane, agreement 77% on 13 contested talents, 17 run it exactly):

`CkEAAAAAAAAAAAAAAAAAAAAAAkBAAGzwMzMzMmNzMLzYMGNmxwiZmZGzwMDAAAAWmZAmxAMwGssY0YGAzCmZDGzMDmNAYmBAgZgxA`

**Most common other builds**, each against the typical:

- 20 (3.1%): +Frothing Berserker, +Resonant Voice; -Bounding Stride, -Crushing Force
  `CkEAAAAAAAAAAAAAAAAAAAAAAkBAAGzwMzMzMmNzMLzYMGNmxwyMmZGzwMDAAAAWmZAmxAMwGssY0YGAzCmZDGzMDjNAYmBAgZgxA`
- 20 (3.1%): +Bloodsurge, +Fearless, +Resonant Voice; -Crushing Force, -Piercing Howl, -Tough as Nails
  `CkEAAAAAAAAAAAAAAAAAAAAAAkBAAGzYmZmZmxsZmZZYMGNmxYbxMzMjZYmBAAAALzMAzYAGYDWWMaMDgZBzsBjZmhBAYmBAgZgxA`
- 15 (2.3%): +Bloodsurge, +Resonant Voice; -Crushing Force, -Enduring Alacrity
  `CkEAAAAAAAAAAAAAAAAAAAAAAkBAAGzYmZmZmxsZmZZGjxoxMGWMzMzYGmZAAAAwyMDwMGgB2glFjGzAYWwMbAzMDjNAYmBAgZgxA`
- 13 (2.0%): +Bloodsurge; -Enduring Alacrity
  `CkEAAAAAAAAAAAAAAAAAAAAAAkBAAGzYmZmZmxsZmZZGjxoxMGWMzMzYGmZAAAAwyMDwMGgB2glFjGzAYWwMbAzMDmNAYmBAgZgxA`

**Split talents:** Rumbling Earth 90%; Storm Bolts (choice) 89%; Indomitable 89%; Into the Fray (choice) 88%; Javelineer 87%; Instigate 87%; Bounding Stride 82%; Flashing Skies (choice) 81%; Tough as Nails 78%; Armor Specialization 77%; Piercing Howl (choice) 54%; Enduring Alacrity 53%; Crushing Force 52%; Resonant Voice 51%; Bloodsurge 49%; Fight Through the Flames 36%; Frothing Berserker 33%; Intimidating Shout (choice) 28%; Bloodborne (choice) 19%; Fearless (choice) 19%; Focused Vigor 18%; Barbaric Training 16%; Last Stand 15%; Snap Induction (choice) 14%; Heavy Repercussions (choice) 12%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 17 of 640 run it exactly.

