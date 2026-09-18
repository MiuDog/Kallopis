# Runtime 契約路徑配對（RC-V1-r1）

狀態：**RC-V1-r1 已派工並整合完成。RUN-V1-02／FEAT-V1-03 complete；APP-V1-06 僅完成 runtime 部分。**2026-09-14。承接完成的 CC-V1-r1，實作 RUN-V1-02／FEAT-V1-03 與 APP-V1-06 的 runtime 部分。Architecture Steward 已自動接受本次可逆路徑選擇；產品行為、公開 API、28 個目錄身分與順序不變。

## 介面與責任

以 [path-map.json](path-map.json) 的 11 個精確來源／目標為準。8 個可供套件內跨模組使用的介面／值／政策移至 runtime/contracts：KlpNodeAdapter、KlpPrepareContext、KlpPreparedNode、KlpPreparedActivationPolicy、KlpPreparedResourcePolicy、KlpRuntimeFrame、KlpPlacementResource、KlpInstallationException。

KlpTreeRuntime 與 KlpScopeBoundaryAdapter 是 application 使用的既有組裝入口，移至 compilation 根層；KlpDefaultPlacement 是現有 adapter 使用的具體預設資源，移至 installation 根層。它們不是抽象 contracts，不建立轉匯出假介面。KlpInstallation 交易演算法仍留在 installation/internal；所有 src 路徑仍對 consumer private，沒有新增任何公開 library 匯出。

採用實體搬移與直接匯入新路徑，不保留舊路徑 forwarding、別名、重複型別或新增 service。保留每個宣告與行為；只更換 import URI，必要時跨目錄改為 package root。否決只用 barrel 掩蓋 internal 依賴，因為權責仍無法從宣告路徑辨識；否決抽取新的 runtime 介面／服務，因為本輪沒有可變實作需求。

## 分工與配對

| 包 | 唯一寫入 module | 結果 |
| --- | --- | --- |
| RUN-V1-02 | runtime | 11 個來源搬移及本模組相依更新，KlpInstallation 留內部。 |
| FEAT-V1-03 | features | 15 個直接呼叫檔改新 runtime 路徑；workspace adapter 四個既有相對匯入同步改 package root。 |
| APP-V1-06-RUNTIME | application | 5 個 Dart 呼叫檔與組裝清冊 runtime source_path 同步；只完成 APP-V1-06 的 runtime 部分。 |
| COMP-RC-V1-01 | composition | 兩個既有自適應實作僅改 runtime import；不搬適配實作、不完成 COMP-V1-03。 |
| TEST-RC-V1-01 | 獨立 Test Author | 20 個既有測試／fixture 路徑同步，另 1 個既有 fixture 核對不變；新增一個跨模組路徑／公開可達性 guard，既有交易與目錄斷言不改。 |

以上支援包是本次遷移的配對交付，不建立新 stage 或新 module。確切路徑由 path-map 及隔離 worktree 的外置簽署 Task Packet 固定。產品 worker 不能改 test、architecture、共通規格或其他 module。跨模組純引用遷移也須依所屬者分包。

APP-V1-06 尚含 composition/features 的具名契約責任，不能因 runtime 部分完成而整項結案。COMP-V1-03／RUN-V1-04 自適應權責搬移與 RUN-V1-05 styling 路徑不在本輪；不藉機改變六個既有循環。

## 驗收與證據

- 新路徑保有原型別身分／API／演算法；舊 11 路徑不殘留 shim；application/features/rendering 不再直接匯入 runtime internal。composition 配對檔同樣改新路徑，但保留既有延期的向上責任。
- 所有公開 barrels 不變；不得讓 consumer 使用 runtime API。獨立檢查以 package 匯出可達性及跨模組 source directives 觀察邊界，不以單純缺檔編譯失敗當有效 Red。
- 真實 application 28 個 adapter 與 metadata 仍相符；交易、reuse、rollback、lease 與 application session 的既有檢查通過。
- 既有 import-root 失敗須消除，不能加豁免。清冊、上層匯入、搬移後的直接呼叫端驗證必要；不用全庫測試代替局部風險。
- 測試作者先發布保護 hash，再整合；產品 worker 不修改測試要求。每模組執行真實基線 scope gate。

## 基線、估算與整合

使用含現有工作樹的獨立快照，不 stage/reset 原目錄。外置執行包記錄本輪 PLAN commit、architecture 與共通規格 SHA-256、精確 read/write 範圍。提供者與呼叫端採同一 integration batch，缺少其一只能記 integration-pending。

估算採 cold-start：各產品包約 2,000–8,000 token、10–45 分鐘；測試約 4,000–10,000 token、15–60 分鐘。同模型設定、Windows/PowerShell、D:/flutter/bin/flutter.bat 與已安裝相依。參考 CC-V1-r1 的 scope/整合方式，因未取得其可靠 token 統計，不冒充量測估算。里程碑為完成路徑替換並檢查內容等價、通過 scoped verification 後發布結果；超過各上界 1.5 倍或任何越界即回報。

完成與實際執行證據見 [verification.md](verification.md)／[execution.json](execution.json)。

## 文件權威

path-map 的 documentation_paths 是舊引用的檢索清單。現行 consumer runtime 文件同步新來源；自動生成的整套 docs/architecture/src 圖集保留原生成快照，未手改其 manifest、行號或 SHA-256 來冒充重新生成。現行責任與路徑以 module architecture、RC-V1-r1 與 path-map 為準；全圖集重建屬獨立產物刷新。原 CC-V1-r1 的歷史包／hash／遷移矩陣不回寫成新路徑。
