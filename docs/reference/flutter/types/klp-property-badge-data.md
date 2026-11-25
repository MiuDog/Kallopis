# KlpPropertyBadgeData

Flutter · Experimental · 資料與型別

## 主要職責

[KlpPropertySummary.badges] 的一筆徽章資料，直接對應 [KlpBadge] 的
`label`／`tone`／`dot` 參數。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPropertyBadgeData createExample(String label) => KlpPropertyBadgeData(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPropertyBadgeData
```

## 建構子 KlpPropertyBadgeData



```dart
const KlpPropertyBadgeData({
	required String label,
	KlpFeedbackTone tone = KlpFeedbackTone.neutral,
	bool dot = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `tone` | `KlpFeedbackTone` | 否 | KlpFeedbackTone.neutral | 選擇語意呈現。 |
| `dot` | `bool` | 否 | false | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpFeedbackTone](klp-feedback-tone.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/page_chrome/klp_page_chrome.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/page_chrome/klp_page_chrome.dart`。
