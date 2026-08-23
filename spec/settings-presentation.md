# Settings 呈現契約

## 目標

Kallopis 提供 `-ist` 產品共用的設定頁呈現語彙，使消費者只需提供設定資料、文案與事件，
不必重寫雙欄版面、導覽展開、欄位強調、固定動作列與顏色模式選擇器的風格。

本契約從 Planist 已驗證的 Settings 畫面抽取呈現方法，但不搬移 Planist 的產品資訊架構。
Notist 與其他消費者可用相同元件組合自己的設定內容。

## 公開元件

| 元件 | 責任 | 不負責 |
|---|---|---|
| `KlpSettingsPage` | 依可用寬度在雙欄與上下排列間切換 | Popup、route、scope 或關閉流程 |
| `KlpSettingsNavigationPane` | 提供設定導覽的表面、捲動與預設內距 | 搜尋、分組資料與選取狀態 |
| `KlpSettingsContentPane` | 提供標題、說明、可捲動內容與固定 footer | 取得或保存設定資料 |
| `KlpSettingsNavigationGroup` | 顯示不可收縮的分類標題 | 決定分類集合 |
| `KlpSettingsNavigationItem` | 顯示 section，僅在選取時展開 field deep link | 權限、dirty guard 或 deep-link 路由 |
| `KlpSettingsField` | 顯示欄位標題、說明、控制項與定位強調 | 驗證或資料繫結 |
| `KlpSettingsActionBar` | 顯示固定狀態訊息與動作 slots | save state machine |
| `KlpThemeModePicker` | 以 `KlpThemePreviewTile` 排列受控的顏色模式選項 | 保存偏好或解析系統模式 |

## 視覺規則

- 所有顏色只能由 `context.klp` 的 semantic color token 解析。
- 導覽 pane 使用 `base` 表面，內容 pane 使用 `raised` 表面；欄位定位使用 `muted` 表面。
- pane 間距、內距、圓角、導引線與預覽圖尺寸全部由 theme token 決定。
- 寬版使用固定 semantic navigation width；窄版改為上下排列，不縮放文字。
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
- 未選取 section 不建立 field deep link；選取後才建立並顯示 token 導引線。
- content footer 不屬於捲動 viewport。
- Theme picker 可呈現 Light、Dark、Ultra Dark、System 與 Transparent，且回報選取事件。
- Catalog 同時展示完整設定頁、個別設定元件與所有顏色模式。
- token discipline、公開 consumer contract、Catalog coverage、analyze 與 tests 全部通過。
