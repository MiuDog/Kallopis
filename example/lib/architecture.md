# Declarative Catalog examples

狀態：`CAT-MIG-02 / ACW-C` READY。產品契約與固定清冊由 [`docs/architecture/catalog-migration/README.md`](../../docs/architecture/catalog-migration/README.md) 擁有；本 module 只擁有可執行的 consumer specimen 與其入口。

## 責任與邊界

- `catalog_declarative/` 以 `package:kallopis/kallopis_declarative.dart` 建立正式 specimen；每個 specimen 必須是真實可掛載、可操作的單一結構樹。
- `catalog_*_main.dart` 只啟動對應 specimen，不放產品資料、替代 renderer 或另一套 theme。
- specimen 可持有展示用受控資料並把事件回填為新 application snapshot；不得呼叫原生 runner、持久化、網路或產品服務。
- 禁止匯入 Flutter、`package:kallopis/src/`、legacy public library、Widget、BuildContext、style、painter、renderer、primitive 或 preset。
- library、測試、fixture、baseline、build 設定及本檔對 BUILD worker 唯讀。視覺品質與互動手感保持 human-pending。

依賴方向固定為 `catalog_*_main.dart` → `catalog_declarative/*_specimen.dart` → `kallopis_declarative.dart`。不建立共用可自訂 UI framework；只有多個 specimen 確實重複同一個非視覺生命週期時，才另行 PLAN 共用 helper。

拒絕將舊 Catalog Widget 包裝成新 specimen，因為那會保留雙重呈現權威並繞過 declarative consumer boundary。

## 當前階段

`ACW-C` 只新增：

- `catalog_declarative/adaptive_window_specimen.dart`
- `catalog_adaptive_window_main.dart`

specimen 必須真實掛載 `KlpAdaptive`，所有已知 `KlpAdaptivePlatform` 命中策略都回傳含 `KlpWindowControls` 的 `KlpAppLayout`；畫面顯示命中平台、最大化資料與最近 intent。三個 callback 只更新展示資料並重建 application tree。

既有公開策略與控制元件行為測試已是 Green，因此本 slice 不新增存在性測試。確定性接受證據為 declarative consumer boundary verifier、兩個精確檔案的 analyzer、既有兩組公開行為測試及可執行 target build；若 target build 被未變更的全域 dependency 阻擋，必須以既有 target 的同錯誤證明並保留 blocker，不得修改相依設定冒充本 slice 修復。

後續 249 項只作為能力 horizon：每個 family 仍須先在固定清冊契約成為 READY，才能取得自己的精確寫入路徑；本 stage 不預先建立空 specimen 或通用 renderer extension。

## Slice 與保護路徑

| Slice | 寫入範圍 | 完成證據 |
| --- | --- | --- |
| `ACW-C` | 上述兩個精確檔案 | boundary、analyze、既有行為測試、target build 或已證明的外部 dependency blocker、scope gate |

`architecture.md`、`lib/**`、`test/**`、`tool/**`、`example/test/**`、`pubspec.yaml` 與 `example/pubspec.yaml` 皆為受保護路徑。
