# KlpRichTextSpan

Flutter · Stable · 資料與型別

## 主要職責

簡化的行內純文字片段，只承載粗體與顏色覆寫。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRichTextSpan createExample(String text) => KlpRichTextSpan(text: text);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpRichTextSpan
```

## 建構子 KlpRichTextSpan



```dart
const KlpRichTextSpan({
	required String text,
	bool strong = false,
	Color? color,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `text` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `strong` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `color` | `Color?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/content/klp_rich_text_span.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/content/klp_rich_text_span.dart`。
