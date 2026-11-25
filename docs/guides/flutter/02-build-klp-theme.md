# 1. 建立產品根節點

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

## API 查表

- [KlpLocalizationsDelegate](../../reference/flutter/types/klp-localizations-delegate.md)
- [buildKlpTheme](../../reference/flutter/styling/build-klp-theme.md)
