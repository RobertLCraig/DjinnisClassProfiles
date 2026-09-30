"""A copy of Bellular's planner with Rob's druid keys in ENTER YOUR BINDS HERE,
column B. XML surgery on that one sheet (Excel-Handling-Rules: no openpyxl
round trip). The original is only read."""
import re, shutil, zipfile, os, sys

SRC = r"C:\Dev\SecondBrain\raw\processed\Midnight Keybind Planner (Oldschool Edition).xlsx"
DST = sys.argv[1]

# job -> Rob's key, read off Feral / Dungeon (bars 1, 4, 7), Bellular's notation
ROB = {
    "Combat 1": "2", "Combat 2": "1", "Combat 3": "A3", "Combat 4": "A1", "Combat 5": "5",
    "Combat 6": "SQ", "Combat 7": "3", "Combat 8": "A4", "Combat 9": "AS", "Combat 10": "A2",
    "Combat 11": "T", "Class 1 (Movement)": "SV", "Class 3 (Tag)": "AF", "Self-Heal 1": "S1",
    "Self-Heal 3 (Overflow)": "X", "Self-Heal 4 (Emergency/Overflow)": "Z", "Class 5 (Purge)": "SR",
    "Class 8 (Lust/BRes)": "AD", "Personal Defensive 1": "AW", "Personal Defensive 2": "AQ",
    "Movement Ability": "V", "CC 2": "SD", "Interrupt": "SE", "Res": "AG",
    "Immune/Spell Immune/Movement": "AE", "Taunt/Quick Access": "S3", "Buff": "Num1",
    "Healthstone/Potion Macro": "SS", "Damage Potion": "AA",
}

shutil.copyfile(SRC, DST)
z = zipfile.ZipFile(SRC)
wbxml = z.read("xl/workbook.xml").decode("utf-8")
rels = z.read("xl/_rels/workbook.xml.rels").decode("utf-8")
rid = re.search(r'<sheet [^>]*name="ENTER YOUR BINDS HERE"[^>]*r:id="([^"]+)"', wbxml).group(1)
target = re.search(r'<Relationship [^>]*Id="%s"[^>]*Target="([^"]+)"' % rid, rels) or \
    re.search(r'<Relationship [^>]*Target="([^"]+)"[^>]*Id="%s"' % rid, rels)
path = "xl/" + target.group(1).lstrip("/").replace("xl/", "")
sheet = z.read(path).decode("utf-8")
shared = re.findall(r"<si>(.*?)</si>", z.read("xl/sharedStrings.xml").decode("utf-8"), re.S)
texts = ["".join(re.findall(r"<t[^>]*>(.*?)</t>", s, re.S)) for s in shared]


def cell_text(xml, ref):
    m = re.search(r'<c r="%s"([^>]*?)(?:/>|>(.*?)</c>)' % ref, xml, re.S)
    if not m:
        return None
    v = re.search(r"<v>(.*?)</v>", m.group(2) or "")
    if 't="s"' in m.group(1) and v:
        return texts[int(v.group(1))]
    t = re.search(r"<t[^>]*>(.*?)</t>", m.group(2) or "", re.S)
    return t.group(1) if t else (v.group(1) if v else None)


changed = []
for row in range(3, 60):
    job = cell_text(sheet, "A%d" % row)
    if job in ROB:
        m = re.search(r'<c r="B%d"([^>]*?)(?:/>|>.*?</c>)' % row, sheet, re.S)
        style = re.search(r'\ss="(\d+)"', m.group(1)) if m else None
        new = '<c r="B%d"%s t="inlineStr"><is><t>%s</t></is></c>' % (row, ' s="%s"' % style.group(1) if style else "", ROB[job])
        old = cell_text(sheet, "B%d" % row)
        if m:
            sheet = sheet[:m.start()] + new + sheet[m.end():]
        else:
            rm = re.search(r'(<row r="%d"[^>]*>.*?<c r="A%d"[^>]*?(?:/>|>.*?</c>))' % (row, row), sheet, re.S)
            sheet = sheet[:rm.end()] + new + sheet[rm.end():]
        changed.append((row, job, old, ROB[job]))

# the class sheets read these cells by formula: recalculate on open
wbxml2 = re.sub(r"<calcPr([^>]*?)/>", lambda m: "<calcPr%s fullCalcOnLoad=\"1\"/>" % re.sub(r'\sfullCalcOnLoad="[^"]*"', "", m.group(1)), wbxml)
if "<calcPr" not in wbxml2:
    wbxml2 = wbxml2.replace("</workbook>", '<calcPr fullCalcOnLoad="1"/></workbook>')

tmp = DST + ".tmp"
with zipfile.ZipFile(SRC) as zin, zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as zout:
    for item in zin.infolist():
        data = zin.read(item.filename)
        if item.filename == path:
            data = sheet.encode("utf-8")
        elif item.filename == "xl/workbook.xml":
            data = wbxml2.encode("utf-8")
        zout.writestr(item, data)
os.replace(tmp, DST)
for c in changed:
    print("row %d  %-34s %s -> %s" % c)
print(len(changed), "cells;", path)
