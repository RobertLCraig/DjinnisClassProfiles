# What top Warcraft Logs players run

Written by `wcl-builds.py` on 2026-10-18 21:24 UTC, for every class. Card 0064. From `wcl-builds.json`, `update-builds.py` takes every spec's typical Mythic+ build as `Dungeon`, every typical raid build as `Raid` for a spec with no boss rows, and for each druid boss row the typical pooled over its bosses.

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

999 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 577 distinct builds. Hero tree: San'layn 80%, Deathbringer 20%. 1 left out: their log has no talents.

**Typical** (San'layn, agreement 76% on 22 contested talents, 12 run it exactly):

`CoPAAAAAAAAAAAAAAAAAAAAAAwYWGzMmxMjhZbmZmmZxMjxMGAAAAwMzMzMzMDzYMAYMzMzAAAYgBmxiGLbA2GwGgZMDAAYmBzwA`

**Most common other builds**, each against the typical:

- 20 (2.0%): +Grip of the Dead; -Enfeeble
  `CoPAAAAAAAAAAAAAAAAAAAAAAwYWGzMmxMzMMbzMz0MLmZMmxAAAAAmZmZmZmZYGjBAjZmZGAAADMwMW0YZDw2A2AMjZAAAzMwwA`
- 18 (1.8%): +Foul Bulwark, +Lifeblood, +Osmosis, +Umbilicus Eternus; -Bloodied Blade, -Enfeeble, -Relish in Blood, -Sanguinary Burst
  `CoPAAAAAAAAAAAAAAAAAAAAAAwMzyYmxMmZMMbzMz0MLmZMmxMAAAAwMmZmZmZYmZAAzMzMzAAAYgBmxiGLbA2GwGgZYAAAzMwwA`
- 12 (1.2%): +Foul Bulwark; -Relish in Blood
  `CoPAAAAAAAAAAAAAAAAAAAAAAwYWGzMmxMjhZbmZmmZxMjxMGAAAAwMzMzMzMDzYAAzMzMzAAAYgBmxiGLbA2GwGgZMDAAYmBzwA`
- 12 (1.2%): +Osmosis; -Enfeeble
  `CoPAAAAAAAAAAAAAAAAAAAAAAwYWGzMmxMjhZbmZmmZxMjxMmBAAAAmZmZmZmZYGjBAjZmZGAAADMwMW0YZDw2A2AMjZAAAzMwwA`

**Split talents:** Sanguinary Burst 86%; Blood Scent 81%; Visceral Strength 80%; Transfusion 80%; Thrill of Blood 80%; The Blood is Life 80%; Infliction of Sorrow 80%; Inevitable 80%; Incite Terror 80%; Gift of the San'layn 80%; Frenzied Bloodthirst 80%; Pact of the San'layn (choice) 79%; Relish in Blood 78%; Blood-Soaked Ground (choice) 77%; Assimilation 76%; Bloodied Blade 74%; Bloody Fortitude (choice) 73%; Vampiric Speed (choice) 73%; March of Darkness (choice) 73%; Death Notes 57%; Enfeeble 44%; Grip of the Dead 39%; Osmosis 31%; Blinding Sleet 31%; Foul Bulwark 29%; Wraith Walk (choice) 27%; Wither Away 20%; Wave of Souls 20%; Swift and Painful 20%; Soul Rupture 20%; Rune Carved Plates (choice) 20%; Grim Reaper 20%; Frigid Resolve 20%; Exterminate 20%; Echoing Fury 20%; Deathly Blows 20%; Bind in Darkness 20%; Death's Messenger (choice) 19%; Dark Talons (choice) 19%; Coldthirst 19%; Death Pact 16%; Subduing Grasp 14%; Lifeblood 14%; Bloodworms 13%; Umbilicus Eternus 11%

**Ours, against the whole sample:**

- `Raid`: 20 of 999 run it exactly. Typical has +Enfeeble; lacks Grip of the Dead.

### Mythic+

668 rankings over 8 dungeons, logged 2026-09-25 to 2026-10-18, keys 22 to 24 (median 22). 94 distinct builds. Hero tree: San'layn 100%, Deathbringer 0%. 132 left out: their log has no talents.

**Typical** (San'layn, agreement 75% on 3 contested talents, 179 run it exactly):

`CoPAAAAAAAAAAAAAAAAAAAAAAwMzyMzwMmZmhZbmZmmZZmZMzMAAAAAmhZmZmZMzYAAzMzMzAAAYgBmxiGLbA2GwGgZMAAAzMAGA`

**Most common other builds**, each against the typical:

- 89 (13.3%): +Assimilation; -Death Pact
  `CoPAAAAAAAAAAAAAAAAAAAAAAwMzyMzMmxMzMMbzMz0MLmZMzMAAAAAmhZmZmZMzYAAzMzMzAAAYgBmxiGLbA2GwGgZMAAAzMAGA`
- 68 (10.2%): +Suppression; -Death Pact
  `CoPAAAAAAAAAAAAAAAAAAAAAAwMzyMzwMmZmhZbmZmmZxMjZmxAAAAAmhZmZmZMzYAAzMzMzAAAYgBmxiGLbA2GwGgZMAAAzMAGA`
- 37 (5.5%): +Control Undead; -Death Pact
  `CoPAAAAAAAAAAAAAAAAAAAAAAwMzyMzwMmZmZMbzMz0MLmZMzMAAAAAmhZmZmZMzYAAzMzMzAAAYgBmxiGLbA2GwGgZMAAAzMAGA`
- 35 (5.2%): +Subduing Grasp; -Death Pact
  `CoPAAAAAAAAAAAAAAAAAAAAAAwMzyMzwMmZmhZbmZmmZxMzMzMAAAAAmhZmZmZMzYAAzMzMzAAAYgBmxiGLbA2GwGgZMAAAzMAGA`

**Split talents:** Permafrost 90%; Blood Scent 89%; Death Pact 45%; Suppression 25%; Assimilation 21%; Control Undead 13%

**Ours, against the whole sample:**

- `Dungeon`: 68 of 668 run it exactly. Typical has +Death Pact; lacks Suppression.

## Frost Death Knight

### Raid

951 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 297 distinct builds. Hero tree: Deathbringer 100%.

**Typical** (Deathbringer, agreement 69% on 8 contested talents, 25 run it exactly):

`CsPAAAAAAAAAAAAAAAAAAAAAAMAmZMjxYY2mZmZmZZmZkZMGDzMGMzMzMzMzMDAAAAAAAAAjZbgBsAWGmAjFMzYmZgBghZGAzgB`

**Most common other builds**, each against the typical:

- 40 (4.2%): +Enfeeble, +Runic Protection; -Blood Draw, -Unholy Endurance
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAmZMjZAz2MzMzMLzMjMjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAMzgB`
- 38 (4.0%): +Enfeeble; -Death Notes
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAmZMjxYY2mZmZmZZmZkZMGDzMGMzMzMzMzMDAAAAAAAAAjZbgBsAWGmAjFMzYmZgBghZGgxgB`
- 28 (2.9%): +Wraith Walk; -March of Darkness
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAmZMjxYY2mZmZmZbmZkZMGDzMGMzMzMzMzMDAAAAAAAAAjZbgBsAWGmAjFMzYmZgBghZGAzgB`
- 23 (2.4%): +Asphyxiate, +Blinding Sleet, +Runic Protection, +Wraith Walk; -Assimilation, -Death Notes, -Death's Reach, -March of Darkness
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAzMMjZGDzyMzMzMbzMjMjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAwgB`

**Split talents:** Death's Reach (choice) 89%; Death Pact 75%; Assimilation 73%; Unholy Endurance 72%; Death Notes 63%; Blood Draw 63%; March of Darkness (choice) 59%; Death Defiance 55%; Runic Protection 55%; Blinding Sleet 46%; Enfeeble 45%; Coldthirst 44%; Wraith Walk (choice) 40%; Asphyxiate (choice) 11%; Osmosis 10%

**Ours, against the whole sample:**

- `Raid`: 10 of 951 run it exactly. Typical has +Blood Draw; lacks Runic Protection.

### Mythic+

682 rankings over 8 dungeons, logged 2026-09-13 to 2026-10-18, keys 20 to 23 (median 21). 168 distinct builds. Hero tree: Deathbringer 100%. 118 left out: their log has no talents.

**Typical** (Deathbringer, agreement 70% on 7 contested talents, 22 run it exactly):

`CsPAAAAAAAAAAAAAAAAAAAAAAMAzMMjZYY2mZmZmZbmZ0MjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAwgB`

**Most common other builds**, each against the typical:

- 54 (7.9%): +Blood Draw; -Runic Protection
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAzMMjxYY2mZmZmZbmZ0MjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAwgB`
- 32 (4.7%): +Asphyxiate; -Death's Reach
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAzMMjZYYWmZmZmZbmZ0MjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAwgB`
- 29 (4.3%): +Asphyxiate, +Blood Draw; -Death's Reach, -Runic Protection
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAzMMjxYYWmZmZmZbmZ0MjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAwgB`
- 26 (3.8%): +Assimilation; -Unholy Endurance
  `CsPAAAAAAAAAAAAAAAAAAAAAAMAzMjZMDY2mZmZmZbmZ0MjxYYmxgZmZmZmZmZAAAAAAAAAYMbDMgFwywEYsgZGzMDMAMMzAwgB`

**Split talents:** Blood Scent 86%; Death Pact 77%; Wraith Walk (choice) 68%; Unholy Endurance 67%; Death's Reach (choice) 64%; Death Defiance 64%; Runic Protection 64%; Blood Draw 48%; Death Notes 35%; Asphyxiate (choice) 35%; Assimilation 34%; March of Darkness (choice) 30%; Grip of the Dead 11%; Enfeeble 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 22 of 682 run it exactly.

## Unholy Death Knight

### Raid

823 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 462 distinct builds. Hero tree: San'layn 100%, Rider of the Apocalypse 0%. 1 left out: their log has no talents.

**Typical** (San'layn, agreement 69% on 10 contested talents, 9 run it exactly):

`CwPAAAAAAAAAAAAAAAAAAAAAAAwMjZMGDz2MzMTzyMzYMjBAAAAAAAg5BGGDAWmhZ2MzYmZMwAzYRjlFAbD2AwMAmZmZGzgZGMmxA`

**Most common other builds**, each against the typical:

- 24 (2.9%): +Death Notes, +Desecrate, +Runic Protection; -Blood Draw, -Blood-Soaked Ground, -Unholy Endurance
  `CwPAAAAAAAAAAAAAAAAAAAAAAAwMjZMDY2mZmZaWmZGjZMAAAAAAAAMPwwYAwyMMzmZGzMjBGYGbassAYbwGAmBwMzMzYGMzgZmxA`
- 15 (1.8%): +Desecrate, +Wraith Walk; -Blood-Soaked Ground, -March of Darkness
  `CwPAAAAAAAAAAAAAAAAAAAAAAAwMjZMGDz2MzMTz2MzYMjBAAAAAAAg5BGGDAWmhZ2MzYmZMwAzYTjlFAbD2AwMAmZmZGzgZGMmxA`
- 14 (1.7%): +Desecrate; -Blood-Soaked Ground
  `CwPAAAAAAAAAAAAAAAAAAAAAAAwMjZMGDz2MzMTzyMzYMjBAAAAAAAg5BGGDAWmhZ2MzYmZMwAzYTjlFAbD2AwMAmZmZGzgZGMmxA`
- 12 (1.5%): +Coldthirst, +Desecrate, +Wraith Walk; -Assimilation, -Blood-Soaked Ground, -March of Darkness
  `CwPAAAAAAAAAAAAAAAAAAAAAAAwMMjxYY2mZmZa2mZGzMjBAAAAAAAg5BGGDAWmhZ2MzYmZMwAzYTjlFAbD2AwMAmZmZGzgZGMmxA`

**Split talents:** Unholy Devotion 89%; Enfeeble 86%; Insidious Chill 84%; Blood Draw 77%; Death Pact 73%; Assimilation 70%; Vampiric Aura (choice) 60%; Death Defiance 52%; Blood-Soaked Ground (choice) 51%; Death Notes 50%; March of Darkness (choice) 49%; Desecrate (choice) 49%; Runic Protection 44%; Wraith Walk (choice) 43%; Bloody Fortitude (choice) 40%; Blinding Sleet 30%; Coldthirst 27%; Osmosis 23%; Menacing Magus 15%; Grip of the Dead 13%

**Ours, against the whole sample:**

- `Raid`: no one in the sample runs it exactly. Typical has +Blood-Soaked Ground, +March of Darkness; lacks Death Notes, Desecrate.

### Mythic+

657 rankings over 8 dungeons, logged 2026-09-23 to 2026-10-18, keys 20 to 23 (median 21). 296 distinct builds. Hero tree: San'layn 100%, Rider of the Apocalypse 0%. 143 left out: their log has no talents.

**Typical** (San'layn, agreement 71% on 9 contested talents, 8 run it exactly):

`CwPAAAAAAAAAAAAAAAAAAAAAAAYmhZMGDz2MzMTz2MzYmZMAAAAAAAAMPwYYAwyMY2MzYmZMwAzYTjlFAbD2wAmBwMzMzYGMzghxA`

**Most common other builds**, each against the typical:

- 26 (4.0%): +Death Defiance; -Permafrost
  `CwPAAAAAAAAAAAAAAAAAAAAAAAYmhZMGDz2YmZa2mZGzMjBAAAAAAAg5BGDDAWmBzmZGzMjBGYGbassAYbwGGwMAmZmZGzgZGMmxA`
- 18 (2.7%): +Asphyxiate, +Death Defiance; -Death's Reach, -Permafrost
  `CwPAAAAAAAAAAAAAAAAAAAAAAAYmhZMGDzyYmZa2mZGzMjBAAAAAAAg5BGDDAWmBzmZGzMjBGYGbassAYbwGGwMAmZmZGzgZGMmxA`
- 14 (2.1%): +Asphyxiate, +Bloody Fortitude, +Grip of the Dead, +Runic Protection; -Blood Draw, -Death's Reach, -Unholy Endurance, -Vampiric Aura
  `CwPAAAAAAAAAAAAAAAAAAAAAAAYmhZMjBzyMzMTz2MzYmZMAAAAAAAAMPwYYAwyMY2MzYmZMwAzYTjlNAbD2wAmBwMzMzYGMzghxA`
- 12 (1.8%): +March of Darkness; -Wraith Walk
  `CwPAAAAAAAAAAAAAAAAAAAAAAAYmhZMGDz2MzMTzyMzYmZMAAAAAAAAMPwYYAwyMY2MzYmZMwAzYTjlFAbD2wAmBwMzMzYGMzghxA`

**Split talents:** Unholy Endurance 83%; Blood Scent 82%; Death Pact 78%; Permafrost 75%; Enfeeble 74%; Blood Draw 70%; Wraith Walk (choice) 60%; Death's Reach (choice) 57%; Vampiric Aura (choice) 57%; Death Defiance 51%; Bloody Fortitude (choice) 43%; Asphyxiate (choice) 43%; Runic Protection 40%; Grip of the Dead 39%; March of Darkness (choice) 27%; Assimilation 19%; Unholy Devotion 14%; Death Notes 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 8 of 657 run it exactly.

## Devourer Demon Hunter

### Raid

812 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 260 distinct builds. Hero tree: Annihilator 73%, Void-Scarred 27%. 3 refused: unknown talents or not 34/34/13 points.

**Typical** (Annihilator, agreement 72% on 26 contested talents, 88 run it exactly):

`CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzMzMGmBAAAAAAgxsNYGAAAAAAAAmxMMzMzMzMzMDzsYGjFZhZmZmt2mZmBwwAAwDMmhxMA`

**Most common other builds**, each against the typical:

- 105 (12.9%): +Erratic Felheart 1/2, +Master of the Glaive; -Demon Muzzle, -Sigil of Misery
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2MmZmZmZmBmBAAAAAAY5BGz2gZAAAAAAAAYGzwMzMzMzMzMMziZMWkFmZmZ2abmZGADDAAPwYGGzA`
- 57 (7.0%): +Master of the Glaive; -Felfire Haste
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzYmxwMAAAAAAALGz2gZAAAAAAAAYGzwMzMzMzMzMMziZMWkFmZmZ2abmZGADDAAPwYGGzA`
- 40 (4.9%): +Erratic Felheart 1/2, +Gift of the Void, +Master of the Glaive, +Scythe's Embrace, +Second Helping; -Demon Muzzle, -Eradicate, -Focused Ire, -Voidglare Boon, -Voidpurge
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2MmZmZmZmxwMAAAAAAALPwY2GMDAAAAAAAAzYwMzMzMmZmZMziZMW0yCzMzMbtNzMDgZMAA8AjBDD`
- 26 (3.2%): +Blind Focus, +Burn It Out, +Burning Blades, +Demonic Instinct 2/2, +Demonic Intensity, +Devourer's Bite, +Duty Eternal, +Enduring Torment, +Erratic Felheart 1/2, +Flamebound, +Focused Hatred, +Hungering Slash, +Improved Soul Rending, +Master of the Glaive, +Monster Rising, +Pursuit of Angriness, +Second Helping, +Singular Strikes, +The Hunt, +Undying Embers, +Untethered Fury, +Vengeful Bonds, +Violent Transformation, +Void-Scarred, +Voidrush, +Volatile Instinct; -Annihilator, -Catastrophe, -Celestial Echoes, -Dark Matter, -Demon Muzzle, -Demonic Instinct 1/2, -Eradicate, -Final Hour, -Focused Ire, -Harness the Cosmos, -Mass Acceleration, -Meteoric Fall, -Meteoric Rise, -Otherworldly Focus, -Phase Shift, -Rolling Torment, -Sigil of Misery, -Soul Cleanse, -State of Matter, -Sweet Suffering 2/2, -Swift Erasure, -Voidglare Boon, -Voidpurge, -Voidrage 2/2, -World Killer
  `CgcBAAAAAAAAAAAAAAAAAAAAAAAWMzMzMzMzMwMAAAAAAALPwY2GMDAAAAAAAAzYwYmZmxMzMMzyMjxm2WAAgBwYmZ2mZmmtZ2mZYMjB`

**Split talents:** Rolling Torment 85%; Eradicate 82%; Focused Ire 81%; Demonic Instinct 78%; Felfire Haste 77%; Voidrage 75%; Soul Cleanse (choice) 75%; Sweet Suffering 75%; World Killer 73%; Swift Erasure 73%; Phase Shift 73%; Otherworldly Focus 73%; Meteoric Rise 73%; Meteoric Fall 73%; Mass Acceleration 73%; Harness the Cosmos (choice) 73%; Final Hour 73%; Dark Matter 73%; Celestial Echoes 73%; Catastrophe 73%; State of Matter (choice) 73%; Sigil of Misery 66%; Voidpurge 64%; Voidglare Boon 64%; Demon Muzzle 53%; Erratic Felheart 46%; Master of the Glaive (choice) 39%; Second Helping 33%; Volatile Instinct 27%; Violent Transformation 27%; Untethered Fury 27%; Undying Embers 27%; Monster Rising 27%; Focused Hatred 27%; Enduring Torment 27%; Demonic Intensity 27%; Burning Blades 27%; Blind Focus 27%; Voidrush 27%; The Hunt 27%; Hungering Slash 27%; Devourer's Bite 27%; Pursuit of Angriness (choice) 26%; Singular Strikes 25%; Burn It Out (choice) 21%; Scythe's Embrace (choice) 20%; Duty Eternal (choice) 20%; Gift of the Void 17%; Flamebound (choice) 17%; Improved Soul Rending (choice) 14%; Charred Warblades 14%; Set Fire to the Pain (choice) 13%; Vengeful Bonds 10%; Student of Suffering (choice) 10%

**Ours, against the whole sample:**

- `Raid`: no one in the sample runs it exactly. Typical has +Annihilator, +Catastrophe, +Celestial Echoes, +Dark Matter, +Demonic Instinct 1/2, +Emptiness, +Final Hour, +Harness the Cosmos, +Mass Acceleration, +Meteoric Fall, +Meteoric Rise, +Midnight 4/4, +Otherworldly Focus, +Phase Shift, +State of Matter, +Sweet Suffering 2/2, +Swift Erasure, +Voidglare Boon, +Voidpurge, +World Killer; lacks Blind Focus, Burning Blades, Demonic Instinct 2/2, Demonic Intensity, Devourer's Bite, Duty Eternal, Enduring Torment, Flamebound, Focused Hatred, Hungering Slash, Monster Rising, Pursuit of Angriness, Second Helping, Set Fire to the Pain, Singular Strikes, Soul Glutton, The Hunt, Undying Embers, Untethered Fury, Violent Transformation, Void-Scarred, Voidrush, Volatile Instinct.

### Mythic+

714 rankings over 8 dungeons, logged 2026-09-16 to 2026-10-18, keys 20 to 23 (median 21). 143 distinct builds. Hero tree: Annihilator 86%, Void-Scarred 14%. 79 left out: their log has no talents. 7 refused: unknown talents or not 34/34/13 points.

**Typical** (Annihilator, agreement 80% on 23 contested talents, 52 run it exactly):

`CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzMzMGmBAAAAAAgxsNYGAAAAAAAAmxMMzMzMzMzMzYmFzYsolFmZmZ2abmZGADDAAGDGzA`

**Most common other builds**, each against the typical:

- 66 (9.2%): +Swallowed Anger; -Felfire Haste
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzYmxwMAAAAAAAMmthZGAAAAAAAAmxMMzMzMzMzMzYmFzYsolFmZmZ2abmZGADDAAGDGzA`
- 65 (9.1%): +Demonic Instinct 1/2, +Voidglare Boon; -Gift of the Void, -Scythe's Embrace
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzMzMGmBAAAAAAgxsNYGAAAAAAAAmxMMzMzMzMzMDzsYGjFZhZmZmt2mZmBwwAAwDMmhxMA`
- 64 (9.0%): +Demonic Instinct 1/2, +Master of the Glaive, +Voidglare Boon; -Felfire Haste, -Gift of the Void, -Scythe's Embrace
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzYmxwMAAAAAAALGz2gZAAAAAAAAYGzwMzMzMzMzMMziZMWkFmZmZ2abmZGADDAAPwYGGzA`
- 27 (3.8%): +Demonic Instinct 1/2, +Swallowed Anger, +Voidglare Boon; -Felfire Haste, -Gift of the Void, -Scythe's Embrace
  `CgcBAAAAAAAAAAAAAAAAAAAAAAA2mxMzMzYmxwMAAAAAAAMmthZGAAAAAAAAmxMMzMzMzMzMDzsYGjFZhZmZmt2mZmBwwAAwDMmhxMA`

**Split talents:** Focused Ire 89%; Rolling Torment 89%; Sweet Suffering 89%; Voidrage 88%; World Killer 86%; Swift Erasure 86%; State of Matter (choice) 86%; Phase Shift 86%; Otherworldly Focus 86%; Meteoric Rise 86%; Meteoric Fall 86%; Mass Acceleration 86%; Harness the Cosmos (choice) 86%; Final Hour 86%; Dark Matter 86%; Celestial Echoes 86%; Catastrophe 86%; Voidpurge 84%; Soul Cleanse (choice) 78%; Scythe's Embrace (choice) 47%; Gift of the Void 46%; Demonic Instinct 44%; Voidglare Boon 40%; Felfire Haste 36%; Swallowed Anger 27%; Infernal Armor 17%; Master of the Glaive (choice) 16%; Volatile Instinct 14%; Voidrush 14%; Violent Transformation 14%; Untethered Fury 14%; Undying Embers 14%; The Hunt 14%; Singular Strikes 14%; Monster Rising 14%; Hungering Slash 14%; Focused Hatred 14%; Enduring Torment 14%; Devourer's Bite 14%; Demonic Intensity 14%; Burning Blades 14%; Blind Focus 14%; Charred Warblades 13%; Burn It Out (choice) 13%; Set Fire to the Pain (choice) 12%; Pursuit of Angriness (choice) 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 52 of 714 run it exactly.

## Havoc Demon Hunter

### Raid

978 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 253 distinct builds. Hero tree: Aldrachi Reaver 81%, Fel-Scarred 19%. 1 left out: their log has no talents.

**Typical** (Aldrachi Reaver, agreement 78% on 27 contested talents, 74 run it exactly):

`CEkAAAAAAAAAAAAAAAAAAAAAAYgZmZ2MmZmxMzkxMDAAAAAAY2egxsNDzMz2MzYZmxMWmZYmlZ2mBDjlNmwYmxwCAAAAAAAYmBYAAAAYA`

**Most common other builds**, each against the typical:

- 179 (18.3%): +Master of the Glaive; -Champion of the Glaive
  `CEkAAAAAAAAAAAAAAAAAAAAAAYgZmZ2MmZmxMzkxMDAAAAAAYWegxsNDzMz2MzYZmxMWmZYmlZ2mBDjlNmwYmxwCAAAAAAAYmBYAAAAYA`
- 32 (3.3%): +Burn It Out, +Demon Muzzle, +Disrupting Fury; -Erratic Felheart 1/2, -Imprison, -Soul Cleanse
  `CEkAAAAAAAAAAAAAAAAAAAAAAYgZmZWmxMzMzMzkxMDAAAAAAY2MmtZYMz2MzYZmxMWmZYmlZ2mBDjlNmwYmxwCAAAAAAAYmBYAAAAYA`
- 24 (2.5%): +Aldrachi Design, +Disrupting Fury, +Live by the Glaive; -Consume Magic, -Imprison, -Sigil of Misery
  `CEkAAAAAAAAAAAAAAAAAAAAAAYgZmZ2MmZmZmZmwMDAAAAAAY2egZmtZgZ2mZGLzMmxyMDzsMz2MYYssxEGzMzwCAAAAAAAYmBYAAAAYA`
- 23 (2.4%): +Aldrachi Design, +Disrupting Fury, +Live by the Glaive, +Master of the Glaive; -Champion of the Glaive, -Felfire Haste, -Imprison, -Sigil of Misery
  `CEkAAAAAAAAAAAAAAAAAAAAAAYgZmZ2MmZmZGzEmZAAAAAAAzyDMzsNDjZ2mZGLzMmxyMDzsMz2MYYssxEGzMzwCAAAAAAAYmBYAAAAYA`

**Split talents:** Serrated Glaive 82%; Shattered Destiny (choice) 82%; Soul Cleanse (choice) 81%; Wounded Quarry 81%; Warblade's Hunger 81%; Unhindered Assault (choice) 81%; Thrill of the Fight 81%; Soulscar (choice) 81%; Screaming Brutality 81%; Reaver's Mark 81%; Keen Edge 81%; Incisive Blade 81%; Fury of the Aldrachi 81%; Furious Throws 81%; Broken Spirit 81%; Bladecraft 81%; Aldrachi Tactics 81%; Accelerated Blade 81%; Consume Magic 81%; Incorruptible Spirit (choice) 81%; Keen Engagement (choice) 76%; Felfire Haste 72%; Sigil of Misery 72%; Imprison 65%; Champion of the Glaive (choice) 55%; Erratic Felheart 50%; Demon Muzzle 48%; Disrupting Fury 46%; Master of the Glaive (choice) 45%; Aldrachi Design 30%; Live by the Glaive 22%; Trail of Ruin 20%; Volatile Instinct 19%; Violent Transformation 19%; Untethered Fury 19%; Undying Embers 19%; Monster Rising 19%; Focused Hatred 19%; Enduring Torment 19%; Demonic Intensity 19%; Burning Blades 19%; Blind Focus 19%; Student of Suffering (choice) 19%; Pursuit of Angriness (choice) 19%; Ragefire 18%; Growing Inferno 18%; Burning Wound 18%; A Fire Inside 18%; Set Fire to the Pain (choice) 16%; Burn It Out (choice) 13%; Blind Fury 11%; Isolated Prey 10%

**Ours, against the whole sample:**

- `Raid`: 9 of 978 run it exactly. Typical has +Accelerated Blade, +Aldrachi Reaver, +Aldrachi Tactics, +Bladecraft, +Broken Spirit, +Champion of the Glaive, +Furious Throws, +Fury of the Aldrachi, +Incisive Blade, +Incorruptible Spirit, +Keen Edge, +Keen Engagement, +Reaver's Mark, +Screaming Brutality, +Serrated Glaive, +Shattered Destiny, +Soulscar, +Thrill of the Fight, +Unhindered Assault, +Warblade's Hunger, +Wounded Quarry; lacks A Fire Inside, Blind Focus, Burning Blades, Burning Wound, Demonic Intensity, Enduring Torment, Fel-Scarred, Focused Hatred, Growing Inferno, Isolated Prey, Master of the Glaive, Monster Rising, Pursuit of Angriness, Ragefire, Set Fire to the Pain, Student of Suffering, Trail of Ruin, Undying Embers, Untethered Fury, Violent Transformation, Volatile Instinct.

### Mythic+

704 rankings over 8 dungeons, logged 2026-09-10 to 2026-10-18, keys 20 to 23 (median 21). 163 distinct builds. Hero tree: Aldrachi Reaver 92%, Fel-Scarred 8%. 96 left out: their log has no talents.

**Typical** (Aldrachi Reaver, agreement 73% on 8 contested talents, 25 run it exactly):

`CEkAAAAAAAAAAAAAAAAAAAAAAYGMzMz2MmZmZGzkxMDAAAAAAYWMmtZYmZ2mZGLzMmxyMDjlZ2mBDjtNmwYmxwCAAAAAAAYmBYAAAAYA`

**Most common other builds**, each against the typical:

- 80 (11.4%): +Focused Ire; -Felbound
  `CEkAAAAAAAAAAAAAAAAAAAAAAYGMzMz2MmZmZGzkxMDAAAAAAYWMmtBzMz2MzYZmxMWmZYsMz2MYYstxEGzMmxCAAAAAAAYmBYAAAAYA`
- 38 (5.4%): +Champion of the Glaive; -Master of the Glaive
  `CEkAAAAAAAAAAAAAAAAAAAAAAYGMzMz2MmZmZGzkxMDAAAAAAY2MmtZYmZ2mZGLzMmxyMDjlZ2mBDjtNmwYmxwCAAAAAAAYmBYAAAAYA`
- 38 (5.4%): +Focused Ire; -Disrupting Fury
  `CEkAAAAAAAAAAAAAAAAAAAAAAYGMzMz2MmZmxYmMmZAAAAAAAzixsNDzMz2MzYZmxMWmZYsMz2MYYstxEGzMmxCAAAAAAAYmBYAAAAYA`
- 30 (4.3%): +Burn It Out, +Champion of the Glaive, +Never Say Die; -Master of the Glaive, -Soul Cleanse, -Trail of Ruin
  `CEkAAAAAAAAAAAAAAAAAAAAAAYgZmZWmxMzMzYmMmZAAAAAAAzmxsNDzMz2MzYZmxMWmZYmlZ2mBDjtNmwYmxwCAAAAAAAYmBYAAAAYA`

**Split talents:** Preemptive Strike (choice) 87%; Incorruptible Spirit (choice) 86%; Shattered Destiny (choice) 79%; Soul Cleanse (choice) 78%; Trail of Ruin 73%; Disrupting Fury 71%; Felbound 64%; Master of the Glaive (choice) 52%; Focused Ire 49%; Champion of the Glaive (choice) 47%; Never Say Die 43%; Burn It Out (choice) 15%; Blind Fury 13%; Glaive Tempest 12%; Infernal Armor 11%

**Ours, against the whole sample:**

- `Dungeon`: 1 of 704 run it exactly. Typical has +Accelerated Blade, +Aldrachi Reaver, +Aldrachi Tactics, +Bladecraft, +Broken Spirit, +Dancing with Fate 2/2, +Furious Throws, +Fury of the Aldrachi, +Incisive Blade, +Incorruptible Spirit, +Keen Edge, +Preemptive Strike, +Reaver's Mark, +Screaming Brutality, +Serrated Glaive, +Shattered Destiny, +Soulscar, +Thrill of the Fight, +Unhindered Assault, +Warblade's Hunger, +Wounded Quarry; lacks A Fire Inside, Blind Focus, Blind Fury 2/2, Burning Blades, Burning Wound, Demonic Intensity, Enduring Torment, Fel-Scarred, Flamebound, Focused Hatred, Glaive Tempest, Growing Inferno, Monster Rising, Never Say Die, Ragefire, Set Fire to the Pain, Undying Embers, Untethered Fury, Violent Transformation, Volatile Instinct, Wave of Debilitation.

## Vengeance Demon Hunter

### Raid

693 rankings over 10 bosses, logged 2026-10-13 to 2026-10-18. 306 distinct builds. Hero tree: Annihilator 98%, Aldrachi Reaver 2%.

**Typical** (Annihilator, agreement 79% on 15 contested talents, 18 run it exactly):

`CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZMmZkZmBziZmZgZMzYGzMzYYmZmxmZmtxAAAAAAAAAmZGbAAAAYwMzMzMbtNzMDAMAAAAG`

**Most common other builds**, each against the typical:

- 26 (3.8%): +Chains of Anger, +Disrupting Fury; -Calcified Spikes, -Felbound
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZmxMjMzMYWMzMjBjZGzYmZGDzMzM2MzsNGAAAAAAAAwMzYDAAAADMzMzMbtNzMDAMAAAAG`
- 26 (3.8%): +Disrupting Fury; -Felbound
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZmxMjMzMYWMzMDMjZGzYmZGDzMzM2MzsNGAAAAAAAAwMzYDAAAADMzMzMbtNzMDAMAAAAG`
- 13 (1.9%): +Erratic Felheart 2/2, +Felfire Haste; -Chaos Nova, -Demon Muzzle, -Pitch Black
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAYMzMjZmZkZmBziZmZgZMzYGzMzYYmZmx2MzYMAAAAAAAAgZmxGAAAAGMmZmZ2abmZGAYAAAAMA`
- 10 (1.4%): +Erratic Felheart 1/2, +Felfire Haste; -Chaos Nova, -Demon Muzzle
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAYMzMjZmZkZmBziZmZgZMzYGzMzYYmZmx2DMzsNGAAAAAAAAwMzYDAAAADGzMzMbtNzMDAMAAAAG`

**Split talents:** Ascending Flame 89%; Fallout 88%; Demonic Resilience 88%; Fel Flame Fortification 87%; State of Matter (choice) 86%; Quickened Sigils 85%; Pursuit 83%; Final Breath 83%; Feed the Demon 80%; Soul Barrier (choice) 78%; Chaos Nova 78%; Volatile Flameblood 77%; Pitch Black (choice) 70%; Felbound 65%; Erratic Felheart 51%; Demon Muzzle 48%; Felfire Haste 43%; Painbringer 33%; Chains of Anger 30%; Imprison 26%; Disrupting Fury 18%; Retaliation 17%; Improved Sigil of Misery 14%; Consume Magic 12%; Path to Oblivion (choice) 11%

**Ours, against the whole sample:**

- `Raid`: 7 of 693 run it exactly. Typical has +Demon Muzzle; lacks Felfire Haste.

### Mythic+

681 rankings over 8 dungeons, logged 2026-09-08 to 2026-10-18, keys 19 to 22 (median 20). 254 distinct builds. Hero tree: Annihilator 98%, Aldrachi Reaver 2%. 119 left out: their log has no talents.

**Typical** (Annihilator, agreement 71% on 11 contested talents, 6 run it exactly):

`CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZmhZkZmxwyMzMDMjZGzYmZGDmZmxmZmtxYGAAAAAAAAmZGbAAAAYgZmZmZrtZmZAAAAAAG`

**Most common other builds**, each against the typical:

- 21 (3.1%): +Erratic Felheart 1/2; -Consume Magic
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZmhZkZmxwyMzMDMjZGzYmZGDmZmx2DMzsNGGAAAAAAAAmZGbAAAAYgZmZmZrtZmZAAAAAAG`
- 20 (2.9%): +Felbound, +Improved Sigil of Misery, +Painbringer 2/2, +Soulmonger; -Disrupting Fury, -Feed the Demon, -Focused Cleave, -Live by the Glaive, -Quickened Sigils
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZMMzkZmxwyMzMDMjZmZMzMzYwwM2MzsNGzAAAAAAAAwMGbAAAAYwMzMzMbtNzMDAAAAAwA`
- 18 (2.6%): +Fel Flame Fortification, +Improved Sigil of Misery, +Painbringer 2/2; -Consume Magic, -Felfire Fist, -Revel in Pain, -Soul Barrier
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZmhZmMzMYYmZGYGzMmZmZmxgZmZsZmZbMMAAAAAAAAMzM2AAAAwAzMzMzWbzMzAAAAAAMA`
- 17 (2.5%): +Final Breath; -Consume Magic
  `CUkAAAAAAAAAAAAAAAAAAAAAAAAMjZmZmhZkZmxwyMzMDMjZGzYmZGDmZmxmZmtxwAAAAAAAAwMzYDAAAADMzMzMbtNzMDAMAAAAG`

**Split talents:** Ascending Flame 88%; Soul Barrier (choice) 88%; Live by the Glaive 88%; State of Matter (choice) 87%; Focused Cleave 84%; Felfire Fist 76%; Revel in Pain 72%; Quickened Sigils 61%; Painbringer 61%; Feed the Demon 54%; Consume Magic 47%; Disrupting Fury 35%; Final Breath 34%; Fel Flame Fortification 31%; Improved Sigil of Misery 26%; Felbound 23%; Pursuit 20%; Erratic Felheart 20%; Soulmonger 16%; Volatile Flameblood 11%; Sigil of Silence 11%; Path to Oblivion (choice) 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 6 of 681 run it exactly.

## Balance Druid

### Raid

994 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 497 distinct builds. Hero tree: Elune's Chosen 62%, Keeper of the Grove 38%.

**Typical** (Elune's Chosen, agreement 70% on 33 contested talents, 13 run it exactly):

`CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmBDzYMzyMLmZGbsMzyYMzYBDDwYbbmBjZbAMBAAAYxMzMzgNDjxMAAmZgBA`

**Most common other builds**, each against the typical:

- 26 (2.6%): +Astral Communion, +Blooming Infusion, +Cenarius' Might, +Control of the Dream, +Dryad's Dance, +Early Spring, +Elune's Guidance, +Expansiveness, +Force of Nature, +Harmony of the Grove, +Keeper of the Grove, +Meteor Storm, +Potent Enchantments, +Power of Nature, +Protective Growth, +Rattle the Stars, +Spirit of the Thicket, +Sylvan Beckoning, +Treants of the Moon, +Wild Mushroom; -Aetherial Kindling, -Astral Insight, -Atmospheric Exposure, -Bask in Moonlight, -Denizen of the Dream, -Elune's Chosen, -Elune's Grace, -Fury of Elune, -Glistening Fur, -Lunar Calling, -Lunar Insight, -Lunation, -Moon Guardian, -Penumbral Swell, -Radiant Moonlight, -Star Cascade, -Starweaver, -Stellar Command, -The Eternal Moon, -Umbral Intensity
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmBDzY2mZZsNjZsZWmxYmZGbYYAGgttxGmmZWGAAAAsZmZmZwmhxYAYmBAGA`
- 25 (2.5%): +Astral Communion, +Blooming Infusion, +Cenarius' Might, +Control of the Dream, +Dryad's Dance, +Early Spring, +Elune's Guidance, +Expansiveness, +Force of Nature, +Harmony of the Grove, +Improved Stampeding Roar, +Keeper of the Grove, +Lingering Healing, +Potent Enchantments, +Power of Nature, +Protective Growth, +Rattle the Stars, +Spirit of the Thicket, +Sylvan Beckoning, +Treants of the Moon, +Wild Mushroom; -Astral Insight, -Atmospheric Exposure, -Bask in Moonlight, -Elune's Chosen, -Elune's Grace, -Glistening Fur, -Light of the Sun, -Lunar Calling, -Lunar Insight, -Lunation, -Moon Guardian, -Penumbral Swell, -Radiant Moonlight, -Star Cascade, -Starweaver, -Stellar Amplification, -Stellar Command, -The Eternal Moon, -Umbral Embrace, -Umbral Intensity, -Ursine Vigor
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsMzMzMMDzY2mZZsMMjNzyMLjZmhNMMADw22YDTzMLDAAAA2YmZmBbGYMDgZGAYA`
- 23 (2.3%): +Astral Communion, +Blooming Infusion, +Cenarius' Might, +Control of the Dream, +Dryad's Dance, +Early Spring, +Elune's Guidance, +Expansiveness, +Force of Nature, +Harmony of the Grove, +Keeper of the Grove, +Potent Enchantments, +Power of Nature, +Protective Growth, +Rattle the Stars, +Spirit of the Thicket, +Sylvan Beckoning, +Treants of the Moon, +Wild Mushroom; -Astral Insight, -Atmospheric Exposure, -Bask in Moonlight, -Denizen of the Dream, -Elune's Chosen, -Elune's Grace, -Fury of Elune, -Glistening Fur, -Lunar Calling, -Lunar Insight, -Lunation, -Moon Guardian, -Penumbral Swell, -Radiant Moonlight, -Star Cascade, -Starweaver, -Stellar Command, -The Eternal Moon, -Umbral Intensity
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmBDzY2mZZsMjZsZWmxYmZGbYYAGgttxGmmZWGAAAAsZmZmZwmhxYAYmBAGA`
- 22 (2.2%): +Killer Instinct 1/2; -Light of the Sun
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMD8AmFzMzMYYGjZWmZxMzYjlZWGjZGLYYAGbbzMYMbDgJAAAALmZmZGsZgxMAAmZgBA`

**Split talents:** Incarnation: Chosen of Elune (choice) 90%; Umbral Embrace 90%; Wild Charge (choice) 90%; Ursol's Vortex (choice) 90%; Meteorites 89%; Stellar Amplification 87%; Heart of the Wild 85%; Remove Corruption 85%; Typhoon 83%; Denizen of the Dream 82%; Fluid Form 77%; Umbral Intensity 73%; Fury of Elune (choice) 72%; Aetherial Kindling (choice) 71%; Light of the Sun 65%; The Eternal Moon 62%; Stellar Command 62%; Star Cascade 62%; Penumbral Swell 62%; Moon Guardian 62%; Lunar Insight 62%; Lunar Calling 62%; Glistening Fur 62%; Bask in Moonlight 62%; Atmospheric Exposure 62%; Astral Insight (choice) 62%; Radiant Moonlight 61%; Lunation (choice) 61%; Orbit Breaker (choice) 59%; Starweaver (choice) 59%; Elune's Grace (choice) 57%; Killer Instinct 52%; Ursine Vigor 52%; Improved Stampeding Roar 51%; Rattle the Stars (choice) 41%; Sundered Firmament (choice) 41%; Treants of the Moon 38%; Sylvan Beckoning 38%; Spirit of the Thicket 38%; Protective Growth 38%; Power of Nature (choice) 38%; Harmony of the Grove 38%; Force of Nature 38%; Expansiveness 38%; Dryad's Dance 38%; Control of the Dream (choice) 38%; Cenarius' Might 38%; Blooming Infusion 38%; Astral Communion 37%; Elune's Guidance 29%; Wild Mushroom (choice) 27%; Early Spring (choice) 27%; Potent Enchantments (choice) 27%; Perfectly-Honed Instincts 21%; Meteor Storm (choice) 19%; Incapacitating Roar (choice) 18%; Grove's Inspiration (choice) 11%; Tiger Dash (choice) 10%; Power of Goldrinn 10%; Nature's Balance 10%; Bounteous Bloom (choice) 10%; Convoke the Spirits (choice) 10%

**Ours, against the whole sample:**

- `Raid: Cleave`: the typical build. 13 of 994 run it exactly.
- `Raid: Nek'Zali, Altar`: 15 of 994 run it exactly. Typical has +Orbit Breaker, +Ursine Vigor; lacks Improved Stampeding Roar, Sundered Firmament.
- `Raid: Single Target`: 23 of 994 run it exactly. Typical has +Astral Insight, +Atmospheric Exposure, +Bask in Moonlight, +Denizen of the Dream, +Elune's Chosen, +Elune's Grace, +Fury of Elune, +Glistening Fur, +Lunar Calling, +Lunar Insight, +Lunation, +Moon Guardian, +Penumbral Swell, +Radiant Moonlight, +Star Cascade, +Starweaver, +Stellar Command, +The Eternal Moon, +Umbral Intensity; lacks Astral Communion, Blooming Infusion, Cenarius' Might, Control of the Dream, Dryad's Dance, Early Spring, Elune's Guidance, Expansiveness, Force of Nature, Harmony of the Grove, Keeper of the Grove, Potent Enchantments, Power of Nature, Protective Growth, Rattle the Stars, Spirit of the Thicket, Sylvan Beckoning, Treants of the Moon, Wild Mushroom.

### Mythic+

643 rankings over 8 dungeons, logged 2026-09-03 to 2026-10-18, keys 19 to 22 (median 20). 162 distinct builds. Hero tree: Elune's Chosen 100%. 157 left out: their log has no talents.

**Typical** (Elune's Chosen, agreement 74% on 5 contested talents, 113 run it exactly):

`CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmZhBjZZmlZWYmxGLzsMmZM2wwAM22mZwY2GATAAAAWMzMzMYzwYMAAMzglBA`

**Most common other builds**, each against the typical:

- 63 (9.8%): +Improved Stampeding Roar; -Ursine Vigor
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsMzMzMLMYMLzsMzCzM2YZmlxMjxGGGgx22MDGz2AYCAAAwCzMzMYzwYMAAMzglBA`
- 44 (6.8%): +Perfectly-Honed Instincts; -Ursine Vigor
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmZhBjZZmlZWYmxGLzsMmZM2wwAM22mZwY2GATAAAAWYmZmBbGzYMAAMzglBA`
- 31 (4.8%): +Innervate; -Ursine Vigor
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmZhhZMLzsMzCzM2YZmlxMjxGGGgx22MDGz2AYCAAAwCzMzMYzwYMAAMzglBA`
- 15 (2.3%): +Meteorites, +Starweaver, +Stellar Amplification; -Elune's Guidance, -Rattle the Stars, -Sunseeker Mushroom
  `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmZhBjxMLzsYmZsxyMLjxMjFMMAjttZGMmtBwEAAAgFzMzMD2MMGDAAzMYZA`

**Split talents:** Elune's Guidance 85%; Fluid Form 84%; Sunseeker Mushroom (choice) 78%; Rattle the Stars (choice) 77%; Ursine Vigor 49%; Improved Stampeding Roar 34%; Perfectly-Honed Instincts 30%; Stellar Amplification 24%; Starweaver (choice) 23%; Innervate 16%; Killer Instinct 13%; Meteorites 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 113 of 643 run it exactly.

### Boss rows

Each row's typical is pooled over every boss it backs; each boss is also shown alone.

- **`Raid: Nek'Zali, Altar`** for Nek'zali, The Coiled Altar: 200 rankings; Elune's Chosen 100%, Keeper of the Grove 0%; typical agreement 75% on 11 contested. Ours: `Raid: Nek'Zali, Altar`: the typical build. 3 of 200 run it exactly.
  typical: `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsMzMzMYYGjZWmZxMzYhlZWGjZGLYYAGbbzMYMbDgJAAAALMzMzgNDjxMAAmZgBA`
  - Nek'zali alone: 100 rankings; Elune's Chosen 99%, Keeper of the Grove 1%; against its own typical, the row's typical has +Aetherial Kindling; lacks Meteor Storm.
  - The Coiled Altar alone: 100 rankings; Elune's Chosen 100%; against its own typical, the row's typical has +Wild Charge; lacks Tiger Dash.

- **`Raid: Cleave`** for Entombed Sentinels, The Lost Explorers, The Twin Fangs, Kith'ix: 394 rankings; Elune's Chosen 100%, Keeper of the Grove 0%; typical agreement 74% on 8 contested. Ours: `Raid: Cleave`: the typical build. 12 of 394 run it exactly.
  typical: `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmBDzYMzyMLmZGbsMzyYMzYBDDwYbbmBjZbAMBAAAYxMzMzgNDjxMAAmZgBA`
  - Entombed Sentinels alone: 100 rankings; Elune's Chosen 100%; against its own typical, the same build.
  - The Lost Explorers alone: 100 rankings; Elune's Chosen 100%; against its own typical, the same build.
  - The Twin Fangs alone: 100 rankings; Elune's Chosen 100%; against its own typical, the row's typical has +Ursine Vigor; lacks Incapacitating Roar.
  - Kith'ix alone: 94 rankings; Elune's Chosen 99%, Keeper of the Grove 1%; against its own typical, the row's typical has +Orbit Breaker, +Ursine Vigor, +Ursol's Vortex; lacks Improved Stampeding Roar, Mass Entanglement, Sundered Firmament.

- **`Raid: Single Target`** for Vashnik, Sszorak, Ula'tek, Nymrissa Wavecaller: 400 rankings; Keeper of the Grove 93%, Elune's Chosen 7%; typical agreement 69% on 16 contested. Ours: `Raid: Single Target`: the typical build. 23 of 400 run it exactly.
  typical: `CYGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWoMbNjxMDwsYmZmBDzY2mZZsMjZsZWmxYmZGbYYAGgttxGmmZWGAAAAsZmZmZwmhxYAYmBAGA`
  - Vashnik alone: 100 rankings; Keeper of the Grove 84%, Elune's Chosen 16%; against its own typical, the row's typical has +Aetherial Kindling; lacks Meteor Storm.
  - Sszorak alone: 100 rankings; Keeper of the Grove 99%, Elune's Chosen 1%; against its own typical, the row's typical has +Aetherial Kindling, +Early Spring, +Elune's Guidance, +Incarnation: Chosen of Elune, +Light of the Sun, +Meteorites, +Orbit Breaker, +Potent Enchantments, +Twin Moons, +Typhoon, +Wild Mushroom; lacks Bounteous Bloom, Convoke the Spirits, Denizen of the Dream, Grove's Inspiration, Killer Instinct 2/2, Nature's Balance, Power of Goldrinn, Soul of the Forest, Sundered Firmament, Umbral Intensity.
  - Ula'tek alone: 100 rankings; Keeper of the Grove 91%, Elune's Chosen 9%; against its own typical, the row's typical has +Light of the Sun, +Stellar Amplification, +Umbral Embrace, +Ursine Vigor; lacks Denizen of the Dream, Fury of Elune, Improved Stampeding Roar, Lingering Healing.
  - Nymrissa Wavecaller alone: 100 rankings; Keeper of the Grove 98%, Elune's Chosen 2%; against its own typical, the same build.

## Feral Druid

### Raid

649 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 508 distinct builds. Hero tree: Wildstalker 96%, Druid of the Claw 4%.

**Typical** (Wildstalker, agreement 74% on 19 contested talents, 4 run it exactly):

`CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZ2YmZmxY2WGLjtZmZMzMAAAAsEMbGGzMqZMLMzMjxMmBAAAAAwADAAAAAwsNzSzyMLbgZGgFzgBAwMDAGA`

**Most common other builds**, each against the typical:

- 10 (1.5%): +Carnivorous Instinct 2/2, +Double-Clawed Rake, +Heart of the Wild, +Primal Wrath, +Root Network, +Ursine Vigor, +Veinripper; -Feral Frenzy, -Focused Frenzy, -Innervate, -Resilient Flourishing, -Rip and Tear, -Tireless Energy 2/2, -Ursol's Vortex
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZMzCzMzMGz2yMYbmZmxMDAAAALBDDjZG1MmFzMzMGzwAAAAAAYgBAAAAAY2mZpZZmtNYmZAWMDGAAzMAYA`
- 9 (1.4%): +Coiled to Spring, +Forestwalk 1/2, +Heart of the Wild, +Merciless Claws, +Saber Jaws 2/2, +Ursine Vigor; -Apex Predator's Craving, -Fluid Form, -Infected Wounds, -Lycara's Inspiration, -Rampant Ferocity, -Rip and Tear, -Typhoon
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAwgZMGzMzMmtFWGbzMzYmZAAAAYJY2gxMjaGziZmZGjZegBAAAAAAwAAAAAAMbzs0sMzyGMzMALmBDAgZGAMA`
- 8 (1.2%): +Forestwalk 2/2, +Hunger for Battle, +Merciless Claws, +Primal Wrath, +Tireless Energy 1/2; -Fluid Form, -Innervate, -Lunar Inspiration, -Panther's Guile, -Tireless Energy 2/2
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZ2MzMzMzY2MWGbzYm5BmZAAAAYJY2MMmZUzYWYmZGjZGAAAAAAMwAAAAAAMbzs0sMzyGYmBYxMYAAMzAgB`
- 6 (0.9%): +Improved Stampeding Roar, +Incapacitating Roar, +Matted Fur 1/2; -Lycara's Inspiration, -Matted Fur 2/2
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZ2YmZmxY2WGLjtZmZMzMAAAAsEMbGGzMqZMLjZmZWGzYGAAAAAAgBAAAAAY2mZpZZmlNwMPAwiZwAAYmBAD`

**Split talents:** Convoke the Spirits (choice) 89%; Twin Sprouts (choice) 89%; Tireless Energy 88%; Feral Frenzy 88%; Lore of the Grove 87%; Resilient Flourishing (choice) 86%; Focused Frenzy (choice) 82%; Infected Wounds 79%; Lycara's Inspiration 79%; Ursol's Vortex (choice) 76%; Wild Charge (choice) 75%; Lunar Inspiration (choice) 74%; Apex Predator's Craving 65%; Typhoon 63%; Fluid Form 63%; Innervate 62%; Rampant Ferocity 62%; Improved Stampeding Roar 51%; Rip and Tear (choice) 51%; Primal Wrath 50%; Heart of the Wild 33%; Forestwalk 30%; Saber Jaws 29%; Coiled to Spring 28%; Ursine Vigor 27%; Carnivorous Instinct 26%; Merciless Claws 26%; Tiger Dash (choice) 25%; Perfectly-Honed Instincts 25%; Hunger for Battle 23%; Ashamane's Guidance 13%; Veinripper (choice) 13%; Incapacitating Roar (choice) 12%; Double-Clawed Rake 12%; Incarnation: Avatar of Ashamane (choice) 10%; Root Network (choice) 10%

**Ours, against the whole sample:**

- `Raid: Coiled Altar`: no one in the sample runs it exactly. Typical has +Lycara's Inspiration, +Rip and Tear, +Tireless Energy 2/2, +Typhoon; lacks Carnivorous Instinct 1/2, Forestwalk 1/2, Perfectly-Honed Instincts, Primal Wrath, Tireless Energy 1/2.
- `Raid: Entombed Sentinels`: 1 of 649 run it exactly. Typical has +Rip and Tear; lacks Carnivorous Instinct 1/2.
- `Raid: Lost Explorers`: 2 of 649 run it exactly. Typical has +Feral Frenzy, +Focused Frenzy, +Rip and Tear, +Typhoon; lacks Carnivorous Instinct 2/2, Improved Stampeding Roar, Veinripper.
- `Raid: Nek'Zali`: 1 of 649 run it exactly. Typical has +Rampant Ferocity, +Rip and Tear, +Typhoon; lacks Carnivorous Instinct 1/2, Improved Stampeding Roar, Primal Wrath.
- `Raid: Nymrissa`: no one in the sample runs it exactly. Typical has +Fluid Form, +Infected Wounds, +Lunar Inspiration, +Tireless Energy 2/2; lacks Hunger for Battle, Improved Stampeding Roar, Merciless Claws, Primal Wrath, Tireless Energy 1/2.
- `Raid: Sszorak`: no one in the sample runs it exactly. Typical has +Apex Predator's Craving, +Bond with Nature, +Bursting Growth, +Circle of Life and Death, +Flower Walk, +Green Thumb, +Hunt Beneath the Open Skies, +Infected Wounds, +Lethal Preservation, +Lunar Inspiration, +Patient Custodian, +Rampancy, +Rampant Ferocity, +Resilient Flourishing, +Rip and Tear, +Strategic Infusion, +Twin Sprouts, +Typhoon, +Vigorous Creepers, +Wildstalker, +Wildstalker's Power; lacks Aggravate Wounds, Ashamane's Guidance, Bestial Strength, Carnivorous Instinct 1/2, Claw Rampage, Coiled to Spring, Dreadful Wound, Druid of the Claw, Empowered Shapeshifting, Exacerbating Wounds, Fount of Strength, Improved Stampeding Roar, Killing Strikes, Limb from Limb, Merciless Claws, Pack's Endurance, Saber Jaws 2/2, Strike for the Heart, Twin Claw, Wildshape Mastery.
- `Raid: Twin Fangs`: no one in the sample runs it exactly. Typical has +Convoke the Spirits, +Fluid Form, +Focused Frenzy, +Panther's Guile, +Resilient Flourishing, +Tireless Energy 2/2, +Ursol's Vortex, +Wild Charge; lacks Ashamane's Guidance, Double-Clawed Rake, Improved Stampeding Roar, Incapacitating Roar, Incarnation: Avatar of Ashamane, Primal Wrath, Root Network, Tiger Dash, Wild Slashes.
- `Raid: Ula'tek`: no one in the sample runs it exactly. Typical has +Innervate, +Lunar Inspiration, +Tireless Energy 2/2, +Typhoon; lacks Heart of the Wild, Hunger for Battle, Improved Stampeding Roar, Primal Wrath, Tireless Energy 1/2.
- `Raid: Vashnik`: 1 of 649 run it exactly. Typical has +Apex Predator's Craving, +Convoke the Spirits, +Lunar Inspiration, +Tireless Energy 2/2, +Typhoon; lacks Ashamane's Guidance, Hunger for Battle, Improved Stampeding Roar, Incarnation: Avatar of Ashamane, Primal Wrath, Tireless Energy 1/2.

### Mythic+

714 rankings over 8 dungeons, logged 2026-09-05 to 2026-10-18, keys 20 to 23 (median 20). 152 distinct builds. Hero tree: Druid of the Claw 95%, Wildstalker 5%. 86 left out: their log has no talents.

**Typical** (Druid of the Claw, agreement 83% on 7 contested talents, 258 run it exactly):

`CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmZ2YmZmxY2M2mZZGzMmZAAAAYJY2M8AmZUzYWMzMzsMmhBAAAAAwADAAAgmZZWmZmBAsAzMDwCDGAAAzshB`

**Most common other builds**, each against the typical:

- 52 (7.3%): +Convoke the Spirits, +Hunger for Battle; -Ashamane's Guidance, -Incarnation: Avatar of Ashamane
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmZ2MzMzMGzmx2YbGzMmZAAAAYJY2M8AmZUzYWMzMzsMmhBAAAAAwADAAAgmZZWmZmBAsAzMDwCDGAAAzshB`
- 42 (5.9%): +Innervate; -Ursine Vigor
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmZ2YmZmxY2M2mZZGzMmZAAAAYJY2M8AmZUzYWMzMzsMmxMAAAAAAGYAAAA0MLzyMzMAgFwMDwCDGAAAzshB`
- 25 (3.5%): +Tiger Dash; -Wild Charge
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmZ2YmZmxY2M2mZZGzMmZAAAAYLY2M8AmZUzYWMzMzsMmhBAAAAAwADAAAgmZZWmZmBAsAzMDwCDGAAAzshB`
- 15 (2.1%): +Panther's Guile, +Tireless Energy 1/2; -Double-Clawed Rake, -Infected Wounds
  `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAmZ2YmZmxY2M2mZZmZm5BmZAAAAYJY2M8AmZUzYWMzMzsMmhBAAAAAwADAAAgmZZWmZmBAsAzMDwCDGAAAzshB`

**Split talents:** Nurturing Instinct 88%; Infected Wounds 87%; Wild Charge (choice) 87%; Double-Clawed Rake 84%; Ursine Vigor 82%; Ashamane's Guidance 78%; Incarnation: Avatar of Ashamane (choice) 78%; Hunger for Battle 23%; Convoke the Spirits (choice) 22%; Innervate 19%; Tireless Energy 16%; Panther's Guile 13%; Tiger Dash (choice) 13%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 258 of 714 run it exactly.

### Boss rows

Each row's typical is pooled over every boss it backs; each boss is also shown alone.

- **`Raid: Nek'Zali`** for Nek'zali: 100 rankings; Wildstalker 99%, Druid of the Claw 1%; typical agreement 73% on 15 contested. Ours: `Raid: Nek'Zali`: the typical build. 1 of 100 run it exactly.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwYmZMmtl5BWGbzMzMzMDAAAALBzGMmZUzYWGzMzYMjZAAAAAAMwAAAAAAMbzs0sMzyGYmBYxMYAAMzAgB`
  - Nek'zali alone: 100 rankings; Wildstalker 99%, Druid of the Claw 1%; against its own typical, the same build.

- **`Raid: Entombed Sentinels`** for Entombed Sentinels: 100 rankings; Wildstalker 96%, Druid of the Claw 4%; typical agreement 75% on 11 contested. Ours: `Raid: Entombed Sentinels`: 1 of 100 run it exactly. Typical has +Rip and Tear; lacks Carnivorous Instinct 1/2.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZ2YmZmxY2WGLjtZmZMzMAAAAsEMbGGzMqZMLMzMjxMmBAAAAAwADAAAAAwsNzSzyMLbgZGgFzgBAwMDAGA`
  - Entombed Sentinels alone: 100 rankings; Wildstalker 96%, Druid of the Claw 4%; against its own typical, the same build.

- **`Raid: Lost Explorers`** for The Lost Explorers: 100 rankings; Wildstalker 99%, Druid of the Claw 1%; typical agreement 70% on 13 contested. Ours: `Raid: Lost Explorers`: the typical build. 2 of 100 run it exactly.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZWYmZmxY2WmBbzMzYmZAAAAYJY2gxMjaGzyYmZGjZMDAAAAAgBGAAAAAgZbmlmlZW2AzMALmBDAgZGAMA`
  - The Lost Explorers alone: 100 rankings; Wildstalker 99%, Druid of the Claw 1%; against its own typical, the same build.

- **`Raid: Vashnik`** for Vashnik, Kith'ix: 103 rankings; Wildstalker 95%, Druid of the Claw 5%; typical agreement 74% on 15 contested. Ours: `Raid: Vashnik`: 1 of 103 run it exactly. Typical has +Apex Predator's Craving, +Convoke the Spirits, +Typhoon; lacks Ashamane's Guidance, Incarnation: Avatar of Ashamane, Innervate.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZ2MzMzMGzmxyYbmZm5BmZAAAAYJY2MMmZUzYWGzMzYMDDAAAAAgBGAAAAAgZbmlmlZW2AzMALmBDAgZGAMA`
  - Vashnik alone: 100 rankings; Wildstalker 95%, Druid of the Claw 5%; against its own typical, the same build.
  - Kith'ix alone: 3 rankings; Wildstalker 100%; against its own typical, the row's typical has +Apex Predator's Craving, +Hunger for Battle, +Improved Stampeding Roar, +Matted Fur 2/2, +Rampant Ferocity, +Rip and Tear, +Tireless Energy 1/2, +Ursol's Vortex, +Wild Charge; lacks Heart of the Wild, Lunar Inspiration, Mass Entanglement, Matted Fur 1/2, Saber Jaws 2/2, Tiger Dash, Tireless Energy 2/2, Ursine Vigor.

- **`Raid: Sszorak`** for Sszorak: 100 rankings; Wildstalker 94%, Druid of the Claw 6%; typical agreement 73% on 9 contested. Ours: `Raid: Sszorak`: no one in the sample runs it exactly. Typical has +Bond with Nature, +Bursting Growth, +Circle of Life and Death, +Flower Walk, +Green Thumb, +Hunt Beneath the Open Skies, +Lethal Preservation, +Lunar Inspiration, +Patient Custodian, +Rampancy, +Resilient Flourishing, +Strategic Infusion, +Twin Sprouts, +Vigorous Creepers, +Wildstalker, +Wildstalker's Power; lacks Aggravate Wounds, Ashamane's Guidance, Bestial Strength, Carnivorous Instinct 1/2, Claw Rampage, Dreadful Wound, Druid of the Claw, Empowered Shapeshifting, Exacerbating Wounds, Fount of Strength, Killing Strikes, Limb from Limb, Pack's Endurance, Strike for the Heart, Twin Claw, Wildshape Mastery.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAwgZMGzMzMmtFWGbzMzYmZAAAAYJY2gxMjaGzyYmZGjZMDAAAAAgBGAAAAAgZbmlmlZW2AzMALmBDAgZGAMA`
  - Sszorak alone: 100 rankings; Wildstalker 94%, Druid of the Claw 6%; against its own typical, the same build.

- **`Raid: Twin Fangs`** for The Twin Fangs: 37 rankings; Wildstalker 100%; typical agreement 71% on 13 contested. Ours: `Raid: Twin Fangs`: no one in the sample runs it exactly. Typical has +Fluid Form, +Panther's Guile, +Wild Charge; lacks Improved Stampeding Roar, Tiger Dash, Wild Slashes.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZMzGzMzMGz2ywMLzMzMmZAAAAYJYYYMzomxswMzMLjZMDAAAAAgBGAAAAAgZbmlmlZ22AzMALmBDAgZGAMA`
  - The Twin Fangs alone: 37 rankings; Wildstalker 100%; against its own typical, the same build.

- **`Raid: Coiled Altar`** for The Coiled Altar: 9 rankings; Wildstalker 100%; typical agreement 79% on 15 contested. Ours: `Raid: Coiled Altar`: no one in the sample runs it exactly. Typical has +Heart of the Wild, +Improved Stampeding Roar, +Rip and Tear, +Tireless Energy 2/2; lacks Carnivorous Instinct 1/2, Forestwalk 1/2, Perfectly-Honed Instincts, Primal Wrath, Tireless Energy 1/2.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZ2YmZmxY2WGLjtZmZMzMAAAAsEMbwYmRNjZZmZmZMmxMAAAAAAADAAAAAwsNzSzyMLbgZGgFzgBAwMDAGA`
  - The Coiled Altar alone: 9 rankings; Wildstalker 100%; against its own typical, the same build.

- `Raid: Ula'tek` (Ula'tek): no rankings with talents.

- **`Raid: Nymrissa`** for Nymrissa Wavecaller: 100 rankings; Wildstalker 92%, Druid of the Claw 8%; typical agreement 66% on 16 contested. Ours: `Raid: Nymrissa`: no one in the sample runs it exactly. Typical has +Heart of the Wild, +Infected Wounds; lacks Merciless Claws, Typhoon.
  typical: `CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZ2MzMzMGzmxyYbmZm5BmZAAAAYJY2gxMjaGzyMzMzYMjBAAAAAgBGAAAAAgZbmlmlZW2AzMALmBDAgZGAMA`
  - Nymrissa Wavecaller alone: 100 rankings; Wildstalker 92%, Druid of the Claw 8%; against its own typical, the same build.

## Guardian Druid

### Raid

710 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 328 distinct builds. Hero tree: Elune's Chosen 100%, Druid of the Claw 0%.

**Typical** (Elune's Chosen, agreement 75% on 10 contested talents, 44 run it exactly):

`CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYGjZ2MLGMLLDMbwoJamZWmZmZGjZMDAAAAAYGbzAW2mZwY2GATAAAAbYmBYxMYAbW2GgZGAD`

**Most common other builds**, each against the typical:

- 20 (2.8%): +Lycara's Inspiration; -Instincts of the Claw
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYGjZ2MLGMLLDMbwoJamZWmZmZGjZMDAAAAAYmZbGwy2MDGz2AYCAAAYDzMALGYAbW2GgZGAD`
- 15 (2.1%): +Typhoon; -Innervate
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYGjZ2MLGMLLDMbGGNRzMzyMzMzYMDDAAAAAYGbzAW2mZwY2GATAAAAbYmBYxMYAbW2GgZGAD`
- 13 (1.8%): +Incapacitating Roar; -Instincts of the Claw
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYGjZ2MLGMLLDMbwoJamZWmZmZmlxMmBAAAAAMjtZALbzMYMbDgJAAAgNMzAsYgBsZZbAmZAMA`
- 10 (1.4%): +Lycara's Inspiration; -Innervate
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYGjZ2MLGMLLDMbwoJamZWmZmZGjZYAAAAAAzMbzAW2mZwY2GATAAAAbYmBYxMYAbW2GgZGAD`

**Split talents:** Improved Stampeding Roar 89%; Matted Fur 88%; Ursol's Vortex (choice) 86%; Fluid Form 81%; The Light of Elune (choice) 79%; Elune's Grace (choice) 79%; Brambles (choice) 79%; Instincts of the Claw 69%; Innervate 56%; Gory Fur (choice) 55%; Ursoc's Endurance (choice) 44%; Typhoon 39%; Lycara's Inspiration 31%; Astral Influence 29%; Incapacitating Roar (choice) 23%; Moondust (choice) 21%; Astral Insight (choice) 21%; Perfectly-Honed Instincts 18%; Starlight Conduit 17%; Ursol's Warding 14%

**Ours, against the whole sample:**

- `Raid`: the typical build. 44 of 710 run it exactly.

### Mythic+

688 rankings over 8 dungeons, logged 2026-09-18 to 2026-10-18, keys 21 to 24 (median 21). 123 distinct builds. Hero tree: Elune's Chosen 100%. 112 left out: their log has no talents.

**Typical** (Elune's Chosen, agreement 81% on 5 contested talents, 193 run it exactly):

`CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYmZMziZxMmZZZgZzwoJamZWmZmZmlxMAAAAAAMjNDYZbmBjZZAMBAAAshZGgFjhBsYBgZGAD`

**Most common other builds**, each against the typical:

- 63 (9.2%): +Elune's Grace; -Moondust
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYmZMziZxMmZZZgZzwoJamZWmZmZmlxMAAAAAAMjNDYZbmBjZbAMBAAAshZGgFjhBsYBgZGAD`
- 41 (6.0%): +Astral Influence; -Primal Fury
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYmZMziZxMmZZZgZzMGNRmZWmZmZmlxMAAAAAAMjNDYZbmBjZZAMBAAAshZGgFjhBsYBgZGAD`
- 34 (4.9%): +Astral Insight; -The Light of Elune
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYmZMziZxMmZZZgZzwoJamZWmZmZmlxMAAAAAAMjNDYbbmBjZZAMBAAAshZGgFjhBsYBgZGAD`
- 19 (2.8%): +Fluid Form; -Perfectly-Honed Instincts
  `CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmxsYmZMziZxMmZZZgZzwoJamZWmZmZmlxMMAAAAAgZsZALbzMYMLDgJAAAgNMzAsYgBsYBgZGAD`

**Split talents:** Perfectly-Honed Instincts 83%; The Light of Elune (choice) 82%; Moondust (choice) 79%; Primal Fury 77%; Elune's Grace (choice) 21%; Astral Insight (choice) 18%; Fluid Form 17%; Astral Influence 16%; Innervate 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 193 of 688 run it exactly.

## Restoration Druid

### Raid

923 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 442 distinct builds. Hero tree: Wildstalker 100%, Keeper of the Grove 0%. 1 left out: their log has no talents.

**Typical** (Wildstalker, agreement 72% on 11 contested talents, 11 run it exactly):

`CkGAAAAAAAAAAAAAAAAAAAAAAYMmZZmZMzMmthZwsZsNmBAAAAAAAAAALGa2MjpZGgZZmZmZYYGAAAAAGAAAAAAAwsNzSz2Mb2YMzMYGY0MAAzMAMA`

**Most common other builds**, each against the typical:

- 34 (3.7%): +Fluid Form, +Harmonious Constitution, +Rake, +Rip; -Bond with Nature, -Frenzied Regeneration, -Perfectly-Honed Instincts, -Ursol's Vortex
  `CkGAAAAAAAAAAAAAAAAAAAAAAYMmZZmZMzMmthZwsZsNmBAAAAAAAAAALzQDzYaGGYWmZmZGGmZAAAAAMAAAAAAAgZbmtmtZ2sxYmZwMANDAwMDADA`
- 28 (3.0%): +Incapacitating Roar; -Perfectly-Honed Instincts
  `CkGAAAAAAAAAAAAAAAAAAAAAAYMmZZmZMzMmthZwsZsNmBAAAAAAAAAALGa2MjpZGgZZmZmZWMMDAAAAADAAAAAAAY2mZpZbmNbMmZGMDQzAAMzAwA`
- 18 (2.0%): +Killer Instinct 1/2, +Rake, +Rip, +Tiger Dash; -Starfire, -Starsurge, -Typhoon, -Wild Charge
  `CkGAAAAAAAAAAAAAAAAAAAAAAYMmZZmZMzMmthZwsZsNmBAAAAAAAAAAbDa2YMNzY4BMLzMzMDDzAAAAAAAAAAAAAwsNzSz2Mb2YMzMYGY0MAAzMAMA`
- 16 (1.7%): +Circle of the Heavens, +Tiger Dash; -Perfectly-Honed Instincts, -Wild Charge
  `CkGAAAAAAAAAAAAAAAAAAAAAAYMmZZmZMzMmthZwsZsNmBAAAAAAAAAAbGa2MjpZGgZZmZmZYYGAAAAAGAAAAAAAwsNzSz2Mb2YMzMYmNQzAAMzAwA`

**Split talents:** Frenzied Regeneration 86%; Ursol's Vortex (choice) 83%; Master Shapeshifter (choice) 81%; Starlight Conduit 81%; Heart of the Wild 74%; Starfire 70%; Starsurge 65%; Wild Charge (choice) 62%; Typhoon 58%; Killer Instinct 49%; Perfectly-Honed Instincts 47%; Rake 46%; Rip 42%; Tiger Dash (choice) 38%; Incapacitating Roar (choice) 29%; Liveliness (choice) 18%; Moonkin Form 16%; Ursine Vigor 14%; Fluid Form 12%

**Ours, against the whole sample:**

- `Raid`: the typical build. 11 of 923 run it exactly.

### Mythic+

657 rankings over 8 dungeons, logged 2026-09-10 to 2026-10-18, keys 19 to 22 (median 20). 334 distinct builds. Hero tree: Wildstalker 93%, Keeper of the Grove 7%. 143 left out: their log has no talents.

**Typical** (Wildstalker, agreement 70% on 22 contested talents, 1 run it exactly):

`CkGAAAAAAAAAAAAAAAAAAAAAAMMmZZMjZmxsNMMmNjNbzAAAAAAAAAAgFDNbzw0MDwsYmZmZxwDMAAAAAMAAzAAAAAgZbmtmtZ2sxMzMYmZD0MAAzMAMA`

**Most common other builds**, each against the typical:

- 20 (3.0%): +Astral Influence, +Circle of the Wild, +Entangling Vortex, +Fluid Form, +Grievous Wounds, +Harmonious Blooming, +Killer Instinct 2/2, +Liveliness, +Rake, +Resilient Flourishing, +Rip, +Swipe, +Verdant Infusion; -Circle of the Heavens, -Feline Swiftness, -Flower Walk, -Innervate, -Master Shapeshifter, -Matted Fur 2/2, -Moonkin Form, -Nurturing Dormancy, -Prosperity, -Root Network, -Starfire, -Starsurge, -Sunfire
  `CkGAAAAAAAAAAAAAAAAAAAAAAMMmZZMjZmxsNMMmFmFbzAAAAAAAAAAglBNbmx0MjZMmFzMzYZGeADAAAAAAAGAAAAAMLzs1sNziNmZGYmZB0MAAzMAMA`
- 15 (2.3%): +Call of the Elder Druid, +Reforestation, +Starlight Conduit; -Feline Swiftness, -Nurturing Dormancy, -Verdancy
  `CkGAAAAAAAAAAAAAAAAAAAAAAMMmZZMjZmxsNmZwshNbzAAAAAAAAAAgFDNbzw0MDwsYmZGLGegBAAAAgBAYGAAAAAMbzs1sNzmNmZmZYmZD0MAAzMAMA`
- 12 (1.8%): +Astral Influence, +Call of the Elder Druid, +Dream of Cenarius, +Fluid Form, +Harmonious Blooming, +Matted Fur 1/2, +Resilient Flourishing, +Starlight Conduit, +Thriving Vegetation 1/2; -Innervate, -Matted Fur 2/2, -Nurturing Dormancy, -Root Network, -Thriving Vegetation 2/2, -Typhoon, -Verdancy
  `CkGAAAAAAAAAAAAAAAAAAAAAAMMmZZMjZmxsNz8AwsxsZbGAAAAAAAAAAsYoZbMmmZAmFzMzMLGeADAAAAgBAYGAAAAAMbzs1sNziNmZmHYYmZD0MAAzMAMA`
- 12 (1.8%): +Astral Influence, +Forestwalk 2/2, +Starlight Conduit, +Tiger Dash; -Forestwalk 1/2, -Innervate, -Moonkin Form, -Sunfire, -Wild Charge
  `CkGAAAAAAAAAAAAAAAAAAAAAAMMmZZMjZmxsNMMmNjNbzAAAAAAAAAAgNDNbmx0MDwsYmZmZxwAAAAAgBAwAAAAAgZbmtmtZ2sxMzMDzMbgmBAYmBgB`

**Split talents:** Overgrowth (choice) 89%; Typhoon 87%; Incapacitating Roar (choice) 84%; Flower Walk (choice) 82%; Harmonious Constitution (choice) 82%; Ursine Vigor 77%; Master Shapeshifter (choice) 77%; Starfire 76%; Matted Fur 76%; Feline Swiftness 71%; Heart of the Wild 70%; Moonkin Form 68%; Starsurge 67%; Sunfire 67%; Wild Charge (choice) 67%; Circle of the Heavens (choice) 65%; Starlight Conduit 64%; Innervate 64%; Verdancy 61%; Root Network (choice) 60%; Fluid Form 51%; Nurturing Dormancy 48%; Harmonious Blooming 46%; Astral Influence 44%; Tiger Dash (choice) 33%; Resilient Flourishing (choice) 32%; Killer Instinct 28%; Rake 28%; Rip 28%; Circle of the Wild (choice) 25%; Grievous Wounds 24%; Liveliness (choice) 23%; Reforestation 23%; Call of the Elder Druid 22%; Swipe 18%; Nature's Bounty 18%; Perfectly-Honed Instincts 16%; Dream of Cenarius 12%; Bond with Nature (choice) 11%; Entangling Vortex (choice) 10%

**Ours, against the whole sample:**

- `Dungeon`: no one in the sample runs it exactly. Typical has +Root Network; lacks Resilient Flourishing.

## Augmentation Evoker

### Raid

971 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 494 distinct builds. Hero tree: Chronowarden 100%.

**Typical** (Chronowarden, agreement 64% on 11 contested talents, 1 run it exactly):

`CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzgBzMLzMzMjZAAAAAAAAgZGMDGTNzMzMAAAAYGzMjZmlxMDMziBGzYhFYgZYoBWwYMzAAD`

**Most common other builds**, each against the typical:

- 11 (1.1%): +Attuned to the Dream 2/2, +Inferno's Blessing, +Mighty Inferno; -Clairvoyant, -Foci of Life, -Tomorrow, Today, -Unravel
  `CEcBAAAAAAAAAAAAAAAAAAAAAMmZmZbmZGMYmZZmZMjZAAAAAAAAgZGjZwYqxMzMAAAAYGzYMzsMmZgZYgxMWYBGYGGagFMzYmBAG`
- 10 (1.0%): +Exuberance, +Inferno's Blessing, +Mighty Inferno; -Cauterizing Flame, -Clairvoyant, -Tomorrow, Today
  `CEcBAAAAAAAAAAAAAAAAAAAAAMmZmZbmZGMYmZZmZMjZAAAAAAAAgZGYYGTNzMzMAAAAYGzMjZmlxMDMDDMmxCLwAzwQDsgZGzMAwA`
- 10 (1.0%): +Attuned to the Dream 1/2, +Chrono Ward; -Arcane Reach, -Unravel
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzgBzMLzYmZMzGAAAAAAAAmZ8AmBjpGzMzAAAAgZMzMmZWGzMwMLGYMjFWgBmhhGYBjxMDAM`
- 10 (1.0%): +Attuned to the Dream 2/2, +Chrono Ward, +Overlord; -Arcane Reach, -Foci of Life, -Tomorrow, Today, -Unravel
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzgZYmZZGzMjZ2AAAAAAAAwMjxMYM1YmZGAAAAMjZMmZWGzMwMMwYGLsADMDDNwCGjZGAYA`

**Split talents:** Scarlet Adaptation 84%; Draconic Attunements 83%; Improved Defy Fate 78%; Quell 74%; Tailwind 74%; Cauterizing Flame 62%; Arcane Reach 60%; Clairvoyant 58%; Attuned to the Dream 54%; Unravel 46%; Foci of Life 45%; Inferno's Blessing 44%; Mighty Inferno 43%; Chrono Ward (choice) 42%; Twin Guardian 41%; Tomorrow, Today (choice) 38%; Exuberance 28%; Bestow Weyrnstone 28%; Ancient Flame 21%; Overlord 20%; Blistering Scales 19%; Regenerative Chitin (choice) 17%

**Ours, against the whole sample:**

- `Raid`: 11 of 971 run it exactly. Typical has +Clairvoyant, +Foci of Life, +Tomorrow, Today, +Unravel; lacks Attuned to the Dream 2/2, Inferno's Blessing, Mighty Inferno.

### Mythic+

685 rankings over 8 dungeons, logged 2026-09-02 to 2026-10-18, keys 17 to 21 (median 18). 318 distinct builds. Hero tree: Chronowarden 92%, Scalecommander 8%. 114 left out: their log has no talents. 1 refused: unknown talents or not 34/34/13 points.

**Typical** (Chronowarden, agreement 72% on 15 contested talents, 21 run it exactly):

`CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzMzyMYmlZYmxMAAAAAAAAwMwMzYM1YmZGAAAAYmZMmZWGzMwMbGYMjFWgBmhhGYBMzMDAM`

**Most common other builds**, each against the typical:

- 14 (2.0%): +Enkindled 1/2, +Scarlet Adaptation; -Enkindled 2/2
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzMbzMzMzyMYmlZYmxMAAAAAAAAwMw8AzYM1YmZGAAAAMzMjxMzyYmBmZzAjZswCMwMM0ALgZmZAgB`
- 13 (1.9%): +Ancient Flame, +Attuned to the Dream 2/2, +Chrono Ward; -Clobbering Sweep, -Overawe, -Power Nexus, -Terror of the Skies
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzYbmZmZWmBzsMDzMmZDAAAAAGAAYGGzYMmaMzMDAAAAMmxYmZZMzAzsZgxMWYBGYGGagFwYmBAG`
- 12 (1.8%): +Attuned to the Dream 2/2, +Chrono Ward, +Scarlet Adaptation; -Clobbering Sweep, -Overawe, -Power Nexus, -Terror of the Skies
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzYbmZmZWmBzsMDzMmZDAAAAAAAAzwYGjxUjZmZAAAAwMmxYmZZMzAzsZgxMWYBGYGGagFwYmBAG`
- 12 (1.8%): +Chrono Ward; -Power Nexus
  `CEcBAAAAAAAAAAAAAAAAAAAAAMMzYbmZmZWmBzsMDzMmZDAAAAAAAAzAzMjxUjZmZAAAAgZmxYmZZMzAzsZgxMWYBGYGGagFwMzMAwA`

**Split talents:** Blistering Scales 86%; Regenerative Chitin (choice) 85%; Enkindled 84%; Time Spiral (choice) 84%; Stretch Time 82%; Improved Defy Fate 80%; Clairvoyant 76%; Reactive Hide 76%; Interwoven Threads (choice) 75%; Overlord 70%; Clobbering Sweep 68%; Attuned to the Dream 67%; Power Nexus 64%; Oppressing Roar 62%; Terror of the Skies 62%; Chrono Ward (choice) 52%; Overawe 47%; Imminent Destruction 47%; Plot the Future 37%; Scarlet Adaptation 34%; Foci of Life 28%; Draconic Attunements 21%; Ancient Flame 18%; Bestow Weyrnstone 16%; Sleep Walk 14%; Inferno's Blessing 13%; Mighty Inferno 13%; Unravel 12%; Spatial Paradox (choice) 11%

**Ours, against the whole sample:**

- `Dungeon`: no one in the sample runs it exactly. Typical has +Blistering Scales, +Enkindled 2/2, +Interwoven Threads, +Overawe, +Reactive Hide, +Regenerative Chitin; lacks Attuned to the Dream 2/2, Chrono Ward, Draconic Attunements, Imminent Destruction, Plot the Future, Scarlet Adaptation.

## Devastation Evoker

### Raid

773 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 230 distinct builds. Hero tree: Scalecommander 97%, Flameshaper 3%. 1 left out: their log has no talents.

**Typical** (Scalecommander, agreement 77% on 8 contested talents, 25 run it exactly):

`CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwMDzwMDMYMTjZmpZmx2MzMzMzMzMzAmxMzYmZZmZgBGD2glxox2AYGA2wAzMY4BA`

**Most common other builds**, each against the typical:

- 91 (11.8%): +Unravel; -Foci of Life
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwMDzwMDMYMTzMzMNzM2mZmZmZmZmZGwMmxYmZZmZgBGD2glxox2AYGA2wAzMY4BA`
- 82 (10.6%): +Terror of the Skies; -Foci of Life
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwMDzwMDMYMTjZmpZmx2MzMzMzMzMzAmZmxYmZZmZgBGD2glxox2AYGA2wAzMY4BA`
- 45 (5.8%): +Strike from Above; -Tailwind
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwMDzwMgBjZaMzMNzM2mZmZmZmZmZGwMmZGzMLzMDMwYwGsMGN2GAzAwGGYmBz4BA`
- 19 (2.5%): +Unravel; -Tailwind
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwMDzwMgBjZamZmpZmx2MzMzMzMzMzAmxMzYmZZmZgBGD2glxox2AYGA2wAzMY4BA`

**Split talents:** Eternity's Span 90%; Scarlet Adaptation 88%; Font of Magic 87%; Iridescence 87%; Star Salvo 84%; Tailwind 55%; Foci of Life 38%; Unravel 38%; Terror of the Skies 28%; Strike from Above 19%; Cauterizing Flame 17%; Power Nexus 12%; Twin Guardian 11%; Ancient Flame 10%

**Ours, against the whole sample:**

- `Raid`: the typical build. 25 of 773 run it exactly.

### Mythic+

670 rankings over 8 dungeons, logged 2026-08-24 to 2026-10-18, keys 18 to 21 (median 18). 292 distinct builds. Hero tree: Scalecommander 96%, Flameshaper 4%. 130 left out: their log has no talents.

**Typical** (Scalecommander, agreement 78% on 12 contested talents, 58 run it exactly):

`CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwgZGmBGzYMTjZmpZmZ2mZmZmZmZmZGgZmxYmZZmZgBGD2glxox2AYGA2wMYmBDPA`

**Most common other builds**, each against the typical:

- 33 (4.9%): +Scarlet Adaptation; -Terror of the Skies
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwgZGmBGzYMTjZmpZmZ2mZmZmZmZmZGwMmxYmZZmZgBGD2glxox2AYGA2wMYmBDPA`
- 24 (3.6%): +Foci of Life, +Scarlet Adaptation; -Oppressing Roar, -Overawe
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwgZGmBGYMTjZmpZmZ2mZmZmZmZmZGwMzMzYmZZmZgBGD2glxox2AYGA2wMYmBDPA`
- 18 (2.7%): +Foci of Life; -Terror of the Skies
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwgZGmBGzYMTjZmpZmZ2mZmZmZmZmZGgxMzYmZZmZgBGD2glxox2AYGA2wMYmBDPA`
- 14 (2.1%): +Sleep Walk; -Terror of the Skies
  `CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjZwgZGmBzYGjZaMzMNzMz2MzMzMzMzMzAMmxYmZZmZgBGD2glxox2AYGA2wMYmBDPA`

**Split talents:** Rescue 89%; Regenerative Magic 85%; Slipstream (choice) 84%; Font of Magic 84%; Time Spiral (choice) 84%; Clobbering Sweep 84%; Iridescence 83%; Star Salvo 81%; Oppressing Roar 66%; Terror of the Skies 63%; Overawe 54%; Scarlet Adaptation 41%; Foci of Life 33%; Enkindled 24%; Unravel 21%; Sleep Walk 21%; Attuned to the Dream 14%; Nimble Flyer (choice) 12%; Heat Wave 10%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 58 of 670 run it exactly.

## Preservation Evoker

### Raid

995 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 446 distinct builds. Hero tree: Flameshaper 100%.

**Typical** (Flameshaper, agreement 68% on 9 contested talents, 2 run it exactly):

`CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAMzMDmZMYGzmhZmZbYAAgZMjZMGzImZAAAAmZGZGzMmlZmBAzYGYDsAmhJwmhNDDgZmxA`

**Most common other builds**, each against the typical:

- 30 (3.0%): +Spark of Insight, +Time of Need, +Unravel; -Life-Giver's Flame, -Oppressing Roar, -Temporal Artificer
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAYmZwMjBzY2mhxMbzYAAgZMjZwYGNmZAAAAmZGZGzMmlZmBAzYGYDsAmhJwmhNDDgZmxA`
- 23 (2.3%): +Lifecinders, +Unravel; -Draconic Instincts, -Oppressing Roar
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAMzMDmZMYGzmhZmZbYAAgZMjZwYGNmZAAAAmZGZGzMmlZmBAzYGYBsAmhJwmhNDDgZmxA`
- 22 (2.2%): +Unravel; -Oppressing Roar
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAMzMDmZMYGzmhZmZbYAAgZMjZwYGNmZAAAAmZGZGzMmlZmBAzYGYDsAmhJwmhNDDgZmxA`
- 21 (2.1%): +Stretch Time; -Oppressing Roar
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAMzMDmZMYGzmhZmZbYAAgZMjZwYGZmZAAAAmZGZGzMmlZmBAzYGYDsAmhJwmhNDDgZmxA`

**Split talents:** Ancient Flame 87%; Titan's Gift 78%; Temporal Artificer 68%; Blast Furnace 63%; Draconic Instincts (choice) 58%; Life-Giver's Flame 57%; Lifecinders (choice) 42%; Extended Flight 41%; Oppressing Roar 41%; Unravel 30%; Stretch Time 27%; Time of Need 27%; Spark of Insight 27%; Flow State 22%; Foci of Life 22%; Tailwind 17%; Ouroboros 17%; Exuberance 15%; Scarlet Adaptation 13%

**Ours, against the whole sample:**

- `Raid`: the typical build. 2 of 995 run it exactly.

### Mythic+

666 rankings over 8 dungeons, logged 2026-09-03 to 2026-10-18, keys 19 to 22 (median 20). 361 distinct builds. Hero tree: Flameshaper 97%, Chronowarden 3%. 134 left out: their log has no talents.

**Typical** (Flameshaper, agreement 70% on 13 contested talents, 8 run it exactly):

`CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAmZmZ2WGzYYMPwsZGw2wAAAzYGzMjhZiZmBAAAMzMTGzMjZZMDAMmBWAbgZYCsZGbGmBYmhB`

**Most common other builds**, each against the typical:

- 15 (2.3%): +Draconic Instincts, +Extended Flight 2/2, +Flow State 2/2, +Time Lord 2/2, +Unravel; -Bountiful Bloom, -Clobbering Sweep, -Field of Dreams, -Flow State 1/2, -Fluttering Seedlings 2/2, -Foci of Life, -Lifecinders
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAmZmZ2WGYYmZmNzA2GGAAYGGzMjhZaMzMAAAgZmZywMzMLjZAgxMwGYDMDTgNzYzwAYmhB`
- 14 (2.1%): +Flow State 2/2, +Terror of the Skies; -Clobbering Sweep, -Flow State 1/2, -Titan's Gift
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAmZmZ2WGzYYMzsZGw2wAAAzYGzMjhZiZmBAAAMzMTzYmZMLjZAgxMwCYDMDTgNGbGGAzMMA`
- 10 (1.5%): +Draconic Instincts, +Extended Flight 2/2, +Flow State 2/2, +Terror of the Skies, +Time Lord 2/2, +Unravel; -Bountiful Bloom, -Field of Dreams, -Flow State 1/2, -Fluttering Seedlings 2/2, -Foci of Life, -Lifecinders, -Oppressing Roar, -Overawe
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAmZmZ2WGYYmZmNzA2GGAAYGGzghZaMzMAAAgZmZaGmZmZZMDAMmB2AbgZYCsZGbGmBYmhB`
- 10 (1.5%): +Flow State 2/2, +Sleep Walk, +Terror of the Skies, +Trailblazer; -Ancient Flame, -Flow State 1/2, -Foci of Life, -Shape of Flame, -Titan's Gift
  `CwbBAAAAAAAAAAAAAAAAAAAAAAAAAAAmZmZ2WGzYYMzsZGw2AAAYGzMzMjhZiZmBAAAMzMTzwMjZZMDAMmBWALgZYCsxYzwMAzMMA`

**Split talents:** Fluttering Seedlings 88%; Bountiful Bloom 88%; Field of Dreams 87%; Scarlet Adaptation 84%; Flow State 83%; Ancient Flame 78%; Oppressing Roar 76%; Time Spiral (choice) 73%; Shape of Flame (choice) 69%; Overawe 64%; Titan's Gift 60%; Clobbering Sweep 58%; Foci of Life 53%; Extended Flight 49%; Terror of the Skies 33%; Trailblazer (choice) 28%; Stretch Time 24%; Unravel 20%; Protracted Talons 18%; Just in Time (choice) 17%; Regenerative Magic 17%; Exhilarating Burst 15%; Time Lord 14%; Sleep Walk 13%

**Ours, against the whole sample:**

- `Dungeon`: 5 of 666 run it exactly. Typical has +Flow State 1/2, +Titan's Gift; lacks Flow State 2/2.

## Beast Mastery Hunter

### Raid

793 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 441 distinct builds. Hero tree: Pack Leader 100%.

**Typical** (Pack Leader, agreement 66% on 14 contested talents, 1 run it exactly):

`C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzsMzwMzMjZGMzYmhZGzMzwMzYGzgx0MAAAAAAAAYmZGAzsBgZBsNAA`

**Most common other builds**, each against the typical:

- 20 (2.5%): +Bloody Frenzy, +Dire Command, +Dire Frenzy 2/2, +Huntmaster's Call, +Shell Wall, +Trailblazer, +Wildspeaker; -Beast Cleave, -Intimidation, -Kill Cleave, -Laceration, -Misdirection, -Training Expert 2/2, -Wild Thrash
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGGzsMzwMmZMDzMGzMMzYmZGmxYGzghmBAAAAMDAAAzMzAYmNgZxsA2GAG`
- 18 (2.3%): +Bloody Frenzy, +Dire Beast, +Dire Command, +Dire Frenzy 2/2, +Huntmaster's Call, +Shell Wall, +Wildspeaker; -Beast Cleave, -Kill Cleave, -Laceration, -Misdirection, -Razor Sharp, -Training Expert 2/2, -Wild Thrash
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGGzsMzwMmZYYmxYmxMzYmZGmZGzYGM0MAAAAgZAAAYmZGAzsBMMLgtBgB`
- 15 (1.9%): +Bloody Frenzy, +Dire Command, +Dire Frenzy 2/2, +Huntmaster's Call, +Shell Wall, +Wildspeaker; -Beast Cleave, -Kill Cleave, -Laceration, -Misdirection, -Training Expert 2/2, -Wild Thrash
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGGzsMzwMmZMDzMGzMMzYmZGmZGzYGM0MAAAAgZAAAYmZGAzsBMMLgtBgB`
- 11 (1.4%): +Bloody Frenzy, +Dire Beast, +Dire Command, +Dire Frenzy 2/2, +Huntmaster's Call, +Kindling Flare, +Tranquilizing Shot, +Wildspeaker; -Beast Cleave, -Intimidation, -Kill Cleave, -Laceration, -Misdirection, -Razor Sharp, -Training Expert 2/2, -Wild Thrash
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGGzsMzwMmZYYmxYmxMzYmZGmxYGzghmZAAAAgZAAAYmZGDYmNAMLgtBgB`

**Split talents:** Scout's Instincts 87%; Emergency Salve 84%; Disruptive Rounds 83%; Razor Sharp 83%; Bloody Frenzy 81%; Improved Feign Death 78%; Intimidation 69%; Wild Thrash 59%; Laceration 59%; Beast Cleave 59%; Training Expert 59%; Kill Cleave 58%; Catlike Reflexes 55%; Misdirection 50%; Shell Wall 45%; Tranquilizing Shot 42%; Dire Frenzy 41%; Dire Command 41%; Wildspeaker 41%; Huntmaster's Call 41%; Binding Shot 40%; Guttural Roar (choice) 33%; Trailblazer (choice) 27%; Tar Trap (choice) 18%; Dire Beast 17%; Camouflage 12%; Kodo Tranquilizer (choice) 11%; Aspect of the Beast 10%

**Ours, against the whole sample:**

- `Raid`: no one in the sample runs it exactly. Typical has +Catlike Reflexes, +Kill Cleave; lacks Binding Shot, Bloody Frenzy.

### Mythic+

685 rankings over 8 dungeons, logged 2026-09-08 to 2026-10-18, keys 20 to 23 (median 21). 210 distinct builds. Hero tree: Pack Leader 100%. 115 left out: their log has no talents.

**Typical** (Pack Leader, agreement 71% on 6 contested talents, 24 run it exactly):

`C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzsMzwMzMjZGMzYmhZGzMzYzMjZMDGTzAAAAAAAAgZGjBMzGAmFw2AA`

**Most common other builds**, each against the typical:

- 39 (5.7%): +Camouflage; -Scout's Instincts
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzsMzwMzMjZGMzYmhZGzMzYzMjZMDGTzAAAAAAAAAzYMgZ2AYmFw2AA`
- 36 (5.3%): +Kodo Tranquilizer; -Scout's Instincts
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzsMzwMzMjZGMzYmhZGzMzYzMjZMDLjpZAAAAAAAAgZMGwMbAYWAbDAA`
- 28 (4.1%): +Binding Shot; -Guttural Roar
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzsMzwMzMjZGMzYmhZGzMzgZGzYGMmmBAAAAAAAAzMmZAzsBgZBsNAA`
- 22 (3.2%): +Trailblazer; -Guttural Roar
  `C0PAAAAAAAAAAAAAAAAAAAAAAAMmxwCsAzwQDbAAYGzMzsMzwMzMjZGMzYmhZGzMzgZGzYGMmmBAAAAAAAAzMGDYmNALmFw2AA`

**Split talents:** Tranquilizing Shot 88%; Misdirection 69%; Guttural Roar (choice) 62%; Scout's Instincts 43%; Disruptive Rounds 38%; Kodo Tranquilizer (choice) 33%; Camouflage 30%; Binding Shot 20%; Aspect of the Beast 18%; Shell Wall 18%

**Ours, against the whole sample:**

- `Dungeon`: 15 of 685 run it exactly. Typical has +Scout's Instincts; lacks Disruptive Rounds.

## Marksmanship Hunter

### Raid

1000 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 395 distinct builds. Hero tree: Sentinel 100%.

**Typical** (Sentinel, agreement 68% on 8 contested talents, 9 run it exactly):

`C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmZxMmZGzgx0MGMbbbzMzMzMzMDmZZYmBAAMmZAgZsxwAsxMbzYA`

**Most common other builds**, each against the typical:

- 22 (2.2%): +Improved Feign Death 1/2, +Trailblazer; -Intimidation, -Tar Trap
  `C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmhZMzMmBjpZMY222mZmZmZmZGYWGmZAAAzDMzAAzYjZxAsxMbzYA`
- 19 (1.9%): +Binding Shot, +Camouflage, +Kill Shot; -Accuracy By Volume, -Shell Wall, -Tar Trap
  `C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmhZMzMmBjpZMY222mZmZmZmZGMzywMAAAjZmxAYGbwMAbMz2MG`
- 17 (1.7%): +Improved Feign Death 2/2, +Trailblazer; -Disruptive Rounds, -Intimidation, -Tar Trap
  `C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmBjZmxMYMNjBz222MzMzMzMzAzywMDAAYmZGAYGbMLGgNmZbGD`
- 17 (1.7%): +Improved Feign Death 1/2, +Roar of Sacrifice, +Trailblazer; -Emergency Salve, -Guardian's Hide, -Tar Trap
  `C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmxMMjZmxMYMNjBz222MzMzMzMzgZWGmZAAAzDMzAAzYjZxAswMbzYA`

**Split talents:** Catlike Reflexes 89%; Emergency Salve 79%; On Target (choice) 79%; Guardian's Hide (choice) 78%; Accuracy By Volume 74%; Shell Wall 57%; Intimidation 54%; Improved Feign Death 52%; Kill Shot 44%; Binding Shot 38%; Trailblazer (choice) 32%; Tar Trap (choice) 30%; Roar of Sacrifice (choice) 21%; Guttural Roar (choice) 19%; Camouflage 19%; Horsehair Tether (choice) 13%; Tranquilizing Shot 12%

**Ours, against the whole sample:**

- `Raid`: 4 of 1000 run it exactly. Typical has +On Target; lacks Kill Shot.

### Mythic+

655 rankings over 8 dungeons, logged 2026-08-24 to 2026-10-18, keys 18 to 22 (median 18). 199 distinct builds. Hero tree: Sentinel 96%, Dark Ranger 4%. 145 left out: their log has no talents.

**Typical** (Sentinel, agreement 65% on 8 contested talents, 13 run it exactly):

`C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmx2MmZGzwyYaGDmlttZmZmZmZmZhZWGmBAAwDMGDAzYDMAbMz2MG`

**Most common other builds**, each against the typical:

- 60 (9.2%): +Open Fire; -Stargazer
  `C4PAAAAAAAAAAAAAAAAAAAAAAwGMwMGNWGAzgNAAAAAAAAwMmZmx2MmZGzwyYaGDmlttZmZmZmZmZhZWGmBAAwDMGDAzYDMAbMz2MG`
- 36 (5.5%): +Improved Feign Death 2/2; -Disruptive Rounds, -Improved Feign Death 1/2
  `C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmxmxMzYGWGTzYwsstNzMzMzMzMLMzywMAAAmxYAYGbgBYjZ2mxA`
- 33 (5.0%): +Obsidian Arrowhead, +Open Fire; -On Target, -Stargazer
  `C4PAAAAAAAAAAAAAAAAAAAAAAwGMwMGNWGAzgNAAAAAAAAwMmZmx2MmZGzwyYaGDmltlZmZmZmZmZhZWGmBAAwDMGDAzYDMAbMz2MG`
- 25 (3.8%): +Accuracy By Volume; -Tenacious
  `C4PAAAAAAAAAAAAAAAAAAAAAAwCMwMGNWGAzgNAAAAAAAAwMmZmx2MmZGzwyYaGDmlttZmZmZmZmBzsMMzAAA8AjxAwM2ADwGzsNjB`

**Split talents:** Improved Feign Death 89%; Unerring Vision (choice) 88%; Guttural Roar (choice) 87%; Disruptive Rounds 70%; Tenacious (choice) 61%; Stargazer (choice) 60%; On Target (choice) 55%; Kodo Tranquilizer (choice) 53%; Accuracy By Volume 46%; Open Fire (choice) 36%; Obsidian Arrowhead (choice) 24%; Camouflage 21%; Scout's Instincts 19%; Calling the Shots (choice) 12%; Kill Shot 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 13 of 655 run it exactly.

## Survival Hunter

### Raid

576 rankings over 10 bosses, logged 2026-10-13 to 2026-10-18. 293 distinct builds. Hero tree: Sentinel 86%, Pack Leader 14%.

**Typical** (Sentinel, agreement 79% on 27 contested talents, 4 run it exactly):

`C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGwmxMzYYZAAAAAAYGzMzwMGzYGMmmBAAAYAwMWWmZmFmZmZMzYAYGLYxYMzsZAA`

**Most common other builds**, each against the typical:

- 62 (10.8%): +Improved Feign Death 2/2, +Shell Wall; -Disruptive Rounds, -Emergency Salve, -Tranquilizing Shot
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGwmxMzYYZAAAAAAYGzYGMGzYGMmmBAAAYAwMWWmZmFmZmZmZGAYGLMLGjZmNDA`
- 12 (2.1%): +Improved Feign Death 2/2, +Shell Wall; -Disruptive Rounds, -Trailblazer, -Tranquilizing Shot
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGwmxMzYYZAAAAAAYGzMzgxYGzgx0MAAAADAmxyyMzswMzMzMzAAzYhhxYmZzAA`
- 11 (1.9%): +Improved Feign Death 2/2, +Shell Wall; -Disruptive Rounds, -Intimidation, -Tranquilizing Shot
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGwmxMzYYZAAAAAAYGzMzgxYGzgx0MAAAAAwMWWmZmFmZmZmZGAYGLMLGjZmNDA`
- 10 (1.7%): +Shell Wall, +Shellshock; -Catlike Reflexes, -Two Against Many
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGwmxMzYYZAAAAAAYGzMzwMGzYGMmmBAAAYAwMWWmZmFzMzMjxYAYGLMLGjZsZAA`

**Split talents:** Guardian's Hide (choice) 89%; Sic 'Em 88%; Flanked 87%; Sanctified Armaments 86%; Radiant Edge 86%; Moonlight Chakram 86%; Moon's Blessing 86%; Lunar Storm 86%; Lunar Calling 86%; Invigorating Pulse 86%; Don't Look Back 86%; Can't Miss, Won't Miss 86%; Arcane Talons 86%; Stargazer (choice) 86%; Conditioning (choice) 86%; Bloody Claws (choice) 85%; Twin Fangs 85%; Savagery 84%; Intimidation 80%; Emergency Salve 73%; Twilight Requiem (choice) 72%; Two Against Many 69%; Disruptive Rounds 67%; Catlike Reflexes 66%; Improved Feign Death 56%; Shell Wall 52%; Trailblazer (choice) 50%; Tranquilizing Shot 37%; Shellshock 34%; Binding Shot 26%; Guttural Roar (choice) 21%; Lethal Calibration 19%; Flanker's Advantage 18%; Explosives Expert 18%; Bombardier 16%; Wallop (choice) 15%; Stalk and Strike (choice) 14%; Stampede! 14%; Shell Cover 14%; Sharpened Fangs 14%; Pack Mentality 14%; No Mercy 14%; Lethal Barbs 14%; Hogstrider 14%; Fury of the Wyvern 14%; Dire Summons 14%; Better Together 14%; Wyvern's Gaze (choice) 14%; Slicked Shoes (choice) 13%; Tar Trap (choice) 12%; Wilderness Medicine 11%; Roar of Sacrifice (choice) 11%

**Ours, against the whole sample:**

- `Raid`: 12 of 576 run it exactly. Typical has +Disruptive Rounds, +Trailblazer, +Tranquilizing Shot; lacks Improved Feign Death 2/2, Shell Wall.

### Mythic+

672 rankings over 8 dungeons, logged 2026-08-28 to 2026-10-18, keys 18 to 23 (median 19). 257 distinct builds. Hero tree: Sentinel 79%, Pack Leader 21%. 128 left out: their log has no talents.

**Typical** (Sentinel, agreement 74% on 27 contested talents, 19 run it exactly):

`C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGw2MzMzYMbzAAAAAAYGzMzYbGjZMDGTzAAAAMAwYZZmxCmZGzYMAMjNwYMzsZAA`

**Most common other builds**, each against the typical:

- 22 (3.3%): +Flamebreak, +Flanker's Advantage, +Grenade Juggler, +Scout's Instincts, +Shellshock, +Trailblazer; -Flanked, -Improved Feign Death 2/2, -Shrapnel Bomb, -Sic 'Em, -Twin Fangs
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGw2MzMzYmZbGAAAAAAzYmZGbzYMjZwYaGAAAgBAYZbmxyMmZMGjBgZshFjhZ2MAA`
- 20 (3.0%): +Bloodseeker, +Improved Feign Death 1/2, +Improved Wildfire Bomb 1/2, +Kodo Tranquilizer; -Improved Feign Death 2/2, -Improved Wildfire Bomb 2/2
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGw2MzMzMjZbeAAAAAAAzYmZGbzYMjZYZMNDAAAwAAjllZGLYmZ8AjxAwM2AjxMzmBA`
- 20 (3.0%): +Better Together, +Bloodseeker, +Dire Summons, +Flanker's Advantage, +Fury of the Wyvern, +Hogstrider, +Kodo Tranquilizer, +Lethal Barbs, +No Mercy, +Pack Leader, +Pack Mentality, +Razor Edge 2/2, +Savagery 2/2, +Sharpened Claws, +Sharpened Fangs, +Shell Cover, +Slicked Shoes, +Stampede!, +Sweeping Spear 1/2, +Vulnerability, +Wyvern's Gaze; -Arcane Talons, -Blackrock Munitions, -Bombardier, -Can't Miss, Won't Miss, -Conditioning, -Disruptive Rounds, -Don't Look Back, -Explosives Expert 2/2, -Improved Wildfire Bomb 2/2, -Invigorating Pulse, -Lunar Calling, -Lunar Storm, -Moon's Blessing, -Moonlight Chakram, -Radiant Edge, -Sanctified Armaments, -Sentinel, -Sic 'Em, -Stalk and Strike, -Stargazer, -Twin Fangs
  `C8PAAAAAAAAAAAAAAAAAAAAAAMgxMG2gFYGGawiZmZmZGLDAAAAAAzYmZGbGjZMDLjpZAAAAGAMssMz8ALMzMMjxAmZDAjxMzmBA`
- 18 (2.7%): +Improved Feign Death 1/2, +Kodo Tranquilizer; -Improved Feign Death 2/2
  `C8PAAAAAAAAAAAAAAAAAAAAAAMWgBmxoxyAYGw2MzMzYMbzAAAAAAYGzMzYbGjZMDLjpZAAAAGAYssMzYBzMjHYMGAmxGYMmZ2MAA`

**Split talents:** Pathfinding 86%; Guttural Roar (choice) 85%; Guardian's Hide (choice) 80%; Stargazer (choice) 79%; Sanctified Armaments 79%; Radiant Edge 79%; Moonlight Chakram 79%; Moon's Blessing 79%; Lunar Storm 79%; Lunar Calling 79%; Invigorating Pulse 79%; Don't Look Back 79%; Can't Miss, Won't Miss 79%; Arcane Talons 79%; Conditioning (choice) 78%; Stalk and Strike (choice) 78%; Improved Wildfire Bomb 78%; Explosives Expert 78%; Bombardier 78%; Blackrock Munitions (choice) 78%; Improved Feign Death 77%; Disruptive Rounds 66%; Shrapnel Bomb (choice) 62%; Flanked 60%; Flanker's Advantage 59%; Twin Fangs 55%; Sic 'Em 46%; Kodo Tranquilizer (choice) 42%; Grenade Juggler 40%; Bloodseeker 39%; Flamebreak (choice) 38%; Razor Edge 23%; Savagery 22%; Vulnerability (choice) 22%; Wyvern's Gaze (choice) 21%; Stampede! 21%; Shell Cover 21%; Sharpened Fangs 21%; Pack Mentality 21%; No Mercy 21%; Lethal Barbs 21%; Hogstrider 21%; Fury of the Wyvern 21%; Dire Summons 21%; Better Together 21%; Slicked Shoes (choice) 21%; Scout's Instincts 20%; Sharpened Claws (choice) 20%; Roar of Sacrifice (choice) 20%; Shellshock 18%; Sweeping Spear 18%; Devilsaur Tranquilizer (choice) 17%; Camouflage 17%; Shell Wall 13%; Trailblazer (choice) 10%

**Ours, against the whole sample:**

- `Dungeon`: 3 of 672 run it exactly. Typical has +Flanked, +Shrapnel Bomb, +Sic 'Em, +Twin Fangs; lacks Flamebreak, Flanker's Advantage, Grenade Juggler, Shellshock.

## Arcane Mage

### Raid

1000 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 341 distinct builds. Hero tree: Sunfury 100%.

**Typical** (Sunfury, agreement 75% on 6 contested talents, 98 run it exactly):

`C4DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMDamZGAAAGAwMz0sssMDAgNAAAzMDbWmxMLzYMzMzMswMmZmBAYAAAGgZGwMAYYmZA`

**Most common other builds**, each against the typical:

- 64 (6.4%): +Master of Escape; -Mana Confluence
  `C4DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMDamZGAAAGAwMz0sssMDAgNAAAzMDbWmxMLzYMzMzMswMzMzMAADAAwAMzAMAYYmZA`
- 62 (6.2%): +Master of Escape; -Captured Thoughts
  `C4DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMDamxAAAwAAmZmmlllZAAsBAAYmZYzyMmZZGjZmZmhFmZmZmBAYAAAGgZGwMAYYmZA`
- 32 (3.2%): +Master of Escape, +Master of Time 1/2; -Master of Time 2/2
  `C4DAAAAAAAAAAAAAAAAAAAAAAYGGLzMPwswMDamZGAAAGAwMz0sssMDAgNAAAzMDbWmxMLzYMzMzMswMzMzMAADAAwAMzAmBADzMD`
- 32 (3.2%): +Arcane Familiar, +Energized Familiar, +Impetus; -Aether Attunement 2/2, -Resonance
  `C4DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMDamZGAAAGAwMz0sssMDAgNAAgZmZGbWmZmZZGjxMzgFmxMzMAADAAwAMzAmBADzMD`

**Split talents:** Incantation of Swiftness 79%; Lessons in Debilitation (choice) 73%; Captured Thoughts 72%; Mana Confluence 70%; Master of Escape 66%; Explosive Potential (choice) 27%; Supernova (choice) 23%; Dragon's Breath (choice) 18%; Remove Curse 18%; Arcane Familiar 14%; Spellsteal 12%

**Ours, against the whole sample:**

- `Raid`: the typical build. 98 of 1000 run it exactly.

### Mythic+

656 rankings over 8 dungeons, logged 2026-09-18 to 2026-10-18, keys 21 to 23 (median 22). 208 distinct builds. Hero tree: Sunfury 100%. 144 left out: their log has no talents.

**Typical** (Sunfury, agreement 69% on 7 contested talents, 28 run it exactly):

`C4DAAAAAAAAAAAAAAAAAAAAAAMzwMLzMmFMzQzMzAAAwAAmZmmlllZAAsBAwGMzMsZZGzsMjxMzMzwCzMzMzAAMAAADwMDwAghZmB`

**Most common other builds**, each against the typical:

- 33 (5.0%): +Mana Bomb; -Consortium's Bauble
  `C4DAAAAAAAAAAAAAAAAAAAAAAMzwMLzMmFMzQzMzAAAwAAmZmmlllZAAsBAwGjZmhNLzYmlZMmxMzwCzMzMzAAMAAADwMDwAghZmB`
- 27 (4.1%): +Mana Bomb, +Master of Time 2/2; -Consortium's Bauble, -Remove Curse, -Spellsteal
  `C4DAAAAAAAAAAAAAAAAAAAAAAYGmZZmZmFMDamZGAAAGAwMz0sssMDAgNAA2YMzMsZZGzsMjxMmZGWYmZmZGAgBAAYAmZAGAMMzM`
- 25 (3.8%): +Master of Time 2/2; -Captured Thoughts, -Remove Curse
  `C4DAAAAAAAAAAAAAAAAAAAAAAMzwMLzMzsgZQzMGAAAGAwMz0sssMDAgNAA2gZmhNLzYmlZMmZmZGWYmZmZGAgBAAYAmZAGAMMzM`
- 25 (3.8%): +Master of Time 2/2; -Mass Invisibility, -Remove Curse
  `C4DAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMDamZGAAAGAwMz0sssMDAgNAA2gZmhNLzYmlZMmZmZGWYmZmZGAgBAAYAmZAGAMMzM`

**Split talents:** Lessons in Debilitation (choice) 84%; Captured Thoughts 83%; Master of Time 70%; Mass Invisibility 69%; Consortium's Bauble 58%; Spellsteal 54%; Remove Curse 51%; Mana Confluence 42%; Mana Bomb 41%; Explosive Potential (choice) 16%

**Ours, against the whole sample:**

- `Dungeon`: 10 of 656 run it exactly. Typical has +Consortium's Bauble, +Remove Curse; lacks Mana Bomb, Mana Confluence.

## Fire Mage

### Raid

299 rankings over 10 bosses, logged 2026-10-13 to 2026-10-18. 114 distinct builds. Hero tree: Sunfury 100%, Frostfire 0%. 1 left out: their log has no talents.

**Typical** (Sunfury, agreement 69% on 8 contested talents, 17 run it exactly):

`C8DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMzIzMzAAAwAAmZmmlttZAA2MzM2mZmZGLAAAAAYxMzMDAAMjxMzMjZmlBgZGgxAmhxA`

**Most common other builds**, each against the typical:

- 29 (9.7%): +Improved Counterspell; -Master of Escape
  `C8DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMzIzMzAAAwAAmZmmlttZAA2MzM2mZmZGLAAAAAYxMjZAAgZMmZmZMzsMAMzAjxAmhxA`
- 25 (8.4%): +Flamestrike, +Improved Counterspell; -Flamestrike, -Master of Escape
  `C8DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMzIzMzAAAwAAmZmmlttZAA2MzM2mZmZGLAAAAAYxMjZAAgZMmZmZMzsNAMzAjxAmhxA`
- 11 (3.7%): +Spellsteal, +Supernova, +Time Manipulation; -Dragon's Breath, -Incantation of Swiftness 2/2
  `C8DAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzIzMzMAAAGAwMz0sstNDAwmZmx2MzMzYDAAAAALmZmZAAgZMmZmZMzsMAMzAMGwMMGA`
- 8 (2.7%): +Improved Counterspell, +Lessons in Debilitation, +Supernova; -Dragon's Breath, -Explosive Potential, -Master of Escape
  `C8DAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMzIzMzAAAwAAmZmmltlZAA2MzM2mZmZGbAAAAAYxMjZAAgZMmZmZMzsMAMzAjxAmhxA`

**Split talents:** Time Walk (choice) 86%; Remove Curse 83%; Captured Thoughts 82%; Incantation of Swiftness 69%; Flamestrike (choice) 65%; Explosive Potential (choice) 64%; Master of Escape 62%; Dragon's Breath (choice) 53%; Improved Counterspell 48%; Spellsteal 35%; Lessons in Debilitation (choice) 35%; Flamestrike (choice) 35%; Supernova (choice) 33%; Improved Conjuration 31%; Ring of Frost (choice) 15%; Time Manipulation 15%; Temporal Realignment (choice) 14%

**Ours, against the whole sample:**

- `Raid`: 1 of 299 run it exactly. Typical has +Dragon's Breath; lacks Improved Counterspell.

### Mythic+

582 rankings over 8 dungeons, logged 2026-08-29 to 2026-10-18, keys 17 to 22 (median 18). 266 distinct builds. Hero tree: Sunfury 100%. 218 left out: their log has no talents.

**Typical** (Sunfury, agreement 73% on 12 contested talents, 13 run it exactly):

`C8DAAAAAAAAAAAAAAAAAAAAAAMzwMLzMzsgZGZmZGAAAGAwMz0sstMDAwmZmx2MzMzYDAAAAALmZmZAAgZMmZmZMzsMAMzAMGwMMGA`

**Most common other builds**, each against the typical:

- 31 (5.3%): +Explosive Potential, +Time Manipulation; -Lessons in Debilitation, -Mass Invisibility
  `C8DAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzIzMzMAAAGAwMz0sstNDAwmZmx2MzMzYDAAAAALmZmZAAgZMmZmZMzsMAMzAMGwMMGA`
- 27 (4.6%): +Explosive Potential, +Flamestrike, +Time Manipulation; -Flamestrike, -Lessons in Debilitation, -Mass Invisibility
  `C8DAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzIzMzMAAAGAwMz0sstNDAwmZmx2MzMzYDAAAAALmZmZAAgZMmZmZMzsNAMzAMGwMMGA`
- 11 (1.9%): +Dragon's Breath, +Improved Counterspell, +Ring of Frost; -Barrier Diffusion, -Captured Thoughts, -Supernova
  `C8DAAAAAAAAAAAAAAAAAAAAAAMzYxsMzMzCmZkZGDAAADAYmZaW2WmBAYzMzYbmZmZsAAAAAgFzMzMAAwMGzMzMmZWGAmZgxYAzwYA`
- 9 (1.5%): +Fire's Ire 2/2, +Flamestrike, +Improved Conjuration 1/2, +Temporal Realignment; -Firestarter, -Flamestrike, -Heat Shimmer, -Mass Invisibility, -Time Walk
  `C8DAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzIzMzAAAwAAmZmmltlZAA2MzMz2MzMzYDAAAAAbmZmZeAAAMjxMzMjZmNAMzAMGghxA`

**Split talents:** Barrier Diffusion 90%; Spellsteal 86%; Firestarter 86%; Merely a Setback (choice) 86%; Captured Thoughts 78%; Time Walk (choice) 70%; Heat Shimmer 70%; Supernova (choice) 69%; Lessons in Debilitation (choice) 57%; Flamestrike (choice) 52%; Mass Invisibility 49%; Flamestrike (choice) 48%; Explosive Potential (choice) 43%; Time Manipulation 38%; Dragon's Breath (choice) 31%; Improved Counterspell 30%; Temporal Realignment (choice) 30%; Improved Conjuration 26%; Fire's Ire 19%; Time Twist (choice) 14%; Incantation of Swiftness 14%; Conflagration 13%; Ring of Frost (choice) 10%

**Ours, against the whole sample:**

- `Dungeon`: 4 of 582 run it exactly. Typical has +Mass Invisibility; lacks Time Manipulation.

## Frost Mage

### Raid

699 rankings over 10 bosses, logged 2026-10-13 to 2026-10-18. 324 distinct builds. Hero tree: Spellslinger 67%, Frostfire 33%.

**Typical** (Spellslinger, agreement 71% on 27 contested talents, 100 run it exactly):

`CAEAAAAAAAAAAAAAAAAAAAAAAYGGLzMzsMmZmYmZGzMzMziZmZMjZAAAgZmZWWmZaDAAAAAA2AYbZMzMDmthxMsAAAwMbAzADYGMMA`

**Most common other builds**, each against the typical:

- 30 (4.3%): +Blast Radius, +Dragon's Breath, +Dualcasting Adept, +Duality, +Elemental Affinity, +Elemental Conduit, +Flash Freezeburn, +Frostfire, +Frostfire Empowerment, +Frostfire Infusion, +Glacial Shatter, +Hailstones, +Hand of Frost 3/4, +Heat Sink, +Imbued Warding, +Isothermic Core, +Molten Chill, +Piercing Cold, +Rimecaster 2/2, +Thermal Conditioning; -Archmage's Wrath, -Augury Abounds, -Controlled Instincts, -Crystalline Refraction, -Force of Will, -Frigid Focus, -Glaciate, -Hand of Frost 4/4, -Improved Warding, -Infused Splinters, -Polished Focus, -Ray of Frost, -Reactive Barrier, -Shifting Shards, -Signature Spell, -Slippery Slinging, -Spellfrost Teachings, -Spellslinger, -Splintering Orbs, -Splinterstorm
  `CAEAAAAAAAAAAAAAAAAAAAAAAYGGLzMzsMmZmYmZGzYmZWMzMzMMzsMTzMLzCAAAsAAALAAAAAstMmZmBz2MmZGbLAAAgZGMDMgB+AA`
- 19 (2.7%): +Blast Radius, +Dragon's Breath, +Dualcasting Adept, +Duality, +Elemental Affinity, +Elemental Conduit, +Flash Freezeburn, +Frostfire, +Frostfire Empowerment, +Frostfire Infusion, +Glacial Shatter, +Hailstones, +Hand of Frost 3/4, +Heat Sink, +Imbued Warding, +Isothermic Core, +Molten Chill, +Piercing Cold, +Rimecaster 2/2, +Thermal Conditioning; -Archmage's Wrath, -Augury Abounds, -Controlled Instincts, -Crystalline Refraction, -Force of Will, -Frigid Focus, -Glaciate, -Hand of Frost 4/4, -Infused Splinters, -Master of Escape, -Polished Focus, -Ray of Frost, -Reactive Barrier, -Shifting Shards, -Signature Spell, -Slippery Slinging, -Spellfrost Teachings, -Spellslinger, -Splintering Orbs, -Splinterstorm
  `CAEAAAAAAAAAAAAAAAAAAAAAAYGGLzMzsMmZmYmZGzYmZWMzMzMMzsMTzMLzCAAAsAAALAAAAAstMmxMY2mxMzYbBAAAMzgZgBMwHwA`
- 18 (2.6%): +Improved Conjuration 2/2; -Improved Warding, -Remove Curse
  `CAEAAAAAAAAAAAAAAAAAAAAAAYGGLzMzsMmZEzMzYmZmZWMzMjZMDAAAMzMzyyMTbAAAAAAwGAbLjZmZGmthxMsAAAwMbAzADYGMA`
- 18 (2.6%): +Improved Conjuration 2/2; -Frost Conditioning, -Remove Curse
  `CAEAAAAAAAAAAAAAAAAAAAAAAYGGLzMzswMjYmZGzMzMziZmZMjZAAAgZmZWWmZaDAAAAAA2AYbZMzMzwsNMmhFAAAmZDYGYAzghB`

**Split talents:** Blizzard (choice) 89%; Incantation of Swiftness 88%; Master of Escape 86%; Time Walk (choice) 84%; Improved Warding 79%; Frost Conditioning 79%; Captured Thoughts 77%; Ray of Frost 74%; Glaciate 74%; Remove Curse 73%; Splinterstorm 67%; Splintering Orbs 67%; Spellfrost Teachings 67%; Signature Spell 67%; Shifting Shards (choice) 67%; Polished Focus 67%; Infused Splinters 67%; Force of Will 67%; Controlled Instincts 67%; Augury Abounds 67%; Archmage's Wrath 67%; Reactive Barrier (choice) 67%; Slippery Slinging (choice) 65%; Frigid Focus (choice) 64%; Crystalline Refraction 62%; Piercing Cold 41%; Rimecaster 41%; Hailstones 38%; Dragon's Breath (choice) 34%; Molten Chill 33%; Isothermic Core 33%; Imbued Warding (choice) 33%; Heat Sink 33%; Frostfire Infusion 33%; Frostfire Empowerment 33%; Flash Freezeburn 33%; Elemental Conduit 33%; Duality 33%; Dualcasting Adept 33%; Blast Radius 33%; Glacial Shatter (choice) 32%; Elemental Affinity (choice) 32%; Improved Conjuration 32%; Thermal Conditioning (choice) 28%; Supernova (choice) 19%; Temporal Realignment (choice) 16%; Time Manipulation 15%; Improved Counterspell 13%; Ring of Frost (choice) 12%; Spellsteal 11%; Blizzard (choice) 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 100 of 699 run it exactly.

### Mythic+

579 rankings over 8 dungeons, logged 2026-09-04 to 2026-10-18, keys 17 to 21 (median 18). 265 distinct builds. Hero tree: Frostfire 61%, Spellslinger 39%. 221 left out: their log has no talents.

**Typical** (Frostfire, agreement 62% on 28 contested talents, 7 run it exactly):

`CAEAAAAAAAAAAAAAAAAAAAAAAMzwMLzMzsgZmYmxYmZmZWMzMzMzMzsMTzMbzCAAAsAAAbAAAAAstMmZmBz2MmZGbLAAAgZGMDjBMAGA`

**Most common other builds**, each against the typical:

- 20 (3.5%): +Time Manipulation; -Mass Invisibility
  `CAEAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzEzMmZmZmZWMzMzMzMzsMTzMbzCAAAsAAAbAAAAAstMmZmBz2MmZGbLAAAgZGMDjBMAGA`
- 20 (3.5%): +Dragon's Breath, +Time Manipulation; -Mass Invisibility, -Supernova
  `CAEAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzEzMmZmZmZWMzMzMzMzsMTzMbzCAAAsAAALAAAAAstMmZmBz2MmZGbLAAAgZGMDjBMAGA`
- 19 (3.3%): +Captured Thoughts, +Dragon's Breath, +Temporal Realignment, +Thermal Conditioning, +White Out; -Mass Invisibility, -Severe Temperatures, -Supernova, -Time Walk, -Wintertide
  `CAEAAAAAAAAAAAAAAAAAAAAAAMzwYZmZmFMzEzMzYmZmZ2MzMzMzMzsMTzMLzCAAAsAAALAAAAAstNmZmBz2MmZGbLAAAgZGMDjBMAGA`
- 13 (2.2%): +Captured Thoughts, +Improved Blink, +Improved Conjuration 2/2, +Thermal Conditioning; -Mass Invisibility, -Master of Time 2/2, -Severe Temperatures, -Shimmer
  `CAEAAAAAAAAAAAAAAAAAAAAAAMzwYZmxshZmYmZGzMzMziZmZmZmZmlZamZZWAAAgFAAYDAAAAgtlxMzMDz2MmZGbLAAAgZGMDjBMAGA`

**Split talents:** Master of Time 86%; Frozen Touch 80%; Spellsteal 80%; Wintertide (choice) 79%; Blizzard (choice) 73%; Time Walk (choice) 62%; Supernova (choice) 62%; Rimecaster 61%; Molten Chill 61%; Isothermic Core 61%; Imbued Warding (choice) 61%; Heat Sink 61%; Frostfire Infusion 61%; Frostfire Empowerment 61%; Flash Freezeburn 61%; Elemental Conduit 61%; Duality 61%; Dualcasting Adept 61%; Blast Radius 61%; Piercing Cold 60%; Comet Storm 60%; Glacial Shatter (choice) 60%; Elemental Affinity (choice) 60%; Hailstones 59%; Improved Counterspell 57%; Mass Invisibility 46%; Frost Conditioning 43%; Hand of Frost 42%; Crystalline Refraction 41%; Severe Temperatures (choice) 40%; Splintering Ray (choice) 40%; Splinterstorm 39%; Splintering Orbs 39%; Spellfrost Teachings 39%; Signature Spell 39%; Shifting Shards (choice) 39%; Polished Focus 39%; Infused Splinters 39%; Force of Will 39%; Controlled Instincts 39%; Augury Abounds 39%; Archmage's Wrath 39%; Reactive Barrier (choice) 39%; Slippery Slinging (choice) 39%; Time Manipulation 38%; Temporal Realignment (choice) 37%; Dragon's Breath (choice) 37%; Captured Thoughts 34%; Blizzard (choice) 27%; Improved Conjuration 23%; White Out (choice) 21%; Incantation of Swiftness 21%; Thermal Conditioning (choice) 21%; Freezing Rain 20%

**Ours, against the whole sample:**

- `Dungeon`: 3 of 579 run it exactly. Typical has +Blast Radius, +Comet Storm, +Dualcasting Adept, +Duality, +Elemental Affinity, +Elemental Conduit, +Flash Freezeburn, +Frostfire, +Frostfire Empowerment, +Frostfire Infusion, +Glacial Shatter, +Hailstones, +Heat Sink, +Imbued Warding, +Isothermic Core, +Mass Invisibility, +Molten Chill, +Piercing Cold, +Rimecaster 2/2, +Severe Temperatures; lacks Archmage's Wrath, Augury Abounds, Controlled Instincts, Crystalline Refraction, Force of Will, Hand of Frost 4/4, Infused Splinters, Polished Focus, Reactive Barrier, Shifting Shards, Signature Spell, Slippery Slinging, Spellfrost Teachings, Spellslinger, Splintering Orbs, Splintering Ray, Splinterstorm, Time Manipulation.

## Brewmaster Monk

### Raid

831 rankings over 10 bosses, logged 2026-10-13 to 2026-10-18. 400 distinct builds. Hero tree: Shado-Pan 83%, Master of Harmony 17%.

**Typical** (Shado-Pan, agreement 78% on 27 contested talents, 1 run it exactly):

`CwQAAAAAAAAAAAAAAAAAAAAAAAAAAwMbbGzYGWmxGmZMAAAAAAALLYEzMwMM2YwMzMDz2YmxMLDLb22mtZMLAAwGAAAY2mlmZmZhhNAmZYaMAAgB`

**Most common other builds**, each against the typical:

- 35 (4.2%): +Empty the Cellar, +Energy Transfer, +Save Them All; -Chi Transfer, -Tiger Tail Sweep, -Vital Flame
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAwMbbGzYGWmxGmZMAAAAAAALLYEzMYmhZ2YwMzMDz2wMGLDLb22GzYWAAgNAAAwsNLNzMziZYDgZGmGDAAYA`
- 18 (2.2%): +Balanced Stratagem, +Bob and Weave, +Clarity of Purpose, +Coalescence, +Elixir of Determination, +Endless Draught, +Harmonic Surge, +High Tolerance 1/2, +Manifestation, +Mantra of Purity, +Master of Harmony, +Meditative Focus, +Overwhelming Force, +Ox Stance, +Potential Energy, +Purified Spirit, +Stillstep Coil, +Tiger's Vigor, +Way of a Thousand Strikes, +Zen State; -Against All Odds, -Black Ox Brew, -Chi Transfer, -Combat Stance, -Efficient Training, -Fuel on the Fire, -Martial Precision, -One Versus Many, -Predictive Training, -Pride of Pandaria, -Shado Over the Battlefield, -Shado-Pan, -Stand Ready, -Swift as a Coursing River, -Veteran's Eye, -Vigilant Watch, -Walk with the Ox 2/2, -Weapons of the Wall, -Wisdom of the Wall
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAgZbzYGGzyM2YmZMAAAAAAALLYEzMwMM2YwMzMDz2wMmZZYZ7BW2mtxMLAAwysMtMbzsMAAAAG2AzMgpxAMAwA`
- 15 (1.8%): +Balanced Stratagem, +Bob and Weave, +Clarity of Purpose, +Coalescence, +Elixir of Determination, +Endless Draught, +Harmonic Surge, +Manifestation, +Mantra of Purity, +Master of Harmony, +Meditative Focus, +Overwhelming Force, +Potential Energy, +Purified Spirit, +Stillstep Coil, +Tiger's Vigor, +Way of a Thousand Strikes, +Zen State; -Against All Odds, -Black Ox Brew, -Chi Transfer, -Combat Stance, -Efficient Training, -Fuel on the Fire, -Martial Precision, -One Versus Many, -Predictive Training, -Pride of Pandaria, -Shado Over the Battlefield, -Shado-Pan, -Stand Ready, -Swift as a Coursing River, -Veteran's Eye, -Vigilant Watch, -Weapons of the Wall, -Wisdom of the Wall
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAgZbzYGzYWmxGzMjBAAAAAAYZBjYmBmhxGDmZmZY2GmxMLDLbW2mthZBAAWmlplZbmlBAAAwwGYmBMNGgBAG`
- 13 (1.6%): +Bob and Weave, +Chi Wave, +Elixir of Determination, +High Tolerance 2/2, +Initiator's Edge, +Light Brewing, +Summon Black Ox Statue, +Zen State; -Black Ox Brew, -Chi Burst, -Combat Stance, -Fuel on the Fire, -Improved Blackout Kick, -Training of Niuzao, -Walk with the Ox 2/2, -Windwalking
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAwMbbGDGzyMWYmZMAAAAAAALLYEzMwMM2YwMzMjZ2YmxMLDLbzy2sNMLAAwGAAAY2mlmZmZjhFAmZYaMAAgB`

**Split talents:** Black Ox Brew (choice) 90%; Improved Blackout Kick 90%; Detox 89%; Chi Burst (choice) 88%; Walk with the Ox 83%; Wisdom of the Wall 83%; Weapons of the Wall 83%; Vigilant Watch 83%; Veteran's Eye 83%; Stand Ready 83%; Shado Over the Battlefield 83%; Pride of Pandaria (choice) 83%; Predictive Training (choice) 83%; One Versus Many 83%; Martial Precision 83%; Efficient Training 83%; Against All Odds 83%; Windwalking 82%; Bounding Agility 82%; Tiger Tail Sweep 74%; Combat Stance (choice) 69%; Vital Flame (choice) 67%; Swift as a Coursing River 65%; Fuel on the Fire 55%; Empty the Cellar 52%; Peace and Prosperity 39%; Elixir of Determination 38%; Chi Transfer 38%; Zen State 37%; Save Them All 30%; Jade Walk 27%; High Tolerance 26%; Summon Black Ox Statue 21%; Silent Sanctuary 18%; Way of a Thousand Strikes (choice) 17%; Purified Spirit (choice) 17%; Potential Energy 17%; Overwhelming Force 17%; Meditative Focus 17%; Manifestation 17%; Harmonic Surge 17%; Endless Draught 17%; Coalescence 17%; Clarity of Purpose 17%; Balanced Stratagem 17%; Mantra of Purity (choice) 17%; Ox Stance 17%; Tiger's Vigor (choice) 15%; Pressure Points 14%; Initiator's Edge (choice) 14%; Chi Wave (choice) 12%; Bob and Weave (choice) 10%

**Ours, against the whole sample:**

- `Raid`: the typical build. 1 of 831 run it exactly.

### Mythic+

720 rankings over 8 dungeons, logged 2026-09-04 to 2026-10-18, keys 19 to 23 (median 20). 133 distinct builds. Hero tree: Master of Harmony 98%, Shado-Pan 2%. 80 left out: their log has no talents.

**Typical** (Master of Harmony, agreement 68% on 4 contested talents, 36 run it exactly):

`CwQAAAAAAAAAAAAAAAAAAAAAAAAAAgZbzYGGzyMzGzMjBAAAAAAYZBzEzMwMM2gxMzMDzGzMmZZYZ7B22mNMLAAwysMtMbzsMAAAAG2AzMgpxAAAG`

**Most common other builds**, each against the typical:

- 60 (8.3%): +Windwalking; -Tiger Tail Sweep
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAgZbzYGGzyMzGzMjBAAAAAAYZBzEzMwMM2gxMzMDz2YmxYZYZ7B22mNMLAAwysMtMbzsMAAAAG2AzMgpxAAAG`
- 42 (5.8%): +Transcendence: Linked Spirits; -Tiger Tail Sweep
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAgZbzYGGzyMzGzMjBAAAAAAYZBzEzMwMM2gxMzMDzmtZGjlhltHYbb2wsAAALzy0ysNzyAAAAYYDMzAmGDAAYA`
- 31 (4.3%): +Jade Walk, +Transcendence: Linked Spirits; -Peace and Prosperity, -Tiger Tail Sweep
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAgZbzYGGzyMzGzMjBAAAAAAYZBzEzMwMM2MwMzMDzmtZGjlhltHYbb2wsAAALzy0ysNzyAAAAYYDMzAmGDAAYA`
- 29 (4.0%): +Jade Walk; -Peace and Prosperity
  `CwQAAAAAAAAAAAAAAAAAAAAAAAAAAgZbzYGGzyMzGzMjBAAAAAAYZBzEzMwMM2MwMzMDzGzMmZZYZ7B22mNMLAAwysMtMbzsMAAAAG2AzMgpxAAAG`

**Split talents:** Pressure Points 89%; Vivacious Vivification 84%; Peace and Prosperity 50%; Tiger Tail Sweep 50%; Jade Walk 32%; Windwalking 28%; Summon Black Ox Statue 26%; Transcendence: Linked Spirits (choice) 21%; Save Them All 13%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 36 of 720 run it exactly.

## Mistweaver Monk

### Raid

832 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 312 distinct builds. Hero tree: Conduit of the Celestials 98%, Master of Harmony 2%. 3 refused: unknown talents or not 34/34/13 points.

**Typical** (Conduit of the Celestials, agreement 71% on 11 contested talents, 44 run it exactly):

`C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAghx2YZYzixMzyyM2wYGmZZZbmxCzoZMDYwgxsMzMzwsNYwiJAAAAAAYxyMLz2MDAAMgBYGwYYsIjZA`

**Most common other builds**, each against the typical:

- 47 (5.6%): +Revival; -Restoral
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAghx2YZYzixMzyyM2wYGmZZZZmxCzoZMDYwgxsMzMzwsNYwiJAAAAAAYxyMLz2MDAAMgBYGwYYsIjZA`
- 31 (3.7%): +Crane Style, +Deep Clarity, +Revival, +Zen Pulse; -Chrysalis, -Healing Elixir, -Mists of Life, -Restoral
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAghx2MwmFzYmllZshZmhZWWWmZswMaGzAGMYMLzMzMMbDGsYCAAAAAAWsMzysNzAAADYAmBMGGLyYGA`
- 25 (3.0%): +Ancient Arts 1/2, +Ferocity of Xuen 1/2, +Jade Walk, +Pressure Points, +Tiger Tail Sweep; -Bounding Agility, -Ferocity of Xuen 2/2, -Improved Touch of Death, -Peace and Prosperity
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAghx2YZYzixMzyyM2wYGmZZZbmxCjpZMDYwwgl5BmZGmtBDzyDMBAAAAAALWmZZ2mZAAgBMAzAGDjFZMDA`
- 20 (2.4%): +Crane Style, +Deep Clarity, +Quick Footed, +Zen Pulse; -Chrysalis, -Healing Elixir, -Mists of Life, -Peace and Prosperity
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAghx2MwmFzYmllZshZmhZWW2mZswMaGzAGMLMsMzMzwsNYwiJAAAAAAYxyMLz2MDAAMgBYGwYYsIjZA`

**Split talents:** Silent Sanctuary 89%; Windwalking 89%; Expeditious Fortification (choice) 87%; Jade Infusion (choice) 87%; Bounding Agility 74%; Improved Touch of Death 68%; Healing Elixir 60%; Mists of Life 60%; Peace and Prosperity 59%; Chrysalis (choice) 59%; Restoral (choice) 51%; Revival (choice) 49%; Crane Style 47%; Tiger Tail Sweep 47%; Zen Pulse 43%; Deep Clarity 41%; Ancient Arts 25%; Ironshell Brew (choice) 13%; Reinvigoration 12%; Quick Footed (choice) 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 44 of 832 run it exactly.

### Mythic+

664 rankings over 8 dungeons, logged 2026-09-03 to 2026-10-18, keys 19 to 23 (median 20). 185 distinct builds. Hero tree: Conduit of the Celestials 98%, Master of Harmony 2%. 105 left out: their log has no talents. 31 refused: unknown talents or not 34/34/13 points.

**Typical** (Conduit of the Celestials, agreement 79% on 8 contested talents, 65 run it exactly):

`C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBWmZZML2mxMz2mBmhZzMbLLzMWYMNjZADGAzMzMMbYGmlZCAAAAAAWsNz2sNzAAADGDwMgxALyYGA`

**Most common other builds**, each against the typical:

- 46 (6.9%): +Peace and Prosperity; -Chi Wave
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBWmZZML2mxMz2mBmhZzMbLLzMWYMNjZADGwYmZmhZDzwsMTAAAAAAwitZ2mtZGAAAGDwMgxALyYGA`
- 28 (4.2%): +Improved Touch of Death; -Tiger Tail Sweep
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBWmZZML2mxMz2mBmhZzMbLLzMWYmpZMDYwAYmZmhZDzglZCAAAAAAWsNz2sNzAAADGDwMgxALyYGA`
- 27 (4.1%): +Peace and Prosperity, +Swift Art; -Chi Wave, -Vital Clarity
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBWmZZML2mxMz2mBmhZzMbLLzMWYMNjZAjxAGzMzMMbYGmlZCAAAAAAWsNz2sNzAAAwYAmBMALyYGA`
- 25 (3.8%): +Swift Art, +Temple Training; -Vital Clarity, -Xuen's Guidance
  `C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBWmZZML2mxMz2mBmhZzMbLLzMWYMNjZAjxAYmZmhZDzwsMTAAAAAAwitZWmtZGAAYwYAmBMALyYGA`

**Split talents:** Tiger Tail Sweep 90%; Pressure Points 86%; Pool of Mists 83%; Diffuse Magic 80%; Xuen's Guidance (choice) 77%; Chi Wave 76%; Fatal Touch 76%; Vital Clarity 62%; Swift Art 38%; Peace and Prosperity 30%; Improved Touch of Death 25%; Temple Training (choice) 20%; Jade Infusion (choice) 20%; Amplified Rush 17%; Windwalking 14%; Mist Wrap 12%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 65 of 664 run it exactly.

## Windwalker Monk

### Raid

957 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 496 distinct builds. Hero tree: Conduit of the Celestials 97%, Shado-Pan 3%.

**Typical** (Conduit of the Celestials, agreement 71% on 16 contested talents, 3 run it exactly):

`C0QAAAAAAAAAAAAAAAAAAAAAAMzYM2GGsMzMbzAAAAAAAAAAAAsMMaGzwwAGGmZmZY2GmhZZmAAWMz2YGzMzMAAWMzysMmAAAGDgZAGLDgZmZzFA`

**Most common other builds**, each against the typical:

- 25 (2.6%): +Jade Walk, +Peace and Prosperity, +Silent Sanctuary, +Tigereye Brew 3/4; -Ancient Arts 2/2, -Harmonic Combo, -Tiger Tail Sweep, -Tigereye Brew 2/4
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYM2GGsMzMbzAAAAAAAAAAAAsMMaGzwwAmxMmZmZY2GmBLmAAWMz2YGzMzMAAWMzysMmAAAYAMDwYZGgZmZzHA`
- 24 (2.5%): +Ancient Arts 1/2, +Ironshell Brew, +Jade Ignition, +Restore Balance, +Silent Sanctuary, +Skyfire Heel, +Tigereye Brew 4/4; -Ancient Arts 2/2, -Expeditious Fortification, -Inner Peace, -Jadefire Stomp, -Rising Star, -Singularly Focused Jade, -Tigereye Brew 2/4, -Xuen's Bond
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYZmZ2mBAAAAAAAAAAAYZY0MmhhBMMMzMzwsMMDzyDMBAswsNmxYmZAAsYmlZZMBAAmxAYGgxyMAzMziB`
- 20 (2.1%): +Jade Walk, +Memory of the Monastery, +Peace and Prosperity, +Silent Sanctuary; -Ancient Arts 2/2, -Inner Peace, -Tiger Tail Sweep
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYM2GGsMzMbzAAAAAAAAAAAAsMMaGzwwAmxMmZmZY2GmBLmAAWMz2MzYMzMAAWMzysMmAAAGDgZAGLzAMzMbuA`
- 20 (2.1%): +Jade Ignition, +Jade Walk, +Peace and Prosperity, +Shadowboxing Treads, +Song of Chi-Ji, +Tigereye Brew 3/4; -Elusive Mists, -Jadefire Stomp, -Ring of Peace, -Rising Star, -Singularly Focused Jade, -Soothing Mist, -Tigereye Brew 2/4
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYZmZ2mxAAAAAAAAAAAAbDjwMMMgZMjZmZGmthZYWmJAgFmtxMmZmZAAsYmlZZMBAAMGAzAMWGAzMzmPA`

**Split talents:** Vigorous Expulsion 89%; Energy Burst 89%; Expeditious Fortification (choice) 89%; Harmonic Combo 86%; Windwalking 83%; Xuen's Bond (choice) 81%; Tiger Tail Sweep 78%; Ancient Arts 77%; Niuzao's Protection (choice) 74%; Soothing Mist 73%; Elusive Mists 69%; Rising Star 69%; Inner Peace 54%; Jade Ignition 52%; Jadefire Stomp 52%; Singularly Focused Jade (choice) 51%; Jade Walk 50%; Memory of the Monastery 38%; Peace and Prosperity 36%; Silent Sanctuary 30%; Jade Sanctuary (choice) 23%; Skyfire Heel 19%; Bounding Agility 19%; Restore Balance (choice) 16%; Shadowboxing Treads 15%; Pressure Points 11%; Ironshell Brew (choice) 11%

**Ours, against the whole sample:**

- `Raid`: 5 of 957 run it exactly. Typical has +Elusive Mists, +Jadefire Stomp, +Singularly Focused Jade, +Tigereye Brew 2/4; lacks Jade Ignition, Jade Walk, Tigereye Brew 3/4.

### Mythic+

710 rankings over 8 dungeons, logged 2026-09-07 to 2026-10-18, keys 20 to 23 (median 21). 230 distinct builds. Hero tree: Conduit of the Celestials 98%, Shado-Pan 2%. 90 left out: their log has no talents.

**Typical** (Conduit of the Celestials, agreement 75% on 11 contested talents, 13 run it exactly):

`C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYZmZ2mBAAAAAAAAAAAYZYmmxMMMghhZmZGmNMDzyMBAswsxMmZmZAAsYmlZbMBAAmxAYGgxyAYmZ2M`

**Most common other builds**, each against the typical:

- 59 (8.3%): +Ancient Arts 1/2, +Martial Agility, +Swift Art; -Ancient Arts 2/2, -Inner Peace
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYZmZ2mBAAAAAAAAAAAYZYmmxMMMGMMMzMzwshZYWegJAgFmtxMGzMDAgFzsMbjJAAwMGAzAMWGAzMzmB`
- 26 (3.7%): +Chi Transfer, +Martial Agility, +Profound Rebuttal, +Spiritual Focus; -Drinking Horn Cover, -Energy Burst, -Strength of Spirit, -Tiger Tail Sweep
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYbmx2MAAAAAAAAAAAALDz0MmhhBMMMzMzwsxMDWmJAgFmtxMmZmZAAsYmlZbMBAAmxAYGgx2AYmZ2M`
- 25 (3.5%): +Chi Transfer, +Martial Agility, +Spiritual Focus; -Drinking Horn Cover, -Energy Burst, -Tiger Tail Sweep
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYbmx2MAAAAAAAAAAAALDz0MmhhBMMMzMzwsxMDWmJAgFmtxMmZmZAAsYmlZbMBAAmxAYGgxyAYmZ2M`
- 25 (3.5%): +Chi Transfer, +Profound Rebuttal, +Spiritual Focus; -Drinking Horn Cover, -Strength of Spirit, -Tiger Tail Sweep
  `C0QAAAAAAAAAAAAAAAAAAAAAAMzYMgxYbmZ2mBAAAAAAAAAAAYZYmmxMMMghhZmZGmNmZwyMBAswsxMmZmZAAsYmlZbMBAAmxAYGgx2AYmZ2M`

**Split talents:** Vigorous Expulsion 89%; Pressure Points 89%; Strength of Spirit (choice) 83%; Soothing Mist 81%; Elusive Mists 79%; Energy Burst 78%; Jade Sanctuary (choice) 73%; Inner Peace 61%; Martial Agility 60%; Tiger Tail Sweep 58%; Drinking Horn Cover (choice) 58%; Spiritual Focus (choice) 42%; Chi Transfer 35%; Swift Art 29%; Niuzao's Protection (choice) 26%; Diffuse Magic 24%; Jade Walk 18%; Profound Rebuttal (choice) 12%; Windwalking 11%

**Ours, against the whole sample:**

- `Dungeon`: 4 of 710 run it exactly. Typical has +Drinking Horn Cover; lacks Spiritual Focus.

## Holy Paladin

### Raid

961 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 288 distinct builds. Hero tree: Herald of the Sun 100%.

**Typical** (Herald of the Sun, agreement 81% on 5 contested talents, 287 run it exactly):

`CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwMAAw2MzMjZMzYxYmZYZwMLmpJGGzMDjZLDADYYDsxyMmZZ2mZmtGAAAgFAYzwYGzwMAAmZYGjhB`

**Most common other builds**, each against the typical:

- 40 (4.2%): +Light's Revocation, +Unbound Freedom; -Echoing Blessings, -Hammer of Wrath
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwAAA2mZmZMjZGLGzMDLDmZxMNxYGzMDjZLDADYYDsx2MmZZ2mZmtGAAAgFAYzwYGzwMAAmZYGjhB`
- 24 (2.5%): +Light's Revocation; -Blinding Light
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwMAAw2MzMjZMzYxYmZYZwMLmJxYGzMDjZLDADYYDsxyMmZZ2mZmtGAAAgFAYzwYGzwMAAmZYGjhB`
- 24 (2.5%): +Light's Revocation; -Hammer of Wrath
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwAAA2mZmZMjZGLGzMDLDmZxMNxYGzMDjZLDADYYDsxyMmZZ2mZmtGAAAgFAYzwYGzwMAAmZYGjhB`
- 20 (2.1%): +Unbound Freedom; -Echoing Blessings
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwMAAw2MzMjZMzYxYmZYZwMLmpJGGzMDjZLDADYYDsx2MmZZ2mZmtGAAAgFAYzwYGzwMAAmZYGjhB`

**Split talents:** Moment of Compassion (choice) 90%; A Just Reward 89%; Blinding Light 83%; Hammer of Wrath 80%; Echoing Blessings (choice) 79%; Light's Revocation 39%; Unbound Freedom (choice) 20%; Unending Light 15%; Breaking Dawn 13%; Empyreal Ward 10%; Seraphic Barrier 10%

**Ours, against the whole sample:**

- `Raid`: the typical build. 287 of 961 run it exactly.

### Mythic+

660 rankings over 8 dungeons, logged 2026-09-25 to 2026-10-18, keys 22 to 24 (median 22). 289 distinct builds. Hero tree: Lightsmith 99%, Herald of the Sun 1%. 140 left out: their log has no talents.

**Typical** (Lightsmith, agreement 65% on 6 contested talents, 13 run it exactly):

`CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwMAAwyAmZWmZmlZMjhFzmZWMTTMLGzMzYMbZAYAYDsxiZGAAAYmZZZxyMDbsNmBbAzYAAmZAYGjRDA`

**Most common other builds**, each against the typical:

- 25 (3.8%): +Light's Revocation, +Unbound Freedom; -Echoing Blessings, -Sacrifice of the Just
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwMAAwyAmZWmZmlZMjhFzmZWMTTMmxMzMGzWGAGA2AbsZmBAAAmZWWWsMzwGbjZwGwMGAgZGAmxY0A`
- 15 (2.3%): +Light's Revocation; -Sacrifice of the Just
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwMAAwyAmZWmZmlZMjhFzmZWMTTMmxMzMGzWGAGA2AbsYmBAAAmZWWWsMzwGbjZwGwMGAgZGAmxY0A`
- 14 (2.1%): +A Just Reward 2/2, +Righteous Protection; -Improved Blessing of Protection, -Vengeful Wrath 2/2
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwMAAwyAmZWmZmlZMjhFzmZWMTTMLGzMDjZLDADAbgNWMzAAAAzMLLLWmZYjthBbGYmtBAYmBgZMGNA`
- 13 (2.0%): +A Just Reward 2/2, +Protection of Tyr; -Improved Blessing of Protection, -Sacrifice of the Just, -Unwavering Spirit
  `CEEAAAAAAAAAAAAAAAAAAAAAAAAAALAwMAAwyAmZ2mZmlZMjhFzmZWMTTMMmZGGzWGAGA2AbsYmBAAAmZWWWsMzwGbjZwmBmxAAMzAwMGjGA`

**Split talents:** Unwavering Spirit (choice) 79%; Brought to Light 75%; Improved Blessing of Protection 73%; Echoing Blessings (choice) 63%; Vengeful Wrath 61%; Sacrifice of the Just (choice) 54%; Faith's Armor 42%; Unbound Freedom (choice) 37%; Light's Revocation 37%; Righteous Protection (choice) 30%; A Just Reward 28%; Protection of Tyr (choice) 18%; Consecrated Ground 12%; Turn Evil 10%; Stand Against Evil (choice) 10%

**Ours, against the whole sample:**

- `Dungeon`: 13 of 660 run it exactly. Typical has +Sacrifice of the Just; lacks Faith's Armor.

## Protection Paladin

### Raid

840 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 586 distinct builds. Hero tree: Lightsmith 99%, Templar 1%. 1 left out: their log has no talents.

**Typical** (Lightsmith, agreement 74% on 19 contested talents, 3 run it exactly):

`CIEAAAAAAAAAAAAAAAAAAAAAAsNDzyMzMzMzMsMGWGWmxAAMAAAAAAINzsMzYmhxs1GAGAYGsBAAAAzMLbLtMzYx2GzAgxMMGAMzAgZGwYB`

**Most common other builds**, each against the typical:

- 15 (1.8%): +Blinding Light, +Bulwark of Order, +Empyreal Ward; -Cleanse Toxins, -Light's Revocation, -Seal of Reprisal
  `CIEAAAAAAAAAAAAAAAAAAAAAAsNDzyMzMzMzMsMGzywywAAMAAAAAAopZmFzYmhxsFAMAwMYDAAAAmZW2WaZmxitNmBwYMDjBAzMAYmBMWA`
- 8 (1.0%): +Bulwark of Order, +Divine Reach, +Punishment, +Tyr's Enforcer 1/2; -Blessing of Protection, -Cleanse Toxins, -Gift of the Golden Val'kyr, -Sanctuary
  `CIEAAAAAAAAAAAAAAAAAAAAAAsNzDYWmZMzYmhlxYWGWGGAgBAAAAAApZmlZGzgxs1GAGYGYGsBAAAAzMLbLtMzYx2GzAgxMMGAMzAgZGwYB`
- 7 (0.8%): +Bulwark of Order, +Divine Reach, +Empyreal Ward, +Punishment, +Recompense, +Worthy Sacrifice; -Cleanse Toxins, -Consecrated Ground, -Gift of the Golden Val'kyr, -Light's Revocation, -Lightbearer, -Sacrifice of the Just
  `CIEAAAAAAAAAAAAAAAAAAAAAAsNDzyMjZmZmhlxYWGWGGAAAAAAAAINzsZGzMMmt2AwAzAzgNAAAAYmZZbplZGL22YGADmZxYAwMDAmZAjF`
- 7 (0.8%): +Empyreal Ward, +Eye for an Eye, +Improved Blessing of Protection; -Fist of Justice, -Guided Prayer, -Lightbearer
  `CIEAAAAAAAAAAAAAAAAAAAAAAsNDzyMzMzMzMsMGWGWmxAAMAAAAAAINzsMzYmZMzs1GAGAYGsBAAAAzMLbLtMzYx2GzAYwMMGAMzAADwYB`

**Split talents:** Fist of Justice 87%; Sweeping Verdict (choice) 87%; Focused Enmity (choice) 87%; Tempered in Battle (choice) 86%; Consecration in Flame 83%; Ferren Marcus's Fervor 82%; Guided Prayer 81%; Vision of Sanctity 80%; Afterimage 78%; Blessing of Protection 78%; Lightforged Blessing 77%; Sanctuary 76%; Gift of the Golden Val'kyr 75%; Consecrated Ground 75%; Lightbearer 73%; Light's Revocation 69%; Instrument of the Divine (choice) 64%; Sacrifice of the Just (choice) 62%; Bulwark of Order 61%; Punishment 58%; Cleanse Toxins 56%; Empyreal Ward 54%; Crusader's Resolve (choice) 47%; Blinding Light 46%; Solace (choice) 36%; Tyr's Enforcer 32%; Improved Blessing of Protection 29%; Divine Reach 25%; Light of the Titans (choice) 21%; Undying Embers 15%; Authoritative Rebuke (choice) 13%; Recompense (choice) 13%; Eye for an Eye 13%; Soaring Shield (choice) 12%; Blessed Calling 11%

**Ours, against the whole sample:**

- `Raid`: no one in the sample runs it exactly. Typical has +Cleanse Toxins; lacks Punishment.

### Mythic+

695 rankings over 8 dungeons, logged 2026-09-15 to 2026-10-18, keys 20 to 22 (median 20). 338 distinct builds. Hero tree: Lightsmith 100%, Templar 0%. 105 left out: their log has no talents.

**Typical** (Lightsmith, agreement 72% on 10 contested talents, 2 run it exactly):

`CIEAAAAAAAAAAAAAAAAAAAAAAsZYWGzYmZmZWWGjZZWmlZMAADAAAAAAaamZZmxMDDbtBgBGwAbAAAAwMzy2SLzMWsswMAGMzmxAgZGAMzAGL`

**Most common other builds**, each against the typical:

- 22 (3.2%): +Consecration in Flame 2/2, +Obduracy 2/2; -Empyreal Ward, -Light of the Titans, -Righteous Protection, -Undying Embers
  `CIEAAAAAAAAAAAAAAAAAAAAAAsZYWGzMzMzMWWGjZZMLzYAAGAAAAAA00MzyMjZGGzWbAYgBMwGAAAAMzsst0yMjFLLMDAYGGDAmZAwMDYsA`
- 17 (2.4%): +Afterimage; -Lead the Charge
  `CIEAAAAAAAAAAAAAAAAAAAAAAsZYWGzYmZmZWWGjZZWmlZMAADAAAAAAaamZZmxMDDbtBgBGwMYDAAAAmZW2WaZmxilFmBwgZ2wAgZGAMzAGL`
- 14 (2.0%): +Afterimage, +Redoubt; -Imbued Shield, -Lead the Charge
  `CIEAAAAAAAAAAAAAAAAAAAAAAsZYWGzYmZmZW2GjZZWmlZMAADAAAAAAaamZZmxMDDbtBgBGwMYDAAAAmZW2WaZmxilFmBwgZ2wAgZGAMzAGL`
- 13 (1.9%): +Afterimage, +Blessed Word, +Instrument of the Divine, +Obduracy 1/2; -Empyreal Ward, -Lightforged Blessing, -Searing Sunlight, -Solace
  `CIEAAAAAAAAAAAAAAAAAAAAAAsZsNLjZMzMzMLLjxYWmlZMAADAAAAAAaamZZmxMDjHYrNAMwAmBbAAAAwMzy2SLzMWstgBAMzmxAgZGAMzAGL`

**Split talents:** Tempered in Battle (choice) 86%; Blessing of Spellwarding (choice) 84%; Undying Embers 83%; Lightforged Blessing 82%; Searing Sunlight (choice) 81%; Light of the Titans (choice) 73%; Obduracy 66%; Imbued Shield (choice) 64%; Empyreal Ward 62%; Lead the Charge 54%; Righteous Protection (choice) 52%; Afterimage 45%; Redoubt (choice) 36%; Consecration in Flame 28%; Blessed Word (choice) 25%; Lightbearer 15%; Improved Blessing of Protection 14%; Authoritative Rebuke (choice) 13%; Uther's Counsel (choice) 10%

**Ours, against the whole sample:**

- `Dungeon`: 17 of 695 run it exactly. Typical has +Lead the Charge; lacks Afterimage.

## Retribution Paladin

### Raid

961 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 442 distinct builds. Hero tree: Herald of the Sun 98%, Templar 2%.

**Typical** (Herald of the Sun, agreement 75% on 9 contested talents, 13 run it exactly):

`CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzMzAAAAAAYmyYGmZsNmthZ2mxYMGmxCbAYWmtZmZrBAAAWAMAYMDzgZMzsBMzMMGGMA`

**Most common other builds**, each against the typical:

- 62 (6.5%): +Punishment; -Blessed Calling
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzMzAAAAAAYmyYGmZsNmthZ2mxYMGmxCbAYWmtZmZrBAAAWAMAYMDDMjZmNgZmhxMGMA`
- 44 (4.6%): +Punishment, +Righteous Protection, +Sacrifice of the Just; -Blessed Calling, -Consecrated Ground, -Lead the Charge
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzYGAAAAAAzUmlZYmx2Y2GmZbGjxYYGLsBgZZ2mZmtGAAAYBwAgxMbAzYmZDYmZYMjBD`
- 23 (2.4%): +Punishment; -Cleanse Toxins
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAANbbzMzyYmZGAAAAAAzUGzwMjtxsNMz2MGjxwMWYDAzysNzMbNAAAwCgBAjZYGMjZmNgZmhxMGMA`
- 20 (2.1%): +Divine Reach, +Holy Reprieve, +Lightforged Blessing; -Blinding Light, -Cleanse Toxins, -Consecrated Ground
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAANbbzMzyYGzAAAAAAYUGzwMjtxsNMz2MmZMGzMWYDAzysNzMbNAAAwCgBgZMDzgZMzsBMzMMGGMA`

**Split talents:** Light of Justice (choice) 89%; Lead the Charge 87%; Blessed Champion 87%; Blade of Vengeance 84%; Lightbearer 80%; Cleanse Toxins 78%; Blinding Light 73%; Blessed Calling 46%; Consecrated Ground 46%; Punishment 43%; Sacrifice of the Just (choice) 32%; Lightforged Blessing 30%; Righteous Protection (choice) 17%; Heart of the Crusader 16%; Recompense (choice) 14%; Holy Reprieve 13%; Swift Justice (choice) 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 13 of 961 run it exactly.

### Mythic+

703 rankings over 8 dungeons, logged 2026-09-17 to 2026-10-18, keys 20 to 23 (median 21). 136 distinct builds. Hero tree: Herald of the Sun 100%, Templar 0%. 97 left out: their log has no talents.

**Typical** (Herald of the Sun, agreement 69% on 5 contested talents, 110 run it exactly):

`CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzYGAAAAAAzUmlZYmx2Y2GmZbGjxYYGLsBgZZ2mZmtGAAAYBwAgxMbAzYmZDYmZYMjBD`

**Most common other builds**, each against the typical:

- 136 (19.3%): +Swift Justice; -Light of Justice
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZZbmZWGzYGAAAAAAzUmlZYmx2Y2GmZbGjxYYGLsBgZZ2mZmtGAAAYBwAgxMbAzYmZDYmZYMjBD`
- 50 (7.1%): +Consecrated Ground, +Lead the Charge; -Righteous Protection, -Sacrifice of the Just
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzMzAAAAAAYmyYGmZsNmthZ2mxYMGmxCbAYWmtZmZrBAAAWAMAYMDDMjZmNgZmhxMGMA`
- 25 (3.6%): +Consecrated Ground; -Punishment
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzMzAAAAAAYmysMDzM2Gz2wMbzYMGDzYhNAMLz2Mzs1AAAALAGAMmZDYGzMbAzMDjhBD`
- 25 (3.6%): +Consecrated Ground, +Lead the Charge; -Punishment, -Righteous Protection
  `CYEAAAAAAAAAAAAAAAAAAAAAAAAAAAwoZbbmZWGzMzAAAAAAYmysMDzM2Gz2wMbzYMGDzYhNAMLz2Mzs1AAAALAGAMmhBmxMzGwMzwYYwA`

**Split talents:** Sacrifice of the Just (choice) 85%; Lightbearer 71%; Righteous Protection (choice) 69%; Punishment 68%; Light of Justice (choice) 52%; Swift Justice (choice) 48%; Lead the Charge 42%; Consecrated Ground 31%; Lightforged Blessing 15%; Blessed Calling 11%

**Ours, against the whole sample:**

- `Dungeon`: 136 of 703 run it exactly. Typical has +Light of Justice; lacks Swift Justice.

## Discipline Priest

### Raid

649 rankings over 10 bosses, logged 2026-10-13 to 2026-10-18. 287 distinct builds. Hero tree: Voidweaver 95%, Oracle 5%. 1 refused: unknown talents or not 34/34/13 points.

**Typical** (Voidweaver, agreement 64% on 9 contested talents, 7 run it exactly):

`CAQAAAAAAAAAAAAAAAAAAAAAAADsMmxyYmBzwMmZbmZmZmZAAAAAAAAAAYGWmBzMzwMmZATz0YwMDAAwsNbLgxmBAgxYmxgZwMDmJYA`

**Most common other builds**, each against the typical:

- 32 (4.9%): +Lightburst, +Protector of the Frail; -Body and Soul, -Searing Light
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMmxyYmBzgZbmtZmZmZmBAAAAAAAAAgZYZGMzMDzYmBMNTzMYmBAAY2mtFwYzAAwYMzYwMYmBjgB`
- 19 (2.9%): +Abyssal Reverie 1/2, +Embrace the Shadow, +Encroaching Shadows, +Lightburst; -Mass Dispel, -Pain Suppression, -Shield Discipline, -Void Leech
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMmxyYmxYmHwgZbmZmZmZAAAAAAAAAAYGWmBzMzwMmZATz0MDmZAAAmtZbDM2MAAMGzMGMDmZgJYA`
- 14 (2.2%): +Lightburst, +Mental Agility, +Protector of the Frail; -Body and Soul, -Psychic Scream, -Searing Light
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMmxyYmBzgZbmtZmZmZmBAAAAAAAAAgZYZGMzMDzwMgpZamBzMAAAz2stAGbGAAGjZGDzMYmBjgB`
- 13 (2.0%): +Protector of the Frail; -Searing Light
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMmxyYmBzgZbmtZmZmZmBAAAAAAAAAgZYZGMzMDzYmBMNTjBzMAAAz2stAGbGAAGjZGDmBzMYmgB`

**Split talents:** Mass Dispel 80%; Inspiration 78%; Body and Soul 73%; Pain Suppression 66%; Holy Nova 65%; Shield Discipline 58%; Abyssal Reverie 56%; Searing Light 53%; Void Leech (choice) 53%; Psychic Scream 51%; Lightburst 42%; Embrace the Shadow (choice) 42%; Dispel Magic 41%; Protector of the Frail (choice) 28%; Mental Agility 25%; Tithe Evasion 20%; Encroaching Shadows 14%; Move with Grace 14%; Angelic Bulwark 10%

**Ours, against the whole sample:**

- `Raid`: the typical build. 7 of 649 run it exactly.

### Mythic+

663 rankings over 8 dungeons, logged 2026-09-16 to 2026-10-18, keys 19 to 23 (median 20). 338 distinct builds. Hero tree: Oracle 85%, Voidweaver 15%. 137 left out: their log has no talents.

**Typical** (Oracle, agreement 80% on 30 contested talents, 31 run it exactly):

`CAQAAAAAAAAAAAAAAAAAAAAAAADsMDzyMjxMzMMbzgZmZYGAAAAAAAAAADzyMYmZGmxMDYamYGwMLYIMmlBYMYBAAGzMzYwMAzMzAmB`

**Most common other builds**, each against the typical:

- 32 (4.8%): +Mental Agility; -Inspiration
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMDzyMjxMzMMbzgZmZYGAAAAAAAAAADzyMYmZGMmZATzEzAmZBDhxsMAjBLAAwYmZGDzMAzMzAmB`
- 17 (2.6%): +Dominate Mind; -Psychic Scream
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMDzyMjxMzMMbzgZmZYGAAAAAAAAAADzyMYmZGmhZwmpZiZAzsghwYWGgxgFAAYMzMjBzAMzMDYG`
- 17 (2.6%): +Dominate Mind, +Mental Agility; -Inspiration, -Psychic Scream
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMDzyMjxMzMMbzgZmZYGAAAAAAAAAADzyMYmZGMMD2MNTMDYmFMEGzyAMGsAAAjZmZMMzAMzMDYG`
- 11 (1.7%): +Phantasm; -Mindpierce
  `CAQAAAAAAAAAAAAAAAAAAAAAAADsMDzyMjxMzMMbzgZmZYGAAAAAAAAAAjZWmBzMzwMmZATzEzAmZBDhxsMAjBLAAwYmxYwMAzMzAmB`

**Split talents:** Holy Ray 89%; Borrowed Time 89%; Shield Discipline 87%; Purge the Wicked 87%; Words of the Wise 85%; Waste No Time 85%; Unfolding Vision 85%; Twinsight 85%; Prophet's Insight 85%; Prompt Prognosis 85%; Preventive Measures 85%; Preemptive Care 85%; Piety 85%; Foreseen Circumstances 85%; Assured Safety 85%; Weal and Woe 85%; Shadow Tap 85%; Revel in Darkness 85%; Prophet's Will (choice) 85%; Occultist 84%; Body and Soul 82%; Angelic Bulwark 82%; Mindpierce 80%; Divine Feathers (choice) 76%; Inspiration 70%; Psychic Scream 68%; Abyssal Reverie 62%; Power Word: Radiance 56%; Shadowfiend 49%; Harsh Discipline 48%; Light's Promise 47%; Sanctuary 45%; Dominate Mind (choice) 39%; Phantasm 33%; Mental Agility 33%; Searing Light 28%; Blaze of Light 27%; Pain and Suffering 24%; Greater Smite 16%; Divine Procession 16%; Voidwraith 15%; Voidheart 15%; Void Infusion 15%; Void Blast 15%; Touch of the Void 15%; Quickened Pulse 15%; Overwhelming Shadows 15%; Inner Quietus 15%; Devour Matter 15%; Darkening Horizon (choice) 15%; Collapsing Void 15%; Angel's Mercy 14%; Dark Energy (choice) 14%

**Ours, against the whole sample:**

- `Dungeon`: no one in the sample runs it exactly. Typical has +Abyssal Reverie 2/2, +Revel in Darkness, +Sanctuary, +Shadowfiend; lacks Harsh Discipline 2/2, Light's Promise, Power Word: Radiance, Searing Light.

## Holy Priest

### Raid

988 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 319 distinct builds. Hero tree: Oracle 100%, Archon 0%.

**Typical** (Oracle, agreement 75% on 7 contested talents, 57 run it exactly):

`CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAYBmZWGzMmZMMDzsMzYGAAAAzYWmBzMzwMMDgZqBwMLYIMmlBYMwiZmZBgZMGjhZGgZmZgB`

**Most common other builds**, each against the typical:

- 42 (4.3%): +Empyreal Blaze, +Gales of Song, +Psychic Scream; -Afterlife, -Mental Agility, -Seraphic Crescendo
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAYBmZ2GzMmZMMDjlZmZGAAAAzYWmBzMzwMmZAMTNAmZBDhxsMAjBWMzMLAMjxYMYGgZmZgB`
- 38 (3.8%): +Psychic Scream; -Lightburst
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAYBmZWGzMmZMMDzsMzYGAAAAzYWmBzMzwMmZAMTBwMLYIMmlBYMwiZmZBgZMGjhZGgZmZgB`
- 26 (2.6%): +Gales of Song; -Seraphic Crescendo
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAYBmZ2GzMmZMMDzsMzYGAAAAzYWmBzMzwMMDgZqBwMLYIMmlBYMwiZmZBgZMGjhZGgZmZgB`
- 26 (2.6%): +Psychic Scream; -Mental Agility
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAYBmZWGzMmZMMDzsMzYGAAAAzYWmBzMzwMmZAMTNAmZBDhxsMAjBWMzMLAMjxYMYGgZmZgB`

**Split talents:** Afterlife 90%; Prophet's Will (choice) 88%; Divine Feathers (choice) 84%; Painful Invocation 69%; Seraphic Crescendo (choice) 67%; Lightburst 65%; Mental Agility 60%; Psychic Scream 58%; Move with Grace 40%; Gales of Song (choice) 33%; Dispel Magic 29%; Save the Day (choice) 16%; Phantasm 13%; Desperate Measures (choice) 12%; Angel's Mercy 10%

**Ours, against the whole sample:**

- `Raid`: the typical build. 57 of 988 run it exactly.

### Mythic+

686 rankings over 8 dungeons, logged 2026-09-07 to 2026-10-18, keys 20 to 22 (median 20). 366 distinct builds. Hero tree: Oracle 100%. 114 left out: their log has no talents.

**Typical** (Oracle, agreement 77% on 15 contested talents, 19 run it exactly):

`CEQAAAAAAAAAAAAAAAAAAAAAAwYAAAAAAAMzMmlxMjZGDzALzMzMAAAAGmlZYmZmhZMzAYmCgZWwQYMLDwYgFjZWAYGzMGDmBYmZGYA`

**Most common other builds**, each against the typical:

- 35 (5.1%): +Dominate Mind, +Petrifying Scream, +Phantasm, +Save the Day; -Angel's Mercy, -Body and Soul, -Divine Feathers, -Inspiration
  `CEQAAAAAAAAAAAAAAAAAAAAAAwYAAAAAAAMzMmlxMjZGDzALzMzMAAAAGzsMDmZmxmxMD2wMFAzshhwYWGgxALGzsAwMmZMGMDwMzAGA`
- 15 (2.2%): +Desperate Measures, +Light of the Naaru 2/2, +Light's Inspiration, +Prismatic Echoes 1/2, +Unwavering Will 1/2; -Divine Image, -Light in the Darkness 2/2, -Prophet's Will, -Unwavering Will 2/2
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAgZm5BmlxMjZGjZGYZmZmBAAAwwsMzYmZmh5BMzAYmCgZWwQYMbDwYgFDzCAzYmxYwMAzMzAD`
- 10 (1.5%): +Desperate Measures, +Light's Inspiration, +Trail of Light, +Unwavering Will 1/2; -Divine Image, -Prophet's Will, -Unwavering Will 2/2
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAYzMzYWGzMmZMMDsMzMzAAAAYYWmZMzMzw8AmZAMTBwMLYIMmtBYMwixMLAMjZGjBzAMzMDMA`
- 9 (1.3%): +Desperate Measures, +Guardian Angel, +Healing Focus, +Lasting Words, +Light of the Naaru 1/2, +Lightburst, +Prismatic Echoes 2/2; -Desperate Times 2/2, -Dispel Magic, -Divine Image, -Divine Service, -Epiphany, -Prophet's Will, -Restitution
  `CEQAAAAAAAAAAAAAAAAAAAAAAADAAAAAAghZmlxYMzY8AzwYbmZmBAAAwwsMDzMzMMjZGAzUDgZWwQYMbDwYgFzMzCAzYMGDmBYmZGYA`

**Split talents:** Cosmic Wave 90%; Psychic Scream 89%; Eternal Sanctity (choice) 88%; Unwavering Will 88%; Inspiration 87%; Desperate Times 86%; Divine Feathers (choice) 85%; Epiphany 77%; Restitution (choice) 74%; Body and Soul 73%; Angel's Mercy 66%; Prophet's Will (choice) 59%; Phantasm 43%; Desperate Measures (choice) 41%; Prismatic Echoes 41%; Dominate Mind (choice) 38%; Divine Image 38%; Light's Inspiration 36%; Guardian Angel (choice) 26%; Trail of Light (choice) 23%; Light of the Naaru 23%; Healing Focus 23%; Lasting Words 20%; Save the Day (choice) 15%; Petrifying Scream (choice) 15%

**Ours, against the whole sample:**

- `Dungeon`: 5 of 686 run it exactly. Typical has +Divine Image; lacks Trail of Light.

## Shadow Priest

### Raid

949 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 341 distinct builds. Hero tree: Archon 91%, Voidweaver 9%.

**Typical** (Archon, agreement 76% on 15 contested talents, 94 run it exactly):

`CIQAAAAAAAAAAAAAAAAAAAAAAMMDDAAAAAAAAAAAAmZxMmZbmxMz2MGzw2MzYmZGbIzYxMNAzAMzmZY2MAkxYBAzMgxMzMmNmZbZAmBDA`

**Most common other builds**, each against the typical:

- 31 (3.3%): +Angelic Bulwark; -Protective Light
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMDDAAAAAAAAAAAAmZxMmZbmxMz2MGzY2MzYmZGbIzYxMNAzAMzmZY2MAkxYBAzMgxMzMmNmZbZAmBDA`
- 29 (3.1%): +Misery; -Invoked Nightmare
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMDDAAAAAAAAAAAAmZxMmZbmxMzyMGzw2MzYmZGbIzYxMNAzAMzmZY2MAkxYBAzMgxMzMmNmZbZAmBDA`
- 28 (3.0%): +Angelic Bulwark, +Collapsing Void, +Dark Energy, +Dark Thoughts, +Darkening Horizon, +Devour Matter, +Inner Quietus, +Instilled Doubt 2/2, +Move with Grace, +Overwhelming Shadows, +Quickened Pulse, +Shadowy Insight, +Spectral Horrors, +Touch of the Void, +Void Blast, +Void Infusion, +Void Leech, +Voidheart, +Voidweaver, +Voidwraith; -Archon, -Dark Evangelism, -Divine Halo, -Empowered Surges, -Energy Conservation, -Energy Cycle, -Focused Outburst, -Incessant Screams, -Maddening Touch, -Manifested Power, -Mental Decay, -Perfected Form, -Power Surge, -Protective Light, -Psychic Link, -Purify Disease, -Resonant Energy, -Shattered Psyche, -Spiritwell, -Sustained Potency, -Word of Supremacy
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMDzAAAAAAAAAAAAwMLmxMbzMDz2MzYGzmZGzMzYjJDLmpBYmZGAIAz2stAmNGAYwYmZGzGzgZGMDGA`
- 21 (2.2%): +Everlasting Light, +Improved Flash Heal, +Inspiration, +Phantasm, +Surge of Light; -Light's Inspiration, -Mass Dispel, -Petrifying Scream, -Psychic Voice, -Purify Disease
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMDDAAAAAAAAAAAAmZxMmZbmxMz2MGzM2mxYmZGGaGYmmZgZAmZzMMbGAyYsAgZGwYmZGzGzstMAGMA`

**Split talents:** Dark Evangelism 90%; Psychic Link 89%; Descending Darkness 88%; Shattered Psyche 86%; Crushing Void 85%; Light's Inspiration 85%; Incessant Screams (choice) 84%; Sustained Potency (choice) 84%; Mastermind 81%; Mass Dispel 77%; Invoked Nightmare (choice) 73%; Protective Light 71%; Petrifying Scream (choice) 63%; Psychic Voice (choice) 45%; Purify Disease 44%; Improved Flash Heal 42%; Move with Grace 40%; Surge of Light 35%; Instilled Doubt 28%; Spectral Horrors 27%; Misery (choice) 27%; Angelic Bulwark 27%; Everlasting Light 24%; Inspiration 23%; Phantasm 19%; Idol of C'Thun 19%; Shadowy Insight 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 94 of 949 run it exactly.

### Mythic+

641 rankings over 8 dungeons, logged 2026-09-06 to 2026-10-18, keys 19 to 22 (median 20). 310 distinct builds. Hero tree: Archon 66%, Voidweaver 34%. 159 left out: their log has no talents.

**Typical** (Archon, agreement 64% on 27 contested talents, 5 run it exactly):

`CIQAAAAAAAAAAAAAAAAAAAAAAMMDDAAAAAAAAAAAAMLmxMbzMmZWmxYY2mZGzMzYDZYZbmGgZAmZzMMbGAyYsAgZGDGzMzY2YmtlBYGMA`

**Most common other builds**, each against the typical:

- 28 (4.4%): +False Autonomy, +Mastermind 2/2, +Phantasm; -Angelic Bulwark, -Instilled Doubt 2/2, -Psychic Voice
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMDDAAAAAAAAAAAAmZxMmZbmxMzyMGjx2MzYmZGbID2mpBYGgZ2MDzmBgMGLAYmBMzMzMmNmZbZAmBDA`
- 16 (2.5%): +Mastermind 2/2, +Phantasm; -Angelic Bulwark, -Instilled Doubt 2/2
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMDDAAAAAAAAAAAAmZxMmZbmxMzyMGjx2MzYmZGbIDLbz0AMDwMbmhZzAQGjFAMzAGzMzY2YmtlBYGMA`
- 13 (2.0%): +False Autonomy, +Mastermind 2/2, +Phantom Reach; -Angelic Bulwark, -Instilled Doubt 2/2, -Psychic Voice
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMDDAAAAAAAAAAAAmZxMmZbmxMzyMGzw2MzYmZGbID2mpBYGgZ2MDzmBgMGLAYmBMzMzMmNmZbZAmBDA`
- 10 (1.6%): +Collapsing Void, +Dark Energy, +Darkening Horizon, +Devour Matter, +Embrace the Shadow, +Idol of C'Thun, +Improved Flash Heal, +Inner Quietus, +Insidious Ire 1/2, +Invoked Nightmare, +Overwhelming Shadows, +Quickened Pulse, +Shadowfiend, +Shadowy Insight, +Subservient Shadows, +Touch of the Void, +Void Blast, +Void Infusion, +Voidheart, +Voidweaver, +Voidwraith; -Archon, -Dark Evangelism, -Divine Halo, -Empowered Surges, -Energy Conservation, -Energy Cycle, -Focused Outburst, -Incessant Screams, -Insidious Ire 2/2, -Manifested Power, -Mental Decay, -Misery, -Perfected Form, -Power Surge, -Resonant Energy, -Shattered Psyche, -Spiritwell, -Sustained Potency, -Tithe Evasion, -Word of Supremacy
  `CIQAAAAAAAAAAAAAAAAAAAAAAMMj5BAAAAAAAAAAAAMMLmxMbzMmZ2mZGDz2MzYmZGbIDLbmGDMzMDAEgZb22AzGDAMYMzMjZbMDmZwMYA`

**Split talents:** Light's Inspiration 89%; Insidious Ire 73%; Crushing Void 73%; Petrifying Scream (choice) 70%; Dominate Mind (choice) 70%; Tithe Evasion 69%; Word of Supremacy (choice) 66%; Spiritwell (choice) 66%; Resonant Energy 66%; Power Surge 66%; Perfected Form 66%; Manifested Power 66%; Focused Outburst 66%; Energy Cycle 66%; Energy Conservation 66%; Empowered Surges 66%; Divine Halo 66%; Incessant Screams (choice) 65%; Sustained Potency (choice) 65%; Mental Decay 61%; Shattered Psyche 58%; Dark Evangelism 57%; Instilled Doubt 56%; Misery (choice) 55%; Psychic Voice (choice) 49%; Mastermind 48%; Angelic Bulwark 46%; Invoked Nightmare (choice) 45%; Improved Flash Heal 44%; Phantasm 42%; Shadowy Insight 39%; Shadowfiend 38%; Subservient Shadows 37%; Voidwraith 34%; Voidheart 34%; Void Infusion 34%; Void Blast 34%; Touch of the Void 34%; Quickened Pulse 34%; Overwhelming Shadows 34%; Inner Quietus 34%; Devour Matter 34%; Darkening Horizon (choice) 34%; Dark Energy (choice) 34%; Collapsing Void 34%; Phantom Reach 29%; Mindbender 27%; Inescapable Torment 27%; Idol of Y'Shaarj 27%; Embrace the Shadow (choice) 26%; Purify Disease 26%; Surge of Light 22%; False Autonomy 21%; Idol of C'Thun 11%; Holy Nova 10%

**Ours, against the whole sample:**

- `Dungeon`: 1 of 641 run it exactly. Typical has +Archon, +Crushing Void, +Dark Evangelism, +Divine Halo, +Empowered Surges, +Energy Conservation, +Energy Cycle, +Focused Outburst, +Incessant Screams, +Insidious Ire 2/2, +Manifested Power, +Mental Decay, +Misery, +Perfected Form, +Power Surge, +Psychic Voice, +Resonant Energy, +Shattered Psyche, +Spiritwell, +Sustained Potency, +Word of Supremacy; lacks Collapsing Void, Dark Energy, Darkening Horizon, Devour Matter, Embrace the Shadow, Idol of Y'Shaarj, Improved Flash Heal, Inescapable Torment, Inner Quietus, Invoked Nightmare, Mindbender, Overwhelming Shadows, Quickened Pulse, Shadowfiend, Shadowy Insight, Subservient Shadows, Touch of the Void, Void Blast, Void Infusion, Voidheart, Voidweaver, Voidwraith.

## Assassination Rogue

### Raid

917 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 305 distinct builds. Hero tree: Fatebound 98%, Deathstalker 2%. 1 left out: their log has no talents.

**Typical** (Fatebound, agreement 76% on 12 contested talents, 108 run it exactly):

`CMQAAAAAAAAAAAAAAAAAAAAAAYmlxsYwAAAAAAzygtZAAAAAAZbmZmZmZMWmZmZbmlZmZGjZGjxMzYMAGYBmxoxsBYbAbGAMzMGD`

**Most common other builds**, each against the typical:

- 51 (5.6%): +Fatal Concoction 1/2, +Scent of Blood 2/2, +Thistle Tea, +Thrown Precision; -Avulsion, -Fatal Concoction 2/2, -Regicide's Reward, -Thistle Tea
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAIbzMzMzMjx2MzMbzsMzMPgZMzYMMzYMAGYBmxoxsBYbAbGAMzMGD`
- 46 (5.0%): +Fatal Concoction 1/2, +Scent of Blood 2/2, +Thrown Precision; -Avulsion, -Fatal Concoction 2/2, -Regicide's Reward
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAIbzMzMzMjxyMzMbzsMzMPgZMzYMMzYMAGYBmxoxsBYbAbGAMzMGD`
- 30 (3.3%): +Thistle Tea; -Thistle Tea
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlxsYwAAAAAAzygtZAAAAAAZbmZmZmZM2mZmZbmlZmZGjZGjxMzYMAGYBmxoxsBYbAbGAMzMGD`
- 20 (2.2%): +Doomblade, +Improved Poisons, +Internal Bleeding, +Systemic Failure; -Canny Strikes, -Caustic Spatter, -Crimson Tempest, -Poison Bomb
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlxsNDGAAAAAYWGsNDAAAAAIbzMzMzMjxyMzMbzsMzMzYGzYMmZMMAGYBmxoxsBYbAbGAMzMGD`

**Split talents:** Iron Stomach 88%; Caustic Spatter 88%; Crimson Tempest 87%; Recuperator 86%; Poison Bomb 85%; Canny Strikes (choice) 84%; Death's Arrival (choice) 79%; Toxic Stiletto 75%; Thistle Tea (choice) 68%; Avulsion 66%; Regicide's Reward 55%; Scent of Blood 45%; Thrown Precision 43%; Airborne Irritant (choice) 36%; Thistle Tea (choice) 32%; Shadowrunner 21%; Inexorable March (choice) 19%; Doomblade 17%; Internal Bleeding (choice) 16%; Systemic Failure 13%; Improved Poisons 13%

**Ours, against the whole sample:**

- `Raid`: the typical build. 108 of 917 run it exactly.

### Mythic+

629 rankings over 8 dungeons, logged 2026-09-17 to 2026-10-18, keys 21 to 23 (median 22). 136 distinct builds. Hero tree: Deathstalker 90%, Fatebound 10%. 171 left out: their log has no talents.

**Typical** (Deathstalker, agreement 87% on 17 contested talents, 152 run it exactly):

`CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAotlxMzMzMGbzMzsNzyMz8AmxMjxwMjxAsZWGYALglhJwwiBzMAjxA`

**Most common other builds**, each against the typical:

- 149 (23.7%): +Avulsion, +Sudden Demise; -Zoldyck Recipe 2/2
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAotlxMzMzMGbzMzsNzyMz8AzMmZwMmZMGgNzyADYBsMMBGWMYmBYMGA`
- 20 (3.2%): +Avulsion, +Shadowrunner, +Sudden Demise; -Recuperator, -Zoldyck Recipe 2/2
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDAAAAAAzygtZAAAAAAttMmZmZmxYbmZmtZWmZmHYmxMDmxMjxAsZWGYALglhJwwiBzMAzMGA`
- 11 (1.7%): +Iron Stomach; -Featherfoot
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAotlZmZmZmxYbmZmtZWmZmHwMmZMGmZMGgNzyADYBsMMBGWAzMAjxA`
- 10 (1.6%): +Controlled Chaos, +Deal Fate, +Delivered Doom, +Edge Case, +Fate Intertwined, +Fatebound, +Inexorable March, +Lucky Coin, +Mean Streak, +Overflowing Purse, +Ravenholdt Mint, +Rush to the Inevitable, +Sometimes Lucky, +Tempted Fate; -Bait and Switch, -Clear the Witnesses, -Corrupt the Blood, -Darkest Night, -Deathstalker, -Hunt Them Down, -Lingering Darkness, -Mass Casualty, -Momentum of Despair, -Precise Killer, -Quietus Celeris, -Shadewalker, -Singular Focus, -Unshakeable Drive
  `CMQAAAAAAAAAAAAAAAAAAAAAAYmlZmFDGAAAAAYWGsNDAAAAAotlxMzMzMGbzMzsNzyMz8AmxMjxwMjxAYgFYGjGzCgtBsZAwMzYMA`

**Split talents:** Unshakeable Drive 90%; Singular Focus 90%; Quietus Celeris 90%; Precise Killer 90%; Mass Casualty 90%; Lingering Darkness (choice) 90%; Hunt Them Down 90%; Darkest Night 90%; Corrupt the Blood 90%; Clear the Witnesses 90%; Shadewalker (choice) 89%; Momentum of Despair (choice) 89%; Bait and Switch (choice) 88%; Recuperator 85%; Featherfoot 84%; Zoldyck Recipe 62%; Sudden Demise 50%; Avulsion 44%; Iron Stomach 18%; Shadowrunner 16%; Sometimes Lucky 10%; Rush to the Inevitable 10%; Ravenholdt Mint 10%; Overflowing Purse (choice) 10%; Mean Streak 10%; Lucky Coin 10%; Fate Intertwined 10%; Edge Case 10%; Delivered Doom 10%; Deal Fate 10%; Controlled Chaos 10%

**Ours, against the whole sample:**

- `Dungeon`: 10 of 629 run it exactly. Typical has +Bait and Switch, +Clear the Witnesses, +Corrupt the Blood, +Darkest Night, +Deathstalker, +Hunt Them Down, +Lingering Darkness, +Mass Casualty, +Momentum of Despair, +Precise Killer, +Quietus Celeris, +Shadewalker, +Singular Focus, +Unshakeable Drive; lacks Controlled Chaos, Deal Fate, Delivered Doom, Edge Case, Fate Intertwined, Fatebound, Inexorable March, Lucky Coin, Mean Streak, Overflowing Purse, Ravenholdt Mint, Rush to the Inevitable, Sometimes Lucky, Tempted Fate.

## Outlaw Rogue

### Raid

585 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 217 distinct builds. Hero tree: Trickster 100%, Fatebound 0%.

**Typical** (Trickster, agreement 69% on 7 contested talents, 8 run it exactly):

`CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMzMzsNzMzMjxsAmZbaZw2MAAAAAAbbzMzwMzMziZmZbAAAAYMAYMLGGYgZhFahNGgZGMDG`

**Most common other builds**, each against the typical:

- 55 (9.4%): +Heavy Hitter 1/2, +Stillshroud; -Blade Rush, -Shadowrunner
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMmZmtZmZmZMmF4BmZbaZw2MAAAAAAbbzMzwMzMziZmZbAAAAYmBAjZxwADMLsQLsxAMzgBG`
- 32 (5.5%): +Heavy Hitter 1/2; -Blade Rush
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMmZmtZmZmZMmF4BmZbaZw2MAAAAAAbbzMzwMzMziZmZbAAAAYMAYMLGGYgZhFahNGgZGMDG`
- 27 (4.6%): +Grand Melee, +Gravedigger 1/4, +Summarily Dispatched 2/2; -Gravedigger 4/4
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMzMzsNzMzMzMmFGmZbaZw2MAAAAAAbbzMzwMzMziZmZbAAAAYMAYMLGGYgZhFahNGgZGMDeA`
- 19 (3.2%): +Heavy Hitter 1/2, +Unbreakable Stride; -Blade Rush, -Shadowrunner
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMmZmtZmZmZMmF4BmZbaZw2MAAAAAAbbzMzwMzMziZmZbAAAAMjBAjZxwADMLsQLsxAMzgBG`

**Split talents:** Airborne Irritant (choice) 86%; Cheat Death (choice) 82%; Combat Stamina (choice) 81%; Acrobatic Strikes 68%; Grand Melee 55%; Blade Rush 53%; Heavy Hitter 52%; Shadowrunner 37%; Unbreakable Stride 27%; Stillshroud 25%; Summarily Dispatched 25%; Elusiveness (choice) 18%; Shiv 16%; Dancing Steel 16%; Deadly Pursuit 13%

**Ours, against the whole sample:**

- `Raid`: 8 of 585 run it exactly. Typical has +Acrobatic Strikes; lacks Grand Melee.

### Mythic+

717 rankings over 8 dungeons, logged 2026-09-05 to 2026-10-18, keys 19 to 23 (median 20). 133 distinct builds. Hero tree: Trickster 100%. 83 left out: their log has no talents.

**Typical** (Trickster, agreement 68% on 6 contested talents, 21 run it exactly):

`CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMzMzsNzMzMzMjFwMbTLD2mBAAAAAMbLzMzwMjZWMzMbDAAAAjBAjZxwADMLsQLsxAMzgBG`

**Most common other builds**, each against the typical:

- 67 (9.3%): +Gravedigger 1/4, +Heavy Hitter 1/2, +Summarily Dispatched 2/2; -Gravedigger 4/4
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMzMzsNzMzMzMjFGPwMbTLD2mBAAAAAMbLzMzwMjZWMzMbDAAAAjBAjZxwADMLsQLsxAMzgBeA`
- 58 (8.1%): +Gravedigger 1/4, +Heavy Hitter 1/2, +Shadowrunner, +Summarily Dispatched 2/2; -Gravedigger 4/4, -Shiv
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMzMzsNzMzMzMjFGPwMbTLD2mBAAAAAYbZmZGmZMziZmZbAAAAYMAYMLGGYgZhFahNGgZGMDeA`
- 46 (6.4%): +Improved Between the Eyes, +Zero In; -Acrobatic Strikes, -Sleight of Hand
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMjZmtZmZMzMzsAmZbaZw2MAAAAAgZbZmZGmZmZWMzMbDAAAAjBAjZxwADMLsQLsxAMzgBG`
- 38 (5.3%): +Shadowrunner; -Shiv
  `CQQAAAAAAAAAAAAAAAAAAAAAAAgx2MMzMzMzsNzMzMzMjFwMbTLD2mBAAAAAYbZmZGmZMziZmZbAAAAYMAYMLGGYgZhFahNGgZGMDG`

**Split talents:** Iron Stomach 87%; Acrobatic Strikes 75%; Airborne Irritant (choice) 75%; Sleight of Hand 74%; Summarily Dispatched 54%; Shiv 51%; Heavy Hitter 41%; Shadowrunner 41%; Zero In 36%; Improved Between the Eyes 34%; Gouge (choice) 23%; Stillshroud 19%

**Ours, against the whole sample:**

- `Dungeon`: 67 of 717 run it exactly. Typical has +Gravedigger 4/4; lacks Gravedigger 1/4, Heavy Hitter 1/2, Summarily Dispatched 2/2.

## Subtlety Rogue

### Raid

937 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 144 distinct builds. Hero tree: Trickster 97%, Deathstalker 3%.

**Typical** (Trickster, agreement 84% on 4 contested talents, 397 run it exactly):

`CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbLjxMjZgZmZGzMbzYGbbzMzMzMjBjZ2GAAAAGMGwYWMMwAzCL0iNMDYmBzYA`

**Most common other builds**, each against the typical:

- 86 (9.2%): +Warning Signs; -Planned Execution
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbbjxMjZgZmZGzMbzYGbbzMzMzMjBjZ2GAAAAGMGwYWMMwAzCL0iNMDYmBzYA`
- 25 (2.7%): +Shiv; -Iron Stomach
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbLjxMjZgZmZGzMbzYmZbbMzMzMjBjZ2GAAAAGMGwYWMMwAzCL0iNMDYmBzYA`
- 25 (2.7%): +Unbreakable Stride; -Airborne Irritant
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbLjxMjZgZmZGzMbzYG2mZmZmZGDGzsNAAAAmBjBMmFDDMwswCtYDzAmZwMGA`
- 16 (1.7%): +Shiv; -Airborne Irritant
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbLjxMjZgZmZGzMbzYmx2MzMzMzYwYmtBAAAgBjBMmFDDMwswCtYDzAmZwMGA`

**Split talents:** Improved Secret Technique 90%; Iron Stomach 87%; Airborne Irritant (choice) 86%; Planned Execution (choice) 74%; Warning Signs (choice) 26%; Shiv 20%; Finality 19%; Unbreakable Stride 12%

**Ours, against the whole sample:**

- `Raid`: 11 of 937 run it exactly. Typical has +Clever Combatant, +Cloud Cover, +Coup de Grace, +Danse Macabre, +Dark Shadow 2/2, +Devious Distractions, +Disorienting Strikes, +Flashing Steel, +Flawless Form, +Hoodwink, +Improved Secret Technique, +Nimble Flurry, +Planned Execution, +Smoke, +So Tricky, +Surprising Strikes, +Thousand Cuts, +Trickster; lacks Clear the Witnesses, Corrupt the Blood, Dark Brew, Dark Shadow 1/2, Darkest Night, Deathstalker, Ethereal Cloak, Finality 2/2, Hunt Them Down, Lingering Darkness, Mass Casualty, Momentum of Despair, Precise Killer, Quietus Celeris, Shadewalker, Singular Focus, Unshakeable Drive, Warning Signs.

### Mythic+

673 rankings over 8 dungeons, logged 2026-09-28 to 2026-10-18, keys 21 to 24 (median 22). 179 distinct builds. Hero tree: Trickster 85%, Deathstalker 15%. 127 left out: their log has no talents.

**Typical** (Trickster, agreement 82% on 22 contested talents, 37 run it exactly):

`CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbLjxMjZMMzMzwMbzYmZbZMzMzMjBjZ2GAAAAGMGwYWMMwAzCL0iNMDYmBzYA`

**Most common other builds**, each against the typical:

- 69 (10.3%): +Danse Macabre; -Veiltouched
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbLjxMMjhZmZGzMbzYmZbZMzMzMjBjZ2GAAAAGMGwYWMMwAzCL0iNMDYmBzYA`
- 36 (5.3%): +Dark Brew, +Finality 2/2; -Dark Shadow 2/2, -Improved Secret Technique
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbLjxMDjZmZmZGGbzYmZbZMzMzMjBjZ2GAAAAGMGwYWMMwAzCL0iNMDYmBzYA`
- 27 (4.0%): +Bait and Switch, +Clear the Witnesses, +Corrupt the Blood, +Dark Brew, +Darkest Night, +Deathstalker, +Finality 2/2, +Hunt Them Down, +Lingering Darkness, +Mass Casualty, +Momentum of Despair, +Precise Killer, +Quietus Celeris, +Shadewalker, +Singular Focus, +Unshakeable Drive; -Clever Combatant, -Cloud Cover, -Coup de Grace, -Dark Shadow 2/2, -Devious Distractions, -Disorienting Strikes, -Flashing Steel, -Flawless Form, -Hoodwink, -Improved Secret Technique, -Nimble Flurry, -Smoke, -So Tricky, -Surprising Strikes, -Thousand Cuts, -Trickster
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbLjxMDjZmZmZGGbzYmZbZMzMzMjBjZ2GAAAAGMmNzyADYBsMMBmFMDzMAzYA`
- 26 (3.9%): +Danse Macabre, +Iron Stomach; -Shiv, -Veiltouched
  `CUQAAAAAAAAAAAAAAAAAAAAAAAgx2MAAAAAwsMGLTMbLjxMMjhZmZGzMbzYGbLzMzMzMjBjZ2GAAAAGMGwYWMMwAzCL0iNMDYmBzYA`

**Split talents:** Featherfoot 90%; Shadowrunner 90%; Planned Execution (choice) 88%; Thousand Cuts (choice) 85%; Surprising Strikes 85%; Nimble Flurry 85%; Hoodwink 85%; Flawless Form 85%; Flashing Steel 85%; Disorienting Strikes 85%; Devious Distractions 85%; Coup de Grace 85%; Clever Combatant 85%; Potent Powder 85%; So Tricky (choice) 83%; Cloud Cover (choice) 81%; Smoke (choice) 79%; Shiv 75%; Dark Shadow 72%; Improved Secret Technique 65%; Veiltouched 61%; Danse Macabre 44%; Finality 44%; Iron Stomach 33%; Dark Brew 30%; Unshakeable Drive 15%; Singular Focus 15%; Quietus Celeris 15%; Precise Killer 15%; Momentum of Despair (choice) 15%; Mass Casualty 15%; Lingering Darkness (choice) 15%; Hunt Them Down 15%; Darkest Night 15%; Corrupt the Blood 15%; Clear the Witnesses 15%; Shadewalker (choice) 15%; Bait and Switch (choice) 15%; Toxic Stiletto 14%; Stillshroud 12%; Warning Signs (choice) 12%

**Ours, against the whole sample:**

- `Dungeon`: 12 of 673 run it exactly. Typical has +Clever Combatant, +Cloud Cover, +Coup de Grace, +Dark Shadow 2/2, +Devious Distractions, +Disorienting Strikes, +Flashing Steel, +Flawless Form, +Hoodwink, +Improved Secret Technique, +Nimble Flurry, +Planned Execution, +Shiv, +Smoke, +So Tricky, +Surprising Strikes, +Thousand Cuts, +Trickster; lacks Bait and Switch, Clear the Witnesses, Corrupt the Blood, Dark Brew, Darkest Night, Deathstalker, Finality 2/2, Hunt Them Down, Iron Stomach, Lingering Darkness, Mass Casualty, Momentum of Despair, Precise Killer, Quietus Celeris, Shadewalker, Singular Focus, Unshakeable Drive, Warning Signs.

## Elemental Shaman

### Raid

963 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 619 distinct builds. Hero tree: Farseer 100%. 1 left out: their log has no talents.

**Typical** (Farseer, agreement 64% on 17 contested talents, 3 run it exactly):

`CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMmZmZZbZMMjBAAAAsYmNYADY2YCMLAwsNzMjx2ipNmZMWmZmZMsMLzYxMDzsMAgBAmZMMMA`

**Most common other builds**, each against the typical:

- 15 (1.6%): +Earthgrab Totem, +Jet Stream, +Preeminence, +Refreshing Waters, +Tremor Totem; -Cleanse Spirit, -First Ascendant, -Poison Cleansing Totem, -Purge, -Windveil
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMmZmZZbZMMjBAAAAsYmNYADY2YCMLAwsNzMjx2yMtwMzGLzMzMmhZZYxMDzsNAgBAmZMMMA`
- 13 (1.3%): +Ascending Air; -Totemic Focus
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMmZmZZbZMMjBAAAAsYmNYADY2YCMLAwsNzMjx2ipNmZWGLzMzMGWsMjFzMMzyAAGAYmxwwA`
- 12 (1.2%): +Ascending Air, +Astral Bulwark, +Crackling Fury 2/2, +Flames of the Cauldron, +Purging Flames, +Swelling Maelstrom, +Voltaic Blaze; -Earthen Rage, -Elemental Unity, -Everlasting Elements, -Flames of the Firelord, -Fusion of Elements, -Planes Traveler, -Power of the Maelstrom, -Windveil
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhZAAAAgFzsBDYAzGTgZBAmtZmZM2WMtxMzyYbmZmxwysMmlhxMzCAwAAzMGGGA`
- 9 (0.9%): +Ascending Air, +Spirit Wolf; -Thunderous Paws, -Windveil
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMmZmZZbZMMjBAAAAsYmNYADY2YCMLAwsMzMjx2ipNmZWGLzMzMGWmlhFzMMzyAAGAYmxwwA`

**Split talents:** Capacitor Totem 89%; First Ascendant (choice) 76%; Earthquake (choice) 72%; Cleanse Spirit 69%; Purge (choice) 69%; Thunderous Paws (choice) 68%; Flames of the Firelord 65%; Totemic Focus 62%; Windveil 58%; Poison Cleansing Totem (choice) 55%; Voltaic Blaze 53%; Purging Flames 53%; Crackling Fury 53%; Flames of the Cauldron 51%; Elemental Unity 50%; Power of the Maelstrom 47%; Fusion of Elements 47%; Earthen Rage 47%; Everlasting Elements 44%; Swelling Maelstrom 36%; Jet Stream (choice) 35%; Ascending Air (choice) 33%; Earthgrab Totem 33%; Spirit Wolf (choice) 32%; Refreshing Waters 31%; Earthquake (choice) 28%; Preeminence (choice) 24%; Totemic Surge 21%; Lava Flows 19%; Frost Shock 17%; Tremor Totem (choice) 15%; Static Charge 11%; Mana Spring 10%

**Ours, against the whole sample:**

- `Raid`: 2 of 963 run it exactly. Typical has +Earthen Rage, +Elemental Unity, +Everlasting Elements, +Flames of the Firelord, +Fusion of Elements, +Power of the Maelstrom; lacks Crackling Fury 2/2, Flames of the Cauldron, Purging Flames, Swelling Maelstrom, Voltaic Blaze.

### Mythic+

625 rankings over 8 dungeons, logged 2026-09-24 to 2026-10-18, keys 22 to 24 (median 22). 356 distinct builds. Hero tree: Farseer 100%. 175 left out: their log has no talents.

**Typical** (Farseer, agreement 65% on 11 contested talents, 9 run it exactly):

`CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhZAAAAgFzsBDYAzGTgZBAmlZmZM2WMtxMz2YZGzMGzysMzsMMmZWAAGAYmxwwA`

**Most common other builds**, each against the typical:

- 21 (3.4%): +Winds of Al'Akir 2/2; -Jet Stream, -Totemic Focus
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhZAAAAgFzsBDYAzGTgZBAmlZmZM2WMtxMjxyMzMjxsYZmZZYMzsAAMAwMjhhB`
- 11 (1.8%): +Thunderous Paws; -Spirit Wolf
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhZAAAAgFzsBDYAzGTgZBAmtZmZM2WMtxMz2YZGzMGzysMzsMMmZWAAGAYmxwwA`
- 8 (1.3%): +Static Charge 1/2, +Thunderous Paws; -Spirit Wolf, -Totemic Focus
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhZAAAAgFzsBDYAzGTgZBAmtZmZM2WMtxMz2YZGzMPwYWsMzsMMmZWAAGAYmxwwA`
- 8 (1.3%): +Spirit Walk, +Thunderous Paws; -Gust of Wind, -Spirit Wolf
  `CYQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMbbzMGjZZbZMmhZAAAAgFzsBDYAzGTgZBAmtZmZMWWMtxMz2YZGzMGzysMzsMMmZWAAGAYmxwwA`

**Split talents:** Earthquake (choice) 87%; Poison Cleansing Totem (choice) 79%; Hex 75%; Therazane's Resilience (choice) 68%; Gust of Wind (choice) 65%; Winds of Al'Akir 61%; Chain Heal 60%; Earth Shield 59%; Elemental Orbit 58%; Totemic Focus 58%; Spirit Wolf (choice) 55%; Jet Stream (choice) 53%; Ancestral Wolf Affinity 46%; Static Charge 45%; Thunderous Paws (choice) 44%; Spirit Walk (choice) 35%; Earthgrab Totem 17%; Totemic Surge 13%; Tremor Totem (choice) 13%; Earthquake (choice) 13%

**Ours, against the whole sample:**

- `Dungeon`: 11 of 625 run it exactly. Typical has +Spirit Wolf; lacks Thunderous Paws.

## Enhancement Shaman

### Raid

709 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 335 distinct builds. Hero tree: Stormbringer 100%. 2 left out: their log has no talents.

**Typical** (Stormbringer, agreement 68% on 10 contested talents, 2 run it exactly):

`CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZZGzYssYsxMz2YZmZmhxyYGAgZYMzwMBmZwgxA`

**Most common other builds**, each against the typical:

- 42 (5.9%): +Static Charge 2/2; -Earthgrab Totem, -Totemic Focus
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZZGzYssYsxMz2YZmZmZwCzAAMDjZGmJwMDGMGA`
- 19 (2.7%): +Static Charge 2/2, +Thunderous Paws; -Earthgrab Totem, -Spirit Wolf, -Totemic Focus
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZbGzYssYsxMz2YZmZmZwCzAAMDjZGmJwMDGMGA`
- 18 (2.5%): +Mana Spring, +Refreshing Waters, +Totemic Projection; -Cleanse Spirit, -Poison Cleansing Totem, -Purge
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZZGzMjllZgZmNWmZmZYYMDAwMMmZMzEYmBDGDA`
- 16 (2.3%): +Mana Spring, +Refreshing Waters; -Cleanse Spirit, -Purge
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZZGzMjllZsxMzGLzMzMMMmBAYGGzMMTgZGMYMA`

**Split talents:** Jet Stream (choice) 84%; Supercharge (choice) 81%; Spirit Walk (choice) 77%; Totemic Focus 76%; Poison Cleansing Totem (choice) 69%; Earthgrab Totem 67%; Totemic Surge 67%; Spirit Wolf (choice) 61%; Refreshing Waters 59%; Cleanse Spirit 53%; Static Charge 49%; Purge (choice) 44%; Thunderous Paws (choice) 39%; Totemic Projection 36%; Mana Spring 35%; Gust of Wind (choice) 23%; Storm Swell (choice) 19%; Tremor Totem (choice) 16%; Ancestral Wolf Affinity 12%; Ascending Air (choice) 10%

**Ours, against the whole sample:**

- `Raid`: 8 of 709 run it exactly. Typical has +Cleanse Spirit, +Purge; lacks Refreshing Waters, Totemic Projection.

### Mythic+

704 rankings over 8 dungeons, logged 2026-09-06 to 2026-10-18, keys 19 to 22 (median 20). 355 distinct builds. Hero tree: Stormbringer 100%. 96 left out: their log has no talents.

**Typical** (Stormbringer, agreement 71% on 9 contested talents, 44 run it exactly):

`CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZbGzYssMjNmZ2GLzMzMMWGzAAMDjZGGBmZwgxA`

**Most common other builds**, each against the typical:

- 21 (3.0%): +Hex; -Cleanse Spirit
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZbGzYssMjNmZ2YZmZmhZWGzAAMDjZGGBmZwgxA`
- 19 (2.7%): +Hex, +Spirit Wolf, +Static Charge 2/2; -Earthgrab Totem, -Refreshing Waters, -Thunderous Paws, -Totemic Focus
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZZGzYssYsxMz2YZmZmZYWYGAgZYMzwIwMDGMGA`
- 18 (2.6%): +Spirit Wolf, +Static Charge 2/2, +Totemic Surge; -Earthgrab Totem, -Refreshing Waters, -Thunderous Paws, -Totemic Focus
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZZGzYssYsxMz2YZmZmZwCzAAMDjZGmJwMDGMGA`
- 15 (2.1%): +Hex; -Purge
  `CcQAAAAAAAAAAAAAAAAAAAAAAMzMzgZmZmZmhZmZAAAAAAAAA2AsZGDbwCMDDNYBgZbGzYssMjNmZ2GLzMzMMjxMAAzwYmhRgZGMYMA`

**Split talents:** Poison Cleansing Totem (choice) 78%; Cleanse Spirit 77%; Jet Stream (choice) 75%; Earthgrab Totem 67%; Purge (choice) 67%; Refreshing Waters 65%; Thunderous Paws (choice) 60%; Totemic Focus 57%; Static Charge 55%; Hex 42%; Spirit Wolf (choice) 40%; Totemic Surge 27%; Healing Stream Totem 15%; Ancestral Wolf Affinity 14%; Elemental Resistance 13%; Tremor Totem (choice) 12%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 44 of 704 run it exactly.

## Restoration Shaman

### Raid

965 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 515 distinct builds. Hero tree: Totemic 100%.

**Typical** (Totemic, agreement 69% on 11 contested talents, 7 run it exactly):

`CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsssNjZGjZGzMYsAbwMW0YbAMDsZGmhZbMzMNbLzMbmxswyMmZMYWGAAAYmZwMDAMYG`

**Most common other builds**, each against the typical:

- 36 (3.7%): +Earthgrab Totem, +Improved Purify Spirit, +Winds of Al'Akir 1/2; -Capacitor Totem, -Earth Elemental, -Primordial Bond
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsssNjZGjZGzMDjFYDmxiGbDgZgNzwMYbMmpZbZmZzMmFWMPwMjZYWGAAAYmZwMDAMYG`
- 25 (2.6%): +Improved Purify Spirit, +Winds of Al'Akir 1/2; -Earth Elemental, -Primordial Bond
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsssNjZGjZGzMDjFYDmxiGbDgZgNzwMMbjxMNbLzMbmxswi5BmZMYWGAAAYmZwMDAMYG`
- 25 (2.6%): +Winds of Al'Akir 2/2; -Earth Elemental, -Primordial Bond
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsssNjZGjZGzMYsAbwMW0YbAMDsZGmhZbMmpZbZmZzMmFWMzMjBzyAAAAzMDmZAgBzA`
- 17 (1.8%): +Winds of Al'Akir 2/2; -Capacitor Totem, -Wind Shear
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsssNjZGjZGzMYsAbwMW0YbAMDsZGmBbjZmpZbZmZzMmFWmZMjBzyAAAAzMDmZAgBzA`

**Split talents:** Winds of Al'Akir 89%; Amplification Core (choice) 87%; Overflowing Shores 86%; Coalescing Water 85%; Torrent 73%; Wind Shear 71%; Thunderous Paws (choice) 68%; Poison Cleansing Totem (choice) 66%; Ascending Air (choice) 62%; Earth Elemental 56%; Primordial Bond 53%; Capacitor Totem 50%; Acid Rain 37%; Spirit Wolf (choice) 32%; Jet Stream (choice) 24%; Improved Purify Spirit 20%; Chain Lightning 15%; Tremor Totem (choice) 15%; Earthgrab Totem 15%; Oversurge (choice) 13%

**Ours, against the whole sample:**

- `Raid`: 4 of 965 run it exactly. Typical has +Capacitor Totem, +Primordial Bond; lacks Winds of Al'Akir 2/2.

### Mythic+

733 rankings over 8 dungeons, logged 2026-09-10 to 2026-10-18, keys 21 to 23 (median 21). 502 distinct builds. Hero tree: Totemic 100%, Farseer 0%. 67 left out: their log has no talents.

**Typical** (Totemic, agreement 61% on 9 contested talents, 10 run it exactly):

`CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsstMmZmZMzYMMsAbwMW0YbAMDshZmhZbmZGNLLzMbmxglZMzYwsMDAADgZGMzAwYwA`

**Most common other builds**, each against the typical:

- 11 (1.5%): +Improved Earthliving Weapon, +Improved Purify Spirit, +Jet Stream; -Earth Elemental, -Primordial Bond, -Tidewaters
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsstMmZmZMzMjZMsAbwMW0YbAMDshZGMbzMGNLLzMbmxsxixMjBzyMAAMAmZwMDAjBD`
- 8 (1.1%): +Earthweaver, +Improved Purify Spirit, +Purge; -Tidewaters, -Wind Rush Totem, -Windveil
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsstMmZmZmZGjZMsAbwMW0YbAMDshZGMbzMzoZZZmZzMGsMjZGDLzCAAMAmZwMDAjBD`
- 7 (1.0%): +Improved Purify Spirit, +Jet Stream; -Earth Elemental, -Primordial Bond
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsstMmZmZMzYMjhFYDmxiGbDgZgNMzMMbzMGNLLzMbmxsxixMjBzyMAAMAmZwMDAjBD`
- 7 (1.0%): +Earthgrab Totem, +Gust of Wind, +Jet Stream, +Purge, +Tremor Totem; -Earth Elemental, -Poison Cleansing Totem, -Primordial Bond, -Spirit Walk, -Windveil
  `CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsstMmZmZMzYMMsAbwMW0YbAMDshZmhZbmxoZbZmZxMmNWMmZMjlZZAAwAYmBzMAMGMA`

**Split talents:** Unleash Life 89%; Earthen Accord 77%; Poison Cleansing Totem (choice) 70%; Thunderous Paws (choice) 64%; Spirit Walk (choice) 60%; Windveil 57%; Purge (choice) 47%; Earth Elemental 47%; Primordial Bond 46%; Jet Stream (choice) 45%; Improved Purify Spirit 41%; Gust of Wind (choice) 38%; Tidewaters 37%; Spirit Wolf (choice) 36%; Improved Earthliving Weapon 30%; Hex 24%; Current Control 22%; Earthweaver 17%; Crashing Waves 14%; Soothing Rain 12%; Earthgrab Totem 11%; Mana Spring 11%

**Ours, against the whole sample:**

- `Dungeon`: 3 of 733 run it exactly. Typical has +Earth Elemental, +Primordial Bond, +Tidewaters; lacks Improved Earthliving Weapon, Jet Stream, Purge.

## Affliction Warlock

### Raid

743 rankings over 10 bosses, logged 2026-10-13 to 2026-10-18. 361 distinct builds. Hero tree: Hellcaller 74%, Soul Harvester 26%.

**Typical** (Hellcaller, agreement 75% on 30 contested talents, 16 run it exactly):

`CkQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMMzMzsMAAAzMLzyMzsMGAwCMwsY0YGAzCYZAAAYGAAYmBzMjZGmZYmxMzYwMzMAAzAD`

**Most common other builds**, each against the typical:

- 83 (11.2%): +Blight of Tongues; -Curse of Tongues
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMMzMzsMAAAzMLzyMzsMGAwCMwsY0YGAzCYZAAAYGAAYmBzMjxsZmhZGzMjBzMzAAMDMA`
- 23 (3.1%): +Blight of Tongues, +Shadowfury; -Curse of Tongues, -Swift Artifice
  `CkQAAAAAAAAAAAAAAAAAAAAAAgxMzoZjx2MzMzyAAAMzsMLzMzyYAALwAziRjZAMLglBAAgZAAgZGMzMGzmZGmZMzMGMzMDAwMwA`
- 20 (2.7%): +Cull the Weak, +Demoniac's Fervor, +Eternal Hunger, +Eternal Servitude, +Feast of Souls, +Friends In Dark Places, +Hedonic Gorging, +Manifested Avarice, +Necrolyte Teachings, +Nether Plating, +Potent Soul Shards, +Quietus, +Sataiel's Volition, +Seeds of Destruction 2/2, +Shadow of Death, +Shadowfury, +Shared Vessel, +Soul Anathema, +Soul Harvester, +Sow the Seeds, +Sudden Onset, +Wicked Reaping; -Abyss Walker, -Alzzin's Iniquity, -Blackened Soul, -Cascading Calamity, -Curse of the Satyr, -Devil Fruit, -Eye Contract, -Fatal Echoes, -Hatefury Rituals, -Hellcaller, -Malediction, -Malefic Grasp, -Malevolence, -Mark of Peroth'arn, -Mark of Xavius, -Sacrolash's Dark Strike, -Seeds of Their Demise, -Through the Felvine, -Xalan's Cruelty, -Xalan's Ferocity, -Xavius' Gambit 2/2, -Zevrim's Resilience
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbM2mZGzyAAAmZmlZxMzyYAgx2yADYAzwWghtBAAgZAAAMzMzMmZMGzYMzMzYYmZGAgBMA`
- 19 (2.6%): +Empowered Drain Life, +Gorefiend's Avarice, +Ichor of Devils, +Infernal Beneficiary; -Curse of Tongues, -Foul Mouth, -Frequent Donor, -Frequent Traveler
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZhhZmZmlBAAYmZZWmZmlxAAWgBmFjGzAYWALDAAAzAAAzMgZmxwMDzMmZGDmZmZAAzAD`

**Split talents:** Swift Artifice 90%; Curse of Exhaustion 88%; Frequent Donor (choice) 86%; Xavius' Gambit 84%; Cascading Calamity 84%; Eye Contract 84%; Malediction 84%; Strength of Will (choice) 83%; Malefic Grasp 81%; Fatal Echoes 80%; Frequent Traveler 78%; Xalan's Ferocity 74%; Xalan's Cruelty 74%; Through the Felvine 74%; Seeds of Their Demise 74%; Mark of Xavius 74%; Mark of Peroth'arn 74%; Malevolence 74%; Devil Fruit 74%; Blackened Soul 74%; Alzzin's Iniquity 74%; Zevrim's Resilience (choice) 72%; Curse of the Satyr (choice) 70%; Hatefury Rituals (choice) 69%; Foul Mouth 66%; Abyss Walker 63%; Sacrolash's Dark Strike 61%; Curse of Tongues 45%; Gorefiend's Avarice 40%; Blight of Tongues (choice) 32%; Sudden Onset 30%; Shadowfury (choice) 29%; Empowered Drain Life 28%; Cull the Weak 28%; Wicked Reaping 26%; Soul Anathema 26%; Shared Vessel 26%; Shadow of Death 26%; Sataiel's Volition 26%; Quietus 26%; Necrolyte Teachings 26%; Manifested Avarice 26%; Eternal Hunger 26%; Demoniac's Fervor 26%; Banish 24%; Feast of Souls (choice) 23%; Friends In Dark Places (choice) 22%; Sow the Seeds 20%; Seeds of Destruction 20%; Nether Plating 19%; Potent Soul Shards 19%; Hedonic Gorging 19%; Eternal Servitude (choice) 19%; Dark Accord (choice) 17%; Ichor of Devils (choice) 14%; Infernal Beneficiary 14%; Oppressive Darkness 11%; Fel Pact 10%

**Ours, against the whole sample:**

- `Raid`: the typical build. 16 of 743 run it exactly.

### Mythic+

636 rankings over 8 dungeons, logged 2026-09-02 to 2026-10-18, keys 17 to 21 (median 18). 236 distinct builds. Hero tree: Soul Harvester 99%, Hellcaller 1%. 164 left out: their log has no talents.

**Typical** (Soul Harvester, agreement 64% on 15 contested talents, 1 run it exactly):

`CkQAAAAAAAAAAAAAAAAAAAAAAwMjZGNbmZ2mZGzyAAAmZmlZxMz2YAgx2yADYAzwWghtBAAgZAAAMzMmxM2GjZMmZmhhZmZAAmBG`

**Most common other builds**, each against the typical:

- 39 (6.1%): +Absolute Corruption, +Cascading Calamity, +Curse of Exhaustion, +Gorefiend's Resolve, +Malediction, +Malefic Grasp, +Xavius' Gambit 2/2; -Death's Embrace, -Eternal Servitude, -Gorefiend's Avarice, -Hedonic Gorging, -Niskaran Methods, -Ravenous Afflictions, -Siphon Life, -Sudden Onset
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzYWGAAwMmlZZmZWGDAM22GYADYG2CMsNAAAMAAAMzMmxMzGDzMzMzwMMzMDAwMwA`
- 34 (5.3%): +Dark Accord, +Empowered Drain Life, +Gorefiend's Resolve; -Empowered Healthstone, -Eternal Servitude, -Strength of Will
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMjZGNbmZ2mZGz2AAAmZmlZxMz2YAgx22ADYAzwWghtBAAgZAAAMzMmxM2GjZMmZmhhZmxAAmBG`
- 22 (3.5%): +Curse of Exhaustion, +Potent Soul Shards; -Banish, -Eye Contract
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMjZGNbmx2MzYWGAAwMzsMLmZ2GDAM2WGYADYG2CMsNAAAMDAAgZmxMmZ2GjZMmZmZMMzMDAwAG`
- 11 (1.7%): +Absolute Corruption, +Cascading Calamity, +Fatal Echoes, +Frequent Traveler, +Gorefiend's Resolve, +Malediction, +Malefic Grasp, +Xavius' Gambit 2/2; -Death's Embrace, -Eternal Servitude, -Eye Contract, -Gorefiend's Avarice, -Hedonic Gorging, -Niskaran Methods, -Ravenous Afflictions, -Siphon Life, -Sudden Onset
  `CkQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzYWGAAwMmlZZmZWGDAM22GYADYG2CMsNAAAMAAAMzMzMmxGzYmZmZGmhZmZAAGwA`

**Split talents:** Improved Mortal Coil 90%; Fiendish Stride 87%; Blight of Tongues (choice) 81%; Strength of Will (choice) 77%; Oppressive Darkness 71%; Banish 63%; Eye Contract 61%; Niskaran Methods 59%; Ravenous Afflictions 58%; Death's Embrace 57%; Siphon Life (choice) 56%; Hedonic Gorging 56%; Sudden Onset 55%; Curse of Exhaustion 54%; Eternal Servitude (choice) 52%; Malediction 47%; Gorefiend's Resolve (choice) 46%; Xavius' Gambit 46%; Cascading Calamity 46%; Malefic Grasp 44%; Fel Synergy 44%; Absolute Corruption (choice) 44%; Potent Soul Shards 33%; Gorefiend's Avarice 30%; Dark Accord (choice) 23%; Abyss Walker 21%; Empowered Drain Life 14%; Frequent Traveler 13%

**Ours, against the whole sample:**

- `Dungeon`: 2 of 636 run it exactly. Typical has +Eye Contract, +Gorefiend's Avarice; lacks Curse of Exhaustion, Potent Soul Shards.

## Demonology Warlock

### Raid

921 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 471 distinct builds. Hero tree: Diabolist 100%. 1 left out: their log has no talents.

**Typical** (Diabolist, agreement 77% on 10 contested talents, 32 run it exactly):

`CoQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMMzMzsMAAAAAAAgxMGWgB2GWohFjZGLzyMzMmBAmZMzMmZAmZGzMAAAjZmZMMsMjBMA`

**Most common other builds**, each against the typical:

- 19 (2.1%): +Shadowfury; -Abyss Walker
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbM2mZGzyAAAAAAAAGzYYBGYbYhGWMmZsMLzMzYGAYmxMzYmBYmZMzAAAMmZmxwwyMGwA`
- 16 (1.7%): +Banish, +Gorefiend's Avarice; -Curse of Exhaustion, -Foul Mouth
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjZMzMzsMAAAAAAAgxMGWgB2GWohFjZGLzyMzMmBAmZMzMmZAMzYGAAAjZmZMMsMjBMA`
- 15 (1.6%): +Banish, +Howl of Terror; -Curse of Exhaustion, -Foul Mouth
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMzyMzMzyAAAAAAAAGzYYBGYbYhGWMmZsMLzMzYGAYmxMzYmBwMjZAAAMmZmxwwyMGwA`
- 12 (1.3%): +Gorefiend's Avarice; -Foul Mouth
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjhZmZmlBAAAAAAAMmxwCMw2wCNsYMzYZWmZmxMAwMjZmxMDgZGzMAAAjZmZMMsMjBMA`

**Split talents:** Improved Mortal Coil 89%; Curse of Tongues 84%; Mark of Shatug (choice) 84%; Practiced Rituals 83%; Frequent Traveler 82%; Strength of Will (choice) 73%; Foul Mouth 69%; Curse of Exhaustion 67%; Abyss Walker 55%; Banish 47%; Shadowfury (choice) 32%; Dark Accord (choice) 27%; Howl of Terror (choice) 21%; Oppressive Darkness 19%; Summon Felguard 18%; Gorefiend's Avarice 17%; Mark of F'harg (choice) 16%; Fel Pact 13%; Blight of Tongues (choice) 12%; Demonic Resilience 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 32 of 921 run it exactly.

### Mythic+

656 rankings over 8 dungeons, logged 2026-09-09 to 2026-10-18, keys 20 to 23 (median 20). 238 distinct builds. Hero tree: Diabolist 100%. 144 left out: their log has no talents.

**Typical** (Diabolist, agreement 72% on 8 contested talents, 27 run it exactly):

`CoQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzMzyAAAAAAAAGzYYBGYbYhGWMmZsMLzMzYGAYmxMzYmBYMjZsBAAGzMzYYYZGDYA`

**Most common other builds**, each against the typical:

- 25 (3.8%): +Mark of F'harg; -Mark of Shatug
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzMzyAAAAAAAAGzYYBGYbYhGWMmZsMbzMzYGAYmxMzYmBYMjZsBAAGzMzYYYZGDYA`
- 24 (3.7%): +Frequent Traveler; -Abyss Walker
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzYWGAAAAAAAwYGDLwAbDL0wixMjlZZmZGzAAzMmZGzMAzMjZsBAAGzMzYYYZGDYA`
- 20 (3.0%): +Fel Synergy 2/2; -Abyss Walker, -Oppressive Darkness
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMz2MzYWGAAAAAAAwYGDLwAbDL0wixMjlZZmZGzAAzMmZGzMAjZMjNAAwYmZGDDLzYAD`
- 17 (2.6%): +Curse of Exhaustion, +Dark Accord, +Fel Synergy 1/2; -Banish, -Fortified Soul, -Strength of Will
  `CoQAAAAAAAAAAAAAAAAAAAAAAwMegZGNbmx2MzMz2AAAAAAAAGzYYBGYbYhGWMmZsMLzMzYGAYmxMzYmBYMjZmNAAwYmxYYYZGDYA`

**Split talents:** Fortified Soul 86%; Improved Mortal Coil 84%; Banish 78%; Blight of Tongues (choice) 74%; Oppressive Darkness 73%; Mark of Shatug (choice) 64%; Strength of Will (choice) 60%; Fel Synergy 55%; Abyss Walker 52%; Dark Accord (choice) 40%; Mark of F'harg (choice) 36%; Curse of Exhaustion 27%; Blight of Weakness (choice) 18%; Gorefiend's Avarice 14%

**Ours, against the whole sample:**

- `Dungeon`: 25 of 656 run it exactly. Typical has +Mark of Shatug; lacks Mark of F'harg.

## Destruction Warlock

### Raid

548 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 427 distinct builds. Hero tree: Hellcaller 97%, Diabolist 3%. 1 left out: their log has no talents.

**Typical** (Hellcaller, agreement 74% on 15 contested talents, 1 run it exactly):

`CsQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjhZmZmlZZmZmZxY2WMDAAmxYmZWsADMLGNmBwshNGAAYMAbAAzMYmZMGAAAmZmBAgxwA`

**Most common other builds**, each against the typical:

- 7 (1.3%): +Dark Accord, +Teachings of the Black Harvest; -Foul Mouth, -Strength of Will
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZbMMzMzsNLzMzMLGz2iZAAwMGzMziFYgZxoxMAmNsxAAAjBYDAYmBmZMGAAAmZmBAgxwA`
- 7 (1.3%): +Blight of Tongues; -Gorefiend's Avarice
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMMzMzsMLzMzMLGz2iZAAwMGzMziFYgZxoxMAmNsxAAAjBYDAYmBzMjxsBAAYmZGAAGDD`
- 7 (1.3%): +Backlash 1/2, +Blight of Tongues, +Dark Accord, +Practiced Chaos; -Backlash 2/2, -Gorefiend's Avarice, -Strength of Will
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbMMzMzsNLzMzMLGz2iHYAAwMGzMziFYgZxoxMAmNsxAAAjBGbAAzMYmZMmNAAAzMzAAwYYA`
- 5 (0.9%): +Backlash 1/2, +Chaotic Inferno, +Empowered Drain Life; -Abyss Walker, -Backlash 2/2
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjhZmxsMLzMzMLGz2iHYAAwMzYmZWsADMLGNmBwshNGAAYMAbAAzMYmZMGAAAmZmZAAMGG`

**Split talents:** Fiendish Stride 89%; Swift Artifice 88%; Backlash 88%; Rain of Fire (choice) 88%; Curse of Exhaustion 87%; Improved Havoc 85%; Strength of Will (choice) 78%; Frequent Traveler 75%; Curse of the Satyr (choice) 75%; Frequent Donor (choice) 75%; Foul Mouth 71%; Abyss Walker 70%; Havoc (choice) 48%; Gorefiend's Avarice 42%; Mayhem (choice) 40%; Chaotic Inferno 38%; Curse of Tongues 35%; Shadowfury (choice) 34%; Banish 30%; Practiced Chaos 26%; Ichor of Devils (choice) 25%; Empowered Drain Life 24%; Dark Accord (choice) 22%; Aura of Enfeeblement (choice) 22%; Blight of Tongues (choice) 20%; Cataclysm 18%; Howl of Terror (choice) 13%; Rain of Fire (choice) 12%; Demonic Resilience 12%; Fel Pact 11%; Oppressive Darkness 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 1 of 548 run it exactly.

### Mythic+

565 rankings over 8 dungeons, logged 2026-08-29 to 2026-10-18, keys 17 to 22 (median 18). 263 distinct builds. Hero tree: Diabolist 96%, Hellcaller 4%. 235 left out: their log has no talents.

**Typical** (Diabolist, agreement 73% on 12 contested talents, 21 run it exactly):

`CsQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzMz2MzYWmNzMzsYmZZZMAAYGjZmZBMmxwCMw2wCNWYAAgxgBAYmBYMjZmNAAAzMzAAgZYA`

**Most common other builds**, each against the typical:

- 21 (3.7%): +Fel Synergy 2/2, +Ichor of Devils; -Banish, -Blight of Tongues, -Frequent Donor
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMmZGNLmx2MzYWmNzMzsYmZZZMAAYGjZmZBMmxwCMw2wCNWYAAgxgBAYmBYMjZGAAAmZmBAAzwA`
- 19 (3.4%): +Alythess's Ire, +Devastation 1/2, +Fel Synergy 2/2; -Banish, -Blight of Tongues, -Devastation 2/2
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMmZGNbmx2MzYWmNzMzsYmZZZMAAYGjZmZBMmxwCMw2wCNWYAAgxMMAAzMAjZMzAAAwMzMAA4BGG`
- 11 (1.9%): +Avatar of Destruction, +Dark Accord, +Frequent Traveler, +Improved Havoc, +Soul Fire; -Banish, -Devastation 2/2, -Lake of Fire, -Strength of Will
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMMzoZzM2mZGz2sNzMzsYmZZZMAAYGjZmZBMmxwCMw2wCNWYAAgxAsBgZGgZmxMzGAAgZmZAAYMM`
- 11 (1.9%): +Alythess's Ire, +Dark Accord, +Devastation 1/2, +Fel Synergy 1/2; -Curse of Exhaustion, -Devastation 2/2, -Strength of Will
  `CsQAAAAAAAAAAAAAAAAAAAAAAwMegZGNbmZ2mZGz2sZmZmFzMLLjBAAzYMzMLgxMGWgB2GWoxCDAAMmhBAYmBYMjZsBAAYmZGAA8ADD`

**Split talents:** Improved Mortal Coil 90%; Fiendish Stride 90%; Swift Artifice 88%; Infernal Vitality (choice) 88%; Oppressive Darkness 80%; Frequent Donor (choice) 80%; Rain of Fire (choice) 77%; Strength of Will (choice) 69%; Devastation 69%; Curse of Exhaustion 68%; Fel Synergy 64%; Blight of Tongues (choice) 61%; Banish 47%; Soul Fire (choice) 33%; Alythess's Ire 33%; Dark Accord (choice) 31%; Rain of Fire (choice) 23%; Abyss Walker 21%; Gorefiend's Avarice 21%; Ichor of Devils (choice) 20%; Improved Havoc 18%; Avatar of Destruction 17%; Empowered Drain Life 11%

**Ours, against the whole sample:**

- `Dungeon`: the typical build. 21 of 565 run it exactly.

## Arms Warrior

### Raid

1000 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 308 distinct builds. Hero tree: Slayer 100%.

**Typical** (Slayer, agreement 76% on 10 contested talents, 89 run it exactly):

`CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzYmZGAAAghphZGzMWmZmZGMmZAAAAAMzyMDMhxy2ALgBMDTgZwGYmhx2ALzsNAzMAYGGA`

**Most common other builds**, each against the typical:

- 46 (4.6%): +Bloodborne 2/2, +Fierce Followthrough, +Just Warming Up; -Broad Strokes, -Dreadnaught, -Opportunist, -Powerful Momentum
  `CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzMmZGAAAghphZGzMWmZmZGMmZAAAAAMzyMDIMWWGYBMgZYCMD2AzMM2GYZmlBYmBAzwA`
- 37 (3.7%): +Shockwave; -Second Wind
  `CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzYmZGAAAghphxYmxyMzMzwMmZAAAAAMzyMDMhxy2ALgBMDTgZwGYmhx2ALzsNAzMAYGGA`
- 32 (3.2%): +Collateral Damage, +Fervor of Battle; -Bloodsurge, -Fatality
  `CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphZGzMWmZmZGMmZAAAAAMWmZgJMW2GYBMgZYCMD2AzMM2GMLzsNAzMAYGGA`
- 27 (2.7%): +Bloodborne 1/2, +Fierce Followthrough; -Dreadnaught, -Opportunist
  `CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMz8AmZGAAAghphZGzMWmZmZGMmZAAAAAMzyMDMhxyyALgBMDTgZwGYmhx2ALzsNAzMAYGGA`

**Split talents:** Broad Strokes (choice) 88%; Wrecking Throw (choice) 88%; Powerful Momentum 86%; Fatality 82%; Dreadnaught 75%; Opportunist (choice) 72%; Bloodsurge 70%; Storm Bolt 70%; Piercing Howl (choice) 67%; Second Wind 64%; Shockwave 47%; Fearless (choice) 35%; Fervor of Battle 30%; Fierce Followthrough (choice) 28%; Bloodborne 24%; Collateral Damage 19%; Rumbling Earth 16%; Just Warming Up (choice) 12%; Berserker Shout (choice) 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 89 of 1000 run it exactly.

### Mythic+

646 rankings over 8 dungeons, logged 2026-09-23 to 2026-10-18, keys 22 to 24 (median 22). 78 distinct builds. Hero tree: Slayer 100%. 154 left out: their log has no talents.

**Typical** (Slayer, agreement 68% on 3 contested talents, 108 run it exactly):

`CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphZGzMbmZmZGmxMDAAAAgxyMDMhxy2ALgBMDTgZwGYmhhBzyMbDwMDAmhBA`

**Most common other builds**, each against the typical:

- 83 (12.8%): +Wrecking Throw; -Fast Footwork
  `CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphZGmZbZmZmZYGzMAAAAAGLzMwEGLbDsAGwMMBmBbgZGGGMLzsNAzMAYGGA`
- 46 (7.1%): +Rumbling Earth; -Second Wind
  `CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphxYmZzMzMzYmxMDAAAAgxyMDMhxy2ALgBMDTgZwGYmhhBzyMbDwMDAmhBA`
- 42 (6.5%): +Intervene; -Fast Footwork
  `CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphZGmZzMzMzwMmZAAAAAMWmZgJMW2GYBMgZYCMD2AzMWGGMLzsNAzMAYGGA`
- 38 (5.9%): +Rumbling Earth; -Fast Footwork
  `CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphZGmZzMzMzYmxMDAAAAgxyMDMhxy2ALgBMDTgZwGYmhhBzyMbDwMDAmhBA`

**Split talents:** Fearless (choice) 85%; Second Wind 70%; Fast Footwork 49%; Wrecking Throw (choice) 39%; Rumbling Earth 32%; Intervene (choice) 19%; Berserker Shout (choice) 12%

**Ours, against the whole sample:**

- `Dungeon`: 83 of 646 run it exactly. Typical has +Fast Footwork; lacks Wrecking Throw.

## Fury Warrior

### Raid

627 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 222 distinct builds. Hero tree: Slayer 93%, Mountain Thane 7%.

**Typical** (Slayer, agreement 71% on 8 contested talents, 20 run it exactly):

`CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDzMmZ2MzMzMDjZmZmZGzsMjxMjZzMzMAAQMW2GYBMgZYCMDbAzMM2AAgZGGzywYwYA`

**Most common other builds**, each against the typical:

- 41 (6.5%): +Interpose; -Second Wind
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDjxMzmZmZmZYMzMzMzYmlZMmZMbmZmBAAixy2ALgBMDTgZYDYmZzYDAAmZYMLDjBjB`
- 41 (6.5%): +Cold Steel, Hot Blood, +Enraged Regeneration, +Massacre; -Improved Whirlwind, -Meat Cleaver, -Rampaging Ruin
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDzMmZ2MzMzMDjZmZGzMzsMzMmZmZzYmBAAixy2ALgBMDTgZYDYmhxGAAMzwYMMGMG`
- 18 (2.9%): +Wrecking Throw; -Piercing Howl
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDzMmZ2WmZmZmhxMzMzMjZWmxYmxsZmZGAAIGLbDsAGwMMBmhNgZGGAAgZGGzywYwYA`
- 17 (2.7%): +Enraged Regeneration, +Rumbling Earth, +Shockwave, +Spite 1/2; -Piercing Howl, -Second Wind, -Spite 2/2
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDjxMzmZmZmZmZMzMzMzMzDsMjxMjZzMzMAAQMW2GYBMgZYCMDbAzMMAAAzMMmlhxgxA`

**Split talents:** Field Dressing 90%; Improved Whirlwind 85%; Storm Bolt 82%; Fearless (choice) 79%; Rampaging Ruin 75%; Second Wind 60%; Piercing Howl (choice) 53%; Wrecking Throw (choice) 49%; Shockwave 44%; Meat Cleaver (choice) 42%; Enraged Regeneration 40%; Cold Steel, Hot Blood 35%; Massacre 34%; Interpose (choice) 17%; Rumbling Earth 15%

**Ours, against the whole sample:**

- `Raid`: 11 of 627 run it exactly. Typical has +Meat Cleaver, +Piercing Howl; lacks Massacre, Wrecking Throw.

### Mythic+

675 rankings over 8 dungeons, logged 2026-08-28 to 2026-10-18, keys 19 to 22 (median 19). 151 distinct builds. Hero tree: Slayer 58%, Mountain Thane 42%. 125 left out: their log has no talents.

**Typical** (Slayer, agreement 62% on 29 contested talents, 28 run it exactly):

`CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDjhZ2WmZmZmZmxMzMzMzMPwyMGzMmNzMzAAAxYZbgFwAmhJwMsBMzwAAAMzwYWGGDGD`

**Most common other builds**, each against the typical:

- 151 (22.4%): +Fast Footwork; -Wrecking Throw
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDjxMzmZmZmZmZMzMzMzMzDsMjxMjZzMzMAAQMW2GYBMgZYCMDbAzMMAAAzMMmlhxgxA`
- 103 (15.3%): +Avatar, +Avatar of the Storm, +Burst of Power, +Capacitance, +Cold Steel, Hot Blood, +Conductivity, +Crackling Thunder, +Crashing Thunder, +Crushing Force, +Deft Experience 2/2, +Flashing Skies, +Ground Current, +Javelineer, +Keep Your Feet on the Ground, +Mountain Thane, +Scent of Blood, +Spite 2/2, +Storm Bolts, +Storm Surge, +Strength of the Mountain, +Thorim's Might, +Thunder Blast, +Thunder Clap, +Vicious Contempt; -Bladestorm, -Critical Thinking 2/2, -Culling Cyclone, -Deadly Focus, -Death Drive, -Deep Wounds, -Executioner's Wrath, -Field Dressing, -Imminent Demise, -Odyn's Fury, -Opportunist, -Overwhelming Blades, -Reap the Storm, -Relentless Pursuit, -Resonant Voice, -Rumbling Earth, -Show No Mercy, -Slayer, -Slayer's Malice, -Spite 1/2, -Stance Mastery, -Surge of Adrenaline, -Unhinged, -Unrelenting Onslaught, -Violent Euphoria
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDjZMz2yMzMzMmxMzMzMzMzyMzYmxsMmZGAAIMwGssY0YGAzCmxCgZwAAmZAMYxMAjB`
- 30 (4.4%): +Fast Footwork, +Second Wind; -Rumbling Earth, -Wrecking Throw
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDzMmZ2MzMzMjZMzMzMzMzDsMjxMjZzMzMAAQMW2GYBMgZYCMDbAzMMAAAzMMmlhxgxA`
- 24 (3.6%): +Avatar, +Avatar of the Storm, +Burst of Power, +Capacitance, +Cold Steel, Hot Blood, +Conductivity, +Crackling Thunder, +Crashing Thunder, +Crushing Force, +Deft Experience 2/2, +Flashing Skies, +Ground Current, +Javelineer, +Keep Your Feet on the Ground, +Mountain Thane, +Scent of Blood, +Spite 2/2, +Storm Bolts, +Storm Surge, +Strength of the Mountain, +Thorim's Might, +Thunder Blast, +Thunder Clap, +Vicious Contempt; -Bladestorm, -Critical Thinking 2/2, -Culling Cyclone, -Deadly Focus, -Death Drive, -Deep Wounds, -Executioner's Wrath, -Field Dressing, -Imminent Demise, -Leeching Strikes, -Odyn's Fury, -Opportunist, -Overwhelming Blades, -Reap the Storm, -Relentless Pursuit, -Resonant Voice, -Show No Mercy, -Slayer, -Slayer's Malice, -Spite 1/2, -Stance Mastery, -Surge of Adrenaline, -Unhinged, -Unrelenting Onslaught, -Violent Euphoria
  `CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgGDjZMz2yMzMjZmxMzMzMzMzyMzYmxsMmZGAAIMwGssY0YGAzCmxCgZwAAmZAMYxMAjB`

**Split talents:** Leeching Strikes 89%; Storm Bolt 89%; Enraged Regeneration 87%; Odyn's Fury 68%; Resonant Voice 62%; Field Dressing 62%; Surge of Adrenaline 62%; Critical Thinking 62%; Rumbling Earth 59%; Executioner's Wrath 59%; Violent Euphoria 58%; Unrelenting Onslaught 58%; Unhinged 58%; Slayer's Malice 58%; Show No Mercy 58%; Reap the Storm 58%; Overwhelming Blades 58%; Imminent Demise 58%; Deep Wounds 58%; Death Drive 58%; Deadly Focus 58%; Bladestorm (choice) 58%; Stance Mastery 58%; Culling Cyclone (choice) 58%; Opportunist (choice) 57%; Wrecking Throw (choice) 57%; Relentless Pursuit (choice) 56%; Fast Footwork 47%; Crushing Force 43%; Thunder Clap 42%; Thunder Blast 42%; Strength of the Mountain 42%; Storm Surge 42%; Scent of Blood 42%; Ground Current 42%; Flashing Skies (choice) 42%; Crashing Thunder 42%; Conductivity 42%; Capacitance 42%; Burst of Power 42%; Avatar of the Storm 42%; Avatar (choice) 42%; Crackling Thunder 41%; Storm Bolts (choice) 41%; Cold Steel, Hot Blood 41%; Thorim's Might (choice) 40%; Deft Experience 38%; Vicious Contempt 38%; Javelineer 38%; Keep Your Feet on the Ground (choice) 37%; Second Wind 17%

**Ours, against the whole sample:**

- `Dungeon`: 151 of 675 run it exactly. Typical has +Wrecking Throw; lacks Fast Footwork.

## Protection Warrior

### Raid

704 rankings over 10 bosses, logged 2026-10-14 to 2026-10-18. 436 distinct builds. Hero tree: Mountain Thane 78%, Colossus 22%.

**Typical** (Mountain Thane, agreement 72% on 27 contested talents, 1 run it exactly):

`CkEAAAAAAAAAAAAAAAAAAAAAA0yAAAzMzYmZmZGzmxsMMGjGmZYZmZmZwYmBAAAALjBYGDwAbwyiRjZAMbYmNYGzMY2AgZGAAmBGD`

**Most common other builds**, each against the typical:

- 12 (1.7%): +Tough as Nails; -Armor Specialization
  `CkEAAAAAAAAAAAAAAAAAAAAAA0yAAAzMzYmZGzY2MmlZMGjGmZYZmZmZwYmBAAAALjBYGDwAbwyiRjZAMbYmNYGzMY2AgZGAAmBGD`
- 11 (1.6%): +Barbaric Training, +Bloodsurge, +Intervene, +Resonant Voice, +Storm Bolts, +Tough as Nails; -Battle-Scarred Veteran, -Field Dressing, -Fight Through the Flames, -Javelineer, -Stance Mastery, -Storm Shield
  `CkEAAAAAAAAAAAAAAAAAAAAAA0yAAAzMjZmZmZGzmxsMjxYmGmZGLzMzMDGzMAAAAYZAYGDwAbwyiRjZAMLYmNYGmhZ2AgZGAAAGD`
- 8 (1.1%): +Shield Specialization; -Armor Specialization
  `CkEAAAAAAAAAAAAAAAAAAAAAA0yAAAzMzYmZGzY2MzsMMGjGmZYZmZmZwYmBAAAALjBYGDwAbwyiRjZAMbYmNYGzMY2AgZGAAmBGD`
- 7 (1.0%): +Intervene, +Ravager, +Shield Specialization, +Shockwave, +Snap Induction, +Tough as Nails; -Armor Specialization, -Battle-Scarred Veteran, -Field Dressing, -Flashing Skies, -Pain and Gain, -Whirling Blade
  `CkEAAAAAAAAAAAAAAAAAAAAAA0yAAAzMzYmZGzY2MzsMjxYmGmZYZMzMDzYmBAAAAbDAzYAGYD2WMaMDgZDzsBzYmBzGAMzAAwAGD`

**Split talents:** Devastating Focus 89%; Thunderlord 88%; Wrecking Throw (choice) 86%; Thunder Blast 78%; Strength of the Mountain 78%; Storm Surge 78%; Ground Current 78%; Crashing Thunder 78%; Conductivity 78%; Capacitance 78%; Burst of Power 78%; Avatar of the Storm 78%; Keep Your Feet on the Ground (choice) 78%; Thorim's Might (choice) 77%; Overwhelming Rage 75%; Javelineer 74%; Fast Footwork 74%; Field Dressing 72%; Flashing Skies (choice) 66%; Fight Through the Flames 66%; Stance Mastery 59%; Piercing Howl (choice) 59%; Bloodborne (choice) 55%; Battle-Scarred Veteran 52%; Shockwave 46%; Storm Shield (choice) 44%; Armor Specialization 44%; Barbaric Training 43%; Fearless (choice) 40%; Tough as Nails 38%; Deep Wounds 35%; Storm Bolts (choice) 34%; Sudden Death (choice) 33%; Intervene 33%; Massacre 30%; Resonant Voice 28%; Shield Specialization 24%; Tide of Battle 22%; Precise Might 22%; Practiced Strikes 22%; No Stranger to Pain (choice) 22%; Mountain of Muscle and Scars 22%; Martial Expert 22%; Dominance of the Colossus 22%; Decimator 22%; Cut to the Bone 22%; Colossal Might 22%; Celeritous Conclusion 22%; Arterial Bleed (choice) 21%; Bloodsurge 20%; Heavy Handed 18%; Storm Bolt 14%; Snap Induction (choice) 12%; Second Wind 12%; Boneshaker (choice) 11%; Disrupting Shout 11%; Earthquaker (choice) 11%

**Ours, against the whole sample:**

- `Raid`: the typical build. 1 of 704 run it exactly.

### Mythic+

694 rankings over 8 dungeons, logged 2026-09-08 to 2026-10-18, keys 19 to 23 (median 20). 349 distinct builds. Hero tree: Mountain Thane 97%, Colossus 3%. 106 left out: their log has no talents.

**Typical** (Mountain Thane, agreement 80% on 18 contested talents, 4 run it exactly):

`CkEAAAAAAAAAAAAAAAAAAAAAAkBAAGzwMzMzMmNzMLzYMGNmxwiZmZGzwMDAAAAWmZAmxAMwGssY0YGAzCmZDGzMDjNAYmBAgZgxA`

**Most common other builds**, each against the typical:

- 12 (1.7%): +Bloodborne, +Bloodsurge, +Fight Through the Flames, +Focused Vigor, +Frothing Berserker, +Gathering Clouds, +Intimidating Shout, +Overwhelming Rage, +Snap Induction; -Battle-Scarred Veteran, -Best Served Cold, -Disrupting Shout, -Flashing Skies, -Piercing Howl, -Punish, -Rumbling Earth, -Storm Bolt, -Thorim's Might
  `CkEAAAAAAAAAAAAAAAAAAAAAA0yAAAjZmZmZmZY2MzsMjxY0wYYZmZmZYGzMAAAAYZGAGDwALw2iRjZAMLYmNYGzMMWAgZGAAmBGD`
- 11 (1.6%): +Bloodsurge, +Crushing Force; -Enduring Alacrity, -Resonant Voice
  `CkEAAAAAAAAAAAAAAAAAAAAAAkBAAGzYmZmZmxsZmZZGjxoxMGWMzMzYGmZAAAAwyMDwMGgB2glFjGzAYWwMbAzMDmNAYmBAgZgxA`
- 9 (1.3%): +Barbaric Training, +Fight Through the Flames, +Focused Vigor, +Frothing Berserker; -Bounding Stride, -Disrupting Shout, -Indomitable, -Javelineer
  `CkEAAAAAAAAAAAAAAAAAAAAAAkBAAGzMmZmZmxsZmZZGjxoxMmxyMmZGzwMDAAAAWGDwMGgB2glFjGzAYWwMbwMmZYsBAzMAAYgxA`
- 9 (1.3%): +Frothing Berserker; -Bounding Stride
  `CkEAAAAAAAAAAAAAAAAAAAAAAkBAAGzwMzMzMmNzMLzYMGNmxwyMmZGzwMDAAAAWmZAmxAMwGssY0YGAzCmZDGzMDjNAYmBAgZgxA`

**Split talents:** Into the Fray (choice) 89%; Thorim's Might (choice) 87%; Best Served Cold 87%; Rumbling Earth 87%; Punish 86%; Indomitable 85%; Instigate 84%; Storm Bolts (choice) 82%; Storm Bolt 82%; Flashing Skies (choice) 82%; Disrupting Shout 82%; Bounding Stride 81%; Armor Specialization 78%; Javelineer 77%; Enduring Alacrity 72%; Tough as Nails 72%; Resonant Voice 63%; Piercing Howl (choice) 57%; Fight Through the Flames 54%; Frothing Berserker 38%; Crushing Force 38%; Bloodborne (choice) 37%; Bloodsurge 35%; Barbaric Training 24%; Intimidating Shout (choice) 24%; Fearless (choice) 21%; Focused Vigor 20%; Storm Shield (choice) 15%; Snap Induction (choice) 15%; Last Stand 14%; Heavy Repercussions (choice) 11%

**Ours, against the whole sample:**

- `Dungeon`: 9 of 694 run it exactly. Typical has +Resonant Voice; lacks Crushing Force.

