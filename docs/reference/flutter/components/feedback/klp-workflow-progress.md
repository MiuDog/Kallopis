# KlpWorkflowProgress

Flutter · Stable · 狀態回饋

## 主要職責

顯示具名稱的真實階段，並向輔助技術宣告目前階段。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpWorkflowProgress createExample(List<KlpWorkflowStageData> stages) => KlpWorkflowProgress(stages: stages);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpWorkflowProgress extends StatelessWidget
```

## 建構子 KlpWorkflowProgress



```dart
const KlpWorkflowProgress({
	Key? key,
	required List<KlpWorkflowStageData> stages,
	String? label,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `stages` | `List<KlpWorkflowStageData>` | 是 | — | 依公開型別提供此輸入。 |
| `label` | `String?` | 否 | null | 顯示標籤。 |


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
- [KlpWorkflowStageData](../../types/klp-workflow-stage-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/feedback/workflow/klp_finite_workflow.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/feedback/workflow/klp_finite_workflow.dart`。
