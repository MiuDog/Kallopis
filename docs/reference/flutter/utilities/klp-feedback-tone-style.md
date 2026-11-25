# KlpFeedbackToneStyle

Flutter · Stable · 工具函式

## 主要職責

提供回饋訊息的解析風格；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

Object? readExample(KlpFeedbackTone value) => KlpFeedbackToneStyle(value).icon;
```

<!-- reference-api:start -->

## 公開簽名

```dart
extension KlpFeedbackToneStyle on KlpFeedbackTone
```

## 成員與方法

### color

```dart
Color color(KlpThemeData tokens)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `tokens` | `KlpThemeData` | 是 | — | 依公開型別提供此輸入。 |


### icon

```dart
KlpIconData get icon
```

操作或內容圖示。

### label

```dart
String get label
```

顯示標籤。

<!-- reference-api:end -->

## 使用限制與關聯

- 繼承／實作：[KlpFeedbackTone](../types/klp-feedback-tone.md)。
- [KlpFeedbackTone](../types/klp-feedback-tone.md)
- [KlpIconData](../types/klp-icon-data.md)
- [KlpThemeData](../styling/klp-theme-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/feedback/klp_feedback_tone.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/feedback/klp_feedback_tone.dart`。
