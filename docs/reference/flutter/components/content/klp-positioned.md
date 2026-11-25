# KlpPositioned

Flutter · Stable · 內容元件

## 主要職責

絕對/相對定位排版原語。取代 Positioned。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPositioned createExample(Widget child) => KlpPositioned(child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPositioned extends StatelessWidget
```

## 建構子 KlpPositioned



```dart
const KlpPositioned({
	Key? key,
	double? left,
	double? top,
	double? right,
	double? bottom,
	double? width,
	double? height,
	required Widget child,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `left` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `top` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `right` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `bottom` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `width` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `height` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |


## 建構子 KlpPositioned.fill



```dart
const KlpPositioned.fill({Key? key, required Widget child})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### fill

```dart
final bool fill
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/layout/klp_positioned.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_positioned.dart`。
