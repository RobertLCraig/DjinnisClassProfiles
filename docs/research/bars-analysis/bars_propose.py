"""Feral (Dungeon) as the model: each job's key there, and for each other spec,
where that job's ability sits now and where it would move. Prints markdown."""
import json, os

TEMP = os.environ["TEMP"]
A = json.load(open(os.path.join(TEMP, "bars-analysis.json"), encoding="utf-8"))
FIGHT = {"Feral": 7, "Guardian": 9, "Balance": 10, "Resto": 1}
OTHERS = ["Guardian", "Balance", "Resto"]
ACTIVE = ("MULTIACTIONBAR3BUTTON", "MULTIACTIONBAR6BUTTON")


def active(lname):
    L = A["layouts"][lname]
    out = {}
    for r in L["rows"]:
        b = r["button"] or ""
        if (b.startswith("ACTIONBUTTON") and r["page"] == FIGHT[L["spec"]]) or b.startswith(ACTIVE):
            out[b] = r
    return out


keys = {}
for l in A["layouts"]:
    for r in A["layouts"][l]["rows"]:
        if r["button"] and r["keys"]:
            keys.setdefault(r["button"], ", ".join(r["keys"]))

feral = active("Feral / Dungeon")
model = {}  # job -> button, from Feral
for b, r in feral.items():
    for c in r["cats"]:
        model.setdefault(c, b)

print("## Your key for each job, read off your Feral bars\n")
print("| Job | Bellular's key | Your key (Feral) | Feral ability |")
print("|---|---|---|---|")
for c in A["cats"]:
    if c in model:
        print("| %s | %s | **%s** | %s |" % (c, A["bell_key"][c], keys.get(model[c], "-"), feral[model[c]]["what"]))

for spec in OTHERS:
    grid = active(spec)
    rows = A["layouts"][spec]["rows"]
    print("\n## %s: what would move to match Feral\n" % spec)
    print("| Job | %s ability (Bellular) | Now on | Would go to |" % spec)
    print("|---|---|---|---|")
    for c in A["cats"]:
        if c not in model:
            continue
        ability = A["druid"][c][spec]
        now = [b for b, r in grid.items() if c in r["cats"]]
        elsewhere = [r["bar"] for r in rows if c in r["cats"] and r["button"] not in grid]
        target = model[c]
        if now == [target]:
            state = "same key already"
            print("| %s | %s | %s | ✓ same |" % (c, ability or "-", keys.get(target, "-")))
            continue
        where = ", ".join(keys.get(b, b) for b in now) or (("not on bars 1/4/7 (" + elsewhere[0] + ")") if elsewhere else "not on the bars")
        taken = grid.get(target)
        clash = (" - now holds " + taken["what"]) if taken and c not in taken["cats"] else ""
        if not ability:
            print("| %s | - (no %s ability) | %s | leave %s free%s |" % (c, spec, where, keys.get(target, "-"), clash))
        else:
            print("| %s | %s | %s | **%s**%s |" % (c, ability, where, keys.get(target, "-"), clash))
