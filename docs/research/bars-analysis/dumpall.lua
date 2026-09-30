dofile(os.getenv("TEMP") .. "\\sv-dcp.lua")
local out = io.open(os.getenv("TEMP") .. "\\bars-dump.tsv", "w")
local function dump(prefix, t)
  for name, layout in pairs(t or {}) do
    if type(layout) == "table" then
      out:write(("L\t%s%s\t%s\n"):format(prefix, name, tostring(layout.saved)))
      for slot, a in pairs(layout.slots or {}) do
        local body = a.body and a.body:gsub("\r?\n", " ; "):gsub("\t", " ") or ""
        out:write(("S\t%s%s\t%d\t%s\t%s\t%s\n"):format(prefix, name, slot, tostring(a.type), tostring(a.id or a.name), body))
      end
      for key, action in pairs(layout.keys or {}) do
        out:write(("K\t%s%s\t%s\t%s\n"):format(prefix, name, key, action))
      end
    end
  end
end
dump("", DjinnisCPDB.bars)
dump("profile:", DjinnisCPDB.barProfiles)
out:close()
