# KlpInlineCode

Flutter · Stable · 內容元件

## 主要職責

行內程式碼片段。帶有圓角背景與等寬字體，適合在段落文字中呈現指令、變數或路徑。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpInlineCode createExample(String text) => KlpInlineCode(text);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpInlineCode extends StatelessWidget
```

## 建構子 KlpInlineCode



```dart
const KlpInlineCode(
	String text, {
	Key? key,
	Color? color,
	Color? backgroundColor,
	double? fontSize,
	double? radius,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `text` | `String` | 是 | — | 程式碼文字內容。 |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `color` | `Color?` | 否 | null | 文字顏色。預設為 `context.klp.color.text`。 |
| `backgroundColor` | `Color?` | 否 | null | 背景填色。預設為 `context.klp.color.surfaceInset`。 |
| `fontSize` | `double?` | 否 | null | 字體大小。預設為 `context.klp.type.sub` (14px)。 |
| `radius` | `double?` | 否 | null | 圓角半徑。預設為 `context.klp.shape.control`。 |


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
- [宣告來源](../../../../../flutter/lib/src/foundation/klp_inline_code.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/klp_inline_code.dart`。
