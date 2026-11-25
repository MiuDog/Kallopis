# KlpRichTextNode

Flutter · Stable · 資料與型別

## 主要職責

可巢狀組成粗體、斜體、連結與 mention 的行內文字節點。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRichTextNode createExample() => KlpRichTextNode();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpRichTextNode
```

## 建構子 KlpRichTextNode



```dart
const KlpRichTextNode({
	KlpRichTextKind kind = KlpRichTextKind.text,
	String? text,
	String? href,
	String? label,
	bool missing = false,
	bool unsafe = false,
	List<KlpRichTextNode> children = const [],
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `kind` | `KlpRichTextKind` | 否 | KlpRichTextKind.text | 依公開型別提供此輸入。 |
| `text` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `href` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `label` | `String?` | 否 | null | 顯示標籤。 |
| `missing` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `unsafe` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `children` | `List<KlpRichTextNode>` | 否 | const [] | 產品提供的子內容。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpRichTextKind](klp-rich-text-kind.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/content/klp_rich_text_node.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/content/klp_rich_text_node.dart`。
