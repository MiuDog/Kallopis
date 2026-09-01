# Settings 呈現契約

## 目標

Kallopis 提供 `-ist` 產品共用的設定頁呈現語彙，使消費者只需提供設定資料、文案與事件，
不必重寫雙欄版面、導覽展開、欄位強調、固定動作列與顏色模式選擇器的風格。

本契約從 Planist 已驗證的 Settings 畫面抽取呈現方法，但不搬移 Planist 的產品資訊架構。
Notist 與其他消費者可用相同元件組合自己的設定內容。

## 公開元件

| 元件 | 責任 | 不負責 |
|---|---|---|
| `KlpSettingsPage` | 提供共同外框，依可用寬度切換雙欄／上下排列，並可受控調整導覽寬度 | Popup、route、scope 或寬度狀態 |
| `KlpSettingsNavigationPane` | 固定 header 並讓分組導覽獨立捲動 | 分組資料與選取狀態 |
| `KlpSettingsNavigationHeader` | 組合 identity、輔助動作與搜尋 slot | 帳號資料、搜尋狀態或權限 |
| `KlpSettingsSearchField` | 提供設定搜尋的標準小型欄位 | 建立索引或過濾 section |
| `KlpSettingsContentPane` | 提供標題、說明、可捲動內容與固定 footer | 取得或保存設定資料 |
| `KlpSettingsContentHeader` | 組合內容標題、說明與右側關閉／輔助動作 | 關閉 overlay 或 route |
| `KlpSettingsNavigationGroup` | 顯示不可收縮的分類標題 | 決定分類集合 |
| `KlpSettingsNavigationItem` | 顯示 section，僅在選取時展開 field deep link | 權限、dirty guard 或 deep-link 路由 |
| `KlpSettingsField` | 顯示欄位標題、說明、控制項與定位強調 | 驗證或資料繫結 |
| `KlpSettingsActionBar` | 顯示固定狀態訊息與動作 slots | save state machine |
| `KlpThemeModePicker` | 以 `KlpThemePreviewTile` 排列受控的顏色模式選項 | 保存偏好或解析系統模式 |

## 視覺規則

- 所有顏色只能由 `context.klp` 的 semantic color token 解析。
- 設定 pane 在所有模式都維持左深右淺：導覽 pane 亮態使用 `base`、暗態使用 `component`，內容 pane 固定使用 `raised`；欄位定位使用 `muted`。
- 兩 pane 的間距由 `layout.settingsPaneGap` 控制，標準值使用 `space200`，resize handle 與窄版垂直間距必須共用同一值。
- 兩個 pane 共用 overlay 外框；導覽與內容表面連續，以 semantic divider／resize handle 分隔。
- pane 內距、圓角、導引線、導覽寬度範圍與預覽圖尺寸全部由 theme token 決定。
- 寬版使用可受控調整的 semantic navigation width；窄版改為上下排列，不縮放文字。
- identity 與搜尋固定於導覽捲動區外；長導覽只捲動分組項目。
- footer 位於內容捲動區外；內容過長時只捲動內容，不捲走 footer。
- section 的 field deep link 只在 section 被選取時建立，並以 semantic divider 顯示左側導引線。
- 顏色模式選取是受控狀態；切換動畫與偏好保存由產品處理。

## 明確邊界

下列項目保留在產品層：

- Project／App scope、設定 section descriptor、stable field ID 與搜尋索引。
- 權限、capability、restricted／decision-required 狀態與產品文案。
- dirty／saving／saved／invalid／failure 狀態機，以及 save／discard／cancel guard。
- 原生透明視窗能力、偏好 migration、accent 策展清單與持久化。
- Settings 的入口、route、Popup 尺寸與 Screen composition。

## 驗收條件

- 同一組內容在寬版呈現左右雙欄，在窄版呈現上下排列且不 overflow。
- 寬版 resize handle 回報已依 semantic 最小／最大值夾制的導覽寬度。
- identity 與搜尋在長導覽捲動時仍留在 pane 頂端。
- 未選取 section 不建立 field deep link；選取後才建立並顯示 token 導引線。
- content footer 不屬於捲動 viewport。
- Theme picker 可呈現 Light、Dark、Ultra Dark、System 與 Transparent，且回報選取事件。
- Catalog 同時展示完整設定頁、個別設定元件與所有顏色模式。
- token discipline、公開 consumer contract、Catalog coverage、analyze 與 tests 全部通過。
