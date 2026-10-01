"""Card 0082. Pulls the spell list out of Bellular's keybinding web tool
(https://keybinding.bellular.games/), which carries every spec's spells with
their spell id and icon name, and writes bellular_spells.json next to this
script. Read only; the page is fetched over HTTPS.

    python docs/research/bars-analysis/bellular_spells.py
"""
import json, os, re, urllib.request

BASE = "https://keybinding.bellular.games"
HERE = os.path.dirname(os.path.abspath(__file__))


def get(url):
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (DjinnisClassProfiles keybind page)"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return r.read().decode("utf-8", "replace")


html = get(BASE + "/")
chunks = re.findall(r'src="(/_next/static/chunks/[^"]+\.js)"', html)
spells = {}
for path in chunks:
    js = get(BASE + path)
    for m in re.finditer(r'\{id:(\d+),name:"((?:[^"\\]|\\.)*)",category:"([^"]*)",iconName:"([^"]*)"(?:,[a-zA-Z]+:(?:"[^"]*"|!?[01]|\d+))*,specs:\[([0-9,]*)\]', js):
        sid, name, cat, icon, specs = m.groups()
        name = name.encode().decode("unicode_escape")
        e = spells.setdefault(sid, {"id": int(sid), "name": name, "category": cat, "icon": icon, "specs": []})
        e["specs"] = sorted(set(e["specs"]) | {int(s) for s in specs.split(",") if s})
    # the preset bar layouts carry more spells (no spec list): {actionType:"spell",id:..,name:..,iconName:..}
    for m in re.finditer(r'\{actionType:"spell",id:(\d+),name:"((?:[^"\\]|\\.)*)",iconName:"([^"]*)"', js):
        sid, name, icon = m.groups()
        if sid not in spells:
            spells[sid] = {"id": int(sid), "name": name.encode().decode("unicode_escape"), "category": "", "icon": icon, "specs": []}
out = sorted(spells.values(), key=lambda e: e["id"])
with open(os.path.join(HERE, "bellular_spells.json"), "w", encoding="utf-8") as f:
    json.dump({"source": BASE + "/", "spells": out}, f, ensure_ascii=False, indent=0)
print(len(out), "spells from", len(chunks), "scripts")
