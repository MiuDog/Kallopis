# KlpMessageComposer

Flutter · Experimental · 內容元件

## 主要職責

帶有範圍標籤、附件動作與提交動作的多行訊息輸入器。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpMessageComposer createExample(String placeholder, String sendLabel, String attachLabel, void Function()? onSend, void Function()? onAttach) => KlpMessageComposer(placeholder: placeholder, sendLabel: sendLabel, attachLabel: attachLabel, onSend: onSend, onAttach: onAttach);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpMessageComposer extends StatelessWidget
```

## 建構子 KlpMessageComposer



```dart
const KlpMessageComposer({
	Key? key,
	required String placeholder,
	required String sendLabel,
	required String attachLabel,
	required VoidCallback? onSend,
	required VoidCallback? onAttach,
	List<String> tags = const [],
	String? value,
	ValueChanged<String>? onChanged,
	bool dense = false,
	bool inlineActions = false,
	bool outlined = false,
	int minLines = 1,
	int? maxLines = 5,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `placeholder` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `sendLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `attachLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `onSend` | `void Function()?` | 是 | — | 依公開型別提供此輸入。 |
| `onAttach` | `void Function()?` | 是 | — | 依公開型別提供此輸入。 |
| `tags` | `List<String>` | 否 | const [] | 依公開型別提供此輸入。 |
| `value` | `String?` | 否 | null | 目前值。 |
| `onChanged` | `void Function(String)?` | 否 | null | 將值的變更交回產品。 |
| `dense` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `inlineActions` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `outlined` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `minLines` | `int` | 否 | 1 | 依公開型別提供此輸入。 |
| `maxLines` | `int?` | 否 | 5 | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/workspace/message_composer/klp_message_composer.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/message_composer/klp_message_composer.dart`。
