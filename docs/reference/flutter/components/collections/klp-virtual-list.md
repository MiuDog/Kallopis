# KlpVirtualList

Flutter · Stable · 資料呈現

## 主要職責

長清單虛擬化捲動檢視。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpVirtualList createExample(int itemCount, Widget Function(BuildContext, int) itemBuilder) => KlpVirtualList(itemCount: itemCount, itemBuilder: itemBuilder);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpVirtualList extends StatelessWidget
```

## 建構子 KlpVirtualList



```dart
const KlpVirtualList({
	Key? key,
	required int itemCount,
	required IndexedWidgetBuilder itemBuilder,
	ScrollController? controller,
	EdgeInsetsGeometry? padding,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `itemCount` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `itemBuilder` | `Widget Function(BuildContext, int)` | 是 | — | 依公開型別提供此輸入。 |
| `controller` | `ScrollController?` | 否 | null | 借用產品提供的控制器。 |
| `padding` | `EdgeInsetsGeometry?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/foundation/layout/klp_virtual_list.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_virtual_list.dart`。
