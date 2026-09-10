# 目錄重整：舊頂層目錄退役

本文件記錄 2026-09-10 的實體路徑遷移。目的不是以新名稱包住舊架構，而是讓來源位置直接表達責任；舊 Flutter 呈現實作仍屬於其功能或 foundation 範圍，不能被誤認為宣告式公開 API。

## 退役對照

| 舊頂層 | 新位置 | 責任 |
| --- | --- | --- |
| `app`、`l10n` | `application/legacy`、`application/localization` | 舊組合根與語系接線 |
| `tokens`、`theme`、`styles` | `styling/legacy_tokens`、`styling/legacy_theme`、`styling/presets/legacy` | 舊風格系統，與新 styling schema 並列直到替換完成 |
| `layout`、`surface`、`typography`、`interaction`、`components` | `foundation` 對應責任目錄 | 可重用基礎呈現能力 |
| `controls`、`form` | `features/actions`、`features/forms` | 操作與輸入功能 |
| `data` | `features/collections` | 集合與資料呈現功能 |
| `navigation`、`routing` | `features/navigation` | 可見導覽功能與舊 Router 實作 |
| `feedback`、`overlay` | `features/feedback`、`features/overlays` | 回饋與覆層功能 |
| `shell`、`settings` | `features/workspace` | 工作區組合功能 |
| `editor` | `features/actions`、`features/workspace`、`features/infinite_canvas` | 各自歸入可重用功能，而非以 editor 作總類別 |

`kernel`、`composition`、`capabilities`、`styling`、`foundation`、`features`、`runtime`、`rendering` 與 `application` 是重整後僅保留的架構根。各舊實作後續會以宣告式定義、受控 renderer 與功能契約逐步取代；路徑遷移本身不把舊 Widget API 宣告為新 API。

## 驗收

1. `lib/src` 不保留退役頂層目錄。
2. Dart 的 import、export 與 part 指向搬移後的位置。
3. 架構圖集、inventory、前端邊界測試與 analyzer 反映新路徑。
