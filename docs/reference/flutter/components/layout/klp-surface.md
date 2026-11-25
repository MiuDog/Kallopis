# KlpSurface

Flutter · Stable · 布局元件

## 主要職責

有底色的容器，是所有區塊的基底。`tone` 指定它在表面階層中的位置，
支援邊框、微漸層、外發光與霧化透明（毛玻璃）等多種原生 Box 視覺效果。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSurface createExample(Widget child) => KlpSurface(child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSurface extends StatelessWidget
```

## 建構子 KlpSurface



```dart
const KlpSurface({
	Key? key,
	required Widget child,
	KlpSurfaceTone tone = KlpSurfaceTone.base,
	double? radius,
	EdgeInsetsGeometry? padding,
	BoxBorder? border,
	Gradient? gradient,
	List<BoxShadow>? shadows,
	bool frosted = false,
	double? blurSigma,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `tone` | `KlpSurfaceTone` | 否 | KlpSurfaceTone.base | 選擇語意呈現。 |
| `radius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `padding` | `EdgeInsetsGeometry?` | 否 | null | 依公開型別提供此輸入。 |
| `border` | `BoxBorder?` | 否 | null | 依公開型別提供此輸入。 |
| `gradient` | `Gradient?` | 否 | null | 依公開型別提供此輸入。 |
| `shadows` | `List<BoxShadow>?` | 否 | null | 依公開型別提供此輸入。 |
| `frosted` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `blurSigma` | `double?` | 否 | null | 依公開型別提供此輸入。 |


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

- [2. 組合產品畫面](../../../../guides/flutter/03-klp-surface.md)：跨元件使用流程。
- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpSurfaceTone](../../types/klp-surface-tone.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/surface/klp_surface.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/klp_surface.dart`。
