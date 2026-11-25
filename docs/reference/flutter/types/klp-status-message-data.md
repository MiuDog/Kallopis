# KlpStatusMessageData

Flutter · Experimental · 資料與型別

## 主要職責

[KlpSaveStatusCard] 裡的一則狀態訊息，例如「已同步」「有欄位驗證失敗」。
[tone] 為 [KlpFeedbackTone.neutral] 時走低對比的靜音文字色，其餘 tone 才
使用對應的狀態色。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpStatusMessageData createExample(String label) => KlpStatusMessageData(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpStatusMessageData
```

## 建構子 KlpStatusMessageData



```dart
const KlpStatusMessageData({required String label, KlpFeedbackTone tone = KlpFeedbackTone.neutral})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `tone` | `KlpFeedbackTone` | 否 | KlpFeedbackTone.neutral | 選擇語意呈現。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpFeedbackTone](klp-feedback-tone.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/page_chrome/klp_page_chrome.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/page_chrome/klp_page_chrome.dart`。
