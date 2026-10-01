"""Card 0082. Builds docs/research/2026-10-01-keybind-layout.html: Rob's bars
laid out as on his screen, for every class and spec, with icons and Wowhead
tooltips, drag to move, and a Clique panel.

Reads keys_data.json (from keys_page.lua) and bellular_spells.json (from
bellular_spells.py). Item icons come from Wowhead's tooltip API and are
cached in item_icons.json.

    lua docs/research/bars-analysis/keys_page.lua
    python docs/research/bars-analysis/build_keys_page.py
"""
import json, os, urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "2026-10-01-keybind-layout.html")
ITEMS = {"Healthstone": 5512, "Damage Potion": 245898, "Healing Potion": 258138}  # Potent Healing Potion, on Rob's Feral Shift+2

data = json.load(open(os.path.join(HERE, "keys_data.json"), encoding="utf-8"))
bell = json.load(open(os.path.join(HERE, "bellular_spells.json"), encoding="utf-8"))["spells"]
by_name = {}
for e in bell:
    by_name.setdefault(e["name"].lower(), []).append(e)

cache_path = os.path.join(HERE, "item_icons.json")
item_icons = json.load(open(cache_path, encoding="utf-8")) if os.path.exists(cache_path) else {}
for name, iid in ITEMS.items():
    if name not in item_icons:
        req = urllib.request.Request("https://nether.wowhead.com/tooltip/item/%d" % iid, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=30) as r:
            item_icons[name] = json.loads(r.read().decode("utf-8"))["icon"]
json.dump(item_icons, open(cache_path, "w", encoding="utf-8"), indent=1)

# Names Bellular's tool does not carry: the player spell of that name from
# wago.tools (SpellName, kept to spells in SkillLineAbility, so not an NPC's),
# its icon from Wowhead. Cached in name_icons.json.
names_path = os.path.join(HERE, "name_icons.json")
name_icons = json.load(open(names_path, encoding="utf-8")) if os.path.exists(names_path) else {}


def fetch(url):
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (DjinnisClassProfiles keybind page)"})
    with urllib.request.urlopen(req, timeout=120) as r:
        return r.read().decode("utf-8", "replace")


def wago_lookup(wanted):
    import csv, io
    want = {w.lower() for w in wanted if w.lower() not in name_icons}
    if not want:
        return
    names = csv.DictReader(io.StringIO(fetch("https://wago.tools/db2/SpellName/csv")))
    ids = {}
    for row in names:
        n = (row.get("Name_lang") or "").lower()
        if n in want:
            ids.setdefault(n, []).append(int(row["ID"]))
    player = {int(r["Spell"]) for r in csv.DictReader(io.StringIO(fetch("https://wago.tools/db2/SkillLineAbility/csv")))}
    # talents are not in SkillLineAbility (Maul is a talent): add the talent tree's spells
    player |= {int(r["SpellID"]) for r in csv.DictReader(io.StringIO(fetch("https://wago.tools/db2/TraitDefinition/csv"))) if r.get("SpellID", "0").isdigit()}
    for n, cands in ids.items():
        pick = sorted(c for c in cands if c in player) or []
        for sid in pick[:3]:
            try:
                tip = json.loads(fetch("https://nether.wowhead.com/tooltip/spell/%d" % sid))
            except Exception:
                continue
            if tip.get("icon"):
                name_icons[n] = {"id": sid, "icon": tip["icon"]}
                break
    json.dump(name_icons, open(names_path, "w", encoding="utf-8"), indent=1, sort_keys=True)


# spells neither table names as a player's, by id: Lunar Eclipse is the spell on
# Rob's Balance moonkin Shift+Q (1233272); the rest are PvP talents or older ids
BY_ID = {"lunar eclipse": 1233272, "infernal strike": 189110, "heal": 2060, "illidan's grasp": 205630,
         "reverse magic": 205604, "rain from above": 206803, "ancient hysteria": 90355}
for n, sid in BY_ID.items():
    if n not in name_icons:
        try:
            tip = json.loads(fetch("https://nether.wowhead.com/tooltip/spell/%d" % sid))
            if tip.get("icon"):
                name_icons[n] = {"id": sid, "icon": tip["icon"]}
        except Exception:
            pass
json.dump(name_icons, open(names_path, "w", encoding="utf-8"), indent=1, sort_keys=True)

unresolved = set()


def resolve(cell, spec_id):
    """Adds icon and Wowhead id to a cell, by its spell name, preferring the spec's own spell."""
    name = cell["spell"]
    if name in ITEMS:
        cell["icon"], cell["wh"] = item_icons.get(name), "item=%d" % ITEMS[name]
        return True
    for alt in name.split("/"):
        hits = by_name.get(alt.strip().lower(), [])
        hit = next((e for e in hits if spec_id in e["specs"]), hits[0] if hits else None)
        if hit:
            cell["icon"], cell["wh"] = hit["icon"], "spell=%d" % hit["id"]
            return spec_id in hit["specs"] or not hit["specs"]
    for alt in name.split("/"):
        hit = name_icons.get(alt.strip().lower())
        if hit:
            cell["icon"], cell["wh"] = hit["icon"], "spell=%d" % hit["id"]
            return True
    unresolved.add(name)
    return None


def all_names():
    out = set()
    for s in data["specs"]:
        for c in list(s["cells"].values()) + s["nokey"] + (s.get("clique") or []):
            out |= {a.strip() for a in c["spell"].split("/")}
    for p in data["clique"].values():
        out |= {b["spell"] for b in p["binds"] if b.get("spell")}
    return {n for n in out if n.lower() not in by_name and n not in ITEMS}


wago_lookup(all_names())


# Bar 1 per form (Rob, 2026-10-01: "can we make bar 1 change based on stance?
# Like in game?"). The game pages bar 1 for a druid's forms and a rogue's
# stealth; a warrior's stances only page it under a bar addon (Dominos'
# retail bar states give warriors `form`, not `bonusbar`), so not here.
# A saved action is named and iconed by its spell or item id; cached in id_icons.json.
ids_path = os.path.join(HERE, "id_icons.json")
id_icons = json.load(open(ids_path, encoding="utf-8")) if os.path.exists(ids_path) else {}


def by_id(kind, num):
    k = "%s=%d" % (kind, num)
    if k not in id_icons:
        try:
            tip = json.loads(fetch("https://nether.wowhead.com/tooltip/%s/%d" % (kind, num)))
            id_icons[k] = {"name": tip.get("name"), "icon": tip.get("icon")}
        except Exception:
            id_icons[k] = {"name": None, "icon": None}
    return k, id_icons[k]


def saved_cell(v):
    if v["type"] == "macro":
        k, hit = by_id("spell", v["index"]) if v.get("index") else (None, {})
        name = v.get("name") or "macro"
        # Rob's macros are named "Druid - Moonfire": the spell is the part after the dash
        spell = hit.get("name") or name.split(" - ")[-1]
        return {"spell": spell, "icon": hit.get("icon"), "wh": k, "short": "macro", "source": "saved", "macro": name}
    k, hit = by_id(v["type"], v["id"])
    return {"spell": hit.get("name") or "%s %d" % (v["type"], v["id"]), "icon": hit.get("icon"), "wh": k, "source": "saved"}


FORM_NAMES = {"caster": "Caster", "cat": "Cat Form", "prowl": "Prowl", "bear": "Bear Form", "moonkin": "Moonkin Form",
              "normal": "Normal", "stealth": "Stealth"}
for s in data["specs"]:
    f = s.pop("forms", None)
    bar1 = {b: c for b, c in s["cells"].items() if b.startswith("ACTIONBUTTON")}
    if f:
        home = f["home"]
        s["formList"] = [[n, FORM_NAMES[n]] for n in ("caster", "cat", "prowl", "bear", "moonkin")]
        s["formHome"] = home
        s["formNote"] = "Pages other than %s are your saved bars (%s, saved %s), as they are." % (FORM_NAMES[home], f["from"], f["saved"])
        for b, c in bar1.items():
            del s["cells"][b]
            s["cells"][b + "@" + home] = c
        for form, page in f["pages"].items():
            if form == home or not isinstance(page, dict):
                continue
            for b, v in page.items():
                s["cells"][b + "@" + form] = saved_cell(v)
    elif s["className"] == "Rogue":
        # no saved rogue bars: the stealth page starts as a copy of bar 1
        s["formList"] = [["normal", "Normal"], ["stealth", "Stealth"]]
        s["formHome"] = "normal"
        s["formNote"] = "The Stealth page starts as a copy of bar 1. Put your openers on it."
        for b, c in bar1.items():
            del s["cells"][b]
            s["cells"][b + "@normal"] = c
            s["cells"][b + "@stealth"] = dict(c, source="copy")
json.dump(id_icons, open(ids_path, "w", encoding="utf-8"), indent=1, sort_keys=True)

# Either/or talents share a key (Rob, 2026-10-01: "you cannot have mighty bash
# AND incapacitating roar at the same time, so both can be on the same bind").
# choice_nodes.json (from choice_nodes.py) lists every talent choice node. One
# option on a key and the other with none: the other joins that key. Both on
# keys: listed, not merged, since a node can be one spec's only (Bellular keeps
# Arms' Avatar and Bladestorm apart, Fury's together).
choices = json.load(open(os.path.join(HERE, "choice_nodes.json"), encoding="utf-8"))["nodes"]
for s in data["specs"]:
    s["choiceBoth"] = []
    for node in choices:
        names = list(dict.fromkeys(o["name"] for o in node["options"]))
        if len(names) < 2:
            continue
        keyed = [(b, c) for b, c in s["cells"].items() if c.get("source") != "saved" and any(a.strip() in names for a in c["spell"].split("/"))]
        spare = [c for c in s["nokey"] if c["spell"] in names]
        # one spell can be on several pages (a rogue's Stealth copy): count spells, not keys
        if len({c["spell"] for _, c in keyed}) == 1 and spare:
            for b, c in keyed:
                c["spell"] = " / ".join([c["spell"]] + [x["spell"] for x in spare])
                c["choice"] = True
            s["nokey"] = [x for x in s["nokey"] if x not in spare]
        elif len({c["spell"] for _, c in keyed}) > 1:
            s["choiceBoth"].append([[c["spell"], b] for b, c in keyed])

MOUSE_ORDER = ["MOUSEWHEELUP", "MOUSEWHEELDOWN"]
for s in data["specs"]:
    sid = s["id"]
    for c in s["cells"].values():
        if c.get("source") != "saved":  # a saved action is already named by its id
            resolve(c, sid)
        # Bellular's "Taunt/Quick Access": a taunt only for a tank (Prowl, a stealth, elsewhere)
        if c.get("job") == "Taunt/Quick Access" and s["role"] != "TANK":
            c["short"] = "Quick"
    for c in s["nokey"]:
        resolve(c, sid)
    # Clique: the class profile's spells this spec has; the dispel on the wheel where it is missing
    prof = data["clique"].get(s["className"])
    slots, taken = [], set()
    if prof:
        s["cliqueProfile"] = prof["profile"]
        for b in prof["binds"]:
            if b.get("type") != "spell" or b["key"].startswith("CTRL-") or b["key"] in taken:
                continue
            c = {"spell": b["spell"], "key": b["key"], "source": "clique"}
            ok = resolve(c, sid)
            if ok is False:
                continue  # another spec's spell (Remove Corruption on a Resto)
            slots.append(c)
            taken.add(b["key"])
    have = {c["spell"] for c in slots}
    for d in s.get("clique") or []:
        if d["spell"] in have:
            continue
        key = next((k for k in MOUSE_ORDER if k not in taken), None)
        if key:
            c = {"spell": d["spell"], "key": key, "source": "cliqueNew", "job": d["job"], "short": d["short"]}
            resolve(c, sid)
            slots.append(c)
            taken.add(key)
    s["cliqueSlots"] = slots
    # every other spell Bellular's tool gives this spec
    planned = {c["spell"].lower() for c in s["cells"].values()} | {c["spell"].lower() for c in s["nokey"]} | {c["spell"].lower() for c in slots}
    planned |= {alt.strip().lower() for p in list(planned) for alt in p.split("/")}
    s["others"] = [{"spell": e["name"], "icon": e["icon"], "wh": "spell=%d" % e["id"], "source": "spare"}
                   for e in bell if sid in e["specs"] and e["name"].lower() not in planned]
    for k in ("clique", "clash"):
        s.pop(k, None)

# druids first, then the rest by class name
data["specs"].sort(key=lambda s: (s["className"] != "Druid", s["className"], s["spec"]))
data["unresolved"] = sorted(unresolved)
data.pop("clique", None)

html = open(os.path.join(HERE, "keys_page_template.html"), encoding="utf-8").read()
html = html.replace("/*DATA*/", json.dumps(data, ensure_ascii=False)).replace("/*BUILT*/", data["built"]).replace("/*VERSION*/", data["version"])
open(OUT, "w", encoding="utf-8").write(html)
print("wrote", os.path.normpath(OUT), "-", len(data["specs"]), "specs,", len(unresolved), "names without an icon:", ", ".join(sorted(unresolved)))
