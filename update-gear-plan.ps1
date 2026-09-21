<#
.SYNOPSIS
    Bake the winning gear of one or more Raidbots Top Gear reports into
    DjinnisBiS.lua, between the GENERATED GEAR PLAN markers.

.DESCRIPTION
    An addon-author tool, not a runtime one, for the same reason
    update-classcodex-data.ps1 is: a WoW addon cannot make a network request, so
    a sim result has to be baked in at author time.

    Each report fills ONE cell of the plan, spec by scenario. The spec is read
    off the report and the scenario off its enemy count: 1 is `st`, 2 is `2t`.
    Cells the given reports do not fill are kept exactly as they are, because a
    Raidbots report expires after 30 days and a cell that could only be rebuilt
    by fetching its report again would quietly vanish a month later.

    WHERE THE WINNING COMBO IS, because it is not where it looks

      data.json   sim.profilesets.results holds the dps of every combo, by name.
                  simbot.input looks like the gear and IS NOT: it is one chunk
                  of the last Smart Sim stage, so on 2026-09-21 it carried
                  Combo 142 and not the winner, Combo 145.
      input.txt   every combo in full, each gear line under a comment giving
                  the item's name and item level. This is what is read. The
                  form data in data.json also lists the gear, but without the
                  gems and enchants Top Gear adds, so it is not used.

    The actor Raidbots calls the base is Combo 1, what was equipped. It has no
    entry in profilesets.results, so it is compared separately and can win.

.PARAMETER Report
    One or more report ids or full report URLs.

.PARAMETER Deploy
    After a write, deploy the addon to the game folder.

.PARAMETER From
    Read <id>.json and <id>.input.txt from this folder instead of fetching.
    What -SelfTest uses, and a way to re-run against a saved report.

.PARAMETER SelfTest
    Run the generator's own checks against fixtures/gear-plan and exit 1 on a
    failure. Writes nothing outside the temp folder.

.PARAMETER WhatIf
    Report what would change and write nothing. Always run this first.

.EXAMPLE
    .\update-gear-plan.ps1 -WhatIf https://www.raidbots.com/simbot/report/ttktB9kVE77x2zkadhVgPn
    .\update-gear-plan.ps1 ttktB9kVE77x2zkadhVgPn -Deploy
    .\update-gear-plan.ps1 -SelfTest
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]]$Report,
    [switch]$Deploy,
    [string]$From,
    [switch]$SelfTest,
    [string]$Target = (Join-Path $PSScriptRoot 'DjinnisBiS.lua')
)

$ErrorActionPreference = 'Stop'

# Raidbots' name on the left, this addon's spec key on the right. Resto, not
# Restoration, because that is the key every other table in the addon uses.
$SPECS = [ordered]@{
    'Balance Druid'     = 'Balance'
    'Feral Druid'       = 'Feral'
    'Guardian Druid'    = 'Guardian'
    'Restoration Druid' = 'Resto'
}
# A plain hashtable on purpose: indexing an [ordered] one with an int is BY POSITION,
# so [1] answered '2t'. The self-test caught it.
$SCENARIOS = @{ 1 = 'st'; 2 = '2t' }
$SCENARIO_ORDER = @('st', '2t')
$SLOTS = @('head', 'neck', 'shoulder', 'back', 'chest', 'wrist', 'hands', 'waist', 'legs', 'feet',
    'finger1', 'finger2', 'trinket1', 'trinket2', 'main_hand', 'off_hand')
# The only parts of a simc gear line the addon reads. Everything else on the
# line (content_tuning, redirected_base_stats) is sim plumbing.
$KEEP = @('id', 'enchant_id', 'gem_id', 'bonus_id')

function Get-ReportId {
    param([string]$Text)
    # a bare id, or any URL with the id as the segment after /report/ or /reports/
    if ($Text -match '^[A-Za-z0-9]{16,}$') { return $Text }
    if ($Text -match '/reports?/([A-Za-z0-9]{16,})') { return $Matches[1] }
    throw "'$Text' is neither a Raidbots report id nor a report URL."
}

function Get-ReportFiles {
    param([string]$Id, [string]$From)
    if ($From) {
        $json = Join-Path $From "$Id.json"
        $inputPath = Join-Path $From "$Id.input.txt"
        if (-not (Test-Path $json)) { throw "Report ${Id}: '$json' not found." }
        return @{
            Data  = Get-Content $json -Raw | ConvertFrom-Json -AsHashtable
            Input = if (Test-Path $inputPath) { Get-Content $inputPath } else { @() }
        }
    }
    $base = "https://www.raidbots.com/reports/$Id"
    try {
        return @{
            Data  = (Invoke-WebRequest "$base/data.json").Content | ConvertFrom-Json -AsHashtable
            Input = (Invoke-WebRequest "$base/input.txt").Content -split "`r?`n"
        }
    }
    catch { throw "Report ${Id}: could not fetch it from Raidbots ($($_.Exception.Message)). Reports expire after 30 days." }
}

function Read-Plan {
    <#  One report in, one plan cell out: @{ Spec; Scenario; Lines }, where
        Lines is the rendered Lua for that cell. Throws, naming the report,
        for anything it cannot place.  #>
    param([string]$Id, [string]$From)

    $r = Get-ReportFiles -Id $Id -From $From
    $data = $r.Data

    if ($data.simbot.simType -ne 'optimize') {
        throw "Report ${Id} is not a Top Gear report (its type is '$($data.simbot.simType)'). Nothing written."
    }
    $player = $data.sim.players[0]
    $spec = $SPECS[[string]$player.specialization]
    if (-not $spec) { throw "Report ${Id}: cannot place spec '$($player.specialization)'. Nothing written." }
    $scenario = $SCENARIOS[[int]$data.simbot.enemyCount]
    if (-not $scenario) { throw "Report ${Id}: $($data.simbot.enemyCount) enemies is neither st (1) nor 2t (2). Nothing written." }

    # the winner, with the base actor in the running as Combo 1
    $winner = 'Combo 1'
    $dps = [double]$player.collected_data.dps.mean
    foreach ($res in $data.sim.profilesets.results) {
        if ([double]$res.mean -gt $dps) { $winner = $res.name; $dps = [double]$res.mean }
    }

    # Walk input.txt to the winner's section. A gear line's name and item level
    # are the comment directly above it.
    $gear = [ordered]@{}
    $talents = $null
    $inSection = $false
    $above = $null
    $prefix = 'profileset."{0}"+=' -f $winner
    foreach ($line in $r.Input) {
        if ($line -match '^### (.+?)\s*$') { $inSection = ($Matches[1] -eq $winner); $above = $null; continue }
        if (-not $inSection) { continue }
        if ($line -match '^# (.+) (\d+)\s*$') { $above = @{ Name = $Matches[1]; Level = [int]$Matches[2] }; continue }
        if ($line.StartsWith($prefix)) { $line = $line.Substring($prefix.Length) }
        if ($line -match '^talents=([A-Za-z0-9+/]+)\s*$') { $talents = $Matches[1] }
        elseif ($line -match '^([a-z_0-9]+)=,(.+)$' -and $SLOTS -contains $Matches[1]) {
            $slot = $Matches[1]
            if (-not $above) { throw "Report ${Id}: $winner $slot has no name and item level comment above it. Raidbots has changed input.txt; fix this script." }
            $parts = foreach ($token in $Matches[2].Trim() -split ',') {
                # only digits and slashes reach the Lua file, whatever the report held
                if ($token -match '^([a-z_]+)=[\d/]+$' -and $KEEP -contains $Matches[1]) { $token }
            }
            if (-not ($parts -match '^id=\d+$')) { throw "Report ${Id}: $winner $slot has no item id." }
            $gear[$slot] = @{ Line = (@($parts) + "ilevel=$($above.Level)") -join ','; Name = $above.Name }
        }
        $above = $null
    }
    if ($gear.Count -lt 10 -or -not $talents) {
        throw "Report ${Id}: found $($gear.Count) gear slots and $(if ($talents) { 'a' } else { 'no' }) talent string for $winner in input.txt. Nothing written."
    }

    # The loadout's own name, and the string the game's import box takes. simc
    # blanks the header of the one it sims, so match on that and keep the raw.
    $loadout = $data.simbot.meta.rawFormData.optimize.talentLoadouts | Where-Object { $_.string -eq $talents } | Select-Object -First 1
    $loadoutName = if ($loadout) { [string]$loadout.name } else { '' }
    if ($loadout -and $loadout.rawString -match '^[A-Za-z0-9+/]+$') { $talents = $loadout.rawString }
    $loadoutName = ($loadoutName -replace '[\\"\r\n]', '').Trim()

    $simmed = [DateTimeOffset]::FromUnixTimeMilliseconds([long]$data.simbot.date).ToString('yyyy-MM-dd')
    $pad = ($SLOTS | Measure-Object Length -Maximum).Maximum

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add("`t`t[`"$scenario`"] = {")
    $lines.Add(("`t`t`treport = `"{0}`", simmed = `"{1}`", dps = {2}," -f $Id, $simmed, [int][Math]::Round($dps)))
    $lines.Add(("`t`t`tloadout = `"{0}`"," -f $loadoutName))
    $lines.Add(("`t`t`ttalents = `"{0}`"," -f $talents))
    $lines.Add("`t`t`tslots = {")
    foreach ($slot in $SLOTS) {
        if (-not $gear.Contains($slot)) { continue }
        $name = $gear[$slot].Name -replace '[\r\n]', ' '
        $lines.Add(("`t`t`t`t{0} = `"{1}`", -- {2}" -f $slot.PadRight($pad), $gear[$slot].Line, $name))
    }
    $lines.Add("`t`t`t},")
    $lines.Add("`t`t},")

    return @{ Spec = $spec; Scenario = $scenario; Lines = $lines; Winner = $winner; Dps = $dps }
}

function Read-ExistingCells {
    <#  The cells already in the block, as text, keyed "Spec/scenario". The
        block is this script's own output, so its indentation is the grammar.  #>
    param([string]$Block)
    $cells = @{}
    $spec = $null; $key = $null
    foreach ($line in $Block -split "`r?`n") {
        if ($line -match '^\t(\w+) = \{$') { $spec = $Matches[1]; continue }
        if ($line -match '^\t\t\["(\w+)"\] = \{$') { $key = "$spec/$($Matches[1])"; $cells[$key] = [System.Collections.Generic.List[string]]::new() }
        if ($key) { $cells[$key].Add($line) }
        if ($line -eq "`t`t},") { $key = $null }
    }
    return $cells
}

function Update-GearPlan {
    param([string[]]$Report, [string]$Target, [string]$From, [switch]$DryRun)

    if (-not (Test-Path $Target)) { throw "Target '$Target' not found." }
    $lua = [System.IO.File]::ReadAllText($Target)
    $pattern = '(?s)-- BEGIN GENERATED GEAR PLAN.*?-- END GENERATED GEAR PLAN'
    if ($lua -notmatch $pattern) {
        throw "Could not find the BEGIN/END GENERATED GEAR PLAN markers in '$Target'. They are what makes this script safe to re-run; put them back rather than removing this check."
    }
    $old = [regex]::Match($lua, $pattern).Value
    $cells = Read-ExistingCells -Block $old

    # every report is read before anything is written, so one bad report in a
    # list of four writes none of them
    $changes = @()
    foreach ($text in $Report) {
        $id = Get-ReportId $text
        $plan = Read-Plan -Id $id -From $From
        $key = "$($plan.Spec)/$($plan.Scenario)"
        Write-Host ("  {0}  fills {1,-8} {2,-3} with {3} at {4:n0} dps" -f $id, $plan.Spec, $plan.Scenario, $plan.Winner, $plan.Dps)

        $before = @{}
        if ($cells.ContainsKey($key)) { foreach ($l in $cells[$key]) { if ($l -match '^\t{4}(\w+)\s+= (.+)$') { $before[$Matches[1]] = $Matches[2] } } }
        foreach ($l in $plan.Lines) {
            if ($l -match '^\t{4}(\w+)\s+= (.+)$' -and $before[$Matches[1]] -ne $Matches[2]) {
                $changes += "    {0,-8} {1,-3} {2,-10} {3}" -f $plan.Spec, $plan.Scenario, $Matches[1], ($Matches[2] -replace '^.*-- ', '')
            }
        }
        $cells[$key] = $plan.Lines
    }

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('-- BEGIN GENERATED GEAR PLAN')
    $lines.Add(('local GEAR_PLAN_SOURCE = "Raidbots Top Gear, written {0}"' -f (Get-Date -Format 'yyyy-MM-dd')))
    $lines.Add('local GEAR_PLAN = {')
    foreach ($spec in $SPECS.Values) {
        $mine = $SCENARIO_ORDER | Where-Object { $cells.ContainsKey("$spec/$_") }
        if (-not $mine) { continue }
        $lines.Add("`t$spec = {")
        foreach ($scenario in $mine) { $lines.AddRange($cells["$spec/$scenario"]) }
        $lines.Add("`t},")
    }
    $lines.Add('}')
    $lines.Add('-- END GENERATED GEAR PLAN')
    $block = $lines -join "`n"

    # Compare without the _SOURCE line, which carries today's date
    $strip = { param($t) ($t -replace "`r", '' -replace '(?m)^local \w+_SOURCE = .*$', '') }
    if ((& $strip $old) -eq (& $strip $block)) {
        Write-Host "`nAlready current. Nothing to write." -ForegroundColor Green
        return $false
    }

    Write-Host "`n  slots that change:"
    $changes | ForEach-Object { Write-Host $_ }

    if ($DryRun) { Write-Host 'DRY RUN - nothing written.' -ForegroundColor Yellow; return $false }
    # the instance overload: on the static one a trailing 1 is RegexOptions.IgnoreCase, not a count
    [System.IO.File]::WriteAllText($Target, ([regex]$pattern).Replace($lua, { $block }, 1))
    Write-Host "Wrote the gear plan to $Target" -ForegroundColor Green
    return $true
}

# --- self-test ---------------------------------------------------------------

if ($SelfTest) {
    $fx = Join-Path $PSScriptRoot 'fixtures\gear-plan'
    $topGear = 'ttktB9kVE77x2zkadhVgPn'   # Feral, 1 enemy, Combo 145 wins
    $advanced = '1KNa9hARUZEscjxJ6LvjST'  # an Advanced sim, which must be refused
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) "gear-plan-selftest-$PID.lua"
    $empty = "local x = 1`n-- BEGIN GENERATED GEAR PLAN`n-- END GENERATED GEAR PLAN`nreturn x`n"
    $failed = 0
    function Test-That([string]$Name, [bool]$Ok) {
        if ($Ok) { Write-Host "  ok    $Name" } else { $script:failed++; Write-Host "  FAIL  $Name" -ForegroundColor Red }
    }
    try {
        [System.IO.File]::WriteAllText($tmp, $empty)
        $wrote = Update-GearPlan -Report $topGear -Target $tmp -From $fx 6>$null
        $lua = [System.IO.File]::ReadAllText($tmp)
        Test-That 'gear plan block holds a slot table per spec and scenario' (
            $wrote -and $lua -match '(?s)\tFeral = \{\n\t\t\["st"\] = \{.*?slots = \{' -and
            # the winner's chest, with its enchant and the level from the comment above it
            $lua -match 'chest\s+= "id=268235,enchant_id=7987,bonus_id=41/13662/13334/12846,ilevel=321"' -and
            # a gem Top Gear added, which the form data does not carry
            $lua -match 'wrist\s+= "id=251135,bonus_id=[\d/]+,gem_id=240908,ilevel=318"' -and
            # sim plumbing on the winner's neck line, which $KEEP must drop
            $lua -notmatch 'content_tuning' -and
            $lua -notmatch 'off_hand\s+=' -and $lua -match 'loadout = "DotC Raid ST \*"' -and
            $lua.StartsWith('local x = 1') -and $lua.TrimEnd().EndsWith('return x'))

        # an older date stamp, or a same-day re-run proves nothing about the date being ignored
        $lua = $lua -replace 'written \d{4}-\d{2}-\d{2}', 'written 2000-01-01'
        [System.IO.File]::WriteAllText($tmp, $lua)
        $wrote = Update-GearPlan -Report $topGear -Target $tmp -From $fx 6>$null
        Test-That 'generator is idempotent' ((-not $wrote) -and [System.IO.File]::ReadAllText($tmp) -eq $lua)

        Test-That 'generator accepts a report url or a bare id' (
            (Get-ReportId $topGear) -eq $topGear -and
            (Get-ReportId "https://www.raidbots.com/simbot/report/$topGear") -eq $topGear -and
            (Get-ReportId "https://www.raidbots.com/reports/$topGear/data.json") -eq $topGear)

        [System.IO.File]::WriteAllText($tmp, $empty)
        $message = ''
        # the good report first, so this also proves a bad one stops the whole run
        try { Update-GearPlan -Report $topGear, $advanced -Target $tmp -From $fx 6>$null | Out-Null } catch { $message = "$_" }
        Test-That 'generator refuses a report it cannot place' (
            $message -match $advanced -and $message -match 'not a Top Gear' -and
            [System.IO.File]::ReadAllText($tmp) -eq $empty)
    }
    finally { Remove-Item $tmp -ErrorAction SilentlyContinue }

    Write-Host $(if ($failed) { "update-gear-plan: $failed FAIL" } else { 'update-gear-plan: self-test passed' })
    exit $(if ($failed) { 1 } else { 0 })
}

# --- main --------------------------------------------------------------------

if (-not $Report) { throw 'Give at least one Raidbots Top Gear report id or URL. See Get-Help .\update-gear-plan.ps1 -Examples.' }

$wrote = Update-GearPlan -Report $Report -Target $Target -From $From -DryRun:(-not $PSCmdlet.ShouldProcess($Target, 'rewrite the generated gear plan block'))

if ($wrote) {
    Write-Host 'Checking the addon still loads and passes its own tests...'
    & lua (Join-Path $PSScriptRoot 'offline-check.lua') | Select-Object -Last 2
    if ($LASTEXITCODE -ne 0) { throw 'offline-check.lua failed after the write. Not deploying. Look at the FAIL lines above.' }
}
if ($Deploy) {
    # deploys whether or not this run wrote, so "-Deploy" after a plain run works
    & (Join-Path $PSScriptRoot '..\bin\deploy.ps1') -Only DjinnisBiS
}
elseif ($wrote) {
    Write-Host 'Next: run this again with -Deploy, or C:\Dev\WoWAddons\bin\deploy.ps1 -Only DjinnisBiS' -ForegroundColor Yellow
}
