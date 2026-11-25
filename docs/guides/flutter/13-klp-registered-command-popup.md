# Registered 錨定與右鍵命令選單

stable foundation 的 `KlpRegisteredCommandPopup<C>`沿用同registry／getContext／items／label／emptyLabel／onResult，另必填受控open、原生Rect anchor及onDismiss。anchor為同視窗邏輯viewport座標；按鈕以原生RenderBox bounds，context pointer用globalPosition與Size.zero。有限位置依當前context.klp決定偏好下方、翻上方或較大側，保留同公開menu的scroll及鍵盤行為。

```dart
KlpRegisteredCommandPopup<ProductContext>(
	registry: commands,
	getContext: () => currentContext,
	items: const [KlpCommandReference(commandId: 'document.save')],
	open: popupOpen,
	anchor: popupAnchor,
	label: '文件命令',
	emptyLabel: '没有可用命令',
	onResult: handleProductResult,
	onDismiss: (reason) => setState(() => popupOpen = false),
)
```

## API 查表

- [KlpCommandReference](../../reference/flutter/types/klp-command-reference.md)
- [KlpRegisteredCommandPopup](../../reference/flutter/components/actions/klp-registered-command-popup.md)
