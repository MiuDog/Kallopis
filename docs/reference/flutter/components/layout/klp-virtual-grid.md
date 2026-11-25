# KlpVirtualGrid

Flutter · Stable · 布局元件

## 主要職責

格狀虛擬化捲動檢視。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpVirtualGrid createExample(int itemCount, Widget Function(BuildContext, int) itemBuilder) => KlpVirtualGrid(itemCount: itemCount, itemBuilder: itemBuilder);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpVirtualGrid extends StatelessWidget
```

## 建構子 KlpVirtualGrid



```dart
const KlpVirtualGrid({
	Key? key,
	required int itemCount,
	required IndexedWidgetBuilder itemBuilder,
	double minimumItemWidth = 240,
	int? crossAxisCount,
	double? spacing,
	double childAspectRatio = 1.0,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `itemCount` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `itemBuilder` | `Widget Function(BuildContext, int)` | 是 | — | 依公開型別提供此輸入。 |
| `minimumItemWidth` | `double` | 否 | 240 | 依公開型別提供此輸入。 |
| `crossAxisCount` | `int?` | 否 | null | 依公開型別提供此輸入。 |
| `spacing` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `childAspectRatio` | `double` | 否 | 1.0 | 依公開型別提供此輸入。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/layout/klp_virtual_grid.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_virtual_grid.dart`。
