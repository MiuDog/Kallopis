# KlpLayoutDiagnosticData

Flutter · Experimental · 資料與型別

## 主要職責

Layout Lens 的單一診斷項目。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpLayoutDiagnosticData createExample(String label, String value) => KlpLayoutDiagnosticData(label: label, value: value);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpLayoutDiagnosticData
```

## 建構子 KlpLayoutDiagnosticData



```dart
const KlpLayoutDiagnosticData({
	required String label,
	required String value,
	KlpFeedbackTone tone = KlpFeedbackTone.neutral,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `value` | `String` | 是 | — | 目前值。 |
| `tone` | `KlpFeedbackTone` | 否 | KlpFeedbackTone.neutral | 選擇語意呈現。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpFeedbackTone](klp-feedback-tone.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/infinite_canvas/klp_canvas_workspace.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/infinite_canvas/klp_canvas_workspace.dart`。
