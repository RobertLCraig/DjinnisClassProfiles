"""Card 0082. Writes choice_nodes.json: every Retail class-tree talent choice
node (TraitNode.Type 2, Enum.TraitNodeType.Selection; 3 is the hero-tree
pick and is left out) with the spell each option grants, so the keybinding
planner can put the alternatives on one key.

Reads the wago.tools DB2 CSVs for the live "wow" build. A tree is a class
tree when SkillLineXTraitTree ties it to a SkillLine of category 7 (class).
Options whose TraitDefinition grants no spell are dropped, and so is a node
left with fewer than two options.

    python docs/research/bars-analysis/choice_nodes.py
"""
import csv, datetime, io, json, os, urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "choice_nodes.json")
UA = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36"}
SELECTION, CLASS_CATEGORY = "2", "7"


def get(url):
    with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=120) as r:
        return r.read().decode("utf-8")


BUILD = json.loads(get("https://wago.tools/api/builds/latest"))["wow"]["version"]


def table(name):
    return list(csv.DictReader(io.StringIO(get("https://wago.tools/db2/%s/csv?build=%s" % (name, BUILD)))))


skill = {r["ID"]: r for r in table("SkillLine")}
tree_class = {r["TraitTreeID"]: skill[r["SkillLineID"]]["DisplayName_lang"]
              for r in table("SkillLineXTraitTree")
              if skill.get(r["SkillLineID"], {}).get("CategoryID") == CLASS_CATEGORY}
subtree = {r["ID"]: r["Name_lang"] for r in table("TraitSubTree")}
definition = {r["ID"]: r for r in table("TraitDefinition")}
entry = {r["ID"]: r for r in table("TraitNodeEntry")}
entries_of = {}
for r in table("TraitNodeXTraitNodeEntry"):
    entries_of.setdefault(r["TraitNodeID"], []).append((int(r["_Index"]), r["TraitNodeEntryID"]))

picked = []
for n in table("TraitNode"):
    if n["Type"] != SELECTION or n["TraitTreeID"] not in tree_class:
        continue
    spells = []
    for _, eid in sorted(entries_of.get(n["ID"], [])):
        d = definition.get(entry.get(eid, {}).get("TraitDefinitionID"))
        if d and d["SpellID"] != "0" and int(d["SpellID"]) not in spells:
            spells.append(int(d["SpellID"]))
    if len(spells) >= 2:
        picked.append((n, spells))

wanted = {s for _, spells in picked for s in spells}
names = {int(r["ID"]): r["Name_lang"] for r in table("SpellName") if int(r["ID"]) in wanted}

nodes, by_name = [], {}
for n, spells in picked:
    options = [{"spell": s, "name": names.get(s, "")} for s in spells]
    node = {"node": int(n["ID"]), "tree": int(n["TraitTreeID"]), "class": tree_class[n["TraitTreeID"]]}
    if n["TraitSubTreeID"] != "0":
        node["heroTree"] = subtree.get(n["TraitSubTreeID"], int(n["TraitSubTreeID"]))
    node["options"] = options
    nodes.append(node)
    for o in options:
        others = by_name.setdefault(o["name"], [])
        others += [p["name"] for p in options if p["name"] != o["name"] and p["name"] not in others]
nodes.sort(key=lambda x: (x["class"], x.get("heroTree", ""), x["node"]))

json.dump({"built": datetime.date.today().isoformat(), "source": "wago.tools build " + BUILD,
           "nodes": nodes, "byName": dict(sorted(by_name.items()))},
          open(OUT, "w", encoding="utf-8"), indent=1, ensure_ascii=False)
print("%d choice nodes, build %s -> %s" % (len(nodes), BUILD, OUT))
