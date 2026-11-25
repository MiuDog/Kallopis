# 3. 投影狀態與回傳事件

### Panel 的可選微立體

`KlpPanelFrame(elevation: KlpPanelElevation.raised, content: content)` 啟用原微立體效果；預設 `KlpPanelElevation.flat`。右下陰影與左上亮邊由共用配方及目前 semantic theme 決定，深色沿用低對比亮邊，不改變布局或內容裁切。此選項只適用 `KlpPanelFrame`，其他 frame 不會自動改變。Catalog 提供 flat／raised 展示；`example/lib/panel_relief_main.dart` 提供淺深色並排比較。

產品 controller 是唯一資料權威。Widget 接收目前值，使用 callback 把使用者操作送回 controller：

```dart
KlpFileExplorer(
	sections: controller.sections,
	selectedId: controller.selectedId,
	expandedSectionIds: controller.expandedSectionIds,
	expandedItemIds: controller.expandedItemIds,
	onItemSelected: controller.selectItem,
	onSectionToggle: controller.toggleSection,
	onItemToggle: controller.toggleItem,
)
```

Kallopis 元件可以持有 hover、focus、pressed 等內部暫態，但不接管產品資料、導航或保存流程。

## API 查表

- [KlpFileExplorer](../../reference/flutter/components/workspace/klp-file-explorer.md)
- [KlpPanelElevation](../../reference/flutter/types/klp-panel-elevation.md)
- [KlpPanelFrame](../../reference/flutter/components/layout/klp-panel-frame.md)
