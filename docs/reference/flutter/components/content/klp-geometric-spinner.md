# KlpGeometricSpinner

Flutter · Stable · 內容元件

## 主要職責

幾何圖案載入動畫。

由四個對稱的小方塊圍繞中心旋轉，並伴隨對比色進行平滑色彩動畫，
適合用於載入狀態、資料請求或背景處理中指示。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpGeometricSpinner createExample() => KlpGeometricSpinner();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpGeometricSpinner extends StatefulWidget
```

## 建構子 KlpGeometricSpinner



```dart
const KlpGeometricSpinner({
	Key? key,
	double? size,
	Color? color,
	Color? contrastColor,
	Duration? duration,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `size` | `double?` | 否 | null | 動畫尺寸（寬高等長）。預設為 `context.klp.space.iconLarge` (24px)。 |
| `color` | `Color?` | 否 | null | 主幾何填色。預設為 `context.klpColors.text`。 |
| `contrastColor` | `Color?` | 否 | null | 對比幾何填色。預設為 `context.klpColors.accent`。 |
| `duration` | `Duration?` | 否 | null | 單次循環週期時長。 |


## 成員與方法

### createState

```dart
State<KlpGeometricSpinner> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/klp_geometric_spinner.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/klp_geometric_spinner.dart`。
