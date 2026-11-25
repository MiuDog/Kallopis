# Dock 布局保存與載入

從 foundation 使用 KlpDockLayoutCodec.encode(layout) 取得版本化 JSON。產品擁有保存位置及何時採用布局，codec 不寫檔案、storage 或產品內容。載入成功的 layout／groups／panelIds 及診斷列表均不可變。

```dart
final saved = KlpDockLayoutCodec.encode(layout);
try {
	final restored = KlpDockLayoutCodec.restore(
		saved,
		panels: [
			for (final panel in panels)
				KlpDockPanelPolicy(
					id: panel.id,
					allowSide: panel.allowSide,
					allowBottom: panel.allowBottom,
				),
		],
	);
	// 產品自行顯示 missingPanelIds／availablePanelIds 後決定採用。
	setState(() => layout = restored.layout);
} on FormatException catch (error) {
	// 產品呈現 error；原本 layout 保持不變。
	showLoadError(error.message);
}
```

缺少面板按保存順序移除並回報；空群組刪除，選取項目消失則選剩下的第一個；未放置面板依清冊順序回報，庫不自動新增布局。版本、未知欄位、重複 id、非法 active／數值及停靠能力衝突會整份拒絕。完整 wire 與還原規則見 [Dock 保存契約](../../architecture/workbench-dock-contract.md)。reset 由產品提供預設 layout。現有受控 KlpDockLayout API 保留；本 codec 不代表 Dock 其餘 UI 補齊已完成。

## API 查表

- [KlpDockLayout](../../reference/flutter/components/workspace/klp-dock-layout.md)
- [KlpDockLayoutCodec](../../reference/flutter/types/klp-dock-layout-codec.md)
- [KlpDockPanelPolicy](../../reference/flutter/types/klp-dock-panel-policy.md)
