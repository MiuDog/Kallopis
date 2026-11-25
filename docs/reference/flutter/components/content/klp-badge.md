# KlpBadge

Flutter · Stable · 內容元件

## 主要職責

狀態標記。文字、內距與 pill 幾何皆由目前 Kallopis theme 解析。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpBadge createExample(String label) => KlpBadge(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpBadge extends StatelessWidget
```

## 建構子 KlpBadge



```dart
const KlpBadge({
	Key? key,
	required String label,
	KlpFeedbackTone tone = KlpFeedbackTone.neutral,
	KlpBadgeVariant variant = KlpBadgeVariant.filled,
	bool dot = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 標籤文字。 |
| `tone` | `KlpFeedbackTone` | 否 | KlpFeedbackTone.neutral | 語意色調。 |
| `variant` | `KlpBadgeVariant` | 否 | KlpBadgeVariant.filled | 視覺樣式。 |
| `dot` | `bool` | 否 | false | 是否顯示狀態圓點。 |


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
- [KlpBadgeVariant](../../types/klp-badge-variant.md)
- [KlpFeedbackTone](../../types/klp-feedback-tone.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/badge/klp_badge.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/badge/klp_badge.dart`。
