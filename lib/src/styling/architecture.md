# Styling 模組架構

FRAME-8-R1：本輪接受的 [8px／微立體契約](../../../spec/frame-relief-8px.md) 配對 features/rendering。`presets/klp_frame_relief_recipe.dart` 擁有純 Dart 陰影、亮邊與距離比例，從已解析 surface／shadow 產生色彩；primitive 表不变，無 Flutter 或 features 反向相依。

Status: PLAN READY — v1 宣告式邊界已記錄；舊版相依技術債限於相容範圍

依據：[模組登錄表](../architecture.md)、[模組架構 v1 規格](../../../spec/module-architecture-v1.md)、[樣式 v1](../../../spec/style-v1.md)

## 目的

`styling` 掌管 Kallopis 樣式詞彙與意義。現行宣告式路徑定義固定 primitive schema、具型別參照、語意鍵／token、程式庫所屬預設組與私有解析。它是供 composition、features、runtime 與 rendering 使用的 L1 權威，不允許這些模組或使用端建立另一個樣式來源。

## 非目標

- 渲染 Flutter widget 或選擇產品專屬呈現。
- 使用端局部備援值、任意 token 集合，或個別元件的主題注入。
- 元件結構、插槽、狀態、應用生命週期或產品資料。
- 將舊版 `ThemeExtension` API 視為宣告式 schema 的擴充。

## 目標階段與能力範圍

目前目標階段：為架構 v1 明確區分宣告式與相容樣式路徑，同時讓新使用端收斂至單一有限的宣告式來源。語意定義仍由程式庫掌管，不納入使用端匯出入口。

目前能力範圍：

- 單一固定 primitive schema，僅能在應用根節點整套替換。
- 具型別的 primitive 與語意參照，在渲染前驗證。
- 單一程式庫所屬解析器，以及不可變的解析結果。
- 由程式庫預設組提供完整支援樣式，不需使用端自訂預設值。
- 隔離舊版 Flutter 主題相容性，直到 KLP-0019 P9。

此範圍不授權動態 token 註冊、第二份主題環境，或立即移除 Stable 舊版 API。

## 所屬路徑與公開介面

所屬路徑：

- 現行宣告式路徑：`primitives/`、`references/`、`semantics/`、`resolution/`，以及 `presets/` 中非舊版的項目。
- 相容路徑：`legacy_tokens/`、`legacy_theme/` 與 `presets/legacy/`。

透過 `kallopis_declarative.dart` 公開：

- Primitive 索引、集合、種類與值型別。
- 程式庫所屬的工作區預設組。

僅供程式庫內部使用：

- 程式庫所屬定義使用的具型別樣式參照，以及語意鍵、token 與 schema。
- 語意解析器與不可變解析細節。
- 用來產生受支援值的預設配方。

僅透過 `kallopis_theme.dart` 提供相容性：

- 舊版 token、`KlpTheme`、主題作用域、視覺樣式 JSON 與 ThemeExtension 模型。

相容路徑不是另一個宣告式元件／樣式來源，不能注入宣告式樹。

## 責任分布與相依方向

| 區域 | 責任 | 相依方向 |
| --- | --- | --- |
| `primitives` | 固定的具型別值與完整 primitive 集合。 | 僅 kernel 診斷。 |
| `references` | 指向 primitive 索引或語意鍵的封閉具型別參照。 | Primitives 與 semantics 契約。 |
| `semantics` | 穩定語意鍵／token／schema 與識別碼驗證。 | Kernel 與 primitive／reference 契約。 |
| `resolution` | 具名語意圖驗證與解析契約，產生不可變值。 | 僅 kernel 與現行 styling 契約。 |
| `presets` | 提供完整、由程式庫掌管的 primitive／樣式配方。 | 僅現行 styling 契約。 |
| `legacy_*`、`presets/legacy` | 保留既有 Flutter 主題行為直到 P9。 | 可使用 Flutter 與本模組 `legacy_metrics/klp_metrics.dart` 唯一度量；不得供給現行宣告式路徑。 |

舊版主題的兩個度量匯入已由 METRICS-V1-r1 改用本模組 `legacy_metrics`；完整 styling 不再相依於 foundation。Stable 主題相容介面的移除仍受 P9 閘門約束。

## 不變條件、生命週期與錯誤權責

- Primitive 結構由 Kallopis 固定。使用端替換完整集合；不得附加鍵，或在集合外覆寫單一值。
- 語意意義由具型別鍵與程式庫所屬 schema 識別。渲染器不能從 primitive 位置或字面值推斷意義。
- 值到達渲染前，解析器輸入必須完成驗證。缺少參照、種類不符與循環會產生具穩定代碼的 `KlpContractError`。
- 元件與渲染器程式碼使用已解析的語意值，不掌管備援樣式值。
- 預設組是不可變輸入。Styling 不掌管可變的全域登錄表，也不掌管個別畫面的樣式權威。
- 舊版 Flutter 主題生命週期留在相容介面內；不得成為宣告式 primitives、semantics 或 resolution 的相依。

## 允許與禁止的相依

現行路徑允許：

- Dart SDK 與 L0 kernel。
- 現行 styling 區域內的匯入。

僅舊版相容隔離區允許：

- Flutter foundation／widgets／material。
- 幾何／表面只使用本模組 legacy_metrics；foundation 舊入口向下轉匯出至 P9。

禁止：

- `application`、`capabilities`、`composition`、`features`、`rendering` 或 `runtime` 實作。
- 產品主題、產品標籤、產品狀態或持久化。
- 使用端提供的解析器回呼、局部預設值對照表或任意語意註冊。
- 現行宣告式程式碼匯入任何 `legacy_*` 路徑。

## 採用設計與否決方案

採用：封閉的具型別 primitive／schema 值，加上私有解析器。這讓 Kallopis 能在渲染器取得值之前，驗證樣式完整性與語意參照種類，同時保持使用端介面有限。

否決：開放的字串鍵對照表與使用端所屬備援回呼。這會讓每個使用端成為樣式權威，妨礙完整驗證，並允許重複的元件預設值。

v1 否決：將舊版 ThemeExtension 類別合併至宣告式 schema。這會讓 Flutter 滲入現行純 Dart 契約，並無限期保留兩套同義的自訂系統。

## 目前階段切片

| 切片 | 成果 | 允許路徑 | 驗收證據 | 狀態 |
| --- | --- | --- | --- | --- |
| `STYLE-V1-01` | 建立本受保護契約，並分類現行與舊版相依。 | `lib/src/styling/architecture.md`、模組登錄表狀態 | 匯入清冊證明現行路徑只相依於 kernel；公開匯出入口區分宣告式與舊版型別；反向 foundation 匯入已列為相容技術債。 | complete（已完成） |
| `STYLE-V1-02` | 在儲存庫視覺測試退役期間，保留確定性的 primitive／schema／解析器檢查，並移除 golden 外觀權責。 | 由獨立測試切片指定的測試所屬路徑；預設不含產品路徑 | 必要 styling 測試不使用像素基準；種類、完整性、循環與語意解析行為持續有確定性檢查。 | complete（已完成） |
| `STYLE-V1-03` | 為 composition 提供具名的套件內部語意圖驗證介面，不向使用端匯出解析器實作。 | `lib/src/styling/resolution/**`、直接相關模組文件 | Composition 無須匯入另一模組的 `internal/` 路徑即可驗證語意相依；使用端公開匯出維持不變。 | complete（SEM-V1-r1 已整合） |
| `STYLE-V1-04` | 關閉使用端語意定義能力，同時保留完整 primitive 集合選擇。 | `lib/kallopis_declarative.dart`、公開介面文件與獨立編譯契約 | 使用端可建構完整固定 primitive 集合，但不能建構樣式參照、語意鍵／token／schema 或第二份解析器輸入。 | complete（已完成） |

`STYLE-V1-02` 屬於儲存庫測試政策遷移，必須由其測試作者任務掌管，不得由 styling 產品 BUILD worker 掌管。

`STYLE-V1-02` 冷啟動估算：4,000–8,000 個模型 token 與 25–60 分鐘。沒有可比較的已結案任務登錄紀錄。里程碑為測試分類、保留確定性覆蓋，以及基準退役；若超過 12,000 個 token 或 90 分鐘，需設檢查點並縮小證據範圍。

### 語意驗證介面配對（SEM-V1-r1）

已接受共通規格SEM-V1-r1與 [精確範圍](../../../docs/architecture/semantic-module-plan/README.md)。composition只呼叫具名驗證操作，runtime與features使用明確解析契約路徑；styling維持唯一驗證／解析規則與錯誤。沒有consumer匯出或default變更。


SEM-V1-r1 已整合：39 項獨立邊界／語意圖與保留的綁定／rail／shadow 測試、18 項目錄／runtime／frame／import-root 測試通過；局部分析無問題。解析器搬移保持演算法等價，公開匯出不變。見 [驗證紀錄](../../../docs/architecture/semantic-module-plan/verification.md)。

## 驗收證據與測試狀態

2026-09-14 已觀察：

- 現行宣告式 styling 透過 `kallopis_declarative.dart` 匯出五個來源契約／預設組：四個固定 primitive 家族與一個程式庫所屬工作區預設組。
- 現行 primitive、reference、semantic、resolution 與工作區預設組檔案，只匯入 kernel 或其他現行 styling 檔案。
- 舊版主題與 token 檔案匯入 Flutter；兩個舊版主題檔已使用本模組 legacy_metrics，完整 styling 不再依賴 foundation。
- `kallopis_theme.dart` 只匯出舊版樣式家族；宣告式匯出入口只提供固定 primitive 選擇與程式庫所屬預設組，語意定義留在內部。

測試狀態：

- Green 範圍：宣告式公開匯出入口已不再匯出樣式參照或語意定義型別；獨立編譯覆蓋是本次僅涉及公開介面變更的驗收閘門。
- Yellow 範圍：已直接檢查匯入與匯出權責。
- Red 範圍：無。
- 待人類確認的視覺證據：本架構切片無此項；未來外觀變更需在必要測試之外交由人類審查。

## 受保護路徑

- `lib/src/styling/architecture.md`
- `test/klp_primitive_contract_test.dart`
- `test/klp_semantic_contract_test.dart`
- `test/klp_style_compile_contract_test.dart`
- `test/klp_style_registry_test.dart`
- `test/primitive_token_ownership_test.dart`
- `test/token_discipline_test.dart`
- 確定性的 primitive、schema、解析器、權責與紀律檢查；golden 路徑與 PNG 基準已退役。

### 具名下層契約配對（LOWER-V1-r1）

LOWER-V1-r1：CAP-V1-02 與 REND-V1-04 配對，71 個既有檔案實體移至具名路徑；全部名稱、constructor、預設值、演算法、狀態與 callback 身分不變。Provider 42 個 editing export 與 9 個 part 移至 editing/contracts，根入口原 44 個 export 的符號可達性不變。draw_command_validation 留 internal，不新增公開；block_drop_preview 仍非公開，drop_target 與 editing_submission 為 editing/ 下具名套件內入口，保留整體演算法及狀態。Foundation 15 個通用 binding 檔案含 11 part 移至 binding/contracts，維持同 library、abstract KlpBoundTemplate 與非 consumer 公開協定；此條明確接替 PRES-V1-r1 的「路徑保留」，其名稱、constructor、模組責任與原行為仍保留。Styling 的 paper_shadow_recipe 與 control_density 移至各自具名入口，值與唯一來源不變。所有直接呼叫端與測試 URI 配對更新，不留 shim、不新增 export。完整 rendering 的 import/export/part/part-of/conditional 指令不得跨到任何其他模組 internal；不能只檢查 capabilities/foundation。維持 26 renderer 分支、28 catalog ID、未知類型拒絕、同模組 reciprocal part、Stable 與 provider 可達性。編輯 pending/resync、save job/confirmed revision、手寫生命週期與上游正文／undo 權威不變。CAP-V1-03 舊正文分類、FND-V1-05 metrics、host 與剩餘 APP-V1-06 不藉此宣告完成。

精確本模組範圍與派工條件見 [配對計畫](../../../docs/architecture/lower-contract-plan/README.md)。LOWER-V1-r1 已整合：71 個原始檔實體搬移與 57 個直接 caller（共 128 個來源）正文／指令身分等價；7 個 module scope、局部分析與獨立整合測試通過。Provider 公開身分不變，完整 renderer 無不允許的跨模組 internal 指令。見 [驗證](../../../docs/architecture/lower-contract-plan/verification.md)。

### 舊度量來源配對（METRICS-V1-r1）

METRICS-V1-r1：FND-V1-05 配對 styling，14 個原 library／part 檔整體歸 lib/src/styling/legacy_metrics/，13 個 abstract final metrics 類型與全部 static 常數／list／Duration／字型 package 名稱、順序與型別完全保留。原 foundation/klp_metrics.dart 僅留單一相容 export 指向新唯一 library，13 個舊 part 刪除。此 export 是原切片明定 P9 前相容入口，非第二實作；根 Stable kallopis_foundation.dart 保持原 export，所有公開 barrel 可達性／型別身分不變。兩個 styling legacy_theme source 改用新下層權威；完整 styling 不得再 import/export/part 到 foundation，包含條件／相對／named part／barrel 旁路，不禁止正常同模組 private helper。part 與 part-of 仍在同 library/module。沒有第二 theme／environment／l10n 或新增 consumer API；只移動權責不重設預設值。

精確範圍與 Task Packet 條件見 [配對計畫](../../../docs/architecture/metrics-module-plan/README.md)。METRICS-V1-r1 已整合：14 檔度量 library／part 已歸 styling，foundation 單一相容 export 保留 Stable 身分；13 類型與150常數、完整 styling 向下邊界通過 8 項獨立契約，兩 module scope PASS。全九模組指令圖無循環。文件修復僅補50個dartdoc，原 token baseline45不變且9項通過。見 [驗證](../../../docs/architecture/metrics-module-plan/verification.md)。
