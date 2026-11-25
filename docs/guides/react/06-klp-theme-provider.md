# 一般布局與尺寸限制

Row／Column／Pane 接受 `flex`（預設 1）及 `bounds: {minimum?, maximum?, preferred?}`；Spacer 的 flex 必須大於零。合法直接 child 為這些布局元件及 Divider，可用 Fragment／null 做條件組合；Pane 內可放任意產品 React 內容。Root 接受單一 Row／Column／Pane。

```tsx
import { KlpThemeProvider, KlpAppLayout, KlpLayoutRow, KlpLayoutPane, KlpLayoutDivider } from '@kallopis/react';

export function ProductLayout() {
	return <KlpThemeProvider>
		<div style={{ width: '100%', height: 280 }}>
			<KlpAppLayout>
				<KlpLayoutRow>
					<KlpLayoutPane flex={0} bounds={{ minimum: 80, preferred: 120, maximum: 160 }}>側欄內容</KlpLayoutPane>
					<KlpLayoutDivider />
					<KlpLayoutPane bounds={{ minimum: 80 }}>產品內容</KlpLayoutPane>
				</KlpLayoutRow>
			</KlpAppLayout>
		</div>
	</KlpThemeProvider>;
}
```

`spacing="none"` 取消普通相鄰 gap，顯式 Divider 仍有語意尺寸；`alignment="end"` 把 maximum 產生的留白放在開頭。Root `inset="none"` 可取消外距。所有間距讀取 scope 的 `theme.spacing.space2`，不足空間與極大值會依 [共通契約](../../architecture/workbench-linear-contract.md) 壓縮，內容每槽裁切。

預設 `sizing="fill"` 使用 enclosing CSS 容器尺寸，產品需提供希望填滿軸的明確尺寸。`sizing="content"` 使用有限自然／preferred 主軸總和，flex 不延伸填滿；Web 沒有 Flutter 的 Infinity constraint 訊號。不要藉內部 grid／gap 樣式繞過尺寸算法，使用 bounds 或產品外部容器調整。

元素 ResizeObserver、scope 更新與內容變更會重新量測；沒有 ResizeObserver 時保留首次量測與 resize fallback。SSR 先呈現可及 DOM，client 掛載後才完成量測。example 提供窄容器、end alignment、極大語意 gap、還原與原生輸入保留展示。

## API 查表

- [KlpAppLayout](../../reference/react/components/workspace/klp-app-layout.md)
- [KlpLayoutDivider](../../reference/react/components/layout/klp-layout-divider.md)
- [KlpLayoutPane](../../reference/react/components/layout/klp-layout-pane.md)
- [KlpLayoutRow](../../reference/react/components/layout/klp-layout-row.md)
- [KlpThemeProvider](../../reference/react/styling/klp-theme-provider.md)
