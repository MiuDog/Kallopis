# RC-V1-r1 結案驗證

日期：2026-09-14。**RUN-V1-02 與 FEAT-V1-03 已完成。** APP-V1-06 只完成 runtime 契約部分，其他模組介面仍待配對；composition 的 import-only 支援完成，COMP-V1-03 仍 planned。

## 交付與邊界

11 個 runtime 檔案已依 [路徑對照](path-map.json) 實體搬移：8 個通用介面／值／政策在 contracts，KlpTreeRuntime 與 KlpScopeBoundaryAdapter 在 compilation 根層，KlpDefaultPlacement 在 installation 根層。KlpInstallation 交易實作留在 internal。

features 15 個 Dart 檔、application 5 個 Dart 檔與組裝清冊、composition 2 個 Dart 檔同步新路徑。22 個呼叫端函式 body 與基線相同；runtime 的非 directive 內容僅正規化縮排。既有 API、28 個內建身分、組裝順序、交易／生命週期與 public barrels 不變；沒有舊路徑 forwarding 或重複型別。workspace adapter 四個相對匯入一併改為 package root，已消除上輪 import-root 失敗。

## 已執行驗證

| 群組 | 結果 | 證據 |
| --- | --- | --- |
| 19 份受影響測試 | 139 通過，exit 0 | 新路徑邊界、公開封閉、真實目錄、runtime／installation 交易、直接呼叫端及 consumer lint；integration-tests.log。 |
| application 與 import-root | 14 通過，exit 0 | router/session、application review、全 lib 跨目錄 root URI；application-import-root.log。 |
| 前端／模組架構 | 158 通過，exit 0 | 155 前端邊界與 3 模組文件；architecture-tests.log。 |
| runtime analyzer | 無問題，exit 0 | lib/src/runtime；runtime-analysis.log。 |
| 四個產品任務包 | 4／4 scope PASS | 真實隔離基線、精確 allowed_write、未追蹤檔；完整收據在 execution.json。 |
| 獨立測試保護 | PASS | 21 個變更檔與作者 SHA-256 逐檔相等；20 個既有測試／fixture 只改 URI，新 guard 一檔。 |

以上均為本輪完成版實測結果；不將重跑累加成新案例。

主要命令（在 D:/Projects/Kallopis-rc-integration 執行）：

```powershell
$rcRecord = Get-Content -Raw docs/architecture/runtime-contract-plan/execution.json | ConvertFrom-Json
$rcTests = ($rcRecord.checks | Where-Object name -eq affected_tests).files
& 'D:/flutter/bin/flutter.bat' test @rcTests --no-pub --reporter expanded
& 'D:/flutter/bin/flutter.bat' test test/lib_import_root_contract_test.dart test/klp_application_router_session_test.dart test/klp_application_review_test.dart --no-pub --reporter compact
& 'D:/flutter/bin/flutter.bat' analyze --no-pub lib/src/runtime
& 'D:/flutter/bin/flutter.bat' test test/frontend_architecture_boundary_test.dart test/module_architecture_contract_test.dart --no-pub --reporter expanded
```

結案文件經獨立唯讀查核：20 個新增／變更本機連結有效；已修正 README 將指派的 21 個既有檔誤寫成全部有路徑變更的措辭。實際為 20 個既有檔改 URI、1 個既有 fixture 核對不變，加上新 guard。

完整路徑、基線、scope 收據與保護 hash 在 [execution.json](execution.json)。原始派發包、等價證據及 log 保存於 `D:/Projects/Kallopis-rc-evidence`。

## 獨立測試的 Red → Green

作者在乾淨 PLAN 基線先執行不匯入搬移後產品型別的新 guard；跨模組 internal 匯入斷言失敗，其餘 3 項通過。這是確實存在的邊界違規，並非缺檔／編譯錯誤。四項檢查涵蓋真實 lib 指令、公開 library 的傳遞匯出，及相對／package／條件 URI 的負向控制；整合後同一保護檢查全部通過。

20 個既有檔案共替換 33 處 URI，原 101 個 test/testWidgets 宣告位置與 390 個 expect/expectLater 呼叫位置保留；這些是來源保留證據，不冒充執行案例數。未搬移的 KlpInstallation fixture 保持原內容。產品 worker 沒有修改測試要求、斷言、skip、fixture 行為或設定。

## 隔離與回寫

原工作樹包含大量既有變更，先保存原 HEAD／index hash，再建立包含其現況的隔離快照。各包以已接受 PLAN commit 及實際契約 hash 派發；composition 支援包在 runtime 提供者提交後重新簽發基線。只有模組自身來源可由各 worker 寫入，契約與文件由 Architecture Steward 維護。

回寫前逐檔核對最初 source hash；只複製本輪變更，精確刪除 11 個搬移前來源。原 HEAD、index 與其他未提交變更保留。實際傳輸檔案、前後 SHA-256 與整合 commit 記錄於 evidence 目錄的 transfer-receipt.json。

## 限制與下一步

[下一切片](../module-next-slices.md) 優先列 COMP-V1-03／RUN-V1-04 的自適應權責配對。FND-V1-03／FEAT-V1-04、在地化及 APP-V1-06 其餘介面維持原條件；本輪沒有將路徑整理當成循環相依全部消除。

未執行全庫測試、全庫分析、感官或 Krepis 保存驗收。現行 module contracts 與 consumer 指南已同步，生成式架構圖集保留原生成快照，沒有手改其舊 manifest／hash／行號來冒充重建。最初隔離時點已記錄，沒有供應者 token 統計；不將估算冒充量測。
