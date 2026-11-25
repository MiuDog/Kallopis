# Unico：側欄與 Stage 組裝回饋

此布局已由使用者要求命名並保存為 [Kallopis 雙區工作台（sidebar-stage-workbench）](../../templates/sidebar-stage-workbench/README.md)。後續複製以具名模板為準；本頁較早的探索尺寸與「不提升為模板」記錄為當時狀態，已由使用者此次明確要求取代。不新增套件公開 API，也不聲稱已有第二個消費者。

日期：2026-10-17。狀態：已建立並觀察渲染，仍待使用者確認視覺與手感；不是通用模板提案。

使用者已追加確認[側欄與 Stage Header 規則](../design-tokens/recipes.md#側欄與-stage-header2026-10-17-使用者已確認)，Unico 已移除側欄名稱、保留 header 空區與收合／展開控制，並在 Stage 主內容 Panel 上方保留透明 header 空間，標題留在內容中。此限制已進正式規範，不在此維護第二份條文。

## 已使用組成

預設 `KlpThemeProvider` → 不換行的 `KlpWorkspace` → 兩個 `KlpFrame surface="raised"`。左側採 `role="sidebar"`，右側為 content Stage，無額外全域 header、右區或底區。左側用 `KlpButton tone="ghost"` 顯示主要功能與目前入口的內部功能，產品持有 selected、aria-current 與 hash 路由。

Kallopis 持有字型、tokens、微立體配方與按鈕內部互動；Unico 持有入口名稱、歸屬、路由及業務狀態。Workspace 目前預設可換行，產品依兩區限制用 CSS flex-wrap: nowrap；高度、捲動與排列仍由產品配置。未新增產品專用共用元件。

## 證據及引用限制

Unico frontend/architecture.md 與 docs/verification/sidebar-stage-2026-10-17.png 記錄實作與 1280×720 畫面。已觀察 Agents、設定、返回切換；尚未接引擎。使用本機 React 工作樹建置的 0.1.0 tarball，來源狀態與 SHA256 記錄於 Unico vendor/README.md，並非遠端正式發布版本。

未證明第二個消費者需要相同導覽，不提升為 Kallopis 固定模板。後續觀察可用性、鍵盤操作與跨產品需求，再判斷共用規則是否需要調整。

追加實作證據：依最新 Header 條文，Stage header 中檢查元件使用公開 raised Frame，頂緣對齊 sidebar 外框；sidebar header 按鈕為正方形，底部 padding 中心有低對比細虛線，垂直對齊右側 header／Stage 留白中心。正式條文取代先前兩邊元件同高同頂緣的規則。Unico 已建置及量測核對，畫面為 header-panel-divider-2026-10-17.png。
