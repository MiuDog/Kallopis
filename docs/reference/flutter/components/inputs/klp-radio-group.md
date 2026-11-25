# KlpRadioGroup

Flutter · Stable · 輸入元件

## 主要職責

提供單選項目組；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRadioGroup<T> createExample<T>(Map<T, String> items, T value, void Function(T) onChanged) => KlpRadioGroup<T>(items: items, value: value, onChanged: onChanged);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpRadioGroup<T> extends StatelessWidget
```

## 建構子 KlpRadioGroup



```dart
const KlpRadioGroup<T>({
	Key? key,
	required Map<T, String> items,
	required T value,
	required ValueChanged<T> onChanged,
	Map<T, String>? descriptions,
	bool vertical = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `items` | `Map<T, String>` | 是 | — | 由產品提供的項目。 |
| `value` | `T` | 是 | — | 目前值。 |
| `onChanged` | `void Function(T)` | 是 | — | 將值的變更交回產品。 |
| `descriptions` | `Map<T, String>?` | 否 | null | 依公開型別提供此輸入。 |
| `vertical` | `bool` | 否 | false | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/selection/klp_radio_group.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_radio_group.dart`。
