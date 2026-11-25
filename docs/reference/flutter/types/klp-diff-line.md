# KlpDiffLine

Flutter · Stable · 資料與型別

## 主要職責

Diff 單行資料。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDiffLine createExample(String content) => KlpDiffLine(content: content);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDiffLine
```

## 建構子 KlpDiffLine



```dart
const KlpDiffLine({
	int? oldNumber,
	int? newNumber,
	required String content,
	KlpDiffLineType type = KlpDiffLineType.unchanged,
	VoidCallback? onApprove,
	VoidCallback? onReject,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `oldNumber` | `int?` | 否 | null | 依公開型別提供此輸入。 |
| `newNumber` | `int?` | 否 | null | 依公開型別提供此輸入。 |
| `content` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `type` | `KlpDiffLineType` | 否 | KlpDiffLineType.unchanged | 原生 HTML 元素的 type。 |
| `onApprove` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onReject` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpDiffLineType](klp-diff-line-type.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/code/models/klp_code_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/code/models/klp_code_models.dart`。
