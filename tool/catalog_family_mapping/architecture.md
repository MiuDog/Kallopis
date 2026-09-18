# Catalog capability family mapping

狀態：`SCL-FAM-r1` PLAN READY。Owning module 是 Catalog migration governance；本階段只把已接受的固定 254 項形成 capability families，並固定每個公開 family 的 exact semantic roles。公開處置、Dart 名稱、owning module 與 runtime migration 均不在本階段。

## 目的、非目標與階段

目前 target stage 是 `CAT-TAX-02／SCL-FAM-r1`。它回答兩個問題：哪些 legacy 項目其實共享同一份不變資料／事件／組裝／生命週期契約，以及這個 family 在 `screen → layout → container → element` 中可直接承載哪些具名 role。

輸入權威固定為已接受的 [`classification.json`](../catalog_classification/classification.json)，接受 commit `0fcf54782b0fc0013a296bd4d505a85fd50ffd1a`，檔案 SHA-256 `e837e0d6be2ee36dbba4a94bb4869c1989050b232d3c0fefa640435ffcb07de8`。舊 [`catalog-capability-map.md`](../../docs/ai/catalog-capability-map.md) 只可作查漏索引，不得提供 family、處置或 module 答案。

非目標：

- 不決定 `preserve`、`migrate`、`absorb`、`replace`、`retire`。
- 不指定 application／features／composition 等 owning module，也不列支援 module。
- 不命名新版 Dart class、library、constructor 或 controller。
- 不修改 `lib/**`、Catalog specimen、coverage、reference site或舊 API。
- 不用舊 class 名稱、來源路徑、舊 25 群或視覺外形自動分組。

Capability horizon 是 family 接受後的逐項公開處置與單一 module ownership，接著才選一個端到端 pilot family。此 horizon 只影響本階段要保留穩定 family ID 與完整組裝圖，不在本計畫提前實作。

## 所屬路徑與邊界介面

| 路徑 | 責任 |
| --- | --- |
| `tool/catalog_family_mapping/families.json` | Family、254 項 membership 與 exact roles 的唯一機械權威。 |
| `tool/catalog_family_mapping/verify.dart` | 驗證 accepted classification、集合、family invariants 與合法結構圖。 |
| `tool/catalog_family_mapping/render_review.dart` | 產生供人類按 family 與組裝邊審閱的 Markdown。 |
| `tool/catalog_family_mapping/review.md` | 可重建的人類審閱輸出，不是第二份權威。 |
| `tool/catalog_family_mapping/architecture.md` | 本 module current truth；BUILD worker 唯讀。 |
| `test/catalog_family_mapping_contract_test.dart` | 獨立固定 schema、254 membership 與結構圖的 deterministic contract。 |

Verifier CLI：

```text
dart run tool/catalog_family_mapping/verify.dart
	--classification tool/catalog_classification/classification.json
	--families tool/catalog_family_mapping/families.json
	[--require-accepted]
```

Renderer CLI：

```text
dart run tool/catalog_family_mapping/render_review.dart
	--classification tool/catalog_classification/classification.json
	--families tool/catalog_family_mapping/families.json
	--output tool/catalog_family_mapping/review.md
```

兩者只讀完整且已接受的 classification；解析、集合或契約失敗時回傳非 0。Renderer 在所有輸入驗證成功前不得覆寫 review。

## `families.json` 封閉契約

頂層只有：

- `schemaVersion: 1`
- `classificationRevision`：上述接受 commit 的完整 hash。
- `classificationSha256`：逐 byte 綁定 accepted classification。
- `reviewStatus`：`proposed` 或 `accepted`。
- `acceptedAt`：proposed 時為 null，accepted 時為非空 ISO-8601 offset datetime。
- `families`：依 `id` 穩定排序的 family records。

每個 family record 只有：

- `id`：穩定的 `FAM-<DOMAIN>-<INTENT>` ID；描述 consumer 能力，不複製舊 class 名。
- `title`、`consumerJob`：人類可讀名稱與不依賴 renderer 的工作敘述。
- `compositionLevel`：`screen`、`layout`、`container`、`element`、`internal`、`none` 之一。
- `dataInvariants`：共同資料身分、狀態與必要約束；不得寫視覺值。
- `eventContract`：共同輸出 intent 與 host 更新責任；沒有 consumer event 時仍須明述原因。
- `lifecycleContract`：建立、更新、釋放及必要 controller lease 的共同生命週期。
- `members`：依名稱排序的 legacy 名稱；每個固定項目恰好出現一次。
- `roles`：由本 family 擁有的具名直接 child roles。

每個 role record 只有：

- `id`、`purpose`：family scope 內唯一語意名稱與用途。
- `acceptedFamilyIds`：可直接放入此 role 的 family ID，排序且非空。
- `min`、`max`：非負 cardinality；`max: null` 只允許真正的資料集合，不能代表任意結構 children。
- `orderMeaning`：`fixed` 或 `consumer-semantic`；後者只能表示閱讀、工作流程或優先序。

Family ID 是遷移治理識別，不是 Dart API 承諾。`families.json` 嚴禁 owner、module、package、source path、disposition、replacement、public target、Dart symbol、style、axis、flex、gap、alignment、尺寸、座標、Widget、builder、painter 或任意 children 欄位。

## 分組與組裝不變條件

同一 family 的所有 members 必須具有相同 `compositionLevel`，並能共享一份資料、事件、合法組裝與生命週期契約。只共享畫面外形、renderer primitive、舊資料夾或舊 capability ID 不足以合併；其中任一不變條件不同就拆成 family。反之，同一契約的 visual variants 或 legacy helper 不得為保留舊 class 數量而拆 family。

Roles 由 parent family 擁有，而不是 child 自行宣稱位置：

```text
screen role → layout family
layout role → container family
container role → element family
```

- `screen` family 恰有一個 `root-layout` role，`min=1`、`max=1`。
- `layout` 只可定義具名 container roles；禁止 layout child。
- `container` 只可定義 feature-specific element-data roles；不得接受 container 或 layout。
- `element`、`internal`、`none` 的 `roles` 必須為空。
- 每個 layout、container、element family 至少由一個合法直接 parent role 可達；所有 public families 最終都從某個 screen family 可達。
- 每條 reference 必須存在、只跨下一層，且 family graph 無 dangling edge、skip、reverse、same-level 或 cycle。
- 領域資料遞迴留在 `dataInvariants` 所描述的 family-owned schema，例如 tree item children；不得建立第二棵 structural role graph。

`internal` 與 `none` 仍須納入 family，才能讓 254 項在後續 disposition 階段都有完整上下文；它們以共同 implementation purpose 或 non-runtime governance purpose 分組，但不取得 public role。Family review 接受只接受這份語意分組與合法邊，不等於接受任何公開 class。

## 責任與依賴方向

```text
accepted classification + fixed 254 baseline evidence
	→ hand-authored family graph
	→ independent contract test + verifier
	→ deterministic review
	→ human acceptance
	→ later disposition and module mapping PLAN
```

Family architect 擁有語意分組與 role graph；Test Author 擁有可機械判定的封閉契約；renderer 只投影已驗證資料。任何無法以既有四層表達的 family 都必須回到已接受規格處理，不得在資料中新增通用 group、第五個 public level 或 escape hatch。

採用單一 family graph，而不是「membership 表＋另一份 role 表」，因為 parent-owned roles 和 family contract 必須在一次人類審閱中保持一致。否決沿用舊 25 capability IDs，因為它們混合視覺形狀、module 猜測與處置；也否決此時加入 owner／public target，因為會讓後續決策反向影響 family 邊界。

## Ordered slices

### `SCL-FAM-T` — Independent contract Red

允許寫入：`test/catalog_family_mapping_contract_test.dart` 與 test-owned fixtures。

固定 schema、accepted classification digest、254 項一對一 membership、同 family 層級一致、封閉欄位、role cardinality、直接層級 reference、public reachability，以及 forbidden owner／disposition／Dart API 欄位。初始 Red 必須因 `families.json` 尚不存在，不得因 test harness 或 dependency failure。

估算：4k–8k tokens／30–60 分鐘，參考 `SCL-TAX-T`，historical adjusted。M1 schema／membership Red（2k–4k／20–35 分）；M2 role graph assertions（4k–8k／30–60 分）。超過 12k／90 分鐘或需解析 Dart source 即異常，回 PLAN。

### `SCL-FAM-D` — Hand-authored family graph

允許寫入：`tool/catalog_family_mapping/families.json`。

逐項比較 254 筆已接受 intent 與 level，先形成 family，再為 public parent families 寫 exact roles；不得用 regex、舊 capability ID 或來源路徑批次決定。資料保持 `reviewStatus=proposed`。

估算：20k–40k tokens／150–300 分鐘，參考 `SCL-TAX-D`，cold-start due to cross-item comparison。M1 public family boundaries（10k–20k／75–150 分）；M2 internal／none membership 完整（14k–28k／100–210 分）；M3 exact role graph 與 reachability（20k–40k／150–300 分）。超過 55k／390 分鐘、任一 family 需要跨 composition level，或 exact role 只能靠任意 children 表達時即異常，回 DEFINE／PLAN。

### `SCL-FAM-V` — Verifier and review

允許寫入：`tool/catalog_family_mapping/verify.dart`、`render_review.dart`、`review.md`。

Verifier 對真實資料與獨立 test 都 Green；review 顯示每個 family 的 job、四種契約、members、parent roles、child roles與完整可達性摘要。Renderer 連續執行兩次產物 hash 必須相同；`--require-accepted` 在 proposed 狀態正確失敗。

估算：6k–12k tokens／45–90 分鐘，參考 `SCL-TAX-V`，historical adjusted。M1 schema／membership verifier（3k–6k／25–50 分）；M2 graph verification（5k–10k／40–75 分）；M3 deterministic review（6k–12k／45–90 分）。超過 18k／130 分鐘或 verifier 開始判斷語意好壞即異常，縮回 deterministic evidence。

### `SCL-FAM-A` — Human acceptance

Family architect 只在使用者審閱 generated review 並明確接受後更新 `reviewStatus` 與 `acceptedAt`，再執行 `--require-accepted`。這個 slice 不修改 family 內容，不授權 disposition、module mapping 或 runtime BUILD。

## 驗證狀態、保護與 readiness

目前 test state 為 Red 尚未建立：已接受 classification 已具 254/254 前置證據，但 family graph、獨立 test、verifier 與 review 都尚不存在。第一個 BUILD slice 必須是 `SCL-FAM-T`。

受保護：`spec/**`、`tool/catalog_classification/**`、`docs/architecture/catalog-migration/legacy-baseline.json`、`coverage.json`、`lib/**`、`example/**`、reference site、既有 migration evidence、非當前 slice tests 與本 `architecture.md`。各 worker 只能修改 slice 明列路徑。

TAX-08、TAX-11～15 在此階段需要的 family boundary、四層合法邊、exact roles 與 human acceptance 均已映射到 owner、資料契約、slice 與證據；TAX-09 的 disposition 明確保留到 family 接受後。依賴方向一致，下一 slice `SCL-FAM-T` 無未決 P1 架構選擇，因此 `SCL-FAM-r1` 為 PLAN READY。
