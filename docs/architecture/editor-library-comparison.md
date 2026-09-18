# 編輯器原型比較

2026-09-12。目標是降低筆記自研成本；此頁保留選型證據；使用者已同意採用 BlockNote，正式接入依 [KLP-0020](../../spec/decisions/KLP-0020-blocknote-editor-adoption.md)，尚未完成遷移。原型位於 `tool/editor_comparison/`，沒有替換 Kallopis／Krepis 產品。

## 實際版本與整合成本

| 項目 | BlockNote | AppFlowy Editor |
|---|---|---|
| 來源 | registry 0.54.2；package-lock.json 固定依賴 | pub 6.2.0 不相容本機 Flutter 3.44.2；改用官方 commit 01eccc6ee36bd07698bd80915289fe7070478cd2，pubspec.lock 固定 |
| 技術 | React／Vite，本次瀏覽器驗證 | Flutter，本次只驗 Web build，未驗 Windows 原生 |
| 初次障礙 | Mantine peer version 配對；用原生 light theme 避免宿主色彩不一致 | 正式套件未實作 TextInputClient.onFocusReceived；官方上游已修，不 fork／改上游 |
| 保存 | 原型以 localStorage 保存原生文件 JSON | 原型以 shared_preferences 保存原生文件 JSON |

保存按鈕是原型接線，不代表套件附帶完整文件管理、同步、備份或 production 保存保證。兩邊保留上游 UI；沒有把操作搬回 Krepis，也沒有雙文件模型同步。

## 本次操作證據

由 Codex in-app browser 操作 localhost，不把 compile 當 runtime，不把 Unicode 插入當注音組字測試。

| 案例 | BlockNote | AppFlowy Editor |
|---|---|---|
| 中文、粗斜體、標記、兩層清單 | 已呈現 | 已呈現 |
| Enter 新清單項 | 已觀察新增項與文字 | 未啟用 Flutter accessibility 語意層後，已觀察新增項與文字 |
| Tab 縮排／Ctrl+Z 撤銷 | 已觀察第二→第三層，再恢復第二層 | 未判定；操作受到焦點／組字狀態干擾，不當作套件缺陷 |
| 表格 | 已呈現，直接點入儲存格追加文字及撤銷通過 | 已呈現，儲存格編輯未驗 |
| 本地圖片 | 已呈現 | 已呈現；使用同源絕對 PNG URL，相對路徑會走檔案分支 |
| 保存→修改→重開 | 已恢復原存檔 | 已恢復原存檔 |
| 瀏覽器重載存檔 | 已恢復 | 已恢復 |
| 400 段中文長文 | 已載入，AX 有第400段 | 已載入並捲到第400段 |
| 真正中文 IME、跨區塊貼上、讀屏、手機 | 未完成 | 未完成 |

長文僅是基本載入觀察，沒有延遲／記憶體基準。AppFlowy 啟用 Flutter Web accessibility 後，這次自動操作無法讓正文取得輸入；重載且不啟用後可輸入，仍需真實平台確認。BlockNote 曾用自動 selectText 選表格文字造成非預期儲存格選取；改用直接點儲存格後可正常編輯，未將自動化選取異常判成產品bug。

## 初步選擇

若可接受 Web 編輯區，先以 BlockNote 作候選：此環境正式套件直接可用、預設操作通過較多。若 Flutter 原生是必要條件，保留 AppFlowy，但需先通過 Windows 原生與微軟注音案例，並承擔官方未發布 commit 的更新成本。不能用 Flutter Web 的結果直接推論 native 好壞。

下一步只補決策必要差異：兩邊微軟注音／跨區塊貼上，AppFlowy Windows 原生；若選 Web，再验证 Flutter WebView 焦點／剪貼簿／檔案。選定前不 fork、不移植全文字模型、不擴大自研功能。手寫與 Spatial 不在本次兩個原型驗收內，Excalidraw／BlockSuite 保留後續選型。

## 入口與來源

- 原型：[啟動說明](../../tool/editor_comparison/README.md)
- [BlockNote 官方起步](https://www.blocknotejs.org/docs/getting-started)、[保存範例](https://www.blocknotejs.org/examples/backend/saving-loading)
- [AppFlowy 正式套件](https://pub.dev/packages/appflowy_editor)、[採用的官方 commit](https://github.com/AppFlowy-IO/appflowy-editor/commit/01eccc6ee36bd07698bd80915289fe7070478cd2)