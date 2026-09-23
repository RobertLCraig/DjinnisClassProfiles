"""Author tooling, never shipped (pkgmeta.yaml ignores it).

Rewrites the GENERATED BUILDS block in DjinnisBiS.lua: the talent builds Dreamgrove
recommends, one per boss where the guide gives one, named for WHEN to pick them
(Rob, 2026-09-23: the old "DotC Raid ST *" names "don't convey information that
lets me choose"). Card 0030; it replaces DjinnisDreamgrove's gen_data.py.

    python update-builds.py            # rewrite
    python update-builds.py --check    # exit 1 if the block would change

Sources: the four compendium pages in GitHub's dreamgrove/dreamgrove, fetched
with `gh api` because plain web fetch is blocked for unattended agents on this
machine, and Raidbots' talents.json for the tree. Every build is decoded the way
Blizzard's ReadLoadoutContent reads it and must spend 34 class, 34 spec and 13
hero points in its own spec, or nothing is written.
"""
import json
import re
import subprocess
import sys
import urllib.request
from datetime import date

LUA = "DjinnisBiS.lua"
BEGIN, END = "-- BEGIN GENERATED BUILDS", "-- END GENERATED BUILDS"
TALENTS = "https://www.raidbots.com/static/data/live/talents.json"
POINTS = {"classNodes": 34, "specNodes": 34, "heroNodes": 13}
SPEC_ID = {"Balance": 102, "Feral": 103, "Guardian": 104, "Resto": 105}
PAGE = {"Balance": "balance", "Feral": "feral", "Guardian": "guardian", "Resto": "resto"}

# Guide build name -> the loadout names it backs. One build can back several
# bosses. A build not listed is left out on purpose. The loadout name box takes
# 30 letters. These are the names DjinnisDreamgrove 0.7.0 imported, so a
# loadout already made under one is the same loadout here.
PICK = {
    # Named for the fight, not the hero tree (Rob, 2026-09-23: "Raid: Single
    # Target, Raid: Cleave, Raid: AoE ... means much more"). The guide's own
    # comments say which bosses each is for; the boss rows carry that.
    "Balance": {
        "Elune's Chosen - Single Target": ["Raid: Single Target"],
        "Elune's Chosen - Cleave": ["Raid: Cleave"],
        "Keeper of the Grove - Cleave": ["Raid: Nek'Zali, Nymrissa"],
        "Elune's Chosen M+": ["Dungeon"],
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
        # "DOTC" backed "Dungeon" until 2026-09-24; PIN has it now (card 0047).
    },
    "Guardian": {
        # The guide gives one raid build per hero tree and does not rank them.
        "DotC Raid": ["Raid: Druid of the Claw"],
        "EC Raid Default": ["Raid: Elune's Chosen"],
        "Razeless": ["Dungeon"],
        "Razeless sustain": ["Dungeon: survive more"],
    },
    "Resto": {
        "Raid w/ mana return": ["Raid: short on mana"],
        "Raid w/o mana return": ["Raid: mana is fine"],
        "M+ #HealersHeal": ["Dungeon: heal only"],
        "M+ Cat DPS": ["Dungeon: cat damage"],
        "M+ Caster DPS": ["Dungeon: caster damage"],
    },
}

# Builds no guide publishes, pinned by hand: loadout name -> (string, source).
# Checked for spec and points like the rest, and never refreshed: copy a new
# string in when the tree changes (the points check fails loudly when it does).
PIN = {
    "Feral": {
        # Card 0047. Archon, Mythic+, High Keys, all dungeons, recommended build
        # with its recommended class tree (39.5% and 64.7%, 2,600 runs),
        # 2026-09-24. Against Dreamgrove's DOTC: Double-Clawed Rake for Tireless
        # Energy, and Lycara's Inspiration and Ursine Vigor for Innervate and
        # Forestwalk (wowvalor top 50: 100%, 82%, 12%, 2%). Archon has a human
        # check, so it cannot be fetched here.
        "Dungeon": ("CcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAgZmZ2YmZmxY2M2mZZGzMmZAAAAYJY2M8AmZUzYWMzMzsMmhBAAAAAwADAAAgmZZWmZmBAsAzMDwCDGAAAzshB",
                    "Archon high keys #1, 2026-09-24"),
    },
}

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


def block(trees):
    if set(PIN) - set(SPEC_ID):
        sys.exit(f"PIN names a spec SPEC_ID does not: {sorted(set(PIN) - set(SPEC_ID))}. Its builds would vanish.")
    lines = [BEGIN, f'PlanTab.BUILD_SOURCE = "dreamgrove.gg compendiums, and the pinned builds in update-builds.py PIN, read {date.today()}"', "PlanTab.BUILDS = {"]
    for spec in SPEC_ID:
        guide = guide_builds(spec)
        missing = set(PICK[spec]) - set(guide)
        if missing:
            sys.exit(f"{spec}: the guide no longer has {sorted(missing)}. Change PICK, do not guess.")
        tree = next(t for t in trees if t["specId"] == SPEC_ID[spec])
        lines.append(f"\t{spec} = {{")
        for source, names in PICK[spec].items():
            code = guide[source]
            got, spent = points(code, tree)
            if got != SPEC_ID[spec] or spent != POINTS:
                sys.exit(f"{spec} {source}: spec {got}, points {spent}. Not written.")
            for name in names:
                assert len(name) <= 30 and '"' not in name, name
                lines.append(f'\t\t["{name}"] = "{code}", -- {source}')
        for name, (code, source) in PIN.get(spec, {}).items():
            got, spent = points(code, tree)
            if got != SPEC_ID[spec] or spent != POINTS:
                sys.exit(f"{spec} pinned {name}: spec {got}, points {spent}. Copy a fresh string in.")
            if len(name) > 30 or '"' in name or any(name in n for n in PICK[spec].values()):
                sys.exit(f"{spec} pinned {name!r}: over 30 letters, a quote, or already a PICK name.")
            lines.append(f'\t\t["{name}"] = "{code}", -- {source}')
        lines.append("\t},")
    lines += ["}", END]
    return lines


def main():
    lua = open(LUA, encoding="utf-8", newline="").read()
    if BEGIN not in lua or END not in lua:
        sys.exit(f"{LUA} has no {BEGIN} / {END} markers. Put them back rather than guessing where the table goes.")
    req = urllib.request.Request(TALENTS, headers={"User-Agent": "curl/8.0 DjinnisBiS update-builds"})
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
