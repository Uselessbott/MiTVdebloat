param(
    [string]$OutputRoot = (Join-Path $env:USERPROFILE 'TV-Debloat-Backup')
)
$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$out = Join-Path $OutputRoot $stamp
New-Item -ItemType Directory -Force -Path $out | Out-Null

function Save-Adb([string]$Name, [string[]]$Args) {
    & adb @Args 2>&1 | Out-File -Encoding utf8 (Join-Path $out $Name)
    if ($LASTEXITCODE -ne 0) { Write-Warning "adb returned exit code $LASTEXITCODE for $Name" }
}

$deviceList = & adb devices
$deviceList | Out-File -Encoding utf8 (Join-Path $out 'adb-devices.txt')
if (-not (($deviceList | Select-String '\sdevice$') -and ($deviceList.Count -gt 1))) {
    throw 'No ADB device in state "device". Connect the TV and retry.'
}
Save-Adb 'packages-all.txt' @('shell','pm','list','packages','-f')
Save-Adb 'packages-third-party.txt' @('shell','pm','list','packages','-3')
Save-Adb 'packages-disabled.txt' @('shell','pm','list','packages','-d')
Save-Adb 'packages-user0.txt' @('shell','pm','list','packages','--user','0')
Save-Adb 'getprop.txt' @('shell','getprop')
Save-Adb 'settings-global.txt' @('shell','settings','list','global')
Save-Adb 'settings-secure.txt' @('shell','settings','list','secure')
Save-Adb 'settings-system.txt' @('shell','settings','list','system')
Save-Adb 'home-activities.txt' @('shell','cmd','package','query-activities','-a','android.intent.action.MAIN','-c','android.intent.category.HOME')
Save-Adb 'top-activity.txt' @('shell','dumpsys','activity','activities')
Write-Host "Backup reports saved to: $out"
Write-Host 'This is a diagnostic backup, not a complete firmware/system image.'
