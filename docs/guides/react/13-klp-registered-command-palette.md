# React 命令面板

`KlpRegisteredCommandPalette<C>`查詢同registry全部可見命令；產品持有open與getContext，onDismiss更新open。搜尋包含label/id/description/category/各keyword，支援空白分詞、子字串與依序字元；disabled/running保留顯示但不能啟動。

```tsx
<KlpRegisteredCommandPalette
	registry={commands}
	getContext={() => latestContext}
	open={paletteOpen}
	label="命令面板"
	searchLabel="搜尋命令"
	emptyLabel="沒有符合的命令"
	onResult={handleProductResult}
	onDismiss={reason => setPaletteOpen(false)}
/>
```

上下選取、Enter執行、Escape與背景點擊提出關閉；成功執行後也提出關閉，錯誤保留面板供產品處理。搜尋input保留原生文字游標／composition；SSR待client mount才開啟modal。原生dialog由同Provider tokens及CSS投影取得風格，開關不改背景產品輸入。原生範例包含儲存pending、格線checked、可見及可用條件與失敗結果；[CommandsDemo](../../../react/example/commands-demo.tsx)全部使用公開library入口。

## API 查表

- [KlpRegisteredCommandPalette](../../reference/react/components/actions/klp-registered-command-palette.md)
