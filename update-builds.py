"""Author tooling, never shipped (pkgmeta.yaml ignores it).

Rewrites the GENERATED BUILDS block in DjinnisClassProfiles.lua: the talent builds Dreamgrove
recommends, one per boss where the guide gives one, named for WHEN to pick them
(Rob, 2026-09-23: the old "DotC Raid ST *" names "don't convey information that
lets me choose"). Card 0030; it replaces DjinnisDreamgrove's gen_data.py.

    python update-builds.py            # rewrite
    python update-builds.py --check    # exit 1 if the block would change

Sources: the four compendium pages in GitHub's dreamgrove/dreamgrove, fetched
with `gh api` because plain web fetch is blocked for unattended agents on this
machine, and Raidbots' talents.json for the tree. Every build is decoded the way
Blizzard's ReadLoadoutContent reads it and must spend 34 class, 34 spec and 13
hero points in its own spec, or nothing is written. Each spec's "Dungeon" is
not Dreamgrove's but a string pinned in PIN below (card 0047), checked the same way.

Warcraft Logs first (card 0064; Rob, 2026-09-25: automatic). `python
wcl-builds.py` writes docs/builds/wcl-builds.json: each spec's typical raid and
Mythic+ build among top ranked players, and each druid boss's. This script
reads that file and takes, in order of precedence:
- a PIN entry, always, because it was put there by hand;
- every spec's "Dungeon", and "Raid" for every spec with no boss rows (every
  non-druid, Guardian, Resto): the Warcraft Logs typical;
- a druid boss row (PlanTab.BOSSES): the typical pooled over every boss its
  loadout backs, when WCL_MIN_SAMPLE players or more ranked on them. Which
  boss goes with which row is the Lua's, grouped by what players run.
The rest (Dreamgrove's) fill in where the logs have too few. A file older than
WCL_MAX_DAYS stops the run: run wcl-builds.py first.

Where Warcraft Logs has no build, the older sources fill in (card 0050),
keyed by PlanTab.SPECS in the Lua, the one list of specs:
- "Dungeon": wowvalor.app's recommendedBuild for Mythic+, the exact build most
  of its top 50 characters of the spec run. It needs a browser user agent.
- "Raid": SimulationCraft's default profile for the tier (SIMC_TIER), read with
  `gh api`. SimC keeps none for healers or Evokers.
Archon, Icy Veins and Wowhead all refuse scripts (a human check or a 403), and
that is not worked around.
"""
import gzip
import json
import re
import subprocess
import sys
import urllib.request
from datetime import date, datetime

LUA = "DjinnisClassProfiles.lua"
BEGIN, END = "-- BEGIN GENERATED BUILDS", "-- END GENERATED BUILDS"
TALENTS = "https://www.raidbots.com/static/data/live/talents.json"
POINTS = {"classNodes": 34, "specNodes": 34, "heroNodes": 13}
SPEC_ID = {"Balance": 102, "Feral": 103, "Guardian": 104, "Resto": 105}
PAGE = {"Balance": "balance", "Feral": "feral", "Guardian": "guardian", "Resto": "resto"}
DRUID = 11  # PlanTab.DRUID: druids keep the Dreamgrove rows above
SIMC_TIER = "MID2"  # profiles/<tier>/ in simulationcraft/simc; move it with the season
VALOR = "https://wowvalor.app/en/stats/{cls}/{spec}/m+"
WCL_JSON = "docs/builds/wcl-builds.json"  # written by wcl-builds.py
WCL_MAX_DAYS = 14
WCL_MIN_SAMPLE = 20  # rankings with talents; Feral had 10 on Twin Fangs on 2026-09-25
# Blizzard's name box takes 30 letters, and the longest mark the addon puts in
# front ("[CP*] ", "[CP+] ") is 6; the Lua's self-test checks the same.
NAME_MAX = 24
BROWSER = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0 Safari/537.36"

# Guide build name -> the loadout names it backs. One build can back several
# bosses. A build not listed is left out on purpose. The loadout name box takes
# 30 letters. These are the names DjinnisDreamgrove 0.7.0 imported, so a
# loadout already made under one is the same loadout here.
PICK = {
    # Named for the fight, not the hero tree (Rob, 2026-09-23: "Raid: Single
    # Target, Raid: Cleave, Raid: AoE ... means much more"). The guide's own
    # comments say which bosses each is for; the boss rows carry that.
    # Since card 0064 each raid row takes the Warcraft Logs typical of its
    # bosses; the guide build only fills a row the logs have too few for.
    "Balance": {
        "Elune's Chosen - Single Target": ["Raid: Nek'Zali, Altar"],
        "Elune's Chosen - Cleave": ["Raid: Cleave"],
        # Keeper of the Grove, which top players run on these four. The guide's
        # only Keeper build is its cleave one; it fills in only without logs.
        "Keeper of the Grove - Cleave": ["Raid: Single Target"],
        # Each spec's "Dungeon" is in PIN since card 0047: what players run.
    },
    "Feral": {
        "Nekzali": ["Raid: Nek'Zali"],
        "Entombed Sentinels": ["Raid: Entombed Sentinels"],
        "Sszorak": ["Raid: Sszorak"],
        "Twin Fangs": ["Raid: Twin Fangs"],
        "Lost Explorers": ["Raid: Lost Explorers"],
        "Vashnik": ["Raid: Vashnik"],
        "Coiled Altar": ["Raid: Coiled Altar"],
        "Ulatek": ["Raid: Ula'tek"],
        "Nymrissa (Lair)": ["Raid: Nymrissa"],
    },
    # Guardian and Resto's raid rows ("Raid: Druid of the Claw", "Raid: Elune's
    # Chosen", "Raid: short on mana", "Raid: mana is fine") became one "Raid"
    # from Warcraft Logs (Rob, 2026-09-25): no top player ran any of the four.
    "Guardian": {
        "Razeless sustain": ["Dungeon: survive more"],
    },
    "Resto": {
        "M+ Cat DPS": ["Dungeon: cat damage"],
        "M+ Caster DPS": ["Dungeon: caster damage"],
    },
}

# Builds pinned by hand: spec -> {loadout name: (string, source)}. A pin beats
# every fetched source. Checked for spec and points like the rest, and never
# refreshed: copy a new string in when the tree changes (the points check fails
# loudly when it does). The druids' "Dungeon" pins (Archon's, card 0047) gave
# way to Warcraft Logs on 2026-09-25 (card 0064); git holds them.
PIN = {}

CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
VAL = {c: i for i, c in enumerate(CHARS)}


class Bits:
    """Blizzard's ExportUtil stream: LSB first, 6 bits a character. Past the
    end reads as zero, as the game reads the padding."""

    def __init__(self, code):
        self.bits = [(VAL[c] >> i) & 1 for c in code for i in range(6)]
        self.pos = 0

    def take(self, n):
        v = sum(self.bits[self.pos + i] << i for i in range(n) if self.pos + i < len(self.bits))
        self.pos += n
        return v


def encode(bits):
    """ExportUtil's writer: bits LSB first, 6 a character, zero padded."""
    bits = bits + [0] * (-len(bits) % 6)
    return "".join(CHARS[sum(bits[i + j] << j for j in range(6))] for i in range(0, len(bits), 6))


def ungrant(code, tree):
    """The string with every free node (a hero tree's keystone) read as granted,
    not purchased: the way the game exports it. SimC writes the keystone as
    purchased, and Blizzard's import (CreateImportLoadoutEntryInfoFromSingleNode)
    would then buy a 14th hero rank. Returns (code, how many were changed)."""
    free = {n["id"] for n in tree["heroNodes"] if n.get("freeNode")}
    s, out = Bits(code), []

    def copy(n):
        v = s.take(n)
        out.extend((v >> i) & 1 for i in range(n))
        return v

    copy(8), copy(16), copy(128)
    changed = 0
    for node_id in tree["fullNodeOrder"]:
        if not copy(1):
            continue
        if node_id in free:
            if s.take(1):  # purchased: drop it and the rank and choice bits after it
                if s.take(1):
                    s.take(6)
                if s.take(1):
                    s.take(2)
                changed += 1
            out.append(0)
            continue
        if not copy(1):
            continue
        if copy(1):
            copy(6)
        if copy(1):
            copy(2)
    return (encode(out) if changed else code), changed


def points(code, tree):
    """(spec id, {part: points}) for one import string."""
    s = Bits(code)
    s.take(8)
    spec = s.take(16)
    s.take(128)
    nodes = {n["id"]: (part, n) for part in ("classNodes", "specNodes", "heroNodes", "subTreeNodes") for n in tree[part]}
    picks = {}
    for node_id in tree["fullNodeOrder"]:
        if not s.take(1) or not s.take(1):
            continue  # not selected, or granted free
        rank = s.take(6) if s.take(1) else None
        choice = s.take(2) if s.take(1) else 0
        picks[node_id] = (rank, choice)
    # A string can carry points in both hero trees; the one picked on the
    # subtree node is the live one.
    hero = tree["subTreeNodes"][0]
    live = hero["entries"][picks.get(hero["id"], (None, 0))[1]]["traitSubTreeId"]
    spent = {}
    for node_id, (rank, _) in picks.items():
        part, n = nodes.get(node_id, (None, None))
        if part not in POINTS or (part == "heroNodes" and n.get("subTreeId") != live):
            continue
        spent[part] = spent.get(part, 0) + (rank if rank is not None else n.get("maxRanks", 1))
    return spec, spent


def guide_builds(spec):
    raw = subprocess.run(
        ["gh", "api", f"repos/dreamgrove/dreamgrove/contents/data/blog/{PAGE[spec]}/compendium.mdx",
         "-H", "Accept: application/vnd.github.raw"],
        capture_output=True, text=True, encoding="utf-8", check=True).stdout
    out = {}
    for tag in re.findall(r"<Talents\b(.*?)/?>", raw, re.S):
        if "hideCopy" in tag:
            continue
        # Feral writes `talents= {"..."}` with a space; allow it or miss builds.
        name = re.search(r'name=\s*\{?"([^"]*)"', tag)
        code = re.search(r'talents=\s*\{?"([^"]*)"', tag)
        if name and code:
            out[name.group(1).strip()] = code.group(1)
    return out


def lua_specs():
    """PlanTab.SPECS from the Lua, in its order: [(id, key, class id)]."""
    lua = open(LUA, encoding="utf-8").read()
    rows = re.findall(r'\{ (\d+), "([^"]+)", (\d+), "(?:TANK|HEALER|DAMAGER)" \}', lua)
    if len(rows) != 40:
        sys.exit(f"PlanTab.SPECS in {LUA} reads as {len(rows)} specs, not 40. Fix the pattern or the table, do not guess.")
    return [(int(i), key, int(cls)) for i, key, cls in rows]


def lua_bosses():
    """PlanTab.BOSSES from the Lua: {spec key: [(encounter id, boss, loadout)]}, raid rows only."""
    lua = open(LUA, encoding="utf-8").read()
    block = lua.split("PlanTab.BOSSES = {", 1)[1].split("\n}", 1)[0]
    out, key = {}, None
    for line in block.splitlines():
        m = re.match(r"^\t(\w+) = \{", line)
        if m:
            key = m.group(1)
            out[key] = []
            continue
        m = re.search(r'boss = "([^"]+)",\s*id = (\d+),.*loadout = "([^"]+)"', line)
        if m and key:
            out[key].append((int(m.group(2)), m.group(1), m.group(3)))
    return out


def wcl_picks():
    """What wcl-builds.json says each row should be: {spec key: {loadout name: (code, source)}}.
    "Dungeon" and "Raid" for every spec, and each druid boss row, pooled over the
    bosses it backs. Stops when the file is missing or older than WCL_MAX_DAYS."""
    try:
        with open(WCL_JSON, encoding="utf-8") as f:
            data = json.load(f)
    except FileNotFoundError:
        sys.exit(f"No {WCL_JSON}. Run `python wcl-builds.py` first. Nothing written.")
    # Only the specs PlanTab.SPECS has now: a dropped spec's old date must not stop every run.
    data = {k: v for k, v in data.items() if k in {key for _, key, _ in lua_specs()}}
    ran = min((c["ran"] for spec in data.values() for c in (spec.get("raid"), spec.get("mplus")) if c), default=None)
    if not ran:
        sys.exit(f"{WCL_JSON} has no spec the addon knows. Run `python wcl-builds.py` first. Nothing written.")
    age = (datetime.now() - datetime.strptime(ran[:10], "%Y-%m-%d")).days
    if age > WCL_MAX_DAYS:
        sys.exit(f"{WCL_JSON} is {age} days old. Run `python wcl-builds.py` first. Nothing written.")
    out = {}
    for key, spec in data.items():
        rows = out[key] = {}
        for content, name, what in (("raid", "Raid", "raid, all bosses"), ("mplus", "Dungeon", "M+, all dungeons")):
            c = spec.get(content)
            if c and c["sample"] >= WCL_MIN_SAMPLE:
                p = c["pick"]
                rows[name] = (p["code"], f"Warcraft Logs {what}: typical of {c['sample']}, {p['agreement']:.0%} agree on {p['contested']} contested, {c['ran'][:10]}")
    # Boss rows: the typical pooled over the bosses the row backs. Only when the
    # JSON's bosses are the Lua's now: a row regrouped since the run would
    # otherwise take the old group's build (0064 review).
    for key, bosses in lua_bosses().items():
        for loadout, row in data.get(key, {}).get("rows", {}).items():
            now = [boss for _, boss, l in bosses if l == loadout]
            if row["bosses"] != now:
                print(f"{key} {loadout}: backs {now} now, {row['bosses']} when wcl-builds.py ran. Run it again.", file=sys.stderr)
            elif row["sample"] >= WCL_MIN_SAMPLE:
                p = row["pick"]
                out.setdefault(key, {})[loadout] = (p["code"], f"Warcraft Logs {', '.join(now)}: typical of {row['sample']}, {p['agreement']:.0%} agree on {p['contested']} contested, {row['ran'][:10]}")
    return out


def slug(name):
    return name.lower().replace("'", "").replace(" ", "-")


def fetch(url, agent, tries=3):
    """Three tries: a TLS handshake timeout on one page of 36 is common here."""
    req = urllib.request.Request(url, headers={"User-Agent": agent, "Accept-Encoding": "gzip"})
    for attempt in range(tries):
        try:
            with urllib.request.urlopen(req, timeout=60) as r:
                body = r.read()
                if r.headers.get("Content-Encoding") == "gzip":
                    body = gzip.decompress(body)
            return body.decode("utf-8", "replace")
        except (urllib.error.URLError, TimeoutError) as e:
            if attempt == tries - 1:
                sys.exit(f"{url}: {e}. Nothing written.")


def valor_dungeon(tree):
    """wowvalor's recommendedBuild import string for the spec's Mythic+ page, or None."""
    html = fetch(VALOR.format(cls=slug(tree["className"]), spec=slug(tree["specName"])), BROWSER)
    at = html.find("recommendedBuild:")
    m = at >= 0 and re.search(r'importString:"([A-Za-z0-9+/]+)"', html[at:at + 800])
    return m.group(1) if m else None


def simc_raid(tree):
    """The talents= line of SimC's default profile for the spec this tier, or None."""
    name = f"{SIMC_TIER}_{tree['className'].replace(' ', '_')}_{tree['specName'].replace(' ', '_')}.simc"
    got = subprocess.run(
        ["gh", "api", f"repos/simulationcraft/simc/contents/profiles/{SIMC_TIER}/{name}",
         "-H", "Accept: application/vnd.github.raw"],
        capture_output=True, text=True, encoding="utf-8")
    if got.returncode != 0:
        if "Not Found" in got.stdout + got.stderr:
            return None
        sys.exit(f"gh api failed on {name}: {got.stderr.strip()}")
    m = re.search(r"^talents=(\S+)", got.stdout, re.M)
    return m.group(1) if m else None


def lua_key(key):
    return key if re.fullmatch(r"[A-Za-z_]\w*", key) else f'["{key}"]'


class Refused(Exception):
    pass


def checked(spec_name, spec_id, name, code, source, tree):
    got, spent = points(code, tree)
    if got != spec_id or spent != POINTS:
        raise Refused(f"{spec_name} {name} ({source}): spec {got}, points {spent}")
    return f'\t\t["{name}"] = "{code}", -- {source}'


def from_wcl(key, spec_id, name, picks, tree):
    """The checked row for a Warcraft Logs build, or None so the next source fills
    it. A refused one is said, not fatal (0064 review): wcl-builds.py checks points
    already, so a refusal here means the tree moved since it ran."""
    pick = picks.get(key, {}).get(name)
    if not pick:
        return None
    try:
        return checked(key, spec_id, name, *pick, tree)
    except Refused as e:
        print(f"Warcraft Logs build refused, the older source used: {e}", file=sys.stderr)
        return None


def other_classes(trees, lines, picks):
    """Every non-druid spec: PIN, else Warcraft Logs, else wowvalor's Dungeon and SimC's Raid.
    A pinned or Dungeon string that fails the check stops the run. SimC's Raid
    string only drops out, named: SimC keeps some profiles on a stale tree
    (Frost Death Knight's spent 9 class points on 2026-09-24), and one stale
    file must not hold every other spec back. Returns the specs with no Raid."""
    no_raid = []
    for spec_id, key, cls in lua_specs():
        if cls == DRUID:
            continue
        tree = next((t for t in trees if t["specId"] == spec_id), None)
        if not tree:
            sys.exit(f"Raidbots has no tree for spec {spec_id} ({key}).")
        pinned = PIN.get(key, {})
        rows = {}
        why_no_raid = "no profile"
        for name, fetcher, source in (("Dungeon", valor_dungeon, "wowvalor M+ recommended"),
                                      ("Raid", simc_raid, f"SimulationCraft {SIMC_TIER} profile")):
            optional = name == "Raid" and name not in pinned
            wl = None if name in pinned else from_wcl(key, spec_id, name, picks, tree)
            if wl:
                rows[name] = wl
                continue
            if name in pinned:
                code, source = pinned[name]
            else:
                code = fetcher(tree)
                if code:
                    code, changed = ungrant(code, tree)
                    if changed:
                        source += ", free keystone read as granted"
            if not code:
                continue
            try:
                rows[name] = checked(key, spec_id, name, code, source, tree)
            except Refused as e:
                if not optional:
                    sys.exit(f"{e}. Nothing written.")
                why_no_raid = f"refused: {e}"
        for name in pinned:
            if name not in rows:
                try:
                    rows[name] = checked(key, spec_id, name, pinned[name][0], pinned[name][1], tree)
                except Refused as e:
                    sys.exit(f"{e}. Copy a fresh string into PIN.")
        if "Dungeon" not in rows:
            sys.exit(f"{key}: neither Warcraft Logs nor wowvalor gave a Mythic+ build. Check them, or PIN one.")
        if "Raid" not in rows:
            no_raid.append(f"{key} ({why_no_raid})")
        lines.append(f"\t{lua_key(key)} = {{")
        lines.extend(rows[name] for name in sorted(rows))
        lines.append("\t},")
    return no_raid


def block(trees):
    known = set(SPEC_ID) | {key for _, key, _ in lua_specs()}
    if set(PIN) - known:
        sys.exit(f"PIN names a spec PlanTab.SPECS does not: {sorted(set(PIN) - known)}. Its builds would vanish.")
    picks = wcl_picks()
    lines = [BEGIN, f'PlanTab.BUILD_SOURCE = "Warcraft Logs top rankings (typical build), dreamgrove.gg compendiums for the druid rows it does not cover, wowvalor.app and SimulationCraft where it has none, and the pinned builds in update-builds.py PIN, read {date.today()}"', "PlanTab.BUILDS = {"]
    for spec in SPEC_ID:
        guide = guide_builds(spec)
        tree = next(t for t in trees if t["specId"] == SPEC_ID[spec])
        # One row a name, by precedence: PIN, then Warcraft Logs, then the guide.
        # A dict, so no name can be written twice (0064 review).
        rows = {}
        for name, (code, source) in PIN.get(spec, {}).items():
            if len(name) > NAME_MAX or '"' in name:
                sys.exit(f"{spec} pinned {name!r}: over {NAME_MAX} letters, or a quote.")
            try:
                rows[name] = checked(spec, SPEC_ID[spec], name, code, source, tree)
            except Refused as e:
                sys.exit(f"{e}. Copy a fresh string into PIN.")
        # A spec with no boss rows (Guardian, Resto) gets one "Raid", the logs' typical
        # (Rob, 2026-09-25): the guide's raid builds were ones no top player ran.
        boss_rows = [l for _, _, l in lua_bosses().get(spec, [])]
        raid = [] if boss_rows else ["Raid"]
        for name in dict.fromkeys(["Dungeon"] + raid + boss_rows + [n for names in PICK[spec].values() for n in names]):
            if name not in rows:
                wl = from_wcl(spec, SPEC_ID[spec], name, picks, tree)
                if wl:
                    rows[name] = wl
        for source, names in PICK[spec].items():
            if all(name in rows for name in names):
                continue  # every row it backs has a better source: the guide may drop it
            if source not in guide:
                sys.exit(f"{spec}: the guide no longer has {source!r}. Change PICK, do not guess.")
            try:
                for name in names:
                    assert len(name) <= NAME_MAX and '"' not in name, name
                    rows.setdefault(name, checked(spec, SPEC_ID[spec], name, guide[source], source, tree))
            except Refused as e:
                sys.exit(f"{e}. Not written.")
        # Every spec's boss rows or the M+ reminder load "Dungeon"; a lost source
        # must not drop it without a word (0047 review).
        # Nothing else backs these: no row may drop out without a word (0064 review).
        for name in ["Dungeon"] + raid + boss_rows:
            if name not in rows:
                sys.exit(f"{spec} has no {name!r} build: Warcraft Logs had under {WCL_MIN_SAMPLE} rankings and no PICK or PIN fills it. PIN one.")
        lines.append(f"\t{spec} = {{")
        lines.extend(rows.values())
        lines.append("\t},")
    no_raid = other_classes(trees, lines, picks)
    if no_raid:
        print(f"No Raid build, and no PIN for one: {'; '.join(no_raid)}", file=sys.stderr)
    lines += ["}", END]
    return lines


def main():
    lua = open(LUA, encoding="utf-8", newline="").read()
    if BEGIN not in lua or END not in lua:
        sys.exit(f"{LUA} has no {BEGIN} / {END} markers. Put them back rather than guessing where the table goes.")
    req = urllib.request.Request(TALENTS, headers={"User-Agent": "curl/8.0 DjinnisClassProfiles update-builds"})
    with urllib.request.urlopen(req, timeout=60) as r:
        trees = json.load(r)
    nl = "\r\n" if "\r\n" in lua else "\n"
    new = nl.join(block(trees))
    pattern = re.compile(re.escape(BEGIN) + ".*?" + re.escape(END), re.S)
    old = pattern.search(lua).group(0)
    # The date line changes every day; compare the builds, not the date.
    if old.split("PlanTab.BUILDS", 2)[-1] == new.split("PlanTab.BUILDS", 2)[-1]:
        print("BUILDS block already current.")
        return
    if "--check" in sys.argv:
        sys.exit("The BUILDS block is out of date. Run without --check.")
    open(LUA, "w", encoding="utf-8", newline="").write(pattern.sub(lambda _: new, lua))
    print("BUILDS block written.")


if __name__ == "__main__":
    main()
