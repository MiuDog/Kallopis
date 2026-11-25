# KlpProgress

Flutter · Stable · 狀態回饋

## 主要職責

呈現確定或未確定比例的通用進度資訊。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpProgress createExample() => KlpProgress();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpProgress extends StatelessWidget
```

## 建構子 KlpProgress



```dart
const KlpProgress({
	Key? key,
	double? value,
	String? label,
	String? trailing,
	int segments = 12,
	String? detail,
	KlpProgressState state = KlpProgressState.active,
	VoidCallback? onCancel,
	String cancelLabel = 'Cancel',
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `value` | `double?` | 否 | null | 介於 0 至 1 的資料比例；超出範圍時會被截斷。 |
| `label` | `String?` | 否 | null | 顯示標籤。 |
| `trailing` | `String?` | 否 | null | 後方內容。 |
| `segments` | `int` | 否 | 12 | 僅為舊版相容保留；連續進度軌道不使用分段數。 |
| `detail` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `state` | `KlpProgressState` | 否 | KlpProgressState.active | 依公開型別提供此輸入。 |
| `onCancel` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `cancelLabel` | `String` | 否 | 'Cancel' | 依公開型別提供此輸入。 |


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
- [KlpProgressState](../../types/klp-progress-state.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/progress/klp_progress.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/progress/klp_progress.dart`。
