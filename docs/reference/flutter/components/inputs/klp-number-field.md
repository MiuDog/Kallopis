# KlpNumberField

Flutter · Stable · 輸入元件

## 主要職責

數值輸入欄位，底層仍是文字輸入框（[KlpTextField]），但只在能解析成
[double] 且落在 [minimum]／[maximum] 範圍內時才呼叫 [onChanged]。

超出範圍或無法解析的輸入會被直接忽略——欄位仍顯示使用者打的字，但
[onChanged] 不會觸發，因此外部的 `value` 不會更新。需要即時錯誤提示時
請自行比較顯示字串與 [value] 是否一致，而不是依賴 [onChanged] 的呼叫時機。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpNumberField createExample(String label, double value, void Function(double)? onChanged) => KlpNumberField(label: label, value: value, onChanged: onChanged);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpNumberField extends StatelessWidget
```

## 建構子 KlpNumberField



```dart
const KlpNumberField({
	Key? key,
	required String label,
	required double value,
	required ValueChanged<double>? onChanged,
	double? minimum,
	double? maximum,
	String? unit,
	String? error,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `value` | `double` | 是 | — | 目前值。 |
| `onChanged` | `void Function(double)?` | 是 | — | 將值的變更交回產品。 |
| `minimum` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `maximum` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `unit` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `error` | `String?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/input/klp_number_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/input/klp_number_field.dart`。
