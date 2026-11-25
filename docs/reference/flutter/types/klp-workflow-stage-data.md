# KlpWorkflowStageData

Flutter · Stable · 資料與型別

## 主要職責

一個具名稱的工作流階段，不使用虛構的時間估算。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpWorkflowStageData createExample(String label, String statusLabel, bool complete) => KlpWorkflowStageData(label: label, statusLabel: statusLabel, complete: complete);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpWorkflowStageData
```

## 建構子 KlpWorkflowStageData



```dart
const KlpWorkflowStageData({
	required String label,
	required String statusLabel,
	required bool complete,
	bool active = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `statusLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `complete` | `bool` | 是 | — | 依公開型別提供此輸入。 |
| `active` | `bool` | 否 | false | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/feedback/workflow/klp_finite_workflow.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/feedback/workflow/klp_finite_workflow.dart`。
