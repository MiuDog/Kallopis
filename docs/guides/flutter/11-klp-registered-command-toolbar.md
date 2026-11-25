# Registered 命令工具列與選單

`KlpRegisteredCommandToolbar<C>`／`KlpRegisteredCommandMenu<C>`從stablefoundation使用。產品提供同registry、最新getContext、ID/order/kind及onResult；label、description、icon、enabled、checked、running都從registry投影，不複製第二份handler/state。

```dart
KlpRegisteredCommandToolbar<ProductContext>(
	registry: commands,
	getContext: () => currentContext,
	items: const [
		KlpCommandReference(commandId: 'document.save'),
		KlpCommandReference(commandId: 'view.grid', kind: KlpCommandKind.toggle),
	],
	label: '文件工具',
	onResult: handleProductResult,
)
KlpRegisteredCommandMenu<ProductContext>(
	registry: commands,
	getContext: () => currentContext,
	items: const [KlpCommandReference(commandId: 'document.save')],
	label: '文件命令',
	emptyLabel: '沒有可用命令',
	onResult: handleProductResult,
	onDismiss: closeProductPopup,
)
```

外部closure變動呼叫commands.refresh()。缺失/隱藏/條件錯誤項不呈現；停用/執行中項保持呈現但不進可用索引。toolbar左右、menu上下循環，Home/End跳首尾，Enter/Space只KeyDown啟動一次，repeat不啟動；menu Escape呼叫onDismiss。autoFocus預設false，true才在掛載後取得首可用項或空root焦點。

UI不取消已開始產品Future；samehost/sameregistry完成交最新onResult，卸載或更換registry後隔離舊結果，解除命令註冊仍保留原結果。onResult自身錯誤交FlutterError，不能偽裝成handler結果。風格讀context.klp，menu scroll/toolbar wrap保護有限宿主；popup使用下方公開入口，shortcut待接續。

## API 查表

- [KlpCommandKind](../../reference/flutter/types/klp-command-kind.md)
- [KlpCommandReference](../../reference/flutter/types/klp-command-reference.md)
- [KlpRegisteredCommandMenu](../../reference/flutter/components/actions/klp-registered-command-menu.md)
- [KlpRegisteredCommandToolbar](../../reference/flutter/components/actions/klp-registered-command-toolbar.md)
