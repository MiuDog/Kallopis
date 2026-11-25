# React 命令工具列與選單

`KlpRegisteredCommandToolbar<C>`與`KlpRegisteredCommandMenu<C>`直接讀同一個registry；產品提供items的commandId/kind與排列，不複製label、handler或enabled。條件closure變動呼叫registry.refresh()；每次查詢及啟動都讀getContext最新資料。

```tsx
<KlpRegisteredCommandToolbar
	registry={commands}
	getContext={() => latestContext}
	items={[{ commandId: 'document.save' }, { commandId: 'view.grid', kind: 'toggle' }]}
	label="文件工具"
	onResult={handleProductResult}
/>
<KlpRegisteredCommandMenu
	registry={commands}
	getContext={() => latestContext}
	items={[{ commandId: 'document.save' }]}
	label="文件命令"
	emptyLabel="沒有可用命令"
	onResult={handleProductResult}
	onDismiss={closeProductPopup}
/>
```

toolbar左右、menu上下循環移動可用項；Home/End跳首尾、Enter/Space啟動一次。Menu Escape呼叫onDismiss；autoFocus預設false，明確true才取得首個可用項或空menu宿主焦點。缺失/隱藏/條件錯誤項不呈現；停用/執行中項仍呈現但不進可用索引。toggle映射checked，普通action沒有toggle語意。

非同步執行完成交最新onResult；入口卸載或更換registry後不再把舊結果交新宿主，同registry的原結果仍保留。onResult自身例外交原生error通道。style/className/id供外部有限宿主，內部呈現讀semantic；menu本身是原生平面入口，錨定／context選單使用下方registered popup。

## API 查表

- [KlpRegisteredCommandMenu](../../reference/react/components/actions/klp-registered-command-menu.md)
- [KlpRegisteredCommandToolbar](../../reference/react/components/actions/klp-registered-command-toolbar.md)
