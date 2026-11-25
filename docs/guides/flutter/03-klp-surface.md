# 2. 組合產品畫面

產品使用 Flutter 的 `Row`、`Column`、`Stack`、`Expanded` 與自己的 Widget 組合畫面；共用視覺與互動使用 `kallopis_foundation.dart` 公開元件：

```dart
class ProductWorkspace extends StatelessWidget {
	const ProductWorkspace({super.key});

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		return KlpSurface(
			tone: KlpSurfaceTone.app,
			child: Padding(
				padding: EdgeInsets.all(space.base),
				child: Row(
					children: [
						const SizedBox(width: 280, child: ProductSidebar()),
						SizedBox(width: space.base),
						const Expanded(
							child: KlpStageFrame(
								content: Center(child: KlpText('Product content')),
							),
						),
					],
				),
			),
		);
	}
}
```

產品專用寬度、順序與流程留在產品；顏色、字級、間距、圓角與動效從 `context.klp` 取得，不建立第二份共用 theme，也不引用 `package:kallopis/src/...`。

## API 查表

- [KlpStageFrame](../../reference/flutter/components/layout/klp-stage-frame.md)
- [KlpSurface](../../reference/flutter/components/layout/klp-surface.md)
- [KlpSurfaceTone](../../reference/flutter/types/klp-surface-tone.md)
- [KlpText](../../reference/flutter/components/content/klp-text.md)
