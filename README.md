# WapForm for Web — samples

The sample platform installed by **WapForm for Web** (`wapsetup.exe`, download at
[wapform.com/web](https://wapform.com/web)): an online shop served by WapForm for Web,
a back office for Windows and Flutter built from the same WML pages, and the shared
sample database.

The installer copies these files to `C:\Wapform`. This repository holds the same files so
you can read them, compare versions or start your own project from them.

| Folder | Contents |
|---|---|
| `shop/` | The online store (English): WML pages served by WapForm for Web — IIS with WapServ.dll, or the free WapForm Web Server on localhost. Cart, members, orders, reports, crosstab, charts, uploads, LINE Bot / push samples. |
| `flutter/` | The back office, a WapForm for Flutter project. One set of WML pages: WapForm Runtime / Toolkit (Microsoft Store) opens `flutter/lib/*.wml` on Windows; the `.dart` pages generated from the same `.wml` files run on Flutter (Web and Android) with [wapform_flutter](https://pub.dev/packages/wapform_flutter) ^1.6.8. |
| `flutter/server/` | REST back end of the Flutter back office (Node.js, `start_server.bat`, port 3000). |
| `database/sales.sql` | The shared MySQL / MariaDB sample database. |
| `wapform.ini` | Settings file of the WapForm programs (database, date format, font, language). |
| `Install-Guide.html` | Full installation guide in English, Chinese and Japanese. |

## Database

Both parts share one MySQL / MariaDB database named `sales`:

```
mysql -u root -p < database/sales.sql
```

The data is fictitious (stationery catalog, 5,390 products, customers, vendors, staff, orders,
articles). The script re-creates the sample tables and the MySQL account `xyz` / `123`.
To use another server or account, change Server / Username / Password in
`wapform.ini`, `shop/wapform.ini`, `flutter/lib/wapform.ini` and `flutter/server/server.js`.

Logins: back office `admin` / `123` or `demo` / `123`; web shop `demo@example.com` / `123`.

**All accounts, passwords and LINE values in the samples are simulated — replace them before
going live.** `shop/forget.wml` (password-reset mail) needs your own mail account and app password.

## Running the Flutter back office

```
flutter/server/start_server.bat
cd flutter
flutter pub get
flutter run -d chrome          # Web
adb reverse tcp:3000 tcp:3000
flutter run -d android         # Android phone or emulator
```

## Requirements

- The shop needs **WapForm for Web** (IIS + WapServ.dll, or WapForm Web Server for local testing):
  [wapform.com/web](https://wapform.com/web)
- The Windows back office needs **WapForm Runtime** or **WapForm Toolkit** from the Microsoft Store.
- The Flutter back office needs Flutter and the open-source
  [wapform_flutter](https://github.com/wapform/wapform_flutter) package.

## 中文簡介

WapForm for Web 安裝程式附帶的範例平台：`shop/` 是網路商店（WapForm for Web 執行），`flutter/` 是用同一組 WML
做成的 Windows／Flutter 後台，`database/sales.sql` 是共用的範例資料庫。安裝說明見 `Install-Guide.html`。
範例中的帳號、密碼與 LINE 設定都是模擬值，正式上線前請換掉。

## 日本語の概要

WapForm for Web のインストーラーに含まれるサンプル一式です。`shop/` は WapForm for Web で動くオンラインショップ、
`flutter/` は同じ WML から作った Windows／Flutter のバックオフィス、`database/sales.sql` は共通のサンプルデータベースです。
インストール手順は `Install-Guide.html` をご覧ください。サンプルのアカウント、パスワード、LINE の設定値はすべて仮の値です。
本番運用の前に必ず置き換えてください。

---

Documentation and support: [wapform.com](https://wapform.com) · [github.com/wapform](https://github.com/wapform)
