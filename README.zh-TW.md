# WapForm for Web — 範例平台

[English](README.md) · 中文 · 日本語：[Install-Guide.html](Install-Guide.html)（日本語の章）

這是 **WapForm for Web** 安裝程式（`wapsetup.exe`，下載：[wapform.com/web](https://wapform.com/web)）
所附的範例平台：一個由 WapForm for Web 執行的網路商店、一套用同一組 WML 做成的 Windows／Flutter 後台，
以及共用的範例資料庫。

安裝程式會把這些檔案放到 `C:\Wapform`。這個 repo 收錄相同的檔案，方便閱讀、比對版本，或當成自己專案的起點。

> 範例中的帳號、密碼與 LINE 設定都是**模擬值**（例如 `xyz` / `123`），只供本機測試。
> 正式上線前請全部換掉，見〈[上線前檢查](#上線前檢查)〉。

## 目錄

- [架構](#架構)
- [檔案結構](#檔案結構)
- [需求](#需求)
- [安裝](#安裝)
- [範例資料庫](#範例資料庫)
- [wapform.ini 參數說明](#wapformini-參數說明)
- [執行範例](#執行範例)
- [Flutter 開發環境](#flutter-開發環境)
- [授權與試用](#授權與試用)
- [上線前檢查](#上線前檢查)

## 架構

一份 WML 定義，三種執行方式，一個資料庫：

```
                         ┌──────────────────────────────┐
  瀏覽器   ──HTTP──▶     │ IIS + WapServ.dll（授權版）    │──┐
  （商店顧客）           │  或 WapServer.exe（免費版，    │  │
                         │      只服務 localhost:8080）   │  │
                         │  執行 shop\*.wml               │  │
                         └──────────────────────────────┘  │
                                                            ▼
  Windows 電腦 ────▶  WapForm Runtime／Toolkit           ┌──────────┐
  （後台）            直接開啟 flutter\lib\*.wml ───────▶│  MySQL／ │
                                                          │ MariaDB  │
  手機／瀏覽器 ────▶  Flutter App（flutter\lib\*.dart，   │ "sales"  │
  （後台）            由同一份 .wml 產生）               └──────────┘
                         │                                    ▲
                         └──REST──▶ flutter\server\server.js ─┘
                                    （Node.js，port 3000）
```

- **商店（Web）**：`shop\` 是用 WML 寫成的完整網路商店。每個請求由 WapForm for Web 執行一支 `.wml`，
  版面來自樣板 `wapform.htm`／`wapform.html`，版面與邏輯分開維護。
- **後台（Windows）**：WapForm Runtime 或 Toolkit（Microsoft Store）直接把 `flutter\lib\` 裡的 `.wml`
  開成 Windows 表單與報表。
- **後台（Flutter）**：WapForm Toolkit 把同一批 `.wml` 各自產生成 `.dart`。Flutter App（Web、Android）
  使用開源執行層 [wapform_flutter](https://pub.dev/packages/wapform_flutter)，透過 `flutter\server\`
  的 REST 後端存取資料庫。
- **同一個資料庫**：商店產生的訂單與會員，直接在後台（Windows 或 Flutter）管理。

## 檔案結構

| 路徑 | 內容 |
|---|---|
| `shop/` | 範例網路商店（英文）：商品目錄、商品、購物車、會員、訂單、報表、交叉分析、圖表、上傳、LINE Bot 與 LINE 推播範例。`wapform.htm`／`wapform.html` 是頁面樣板。 |
| `shop/wapform.ini` | 商店網站的設定（見〈[wapform.ini 參數說明](#wapformini-參數說明)〉）。 |
| `shop/upload/` | 上傳範例的存放資料夾。其中的 `web.config`（只對 IIS 有效）加上 CORS 標頭，讓 Flutter Web App 能顯示上傳的圖片。 |
| `flutter/` | WapForm for Flutter 專案（含 Web、Android 平台資料夾），使用 pub.dev 上的 `wapform_flutter` ^1.6.8。 |
| `flutter/lib/` | 後台：同一批 `.wml` 在 Windows 執行，產生的 `.dart` 在 Flutter 執行。這裡的 `wapform.ini` 給 Windows 後台讀取。 |
| `flutter/server/` | Flutter 後台的 REST 後端（Node.js `server.js`、`start_server.bat`，port 3000）。 |
| `database/sales.sql` | 範例資料庫 `sales`（虛構的英文資料）。 |
| `wapform.ini` | `C:\Wapform` 的共用設定檔。 |
| `Install-Guide.html` | 安裝說明（英、中、日三語）。 |

安裝程式另外會把 `WapServ.dll`、`WapServer.exe` 與 IIS 設定腳本放到 `C:\Wapform`，這些不在本 repo 中。

## 需求

| 項目 | 用途 | 何時需要 |
|---|---|---|
| Windows 10／11 或 Windows Server | 所有元件 | 一定需要 |
| MySQL 或 MariaDB（例如 XAMPP） | 範例資料庫 `sales` | 執行範例時 |
| IIS（含 ISAPI 擴充） | 以 WapServ.dll 提供網站 | 只有 IIS 模組需要 |
| WapForm for Web（`wapsetup.exe`） | 執行商店的 WapServ.dll／WapServer.exe | 執行商店時 |
| WapForm Runtime 或 Toolkit（Microsoft Store） | 在 Windows 執行後台 | Windows 後台 |
| Node.js | `flutter\server\server.js` | Flutter 後台 |
| Flutter SDK、Chrome、Android Studio | 建置與執行 Flutter 後台 | Flutter 後台 |

開啟 IIS：控制台 › 程式集 › 開啟或關閉 Windows 功能 › Internet Information Services › World Wide Web 服務
› 應用程式開發功能 › 勾選 **ISAPI 擴充程式**。

## 安裝

### 用安裝程式（建議）

1. 從 [wapform.com/web](https://wapform.com/web) 下載 `wapsetup.exe`，以系統管理員身分執行。
2. 選擇 **完整環境**（Web、範例、Flutter）或 **自訂**。
3. 若安裝 IIS 模組，確認 IIS 站台（預設 *Default Web Site*）與應用程式集區（預設 *DefaultAppPool*）。
   安裝程式會啟用 32 位元應用程式、允許 ISAPI 擴充、把 `*.wml` 對應到 `C:\Wapform\WapServ.dll`、
   把 `index.wml` 加入預設文件、開放授權與上傳資料夾的寫入權限，並重新啟動集區。
   紀錄檔：`C:\Wapform\setup\iis-setup.log`。
4. 範例商店會同時放在 `C:\Wapform\shop`（給 WapForm Web Server）與 IIS 站台的 `shop` 資料夾（給 IIS）。

重新執行安裝（升級）不會覆蓋你改過的範例或 `wapform.ini`；解除安裝也會保留，除非在
「*也要移除全部內容嗎？*」回答 **是**。授權資料（`C:\ProgramData\WapForm\License`）與 `sales` 資料庫一律保留。

### 從本 repo 取用

若要改用 GitHub 上的檔案（例如較新的範例），先安裝 WapForm for Web，再把資料夾覆蓋到安裝位置：

| repo | 複製到 |
|---|---|
| `shop\` | `C:\Wapform\shop\`；使用 IIS 時另外複製到 `C:\inetpub\wwwroot\shop\` |
| `flutter\` | `C:\Wapform\flutter\` |
| `database\sales.sql` | `C:\Wapform\database\` |
| `wapform.ini` | `C:\Wapform\` |

接著依下方說明建立資料庫、調整 `wapform.ini`。

## 範例資料庫

```
cd C:\Wapform\database
mysql -u root -p < sales.sql
```

使用 XAMPP 時，用戶端是 `C:\xampp\mysql\bin\mysql.exe`；也可以用 phpMyAdmin › 匯入。

`sales.sql` 會：

- 建立資料庫 `sales`（若已存在，會重建其中的範例資料表——同名資料庫請先備份）；
- 建立只能存取 `sales` 的 MySQL 帳號 `xyz`／`123`（模擬值）；
- 載入虛構的英文資料：271 個分類的文具目錄、5,390 項商品（每類 22 項，其中 4 項推薦）、30 位客戶、
  10 家廠商、6 位員工、3 家貨運、120 筆訂單、8 篇文章。

| 資料表 | 內容 |
|---|---|
| `pa` | 目錄（`mnu='m'`：`gid='0000'` 為第一層，其餘為子分類）與商品（`mnu='n'`，`gid` = 子分類代碼）。`active`：0 隱藏、1 上架、2 以上為推薦（依數字排序） |
| `menu`、`web` | 商店的分類選單與分類清單 |
| `cu`／`ve`／`em`／`fm` | 客戶（含商店會員）／廠商／員工／貨運 |
| `sh`／`sn` | 出貨單（表頭／明細）；也是商店熱銷商品的來源 |
| `rh`／`rn` | 商店購物車與網路訂單 |
| `sys` | 公司資料、稅率、會計期間 |
| `mnu`／`users`／`login` | 後台選單／帳號／權限 |
| `topic`、`counter`、`num` | 文章、瀏覽計數、單據編號 |

## wapform.ini 參數說明

`wapform.ini` 是 WapForm 程式的設定檔，共有三份，各程式或網站資料夾讀取自己旁邊那一份：

| 檔案 | 由誰讀取 |
|---|---|
| `C:\Wapform\wapform.ini` | 安裝資料夾的共用設定 |
| `shop\wapform.ini` | 商店網站（WapServ.dll／WapServer.exe） |
| `flutter\lib\wapform.ini` | Windows 後台（WapForm Runtime／Toolkit 開啟 `flutter\lib\*.wml` 時） |

Flutter 後台不讀 `wapform.ini`：它的 REST 後端在 `flutter\server\server.js` 裡有相同的資料庫設定。

格式：每行一個 `名稱=值`；名稱不分大小寫；`;` 開頭為註解；檔案請存成 **UTF-8**。
只有資料庫那幾行是必要的，其他行省略即使用預設值。

```ini
; ---- 資料庫（必要） ----
Driver=mysql
Server=localhost
Database=sales
Username=xyz
Password=123

; ---- 選用 ----
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

| 參數 | 範例 | 說明 |
|---|---|---|
| `driver` | `mysql` | **必要。** 資料庫類型：`mysql`（MySQL／MariaDB）；專業版另支援 `mssql`（SQL Server）。 |
| `server` | `localhost` | **必要。** 資料庫主機名稱或 IP；非預設連接埠用 `主機:埠`。 |
| `database` | `sales` | **必要。** 資料庫名稱。 |
| `username` | `xyz` | **必要。** 資料庫帳號——請用只能存取此資料庫的帳號，不要用 `root`。 |
| `password` | `123` | **必要。** 資料庫密碼（模擬值，正式安裝一定要改）。 |
| `dateformat` | `yyyy/mm/dd` | 選用（預設：Windows 地區設定）。畫面與報表的日期格式。 |
| `fontname` | `MingLiU` | 選用（預設：系統字型）。Windows 表單與報表的預設字型。版面以字元格（`charwidth`／`charheight`）計算，請用等寬字型。細明體 MingLiU 內建於 Windows，涵蓋英、繁中、日文；純英文介面也可用 Consolas；MS Gothic 缺部分繁中字。 |
| `fontsize` | `10` | 選用（預設 10）。預設字型大小（點）。 |
| `charwidth` | `7` | 選用（預設 7）。一個字元格的寬度（像素），用來換算 WML 中以字數表示的寬度。 |
| `charheight` | `13` | 選用（預設 13）。一個字元格的高度（像素），用於列高與版面。 |
| `unicode` | `yes` | 像範例這樣的 utf8mb4 資料庫請保留：**有這一行**就啟用 Unicode（UTF-8／utf8mb4），值不檢查；沒有這行則不是 Unicode 連線。 |
| `language` | `en` | 選用（預設 `en`）。WapForm Toolkit／Runtime 的介面語言：`en`、`tw`（繁體中文）、`jp`（日文）。 |
| `line_bot_id` | （空白） | 僅 LINE 範例使用。LINE 官方帳號 ID（linebot、linepush）。 |
| `line_channel_secret` | （空白） | 僅 LINE 範例使用。Messaging API 的 channel secret，用來驗證 webhook 簽章（`X-Line-Signature`）。 |
| `line_channel_access_token` | （空白） | 僅 LINE 範例使用。推播／回覆 API 的 channel access token。 |
| `loginusr`／`loginpwd` | `admin`／`123` | 只在 `shop\wapform.ini`：商店管理頁面的預設登入帳密。 |

> **安全提醒**：正式環境的 `wapform.ini` 含有資料庫密碼與 LINE 金鑰，絕不可放到網站上供下載，也不可提交到公開
> repo（這裡的檔案只含模擬值）。IIS 預設不提供 `.ini` 檔下載，請勿把它移到可下載的位置。LINE 金鑰請在
> LINE Developers 主控台取得，一旦外洩請立即重新發行。

商店的忘記密碼信（`shop\forget.wml`）使用 Gmail：請把 `your-account@gmail.com` 與
`your-gmail-app-password` 換成你自己的帳號與應用程式密碼。

## 執行範例

### Web：網路商店（shop）

- IIS：`http://localhost/shop/`
- WapForm Web Server（免費）：開啟 *WapForm Web Server* › Start，然後瀏覽 `http://localhost:8080/shop/`
  （文件路徑預設為 `C:\Wapform`）。
- 會員登入：`demo@example.com`／`123`。

### Windows：後台管理

用 WapForm Toolkit 或 Runtime 開啟 `C:\Wapform\flutter\lib` 的 `.wml`，例如 `app002.wml`（商品）、
`app006.wml`（出貨單）。登入：`admin`／`123`（全部功能）或 `demo`／`123`（只有銷售選單）。

### Flutter：後台管理（Web、Android）

先完成〈[Flutter 開發環境](#flutter-開發環境)〉，然後：

```
cd C:\Wapform\flutter\server
npm install
node server.js                     （或執行 start_server.bat）

cd C:\Wapform\flutter
flutter pub get
flutter run -d chrome              （Web）
adb reverse tcp:3000 tcp:3000      （Android：把裝置的 localhost:3000 轉到這台電腦）
flutter run -d android             （Android）
```

`server.js` 使用與 `wapform.ini` 相同的資料庫設定，監聽 `http://localhost:3000`。在 Android 手機或模擬器上，
`localhost` 指的是裝置本身，所以每次接上裝置都要執行 `adb reverse tcp:3000 tcp:3000`。

## Flutter 開發環境

開發環境：Windows；目標平台：Web、Android。

1. **Git for Windows**：git-scm.com/download/win。
2. **Flutter SDK**：從 docs.flutter.dev 下載 Windows zip，解壓到沒有空白的資料夾（例如 `C:\src\flutter`），
   並把 `C:\src\flutter\bin` 加入使用者 `Path`。用 `flutter --version` 確認。
3. **Web**：安裝 Google Chrome。
4. **Android**：安裝 Android Studio；在 SDK Manager 勾選 Android SDK、SDK Command-line Tools 與 Platform-Tools；
   建立模擬器或接上開啟 USB 偵錯的手機。執行 `flutter doctor --android-licenses`。
5. **Node.js LTS**：給 REST 後端使用。
6. 執行 `flutter doctor`：Chrome 與 Android toolchain 應為打勾。

WapForm Toolkit 會從 `.wml` 產生 Flutter 的 `.dart`。改了 `.wml` 之後，重新產生 `.dart` 再 `flutter run`。
正式版建置：`flutter build web` 與 `flutter build apk`；正式環境的 REST 後端要放在裝置連得到的伺服器上（建議 HTTPS）。

## 授權與試用

每個產品第一次使用時開始 30 天全功能試用。試用結束後，Toolkit 與 Runtime 轉為免費版，WapForm for Web 停止服務。
購買：[wapform.com/pricing](https://wapform.com/pricing)，序號會寄到你的 Email。
WapForm for Web：在伺服器本機開啟 `http://localhost/license.wml` 輸入序號。

## 上線前檢查

- 換掉所有模擬值：MySQL 帳號（`wapform.ini`、`server.js`）、後台帳號 `admin`／`123`、測試會員、`loginusr`／`loginpwd`。
- 填入你自己的 LINE 與 Gmail 設定（不要用範例值）。
- 刪除或修改範例商品、客戶與文章。
- 網站改用 HTTPS。

## 授權

本 repo 的範例檔案以 [MIT 授權](LICENSE) 釋出：可以自由複製、修改並用在你自己的專案，包括商業用途。
WapForm 產品本身（WapForm Toolkit、WapForm Runtime、WapForm for Web）是商業軟體，另行授權——
見 [wapform.com/tw/terms](https://wapform.com/tw/terms)。

---

文件與支援：[wapform.com](https://wapform.com) ·
[github.com/wapform](https://github.com/wapform) · Flutter 執行層：
[wapform_flutter](https://github.com/wapform/wapform_flutter)
