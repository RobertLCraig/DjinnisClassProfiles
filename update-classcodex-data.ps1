<#
.SYNOPSIS
    Refresh the generated tables in DjinnisClassProfiles.lua from ClassCodex's data files.

.DESCRIPTION
    An addon-author tool, not a runtime one. A WoW addon cannot make a network
    request: there is no HTTP call anywhere in Blizzard's API surface, verified
    against wow-ui-source's Blizzard_APIDocumentationGenerated. So this data has
    to be baked in at author time, and this is the thing that bakes it.

    It writes TWO blocks, each between its own BEGIN/END markers:

      TRINKET TIERS   S/A/B/C letters per trinket, per spec, from u.gg and
                      Icy Veins. Keyed by item id.
      STAT TARGETS    the secondary-stat ratings the top 20% of each spec
                      actually run, per hero talent, for raid and Mythic+.
                      From u.gg only, because Icy Veins publishes no numbers.

    Both come out of the same files and the same walk, so they are one script
    and one command rather than two that can disagree about which ClassCodex
    version they read.

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

    THIS SCRIPT READS DISK. IT DOES NOT FETCH.

    So it is only as current as the ClassCodex folder is. CurseForge or Wago
    refresh that folder on their own schedule; to force it, run

        python C:\Dev\WoWAddons\WoWClassCodexDownloader\download_classcodex.py

    first. That tool pulls ClassCodex straight from its own CDN and writes the
    Data files this script then reads, so the full refresh is those two commands
    in that order. Set DRY_RUN = True at the top of it to see what it would do.

.PARAMETER ClassCodexPath
    The ClassCodex addon folder. Defaults to the retail AddOns folder.

.PARAMETER WhatIf
    Report what would change and write nothing. Always run this first; the dry
    run is the plan, which is the convention across this workspace.

.EXAMPLE
    .\update-classcodex-data.ps1 -WhatIf
    .\update-classcodex-data.ps1
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ClassCodexPath = "C:\Games\World of Warcraft\_retail_\Interface\AddOns\ClassCodex",
    [string]$Target = (Join-Path $PSScriptRoot 'DjinnisClassProfiles.lua')
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

function Read-StatTargets {
    <#  Returns @{ Spec = @{ heroSlug = @{ context = @{ stat = rating } } } }.

        Same file, same line-by-line walk, a different branch of it:

            DRUID={
              feral={
                statTargets={
                  all={
                    mplus={
                      top20={crit=850,haste=1265,mastery=1161,versatility=445},
                      top50={...},
                    },
                    raid={ ... },
                    pvp={ ... },
                  },
                  ["druid-of-the-claw"]={ ... },

        Only top20 is taken. The bins are what the top 20%, 50% and 80% of
        logged players run, and this addon is answering "what should I be
        aiming at", which is the first one. Carrying all three would mean a
        selector on the panel for a distinction nobody asked for.

        pvp is dropped, as it is everywhere else in this addon.
    #>
    param([string]$Path)

    $out = @{}
    $inDruid = $false
    $spec = $null
    $inTargets = $false
    $hero = $null
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
        if ($line -match '^        statTargets=\{') { $inTargets = $true; $hero = $null; continue }
        if ($inTargets -and $line -match '^        \},') { $inTargets = $false; continue }
        if (-not ($inTargets -and $spec)) { continue }

        # hero keys are bare when they are plain words and bracketed when they
        # carry a hyphen, so both spellings have to be read
        if ($line -match '^          (?:\["([a-z0-9-]+)"\]|([a-z0-9-]+))=\{') {
            $hero = if ($Matches[1]) { $Matches[1] } else { $Matches[2] }
            $context = $null
            continue
        }
        if ($line -match '^            ([a-z+]+)=\{') { $context = $Matches[1]; continue }
        if (-not $hero -or -not $context -or $context -eq 'pvp') { continue }

        if ($line -match '^              top20=\{(.+?)\},?\s*$') {
            $stats = @{}
            foreach ($m in [regex]::Matches($Matches[1], '([a-z]+)=(\d+)')) {
                $stats[$m.Groups[1].Value] = [int]$m.Groups[2].Value
            }
            if ($stats.Count -eq 0) { continue }
            if (-not $out.ContainsKey($spec))               { $out[$spec] = @{} }
            if (-not $out[$spec].ContainsKey($hero))        { $out[$spec][$hero] = @{} }
            $out[$spec][$hero][$context] = $stats
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

# Stat targets come from u.gg alone: Icy Veins publishes guide prose about which
# stat to favour and no ratings to aim at, so there is nothing there to read.
$uggPath = Join-Path $dataDir 'db_ugg.lua'
$targets = Read-StatTargets -Path $uggPath
foreach ($spec in $SPECS.Values) {
    if (-not $targets.ContainsKey($spec) -or -not $targets[$spec].ContainsKey('all')) {
        throw "No 'all' stat targets found for $spec in db_ugg.lua. ClassCodex's data shape has probably changed; fix this script rather than shipping a gap."
    }
    Write-Host ("  {0,-9} {1} hero set(s) of stat targets" -f $spec, $targets[$spec].Count)
}

# --- render the Lua blocks ---------------------------------------------------

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

$trinketBlock = $lines -join "`n"

# Stat targets. `all` first because it is the fallback every other key falls
# back to, then the hero slugs alphabetically so a diff shows a real change.
$STAT_ORDER = @('crit', 'haste', 'mastery', 'versatility')
$CONTEXT_ORDER = @('raid', 'mplus')

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('-- BEGIN GENERATED STAT TARGETS')
$lines.Add(('local STAT_TARGET_SOURCE = "{0}, u.gg top 20%, read {1}"' -f $version, (Get-Date -Format 'yyyy-MM-dd')))
$lines.Add('local STAT_TARGET = {')

$targetCount = 0
foreach ($spec in $SPECS.Values) {
    $lines.Add("`t$spec = {")
    $heroes = @('all') + (($targets[$spec].Keys | Where-Object { $_ -ne 'all' }) | Sort-Object)
    foreach ($hero in $heroes) {
        $key = if ($hero -match '^[a-z]+$') { $hero } else { '["{0}"]' -f $hero }
        $lines.Add("`t`t$key = {")
        foreach ($context in $CONTEXT_ORDER) {
            $stats = $targets[$spec][$hero][$context]
            if (-not $stats) { continue }
            $parts = foreach ($stat in $STAT_ORDER) { '{0} = {1}' -f $stat, $stats[$stat] }
            $lines.Add(("`t`t`t{0,-5} = {{ {1} }}," -f $context, ($parts -join ', ')))
            $targetCount++
        }
        $lines.Add("`t`t},")
    }
    $lines.Add("`t},")
}
$lines.Add('}')
$lines.Add('-- END GENERATED STAT TARGETS')

$statBlock = $lines -join "`n"

# --- splice them in ----------------------------------------------------------

if (-not (Test-Path $Target)) { throw "Target '$Target' not found." }
$lua = [System.IO.File]::ReadAllText($Target)

# One helper for both blocks, so a second generated table cannot drift into a
# second, subtly different way of being written.
function Update-Block {
    param([string]$Lua, [string]$Marker, [string]$Block)

    $pattern = "(?s)-- BEGIN GENERATED $Marker.*?-- END GENERATED $Marker"
    if ($Lua -notmatch $pattern) {
        throw "Could not find the BEGIN/END GENERATED $Marker markers in '$Target'. They are what makes this script safe to re-run; put them back rather than removing this check."
    }
    # Compare without the _SOURCE line. It carries today's date, so comparing
    # the whole block would report "changed" every day whatever the data did,
    # and a rewrite that only moves a date stamp is noise in the diff.
    $old = [regex]::Match($Lua, $pattern).Value
    $strip = { param($t) ($t -replace '(?m)^local \w+_SOURCE = .*$', '') }
    if ((& $strip $old) -eq (& $strip $Block)) { return @{ Lua = $Lua; Changed = $false } }

    # A plain -replace would eat $1 and friends in the replacement text
    return @{ Lua = [regex]::Replace($Lua, $pattern, { $Block }, 1); Changed = $true }
}

$r = Update-Block -Lua $lua -Marker 'TRINKET TIERS' -Block $trinketBlock
$lua = $r.Lua
$trinketsChanged = $r.Changed

$r = Update-Block -Lua $lua -Marker 'STAT TARGETS' -Block $statBlock
$lua = $r.Lua
$targetsChanged = $r.Changed

if (-not $trinketsChanged -and -not $targetsChanged) {
    Write-Host "`nAlready current: $total trinkets, $targetCount stat target rows. Nothing to write." -ForegroundColor Green
    return
}

Write-Host ("`n  trinket tiers: {0}" -f $(if ($trinketsChanged) { 'changed' } else { 'unchanged' }))
Write-Host ("  stat targets:  {0}" -f $(if ($targetsChanged) { 'changed' } else { 'unchanged' }))

if ($PSCmdlet.ShouldProcess($Target, 'rewrite the generated trinket tier and stat target blocks')) {
    [System.IO.File]::WriteAllText($Target, $lua)
    Write-Host "Wrote $total trinkets and $targetCount stat target rows to $Target" -ForegroundColor Green
    Write-Host "Next: run the in-game self-test (/bis test) and deploy." -ForegroundColor Yellow
}
else {
    Write-Host "DRY RUN - nothing written." -ForegroundColor Yellow
}
