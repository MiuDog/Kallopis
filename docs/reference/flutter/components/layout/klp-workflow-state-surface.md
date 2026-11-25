# KlpWorkflowStateSurface

Flutter · Stable · 布局元件

## 主要職責

將有限工作流狀態轉成可讀、可宣告的狀態表面。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpWorkflowStateSurface createExample(KlpWorkflowState state, String title, String message, String statusLabel) => KlpWorkflowStateSurface(state: state, title: title, message: message, statusLabel: statusLabel);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpWorkflowStateSurface extends StatelessWidget
```

## 建構子 KlpWorkflowStateSurface



```dart
const KlpWorkflowStateSurface({
	Key? key,
	required KlpWorkflowState state,
	required String title,
	required String message,
	required String statusLabel,
	String? actionLabel,
	VoidCallback? onAction,
	Widget? child,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `state` | `KlpWorkflowState` | 是 | — | 依公開型別提供此輸入。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `message` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `statusLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `actionLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onAction` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `child` | `Widget?` | 否 | null | 產品提供的內容。 |


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
- [KlpWorkflowState](../../types/klp-workflow-state.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/feedback/workflow/klp_finite_workflow.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/feedback/workflow/klp_finite_workflow.dart`。
