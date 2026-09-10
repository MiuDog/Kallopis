# Sidebar＋Stage 畫面組合

新的桌面產品畫面若由 Sidebar 與固定 Stage 組成，優先使用 `KlpDockLayout`。
Kallopis 負責 AppFrame padding、panel surface、resize、tab 與合法停駐；產品提供
內容、能力、目前 layout 與持久化。

## 第一層布局規則

```text
KlpApp
└─ app background
   └─ AppFrame → appFrameInset（預設 4px）
      ├─ KlpWindowHeader → windowHeaderMargin（預設 4px）
      └─ product content root
         └─ KlpDockLayout／Panel Tree
            └─ KlpPanelFrame → dockMargin（預設 4px）
            ├─ Left／Right side panels
            ├─ fixed Stage
            └─ optional Bottom panels
```

- AppFrame 一律套用一次 `context.klp.space.appFrameInset` padding，同時包住 Header
  與產品主內容。
- App Header 自身解析 `windowHeaderMargin`；AppFrame 4px 與 Header 4px 共同形成 8px gutter。
- Panel Tree 的 `KlpPanelFrame` 解析 `dockMargin`；與 AppFrame 相鄰時同樣形成 8px gutter。
- appFrameInset、windowHeaderMargin、dockMargin、pane gap 與 panel 內距是不同語意，
  即使預設值相同也不得互相代替。

## App Header 拖動

`KlpWindowHeader` 的完整占位範圍（包含自身 margin）都是平台視窗拖動範圍。產品可
注入 leading、actions、trailing 等操作元件；一般點擊仍由子元件處理，拖動超過手勢
門檻後才由 Header 父層呼叫平台視窗拖動。雙擊最大化只保留在 identity 與空白等
非互動區域。

## Panel 能力

```dart
KlpDockPanel(
	id: 'navigation',
	header: const KlpText('目錄', role: KlpTextRole.code),
	content: navigation,
	allowSide: true,
	allowBottom: false,
)
```

目錄、Explorer 與主要 Sidebar 通常是 side-only：可在 Left／Right 間移動，不能
進入 Bottom。Terminal、Problems 等橫向工具才適合 `allowBottom: true`；是否也能
放在側邊必須由產品需求明確決定。

## Panel 捲軸

Panel 內容需要垂直捲動時，讓 `KlpPanelFrame` 與內層 Scrollable 共用同一個
`ScrollController`。Frame 會保留內容原有的 8px `chromePanelInset`，並把 5px
Scrollbar thumb 置中於尾側 8px padding 槽，而不是放進 padding 後的內容區。

透過 Dock 組合時，把 controller 同時傳給 `KlpDockPanel.contentScrollController`
與 Navigator／Explorer；Frame 會停用該內容子樹的桌面自動 scrollbar，避免出現兩條
軌道。若內容有多個彼此獨立的捲動區，則由產品先明確指定哪一個 Scrollable 屬於
panel 主捲動，不得讓一個 controller 同時掛到多個 ScrollPosition。

## AI 組裝契約

```text
composeSidebarStage(product):
	panels = product.panelRegistry
	layout = product.persistedDockLayout or product.initialDockLayout
	for each panel:
		require stable id
		require explicit allowSide and allowBottom
	return KlpDockLayout(
		stage: product.stage,
		panels: panels,
		layout: layout,
		onLayoutChanged: product.saveLayout,
		constraints: product.confirmedConstraints,
	)
```

AI 不應在產品端以 Row／Stack 重寫 Dock 行為，也不應替未確認的 panel 猜測能力、
尺寸限制或保存策略。Catalog 的目錄範例固定為 `allowSide: true`、
`allowBottom: false`。
