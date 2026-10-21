# Mi TV Debloat

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/2/29/Xiaomi_logo.svg"
       alt="Xiaomi Mi TV Debloat"
       width="180">
</p>

<p align="center">
  <a href="https://cleanyour.tv">cleanyour.tv</a> ·
  <a href="https://github.com/Gathin23/cleanyourtv/tree/main/launcher">The launcher</a> ·
  <a href="https://github.com/Uselessbott/MiTVdebloat">This repo</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/tv-MiTV--AXSO0-cfffcf?style=flat&labelColor=15181e" alt="Tested TV">
  <img src="https://img.shields.io/badge/os-Android%20TV%209-cfffcf?style=flat&labelColor=15181e" alt="Android TV 9">
  <img src="https://img.shields.io/badge/licence-MIT-cfffcf?style=flat&labelColor=15181e" alt="MIT">
</p>

Strip bloatware from your Xiaomi TV over Wi-Fi and replace the ad-filled home screen with a clean launcher inspired by Apple TV. **No root, no cable, nothing physically deleted, and a restore script if you change your mind.**

<h3 align="center">1 tested TV &nbsp;·&nbsp; 1 model &nbsp;·&nbsp; 44 packages &nbsp;·&nbsp; ~370 KB launcher</h3>

> **Tested device:** Xiaomi TV `MiTV-AXSO0` (Mi TV 4C Pro 2019 / 4A Pro) running Android TV 9.
>
> This repository documents one personal TV configuration. Package availability, dependencies, and behavior vary by model, firmware, region, and software version. **Do not assume every package listed here exists on your TV or is safe to remove.**

---

## Start Here: How to Use This Project

This guide is written for Windows users who want to debloat a compatible Android TV and optionally install CleanYourTV. Go slowly and review each preview before applying it.

### Before you begin

- A Windows computer connected to the same Wi-Fi network as your TV.
- The TV and computer on the same local network.
- Android SDK Platform-Tools (ADB): [download from Google](https://developer.android.com/tools/releases/platform-tools).
- Git for Windows, or another way to download this repository.
- A few minutes with the TV remote.
- Enough time to read the package list and keep a backup.

**Important:** This is not a one-click universal debloater. The example package list was tested on one Xiaomi model only. Removing the wrong package can break Settings, HDMI/AV input, Live TV, audio, setup, updates, or the home screen. Do not proceed if you cannot reconnect to the TV through ADB.

### Step 1 — Enable debugging on the TV

1. Open **Settings → Device Preferences → About** (the wording varies by TV).
2. Find **Build** and press OK on it seven times to enable Developer options.
3. Return to the previous menu and open **Developer options**.
4. Enable **USB debugging** and, if available, **Network debugging / ADB debugging**.
5. Leave the TV switched on. When your computer connects, accept the authorization prompt shown on the TV.

Do not share your TV's network address or accept an ADB authorization prompt from a computer you do not trust.

### Step 2 — Prepare the Windows computer

Install [Android SDK Platform-Tools](https://developer.android.com/tools/releases/platform-tools), then extract the ZIP. Open that extracted `platform-tools` folder in File Explorer, click the address bar, type `cmd`, and press Enter. This opens Command Prompt in the correct directory.

Download this repository using **Code → Download ZIP** on GitHub and extract it. Alternatively, if Git is installed, run:

```powershell
git clone https://github.com/Uselessbott/MiTVdebloat.git
```

If you used Git, open the cloned `MiTVdebloat` folder in a separate terminal. Keep the Platform-Tools folder available too, or add it to your PATH so that the `adb` command works from the repository directory.

### Step 3 — Find the TV's IP address

On the TV, open **Settings → Network / Status** and note its IP address. The menu varies by model. Your TV's address may look like `192.168.1.50`; use the actual address shown by your TV.

In Command Prompt, check that ADB is available:

```bat
adb version
```

If Windows says `adb` is not recognized, run the command from inside the extracted `platform-tools` directory or use the full path to `adb.exe`.

Connect to the TV (replace the example IP):

```bat
adb connect 192.168.1.50:5555
adb devices
```

If your TV uses a different port or provides a pairing workflow, follow the instructions shown by its debugging settings. On newer Android versions, wireless debugging may require pairing rather than a direct port-5555 connection.

The device should appear as `device`, not `unauthorized` or `offline`. If it says `unauthorized`, check the TV for an authorization prompt. Do not continue until ADB is connected correctly.

### Step 4 — Back up the TV's current state

In PowerShell, change to the repository directory and run:

```powershell
.\scripts\backup.ps1
```

Read the output and confirm the backup files were created. **Keep the backup and repository folder.** The backup helps record package and Home state before changes; it is not a complete firmware backup and cannot recover every app's data or every possible failure.

If PowerShell blocks the script, stop and review the script and your Windows execution-policy settings rather than blindly bypassing security controls.

### Step 5 — Preview the debloat list

Run the script without `-Apply` first:

```powershell
.\scripts\debloat.ps1
```

This is the preview stage. Read the proposed actions carefully. Review the package lists in `packages/`, especially:

- `removed-user0.txt` — packages proposed for removal for Android user 0.
- `disabled-user0.txt` — packages proposed to be disabled for user 0.
- `keep-protected.txt` — packages intended to be protected.

Package names and dependencies can differ across TVs. Remove anything you do not understand from your planned changes, and do not use this tested-device list unchanged on another model. Keep core TV input, settings, Bluetooth/remote, setup, media, Play Services, and other required system components unless you have verified their role on your specific TV.

### Step 6 — Apply only changes you understand

When you have reviewed the proposed actions and saved the backup, apply the changes:

```powershell
.\scripts\debloat.ps1 -Apply
```

Read the output for errors. Apply changes in small batches where practical, and verify that your TV still boots and that remote control, Settings, Wi-Fi, sound, HDMI/AV, Live TV, and the apps you use work as expected.

The Android command `pm uninstall --user 0` removes an app for the primary Android user; it does **not** normally erase the preinstalled APK from the system partition. This is different from flashing firmware or permanently deleting system files, but it can still disable functions that depend on a package.

### Step 7 — Install CleanYourTV (optional)

The debloat scripts and launcher are separate tasks. Debloating does not by itself install a replacement launcher.

The launcher source and documentation are maintained upstream by Gathin: [CleanYourTV launcher](https://github.com/Gathin23/cleanyourtv/tree/main/launcher) · [Project website](https://cleanyour.tv).

Follow the launcher's current build and installation instructions. The repository describes a small native Java Android TV launcher and lists JDK 17 and Android SDK platform 34 for building it. Do not download or run an APK from an untrusted mirror.

After installing it, open CleanYourTV and test app launching, navigation, settings, and input shortcuts with the remote. **Keep the stock launcher enabled until the replacement is installed and confirmed to work.** Only then consider disabling the original launcher, and only using the project's reviewed script.

If Home stops working, see [Recovery](#recovery-and-restoring-your-tv) below.

### Step 8 — Verify, then close ADB

Run:

```powershell
.\scripts\verify.ps1
```

Check both the script output and the TV itself. Verify the functions you actually use rather than relying only on a successful script exit.

When finished, turn off **USB debugging** and **Network/ADB debugging** in the TV's Developer options, and revoke debugging authorizations if that option is available. Reboot the TV if appropriate and confirm you can no longer connect over the debugging port. Network ADB should not be left enabled unnecessarily.

---

## How It Works

Android TVs use Android Debug Bridge (ADB), like Android phones. Once debugging is enabled and your computer is authorized, these scripts:

1. **Back up** the package list, package states, and relevant Home/settings information.
2. **Preview and apply** selected package changes for Android user 0.
3. **Optionally install** a third-party launcher and, only after testing it, disable the stock launcher.
4. **Verify or restore** the changes the scripts know how to manage.

The goal is to reduce unwanted apps, telemetry and sponsored home-screen content. Results depend on the TV's firmware and apps; this project does not guarantee that all ads or network activity will disappear.

---

## What You Get

- **A pitch-black home screen** with CleanYourTV, an Apple TV–inspired launcher by **Gathin**.
- **A dock** for favourite apps.
- **A top shelf** naming the focused app, with an ambient glow based on its artwork.
- **An app grid** that appears as you navigate down.
- **Three frosted buttons:** Inputs (HDMI, AV, Live TV), Wi-Fi or Ethernet, and Settings.
- **A greeting, clock and date** in Outfit, plus a matching clock screensaver.
- **Themes** that change colours, wallpaper, dock and columns without rebuilding.

The intent is to reduce sponsored rows, unwanted content prompts, and optional preloaded apps. Actual behavior depends on the device, firmware, region, app versions, and which packages are retained.

| | |
|---|---|
| ![Top shelf and ambient glow](https://raw.githubusercontent.com/Gathin23/cleanyourtv/main/docs/focus-2-up-netflix.png) | ![Inputs menu](https://raw.githubusercontent.com/Gathin23/cleanyourtv/main/docs/inputs-menu.jpg) |
| *Top shelf and ambient glow* | *Inputs: HDMI with connection state, AV, Live TV* |
| ![The grid with glass highlight](https://raw.githubusercontent.com/Gathin23/cleanyourtv/main/docs/focus-1-fancode.png) | ![Clock screensaver](https://raw.githubusercontent.com/Gathin23/cleanyourtv/main/docs/clock-screensaver.png) |
| *The grid, one glass highlight* | *Clock screensaver, which drifts to reduce static-image burn-in risk* |

---

## Supported TVs

The debloat approach may work on Android TV and Google TV sets, but the package list must be adapted for each device. The launcher may work on many Android TV devices, but compatibility is not guaranteed. Samsung TVs running Tizen and LG TVs running webOS use different platforms and are out of scope. **Fire TV / Fire OS is debloat-only for this project**: Fire OS restrictions mean you should not expect CleanYourTV to replace its Home screen.

This repository has been tested on one model:

| TV | OS |
|---|---|
| Xiaomi MiTV-AXSO0 (Mi TV 4C Pro 2019 / 4A Pro) | Android TV 9 |

If your TV is not listed, start by identifying its Android version and installed packages. Review and adapt the lists, and share your results only after testing. Never assume that an unknown package is safe to remove.

---

## Running the Scripts Manually

The scripts are designed for PowerShell. Run them from the repository root.

```powershell
# Save a report of the TV's current state
.\scripts\backup.ps1

# Preview the debloat actions; does not apply them
.\scripts\debloat.ps1

# Apply after reviewing the plan and backup
.\scripts\debloat.ps1 -Apply

# Check the result
.\scripts\verify.ps1

# Preview the supported restoration actions
.\scripts\restore.ps1 -ListOnly

# Apply restoration
.\scripts\restore.ps1 -Apply
```

| Tool | What it does |
|---|---|
| `scripts/backup.ps1` | Saves package, property, and HOME-state reports |
| `scripts/debloat.ps1` | Preview-first user-0 package change script |
| `scripts/restore.ps1` | Attempts to restore documented package changes and Home state |
| `scripts/verify.ps1` | Checks important packages, Home state, and activity |

The repository is expected to contain files similar to these:

```text
MiTVdebloat/
├── README.md
├── LICENSE
├── SOURCES.md
├── scripts/
│   ├── backup.ps1
│   ├── debloat.ps1
│   ├── restore.ps1
│   └── verify.ps1
├── packages/
│   ├── removed-user0.txt
│   ├── disabled-user0.txt
│   └── keep-protected.txt
├── docs/
│   └── session-notes.md
└── launcher/
    └── ...
```

---

## The Launcher

CleanYourTV is a small native Android TV app (`com.gathin.tvhome`) written in plain Java, using AndroidX RecyclerView. The upstream project describes an approximately 370 KB installed app intended for TVs with 1 GB of RAM. It is designed to avoid blur effects, video, network access, and background services.

- **Configure** in `config.xml`: dock order, hidden apps, Live TV package, columns, rows under the dock, an optional VPN app for the network pill, and `reduced_motion` for TVs whose GPU cannot keep up.
- **Change the default Home:** the launcher settings and optional Default-home tile open Android's Home picker. Choose the original launcher to stop using CleanYourTV as Home, or CleanYourTV to return. Keep the original launcher enabled until you have tested the new one.
- **Themes:** use a `config.json` pushed to the TV to change theme colours, background colour, wallpaper, dock and columns without rebuilding. Theme configuration uses the same keys as the launcher configuration where applicable.
- **Language:** follows the TV. Available translations listed by the upstream project include English, German, Spanish, Catalan, French, Russian, Serbian (Latin), Polish, Portuguese, Turkish, Arabic, Hebrew, Simplified Chinese, Traditional Chinese (Taiwan), Thai, Finnish, and Vietnamese.
- **Clock screensaver:** shows a drifting clock over the artwork glow.
- **Navigation:** designed for TV remotes, with focused app memory and tile refresh behavior when apps change.

Launcher source: https://github.com/Gathin23/cleanyourtv/tree/main/launcher  
Website: https://cleanyour.tv

This repository does not claim the upstream launcher as original work. Retain the upstream MIT license and copyright notices when redistributing its source.

---

## Documented Removed Packages

The following packages were removed for Android user 0 during the documented session. Their APK files were not necessarily physically erased from the TV's system partitions. **Use this list as documentation of one device, not as a universal removal checklist.** Cross-check it against `packages/removed-user0.txt` and the original backup before applying any change.

### Optional Apps and Third-Party Utilities

```text
pure.lite.browser
com.tcl.browser
nextapp.fx
org.videolan.vlc
com.yablio.sendfilestotv
netshare.wifihotspot
kha.prog.mikrotik
com.dp.logcatapp
com.xiaomi.mimusic2
com.mitv.gallery
com.xiaomi.mitv.handbook
com.sonyliv
in.startv.hotstar
com.flixer
com.chess.chesscoach
com.amazon.amazonvideo.livingroom
com.netflix.ninja
```

### Xiaomi Apps, Analytics, and Optional Services

```text
com.miui.tv.analytics
com.xiaomi.statistic
com.xiaomi.mitv.updateservice
com.xiaomi.mitv.smartshare
com.xiaomi.floatingframe
com.xiaomi.mitv.mediaexplorer
com.xiaomi.mitv.tvmanager
com.xiaomo.tv.milegal
com.xm.webcontent
com.mitv.milinkservice
com.mitv.tvlock
com.mitv.videoplayer
com.mitv.tvhome.atv
```

### Google Optional Apps and Services

```text
com.google.android.feedback
com.google.android.tv.bugreportsender
com.google.android.youtube.tvmusic
com.google.android.marvin.talkback
com.google.android.syncadapters.calendar
com.google.android.backdrop
com.google.android.speech.pumpkin
com.google.android.katniss
com.google.android.onetimeinitializer
com.google.android.sss.authbridge
com.google.android.apps.mediashell
com.google.android.partnersetup
```

### Android Optional or Setup Components

```text
android.autoinstalls.config.xioami.dangal
com.google.android.onetimeinitializer
com.android.onetimeinitializer
com.android.sharedstoragebackup
com.android.backupconfirm
com.android.statementservice
com.android.settings.intelligence
com.google.android.tts
com.android.proxyhandler
com.android.pacprocessor
com.xiaomi.wfdsinkhelperservice
```

---

## Launchers Disabled for User 0

The following launcher packages were disabled after CleanYourTV had been installed and tested:

```text
com.google.android.tvlauncher
com.google.android.leanbacklauncher
```

Do **not** disable the stock launcher before a working replacement is installed and verified. The active Home package differs across devices; one listed launcher may not exist or may not be active on your TV.

---

## Protected Packages and Components

These packages and components were intentionally retained on the documented device because they support core TV operation, remote control, settings, or system services.

| Package / Component | Reason to Keep |
|---|---|
| `android` | Core Android framework |
| `com.android.systemui` | System UI and core system interactions |
| `com.android.tv.settings` | Android TV Settings |
| `com.android.tv` | TV/tuner and channel functions |
| `com.droidlogic.tvinput` | HDMI, AV, and broadcast TV input services |
| `com.droidlogic.droidlivetv` | DroidLogic Live TV application |
| `com.droidlogic.tv.settings` | TV display, sound, and hardware settings |
| `com.droidlogic.tv.soundeffectsettings` | Vendor sound settings |
| `com.droidlogic` | Core vendor services, including power and TV-related services |
| `mitv.service` | Xiaomi TV system service and TV-control integration |
| `com.android.bluetooth` | Bluetooth and remote-control support |
| `com.droidlogic.ble` | Vendor Bluetooth Low Energy integration |
| `com.google.android.tv.remote.service` | TV remote and related provider services |
| `com.android.vending` | Google Play Store |
| `com.google.android.gms` | Google Play Services |
| `com.google.android.gsf` | Google Services Framework |
| `com.google.android.tungsten.setupwraith` | Android TV setup and provisioning |
| `com.android.providers.tv` | TV provider and channel data |
| `com.android.providers.media` | Media provider |
| `com.android.providers.downloads` | Download provider |
| `com.android.providers.contacts` | Contacts and related provider infrastructure |
| `com.android.inputdevices` | Input-device support |
| `com.google.android.inputmethod.latin` | On-screen keyboard |
| `com.google.android.webview` | Web content rendering |
| `com.google.android.tv.frameworkpackagestubs` | Android TV framework compatibility |
| `com.google.android.backuptransport` | Privileged backup integration |
| `com.google.android.ext.services` | Android extension services |
| `com.google.android.ext.shared` | Android extension shared components |
| `com.android.defcontainer` | Package installation and container support |
| `com.android.certinstaller` | Certificate installation |
| `com.android.keychain` | System credential and key-chain support |
| `com.android.se` | Secure Element service |
| `com.android.captiveportallogin` | Captive portal handling |
| `com.xiaomi.android.TV.audio` | Xiaomi TV audio integration |
| `com.xiaomi.android.tvsetup.partnercustomizer` | Xiaomi TV setup and partner customization |
| `com.xiaomi.mitv.res` | Xiaomi TV framework resources |
| `com.droidlogic.overlay` | Vendor configuration overlay |

This is a conservative protection list based on one tested device, not a universal dependency map. Do not disable a package simply because its name is unfamiliar or because it appears to consume memory in the background.

---

## Recovery and Restoring Your TV

Before changing packages, the debloat script is intended to record their previous state, including whether a package was enabled, disabled, or not installed, which component owned Home, and the animation scales. Keep the repository's local state directory and the exact lists you applied.

Preview restoration first:

```powershell
.\scripts\restore.ps1 -ListOnly
```

Review the proposed actions, then apply:

```powershell
.\scripts\restore.ps1 -Apply
```

For a preinstalled system package, this ADB command may restore it for user 0:

```bat
adb shell cmd package install-existing --user 0 PACKAGE_NAME
```

Replace `PACKAGE_NAME` with the exact package name. On some devices, `pm install-existing --user 0 PACKAGE_NAME` is the available equivalent. A command can fail if the package is absent or the firmware handles it differently.

Restoration does not guarantee that removed app data, settings, configuration, or third-party APKs will return. Install missing third-party apps separately from trusted sources. Review script output and verify TV functions afterward.

### If Home is blank or the launcher fails

If ADB is still connected, try enabling the original Android TV launcher:

```bat
adb connect 192.168.1.50:5555
adb shell pm enable --user 0 com.google.android.tvlauncher
adb shell am start -a android.intent.action.MAIN -c android.intent.category.HOME
```

Replace `192.168.1.50` with your TV's actual IP address. If you are already connected, you do not need to run `adb connect` again. The package name may differ by model; use your backup and package report to identify the correct Home app.

On some Google TV versions, the setup wizard (`com.google.android.tungsten.setupwraith`) can take over Home or cause problems when the stock launcher is disabled. Do not disable setup components based only on this note; inspect the specific device and keep a restoration path.

---

## Questions People Ask

**Is this safe? Can it brick the TV?**  
Nothing is flashed or rooted, and `pm uninstall --user 0` normally does not physically delete the system APK. However, removing or disabling a package the TV relies on can break functions or leave you without a working Home screen. Back up first, preview every action, make small changes, and keep ADB recovery available. No script can guarantee that every device is recoverable.

**What about firmware updates?**  
The documented list includes `com.xiaomi.mitv.updateservice`. Removing the update service for user 0 may affect update behavior. Understand this trade-off before applying that entry. Keep a note of changes and restore the relevant package when needed.

**Will apps stop working?**  
It depends on the packages changed. The launcher is intended to list and launch installed apps, but removed dependencies or vendor-specific behavior may affect individual apps. Test your streaming apps and inputs after each change.

**Is ADB a security risk?**  
ADB grants powerful debugging access to an authorized computer. Network ADB is not encrypted like a typical secure remote-administration channel. Only authorize a computer you trust; disable USB and network debugging and revoke authorizations when finished.

**Can I just download the launcher APK?**  
Follow the upstream project's current build/install instructions. Do not install an APK from an unknown website. Building from source lets you inspect the code and verify what you install.

---

## Contributing

Useful contributions include package lists tested on other TV models, device-specific dependency notes, bug reports, and launcher improvements. Include the TV model, Android/Google TV version, and exactly what was tested. Remove personal information such as Wi-Fi names, IP addresses, serial numbers, and account details from logs before posting them.

---

## Licence

This repository is licensed under the MIT License; see [`LICENSE`](LICENSE). The Outfit typeface is under the SIL Open Font License; see `launcher/FONT-LICENSE-OFL.txt` when the font is included.

CleanYourTV was created by **Gathin**. This repository does not claim the upstream launcher as original work. Retain the upstream MIT license and copyright notice when redistributing the launcher source.