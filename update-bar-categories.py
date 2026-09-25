"""Author tooling, never shipped (pkgmeta.yaml ignores it).

Rewrites the GENERATED BAR CATEGORIES block in DjinnisClassProfiles.lua from
Bellular's Midnight Keybinding Planner (card 0051). Each row of its Master
Sheet is a category ("Combat 1", "Personal Defensive 1", "Interrupt") and the
ability each spec puts there, so one key does one job in every spec. The addon
reads the block to turn a druid layout into another spec's: a button's druid
ability gives the category, and the category gives the other spec's ability.

    python update-bar-categories.py            # rewrite
    python update-bar-categories.py --check    # exit 1 if the block would change
    python update-bar-categories.py --file x.csv   # read a saved copy, not the sheet

The sheet is public and downloads as CSV with no sign-in. Its spec columns are
named, but four names come twice (Frost, Restoration, Holy, Protection), so
they are read by position against COLUMNS below. A sheet whose header differs
stops the run: a new column must be mapped by hand, not guessed.

A cell is cleaned, not rewritten: a trailing "?" and a note in brackets go
("Void Torrent/Halo (macro this?)" is "Void Torrent/Halo"). A "/" stays: it
lists alternatives, and the addon takes the first one the character knows.
"""
import csv
import io
import re
import sys
import urllib.request
from datetime import date

LUA = "DjinnisClassProfiles.lua"
BEGIN, END = "-- BEGIN GENERATED BAR CATEGORIES", "-- END GENERATED BAR CATEGORIES"
SHEET = "1czh-ldWbTuNJbsxpzmzDG9iCO3YSVDlqafuUzbuQlJ4"
MASTER_GID = "570501571"
URL = f"https://docs.google.com/spreadsheets/d/{SHEET}/export?format=csv&gid={MASTER_GID}"

# The sheet's header, left to right, and the PlanTab.SPECS key of each spec
# column. "Markmanship" is the sheet's own spelling.
FIXED = ["Bar", "Slot", "Keybind", "Category (Common Use)"]
COLUMNS = [
    ("Blood", "Blood"), ("Frost", "Frost Death Knight"), ("Unholy", "Unholy"),
    ("Devourer", "Devourer"), ("Havoc", "Havoc"), ("Vengeance", "Vengeance"),
    ("Balance", "Balance"), ("Feral", "Feral"), ("Guardian", "Guardian"), ("Restoration", "Resto"),
    ("Augmentation", "Augmentation"), ("Devastation", "Devastation"), ("Preservation", "Preservation"),
    ("Beast Mastery", "Beast Mastery"), ("Markmanship", "Marksmanship"), ("Survival", "Survival"),
    ("Arcane", "Arcane"), ("Fire", "Fire"), ("Frost", "Frost Mage"),
    ("Brewmaster", "Brewmaster"), ("Mistweaver", "Mistweaver"), ("Windwalker", "Windwalker"),
    ("Holy", "Holy Paladin"), ("Protection", "Protection Paladin"), ("Retribution", "Retribution"),
    ("Discipline", "Discipline"), ("Holy", "Holy Priest"), ("Shadow", "Shadow"),
    ("Assassination", "Assassination"), ("Outlaw", "Outlaw"), ("Subtlety", "Subtlety"),
    ("Elemental", "Elemental"), ("Enhancement", "Enhancement"), ("Restoration", "Restoration Shaman"),
    ("Affliction", "Affliction"), ("Demonology", "Demonology"), ("Destruction", "Destruction"),
    ("Arms", "Arms"), ("Fury", "Fury"), ("Protection", "Protection Warrior"),
]


def fetch():
    req = urllib.request.Request(URL, headers={"User-Agent": "curl/8.0 DjinnisClassProfiles update-bar-categories"})
    with urllib.request.urlopen(req, timeout=60) as r:
        return r.read().decode("utf-8")


def clean(cell):
    cell = re.sub(r"\([^)]*\)", "", cell)
    cell = cell.strip().rstrip("?").strip()
    return re.sub(r"\s*/\s*", "/", re.sub(r"\s+", " ", cell))


def read(text):
    rows = list(csv.reader(io.StringIO(text)))
    want = FIXED + [name for name, _ in COLUMNS]
    if rows[0] != want:
        sys.exit("The Master Sheet's header changed. Map the new columns in COLUMNS. Nothing written.\n"
                 f"  expected: {want}\n  got:      {rows[0]}")
    categories, abilities = [], {key: [] for _, key in COLUMNS}
    for row in rows[1:]:
        name = row[3].strip() if len(row) > 3 else ""
        if not name:
            continue  # the sheet's blank rows at the end
        if name in categories:
            sys.exit(f"Category {name!r} is on two rows. Nothing written.")
        categories.append(name)
        for i, (_, key) in enumerate(COLUMNS):
            cell = row[4 + i] if 4 + i < len(row) else ""
            abilities[key].append(clean(cell))
    if len(categories) < 30:
        sys.exit(f"Only {len(categories)} categories read. Nothing written.")
    return categories, abilities


def block(categories, abilities):
    q = lambda s: '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'
    out = [BEGIN,
           f'PlanTab.BAR_CATEGORY_SOURCE = "Bellular\'s Midnight Keybinding Planner, Master Sheet, read {date.today()}"',
           "PlanTab.BAR_CATEGORIES = {"]
    out += ["\t" + ", ".join(q(c) for c in categories[i:i + 6]) + "," for i in range(0, len(categories), 6)]
    out += ["}", "-- spec -> the ability in each category above, \"\" for none, \"A/B\" for either",
            "PlanTab.BAR_ABILITIES = {"]
    for _, key in COLUMNS:
        out.append(f"\t[{q(key)}] = {{ " + ", ".join(q(a) for a in abilities[key]) + " },")
    out += ["}", END]
    return "\n".join(out)


def main():
    lua = open(LUA, encoding="utf-8", newline="").read()
    nl = "\r\n" if "\r\n" in lua else "\n"
    if BEGIN not in lua or END not in lua:
        sys.exit(f"{LUA} has no {BEGIN} / {END} markers. Put them back rather than guessing where the table goes.")
    specs = set(re.findall(r'\{ \d+, "([^"]+)", \d+, "[A-Z]+" \}', lua))
    unknown = [key for _, key in COLUMNS if key not in specs]
    if unknown:
        sys.exit(f"Not in PlanTab.SPECS: {unknown}. Nothing written.")
    if "--file" in sys.argv:
        text = open(sys.argv[sys.argv.index("--file") + 1], encoding="utf-8").read()
    else:
        text = fetch()
    new = block(*read(text)).replace("\n", nl)
    pattern = re.compile(re.escape(BEGIN) + ".*?" + re.escape(END), re.S)
    old = pattern.search(lua).group(0)
    strip = lambda s: re.sub(r"read \d{4}-\d{2}-\d{2}", "", s)
    if strip(old) == strip(new):
        print("Already current")
        return
    if "--check" in sys.argv:
        sys.exit("The BAR CATEGORIES block is out of date. Run without --check.")
    open(LUA, "w", encoding="utf-8", newline="").write(pattern.sub(lambda _: new, lua))
    print(f"Wrote {new.count(nl) + 1} lines to {LUA}")


if __name__ == "__main__":
    main()
