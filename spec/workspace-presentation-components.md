# Workspace presentation components

## Outcome

Kallopis 提供桌面知識工作區所需的無產品語意視覺元件，讓第一個消費者只傳入內容與事件，
不自行指定色彩、字體、圓角、控制尺寸或 panel 內距。

## Visual contract

1. Window header 預設高度為 44px。
2. Workbench 外框左右與底部、相鄰 panel 間距皆沿用 `space.compact`；預設為 10px，頂部為 0。
3. Primary Sidebar identity 與 navigation row 高度皆為 36px。
4. Navigation group 的相鄰列間距為 hairline（預設 2px）。
5. Workbench resize hit area 與 pane gap 同寬，中央 grip 為 2×28px。
6. File Explorer section header 高 20px、水平內縮 12px，caret 為 10px。
7. Journals、對話與資產瀑布流所需元件只描述通用日期、訊息、輸入與內容卡片，不包含 Notist 文案或資料模型。

## Architecture constraints

- 元件的風格只讀取 `context.klp`。
- Notist 只組合公開元件；sidebar width 與 destination 是產品布局／狀態，不下沉 Kallopis。
- Catalog 必須展示新增的公開 Widget，並由既有 Catalog coverage 與三主題渲染測試覆蓋。

## Acceptance criteria

1. Notist 的既有絕對布局測試不修改且全部通過。
2. Kallopis 公開 resize handle、primary sidebar frame 與 navigation group。
3. Explorer 在空資料狀態仍可呈現產品提供的結構分區。
4. 新工作區內容元件全部出現在 Catalog registry。
5. Kallopis 與 Notist analyze、test 均通過。
