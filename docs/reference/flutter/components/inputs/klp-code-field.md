# KlpCodeField

Flutter · Stable · 輸入元件

## 主要職責

程式碼欄位：唯讀時走語法高亮的 [KlpCodeViewer]，可編輯時走純文字的
[KlpTextArea]。

[readOnly] 切換的是整套渲染方式而非同一個 widget 加鎖——唯讀模式沒有
[onChanged] 也沒有 [error] 提示，這兩者只在可編輯（[readOnly] 為 false）
時才有意義。[language] 只影響唯讀模式下的語法高亮，可編輯模式不使用。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCodeField createExample(String label, String value) => KlpCodeField(label: label, value: value);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCodeField extends StatelessWidget
```

## 建構子 KlpCodeField



```dart
const KlpCodeField({
	Key? key,
	required String label,
	required String value,
	String? language,
	ValueChanged<String>? onChanged,
	bool readOnly = false,
	String? error,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `value` | `String` | 是 | — | 目前值。 |
| `language` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onChanged` | `void Function(String)?` | 否 | null | 將值的變更交回產品。 |
| `readOnly` | `bool` | 否 | false | 依公開型別提供此輸入。 |
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
- [宣告來源](../../../../../flutter/lib/src/features/forms/structured/klp_code_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/structured/klp_code_field.dart`。
