"""Grid of Rob's ability buttons (bars 1, 4, 7) across the four druid specs, and
Bellular's category of each. Prints markdown."""
import json, os, collections

TEMP = os.environ["TEMP"]
A = json.load(open(os.path.join(TEMP, "bars-analysis.json"), encoding="utf-8"))
MAIN = ["Feral / Dungeon", "Guardian", "Balance", "Resto"]
FIGHT = {"Feral": 7, "Guardian": 9, "Balance": 10, "Resto": 1}


def ability_rows(lname):
    L = A["layouts"][lname]
    spec = L["spec"]
    out = {}
    for r in L["rows"]:
        b = r["button"] or ""
        on_bar1 = b.startswith("ACTIONBUTTON") and r["page"] == FIGHT[spec]
        if on_bar1 or b.startswith("MULTIACTIONBAR3BUTTON") or b.startswith("MULTIACTIONBAR6BUTTON"):
            out[b] = r
    return out


grid = {l: ability_rows(l) for l in MAIN}
keys = {}
for l in MAIN:
    for b, r in grid[l].items():
        if r["keys"]:
            keys[b] = r["keys"]
# every button's key, from any layout (keys are the same in all four)
for l in MAIN:
    for r in A["layouts"][l]["rows"]:
        if r["button"] and r["keys"]:
            keys.setdefault(r["button"], r["keys"])


def order(b):
    for i, p in enumerate(["ACTIONBUTTON", "MULTIACTIONBAR3BUTTON", "MULTIACTIONBAR6BUTTON"]):
        if b.startswith(p) and b[len(p):].isdigit():
            return (i, int(b[len(p):]))
    return (9, 0)


BARNAME = {"ACTIONBUTTON": "Bar 1", "MULTIACTIONBAR3BUTTON": "Bar 4", "MULTIACTIONBAR6BUTTON": "Bar 7"}


def bname(b):
    for p, n in BARNAME.items():
        if b.startswith(p) and b[len(p):].isdigit():
            return "%s #%s" % (n, b[len(p):])
    return b


def cell(r):
    if not r:
        return "·"
    c = "/".join(r["cats"])
    return r["what"] + (" *(" + c + ")*" if c else "")


buttons = sorted({b for l in MAIN for b in grid[l]} | {b for b in keys if order(b)[0] < 9}, key=order)
print("## Ability buttons, by spec\n")
print("| Button | Key | Feral (Dungeon) | Guardian | Balance | Resto |")
print("|---|---|---|---|---|---|")
for b in buttons:
    print("| %s | %s | %s |" % (bname(b), ", ".join(keys.get(b, [])) or "-", " | ".join(cell(grid[l].get(b)) for l in MAIN)))

# category -> button per spec
print("\n## Each Bellular job: where it sits in each spec\n")
print("| Job | Bellular key | Feral | Guardian | Balance | Resto | Same button? |")
print("|---|---|---|---|---|---|---|")
for c in A["cats"]:
    where, any_ = [], False
    for l in MAIN:
        spec = A["layouts"][l]["spec"]
        hits = [b for b, r in grid[l].items() if c in r["cats"]]
        # also anywhere else on the layout (utility bars, other forms)
        if not hits:
            hits = ["(%s)" % r["bar"] for r in A["layouts"][l]["rows"] if c in r["cats"]][:1]
        where.append(hits)
        any_ = any_ or bool(hits)
    if not any_:
        continue
    cells = []
    for h in where:
        cells.append(", ".join("%s [%s]" % (bname(x), ", ".join(keys.get(x, [])) or "-") if not x.startswith("(") else x for x in h) or "—")
    main = [tuple(h) for h in where if h and not h[0].startswith("(")]
    same = "yes" if len(set(main)) == 1 and len(main) == sum(1 for l in MAIN if A["druid"][c][A["layouts"][l]["spec"]]) else "no"
    print("| %s | %s | %s | %s |" % (c, A["bell_key"].get(c, ""), " | ".join(cells), same))
