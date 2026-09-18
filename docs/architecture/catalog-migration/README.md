# 舊 Catalog 全面遷移與移除

狀態：進行中；不得以首批完成宣稱全面完成。權威為使用者 2026-09-15 指示及 `spec/visual-component-governance.md`。

## 完成條件

1. 固定起始舊 Catalog 的每頁、specimen、hasDemo、coveredComponents 及舊來源，不因刪檔縮小分母。
2. 每項有新版公開宣告、受限組裝、資料與事件、唯一語意風格解析、可操作 Catalog 及驗證證據；缺失或占位保持 pending。
3. 保留新版已接受的 icon、按鈕列、Explorer、Frame 等風格，以及 hover／selected 同色。
4. 全面完成後刪除舊公開視覺元件、舊展示入口與已無使用者的專用實作，同步遷移本庫呼叫端。共用非視覺能力與已接受新版實作不得誤刪。
5. 不將舊 Widget 包一層或移到 private 就標成新版本；consumer 不可注入 Widget、builder、局部 style、painter。
6. KLP-0020 已取代的正文權威以現行宿主對應，不復活自研正文；移除舊 API 不可丟棄舊資料相容能力。

## 清冊與證據

`legacy-baseline.json` 由獨立 Test Author 固定，禁止實作 worker 更新分母。`coverage.json` 每項明列 pending／migrated／preserved；完整性檢查只證明清冊與檔案／宣告證據，不代替實際互動及人類視覺接受。

人類可讀的逐項對照見 [inventory.md](inventory.md)；更新該頁不得修改固定分母。機械權威仍為 baseline 與 coverage。

## 當前階段 CAT-TAX-01：重新定義 Catalog 分類

狀態：DEFINE READY，等待 `CAT-TAX-01` PLAN。使用者已接受 18 個 consumer-oriented 第一層分類，以及每項一個 primary category／多個 secondary tags；仍禁止依現有 class、資料夾或舊頁面直接配對 module。當前規格為 [`spec/catalog-classification.md`](../../../spec/catalog-classification.md)。

固定 254 項、既有 2 migrated／1 preserved 證據與已接受新版風格不變。分類規格接受後，先完成 254 項無 owner 欄位的分類清冊及 verifier；全部分類通過並由人類接受後，才形成能力家族、公開處置與 module ownership。

下列 `CAT-MIG-02` 保留為未執行候選，不是目前 BUILD 授權；其 `KlpAdaptive`／`KlpWindowControls` 配對必須等待新分類與能力家族結果重新確認。

## 暫停階段 CAT-MIG-02：既有新版 Adaptive／WindowControls 對帳

狀態：PAUSED；不得從本節啟動 BUILD。

### 接受契約 ACW-01

- `KlpAdaptive` 的新版權威是 `composition/nodes/klp_adaptive.dart`：consumer 只提供 `KlpPlatformStrategy` 回傳的 Kallopis-owned composite tree；不得使用 Flutter builder、`BuildContext` 或 Widget 分支。
- `KlpWindowControls` 的新版權威是 `features/workspace/components/klp_window_controls.dart`：consumer 提供最大化資料及三個 host intent callback；尺寸、圖示、平台風格與命中區由 Kallopis semantic adapter／bound renderer 擁有。
- 同一個正式 Catalog specimen 必須由 `kallopis_declarative.dart` 組裝，真實掛載 `KlpAdaptive`，並在命中的平台策略內呈現 `KlpWindowControls`。操作最小化、最大化／還原、關閉只更新展示資料，不呼叫原生 runner。
- Catalog 顯示目前命中的 `KlpAdaptivePlatform` 與最近一次 window intent，證明策略與事件是資料流，不以靜態截圖或 legacy Widget 冒充。
- `lib/src/rendering/flutter/internal/klp_flutter_window_controls.dart` 沒有 caller，且仍橋接 legacy theme／Widget；本 stage 刪除它，不建立 shim。現行 renderer `klp_flutter_workspace_components.dart` 保持唯一新版呈現。
- legacy `foundation/layout/klp_adaptive.dart`、`features/workspace/shell/window/klp_window_controls.dart` 及 Stable export 暫留，因舊 WindowHeader／Catalog／測試仍有 caller。Coverage 可在新版 Catalog、資料／事件、renderer 與測試證據齊全後標為 migrated，並明列 legacyRemoval 等待各 caller family 遷移；不能把暫留解讀為雙權威。

### ACW-01 切片與寫入邊界

| Slice | Owner | 寫入範圍 | 可觀察成果 |
| --- | --- | --- | --- |
| `ACW-T` | Existing test evidence | `test/klp_adaptive_declarative_test.dart`、`test/klp_workspace_components_declarative_test.dart` | 既有 Green 已證明策略命中、三 intent 與不可變資料更新；不新增只檢查檔案存在的低價值測試。Catalog 邊界由既有 consumer verifier 檢查。 |
| `ACW-C` | Catalog | `example/lib/catalog_declarative/adaptive_window_specimen.dart`、`example/lib/catalog_adaptive_window_main.dart` | 一個可執行 specimen 同時覆蓋兩個固定清冊項目，無 Flutter、`src`、legacy import。 |
| `ACW-R` | Rendering cleanup | `lib/src/rendering/flutter/internal/klp_flutter_window_controls.dart` | 刪除零 caller bridge；現行 bound renderer 與 dispatch 不變。 |
| `ACW-E` | Migration evidence | `docs/architecture/catalog-migration/coverage.json`、`inventory.md`、`verification.md`、`docs/ai/catalog-capability-map.md`、`docs/ai/catalog.md` | 兩項具有新版 API、Catalog、資料／事件、renderer 及測試路徑；固定分母仍為 254，pending 由 251 降至 249。 |

估算：以 CM-01 與現有 declarative specimen 為參考，4k–9k tokens／25–60 分鐘。M1 test＋specimen（累計 3k–6k／20–40 分），M2 dead bridge＋evidence（累計 4k–9k／25–60 分）；超過 13k／90 分鐘、發現非零 bridge caller，或必須改 public API／semantic style 時停止並回 PLAN。

驗收：兩個既有宣告式行為測試群保持 Green；新 Catalog 契約 Green；external compile boundary 拒絕 Widget／BuildContext；現行 renderer source 不 import legacy window shell；coverage 完整性仍以原 254 分母通過。視覺與原生視窗手感保持 human-pending。

## 已完成階段 CAT-MIG-01：選單垂直遷移

使用者已接受[完整選單互動](../../../spec/menu-interaction-migration.md)：庫管理定位、邊界、外部點擊／Escape 關閉、子選單展開／返回。以下 CM-01 是已實作面板切片的契約與證據，不是完整互動的能力上限。下一切片須依此規格更新配對契約；其餘元件按使用者要求逐組說明舊定位與新行為再決策。

原因：現行工作區雖接回舊選單，卻仍直接 import 舊 Widget，且公開命令丟失舊項目部分資訊。先建立可在新 Catalog 操作的真正資料式選單，後續逐家族依同一完成條件遷移。其他家族仍屬本次完整目標，不是 deferred。

### 共通契約 CM-01

- features：新增純 Dart `KlpMenu`（KlpNode）與封閉 `KlpMenuItem` 資料，使用唯一 id、標籤、可選既有 KlpWorkspaceIcon 圖示、快捷鍵顯示、勾選／切換、disabled、destructive、分隔與子選單指示；click／escape 為資料事件。沒有尺寸、顏色、Widget 或 builder。作為 FrameGroup content 使用，項目不可獨立放置或任意加子樹；重複 item id 拒絕。
- `KlpMenu` 為獨立選單面板，明確保留舊 Menu 的「只呈現面板，呼叫端管理何時顯示」責任。子選單旗標保持舊有指示用途，不假稱已實作遞迴定位。
- features：`KlpMenuAdapter` 準備不可變 `KlpBoundMenu`／`KlpBoundMenuStyle`。所有 callback 受 frame lease 控制，停用項不觸發。
- styling：`KlpMenuRecipe` 擁有舊選單幾何與配色映射；從已解析的表面、前景、互動、陰影、distance、radius、font 基準套用。保留舊選單標頭／項目／分隔與陰影；不修改現行全域 preset。
- rendering：新增私有 Flutter menu renderer，只消費 bound 值，提供方向鍵、Home／End、Enter／Space、Escape、停用跳過、滑鼠與語意；不引用舊 Menu 或建立 legacy theme。尺寸受 viewport 約束且內容可捲動。
- application：封閉 adapter 清單接入 Menu。公開 library 只匯出新純 Dart 宣告。
- Catalog：純宣告式入口展示正常、disabled、destructive、圖示、快捷鍵、分隔、勾選、子選單指示及狀態更新；工作區新外觀保持。
- 舊 Menu 暫時保留到依賴它的舊 Catalog 家族全部完成，最終刪除。本切片不能標記全面移除完成。

### 模組配對與白名單

| Slice | Owner | 寫入範圍 |
| --- | --- | --- |
| CM-S | styling | `lib/src/styling/presets/klp_menu_recipe.dart` |
| CM-F | features | `lib/src/features/overlays/declarative/`、`lib/src/features/catalog/component-ownership.json` |
| CM-R | rendering | `lib/src/rendering/flutter/internal/klp_flutter_menu_panel.dart`、`lib/src/rendering/flutter/klp_flutter_renderer.dart` |
| CM-A | application／公開入口 | `lib/src/application/bootstrap/internal/klp_application_adapters.dart`、`lib/kallopis_declarative.dart`、`lib/src/application/bootstrap/internal/klp_application_catalog.json` |
| CM-C | Catalog | `example/lib/catalog_declarative/menu_specimen.dart`、`example/lib/catalog_menu_main.dart` |

獨立測試路徑由 Test Author 擁有。其餘既有元件、primitive preset、fixture、baseline、測試設定與架構文件對 BUILD 唯讀。

冷啟動估算：本切片 12k–24k tokens／45–100 分鐘；無可比較歷史 task，沿用目前模型與本機 Flutter。M1 宣告／解析／安裝（累計 6k–12k／20–45 分），M2 互動／Catalog／驗證（累計 12k–24k／45–100 分）；超上限記錄原因與仍未完成項，不減少全庫遷移目標。

實際證據與完整待辦見 [verification.md](verification.md)。
