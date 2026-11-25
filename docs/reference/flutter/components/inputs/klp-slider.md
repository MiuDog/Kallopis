# KlpSlider

Flutter · Stable · 輸入元件

## 主要職責

提供數值滑桿；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSlider createExample(String label, double value, void Function(double)? onChanged) => KlpSlider(label: label, value: value, onChanged: onChanged);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSlider extends StatelessWidget
```

## 建構子 KlpSlider



```dart
const KlpSlider({
	Key? key,
	required String label,
	required double value,
	required ValueChanged<double>? onChanged,
	double min = 0.0,
	double max = 1.0,
	int? divisions,
	String? displayValue,
	List<String>? marks,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `value` | `double` | 是 | — | 目前值。 |
| `onChanged` | `void Function(double)?` | 是 | — | 將值的變更交回產品。 |
| `min` | `double` | 否 | 0.0 | 依公開型別提供此輸入。 |
| `max` | `double` | 否 | 1.0 | 依公開型別提供此輸入。 |
| `divisions` | `int?` | 否 | null | 依公開型別提供此輸入。 |
| `displayValue` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `marks` | `List<String>?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/selection/klp_slider.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_slider.dart`。
