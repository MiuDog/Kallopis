# KlpCodeEditorField

Flutter · Stable · 輸入元件

## 主要職責

結構化設定與程式碼編輯器欄位。支援頂部動作列、行內錯誤／警告提示與底部運算式動作列。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCodeEditorField createExample(String label, String code) => KlpCodeEditorField(label: label, code: code);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCodeEditorField extends StatelessWidget
```

## 建構子 KlpCodeEditorField



```dart
const KlpCodeEditorField({
	Key? key,
	required String label,
	String? subtitle,
	List<String>? actions,
	required String code,
	String? error,
	String? warning,
	Widget? footerLeft,
	Widget? footerRight,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `subtitle` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `actions` | `List<String>?` | 否 | null | 依公開型別提供此輸入。 |
| `code` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `error` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `warning` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `footerLeft` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `footerRight` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/structured/klp_code_editor_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/structured/klp_code_editor_field.dart`。
