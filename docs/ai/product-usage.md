# Kallopis 唯一產品使用指南

Kallopis 是 Flutter design system，不是 application framework。產品擁有 app root、導航、畫面結構、狀態與業務流程；Kallopis 擁有 semantic theme、公開共用元件，以及元件內部的視覺、互動、無障礙與平台適應。

## 1. 建立產品根節點

產品直接使用 `MaterialApp`，並安裝 Kallopis theme 與語系 delegate：

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

void main() {
	runApp(const ProductApp());
}

class ProductApp extends StatelessWidget {
	const ProductApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: buildKlpTheme(Brightness.light),
			darkTheme: buildKlpTheme(Brightness.dark),
			localizationsDelegates: const [KlpLocalizationsDelegate()],
			home: const ProductWorkspace(),
		);
	}
}
```

## 2. 組合產品畫面

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

## 3. 投影狀態與回傳事件

產品 controller 是唯一資料權威。Widget 接收目前值，使用 callback 把使用者操作送回 controller：

```dart
KlpFileExplorer(
	sections: controller.sections,
	selectedId: controller.selectedId,
	expandedSectionIds: controller.expandedSectionIds,
	expandedItemIds: controller.expandedItemIds,
	onItemSelected: controller.selectItem,
	onSectionToggle: controller.toggleSection,
	onItemToggle: controller.toggleItem,
)
```

Kallopis 元件可以持有 hover、focus、pressed 等內部暫態，但不接管產品資料、導航或保存流程。

## 4. 使用高階實驗元件

尚未穩定、但已證明跨產品重用的直接 Flutter 元件可從 `kallopis_experimental.dart` 匯入。產品專用 editor host、WebView bridge、packaged asset 與 session 接線不屬於 Kallopis；它們留在產品自己的 capability module，並可在內部使用 Kallopis theme 與公開共用元件。

例如 Planist 的 BlockNote 與 Canva host 分別由 Flow／Canva presentation 擁有，Workspace 只取得既有 session 並組裝 editor。正文、selection、undo 與 persistence 仍由 Krepis／provider 掌管。

## 5. 元件缺口處理

Kallopis 沒有某個產品畫面時，產品直接建立 Flutter Widget，並沿用 Kallopis semantic theme。只有同一能力已證明跨產品重用，才提升為 Kallopis 公開元件。

禁止建立 declarative node、application host、adapter／bound model、私有 renderer、相容 shim、feature flag 或第二條產品接入路徑。
