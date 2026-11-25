# 桌面工作台插槽模板

搭配 [雙區工作台](../sidebar-stage-workbench/README.md) 使用。複製此目錄的 TSX 與 CSS，引用既有 `@kallopis/react` 公開元件。

- `WindowToolbar`：圖示與回呼由宿主提供；本模板不存取 Electron。
- `SidebarBanner`：左側內容與右側操作插槽，平面呈現與低對比虛線。
- `SettingsLayout`：設定視窗導覽約 22%、內容占其餘空間；頁首與未保存提示採插槽。

側欄完全收合後，展開控制移到 Stage header 左端。Header 導覽只改清單，Stage 由明確選取決定，不生成預設內容。一般 Stage 水平內距為基礎 inset 兩倍；無限畫布吃滿 Panel。選單與巢狀內容採平面規則。

團隊、帳戶、設定分類、路由、保存、dirty 判定、視窗 IPC 與執行權限全部留在 consumer。完整實作責任見 [architecture.md](architecture.md)，風格權威見 [recipes.md](../../docs/design-tokens/recipes.md)。
