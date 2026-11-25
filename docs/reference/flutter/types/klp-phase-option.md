# KlpPhaseOption

Flutter · Stable · 資料與型別

## 主要職責

階段選項資料。包含選項值、文字標籤或圖示，與啟用時的語意色調。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPhaseOption<T> createExample<T>(T value) => KlpPhaseOption<T>(value: value);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPhaseOption<T>
```

## 建構子 KlpPhaseOption



```dart
const KlpPhaseOption<T>({
	required T value,
	String? label,
	KlpIconData? icon,
	KlpFeedbackTone? activeTone,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `value` | `T` | 是 | — | 目前值。 |
| `label` | `String?` | 否 | null | 顯示標籤。 |
| `icon` | `KlpIconData?` | 否 | null | 操作或內容圖示。 |
| `activeTone` | `KlpFeedbackTone?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpFeedbackTone](klp-feedback-tone.md)
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/toggle/klp_phase_toggle.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/toggle/klp_phase_toggle.dart`。
