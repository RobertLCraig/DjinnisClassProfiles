<#
.SYNOPSIS
    Refresh the trinket tier table in DjinnisBiS.lua from ClassCodex's data files.

.DESCRIPTION
    An addon-author tool, not a runtime one. A WoW addon cannot make a network
    request: there is no HTTP call anywhere in Blizzard's API surface, verified
    against wow-ui-source's Blizzard_APIDocumentationGenerated. So tier data has
    to be baked in at author time, and this is the thing that bakes it.

    WHY CLASSCODEX AND NOT THE SITES THEMSELVES

    Because the sites are closed to a script and ClassCodex is not:

      Archon.gg     answers a plain GET with 403. It is behind bot protection,
                    and beating that is an arms race with somebody who does not
                    want us there.
      Wowhead       no public API. Its rankings are rendered client side.
      Icy Veins     no public API. Guide pages are prose and HTML.
      u.gg          no public API.
      Bloodmallet   reachable, but publishes no documented endpoint. Guessing at
                    one returned 500 and 404 on 2026-09-02.
      Raidbots      already used, elsewhere in this addon, for the thing it is
                    actually good at: YOUR character. Its Droptimizer CSV is a
                    per-character sim, not a public per-spec ranking, so it
                    cannot answer "what tier is this trinket for Feral".

    ClassCodex already scrapes u.gg and Icy Veins, maintains those parsers, and
    ships the result as plain Lua tables keyed by item id. Reusing its output
    means we inherit that maintenance for free instead of duplicating it. Its
    files are refreshed on disk by CurseForge or Wago whenever the addon
    updates, WHICH HAPPENS WHETHER OR NOT THE ADDON IS ENABLED IN THE GAME. That
    matters here: the addon is deliberately disabled (it taints the action bars,
    see docs/board), and the data keeps arriving anyway.

    The cost of that choice, stated plainly: this is second-hand data. If
    ClassCodex stops shipping, is uninstalled, or changes its table shape, this
    script fails loudly rather than writing a half-empty table. That is the
    intended behaviour, not a limitation to work around.

.PARAMETER ClassCodexPath
    The ClassCodex addon folder. Defaults to the retail AddOns folder.

.PARAMETER WhatIf
    Report what would change and write nothing. Always run this first; the dry
    run is the plan, which is the convention across this workspace.

.EXAMPLE
    .\update-trinket-tiers.ps1 -WhatIf
    .\update-trinket-tiers.ps1
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ClassCodexPath = "C:\Games\World of Warcraft\_retail_\Interface\AddOns\ClassCodex",
    [string]$Target = (Join-Path $PSScriptRoot 'DjinnisBiS.lua')
)

$ErrorActionPreference = 'Stop'

# ClassCodex's spec keys on the left, this addon's on the right. Druid only,
# because this addon is druid only. Adding a class means adding its specs here
# and a matching block in the BIS table, which is a bigger change than this file.
$SPECS = [ordered]@{
    balance     = 'Balance'
    feral       = 'Feral'
    guardian    = 'Guardian'
    restoration = 'Resto'
}

# Source file -> the short key it gets in the generated table.
$SOURCES = [ordered]@{
    'db_ugg.lua'      = 'u'
    'db_icyveins.lua' = 'iv'
}

# S is best. Anything outside this set is dropped rather than coloured: Icy
# Veins has published at least one "F-", which is a joke and not a tier.
$RANK = @{ S = 1; A = 2; B = 3; C = 4; D = 5 }

function Read-TrinketTiers {
    <#  Returns @{ Spec = @{ itemId = @{ src = tier } } } for one source file.

        The files are pretty printed one entry per line, so this reads line by
        line and tracks where it is rather than trying to parse Lua properly.
        The shape it is walking:

            DRUID={
              balance={
                trinkets={
                  all={
                    all={ {bonusIDs={..},itemId=270164,pop=4.1,tier="C"}, ... },
                    pvp={ ... },
    #>
    param([string]$Path, [string]$SrcKey)

    $out = @{}
    $inDruid = $false
    $spec = $null
    $inTrinkets = $false
    $context = $null

    foreach ($line in [System.IO.File]::ReadLines($Path)) {
        if ($line -match '^    ([A-Z]+)=\{') {
            $inDruid = ($Matches[1] -eq 'DRUID')
            continue
        }
        if (-not $inDruid) { continue }

        if ($line -match '^      ([a-z]+)=\{') {
            $spec = $SPECS[$Matches[1]]   # $null for a spec we do not carry
            continue
        }
        if ($line -match '^        trinkets=\{') { $inTrinkets = $true; $context = $null; continue }
        if ($inTrinkets -and $line -match '^        \},') { $inTrinkets = $false; continue }
        if (-not ($inTrinkets -and $spec)) { continue }

        if ($line -match '^            ([a-z]+)=') { $context = $Matches[1] }
        if ($context -eq 'pvp') { continue }   # this addon is about PvE drops

        # bonusIDs carries its own digits and would be read as an item id
        $clean = [regex]::Replace($line, 'bonusIDs=\{[^}]*\},?', '')
        foreach ($m in [regex]::Matches($clean, 'itemId=(\d+)[^}]*?tier="([^"]+)"')) {
            $tier = $m.Groups[2].Value
            if (-not $RANK.ContainsKey($tier)) { continue }
            $id = [int]$m.Groups[1].Value
            if (-not $out.ContainsKey($spec)) { $out[$spec] = @{} }
            if (-not $out[$spec].ContainsKey($id)) { $out[$spec][$id] = @{} }
            $out[$spec][$id][$SrcKey] = $tier
        }
    }
    return $out
}

# --- read both sources -------------------------------------------------------

$dataDir = Join-Path $ClassCodexPath 'Data'
if (-not (Test-Path $dataDir)) {
    throw "ClassCodex Data folder not found at '$dataDir'. Install ClassCodex (it does not need to be ENABLED in the game, only present on disk), or pass -ClassCodexPath."
}

$merged = @{}
foreach ($spec in $SPECS.Values) { $merged[$spec] = @{} }

foreach ($file in $SOURCES.Keys) {
    $path = Join-Path $dataDir $file
    if (-not (Test-Path $path)) { throw "Expected '$path' and it is not there. ClassCodex has changed its layout; this script needs updating rather than working around." }

    $found = Read-TrinketTiers -Path $path -SrcKey $SOURCES[$file]
    $count = 0
    foreach ($spec in $found.Keys) {
        foreach ($id in $found[$spec].Keys) {
            if (-not $merged[$spec].ContainsKey($id)) { $merged[$spec][$id] = @{} }
            foreach ($k in $found[$spec][$id].Keys) { $merged[$spec][$id][$k] = $found[$spec][$id][$k] }
            $count++
        }
    }
    Write-Host ("  read {0,-18} {1,4} rated trinkets" -f $file, $count)
}

# Refuse to write a table that lost a spec. Half a table is worse than an error,
# because it looks like the sites simply stopped rating that spec.
foreach ($spec in $SPECS.Values) {
    if ($merged[$spec].Count -eq 0) {
        throw "No trinket tiers found for $spec. ClassCodex's data shape has probably changed; fix this script rather than shipping a gap."
    }
}

# --- render the Lua block ----------------------------------------------------

function Get-BestRank {
    param([hashtable]$Tiers)
    ($Tiers.Values | ForEach-Object { $RANK[$_] } | Measure-Object -Minimum).Minimum
}

$version = 'unknown version'
$toc = Join-Path $ClassCodexPath 'ClassCodex.toc'
if (Test-Path $toc) {
    $m = Select-String -Path $toc -Pattern '^## Version:\s*(.+)$' | Select-Object -First 1
    if ($m) { $version = "ClassCodex $($m.Matches[0].Groups[1].Value.Trim())" }
}

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('-- BEGIN GENERATED TRINKET TIERS')
$lines.Add(('local TRINKET_TIER_SOURCE = "{0}, read {1}"' -f $version, (Get-Date -Format 'yyyy-MM-dd')))
$lines.Add('local TRINKET_TIER = {')

$total = 0
foreach ($spec in $SPECS.Values) {
    $lines.Add("`t$spec = {")
    # best tier first, then by id so the file is stable between runs and a diff
    # shows a real change rather than a reshuffle
    $ordered = $merged[$spec].GetEnumerator() | Sort-Object @{E = { Get-BestRank $_.Value } }, @{E = { $_.Key } }
    foreach ($entry in $ordered) {
        $parts = @()
        foreach ($k in $SOURCES.Values) {
            if ($entry.Value.ContainsKey($k)) { $parts += ('{0} = "{1}"' -f $k, $entry.Value[$k]) }
        }
        $lines.Add(("`t`t[{0}] = {{ {1} }}," -f $entry.Key, ($parts -join ', ')))
        $total++
    }
    $lines.Add("`t},")
    Write-Host ("  {0,-9} {1,3} trinkets" -f $spec, $merged[$spec].Count)
}
$lines.Add('}')
$lines.Add('-- END GENERATED TRINKET TIERS')

$block = $lines -join "`n"

# --- splice it in ------------------------------------------------------------

if (-not (Test-Path $Target)) { throw "Target '$Target' not found." }
$lua = [System.IO.File]::ReadAllText($Target)

$pattern = '(?s)-- BEGIN GENERATED TRINKET TIERS.*?-- END GENERATED TRINKET TIERS'
if ($lua -notmatch $pattern) {
    throw "Could not find the BEGIN/END GENERATED TRINKET TIERS markers in '$Target'. They are what makes this script safe to re-run; put them back rather than removing this check."
}

$old = [regex]::Match($lua, $pattern).Value
if ($old -eq $block) {
    Write-Host "`nAlready current: $total trinkets, nothing to write." -ForegroundColor Green
    return
}

# A plain -replace would eat $1 and friends in the replacement text
$updated = [regex]::Replace($lua, $pattern, { $block }, 1)

$oldIds = ([regex]::Matches($old, '^\s*\[(\d+)\]', 'Multiline') | ForEach-Object { $_.Groups[1].Value })
$newIds = ([regex]::Matches($block, '^\s*\[(\d+)\]', 'Multiline') | ForEach-Object { $_.Groups[1].Value })
Write-Host ("`n  rows: {0} -> {1}" -f $oldIds.Count, $newIds.Count)

if ($PSCmdlet.ShouldProcess($Target, 'rewrite the generated trinket tier block')) {
    [System.IO.File]::WriteAllText($Target, $updated)
    Write-Host "Wrote $total trinkets to $Target" -ForegroundColor Green
    Write-Host "Next: run the in-game self-test (/bis test) and deploy." -ForegroundColor Yellow
}
else {
    Write-Host "DRY RUN - nothing written." -ForegroundColor Yellow
}
