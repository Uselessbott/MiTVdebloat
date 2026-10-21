# Session notes

## Device and usage

- Model reported by ADB: `MiTV-AXSO0`
- Platform: Android TV 9
- Main use: Live TV, Play Store and TizenTube
- ADB host session used Windows PowerShell with Android Platform Tools
- CleanYourTV package: `com.gathin.tvhome`
- CleanYourTV main activity: `com.gathin.tvhome/.MainActivity`

## Launcher validation recorded during the session

The user manually tested D-pad/remote navigation, Home, Back, Live TV, TizenTube, Play Store, Settings and persistence after reboot. The stock launcher `com.google.android.tvlauncher` and unused `com.google.android.leanbacklauncher` were disabled for user 0 after the new launcher was working.

## Critical components deliberately kept

- `com.droidlogic.tvinput`: HDMI, AV, digital/analog TV input services.
- `com.droidlogic.droidlivetv`: DroidLogic Live TV app / EPG.
- `com.droidlogic.tv.settings`: vendor TV display/sound settings and control provider.
- `com.droidlogic.tv.soundeffectsettings`: sound mode component.
- `com.xiaomi.android.TV.audio`: Xiaomi audio component; kept due broad privileges.
- `com.google.android.tv.remote.service`: remote/gamepad/search and CEC-related integration.
- `com.android.tv`: tuner, channels and TV functions.
- `com.android.tv.settings`: Android TV settings.
- `com.google.android.tungsten.setupwraith`: setup, accounts, device reset and remote pairing.
- `mitv.service`: TV server and settings service.
- `com.droidlogic`: vendor system resource/service package, system UID.
- `com.android.bluetooth` and `com.droidlogic.ble`: Bluetooth / BLE remote.
- `com.android.systemui`, Play Store, Google Play services, GSF, package installer and core providers.

## Audited packages left intact

`com.xiaomi.android.tvsetup.partnercustomizer` was audited and kept. It is persistent, privileged, shares system UID 1000, registers setup hooks, network/global-button/boot receivers and exports TV launcher partner-configuration provider authorities (`tvlauncher.apprecs`, `tvlauncher.config`, `tvlauncher.widget`, `tvlauncher.image`). Its broad permissions make blind removal risky.

`com.google.android.backuptransport`, `com.google.android.ext.services`, `com.google.android.ext.shared`, `com.android.defcontainer`, `com.android.certinstaller`, `com.android.keychain`, `com.android.se`, `com.android.location.fused`, `com.android.captiveportallogin`, `com.droidlogic.overlay`, `com.xiaomi.mitv.res` and `com.google.android.tv.frameworkpackagestubs` were all classified KEEP.

`com.android.pacprocessor` was removed for user 0 after inspection; HOME stayed on the stock launcher at that point. `com.mitv.tvhome.atv` was removed and HDMI/Live TV input mappings remained present in checks.

## Power/wake

After the user reported a blank screen when entering sleep and remote wake concern, inspection showed Bluetooth, `BleRemoteService`, `DroidLogicPowerService`, `RemoteService` and `mitv.service/.TvServer` running. The user later reported that everything seemed to work normally. No remote/power packages were removed.

## Local backup

The original device-side audit/backup folder was `C:\TV-Debloat-Backup`. It is not bundled in this repository; use the local copy to confirm exact installed/disabled state before attempting any restore.
