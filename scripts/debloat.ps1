param([switch]$Apply)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$listPath = Join-Path $repo 'packages\removed-user0.txt'
$keepPath = Join-Path $repo 'packages\keep-protected.txt'
$packages = Get-Content $listPath | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith('#') }
$protected = Get-Content $keepPath | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith('#') }
$blocked = @($packages | Where-Object { $protected -contains $_ })
if ($blocked.Count) { throw "Safety check failed; protected package(s) in removal list: $($blocked -join ', ')" }

$devices = & adb devices
if (-not (($devices | Select-String '\sdevice$') -and ($devices.Count -gt 1))) { throw 'No ADB device in state "device".' }

Write-Host "Package count: $($packages.Count)"
if (-not $Apply) {
    Write-Host 'DRY RUN only. No packages changed. To apply after reviewing: .\scripts\debloat.ps1 -Apply'
    $packages | ForEach-Object { Write-Host "Would run: adb shell pm uninstall --user 0 $_" }
    return
}

$confirm = Read-Host 'This applies user-0 uninstalls from this device-specific list. Type APPLY to continue'
if ($confirm -cne 'APPLY') { Write-Host 'Cancelled.'; return }
$log = Join-Path $repo ('debloat-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.log')
foreach ($package in $packages) {
    Write-Host "Removing for user 0: $package"
    $result = & adb shell pm uninstall --user 0 $package 2>&1
    $line = "[$package] $($result -join ' ')"
    Add-Content -Encoding utf8 -Path $log -Value $line
    Write-Host $result
}
Write-Host "Log written to $log"
Write-Host 'Test HOME, Live TV, HDMI, Settings, Play Store, TizenTube, remote and sleep/wake before proceeding.'
