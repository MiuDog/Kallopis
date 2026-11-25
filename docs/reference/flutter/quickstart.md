# Flutter 速成接入

套件根目錄是 repository 的 `flutter/`。在產品的 pubspec 將 `kallopis` path dependency 指向該目錄，再執行 `flutter pub get`；Git dependency 使用 repository 的 `flutter` subdirectory。資產由 package 擁有，不複製字型到產品。

## 第一個畫面

以下可作為產品的 `lib/main.dart`：

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

void main() => runApp(const ProductApp());

class ProductApp extends StatelessWidget {
	const ProductApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: buildKlpTheme(Brightness.light),
			darkTheme: buildKlpTheme(Brightness.dark),
			localizationsDelegates: const [KlpLocalizationsDelegate()],
			home: Scaffold(body: Center(child: KlpButton(label: '儲存', onPressed: () {}))),
		);
	}
}
```

產品持有選取、資料、路由與事件回呼。產品專用視覺從 `context.klp` 取 semantic theme；不要匯入 `lib/src`，也不要複製共用元件的預設樣式。

## 下一步

- [所有公開能力](README.md)
- [KlpButton](components/actions/klp-button.md)
- [跨元件使用流程](../../ai/product-usage.md)
- [畫面範例](../../examples/README.md)
- [正式 token 規範](../../design-tokens/KALLOPIS-DESIGN-MAP.md)
