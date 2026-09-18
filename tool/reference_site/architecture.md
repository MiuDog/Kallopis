# Declarative API Reference Site 架構

Status: PLAN READY — `AR-V1` 已配對至 KLP-0021 `PE-23`～`PE-25`；本階段只建立完整 declarative API extraction、module／declaration pages 與確定性驗證。固定 254 項遷移完成與舊實作刪除仍由 Catalog migration 各 feature stage 擁有，最後再執行網站發布接受。

## 目的、階段與能力地平線

本 module 將 repository Markdown、consumer guides、固定 Catalog 證據及 `package:kallopis/kallopis_declarative.dart` 的實際公開 export closure 轉成 GitHub Pages reference site。當前階段 `AR-V1` 的可觀察結果是：使用者先看到全部 Kallopis module 與它們和 consumer 前端的關係，再從任一 module 進入該 module 的全部公開 API，最後進入一個宣告一頁的正式 reference。

完整能力地平線還包含固定 254 項全部改由新版架構呈現、舊同義入口刪除、每個 semantic feature 的能力卡與最終人類可理解性接受。`AR-V1` 只建立會隨公開面更新的 reference 機制，不把 pending legacy API 宣稱為新 consumer 能力。

非目標：

- 不由文件 generator 定義、修改或兼容 Dart API。
- 不從 `lib/src` 檔案存在、舊 Catalog class 或 Stable legacy library 推定 consumer 可用性。
- 不用網站頁面取代能力成熟度、Catalog migration coverage 或人類視覺接受。
- 不在本階段遷移 254 項元件、改 renderer、修改 style 或刪除 legacy 實作。
- 不把 internal architecture graph 當成初學者正式 API Reference。

## 輸入、輸出與 module 分類

```text
kallopis_declarative.dart export closure
	→ Dart analyzer extraction
	→ immutable API manifest
	→ module index／declaration pages／search
	→ site verifier
	→ GitHub Pages artifact

repository Markdown＋Dart documentation comments
	→ human explanation
	→ same generated pages
```

`kallopis_declarative.dart` 的 analyzer `exportNamespace` 是公開名稱集合的唯一權威。每個名稱保留宣告 kind、library／source URI、完整 display signature、documentation comment、型別關係及 public members。Generator 不以 regex 或手寫 inventory 猜測 API 可達性。

Reference 頂層固定列出目前 repository 的九個 module：`application`、`capabilities`、`composition`、`features`、`foundation`、`kernel`、`rendering`、`runtime`、`styling`。前六者依公開宣告來源列 API；沒有 declarative public API 的 `rendering`、`runtime`、`styling` 仍顯示為 Kallopis-owned／consumer 不直接使用，公開數量為 0。外部 Krepis re-export 歸入 `features.editing.providers`，但保留實際 package source。

`features` 依第一個 feature family 子路徑再分組，例如 `features.workspace`、`features.editing`、`features.overlays`；其他 module 只有在 public surface 已有穩定子責任時才增加次分類，不從內部資料夾自動建立空導覽。

## 所屬路徑與公共介面

| 路徑 | 責任 | AR-V1 |
| --- | --- | --- |
| `tool/reference_site/extract_api.dart` | 以 analyzer 解析唯一 declarative library，輸出 API manifest。 | 新增 |
| `tool/reference_site/api_manifest.schema.json` | 固定 extractor → generator 的資料形狀與 schema version。 | 新增 |
| `tool/reference_site/generate.mjs` | 將 manifest 與既有 Markdown 轉成 module／declaration／guide／spec 頁。 | 更新 |
| `tool/reference_site/verify.mjs` | 比對 manifest、HTML、search、來源與連結，拒絕遺漏或多餘 API 頁。 | 更新 |
| `tool/reference_site/layout.mjs`、`static/**` | 提供 module 導覽、宣告目錄及既有響應式網站外殼。 | 必要時更新 |
| `tool/reference_site/assembly_examples.json` | 少量已證明的 consumer assembly example。 | 保留；只允許 declarative API |
| `build/reference-api.json` | extractor 的可再生中介 manifest。 | 不提交 |
| `build/reference-site/**` | 可再生 GitHub Pages artifact。 | 不提交 |

Extractor CLI 契約：

```text
dart run tool/reference_site/extract_api.dart
	--entry lib/kallopis_declarative.dart
	--output build/reference-api.json
```

成功時寫入 schema-valid UTF-8 JSON 並回傳 0；entry 無法解析、存在 analyzer error、同一公開名稱無法唯一歸屬、未知 declaration kind 或輸出不完整時回傳非 0，且不留下看似成功的部分 manifest。

Generator 只讀完成的 manifest。每個 public declaration 產生穩定 URL `docs/api/<module>/<declaration-slug>.html`；module 頁為 `docs/api/<module>/index.html`。同名宣告以公開名稱衝突視為 extraction failure，不用來源路徑偷偷產生兩頁。

## 責任分解與依賴方向

### API extractor

擁有「什麼是目前 public API」與 Dart element → manifest 的邊界轉換。它只依賴 analyzer、package configuration 及 declarative entry，不讀 Catalog coverage 決定可達性。Manifest 中集合按 module、公開名稱及 member 名稱穩定排序，避免平台或 filesystem 順序造成網站 diff。

### Reference generator

擁有 URL、頁面組合、導覽、search entry 及 source link。Declaration 頁必須包含：名稱、kind、module、source package、documentation、完整 public signature、型別關係、constructors、public fields／getters／setters／methods，以及可用時的組裝 example。它不得補造 analyzer 未提供的 member 或把 private member 顯示成 public。

### Site verifier

擁有 artifact 完整性，不擁有 API 定義。它重新讀取 manifest，逐項驗證唯一 module membership、module index link、declaration page、page anchor、search entry 與 source link；並驗證輸出沒有 manifest 之外的正式 declaration page。既有 Markdown source warning 與新產生失敗分開報告。

### Human guidance

`docs/ai` 繼續擁有意圖導向、四階段教學、能力卡、狀態權威與組裝限制。正式 API 頁以 Dart documentation comment 為基本說明，再連回相關能力卡；本 stage 不建立第二份逐 class 手寫簽名清冊。

依賴只能是 public Dart source／Markdown → extractor／generator → artifact。Dart runtime、features、application 與 Catalog 不得反向依賴 reference manifest。

## 不變條件、錯誤與相容性

- 正式 API Reference 只含 declarative export closure；`kallopis.dart`、`kallopis_theme.dart`、`kallopis_foundation.dart` 及 `lib/src` 不列入正式 consumer API。
- 每個 public 名稱恰好一個 module、恰好一個 declaration page、恰好一個 search entry。
- 每個 class／sealed class／base class／interface class／mixin／enum／extension／typedef 各自一頁；top-level function 與 variable 也各自一頁。
- Class 頁不得合併另一個 class；member 是其 owner class 頁的一部分，不另建數千個 member 頁。
- module 頁列出該 module 的全部宣告並按 kind 分組；0 API module 仍說明 ownership 與 consumer 關係。
- API 名稱或簽名只來自 analyzer；Markdown 與 assembly example 不能讓未匯出 API 出現在正式清冊。
- Legacy API 完成新版替換並從 declarative surface 移除後，下一次 extraction 必須讓正式頁消失；migration map 保留歷史對照，不保留相容 API 頁。
- Generator 不直接刪除 repository source；只重建已驗證位於 `build/reference-site` 的 artifact。
- Extractor 或 verifier failure 阻止 Pages artifact；不以空清冊、warning 降級或沿用舊 manifest 發布。

## 採用設計與否決方案

採用 analyzer-first manifest，因為 export／show／conditional library、external package re-export、型別別名與 Dart class modifiers 無法由檔名或 Markdown 圖集可靠推導。Manifest 是單次 build artifact，不提交、不成為第三份 API 權威；generator 與 verifier共用它以避免兩種解析結果。

保留意圖導向 guides 與 declaration reference 兩條導覽：初學者從四階段與能力卡開始，已知 API 名稱者從 module／declaration 搜尋進入。否決只按 class 清單當首頁，因為這會重建使用者最初遇到的認知陷阱；也否決只保留現行 `docs/architecture/src` 檔案頁，因為它包含 internal API 且不等於 declarative export closure。

## AR-V1 slices

### `AR-T` — Independent Test Author

允許寫入：`tool/reference_site/test/**` 與 extractor／generator 專用 fixtures，不改 production。

凍結 Red：fixture 具 public、private、show-filtered、external re-export、class modifiers、members、top-level API 與 0-public module；要求 manifest 完整且穩定，generator 每宣告一頁，verifier 對缺頁、多頁、漏 search、額外 legacy page 失敗。

驗收：Red 只因 extractor／module pages 尚不存在而失敗，不因 package resolution 或 fixture 語法錯誤失敗。

估算：4k–8k tokens／25–50 分鐘，cold-start。M1 manifest Red（2k–4k／20–30 分）；M2 site completeness Red（4k–8k／25–50 分）。超過 12k／75 分鐘時檢查是否誤測 Dart analyzer internals。

### `AR-E` — API Extractor

允許寫入：`tool/reference_site/extract_api.dart`、`tool/reference_site/api_manifest.schema.json` 及 extractor-owned helper。

公共契約：上列 CLI 與 schema。驗收：真實 declarative entry 無 analyzer error；所有 exported public names 唯一分類、穩定排序、包含指定 declaration/member facts；fixture tests Green。

估算：8k–16k tokens／45–100 分鐘，cold-start。M1 export closure／classification（5k–9k／35–60 分）；M2 signatures／members／schema output（8k–16k／45–100 分）。超過 22k／140 分鐘或 analyzer API 無法提供所需 display 時提出 ACR，不改用 regex。

### `AR-G` — Site Generator

允許寫入：`tool/reference_site/generate.mjs`、`tool/reference_site/layout.mjs`、必要 `tool/reference_site/static/**`。

公共契約：只讀 schema-valid manifest；輸出 module／declaration pages、search 與 site manifest。驗收：每個宣告從 API index 經 module 一次到達；一個 class 一頁；九個 module 全出現；現有 guide／spec／component URL 保持或提供 redirect。

估算：8k–18k tokens／50–120 分鐘，cold-start。M1 module／page route（5k–10k／40–70 分）；M2 content／search／responsive navigation（8k–18k／50–120 分）。視覺可理解性保持 human-pending。

### `AR-V` — Verifier

允許寫入：`tool/reference_site/verify.mjs` 與 verifier-owned helper。

驗收：manifest ↔ module page ↔ declaration page ↔ search 為雙向完整集合；刪一頁、加一頁、重複名稱、漏 member source 或加入 legacy-only 頁均能確定失敗；既有 Markdown links、anchors、tables 與 image checks 保持。

估算：4k–10k tokens／30–70 分鐘，cold-start。M1 集合完整性（3k–6k／25–45 分）；M2 舊 verifier 合併與故障 fixture（4k–10k／30–70 分）。

### `AR-I` — Pages Integration

`tool/reference_site` 只定義所需命令，不直接擁有 `.github/workflows/pages.yml`。Integration Steward 另以精確 write path 安裝與 `pub get` 相符的 Flutter／Dart toolchain，依序執行 extractor、Node tests、generator、verifier，再上傳 artifact。不得上傳 extraction 或 verification 失敗的舊 artifact。

估算：2k–5k tokens／15–35 分鐘，cold-start。M1 CI command chain（1k–3k／10–25 分）；M2 本機與 workflow parity（2k–5k／15–35 分）。

## 驗證狀態與受保護路徑

目前為 Yellow：既有 reference site 可產生並驗證 4062 個 HTML 頁，但 API index 仍取自 `docs/architecture/src` 的 internal 文件，沒有 declarative export completeness，故不符合 `PE-23`～`PE-25`。現有 Markdown tests 5／5；舊 generator／verifier 是待替換的行為基準，不是新契約 Green。

受保護：`lib/**`、`spec/**`、`docs/architecture/catalog-migration/legacy-baseline.json`、`coverage.json`、所有非當前 Test Author 擁有的 tests、`build/**` 與本 `architecture.md`。BUILD worker 不得為產頁修改 public API、遷移狀態、文件成熟度或舊元件。

所有 P1 已映射到 extractor、generator、verifier 或 Integration owner，依賴方向一致，下一 slice `AR-T` 沒有未決產品或架構選擇；`AR-V1` 為 `PLAN READY`。
