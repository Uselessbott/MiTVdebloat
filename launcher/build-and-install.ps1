    }

    Write-Host "`n[5/7] Installing launcher and testing it..." -ForegroundColor Yellow

    & $Adb -s $serial install -r $Apk | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw 'APK installation failed. Stock launcher was not disabled.'
    }

    $startOutput = & $Adb -s $serial shell am start -W -n $LauncherActivity 2>&1 |
        Out-String

    Write-Host $startOutput.Trim()

    if ($startOutput -notmatch 'Status:\s+ok' -or
        $startOutput -match '(?im)^Error:') {
        throw 'CleanYourTV launcher installed but did not start successfully. Stock launcher was left enabled.'
    }

    Write-Host "`n[6/7] Switching Home to CleanYourTV..." -ForegroundColor Yellow

    & $Adb -s $serial shell cmd package compile -m speed -f $LauncherPackage |
        Out-Host

    & $Adb -s $serial shell cmd package set-home-activity --user 0 $LauncherActivity |
        Out-Host

    if ($stockLauncher -ne 'none') {
        & $Adb -s $serial shell pm disable-user --user 0 $stockLauncher |
            Out-Host

        if ($LASTEXITCODE -ne 0) {
            throw "Failed to disable stock launcher $stockLauncher"
        }
    }

    if ($InputKeyService) {
        & $Adb -s $serial shell settings put secure enabled_accessibility_services `
            'com.gathin.tvhome/.InputKeyService' | Out-Null
        & $Adb -s $serial shell settings put secure accessibility_enabled 1 |
            Out-Null
    }

    if ($HomeKeyService) {
        $existing = Adb-Text @(
            '-s', $serial, 'shell',
            'settings', 'get', 'secure',
            'enabled_accessibility_services'
        )

        $svc = 'com.gathin.tvhome/.HomeKeyService'

        if ($existing -and $existing -ne 'null') {
            $svc = "$existing`:$svc"
        }

        & $Adb -s $serial shell settings put secure `
            enabled_accessibility_services $svc | Out-Null
        & $Adb -s $serial shell settings put secure `
            accessibility_enabled 1 | Out-Null
    }

    Start-Sleep -Seconds 1

    Write-Host "`n[7/7] Verifying Home..." -ForegroundColor Yellow

    $finalHome = Adb-Text @(
        '-s', $serial, 'shell',
        'cmd', 'package', 'resolve-activity', '--brief',
        '-a', 'android.intent.action.MAIN',
        '-c', 'android.intent.category.HOME'
    )

    $finalComponent = ($finalHome -split "`r?`n" |
        Where-Object { $_ -match '/' } |
        Select-Object -Last 1).Trim()

    if ($finalComponent -notlike "$LauncherPackage/*") {
        Write-Host "Home ended at: $finalComponent" -ForegroundColor Red

        if ($stockLauncher -ne 'none') {
            Write-Host 'Rolling back stock launcher...' -ForegroundColor Yellow
            & $Adb -s $serial shell pm enable --user 0 $stockLauncher |
                Out-Null
            & $Adb -s $serial shell cmd package set-home-activity `
                --user 0 $stockLauncher | Out-Null
        }

        throw 'Home verification failed. The stock launcher was restored when possible.'
    }

    Write-Host "`nSUCCESS: CleanYourTV is installed and owns Home." -ForegroundColor Green
    Write-Host 'Press the Home button on the TV remote.' -ForegroundColor Green
}
catch {
    Write-Host "`nFAILED: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    Pop-Location -ErrorAction SilentlyContinue

    if ($KeepSource) {
        Write-Host "Source kept at: $Source" -ForegroundColor DarkGray
    }
    else {
        Remove-Item -LiteralPath $Work -Recurse -Force -ErrorAction SilentlyContinue
    }
}
