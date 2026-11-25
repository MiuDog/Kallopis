# React 速成接入

`@kallopis/react` 目前尚未發布 npm。先在 repository 的 `react/` 執行：

```sh
npm ci
npm run build
npm pack
```

在使用 React 19 的產品安裝產生的套件檔：`npm install /path/to/kallopis-react-0.1.0.tgz`。公開入口是 `@kallopis/react`，樣式入口是 `@kallopis/react/styles.css`。

## 第一個畫面

```tsx
import { KlpThemeProvider, KlpFrame, KlpButton } from '@kallopis/react';
import '@kallopis/react/styles.css';

export function ProductPanel() {
	return <KlpThemeProvider mode="light">
		<KlpFrame header="內容">
			<KlpButton onClick={() => {}}>儲存</KlpButton>
		</KlpFrame>
	</KlpThemeProvider>;
}
```

共用元件必須在 Provider 內使用。產品持有 state、資料與 callback；需要產品專用樣式時，在 Provider 內以 `useKlp().semantic(id)` 讀正式語意，不建立第二份 theme 預設。

## 下一步

- [所有公開能力](README.md)
- [KlpButton](components/actions/klp-button.md)
- [跨元件使用流程](../../ai/react-usage.md)
- [畫面範例](../../examples/README.md)
- [正式 token 規範](../../design-tokens/KALLOPIS-DESIGN-MAP.md)
