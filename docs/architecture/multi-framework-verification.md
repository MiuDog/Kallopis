# 跨框架整合驗證

此紀錄只報告實際觀察；視覺品質與操作手感仍由使用者接受。

## 2026-10-13 發布整合驗證

使用者已授權整合 `main`、修復發布 CI 並發布 README／參考網站。`main` 整合提交為 `72eb4f0f`，保留主目錄既有未提交內容；修復使用隔離 checkout。公開 Flutter theme／foundation API 與 React import 入口保持原契約。

| 檢查 | 本次觀察 |
| --- | --- |
| React freshness | 只刷新兩個來源 manifest；269 primitives、350 semantics × 4、118 recipes 的值未變，原 check:tokens 通過 |
| React 套件／consumer | 177 項 tests 通過；公開 package 與 example production build 成功 |
| Flutter SDK 測試遷移 | 獨立 Test Author 保留原 assertions、test names、fixture；157 項對應 tests 通過，fatal-infos 分析無問題 |
| Flutter 套件 | 完整 639 項 tests 通過；fatal-infos analyze 無問題，inventory 由真實 source 生成並通過 --check |
| Flutter example | 完整 54 項 tests 通過；fatal-infos analyze 無問題，release Web build 成功；Catalog 修復不計入專屬原生驗證數量 |
| 公開 API extraction | 561 canonical declarations、17 modules、3 surfaces；enum 改為同 theme module 的 leaf，原公開匯出保持 |
| 純 Node 網站檢查 | 原 15 項及 extractor 4 項通過；React specimen／雙框架場景的 22 項檢查通過，公開 React 清單為 23 個元件 |

修復切斷 theme builder／pack 的 import cycle，恢復 icon hover 使用共用 selection wash，Dock 由 State 擁有 protected rebuild；開發者錯誤訊息、配方 metadata 與動態 chord deadline 不新增使用者文案或動畫預設值。所有原 CI 閘門、assertions、baseline 與 golden 保留。

完整 Workbench 功能目標仍未關閉：Flutter 尚未完成全部 273 個專屬展示的原生驗證，柔和按鈕與 8px 總間距、完整窄瀏覽器及風格矩陣仍依交接接續。GUI 的正文、程式碼、3D 與終端為明示示意。公開發布結果以 [PR #19](https://github.com/MiuDog/Kallopis/pull/19) 與 GitHub Actions 實際狀態為準；本機通過不等於遠端部署成功。

## 2026-10-12 搬移與初次接入紀錄

以下是當時已觀察的歷史範圍與失敗，不代表本次發布整合的最新檢查結果。

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
