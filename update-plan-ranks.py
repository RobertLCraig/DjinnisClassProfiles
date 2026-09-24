"""Author tooling, never shipped (pkgmeta.yaml ignores it).

Rewrites the GENERATED PLAN RANKS block in DjinnisClassProfiles.lua: for every enchant
and gem the gear plan asks for, every id in that enchant's or gem's family,
with its rank. The game has no call from an enchant id to a name, and two gem
ids can share a name ("Flawless Masterful Garnet" is 240907 and 240908), so
the addon cannot tell "lower rank of the same thing" from "wrong thing" without
this table. It fetches Raidbots' public data files.

    python update-plan-ranks.py            # rewrite
    python update-plan-ranks.py --check    # exit 1 if the block would change

An enchant family is the scroll's item name and its rank is craftingQuality.
A gem family is the name without its quality prefix ("Flawless ", "Perfect ")
and its rank is its place in the family ordered by quality, then item level.
Quality is the major key because the stats say so (Wowhead tooltips,
2026-09-22): Flawless Masterful Garnet 278 gives 14 crit / 6 mastery and plain
Masterful Garnet 295 gives 12 / 5, so the rare at the lower item level is the
better gem. Blizzard's own enchant ids run the same way (8150 to 8153).
"""
import json
import re
import sys
import urllib.request
from datetime import date

LUA = "DjinnisClassProfiles.lua"
BEGIN, END = "-- BEGIN GENERATED PLAN RANKS", "-- END GENERATED PLAN RANKS"
ENCHANTS = "https://www.raidbots.com/static/data/live/enchantments.json"
GEMS = "https://www.raidbots.com/static/data/live/gems.json"
GEM_PREFIX = re.compile(r"^(Flawless|Perfect) ")


def fetch(url):
    # Raidbots answers Python's default user agent with 403 and curl's with 200.
    req = urllib.request.Request(url, headers={"User-Agent": "curl/8.0 DjinnisClassProfiles update-plan-ranks"})
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.load(r)


def planned(lua):
    block = re.search(r"-- BEGIN GENERATED GEAR PLAN.*?-- END GENERATED GEAR PLAN", lua, re.S).group(0)
    enchants = {int(x) for x in re.findall(r"enchant_id=(\d+)", block)}
    gems = {int(x) for m in re.findall(r"gem_id=([\d/]+)", block) for x in m.split("/")}
    return enchants, gems


def enchant_rows(data, wanted):
    by_id = {e["id"]: e for e in data}
    families = {by_id[i]["itemName"] for i in wanted if i in by_id}
    missing = [i for i in wanted if i not in by_id]
    if missing:
        sys.exit(f"enchant ids not on Raidbots' list: {missing}. Nothing written.")
    rows = []
    for fam in sorted(families):
        members = sorted((e for e in data if e.get("itemName") == fam), key=lambda e: e.get("craftingQuality") or 0)
        for rank, e in enumerate(members, 1):
            rows.append((e["id"], fam, rank, len(members)))
    return rows


def gem_rows(data, wanted):
    by_id = {g["id"]: g for g in data}
    missing = [i for i in wanted if i not in by_id]
    if missing:
        sys.exit(f"gem ids not on Raidbots' list: {missing}. Nothing written.")
    families = {GEM_PREFIX.sub("", by_id[i]["name"]) for i in wanted}
    rows = []
    for fam in sorted(families):
        members = sorted((g for g in data if GEM_PREFIX.sub("", g["name"]) == fam),
                         key=lambda g: (g.get("quality") or 0, g.get("itemLevel") or 0))
        for rank, g in enumerate(members, 1):
            rows.append((g["id"], fam, rank, len(members)))
    return rows


def block(enchants, gems):
    q = lambda s: s.replace("\\", "\\\\").replace('"', '\\"')
    out = [BEGIN, f'PlanTab.RANK_SOURCE = "Raidbots enchantments.json and gems.json, read {date.today()}"',
           "PlanTab.RANK = {", "\tenchant = {"]
    out += [f'\t\t[{i}] = {{ "{q(f)}", {r}, {n} }},' for i, f, r, n in enchants]
    out += ["\t},", "\tgem = {"]
    out += [f'\t\t[{i}] = {{ "{q(f)}", {r}, {n} }},' for i, f, r, n in gems]
    out += ["\t},", "}", END]
    return "\n".join(out)


def main():
    lua = open(LUA, encoding="utf-8", newline="").read()
    nl = "\r\n" if "\r\n" in lua else "\n"
    if BEGIN not in lua or END not in lua:
        sys.exit(f"{LUA} has no {BEGIN} / {END} markers. Put them back rather than guessing where the table goes.")
    want_e, want_g = planned(lua)
    new = block(enchant_rows(fetch(ENCHANTS), want_e), gem_rows(fetch(GEMS), want_g)).replace("\n", nl)
    pattern = re.compile(re.escape(BEGIN) + ".*?" + re.escape(END), re.S)
    old = pattern.search(lua).group(0)
    strip = lambda s: re.sub(r"read \d{4}-\d{2}-\d{2}", "", s)
    if strip(old) == strip(new):
        print("Already current")
        return
    if "--check" in sys.argv:
        sys.exit("The PLAN RANKS block is out of date. Run without --check.")
    open(LUA, "w", encoding="utf-8", newline="").write(pattern.sub(lambda _: new, lua))
    print(f"Wrote {new.count(nl) + 1} lines to {LUA}")


if __name__ == "__main__":
    main()
