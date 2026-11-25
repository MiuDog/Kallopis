# React 命令核心

`KlpCommandRegistry<C>` 從公開套件匯入；產品擁有registry生命週期及context，每次query/execute傳最新context。`register`回傳只解除該註冊者的函式；ID重用不受舊disposer影響。metadata字串須含非空白內容，原值保留；沒有全域registry或預設業務命令。

```ts
import { KlpCommandRegistry, type KlpCommandDefinition } from '@kallopis/react';

type Context = { canSave: boolean };
const commands = new KlpCommandRegistry<Context>();
const definition: KlpCommandDefinition<Context> = {
	id: 'document.save',
	label: '儲存',
	isEnabled: (context) => context.canSave,
	handler: () => productSave(),
};
const unregister = commands.register(definition);
const result = await commands.execute('document.save', latestContext);
if (result.status === 'error') showProductError(result.error);
// 產品卸載時解除註冊，並銷毀自己擁有的 registry。
unregister();
commands.dispose();
```

`getState`及`list`提供visible/enabled/checked/running與conditionError；呈現入口檢查visible與enabled為true、running為false，執行仍經registry重新驗證。相同註冊者pending時回busy，不同命令可並行；產品Promise開始後不會被解除註冊取消，舊結果不能清新owner的running。`subscribe`／`version`供宿主更新；外部closure變動用`refresh()`通知，不儲存第二份context。

## API 查表

- [KlpCommandDefinition](../../reference/react/types/klp-command-definition.md)
- [KlpCommandRegistry](../../reference/react/controllers/klp-command-registry.md)
