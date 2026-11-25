# Kallopis Reference

[Flutter](flutter/README.md) · [React](react/README.md) · [文件總入口](../README.md)

每份文件提供主要職責、公開入口、速成接入、完整本庫成員／方法及必要限制。框架繼承 API 連至官方文件。各平台只列目前真正公開的能力，名稱相同不代表參數或預設值相同。

| 能力 | Flutter | React |
| --- | --- | --- |
| 共用元件 | Widget、受控狀態與 callback | React 元件、Props 與原生事件 |
| 資料與型別 | class、enum、typedef | interface、type、聯集 |
| 控制與生命週期 | controller、command registry、keymap | command registry、keymap |
| 語意風格 | `context.klp`、theme、style pack | `KlpThemeProvider`、`useKlp`、style pack |
| 工具函式 | 公開函式與 extension | 公開函式與資料操作 |
| 平台整合 | 以 Flutter 索引中的實際公開能力為準 | 瀏覽器能力依各元件宿主契約；不宣稱原生平台對等 |

Flutter Stable 由 theme／foundation 入口提供，Experimental 逐頁標記。React 目前為 0.1，尚未發布 npm。

## 給 AI 的索引

[manifest.json](manifest.json) 每項包含 `id`、`framework`、`name`、`source`、`href`、`category`。先依平台與能力定位，再讀該頁及必要關聯頁；不要整庫預載。`source` 是 repository 根相對路徑。

## 維護

API 標記區由程式碼擷取，手動維護區是主要職責、速成使用、限制與關聯。更新命令與檢查方式見 [產生器說明](../../tool/reference_site/README.md)。公開 API 異動須同步文件；不得靠手改產生區隱藏差異。
