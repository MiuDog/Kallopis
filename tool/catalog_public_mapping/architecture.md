# Catalog public disposition mapping

狀態：`SCL-DISP-r1` PLAN READY。Owning module 是 Catalog migration governance；本階段只決定 161 個 accepted families 的目標狀態，以及固定 254 項各自的 `preserve／migrate／absorb／replace／retire`。單一 module ownership 必須等 disposition 接受後才另行規劃。

## 目的、輸入與非目標

目前 target stage 是 `CAT-TAX-02／SCL-DISP-r1`。它把「已接受的語意 family」轉成可執行的 migration 去向，但不從舊 class、來源路徑或現有 module 反推答案。

唯一輸入權威是 accepted [`families.json`](../catalog_family_mapping/families.json)，接受 commit `b8aa7131851bdee4ae0feba78b0f8d660f26c7cd`，SHA-256 `2502f95a70f3f88bc49febae8513a6377c7ee0fd079dd212bf75533c4814e24b`。Classification 與固定 baseline 只透過 family verifier 間接驗證；舊 capability map、現有 export、檔案位置與 implementation class 不得成為處置輸入。

非目標：

- 不指定 application／features／composition 等 owning module 或支援 module。
- 不命名 Dart class、library、constructor、intent 或 controller。
- 不修改 public exports、runtime、renderer、Catalog specimen、coverage 或 legacy source。
- 不以刪檔、合併頁面或改名縮小固定 254 分母。
- 不把 `preserve` 當作外觀永久凍結；已接受的新外觀仍由既有 visual evidence 保護。

Capability horizon 是 disposition 接受後的單一 module ownership，接著才為一個端到端 pilot family 設計確切 Dart API。Family ID 是目前可引用的語意 public target；它不是最終 Dart symbol。

## 所屬路徑與邊界介面

| 路徑 | 責任 |
| --- | --- |
| `tool/catalog_public_mapping/dispositions.json` | 161 個 family target states 與 254 項 disposition 的唯一機械權威。 |
| `tool/catalog_public_mapping/verify.dart` | 驗證 accepted family input、集合完整性與處置一致性。 |
| `tool/catalog_public_mapping/render_review.dart` | 產生按 target state、disposition 與 family 分組的人類審閱頁。 |
| `tool/catalog_public_mapping/review.md` | 可重建的人類審閱輸出，不是第二份權威。 |
| `tool/catalog_public_mapping/architecture.md` | 本 module current truth；BUILD worker 唯讀。 |
| `test/catalog_public_mapping_contract_test.dart` | 獨立固定 schema、集合與跨記錄一致性。 |

Verifier CLI：

```text
dart run tool/catalog_public_mapping/verify.dart
	--families tool/catalog_family_mapping/families.json
	--dispositions tool/catalog_public_mapping/dispositions.json
	[--require-accepted]
```

Renderer CLI：

```text
dart run tool/catalog_public_mapping/render_review.dart
	--families tool/catalog_family_mapping/families.json
	--dispositions tool/catalog_public_mapping/dispositions.json
	--output tool/catalog_public_mapping/review.md
```

兩者必須先以 family module 的 production verifier確認 254/254 與 `reviewStatus=accepted`。任何輸入、集合或一致性失敗回傳非 0；renderer 在完整成功前不得覆寫 review。

## `dispositions.json` 封閉契約

頂層只有：

- `schemaVersion: 1`
- `familyRevision`：上述 accepted family commit 完整 hash。
- `familySha256`：逐 byte 綁定 accepted `families.json`。
- `reviewStatus`：`proposed` 或 `accepted`。
- `acceptedAt`：proposed 時為 null；accepted 時為非空 ISO-8601 offset datetime。
- `familyTargets`：依 `familyId` 排序，恰好一筆對應每個 accepted family。
- `items`：依 `legacyName` 排序，恰好一筆對應固定 254 項。

每個 family target record 只有：

- `familyId`
- `targetStatus`：`public-contract`、`internal-support`、`catalog-tooling`、`retired` 之一。
- `rationale`：依 family 的資料、事件、組裝與生命週期說明，不得引用現行路徑或 module。

`public-contract` 表示後續 pilot 可將此 family 具體化為 declarative API；`internal-support` 表示只保留 Kallopis 私有實作責任；`catalog-tooling` 表示只由 Catalog／Reference 檢查流程呈現；`retired` 表示 family 的舊介面與意圖都不再形成產品能力。

每個 item record 只有：

- `legacyName`
- `familyId`：必須與 accepted family membership 相同。
- `disposition`：`preserve`、`migrate`、`absorb`、`replace`、`retire` 之一。
- `outcomeFamilyIds`：處置完成後承接能力或實作責任的 accepted family IDs，排序且唯一。
- `rationale`：說明為何保留、遷移、吸收、替代或退役，不得以目前檔案位置作理由。

資料嚴禁 owner、module、package、source path、Dart symbol、public class name、style、Widget、builder、renderer 或 coverage status 欄位。

## 處置語意與一致性

| Disposition | 舊介面結果 | `outcomeFamilyIds` | 使用時機 |
| --- | --- | --- | --- |
| `preserve` | 新版 declarative 契約與已完成證據保持，舊同義入口仍依整體 migration gate 移除。 | 恰為自己的 `public-contract` family。 | 現有新版能力已符合接受契約，例如已完成的 Explorer／Menu 證據。 |
| `migrate` | 以自己的 accepted family 建立新版 declarative contract；完成後刪除舊寫法。 | 恰為自己的 `public-contract` family。 | Consumer intent 保留，但目前 API／資料／事件／組裝不符合。 |
| `absorb` | 不形成獨立 public contract；其必要能力成為其他 family 的私有實作或受控資料部分。 | 一個以上 `public-contract` 或 `internal-support` family，不得只有自己。 | Layout primitive、surface、helper 或拆太細的 composition part。 |
| `replace` | 舊介面移除，由明列 family 或 catalog tooling 以不同契約完成原意圖。 | 一個以上非 `retired` family；可為同 family，表示保留意圖但完全換契約形態。 | 舊名稱或責任邊界誤導，不能視為同契約 migration。 |
| `retire` | 舊介面與意圖皆移除，只留固定清冊歷史。 | 必須為空。 | 重複、過時或不再屬於產品能力地平線。 |

跨記錄規則：

- 每個 `public-contract` family 至少有一個 member 為 `preserve` 或 `migrate`，其餘 member 可吸收或替代。
- `preserve`／`migrate` 只能指向自己的 `public-contract` family。
- `internal-support` family 不得有 `preserve`／`migrate` member；其成員只能被吸收、替代或退役。
- `catalog-tooling` family 不進入 declarative API；其 member 只能 `replace` 或 `retire`。
- `retired` family 的全部 member 都必須 `retire`。
- `absorb`／`replace` 的每個 outcome 都必須存在且不能指向 `retired`；`absorb` 不能只指回自己。
- 每個固定 legacy item 恰好一筆，不能因多個 outcome 重複計入 coverage。
- 已有 2 migrated／1 preserved 的 coverage evidence 不在本 stage 改寫；若新處置與既有 evidence 衝突，回到架構 owner，不修改證據迎合資料。

## 責任與依賴方向

```text
accepted family graph
	→ hand-authored family target decisions
	→ hand-authored 254 item dispositions
	→ independent contract test + verifier
	→ deterministic review
	→ human acceptance
	→ later single-module ownership PLAN
```

Disposition architect 擁有去向判斷；Test Author 擁有封閉 schema 與 deterministic consistency；renderer 只投影已驗證資料。Verifier 不判斷「某項語意上應該 migrate 還是 absorb」，該判斷由人類 review 接受。

採用 family target＋item disposition 同一 authority，因為 item outcome 必須即時驗證目標是否仍為 public/internal/catalog。否決直接在 `families.json` 加 disposition，避免已接受 family identity 被後續 migration 決策污染；也否決同時加入 module owner，遵守「先接受處置、最後決定 owner」的已接受順序。

## Ordered slices

### `SCL-DISP-T` — Independent contract Red

允許寫入：`test/catalog_public_mapping_contract_test.dart` 與 test-owned fixtures。

固定 accepted family digest、161／254 雙集合、封閉欄位、enum、排序、membership、target/disposition/outcome 一致性及 forbidden ownership/API fields。初始 Red 必須因 `dispositions.json` 尚不存在，不得因 harness、family verifier 或 dependency failure。

估算：4k–9k tokens／30–70 分鐘，參考 `SCL-FAM-T`，historical adjusted。M1 schema／雙集合 Red（2k–5k／20–40 分）；M2 outcome consistency（4k–9k／30–70 分）。超過 13k／100 分鐘或需讀 runtime source 即異常，回 PLAN。

### `SCL-DISP-D` — Hand-authored target and item decisions

允許寫入：`tool/catalog_public_mapping/dispositions.json`。

先逐 family 決定 target status，再逐項比較舊介面與 accepted family 契約，寫入 254 項 disposition／outcomes／rationale。不得從舊 map、來源路徑、名稱 regex 或現有 export 自動決定；資料保持 `reviewStatus=proposed`。

估算：22k–46k tokens／170–340 分鐘，參考 `SCL-FAM-D`，cold-start。M1 161 family targets（9k–18k／70–135 分）；M2 254 item dispositions（18k–36k／135–270 分）；M3 outcome cross-check（22k–46k／170–340 分）。超過 62k／450 分鐘、需要第六種 disposition，或無法指出承接 family 時即異常，回 DEFINE／PLAN。

### `SCL-DISP-V` — Verifier and review

允許寫入：`tool/catalog_public_mapping/verify.dart`、`render_review.dart`、`review.md`。

Verifier 與 protected test 對真實資料 Green；review 顯示 target status 統計、五種 disposition 統計、每個 family 的 members／decisions／outcomes。Renderer 連續兩次 SHA-256 相同；`--require-accepted` 在 proposed 時正確失敗。

估算：6k–13k tokens／45–100 分鐘，參考 `SCL-FAM-V`，historical adjusted。M1 family target與item verifier（4k–8k／30–60 分）；M2 cross-record rules（5k–10k／40–80 分）；M3 deterministic review（6k–13k／45–100 分）。超過 19k／145 分鐘或 verifier 開始猜測語意處置即異常。

### `SCL-DISP-A` — Human acceptance

Disposition architect 只在使用者審閱 generated review 並明確接受後更新 `reviewStatus` 與 `acceptedAt`，再執行 `--require-accepted`。不在此 slice 新增 module owner 或啟動 runtime BUILD。

## 驗證狀態、保護與 readiness

目前 test state 為 Red 尚未建立：accepted family graph 已具 161 families／254 members／281 role edges 前置證據，但 disposition data、test、verifier 與 review 尚不存在。第一個 BUILD slice 必須是 `SCL-DISP-T`。

受保護：`spec/**`、`tool/catalog_classification/**`、`tool/catalog_family_mapping/**`、baseline、coverage、`lib/**`、`example/**`、reference site、既有 migration evidence、非當前 slice tests 與本 `architecture.md`。各 worker 只能修改 slice 明列路徑。

TAX-09 的五種處置、每項新版去向、固定證據保留與 human acceptance 都已映射到責任、資料契約、slice 與 deterministic evidence；TAX-08 的 module ownership 明確留在 disposition 接受後。依賴方向一致，下一 slice `SCL-DISP-T` 無未決 P1 架構選擇，因此 `SCL-DISP-r1` 為 PLAN READY。
