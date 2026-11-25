# KlpSelectionToolbar

Flutter · Stable · 操作元件

## 主要職責

批次選取浮動／固定操作列。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSelectionToolbar createExample(int count, String countLabel, List<KlpSelectionAction> actions) => KlpSelectionToolbar(count: count, countLabel: countLabel, actions: actions);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSelectionToolbar extends StatelessWidget
```

## 建構子 KlpSelectionToolbar



```dart
const KlpSelectionToolbar({
	Key? key,
	required int count,
	required String countLabel,
	required List<KlpSelectionAction> actions,
	VoidCallback? onClear,
	String? clearLabel = 'Clear',
	bool dashed = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `count` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `countLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `actions` | `List<KlpSelectionAction>` | 是 | — | 依公開型別提供此輸入。 |
| `onClear` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `clearLabel` | `String?` | 否 | 'Clear' | 依公開型別提供此輸入。 |
| `dashed` | `bool` | 否 | true | 依公開型別提供此輸入。 |


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
- [KlpSelectionAction](../../types/klp-selection-action.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/actions/selection_toolbar/klp_selection_toolbar.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/selection_toolbar/klp_selection_toolbar.dart`。
