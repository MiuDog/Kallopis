# 可替換風格

以 `createKlpStylePack(jsonOrObject)` 匯入完整 style pack，省略參數採用 Kallopis 預設。schema／canonical ID／四模式參數都驗證成功才接受；回傳深度不可變且與來源隔離的 pack。`klpStyleParameters` 提供 350 項語意的型別、單位、限制、用途及直接引用配方。

```tsx
import { createKlpStylePack, applyKlpStyleOverrides, KlpThemeProvider } from '@kallopis/react';

const initial = createKlpStylePack();
const roomier = applyKlpStyleOverrides(initial, {
	semantics: {
		'theme.spacing.contentInlineGap': { light: 'p(space300)' },
	},
});

export function StyledProduct() {
	return <KlpThemeProvider mode="light" stylePack={roomier}>產品內容</KlpThemeProvider>;
}
```

`applyKlpStyleOverrides` 只覆寫已有 primitive 或 partial mode semantic；成功回傳新 pack，失敗不修改原值。Provider 對全部 CSS variables 與 hook 同步採用 scoped 風格；巢狀 Provider 可獨立切換。example 提供檔案／完整 JSON 貼上匯入、錯誤保留及預設還原。

產物另包含 common runtime／default pack／catalog 的來源雜湊，`check:tokens` 檢查新鮮度。生成的 `src/style-pack-data.ts`、`src/style-runtime/`、manifest 不手改；打包後不依賴 checkout 的 styles/。目前接入 typed semantic；recipe 原文仍供查詢，不能宣稱所有 recipe 參數已影響元件或任意風格下布局已驗收。

## API 查表

- [applyKlpStyleOverrides](../../reference/react/styling/apply-klp-style-overrides.md)
- [createKlpStylePack](../../reference/react/styling/create-klp-style-pack.md)
- [KlpThemeProvider](../../reference/react/styling/klp-theme-provider.md)
