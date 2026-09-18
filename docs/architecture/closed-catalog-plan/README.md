# 封閉目錄配對計畫

狀態：**CC-V1-r1 已派工、整合完成。五個切片均已 complete。**

契約版號：`CC-V1-r1`，2026-09-14。權威為 [共通規格](../../../spec/module-architecture-v1.md#closed-catalog-completion-contract--cc-v1-r1) 及五個 module 的 `architecture.md`；本目錄固定派工邊界與整合方式，不另建產品規格。

## 共同成果與決策

使用端仍只組合本庫節點。application 提供完整內建轉接器清單，runtime 只從這些轉接器建立 registry；舊 `components`、`KlpComponentAdapter`、`KlpComponentCompiler`、`KlpComponentDefinition` 退役。現有內建節點、結構擷取、語意驗證、交易與租約行為保留。

`KlpDefinition`／`KlpRegistry` 必須保留套件內建構能力；它們本來就是功能轉接器與結構驗證所需介面。封閉的是受支援使用端入口，不以 Dart 私有命名或合併成巨大 library 阻止套件內呼叫。composition 不新增 feature 名單，也不匯入 runtime adapter。

清冊採兩份 JSON：features 掌管功能宣告／身分資料；application 引用 features 檔，補上結構節點及實際組裝順序。來源程式仍為權威。否決新增執行期 catalog 服務、反射探索及複製兩份完整清冊：它們會擴大本次 API 與同步成本。欄位定義集中於共通規格，不由 worker 自行決定。

## 需求與責任對照

| 需求 | 責任／現有介面 | 配對切片 | 完成證據 |
| --- | --- | --- | --- |
| API-P1-03：有限且本庫擁有的擴充 | composition 定義／registry 邊界；application 零參數組裝 | COMP-V1-02、APP-V1-03 | 公開負向編譯控制組正常；未知身分在安裝前拒絕 |
| API-P1-04：一個現行權威來源 | features 權責清冊與 application 清冊聯集 | FEAT-V1-02、APP-V1-03 | 每個身分一份宣告／adapter 組態；缺漏、額外項目、重複與錯誤權責可被檢查拒絕 |
| ARCH-P1-03：明確相依與介面 | runtime adapters → composition contracts；foundation 舊編譯器退役 | RUN-V1-03、FND-V1-02 | 無舊元件輸入／編譯器引用，runtime 不新增上層匯入 |
| MIG-P1-01：相容性與資料權威 | 現有內建節點、語意 resolver、交易、Krepis 邊界 | 五切片共同整合 | 受影響交易／內建組合檢查通過；Stable／引擎／公開匯出未變 |
| TEST-P1-02/03：確定性證據 | 獨立 Test Author，既有局部行為檢查 | TEST-CC-V1-01 | 舊案例對照、測試 hash、有效 Red 或明示 integration-pending、整合 Green |

這是目前 v1 的收尾，不建立新 stage。其他切片只保留目錄：RUN-V1-02、STYLE-V1-03、CAP-V1-02、在地化配對及 P9 相容清除。

## 任務包與唯一寫入者

| 任務包 | 角色／唯一 module | 成果與寫入範圍 | 前置／配對 |
| --- | --- | --- | --- |
| [COMP-V1-02](COMP-V1-02.json) | composition BUILD（文件） | `registry/catalog-contract.md`：建構及整合驗收邊界 | 已接受 CC-V1-r1；結案待共同證據 |
| [FEAT-V1-02](FEAT-V1-02.json) | features BUILD | `catalog/component-ownership.json` | 已固定欄位；需 Test Author 核對 |
| [APP-V1-03](APP-V1-03.json) | application BUILD | adapter 目錄、catalog JSON、session commit 共 3 檔 | 清冊完成需要 feature 清冊；簽名遷移配對 RUN |
| [RUN-V1-03](RUN-V1-03.json) | runtime BUILD | update/context 兩檔及退役 component adapter | 與 APP、FND、測試同批整合 |
| [FND-V1-02](FND-V1-02.json) | foundation BUILD | 退役 definition、template slots helper、compiler 共 3 檔 | 刪除前確認 RUN／測試遷移已可整合 |
| [TEST-CC-V1-01](TEST-CC-V1-01.md) | 獨立高階 Test Author | 既有測試遷移、清冊契約檢查及案例對照 | 不讀 implementation worker 推理；不改產品／架構 |
| 整合與結案 | Architecture Steward | 接收有 scope 證據的模組結果、重簽基線／契約、更新狀態 | 不代替 worker 跨界修碼；無需新增模組 |

JSON 任務包符合既有 BUILD schema：`allowed_read` 對應模板的 `read_paths`、`allowed_write` 對應 `write_paths`。Test Author 是測試角色，不套用強制要求 `test/architecture.md` 的產品 BUILD schema，也不建立第十個 module。

## 本輪採用的執行與整合順序

1. 架構負責人核對 CC-V1-r1 與任務包 hash、保存現有工作樹，再準備乾淨隔離基線。不得用 reset、清除或全面 stage 改動使用者工作樹。
2. Test Author 先固定案例遷移矩陣、清冊檢查與風險保護；composition 完成文件邊界。features 可建立清冊，application 可核對既有組裝。這些工作沒有寫入路徑重疊，但不要求同時派多個 agent。
3. features 清冊與 Test Author 產物交接後，重簽 application packet 的輸入／基線。application 完整清冊依賴的是 feature 清冊內容，不是虛構的模組層級順序。
4. RUN、APP session 呼叫端、FND 刪除及測試調整作為一個整合批次。可分支實作，或由同一 agent 分角色依次實作；任何 worker 都只寫自己的路徑。FND 刪除沒有必要先於 RUN；最終整合不得殘留舊呼叫。
5. 所有配對變更就位後才取整合 Green。中途少一個 named parameter 或找不到退役檔案，只是尚未完成整合，不能當成預期行為 Red。若需修碼，退回所屬任務包，不能由整合者任意修改其他模組。
6. 各 worker 通過 scope gate，整合者確認共同證據後才更新五份 architecture 狀態；composition 的文件交付不等於整組完成。

`RUN-V1-02` 不在上述前置。應在這批簽名變更完成後另行配對規劃；不要同時搬同一批 runtime 檔案。

## 派工基線與執行紀錄

本輪從含既有未提交／未追蹤內容的工作樹建立隔離快照 `17216dcb4a7caa0dc32c0ae44d7c827b54fdf0e7`，再按上游成果重簽各 worker 基線。五個產品任務包均經實際 Git 差異 scope checker 通過。獨立 Test Author 的 23 個檔案另有逐檔 SHA-256 與案例矩陣。

本目錄五份 JSON 是原始**規劃紀錄**，保留當時 HEAD／契約 hash，不能在已完成工作樹直接重跑。實際派發版、乾淨基線、scope 收據、保護 hash 與整合結果列於 [execution.json](execution.json)；原始派發包及 log 保存在 `D:/Projects/Kallopis-cc-evidence`。後續工作須使用新切片任務包，不以重簽舊 packet 重新執行已完成的刪除。

## 已完成成果

- composition 保留套件內建構能力並交付 [catalog-contract.md](../../../lib/src/composition/registry/catalog-contract.md)。
- features 清冊涵蓋 67 個匯出符號、24 個功能身分；application 補齊 4 個結構身分與 15 筆組裝。聯集與實際轉接器展開完全相等，共 28 個內建身分。
- runtime 僅以 adapters 的 contract 建構 registry；application session 不再傳 `components`。
- foundation 三個舊 definition/compiler/helper 檔及 runtime component adapter 已退役；保留 templates、bound/prepared 值及 Stable 相容面。
- 舊測試由獨立 Test Author 對照保留行為遷移；專屬已退役編譯器的案例逐項說明退役原因。測試 adapter 未複製 compiler。

## 驗收與已知限制

清冊、公開封閉、runtime、直接呼叫端與 application 整合檢查均通過；五模組 scope gate 通過。完整結果、命令、測試 setup 修復與原有匯入閘門失敗見 [verification.md](verification.md)。

原有 `lib_import_root_contract_test.dart` 在隔離基線及完成版均因同一 workspace adapter 的四個跨目錄相對匯入失敗；該產品檔案未改動。本輪沒有加入測試例外、skip 或放寬規則，也不將其列為 Green。後續目錄見 [全模組下一切片](../module-next-slices.md)。
