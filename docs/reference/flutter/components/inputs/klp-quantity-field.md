# KlpQuantityField

Flutter · Stable · 輸入元件

## 主要職責

以欄位等高的減少／增加操作調整數量。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpQuantityField createExample(String label, num value) => KlpQuantityField(label: label, value: value);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpQuantityField extends StatelessWidget
```

## 建構子 KlpQuantityField



```dart
const KlpQuantityField({
	Key? key,
	required String label,
	required num value,
	num step = 1,
	num? minimum,
	num? maximum,
	ValueChanged<num>? onChanged,
	bool enabled = true,
	bool readOnly = false,
	String? error,
	String? decreaseLabel,
	String? increaseLabel,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `value` | `num` | 是 | — | 目前值。 |
| `step` | `num` | 否 | 1 | 依公開型別提供此輸入。 |
| `minimum` | `num?` | 否 | null | 依公開型別提供此輸入。 |
| `maximum` | `num?` | 否 | null | 依公開型別提供此輸入。 |
| `onChanged` | `void Function(num)?` | 否 | null | 將值的變更交回產品。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `readOnly` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `error` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `decreaseLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `increaseLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/input/klp_quantity_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/input/klp_quantity_field.dart`。
