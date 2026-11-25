# KlpTextArea

Flutter · Stable · 內容元件

## 主要職責

多行文字輸入欄位，是 [KlpTextField] 的薄封裝——固定 `multiline: true`，
其餘外觀與行為完全繼承自 [KlpTextField]。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTextArea createExample() => KlpTextArea();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTextArea extends StatelessWidget
```

## 建構子 KlpTextArea



```dart
const KlpTextArea({
	Key? key,
	String? label,
	String? value,
	String? placeholder,
	String? error,
	ValueChanged<String>? onChanged,
	bool enabled = true,
	int? minLines,
	int? maxLines,
	bool unboundedLines = false,
	bool outlined = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String?` | 否 | null | 顯示標籤。 |
| `value` | `String?` | 否 | null | 目前值。 |
| `placeholder` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `error` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onChanged` | `void Function(String)?` | 否 | null | 將值的變更交回產品。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `minLines` | `int?` | 否 | null | 依公開型別提供此輸入。 |
| `maxLines` | `int?` | 否 | null | 依公開型別提供此輸入。 |
| `unboundedLines` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `outlined` | `bool` | 否 | false | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/input/klp_text_area.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/input/klp_text_area.dart`。
