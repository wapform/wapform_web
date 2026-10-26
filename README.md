# WapForm for Web — sample platform

English · [中文](README.zh-TW.md) · 日本語：[Install-Guide.html](Install-Guide.html)（日本語の章）

The sample platform installed by **WapForm for Web** (`wapsetup.exe`, download at
[wapform.com/web](https://wapform.com/web)): an online shop served by WapForm for Web, a back
office for Windows and Flutter built from the same WML pages, and the shared sample database.

The installer copies these files to `C:\Wapform`. This repository holds the same files so you
can read them, compare versions or start your own project from them.

> All accounts, passwords and LINE values in the samples are **simulated** (for example
> `xyz` / `123`) and meant for local testing only. Replace them before going live — see
> [Before going live](#before-going-live).

## Contents

- [Architecture](#architecture)
- [Repository layout](#repository-layout)
- [Requirements](#requirements)
- [Installation](#installation)
- [Sample database](#sample-database)
- [wapform.ini](#wapformini)
- [Running the samples](#running-the-samples)
- [Setting up Flutter](#setting-up-flutter)
- [License and trial](#license-and-trial)
- [Before going live](#before-going-live)

## Architecture

One WML definition, three ways to run it, one database:

```
                         ┌──────────────────────────────┐
  Browser  ──HTTP──▶     │ IIS + WapServ.dll (licensed)  │──┐
  (shop customers)       │  or WapServer.exe (free,      │  │
                         │      localhost:8080 only)     │  │
                         │  runs shop\*.wml              │  │
                         └──────────────────────────────┘  │
                                                            ▼
  Windows PC ──────▶  WapForm Runtime / Toolkit          ┌──────────┐
  (back office)       opens flutter\lib\*.wml directly ──▶│  MySQL / │
                                                          │ MariaDB  │
  Phone / browser ──▶ Flutter app (flutter\lib\*.dart,   │ "sales"  │
  (back office)       generated from the same .wml)      └──────────┘
                         │                                    ▲
                         └──REST──▶ flutter\server\server.js ─┘
                                    (Node.js, port 3000)
```

- **Shop (Web).** `shop\` is a complete online store written in WML. Each request runs a `.wml`
  page in WapForm for Web; the page layout comes from the template `wapform.htm` / `wapform.html`,
  so layout and logic are maintained separately.
- **Back office (Windows).** WapForm Runtime or Toolkit (Microsoft Store) opens the `.wml`
  pages in `flutter\lib\` directly as Windows forms and reports.
- **Back office (Flutter).** WapForm Toolkit generates a `.dart` page from each of those `.wml`
  pages. The Flutter app (Web and Android) uses the open-source runtime
  [wapform_flutter](https://pub.dev/packages/wapform_flutter) and reaches the database through the
  REST back end in `flutter\server\`.
- **One database.** Orders and members created in the shop are managed directly in the back
  office, on Windows or Flutter.

## Repository layout

| Path | Contents |
|---|---|
| `shop/` | Sample online store (English): catalog, products, cart, members, orders, reports, crosstab, charts, uploads, LINE Bot and LINE push samples. `wapform.htm` / `wapform.html` are the page templates. |
| `shop/wapform.ini` | Settings of the store site (see [wapform.ini](#wapformini)). |
| `shop/upload/` | Upload folder of the upload samples. Its `web.config` (IIS only) adds a CORS header so a Flutter Web app can show the uploaded images. |
| `flutter/` | WapForm for Flutter project (Web and Android platform folders included), using `wapform_flutter` ^1.6.8 from pub.dev. |
| `flutter/lib/` | The back office: the same `.wml` pages run on Windows, the generated `.dart` pages run on Flutter. `wapform.ini` here is read by the Windows back office. |
| `flutter/server/` | REST back end of the Flutter back office (Node.js `server.js`, `start_server.bat`, port 3000). |
| `database/sales.sql` | Sample database `sales` (fictitious English data). |
| `wapform.ini` | Shared settings file in `C:\Wapform`. |
| `Install-Guide.html` | The installation guide in English, Chinese and Japanese (the same content as this README, plus Chinese and Japanese). |

The installer also places `WapServ.dll`, `WapServer.exe` and the IIS setup scripts in
`C:\Wapform`; those are not part of this repository.

## Requirements

| Item | Used for | Needed |
|---|---|---|
| Windows 10 / 11 or Windows Server | All components | Always |
| MySQL or MariaDB (for example XAMPP) | The sample database `sales` | To run the samples |
| IIS with ISAPI Extensions | Serving sites with WapServ.dll | IIS module only |
| WapForm for Web (`wapsetup.exe`) | WapServ.dll / WapServer.exe to run the shop | To run the shop |
| WapForm Runtime or Toolkit (Microsoft Store) | Running the back office on Windows | Windows back office |
| Node.js | `flutter\server\server.js` | Flutter back office |
| Flutter SDK, Chrome, Android Studio | Building and running the Flutter back office | Flutter back office |

Turning on IIS: Control Panel › Programs › Turn Windows features on or off › Internet Information
Services › World Wide Web Services › Application Development Features › check **ISAPI Extensions**.

## Installation

### With the installer (recommended)

1. Download `wapsetup.exe` from [wapform.com/web](https://wapform.com/web) and run it as administrator.
2. Choose **Full environment** (Web, samples and Flutter) or **Custom**.
3. With the IIS module, confirm the IIS site (default *Default Web Site*) and application pool
   (default *DefaultAppPool*). Setup enables 32-bit applications, allows the ISAPI extension, maps
   `*.wml` to `C:\Wapform\WapServ.dll`, adds `index.wml` as default document, grants write access
   to the license and upload folders and restarts the pool. Log: `C:\Wapform\setup\iis-setup.log`.
4. The sample store is placed in `C:\Wapform\shop` (for WapForm Web Server) and in the `shop`
   folder of the IIS site (for IIS).

Running setup again never overwrites samples or a `wapform.ini` you have changed. Uninstalling
keeps them too, unless you answer **Yes** to *Remove everything as well?*. The license data
(`C:\ProgramData\WapForm\License`) and the `sales` database are always kept.

### From this repository

To use the files from GitHub instead (for example a newer sample version), install WapForm for
Web first, then copy the folders over the installed ones:

| Repository | Copy to |
|---|---|
| `shop\` | `C:\Wapform\shop\` and, for IIS, `C:\inetpub\wwwroot\shop\` |
| `flutter\` | `C:\Wapform\flutter\` |
| `database\sales.sql` | `C:\Wapform\database\` |
| `wapform.ini` | `C:\Wapform\` |

Then create the database and adjust `wapform.ini` as described below.

## Sample database

```
cd C:\Wapform\database
mysql -u root -p < sales.sql
```

With XAMPP the client is `C:\xampp\mysql\bin\mysql.exe`; you can also use phpMyAdmin › Import.

`sales.sql`:

- creates the database `sales` (if it exists, its sample tables are re-created — back up a
  database with that name first);
- creates the MySQL account `xyz` / `123` (simulated values) with access to `sales` only;
- loads fictitious English data: a stationery catalog with 271 categories, 5,390 products (22 per
  category, 4 of them recommended), 30 customers, 10 vendors, 6 staff, 3 carriers, 120 orders and
  8 articles.

| Table | Contents |
|---|---|
| `pa` | Catalog (`mnu='m'`: `gid='0000'` = top level, others = sub-categories) and products (`mnu='n'`, `gid` = sub-category code). `active`: 0 hidden, 1 listed, 2 and up recommended (sorted by the number) |
| `menu`, `web` | The store's category menu and category list |
| `cu` / `ve` / `em` / `fm` | Customers (including store members) / vendors / staff / carriers |
| `sh` / `sn` | Shipping orders (header / lines); also the source of the store's best sellers |
| `rh` / `rn` | Store carts and web orders |
| `sys` | Company profile, tax rate, accounting period |
| `mnu` / `users` / `login` | Back-office menu / accounts / permissions |
| `topic`, `counter`, `num` | Articles, visit counter, document number sequence |

## wapform.ini

`wapform.ini` is the settings file of the WapForm programs. There are three copies, and each
program or site folder reads the one next to it:

| File | Read by |
|---|---|
| `C:\Wapform\wapform.ini` | Shared settings of the installation folder |
| `shop\wapform.ini` | The store site (WapServ.dll / WapServer.exe) |
| `flutter\lib\wapform.ini` | The Windows back office (WapForm Runtime / Toolkit opening `flutter\lib\*.wml`) |

The Flutter back office does not read `wapform.ini`: its REST back end has the same database
settings in `flutter\server\server.js`.

Format: `name=value`, one per line; names are case-insensitive; lines starting with `;` are
comments; save the file as **UTF-8**. Only the database lines are required — leave out any other
line to use its default.

```ini
; ---- Database (required) ----
Driver=mysql
Server=localhost
Database=sales
Username=xyz
Password=123

; ---- Optional ----
DateFormat=yyyy/mm/dd
FontName=MingLiU
FontSize=10
CharWidth=7
CharHeight=13
unicode=yes
language=en
line_bot_id=
line_channel_secret=
line_channel_access_token=
```

| Key | Sample | Meaning |
|---|---|---|
| `driver` | `mysql` | **Required.** Database type: `mysql` (MySQL / MariaDB); the Professional edition also supports `mssql` (SQL Server). |
| `server` | `localhost` | **Required.** Database host name or IP; use `host:port` for a non-default port. |
| `database` | `sales` | **Required.** Database name. |
| `username` | `xyz` | **Required.** Database account — use one limited to this database, not `root`. |
| `password` | `123` | **Required.** Database password (simulated — always change it for a real installation). |
| `dateformat` | `yyyy/mm/dd` | Optional (default: Windows regional settings). Date format on screens and reports. |
| `fontname` | `MingLiU` | Optional (default: system font). Default font of Windows forms and reports. Use a monospaced font, because layouts are measured in character cells (`charwidth` / `charheight`). MingLiU is built into Windows and covers English, Traditional Chinese and Japanese. For an English-only interface Consolas also works; MS Gothic lacks some Traditional Chinese characters. |
| `fontsize` | `10` | Optional (default 10). Default font size in points. |
| `charwidth` | `7` | Optional (default 7). Width of one character cell in pixels, used to convert WML widths given in characters. |
| `charheight` | `13` | Optional (default 13). Height of one character cell in pixels, used for row heights and layout. |
| `unicode` | `yes` | Keep it for utf8mb4 databases such as the sample: the presence of the line switches Unicode (UTF-8 / utf8mb4) on — the value is not checked; without it the connection is not Unicode. |
| `language` | `en` | Optional (default `en`). Interface language of WapForm Toolkit / Runtime: `en`, `tw` (Traditional Chinese) or `jp` (Japanese). |
| `line_bot_id` | *(empty)* | LINE samples only. LINE Official Account ID (linebot, linepush). |
| `line_channel_secret` | *(empty)* | LINE samples only. Messaging API channel secret; verifies the webhook signature (`X-Line-Signature`). |
| `line_channel_access_token` | *(empty)* | LINE samples only. Channel access token for the push / reply API. |
| `loginusr` / `loginpwd` | `admin` / `123` | Only in `shop\wapform.ini`: default sign-in of the store's management pages. |

> **Security.** A real `wapform.ini` holds the database password and LINE keys: never publish it
> on a website or commit it to a public repository (the copies here contain only simulated
> values). IIS does not serve `.ini` files by default — do not move it to a downloadable
> location. Get the LINE keys from the LINE Developers console and re-issue them at once if they
> leak.

The store's password-reset mail (`shop\forget.wml`) uses Gmail: replace
`your-account@gmail.com` and `your-gmail-app-password` with your own account and an app password.

## Running the samples

### Web: online store (shop)

- IIS: `http://localhost/shop/`
- WapForm Web Server (free): open *WapForm Web Server* › Start, then `http://localhost:8080/shop/`
  (documents path defaults to `C:\Wapform`).
- Member sign-in: `demo@example.com` / `123`.

### Windows: back office

Open the `.wml` pages in `C:\Wapform\flutter\lib` with WapForm Toolkit or Runtime, for example
`app002.wml` (products) and `app006.wml` (shipping orders). Sign in: `admin` / `123` (all
functions) or `demo` / `123` (sales menu only).

### Flutter: back office (Web, Android)

Complete [Setting up Flutter](#setting-up-flutter) first, then:

```
cd C:\Wapform\flutter\server
npm install
node server.js                     (or start_server.bat)

cd C:\Wapform\flutter
flutter pub get
flutter run -d chrome              (Web)
adb reverse tcp:3000 tcp:3000      (Android: forward the device's localhost:3000 to this PC)
flutter run -d android             (Android)
```

`server.js` uses the same database settings as `wapform.ini` and listens on
`http://localhost:3000`. On an Android phone or emulator `localhost` is the device itself, so run
`adb reverse tcp:3000 tcp:3000` every time a device is connected.

## Setting up Flutter

Develop on Windows; targets: Web and Android.

1. **Git for Windows**: git-scm.com/download/win.
2. **Flutter SDK**: extract the Windows zip from docs.flutter.dev to a folder with no spaces,
   for example `C:\src\flutter`, and add `C:\src\flutter\bin` to the user `Path`. Check with
   `flutter --version`.
3. **Web**: install Google Chrome.
4. **Android**: install Android Studio; in SDK Manager select Android SDK, SDK Command-line Tools
   and Platform-Tools; create an emulator or connect a phone with USB debugging. Run
   `flutter doctor --android-licenses`.
5. **Node.js LTS** for the REST back end.
6. Run `flutter doctor`: Chrome and the Android toolchain should be checked.

WapForm Toolkit generates the Flutter `.dart` pages from `.wml`. After changing a `.wml`, generate
the `.dart` page again and `flutter run`. Release builds: `flutter build web` and
`flutter build apk`; in production the REST back end must run on a server the device can reach
(HTTPS recommended).

## License and trial

Each product starts a 30-day trial with all features on first use. After the trial, Toolkit and
Runtime continue as the Free edition and WapForm for Web stops serving. Buy at
[wapform.com/pricing](https://wapform.com/pricing); the license key is emailed to you.
WapForm for Web: open `http://localhost/license.wml` on the server itself and enter the key.

## Before going live

- Replace every simulated value: the MySQL account (`wapform.ini`, `server.js`), the back-office
  account `admin` / `123`, test members, `loginusr` / `loginpwd`.
- Enter your own LINE and Gmail settings (never the sample values).
- Delete or edit the sample products, customers and articles.
- Serve the site over HTTPS.

## License

The sample files in this repository are released under the [MIT License](LICENSE): you may copy,
change and use them in your own projects, including commercial ones. The WapForm products
themselves (WapForm Toolkit, WapForm Runtime, WapForm for Web) are commercial software, licensed
separately — see [wapform.com/terms](https://wapform.com/terms).

---

Documentation and support: [wapform.com](https://wapform.com) ·
[github.com/wapform](https://github.com/wapform) · Flutter runtime:
[wapform_flutter](https://github.com/wapform/wapform_flutter)
