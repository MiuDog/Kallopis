# Consumer Reference 模組架構

Status: PLAN COMPLETE — `PE-B1` 至 `PE-B4` 已完成確定性驗證；reference 導航與可理解性仍待人類接受，本階段不補元件實作。

## 目的

本模組把 KLP-0021 已接受的生產力 App 能力地平線，轉成 consumer 與 agent 可依產品意圖及目前開發階段查詢的單一 reference。它負責回答「這個階段應思考什麼、現有 Klp 能否合法完成、如何開始、證據在哪裡」，而不是展示 Kallopis 內部 module 結構。

目前目標階段為 `PE-BASE-01`：建立能力清冊、初學者學習入口及三條端到端 reference flow，修正現有網站範例中與宣告式 consumer 契約衝突的內容。經清冊證實的元件缺口，後續由所屬程式 module 各自進入 PLAN；本階段不修改公開 API、renderer 或 Catalog 元件。

## 非目標

- 不在本階段新增、遷移或刪除 Klp 元件。
- 不重新設計 application、capabilities、composition、features、runtime、rendering 或 styling 的內部架構。
- 不把 Planist 的產品組裝、資料模型或商業流程變成 Kallopis reference template。
- 不以舊 Widget、舊 Catalog 頁面、類別名稱或靜態畫面推定新版能力已交付。
- 不建立另一份 API、Catalog migration 或視覺接受權威。

## 能力地平線

Productivity Ecosystem 的完整地平線依 KLP-0021 涵蓋所有產品無關的生產力 App 相關能力，包括 application／navigation、workspace／layout、actions／commands、collections／data、forms／input、feedback、overlays、筆記與內容編輯、圖表與資料視覺化、規劃視圖、畫布／繪圖／手寫、溝通協作、keyboard／focus／accessibility，以及 adaptive／platform environment；此列舉不是封閉上限。

本階段只建立完整地平線的可查詢基線與證據鏈，不一次實作全部能力。固定 254 項舊 Catalog 是目前已知的起始清冊，不是完整能力上限；圖表、筆記、手寫及其他尚未交付能力必須保留為具 owner 的缺口，不得僅因較專門而標成永久 deferred。

## 所屬路徑與公共輸出

本模組的主要所屬路徑為 `docs/ai/`；本專案既有 GitHub Pages／github.io reference site 是這些 Markdown 的最終發佈面。當網站保存了獨立 assembly example，該內容也受本模組的 consumer 契約約束。

| 路徑 | 責任 | 本階段處置 |
| --- | --- | --- |
| `docs/ai/productivity-capabilities.md` | 唯一意圖導向能力清冊；保存領域、能力狀態、公開入口、證據、缺口與下一責任人。 | 新增 |
| `docs/ai/catalog-capability-map.md` | 固定 254 項逐項分類轉接；保存能力 ID、consumer 階段、coverage、預定處置、來源與下一 owner，不取代 migration baseline。 | 新增 |
| `docs/ai/getting-started.md` | 初學者依視覺組成、產品資料模型、資料／互動接線、動畫／體驗優化四階段建立產品的主路徑。 | 新增 |
| `docs/ai/reference-flows.md` | 工作區、結構化資料、正文工作三條跨功能證據；不是產品模板。 | 新增 |
| `docs/ai/README.md` | Consumer Reference 首頁與漸進揭露導航。 | 最小更新 |
| `docs/ai/*-model.md`、既有功能頁 | 各能力的詳細契約卡與現有證據。 | 原則上引用；只有直接矛盾時才局部修正 |
| `tool/reference_site/assembly_examples.json` | reference site 額外顯示的 consumer 組裝片段；由 `tool/reference_site/architecture.md` 擁有。 | 透過獨立 `PE-B3B` slice 移除、替換或降級任何違反 `kallopis_declarative.dart` 邊界的片段 |

對 consumer 的公共輸出是文件中的能力狀態與使用路徑，不是新的 Dart API。reference 只能引用現有公開入口，不能藉文件創造支援承諾。

## 輸入權威與轉換方向

能力清冊依下列優先順序判讀；後項不能推翻前項：

1. `lib/kallopis_declarative.dart`：新 consumer 的實際公開可達性。
2. `lib/src/features/catalog/component-ownership.json` 與 `lib/src/application/bootstrap/internal/klp_application_catalog.json`：definition、owner、資格、slot、adapter 與安裝配對。
3. 直接功能契約及實作：資料、事件、狀態權威、限制與失敗行為。
4. `docs/ai/` 功能頁、可操作 Catalog 與驗證紀錄：如何使用及目前證據。
5. `docs/architecture/catalog-migration/coverage.json`：固定 254 項舊能力的遷移狀態；它不自行證明新版可用。

```text
公開可達性＋目錄配對＋功能契約＋Catalog 證據
	→ 能力分類
	→ 意圖導向清冊
	→ 初學者路徑與端到端 reference
	→ reference site
```

runtime 與程式 module 不依賴本 reference。資料流只能由程式與證據流向文件；文件不能成為 renderer 或 registry 的執行輸入。

## 能力清冊契約

每個能力條目必須具有穩定 ID，並明列：

- 生產力領域與使用者意圖。
- 最早適用的 consumer 開發階段，以及後續仍會使用的階段。
- `supported`、`partial`、`unverified`、`unsupported`、`deferred` 或 `legacy` 狀態。
- 真實公開宣告入口；沒有時明寫無。
- 必要資料、輸出事件與狀態權威摘要。
- 合法父容器、插槽與主要組裝限制。
- 詳細契約頁、Catalog／操作證據及 deterministic evidence。
- 已知缺口與下一個 owner；`unknown` 事實以 `unverified` 表示，不得改寫成 `unsupported`。

狀態判準：

| 狀態 | 判準 |
| --- | --- |
| `supported` | 新版公開宣告、資料／事件、合法組裝、唯一語意風格及可操作 Catalog 全部存在。 |
| `partial` | 已有新版公開入口，但 KLP-0021 要求的行為或證據不完整。 |
| `unverified` | 現有來源不足或互相矛盾，尚不能判定是否支援。 |
| `unsupported` | 已核對現行契約，確定沒有合法新版能力。 |
| `deferred` | 只用於不屬目前生產力 App 地平線或明確由後續產品決策處理的項目；不能用來擱置已接受的筆記、圖表、手寫等生產力能力。 |
| `legacy` | 只有舊 Flutter／相容入口；不能提供給新 consumer。 |

同一能力的詳細欄位留在既有功能契約頁；清冊只保存足以選擇、判讀狀態及追查證據的摘要，避免複製完整 API reference。

## 不變條件與錯誤權責

- Consumer Reference 的所有新程式範例只匯入 `package:kallopis/kallopis_declarative.dart`。
- 第一階段的版面注入只表示把 Kallopis 公開節點放入合法 slot；不表示接受 Flutter Widget、builder 或 renderer callback。
- 第二階段的產品資料模型由 consumer 擁有，不得為了配合畫面而把 Klp 呈現型別升格為產品資料權威。
- 第三階段先更新產品權威，再建立並提交新的 application declaration；callback 不直接操作 renderer 或建立第二份狀態。
- 第四階段只選用 Kallopis 公開的體驗能力；動畫、duration、curve、視覺狀態與局部 style 不能成為 consumer 逃生孔。
- 禁止 Widget、`BuildContext`、renderer、painter、局部 style 與自訂 component type 的現行契約不得因教學方便而放寬。
- 找到 class、舊 Widget、adapter 或 Catalog specimen，不等於 `supported`。
- 找不到證據先標 `unverified`；只有核對公開面及相關契約後才能標 `unsupported`。
- 若公開匯出、目錄、文件及 Catalog 互相矛盾，reference 必須顯示衝突並降低狀態，不得替實作選擇看似合理的答案。
- 固定 Catalog 分母保持 254；能力清冊可以重新分類意圖，但不能更改 migration coverage。
- 固定 254 項每一項都必須出現在逐項分類轉接；來源區域統計不能替代逐項對照。合併或取代只描述未來處置，不得將 coverage 提前標為完成。
- Reference flow 只證明通用能力共同工作，不擁有產品資料、順序或商業行為。
- 視覺品質與初學者可理解性由人類接受；連結、來源覆蓋、狀態欄位與網站產物由 deterministic evidence 檢查。

## 採用設計與否決方案

採用一份手動維護的 Markdown 能力清冊，並以另一份 Markdown 逐項轉接固定 254 項；兩者引用現有機械清冊及功能契約。產品意圖、缺口語意與成熟度需要人類判斷；目前直接生成 runtime JSON registry 只會把尚未接受的分類固化成第二份執行權威。Markdown 也可直接進入既有 reference-site 的單一來源管線。

能力詳情沿用既有功能頁，以 `Workspace.Explorer` 文件作為能力卡完整度範例。初學者入口、能力清冊與端到端流程各自只有一個變更理由：學習順序、能力判讀、跨能力證據；不合併成一篇巨型文件。

否決：

- 從 `lib/src` 資料夾或 class 名稱自動生成 consumer 學習順序；內部依賴層不是前端組裝層。
- 立即建立新的 machine-readable capability registry；現有 manifest 沒有產品意圖與證據成熟度，會形成重複權威。
- 每個能力重寫完整 API 文件；這會與既有契約頁分岔。
- 先安排所有缺口元件 BUILD；在基線完成前無法區分真正缺口、尚未遷移、未驗證與文件不可發現。

## 現況證據與已知衝突

- `component-ownership.json` 目前列出 26 個 feature definition，其中 24 個 public、2 個 internal，並列出 88 個相關 export；這不是完整生產力能力地平線。
- application catalog 另列 4 個 structural component 與 18 組 adapter assembly；其中 internal 項不得出現在 consumer reference。
- 固定舊 Catalog 共 254 項：2 migrated、1 preserved、251 pending，`complete=false`。
- `docs/ai/systems.md` 可作維護者能力索引，但仍以架構 system 為主，不是初學者的意圖入口。
- `Workspace.Explorer` 已具用途、資料／事件、組裝、限制、Catalog 與維護證據，可作能力卡最接近的現行範例。
- `tool/reference_site/assembly_examples.json` 目前含 `KlpRail` 範例，以及從 `kallopis_foundation.dart` 建構 style／painter 的片段；它們與新 consumer 唯一宣告式入口及封閉呈現規則衝突，必須在本階段修正，不能發布為建議用法。

以上是 PLAN 時觀察到的工作樹現況，不宣稱 main 或已發布套件具有相同內容。本階段開始前工作樹已有大量未提交修改，BUILD 必須逐檔保留非本 slice 變更。

## 目前階段 slices

### `PE-B1`：能力證據與缺口基線

狀態：完成。固定 254 項已逐項轉接，名稱、coverage、來源、能力 ID 與欄位完整性均通過本機檢查。

產出：新增 `docs/ai/productivity-capabilities.md` 與 `docs/ai/catalog-capability-map.md`。前者覆蓋 KLP-0021 全部能力領域，將現有公開能力與證據分類為六種狀態；後者逐一轉接固定 254 項，標示能力 ID、適用階段、coverage、預定處置、來源及下一 owner。

允許寫入：`docs/ai/productivity-capabilities.md`、`docs/ai/catalog-capability-map.md`。

公共契約：能力條目的欄位與狀態判準；不改 Dart API。

里程碑：

1. M1 — 建立完整生產力能力領域、四個 consumer 開發階段與來源交叉表；證據包含 24 個 public feature definition、public structural nodes、application/navigation/state 等公開系統。累計 4k–8k tokens／20–40 分鐘；超過 12k 或 60 分鐘須檢查是否誤把逐 class API 文件納入。
2. M2 — 將固定 254 項逐一配對能力 ID、階段、coverage、預定處置、來源及 owner；同義項可以指向相同能力，但每個 legacy 名稱仍保留一列。累計 10k–20k tokens／45–100 分鐘；超過 28k 或 135 分鐘須檢查分類規則與人工例外是否失控。
3. M3 — 完成能力狀態、缺口、證據與 owner 判讀；所有 supported 條目具五項交付證據，矛盾降為 partial／unverified。累計 14k–28k tokens／65–135 分鐘；超過 38k 或 180 分鐘須重新界定同義能力合併方式。

驗收：完整能力領域與四個階段全部出現，明列筆記、圖表與手寫；每個目前 public definition 可追溯到至少一個能力條目或明示非 consumer 項；固定 254 項名稱無遺漏、無重複並逐項具有分類欄位；coverage 分布仍為 2 migrated、1 preserved、251 pending 且明示不是能力上限；沒有僅因 class 存在而標 supported 的項目。

### `PE-B2`：初學者入口與能力卡導航

產出：新增 `docs/ai/getting-started.md`，最小更新 `docs/ai/README.md`，讓入口依「視覺組成 → 產品資料模型 → 資料／互動接線 → 動畫／體驗優化」前進；每階段再從意圖索引進入能力清冊與既有詳細契約頁。

允許寫入：`docs/ai/getting-started.md`、`docs/ai/README.md`；若某既有能力頁含直接錯誤連結或狀態，必須先回報並另行增加精確 write path，不預設批次重寫。

公共契約：學習順序與 reference 導航；不新增程式能力。

里程碑：

1. M1 — 建立不暴露內部 module 的四階段路徑；第一階段先以空資料完成合法結構，第二階段保持產品模型獨立，第三階段接上資料與事件，第四階段只使用 Klp 受控體驗能力。所有範例只使用宣告式入口並引用真實公開型別。累計 4k–9k tokens／20–45 分鐘；超過 13k 或 65 分鐘須檢查是否混入完整 API reference。
2. M2 — 將 README 改為依意圖與熟練度導向清冊、配方及進階維護文件，保留既有專門契約連結。累計 7k–15k tokens／35–75 分鐘；超過 20k 或 100 分鐘須檢查是否在入口重複能力詳情。

驗收：初學者可依當前階段停止，不需預讀後續階段或 kernel、runtime、rendering、foundation、styling 架構；所有程式片段只匯入 `kallopis_declarative.dart`；內部圖集明確標為維護者入口；第四階段不教 consumer 傳入任意動畫或局部樣式。

### `PE-B3`：端到端 reference flow 與網站片段收斂

產出：新增 `docs/ai/reference-flows.md`，為工作區、結構化資料、正文工作及跨切面要求建立證據矩陣；修正 reference-site 額外 assembly examples，使其不再推薦 `KlpRail`、舊 foundation 元件或 painter/style authoring。

此階段拆成兩個 module-local slices，避免同一 BUILD packet 跨越 `docs/ai` 與 `tool/reference_site`：

- `PE-B3A` — module root `docs/ai`；只允許寫入 `docs/ai/reference-flows.md`。
- `PE-B3B` — module root `tool/reference_site`；只允許寫入 `tool/reference_site/assembly_examples.json`，完整契約見該 module 的 `architecture.md`。

如果現有公開能力不足，文件標示 partial／unsupported 並連回缺口，不為了讓範例完整而修改 `lib/**`。

公共契約：端到端證據格式及 reference-site consumer 範例；不改產品模板或 Dart API。

里程碑：

1. `PE-B3A / M1` — 三條流程依四個 consumer 開發階段逐步對照能力清冊，列出成功路徑、失敗／缺口、合法組裝與證據；不把未完成流程寫成可執行範例。累計 5k–10k tokens／25–55 分鐘；超過 15k 或 80 分鐘須檢查是否誤進入元件 PLAN。
2. `PE-B3B / M1` — 移除或替換網站中違反宣告式入口的 assembly snippets；只有能由現行公開契約證明的片段保留。階段累計 4k–8k tokens／20–40 分鐘；超過 12k 或 60 分鐘須停止並回報公開 API 缺口。

驗收：三條流程與跨切面要求都有 supported／partial／unsupported 結論及證據；網站 assembly snippets 不含 `KlpRail`、`kallopis_foundation.dart`、Widget、style 或 painter authoring；不以範例隱藏能力缺口。

狀態：完成。Reference flow 具有 3 條流程、12 個階段列、跨切面矩陣與 0 個斷鏈；assembly examples 收斂為 4 個公開宣告式結構入口，禁用內容 0 命中，候選公開型別通過 Dart analyzer。兩個 module-local scope gate 均通過。

### `PE-B4`：Reference 發佈驗證與人類接受

產出：使用與本專案 GitHub Pages 相同的既有管線生成本機 reference site，驗證 Markdown、來源映射、搜尋與連結；提供初學者入口及三條流程的待人類檢查頁面。通過後的 repository 來源可由既有 CI 發佈至 github.io；本 slice 不自行 push。

允許寫入：只有前述 slices 已列路徑；`build/reference-site/**` 是可再生輸出，不作手寫來源或交付權威。若 generator 本身無法呈現既有 Markdown，停止並為 `tool/reference_site` 另建故障或改版任務，不在本 slice 擴張。

公共契約：無新增契約；只驗證前述內容可被既有網站消費。

里程碑：

1. M1 — 執行 reference-site 的 Markdown tests、generate 與 verify，修正本 slice 引入的來源或連結問題。累計 3k–7k tokens／15–35 分鐘；超過 10k 或 50 分鐘須判斷是否為既有 generator 故障。
2. M2 — 產出首頁、初學者入口、能力清冊與 flow 頁的桌面／窄寬人工檢查清單；只記錄已觀察結果。累計 5k–10k tokens／25–55 分鐘；超過 14k 或 75 分鐘須停止擴大視覺調整。

驗收：`npm test --prefix tool/reference_site`、`node tool/reference_site/generate.mjs`、`node tool/reference_site/verify.mjs` 對本輪內容通過；人類接受初學者導航與可理解性前，只能標記 deterministic evidence 完成，不能宣稱 reference 體驗已接受。

狀態：確定性完成。Markdown tests 5／5 通過；網站產生 128 個元件頁、1495 個 API 頁、377 篇指南、47 份規格與 2 份專案文件，最終共 4060 個 HTML 頁；verify 完成來源覆蓋、表格、內部連結與錨點檢查。全站回報 50 個既有來源警告，本輪新增的初學者入口、能力清冊、固定 Catalog 轉接與 reference flows 各為 0 個來源問題。桌面／窄寬導航及可理解性仍為 human-pending。

## 估算與派工順序

順序固定為 `PE-B1 → PE-B2 → PE-B3A → PE-B3B → PE-B4`。B2 依賴能力狀態，B3A 依賴清冊與學習詞彙，B3B 依賴 B3A 的狀態結論，B4 只驗證前三個階段的整合結果。禁止平行撰寫同一份 reference，以免狀態與術語分岔。

目前沒有可比較的已結案「意圖導向能力清冊」任務，以下為 cold-start 估算：總計 35k–71k model tokens、170–360 分鐘。假設使用目前模型、本機 `rg`／PowerShell、Node.js 24 與既有 reference-site 工具；本階段不需要 Flutter renderer 修改或全庫測試。若總計超過 94k tokens 或 470 分鐘，必須檢查是否提前進入能力補齊、逐 class API 文件化或網站重構。

## 驗收對照與 test state

| KLP-0021 | Owner | Slice | 證據 |
| --- | --- | --- | --- |
| PE-01 | Consumer Reference 契約 | B2、B3 | 所有新範例只用宣告式入口；網站片段移除 Widget／style／painter 路徑。 |
| PE-02、PE-03 | 能力清冊 | B1 | 十個已接受領域全部分類且可追溯。 |
| PE-04、PE-07 | 能力清冊 | B1 | 六種狀態、五項 supported 閘門、證據與 gap owner。 |
| PE-05、PE-06 | 四階段初學者入口與既有能力卡 | B1、B2 | 視覺組成 → 產品資料模型 → 資料／互動接線 → 動畫／體驗優化；各階段再依意圖進入配方與 API，Explorer 作完整度參考。 |
| PE-08 | Reference flows | B3、B4 | 三條流程、跨切面矩陣、網站生成與人類 pending artifact。 |
| PE-09 | Reference flow 邊界 | B1–B3 | 無產品模板、資料模型或固定商業流程。 |
| PE-10、PE-13 | Migration evidence adapter | B1 | 逐項轉接 254 固定清冊，不寫入 baseline／coverage；名稱無遺漏或重複，每項具能力、階段、coverage、處置、來源與 owner。 |
| PE-11 | Capability horizon | B1 | 筆記、圖表、手寫及其他產品無關生產力能力保留在完整地平線；未交付項有狀態與 owner，不以 deferred 永久排除。 |
| PE-12 | GitHub Pages reference | B2–B4 | Markdown 單一來源進入既有 reference-site generator，B4 以 GitHub Pages 同管線驗證；外部 push／部署依當次授權。 |

PE-B1 已以固定 baseline 與 coverage 驗證 254 個 migration 項目：名稱 254／254、無重複，coverage 為 2 migrated、1 preserved、251 pending，每列來源存在且能力 ID、階段、處置與 owner 欄位有效。尚未執行 Node、Flutter 或網站視覺驗證；它們分別屬 B4、元件 module BUILD 與人類接受。

## 受保護路徑

本階段 `lib/**`、`test/**`、`example/**`、`docs/architecture/catalog-migration/legacy-baseline.json`、`docs/architecture/catalog-migration/coverage.json`、module `architecture.md`、fixture、測試設定、KLP-0019、KLP-0020 與視覺治理規格全部唯讀。

若 B1 證實需要新的公開能力、跨 module 契約或測試，停止此 BUILD，將能力條目交給對應 module 的 PLAN／Test Author；不得在 reference slice 內順手修改元件、測試或 renderer。

## PLAN readiness

`PE-BASE-01` 已完成確定性範圍：KLP-0021 所有目前 P1 均有 owner、slice 與驗收證據；依賴方向由程式及現有證據單向流入 reference；未引入程式抽象或第二份 runtime 權威。`PE-B1` 至 `PE-B4` 均完成，網站 adapter 契約由 `tool/reference_site/architecture.md` 擁有；reference 體驗只等待人類在桌面與窄寬頁面接受。後續逐項接回舊 Catalog widget 屬各元件 module 的獨立 PLAN／BUILD，不在本 stage 內擴張。
