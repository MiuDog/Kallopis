# Registered 命令面板

`KlpRegisteredCommandPalette<C>`從stable foundation使用，產品控制open；全部候選、條件與執行仍讀同registry。三個label由產品本地化且不得空白。mount於現有Overlay／semantic theme宿主下，浮層會隨caller重建刷新同主題、方向與locale。

```dart
KlpRegisteredCommandPalette<ProductContext>(
	registry: commands,
	getContext: () => currentContext,
	open: commandPaletteOpen,
	label: '全部命令',
	searchLabel: '搜尋命令',
	emptyLabel: '沒有符合的命令',
	onResult: handleProductResult,
	onDismiss: (reason) => setState(() => commandPaletteOpen = false),
)
```

搜尋支援多詞與跨metadata field、完整／前綴／包含／子序列固定score，最後依UTF-16 ID排序。停用或執行中候選仍呈現但不可選。上下循環、Enter一次執行、Tab保留輸入、Escape／outside只提出關閉意圖；Home／End／左右及composition保留原生文字編輯。成功結果提出executed關閉，錯誤保留面板由產品呈現；關閉／重開／替換registry隔離舊Future UI結果。

## API 查表

- [KlpRegisteredCommandPalette](../../reference/flutter/components/actions/klp-registered-command-palette.md)
