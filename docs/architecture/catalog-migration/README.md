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

## 當前階段 CAT-MIG-01：選單垂直遷移

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
