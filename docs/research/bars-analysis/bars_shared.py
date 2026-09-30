"""Spells (and items, macros) on the bars of two or more druid specs: the key
each has in each spec. Prints markdown."""
import json, os, collections

TEMP = os.environ["TEMP"]
A = json.load(open(os.path.join(TEMP, "bars-analysis.json"), encoding="utf-8"))
MAIN = [("Feral", "Feral / Dungeon"), ("Guardian", "Guardian"), ("Balance", "Balance"), ("Resto", "Resto")]
FIGHT = {"Feral": 7, "Guardian": 9, "Balance": 10, "Resto": 1}
ITEMS = {"245898": "Fleeting Light's Potential (damage potion)", "258138": "Potent Healing Potion", "5512": "Healthstone"}


def where(r, spec):
    b = r["button"] or ""
    k = ", ".join(r["keys"]) or "no key"
    if b.startswith("ACTIONBUTTON"):
        if r["page"] == FIGHT[spec]:
            return k
        return "%s bar (%s)" % (r["bar"].split("(")[-1].rstrip(")"), k)
    if b.startswith(("MULTIACTIONBAR3BUTTON", "MULTIACTIONBAR6BUTTON")):
        return k
    return "%s (%s)" % (r["bar"], k)


table = collections.defaultdict(dict)
for spec, lname in MAIN:
    for r in A["layouts"][lname]["rows"]:
        name = r["what"]
        if r["type"] == "item":
            name = ITEMS.get(r["id"], name)
        table[name].setdefault(spec, []).append(where(r, spec))

print("| Spell or item | Feral | Guardian | Balance | Resto | Same key? |")
print("|---|---|---|---|---|---|")
rows = []
for name, per in table.items():
    if len(per) < 2:
        continue
    cells = [", ".join(per.get(s, [])) or "—" for s, _ in MAIN]
    present = [tuple(sorted(per[s])) for s, _ in MAIN if s in per]
    same = "yes" if len(set(present)) == 1 else "**no**"
    rows.append((same != "yes", name, cells, same))
for _, name, cells, same in sorted(rows, key=lambda x: (not x[0], x[1])):
    print("| %s | %s | %s |" % (name, " | ".join(cells), same))
