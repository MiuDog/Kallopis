# KlpDashedBorder

Flutter · Stable · 內容元件

## 主要職責

虛線邊框容器。為子元件提供自訂粗細、圓角、顏色與虛線間距的虛線外框。

預設使用 theme 的 [KlpShapeTheme.dashedOpacity] 輔助線顏色與 [KlpShapeTheme.control] 圓角。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDashedBorder createExample(Widget child) => KlpDashedBorder(child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDashedBorder extends StatelessWidget
```

## 建構子 KlpDashedBorder



```dart
const KlpDashedBorder({
	Key? key,
	required Widget child,
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
| `child` | `Widget` | 是 | — | 包裹之子元件。 |
| `color` | `Color?` | 否 | null | 虛線顏色。`null` 時取自 theme 的 [KlpThemeData.guide]。 |
| `radius` | `double?` | 否 | null | 邊角圓角半徑。`null` 時取自 theme 的 [KlpShapeTheme.control]。 |
| `width` | `double?` | 否 | null | 虛線線寬（粗細）。`null` 時取自 theme 的 [KlpShapeTheme.hairline]。 |
| `dashLength` | `double?` | 否 | null | 每段虛線長度。`null` 時取自 theme 的 [KlpShapeTheme.dashedLength]。 |
| `gapLength` | `double?` | 否 | null | 虛線間隔長度。`null` 時取自 theme 的 [KlpShapeTheme.dashedGap]。 |
| `opacity` | `double?` | 否 | null | 透明度。 |


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
- [KlpShapeTheme](../../styling/klp-shape-theme.md)
- [KlpThemeData](../../styling/klp-theme-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/surface/klp_dashed_border.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/klp_dashed_border.dart`。
