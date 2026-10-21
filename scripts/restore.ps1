param([switch]$Apply, [switch]$ListOnly)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$removed = Get-Content (Join-Path $repo 'packages\removed-user0.txt') | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith('#') }
$disabled = Get-Content (Join-Path $repo 'packages\disabled-user0.txt') | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith('#') }
if ($ListOnly -or -not $Apply) {
    Write-Host 'Restore plan (no changes made):'
    $removed | ForEach-Object { Write-Host "adb shell cmd package install-existing --user 0 $_" }
    $disabled | ForEach-Object { Write-Host "adb shell pm enable $_" }
    if (-not $ListOnly) { Write-Host 'Apply only after review: .\scripts\restore.ps1 -Apply' }
    return
}
$devices = & adb devices
if (-not (($devices | Select-String '\sdevice$') -and ($devices.Count -gt 1))) { throw 'No ADB device in state "device".' }
$confirm = Read-Host 'Attempt package restoration and launcher re-enable. Type RESTORE to continue'
if ($confirm -cne 'RESTORE') { Write-Host 'Cancelled.'; return }
$log = Join-Path $repo ('restore-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.log')
foreach ($package in $removed) {
    $result = & adb shell cmd package install-existing --user 0 $package 2>&1
    Add-Content -Encoding utf8 -Path $log -Value "[install-existing $package] $($result -join ' ')"
    Write-Host "$package : $result"
}
foreach ($package in $disabled) {
    $result = & adb shell pm enable $package 2>&1
    Add-Content -Encoding utf8 -Path $log -Value "[enable $package] $($result -join ' ')"
    Write-Host "$package : $result"
}
Write-Host "Log written to $log"
Write-Host 'Note: this may not restore third-party APKs or apps removed from the system image. Verify manually.'
