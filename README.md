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

### Step 7 — Install CleanYourTV automatically (optional)

The CleanYourTV launcher source is already included in this repository under `launcher/`. You do **not** need to clone the upstream launcher repository separately or download a prebuilt APK.

The installer uses the launcher source that is shipped with this repo, builds it locally, installs it to the TV, tests it, and only then changes the default Home launcher. No separate launcher download is required.

#### Requirements

- ADB is already connected to the TV and shows as `device`.
- Java/JDK 17 or newer is installed.
- You are running PowerShell from the root of this repository.

#### Run the installer

If ADB is already connected:

```powershell
.\scripts\install-launcher.ps1
```

Or connect to a TV by IP from the installer:

```powershell
.\scripts\install-launcher.ps1 -TVHost 192.168.1.50
```

Replace `192.168.1.50` with your TV's actual IP address.

#### What the installer does

The installer follows this order deliberately:

1. Checks Java, ADB, and the TV connection.
2. Uses the **local `launcher/` directory** included in this repository.
3. Builds the CleanYourTV release APK with the included Gradle project.
4. Detects the TV's currently active Home launcher instead of assuming one fixed Xiaomi package.
5. Installs CleanYourTV.
6. Starts CleanYourTV and checks that it launches successfully.
7. Compiles the launcher for the device where supported.
8. Sets CleanYourTV as the Home activity.
9. Verifies that Home now resolves to CleanYourTV.
10. Only after successful verification does it disable the previous stock launcher.
11. If the Home handover fails, it attempts to re-enable the previous launcher and restore it as Home.

This means the installer does **not** immediately disable the stock launcher before the replacement has been installed and tested.

#### Compatibility and safety

The launcher installer is designed to work across **compatible Xiaomi Mi TV / Android TV devices** because it detects the active Home package instead of relying on one hard-coded Xiaomi launcher package. However, no Android TV script can honestly guarantee compatibility with every Mi TV model, firmware, region, or Google TV variant.

The **launcher installer and the debloat package list are separate**. The launcher installer is intended for compatible Mi TV / Android TV devices, while the package-removal list in this repository was tested on the documented TV and must not be treated as a universal debloat list.

If you need an app that is currently in the removal list, **remove that package from the removal list before running the debloat script**. If the app was already removed for user 0, a preinstalled package can usually be restored with:

```powershell
adb shell cmd package install-existing --user 0 PACKAGE_NAME
```

Replace `PACKAGE_NAME` with the actual package name. For third-party apps, reinstall them from the **Google Play Store** or another trusted official source. Do not download random APKs from unknown websites.

Keep the original launcher enabled until CleanYourTV has been successfully installed and tested. If Home stops working, see [Recovery](#recovery-and-restoring-your-tv) below.

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
com.google.android.apps.tv.launcherx
```

---

## Protected Packages

Do not remove these packages blindly. They were treated as protected in the documented configuration because they provide core Android, TV input, settings, connectivity, Play Services, setup, or other system functions.

```text
android
com.android.systemui
com.android.settings
com.android.providers.settings
com.android.providers.media
com.android.providers.downloads
com.android.packageinstaller
com.android.permissioncontroller
com.android.bluetooth
com.android.tv.settings
com.google.android.gms
com.google.android.gsf
com.android.vending
com.google.android.tv.frameworkpackagestubs
com.google.android.inputmethod.latin
com.google.android.webview
com.google.android.backuptransport
com.google.android.ext.services
com.google.android.ext.shared
com.android.defcontainer
com.android.certinstaller
com.android.keychain
com.android.se
com.android.captiveportallogin
```

The complete protected list is maintained in `packages/keep-protected.txt`. It is still not a guarantee that every listed package is required on every TV.

---

## Recovery and Restoring Your TV

If an app disappears after debloating, first try restoring the preinstalled package for user 0:

```powershell
adb shell cmd package install-existing --user 0 PACKAGE_NAME
```

If a package was only disabled:

```powershell
adb shell pm enable --user 0 PACKAGE_NAME
```

For packages removed by this project's scripts, use the restore script:

```powershell
.\scripts\restore.ps1 -ListOnly
.\scripts\restore.ps1 -Apply
```

### If the Home screen is broken

If CleanYourTV or another launcher is not working, re-enable a known stock launcher:

```powershell
adb shell pm enable --user 0 com.google.android.tvlauncher
adb shell cmd package set-home-activity --user 0 com.google.android.tvlauncher
adb shell am start -a android.intent.action.MAIN -c android.intent.category.HOME
```

On a TV where that package does not exist, use the stock launcher package identified by the backup or by resolving the current Home activity. Do not blindly use a package name from another model.

### If you need a removed app again

If the package is in the removal list and you still need it, remove that package from the removal list before running the debloat process on a fresh setup. If it has already been removed for user 0 and the APK remains preinstalled, use `cmd package install-existing` as shown above. Third-party apps can be reinstalled from the Google Play Store or another trusted official source.

---

## Safety Notes

- **No root:** the scripts use ADB and normal Android package-management commands.
- **No firmware flashing:** this project does not flash system partitions or replace the TV's firmware.
- **No physical deletion:** `pm uninstall --user 0` normally removes the package only for user 0; the factory APK can remain on the system partition.
- **Still not risk-free:** removing or disabling a dependency can break another feature even when the APK itself remains on the system partition.
- **Back up first:** always run `backup.ps1` before changing packages.
- **Preview first:** run `debloat.ps1` without `-Apply` before applying anything.
- **Keep the stock launcher:** do not disable it until CleanYourTV is installed and verified.
- **ADB security:** only authorize computers you trust and disable debugging when finished.

### Is this safe for all Mi TVs?

The **launcher installer is designed for compatible Xiaomi Mi TV / Android TV devices**, and it detects the current Home launcher instead of assuming one exact Xiaomi package. It also verifies CleanYourTV before disabling the detected stock launcher and attempts rollback if final Home verification fails.

However, it is not honest to claim that any script is guaranteed safe on **every** Mi TV model, firmware, region, Android version, or Google TV variant. The **debloat package list is definitely not universal**; it was tested on the documented MiTV-AXSO0 and must be reviewed for other models.

If your TV differs from the documented model, treat the launcher installer and the debloat list separately: the launcher may be compatible while one or more debloat packages may not be.

---

## Credits

CleanYourTV was created by **Gathin**. This repository includes the launcher source under `launcher/` for the convenience of this project. The launcher remains upstream work; this repository does not claim it as original work.

Upstream launcher: https://github.com/Gathin23/cleanyourtv/tree/main/launcher  
Project website: https://cleanyour.tv

---

## License

This repository is licensed under the MIT License; see [`LICENSE`](LICENSE). The Outfit typeface is under the SIL Open Font License; see `launcher/FONT-LICENSE-OFL.txt` when the font is included.

CleanYourTV was created by **Gathin**. This repository does not claim the upstream launcher as original work. Retain the upstream MIT license and copyright notice when redistributing the launcher source.
