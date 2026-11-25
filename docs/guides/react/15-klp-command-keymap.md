# Registered 快捷鍵純核心

`KlpCommandKeymap<C>`借用同`KlpCommandRegistry<C>`，產品註冊command ID及預設組合。primary在mac對應meta，其餘對應ctrl；作用域固定component／region／page／app，再比priority及UTF-16 ID。產品提供當次context與原生focus鏈；沒有把handler或焦點複製到keymap。

```ts
const keymap = new KlpCommandKeymap(commands, { platform: 'other' });
const unregister = keymap.register({
	id: 'save.primary',
	commandId: 'document.save',
	sequence: [{ key: 's', primary: true }],
	scope: 'app',
});
const outcome = keymap.handle({ key: 's', ctrl: true }, { focusId: 'workspace' }, currentContext);
if (outcome.execution) await outcome.execution;
keymap.setOverride('save.primary', [{ key: 'k', primary: true }, { key: 's' }]);
const saved = JSON.stringify(keymap.exportOverrides());
keymap.importOverrides(JSON.parse(saved));
unregister();
keymap.dispose();
```

## API 查表

- [KlpCommandKeymap](../../reference/react/controllers/klp-command-keymap.md)
- [KlpCommandRegistry](../../reference/react/controllers/klp-command-registry.md)
