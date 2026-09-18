# Catalog classification tool

狀態：`SCL-TAX-r1` ACCEPTED。完整四層結構、合法邊、跨模組責任與 runtime gate 見 [`semantic-composition-layer-plan`](../../docs/architecture/semantic-composition-layer-plan/README.md)。254 筆分類已於 2026-09-18 由使用者接受；這只解除 capability family 規劃的前置條件，不代表 migration 完成。

## 目的與邊界

本 module 把固定 baseline 中的每個 legacy 項目轉成一筆分類記錄：consumer intent、一個 primary category、零至多個 secondary categories、一個 catalog role，以及一個 screen／layout／container／element／internal／none 的 public composition level candidate。分類服務 consumer 導航與後續 family formation；baseline 繼續擁有固定名稱與來源，coverage 繼續擁有 migration 狀態。

非目標：不修改 254 分母、coverage、public Dart surface、renderer、style、Catalog specimen 或舊 API；不產生 owner、module、package、layer、disposition、replacement 等後續階段欄位。已完成的 2 migrated／1 preserved 保持原證據。

能力地平線包含分類接受後的 capability family、public disposition 與 module ownership，但本 stage 不建立它們。`reviewStatus=accepted` 只表示使用者接受分類，不表示元件已遷移或 module 已決定。

## 所屬路徑與介面

| 路徑 | 責任 |
| --- | --- |
| `tool/catalog_classification/classification.json` | 254 筆唯一分類資料的機械權威。 |
| `tool/catalog_classification/verify.dart` | 將 baseline 與 classification 做雙向集合及欄位驗證。 |
| `tool/catalog_classification/render_review.dart` | 產生依 primary category 分組的人類審閱頁。 |
| `tool/catalog_classification/review.md` | 可重建的人類審閱輸出；不得手改成第二份權威。 |
| `tool/catalog_classification/architecture.md` | 本 module 契約；BUILD 唯讀。 |

Verifier CLI：

```text
dart run tool/catalog_classification/verify.dart
  --baseline docs/architecture/catalog-migration/legacy-baseline.json
  --classification tool/catalog_classification/classification.json
  [--require-accepted]
```

Renderer CLI：

```text
dart run tool/catalog_classification/render_review.dart
  --baseline docs/architecture/catalog-migration/legacy-baseline.json
  --classification tool/catalog_classification/classification.json
  --output tool/catalog_classification/review.md
```

成功回傳 0；參數、JSON、集合或契約失敗回傳非 0，不覆寫既有 review。`--require-accepted` 額外要求頂層 `reviewStatus=accepted` 與非空 `acceptedAt`；分類建立階段使用 `proposed`，人類接受後才由 taxonomy owner 更新狀態。

## 資料契約與不變條件

`classification.json` schema v2 頂層固定為 `schemaVersion`、`specRevision`、`reviewStatus`、`acceptedAt`、`items`。每個 item 只包含：

- `legacyName`：與 baseline 唯一名稱精確相等。
- `consumerIntent`：不以 class、資料夾、module 或 layer 描述用途的非空句子。
- `primaryCategory`：接受規格中的 18 個 ID 之一。
- `secondaryCategories`：穩定排序、無重複、不可含 primary 的 0 至多個接受 ID。
- `role`：`consumer-capability`、`composition-part`、`system-contract`、`implementation-material` 或 `catalog-artifact` 之一。
- `compositionLevel`：`screen`、`layout`、`container`、`element`、`internal` 或 `none` 之一；這是 public-layer candidate，不是 disposition。
- `compositionRationale`：不以現有資料夾或 renderer 形狀判斷，說明 consumer 注入的資料／功能、合法直接 parent，或沒有 public composition level 的原因。

items 依 `legacyName` 排序。baseline 與 classification 名稱集合必須完全相等且恰為 254；分類不得出現 `owner`、`module`、`package`、一般 architecture `layer`、`disposition`、`replacement` 或同義欄位。唯一允許的結構層欄位是上述 `compositionLevel`。Verifier 不從舊頁面、來源路徑或舊能力 map 自動決定分類。

`specRevision` 必須指向包含已接受 TAX-01～15 的 Git commit。`reviewStatus=proposed` 可以通過資料完整性，但不能解除 migration 暫停；只有 254 筆依新語意邊界重審、重新產生 review 並由使用者審閱後，才能更新為 accepted。

## 責任與依賴方向

```text
accepted taxonomy spec + immutable legacy baseline
  → hand-authored classification.json
  → independent contract test + verifier
  → generated review.md
  → human acceptance
```

分類資料由 taxonomy owner 逐項判斷，renderer 只做 deterministic projection；禁止用舊 capability ID、檔案路徑或 regex 批次決定 primary。每項還必須用 TAX-11～15 判斷它是語意能力、語意原子、封閉功能群組／composition part，或應吸收的 primitive／renderer implementation；不以支援多 view 作為通過條件。Verifier 擁有資料形狀與集合完整性，不判斷分類語意是否合理；語意由人類審閱。

採用 JSON source＋generated Markdown，因為 JSON 適合精確集合驗證，Markdown 適合按分類審閱。否決以 Markdown table 作機械權威，因為 escaping 與人工排版會使解析脆弱；也否決只保留 JSON，因為 254 筆資料不利於人類按分類檢查。

## 當前 slices

### `SCL-TAX-r1` — Semantic composition level re-audit

依配對計畫依序執行 `SCL-TAX-T → SCL-TAX-D → SCL-TAX-V → SCL-TAX-A`。逐項套用 TAX-11～15 與四層合法邊，特別重審所有 layout、surface、List／Grid／Masonry／virtualization 與任意 children 候選；判斷 consumer 注入的是 screen、layout role、container projection、element data，還是實際上仍在組裝元件樹。不得把舊 class 名稱直接視為公開能力，也不得強迫每項支援多 view。

精確 write paths、role-level consistency、里程碑、估算與異常門檻以 [`semantic-composition-layer-plan`](../../docs/architecture/semantic-composition-layer-plan/README.md) 為準。輸出目前為 `reviewStatus=accepted`，後續不得以 family 或 migration 進度回寫分類語意。

### `TAX-T` — Independent Test Author（已完成）

寫入：`test/catalog_classification_contract_test.dart`。以 fixed baseline 為獨立來源，要求 classification 存在、恰為 254、一對一、排序穩定、欄位封閉、enum 合法、intent 非空、secondary 合法且沒有 owner/module/disposition。初始 Red 必須因 classification 尚不存在或不完整，而不是測試 harness 失敗。

估算：2k–5k tokens／15–35 分鐘，參考 `AR-T`，historical。M1 完整性 Red（1k–3k／10–20 分）；M2 failure messages 與 test hash（2k–5k／15–35 分）。若 root 測試 harness 的既有 primitive compile failure污染此純資料測試，改用 `dart test` 精確路徑；不得弱化斷言。

### `TAX-D` — Classification data（已完成）

寫入：`tool/catalog_classification/classification.json`。逐項撰寫 254 個 consumer intent、primary、secondary、role、composition level 與 rationale；不得從舊 map 自動搬運。人類接受前資料保持 `reviewStatus=proposed`。

估算：12k–28k tokens／90–210 分鐘，cold-start。M1 254 名稱與 role 完整（6k–14k／45–100 分）；M2 intent 與分類語意審查（12k–28k／90–210 分）。超過 40k／300 分鐘或遇到無法由接受分類表達的項目時回 DEFINE，不新增 misc。

### `TAX-V` — Verifier and review renderer（已完成）

寫入：`tool/catalog_classification/verify.dart`、`render_review.dart`、`review.md`。Verifier 與獨立 test 對真實資料都必須 Green；renderer 產物重跑無 diff，並列出 18 分類、每項 intent、tags、role、legacy page 與來源。

估算：6k–14k tokens／45–100 分鐘，參考 `AR-V`，historical。M1 verifier（3k–7k／25–50 分）；M2 deterministic review（6k–14k／45–100 分）。若 baseline 缺少生成 review 所需資料，只能使用其既有欄位，不回填 module 或猜測來源。

### `TAX-A` — Human acceptance（已完成）

使用者於 2026-09-18 明確接受 generated `review.md`；taxonomy owner 已更新 `reviewStatus`、`acceptedAt`，並以 `--require-accepted` 驗證。這只授權進入 capability family PLAN，不授權 module mapping 或 migration BUILD。

## 驗證、錯誤與保護

當前 test state 為 Green：schema v2 contract test、254/254 verifier、deterministic review 與 `--require-accepted` 全部通過；人類語意接受已記錄。這仍不證明任何 legacy 項目已完成新版公開宣告、Catalog specimen 或 migration evidence。

受保護：`spec/**`、`docs/architecture/catalog-migration/legacy-baseline.json`、`coverage.json`、既有 migration evidence、`lib/**`、`example/**`、其他 tests 與 build 設定。`SCL-TAX-r1` 已封閉；下一步只能規劃 capability families，不得直接修改 runtime API。
