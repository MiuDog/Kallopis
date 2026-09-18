# CC-V1-r1 派工與整合驗證

日期：2026-09-14。結果：**COMP-V1-02、FND-V1-02、RUN-V1-03、FEAT-V1-02、APP-V1-03 均已完成**。剩餘 v1 工作見 [全模組下一切片](../module-next-slices.md)。

## 交付

| 責任 | 已整合成果 |
| --- | --- |
| composition | [內部建構契約](../../../lib/src/composition/registry/catalog-contract.md)，保留 KlpDefinition／KlpRegistry 與結構驗證。 |
| features | [權責清冊](../../../lib/src/features/catalog/component-ownership.json)：67 個匯出符號、24 個功能身分、21 個插槽、2 組舊版同名來源。 |
| application | [組裝清冊](../../../lib/src/application/bootstrap/internal/klp_application_catalog.json)：4 個結構身分與 15 筆組裝，聯集恰為 28 個內建身分；session 已移除空 components。 |
| runtime | update/context 不再有 components/compiler；registry 僅由 adapters.contract 建構；component adapter 退役。 |
| foundation | component definition、compiler 與專用 template slots helper 共三檔退役，未建立替代 compiler。 |
| 獨立 Test Author | [案例遷移矩陣](../../../test/support/closed_catalog_migration.md) 與清冊契約檢查，23 個測試／fixture／證據檔由作者發布保護 hash。 |

來源程式仍為權威，JSON 不在 runtime 載入。內建 adapter 組裝順序、公開 barrels、Stable 面、templates／bound/prepared 值與 Krepis 權威維持；本輪沒有執行後續契約路徑遷移。

## 實測結果

測試環境為隔離整合工作樹 `D:/Projects/Kallopis-cc-integration`，工具為 `D:/flutter/bin/flutter.bat`，使用現有相依與 `--no-pub`。以下列不同驗證群組，不將重跑累加成更多案例。

| 群組 | 結果 | 證據 |
| --- | --- | --- |
| 清冊／公開封閉／runtime | **38 通過，exit 0** | 最終同批重跑：6 清冊、23 公開封閉、9 runtime；primary-final.log。 |
| 16 份直接呼叫端 | **150 通過，exit 0** | 獨立作者整合驗證；test-author-m3-callers.log。 |
| application router/session 與 review | **13 通過，exit 0** | application-integration.log。 |
| 前端架構與模組文件 | **158 通過，exit 0** | 155 前端架構、3 module architecture；architecture-final.log。 |
| 五模組寫入邊界 | **5／5 PASS** | 每包以真正乾淨 Git 基線及未追蹤檔檢查，無越界。 |
| 獨立測試寫入邊界與保護 | **PASS** | 23 個檔案均符合 Test Author 精確範圍，整合 bytes 與最終保護 hash 相等。 |
| Runtime／application 局部分析 | **PASS** | 各實作者在其包範圍內執行；非全庫分析。 |
| import-root 既有閘門 | **FAIL，exit 1；派工前已存在** | 完成版與基線同一 workspace adapter 失敗，詳見下節。 |

主要重跑命令：

```powershell
& 'D:/flutter/bin/flutter.bat' test test/klp_application_catalog_contract_test.dart test/klp_closed_component_catalog_contract_test.dart test/klp_tree_runtime_test.dart --no-pub --reporter compact
& 'D:/flutter/bin/flutter.bat' test test/klp_application_router_session_test.dart test/klp_application_review_test.dart --no-pub --reporter compact
& 'D:/flutter/bin/flutter.bat' test test/frontend_architecture_boundary_test.dart test/module_architecture_contract_test.dart --no-pub --reporter compact
& 'D:/flutter/bin/flutter.bat' test test/lib_import_root_contract_test.dart --no-pub --reporter compact
```

16 份直接呼叫端的完整命令、參數化舊案例對照及退役理由列於作者矩陣。文件另經獨立唯讀查核，修正三處過時現況描述；修正後重新執行 3 項 module architecture 檢查通過（module-docs-final.log），不重複累加案例數。

原始 log 位於 `D:/Projects/Kallopis-cc-evidence`；[execution.json](execution.json) 保存各 log hash、執行基線、五包 scope 收據與全部測試保護 hash。

## 失敗分類與處理

- 整合初期新版清冊檢查的 AST helper 不符合本機 analyzer 10.1.0 API，屬於測試 setup 失敗。架構負責人只追加公開 AST API 讀取範圍，由同一獨立 Test Author 修復，保留清冊斷言；最終 6 項均通過。初次含此 setup 失敗的批次不記為整批 Green，後續已完整重跑 38 項。
- foundation 定義資料夾退役後，舊 frontend 檔案掃描對不存在目錄拋出例外。架構負責人精確擴充測試任務包，由獨立作者只刪除該目錄的列舉項目；沒有跳過缺少目錄或放寬結構斷言。完整 frontend 檢查通過。
- `lib_import_root_contract_test.dart` 因 `lib/src/features/workspace/components/internal/klp_workspace_components_adapter.dart` 四個 `../` 匯入失敗。相同測試在未整合產品的快照工作樹亦失敗；該產品檔與測試相較快照完全未改。這是**既有未解失敗**，沒有加入豁免或修改該檔，列入下一輪 features 有界任務。第一次「frontend＋import-root」整批為 155 通過／1 失敗，不能稱全綠；frontend 另於最終批次完整通過。

## 隔離、範圍與回寫

原 HEAD 為 `578d24ed111b95c429397b54245de09ade674704`。使用獨立 index 建立包含原有未提交／未追蹤內容的快照 `17216dcb4a7caa0dc32c0ae44d7c827b54fdf0e7`；從乾淨隔離工作樹派工，按上游整合內容重簽 packet。原目錄未全面 stage、reset 或提交。

原五份 JSON 為規劃紀錄；實際派發包保存於 evidence 目錄，其 hash 與真正執行 base revision 列於 execution.json。COMPOSITION／FOUNDATION 依序由主 agent 在各自範圍實作；features、runtime、application 與獨立測試角色分工作業。Architecture Steward 只進行配對整合、來源核對及契約結案更新，測試修復均退回作者。

回寫只使用本次差異路徑，先核對原工作樹逐檔 SHA-256 與最初保護基線，再複製整合 bytes 或刪除四個明確退役檔案；保留原 HEAD/index。詳細檔案與傳輸驗證記錄保存在 evidence 目錄的 transfer-receipt.json。

## 驗證限制

未執行全庫測試、全庫分析、感官驗收或 Krepis 正式保存驗收。既有 import-root 失敗仍存在，其餘後續架構欠債不在本輪完成宣告內。沒有取得供應者 token 統計，也未完整捕捉總開工時點；不將估算冒充實測。
