$ErrorActionPreference = 'Stop'
$devices = & adb devices
$devices
if (-not (($devices | Select-String '\sdevice$') -and ($devices.Count -gt 1))) { throw 'No ADB device in state "device".' }
Write-Host "`n-- Key packages (installed for user 0) --"
& adb shell pm list packages --user 0 | Select-String 'com\.gathin\.tvhome|com\.google\.android\.tvlauncher|com\.google\.android\.leanbacklauncher|com\.android\.bluetooth|com\.google\.android\.tv\.remote\.service|com\.droidlogic\.tvinput|com\.droidlogic\.droidlivetv|com\.android\.tv\.settings|com\.android\.vending|com\.google\.android\.gms|mitv\.service'
Write-Host "`n-- Disabled packages --"
& adb shell pm list packages -d
Write-Host "`n-- HOME activities --"
& adb shell cmd package query-activities -a android.intent.action.MAIN -c android.intent.category.HOME
Write-Host "`n-- Top activity --"
& adb shell dumpsys activity activities | Select-String 'topResumedActivity|mResumedActivity'
Write-Host "`n-- Power state --"
& adb shell dumpsys power | Select-String 'mWakefulness|mWakefulnessChanging|mPoweredWirelessly'
