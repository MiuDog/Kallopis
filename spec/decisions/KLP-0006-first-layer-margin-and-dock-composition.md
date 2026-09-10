# KLP-0006：第一層外距與 Dock 組合

- 狀態：Superseded by KLP-0008
- 日期：2026-09-03

> 2026-09-04：本決策的主內容外距所有權已由 KLP-0008 取代；第一層元件不再各自
> 補產品級外距。Dock 組合與能力邊界仍有效。
>
> 同日 KLP-0009 再次確認 Header 與 Dock 各自擁有 halfCompact margin，同時保留
> KLP-0008 的產品根 halfCompact padding。其後 KLP-0010 將 padding 提升到
> AppFrame 並包住 Header 與主內容；現行組合以 KLP-0010 為準。

## 決策

App background 上的第一層 panel 使用 `halfCompact = compact / 2` margin；Kallopis
預設風格解析為 4px。AppFrame 只鋪背景，不重複加入外距。Header、Workbench panes
與 KlpDockLayout 皆由自身的 Kallopis 元件責任點套用此語意。

新的 Sidebar＋Stage 產品畫面建議以 KlpDockLayout 組合。產品提供 panel registry、
內容、能力、受控 layout 與保存；Kallopis 提供第一層幾何、Area／Group、resize、tab
及拖放。Catalog 也使用此結構，其目錄 panel 為 side-only：
`allowSide: true`、`allowBottom: false`。

Catalog specimen 的風格語意必須直接出現在 subtitle／description；tooltip 保留為
多行補充，不得是唯一可查看入口。內容由原始碼生成，缺值明示「未宣告」。

## 理由

- 明確命名 4px 語意，避免各元件散落 `compact / 2`。
- 每個第一層 panel 各自貢獻外距，維持 app background 可見並避免巢狀雙重 inset。
- 將 Sidebar＋Stage 的互動與幾何集中在 Kallopis，避免產品各自重寫。
- 讓 Catalog 的風格檢查不依賴 hover，也不以人工說明取代實際程式來源。

## 後果

- 消費產品若在 Dock 外再包同一 margin，必須移除其中一層。
- 巢狀 Dock 只有在父層已擁有相同外距時才明確使用 `EdgeInsets.zero`。
- 產品必須為每個 panel 明確宣告停駐能力。
