"""Author tooling, never shipped (pkgmeta.yaml ignores it). Card 0064.

What the top Warcraft Logs players of each spec run, the way Archon's build
pages show it: the most common build, the alternatives, the talents players
split on, and how the addon's own BUILDS compare. It writes a report for a
person to read; it does not change the addon.

    python wcl-builds.py                 # every spec
    python wcl-builds.py Druid           # one class (Warcraft Logs' name: DeathKnight, DemonHunter, ...)
    python wcl-builds.py --pages 2       # top 200 a boss or dungeon, not 100

Source: the Warcraft Logs v2 API (wcl.py; docs/research/automated-build-sources.md).
characterRankings with includeCombatantInfo gives each ranked player's talents
as (talentID, points). Those are Raidbots talents.json entry ids, so the
export string is rebuilt here the way Blizzard_ClassTalentImportExport.lua
writes one (version 2, spec, a zeroed tree hash, then each node in
fullNodeOrder). On 2026-09-25 three rebuilt Guardian strings were
byte-identical to Warcraft Logs' own ReportFight.talentImportCode.

Raid: every boss of RAID_ZONE on Mythic, ranked by dps (hps for healers).
Mythic+: every dungeon of MPLUS_ZONE, ranked by score. One ranking is one
character's best logged kill or run this season, so a character counts once a
boss. That is not Archon's "top 50% in the last 14 days": the report says what
the sample is.

Answers are cached in .cache/wcl/ (gitignored) for CACHE_HOURS, so a run cut
short by the hourly limit picks up where it stopped.

Writes docs/builds/wcl-report.md and docs/builds/wcl-builds.json.
"""
import collections
import importlib.util
import json
import os
import re
import sys
import time
import urllib.request
from datetime import datetime, timezone

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import wcl  # noqa: E402

_spec = importlib.util.spec_from_file_location("update_builds", os.path.join(HERE, "update-builds.py"))
ub = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(ub)

RAID_ZONE, RAID_DIFFICULTY = 53, 5  # The Venomous Abyss, Mythic (wcl.py probe, 2026-09-25)
MPLUS_ZONE = 55  # Mythic+ Season 2
HEALERS = {("Druid", "Restoration"), ("Shaman", "Restoration"), ("Paladin", "Holy"), ("Priest", "Holy"),
           ("Priest", "Discipline"), ("Monk", "Mistweaver"), ("Evoker", "Preservation")}
CACHE = os.path.join(HERE, ".cache", "wcl")
CACHE_HOURS = 12
MARGIN = 60  # points left unspent in the hour
ALTERNATIVES = 4
SPLIT = (0.10, 0.90)  # a talent picked by more than 10% and fewer than 90% is one players split on
REPORT_DIR = os.path.join(HERE, "docs", "builds")


class Tree:
    """One spec's talents.json tree, and a build as {node id: (rank, choice)}."""

    def __init__(self, t):
        self.t = t
        self.nodes, self.entry = {}, {}
        for part in ("classNodes", "specNodes", "heroNodes", "subTreeNodes"):
            for n in t[part]:
                self.nodes[n["id"]] = n
                for i, e in enumerate(n["entries"]):
                    if "id" in e:  # Raidbots leaves a few entries without one
                        self.entry[e["id"]] = (n["id"], i)

    def is_choice(self, n):
        return n.get("type") in ("choice", "subtree")

    def picks(self, talents):
        """WCL's talent list as {node: (rank, choice)}; None when an id is unknown."""
        out = {}
        for t in talents:
            hit = self.entry.get(t["talentID"])
            if not hit:
                return None
            nid, idx = hit
            rank, _ = out.get(nid, (0, 0))
            # a tiered node (an apex talent) lists each tier as its own entry
            out[nid] = (rank + t["points"], idx if self.is_choice(self.nodes[nid]) else 0)
        return out

    def encode(self, picks):
        bits = []

        def put(v, n):
            bits.extend((v >> i) & 1 for i in range(n))

        put(2, 8), put(self.t["specId"], 16), put(0, 128)
        for nid in self.t["fullNodeOrder"]:
            if nid not in picks:
                put(0, 1)
                continue
            rank, choice = picks[nid]
            n = self.nodes[nid]
            put(1, 1)
            if n.get("freeNode"):
                put(0, 1)  # granted, not purchased: the way the game exports it
                continue
            put(1, 1)
            if rank < n.get("maxRanks", 1):
                put(1, 1), put(rank, 6)
            else:
                put(0, 1)
            if self.is_choice(n):
                put(1, 1), put(choice, 2)
            else:
                put(0, 1)
        return ub.encode(bits)

    def decode(self, code):
        """An export string back to {node: (rank, choice)}, granted nodes left out."""
        s = ub.Bits(code)
        s.take(8), s.take(16), s.take(128)
        out = {}
        for nid in self.t["fullNodeOrder"]:
            if not s.take(1) or not s.take(1):
                continue
            rank = s.take(6) if s.take(1) else self.nodes.get(nid, {}).get("maxRanks", 1)
            choice = s.take(2) if s.take(1) else 0
            out[nid] = (rank, choice)
        return out

    def name(self, nid, choice=0):
        n = self.nodes[nid]
        entries = n["entries"]
        e = entries[choice] if self.is_choice(n) and choice < len(entries) else entries[0]
        return e.get("name") or n.get("name") or str(nid)

    def hero(self, picks):
        sub = next(iter(self.t["subTreeNodes"]), None)
        if not sub or sub["id"] not in picks:
            return "?"
        return self.name(sub["id"], picks[sub["id"]][1])

    def diff(self, a, b):
        """What b has that a does not, and the other way: talent names, ranks where partial."""
        def label(nid, rc):
            n = self.nodes[nid]
            name = self.name(nid, rc[1])
            return f"{name} {rc[0]}/{n.get('maxRanks', 1)}" if n.get("maxRanks", 1) > 1 else name
        plus = [label(k, v) for k, v in b.items() if a.get(k) != v and k in self.nodes]
        minus = [label(k, v) for k, v in a.items() if b.get(k) != v and k in self.nodes]
        return sorted(plus), sorted(minus)


def cached_query(key, text, variables, budget):
    path = os.path.join(CACHE, key + ".json")
    if os.path.exists(path) and time.time() - os.path.getmtime(path) < CACHE_HOURS * 3600:
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    if budget["left"] <= MARGIN:
        raise TimeoutError
    data = wcl.query(text + " rateLimitData { pointsSpentThisHour limitPerHour pointsResetIn } }", variables)
    rl = data.pop("rateLimitData")
    budget["left"] = rl["limitPerHour"] - rl["pointsSpentThisHour"]
    budget["reset"] = rl["pointsResetIn"]
    os.makedirs(CACHE, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f)
    return data


RANKINGS = """query($e:Int!,$c:String!,$s:String!,$p:Int!) { worldData { encounter(id:$e) {
  characterRankings(className:$c, specName:$s, %s includeCombatantInfo:true, page:$p) } }"""


def rankings(enc, cls, spec, content, metric, pages, budget):
    args = f"difficulty:{RAID_DIFFICULTY}, metric:{metric}," if content == "raid" else "metric:playerscore,"
    out = []
    for page in range(1, pages + 1):
        key = f"{cls}-{spec}-{content}-{enc}-p{page}"
        data = cached_query(key, RANKINGS % args, {"e": enc, "c": cls, "s": spec, "p": page}, budget)
        r = data["worldData"]["encounter"]["characterRankings"]
        out += r.get("rankings") or []
        if not r.get("hasMorePages"):
            break
    return out


def zone_encounters(zone, budget):
    data = cached_query(f"zone-{zone}", "query($z:Int!) { worldData { zone(id:$z) { name encounters { id name } } }", {"z": zone}, budget)
    z = data["worldData"]["zone"]
    return z["name"], z["encounters"]


def lua_builds():
    """PlanTab.BUILDS from the Lua: {key: {name: code}}."""
    lua = open(os.path.join(HERE, ub.LUA), encoding="utf-8").read()
    block = lua.split(ub.BEGIN, 1)[1].split(ub.END, 1)[0]
    out, key = {}, None
    for line in block.splitlines():
        m = re.match(r'^\t(?:\["([^"]+)"\]|(\w+)) = \{', line)
        if m:
            key = m.group(1) or m.group(2)
            out[key] = {}
            continue
        m = re.match(r'^\t\t\["([^"]+)"\] = "([^"]+)"', line)
        if m and key:
            out[key][m.group(1)] = m.group(2)
    return out


def summarise(tree, ranked, total_encounters):
    builds, refused, bare, heroes, dates, levels = collections.Counter(), 0, 0, collections.Counter(), [], []
    node_count, choice_count = collections.Counter(), collections.Counter()
    decoded = {}
    for r in ranked:
        if not r.get("talents"):
            bare += 1  # a log with no talent data
            continue
        picks = tree.picks(r["talents"])
        if not picks:
            refused += 1
            continue
        code = tree.encode(picks)
        spec_id, spent = ub.points(code, tree.t)
        if spec_id != tree.t["specId"] or spent != ub.POINTS:
            refused += 1
            continue
        builds[code] += 1
        decoded[code] = tree.decode(code)
        heroes[tree.hero(picks)] += 1
        dates.append(r.get("startTime") or 0)
        if r.get("hardModeLevel"):
            levels.append(r["hardModeLevel"])
        for nid, (_, choice) in decoded[code].items():
            node_count[nid] += 1
            if tree.is_choice(tree.nodes[nid]):
                choice_count[(nid, choice)] += 1
    n = sum(builds.values())
    if not n:
        return None
    top = builds.most_common(ALTERNATIVES + 1)
    split = []
    for nid, c in node_count.items():
        n_ = tree.nodes[nid]
        if n_.get("freeNode") or n_ in tree.t["subTreeNodes"]:
            continue
        if tree.is_choice(n_):
            for (cid, choice), cc in choice_count.items():
                if cid == nid and SPLIT[0] < cc / n < SPLIT[1]:
                    split.append((cc / n, tree.name(nid, choice) + " (choice)"))
        elif SPLIT[0] < c / n < SPLIT[1]:
            split.append((c / n, tree.name(nid)))
    stamp = lambda ms: datetime.fromtimestamp(ms / 1000, timezone.utc).strftime("%Y-%m-%d")
    return {
        "sample": n, "refused": refused, "bare": bare, "encounters": total_encounters,
        "oldest": stamp(min(dates)), "newest": stamp(max(dates)),
        "levels": (min(levels), sorted(levels)[len(levels) // 2], max(levels)) if levels else None,
        "heroes": heroes.most_common(),
        "builds": [{"code": code, "count": c, "share": c / n} for code, c in top],
        "distinct": len(builds),
        "split": sorted(split, reverse=True),
        "_decoded": decoded,
        "_counts": builds,
    }


def main():
    args = sys.argv[1:]
    pages = 1
    if "--pages" in args:
        i = args.index("--pages")
        pages = int(args[i + 1])
        del args[i:i + 2]
    only = set(args)
    req = urllib.request.Request(ub.TALENTS, headers={"User-Agent": "curl/8.0 DjinnisClassProfiles wcl-builds"})
    with urllib.request.urlopen(req, timeout=60) as r:
        trees = json.load(r)
    lua_keys = {spec_id: key for spec_id, key, _ in ub.lua_specs()}
    ours = lua_builds()
    budget = {"left": 10 ** 9, "reset": 0}
    ran = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    results, stopped = {}, None
    try:
        raid_name, raid = zone_encounters(RAID_ZONE, budget)
        mplus_name, mplus = zone_encounters(MPLUS_ZONE, budget)
        for t in sorted(trees, key=lambda t: (t["className"], t["specName"])):
            cls, spec = t["className"].replace(" ", ""), t["specName"].replace(" ", "")
            if only and cls not in only:
                continue
            if t["specId"] not in lua_keys:
                continue
            tree = Tree(t)
            metric = "hps" if (cls, spec) in HEALERS else "dps"
            got = {}
            for content, encs in (("raid", raid), ("mplus", mplus)):
                ranked = []
                for e in encs:
                    ranked += rankings(e["id"], cls, spec, content, metric, pages, budget)
                got[content] = summarise(tree, ranked, len(encs))
            results[t["specId"]] = (t, tree, got)
            print(f"{t['specName']} {t['className']}: raid {got['raid'] and got['raid']['sample']}, M+ {got['mplus'] and got['mplus']['sample']}  ({budget['left']:.0f} points left this hour)")
    except TimeoutError:
        stopped = f"Stopped at the hourly limit; {budget['reset'] // 60} minutes to the reset. Run it again then: what is done is cached."
        print(stopped)

    os.makedirs(REPORT_DIR, exist_ok=True)
    out_json, lines = {}, [
        "# What top Warcraft Logs players run",
        "",
        f"Written by `wcl-builds.py` on {ran}. Card 0064. Read it before changing a build: it does not change the addon.",
        "",
        f"- **Raid:** {raid_name}, Mythic, every boss, top {100 * pages} a boss by {'dps (hps for healers)'}.",
        f"- **Mythic+:** {mplus_name}, every dungeon, top {100 * pages} a dungeon by score.",
        "- **Sample:** one ranking is one character's best logged kill or run this season on that boss or dungeon, so a",
        "  character counts once per boss. Not Archon's \"top 50% in the last 14 days\"; the dates below say how recent it is.",
        f"- **Split talents:** picked by more than {SPLIT[0]:.0%} and fewer than {SPLIT[1]:.0%} of the sample.",
        "- **Ours:** each build in the addon's BUILDS, its share of the sample (exact string), and what the top build",
        "  has that it lacks (+) and the other way (-).",
        "",
    ]
    if stopped:
        lines += [f"**Incomplete:** {stopped}", ""]
    for spec_id, (t, tree, got) in results.items():
        key = lua_keys[spec_id]
        lines += [f"## {t['specName']} {t['className']}", ""]
        out_json[key] = {}
        for content, label in (("raid", "Raid"), ("mplus", "Mythic+")):
            s = got[content]
            if not s:
                lines += [f"**{label}:** no rankings.", ""]
                continue
            lv = f", keys {s['levels'][0]} to {s['levels'][2]} (median {s['levels'][1]})" if s["levels"] and content == "mplus" else ""
            heroes = ", ".join(f"{h} {c / s['sample']:.0%}" for h, c in s["heroes"])
            lines += [f"### {label}", "",
                      f"{s['sample']} rankings over {s['encounters']} {'bosses' if content == 'raid' else 'dungeons'}, logged {s['oldest']} to {s['newest']}{lv}. "
                      f"{s['distinct']} distinct builds. Hero tree: {heroes}." + (f" {s['bare']} left out: their log has no talents." if s["bare"] else "") + (f" {s['refused']} refused: unknown talents or not 34/34/13 points." if s["refused"] else ""),
                      ""]
            top = s["builds"][0]
            top_picks = s["_decoded"][top["code"]]
            lines += [f"**Most common** ({top['count']}, {top['share']:.1%}):", "", f"`{top['code']}`", ""]
            if len(s["builds"]) > 1:
                lines += ["**Alternatives:**", ""]
                for b in s["builds"][1:]:
                    plus, minus = tree.diff(top_picks, s["_decoded"][b["code"]])
                    lines.append(f"- {b['count']} ({b['share']:.1%}): +{', +'.join(plus) or ' nothing'}; -{', -'.join(minus) or ' nothing'}")
                    lines.append(f"  `{b['code']}`")
                lines.append("")
            if s["split"]:
                lines += ["**Split talents:** " + "; ".join(f"{name} {share:.0%}" for share, name in s["split"]), ""]
            mine = {n: c for n, c in ours.get(key, {}).items() if (n.startswith("Raid")) == (content == "raid")}
            if mine:
                lines += ["**Ours:**", ""]
                for name, code in sorted(mine.items()):
                    plus, minus = tree.diff(tree.decode(code), top_picks)
                    # compared as picks: decode leaves granted nodes out, so a re-encoded string never matches (2026-09-25)
                    theirs = tree.decode(code)
                    exact = sum(s["_counts"][c] for c, d in s["_decoded"].items() if d == theirs)
                    share = f"{exact / s['sample']:.1%} run it exactly" if exact else "no one in the sample runs it exactly"
                    if not plus and not minus:
                        lines.append(f"- `{name}`: the most common build.")
                    else:
                        lines.append(f"- `{name}`: {share}. Top has +{', +'.join(plus) or ' nothing'}; lacks {', '.join(minus) or 'nothing'}.")
                lines.append("")
            out_json[key][content] = {k: v for k, v in s.items() if not k.startswith("_")}
            out_json[key][content]["ran"] = ran
    with open(os.path.join(REPORT_DIR, "wcl-report.md"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines) + "\n")
    with open(os.path.join(REPORT_DIR, "wcl-builds.json"), "w", encoding="utf-8", newline="\n") as f:
        json.dump(out_json, f, indent=1)
    print(f"Wrote docs/builds/wcl-report.md ({len(results)} specs).")


if __name__ == "__main__":
    main()
