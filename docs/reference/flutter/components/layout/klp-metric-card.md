# KlpMetricCard

Flutter · Stable · 布局元件

## 主要職責

指標呈現卡片 (Metric Card)。

呈現標籤、核心數值、單位、趨勢箭頭、狀態說明或迷你進度長條。
支援正常（neutral/success）與違規告警（danger 具備紅色外框與文字）。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpMetricCard createExample(String label) => KlpMetricCard(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpMetricCard extends StatelessWidget
```

## 建構子 KlpMetricCard



```dart
const KlpMetricCard({
	Key? key,
	required String label,
	String? value,
	String? unit,
	String? trend,
	String? subtitle,
	KlpFeedbackTone tone = KlpFeedbackTone.neutral,
	Widget? child,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 指標標籤（如 'PASS RATE', 'P95 LATENCY'）。 |
| `value` | `String?` | 否 | null | 數值（如 '98.2', '1420'）。 |
| `unit` | `String?` | 否 | null | 數值單位（如 '%', 'ms'）。 |
| `trend` | `String?` | 否 | null | 趨勢或指標符號（如 '↑', '↓'）。 |
| `subtitle` | `String?` | 否 | null | 底部說明（如 'Threshold 95%', 'Breached · threshold 800ms'）。 |
| `tone` | `KlpFeedbackTone` | 否 | KlpFeedbackTone.neutral | 狀態語意色調。為 danger 時卡片邊框與數值呈現紅色。 |
| `child` | `Widget?` | 否 | null | 自訂內容（如進度條）。 |


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
- [KlpFeedbackTone](../../types/klp-feedback-tone.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/card/klp_card.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/card/klp_card.dart`。
