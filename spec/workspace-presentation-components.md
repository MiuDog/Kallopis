# Workspace presentation components

## Outcome

Kallopis 提供桌面知識工作區所需的無產品語意視覺元件，讓第一個消費者只傳入內容與事件，
不自行指定色彩、字體、圓角、控制尺寸或 panel 內距。

## Visual contract

1. Window header 版面占位為 40px，其中可視表面高度為 24px，上下各有一個
   `space.compact` margin。
2. Workbench 外框與相鄰 panel 的可視表面間距皆沿用 `space.compact`；預設為 8px。
3. Primary Sidebar identity 與 navigation row 高度皆為 36px。
4. Navigation group 的相鄰列間距為 hairline（預設 2px）。
5. Workbench resize hit area 與 pane gap 同寬，中央 grip 為 2×28px。
6. File Explorer section header 高 20px、水平內縮 12px，caret 為 10px。
7. Journals、對話與資產瀑布流所需元件只描述通用日期、訊息、輸入與內容卡片，不包含 Notist 文案或資料模型。

## Architecture constraints

- 元件的風格只讀取 `context.klp`。
- 產品只提供 sidebar destination 等產品狀態；標準工作舞台透過
  `KlpStageFrame.workbench` 取得 Kallopis 的完整組合，不自行排 header 與 status。
- Catalog 必須展示新增的公開 Widget，並由既有 Catalog coverage 與三主題渲染測試覆蓋。

## Acceptance criteria

1. Notist 的既有絕對布局測試不修改且全部通過。
2. Kallopis 公開 resize handle、primary sidebar frame 與 navigation group。
3. Explorer 在空資料狀態仍可呈現產品提供的結構分區。
4. 新工作區內容元件全部出現在 Catalog registry。
5. Kallopis 與 Notist analyze、test 均通過。
