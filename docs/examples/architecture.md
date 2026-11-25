# 畫面範例文件

`catalog.md` 擁有 examples 的基礎角色到公開元件對照、畫面類型擴充白名單及採用門檻；README 為入口。它引用正式視覺規範而不複製 token，亦不取代由公開 declarations 生成的 API／specimen 清單。新增例外須明列類型與 slot，不允許 example 自行豁免共用元件風格。現有清單是採用盤點，不是全量合規或人類核准證據。

本模組擁有情境導覽、平台組裝說明與核准截圖；實際畫面仍在 flutter/example 與 react/example。Reference 說明元件 API，範例說明如何組合，不新增商業邏輯 library API。

狀態只有 draft（待迭代／確認）與 approved（使用者已接受具體畫面）。既有可執行示範不等於 approved。只有核准的實際版本可收錄至 assets 並列入已確認索引；保存版本、平台、風格與核准依據。

每個情境提供目的、來源、組裝架構、資料與 callback 所有權、semantic token 選用與限制。modern-productivity 表示既有布局情境，風格另依 style pack 記錄。規範連回 design-tokens，不複製數值。

桌面用途分類見 desktop-components.md，資料權威為 react/example/desktop-catalog-data.mjs；新增類型需同步兩者。元件內部實作由 react/src/desktop/architecture.md 擁有。

Catalog 目前以 CatalogSpecimen 直接共用全部既有 fixture；advanced-specimens.tsx 擁有新增通用元件的示範資料與狀態，NativeFieldSpecimen 展示 TextField 原生變體；不將宿主替身冒充真實 OS 功能。
