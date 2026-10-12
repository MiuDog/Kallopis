# 跨框架整合驗證

日期：2026-10-12。此紀錄只報告實際觀察；視覺品質與操作手感仍由使用者接受。

## 已完成

- 正式通用視覺規範依責任分章；原 primitive、semantic、recipe 數值與配方保留，Markdown 為唯一權威。
- Docs 網站直接讀取正式來源，提供表格、章節連結及全文搜尋；React 產品指南接入同一網站。
- Flutter 完整套件移至第一層 `flutter/`；React 核心庫位於第一層 `react/`。未修改其他產品 repository，也未發布套件或部署網站。
- React 提供 Provider、語意 hook、Text、Surface、Card、Badge、Button、IconButton、TextField、Frame、Workspace、FileExplorer 及真實 consumer 展示。

## 程式證據

| 檢查 | 觀察 |
| --- | --- |
| Flutter 搬移對照 | 1116 檔內容不變（只忽略 CRLF／LF 差異）；另外5檔僅調整共通 spec／docs 相對路徑，包含2個測試及3個工具；元件 source 與資產不變 |
| Flutter 依賴及分析 | pub get 成功；搬移前、後 analyze --fatal-infos 均無問題；本機 Flutter 3.44.2／Dart 3.12.2 |
| Flutter inventory | 搬移前已過期；由實際 source 重新產生後 --check 通過 |
| Flutter package 既有 tests | 398 通過、2失敗；兩項失敗已在搬移前主工作樹重現，期待與實際色值相同 |
| Flutter example 既有 tests | 12通過、3失敗；三項 Catalog 失敗已在搬移前重現 |
| Flutter API extraction | 新目錄成功解析519個 canonical 公開宣告，17個 module、3個公開 surface |
| Docs tests | 15項通過；獨立 Test Author 的測試與 fixture 未改動 |
| Docs generate／verify | 成功；正式來源、頁面、搜尋正文及內部連結通過驗證 |
| React generate／check:tokens | 269 primitive、350 semantic × 4主題、118 recipe；含來源 SHA256 與內容新鮮度檢查 |
| React tests | 15項獨立契約測試全數通過；原3檔測試 SHA256 未改動；Test Author 再驗證取得 Green |
| React library／example build | ESM、TypeScript宣告、樣式及字型建置成功；展示頁型別檢查及 production build 成功 |
| 外部 consumer | 從實際 npm pack 的套件檔安裝至獨立暫存專案；只用公開 import、樣式與型別，TypeScript及Vite建置成功，沒有 source alias |
| 套件資產 | tarball 包含自有字型與授權；瀏覽器觀察 Noto Sans TC、IBM Plex Mono 的 package font 資源已載入 |

## 實際畫面與操作

桌面及390×844窄畫面已檢查，窄版沒有水平溢出。實際操作已確認四模式切換、文字輸入、主要動作計數、Explorer Enter選取與受控回呼；瀏覽器未記錄 error／warn。Docs 已確認正式表格、token內容搜尋與窄版橫向表格區域。

這些是渲染及行為觀察，不代替感官品質的人類接受。透明模式依宿主背景呈現；原生視窗效果由宿主提供。

## 保留的既有失敗

- `interaction_state_discipline_test.dart`：一般 icon button hover 預期較淡色，現存 source 顯示較深色。
- `klp_icon_button_tone_test.dart`：inline hover／focus 同一色值差異。
- `catalog_coverage_test.dart`：未分類 `KlpDeviceAdaptive`／`KlpSlidingDrawerLayout`；`KlpPanelFrame raised` 被當成不存在型別，亦缺風格追蹤資料。

搬移沒有修改這些元件行為、斷言或 baseline；兩組失敗在搬移前後相同。若接續修復，應先依已確認視覺與測試契約處理，不以弱化測試通過。

## 接入提醒

Flutter 產品的 path dependency 改指向 `D:/Projects/Kallopis/flutter`，或同等相對路徑。React 使用方式見 [產品指南](../ai/react-usage.md)。核心配方完整可查，但此版不宣稱全部 Flutter 元件已有 React 等價元件。
