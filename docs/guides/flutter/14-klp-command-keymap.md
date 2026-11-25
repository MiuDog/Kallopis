# Registered 快捷鍵純核心

stable foundation的`KlpCommandKeymap<C>`借用同command registry，與既有KlpKeyBinding caller分開，不修改其事件權威。產品提供canonical keydown、有效focus鏈及當次context；primary平台投影與scope／priority／UTF-16 ID固定解析沿[共同契約](../../architecture/workbench-shortcut-core-contract.md)。

```dart
final keymap = KlpCommandKeymap<ProductContext>(registry: commands);
final unregister = keymap.register(KlpShortcutBinding<ProductContext>(
	id: 'save.primary',
	commandId: 'document.save',
	sequence: const [KlpShortcutStroke(key: 's', primary: true)],
	scope: KlpShortcutScope.app,
));
final outcome = keymap.handle(const KlpShortcutInput(key: 's', ctrl: true), const KlpShortcutFocus(focusId: 'workspace'), currentContext);
if (outcome.execution != null) await outcome.execution!;
keymap.setOverride('save.primary', const [KlpShortcutStroke(key: 'k', primary: true), KlpShortcutStroke(key: 's')]);
final saved = keymap.exportOverrides();
keymap.importOverrides(saved);
unregister();
keymap.dispose();
```

## API 查表

- [KlpCommandKeymap](../../reference/flutter/controllers/klp-command-keymap.md)
- [KlpShortcutBinding](../../reference/flutter/types/klp-shortcut-binding.md)
- [KlpShortcutFocus](../../reference/flutter/types/klp-shortcut-focus.md)
- [KlpShortcutInput](../../reference/flutter/types/klp-shortcut-input.md)
- [KlpShortcutScope](../../reference/flutter/types/klp-shortcut-scope.md)
- [KlpShortcutStroke](../../reference/flutter/types/klp-shortcut-stroke.md)
