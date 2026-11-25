# KlpStrokeFrame

Flutter · Stable · 布局元件

## 主要職責

提供描邊框架呈現；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpStrokeFrame createExample(KlpStrokeRole role, Widget child) => KlpStrokeFrame(role: role, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpStrokeFrame extends StatelessWidget
```

## 建構子 KlpStrokeFrame



```dart
const KlpStrokeFrame({
	Key? key,
	required KlpStrokeRole role,
	required Widget child,
	KlpStrokeState state = KlpStrokeState.rest,
	Color? color,
	double? radius,
	double? width,
	double? dashLength,
	double? gapLength,
	double? opacity,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `role` | `KlpStrokeRole` | 是 | — | 依公開型別提供此輸入。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `state` | `KlpStrokeState` | 否 | KlpStrokeState.rest | 依公開型別提供此輸入。 |
| `color` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `radius` | `double?` | 否 | null | 以下皆為 `null` 表示沿用 theme。指定值只用於刻意偏離的場合——<br>建構子預設值是編譯期常數，讀不到 theme。 |
| `width` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `dashLength` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `gapLength` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `opacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpStrokeRole](../../types/klp-stroke-role.md)
- [KlpStrokeState](../../types/klp-stroke-state.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/surface/klp_stroke.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/klp_stroke.dart`。
