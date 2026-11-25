# KlpSettingsSearchField

Flutter · Experimental · 輸入元件

## 主要職責

Settings 搜尋欄的標準組合；查詢與過濾由產品層處理。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSettingsSearchField createExample(String placeholder) => KlpSettingsSearchField(placeholder: placeholder);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSettingsSearchField extends StatelessWidget
```

## 建構子 KlpSettingsSearchField



```dart
const KlpSettingsSearchField({
	Key? key,
	required String placeholder,
	TextEditingController? controller,
	ValueChanged<String>? onChanged,
	ValueChanged<String>? onSubmitted,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `placeholder` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `controller` | `TextEditingController?` | 否 | null | 借用產品提供的控制器。 |
| `onChanged` | `void Function(String)?` | 否 | null | 將值的變更交回產品。 |
| `onSubmitted` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/workspace/settings/klp_settings_navigation.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/settings/klp_settings_navigation.dart`。
